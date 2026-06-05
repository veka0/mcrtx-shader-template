/* MIT License
 * 
 * Copyright (c) 2025 veka0
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef __UTIL_HLSL__
#define __UTIL_HLSL__

#include "Generated/Signature.hlsl"
#include "Constants.hlsl"

uint3 getDispatchDimensions() {
    return uint3(
        (g_dispatchDimensions >> 0*10) & 1023, 
        (g_dispatchDimensions >> 1*10) & 1023,
        g_dispatchDimensions >> 2*10
    );
}

float2 computeMotionVector(float3 steveSpacePositon, float3 steveSpaceMotion) {
    float4 clipPos = mul(float4(steveSpacePositon, 1), g_view.viewProj);
    float2 ndcPos = clipPos.xy / clipPos.w;

    float3 prevHitPos = steveSpacePositon - steveSpaceMotion;
    float4 prevClipPos = mul(float4(prevHitPos, 1), g_view.prevViewProj);
    float2 prevNdcPos = prevClipPos.xy / prevClipPos.w;

    return (prevNdcPos - ndcPos) * float2(0.5, -0.5); // Offset in UV space.
}

float3 rayDirFromNDC(float2 ndc) {
    // Note: as far as I can tell, view origin is always 0, hence it's not necessary to subtract it or even 
    // divide resulting vector by W. But I'm keeping the code here in case view origin becomes something else in the future.
    const float NDC_Z_Offset = 0.5;
    #if 0
    // Slightly faster but less precise.
    float3 rayDir = mad(ndc.x, g_view.posNdcToDirection[0].xyz, g_view.posNdcToDirection[2].xyz);
    rayDir = mad(ndc.y, g_view.posNdcToDirection[1].xyz, rayDir);
    return normalize(rayDir/mad(g_view.invViewProj._m23, NDC_Z_Offset, g_view.invViewProj._m33) - g_view.viewOriginSteveSpace);
    #else
    float4 steveSpacePos = mul(float4(ndc, NDC_Z_Offset, 1), g_view.invViewProj);
    steveSpacePos.xyz /= steveSpacePos.w;
    return normalize(steveSpacePos.xyz - g_view.viewOriginSteveSpace);
    #endif
}

// Returns true both for upscaling (e.g. DLSS) and anti-aliasing (e.g. DLAA)
bool isUpscalingEnabled() {
    return !g_view.enableTAA;
}

float2 getNDCjittered(uint2 pixelCoord) {
    float2 ndc = g_view.recipRenderResolution * (pixelCoord + 0.5 + (isUpscalingEnabled() ? g_view.subPixelJitter : 0));
    return mad(ndc, float2(2, -2), float2(-1, 1));
}

float4 unpackNormal(uint packedNormal) {
    return float4(
        (int)((packedNormal << 8*3) & 0xff000000) >> 24, 
        (int)((packedNormal << 8*2) & 0xff000000) >> 24, 
        (int)((packedNormal << 8*1) & 0xff000000) >> 24, 
        (int)((packedNormal << 8*0) & 0xff000000) >> 24
    ) / 127.0;
}

uint packNormal(float4 normal) {
    int4 normalInt = int4(round(normal*127));
    return (
        ((uint)(normalInt.x << 24) >> 8*3) | 
        ((uint)(normalInt.y << 24) >> 8*2) | 
        ((uint)(normalInt.z << 24) >> 8*1) | 
        ((uint)(normalInt.w << 24) >> 8*0)
    );
}

float4 unpackVertexColor(uint packedColor) {
    return float4(
        (packedColor >> 8 * 0) & 0xff, 
        (packedColor >> 8 * 1) & 0xff, 
        (packedColor >> 8 * 2) & 0xff, 
        (packedColor >> 8 * 3) & 0xff
    ) / 255.0;
}

float4 unpackObjectInstanceTintColor(uint packedColor) {
    return float4(
        (packedColor >> 8 * 3) & 0xff, 
        (packedColor >> 8 * 2) & 0xff, 
        (packedColor >> 8 * 1) & 0xff, 
        (packedColor >> 8 * 0) & 0xff
    ) / 255.0;
}

float2 unpackVertexUV(uint packedUV, bool packedUvIncludesBias = false) {
    const float uvScale = 1.0 / 65535.0; // 1.0/0xffff
    const float biasScale = 1.0 / 32768.0;

    if (packedUvIncludesBias) {
        float2 uv = float2(packedUV << 1u & 0xfffeu, packedUV >> 15u & 0xfffeu) * uvScale;
        float2 bias = (float2(packedUV >> 15u & 1u, packedUV >> 31u) * 2.0 - 1.0) * biasScale;

        return uv + bias;
    } else {
        float2 uv = float2(packedUV & 0xffff, packedUV >> 16) * uvScale;

        // Quantize UVs according to largest possible texture size (32k on NVidia), fixes visible texture seams on certain objects.
        uv = round(uv * 32768) * (1.0 / 32768.0);

        return uv;
    }
}

// Determine whether g_view.directionToSun is actually direction to moon.
bool isMoonPrimaryLight() {
    if (abs(g_view.directionToSun.y) > 0.999) return g_view.skyTextureW > 0.9;
    float angle1 = g_view.sunAzimuth - PI;
    float angle2 = atan2(g_view.directionToSun.z, g_view.directionToSun.x);
    float angleDiff = abs(angle1-angle2);
    return min(angleDiff, (2*PI)-angleDiff) > 0.001;
}

float3 getTrueDirectionToSun() {
    return isMoonPrimaryLight() ? -g_view.directionToSun : g_view.directionToSun;
}

float3 getTrueDirectionToMoon() {
    return isMoonPrimaryLight() ? g_view.directionToSun : -g_view.directionToSun;
}

#endif
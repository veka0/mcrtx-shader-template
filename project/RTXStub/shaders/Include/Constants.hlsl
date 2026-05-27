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

#ifndef __CONSTANTS_HLSL__
#define __CONSTANTS_HLSL__

// Use these with RayQuery.TraceRayInline()
// Primary mask - with 1st person hand, secondary - without
// Blend mask doesn't include water or sun/moon
#define INSTANCE_MASK_OPAQUE_OR_ALPHA_TEST_PRIMARY   (1 << 0)
#define INSTANCE_MASK_OPAQUE_OR_ALPHA_TEST_SECONDARY (1 << 1)
#define INSTANCE_MASK_OPAQUE_OR_ALPHA_TEST_CHUNKS    (1 << 2) // No actors/entities
#define INSTANCE_MASK_ALPHA_BLEND_PRIMARY            (1 << 3)
#define INSTANCE_MASK_ALPHA_BLEND_SECONDARY          (1 << 4)
#define INSTANCE_MASK_WATER                          (1 << 5)
#define INSTANCE_MASK_SUN_OR_MOON                    (1 << 6)

// ObjectInstance.offsetPack5 >> 8
#define MEDIA_TYPE_WATER 0
#define MEDIA_TYPE_GLASS 1
#define MEDIA_TYPE_AIR   2
#define MEDIA_TYPE_CLOUD 3
#define MEDIA_TYPE_SOLID 4

// HitInfo.materialType (supplied by InstanceID)
#define MATERIAL_TYPE_OPAQUE      0
#define MATERIAL_TYPE_ALPHA_TEST  1
#define MATERIAL_TYPE_ALPHA_BLEND 2
#define MATERIAL_TYPE_WATER       3

// ObjectInstance.flags
static const uint kObjectInstanceFlagUsesIrradianceCache    = (1 << 0);
static const uint kObjectInstanceFlagHasMotionVectors       = (1 << 1);
static const uint kObjectInstanceFlagHasSeasonsTexture      = (1 << 2);
static const uint kObjectInstanceFlagMaskedMultiTexture     = (1 << 3);
static const uint kObjectInstanceFlagMultiTexture           = (1 << 4);
static const uint kObjectInstanceFlagMultiplicativeTint     = (1 << 5);
static const uint kObjectInstanceFlagUsesOverlayColor       = (1 << 6);
static const uint kObjectInstanceFlagClouds                 = (1 << 7);
static const uint kObjectInstanceFlagChunk                  = (1 << 8);
static const uint kObjectInstanceFlagSun                    = (1 << 9);
static const uint kObjectInstanceFlagMoon                   = (1 << 10);
static const uint kObjectInstanceFlagRemapTransparencyAlpha = (1 << 11); // All transparent blocks and entities, except held items in 1st person. In vanilla MCRTX it's used to remap opacity (alpha) into transmittance.
static const uint kObjectInstanceFlagAlphaTestThresholdHalf = (1 << 12);
static const uint kObjectInstanceFlagTextureAlphaControlsVertexColor = (1 << 13);
static const uint kObjectInstanceFlagGlint                  = (1 << 14);
static const uint kObjectInstanceFlagUsesUvBiasPacking      = (1 << 15);

// Constants borrowed from deferred rendering
static const uint kInvalidPBRTextureHandle = 0xffff; // Compare against pbrTextureDataIndex vertex attribute
// PBRTextureData.flags
static const uint kPBRTextureDataFlagHasMaterialTexture             = (1 << 0);
static const uint kPBRTextureDataFlagHasSubsurfaceChannel           = (1 << 1);
static const uint kPBRTextureDataFlagHasNormalTexture               = (1 << 2);
static const uint kPBRTextureDataFlagHasHeightMapTexture            = (1 << 3);
static const uint kPBRTextureDataFlagHasPackedHeightNormalsTexture  = (1 << 4);

// inputTemporallyStableLights[].flags
// Both of these only appear on existing lights, not on newly placed or destroyed lights.
static const int kAdaptiveDenoiserLightFlagAddedToList      = (1 << 0);
static const int kAdaptiveDenoiserLightFlagRemovedFromList  = (1 << 1);

#define PI 3.14159265358979323846

#endif
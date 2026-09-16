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

#ifndef __STRUCTS_HLSL__
#define __STRUCTS_HLSL__

// Structs
struct AdaptiveDenoiserLightInfo {
    float3 position; // 0
    float luminance; // 12
    int flags; // 16
};
struct CheckerboardActions {
    uint16_t mOddAction; // 0
    uint16_t mEvenAction; // 2
    uint16_t mSplitAction; // 4
    uint16_t mTotalReflectionAction; // 6
    float mCosCriticalAngle; // 8
};
struct DenoisingParameters {
    float phiLuminance; // 0
    float phiDepth; // 4
    float phiNormal; // 8
    float pad0; // 12
    float despeckleFilterRelativeDifferenceEpsilon; // 16
    float despeckleFilterRelativeDifferenceEpsilonDisocclusion; // 20
    float pad1; // 24
    float pad2; // 28
};
struct FaceData {
    uint packedNormal; // 0
    uint packedTangent; // 4
    uint packedBitangent; // 8
    half lodConstant; // 12
    uint16_t colourTextureMaxMip; // 14
};
struct FaceIrradianceCache {
    half4 outgoingFrontAndHistoryLength; // 0
    half4 outgoingBackAndPad; // 8
};
struct FaceIrradianceCacheUpdateChunk {
    uint objectInstanceIdxAndNumFaces; // 0
    uint firstFaceIdx; // 4
};
struct LightInfo {
    half3 position; // 0
    uint packedData; // 8
};
struct LightMeterData {
    float lightAccumulationAlpha; // 0
    float maxEV; // 4
    float minEV; // 8
    int accumulationNeedsReset; // 12
    float lobesDifferenceThreshold; // 16
    float lobesDifferenceAlphaMin; // 20
    float lobesDifferenceAlphaMax; // 24
    float manualExposureAdjustmentEv; // 28
};
struct MeshSkinningData {
    uint sizeOfVertex; // 0
    uint offsetToPosition; // 4
    uint offsetToPrevPos; // 8
    uint offsetToNormal; // 12
    uint offsetToBoneIndex; // 16
    uint vertexCount; // 20
    uint sourceVBIndex; // 24
    uint sourceVBOffset; // 28
    uint destVBIndex; // 32
    uint destVBOffset; // 36
    uint2 padding; // 40
    float4x4 bones[8]; // 48
};
struct ObjectInstance {
    float4x3 modelToWorld; // 0
    float4x3 prevModelToWorld; // 48
    uint vertexOffsetInBaseVertices; // 96
    uint vertexOffsetInParallelVertices; // 100
    uint indexOffsetInIndices; // 104
    uint16_t vbIdx; // 108
    uint16_t ibIdx; // 110
    uint16_t vertexStride; // 112
    uint16_t indexSize; // 114
    uint16_t colourTextureIdx; // 116
    uint16_t secondaryTextureIdx; // 118
    uint16_t tertiaryTextureIdx; // 120
    uint16_t flags; // 122
    uint16_t blasIdx; // 124
    uint16_t irradianceCacheMaxHistoryLength; // 126
    uint tintColour0; // 128
    uint tintColour1; // 132
    float irradianceCacheUpdateScore; // 136
    uint16_t objectCategory; // 140
    uint16_t offsetPack1; // 142
    uint16_t offsetPack2; // 144
    uint16_t offsetPack3; // 146
    uint16_t offsetPack4; // 148
    uint16_t offsetPack5; // 150
};
struct PBRTextureData {
    float2 colourToMaterialUvScale; // 0
    float2 colourToMaterialUvBias; // 8
    float2 colourToNormalUvScale; // 16
    float2 colourToNormalUvBias; // 24
    int flags; // 32
    float uniformRoughness; // 36
    float uniformEmissive; // 40
    float uniformMetalness; // 44
    float uniformSubsurface; // 48
    float maxMipColour; // 52
    float maxMipMer; // 56
    float maxMipNormal; // 60
};
struct VertexIrradianceCache {
    half4 incomingFrontAndHistoryLength; // 0
    half4 incomingBackAndPad; // 8
};
struct VertexIrradianceCacheUpdateChunk {
    uint objectInstanceIdxAndNumVertices; // 0
    uint firstVertexIdx; // 4
};
struct View {
    row_major float4x4 view; // 0
    row_major float4x4 viewProj; // 64
    row_major float4x4 proj; // 128
    row_major float4x4 invProj; // 192
    row_major float4x4 invView; // 256
    row_major float4x4 invViewProj; // 320
    row_major float4x4 prevViewProj; // 384
    row_major float4x4 prevView; // 448
    row_major float4x4 prevInvViewProj; // 512
    row_major float4x4 invTransposeView; // 576
    float4 posNdcToDirection[3]; // 640
    float4 posNdcToPrevDirection[3]; // 688
    DenoisingParameters denoisingParams[2]; // 736
    float3 sunColour; // 800
    float sunAzimuth; // 812
    float2 distanceFadeScaleBias; // 816
    float renderDistance; // 824
    float skyTextureW; // 828
    float3 directionToSun; // 832
    float sunColourTextureCoord; // 844
    float3 underwaterDirectionToSun; // 848
    uint numFramesSinceTeleport; // 860
    float3 volumetricLightingResolution; // 864
    uint cameraIsUnderWater; // 876
    float3 recipVolumetricLightingResolution; // 880
    uint previousVolumetricsAreValid; // 892
    float3 volumetricGILightingResolution; // 896
    float rainLevel; // 908
    float3 recipVolumetricGILightingResolution; // 912
    float pad1; // 924
    float3 skyColor; // 928
    float skyColorBlend; // 940
    float3 constantAmbient; // 944
    float nightVisionLevel; // 956
    float3 primaryMediaAbsorption; // 960
    float primaryMediaHenyeyGreensteinG; // 972
    float3 primaryMediaScattering; // 976
    float pad7; // 988
    float3 primaryMediaExtinction; // 992
    float pad8; // 1004
    float4 mediaExtinction[5]; // 1008
    float3 waveWorksOriginInSteveSpace; // 1088
    float causticsWCoord; // 1100
    float3 previousToCurrentCameraPosWorldSpace; // 1104
    float pad9; // 1116
    float3 previousToCurrentCameraPosSteveSpace; // 1120
    float pad10; // 1132
    float3 steveSpaceDelta; // 1136
    float pad11; // 1148
    float3 viewOriginSteveSpace; // 1152
    float tanHalfFovY; // 1164
    float3 previousViewOriginSteveSpace; // 1168
    float pad12; // 1180
    float2 skyTextureUVScale; // 1184
    uint skyTextureIdx; // 1192
    uint padSky; // 1196
    float3 skyColorUp; // 1200
    uint skyLightingType; // 1212
    float3 skyColorDown; // 1216
    uint skyBackgroundType; // 1228
    float3 finalCombineSkyColourOverride; // 1232
    float finalCombineSkyColourOverrideStrength; // 1244
    float2 renderResolution; // 1248
    float2 recipRenderResolution; // 1256
    float2 displayResolution; // 1264
    float2 recipDisplayResolution; // 1272
    float2 fieldSize; // 1280
    float2 volumetricFroxelIdxToNdcXyScale; // 1288
    float2 volumetricGIFroxelIdxToNdcXyScale; // 1296
    float2 subPixelJitter; // 1304
    float2 previousSubPixelJitter; // 1312
    float2 steveToCausticsScale; // 1320
    float2 steveToCausticsBias; // 1328
    float2 steveToWibblyScale; // 1336
    float2 steveToWibblyBias; // 1344
    uint frameCount; // 1352
    float emissiveMultiplier; // 1356
    float emissiveDesaturation; // 1360
    float indirectEmissiveBoostMultiplier; // 1364
    float surfaceWetness; // 1368
    float smoothertron; // 1372
    float mipmapBias; // 1376
    uint enableIrradianceCache; // 1380
    uint injectGlobalIlluminationIntoFog; // 1384
    float fogHenyeyGreensteinG; // 1388
    float waterHenyeyGreensteinG; // 1392
    float renderResolutionDivDisplayResolution; // 1396
    float displayResolutionDivRenderResolution; // 1400
    uint enableAdaptiveDenoiser; // 1404
    float previousResolutionDivRenderResolution; // 1408
    float diffuseTemporalAlpha; // 1412
    float diffuseTemporalAlphaMoments; // 1416
    float specularTemporalAlpha; // 1420
    float specularTemporalAlphaMoments; // 1424
    float primaryRaySpreadAngle; // 1428
    float primaryRayAlphaTestSpreadAngle; // 1432
    float heightMapPixelEdgeWidth; // 1436
    float recipHeightMapDepth; // 1440
    uint rayCountMultiplier; // 1444
    float heightToFogScale; // 1448
    float heightToFogBias; // 1452
    uint refModeAccumulatedFrames; // 1456
    uint renderMethod; // 1460
    uint debugMode; // 1464
    uint enableProbabilityBasedRaycasts; // 1468
    uint enableCausticsStabilizationInRefMode; // 1472
    uint enableRayReordering; // 1476
    uint enableExplicitLightSampling; // 1480
    uint cpuLightsCount; // 1484
    float explicitLightsIntensityBias; // 1488
    float focalDistance; // 1492
    float apertureSize; // 1496
    uint apertureType; // 1500
    float toneMappingShadowContrast; // 1504
    float toneMappingShadowContrastEnd; // 1508
    float toneMappingCurveShift; // 1512
    float toneMappingDynamicRange; // 1516
    float toneMappingShadowMinSlope; // 1520
    float toneMappingMaxExposureIncrease; // 1524
    uint toneMappingNeedsReset; // 1528
    uint enableTAA; // 1532
    uint enableSHDiffuse; // 1536
    uint cameraIsUnderLava; // 1540
    float cpuLightsCountRcp; // 1544
    uint reducedLightsCount; // 1548
    float reducedLightsCountRcp; // 1552
    float lightCullingDistance; // 1556
    float time; // 1560
    float skyIntensityAdjustment; // 1564
    float moonMeshIntensity; // 1568
    float sunMeshIntensity; // 1572
    float maxHistoryLength; // 1576
    uint missingTextureIndex; // 1580
    float genericDebugSlider0; // 1584
    float genericDebugSlider1; // 1588
    float genericDebugSlider2; // 1592
    float genericDebugSlider3; // 1596
};
#endif
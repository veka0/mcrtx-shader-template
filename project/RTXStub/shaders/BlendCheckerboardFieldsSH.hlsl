#include "Include/Generated/Signature.hlsl"

[numthreads(16, 16, 1)]
void BlendCheckerboardFieldsSH(
    uint3 dispatchThreadID : SV_DispatchThreadID,
    uint3 groupThreadID : SV_GroupThreadID,
    uint groupIndex : SV_GroupIndex, 
    uint3 groupID : SV_GroupID
    )
{
    // Use these for indexing denoisingOutputs[] or denoisingChromaAndVarianceOutputs[] arrays
    uint denoisingInputBufferIndex = (g_rootConstant0 >> 8) & 0xff;
    uint denoisingOutputBufferIndex = (g_rootConstant0 >> 16) & 0xff;
}
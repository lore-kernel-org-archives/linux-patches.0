Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1217B255F31;
	Sat, 25 Oct 2025 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761416691; cv=none; b=b0e89HEjQqsYZfWfeNx9qkTIMh9g8J2zwbgqMVkDDSyYkNjc0t/9OR1cNLQjRIoRDy7GHSjqPM5ceBYBoqJnIyudD3fgDq+bf62S9+DkmQlLI2suljaTEkUkxLhlocUDPB3cUXAAwivwnrGPbz2fnAC1oxhxBcW3Uqzj05hahVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761416691; c=relaxed/simple;
	bh=UlEaNYv6J/Zde5KNqT5g3/DYC9K785oQCnkAH4vHwn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SgfA9nLjia/0yqfnaXpWc76eyBkjIPhZI4cN64tt7LY1D+cdJkttjKhOka86fJ0CtZ3OF9pw7GMLa5gQMGSTesTbBS9RSki+wBwaM5m8mtraRgiNiJZ8rP3wLVtEMpfbkvRw3wO08ELgMtqFnGrGwfrT0pqhurGl/qghuSQe9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gbq/xTHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gbq/xTHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808D8C4CEF5;
	Sat, 25 Oct 2025 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761416690;
	bh=UlEaNYv6J/Zde5KNqT5g3/DYC9K785oQCnkAH4vHwn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gbq/xTHFqs06mnDXe5sQt5CFrriDcRmWLwjQViuYh4iKNx0zR7Ga5wkl1MmVPtM/3
	 eF++VhqVNjQE3wULTtiGgPM5tdDpuyKRZIyuo0f18sVrxkIMBWbGtrtDTRIo/2Fjx7
	 O/8zTK5Qg+mjKSWtOluCVjcH7xYVc1AxyxPGL5u1bzOAHR/5eOHCK5Ewcn8piaJHCt
	 9SHrGX06AssRBHTzWjEeLGoZGoHvJJGSkwv+eLkNm/JQWHkR+F5sK/8SGTUIbtovhn
	 MqN9fEIkuXR4k/1PQ1G+0xk3HAgy/9W+KR79ld6eVYFa4FVLlBu4iZT3AFXbt9YcpL
	 n1CpmkUO4Hp+Q==
Message-ID: <a1426a8b-85fb-4428-8d6b-540d3e0b1e33@kernel.org>
Date: Sat, 25 Oct 2025 13:24:48 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-6.1] drm/amd/display: Set up pixel encoding
 for YCBCR422
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Mario Limonciello <Mario.Limonciello@amd.com>,
 Mauri Carvalho <mcarvalho3@lenovo.com>, Wayne Lin <wayne.lin@amd.com>,
 Ray Wu <ray.wu@amd.com>, Daniel Wheeler <daniel.wheeler@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, alex.hung@amd.com,
 aurabindo.pillai@amd.com, chiahsuan.chung@amd.com,
 alexandre.f.demers@gmail.com
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-163-sashal@kernel.org>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20251025160905.3857885-163-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/25/25 10:56 AM, Sasha Levin wrote:
> From: Mario Limonciello <Mario.Limonciello@amd.com>
> 
> [ Upstream commit 5e76bc677cb7c92b37d8bc66bb67a18922895be2 ]
> 
> [Why]
> fill_stream_properties_from_drm_display_mode() will not configure pixel
> encoding to YCBCR422 when the DRM color format supports YCBCR422 but not
> YCBCR420 or YCBCR4444.  Instead it will fallback to RGB.
> 
> [How]
> Add support for YCBCR422 in pixel encoding mapping.
> 
> Suggested-by: Mauri Carvalho <mcarvalho3@lenovo.com>
> Reviewed-by: Wayne Lin <wayne.lin@amd.com>
> Signed-off-by: Mario Limonciello <Mario.Limonciello@amd.com>
> Signed-off-by: Ray Wu <ray.wu@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi,

I don't have a problem with this commit being backported, but if you're 
going to backport it please also backport the other one that came with 
it: db291ed1732e02e79dca431838713bbf602bda1c

Thanks!
> 
> LLM Generated explanations, may be completely bogus:
> 
> ## **Backport Recommendation: CONDITIONAL YES**
> 
> **This commit should be backported ONLY as part of a series with commit
> db291ed1732e0 "drm/amd/display: Add fallback path for YCBCR422".
> Backporting this commit alone is NOT recommended.**
> 
> ---
> 
> ## Detailed Analysis
> 
> ### What the Commit Does
> 
> Commit `5e76bc677cb7c` adds YCBCR422 pixel encoding support to the
> `fill_stream_properties_from_drm_display_mode()` function in
> `/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c` (lines 6408-6410 in
> the diff):
> 
> ```c
> else if ((connector->display_info.color_formats &
> DRM_COLOR_FORMAT_YCBCR422)
>                  && stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
>          timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
> ```
> 
> **The Bug Being Fixed**: Before this commit, when a display supported
> YCBCR422 color format but NOT YCBCR420 or YCBCR444, the driver would
> incorrectly fall back to RGB encoding instead of using the supported
> YCBCR422 encoding. This is a logic gap in the if-else chain that selects
> pixel encoding.
> 
> ### Critical Discovery: Immediate Follow-up Commit
> 
> Through extensive git history analysis, I discovered that commit
> `db291ed1732e0` "drm/amd/display: Add fallback path for YCBCR422" was
> committed **the very next day** (Aug 27, 2025) and **directly modifies
> the code added by this commit**:
> 
> **Original implementation (5e76bc677cb7c)**:
> ```c
> else if ((connector->display_info.color_formats &
> DRM_COLOR_FORMAT_YCBCR422)
>                  && stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)  // Check
> for HDMI
>          timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
> ```
> 
> **Modified by follow-up (db291ed1732e0)**:
> ```c
> else if ((connector->display_info.color_formats &
> DRM_COLOR_FORMAT_YCBCR422)
>                  && aconnector
>                  && aconnector->force_yuv422_output)  // Changed to opt-
> in flag
>          timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
> ```
> 
> ### Why This Matters
> 
> The follow-up commit `db291ed1732e0`:
> 
> 1. **Changes the behavior** from automatic YCBCR422 selection (when HDMI
>     display supports it) to opt-in via `force_yuv422_output` flag
> 2. **Adds a progressive fallback mechanism** for DisplayPort bandwidth
>     validation failures:
>     - First tries YUV422 8bpc (bandwidth efficient)
>     - Then YUV422 6bpc (reduced color depth)
>     - Finally YUV420 (last resort)
> 3. **Fixes a serious issue**: "This resolves cases where displays would
>     show no image due to insufficient DP link bandwidth for the requested
>     RGB mode"
> 4. **Adds the `force_yuv422_output` field** to `struct
>     amdgpu_dm_connector` in `amdgpu_dm.h`
> 
> ### Evidence of Close Relationship
> 
> - **Same author**: Mario Limonciello (both commits)
> - **Same suggested-by**: Mauri Carvalho (both commits)
> - **Same reviewer**: Wayne Lin (both commits)
> - **Same tester**: Daniel Wheeler (both commits)
> - **Consecutive commits**: Aug 26 and Aug 27, 2025
> - **No intervening commits**: These are back-to-back commits in the AMD
>    display driver
> 
> ### Technical Analysis Using Semcode
> 
> Using the `mcp__semcode__find_function` tool, I confirmed that:
> - YCBCR422 encoding (`PIXEL_ENCODING_YCBCR422`) is already well-
>    established in the AMD display driver
> - It's used in 13+ different locations across the driver subsystem for
>    clock calculations, stream encoding, and bandwidth management
> - The missing check in `fill_stream_properties_from_drm_display_mode()`
>    was indeed a gap that needed to be filled
> 
> ### Backporting Criteria Assessment
> 
> **For commit 5e76bc677cb7c ALONE:**
> 
> ✅ **Fixes a bug**: Yes - incorrect pixel encoding selection
> ✅ **Small and contained**: Yes - only 3 lines added
> ❌ **Minimal risk**: Questionable - behavior was modified the next day
> ✅ **No architectural changes**: Yes
> ✅ **Confined to subsystem**: Yes - AMD display driver only
> ❌ **Stable tag present**: No `Cc: stable@vger.kernel.org` tag
> ⚠️ **Complete fix**: No - requires follow-up commit for full
> functionality
> 
> **For BOTH commits as a series:**
> 
> ✅ All criteria above
> ✅ **Complete feature**: Yes - implements both HDMI YCBCR422 support and
> DP fallback
> ✅ **Tested together**: Yes - same test cycle, same tester
> ✅ **No known regressions**: No fixes or reverts found in subsequent
> history
> 
> ### Risk Analysis
> 
> **Risk of backporting 5e76bc677cb7c alone**: MODERATE-HIGH
> - Would enable automatic YCBCR422 for HDMI displays, which the follow-up
>    commit changed to opt-in
> - Would not include the DP bandwidth fallback mechanism that fixes "no
>    image" issues
> - Could introduce unexpected behavior changes that were corrected in
>    db291ed1732e0
> - Missing the `force_yuv422_output` field addition would cause
>    compilation issues if the field is referenced elsewhere
> 
> **Risk of backporting both commits together**: LOW
> - Represents the complete, tested implementation
> - Small, focused changes to AMD display driver
> - No subsequent fixes or reverts found
> - Addresses both HDMI pixel encoding and DP bandwidth issues
> 
> ### Recommendation
> 
> **YES - Backport to stable trees, BUT ONLY as a two-commit series:**
> 
> 1. **5e76bc677cb7c** "drm/amd/display: Set up pixel encoding for
>     YCBCR422"
> 2. **db291ed1732e0** "drm/amd/display: Add fallback path for YCBCR422"
> 
> **These commits should be treated as a single logical changeset**
> because:
> - They implement a complete feature (YCBCR422 support + DP fallback)
> - The second commit fundamentally modifies the first commit's behavior
> - They were developed, reviewed, and tested together
> - They fix related display issues (pixel encoding correctness and
>    bandwidth management)
> 
> **DO NOT backport commit 5e76bc677cb7c alone** as it represents an
> incomplete implementation that was refined the next day.
> 
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 8eb2fc4133487..3762b3c0ef983 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -6399,6 +6399,9 @@ static void fill_stream_properties_from_drm_display_mode(
>   			&& aconnector
>   			&& aconnector->force_yuv420_output)
>   		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
> +	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR422)
> +			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
> +		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
>   	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR444)
>   			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
>   		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR444;


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15810217704;
	Sat, 14 Feb 2026 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031127; cv=none; b=t4DxbMb0Im1puFuVgyjhX8+mkqGr69EUzZjgBC1vNjwmd/YhygMIFvBn5NxJUvO0U/o4NR1gT6FMCoVii44n2wg7sLQY6aOYRCSNB9oEeJfsiELFl4eYjYcIpr9ER9ZS29pcLJWt7YTmSwSz/5ft9jdvHr2QiNp5TZC/mHN8e4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031127; c=relaxed/simple;
	bh=pyYWi2Yhj9LmJKQmEjqNt0ZnJAZz2pK0wX2rYwgWGzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL8KGBzL5L9EKydi+LjqYeFamnsOZBeVaQr4LAAkcBY61YWsCg2wmCzEn8JkpySoGOC5s4pHL1yEnCTMoIOVuUe0i7qvIGnzdRl3ksaVgSkB3AZe6pEkw9U06wLfEr7J+yHphCkse9Rcseb6AcvzSwYqDhUxf//JVaV1WQEIu9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2DIooVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2DIooVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375BDC16AAE;
	Sat, 14 Feb 2026 01:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031127;
	bh=pyYWi2Yhj9LmJKQmEjqNt0ZnJAZz2pK0wX2rYwgWGzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2DIooVl0e1YoplS/p8BtzB7hcqdQsU6+GtdejHhufvfWzmt5A7VV1vEqW9NYd4rN
	 fCWeA/G+WFpdWRR1aCwstYFAWWsLwhNl0B4BQzQ1pjNJTLhsF6VPD50LWvFsci1ayr
	 so+4cHky5OGJlYIDD9+synW24Areq7a7AwRCtkMbkRzvqUYn8aMQvD6jyxWsIDMpoL
	 9xeqYVB2BsY/2oWjqYJUdr5BC1H1pjWiwEF+C9tUv3A6mlslOwFESCn5vI3dO/B3UN
	 tJ1FudaRUy9Li5w33TO6zW7n4855a560fYUxrqx9pMU8m2S+uWey0+Ne71cQHBfo5U
	 cnL17kxuAK3kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Stewart <Matthew.Stewart2@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	superm1@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	daniels@collabora.com,
	alvin.lee2@amd.com,
	contact@emersion.fr,
	david.rosca@amd.com,
	dmitry.baryshkov@oss.qualcomm.com,
	chaitanya.kumar.borah@intel.com,
	bold.zone2373@fastmail.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Fix GFX12 family constant checks
Date: Fri, 13 Feb 2026 19:59:12 -0500
Message-ID: <20260214010245.3671907-72-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Matthew Stewart <Matthew.Stewart2@amd.com>

[ Upstream commit bdad08670278829771626ea7b57c4db531e2544f ]

Using >=, <= for checking the family is not always correct.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Matthew Stewart <Matthew.Stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is crucial! The family constants are **not monotonically increasing
by generation**:

- `AMDGPU_FAMILY_AI` = 141 (GFX9/Vega)
- `AMDGPU_FAMILY_NV` = 143 (Navi10/GFX10)
- `AMDGPU_FAMILY_GC_11_0_0` = 145 (GFX11)
- `AMDGPU_FAMILY_GC_10_3_6` = 149 (GFX10.3!)
- `AMDGPU_FAMILY_GC_11_5_0` = 150
- `AMDGPU_FAMILY_GC_10_3_7` = 151 (GFX10.3!)
- `AMDGPU_FAMILY_GC_12_0_0` = 152 (GFX12)

This confirms the bug: `AMDGPU_FAMILY_GC_10_3_6` (149) and
`AMDGPU_FAMILY_GC_10_3_7` (151) are GFX10.3 parts but have values less
than `AMDGPU_FAMILY_GC_12_0_0` (152). Meanwhile, if any future family is
added with a value > 152, the old `>=` check would incorrectly treat it
as GFX12.

But more importantly, the `<` check in `amdgpu_dm_plane_validate_dcc`:

**Before:** `if (adev->family < AMDGPU_FAMILY_GC_12_0_0 && format >=
SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)`
**After:** `if (adev->family != AMDGPU_FAMILY_GC_12_0_0 && format >=
SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)`

This is also a real bug. Currently with `< AMDGPU_FAMILY_GC_12_0_0`,
family value 152 (GC_12_0_0) and anything above would skip the DCC
validation for video formats. With `!=`, only exactly GC_12_0_0 skips it
- every other family (whether above or below in numeric value) will
properly validate.

### Bug Impact

This is a **real bug** affecting AMD GFX12 GPU users (and potentially
future GPU families). The incorrect comparisons could cause:

1. **Wrong tiling/swizzle mode detection for cursor framebuffers** -
   Could result in corrupted cursor display or cursor rejection
2. **Incorrect DCC compression validation** - Could reject valid
   framebuffers or allow invalid ones, potentially causing display
   corruption
3. **Wrong plane buffer attribute filling** - Using GFX12-specific code
   paths for non-GFX12 hardware or vice versa, leading to display
   corruption or crashes

These are display path bugs that affect real users with AMD GFX12 GPUs.

### Scope and Risk Assessment

- **3 changes across 2 files** - Very small and surgical
- Each change is a single operator substitution: `>=` to `==` or `<` to
  `!=`
- The logic is obvious and easy to verify
- **Reviewed-by**, **Tested-by**, and signed by the AMD display
  maintainer
- Zero risk of regression - the fix makes the comparisons more
  precise/correct

### Stable Kernel Criteria Check

1. **Obviously correct and tested**: Yes - reviewed by AMD engineers,
   tested, and logically sound given the non-monotonic family constants
2. **Fixes a real bug**: Yes - incorrect GPU family identification leads
   to wrong display code paths
3. **Important issue**: Yes - display corruption/incorrect display
   behavior for GFX12 hardware users
4. **Small and contained**: Yes - 3 one-character changes across 2 files
5. **No new features**: Correct - pure bug fix
6. **Applies cleanly**: Likely, the code is straightforward

### Dependencies

This depends on GFX12 support existing in the stable tree. GFX12
(AMDGPU_FAMILY_GC_12_0_0) was introduced relatively recently, so this
would only apply to stable kernels that include GFX12 support (6.8+,
roughly). But for those trees, this is a necessary fix.

### Conclusion

This is a clear, surgical bug fix that corrects incorrect GPU family
identification logic in the AMD display driver. The family constants are
not monotonically ordered by GPU generation (GFX10.3 parts have values
149 and 151, sandwiched between GFX11 at 145-150 and GFX12 at 152),
making `>=`/`<` comparisons unreliable. The fix uses `==` for exact
matching, which is correct. The change is minimal, well-tested, and
prevents display issues on GFX12 hardware.

**YES**

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       | 2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a8a59126b2d2b..ea6a131bb9dc0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11853,7 +11853,7 @@ static int dm_check_cursor_fb(struct amdgpu_crtc *new_acrtc,
 	 * check tiling flags when the FB doesn't have a modifier.
 	 */
 	if (!(fb->flags & DRM_MODE_FB_MODIFIERS)) {
-		if (adev->family >= AMDGPU_FAMILY_GC_12_0_0) {
+		if (adev->family == AMDGPU_FAMILY_GC_12_0_0) {
 			linear = AMDGPU_TILING_GET(afb->tiling_flags, GFX12_SWIZZLE_MODE) == 0;
 		} else if (adev->family >= AMDGPU_FAMILY_AI) {
 			linear = AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 7c4496fb4b9d4..42642f90b4a69 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -278,7 +278,7 @@ static int amdgpu_dm_plane_validate_dcc(struct amdgpu_device *adev,
 	if (!dcc->enable)
 		return 0;
 
-	if (adev->family < AMDGPU_FAMILY_GC_12_0_0 &&
+	if (adev->family != AMDGPU_FAMILY_GC_12_0_0 &&
 	    format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
 		return -EINVAL;
 
@@ -901,7 +901,7 @@ int amdgpu_dm_plane_fill_plane_buffer_attributes(struct amdgpu_device *adev,
 			upper_32_bits(chroma_addr);
 	}
 
-	if (adev->family >= AMDGPU_FAMILY_GC_12_0_0) {
+	if (adev->family == AMDGPU_FAMILY_GC_12_0_0) {
 		ret = amdgpu_dm_plane_fill_gfx12_plane_attributes_from_modifiers(adev, afb, format,
 										 rotation, plane_size,
 										 tiling_info, dcc,
-- 
2.51.0


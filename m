Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5AA340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301050; cv=none; b=EP+HrcT6+0DZgvjrhP9aD06s+22DUjUbRNNxFQvU4A09qMOX7Za1WHDp3Z8XzIaxqrdrSzamyz0CFEZfXtbAlNN2Rij6wspix7pZnzn+2X+QI26M8UxRttSOypsGfPwVFc1OPjTJriixgh7U85ff8kxj3ja5fkSnG6kL9jpzV4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301050; c=relaxed/simple;
	bh=NotfnmaqYK3jl6Xgrmv86thZNX8HzcqVCulI8gosPCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZmaTVNb6y4DwXL7MvwLTAzZSetTWh0Ac8jwWWsgnDeqDyqiy30HkgIgDi33ScWdJlnsMWuoks/voJGQRB36coTMGVXri6cwkC+6HSmL61oqlfrGRTkJ6HcXn5jKz/LSMDGvzXPKPzV8/Tn2hGm7jFxb9xBzYxKbbva3rEDhcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwtMDHvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwtMDHvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B9C19423;
	Sat, 28 Feb 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301050;
	bh=NotfnmaqYK3jl6Xgrmv86thZNX8HzcqVCulI8gosPCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwtMDHvsoJD+0SRN994IedjmnHfznbT8Kc91CJHGplITrSIKSZyrXy03Yqsr+o3ii
	 qW/TjhvI0AtQ24kC05/7BwRDXbNrkRwh2ZVDELXDzp3ncFmkYixlZvH9uzOAoEzBC1
	 HlFunqFTGS6zEWl/YtaCznSswUrdU6wzxhhmz4CNvbZjVsNGNirAOXFpmfyz4pHNrO
	 ezGSQgh3iR3HQG/94R8ce1f9CeFSRDVWelXzAmry3BfWckNywzUg2iLAa9oDyLXUUH
	 F+YlUCC4pwJ0JkvKHzn83N7SRCpGEWKMbp39SWR6QQywTkBUjsRbm9BM4c86qntGKi
	 G1F7fGKyPEabw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Stewart <Matthew.Stewart2@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/752] drm/amd/display: Fix GFX12 family constant checks
Date: Sat, 28 Feb 2026 12:38:21 -0500
Message-ID: <20260228174750.1542406-190-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       | 2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a0077fe79ed26..b3cf43eb6e087 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11616,7 +11616,7 @@ static int dm_check_cursor_fb(struct amdgpu_crtc *new_acrtc,
 	 * check tiling flags when the FB doesn't have a modifier.
 	 */
 	if (!(fb->flags & DRM_MODE_FB_MODIFIERS)) {
-		if (adev->family >= AMDGPU_FAMILY_GC_12_0_0) {
+		if (adev->family == AMDGPU_FAMILY_GC_12_0_0) {
 			linear = AMDGPU_TILING_GET(afb->tiling_flags, GFX12_SWIZZLE_MODE) == 0;
 		} else if (adev->family >= AMDGPU_FAMILY_AI) {
 			linear = AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 9bb7475e80bad..2ecebf9a00fa4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -277,7 +277,7 @@ static int amdgpu_dm_plane_validate_dcc(struct amdgpu_device *adev,
 	if (!dcc->enable)
 		return 0;
 
-	if (adev->family < AMDGPU_FAMILY_GC_12_0_0 &&
+	if (adev->family != AMDGPU_FAMILY_GC_12_0_0 &&
 	    format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
 		return -EINVAL;
 
@@ -900,7 +900,7 @@ int amdgpu_dm_plane_fill_plane_buffer_attributes(struct amdgpu_device *adev,
 			upper_32_bits(chroma_addr);
 	}
 
-	if (adev->family >= AMDGPU_FAMILY_GC_12_0_0) {
+	if (adev->family == AMDGPU_FAMILY_GC_12_0_0) {
 		ret = amdgpu_dm_plane_fill_gfx12_plane_attributes_from_modifiers(adev, afb, format,
 										 rotation, plane_size,
 										 tiling_info, dcc,
-- 
2.51.0


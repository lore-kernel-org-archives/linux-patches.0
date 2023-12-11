Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C975102A;
	Mon, 11 Dec 2023 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX+2W2Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCE9C433C8;
	Mon, 11 Dec 2023 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320687;
	bh=K9HOyhRquWQ+m1N97Plnux6MEwTz/bMkjiZkZv0Zp5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX+2W2Adrb71F9foC611YykVfy4KpiLylNyUrVxPAepq+tWl+ejkC80PBaUTuvPIy
	 uUEaIOja1RvKVa+0rPOKmS0bvFcig6qslWAi/yrLwK48ohvXFwdAhuwl7/ifT16T3t
	 b8JTCXFZHmIBsEnPvR8PtImZ0JPKPuEfHlGKF13E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/194] drm/amd/amdgpu: Fix warnings in amdgpu/amdgpu_display.c
Date: Mon, 11 Dec 2023 19:22:24 +0100
Message-ID: <20231211182043.532247269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 93125cb704919f572c01e02ef64923caff1c3164 ]

Fixes the below checkpatch.pl warnings:

WARNING: Block comments use * on subsequent lines
WARNING: Block comments use a trailing */ on a separate line
WARNING: suspect code indent for conditional statements (8, 12)
WARNING: braces {} are not necessary for single statement blocks

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c6df7f313794 ("drm/amdgpu: correct the amdgpu runtime dereference usage count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 42 ++++++++++++---------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 2fced451f0aea..ee528ed639568 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -90,7 +90,7 @@ static void amdgpu_display_flip_work_func(struct work_struct *__work)
 
 	struct drm_crtc *crtc = &amdgpu_crtc->base;
 	unsigned long flags;
-	unsigned i;
+	unsigned int i;
 	int vpos, hpos;
 
 	for (i = 0; i < work->shared_count; ++i)
@@ -167,7 +167,7 @@ int amdgpu_display_crtc_page_flip_target(struct drm_crtc *crtc,
 	u64 tiling_flags;
 	int i, r;
 
-	work = kzalloc(sizeof *work, GFP_KERNEL);
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
 	if (work == NULL)
 		return -ENOMEM;
 
@@ -298,13 +298,15 @@ int amdgpu_display_crtc_set_config(struct drm_mode_set *set,
 
 	adev = drm_to_adev(dev);
 	/* if we have active crtcs and we don't have a power ref,
-	   take the current one */
+	 * take the current one
+	 */
 	if (active && !adev->have_disp_power_ref) {
 		adev->have_disp_power_ref = true;
 		return ret;
 	}
 	/* if we have no active crtcs, then drop the power ref
-	   we got before */
+	 * we got before
+	 */
 	if (!active && adev->have_disp_power_ref) {
 		pm_runtime_put_autosuspend(dev->dev);
 		adev->have_disp_power_ref = false;
@@ -473,11 +475,10 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 	if (amdgpu_connector->router.ddc_valid)
 		amdgpu_i2c_router_select_ddc_port(amdgpu_connector);
 
-	if (use_aux) {
+	if (use_aux)
 		ret = i2c_transfer(&amdgpu_connector->ddc_bus->aux.ddc, msgs, 2);
-	} else {
+	else
 		ret = i2c_transfer(&amdgpu_connector->ddc_bus->adapter, msgs, 2);
-	}
 
 	if (ret != 2)
 		/* Couldn't find an accessible DDC on this connector */
@@ -486,10 +487,12 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 	 * EDID header starts with:
 	 * 0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00.
 	 * Only the first 6 bytes must be valid as
-	 * drm_edid_block_valid() can fix the last 2 bytes */
+	 * drm_edid_block_valid() can fix the last 2 bytes
+	 */
 	if (drm_edid_header_is_valid(buf) < 6) {
 		/* Couldn't find an accessible EDID on this
-		 * connector */
+		 * connector
+		 */
 		return false;
 	}
 	return true;
@@ -1204,8 +1207,10 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 
 	obj = drm_gem_object_lookup(file_priv, mode_cmd->handles[0]);
 	if (obj ==  NULL) {
-		drm_dbg_kms(dev, "No GEM object associated to handle 0x%08X, "
-			    "can't create framebuffer\n", mode_cmd->handles[0]);
+		drm_dbg_kms(dev,
+			    "No GEM object associated to handle 0x%08X, can't create framebuffer\n",
+			    mode_cmd->handles[0]);
+
 		return ERR_PTR(-ENOENT);
 	}
 
@@ -1398,6 +1403,7 @@ bool amdgpu_display_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
 	}
 	if (amdgpu_crtc->rmx_type != RMX_OFF) {
 		fixed20_12 a, b;
+
 		a.full = dfixed_const(src_v);
 		b.full = dfixed_const(dst_v);
 		amdgpu_crtc->vsc.full = dfixed_div(a, b);
@@ -1417,7 +1423,7 @@ bool amdgpu_display_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
  *
  * \param dev Device to query.
  * \param pipe Crtc to query.
- * \param flags Flags from caller (DRM_CALLED_FROM_VBLIRQ or 0).
+ * \param flags from caller (DRM_CALLED_FROM_VBLIRQ or 0).
  *              For driver internal use only also supports these flags:
  *
  *              USE_REAL_VBLANKSTART to use the real start of vblank instead
@@ -1493,8 +1499,8 @@ int amdgpu_display_get_crtc_scanoutpos(struct drm_device *dev,
 
 	/* Called from driver internal vblank counter query code? */
 	if (flags & GET_DISTANCE_TO_VBLANKSTART) {
-	    /* Caller wants distance from real vbl_start in *hpos */
-	    *hpos = *vpos - vbl_start;
+		/* Caller wants distance from real vbl_start in *hpos */
+		*hpos = *vpos - vbl_start;
 	}
 
 	/* Fudge vblank to start a few scanlines earlier to handle the
@@ -1516,7 +1522,7 @@ int amdgpu_display_get_crtc_scanoutpos(struct drm_device *dev,
 
 	/* In vblank? */
 	if (in_vbl)
-	    ret |= DRM_SCANOUTPOS_IN_VBLANK;
+		ret |= DRM_SCANOUTPOS_IN_VBLANK;
 
 	/* Called from driver internal vblank counter query code? */
 	if (flags & GET_DISTANCE_TO_VBLANKSTART) {
@@ -1622,6 +1628,7 @@ int amdgpu_display_suspend_helper(struct amdgpu_device *adev)
 
 		if (amdgpu_crtc->cursor_bo && !adev->enable_virtual_display) {
 			struct amdgpu_bo *aobj = gem_to_amdgpu_bo(amdgpu_crtc->cursor_bo);
+
 			r = amdgpu_bo_reserve(aobj, true);
 			if (r == 0) {
 				amdgpu_bo_unpin(aobj);
@@ -1629,9 +1636,9 @@ int amdgpu_display_suspend_helper(struct amdgpu_device *adev)
 			}
 		}
 
-		if (fb == NULL || fb->obj[0] == NULL) {
+		if (!fb || !fb->obj[0])
 			continue;
-		}
+
 		robj = gem_to_amdgpu_bo(fb->obj[0]);
 		if (!amdgpu_display_robj_is_fb(adev, robj)) {
 			r = amdgpu_bo_reserve(robj, true);
@@ -1658,6 +1665,7 @@ int amdgpu_display_resume_helper(struct amdgpu_device *adev)
 
 		if (amdgpu_crtc->cursor_bo && !adev->enable_virtual_display) {
 			struct amdgpu_bo *aobj = gem_to_amdgpu_bo(amdgpu_crtc->cursor_bo);
+
 			r = amdgpu_bo_reserve(aobj, true);
 			if (r == 0) {
 				r = amdgpu_bo_pin(aobj, AMDGPU_GEM_DOMAIN_VRAM);
-- 
2.42.0




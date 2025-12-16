Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC4385CCF;
	Tue, 16 Dec 2025 12:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888618; cv=none; b=EiXsG3mo/+IVoLmBXPjtZ0jSyedVsLqKgzyhAyJBXGB0qjX7dDUv19Pay8+2MMgwNUQO45dzwji2kVFsy+Eb+2+iBpGjBcoXoOucNGJJmK0d6kHw2gJxxKv68g4NgmTK8oNdGWZ2hThKoqO01QJ1ARZPFhgxNX2UQ6vdo62XgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888618; c=relaxed/simple;
	bh=JvdKU0U9b6wuu2NqVLam+Mt/HALkAtq7IaHvI5bKfd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiqyKpC90ybvuh2wKHkHWUftaglaaH0J5bGx1pMVPFEA5ly4yNETt8sZnrSlzhH8Y1h96pLfE67RjljLeQg0OmETpGpnvzJAhvmrxCOSGpHZKsxoaN0SD/zdO5+ficvGxPHTRQ251SEA0BSD6tiKzqn5j5st5zOGgN7aORzksZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=repmFiSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="repmFiSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618CFC4CEF1;
	Tue, 16 Dec 2025 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888617;
	bh=JvdKU0U9b6wuu2NqVLam+Mt/HALkAtq7IaHvI5bKfd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=repmFiSue/HXp7I5kqTm2WlzYbbBAY3D5YxmY3a/zEGSWRfqbce2pfr7zEeyyZ0ny
	 IDV3tHSOzCDkqsIYd1L++UoN3WlAbqpuhRsuD5Kh2nYj0nqiorJyscbIwWzg+BoLT5
	 hyJd7HgbIsWRHuKvN6Xbhl3aZZEIuBQ+MEO9fR6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 587/614] drm/{i915, xe}/fbdev: pass struct drm_device to intel_fbdev_fb_alloc()
Date: Tue, 16 Dec 2025 12:15:54 +0100
Message-ID: <20251216111422.660163563@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 9e5cf822a207ee8c9856024c047abaccb4d185e5 ]

The function doesn't actually need struct drm_fb_helper for anything,
just pass struct drm_device.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/16360584f80cdc5ee35fd94cfd92fd3955588dfd.1758184771.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 460b31720369 ("drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c    |  2 +-
 drivers/gpu/drm/i915/display/intel_fbdev_fb.c | 10 +++++-----
 drivers/gpu/drm/i915/display/intel_fbdev_fb.h |  4 ++--
 drivers/gpu/drm/xe/display/intel_fbdev_fb.c   |  7 +++----
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index 7c4709d58aa34..46c6de5f60888 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -237,7 +237,7 @@ int intel_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 	if (!fb || drm_WARN_ON(display->drm, !intel_fb_bo(&fb->base))) {
 		drm_dbg_kms(display->drm,
 			    "no BIOS fb, allocating a new one\n");
-		fb = intel_fbdev_fb_alloc(helper, sizes);
+		fb = intel_fbdev_fb_alloc(display->drm, sizes);
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 	} else {
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
index b9dfd00a7d05b..4de13d1a4c7a7 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
@@ -13,11 +13,11 @@
 #include "intel_fb.h"
 #include "intel_fbdev_fb.h"
 
-struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
+struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
 					       struct drm_fb_helper_surface_size *sizes)
 {
-	struct intel_display *display = to_intel_display(helper->dev);
-	struct drm_i915_private *dev_priv = to_i915(display->drm);
+	struct intel_display *display = to_intel_display(drm);
+	struct drm_i915_private *dev_priv = to_i915(drm);
 	struct drm_framebuffer *fb;
 	struct drm_mode_fb_cmd2 mode_cmd = {};
 	struct drm_i915_gem_object *obj;
@@ -58,12 +58,12 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
 	}
 
 	if (IS_ERR(obj)) {
-		drm_err(display->drm, "failed to allocate framebuffer (%pe)\n", obj);
+		drm_err(drm, "failed to allocate framebuffer (%pe)\n", obj);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	fb = intel_framebuffer_create(intel_bo_to_drm_bo(obj),
-				      drm_get_format_info(display->drm,
+				      drm_get_format_info(drm,
 							  mode_cmd.pixel_format,
 							  mode_cmd.modifier[0]),
 				      &mode_cmd);
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev_fb.h b/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
index cb79572727150..668ae355f5e5b 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
+++ b/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
@@ -6,14 +6,14 @@
 #ifndef __INTEL_FBDEV_FB_H__
 #define __INTEL_FBDEV_FB_H__
 
-struct drm_fb_helper;
+struct drm_device;
 struct drm_fb_helper_surface_size;
 struct drm_gem_object;
 struct fb_info;
 struct i915_vma;
 struct intel_display;
 
-struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
+struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
 					       struct drm_fb_helper_surface_size *sizes);
 int intel_fbdev_fb_fill_info(struct intel_display *display, struct fb_info *info,
 			     struct drm_gem_object *obj, struct i915_vma *vma);
diff --git a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
index bce4cb16f6820..5c0874bfa6ab1 100644
--- a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
@@ -15,12 +15,11 @@
 
 #include <generated/xe_wa_oob.h>
 
-struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
+struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
 					       struct drm_fb_helper_surface_size *sizes)
 {
 	struct drm_framebuffer *fb;
-	struct drm_device *dev = helper->dev;
-	struct xe_device *xe = to_xe_device(dev);
+	struct xe_device *xe = to_xe_device(drm);
 	struct drm_mode_fb_cmd2 mode_cmd = {};
 	struct xe_bo *obj;
 	int size;
@@ -67,7 +66,7 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
 	}
 
 	fb = intel_framebuffer_create(&obj->ttm.base,
-				      drm_get_format_info(dev,
+				      drm_get_format_info(drm,
 							  mode_cmd.pixel_format,
 							  mode_cmd.modifier[0]),
 				      &mode_cmd);
-- 
2.51.0




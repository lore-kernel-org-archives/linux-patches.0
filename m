Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285B0357736;
	Tue, 16 Dec 2025 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886593; cv=none; b=p6f6UGRWiiW0sSZcm1m0de5sAAJQjox+B5PHOvdZTIGU4WGfzM9csauxnwKRXlxIO+fhG/tW9LH9cJngS4GfvF2OrRP9pabYC/eeEB3AwTD1geVnQvhgKGuvb/Ea4gIkwpOiEbkBzVci3IjlIXW3F25TJGfSA2LwqbOvi8cbBzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886593; c=relaxed/simple;
	bh=nrBYrLJiTmnIgeCIIxmIdhaXTPWB4aEg1zmwcLLnRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qf5XgsRJSNeg37TubQ1w2mp81azd89NC9377QLXRQ6/ZIC3VuGtUzJWhQ5Mmfgm1uIm3YL/LCOQlTkzg57fQlSKyZ6+WMxdzEBzOQkbRY/WO4Uj6fbG7K1+oOrh6lehk74XNK/xP+cbwe1xwfTSqQ6wxR0OVxav9uB6TJgT0WZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scX5t6k9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scX5t6k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D76C4CEF1;
	Tue, 16 Dec 2025 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886593;
	bh=nrBYrLJiTmnIgeCIIxmIdhaXTPWB4aEg1zmwcLLnRJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scX5t6k9JqvoPDjussIhcLjfNWkt67mWn0xH4KtBG7n/W0o+s2wgDWnkrywu7tY8T
	 0Riw/rnqO1B/NTj5DQHAo+cptoE4cjvVZYSrrCVkBoGvRsXsSzGTkGaPqfOkVQBwFm
	 L7kXy4t8LCvOnps6ZwnPCV083ifxBdbD9WOwWr5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 482/507] drm/{i915, xe}/fbdev: pass struct drm_device to intel_fbdev_fb_alloc()
Date: Tue, 16 Dec 2025 12:15:23 +0100
Message-ID: <20251216111402.903690169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 37a48c6f2d531..4c9e4de92d3c7 100644
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




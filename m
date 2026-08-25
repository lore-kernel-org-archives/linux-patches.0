Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC96481255;
	Tue, 25 Aug 2026 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664873; cv=none; b=CMDQLraSdcQONfNP7WONqpTFUk/bVgY20SFxcfC7noo0QQIMBF1ETqFfD3r6oTO0M+Tdnw6CcSZv0wmQP1BtAIvSbUJLy73kYZB72Azpd/vHIoFCZZcAx6Tm1eZ9g0w0OdrOH67hfAive2pDM9stReGSMBST3JUHzpnGV+U5fMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664873; c=relaxed/simple;
	bh=41OwfW1VE/TPHmo1CXdDiIbwNcJUV2ldBtpFOhkIDMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ur7RnkF3QQ3DLr9sX7yJfvM61t4Sa4iLpd8XszumhORmt8wgcIwycPGAY2ATSSvgbZZ7fnA02PrtNqI4cYMXilHN3iGoP103XGYwmMhlj/OHL++uEV97MpUh1QPaztPHh0MWRTgLQw/QV4D+yDB0wIWZ663g4or72rJ8ijbIHyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMDXWlTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMDXWlTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F6F1F000E9;
	Tue, 25 Aug 2026 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664872;
	bh=1E/a6r4xGFqu9Xn0qlfIXOvvH2iV0MeA5eZvT9GOmFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMDXWlTDiBK0lgyUabv5U5zfc7PAvKvE6LcUtt/UMxzTl13BpfqH4XSfQdbqGqYEB
	 laoOEhR4EdHNeTq7iapc/Nn/L7/pZWVa+KTa+QdciIavG2TtiBTxsFNkrS1vZ5Sl1y
	 H7HlYEIP62pCn3HTEBY97lWdVW/HMmIKf5KVeIPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 033/101] drm/i915/pin: s/dev_priv/i915/ and drop struct drm_device usage
Date: Tue, 25 Aug 2026 15:25:11 +0200
Message-ID: <20260825132543.309855445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 3823bf019d3b31ccd3e79860b7a3e20c719a1db4 ]

Improve consistency within i915_fb_pin.c by replacing dev_priv naming
with i915, and dropping struct drm_device usage.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/3a4ac0a732a561a487e46838bde6327cff5ccb38.1775556190.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: fc6487579083 ("drm/xe: Fix DPT allocation paths.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fb_pin.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_fb_pin.c
+++ b/drivers/gpu/drm/i915/display/intel_fb_pin.c
@@ -29,9 +29,8 @@ intel_fb_pin_to_dpt(const struct drm_fra
 		    unsigned long *out_flags,
 		    struct intel_dpt *dpt)
 {
-	struct drm_device *dev = fb->dev;
-	struct intel_display *display = to_intel_display(dev);
-	struct drm_i915_private *dev_priv = to_i915(dev);
+	struct intel_display *display = to_intel_display(fb->dev);
+	struct drm_i915_private *i915 = to_i915(fb->dev);
 	struct drm_gem_object *_obj = intel_fb_bo(fb);
 	struct drm_i915_gem_object *obj = to_intel_bo(_obj);
 	struct i915_address_space *vm = i915_dpt_to_vm(dpt);
@@ -43,7 +42,7 @@ intel_fb_pin_to_dpt(const struct drm_fra
 	 * We are not syncing against the binding (and potential migrations)
 	 * below, so this vm must never be async.
 	 */
-	if (drm_WARN_ON(&dev_priv->drm, vm->bind_async_flags))
+	if (drm_WARN_ON(&i915->drm, vm->bind_async_flags))
 		return ERR_PTR(-EINVAL);
 
 	if (WARN_ON(!i915_gem_object_is_framebuffer(obj)))
@@ -56,7 +55,7 @@ intel_fb_pin_to_dpt(const struct drm_fra
 		if (ret)
 			continue;
 
-		if (HAS_LMEM(dev_priv)) {
+		if (HAS_LMEM(i915)) {
 			unsigned int flags = obj->flags;
 
 			/*
@@ -118,9 +117,8 @@ intel_fb_pin_to_ggtt(const struct drm_fr
 		     bool uses_fence,
 		     unsigned long *out_flags)
 {
-	struct drm_device *dev = fb->dev;
-	struct intel_display *display = to_intel_display(dev);
-	struct drm_i915_private *dev_priv = to_i915(dev);
+	struct intel_display *display = to_intel_display(fb->dev);
+	struct drm_i915_private *i915 = to_i915(fb->dev);
 	struct drm_gem_object *_obj = intel_fb_bo(fb);
 	struct drm_i915_gem_object *obj = to_intel_bo(_obj);
 	struct ref_tracker *wakeref;
@@ -129,10 +127,10 @@ intel_fb_pin_to_ggtt(const struct drm_fr
 	unsigned int pinctl;
 	int ret;
 
-	if (drm_WARN_ON(dev, !i915_gem_object_is_framebuffer(obj)))
+	if (drm_WARN_ON(&i915->drm, !i915_gem_object_is_framebuffer(obj)))
 		return ERR_PTR(-EINVAL);
 
-	if (drm_WARN_ON(dev, alignment && !is_power_of_2(alignment)))
+	if (drm_WARN_ON(&i915->drm, alignment && !is_power_of_2(alignment)))
 		return ERR_PTR(-EINVAL);
 
 	/*
@@ -163,7 +161,7 @@ retry:
 	ret = i915_gem_object_lock(obj, &ww);
 	if (!ret && phys_alignment)
 		ret = i915_gem_object_attach_phys(obj, phys_alignment);
-	else if (!ret && HAS_LMEM(dev_priv))
+	else if (!ret && HAS_LMEM(i915))
 		ret = i915_gem_object_migrate(obj, &ww, INTEL_REGION_LMEM_0);
 	if (!ret)
 		ret = i915_gem_object_pin_pages(obj);
@@ -264,7 +262,7 @@ intel_plane_fb_vtd_guard(const struct in
 int intel_plane_pin_fb(struct intel_plane_state *plane_state,
 		       const struct intel_plane_state *old_plane_state)
 {
-	struct intel_display *display = to_intel_display(plane_state);
+	struct drm_i915_private *i915 = to_i915(plane_state->uapi.plane->dev);
 	struct intel_plane *plane = to_intel_plane(plane_state->uapi.plane);
 	const struct intel_framebuffer *fb =
 		to_intel_framebuffer(plane_state->hw.fb);
@@ -308,7 +306,7 @@ int intel_plane_pin_fb(struct intel_plan
 		 * The DPT object contains only one vma, and there is no VT-d
 		 * guard, so the VMA's offset within the DPT is always 0.
 		 */
-		drm_WARN_ON(display->drm, i915_dpt_offset(plane_state->dpt_vma));
+		drm_WARN_ON(&i915->drm, i915_dpt_offset(plane_state->dpt_vma));
 	}
 
 	/*



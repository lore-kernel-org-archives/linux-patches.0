Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D3D1B3927;
	Mon, 10 Mar 2025 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627686; cv=none; b=RLcv2czJd0Z/4Hn8UfX+mnJ6qQgYnoy9D+eHuOKNqEyIYC/J0Y+tNKJ0wAcBrT2o0V0VVz7VkEjoqI/aFVwb3cfUV74C4SVIZqTPxN7HiebdNSpqtN5RSzcGgjJavbONB5pJJe9ZcNHXX1H1NCeft0qwa6Bw5z163SjppzwA+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627686; c=relaxed/simple;
	bh=g5BLrxXtQyavrtIFbYzX/l7eM5bIj4WhTTwAek4ZMos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdiJLRwarW86L8zGMs7r2MayTy+VltfrwQu4FpzGSOeKtHKPH/21m9uS62blxR8LtiN3vPJIYhE+chIiMJWa5pKTZfOJvkitYAFSFbR5F3DpHlOLi0tAnchfPhvfrVsBSv5XVdmH8SIfGOYcqDIGbFTFQ5JML1jYkXIeuBLlcMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeBgKOdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeBgKOdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB22C4CEE5;
	Mon, 10 Mar 2025 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627685;
	bh=g5BLrxXtQyavrtIFbYzX/l7eM5bIj4WhTTwAek4ZMos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeBgKOdTr5um4B71c1CwByBKc3jMSQplkKXaQBYQ5LZnP0AJNlrcrV1AZQ9iFXmF1
	 Il/S68dhUhVcJhHXuwZGpeeQOgDQs/RSMLqsN3vlhymEwnK8cW2n/J7Z11He8s1cHu
	 053iLW5SsmeXXrSJ5SV9ToRcyI2r+FJ3va30dKxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/269] drm/xe: Remove double pageflip
Date: Mon, 10 Mar 2025 18:05:36 +0100
Message-ID: <20250310170505.003444396@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit 30bfc151f0c1ec80c27a80a7651b2c15c648ad16 ]

This is already handled below in the code by fixup_initial_plane_config.

Fixes: a8153627520a ("drm/i915: Try to relocate the BIOS fb to the start of ggtt")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210083111.230484-3-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
(cherry picked from commit 2218704997979fbf11765281ef752f07c5cf25bb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_plane_initial.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_plane_initial.c b/drivers/gpu/drm/xe/display/xe_plane_initial.c
index 0ae3f02b9261b..f99d38cc5d8e9 100644
--- a/drivers/gpu/drm/xe/display/xe_plane_initial.c
+++ b/drivers/gpu/drm/xe/display/xe_plane_initial.c
@@ -194,8 +194,6 @@ intel_find_initial_plane_obj(struct intel_crtc *crtc,
 		to_intel_plane(crtc->base.primary);
 	struct intel_plane_state *plane_state =
 		to_intel_plane_state(plane->base.state);
-	struct intel_crtc_state *crtc_state =
-		to_intel_crtc_state(crtc->base.state);
 	struct drm_framebuffer *fb;
 	struct i915_vma *vma;
 
@@ -241,14 +239,6 @@ intel_find_initial_plane_obj(struct intel_crtc *crtc,
 	atomic_or(plane->frontbuffer_bit, &to_intel_frontbuffer(fb)->bits);
 
 	plane_config->vma = vma;
-
-	/*
-	 * Flip to the newly created mapping ASAP, so we can re-use the
-	 * first part of GGTT for WOPCM, prevent flickering, and prevent
-	 * the lookup of sysmem scratch pages.
-	 */
-	plane->check_plane(crtc_state, plane_state);
-	plane->async_flip(NULL, plane, crtc_state, plane_state, true);
 	return;
 
 nofb:
-- 
2.39.5




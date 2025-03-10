Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B316B17A2E3;
	Mon, 10 Mar 2025 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626830; cv=none; b=XLoTkGbXE92bEjmgTIuZa3t6nVW/ZKleDqvepEYBbHPgX+VvocgyvntBPzG9SOd9YPVd29OhQ8eIOhKRtmoSgcp9KMGe7+MBcwqaUCS4BemB9uHfX8zd2zH84VxSJ2i6c8fBUiPsVGOKewzg1C658c+ahZMEWpHsw5gdHDZSiBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626830; c=relaxed/simple;
	bh=mfWvI21v5x8oLl4j09IuezZStJYLifedV21mO2AtY/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RO27/pj/Pktv/DLZbtYeExXHiu832yI6CX1lXsWz3+HqUeVvzJDCzxKlKqcTzmkApbikrGLYVr29r5rgXaQ05NiIHTfrElrOMLhHKArTPqqAdhZbVer9GUehY5290JlzP0E7o2kRz2bAI9XIMZQ5973Hewn8btWuAzHU9QbywZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPA5pPtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPA5pPtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D7C4CEE5;
	Mon, 10 Mar 2025 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626830;
	bh=mfWvI21v5x8oLl4j09IuezZStJYLifedV21mO2AtY/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPA5pPtuu4rRsZMKdTxiyw2A/5EIG9fontIAnXaIGZUprp2MNJS96YtwMv69Deams
	 AMHpEXLGqPpTObssFgsHxi6pjQ4rUSC5yOnWgeGMEg7yesXuh8+Ui6v1cC776Z9S3q
	 wi0cIgXQDw3r2qNy9NCr1mnbj4tJoXlGRn+zLM9g=
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
Subject: [PATCH 6.13 127/207] drm/xe: Remove double pageflip
Date: Mon, 10 Mar 2025 18:05:20 +0100
Message-ID: <20250310170452.853317329@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8c113463a3d55..668f544a7ac80 100644
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




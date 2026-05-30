Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150430E847;
	Sat, 30 May 2026 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161692; cv=none; b=kDj4QfAQ0+gYrhWWuPK8Vyuq4kg5RCAMNjLxxwHrfKp+AiBFFRU8kBRoBitUYfJ3mSzFlj2pmyTJHQ6gu/LVRqC6gDYLQre1M4tdQCp4W2Tezg/SqXQqW65b6baL9zVhw1tj63Cxd2V80+8VlObv/58xrRCBqC2RfWAn5zsImPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161692; c=relaxed/simple;
	bh=B6vgtDk8qK1SsQIL8RtnXM+8hISzJBG6dXsFH0LGDcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/Wh+/YC+5on3jmzsrfTGUUO/qrvkDKZJL7oIaVOqtKVq+vSqOma9AmuTKc3lnCl6PUKXwnQZoLQKMZnYXoZjTs1RNTRE2ly7yJqYammhrbnxkEk404GQWADMwmlD+szuE8IOQWnJfhnasBAQ29C2vNKgcoavSYBa7VgpN032PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+gQbDj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+gQbDj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FF11F00893;
	Sat, 30 May 2026 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161691;
	bh=qq3THpyNWC1UlgmdSq/tnuQ8n+9pJ4EEymKRRgMzhi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+gQbDj/uR1gJT071p5zMI+7al/N0KrhFIiqLmCyJK83m0wxVaUdW9lhAPmS9H74r
	 80uXUB3qSq74TJOeSdr09TR014PTOCQAgBh5uOjCMezP13LwY/nxXThhCxWJ2cPaEk
	 KrcRagQp0NkKGwNjJxp5vRCgUqlxqyKDFz9oV6UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 669/969] drm/i915: Constify watermark state checker
Date: Sat, 30 May 2026 18:03:13 +0200
Message-ID: <20260530160318.962686319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 487a2db8bc4eb79c53c9ff8fca65a7fc8350df6c ]

The skl+ wm state checker has no reason to modify the crtc state,
so make it const.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231004155607.7719-6-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: a97c88a176b6 ("drm/i915/wm: Verify the correct plane DDB entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 2 +-
 drivers/gpu/drm/i915/display/skl_watermark.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index a7adf02476f6a..b6951881c0570 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3014,7 +3014,7 @@ void skl_wm_sanitize(struct drm_i915_private *i915)
 }
 
 void intel_wm_state_verify(struct intel_crtc *crtc,
-			   struct intel_crtc_state *new_crtc_state)
+			   const struct intel_crtc_state *new_crtc_state)
 {
 	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
 	struct skl_hw_state {
diff --git a/drivers/gpu/drm/i915/display/skl_watermark.h b/drivers/gpu/drm/i915/display/skl_watermark.h
index 7a5a4e67cd738..d1a1fe322e869 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.h
+++ b/drivers/gpu/drm/i915/display/skl_watermark.h
@@ -42,7 +42,7 @@ void skl_wm_get_hw_state(struct drm_i915_private *i915);
 void skl_wm_sanitize(struct drm_i915_private *i915);
 
 void intel_wm_state_verify(struct intel_crtc *crtc,
-			   struct intel_crtc_state *new_crtc_state);
+			   const struct intel_crtc_state *new_crtc_state);
 
 void skl_watermark_ipc_init(struct drm_i915_private *i915);
 void skl_watermark_ipc_update(struct drm_i915_private *i915);
-- 
2.53.0




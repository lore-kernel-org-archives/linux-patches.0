Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059B125228D;
	Thu, 15 Jan 2026 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495941; cv=none; b=QcN8AqAj99PCVvl317Zs5nuDq37lO16ZT/+odHuUHjzwj9e6fgS/NX+EZ/c+UkDzH7wvk2/fy/kdW/dkli1zP0XoEQIte8yrMt3b1Yjz6mizsLmjaKKC8hvyg5aMrIgoYb7eeAGvqDZcnAKBBiF3qbhZhaM84NSZJ/RytX2Dxv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495941; c=relaxed/simple;
	bh=qdVWp603Ql5LubXRSiscej5NbPj4mq/QGNV2+VRBmJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3jwwR7q9J4aQWRaP3L8xrNcFhFt7onskkeE2I8fsGge+gk+3r+LPK4rNyTf85ghlZ5B8Z+URXdXb21kDDRG1TpWtGhGDK63S00bFcbPO1UPPIVN8oqRv0Bao0OujUXhFu+SoDzZCb6deepLhFjUUw5ceqQTTlwTtGBdM24wqBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrHoI9Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrHoI9Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D06FC116D0;
	Thu, 15 Jan 2026 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495940;
	bh=qdVWp603Ql5LubXRSiscej5NbPj4mq/QGNV2+VRBmJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrHoI9GdKSw3G0pHOPjuGuIXxOTbqGjDoMpaWCMQJZComwWDFdV4vY1jjD/0Zfaag
	 1fojQm/P7NkUIL3fRj5paiU8SA/RUeXtqKv+skGlu/WB3gMy7VeZjWp8RqQ7FrtYj9
	 Vy/UD/CsMTE1r3WOQoOm+rmMtktvUixqUUNsTnoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Maxime Ripard <mripard@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 021/181] Revert "drm/atomic-helper: Re-order bridge chain pre-enable and post-disable"
Date: Thu, 15 Jan 2026 17:45:58 +0100
Message-ID: <20260115164203.090438338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit c1ef9a6cabb34dbc09e31417b0c0a672fe0de13a upstream.

This reverts commit c9b1150a68d9362a0827609fc0dc1664c0d8bfe1.

Changing the enable/disable sequence has caused regressions on multiple
platforms: R-Car, MCDE, Rockchip. A series (see link below)  was sent to
fix these, but it was decided that it's better to revert the original
patch and change the enable/disable sequence only in the tidss driver.

Reverting this commit breaks tidss's DSI and OLDI outputs, which will be
fixed in the following commits.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://lore.kernel.org/all/20251202-mcde-drm-regression-thirdfix-v6-0-f1bffd4ec0fa%40kernel.org/
Fixes: c9b1150a68d9 ("drm/atomic-helper: Re-order bridge chain pre-enable and post-disable")
Cc: stable@vger.kernel.org # v6.17+
Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20251205-drm-seq-fix-v1-1-fda68fa1b3de@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_helper.c |   8 +-
 include/drm/drm_bridge.h            | 249 ++++++++--------------------
 2 files changed, 70 insertions(+), 187 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 10adac9397cf..ef97f37560b2 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1341,9 +1341,9 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *state)
 {
 	encoder_bridge_disable(dev, state);
 
-	crtc_disable(dev, state);
-
 	encoder_bridge_post_disable(dev, state);
+
+	crtc_disable(dev, state);
 }
 
 /**
@@ -1682,10 +1682,10 @@ encoder_bridge_enable(struct drm_device *dev, struct drm_atomic_state *state)
 void drm_atomic_helper_commit_modeset_enables(struct drm_device *dev,
 					      struct drm_atomic_state *state)
 {
-	encoder_bridge_pre_enable(dev, state);
-
 	crtc_enable(dev, state);
 
+	encoder_bridge_pre_enable(dev, state);
+
 	encoder_bridge_enable(dev, state);
 
 	drm_atomic_helper_commit_writebacks(dev, state);
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 0ff7ab4aa868..dbafe136833f 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -176,33 +176,17 @@ struct drm_bridge_funcs {
 	/**
 	 * @disable:
 	 *
-	 * The @disable callback should disable the bridge.
+	 * This callback should disable the bridge. It is called right before
+	 * the preceding element in the display pipe is disabled. If the
+	 * preceding element is a bridge this means it's called before that
+	 * bridge's @disable vfunc. If the preceding element is a &drm_encoder
+	 * it's called right before the &drm_encoder_helper_funcs.disable,
+	 * &drm_encoder_helper_funcs.prepare or &drm_encoder_helper_funcs.dpms
+	 * hook.
 	 *
 	 * The bridge can assume that the display pipe (i.e. clocks and timing
 	 * signals) feeding it is still running when this callback is called.
 	 *
-	 *
-	 * If the preceding element is a &drm_bridge, then this is called before
-	 * that bridge is disabled via one of:
-	 *
-	 * - &drm_bridge_funcs.disable
-	 * - &drm_bridge_funcs.atomic_disable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called before the encoder is disabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_disable
-	 * - &drm_encoder_helper_funcs.prepare
-	 * - &drm_encoder_helper_funcs.disable
-	 * - &drm_encoder_helper_funcs.dpms
-	 *
-	 * and the CRTC is disabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.prepare
-	 * - &drm_crtc_helper_funcs.atomic_disable
-	 * - &drm_crtc_helper_funcs.disable
-	 * - &drm_crtc_helper_funcs.dpms.
-	 *
 	 * The @disable callback is optional.
 	 *
 	 * NOTE:
@@ -215,34 +199,17 @@ struct drm_bridge_funcs {
 	/**
 	 * @post_disable:
 	 *
+	 * This callback should disable the bridge. It is called right after the
+	 * preceding element in the display pipe is disabled. If the preceding
+	 * element is a bridge this means it's called after that bridge's
+	 * @post_disable function. If the preceding element is a &drm_encoder
+	 * it's called right after the encoder's
+	 * &drm_encoder_helper_funcs.disable, &drm_encoder_helper_funcs.prepare
+	 * or &drm_encoder_helper_funcs.dpms hook.
+	 *
 	 * The bridge must assume that the display pipe (i.e. clocks and timing
-	 * signals) feeding this bridge is no longer running when the
-	 * @post_disable is called.
-	 *
-	 * This callback should perform all the actions required by the hardware
-	 * after it has stopped receiving signals from the preceding element.
-	 *
-	 * If the preceding element is a &drm_bridge, then this is called after
-	 * that bridge is post-disabled (unless marked otherwise by the
-	 * @pre_enable_prev_first flag) via one of:
-	 *
-	 * - &drm_bridge_funcs.post_disable
-	 * - &drm_bridge_funcs.atomic_post_disable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called after the encoder is disabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_disable
-	 * - &drm_encoder_helper_funcs.prepare
-	 * - &drm_encoder_helper_funcs.disable
-	 * - &drm_encoder_helper_funcs.dpms
-	 *
-	 * and the CRTC is disabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.prepare
-	 * - &drm_crtc_helper_funcs.atomic_disable
-	 * - &drm_crtc_helper_funcs.disable
-	 * - &drm_crtc_helper_funcs.dpms
+	 * signals) feeding it is no longer running when this callback is
+	 * called.
 	 *
 	 * The @post_disable callback is optional.
 	 *
@@ -285,30 +252,18 @@ struct drm_bridge_funcs {
 	/**
 	 * @pre_enable:
 	 *
+	 * This callback should enable the bridge. It is called right before
+	 * the preceding element in the display pipe is enabled. If the
+	 * preceding element is a bridge this means it's called before that
+	 * bridge's @pre_enable function. If the preceding element is a
+	 * &drm_encoder it's called right before the encoder's
+	 * &drm_encoder_helper_funcs.enable, &drm_encoder_helper_funcs.commit or
+	 * &drm_encoder_helper_funcs.dpms hook.
+	 *
 	 * The display pipe (i.e. clocks and timing signals) feeding this bridge
-	 * will not yet be running when the @pre_enable is called.
-	 *
-	 * This callback should perform all the necessary actions to prepare the
-	 * bridge to accept signals from the preceding element.
-	 *
-	 * If the preceding element is a &drm_bridge, then this is called before
-	 * that bridge is pre-enabled (unless marked otherwise by
-	 * @pre_enable_prev_first flag) via one of:
-	 *
-	 * - &drm_bridge_funcs.pre_enable
-	 * - &drm_bridge_funcs.atomic_pre_enable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called before the CRTC is enabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.atomic_enable
-	 * - &drm_crtc_helper_funcs.commit
-	 *
-	 * and the encoder is enabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_enable
-	 * - &drm_encoder_helper_funcs.enable
-	 * - &drm_encoder_helper_funcs.commit
+	 * will not yet be running when this callback is called. The bridge must
+	 * not enable the display link feeding the next bridge in the chain (if
+	 * there is one) when this callback is called.
 	 *
 	 * The @pre_enable callback is optional.
 	 *
@@ -322,31 +277,19 @@ struct drm_bridge_funcs {
 	/**
 	 * @enable:
 	 *
-	 * The @enable callback should enable the bridge.
+	 * This callback should enable the bridge. It is called right after
+	 * the preceding element in the display pipe is enabled. If the
+	 * preceding element is a bridge this means it's called after that
+	 * bridge's @enable function. If the preceding element is a
+	 * &drm_encoder it's called right after the encoder's
+	 * &drm_encoder_helper_funcs.enable, &drm_encoder_helper_funcs.commit or
+	 * &drm_encoder_helper_funcs.dpms hook.
 	 *
 	 * The bridge can assume that the display pipe (i.e. clocks and timing
 	 * signals) feeding it is running when this callback is called. This
 	 * callback must enable the display link feeding the next bridge in the
 	 * chain if there is one.
 	 *
-	 * If the preceding element is a &drm_bridge, then this is called after
-	 * that bridge is enabled via one of:
-	 *
-	 * - &drm_bridge_funcs.enable
-	 * - &drm_bridge_funcs.atomic_enable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called after the CRTC is enabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.atomic_enable
-	 * - &drm_crtc_helper_funcs.commit
-	 *
-	 * and the encoder is enabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_enable
-	 * - &drm_encoder_helper_funcs.enable
-	 * - drm_encoder_helper_funcs.commit
-	 *
 	 * The @enable callback is optional.
 	 *
 	 * NOTE:
@@ -359,30 +302,17 @@ struct drm_bridge_funcs {
 	/**
 	 * @atomic_pre_enable:
 	 *
+	 * This callback should enable the bridge. It is called right before
+	 * the preceding element in the display pipe is enabled. If the
+	 * preceding element is a bridge this means it's called before that
+	 * bridge's @atomic_pre_enable or @pre_enable function. If the preceding
+	 * element is a &drm_encoder it's called right before the encoder's
+	 * &drm_encoder_helper_funcs.atomic_enable hook.
+	 *
 	 * The display pipe (i.e. clocks and timing signals) feeding this bridge
-	 * will not yet be running when the @atomic_pre_enable is called.
-	 *
-	 * This callback should perform all the necessary actions to prepare the
-	 * bridge to accept signals from the preceding element.
-	 *
-	 * If the preceding element is a &drm_bridge, then this is called before
-	 * that bridge is pre-enabled (unless marked otherwise by
-	 * @pre_enable_prev_first flag) via one of:
-	 *
-	 * - &drm_bridge_funcs.pre_enable
-	 * - &drm_bridge_funcs.atomic_pre_enable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called before the CRTC is enabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.atomic_enable
-	 * - &drm_crtc_helper_funcs.commit
-	 *
-	 * and the encoder is enabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_enable
-	 * - &drm_encoder_helper_funcs.enable
-	 * - &drm_encoder_helper_funcs.commit
+	 * will not yet be running when this callback is called. The bridge must
+	 * not enable the display link feeding the next bridge in the chain (if
+	 * there is one) when this callback is called.
 	 *
 	 * The @atomic_pre_enable callback is optional.
 	 */
@@ -392,31 +322,18 @@ struct drm_bridge_funcs {
 	/**
 	 * @atomic_enable:
 	 *
-	 * The @atomic_enable callback should enable the bridge.
+	 * This callback should enable the bridge. It is called right after
+	 * the preceding element in the display pipe is enabled. If the
+	 * preceding element is a bridge this means it's called after that
+	 * bridge's @atomic_enable or @enable function. If the preceding element
+	 * is a &drm_encoder it's called right after the encoder's
+	 * &drm_encoder_helper_funcs.atomic_enable hook.
 	 *
 	 * The bridge can assume that the display pipe (i.e. clocks and timing
 	 * signals) feeding it is running when this callback is called. This
 	 * callback must enable the display link feeding the next bridge in the
 	 * chain if there is one.
 	 *
-	 * If the preceding element is a &drm_bridge, then this is called after
-	 * that bridge is enabled via one of:
-	 *
-	 * - &drm_bridge_funcs.enable
-	 * - &drm_bridge_funcs.atomic_enable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called after the CRTC is enabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.atomic_enable
-	 * - &drm_crtc_helper_funcs.commit
-	 *
-	 * and the encoder is enabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_enable
-	 * - &drm_encoder_helper_funcs.enable
-	 * - drm_encoder_helper_funcs.commit
-	 *
 	 * The @atomic_enable callback is optional.
 	 */
 	void (*atomic_enable)(struct drm_bridge *bridge,
@@ -424,32 +341,16 @@ struct drm_bridge_funcs {
 	/**
 	 * @atomic_disable:
 	 *
-	 * The @atomic_disable callback should disable the bridge.
+	 * This callback should disable the bridge. It is called right before
+	 * the preceding element in the display pipe is disabled. If the
+	 * preceding element is a bridge this means it's called before that
+	 * bridge's @atomic_disable or @disable vfunc. If the preceding element
+	 * is a &drm_encoder it's called right before the
+	 * &drm_encoder_helper_funcs.atomic_disable hook.
 	 *
 	 * The bridge can assume that the display pipe (i.e. clocks and timing
 	 * signals) feeding it is still running when this callback is called.
 	 *
-	 * If the preceding element is a &drm_bridge, then this is called before
-	 * that bridge is disabled via one of:
-	 *
-	 * - &drm_bridge_funcs.disable
-	 * - &drm_bridge_funcs.atomic_disable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called before the encoder is disabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_disable
-	 * - &drm_encoder_helper_funcs.prepare
-	 * - &drm_encoder_helper_funcs.disable
-	 * - &drm_encoder_helper_funcs.dpms
-	 *
-	 * and the CRTC is disabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.prepare
-	 * - &drm_crtc_helper_funcs.atomic_disable
-	 * - &drm_crtc_helper_funcs.disable
-	 * - &drm_crtc_helper_funcs.dpms.
-	 *
 	 * The @atomic_disable callback is optional.
 	 */
 	void (*atomic_disable)(struct drm_bridge *bridge,
@@ -458,34 +359,16 @@ struct drm_bridge_funcs {
 	/**
 	 * @atomic_post_disable:
 	 *
+	 * This callback should disable the bridge. It is called right after the
+	 * preceding element in the display pipe is disabled. If the preceding
+	 * element is a bridge this means it's called after that bridge's
+	 * @atomic_post_disable or @post_disable function. If the preceding
+	 * element is a &drm_encoder it's called right after the encoder's
+	 * &drm_encoder_helper_funcs.atomic_disable hook.
+	 *
 	 * The bridge must assume that the display pipe (i.e. clocks and timing
-	 * signals) feeding this bridge is no longer running when the
-	 * @atomic_post_disable is called.
-	 *
-	 * This callback should perform all the actions required by the hardware
-	 * after it has stopped receiving signals from the preceding element.
-	 *
-	 * If the preceding element is a &drm_bridge, then this is called after
-	 * that bridge is post-disabled (unless marked otherwise by the
-	 * @pre_enable_prev_first flag) via one of:
-	 *
-	 * - &drm_bridge_funcs.post_disable
-	 * - &drm_bridge_funcs.atomic_post_disable
-	 *
-	 * If the preceding element of the bridge is a display controller, then
-	 * this callback is called after the encoder is disabled via one of:
-	 *
-	 * - &drm_encoder_helper_funcs.atomic_disable
-	 * - &drm_encoder_helper_funcs.prepare
-	 * - &drm_encoder_helper_funcs.disable
-	 * - &drm_encoder_helper_funcs.dpms
-	 *
-	 * and the CRTC is disabled via one of:
-	 *
-	 * - &drm_crtc_helper_funcs.prepare
-	 * - &drm_crtc_helper_funcs.atomic_disable
-	 * - &drm_crtc_helper_funcs.disable
-	 * - &drm_crtc_helper_funcs.dpms
+	 * signals) feeding it is no longer running when this callback is
+	 * called.
 	 *
 	 * The @atomic_post_disable callback is optional.
 	 */
-- 
2.52.0




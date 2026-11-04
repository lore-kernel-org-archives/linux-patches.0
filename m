Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830972;
	b=nHbYIpwtQgYqGyI0ySDfgB4q4MdVXq76YL7F9TPyzKIKRDqeGRSd+NDgJCpOMELC2bjB
	 EZ9trocef5BsNA8kXB7sG9bg8GHvs0kK2d9oK0dfMMGlKQdGuGQgTCKomaTYsPMruq/JO
	 ZHfCV017bMuuIe98Gvm0KECkchehQ6NOV+qpuufP1Ie65e3fK5RZprGhGayr/LcOdx/JX
	 BEs0mgvDQ80GZM9UTT5x67ssOhwLYVfOmfyXtJEznj3ylz1J0dL2juRXQXzPrM/F9hPXR
	 MUZFRTZAN8iBPVGYGl9NYZlFS/EV87BOX/6fTsKirbJmwPRtPt1wB3VHHT63+hIJTCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zA6EK7THIKfHGRYkp2AV+zzJGQTMm85Ys70uT6R2fMc=;
	b=fjwrxgKXLxtCYoDno0NPQzdrMfna+JDBS7jP0rwFVja/bAWd6QA+IxKaVQEVnzd3QzHE
	 fBkfaia9U55bLK0fEXJ+UHJKPy7+xN59zIO7UA2TnsWK0lUxPXmrdLiuGlV8Yhnmkbo+1
	 F70wBirTbvPjgZ7MY92Mz3qvRT3tpZBxGE4YpUeLnHWY/P9bSRT8QddOXr8oqCOl30+uS
	 Pw4h55vOAEHFBhow9fdLKoiQgIq5gtoP0DWGSDaWh4oHyCo7NdaPxjMqJfDmvRZEN0Hfj
	 vzzYat+nColiKl9dW8Xn3HCStCjINavgLvbLv7hoFHKyizB2CFH0cQ0vwVoySXx0ZCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXtK8atL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF87606AB1D;
	Wed,  4 Nov 2026 22:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXtK8atL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B31F000C1;
	Wed,  4 Nov 2026 22:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830971;
	bh=zA6EK7THIKfHGRYkp2AV+zzJGQTMm85Ys70uT6R2fMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXtK8atLHtEZeOnmp1T82di7JmIJ0ytoNY5R0efE5M5fOqmTQWDa1vxnwwXG2CdUu
	 7txWQrj1A3UsLIkMTgPePQd/5kgHZLScVjQteicScj2A8ZUOI1BCUJG8V6BANpVPgn
	 FycWST+r1mMgNBiE51VHMoG8tJR4HW9K/uXq9s1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Gilles Risch <gilles.risch@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0434/1005] drm/radeon: fix internal display on iMac11, 1 (RV770/DCE3.1)
Date: Wed,  4 Nov 2026 16:02:47 -0500
Message-ID: <20261104211056.246531449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilles Risch <gilles.risch@gmail.com>

[ Upstream commit 275c3332585bbabcefad109a6978cc0cbecf2008 ]

The Apple iMac11,1 (27-inch, Late 2009) uses a Mobility Radeon HD 4850
(RV770/DCE3.1) with a 2560x1440 internal panel on an internal
DisplayPort path. Without this fix the display stays dark under KMS.

This machine suffers from the same issue as iMac10,1 and iMac11,2:
Apple routes the internal display through Link B of the DIG encoder
instead of Link A. Add iMac11,1 to the existing DMI quirk and move
the Apple-specific encoder assignment into its own block, independent
of the DCE version check.

Additionally, the 2560x1440 panel requires RADEON_PLL_USE_FRAC_FB_DIV
and ATOM_ENCODER_CMD_DP_VIDEO_ON, limited to iMac11,1 via dmi_match()
to avoid affecting other boards.

Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Gilles Risch <gilles.risch@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/atombios_crtc.c     |  5 ++++-
 drivers/gpu/drm/radeon/atombios_encoders.c | 23 ++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 9b3a3a9d60e20..837700ab8079f 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -24,6 +24,8 @@
  *          Alex Deucher
  */
 
+#include <linux/dmi.h>
+
 #include <drm/drm_fixed.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
@@ -594,7 +596,8 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		if (((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
 		    && !radeon_crtc->ss_enabled)
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
-		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
+		if ((ASIC_IS_DCE32(rdev) || dmi_match(DMI_PRODUCT_NAME, "iMac11,1"))
+		    && mode->clock > 165000)
 			radeon_crtc->pll_flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		radeon_crtc->pll_flags |= RADEON_PLL_LEGACY;
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 3d9f47bc807af..ddfa31a7b83a5 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1707,7 +1707,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			/* DP_SET_POWER_D0 is set in radeon_dp_link_train */
 			radeon_dp_link_train(encoder, connector);
-			if (ASIC_IS_DCE4(rdev))
+			if (ASIC_IS_DCE4(rdev) || dmi_match(DMI_PRODUCT_NAME, "iMac11,1"))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_ON, 0);
 		}
 		if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
@@ -2123,17 +2123,20 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
 	}
 
 	/*
-	 * On DCE32 any encoder can drive any block so usually just use crtc id,
-	 * but Apple thinks different at least on iMac10,1 and iMac11,2, so there use linkb,
-	 * otherwise the internal eDP panel will stay dark.
+	 * Apple routes the internal eDP panel through Link B of the DIG encoder
+	 * instead of Link A on the iMac10,1, iMac11,1 and iMac11,2.
+	 * Use linkb to avoid a dark display.
 	 */
-	if (ASIC_IS_DCE32(rdev)) {
-		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
-		    dmi_match(DMI_PRODUCT_NAME, "iMac11,2"))
-			enc_idx = (dig->linkb) ? 1 : 0;
-		else
-			enc_idx = radeon_crtc->crtc_id;
+	if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
+	    dmi_match(DMI_PRODUCT_NAME, "iMac11,1") ||
+	    dmi_match(DMI_PRODUCT_NAME, "iMac11,2")) {
+		enc_idx = (dig->linkb) ? 1 : 0;
+		goto assigned;
+	}
 
+	/* on DCE32 and encoder can driver any block so just crtc id */
+	if (ASIC_IS_DCE32(rdev)) {
+		enc_idx = radeon_crtc->crtc_id;
 		goto assigned;
 	}
 
-- 
2.53.0




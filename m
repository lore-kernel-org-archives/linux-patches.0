Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034259;
	b=bn7Yw4Baq2OAL1XqFlS/x4pdoPNGq3XP9mfVjMGeN0I4d1b9uDVx9PJ1R7L74Bywp9Sj
	 2nFX3Db5SEaAtV+o4C3+Wy6+zgvf+/O5rDsm2GHIFp8C6+xyeSDw9kZS7UbchD4LcRPid
	 38Ew61ut+pJlkA7p4u/23GGwNPm7WroNTcj+BxN3euFT/d4ShgtFx0lLzbfILF19scNJl
	 xnVVUEMY7KRPEqcvOtwMaYqJ++Sk4epMK0GHzE/sNj2031N4yjIhsJgjZqC5NzXLzMbfM
	 rRYUjJwTLu2LHItxA6LM6LkUOEk4/xugqfDc8MxSkXU2v5BRmtE3a/XzKqgXGbuJPDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9sPK2f17BKX3H+AlrCHn7uO3YrSRGzV/69GgxqxyIY=;
	b=CJ7uJxEN2PpE01ZiXSVwrUg0/RdtjNStlt8e229UNgz/nTWolummoO3uUK604FVp8OMU
	 3IBgdVr/+10ACws4AHg5ViPtDpEQ6qAukbT8xUvhL5ITyIxyoaRgsliPl4VlPNi+cw9Cs
	 ovqRqGzjw+EeErbrQhY0ByBLu5aiHfyx4nj0h/tseIxLJLtSe8EhKza9SdaOjUeLl6wzB
	 M2IP+8EYaBpfXKxhJSbTsKQLK3winyN96bGQGbgIpDQoPkUoUEJqB2bG7klwzTzqaFKZc
	 9M+PbPhGurY8jF8F3NHG0LONZqsG6njZFfTTJfj+fSbUXlcUsFBAMjWEZSf5bkPQ/CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2ts+tQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC82606A33A;
	Wed, 18 Nov 2026 20:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2ts+tQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D39B1F000C5;
	Wed, 18 Nov 2026 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034258;
	bh=u9sPK2f17BKX3H+AlrCHn7uO3YrSRGzV/69GgxqxyIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2ts+tQm39K5AV3O1/gFFdKtgydACv4ddrV8c4Od+H5WxhPdPeoFt+vF0YSuPuNJg
	 QxaQXX/sjAY5NSb8qom47yw1zHvK+ysr8Un6alaQ9XbTP5pSFYlJ+i7J3eMPQo7ME4
	 vaawQxRUPxZWQ9iDeULRq7A0QQ3Ou1AEU/Qo5aqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Gilles Risch <gilles.risch@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0306/3318] drm/radeon: fix internal display on iMac11, 1 (RV770/DCE3.1)
Date: Wed, 18 Nov 2026 15:15:28 +0100
Message-ID: <20261118150324.951933189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ade13173921b8..685a274d3eaed 100644
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
index 7ea76fdd714a9..3164a440ba476 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1706,7 +1706,7 @@ radeon_atom_encoder_dpms_dig(struct drm_encoder *encoder, int mode)
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			/* DP_SET_POWER_D0 is set in radeon_dp_link_train */
 			radeon_dp_link_train(encoder, connector);
-			if (ASIC_IS_DCE4(rdev))
+			if (ASIC_IS_DCE4(rdev) || dmi_match(DMI_PRODUCT_NAME, "iMac11,1"))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_ON, 0);
 		}
 		if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
@@ -2122,17 +2122,20 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
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




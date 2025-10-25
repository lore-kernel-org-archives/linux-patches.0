Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B03308F27;
	Sat, 25 Oct 2025 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409314; cv=none; b=JZ2RenxXALbmLzoJJ7yyirvnpjMYlGv316G0fOB78Upr2ubQiS2+uKj8r6dWBZp+O5RvteRonj9scEM5P4KeMPXoVb+isDRIB7pq3K8M2jrIQR46VZNisenyk9YeC+COdLNqV5EQpS/k8h6Ae0+gE//PGblEptFZyvV9LGzrO8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409314; c=relaxed/simple;
	bh=NE+chiJ+DrSu7bpV+Hsj3R4BnVPtwZey5lZIHT8tdSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7rK2Mve1YKGPpdphqDhqqkI6IF8N1+l+OPHKiJN7quzaa6yUzxhg1KOi3p7V+qH+TjA6lbudilJT4hZVVa5rKtipLxDcckAmwFJPn3t4V8MY3UqcBpvc5jFq0gq1ehDLwgaZ0OWUZDcQ2urlL4WihkIYsp/U8dKS77mNO/UZd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipu0yPq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipu0yPq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA736C2BC9E;
	Sat, 25 Oct 2025 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409314;
	bh=NE+chiJ+DrSu7bpV+Hsj3R4BnVPtwZey5lZIHT8tdSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipu0yPq3T8UdjHHYdFXqSKjcywvIWlUtEg634jEIalpz6TKHOsdSvXMBoCbzX9sbD
	 CLcGS3X3OK7d/IiILNxYVxbpOzgt4rEERq16BVwmECOTBUTyRKoLQBqk3Qk+O88sSl
	 Vl2nCDCMSUVZOZT2gmwJDpWOZWy0m5J2mYS0d6L9pXI/sRLnjSsO2+sWOTCLdQqFJ7
	 5qrHg1l3nc92tEwrOG7Urg83zRkmBbYeOYbxFWPQUQu/lgzk0ObN54AJxLvN50pcNm
	 bBA6N15ZnUrVc0EXbMDMqeRqRW5S9ELymIlltFyGsMFo5rwUIqF2FGD79+dAeYNkDb
	 qZEyEUSHHgB8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	olivier.moysan@foss.st.com,
	andy.yan@rock-chips.com,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	stefan.ekenberg@axis.com,
	dianders@chromium.org,
	biju.das.jz@bp.renesas.com,
	luca.ceresoli@bootlin.com,
	tommaso.merciai.xr@bp.renesas.com
Subject: [PATCH AUTOSEL 6.17] drm/bridge: write full Audio InfoFrame
Date: Sat, 25 Oct 2025 11:58:27 -0400
Message-ID: <20251025160905.3857885-276-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit f0e7f358e72b10b01361787134ebcbd9e9aa72d9 ]

Instead of writing the first byte of the infoframe (and hoping that the
rest is default / zeroes), hook Audio InfoFrame support into the
write_infoframe / clear_infoframes callbacks and use
drm_atomic_helper_connector_hdmi_update_audio_infoframe() to write the
frame.

Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20250903-adv7511-audio-infoframe-v1-2-05b24459b9a4@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes real user-visible bug: Previously, the driver only poked a
  single byte in the Audio InfoFrame and relied on default/zero values
  for the rest, which can lead to incorrect or incomplete Audio
  InfoFrame content (e.g., channel count/allocation, coding type, sample
  size/rate). This can break or degrade HDMI audio on some sinks. The
  change switches to generating and writing the full, correct Audio
  InfoFrame.

What changed and why it’s correct
- Uses the generic helper to generate and program the full Audio
  InfoFrame:
  - `adv7511_hdmi_audio_prepare()` now calls
    `drm_atomic_helper_connector_hdmi_update_audio_infoframe(connector,
    &hparms->cea)` to write a complete frame built from ALSA parameters,
    instead of writing a single payload byte (old hack) in the device
    registers. See `drivers/gpu/drm/bridge/adv7511/adv7511_audio.c:160`.
  - Required header is included:
    `drivers/gpu/drm/bridge/adv7511/adv7511_audio.c:15`.
  - The helper’s implementation exists and writes through the
    connector’s infoframe pipeline, with locking and proper callback
    routing: `drivers/gpu/drm/display/drm_hdmi_state_helper.c:1062`
    (update) and `drivers/gpu/drm/display/drm_hdmi_state_helper.c:1098`
    (clear).
- Implements proper program/enable path for the Audio InfoFrame in the
  bridge callbacks:
  - `.hdmi_write_infoframe` handles `HDMI_INFOFRAME_TYPE_AUDIO` by
    gating updates (bit 5), bulk-writing the header
    (version/length/checksum) and payload (skipping the non-configurable
    type byte), then enabling the packet. See:
    - Gate updates:
      `drivers/gpu/drm/bridge/adv7511/adv7511_drv.c:925-926`
    - Bulk write full frame (skip type):
      `drivers/gpu/drm/bridge/adv7511/adv7511_drv.c:929-930`
    - Ungate + enable:
      `drivers/gpu/drm/bridge/adv7511/adv7511_drv.c:933-936`
  - `.hdmi_clear_infoframe` now supports Audio and disables the
    corresponding packet:
    `drivers/gpu/drm/bridge/adv7511/adv7511_drv.c:896-898`.
- Cleans up on shutdown:
  - Calls the helper to stop sending the Audio InfoFrame:
    `drivers/gpu/drm/bridge/adv7511/adv7511_audio.c:205`.
- Startup keeps audio packet/N/CTS setup unchanged and avoids enabling
  Audio InfoFrame before valid contents are written:
  - N/CTS and sample packets enabling retained:
    `drivers/gpu/drm/bridge/adv7511/adv7511_audio.c:175-180`.
  - Audio InfoFrame enabling is now tied to having a fully written frame
    (safer ordering).

Scope, risk, and compatibility
- Small, contained change limited to the ADV7511 HDMI bridge driver and
  the standard DRM HDMI infoframe path:
  - Files touched: `drivers/gpu/drm/bridge/adv7511/adv7511_audio.c`,
    `drivers/gpu/drm/bridge/adv7511/adv7511_drv.c`.
  - No architectural changes; uses existing DRM HDMI state helper APIs
    that are already in-tree (see
    `drivers/gpu/drm/display/drm_hdmi_state_helper.c:1062`,
    `drivers/gpu/drm/display/drm_hdmi_state_helper.c:1098`).
- Behavior improves correctness without broad side effects:
  - Moves from writing a single payload byte to programming the full
    spec-compliant Audio InfoFrame.
  - Ensures the Audio InfoFrame is only enabled after valid data is
    written.
  - Adds proper teardown to stop sending the Audio InfoFrame on
    shutdown.
- Pattern aligns with other bridge drivers that already use the same
  helper, reducing risk:
  - Examples of usage in other drivers: `drivers/gpu/drm/bridge/lontium-
    lt9611.c:974`, `drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c:476`.

Stable backport criteria
- Fixes a real bug affecting users (incorrect Audio InfoFrame content
  leading to HDMI audio issues).
- Change is small, localized, and uses existing subsystem helpers.
- No new features or architectural refactors.
- Low regression risk; order of operations is safer (write then enable).
- Touches a non-core subsystem (DRM bridge) and is standard-compliant.

Notes
- This backport assumes the target stable series has the HDMI infoframe
  helper APIs and the bridge
  `.hdmi_write_infoframe`/`.hdmi_clear_infoframe` integration; for
  series lacking these, additional prerequisite backports would be
  required.

 .../gpu/drm/bridge/adv7511/adv7511_audio.c    | 23 +++++--------------
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c  | 18 +++++++++++++++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index 766b1c96bc887..87e7e820810a8 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -12,6 +12,8 @@
 #include <sound/soc.h>
 #include <linux/of_graph.h>
 
+#include <drm/display/drm_hdmi_state_helper.h>
+
 #include "adv7511.h"
 
 static void adv7511_calc_cts_n(unsigned int f_tmds, unsigned int fs,
@@ -155,17 +157,8 @@ int adv7511_hdmi_audio_prepare(struct drm_bridge *bridge,
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_I2C_FREQ_ID_CFG,
 			   ADV7511_I2C_FREQ_ID_CFG_RATE_MASK, rate << 4);
 
-	/* send current Audio infoframe values while updating */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-			   BIT(5), BIT(5));
-
-	regmap_write(adv7511->regmap, ADV7511_REG_AUDIO_INFOFRAME(0), 0x1);
-
-	/* use Audio infoframe updated info */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-			   BIT(5), 0);
-
-	return 0;
+	return drm_atomic_helper_connector_hdmi_update_audio_infoframe(connector,
+								       &hparms->cea);
 }
 
 int adv7511_hdmi_audio_startup(struct drm_bridge *bridge,
@@ -188,15 +181,9 @@ int adv7511_hdmi_audio_startup(struct drm_bridge *bridge,
 	/* not copyrighted */
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CFG1,
 				BIT(5), BIT(5));
-	/* enable audio infoframes */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE1,
-				BIT(3), BIT(3));
 	/* AV mute disable */
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_GC(0),
 				BIT(7) | BIT(6), BIT(7));
-	/* use Audio infoframe updated info */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
-				BIT(5), 0);
 
 	/* enable SPDIF receiver */
 	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
@@ -214,4 +201,6 @@ void adv7511_hdmi_audio_shutdown(struct drm_bridge *bridge,
 	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
 		regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CONFIG,
 				   BIT(7), 0);
+
+	drm_atomic_helper_connector_hdmi_clear_audio_infoframe(connector);
 }
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 00d6417c177b4..9081c09fc136b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -886,6 +886,9 @@ static int adv7511_bridge_hdmi_clear_infoframe(struct drm_bridge *bridge,
 	struct adv7511 *adv7511 = bridge_to_adv7511(bridge);
 
 	switch (type) {
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		adv7511_packet_disable(adv7511, ADV7511_PACKET_ENABLE_AUDIO_INFOFRAME);
+		break;
 	case HDMI_INFOFRAME_TYPE_AVI:
 		adv7511_packet_disable(adv7511, ADV7511_PACKET_ENABLE_AVI_INFOFRAME);
 		break;
@@ -906,6 +909,21 @@ static int adv7511_bridge_hdmi_write_infoframe(struct drm_bridge *bridge,
 	adv7511_bridge_hdmi_clear_infoframe(bridge, type);
 
 	switch (type) {
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		/* send current Audio infoframe values while updating */
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+				   BIT(5), BIT(5));
+
+		/* The Audio infoframe id is not configurable */
+		regmap_bulk_write(adv7511->regmap, ADV7511_REG_AUDIO_INFOFRAME_VERSION,
+				  buffer + 1, len - 1);
+
+		/* use Audio infoframe updated info */
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_INFOFRAME_UPDATE,
+				   BIT(5), 0);
+
+		adv7511_packet_enable(adv7511, ADV7511_PACKET_ENABLE_AUDIO_INFOFRAME);
+		break;
 	case HDMI_INFOFRAME_TYPE_AVI:
 		/* The AVI infoframe id is not configurable */
 		regmap_bulk_write(adv7511->regmap, ADV7511_REG_AVI_INFOFRAME_VERSION,
-- 
2.51.0


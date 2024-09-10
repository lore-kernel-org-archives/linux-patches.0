Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008718EFE4;
	Tue, 10 Sep 2024 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962349; cv=none; b=dW837g1Y+OtCQm695zZDJyfwImLmEV+YsdbG6p7QwE5nvz48kku1xyMZ67mi3+DWqteKgzRQRYP24B87uAfXixYp4pXB5yNGnGlEzBlAWcYL/RFaVCjMUAbORfWw6XmD7UOMKP7tKFv6qYsCOrxDJBIkfmOEbE304jqnx3JtQFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962349; c=relaxed/simple;
	bh=6gJ/SkqNdxOoK3tFmBLNOHDmQEXsyzWbBSPZGUIExB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tl06HfYa2zIs92wqxMY1sZzVTi8k76+l5QdBw81iizBSlkbFiaQP8+AWCnMMuPgnVT5/qsZkPX/sqXwTWSq8OKFCn+VKOo1Mvp879FYR0C4jg/LYJaTI7mqBUHtP00MRTts6DaUQT+U8Il3s5h0kMqTjjJP423rp5nABX1nk8RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj2A4hQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj2A4hQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0EEC4CED0;
	Tue, 10 Sep 2024 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962348;
	bh=6gJ/SkqNdxOoK3tFmBLNOHDmQEXsyzWbBSPZGUIExB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj2A4hQn3g0CjTL42pzulq8+ZEaObwGeS61j+I2Ty1bb+YBk81ByuXbHrqD9uJdI7
	 aD/+JmGbVEoG3E4VWnirYK+9tEIr4+WwJpDD+QZVv9p7IWlbl854+zCdACDP1yoUuk
	 mK+bActmDQ1PzwkgN2EJ77cxYURBgRkS5l2ESccM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 372/375] drm/i915/display: Increase Fast Wake Sync length as a quirk
Date: Tue, 10 Sep 2024 11:32:49 +0200
Message-ID: <20240910092635.120931368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit a13494de53258d8cf82ed3bcd69176bbf7f2640e upstream.

In commit "drm/i915/display: Increase number of fast wake precharge pulses"
we were increasing Fast Wake sync pulse length to fix problems observed on
Dell Precision 5490 laptop with AUO panel. Later we have observed this is
causing problems on other panels.

Fix these problems by increasing Fast Wake sync pulse length as a quirk
applied for Dell Precision 5490 with problematic panel.

Fixes: f77772866385 ("drm/i915/display: Increase number of fast wake precharge pulses")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: http://gitlab.freedesktop.org/drm/i915/kernel/-/issues/9739
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2246
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11762
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Link: https://patchwork.freedesktop.org/patch/msgid/20240902064241.1020965-3-jouni.hogander@intel.com
(cherry picked from commit fcba2ed66b39252210f4e739722ebcc5398c2197)
Requires: 43cf50eb1408 ("drm/i915/display: Add mechanism to use sink model when applying quirk")
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c |   16 +++++++++++-----
 drivers/gpu/drm/i915/display/intel_dp_aux.h |    2 +-
 drivers/gpu/drm/i915/display/intel_psr.c    |    2 +-
 drivers/gpu/drm/i915/display/intel_quirks.c |   19 ++++++++++++++++++-
 drivers/gpu/drm/i915/display/intel_quirks.h |    1 +
 5 files changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -13,6 +13,7 @@
 #include "intel_dp_aux.h"
 #include "intel_dp_aux_regs.h"
 #include "intel_pps.h"
+#include "intel_quirks.h"
 #include "intel_tc.h"
 
 #define AUX_CH_NAME_BUFSIZE	6
@@ -142,16 +143,21 @@ static int intel_dp_aux_sync_len(void)
 	return precharge + preamble;
 }
 
-int intel_dp_aux_fw_sync_len(void)
+int intel_dp_aux_fw_sync_len(struct intel_dp *intel_dp)
 {
+	int precharge = 10; /* 10-16 */
+	int preamble = 8;
+
 	/*
 	 * We faced some glitches on Dell Precision 5490 MTL laptop with panel:
 	 * "Manufacturer: AUO, Model: 63898" when using HW default 18. Using 20
 	 * is fixing these problems with the panel. It is still within range
-	 * mentioned in eDP specification.
+	 * mentioned in eDP specification. Increasing Fast Wake sync length is
+	 * causing problems with other panels: increase length as a quirk for
+	 * this specific laptop.
 	 */
-	int precharge = 12; /* 10-16 */
-	int preamble = 8;
+	if (intel_has_dpcd_quirk(intel_dp, QUIRK_FW_SYNC_LEN))
+		precharge += 2;
 
 	return precharge + preamble;
 }
@@ -211,7 +217,7 @@ static u32 skl_get_aux_send_ctl(struct i
 		DP_AUX_CH_CTL_TIME_OUT_MAX |
 		DP_AUX_CH_CTL_RECEIVE_ERROR |
 		DP_AUX_CH_CTL_MESSAGE_SIZE(send_bytes) |
-		DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(intel_dp_aux_fw_sync_len()) |
+		DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(intel_dp_aux_fw_sync_len(intel_dp)) |
 		DP_AUX_CH_CTL_SYNC_PULSE_SKL(intel_dp_aux_sync_len());
 
 	if (intel_tc_port_in_tbt_alt_mode(dig_port))
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.h
@@ -20,6 +20,6 @@ enum aux_ch intel_dp_aux_ch(struct intel
 
 void intel_dp_aux_irq_handler(struct drm_i915_private *i915);
 u32 intel_dp_aux_pack(const u8 *src, int src_bytes);
-int intel_dp_aux_fw_sync_len(void);
+int intel_dp_aux_fw_sync_len(struct intel_dp *intel_dp);
 
 #endif /* __INTEL_DP_AUX_H__ */
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1356,7 +1356,7 @@ static bool _compute_alpm_params(struct
 	int tfw_exit_latency = 20; /* eDP spec */
 	int phy_wake = 4;	   /* eDP spec */
 	int preamble = 8;	   /* eDP spec */
-	int precharge = intel_dp_aux_fw_sync_len() - preamble;
+	int precharge = intel_dp_aux_fw_sync_len(intel_dp) - preamble;
 	u8 max_wake_lines;
 
 	io_wake_time = max(precharge, io_buffer_wake_time(crtc_state)) +
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -70,6 +70,14 @@ static void quirk_no_pps_backlight_power
 	drm_info(display->drm, "Applying no pps backlight power quirk\n");
 }
 
+static void quirk_fw_sync_len(struct intel_dp *intel_dp)
+{
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	intel_set_dpcd_quirk(intel_dp, QUIRK_FW_SYNC_LEN);
+	drm_info(display->drm, "Applying Fast Wake sync pulse count quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -224,6 +232,15 @@ static struct intel_quirk intel_quirks[]
 };
 
 static struct intel_dpcd_quirk intel_dpcd_quirks[] = {
+	/* Dell Precision 5490 */
+	{
+		.device = 0x7d55,
+		.subsystem_vendor = 0x1028,
+		.subsystem_device = 0x0cc7,
+		.sink_oui = SINK_OUI(0x38, 0xec, 0x11),
+		.hook = quirk_fw_sync_len,
+	},
+
 };
 
 void intel_init_quirks(struct intel_display *display)
@@ -265,7 +282,7 @@ void intel_init_dpcd_quirks(struct intel
 		    !memcmp(q->sink_oui, ident->oui, sizeof(ident->oui)) &&
 		    (!memcmp(q->sink_device_id, ident->device_id,
 			    sizeof(ident->device_id)) ||
-		     mem_is_zero(q->sink_device_id, sizeof(q->sink_device_id))))
+		     !memchr_inv(q->sink_device_id, 0, sizeof(q->sink_device_id))))
 			q->hook(intel_dp);
 	}
 }
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -19,6 +19,7 @@ enum intel_quirk_id {
 	QUIRK_INVERT_BRIGHTNESS,
 	QUIRK_LVDS_SSC_DISABLE,
 	QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK,
+	QUIRK_FW_SYNC_LEN,
 };
 
 void intel_init_quirks(struct intel_display *display);



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585469;
	b=g6SXH5Ws+EQypD0hF6K8WkZaxCqksAZjN9hF4b0Nr2+Y3n7xMj9W1+e7bC5EBRqM4y3F
	 zwheRM7fKTffXMbFqrvLN9s5Xg4Dc8khJpWfKrNmnx+vbKRoTV6sjT0D79mabjB2NG/Wn
	 vALvVBdW+VWrWss2a4KcxZ25TYG8zfQhb/XLhXm7wk6oW31aQFdgN5tpAB3yLwpKbg9X/
	 8zrdeVhhKwTwW1VCwyBLr4QitHiGzKddYQHSv+J9IyOCEiT+9N5tRe1hqXtxlNWI7Ydt0
	 wX+9RqnSxIjqC1+nXDSmzidvwWr9sfeo/tvYoO+EAYLrmoWAgGoPm8MZnz/VQvYVZ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpftPf6IvqGT5TBRLar4qF/Jjl90/jlFIOkdLRlC57M=;
	b=GXOUG90JptjMjq+ykT39Pf2qB3NYIV2PUalJ5dSg3PImHj9hi1uvfeJsnGPaZcuubH5W
	 85z3TfsnTCndrRTXN/QGaVodtUaEM4WQh7gbTzg0u6HXrBYYnBTwGFkD6JiPuKv77pPvV
	 J0xzesaZAmEwbxPCNPmcwJ8eGqePCwPF+4NyEpkGd0mkQA8ZFeSgT08vMzK562BbgFr2w
	 N4dui7c3lhJDmngFzHaGhWapfAAgXi7xvc1bpC+JZfEX+G9QCmYPfZQOrCLDrlBs7GsBK
	 rzmHLPqeerxXTM4bxMR9z1p26pjDj6YhyIXvwpDfhXvhLwm1A0LUvbhcnASFriRWVZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJFXjJDR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF22606EB88;
	Fri, 13 Nov 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJFXjJDR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275A71F000C6;
	Fri, 13 Nov 2026 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585469;
	bh=SpftPf6IvqGT5TBRLar4qF/Jjl90/jlFIOkdLRlC57M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJFXjJDRFLCEq5eNmOO5rMTZ3/azZrAkdUeFnES1QNbYJAtfLR6rIbeihSdSSc7Z5
	 x/FWhKe7Of8F7Z3mo2hkiLBklrIAMFE+TyoDcTYTZTLIMTw6uLrMbZ0+O2SK+H742N
	 1TsufEgdOg6mPaEn/bzlZv5px+zB4m54CRn9EGN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 124/507] drm/i915/display: Add quirk to force backlight type on some TUXEDO devices
Date: Fri, 13 Nov 2026 10:47:08 -0500
Message-ID: <20261113153758.630283304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 88d804cd1be9a8ffcaf67f1a414ee92b5166a0a8 ]

The display backlight on TUXEDO DX1708 and InsanityBook 15 v1 have a broken
VBT in the AUO 12701 and AUO 12701 panels, but not others. They are
advertising INTEL_BACKLIGHT_DISPLAY_DDI, but are actually failing to use
the Intel interface. Adding a fallback to the VESA interface gives
these devices a working backlight for both the broken and non broken
panel VBTs.

Forcing the fallback can already be achieved via a module parameter,
but this patch adds a quirk to apply this by default on the mentioned
devices.

This commit does not actually test for the exact panels as the ID that is
used in the intel_dpcd_quirks list is sadly zeroed on the devices, but
afaik all these devices use try_intel_interface first anyway so all the
quirk does is to add the fallback to try_vesa_interface, so the behaviour
on the devices not needing the quirk and fallback should functionally stay
the same.

Fixes: 2914709c9141 ("Revert "drm/i915/backlight: Remove try_vesa_interface"")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/15679
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260807200709.464343-2-wse@tuxedocomputers.com
(cherry picked from commit 9499c3fca1c70ccfaddc9815b4c5afdfddedbd04)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_dp_aux_backlight.c | 22 ++++++++++++++++-
 drivers/gpu/drm/i915/display/intel_quirks.c   | 24 +++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_quirks.h   |  1 +
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index 266e042e00237..d84def79c4bfb 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -41,6 +41,7 @@
 #include "intel_display_types.h"
 #include "intel_dp.h"
 #include "intel_dp_aux_backlight.h"
+#include "intel_quirks.h"
 
 /*
  * DP AUX registers for Intel's proprietary HDR backlight interface. We define
@@ -687,11 +688,30 @@ int intel_dp_aux_init_backlight_funcs(struct intel_connector *connector)
 	struct drm_device *dev = connector->base.dev;
 	struct intel_panel *panel = &connector->panel;
 	bool try_intel_interface = false, try_vesa_interface = false;
+	int enable_dpcd_backlight;
+
+	/*
+	 * Some devices have a broken VBT in some Panels, but not others,
+	 * advertising INTEL_BACKLIGHT_DISPLAY_DDI, but actually failing to use
+	 * the Intel interface. Adding a fallback to the Vesa interface gives
+	 * these devices a working backlight for both the broken and non broken
+	 * panel VBTs.
+	 *
+	 * This fallback can not be made the general default as this has broken
+	 * other devices in the past whose VBT correctly reports
+	 * INTEL_BACKLIGHT_DISPLAY_DDI and whose PWM path is the actual
+	 * backlight control, but whose DPCD optimistically advertises
+	 * DP_EDP_BACKLIGHT_AUX_ENABLE_CAP / _BRIGHTNESS_AUX_SET_CAP.
+	 */
+	enable_dpcd_backlight = display->params.enable_dpcd_backlight;
+	if (enable_dpcd_backlight == INTEL_DP_AUX_BACKLIGHT_AUTO &&
+	    intel_has_dpcd_quirk(intel_dp, QUIRK_ENABLE_DPCD_BACKLIGHT))
+		enable_dpcd_backlight = INTEL_DP_AUX_BACKLIGHT_ON;
 
 	/* Check the VBT and user's module parameters to figure out which
 	 * interfaces to probe
 	 */
-	switch (display->params.enable_dpcd_backlight) {
+	switch (enable_dpcd_backlight) {
 	case INTEL_DP_AUX_BACKLIGHT_OFF:
 		return -ENODEV;
 	case INTEL_DP_AUX_BACKLIGHT_AUTO:
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index 7d7db774d8c7b..96eb9a40df9b9 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -100,6 +100,14 @@ static void quirk_disable_psr2(struct intel_display *display)
 	drm_info(display->drm, "PSR2 support not currently available for this setup, applying disable PSR2 quirk\n");
 }
 
+static void quirk_enable_dpcd_backlight(struct intel_dp *intel_dp)
+{
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	intel_set_dpcd_quirk(intel_dp, QUIRK_ENABLE_DPCD_BACKLIGHT);
+	drm_info(display->drm, "Applying Enable DPCD Backlight quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -289,6 +297,22 @@ static const struct intel_dpcd_quirk intel_dpcd_quirks[] = {
 		.sink_oui = SINK_OUI(0x00, 0x22, 0xb9),
 		.hook = quirk_disable_edp_panel_replay,
 	},
+	/* TUXEDO InsanityBook 15 v1 */
+	{
+		.device = 0x591b,
+		.subsystem_vendor = 0x1558,
+		.subsystem_device = 0x9501,
+		.sink_oui = SINK_OUI(0x38, 0xec, 0x11),
+		.hook = quirk_enable_dpcd_backlight,
+	},
+	/* TUXEDO DX1708 */
+	{
+		.device = 0x3e9b,
+		.subsystem_vendor = 0x1558,
+		.subsystem_device = 0x8500,
+		.sink_oui = SINK_OUI(0x38, 0xec, 0x11),
+		.hook = quirk_enable_dpcd_backlight,
+	},
 };
 
 void intel_init_quirks(struct intel_display *display)
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.h b/drivers/gpu/drm/i915/display/intel_quirks.h
index 970a4fe52fafc..4996419ae76bd 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -23,6 +23,7 @@ enum intel_quirk_id {
 	QUIRK_EDP_LIMIT_RATE_HBR2,
 	QUIRK_DISABLE_EDP_PANEL_REPLAY,
 	QUIRK_DISABLE_PSR2,
+	QUIRK_ENABLE_DPCD_BACKLIGHT,
 };
 
 void intel_init_quirks(struct intel_display *display);
-- 
2.53.0




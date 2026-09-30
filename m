Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1756651CF4D;
	Wed, 30 Sep 2026 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793726; cv=none; b=XRNUn9ouVjyYKcaJDWPAVkggcyqfM6ddeYaGqgZn/i5foXTJSVPlobz2MY6v4i6B1CH18QWST48qBAr49QaLyptBl+jhtMtwWcDt4cbSMScpnyE0YEsdawiVwnrBM3WVKtH1YnB57tQ7G1pinKPEqeinIx5WmguLONKp+uaUxIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793726; c=relaxed/simple;
	bh=oM7KpCkdNhYu84aX7n+QoMmjM+PEVeS4JKtsOA6inaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+Dmxw/fmDA2Mta7yNnndhCa8UJYh/6FfQzNajGkjim0wS93xLbkyGVc5zrKUSn0E5LFVOsKi+dbzfKhSmO4dag5xCkzxLLGds82mAV7FAvqh1/KeqHlVA04f196zxnkda3h5NMZXBQDzm7q3i2eHKLvhMKI/+qJb+bp57aZmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnnIR2P9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnnIR2P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345671F000FF;
	Wed, 30 Sep 2026 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793724;
	bh=T8rZ/Wf+E/TLrSE5zYLlZX7vuh0mDmHtlUPN4Q2ta54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnnIR2P9iEd8jrqigHlFqAjZQRCmwjoQuhTRAKwVU1KXasq2FCgyIfuqJU4HG2VQj
	 xf+EfSBm+gUDmPZtrKddevpXPWHL+MzeQYZcoGkjRdMj76BbuobSL1lJmLBikDTFK6
	 0t4pi6hxnOYF9oGJLphlRYUMTiZe9F1GJtigyT1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/395] drm/i915/psr: Disable Panel Replay on Dell XPS 14 DA14260 as a quirk
Date: Wed, 30 Sep 2026 17:30:16 +0200
Message-ID: <20260930152348.364026588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 45c77d4bf8d4d15453d709b9b828e498898e0751 ]

Add new quirk (QUIRK_DISABLE_PANEL_REPLAY) for disabling Panel Replay as
quirk for problematic setups. Apply this newly added quirk on Dell XPS 14
DA14260 if specific panel model is installed.

We are observing problems with Dell XPS 14 DA14260. This device has certain
LGD panel model which seems to be problematic. We have seen other LGD panel
model with same OUI is working fine. Due to this we can't apply the quirk
only based on panel OUI. There are also cases where same device model has
differing panel model. We don't want to disable Panel Replay on such
devices. Best we can do is to apply the quirk based on both device model
and panel model.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/7521
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260317062402.1888624-1-jouni.hogander@intel.com
Stable-dep-of: 5271d81f99dd ("drm/i915/quirks: Limit eDP rate to HBR2 on HP Pavilion Plus 14-ew1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c    |    7 +++++++
 drivers/gpu/drm/i915/display/intel_quirks.c |   17 ++++++++++++++++-
 drivers/gpu/drm/i915/display/intel_quirks.h |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -49,6 +49,7 @@
 #include "intel_hdmi.h"
 #include "intel_psr.h"
 #include "intel_psr_regs.h"
+#include "intel_quirks.h"
 #include "intel_snps_phy.h"
 #include "intel_step.h"
 #include "intel_vblank.h"
@@ -592,6 +593,12 @@ static void _panel_replay_init_dpcd(stru
 	if (intel_dp->mst_detect == DRM_DP_MST)
 		return;
 
+	if (intel_has_dpcd_quirk(intel_dp, QUIRK_DISABLE_PANEL_REPLAY)) {
+		drm_dbg_kms(display->drm,
+			    "Panel Replay support not currently available for this setup\n");
+		return;
+	}
+
 	ret = drm_dp_dpcd_read_data(&intel_dp->aux, DP_PANEL_REPLAY_CAP_SUPPORT,
 				    &intel_dp->pr_dpcd, sizeof(intel_dp->pr_dpcd));
 	if (ret < 0)
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -86,6 +86,14 @@ static void quirk_edp_limit_rate_hbr2(st
 	drm_info(display->drm, "Applying eDP Limit rate to HBR2 quirk\n");
 }
 
+static void quirk_disable_panel_replay(struct intel_dp *intel_dp)
+{
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	intel_set_dpcd_quirk(intel_dp, QUIRK_DISABLE_PANEL_REPLAY);
+	drm_info(display->drm, "Applying disable Panel Replay quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -251,7 +259,14 @@ static const struct intel_dpcd_quirk int
 		.sink_oui = SINK_OUI(0x38, 0xec, 0x11),
 		.hook = quirk_fw_sync_len,
 	},
-
+	/* Dell XPS 14 DA14260 */
+	{
+		.device = 0xb080,
+		.subsystem_vendor = 0x1028,
+		.subsystem_device = 0x0db9,
+		.sink_oui = SINK_OUI(0x00, 0x22, 0xb9),
+		.hook = quirk_disable_panel_replay,
+	},
 };
 
 void intel_init_quirks(struct intel_display *display)
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -21,6 +21,7 @@ enum intel_quirk_id {
 	QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK,
 	QUIRK_FW_SYNC_LEN,
 	QUIRK_EDP_LIMIT_RATE_HBR2,
+	QUIRK_DISABLE_PANEL_REPLAY,
 };
 
 void intel_init_quirks(struct intel_display *display);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92A04F405E;
	Wed, 30 Sep 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793729; cv=none; b=eV9/X80r5twt9/M5Wt6HLVDRpXGkKCPSsIoNQ7Q1bwkgR4+AW6xJ/TX6dCGetUWQB8S1GGTYIfH+su9oVGr4gHxhOoa/k1ZrkP3cvngIdIKA4BI03jTdyNIFW8HxHRYHnNqwx8A8fReRyI2B0u2cqyG3M6ZkI+5OLioUszMsTjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793729; c=relaxed/simple;
	bh=LerTi2X72CkzAUpbmae0qNssVApI+InbrAoqJeJVZvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KCmmdI0QnBTsDTeorkDLlgRTalFerIZCPxkmR663bqxqU159EPxoqL52eT7mP9cYFt6wM2E6bFBGPfyPaJLUcxqezK7RicmFpxVpAhagZViI+US4kWaZbZV4+cuxAh3YvTRCTI9vMflJapYlRSZqhZ2F0SdJZD3lzZ7f4i8hZtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQj5iMet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQj5iMet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F78B1F0089B;
	Wed, 30 Sep 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793727;
	bh=YyxJzIXjUN8V7LsySK/VxgCoY/V00ioeb8G4lRMOvPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQj5iMetugCroOBKz7amD038kbChCd+VQ8uYFKArtFvL7fBla2gtrGd04yqHKTMTk
	 TijZca8qQU4DGU/f0KcM6TJ+1GBo3YQC4nIV845cDj4aHKVwrvYFLzsKgo8eduK8By
	 RpYkloZ4OufMs3tDnnbyN9b+pCJlPh0C3+NIfB5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/395] drm/i915/psr: Fixes for Dell XPS DA14260 quirk
Date: Wed, 30 Sep 2026 17:30:17 +0200
Message-ID: <20260930152348.385152859@linuxfoundation.org>
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

[ Upstream commit 1de647abdfda9dc307503d0a85152161850ba52c ]

Dell seems to be changing device ID even within same device model. Due to
this we need to ignore device ID when applying quirk for Dell XPS 14
DA14260. Do this by adding DEVICE_ID_ANY and assign it to Dell XPS 14
DA14260 quirk. Also apply the quirk only for eDP Panel Replay.

Fixes: 45c77d4bf8d4 ("drm/i915/psr: Disable Panel Replay on Dell XPS 14 DA14260 as a quirk")
Cc: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260320080403.1396926-1-jouni.hogander@intel.com
Stable-dep-of: 5271d81f99dd ("drm/i915/quirks: Limit eDP rate to HBR2 on HP Pavilion Plus 14-ew1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c    |    3 ++-
 drivers/gpu/drm/i915/display/intel_quirks.c |   16 ++++++++++------
 drivers/gpu/drm/i915/display/intel_quirks.h |    2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -593,7 +593,8 @@ static void _panel_replay_init_dpcd(stru
 	if (intel_dp->mst_detect == DRM_DP_MST)
 		return;
 
-	if (intel_has_dpcd_quirk(intel_dp, QUIRK_DISABLE_PANEL_REPLAY)) {
+	if (intel_dp_is_edp(intel_dp) &&
+	    intel_has_dpcd_quirk(intel_dp, QUIRK_DISABLE_EDP_PANEL_REPLAY)) {
 		drm_dbg_kms(display->drm,
 			    "Panel Replay support not currently available for this setup\n");
 		return;
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -86,11 +86,11 @@ static void quirk_edp_limit_rate_hbr2(st
 	drm_info(display->drm, "Applying eDP Limit rate to HBR2 quirk\n");
 }
 
-static void quirk_disable_panel_replay(struct intel_dp *intel_dp)
+static void quirk_disable_edp_panel_replay(struct intel_dp *intel_dp)
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 
-	intel_set_dpcd_quirk(intel_dp, QUIRK_DISABLE_PANEL_REPLAY);
+	intel_set_dpcd_quirk(intel_dp, QUIRK_DISABLE_EDP_PANEL_REPLAY);
 	drm_info(display->drm, "Applying disable Panel Replay quirk\n");
 }
 
@@ -116,6 +116,8 @@ struct intel_dpcd_quirk {
 
 #define SINK_DEVICE_ID_ANY	SINK_DEVICE_ID(0, 0, 0, 0, 0, 0)
 
+#define DEVICE_ID_ANY		0
+
 /* For systems that don't have a meaningful PCI subdevice/subvendor ID */
 struct intel_dmi_quirk {
 	void (*hook)(struct intel_display *display);
@@ -261,11 +263,11 @@ static const struct intel_dpcd_quirk int
 	},
 	/* Dell XPS 14 DA14260 */
 	{
-		.device = 0xb080,
+		.device = DEVICE_ID_ANY,
 		.subsystem_vendor = 0x1028,
 		.subsystem_device = 0x0db9,
 		.sink_oui = SINK_OUI(0x00, 0x22, 0xb9),
-		.hook = quirk_disable_panel_replay,
+		.hook = quirk_disable_edp_panel_replay,
 	},
 };
 
@@ -277,7 +279,8 @@ void intel_init_quirks(struct intel_disp
 	for (i = 0; i < ARRAY_SIZE(intel_quirks); i++) {
 		struct intel_quirk *q = &intel_quirks[i];
 
-		if (d->device == q->device &&
+		if ((d->device == q->device ||
+		     q->device == DEVICE_ID_ANY) &&
 		    (d->subsystem_vendor == q->subsystem_vendor ||
 		     q->subsystem_vendor == PCI_ANY_ID) &&
 		    (d->subsystem_device == q->subsystem_device ||
@@ -300,7 +303,8 @@ void intel_init_dpcd_quirks(struct intel
 	for (i = 0; i < ARRAY_SIZE(intel_dpcd_quirks); i++) {
 		const struct intel_dpcd_quirk *q = &intel_dpcd_quirks[i];
 
-		if (d->device == q->device &&
+		if ((d->device == q->device ||
+		     q->device == DEVICE_ID_ANY) &&
 		    (d->subsystem_vendor == q->subsystem_vendor ||
 		     q->subsystem_vendor == PCI_ANY_ID) &&
 		    (d->subsystem_device == q->subsystem_device ||
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -21,7 +21,7 @@ enum intel_quirk_id {
 	QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK,
 	QUIRK_FW_SYNC_LEN,
 	QUIRK_EDP_LIMIT_RATE_HBR2,
-	QUIRK_DISABLE_PANEL_REPLAY,
+	QUIRK_DISABLE_EDP_PANEL_REPLAY,
 };
 
 void intel_init_quirks(struct intel_display *display);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E04751CF5E;
	Wed, 30 Sep 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793731; cv=none; b=uRR2GJ/XzABrtT98/HjxYgCX/kDmI/Miv4XUmMBpH1igUK8IUQoxkN5dM1BWAjSmaUimOKxddksQOq6kvP/LBHDn0J2mC2rQQ7V/LXLvhjfWCu2x0ch5Uo98Fu19VfDhpgeY4b84UW0m7okyg4HfDF5ZXQP3FfUB/xm2L76BtvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793731; c=relaxed/simple;
	bh=ZWs5+MGf2ua4SJ6t98tI0qLaRb4DLTwCUfkKQ1I2pUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aj7i3fXK58sVQVRcPZE+nhmgJiQ0ifQcp9mLBObPSqYYIGPbYxe2NCs0Ze03I9ZoBDxkggEDcGwzEHMFq88Jh7DA7lmVzX732JqfjGpe8QB9Hovc+s1eIou0dA/wW4h9wmuwfyZPbIjSHUYf+6cvCUklsYAnqtUyGAonfh/mNDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cg7WbK5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cg7WbK5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF13A1F000FF;
	Wed, 30 Sep 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793730;
	bh=Mc5wUWp3u2sQ5YSAVdcG91kczZz7ux6XDssWJvhTxl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cg7WbK5h7RgZzCEkb2pdsi63yhP4TQZEQHFCDhwYo8+5eQ1706jau+nNU+OiGaTtT
	 n4ikFsLVe5cLJRX7CY7/EOFki4LJ6wCAPqoevDCSAHmFZArp7uE0ieVpjvZOm11184
	 IIFjwJOWM5VTQtN0AgqSOaGORO/EHqQ4C6e414VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/395] drm/i915/psr: Disable PSR2 on Xiaomi Book Pro 14 2026 as a quirk
Date: Wed, 30 Sep 2026 17:30:18 +0200
Message-ID: <20260930152348.406607753@linuxfoundation.org>
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

[ Upstream commit 5e79af5db00b2a5f4667aaf16cfe4ecb7759383b ]

Add new quirk (QUIRK_DISABLE_PSR2) for disabling PSR2 as a quirk for
problematic setups. Apply this newly added quirk on Xiaomi Book Pro 14
2026.

v2: logging adjusted

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7677
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260417102350.28328-1-jouni.hogander@intel.com
Stable-dep-of: 5271d81f99dd ("drm/i915/quirks: Limit eDP rate to HBR2 on HP Pavilion Plus 14-ew1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c    |    3 +++
 drivers/gpu/drm/i915/display/intel_quirks.c |    9 +++++++++
 drivers/gpu/drm/i915/display/intel_quirks.h |    1 +
 3 files changed, 13 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -668,6 +668,9 @@ static void _psr_init_dpcd(struct intel_
 	intel_dp->psr.sink_sync_latency =
 		intel_dp_get_sink_sync_latency(intel_dp);
 
+	if (intel_has_quirk(display, QUIRK_DISABLE_PSR2))
+		return;
+
 	if (DISPLAY_VER(display) >= 9 &&
 	    intel_dp->psr_dpcd[0] >= DP_PSR2_WITH_Y_COORD_IS_SUPPORTED) {
 		bool y_req = intel_dp->psr_dpcd[1] &
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -94,6 +94,12 @@ static void quirk_disable_edp_panel_repl
 	drm_info(display->drm, "Applying disable Panel Replay quirk\n");
 }
 
+static void quirk_disable_psr2(struct intel_display *display)
+{
+	intel_set_quirk(display, QUIRK_DISABLE_PSR2);
+	drm_info(display->drm, "PSR2 support not currently available for this setup, applying disable PSR2 quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -250,6 +256,9 @@ static struct intel_quirk intel_quirks[]
 
 	/* Dell XPS 13 7390 2-in-1 */
 	{ 0x8a52, 0x1028, 0x08b0, quirk_edp_limit_rate_hbr2 },
+
+	/* Xiaomi Book Pro 14 2026 */
+	{ 0xb081, 0x1d72, 0x2424, quirk_disable_psr2 },
 };
 
 static const struct intel_dpcd_quirk intel_dpcd_quirks[] = {
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -22,6 +22,7 @@ enum intel_quirk_id {
 	QUIRK_FW_SYNC_LEN,
 	QUIRK_EDP_LIMIT_RATE_HBR2,
 	QUIRK_DISABLE_EDP_PANEL_REPLAY,
+	QUIRK_DISABLE_PSR2,
 };
 
 void intel_init_quirks(struct intel_display *display);



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017047;
	b=3kkeQ3tnj2xMaCTD0tQGJcJILHRxiSGthBLJyeCvaMNoyFMfPu0Av/2ITI4+5UyR5JR3
	 NxNUMt4yKGeULcTg/5Lxqnz8H45kRV5W14HK6sKVUPFjfGV7TsH42pAw6B+qkvKCzAtlP
	 t90yFx2AKBH/pNLBFIefOlmcBA/wpKnG7Fma0TDc9TWyHlRoZbISL6AE38Ipuqc9DgY6A
	 DZf+VmBsWBbjEh+pcQG8kRmX0jh8LFS2vqxkIeVwCmeDj0kqyIIT8JwWXXx9HFTqbtmVF
	 vENTgxRkBOCxUflG+3Qj2LISIBAu7hTq3IrHzDqJX8bLOR/lcmm5JvSW15b0YYrcl2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QqlNpByvNtxQo7DlucRBqTzOaaLbV2Esluqa5asTNJE=;
	b=1rnsfhin0FiYX9MDTkzNYiMUqOtpxOlRsHxpFlmDMCmqIHllVUcYkJcmuiMHzo3hgGjn
	 HucrbechoN+Gdd2+Ya27u7DfiOeaRJ32lwWs85xJbtfzuYt7JDniSLKJwdF6JrxKqCppf
	 xnajASWr9JFMhvUR8K0sokdw/4tKzV83fsxXQzMOkpR1jFQvsZf83WHkVgFkGHZQDjW5C
	 Y3Y1u1y+K6MIoQfwBdp2rBUaGQRpFn+hqXfbxDNu2hbDHYOjFpLu5zC5lImhDePvD4MQ5
	 DkkJwZjlvTAQfE7FJtEGWzCHfBMSNvlW1DrPqGzQy0EPrWPGeXCNUqwP1EteXL8Afgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTlUm7S0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2FC606A320;
	Wed, 18 Nov 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTlUm7S0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8844F1F000C4;
	Wed, 18 Nov 2026 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017047;
	bh=QqlNpByvNtxQo7DlucRBqTzOaaLbV2Esluqa5asTNJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTlUm7S04KtoynTagghlwiVwWj3f8uz9+3fPdOZkULETPaXWXP6WBsH0bNBdSaIsR
	 H5rigZRgU6hceEUmx2oaekxdJRyr8nHdhXJeVyRuItNDcchdRS5yDgFz5IeV1Nqie8
	 zn+N1TSYsqLr5frhH5958S2cn5sHH0+0jpWEcZ+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0746/2651] drm/amd/display: Force FreeSync range minimum on quirky panels
Date: Wed, 18 Nov 2026 15:33:06 +0100
Message-ID: <20261118150314.737886026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Fangzhi Zuo <jerry.zuo@amd.com>

[ Upstream commit 7ea37c0f067875911f3954133fb5ace0bc518ba3 ]

[why]
Some panels advertise a FreeSync range minimum that does not operate
reliably at the low end:
- X34GS (EDID panel id ACR 0x08AF) reports a minimum that
  can flicker or drop out when the refresh rate approaches the reported
  minimum.
- 34w-30 (EDID panel id LEN 0x66F1) reports a 48 Hz minimum over
  DisplayPort, but the panel fails to light up at that minimum, resulting
  in a black screen. Forcing the minimum to 60 Hz avoids the black screen
  and lets the display light up normally.

[how]
- Add a force_freesync_min_hz field to struct dc_panel_patch.
- Add apply_edid_quirks() cases keyed on the affected panel ids that set
  force_freesync_min_hz (55 Hz for the X34GS, 60 Hz for the G34w-30).
- In amdgpu_dm_update_freesync_caps(), when the quirk is set and the sink
  is otherwise FreeSync capable, clamp the reported VRR range minimum
  (min_vfreq and monitor_range.min_vfreq) to the quirked value.
- Add a KUnit test covering the new quirk.

Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e4dca268eea6 ("drm/amd/display: Restore FreeSync VCP code check for HDMI/PCON sinks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/amdgpu_dm/amdgpu_dm_connector.c    | 12 ++++++++++++
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c  | 18 ++++++++++++++++++
 .../amdgpu_dm/tests/amdgpu_dm_helpers_test.c   | 17 +++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dc_types.h      |  1 +
 4 files changed, 48 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
index 45a69bf43971f..c1f1809b7935a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
@@ -3963,6 +3963,18 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 		}
 	}
 
+	/*
+	 * Apply per-monitor FreeSync range quirks. Some panels report a
+	 * VRR minimum that does not operate reliably; force it when the
+	 * monitor is quirked (see apply_edid_quirks()).
+	 */
+	if (sink->edid_caps.panel_patch.force_freesync_min_hz && freesync_capable) {
+		amdgpu_dm_connector->min_vfreq =
+			sink->edid_caps.panel_patch.force_freesync_min_hz;
+		connector->display_info.monitor_range.min_vfreq =
+			amdgpu_dm_connector->min_vfreq;
+	}
+
 	/* Handle MCCS */
 	if (do_mccs) {
 		dm_helpers_read_mccs_caps(adev->dm.dc->ctx, amdgpu_dm_connector->dc_link, sink);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 673b3cede7ddf..e1cc617eeda59 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -147,6 +147,24 @@ STATIC_IFN_KUNIT void apply_edid_quirks(struct dc_link *link, struct edid *edid,
 		drm_dbg_driver(dev, "Hiding secondary tile on panel id %X\n", panel_id);
 		edid_caps->panel_patch.disable_second_tile = true;
 		break;
+	/*
+	 * Workaround for the Acer Predator X34GS which reports a FreeSync
+	 * minimum refresh rate that does not operate reliably. Force the
+	 * FreeSync range minimum to 55 Hz.
+	 */
+	case drm_edid_encode_panel_id('A', 'C', 'R', 0x08AF):
+		drm_dbg_driver(dev, "Force FreeSync min to 55 Hz on panel id %X\n", panel_id);
+		edid_caps->panel_patch.force_freesync_min_hz = 55;
+		break;
+	/*
+	 * Workaround for the Lenovo G34w-30 which reports a FreeSync
+	 * minimum refresh rate (48 Hz) that fails to light up over DP.
+	 * Force the FreeSync range minimum to 60 Hz.
+	 */
+	case drm_edid_encode_panel_id('L', 'E', 'N', 0x66F1):
+		drm_dbg_driver(dev, "Force FreeSync min to 60 Hz on panel id %X\n", panel_id);
+		edid_caps->panel_patch.force_freesync_min_hz = 60;
+		break;
 	default:
 		return;
 	}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/tests/amdgpu_dm_helpers_test.c b/drivers/gpu/drm/amd/display/amdgpu_dm/tests/amdgpu_dm_helpers_test.c
index 639512bea2754..d03a5a61b0cd5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/tests/amdgpu_dm_helpers_test.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/tests/amdgpu_dm_helpers_test.c
@@ -186,6 +186,22 @@ static void dm_test_apply_edid_quirks_skip_phy_ssc(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, link->wa_flags.skip_phy_ssc_reduction);
 }
 
+/**
+ * dm_test_apply_edid_quirks_force_freesync_min - Test ACR 0x08AF FreeSync min quirk
+ * @test: The KUnit test context
+ */
+static void dm_test_apply_edid_quirks_force_freesync_min(struct kunit *test)
+{
+	struct dc_edid_caps edid_caps = {0};
+	struct dc_link *link = dm_test_quirk_link(test);
+	struct edid *edid = dm_test_edid_with_panel_id(test,
+			drm_edid_encode_panel_id('A', 'C', 'R', 0x08AF));
+
+	apply_edid_quirks(link, edid, &edid_caps);
+
+	KUNIT_EXPECT_EQ(test, edid_caps.panel_patch.force_freesync_min_hz, 55U);
+}
+
 /**
  * dm_test_apply_edid_quirks_unknown_noop - Test unknown panel id is a no-op
  * @test: The KUnit test context
@@ -3730,6 +3746,7 @@ static struct kunit_case amdgpu_dm_helpers_test_cases[] = {
 	KUNIT_CASE(dm_test_apply_edid_quirks_remove_sink_ext_caps),
 	KUNIT_CASE(dm_test_apply_edid_quirks_disable_colorimetry),
 	KUNIT_CASE(dm_test_apply_edid_quirks_skip_phy_ssc),
+	KUNIT_CASE(dm_test_apply_edid_quirks_force_freesync_min),
 	KUNIT_CASE(dm_test_apply_edid_quirks_unknown_noop),
 	/* dm_helpers_parse_edid_caps */
 	KUNIT_CASE(dm_test_parse_edid_caps_null_edid),
diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 7da673111ed91..64b4adee36c4b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -194,6 +194,7 @@ struct dc_panel_patch {
 	bool oled_optimize_display_on;
 	unsigned int force_mst_blocked_discovery;
 	unsigned int wait_after_dpcd_poweroff_ms;
+	unsigned int force_freesync_min_hz;
 };
 
 /**
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2AE12B83;
	Sat,  3 Feb 2024 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933652; cv=none; b=g7axTP692uKENd48vpvx8NfaZLvnXVc1TLLmlfVfs6x1zDcXWu0hgRM/kyIkMotnrgJc2+L7Utp3IcUE4ipdkJJawZzJL4ujBmktsv49laZvGDMymVCKoQnaAI+m6LWYzwrSnz5d1w5SKveX+xffCkjuE0hAkCOc49gGL78pvvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933652; c=relaxed/simple;
	bh=uyn9LOz5DuICicw6Mr0RBOLKBtDFVgXdzQvNa2QmjTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja25FlAV83i5SotC9CEu9pGHJWPlwwpxRnj9I03vwUa3qkhyYkvJDIrUI1mlUZRSg/RF72B1/wxzc+FXdUAqAY/kR7z4adPkK9/OrCNMDGYuSz/arBbFDXZm9daDFne8deglgt0WxTNBkxCON7GssysaKC8MalLN4hzpobYjiC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s95toPns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s95toPns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B03C433C7;
	Sat,  3 Feb 2024 04:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933651;
	bh=uyn9LOz5DuICicw6Mr0RBOLKBtDFVgXdzQvNa2QmjTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s95toPnsfF+Zk0Z1CLVr56p1fjsXZkAv2jSzpC0PuwwKbzS5X+fNyeNdaced+ZJbr
	 guD4nyKTQElGSNPrYARXEKInMkdxtMyEj18/qZdph50OZjY91RV1Cc7ifdHuKMumlD
	 iJhttvJIDTJKa6uYg3Rs38SGYSVjqhYPopDAExMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Ivan Lipski <ivlipski@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/322] Re-revert "drm/amd/display: Enable Replay for static screen use cases"
Date: Fri,  2 Feb 2024 20:05:09 -0800
Message-ID: <20240203035406.095385905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivlipski@amd.com>

[ Upstream commit d6398866a6b47e92319ef6efdb0126a4fbb7796a ]

This reverts commit 44e60b14d5a72f91fd0bdeae8da59ae37a3ca8e5.

Since, it causes a regression in which eDP displays with PSR support,
but no Replay support (Sink support <= 0x03), fail to enable PSR and
consequently all IGT amd_psr tests fail. So, revert this until a more
suitable fix can be found.

This got brought back accidently with the backmerge.

Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Ivan Lipski <ivlipski@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 22 -------------------
 .../amd/display/amdgpu_dm/amdgpu_dm_crtc.c    |  9 +-------
 drivers/gpu/drm/amd/include/amd_shared.h      |  2 --
 3 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 861b5e45e2a7..fabbfea33b0c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -65,7 +65,6 @@
 #include "amdgpu_dm_debugfs.h"
 #endif
 #include "amdgpu_dm_psr.h"
-#include "amdgpu_dm_replay.h"
 
 #include "ivsrcid/ivsrcid_vislands30.h"
 
@@ -4338,7 +4337,6 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	const struct dc_plane_cap *plane;
 	bool psr_feature_enabled = false;
-	bool replay_feature_enabled = false;
 	int max_overlay = dm->dc->caps.max_slave_planes;
 
 	dm->display_indexes_num = dm->dc->caps.max_streams;
@@ -4448,20 +4446,6 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		}
 	}
 
-	if (!(amdgpu_dc_debug_mask & DC_DISABLE_REPLAY)) {
-		switch (adev->ip_versions[DCE_HWIP][0]) {
-		case IP_VERSION(3, 1, 4):
-		case IP_VERSION(3, 1, 5):
-		case IP_VERSION(3, 1, 6):
-		case IP_VERSION(3, 2, 0):
-		case IP_VERSION(3, 2, 1):
-			replay_feature_enabled = true;
-			break;
-		default:
-			replay_feature_enabled = amdgpu_dc_feature_mask & DC_REPLAY_MASK;
-			break;
-		}
-	}
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
@@ -4510,12 +4494,6 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 				amdgpu_dm_update_connector_after_detect(aconnector);
 				setup_backlight_device(dm, aconnector);
 
-				/*
-				 * Disable psr if replay can be enabled
-				 */
-				if (replay_feature_enabled && amdgpu_dm_setup_replay(link, aconnector))
-					psr_feature_enabled = false;
-
 				if (psr_feature_enabled)
 					amdgpu_dm_set_psr_caps(link);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 97b7a0b8a1c2..30d4c6fd95f5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -29,7 +29,6 @@
 #include "dc.h"
 #include "amdgpu.h"
 #include "amdgpu_dm_psr.h"
-#include "amdgpu_dm_replay.h"
 #include "amdgpu_dm_crtc.h"
 #include "amdgpu_dm_plane.h"
 #include "amdgpu_dm_trace.h"
@@ -124,12 +123,7 @@ static void vblank_control_worker(struct work_struct *work)
 	 * fill_dc_dirty_rects().
 	 */
 	if (vblank_work->stream && vblank_work->stream->link) {
-		/*
-		 * Prioritize replay, instead of psr
-		 */
-		if (vblank_work->stream->link->replay_settings.replay_feature_enabled)
-			amdgpu_dm_replay_enable(vblank_work->stream, false);
-		else if (vblank_work->enable) {
+		if (vblank_work->enable) {
 			if (vblank_work->stream->link->psr_settings.psr_version < DC_PSR_VERSION_SU_1 &&
 			    vblank_work->stream->link->psr_settings.psr_allow_active)
 				amdgpu_dm_psr_disable(vblank_work->stream);
@@ -138,7 +132,6 @@ static void vblank_control_worker(struct work_struct *work)
 #ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
 			   !amdgpu_dm_crc_window_is_activated(&vblank_work->acrtc->base) &&
 #endif
-			   vblank_work->stream->link->panel_config.psr.disallow_replay &&
 			   vblank_work->acrtc->dm_irq_params.allow_psr_entry) {
 			amdgpu_dm_psr_enable(vblank_work->stream);
 		}
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index 67d7b7ee8a2a..abe829bbd54a 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -240,7 +240,6 @@ enum DC_FEATURE_MASK {
 	DC_DISABLE_LTTPR_DP2_0 = (1 << 6), //0x40, disabled by default
 	DC_PSR_ALLOW_SMU_OPT = (1 << 7), //0x80, disabled by default
 	DC_PSR_ALLOW_MULTI_DISP_OPT = (1 << 8), //0x100, disabled by default
-	DC_REPLAY_MASK = (1 << 9), //0x200, disabled by default for dcn < 3.1.4
 };
 
 enum DC_DEBUG_MASK {
@@ -251,7 +250,6 @@ enum DC_DEBUG_MASK {
 	DC_DISABLE_PSR = 0x10,
 	DC_FORCE_SUBVP_MCLK_SWITCH = 0x20,
 	DC_DISABLE_MPO = 0x40,
-	DC_DISABLE_REPLAY = 0x50,
 	DC_ENABLE_DPIA_TRACE = 0x80,
 };
 
-- 
2.43.0




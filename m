Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061128;
	b=DJWXXNOWYfLQ2yPaYv6y2rB4itKhf6cfImWtDuDpqAkd52GDOp+sbl/CfF3NQXeVXYT1
	 aWdnMoz7VltK2HwxLGEF9IC3BTBHNCd+iWESKPgKdUihDP1n0VeMOZNFe+eBTNgUMYKib
	 vlh2MWbpXBItX5nCfGxMigIeXVbUVp+3EALaBSK3rDyZSbWh3pTTUJZ2RotrE77FK7pzL
	 TBgZDZBGtmYsTQ1lwUOFlollOph6J5YHg2OZpy411EDkqpV4WdF/28KTRs/3Cu/Yp4FPm
	 T3s2TSmqh4Wa1yfFt1BT/Uvny4VZVPY6mhqWnqNzvUukfQ3/bEmXdL8PvevjRq6+dMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNpRCk2Kf2KOFrSzbj6ABjEy4XAe8K2kw7NTkjP+vIA=;
	b=Y7nzWHM+Rg1SFPamx/F6vA90wq17nshhVUU23QeTvUxFcHC1gcsMve9UkaQEys43tP+x
	 T5boO3pnATx/flBuax+fd6gCHssZMjYVmzpFIvbaGM1acd4ZjoEc5xKUWgO/mEXc5CE1d
	 vlVsGlvQmzc+IiNI8yG4l92ZN8zXxDOxrBbQx97o2CNiQqzftmd2b41C2t8zLna6d2eZe
	 /J1ht/F1vse+EDAnlY+NwpvTBs4g7fJzkVCoyCnS5YvnOD4UPGhFH5FIYcck9XmKw6KY3
	 DQS3gq4UTc2kluS3np1L8bCzWsw72ZIAcoWMtskFh8HxFW5SlpDVj0lDmPJ8pdqnhNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgaD65Z3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAAD606A330;
	Thu, 19 Nov 2026 04:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgaD65Z3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0EA1F000C7;
	Thu, 19 Nov 2026 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061128;
	bh=dNpRCk2Kf2KOFrSzbj6ABjEy4XAe8K2kw7NTkjP+vIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgaD65Z3F+P+ZJL5Hy0/oMi0XCBkt/V7w+npKiqI3ECUifr4FB/w60XHoW8LG4cIz
	 HgKCnkyh8Ala8rw0lF4u3yYlHYQZG1tgmRt4BeB9QRFDIJqEmjJZOcwJzz8HUl9uPZ
	 V2yIRG/cTsf5nDuqrr/WhZUGRt3HT3sXhP4sM8h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <khsieh@codeaurora.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1442/1848] drm/msm/dp: reduce link rate if failed at link training 1
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150019.832916091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 4b85d405cfe938ae7ad61656484ae88dee289e3b ]

Reduce link rate and re start link training if link training 1
failed due to loss of clock recovery done to fix Link Layer
CTS case 4.3.1.7.  Also only update voltage and pre-emphasis
swing level after link training started to fix Link Layer CTS
case 4.3.1.6.

Changes in V2:
-- replaced cr_status with link_status[DP_LINK_STATUS_SIZE]
-- replaced dp_ctrl_any_lane_cr_done() with dp_ctrl_colco_recovery_any_ok()
-- replaced dp_ctrl_any_ane_cr_lose() with !drm_dp_clock_recovery_ok()

Changes in V3:
-- return failed if lane_count <= 1

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1628196295-7382-3-git-send-email-khsieh@codeaurora.org
[remove unused cr_status variable]
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: a47987366e7f ("drm/msm/dp: don't report link training success after a reinit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 78 ++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 0b0d86d2121b9..7043e432997c6 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -80,13 +80,6 @@ struct dp_ctrl_private {
 	struct completion video_comp;
 };
 
-struct dp_cr_status {
-	u8 lane_0_1;
-	u8 lane_2_3;
-};
-
-#define DP_LANE0_1_CR_DONE	0x11
-
 static int dp_aux_link_configure(struct drm_dp_aux *aux,
 					struct dp_link_info *link)
 {
@@ -1073,7 +1066,7 @@ static int dp_ctrl_read_link_status(struct dp_ctrl_private *ctrl,
 }
 
 static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int tries, old_v_level, ret = 0;
 	u8 link_status[DP_LINK_STATUS_SIZE];
@@ -1102,9 +1095,6 @@ static int dp_ctrl_link_train_1(struct dp_ctrl_private *ctrl,
 		if (ret)
 			return ret;
 
-		cr->lane_0_1 = link_status[0];
-		cr->lane_2_3 = link_status[1];
-
 		if (drm_dp_clock_recovery_ok(link_status,
 			ctrl->link->link_params.num_lanes)) {
 			return 0;
@@ -1181,7 +1171,7 @@ static void dp_ctrl_clear_training_pattern(struct dp_ctrl_private *ctrl)
 }
 
 static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int tries = 0, ret = 0;
 	char pattern;
@@ -1197,10 +1187,6 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	else
 		pattern = DP_TRAINING_PATTERN_2;
 
-	ret = dp_ctrl_update_vx_px(ctrl);
-	if (ret)
-		return ret;
-
 	ret = dp_catalog_ctrl_set_pattern(ctrl->catalog, pattern);
 	if (ret)
 		return ret;
@@ -1213,8 +1199,6 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 		ret = dp_ctrl_read_link_status(ctrl, link_status);
 		if (ret)
 			return ret;
-		cr->lane_0_1 = link_status[0];
-		cr->lane_2_3 = link_status[1];
 
 		if (drm_dp_channel_eq_ok(link_status,
 			ctrl->link->link_params.num_lanes)) {
@@ -1234,7 +1218,7 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 static int dp_ctrl_reinitialize_mainlink(struct dp_ctrl_private *ctrl);
 
 static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int ret = 0;
 	u8 encoding = DP_SET_ANSI_8B10B;
@@ -1252,7 +1236,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	drm_dp_dpcd_write(ctrl->aux, DP_MAIN_LINK_CHANNEL_CODING_SET,
 				&encoding, 1);
 
-	ret = dp_ctrl_link_train_1(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train_1(ctrl, training_step);
 	if (ret) {
 		DRM_ERROR("link training #1 failed. ret=%d\n", ret);
 		goto end;
@@ -1261,7 +1245,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 	/* print success info as this is a result of user initiated action */
 	DRM_DEBUG_DP("link training #1 successful\n");
 
-	ret = dp_ctrl_link_train_2(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train_2(ctrl, training_step);
 	if (ret) {
 		DRM_ERROR("link training #2 failed. ret=%d\n", ret);
 		goto end;
@@ -1277,7 +1261,7 @@ static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 }
 
 static int dp_ctrl_setup_main_link(struct dp_ctrl_private *ctrl,
-		struct dp_cr_status *cr, int *training_step)
+			int *training_step)
 {
 	int ret = 0;
 
@@ -1293,7 +1277,7 @@ static int dp_ctrl_setup_main_link(struct dp_ctrl_private *ctrl,
 	 */
 	dp_catalog_ctrl_reset(ctrl->catalog);
 
-	ret = dp_ctrl_link_train(ctrl, cr, training_step);
+	ret = dp_ctrl_link_train(ctrl, training_step);
 
 	return ret;
 }
@@ -1489,7 +1473,6 @@ static int dp_ctrl_deinitialize_mainlink(struct dp_ctrl_private *ctrl)
 static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
-	struct dp_cr_status cr;
 	int training_step = DP_TRAINING_NONE;
 
 	dp_ctrl_push_idle(&ctrl->dp_ctrl);
@@ -1497,7 +1480,7 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 
 	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
 
-	ret = dp_ctrl_setup_main_link(ctrl, &cr, &training_step);
+	ret = dp_ctrl_setup_main_link(ctrl, &training_step);
 	if (ret)
 		goto end;
 
@@ -1628,6 +1611,25 @@ void dp_ctrl_handle_sink_request(struct dp_ctrl *dp_ctrl)
 	}
 }
 
+static bool dp_ctrl_clock_recovery_any_ok(
+			const u8 link_status[DP_LINK_STATUS_SIZE],
+			int lane_count)
+{
+	int reduced_cnt;
+
+	if (lane_count <= 1)
+		return false;
+
+	/*
+	 * only interested in the lane number after reduced
+	 * lane_count = 4, then only interested in 2 lanes
+	 * lane_count = 2, then only interested in 1 lane
+	 */
+	reduced_cnt = lane_count >> 1;
+
+	return drm_dp_clock_recovery_ok(link_status, reduced_cnt);
+}
+
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 {
 	int rc = 0;
@@ -1635,7 +1637,7 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	u32 rate = 0;
 	int link_train_max_retries = 5;
 	u32 const phy_cts_pixel_clk_khz = 148500;
-	struct dp_cr_status cr;
+	u8 link_status[DP_LINK_STATUS_SIZE];
 	unsigned int training_step;
 
 	if (!dp_ctrl)
@@ -1668,19 +1670,21 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 
 	while (--link_train_max_retries) {
 		training_step = DP_TRAINING_NONE;
-		rc = dp_ctrl_setup_main_link(ctrl, &cr, &training_step);
+		rc = dp_ctrl_setup_main_link(ctrl, &training_step);
 		if (rc == 0) {
 			/* training completed successfully */
 			break;
 		} else if (training_step == DP_TRAINING_1) {
 			/* link train_1 failed */
-			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+			if (!dp_catalog_link_is_connected(ctrl->catalog))
 				break;
-			}
+
+			dp_ctrl_read_link_status(ctrl, link_status);
 
 			rc = dp_ctrl_link_rate_down_shift(ctrl);
 			if (rc < 0) { /* already in RBR = 1.6G */
-				if (cr.lane_0_1 & DP_LANE0_1_CR_DONE) {
+				if (dp_ctrl_clock_recovery_any_ok(link_status,
+					ctrl->link->link_params.num_lanes)) {
 					/*
 					 * some lanes are ready,
 					 * reduce lane number
@@ -1696,12 +1700,18 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 				}
 			}
 		} else if (training_step == DP_TRAINING_2) {
-			/* link train_2 failed, lower lane rate */
-			if (!dp_catalog_link_is_connected(ctrl->catalog)) {
+			/* link train_2 failed */
+			if (!dp_catalog_link_is_connected(ctrl->catalog))
 				break;
-			}
 
-			rc = dp_ctrl_link_lane_down_shift(ctrl);
+			dp_ctrl_read_link_status(ctrl, link_status);
+
+			if (!drm_dp_clock_recovery_ok(link_status,
+					ctrl->link->link_params.num_lanes))
+				rc = dp_ctrl_link_rate_down_shift(ctrl);
+			else
+				rc = dp_ctrl_link_lane_down_shift(ctrl);
+
 			if (rc < 0) {
 				/* end with failure */
 				break; /* lane == 1 already */
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061131;
	b=hSTpgPt80OgVJ6AHrBz5wW9oxdQzKO6G7BJ18XGp1DcxjKFcKtwxzFbcA9970e+98O0E
	 z7Kmwo5CyE3SERRn8zUOlD2lKwkkzgWu2gBp2OJ54LJjiYQtl51BS4bcYpxNbXl2jsDNn
	 LgiU5bVkl6598kAAtYsM7/nI5dsroEf8BtVN2DA7QoVtSycm2XlHoJ7u0McV3CWk2pU+5
	 6dfnJLZcSmMkgeAXqVMwndNwkcRU9M/bWqjy4kTGdbibSfjPqdpKk+xqyTbECcIkl1O1d
	 Os/N0XTnZkevMK9PjnXly2G6PR6eRwwRLn0lEmbGkzY51CBF029KdNi+b8VNftMdieQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lGCgaRofYiIbUACJPpdB4HRPTrZ61qlXiLJypZ16g3s=;
	b=F868HOu9EFM+wdBaCCIpudke2Z+wsVu99woGFGowTDZKBSlLqOvpov2SexDtpp4Dwpph
	 4r08s6gqN90EyKHXmlLWo98UyRXjgapTKPZnAF/XKFmhtmeCQXHFaJ+ojmALksWWAEJ1x
	 7+FnyTW9NRhSow1M9PS8Qpma2KlVPx45A5J2Mpdqxb0sRmqkzMXb3p0tvAILuHSGp85Eb
	 4BoYZ0OFHRjTaXo9uEtW1lZPf8R1yfy5syx2DPexTTMP8UJw1MCn9gVHvN8mQi+aeDLi3
	 h29QVYq2O4q8DG9xD+iRCXo9Odw4kFdsuOUqSknX3OSC+hjh4ifOaV+HMB7VnqD8L3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+Ufo76C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237F5606A325;
	Thu, 19 Nov 2026 04:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+Ufo76C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DED51F000C4;
	Thu, 19 Nov 2026 04:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061131;
	bh=lGCgaRofYiIbUACJPpdB4HRPTrZ61qlXiLJypZ16g3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+Ufo76Cju2znaOzIvKkFfdv0/smr6WGdHn2sw8Gqi4+tcdU/wt9TZMToVld0QIMz
	 4JjFaegsgVAtowKnuuXEKVYsMP5mDl/0Xu3ACmKTQOPAzfFxrBelOEQg7GrMoI9KZl
	 +7+RsFzrQa82bVBad/6cihuz6uCAsw3zbsEAxIus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <khsieh@codeaurora.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1443/1848] drm/msm/dp: do not end dp link training until video is ready
Date: Wed, 18 Nov 2026 15:58:01 +0100
Message-ID: <20261118150019.868730125@linuxfoundation.org>
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

[ Upstream commit 2e0adc765d884cc080baa501e250bfad97035b09 ]

Initialize both pre-emphasis and voltage swing level to 0 before
start link training and do not end link training until video is
ready to reduce the period between end of link training and video
start to meet Link Layer CTS requirement.  Some dongle main link
symbol may become unlocked again if host did not end link training
soon enough after completion of link training 2. Host have to re
train main link if loss of symbol locked detected before end link
training so that the coming video stream can be transmitted to sink
properly. This fixes Link Layer CTS cases 4.3.2.1, 4.3.2.2, 4.3.2.3
and 4.3.2.4.

Changes in v3:
-- merge retrain link if loss of symbol locked happen into this patch
-- replace dp_ctrl_loss_symbol_lock() with dp_ctrl_channel_eq_ok()

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1628196295-7382-7-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: a47987366e7f ("drm/msm/dp: don't report link training success after a reinit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 56 +++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 7043e432997c6..76a4da82c24ca 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1478,6 +1478,9 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	dp_ctrl_push_idle(&ctrl->dp_ctrl);
 	dp_catalog_ctrl_reset(ctrl->catalog);
 
+	ctrl->link->phy_params.p_level = 0;
+	ctrl->link->phy_params.v_level = 0;
+
 	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
 
 	ret = dp_ctrl_setup_main_link(ctrl, &training_step);
@@ -1630,6 +1633,16 @@ static bool dp_ctrl_clock_recovery_any_ok(
 	return drm_dp_clock_recovery_ok(link_status, reduced_cnt);
 }
 
+static bool dp_ctrl_channel_eq_ok(struct dp_ctrl_private *ctrl)
+{
+	u8 link_status[DP_LINK_STATUS_SIZE];
+	int num_lanes = ctrl->link->link_params.num_lanes;
+
+	dp_ctrl_read_link_status(ctrl, link_status);
+
+	return drm_dp_channel_eq_ok(link_status, num_lanes);
+}
+
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 {
 	int rc = 0;
@@ -1664,6 +1677,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 		ctrl->link->link_params.rate,
 		ctrl->link->link_params.num_lanes, ctrl->dp_ctrl.pixel_rate);
 
+	ctrl->link->phy_params.p_level = 0;
+	ctrl->link->phy_params.v_level = 0;
+
 	rc = dp_ctrl_enable_mainlink_clocks(ctrl);
 	if (rc)
 		return rc;
@@ -1728,17 +1744,19 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN)
 		return rc;
 
-	/* stop txing train pattern */
-	dp_ctrl_clear_training_pattern(ctrl);
+	if (rc == 0) {  /* link train successfully */
+		/*
+		 * do not stop train pattern here
+		 * stop link training at on_stream
+		 * to pass compliance test
+		 */
+	} else  {
+		/*
+		 * link training failed
+		 * end txing train pattern here
+		 */
+		dp_ctrl_clear_training_pattern(ctrl);
 
-	/*
-	 * keep transmitting idle pattern until video ready
-	 * to avoid main link from loss of sync
-	 */
-	if (rc == 0)  /* link train successfully */
-		dp_ctrl_push_idle(dp_ctrl);
-	else  {
-		/* link training failed */
 		dp_ctrl_deinitialize_mainlink(ctrl);
 		rc = -ECONNRESET;
 	}
@@ -1746,9 +1764,15 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	return rc;
 }
 
+static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
+{
+	int training_step = DP_TRAINING_NONE;
+
+	return dp_ctrl_setup_main_link(ctrl, &training_step);
+}
+
 int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 {
-	u32 rate = 0;
 	int ret = 0;
 	bool mainlink_ready = false;
 	struct dp_ctrl_private *ctrl;
@@ -1758,10 +1782,6 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 
 	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
 
-	rate = ctrl->panel->link_info.rate;
-
-	ctrl->link->link_params.rate = rate;
-	ctrl->link->link_params.num_lanes = ctrl->panel->link_info.num_lanes;
 	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
 
 	DRM_DEBUG_DP("rate=%d, num_lanes=%d, pixel_rate=%d\n",
@@ -1776,6 +1796,12 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		}
 	}
 
+	if (!dp_ctrl_channel_eq_ok(ctrl))
+		dp_ctrl_link_retrain(ctrl);
+
+	/* stop txing train pattern to end link training */
+	dp_ctrl_clear_training_pattern(ctrl);
+
 	ret = dp_ctrl_enable_stream_clocks(ctrl);
 	if (ret) {
 		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
-- 
2.53.0




Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8A21360
	for <patches@lists.linux.dev>; Thu, 23 Jun 2022 00:25:44 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id jb13so3170696plb.9
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zfzPrpeTQ+KQnaPrfJgJ0c6hHvEz6fhi8MYcUz9NJ1A=;
        b=AD/Q3Vl+uQOyhp98mrf6gVeSAJ07vt0jJkGwNMCYDUs7mmAb37KqIGxXvHqdQmySpF
         5PlvLWBI447pET9+OUFzDeTEh47Vk7UahKP1NRTrttZEdWdzZOlgEJBrFtouLFo+qysS
         yo+ug9wTUy4RJ74lsHb01vODkIhr2u8LbpPQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfzPrpeTQ+KQnaPrfJgJ0c6hHvEz6fhi8MYcUz9NJ1A=;
        b=RYJIy/lCnVTAHPm3It3/LuqpOrS6/NEihcGSHk9OBdmdql4oh+7RAT7da8c3hXMzuw
         7LkHPNk9bc7slrguy2MnJxbRWkcI7MH+KJPSvRxF+3Dngf9Zd2JeWhI+83zctT8nscCH
         yRS0DEN/kmvfB58aOlV+px/kO9fxl8QNohS+cIxFTg/lKEs+hIE9Iznd5X0VfT3xzs4X
         jX8kafKAMTIeZWSMctIjrgeWZPg81aRHmp70fsX3i3WfkC5ZviILoSFgRn2Rb4gtjT5P
         r+PQYv7wL0zTL7hCdrMBmgI6y/OgZG2UtFzaX2bZNx71Q6iFUEtl/FsJaP7gTieSS3wM
         q1nQ==
X-Gm-Message-State: AJIora+Gi+wIbNuvNueI4wScNW18zYkoAn9PRLI2ud2zUlx/WiHnmWQd
	1Wq2EBNllj43KsU7NfzYAlRybqJVZSaF5w==
X-Google-Smtp-Source: AGRyM1uAcIjLj26SdWCactJRqf1+mYcLWpx5z83YzoAbOeNYSMgDBf7oGeQFNXm6zyu+QDnuj9ToEg==
X-Received: by 2002:a17:902:900c:b0:16a:4521:10fd with SMTP id a12-20020a170902900c00b0016a452110fdmr6965194plp.75.1655943943888;
        Wed, 22 Jun 2022 17:25:43 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:f28c:6f86:743c:1c04])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b00163fbb1eec5sm13332705plh.229.2022.06.22.17.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 17:25:43 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Kuogee Hsieh <quic_khsieh@quicinc.com>
Subject: [PATCH v2 1/3] drm/msm/dp: Reorganize code to avoid forward declaration
Date: Wed, 22 Jun 2022 17:25:38 -0700
Message-Id: <20220623002540.871994-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
In-Reply-To: <20220623002540.871994-1-swboyd@chromium.org>
References: <20220623002540.871994-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's move these functions around to avoid having to forward declare
dp_ctrl_on_stream_phy_test_report(). Also remove
dp_ctrl_reinitialize_mainlink() forward declaration because we're doing
that sort of task.

Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 104 +++++++++++++++----------------
 1 file changed, 50 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 703249384e7c..bd445e683cfc 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1238,8 +1238,6 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	return -ETIMEDOUT;
 }
 
-static int dp_ctrl_reinitialize_mainlink(struct dp_ctrl_private *ctrl);
-
 static int dp_ctrl_link_train(struct dp_ctrl_private *ctrl,
 			int *training_step)
 {
@@ -1534,38 +1532,6 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
-static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl);
-
-static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
-{
-	int ret = 0;
-
-	if (!ctrl->link->phy_params.phy_test_pattern_sel) {
-		drm_dbg_dp(ctrl->drm_dev,
-			"no test pattern selected by sink\n");
-		return ret;
-	}
-
-	/*
-	 * The global reset will need DP link related clocks to be
-	 * running. Add the global reset just before disabling the
-	 * link clocks and core clocks.
-	 */
-	ret = dp_ctrl_off(&ctrl->dp_ctrl);
-	if (ret) {
-		DRM_ERROR("failed to disable DP controller\n");
-		return ret;
-	}
-
-	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
-	if (!ret)
-		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
-	else
-		DRM_ERROR("failed to enable DP link controller\n");
-
-	return ret;
-}
-
 static bool dp_ctrl_send_phy_test_pattern(struct dp_ctrl_private *ctrl)
 {
 	bool success = false;
@@ -1618,6 +1584,56 @@ static bool dp_ctrl_send_phy_test_pattern(struct dp_ctrl_private *ctrl)
 	return success;
 }
 
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
+{
+	int ret;
+	struct dp_ctrl_private *ctrl;
+
+	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
+
+	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
+
+	ret = dp_ctrl_enable_stream_clocks(ctrl);
+	if (ret) {
+		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
+		return ret;
+	}
+
+	dp_ctrl_send_phy_test_pattern(ctrl);
+
+	return 0;
+}
+
+static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
+{
+	int ret = 0;
+
+	if (!ctrl->link->phy_params.phy_test_pattern_sel) {
+		drm_dbg_dp(ctrl->drm_dev,
+			"no test pattern selected by sink\n");
+		return ret;
+	}
+
+	/*
+	 * The global reset will need DP link related clocks to be
+	 * running. Add the global reset just before disabling the
+	 * link clocks and core clocks.
+	 */
+	ret = dp_ctrl_off(&ctrl->dp_ctrl);
+	if (ret) {
+		DRM_ERROR("failed to disable DP controller\n");
+		return ret;
+	}
+
+	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
+	if (!ret)
+		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
+	else
+		DRM_ERROR("failed to enable DP link controller\n");
+
+	return ret;
+}
+
 void dp_ctrl_handle_sink_request(struct dp_ctrl *dp_ctrl)
 {
 	struct dp_ctrl_private *ctrl;
@@ -1815,26 +1831,6 @@ static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
 	return dp_ctrl_setup_main_link(ctrl, &training_step);
 }
 
-static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
-{
-	int ret;
-	struct dp_ctrl_private *ctrl;
-
-	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
-
-	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
-
-	ret = dp_ctrl_enable_stream_clocks(ctrl);
-	if (ret) {
-		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
-		return ret;
-	}
-
-	dp_ctrl_send_phy_test_pattern(ctrl);
-
-	return 0;
-}
-
 int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train)
 {
 	int ret = 0;
-- 
https://chromeos.dev


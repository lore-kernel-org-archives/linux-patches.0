Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9A1360
	for <patches@lists.linux.dev>; Thu, 23 Jun 2022 00:25:46 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so993802pjz.1
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SygWKchO0k+y7yXsZh0lg7LZ0sosds739AKDKHLdzm8=;
        b=b3st9LQI8EUcf4vRZkN9FuY8JTgqSsuawrFH9hFAlJZTkVCtFxFALeeL3f82fotnXr
         6LDOe5qKxy8Vz+vQ0mmD1l7s+y6QJmxrb/atmlIsrpBBGx6kLWqfcw1LvOF5iyJO1MCP
         c2DKMugV/35nUO1ROV12YG7FUQWLGIYSHRSiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SygWKchO0k+y7yXsZh0lg7LZ0sosds739AKDKHLdzm8=;
        b=Cj99WWN722dRhHrxkkG93NBaDf3MShAt7ROwJoEgezbUJ3ilTQVETmjtcT54i7y2BA
         ppk4HUNrKD+WXG1Yv4Tc7jy0w9orx09ySbFeHCmVHeLpl4qC85y1Pp+xnFklacCvOcnh
         SHNk2p4o5dDgcYTfjpWkp8Qfeizjyl/UvMCA2JB6OvrSaWBmoTMDRVZAqaMOuE93ybxB
         FdQyrWWN4LwP3SmvdeVvXECJtWuMdR0b5RirJzWZp7HA2YNveqmuky7NZsIjSwWKuHhN
         6QoDMzhU92q8VWWU4qFs9pJu50Jm8cxO8dxvbhhAjtJdkHTcU7kyubxDzAH9xpp5aSVF
         jmzQ==
X-Gm-Message-State: AJIora/zV2jQENA09/64Im1htWKztFljtiF+nMFoVwW4tyfjO0UG80w0
	poyUA1QysyaDsLyx7K0hhU2V6w==
X-Google-Smtp-Source: AGRyM1vljkq/ZMbBKLNrU/5jd/GiIb1Avw040L4R6xvEuHNHC8lbPLZXn68o6WxIfLbKiAsrJ+bvnw==
X-Received: by 2002:a17:902:b216:b0:16a:854:e641 with SMTP id t22-20020a170902b21600b0016a0854e641mr29379561plr.154.1655943946136;
        Wed, 22 Jun 2022 17:25:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:f28c:6f86:743c:1c04])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b00163fbb1eec5sm13332705plh.229.2022.06.22.17.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 17:25:45 -0700 (PDT)
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
Subject: [PATCH v2 3/3] drm/msm/dp: Get rid of dp_ctrl_on_stream_phy_test_report()
Date: Wed, 22 Jun 2022 17:25:40 -0700
Message-Id: <20220623002540.871994-4-swboyd@chromium.org>
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

This API isn't really more than a couple lines now that we don't store
the pixel_rate to the struct member. Inline it into the caller.

Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 44 ++++++++++++--------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index feb26d4d6e97..e475f4ca078a 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1564,36 +1564,15 @@ static bool dp_ctrl_send_phy_test_pattern(struct dp_ctrl_private *ctrl)
 	return success;
 }
 
-static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
+static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 {
 	int ret;
-	struct dp_ctrl_private *ctrl;
 	unsigned long pixel_rate;
 
-	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
-
-	pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
-	dp_ctrl_set_clock_rate(ctrl, DP_STREAM_PM, "stream_pixel", pixel_rate * 1000);
-
-	ret = dp_power_clk_enable(ctrl->power, DP_STREAM_PM, true);
-	if (ret) {
-		DRM_ERROR("Unable to start pixel clocks. ret=%d\n", ret);
-		return ret;
-	}
-
-	dp_ctrl_send_phy_test_pattern(ctrl);
-
-	return 0;
-}
-
-static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
-{
-	int ret = 0;
-
 	if (!ctrl->link->phy_params.phy_test_pattern_sel) {
 		drm_dbg_dp(ctrl->drm_dev,
 			"no test pattern selected by sink\n");
-		return ret;
+		return 0;
 	}
 
 	/*
@@ -1608,12 +1587,23 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 	}
 
 	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
-	if (!ret)
-		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
-	else
+	if (ret) {
 		DRM_ERROR("failed to enable DP link controller\n");
+		return ret;
+	}
 
-	return ret;
+	pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
+	dp_ctrl_set_clock_rate(ctrl, DP_STREAM_PM, "stream_pixel", pixel_rate * 1000);
+
+	ret = dp_power_clk_enable(ctrl->power, DP_STREAM_PM, true);
+	if (ret) {
+		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
+		return ret;
+	}
+
+	dp_ctrl_send_phy_test_pattern(ctrl);
+
+	return 0;
 }
 
 void dp_ctrl_handle_sink_request(struct dp_ctrl *dp_ctrl)
-- 
https://chromeos.dev


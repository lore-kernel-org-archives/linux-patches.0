Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD2B4C84
	for <patches@lists.linux.dev>; Fri, 17 Jun 2022 20:47:55 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id r5so4978401pgr.3
        for <patches@lists.linux.dev>; Fri, 17 Jun 2022 13:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZkHcSooWDiFQAWanDp+t9iIhWojlq4TIuHk5USWu968=;
        b=EiW2jSIpWnSRYzvxKxkG6vi0w3xy/58QL63gbehgu6Xz2yKJ5Sf2Bfr8wBlOiAOaha
         VILTTueJVdvB68GFjLMbnvdjEe72h5g76xKMIkWXi1UtUr6Uxd0BlGdUaLInDbpIhzQI
         dl7bEPbJsPf6GuAIlyO0Neb7bK8WXwcCwwpIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZkHcSooWDiFQAWanDp+t9iIhWojlq4TIuHk5USWu968=;
        b=w8K7VsTNTaBGukyGLHT6B7BkyGWhtlqUpyPnCI8GOFn31kl+HUZzlniyE6Ef7swxjR
         9414WUZlrDHs9pYCpJ6gsYhjwUivv6Ody4SU0Y/tFTRI+4ACb0etUJZ4WO3OhdoVvbLA
         yKJL10pLWmjgT2K1iLvb0DWwlVSD9BREZDmvr46wDsfbbLbVEQ6Us7mWvKp/IqMswZw+
         Y5l9/+NZYRoKcNc8sGurPD5P76ktEdN/WI3mKIfLt6RFExIni65VHRaJx3sKIDN5WkEN
         vPdPuzq/t7QqDTxI6KDc+hD4WHvirTAmlmdOx504Wf1GlAf6wfuNzemQFyBY4aA40y0n
         uZBQ==
X-Gm-Message-State: AJIora+huN+PwYxAssQvIgAZWYWA35jNqsb7nT5Z7zuHwr14xlhQXLkp
	GretyGvBjlqlbF/CH+4mkt3Cmw==
X-Google-Smtp-Source: AGRyM1tviS+33tpMgDPQRa+qfam6sWYHX1/xJo9ZNWkAIGRMfkx8jNSbEbSqFZIiC7tLsFzZ8nSlnQ==
X-Received: by 2002:a05:6a02:201:b0:3fc:6071:a272 with SMTP id bh1-20020a056a02020100b003fc6071a272mr10732274pgb.518.1655498875212;
        Fri, 17 Jun 2022 13:47:55 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:52e2:7dc8:1e20:f870])
        by smtp.gmail.com with ESMTPSA id z12-20020aa79f8c000000b0052089e1b88esm4098325pfr.192.2022.06.17.13.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:47:54 -0700 (PDT)
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
Subject: [PATCH 3/3] drm/msm/dp: Get rid of dp_ctrl_on_stream_phy_test_report()
Date: Fri, 17 Jun 2022 13:47:50 -0700
Message-Id: <20220617204750.2347797-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220617204750.2347797-1-swboyd@chromium.org>
References: <20220617204750.2347797-1-swboyd@chromium.org>
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
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 40 ++++++++++++--------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index e114521af2e9..d04fddb29fdf 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1582,34 +1582,15 @@ static bool dp_ctrl_send_phy_test_pattern(struct dp_ctrl_private *ctrl)
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
-	ret = dp_ctrl_enable_stream_clocks(ctrl, pixel_rate);
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
@@ -1624,12 +1605,21 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
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
+	ret = dp_ctrl_enable_stream_clocks(ctrl, pixel_rate);
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


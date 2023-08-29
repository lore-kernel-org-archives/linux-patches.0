Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A691643E
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:44 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bdbf10333bso37311125ad.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334864; x=1693939664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V46+9RLRUs4jn3oMfUKtRDAEvgB49sGBWfYkBPv0+7o=;
        b=V/nm6vszO+uvEgAFcBm6ctl27mmYNTIbrvxYVif2P7XV8O9SZ4LQwXasF6coGjMn/T
         PKadI4pkh9xKzUC4CF1RfTbzxH/u80SEUUHcmsx2hmBOVqzX+ILpLP93898uIus/iEL3
         OjamnOk5JD6kmxjUiibEJFzjti2YpMem+i4X4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334864; x=1693939664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V46+9RLRUs4jn3oMfUKtRDAEvgB49sGBWfYkBPv0+7o=;
        b=RaPAGCvPjPZu3iCZlAVN/N1iDqpFCpQumLpAl2dY3M/d8vJLFlbdJVsFrYMNoYPGzM
         6sCvhHQOs5JrRl5rQPcI1h9onv0G8Y5swxYsJHTQEwubeHiUqWrMidDGLD3Ywyt8ec4H
         hfwqKaHsT5+aS2IF2iCQYSkYI2tMBO9iaC/ipC6mP6eST8izqfETEQTHHBOsUVgB0tIC
         LkUSCgN1HTalhWXjxBYxHMr3tLS6j5Yo0raADGRAefO+61m1zvxxmGvpGCcxWsnbOZix
         9dHcn6yG9/3SLx3lgAcRKt5sHvkSi0TaSLcP9Eqg6od4yItOxf/cFIabi5VoeT0HOR2D
         JtcQ==
X-Gm-Message-State: AOJu0YzEfYz6FcUQNiln6Ey10LLqREdczIWIlWkD8/A5ArWt48OgUugL
	yHiap5OGP7tVJlh3t/jw2HEvMA==
X-Google-Smtp-Source: AGHT+IFQ+sayvRTbFlB/yJwtr4beqBjEBFE4xO6oxnY7iGPiTXaDK/H6T4fPE7QuZzDpNy7Vg0mguQ==
X-Received: by 2002:a17:902:db0e:b0:1bf:a41:371e with SMTP id m14-20020a170902db0e00b001bf0a41371emr38019313plx.56.1693334863827;
        Tue, 29 Aug 2023 11:47:43 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:43 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>
Subject: [PATCH 3/7] drm/msm/dp: Remove dead code related to downstream cap info
Date: Tue, 29 Aug 2023 11:47:28 -0700
Message-ID: <20230829184735.2841739-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
In-Reply-To: <20230829184735.2841739-1-swboyd@chromium.org>
References: <20230829184735.2841739-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We read the downstream port count and capability info but never use it
anywhere. Remove 'ds_port_cnt' and 'ds_cap_info' and any associated code
from this driver. Fold the check for 'dfp_present' into a call to
drm_dp_is_branch() at the one place it is used to get rid of any member
storage related to downstream ports.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 25 +++----------------------
 drivers/gpu/drm/msm/dp/dp_panel.h |  6 ------
 2 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index a0523b18b9e9..9fb4e963fefb 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -43,9 +43,7 @@ static void dp_panel_read_psr_cap(struct dp_panel_private *panel)
 
 static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
 {
-	int rc = 0;
-	size_t len;
-	ssize_t rlen;
+	int rc;
 	struct dp_panel_private *panel;
 	struct dp_link_info *link_info;
 	u8 *dpcd, major, minor;
@@ -79,25 +77,8 @@ static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
 	if (drm_dp_enhanced_frame_cap(dpcd))
 		link_info->capabilities |= DP_LINK_CAP_ENHANCED_FRAMING;
 
-	dp_panel->dfp_present = dpcd[DP_DOWNSTREAMPORT_PRESENT];
-	dp_panel->dfp_present &= DP_DWN_STRM_PORT_PRESENT;
-
-	if (dp_panel->dfp_present && (dpcd[DP_DPCD_REV] > 0x10)) {
-		dp_panel->ds_port_cnt = dpcd[DP_DOWN_STREAM_PORT_COUNT];
-		dp_panel->ds_port_cnt &= DP_PORT_COUNT_MASK;
-		len = DP_DOWNSTREAM_PORTS * DP_DOWNSTREAM_CAP_SIZE;
-
-		rlen = drm_dp_dpcd_read(panel->aux,
-			DP_DOWNSTREAM_PORT_0, dp_panel->ds_cap_info, len);
-		if (rlen < len) {
-			DRM_ERROR("ds port status failed, rlen=%zd\n", rlen);
-			rc = -EINVAL;
-			goto end;
-		}
-	}
-
 	dp_panel_read_psr_cap(panel);
-end:
+
 	return rc;
 }
 
@@ -173,7 +154,7 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 		return -EINVAL;
 	}
 
-	if (dp_panel->dfp_present) {
+	if (drm_dp_is_branch(dp_panel->dpcd)) {
 		count = drm_dp_read_sink_count(panel->aux);
 		if (!count) {
 			DRM_ERROR("no downstream ports connected\n");
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.h b/drivers/gpu/drm/msm/dp/dp_panel.h
index 6d733480a62d..3cb1f8dcfd3b 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.h
+++ b/drivers/gpu/drm/msm/dp/dp_panel.h
@@ -13,9 +13,6 @@
 
 struct edid;
 
-#define DP_DOWNSTREAM_PORTS		4
-#define DP_DOWNSTREAM_CAP_SIZE		4
-
 struct dp_display_mode {
 	struct drm_display_mode drm_mode;
 	u32 capabilities;
@@ -39,9 +36,6 @@ struct dp_panel_psr {
 struct dp_panel {
 	/* dpcd raw data */
 	u8 dpcd[DP_RECEIVER_CAP_SIZE];
-	u8 ds_cap_info[DP_DOWNSTREAM_PORTS * DP_DOWNSTREAM_CAP_SIZE];
-	u32 ds_port_cnt;
-	u32 dfp_present;
 
 	struct dp_link_info link_info;
 	struct drm_dp_desc desc;
-- 
https://chromeos.dev


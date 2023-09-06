Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA101097D
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:12:31 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68a41031768so107207b3a.3
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023950; x=1694628750; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Edgvbmd5y4jUc7RB+Rf63E6o4J7BSjl9P5UimGRUsdQ=;
        b=gP436iT5FR1DQCF00WjNWAwCA4PPpPE8Rzb4qtHFUKzR6Ve/TORrWDWo0kqO3HR+Ng
         IU4RK7dHJ5LvZC3g45ZrqeZxiaby4+x2POX6mJwZbt/pfmX5M/tXawa5ACE1Ps44InRg
         3jw0hCE0UAdwXurpMoG9sDFV8hbhQWwxOMKS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023950; x=1694628750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Edgvbmd5y4jUc7RB+Rf63E6o4J7BSjl9P5UimGRUsdQ=;
        b=IdrYQrWDWZZGk4V124bNZ8NtbEVnbBwyC+CR7MbK9I86fCc98nL10/LKwogO4JHUa7
         aLziWme68XzLKLnHh/94hpnhU6iTG0tyPBAW9YaM/OdLR+z8BrVcylkLUkxXYCGfwFvJ
         rpOTlTMbuCZUI4o3bFPkQmXp1AzFfBsb2EwAhkv23KCKHbzKyP7eqbEMb8p80ssiR0cw
         PIVxNYvI3mCT5999tpkcDQsWyfMti70KautPpwXr8W0i7VrER7XvJXVS6eCKoukS1fOp
         bZmjeq9Sd0Ipn1I4yZW8flqVTTzDKxYz+O/h9IoS5CawRZzCCzC3lf4U1va2SuDJ4HO9
         B9RQ==
X-Gm-Message-State: AOJu0Yw2e7Mzs5nwq/GkKyia/xqMOTvbWco73WuUXFeXsk/XHU5cwpLV
	4q3QipDKhPEsbuBFRvakB8yxGA==
X-Google-Smtp-Source: AGHT+IH6kSrFTL9eIlfDr/vwL8Fsw7IYLh/XA+8fJSBKdMHvlaTDr5JYbfbs2SSDKsWyskvF1jKHrg==
X-Received: by 2002:a05:6a00:1786:b0:68a:3e68:f8ab with SMTP id s6-20020a056a00178600b0068a3e68f8abmr16812291pfg.14.1694023950511;
        Wed, 06 Sep 2023 11:12:30 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id c10-20020a62e80a000000b0064fde7ae1ffsm11080552pfi.38.2023.09.06.11.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:12:30 -0700 (PDT)
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
Subject: [PATCH 1/2] drm/msm/dp: Inline dp_display_is_sink_count_zero()
Date: Wed,  6 Sep 2023 11:12:25 -0700
Message-ID: <20230906181226.2198441-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230906181226.2198441-1-swboyd@chromium.org>
References: <20230906181226.2198441-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is basically a one-liner when you ignore the debug
logging. Just inline the function and drop the log to simplify the code.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 96bbf6fec2f1..2a5f1ab9a65b 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -341,14 +341,6 @@ static const struct component_ops dp_display_comp_ops = {
 	.unbind = dp_display_unbind,
 };
 
-static bool dp_display_is_sink_count_zero(struct dp_display_private *dp)
-{
-	drm_dbg_dp(dp->drm_dev, "present=%#x sink_count=%d\n",
-			dp->panel->dpcd[DP_DOWNSTREAMPORT_PRESENT],
-		dp->link->sink_count);
-	return drm_dp_is_branch(dp->panel->dpcd) && dp->link->sink_count == 0;
-}
-
 static void dp_display_send_hpd_event(struct msm_dp *dp_display)
 {
 	struct dp_display_private *dp;
@@ -507,7 +499,7 @@ static int dp_display_handle_port_ststus_changed(struct dp_display_private *dp)
 {
 	int rc = 0;
 
-	if (dp_display_is_sink_count_zero(dp)) {
+	if (drm_dp_is_branch(dp->panel->dpcd) && dp->link->sink_count == 0) {
 		drm_dbg_dp(dp->drm_dev, "sink count is zero, nothing to do\n");
 		if (dp->hpd_state != ST_DISCONNECTED) {
 			dp->hpd_state = ST_DISCONNECT_PENDING;
-- 
https://chromeos.dev


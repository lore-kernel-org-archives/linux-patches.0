Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA2E18019
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:50 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68a440a8a20so4075440b3a.3
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334869; x=1693939669; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDFi+t2HGk6Ez2m1E1bDJmYF5dLdXGiplCl4kzCCGIw=;
        b=j62F56kZri6I4FM2SdOofSv531fJxG2oaOEH53s+jpn9K1YPkd7BsuL+nw9XYj4bmS
         BgxbvU6O2uz00NC2WNnmaHsaRJhqBnHEil4Eh2TwZs5MYsrLEGFnVc30cmB+vG2+uZhK
         VFCfzBiSayC+5GZGmWYQwSeqmC07lzBFhnH2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334869; x=1693939669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDFi+t2HGk6Ez2m1E1bDJmYF5dLdXGiplCl4kzCCGIw=;
        b=Y6pSrwmZc/ktd50uBfD4TbV4hOETuSXqvq1TEpc9zVwR/t4N012tKKzx0tIFqhk09X
         Vfjn+SHt9KbR+dov3rKDKYOPfwi9NdJ53/gUHOwU533WW9J447FtZaBb0iDntip/khAb
         p1opBCtflx42R9ZHiZ87tENZOxvfD4MjSKFrObBXA0igSn1nciU1BV29ttos4DCm86SX
         xqcRB0LoL1UYM6mpXJkDHNqNNm+fGM85KjtG2ixTT5nvn3+1yQ6rO8LDPj6B9lCHNfpH
         0eOUNKOD1WlQHMUuznnzj8CMfOFfdl/T4BU2zW29K8c7tNRnX0twjUPpAU48S5HfP/Ev
         FLhQ==
X-Gm-Message-State: AOJu0YySmSYZlS/HoORqsmsljl7LXQ6pfDDd6QoM7ePJT4HFLz5AcG6p
	Zu08MR4KVz+CwqCHfgjs43CdHw==
X-Google-Smtp-Source: AGHT+IG58CNBx1V/eqpVdTw/QvBwIlAZBBILyaosLO9zrBbi7Cn4JE3QPxGI+6zG/AqLakLHAjK+GQ==
X-Received: by 2002:a05:6a21:66cb:b0:138:2fb8:6b42 with SMTP id ze11-20020a056a2166cb00b001382fb86b42mr180543pzb.14.1693334869676;
        Tue, 29 Aug 2023 11:47:49 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:49 -0700 (PDT)
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
Subject: [PATCH 7/7] drm/msm/dp: Remove dp_display_is_ds_bridge()
Date: Tue, 29 Aug 2023 11:47:32 -0700
Message-ID: <20230829184735.2841739-8-swboyd@chromium.org>
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

This function is simply drm_dp_is_branch() so use that instead of
open-coding it.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 76f13954015b..96bbf6fec2f1 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -341,19 +341,12 @@ static const struct component_ops dp_display_comp_ops = {
 	.unbind = dp_display_unbind,
 };
 
-static bool dp_display_is_ds_bridge(struct dp_panel *panel)
-{
-	return (panel->dpcd[DP_DOWNSTREAMPORT_PRESENT] &
-		DP_DWN_STRM_PORT_PRESENT);
-}
-
 static bool dp_display_is_sink_count_zero(struct dp_display_private *dp)
 {
 	drm_dbg_dp(dp->drm_dev, "present=%#x sink_count=%d\n",
 			dp->panel->dpcd[DP_DOWNSTREAMPORT_PRESENT],
 		dp->link->sink_count);
-	return dp_display_is_ds_bridge(dp->panel) &&
-		(dp->link->sink_count == 0);
+	return drm_dp_is_branch(dp->panel->dpcd) && dp->link->sink_count == 0;
 }
 
 static void dp_display_send_hpd_event(struct msm_dp *dp_display)
-- 
https://chromeos.dev


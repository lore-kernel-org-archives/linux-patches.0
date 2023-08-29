Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DAC18013
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:45 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bbc87ded50so29191765ad.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334865; x=1693939665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ve0TvxUqRJlJKKLuvKm0zT04FAFhZiHAVMwMtJute6s=;
        b=i6Jfs7UbT8S74Gau5HpO2Cq++3W4Nwv+Sc5IC/PuOnGxQCGchsS6d+AjCM2FrnJXeD
         5eVHIfBrChJp7fy6vfXEN1GLV+H4GFIj95yT5fehhqf6C3QHJmQdW0AyI2Wiuv13RtSq
         BvoM5uooP0Gdt7ti18RjTL06os8iqMXkKV4og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334865; x=1693939665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ve0TvxUqRJlJKKLuvKm0zT04FAFhZiHAVMwMtJute6s=;
        b=ijMPK0ThaZtqANaWvi5QgdaeJowfQhNPP0RmT2y/C44xnnexmS9pK+uMOyJY4tFWMs
         UMN3cFJFHB2XfUrpA9ZrbINpexONm5Jx+BmFH7dkso/ToYwZBYP+Jy9/D60oIRggPEyG
         8ewlzSUMt+lA/2Tm+KZ9zU5rMqWnj2Nyz6FKO5KjGykh3a4x+6Eu1gA2yuN8sOCrhl4u
         awJiux9UsV8GufLfs5Sbvm3t5ny5gm57n/sirqFbF+gxN5j18xL+EXzHYzyZEQuo6ilB
         5bXfqPdUFUskheTVbsushQvkPer0QK2dPBtOM5Ivt9tJ97m/ZvLmN7RHKNeBBf3ol30k
         n2SQ==
X-Gm-Message-State: AOJu0Yyc/CBnAOpoQWrR3lRBW9MfdxW3DfGPV0yoHZw2TNl5KlrGzc3y
	CdFFDcgvfJSauxpnJMtrwj4RDg==
X-Google-Smtp-Source: AGHT+IFHhHBo9Psybc2YARcz0/PoU0jc98gokAT1BEhXgw2zEOZ3HQ6Fpg6TBh2Spzq6LjBiUstieA==
X-Received: by 2002:a17:902:ec8d:b0:1bc:69d0:a024 with SMTP id x13-20020a170902ec8d00b001bc69d0a024mr31142802plg.33.1693334865380;
        Tue, 29 Aug 2023 11:47:45 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:44 -0700 (PDT)
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
Subject: [PATCH 4/7] drm/msm/dp: Remove aux_cfg_update_done and related code
Date: Tue, 29 Aug 2023 11:47:29 -0700
Message-ID: <20230829184735.2841739-5-swboyd@chromium.org>
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

The member 'aux_cfg_update_done' is always false. This is dead code that
never runs. Remove it.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 9fb4e963fefb..0893522ae158 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -17,7 +17,6 @@ struct dp_panel_private {
 	struct dp_link *link;
 	struct dp_catalog *catalog;
 	bool panel_on;
-	bool aux_cfg_update_done;
 };
 
 static void dp_panel_read_psr_cap(struct dp_panel_private *panel)
@@ -177,19 +176,6 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 		}
 	}
 
-	if (panel->aux_cfg_update_done) {
-		drm_dbg_dp(panel->drm_dev,
-				"read DPCD with updated AUX config\n");
-		rc = dp_panel_read_dpcd(dp_panel);
-		bw_code = drm_dp_link_rate_to_bw_code(dp_panel->link_info.rate);
-		if (rc || !is_link_rate_valid(bw_code) ||
-			!is_lane_count_valid(dp_panel->link_info.num_lanes)
-			|| (bw_code > dp_panel->max_bw_code)) {
-			DRM_ERROR("read dpcd failed %d\n", rc);
-			return rc;
-		}
-		panel->aux_cfg_update_done = false;
-	}
 end:
 	return rc;
 }
@@ -434,7 +420,6 @@ struct dp_panel *dp_panel_get(struct dp_panel_in *in)
 
 	dp_panel = &panel->dp_panel;
 	dp_panel->max_bw_code = DP_LINK_BW_8_1;
-	panel->aux_cfg_update_done = false;
 
 	return dp_panel;
 }
-- 
https://chromeos.dev


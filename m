Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F8C1643E
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:47 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-68c3ec0578bso2182064b3a.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334867; x=1693939667; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buOYirvM4LTz9UY1JGw3dQAfNg4ODZnJm46kyV7UDeA=;
        b=RmqUUdEsd8KLVm8Crdrj2R3E6KyuLUXmQkihLvPG0W68btyJJbTgStXOmQxqkvTnro
         JLO0VrzAaUMscc5Lu7S23SMHPNu2z+u7lFR9om/FKOKyJitB0PPRp+hEFsVrO7omNH6Z
         +NHWSzAZITsOnAmolrkVeJSkoCwxeMIrDaAtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334867; x=1693939667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buOYirvM4LTz9UY1JGw3dQAfNg4ODZnJm46kyV7UDeA=;
        b=i8FYM54q1TlCepeKewNO17A9ydCTPbxKg3Ge4ydlmgfsZwf0h48YP9KPnbIkbpLZOu
         xV5DpUqJzbEUKXQW3edET9Tc4zK8DYvTTUJG+NZNDzM2tm5B+H8nORsXjJdjMX6ga73K
         whlpp5ocEWclsIpLtaWtehMcSCQXfZkhby/AiIUE6kuhVtCAJMGFu9yk9X3xL0iPo+hT
         5bOmW9ROBrBq1GMeel7num1YsVbT3DEmVByoNmZz4yvhl0qEBD5mQj+amC+qCy2nRBSe
         uRQNvast0yYRcivshp7Ks4/iytgQW1Wqo2jhPJr+wE0JF+UEdH4GpAkL0wt2l90k3PUC
         DLog==
X-Gm-Message-State: AOJu0Yw41+7ucs8D0M0bd8/Crt5HMpQaJOerV5ZvjEThTFj7RKg719oa
	HExhP3KeQgaABsHiKVLvvxpcgg==
X-Google-Smtp-Source: AGHT+IGoA9R8jy+DLGU8vBrurRLkpQ3/Zg84i8rJk8UcpO+wc/82SKC/x3KJjnmNJ9rfBhL040LnrA==
X-Received: by 2002:a05:6a20:729d:b0:140:4563:2243 with SMTP id o29-20020a056a20729d00b0014045632243mr138196pzk.50.1693334866790;
        Tue, 29 Aug 2023 11:47:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:46 -0700 (PDT)
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
Subject: [PATCH 5/7] drm/msm/dp: Simplify with drm_dp_{max_link_rate,max_lane_count}()
Date: Tue, 29 Aug 2023 11:47:30 -0700
Message-ID: <20230829184735.2841739-6-swboyd@chromium.org>
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

These are open-coded versions of common functions. Replace them with the
common code to improve readability.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 0893522ae158..97ba41593820 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -58,8 +58,8 @@ static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
 	major = (link_info->revision >> 4) & 0x0f;
 	minor = link_info->revision & 0x0f;
 
-	link_info->rate = drm_dp_bw_code_to_link_rate(dpcd[DP_MAX_LINK_RATE]);
-	link_info->num_lanes = dpcd[DP_MAX_LANE_COUNT] & DP_MAX_LANE_COUNT_MASK;
+	link_info->rate = drm_dp_max_link_rate(dpcd);
+	link_info->num_lanes = drm_dp_max_lane_count(dpcd);
 
 	/* Limit data lanes from data-lanes of endpoint property of dtsi */
 	if (link_info->num_lanes > dp_panel->max_dp_lanes)
-- 
https://chromeos.dev


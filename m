Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDE1643E
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:39 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c1e128135aso16287655ad.3
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334859; x=1693939659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dx+edCyWT7zKxIInG8qNdrcdM7Jww6Q6gVOtGT7ALUw=;
        b=NXBOd2mkw+gBkwUStDBV8PaGrgZhqCKwaBrY9Usk61+UBBtfDS7Uj7teurMoc22HQb
         3V5SHImgrwViJcGhvlCFMtXqOLx3dqfDPhULkiewQIPMxijOSEnXsKzFpiSIxv02jyRE
         +Jf3CDHT970kefX0aposB1huf8Yi6tErzFupQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334859; x=1693939659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dx+edCyWT7zKxIInG8qNdrcdM7Jww6Q6gVOtGT7ALUw=;
        b=ic8bYfyLXdopHx6YSb3MwG/acu2CiakTVW5SRfIQ6hYnonIJc0Ghp6OET/NEp/uMWJ
         o/XA0mV/4Vkj2i4Sw8Kj8WnKRGs3m810qaia7NQ2veGiaX+5k70AdPYZaNab0QCTeIeF
         JM1Oxu1UATK2GTzcsWe1hpAxAaf5GFQxoM4caVeWJF7YDOlwrxlnjrdlMcav+w3lBlfj
         ifcsjxRVXdzpGIialmE0qapcaoz4l7tlc46PCML8cPEAdIPq9NJGZiEz/P0G4+J8pQBT
         305B7d5y+7aTs3FZv6e4Yh/7OkIXhKQo6qcf9Q0TlZb1HOkuzXb1Qh5AjV1YZOcUBaAa
         fkLA==
X-Gm-Message-State: AOJu0YwBVk7DJPTCTnqjgzShL5oGqeFU9KVUjc5BcIAkUWMuTPsln41v
	iiak2Scu+DVAEJfqFgX56xmtRw==
X-Google-Smtp-Source: AGHT+IES+SJEkk4EUF9mvR0kkp/iKD9S9fLPoptNHth9XsbuVQ5O48L+bHDHC/h6NFzIK11AbzCyfA==
X-Received: by 2002:a17:903:1205:b0:1c2:54c:8beb with SMTP id l5-20020a170903120500b001c2054c8bebmr1955615plh.31.1693334858992;
        Tue, 29 Aug 2023 11:47:38 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:38 -0700 (PDT)
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
Subject: [PATCH 0/7] drm/msm/dp: Simplify DPCD related code with helpers
Date: Tue, 29 Aug 2023 11:47:25 -0700
Message-ID: <20230829184735.2841739-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver open-codes a few of the DPCD register reads when it can be
simplified by using the helpers instead. This series reworks the MSM DP
driver to use the DPCD helpers and removes some dead code along the way.
There's the potential for even more code reduction around the test
registers, but I haven't tried to do that yet.

Stephen Boyd (7):
  drm/msm/dp: Replace open-coded drm_dp_read_dpcd_caps()
  drm/msm/dp: Use drm_dp_read_sink_count() helper
  drm/msm/dp: Remove dead code related to downstream cap info
  drm/msm/dp: Remove aux_cfg_update_done and related code
  drm/msm/dp: Simplify with drm_dp_{max_link_rate,max_lane_count}()
  drm/msm/dp: Inline dp_link_parse_sink_count()
  drm/msm/dp: Remove dp_display_is_ds_bridge()

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>

 drivers/gpu/drm/msm/dp/dp_display.c |   9 +--
 drivers/gpu/drm/msm/dp/dp_link.c    |  38 +---------
 drivers/gpu/drm/msm/dp/dp_panel.c   | 105 +++++-----------------------
 drivers/gpu/drm/msm/dp/dp_panel.h   |  10 +--
 4 files changed, 22 insertions(+), 140 deletions(-)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
-- 
https://chromeos.dev


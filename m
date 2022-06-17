Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E02F4E
	for <patches@lists.linux.dev>; Fri, 17 Jun 2022 20:47:52 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id h192so4976323pgc.4
        for <patches@lists.linux.dev>; Fri, 17 Jun 2022 13:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cthRoKdZynlo7BCJhn2Mvx9FZ9+o8uogeaq20GblQQw=;
        b=nFsBmKmNn+/h8yDv9MpPAjH4ATR3q3Bz0cTI1gh6q7RWGlJq4k9RjlPLJhAYwTAS7p
         fH5Fgfn9tn1XPnw9u35HLDbshjkuLhEvjrdZr3iu2LgriDyOCphiKdNeMNC7ODk7XZo4
         IhYcHQs0mlvPPg1IIzhMtZVfOcaenKJqoL5ZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cthRoKdZynlo7BCJhn2Mvx9FZ9+o8uogeaq20GblQQw=;
        b=CD2ZOnLCexFQStEusNDGlaKTZJA6XpA/OgkfijYAO6B/N4LCUx+VCbXRA9H3xTjvZV
         MOu6cF/OdRG3MHnD0a9f2V/enDgHixzx+5lSVvrvs4MQbrnQoYEPUNu5fLvKvcBIgzJu
         PfQve7BSV8VTSoDKx49oP2Gzaw7ymjWkJQm2gscr6/LBbaVrU62UItIhTaS/GbWuzoYW
         gufWM2cEl+5Ihveadn3IQquat7WCEzmaeQnXgrg9dM+KDlw6CFSaY1VFtiHlpsvpOfuG
         mEm2hnV1c4lZOQkQtCwHHweBSCG3q9+A3E/Ac3At6b4OXY7Fm16sbPp7w6QND0gywCko
         kP2w==
X-Gm-Message-State: AJIora9FxTIt5WODo8JUsJl13MCzQlWpAD0fgebEWVCW+QyQdEttNxUU
	eKVFNzCGFL7VpnvuxzYXqTK7Rw==
X-Google-Smtp-Source: AGRyM1s2KT9lZnLB+hTEDMQKftAyY/9OYB52Ihl7t/kjRy+fLlR2MbQtggQk9rA7rcrF+PobFUc2tg==
X-Received: by 2002:a63:6f8d:0:b0:408:c049:aaf1 with SMTP id k135-20020a636f8d000000b00408c049aaf1mr10554739pgc.199.1655498872314;
        Fri, 17 Jun 2022 13:47:52 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:52e2:7dc8:1e20:f870])
        by smtp.gmail.com with ESMTPSA id z12-20020aa79f8c000000b0052089e1b88esm4098325pfr.192.2022.06.17.13.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:47:51 -0700 (PDT)
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
Subject: [PATCH 0/3] drm/msm/dp: More cleanups for force link train
Date: Fri, 17 Jun 2022 13:47:47 -0700
Message-Id: <20220617204750.2347797-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches do a little cleanup on the v9 patch from Kuogee.

Stephen Boyd (3):
  drm/msm/dp: Reorganize code to avoid forward declaration
  drm/msm/dp: Remove pixel_rate from struct dp_ctrl
  drm/msm/dp: Get rid of dp_ctrl_on_stream_phy_test_report()

 drivers/gpu/drm/msm/dp/dp_ctrl.c | 145 ++++++++++++++-----------------
 drivers/gpu/drm/msm/dp/dp_ctrl.h |   1 -
 2 files changed, 65 insertions(+), 81 deletions(-)

[1] https://lore.kernel.org/r/1655411200-7255-1-git-send-email-quic_khsieh@quicinc.com

base-commit: 9639746eebb13068dc9de6f436151bd88da2b827
prerequisite-patch-id: 2fc33a2830ec84d922023fddb585728c48a59525
-- 
https://chromeos.dev


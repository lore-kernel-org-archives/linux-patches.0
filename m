Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5467EE
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 02:43:59 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 73so11072035pgb.9
        for <patches@lists.linux.dev>; Mon, 22 Aug 2022 19:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=PynmO5Jk7dMLlFmc4BJabIpYsmxogYHpegMgoaOMSq4=;
        b=MabqGyxwHR/rSORTB7TeITLkNwTwRIAZ0fWVRA14qsIbhD91j0WkB+KTPJh+TjKtd2
         Kfa/Xj/wbblHUFxT3lmhHujC6EqGMMnjAQ3hmAZxYdBihPag2jQXaLyIJcrSAKvbZUEx
         3FHOEZdXgHO8p5RN4ENZM0QcmNDqOThrG57A0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=PynmO5Jk7dMLlFmc4BJabIpYsmxogYHpegMgoaOMSq4=;
        b=nOkgtY1czYAj8xX3o1ZILW/GQpSofA4IRFZVld+J3TvqjTr8gv8oWnybKgbstD2QzI
         lFp6qnAMt9X6Gj+nIT4xPP5cdT2fq5eEXsFK9K6uXjxHodzZ9502+1F56amWN7TOmNKb
         tKblXNOOzipLC/go3TX8dkj6fLApEG00NLYcdMiEii92psjiHu1IaCUewRyRLIym+odv
         N6oYPt+JlFPE3JTuFB6ibFIv6UHnzVPXJaL8Ku9oBSSNa8wK/aQ3nAtigV+vpGOWiqm2
         W/oXMhZB/DT6WfqPSLovy24P9MiZ2+geAT2c2vExWOfxgoeDAmZlltguxeuat8bYyvGk
         Vagg==
X-Gm-Message-State: ACgBeo0s9u1E+BCIFOqVOWjVPMhfhP0Ib8ax7iiDxToRpCeokOjHyJna
	gvPGoHKQH1oOGTC7YI1v/F5n3g==
X-Google-Smtp-Source: AA6agR72B2tpzoHRr2X1icCS5N1hJfZlnCktZgRksrhuGPX7UJF1L2xySUvV0LfAKMWPy7NvsdM88Q==
X-Received: by 2002:a62:be0e:0:b0:536:76fe:ee96 with SMTP id l14-20020a62be0e000000b0053676feee96mr8956523pff.44.1661222639316;
        Mon, 22 Aug 2022 19:43:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:14dd:44db:a286:d093])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b001728eb339e2sm9140538plh.286.2022.08.22.19.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 19:43:58 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sean Paul <sean@poorly.run>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] drm/msm/dp: Silence inconsistent indent warning
Date: Mon, 22 Aug 2022 19:43:56 -0700
Message-Id: <20220823024356.783318-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Build robots complain

 smatch warnings:
 drivers/gpu/drm/msm/dp/dp_link.c:969 dp_link_process_link_status_update() warn: inconsistent indenting

Fix it.

Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Fixes: ea530388e64b ("drm/msm/dp: skip checking LINK_STATUS_UPDATED bit")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_link.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 36f0af02749f..1620110806cf 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -965,8 +965,7 @@ static int dp_link_process_link_status_update(struct dp_link_private *link)
 	if (channel_eq_done && clock_recovery_done)
 		return -EINVAL;
 
-
-       return 0;
+	return 0;
 }
 
 /**

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
https://chromeos.dev


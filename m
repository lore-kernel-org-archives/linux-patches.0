Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABB618B0E
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 23:01:13 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bee82fad0fso10973795ad.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 16:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693004473; x=1693609273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IRTyWDBK1um2dub2uCRhljhMZPNFPjV3AO6WOp/mvBA=;
        b=jhsR+9LbG+Ou958P7E+9XQk3NWBxZyvL08H58dOJFMpUbywkYDZuTJiRYqvl6aRWuZ
         ZWu9s/VR8KOtt4TmPta7k9Ii0sbMJEWVEX92p3BZ5Q3axWxD0EJaGZ+Q2g5QflyiOCdz
         K6TFEGZnXS0pu/yaXvvYJN1OTOVbmRLoP1Lcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004473; x=1693609273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IRTyWDBK1um2dub2uCRhljhMZPNFPjV3AO6WOp/mvBA=;
        b=crQu8zrw3FsidIlv7T+e5HpMgcF98R18rsUCrAA+JD8dMPAT5aSgKhBer2zr951dxO
         +aZ6h8BVLSpfqj1LFsN2RpfI8X2mV/IEcUlQeZmXx+mJuEzXFPy8j9Bg95sJnw0SSXcY
         ZYQVbHSW8YyYg1txxB7TzzgB5U9Asj6H9RWJWZ4t/zRJjNsTcnw7Zsk2QrlmZn02nCD+
         SNTodYTvGPi46t2XRLKN6YFIuhu4UByclMoiOM2IRNzQTHN48S2IcoaZEU7rlsHM9YGi
         BUDmLbbDwjYq90vZG9g2oO0FfdZBwv6ODwRga5jBxIOcDl1fqxq+vsiihELyCeLHddia
         i0JQ==
X-Gm-Message-State: AOJu0YzmZe/eConoepqXwuUi2Y/r91NQvjwykjB5ZVb4YQvRqErRIDii
	uEqkjb0fFpZqtYrhv0xAeqV6kNxjhSr9x2wsQBQ=
X-Google-Smtp-Source: AGHT+IFzWclzxaj4YjkShuNK7rHT+Q1ZnPtkApoHCwgpQ4ybP7Ay3vwlvDyjy6qd5fa/B4Eoo/zG4Q==
X-Received: by 2002:a17:903:32c6:b0:1c0:a8cb:b61d with SMTP id i6-20020a17090332c600b001c0a8cbb61dmr11484872plr.34.1693004472806;
        Fri, 25 Aug 2023 16:01:12 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d711:d7a0:fa61:8f24])
        by smtp.gmail.com with ESMTPSA id z12-20020a1709027e8c00b001bf044dc1a6sm2330059pla.39.2023.08.25.16.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 16:01:12 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Vinod Polimera <quic_vpolimer@quicinc.com>
Subject: [PATCH] drm/msm/dp: Add newlines to debug printks
Date: Fri, 25 Aug 2023 16:01:08 -0700
Message-ID: <20230825230109.2264345-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These debug printks are missing newlines, causing drm debug logs to be
hard to read. Add newlines so that the messages are on their own line.

Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 42427129acea..6375daaeb98e 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -1090,7 +1090,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 	} else if (dp_link_read_psr_error_status(link)) {
 		DRM_ERROR("PSR IRQ_HPD received\n");
 	} else if (dp_link_psr_capability_changed(link)) {
-		drm_dbg_dp(link->drm_dev, "PSR Capability changed");
+		drm_dbg_dp(link->drm_dev, "PSR Capability changed\n");
 	} else {
 		ret = dp_link_process_link_status_update(link);
 		if (!ret) {
@@ -1107,7 +1107,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 		}
 	}
 
-	drm_dbg_dp(link->drm_dev, "sink request=%#x",
+	drm_dbg_dp(link->drm_dev, "sink request=%#x\n",
 				dp_link->sink_request);
 	return ret;
 }

base-commit: 706a741595047797872e669b3101429ab8d378ef
-- 
https://chromeos.dev


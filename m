Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BF911192
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:12:32 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-565334377d0so132331a12.2
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023952; x=1694628752; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gX80LwLt7yqAMwtFkIm6jGbzuAJp27nwGBhP1SlyP8=;
        b=Vb8HbzOngZ197kXz7WXC0fAM9WErxPHXLVEzrD19wROsvv7ifg9xQnBGQfQgN8IH2s
         4wtUAEDeDg0B7gklN00ApewvbdeLoPzieqWa71rr7pAUmX/+l098aHYqtr6EIcfbpEJ/
         EmB+hbMlRbyNlQyN00M14BWCeminCbj1+AGvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023952; x=1694628752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3gX80LwLt7yqAMwtFkIm6jGbzuAJp27nwGBhP1SlyP8=;
        b=mBRuhtYhSPsAQjeQnLxVmBjzaeC4531xDcYhVguxq5TChuZVutE37xrnQYespdxIHe
         QOor+bFygDBcmDGZJQXgQsOpWGN+Q18cfBiLp2saVcalsFuu3cgVOJ/gpuHJAJslvHFf
         Yu49fAu+SqJdJBVDSjwvEhtMAKk/REAxccKCVqA9Ftb2c3fTrIneVN/qLI4SMa3WeLgT
         AxMUYWjfNc6n4XPe0FpcBIqJekfNAsRxg/143n1tBXbG57ospsYQqXX8XMmb/UwGo3vc
         N9Ce+MwUuhry1aekBaVR2gcMpd90274s3rPpItuyL5c55ihn6ZDeUUt5vvLaXuVflmP/
         Nxeg==
X-Gm-Message-State: AOJu0YyaLRLyh8btdxYKkFapUvpXOgU5qJWgEAEKEm/UmARBWgi2e6DA
	KoUJ7Dswc99p/rAIXK34VHQxHA==
X-Google-Smtp-Source: AGHT+IHYryhBVKMRFl+PLP7r/f1UH6A77UNtFPyGP0NNScxozW3TWUyTHquM31nYS+ZjqN4OBSdKsw==
X-Received: by 2002:a05:6a20:6a04:b0:14d:f087:c0cc with SMTP id p4-20020a056a206a0400b0014df087c0ccmr21393765pzk.48.1694023951909;
        Wed, 06 Sep 2023 11:12:31 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id c10-20020a62e80a000000b0064fde7ae1ffsm11080552pfi.38.2023.09.06.11.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:12:31 -0700 (PDT)
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
Subject: [PATCH 2/2] drm/msm/dp: Remove error message when downstream port not connected
Date: Wed,  6 Sep 2023 11:12:26 -0700
Message-ID: <20230906181226.2198441-3-swboyd@chromium.org>
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

Plugging in an Apple dongle without the HDMI cable attached prints out
an error message in the kernel logs when nothing is actually wrong.

   no downstream ports connected

This is because the downstream port for the HDMI connector is not
connected, so the Apple dongle reports that as a zero sink count device.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 97ba41593820..ae778e1a6fd0 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -156,7 +156,6 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 	if (drm_dp_is_branch(dp_panel->dpcd)) {
 		count = drm_dp_read_sink_count(panel->aux);
 		if (!count) {
-			DRM_ERROR("no downstream ports connected\n");
 			panel->link->sink_count = 0;
 			return -ENOTCONN;
 		}
-- 
https://chromeos.dev


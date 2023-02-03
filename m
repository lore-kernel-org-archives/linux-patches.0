Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62183D511
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:26:21 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so10141316pjd.2
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=d9t0hT6GiqnRHp4PDpDtSjes5ppgJHVckiZj+66c3rI8mTBGp1eIr5V7jtncsLYobk
         ccIW5PqZL9jddlPKCVmZmjbI3ZuOkihTKOcN6KyekmzflS71kwrA/rfCAuyBMAQJY864
         iNMs7b1jGM70GCQlgSYZ8X2GdiGnr8cDww7gE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=stgR7ttTKaMuLzLx6dIgwyAYN0ZtcEo3swqcljD1Hda+gnLItzbaJlJyJMOW+CMOQd
         DbkI6NO5TjhFbeGkZOO6TUgujdiV2DzOqcaBmSIix2hU7IrGRCsLHbSS396D+Y+3aanH
         CD73YSEtVfRESDfxuY931HLtlJt916ATBcIFMAJY2EJ4HymeZj/nHBOo+nsOMZopAcs0
         C9UGzNJKhi7rbgnWeAkwscdbZUA49gqvUV+7/nZ4YnVbgpaKpOvfys25hCasZ532RIWt
         llFxDc9Y+/reAfb38z1QDZoXP23kByDTf7Oi+OjZYcITnmM2Jb1oZlEmmOQD11f1eHUt
         SUMg==
X-Gm-Message-State: AO0yUKW0Gch6Sxkly/f4nlFKuKaltn6sGfnIWd70PEbBo5n6MTohNRw7
	CRiKY1Od1/XYEDKgkDcFWJ2t2g==
X-Google-Smtp-Source: AK7set+RkDPC8r53YF5/SDwMLYOuXoF2Kt+2qGSlJTPwKp4XmX/yFLUkxvUaOxom+XYX0c1+8XrZfg==
X-Received: by 2002:a17:902:f0c4:b0:198:e5f7:8cf4 with SMTP id v4-20020a170902f0c400b00198e5f78cf4mr1886550pla.53.1675463180852;
        Fri, 03 Feb 2023 14:26:20 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:20 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 1/5] phy: qcom-qmp-combo: disable runtime PM on unbind
Date: Fri,  3 Feb 2023 14:26:12 -0800
Message-Id: <20230203222616.2935268-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
References: <20230203222616.2935268-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 4382d518d1887e62234560ea08a0203d11d28cc1 upstream.

Make sure to disable runtime PM also on driver unbind.

Fixes: ac0d239936bd ("phy: qcom-qmp: Add support for runtime PM").
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220907110728.19092-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index a9687e040960..7b7557c35af6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5740,7 +5740,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 	/*
 	 * Prevent runtime pm from being ON by default. Users can enable
 	 * it using power/control in sysfs.
@@ -5790,13 +5792,10 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QMP phy\n");
-	else
-		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 err_node_put:
-	pm_runtime_disable(dev);
 	of_node_put(child);
 	return ret;
 }
-- 
https://chromeos.dev


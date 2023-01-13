Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C2377
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:54:10 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id y1so21920011plb.2
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=Osh1B7zp7tQhU+9MxWPY/yAEEmUj1gtkg7jmpWJk9NgmbGtaRDmTSetrchIDDB96H+
         p/qRxiUkZPIgdLp122//Q4wMQJBff8z5Wllf5G5VRmLI1m4fSX5EcrMKZqaReT11PdfM
         P6fr4Mh9AH5OB+SOA9myUKG6PNEbejlcVIpio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=ECxqZ/wTaXFlvDf/EHRmulMdhn6W8/Pel7o+/cXGy4xinztiT+XoULoSyRB+k3THds
         j4K57j+KtbTL/UYfVtw+pWtr5WAipRsCRuNuKOGloKOOkBkkhGzTdDKFJkQc8dp6+Rjr
         z/R8QMmdDyjV8csw2/WD4sDro14GitzK83nLblx4Cg61HCn6dF95HkBw3/DxG2XEzcIL
         dxVYkq68MAz6fLEBTo6mK1xofylkV5bP2DU+yljjXvJZJ+A8v0ZUS3blhK8dk7QPCfLn
         Ob93PM7PA+cQWVVnoKhncsJMjXRZvCwjPT2HCuj34rgpF+PopH86WyffJ2P7njI/ZMAC
         ywyQ==
X-Gm-Message-State: AFqh2kqOBSIRFdl+JpEL9RzNqunHk2bolQs3UXbYnyzAYwbApU5q8IDQ
	IRgzqaYtz0npNpDptLO6hkb6rw==
X-Google-Smtp-Source: AMrXdXsvI3zs4GuDkNa8TpijaRhFnlRVYdPGEVTOzyqt4I2mkh0WJTBPXLb075HpeSi0t5xXkCE3Ug==
X-Received: by 2002:a05:6a20:9588:b0:b2:549c:b0eb with SMTP id iu8-20020a056a20958800b000b2549cb0ebmr99249330pzb.36.1673571249545;
        Thu, 12 Jan 2023 16:54:09 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:08 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 1/4] phy: qcom-qmp-combo: disable runtime PM on unbind
Date: Thu, 12 Jan 2023 16:54:02 -0800
Message-Id: <20230113005405.3992011-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113005405.3992011-1-swboyd@chromium.org>
References: <20230113005405.3992011-1-swboyd@chromium.org>
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


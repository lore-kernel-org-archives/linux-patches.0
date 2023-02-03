Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DC7D507
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:28:23 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id b5so6729417plz.5
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gMyHt710tobXZzqB4RVOXm/lfSphZfIQDyw8A1rvqM8=;
        b=KJQTCWhAd7IPsSxTwSEdEe5ccYd6PTpm9gQe4BkQOs0WlNmdWxAQxrM8F0aHiu25In
         0386XN/L0AG/jmBhyONVoBbYBvi5VNUa6YG27G3cZnsLDOCeubj2Fjew82Ab9wI5dFm9
         1JfI/nmp3tNTYA0zPEKeDUbvR5uVXlIKAwp+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMyHt710tobXZzqB4RVOXm/lfSphZfIQDyw8A1rvqM8=;
        b=fDBWTbumJIPjy1WvQu3cN7LLonJIsseY7dney9gHoDB22Lg6iLlPnL8pkAZwqa7qTz
         38STgesnSjjX2+CM+WsTcmhG1uxbNWiAXuRU1tO89OpPYdsJlp1xZUxlx9vwzlPW+T8E
         fo9s5vHBq+qPuexhfgimLUcNRIeXo6jAm5JiDLRdEuwH6QP7pN8JMOd5gS0DGCw/dPfS
         QpndjntvjfXrF2CoSCieXFD2Tp5ItyoLKZ1m/cBguQ9PkeSH/y+lVuyAyljQB770fjms
         PTGVOlvwGiq6YnYXeBcm9FWCJ6HMLIz80yWm0FOp1rB9AXud1QMa6T/lUYhFSrYmp+QR
         I3mA==
X-Gm-Message-State: AO0yUKUMDW5KcIdwrva2E1tj/6l8WqTIAWiPo1MBHxT4kVQMYDWkXFwa
	qV6xTuRnJPG87hkqK8L+Ee9nlw==
X-Google-Smtp-Source: AK7set//yln2V1DGJdDa8X2Q3rBGRrmvfMdT9UHoD5EABS+sltirE42ArLrbAQz68gi6qCTk07lZkQ==
X-Received: by 2002:a17:903:30d2:b0:195:efa7:d54e with SMTP id s18-20020a17090330d200b00195efa7d54emr4510904plc.12.1675463303088;
        Fri, 03 Feb 2023 14:28:23 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id u65-20020a627944000000b0058da56167b7sm2333853pfc.127.2023.02.03.14.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:28:22 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1.y] phy: qcom-qmp-combo: fix runtime suspend
Date: Fri,  3 Feb 2023 14:28:20 -0800
Message-Id: <20230203222820.2958983-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.

Drop the confused runtime-suspend type check which effectively broke
runtime PM if the DP child node happens to be parsed before the USB
child node during probe (e.g. due to order of child nodes in the
devicetree).

Instead use the new driver data USB PHY pointer to access the USB
configuration and resources.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index adcda7762acf..816829105135 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2296,15 +2296,11 @@ static void qmp_combo_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
@@ -2321,16 +2317,12 @@ static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 static int __maybe_unused qmp_combo_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;

base-commit: 68a95455c153f8adc513e5b688f4b348daa7c1b1
-- 
https://chromeos.dev


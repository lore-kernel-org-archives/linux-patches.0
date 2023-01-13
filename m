Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D248BA3A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 20:46:00 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id bj3so20344556pjb.0
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBi2/qyUC845LFRzXkZZ02iiz+01kFcIC3Wu67immxs=;
        b=kRx8bFUPs6e81RW6/OJxTlgFo1g1CRAgsbMtDsiYYz1TT8RfZ5L10WQk0D1yMzb6oz
         1SPZhnB2GsQ9u9XBeFaUxrlxcIU6mAsuURwLUKKIkirlrAt5lGd7cOQJUibEOaodzeu2
         douiBjk0yrxsKBHiaoNilKGx0iiaJybztmtqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HBi2/qyUC845LFRzXkZZ02iiz+01kFcIC3Wu67immxs=;
        b=QUhwcrXWrB8w+ZLeOkYArO3t4GEpO1V6CvWeoE01VflI0Cm49S3FV3PmEElwvyWEdt
         z/dttXLA88yS7RH77kEqw4bvcaBYQoGeqbwHHTtjs7B2iGaRNl+tQUsIDRTaD6oRlmFL
         4GUtVZeFocGNmm6RsA0mVlSDh3tBLhykX5EKVuQWzp7r8ixgEgcJlw/TowojZ0ASYiP5
         rIYEPvqOPAeVTWMVd1aqtKcZ4ze7tOQpneOOYlAwDYJIsJVSg0KtnTN6dvAOWmW1Rfsm
         FTIs3MyviEp07LzrGFEjeDmc/V2wacMi2maNof3Fv5SirKi+3yoftt6PgUgZocXE+Lqe
         834Q==
X-Gm-Message-State: AFqh2kpy7gkDwKbejcBHu3PyC18wztdKfvCwg8kXAegI4ZaZsBpNZTUR
	9dARmTg0f587A40ZQUvjG++FNn80s1JYnB6q
X-Google-Smtp-Source: AMrXdXsf6LhytMMpI9hgTdoKV3tVJYPmL/AlUKNgDNZqknFWYgZVH1aN/OnaJq2PKABVv+k5Fo8pIQ==
X-Received: by 2002:a17:902:c454:b0:192:b52f:33bb with SMTP id m20-20020a170902c45400b00192b52f33bbmr9843370plm.45.1673642759860;
        Fri, 13 Jan 2023 12:45:59 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:59 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 5/5] phy: qcom-qmp-combo: fix runtime suspend
Date: Fri, 13 Jan 2023 12:45:48 -0800
Message-Id: <20230113204548.578798-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113204548.578798-1-swboyd@chromium.org>
References: <20230113204548.578798-1-swboyd@chromium.org>
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
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index b8646eaf1767..64a42e28e99f 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
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
@@ -5010,16 +5006,12 @@ static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
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
-- 
https://chromeos.dev


Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392AD1A239F
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 01:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736299739; cv=none; b=eJR+UTdhq+lAu51dEruKX7Hp6Dw+8wTKrgNKH5HNhjJ+m4Kvsdtrt48E4Yb9ozB610oT8rs5g/IIG6KkhZMWqxsqandBmsvDbsrLbV3bJz4lAj9RV9C6Npxi2+2VR04K2PQjVTKdsK+te4Cc8kfe19B84X0cNqharaG01mCZgPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736299739; c=relaxed/simple;
	bh=ZPZ1RvYh2kO8gp/HE4ITCITiJwPeiYCbTgy1PyW8+MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2uiRjTgiRTxoGlKHkKNDpSbudeuu1W0WFuz1SF6c3Ql0ElYNfyTVMhQEYHcmv2wL09KaIEIsuNrTTjJQsvBieGDZKea9jMTNDqFaQk/8DQCkBHikqYBRiiPZRiAwPomO7s6Jer5jYTjyJtKNirkQPlivAT4pHry+1ngk+y+kus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=nVdRqvUL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nVdRqvUL"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21619108a6bso223784575ad.3
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 17:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736299736; x=1736904536; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2PH+YeR0bEBhGOmEQodK+uTa/B+QOdEM0hw2aypokE=;
        b=nVdRqvULKky0dotFuy3NzyGvoEOm5tI5p8CIFZgas3nFeuoe8R3wPPFynWmDZWfIH1
         QjkzREKFAVEXmfwAI12KJTEM/nR/Z7+y+2BwDpH/9jSYezbxIWZNFjomcl74MYM5qDuF
         GR+Yl3sJVfjIH7eBpwrQQepZafXe23lJ9DoDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736299736; x=1736904536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2PH+YeR0bEBhGOmEQodK+uTa/B+QOdEM0hw2aypokE=;
        b=WPuw1c5PvPZMx7SPQeGl0F1ADtxu8kv0Eb6GyDteyO/bqvDyhcUu2SO9ez6ZvXfyMs
         rGImdTrDtYF2VP/vLzujURH+k9YEfkFChW+APIWRxUByi408wVAOvOTrcNEQIeF9CdtN
         Kx1WFTeNEVmw5E5lcc0YxXEa8uaqVrd0DVI9WwoewV8+ESj5QmzYHd91qfLsGORgZap+
         sWilPklbbesrQc0W1EKtiMz+4zrGTSWdb8MFbpGG1/QzBWLerkV/ZbBBU6ZDrX2MMWD8
         PKPkQzkFZ+cuhIIVjgQ0JSrSjXJUkKPxWCjjevlSTXN/tp7g2EtvE0E+qGAp0duUjcXG
         Ufww==
X-Forwarded-Encrypted: i=1; AJvYcCW4BrL/RMQt6E5ODMgOFPPimBdYJAKsxIMwEb98D9tXiXtFf1t7BwXkpZFs6EG1tZLREBGc6YKn@lists.linux.dev
X-Gm-Message-State: AOJu0YyLt7RPasnUToGjE5sJR4x/qs4PDJYxgAnw4ow8a5bOf57HVzPZ
	7s1eEgQYcLHAh7qxjmlCQIp7akn2RHVKdHm1Cry9FeWMcqan09sGH0/V2oRILA==
X-Gm-Gg: ASbGncugfMiAr2L2eDV/bq8DjRj7go/CSYYcBYUrdwI+hF2OH8zYRBfVqDasa4Bmocb
	YGEEOtlGV5ZMLsM7OnffDQmrX6JrEHxX2ikb9JQknqKINWI+IRrzQoPI/fx76zpAnAOKL9EYNDJ
	1cDUdWAjNKVM9qSTr0jrmjrggmnm4dtzYlc70mH04OJzRe3bC8nwDX7CwUpzB9lkLS6kMEyETgb
	spMWMLBwK9K+5CTURSUbPlMYwWgZLcne3BcZA3N+1Ohaboqc2agMWXi1J+s9v8Tro9btnjAN5Tc
	bqruJ2hTYsZa6+UniLhK
X-Google-Smtp-Source: AGHT+IEPnKUCG2gblLZlLZNHyLGaKfpBR0RoXfdx9u2gcf5pTAWqsgbyihyLPhCZcWcNvOkJsoUDRw==
X-Received: by 2002:a17:903:2311:b0:215:a2e2:53ff with SMTP id d9443c01a7336-21a83f36e1dmr16501155ad.11.1736299736529;
        Tue, 07 Jan 2025 17:28:56 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-219dc962cf4sm316325925ad.25.2025.01.07.17.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 17:28:56 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: [RFC PATCH 5/6] bus: qcom-sc7180: Attach pm domain to watchdog device
Date: Tue,  7 Jan 2025 17:28:42 -0800
Message-ID: <20250108012846.3275443-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
In-Reply-To: <20250108012846.3275443-1-swboyd@chromium.org>
References: <20250108012846.3275443-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Find the watchdog device described as a child node of the sc7180 SoC
node and attach a generic pm domain to the device before registering the
device with the platform bus. The domain simply gets the clk and turns
it on when the pm domain is powered on and turns it off when the pm
domain is powered off.

Cc: Rob Herring <robh@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/bus/qcom/qcom-sc7180.c | 122 +++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/bus/qcom/qcom-sc7180.c b/drivers/bus/qcom/qcom-sc7180.c
index a615cf5a2129..7dfe6b32efef 100644
--- a/drivers/bus/qcom/qcom-sc7180.c
+++ b/drivers/bus/qcom/qcom-sc7180.c
@@ -3,18 +3,140 @@
  * SoC bus driver for Qualcomm SC7180 SoCs
  */
 
+#include <linux/cleanup.h>
+#include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/dev_printk.h>
 #include <linux/init.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_domain.h>
+
+struct qcom_soc_pm_domain {
+	struct clk *clk;
+	struct generic_pm_domain pd;
+};
+
+static struct qcom_soc_pm_domain *
+gpd_to_qcom_soc_pm_domain(struct generic_pm_domain *gpd)
+{
+	return container_of(gpd, struct qcom_soc_pm_domain, pd);
+}
+
+static struct qcom_soc_pm_domain *pd_to_qcom_soc_pm_domain(struct dev_pm_domain *pd)
+{
+	struct generic_pm_domain *gpd;
+
+	gpd = container_of(pd, struct generic_pm_domain, domain);
+
+	return gpd_to_qcom_soc_pm_domain(gpd);
+}
+
+static struct qcom_soc_pm_domain *dev_to_qcom_soc_pm_domain(struct device *dev)
+{
+	struct dev_pm_domain *pd;
+
+	pd = dev->pm_domain;
+	if (!pd)
+		return NULL;
+
+	return pd_to_qcom_soc_pm_domain(pd);
+}
+
+static struct platform_device *
+qcom_soc_alloc_device(struct platform_device *socdev, const char *compatible)
+{
+	struct device_node *np __free(device_node);
+
+	np = of_get_compatible_child(socdev->dev.of_node, compatible);
+
+	return of_platform_device_alloc(np, NULL, &socdev->dev);
+}
+
+static int qcom_soc_domain_activate(struct device *dev)
+{
+	struct qcom_soc_pm_domain *soc_domain;
+
+	dev_info(dev, "Activating device\n");
+	soc_domain = dev_to_qcom_soc_pm_domain(dev);
+
+	soc_domain->clk = devm_clk_get(dev, NULL);
+
+	return PTR_ERR_OR_ZERO(soc_domain->clk);
+}
+
+static int qcom_soc_domain_power_on(struct generic_pm_domain *domain)
+{
+	struct qcom_soc_pm_domain *soc_domain;
+
+	pr_info("Powering on device\n");
+	soc_domain = gpd_to_qcom_soc_pm_domain(domain);
+
+	return clk_prepare_enable(soc_domain->clk);
+}
+
+static int qcom_soc_domain_power_off(struct generic_pm_domain *domain)
+{
+	struct qcom_soc_pm_domain *soc_domain;
+
+	pr_info("Powering off device\n");
+	soc_domain = gpd_to_qcom_soc_pm_domain(domain);
+
+	clk_disable_unprepare(soc_domain->clk);
+
+	return 0;
+}
+
+static int qcom_soc_add_clk_domain(struct platform_device *socdev,
+				   struct platform_device *pdev)
+{
+	struct qcom_soc_pm_domain *domain;
+	struct generic_pm_domain *pd;
+	int ret;
+
+	domain = devm_kzalloc(&socdev->dev, sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return -ENOMEM;
+
+	pd = &domain->pd;
+	pd->name = "wdog";
+	ret = pm_genpd_init(pd, NULL, false);
+	if (ret)
+		return ret;
+
+	/* TODO: Wrap this in a generic_pm_domain function similar to power_on() */
+	pd->domain.activate = qcom_soc_domain_activate;
+	pd->power_on = qcom_soc_domain_power_on;
+	pd->power_off = qcom_soc_domain_power_off;
+
+	dev_info(&socdev->dev, "adding pm domain for %s\n", dev_name(&pdev->dev));
+	dev_pm_domain_set(&pdev->dev, &pd->domain);
+
+	return 0;
+}
 
 static int qcom_soc_sc7180_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	struct platform_device *sdev;
+	int ret;
+
+	sdev = qcom_soc_alloc_device(pdev, "qcom,apss-wdt-sc7180");
+	if (!sdev)
+		return dev_err_probe(dev, -ENODEV, "Failed to alloc sdev\n");
+
+	ret = qcom_soc_add_clk_domain(pdev, sdev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add clk domain to sdev\n");
+
+	ret = of_platform_device_add(sdev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add sdev to bus\n");
 
 	return of_platform_populate(np, NULL, NULL, dev);
 }
-- 
https://chromeos.dev


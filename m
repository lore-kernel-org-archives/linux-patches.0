Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F8B3C00A6;
	Thu, 15 Jan 2026 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498557; cv=none; b=lK8dBkp5olfhgyXWA4hoQ0HLXQl2fNLygM9HTDGg8GHp+h5DtkmXjn+wcbqfegwbO8S6R02K1WLySTCLebdKs4mcZezXH7rg5N3SpPNDpNC9869BJ6rMPWwpNBBPqH9f8Yrj73rEx0ptvTNIesBhAHayNdqxJa3wdrq4yR1iVwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498557; c=relaxed/simple;
	bh=0+SYvKZrGxZo/TC8wmZaNfyYu9mwR/kTYwM1QqqY9tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML+5bW6tDw1esxl6hw9jmb6qcUa2OeAvzWZgBePFLRyjwqyUGepnagLC4fFz0y0z2Z5YgE+f99VjIcjC0d9Q8ot+6k4NOzU1IkpG/dlC8nBWotVL1J3ZDTDONKolnB/93fxulrn65dZ1/YiZn3h/UZzfs+kZKm6eNOjWd5nQiNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/H28xqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/H28xqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E377EC19422;
	Thu, 15 Jan 2026 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498557;
	bh=0+SYvKZrGxZo/TC8wmZaNfyYu9mwR/kTYwM1QqqY9tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/H28xqV/aj1OSC3FjOUtc4nNfQ3T0xuaLLTu+LLzffooYWpYAUkMDliMQaGQmshi
	 W/geg4vQkMAIREf/vo8xWBn3tF/q7iLHnmNcWO8usPzxJaZ615IS2Do6Dp3qjm6pkN
	 tyHYjyXmpnm3BH3Pm4lKuYpYRYUGztyTh3tVznNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/554] pmdomain: Use device_get_match_data()
Date: Thu, 15 Jan 2026 17:49:00 +0100
Message-ID: <20260115164303.457984475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 3ba9fdfaa550936837b50b73d6c27ac401fde875 ]

Use preferred device_get_match_data() instead of of_match_device() to
get the driver match data. With this, adjust the includes to explicitly
include the correct headers.

Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20231006224614.444488-1-robh@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 73cb5f6eafb0 ("pmdomain: imx: Fix reference count leak in imx_gpc_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/actions/owl-sps.c     |   16 +++++-----------
 drivers/soc/imx/gpc.c             |    7 +++----
 drivers/soc/rockchip/pm_domains.c |   13 ++++---------
 3 files changed, 12 insertions(+), 24 deletions(-)

--- a/drivers/soc/actions/owl-sps.c
+++ b/drivers/soc/actions/owl-sps.c
@@ -8,8 +8,10 @@
  * Copyright (c) 2017 Andreas Färber
  */
 
+#include <linux/mod_devicetable.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/pm_domain.h>
 #include <linux/soc/actions/owl-sps.h>
 #include <dt-bindings/power/owl-s500-powergate.h>
@@ -96,24 +98,16 @@ static int owl_sps_init_domain(struct ow
 
 static int owl_sps_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	const struct owl_sps_info *sps_info;
 	struct owl_sps *sps;
 	int i, ret;
 
-	if (!pdev->dev.of_node) {
-		dev_err(&pdev->dev, "no device node\n");
-		return -ENODEV;
-	}
-
-	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	if (!match || !match->data) {
+	sps_info = device_get_match_data(&pdev->dev);
+	if (!sps_info) {
 		dev_err(&pdev->dev, "unknown compatible or missing data\n");
 		return -EINVAL;
 	}
 
-	sps_info = match->data;
-
 	sps = devm_kzalloc(&pdev->dev,
 			   struct_size(sps, domains, sps_info->num_domains),
 			   GFP_KERNEL);
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -7,9 +7,10 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/of_device.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 
@@ -403,9 +404,7 @@ clk_err:
 
 static int imx_gpc_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *of_id =
-			of_match_device(imx_gpc_dt_ids, &pdev->dev);
-	const struct imx_gpc_dt_data *of_id_data = of_id->data;
+	const struct imx_gpc_dt_data *of_id_data = device_get_match_data(&pdev->dev);
 	struct device_node *pgc_node;
 	struct regmap *regmap;
 	void __iomem *base;
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -8,11 +8,13 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/err.h>
+#include <linux/platform_device.h>
 #include <linux/pm_clock.h>
 #include <linux/pm_domain.h>
+#include <linux/property.h>
+#include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_clk.h>
-#include <linux/of_platform.h>
 #include <linux/clk.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
@@ -634,7 +636,6 @@ static int rockchip_pm_domain_probe(stru
 	struct device_node *node;
 	struct device *parent;
 	struct rockchip_pmu *pmu;
-	const struct of_device_id *match;
 	const struct rockchip_pmu_info *pmu_info;
 	int error;
 
@@ -643,13 +644,7 @@ static int rockchip_pm_domain_probe(stru
 		return -ENODEV;
 	}
 
-	match = of_match_device(dev->driver->of_match_table, dev);
-	if (!match || !match->data) {
-		dev_err(dev, "missing pmu data\n");
-		return -EINVAL;
-	}
-
-	pmu_info = match->data;
+	pmu_info = device_get_match_data(dev);
 
 	pmu = devm_kzalloc(dev,
 			   struct_size(pmu, domains, pmu_info->num_domains),



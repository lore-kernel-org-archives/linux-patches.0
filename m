Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969427FD43;
	Tue, 27 May 2025 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368664; cv=none; b=N6GpXuldmmhFE7piCDWg4WxM3dIeBbQAjaFf4BuRnDaT6GopWLpn2UXsxpZtqxM/iTUPK1uVVtegw/4L8IPEoOSuXRSEozOJLYNWyQhFg2EltcTfOCC10c3m4q3c7nLwBeEorxznc1G/RF3J9KOAIzVxy8uJU+LkTfGO92Qa9O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368664; c=relaxed/simple;
	bh=VY4xkZOztDrceP/ODM8BjXwx5N4AZyDC8eJR7VqaZUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw2O8LLB17rBZH3VZPQg1RVzbSXJcbiUTCdnb1/fRlvxa6r0a8B0h+c33niYgI2+K9vN/zXd/F1tmK7kxHknFzMeM7fk2s52H1K/Pnc5grbzS2akC9Xj13DK00gE1wqxejJGBoTMgp+ZA9VklOSwvh6Wm9KPWDTRwalRSmv9jRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQWgBmf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQWgBmf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0805C4CEE9;
	Tue, 27 May 2025 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368664;
	bh=VY4xkZOztDrceP/ODM8BjXwx5N4AZyDC8eJR7VqaZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQWgBmf0UK13GxkK4RoEAWPRgUz4FLGhjklSBEdsReRyJlaUHE7W++GNAVUgN3ihL
	 fJkEvBa4kNvg0czXTXsk4OKfg+okKiAqH+mS7b+DFEYJo6+Te601rDhAa8qJtdP78L
	 jbEOnpSCMWMWxfHF1zXVebZ9ySOCw5koIMGoSjIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.14 739/783] mmc: sdhci_am654: Add SDHCI_QUIRK2_SUPPRESS_V1P8_ENA quirk to am62 compatible
Date: Tue, 27 May 2025 18:28:56 +0200
Message-ID: <20250527162543.222727845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 71c9475b1e2cc4d31370b1b7a328bdfeea5d53b4 upstream.

Add a new struct for platform data for the ti,am62-sdhci compatible to
apply additional quirks, namely "SDHCI_QUIRK2_SUPPRESS_V1P8_ENA", to
host controllers with am62 compatible.

Note, the fix was originally introduced by commit 941a7abd4666
("mmc: sdhci_am654: Add sdhci_am654_start_signal_voltage_switch") but was
found to be applied too broadly and had to be reverted.

This fixes MMC init failures seen across am62x boards.

Fixes: ac5a41b472b4 ("Revert "mmc: sdhci_am654: Add sdhci_am654_start_signal_voltage_switch"")
Fixes: 941a7abd4666 ("mmc: sdhci_am654: Add sdhci_am654_start_signal_voltage_switch")
Cc: stable@vger.kernel.org
Suggested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250516203121.3736379-1-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -155,6 +155,7 @@ struct sdhci_am654_data {
 	u32 tuning_loop;
 
 #define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
+#define SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA BIT(1)
 };
 
 struct window {
@@ -166,6 +167,7 @@ struct window {
 struct sdhci_am654_driver_data {
 	const struct sdhci_pltfm_data *pdata;
 	u32 flags;
+	u32 quirks;
 #define IOMUX_PRESENT	(1 << 0)
 #define FREQSEL_2_BIT	(1 << 1)
 #define STRBSEL_4_BIT	(1 << 2)
@@ -356,6 +358,29 @@ static void sdhci_j721e_4bit_set_clock(s
 	sdhci_set_clock(host, clock);
 }
 
+static int sdhci_am654_start_signal_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
+	int ret;
+
+	if ((sdhci_am654->quirks & SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA) &&
+	    ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180) {
+		if (!IS_ERR(mmc->supply.vqmmc)) {
+			ret = mmc_regulator_set_vqmmc(mmc, ios);
+			if (ret < 0) {
+				pr_err("%s: Switching to 1.8V signalling voltage failed,\n",
+				       mmc_hostname(mmc));
+				return -EIO;
+			}
+		}
+		return 0;
+	}
+
+	return sdhci_start_signal_voltage_switch(mmc, ios);
+}
+
 static u8 sdhci_am654_write_power_on(struct sdhci_host *host, u8 val, int reg)
 {
 	writeb(val, host->ioaddr + reg);
@@ -650,6 +675,12 @@ static const struct sdhci_am654_driver_d
 	.flags = IOMUX_PRESENT,
 };
 
+static const struct sdhci_am654_driver_data sdhci_am62_4bit_drvdata = {
+	.pdata = &sdhci_j721e_4bit_pdata,
+	.flags = IOMUX_PRESENT,
+	.quirks = SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA,
+};
+
 static const struct soc_device_attribute sdhci_am654_devices[] = {
 	{ .family = "AM65X",
 	  .revision = "SR1.0",
@@ -872,7 +903,7 @@ static const struct of_device_id sdhci_a
 	},
 	{
 		.compatible = "ti,am62-sdhci",
-		.data = &sdhci_j721e_4bit_drvdata,
+		.data = &sdhci_am62_4bit_drvdata,
 	},
 	{ /* sentinel */ }
 };
@@ -906,6 +937,7 @@ static int sdhci_am654_probe(struct plat
 	pltfm_host = sdhci_priv(host);
 	sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 	sdhci_am654->flags = drvdata->flags;
+	sdhci_am654->quirks = drvdata->quirks;
 
 	clk_xin = devm_clk_get(dev, "clk_xin");
 	if (IS_ERR(clk_xin)) {
@@ -940,6 +972,7 @@ static int sdhci_am654_probe(struct plat
 		goto err_pltfm_free;
 	}
 
+	host->mmc_host_ops.start_signal_voltage_switch = sdhci_am654_start_signal_voltage_switch;
 	host->mmc_host_ops.execute_tuning = sdhci_am654_execute_tuning;
 
 	pm_runtime_get_noresume(dev);



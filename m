Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FFA2D6E6B;
	Tue, 26 Aug 2025 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208786; cv=none; b=CrRnZMG9760pbWMl713iq1ZYCiY5Ze3di63yhKsBYEPH657KfOgURngle5/mmQOXFCED9JV0GZLnsRVJWeXjKO0q2xYDS8huhrXBGe9u2iDb+74GyhxUCLMs4G2x6wVzHJy2RYx6jIH2b7x8jfxVSHv/QsFAwQzVspi1IiA0RP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208786; c=relaxed/simple;
	bh=3MoOhj7RQlsVKPJgK1JNLRdW9XZ2ZhnfSdm/6SAFzgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw+tAnabLjrW/OiigyjncyePhCjBF5qmxnckTu4O6SNnnlterVBV3olOKEStmLfTH43mtFZkh83VSCERUjeFarvObgdqE84D0jhYrNoURMvBpT/gbJr15FMXwygOzx8rRKCzFjrlZQdt3eJlOR3dGypO8mVuT4iNE34Ut55cIKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thrCMLWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thrCMLWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6E2C4CEF1;
	Tue, 26 Aug 2025 11:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208785;
	bh=3MoOhj7RQlsVKPJgK1JNLRdW9XZ2ZhnfSdm/6SAFzgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thrCMLWul0ht2uTM5VNZmf/W+AStywoMUa8tfUWfQxMHJJ7cGNTAVrQiHvJvToMuO
	 WneNncMijV9uh5V3JXZozEYxBPdxN/nHyiGGsdleXAEumI9BYxGCP19I5fOPHyiNfp
	 ESXXz+QRQm/F6TNNsMNAhgUI0fqGnXbhcXY9M+eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/322] mmc: sdhci_am654: Disable HS400 for AM62P SR1.0 and SR1.1
Date: Tue, 26 Aug 2025 13:10:28 +0200
Message-ID: <20250826110921.134879324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit d2d7a96b29ea6ab093973a1a37d26126db70c79f upstream.

This adds SDHCI_AM654_QUIRK_DISABLE_HS400 quirk which shall be used
to disable HS400 support. AM62P SR1.0 and SR1.1 do not support HS400
due to errata i2458 [0] so disable HS400 for these SoC revisions.

[0] https://www.ti.com/lit/er/sprz574a/sprz574a.pdf
Fixes: 37f28165518f ("arm64: dts: ti: k3-am62p: Add ITAP/OTAP values for MMC")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250820193047.4064142-1-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ adapted quirk bit assignment from BIT(2) to BIT(1) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -155,6 +155,7 @@ struct sdhci_am654_data {
 	u32 tuning_loop;
 
 #define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
+#define SDHCI_AM654_QUIRK_DISABLE_HS400 BIT(1)
 };
 
 struct window {
@@ -734,6 +735,7 @@ static int sdhci_am654_init(struct sdhci
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
+	struct device *dev = mmc_dev(host->mmc);
 	u32 ctl_cfg_2 = 0;
 	u32 mask;
 	u32 val;
@@ -789,6 +791,12 @@ static int sdhci_am654_init(struct sdhci
 	if (ret)
 		goto err_cleanup_host;
 
+	if (sdhci_am654->quirks & SDHCI_AM654_QUIRK_DISABLE_HS400 &&
+	    host->mmc->caps2 & (MMC_CAP2_HS400 | MMC_CAP2_HS400_ES)) {
+		dev_info(dev, "HS400 mode not supported on this silicon revision, disabling it\n");
+		host->mmc->caps2 &= ~(MMC_CAP2_HS400 | MMC_CAP2_HS400_ES);
+	}
+
 	ret = __sdhci_add_host(host);
 	if (ret)
 		goto err_cleanup_host;
@@ -852,6 +860,12 @@ static int sdhci_am654_get_of_property(s
 	return 0;
 }
 
+static const struct soc_device_attribute sdhci_am654_descope_hs400[] = {
+	{ .family = "AM62PX", .revision = "SR1.0" },
+	{ .family = "AM62PX", .revision = "SR1.1" },
+	{ /* sentinel */ }
+};
+
 static const struct of_device_id sdhci_am654_of_match[] = {
 	{
 		.compatible = "ti,am654-sdhci-5.1",
@@ -943,6 +957,10 @@ static int sdhci_am654_probe(struct plat
 		goto err_pltfm_free;
 	}
 
+	soc = soc_device_match(sdhci_am654_descope_hs400);
+	if (soc)
+		sdhci_am654->quirks |= SDHCI_AM654_QUIRK_DISABLE_HS400;
+
 	host->mmc_host_ops.execute_tuning = sdhci_am654_execute_tuning;
 
 	pm_runtime_get_noresume(dev);



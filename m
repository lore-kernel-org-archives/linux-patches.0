Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7D64F218;
	Thu, 12 Dec 2024 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018110; cv=none; b=mrua77qFnyCmqXgo8u2UWLvQM4wbaf7Y0N3ebxq+7SYPnnIkcTKGFCAaIgF2wWna8lrIVMymykssg0dGyN97eWKLFw/DSNrxZY3ACnPOudU2gTpqDfDaEU/cQCZb2FEm0gr/2/Wqxa+XmkWi8SHsvZC59eOCnvCEyeFTur/tAQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018110; c=relaxed/simple;
	bh=floRfjyKxfDi6SwAE1+nQrfRcWBFrVY/KVZVgLUXp1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3S7HBjEI4QY5OUMQKRT1QlALSwy4MEiyYZLue4RPBjhwss+c2ucWaZZPRcMZD/LlcOksYKa/rrYk1cZCoEsi2R6TFPtAlx6L7MMNk4KZkwF2guGjsCrp/wAqlt7V2+xbdiyYi3zrWVSmI6pTsfLQbBuHzDyNAGCnBRVlNagv7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLNaB3vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLNaB3vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD47C4CED0;
	Thu, 12 Dec 2024 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018109;
	bh=floRfjyKxfDi6SwAE1+nQrfRcWBFrVY/KVZVgLUXp1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLNaB3vIbb/5X0VJKnUu73ZckjeA5SvDfAavWEK/d66yM0QquCVrvMECpYFOJ0kNC
	 evnWOh9mK9HYxngZB9YRgkE2epn3LrXgZ5LpZzRIraqSM/9FWBhVLkeZjWIFJqsPHW
	 Rzq0gmea5f79RMoBK2wAxZLvtom6DuGsuCEGEKdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/356] mmc: sdhci-esdhc-imx: enable quirks SDHCI_QUIRK_NO_LED
Date: Thu, 12 Dec 2024 15:58:40 +0100
Message-ID: <20241212144252.562158831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4dede2b76f4a760e948e1a49b1520881cb459bd3 ]

Enable SDHCI_QUIRK_NO_LED for i.MX7ULP, i.MX8MM, i.MX8QXP and
i.MXRT1050. Even there is LCTL register bit, there is no IOMUX PAD
for it. So there is no sense to enable LED for SDHCI for these SoCs.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240923062016.1165868-1-peng.fan@oss.nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 3b8030f3552af..e4e9b84f210b2 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -235,6 +235,7 @@ struct esdhc_platform_data {
 
 struct esdhc_soc_data {
 	u32 flags;
+	u32 quirks;
 };
 
 static const struct esdhc_soc_data esdhc_imx25_data = {
@@ -306,10 +307,12 @@ static struct esdhc_soc_data usdhc_imx7ulp_data = {
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_PMQOS | ESDHC_FLAG_HS400
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 static struct esdhc_soc_data usdhc_imxrt1050_data = {
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 static struct esdhc_soc_data usdhc_imx8qxp_data = {
@@ -318,6 +321,7 @@ static struct esdhc_soc_data usdhc_imx8qxp_data = {
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE
 			| ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 static struct esdhc_soc_data usdhc_imx8mm_data = {
@@ -325,6 +329,7 @@ static struct esdhc_soc_data usdhc_imx8mm_data = {
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 struct pltfm_imx_data {
@@ -1664,6 +1669,7 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 
 	imx_data->socdata = device_get_match_data(&pdev->dev);
 
+	host->quirks |= imx_data->socdata->quirks;
 	if (imx_data->socdata->flags & ESDHC_FLAG_PMQOS)
 		cpu_latency_qos_add_request(&imx_data->pm_qos_req, 0);
 
-- 
2.43.0




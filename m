Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C853E20E034;
	Thu, 12 Dec 2024 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016608; cv=none; b=bAfrJYtdxNB2cZS0X1ShLrHy/QnAeGRlKXRck5yCFZ81fiRRoNjgDOWoiRs1W/lStQXhxEUefoPww1J3g2AncQj+OECH0hUBEv2hdfMSBsdzD27bOqYSF7uf7UKjgRnOPEyWESRkJ6mkBfJeE/GCNHr+2XAP0YvIxW4975ty/6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016608; c=relaxed/simple;
	bh=uipNKCt5bnExvBSKwr8wZ/7+FfBVZTbmsZCRiJD6JB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3zRq31PUo6mkkw5QaNnsaXOXR1uAUxGfJTuFCdXVSr61omo0fqcQ0tti9n5rv1plSAH516yblXM2OIxN+Fs//L2EZCroX15tkTAs5z+/+tPsHRMgE4rzFYrRnDIPUu4aJSie2BOgMrzDNxm06c0j6LhGESnWCm1u1BwQgJmRTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0a763h5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0a763h5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36514C4CED0;
	Thu, 12 Dec 2024 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016608;
	bh=uipNKCt5bnExvBSKwr8wZ/7+FfBVZTbmsZCRiJD6JB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0a763h5b4YitSs+H3u3vVBzWpLtnaeaE7pvCA91aiOs2tZvA6gogSNvj2vin+/BP
	 MO7avTRkSD35w8pak/2XMDuZBc6mfGDFRW/U4n34cRjNOKYM43lLMg8rkBKK2Sy3Rm
	 IOu/2Q3wG9RHi+MTaySj74umc9xmba1j1TFsc5Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/466] mmc: sdhci-esdhc-imx: enable quirks SDHCI_QUIRK_NO_LED
Date: Thu, 12 Dec 2024 15:56:55 +0100
Message-ID: <20241212144316.504220065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f0bc6dca2b04..ef3a44f2dff16 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -238,6 +238,7 @@ struct esdhc_platform_data {
 
 struct esdhc_soc_data {
 	u32 flags;
+	u32 quirks;
 };
 
 static const struct esdhc_soc_data esdhc_imx25_data = {
@@ -309,10 +310,12 @@ static struct esdhc_soc_data usdhc_imx7ulp_data = {
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
@@ -321,6 +324,7 @@ static struct esdhc_soc_data usdhc_imx8qxp_data = {
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE
 			| ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 static struct esdhc_soc_data usdhc_imx8mm_data = {
@@ -328,6 +332,7 @@ static struct esdhc_soc_data usdhc_imx8mm_data = {
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 struct pltfm_imx_data {
@@ -1687,6 +1692,7 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 
 	imx_data->socdata = device_get_match_data(&pdev->dev);
 
+	host->quirks |= imx_data->socdata->quirks;
 	if (imx_data->socdata->flags & ESDHC_FLAG_PMQOS)
 		cpu_latency_qos_add_request(&imx_data->pm_qos_req, 0);
 
-- 
2.43.0




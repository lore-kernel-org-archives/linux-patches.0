Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B5827448;
	Wed,  7 Aug 2024 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043311; cv=none; b=mYpDc5VqXxg2NjyXCp0rn+rAjVfQazrTayC90l5ymkJ73tUgkJnnOYo2NBTm5XkagOtuTOsdvl55dAn5Gt2KhUxcHZ1iUXjG/uMic4zu7OkzwKQT1t1EoLtGCx5OQWrUieJ7rMRrBy3Nkx6n44uhWhcX0yWKfJ1VbO2IMLxy8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043311; c=relaxed/simple;
	bh=66IyaSNJh2y3VVoxaAFI+JDNFbk0hf+k1GSIu+ZEzkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHnaTO0SW8ds+2KQu1ViQ3FwbEVkH0WzE5vPCdoVh9iZ0sRbXNNFsjr+3es9tqNFqzhEtVuFA7n6768DLWbUnjR/QGusssB9JKKDr9ayUFohy5B/A8SAsnch577x5eEkS7691UWtva0xoWYhEUAPupxrALVI4xP64K9DrzH5igg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYTIcLyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYTIcLyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CA8C32781;
	Wed,  7 Aug 2024 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043311;
	bh=66IyaSNJh2y3VVoxaAFI+JDNFbk0hf+k1GSIu+ZEzkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYTIcLyHqhbD37DSoxfjpnQf9KMhWeFJRS55gvW30gQgA6DSDJdbdgy8kU6/X6npe
	 omlRJB7WGbvZZhdQa7KPryhLsT9Dd7sctlM3oBHN3m/lzaT05BhkjEhmkiIfZZqF4j
	 QCKfrU/qx2jqB9b/bh+KO6VpwWWhJ/WzT05C0B+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/121] dmaengine: fsl-edma: clean up unused "fsl,imx8qm-adma" compatible string
Date: Wed,  7 Aug 2024 16:59:36 +0200
Message-ID: <20240807150020.843290508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit 77584368a0f3d9eba112c3df69f1df7f282dbfe9 ]

The eDMA hardware issue only exist imx8QM A0. A0 never mass production.
So remove the workaround safely.

Signed-off-by: Joy Zou <joy.zou@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240424064508.1886764-2-joy.zou@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ddad5589970 ("dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-common.c | 16 ++++------------
 drivers/dma/fsl-edma-common.h |  2 --
 drivers/dma/fsl-edma-main.c   |  8 --------
 3 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index 12e605a756cad..a1ac404977fd8 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -75,18 +75,10 @@ static void fsl_edma3_enable_request(struct fsl_edma_chan *fsl_chan)
 
 	flags = fsl_edma_drvflags(fsl_chan);
 	val = edma_readl_chreg(fsl_chan, ch_sbr);
-	/* Remote/local swapped wrongly on iMX8 QM Audio edma */
-	if (flags & FSL_EDMA_DRV_QUIRK_SWAPPED) {
-		if (!fsl_chan->is_rxchan)
-			val |= EDMA_V3_CH_SBR_RD;
-		else
-			val |= EDMA_V3_CH_SBR_WR;
-	} else {
-		if (fsl_chan->is_rxchan)
-			val |= EDMA_V3_CH_SBR_RD;
-		else
-			val |= EDMA_V3_CH_SBR_WR;
-	}
+	if (fsl_chan->is_rxchan)
+		val |= EDMA_V3_CH_SBR_RD;
+	else
+		val |= EDMA_V3_CH_SBR_WR;
 
 	if (fsl_chan->is_remote)
 		val &= ~(EDMA_V3_CH_SBR_RD | EDMA_V3_CH_SBR_WR);
diff --git a/drivers/dma/fsl-edma-common.h b/drivers/dma/fsl-edma-common.h
index b567da379fc33..20e29a42fcd8d 100644
--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -178,8 +178,6 @@ struct fsl_edma_desc {
 #define FSL_EDMA_DRV_HAS_PD		BIT(5)
 #define FSL_EDMA_DRV_HAS_CHCLK		BIT(6)
 #define FSL_EDMA_DRV_HAS_CHMUX		BIT(7)
-/* imx8 QM audio edma remote local swapped */
-#define FSL_EDMA_DRV_QUIRK_SWAPPED	BIT(8)
 /* control and status register is in tcd address space, edma3 reg layout */
 #define FSL_EDMA_DRV_SPLIT_REG		BIT(9)
 #define FSL_EDMA_DRV_BUS_8BYTE		BIT(10)
diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 4a3edba315887..c96b893d2ac35 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -346,13 +346,6 @@ static struct fsl_edma_drvdata imx8qm_data = {
 	.setup_irq = fsl_edma3_irq_init,
 };
 
-static struct fsl_edma_drvdata imx8qm_audio_data = {
-	.flags = FSL_EDMA_DRV_QUIRK_SWAPPED | FSL_EDMA_DRV_HAS_PD | FSL_EDMA_DRV_EDMA3,
-	.chreg_space_sz = 0x10000,
-	.chreg_off = 0x10000,
-	.setup_irq = fsl_edma3_irq_init,
-};
-
 static struct fsl_edma_drvdata imx8ulp_data = {
 	.flags = FSL_EDMA_DRV_HAS_CHMUX | FSL_EDMA_DRV_HAS_CHCLK | FSL_EDMA_DRV_HAS_DMACLK |
 		 FSL_EDMA_DRV_EDMA3,
@@ -384,7 +377,6 @@ static const struct of_device_id fsl_edma_dt_ids[] = {
 	{ .compatible = "fsl,ls1028a-edma", .data = &ls1028a_data},
 	{ .compatible = "fsl,imx7ulp-edma", .data = &imx7ulp_data},
 	{ .compatible = "fsl,imx8qm-edma", .data = &imx8qm_data},
-	{ .compatible = "fsl,imx8qm-adma", .data = &imx8qm_audio_data},
 	{ .compatible = "fsl,imx8ulp-edma", .data = &imx8ulp_data},
 	{ .compatible = "fsl,imx93-edma3", .data = &imx93_data3},
 	{ .compatible = "fsl,imx93-edma4", .data = &imx93_data4},
-- 
2.43.0




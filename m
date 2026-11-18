Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047967;
	b=nVpj6Fj2ALRRYjy3dmjJxR63m/tVZVECvXkCcw+ikcOz4I/9UlDe9S0gMetWENKSG5e1
	 fml+Tzgsd0zxTvQVtiTQKmdMOcalRsgc3sm0GSYXTo68na5BVFFtE0qlnzQbqt+1IoYg3
	 XQAeq45xrZLqVQ/oXZumJjpU1oNpuS068Zfvff704EbqMOxAqu83DXdpXSDMfVebsVhnb
	 zatZhBC3cNMuct9sBYaJnemYyiD3KITaaBj7rU0HEwrg3/zwl3ZOA7E4bg1IacriC+ARD
	 E5aaBNOsmJ6pDIyzAa+KQZeLJdxAlC5ewmcjHPs+4xR590I1LFcz4r1afA6zQMzgH/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fVoh38mvSTxRVtRQZXrWAiUznZ6Dv8PSmybPTyFQD5Y=;
	b=Qdcx7kz9JUS66qDCWYEkl1Ga6fKr+pVV8bhjgcXTI6+mu/0E+1UKqZMcg/JaVF+kGfaf
	 qNEWCx+QUkkn7mQxFMk1Uhj7ST6iRo7YLy8bGU34m5ljdOLcT29TFqxdGoeTEbvGEHKdB
	 TabHMuJzVZfPluOkvb3+JatB9ZoflEL+oeJ1p/cqc9JND2Zq9wbzu0Cj8IDqzUyZ/wFhn
	 KdJv8lq14V5eoblH9iJlPh40RPC417ZpxZ6njdEgdngzl6OwnrGTrCjqD2Kfpfpg2GWpq
	 3DbWe5G6HbN9eTHFsFVdVmilY0PkNYICZrAMKtReOThp47wSHnnF0QHzP/xCPvJylXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5aZOTGc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756D1606A31C;
	Thu, 19 Nov 2026 00:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5aZOTGc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BB91F000C4;
	Thu, 19 Nov 2026 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047967;
	bh=fVoh38mvSTxRVtRQZXrWAiUznZ6Dv8PSmybPTyFQD5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5aZOTGcI1NDEdy9IED44wgndtM9GE2qkRwv+HCDVcsLHDjBnci/e1JTF22TY6y9U
	 a2dJTzQJzT3YQEXe+a8kNulaK+gf3oALhNPwSbjuNbAA20LYJNIaUcgLTzTdpqz+dH
	 suG+cbTXb42se4GpxI0rZ8rESAHhZ6yLttoXX7Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1828/2857] dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118150307.075801224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit c843417e6d6b55e24318e2edf405566e70786d3b ]

The driver managed its two mandatory clocks (core-clk and cfgr-clk)
individually. This was error prone: axi_dma_resume() enabled cfgr_clk
and then core_clk, and if enabling core_clk failed it returned the
error without disabling cfgr_clk, leaving the clock refcount
unbalanced.

Convert the driver to the clk_bulk API. The two clocks are always
acquired, enabled and disabled together, so a clk_bulk_data array
expresses this naturally and shrinks the get/enable/disable paths.
clk_bulk_prepare_enable() also unwinds any clock it already enabled
when a later one fails, which fixes the resume imbalance.

Fixes: 1fe20f1b8454 ("dmaengine: Introduce DW AXI DMAC driver")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Link: https://lore.kernel.org/all/20260813105432.2577322-1-nagachaithanya9911@gmail.com/
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260816054858.2667380-1-nagachaithanya9911@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dma/dw-axi-dmac/dw-axi-dmac-platform.c    | 28 ++++++++-----------
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h         |  3 +-
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 04d96f7403fc7..c9571c248f4a6 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1249,8 +1249,7 @@ static int axi_dma_suspend(struct axi_dma_chip *chip)
 	axi_dma_irq_disable(chip);
 	axi_dma_disable(chip);
 
-	clk_disable_unprepare(chip->core_clk);
-	clk_disable_unprepare(chip->cfgr_clk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(chip->clks), chip->clks);
 
 	return 0;
 }
@@ -1259,11 +1258,7 @@ static int axi_dma_resume(struct axi_dma_chip *chip)
 {
 	int ret;
 
-	ret = clk_prepare_enable(chip->cfgr_clk);
-	if (ret < 0)
-		return ret;
-
-	ret = clk_prepare_enable(chip->core_clk);
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(chip->clks), chip->clks);
 	if (ret < 0)
 		return ret;
 
@@ -1428,13 +1423,11 @@ static int dw_probe(struct platform_device *pdev)
 
 	chip->dw->hdata->use_cfg2 = !!(flags & AXI_DMA_FLAG_USE_CFG2);
 
-	chip->core_clk = devm_clk_get(chip->dev, "core-clk");
-	if (IS_ERR(chip->core_clk))
-		return PTR_ERR(chip->core_clk);
-
-	chip->cfgr_clk = devm_clk_get(chip->dev, "cfgr-clk");
-	if (IS_ERR(chip->cfgr_clk))
-		return PTR_ERR(chip->cfgr_clk);
+	chip->clks[0].id = "core-clk";
+	chip->clks[1].id = "cfgr-clk";
+	ret = devm_clk_bulk_get(chip->dev, ARRAY_SIZE(chip->clks), chip->clks);
+	if (ret)
+		return dev_err_probe(chip->dev, ret, "failed to get clocks\n");
 
 	ret = parse_device_properties(chip);
 	if (ret)
@@ -1546,10 +1539,13 @@ static int dw_remove(struct platform_device *pdev)
 	struct dw_axi_dma *dw = chip->dw;
 	struct axi_dma_chan *chan, *_chan;
 	u32 i;
+	int ret;
 
 	/* Enable clk before accessing to registers */
-	clk_prepare_enable(chip->cfgr_clk);
-	clk_prepare_enable(chip->core_clk);
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(chip->clks), chip->clks);
+	if (ret)
+		dev_warn(chip->dev, "failed to enable clocks before remove: %d\n",
+			 ret);
 	axi_dma_irq_disable(chip);
 	for (i = 0; i < dw->hdata->nr_channels; i++) {
 		axi_chan_disable(&chip->dw->chan[i]);
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index 8521530a34ec4..2b49ba6355525 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -68,8 +68,7 @@ struct axi_dma_chip {
 	int			irq;
 	void __iomem		*regs;
 	void __iomem		*apb_regs;
-	struct clk		*core_clk;
-	struct clk		*cfgr_clk;
+	struct clk_bulk_data	clks[2];
 	struct dw_axi_dma	*dw;
 };
 
-- 
2.53.0




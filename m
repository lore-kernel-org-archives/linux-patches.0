Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054829;
	b=HibPoc2ZIw3g4fmWKWj5HUJcMBqeK3D4DzoGDyp5no7NaSyquiWQNBiAVvzaCTTiQDLu
	 quOUj1Zk0uRYg79SCOQAuupfbu0n2iuUFPRU/SPLg44fSyI0DYE9q0n4u9JSzUhys5sa9
	 QU0hub9ckWCuypPxtYI/t2MaDbtVVMurc/5dy8Y7XGEHLKElcAcL9lu51Gu6pBd5nfgxq
	 ZgnoVTkHoWEIJXS2O/9ZL8EZDYaV4r8bmoDT+WuNn8zholOg9YGok5kjIb8SC42LISvfg
	 xs6OoMoPXH4iwL7ynBBoaRdwkDXeQKkqYQ219IFv6m/lMTjM1GkzQhN8uSenLQIV1cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMGfCZjZUc2eulaSrnCJABNtQ3nW/3YijsC11Gzm2hs=;
	b=4TOhIPdaT71+eN7DNPXDf4xqhH5pSpQhe7qeDFJF5A6GPQRqOmqTqkkyDPWg0zmLbJcb
	 FkzBp7FU3U+yQw3z5QKLqfOxrFrElPDrf/vggEE5S51CSa2IM9fElGfiu0zAEQZLg72A3
	 67/W8WuiVE7a/Y/0ACdVLGWWxixBHsKY4yuH0MCcbVZMVIvMaB1B4v7Ffyx1U7KyTka4W
	 /rmTdJpJTk+FoJNG0Ze9CuB5OGfh+SGSY/2Hjjm37SEBpOlClIkpG8Dp+CucTImQfPveY
	 TwAF5/NdJnztQCnPrD5avkcnMbnTcpxnaeLtZxpJyel+HYv/1F0oYndjDAIbpXp3Zaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtLW8pMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A46606A31C;
	Thu, 19 Nov 2026 02:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtLW8pMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA371F000C4;
	Thu, 19 Nov 2026 02:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054829;
	bh=TMGfCZjZUc2eulaSrnCJABNtQ3nW/3YijsC11Gzm2hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtLW8pMKhXOWkb58lpEucyZmJJr4QcXn4NrhTUcY6OamW5euzmq9GtRNnqc4xtNNV
	 Elwn89oWQkFeL/py+yF6kedttJX7qvs/e8czViJAfsTz6DwLPhxmNVDHPHKMeKe8ab
	 cQmY5ibGq5jjboJztr9xuK+pJXkkFP3SRWp2FYRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1413/2214] dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150107.773182389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a57c49c8d3b1..e3d40b6cc723b 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1240,8 +1240,7 @@ static int axi_dma_suspend(struct axi_dma_chip *chip)
 	axi_dma_irq_disable(chip);
 	axi_dma_disable(chip);
 
-	clk_disable_unprepare(chip->core_clk);
-	clk_disable_unprepare(chip->cfgr_clk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(chip->clks), chip->clks);
 
 	return 0;
 }
@@ -1250,11 +1249,7 @@ static int axi_dma_resume(struct axi_dma_chip *chip)
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
 
@@ -1419,13 +1414,11 @@ static int dw_probe(struct platform_device *pdev)
 
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
@@ -1537,10 +1530,13 @@ static int dw_remove(struct platform_device *pdev)
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
index 1fcc9662c61f5..a51e35df996ec 100644
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




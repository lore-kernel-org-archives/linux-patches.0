Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023367;
	b=1v5iRZzGdAqZ9WjADJH59qoAEzm0PvIqTpUovA+OweltFfmyfwNsdngYMXC0rtSFlnzw
	 dSoXAx+hFyYWWDb+LLZvYiHvq0g80RgUH6Tclg6hfVsRHz1xonOAOe02LbLv9LrWL1LwT
	 P7sLW/TJVCRuNNpxs22rc+Dc7lUfHRKKaWS0BUqs4vOebF/MypBhmOL1V0W4s3CK4GixQ
	 xPqiBb+DakfYbysQiIumuFe2SdJxU4ZgP84RGMawBxPpmNSW5+Pj7AI/ZoTtZCwjldmOu
	 J/lcoKHHHxyCly+uU9TWm5eFllaNBkLrWM9BXQYCkaGEwx+qBOlogA3O4GEdlbtG3tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qx9Qi6H58voiZKUgQdNwF9Br0WFLohaasYPZkCdUlJ8=;
	b=b/1fZERKwsbQOX3XDXaCaRE4FHDqovwRinnqNLOXlAnxCgr/Qmog5nwAUh/z0ScBBUBa
	 8NrKE6TQKLARrZtVo5Q8QIQ6x58p6ARlBxa9+szECk7g1VrGbCIrEBPBhERe0gc1F1nMQ
	 RYHFK/kSsWSNq+w7jVSTb2m7CK4xljur9D3KbEQnmibVmY5SQJztiLMUlBIToskqFzyqe
	 0IMB003ZyrFflRYMx/2fEnh+VaVMyTB0ucP1WkMaEIyJbTgMsThlmQXrYWT1VjojzfQ9y
	 rsqGFULN6p93YT/4V5MaGi4kSI2wmPfQsdNrKDVaSFyOrpo/h95wYIKcKQbnn+ZE1Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIjpB7+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647A3606CA58;
	Wed, 18 Nov 2026 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIjpB7+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59D71F000C6;
	Wed, 18 Nov 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023367;
	bh=Qx9Qi6H58voiZKUgQdNwF9Br0WFLohaasYPZkCdUlJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIjpB7+W+p6QPZesbgVVOvImrXcgiYtzEhLNPK5C81HWSlsNnQxnnsudEDyUcfph8
	 fsV6MuP1RO6FSItUE/ugHjX2KVEXJ/oRjqrZlVftxtzvG1fBrq/GHSrmthV2ys1e5H
	 VefT9wU6p7ln3lFMijay802/vPO37MI9ZgJbqxiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0301/2151] dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API
Date: Wed, 18 Nov 2026 15:33:56 +0100
Message-ID: <20261118150132.881094368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 343d32eeaa29a..9772a4fdd85e8 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1322,8 +1322,7 @@ static int axi_dma_suspend(struct axi_dma_chip *chip)
 	axi_dma_irq_disable(chip);
 	axi_dma_disable(chip);
 
-	clk_disable_unprepare(chip->core_clk);
-	clk_disable_unprepare(chip->cfgr_clk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(chip->clks), chip->clks);
 
 	return 0;
 }
@@ -1332,11 +1331,7 @@ static int axi_dma_resume(struct axi_dma_chip *chip)
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
 
@@ -1513,13 +1508,11 @@ static int dw_probe(struct platform_device *pdev)
 
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
@@ -1629,10 +1622,13 @@ static void dw_remove(struct platform_device *pdev)
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
index b842e6a8d90d3..d6e53f400af25 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -68,8 +68,7 @@ struct axi_dma_chip {
 	int			irq[DMAC_MAX_CHANNELS];
 	void __iomem		*regs;
 	void __iomem		*apb_regs;
-	struct clk		*core_clk;
-	struct clk		*cfgr_clk;
+	struct clk_bulk_data	clks[2];
 	struct dw_axi_dma	*dw;
 };
 
-- 
2.53.0




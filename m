Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054815;
	b=nkZtzUcRxDw5NsfMcj0FgdF6v+LDbwk6IZh2i2xWm4DTppC4/G4zIfaig+6cH5Z3e462
	 NYK1fgwHnmRyaFXTps66nnEZ7FhDbIeHwlOWfKsjO6mlMG76JAZM2bo1YYf1oSvW6MNhw
	 5kXIpehCwYgUok8WDwBgaXN58MXl8u/2oVwJ/0h1ArqF/q4X6dKVLRwxMsogIfzC8gLQt
	 QYtV1l3YTRo0vrarkhJKH6MVu7/ojT3P31ETs58YZjSEGeWgpDTpMhu/tIoBPVn9SJbgI
	 qo+izSNDpXYJJ7aJfv0fk+oKO44qX5/mjNZnDjazKVBo8g6PAK2DK8vt2L5dCnPoJYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a8HilxtNrsqaEF1wL5QAc0XqmfTgAehKBJg5euHChVk=;
	b=0rDbr6+px5ddlRctwPQ/a79AuU4E0ej+TLRXxB8vq1a7nDHWpbM3HlTeSXLDsdnPoWeD
	 1ckGiafwNobLQ2ZboQY5MuMj1JLnmC4lzhWuH5nK2AbqD47npwjMbhSftOUYZnj1J3JQt
	 If6IKnizbnEpUc0wVhP4HDAfSgL5hdAv/71rTbbodI8jlEwzytkbhZqb4g5bJW3y3hcL2
	 dI3HFlAfpgM5OMQaBIJbE8oJM7niqYqiXs3oHswHBbEnQKJIdoBE/76zcUB4jiXr5dtTQ
	 kSNr+BvzkLwFkqImsYnYnm00jLU3lvX1SfGtGMgvg6KEJACik1MlsKMcion7CXEvSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayX3xTSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41433606A31C;
	Thu, 19 Nov 2026 02:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayX3xTSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BE21F000C6;
	Thu, 19 Nov 2026 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054815;
	bh=a8HilxtNrsqaEF1wL5QAc0XqmfTgAehKBJg5euHChVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayX3xTSgxvLvdflRo4GH7DMLF4sRnTz0nUQ+1CiTM29rK1U3X5pbFntTzvah2o4Wk
	 dN2g+Cr+soh6wvmTNxBDWRLv21D8qfNzmak5Gt19UM/xSjrhIW9gLMEYBxvwOLPDC5
	 +AdM1CuJStOWS4x7py5DOZudNV0Ks1cwSC7Qe6/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1408/2214] dmaengine: zynqmp_dma: simplify with dev_err_probe
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150107.588532828@linuxfoundation.org>
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

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 5637abaab994a933d7f00c95bc1456c7a58c83f4 ]

The clocks are provided by the ZynqMP firmware driver and are deferred
until the firmware driver has probed. This leads to misleading error
messages during probe of the zynqmp_dma driver.

Use dev_err_probe for printing errors during probe to avoid error
messages for -EPROBE_DEFER.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Link: https://lore.kernel.org/r/20210826094742.1302009-2-m.tretter@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0266dac57019 ("dmaengine: zynqmp_dma: Fix chan probe/remove error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 5257bdbf77fb0..931c292e990f7 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1062,16 +1062,14 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	p->dev = &pdev->dev;
 
 	zdev->clk_main = devm_clk_get(&pdev->dev, "clk_main");
-	if (IS_ERR(zdev->clk_main)) {
-		dev_err(&pdev->dev, "main clock not found.\n");
-		return PTR_ERR(zdev->clk_main);
-	}
+	if (IS_ERR(zdev->clk_main))
+		return dev_err_probe(&pdev->dev, PTR_ERR(zdev->clk_main),
+				     "main clock not found.\n");
 
 	zdev->clk_apb = devm_clk_get(&pdev->dev, "clk_apb");
-	if (IS_ERR(zdev->clk_apb)) {
-		dev_err(&pdev->dev, "apb clock not found.\n");
-		return PTR_ERR(zdev->clk_apb);
-	}
+	if (IS_ERR(zdev->clk_apb))
+		return dev_err_probe(&pdev->dev, PTR_ERR(zdev->clk_apb),
+				     "apb clock not found.\n");
 
 	platform_set_drvdata(pdev, zdev);
 	pm_runtime_set_autosuspend_delay(zdev->dev, ZDMA_PM_TIMEOUT);
@@ -1086,7 +1084,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 	ret = zynqmp_dma_chan_probe(zdev, pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Probing channel failed\n");
+		dev_err_probe(&pdev->dev, ret, "Probing channel failed\n");
 		goto err_disable_pm;
 	}
 
@@ -1098,7 +1096,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	ret = of_dma_controller_register(pdev->dev.of_node,
 					 of_zynqmp_dma_xlate, zdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Unable to register DMA to DT\n");
+		dev_err_probe(&pdev->dev, ret, "Unable to register DMA to DT\n");
 		dma_async_device_unregister(&zdev->common);
 		goto free_chan_resources;
 	}
-- 
2.53.0




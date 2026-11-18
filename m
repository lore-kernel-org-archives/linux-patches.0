Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060404;
	b=MFhN6ZxAWeZHoV+1YtpYwqLUyjxy3F7tZMZ82djDoCgcgQH96hTDKb2KZs8h+YTuRhbJ
	 efJLQF3Tf6OzOJvOQ+eoyV7fAA0usojK12i5v3AjmpRQSeyPtxw4fACfUZ0O1Kz5eDYiR
	 g1MMwy1jIGfaTzjA0zzEHfE7jrk4jd6nAJBux6QrFHaRVDes85rPV0+FaKfz6ybO3FMNc
	 +ZgyWeunw/XRi5X/RbcEW9dY9CcZcg/qAcwep8Yt2qrLCJlzZNygRojlohNZ5mwvORW9s
	 L0fPtY7MMBQnJez/7wFFmHRxBjB7AW5rp9aB1aK53ysXiCINMStl1siwWSDsg1+GrXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYIaXYWFUnMe4SoRwdGKl9IWzMj36J96WaYrSGi+mTA=;
	b=vvLpzA9qtH29jqn3hXcezB60CV6CBTpQ+ZFrUP7O1guM0vy1hrrNtuovDxTPcxhIfhpr
	 POPiBcfaxxh3ErA+fwk3oMq4TzGR09/3yyQxSkywVYy7HMEaOx25xwEIL3GWGd0Xbx8UQ
	 nmwvWiXNGcQY5YkjC6vfyuk0udf18/mNtX6YDPF1QGhhj16xW5+soRt9cel3S/8IDXy08
	 GeL8+5aXV9C/Cvfz3u09okNDw+mwCL7j8xFl15ZM4q3uTG3Pr7zk08bxn7Np50opZ9s6G
	 vcbuu7TTEI8cOo4K0/IofXgafvNeUj2wFcs+VnvOwxBUzRGvadB5EMMqG8+n6Wnvt6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2osllK86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD27B606A320;
	Thu, 19 Nov 2026 03:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2osllK86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFB11F000C4;
	Thu, 19 Nov 2026 03:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060404;
	bh=UYIaXYWFUnMe4SoRwdGKl9IWzMj36J96WaYrSGi+mTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2osllK864rWi5lPmCR7nIsAMvYp5Udm5P8zjOxkf/f9omjHJJMBtLTi/De5DAPTCZ
	 4fuTBJ3bFGAFUz3+NYP41DRb0PEVcpjGLDnlX8xPEOHdPkFHFjZxpnWLt9dPHhOKcW
	 wKh6cIKw0qbI0MO3zmwSG9ISy4l+IsUr6Rcxaxsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Tretter <m.tretter@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1186/1848] dmaengine: zynqmp_dma: simplify with dev_err_probe
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150009.173719596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e6be076e9d34..27b19e84124ec 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1063,16 +1063,14 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
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
@@ -1087,7 +1085,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 	ret = zynqmp_dma_chan_probe(zdev, pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Probing channel failed\n");
+		dev_err_probe(&pdev->dev, ret, "Probing channel failed\n");
 		goto err_disable_pm;
 	}
 
@@ -1099,7 +1097,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
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




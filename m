Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023356;
	b=fEjGnmij5I9UIsPURu2wfkxyUSqCpNuqM9DCCwX7BB984BzXH2aPOHCfo6EkQVjOMTQ7
	 zKzQAnBWSoRjJEvEte+7IDVFP5X3UzA0jptPxCy+RQuxwZsxHZjaGMsD63a9I7q3a3iKC
	 cxC5rYI3H37ZdOvL+HSdVLY7uZMA2TbVVzft1n4gpFifIcacCMxX0fJpawTMGbyvwpMFe
	 1sbsFuX3MHefwrnyTRDGEc3ftEpMVWuCCr9o9CPeeg8rqCeICQcPjsmbXfG6Ev6C+FWFp
	 nglFIvBHQCfWOW+BO0WssJ5qEHHIUgiAydM0JSXdv/gfScThCTnGNxbgqMDO/aSEIHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yGKNGZU/4PuUtcov5U7KzksXqRQsd7Q64BLMGY9l8ss=;
	b=r2rWnTAm+E1amM+jmopx7+gpWZe2ykIbjGPVsbPa/+g2LW1d/Q9UQrIYoHo6zNjou0Fr
	 VLHtyLsyrHbbBn8xwyZfpQDcojd+2KA7IHKAIvZhDy2H6PdkppYV3wh7dKcy79LcTsMUn
	 mJYMize7JhgfGO590H3+RAbbLahlzK2R0Bggs9oNNAERJADxMx21K4Aj/dRS6EWEo50Wp
	 fjDb5J83iTavluqFTvCBGirJQhx1dFIjeSQcCdMdLR2fKluAUfO0q1f8ljMkeb/zOu039
	 Zml3Y/nomwOWQqkisipqUKQONV2M18Oor/Fh0bapQJStA2eXF9dvzQBMmnmQ3s2mmGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHzOeotx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB60B606A33B;
	Wed, 18 Nov 2026 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHzOeotx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5017D1F000C5;
	Wed, 18 Nov 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023355;
	bh=yGKNGZU/4PuUtcov5U7KzksXqRQsd7Q64BLMGY9l8ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHzOeotxGKQmFWEFAfSA+u1o/lNUlZpDrs2LZiWEYGKO4cG5N+swEgN4Gz0UW3DhR
	 EQe4rOWz4tNLr5TruxYfK7qaORzsMi7CxE90ao74FL/Cp4PozswL88TcY4WUQ79b6g
	 /ZJ14GTV9R5V7MvHlekfTivPyZVsBBTBVyEM9MBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0297/2151] dmaengine: at_hdmac: Fix use-after-free by proper tasklet cleanup
Date: Wed, 18 Nov 2026 15:33:52 +0100
Message-ID: <20261118150132.734367658@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 13f2d32a09609d083ace2d589fbdc68e970ae34c ]

Current cleanup paths have a use-after-free vulnerability:
- vchan_init() creates tasklets that access at_dma_chan memory
- free_irq() only waits for IRQ handler, NOT tasklets
- atdma is devm-managed and freed after probe/remove
- Running tasklets accessing freed memory → Use-After-Free!

The fix requires careful ordering:
- free_irq() FIRST to synchronize with running IRQ handlers and prevent
  them from scheduling new tasklets
- Then kill tasklets to wait for already-scheduled ones to complete
- Only then free other resources

Fixes: ac803b56860f ("dmaengine: at_hdmac: Convert driver to use virt-dma")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260604073945.54B311F00898@smtp.kernel.org/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727061705.45169-1-zenghongling@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index dffe5becd6c3c..b2715e9427b79 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1940,6 +1940,20 @@ static void at_dma_off(struct at_dma *atdma)
 		cpu_relax();
 }
 
+static void at_dma_cleanup_channels(struct at_dma *atdma)
+{
+	struct dma_chan *chan, *_chan;
+	int i = 0;
+
+	list_for_each_entry_safe(chan, _chan, &atdma->dma_device.channels,
+			device_node) {
+		/* Disable interrupts */
+		atc_disable_chan_irq(atdma, i++);
+		tasklet_kill(&to_at_dma_chan(chan)->vc.task);
+		list_del(&chan->device_node);
+	}
+}
+
 static int __init at_dma_probe(struct platform_device *pdev)
 {
 	struct at_dma		*atdma;
@@ -2105,6 +2119,8 @@ static int __init at_dma_probe(struct platform_device *pdev)
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_device);
 err_dma_async_device_register:
+	disable_irq(platform_get_irq(pdev, 0));
+	at_dma_cleanup_channels(atdma);
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->lli_pool);
@@ -2118,23 +2134,17 @@ static int __init at_dma_probe(struct platform_device *pdev)
 static void at_dma_remove(struct platform_device *pdev)
 {
 	struct at_dma		*atdma = platform_get_drvdata(pdev);
-	struct dma_chan		*chan, *_chan;
 
 	at_dma_off(atdma);
 	if (pdev->dev.of_node)
 		of_dma_controller_free(pdev->dev.of_node);
 	dma_async_device_unregister(&atdma->dma_device);
 
-	dma_pool_destroy(atdma->memset_pool);
-	dma_pool_destroy(atdma->lli_pool);
 	free_irq(platform_get_irq(pdev, 0), atdma);
 
-	list_for_each_entry_safe(chan, _chan, &atdma->dma_device.channels,
-			device_node) {
-		/* Disable interrupts */
-		atc_disable_chan_irq(atdma, chan->chan_id);
-		list_del(&chan->device_node);
-	}
+	at_dma_cleanup_channels(atdma);
+	dma_pool_destroy(atdma->memset_pool);
+	dma_pool_destroy(atdma->lli_pool);
 
 	clk_disable_unprepare(atdma->clk);
 }
-- 
2.53.0




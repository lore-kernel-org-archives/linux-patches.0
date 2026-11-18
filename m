Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017766;
	b=2upQzpHFiQLQFsky50Wlag+pcISfNHIg5mhVQwNxQa1AfuPnDSNEoKf+ZFtLlXPnE1mP
	 8BEuZPICD5rS8gdi8euOf6yAggGZYQWPIFss7DGB6XCAhHqvoM2dkqSQQAnc+vX54GNNQ
	 PUySGwd5KseLgX+uqFT2LDTvQQn9hkSoWWIgPFpC4byYDeiwD3MqtsrVW6ufpyAT40R0I
	 ENiEmzMTHw9qlZkSYKSuB1BdE/FRP8ym4re+aBWWiBqJIjIgp8p/62heQVpUHFj+ij5Kf
	 aCBm4DKUhY/wFcj2QSI/X3WsAIqqbPdA3nHB8VMkBDjW2jDt7rn6/BvBNJvzUKhwDuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8vOdm++TERnP97kCZPMb7kM2WoTq9WTyY+toTUmSIIo=;
	b=vQORqekODe/vfWmRnGglcNkAkFS6tsZ/H2gDBsi1Pgn0rKfVVo7FOQv41YAufCszJmLp
	 oFJ9O6hCC05hmkGUOyhJZx9k9MbFt5vPrQmZTp314t5t9dKCgy7CMz4t6J7Gj+Pnp7Gv1
	 BNaRT6AUObqzWnrBc8LJSdex78gF5gtPBX23sCJm3WQvGyqj8GYWpUF7qJY7lU4e7tbBX
	 fIK2+Hw2XCUnWisiIADYmIH6sPEoiO6d4ptCh2cSr1JaNQMWEiwrdoajMox4vqWGS0M/Q
	 YXZZpex1qyfZ4pODmdJrjiBdHWDTyzSak2mvZwSx+Dty83GqCDAgLIX2aL3P1+m/krQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGohCb3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880ED606A325;
	Wed, 18 Nov 2026 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGohCb3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA7A1F000C4;
	Wed, 18 Nov 2026 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017766;
	bh=8vOdm++TERnP97kCZPMb7kM2WoTq9WTyY+toTUmSIIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGohCb3sfizX/nxb78NMVIAgoS4n5ugc6E2W1zHUiPbwrkUtFTy82l152yAaXu0Tw
	 wlDIUqCFlypCwv/sKOwzr+URm/mKz/RKVwoMHkVb8cXknqtOdy6Rq2ZuN1WWLg7lqU
	 0x1DY7xwFpHFqm7HT2UVGDY6eADjuShGV285BjuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0961/2651] spi: rspi: Fix DMA mode when the DMA controller is built as a module
Date: Wed, 18 Nov 2026 15:36:41 +0100
Message-ID: <20261118150322.498666831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 7b85114d47f693b709b2e8e22e44cdf58c04b111 ]

On the Renesas RZ/G2L platform, the RSPI driver falls back to PIO mode
instead of using DMA when the DMA controller driver is built as a module
(CONFIG_RZ_DMAC=m):

    renesas_spi 1004b000.spi: dma_request_slave_channel_compat failed
    renesas_spi 1004b000.spi: DMA not available, using PIO

The driver requests DMA channels through dma_request_slave_channel_compat()
which returns either a valid pointer or NULL and cannot handle
-EPROBE_DEFER. If the DMA controller has not probed yet, the driver falls
back to PIO directly.

Fix this by replacing the dma_request_slave_channel_compat() call with a
regular dma_request_chan() call. dma_request_slave_channel_compat() is
always passed a NULL fn_param in all code paths, so it actually behaves
like a plain dma_request_chan() call.

Fixes: e825b8dd2b36 ("spi: rspi: Add DT support to DMA setup")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260921195943.107247-1-ovidiu.panait.rb@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 49 ++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 38df676774ee1..c61edd1c1353b 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -22,7 +22,6 @@
 #include <linux/of.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
 #include <linux/spinlock.h>
 
@@ -1091,24 +1090,15 @@ static irqreturn_t rspi_irq_tx(int irq, void *_sr)
 
 static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 					      enum dma_transfer_direction dir,
-					      unsigned int id,
 					      dma_addr_t port_addr)
 {
-	dma_cap_mask_t mask;
 	struct dma_chan *chan;
 	struct dma_slave_config cfg;
 	int ret;
 
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	chan = dma_request_slave_channel_compat(mask, shdma_chan_filter,
-				(void *)(unsigned long)id, dev,
-				dir == DMA_MEM_TO_DEV ? "tx" : "rx");
-	if (!chan) {
-		dev_warn(dev, "dma_request_slave_channel_compat failed\n");
-		return NULL;
-	}
+	chan = dma_request_chan(dev, dir == DMA_MEM_TO_DEV ? "tx" : "rx");
+	if (IS_ERR(chan))
+		return chan;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.dst_addr = port_addr + RSPI_SPDR;
@@ -1121,7 +1111,7 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 	if (ret) {
 		dev_warn(dev, "dmaengine_slave_config failed %d\n", ret);
 		dma_release_channel(chan);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return chan;
@@ -1130,29 +1120,23 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
 			    const struct resource *res)
 {
-	unsigned int dma_tx_id, dma_rx_id;
+	struct dma_chan *chan;
 
-	if (dev->of_node) {
-		/* In the OF case we will get the slave IDs from the DT */
-		dma_tx_id = 0;
-		dma_rx_id = 0;
-	} else {
-		/* The driver assumes no error. */
+	if (!dev->of_node)
 		return 0;
-	}
 
-	ctlr->dma_tx = rspi_request_dma_chan(dev, DMA_MEM_TO_DEV, dma_tx_id,
-					     res->start);
-	if (!ctlr->dma_tx)
-		return -ENODEV;
+	chan = rspi_request_dma_chan(dev, DMA_MEM_TO_DEV, res->start);
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
+	ctlr->dma_tx = chan;
 
-	ctlr->dma_rx = rspi_request_dma_chan(dev, DMA_DEV_TO_MEM, dma_rx_id,
-					     res->start);
-	if (!ctlr->dma_rx) {
+	chan = rspi_request_dma_chan(dev, DMA_DEV_TO_MEM, res->start);
+	if (IS_ERR(chan)) {
 		dma_release_channel(ctlr->dma_tx);
 		ctlr->dma_tx = NULL;
-		return -ENODEV;
+		return PTR_ERR(chan);
 	}
+	ctlr->dma_rx = chan;
 
 	ctlr->can_dma = rspi_can_dma;
 	dev_info(dev, "DMA available");
@@ -1355,6 +1339,11 @@ static int rspi_probe(struct platform_device *pdev)
 	}
 
 	ret = rspi_request_dma(&pdev->dev, ctlr, res);
+	if (ret == -EPROBE_DEFER) {
+		dev_err_probe(&pdev->dev, ret,
+			      "failed to request DMA channels\n");
+		goto error2;
+	}
 	if (ret < 0)
 		dev_warn(&pdev->dev, "DMA not available, using PIO\n");
 
-- 
2.53.0




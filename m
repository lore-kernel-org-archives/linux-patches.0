Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84735201E;
	Wed, 20 May 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295838; cv=none; b=GOAEcy3+IGyFUEWObZ1CAkUhyg78PmMj70LBKQsVE3CinbEqNr2nb9GHiVHHyXFXdpCVfNlDJmaiXtaktrVPSb3KFunW/66srBPc+A4xmpfh6pGYVbTIAk7HaN7ELWryeAxObQA9oARvaEAvD1EDSSykB4bhgnvD6kkztFUP03U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295838; c=relaxed/simple;
	bh=lLKCDByZlBuiglCoORcsvSwTaGj6AXXhSW/9lr86FrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvdnA9/bEcKZRh5v03e6GxKjdh/wpOOd/9s1JEVmsPqYCiVl6eve6QsoLl5pDc5O5qEob0WzjJcvJ+k3xseuwkXn3UKDQul4kFQ/XPJ1XkRkHk8C2WwqvU6+hfgKjCmRJlWZYTRoDPleImanU1V+r2hQrg49Cwu8Di/9E0kyGsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeNASpDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeNASpDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CD21F000E9;
	Wed, 20 May 2026 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295836;
	bh=ZkiOmFlUQYq9zVLdCBkmTnrL+/6x8kafLvw260+GWek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeNASpDuHx9VBFhD3GFHIsNY2qSk8qCaTqP9PJ/cAmP33eRe/5baOEGSpeFHIpu+2
	 1Lq7WQ9V2XQu0c86n8/K4eVYTRUKxVSDPLo4HBAOSlrxRMHmwqcbp3ti1aF9407E5i
	 1eM6xby5K3WL4RYkp7CDDF3z2gHb5TqvfK2WTPPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <karom.9560@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0572/1146] dmaengine: dw-axi-dmac: fix Alignment should match open parenthesis
Date: Wed, 20 May 2026 18:13:42 +0200
Message-ID: <20260520162201.128878457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khairul Anuar Romli <karom.9560@gmail.com>

[ Upstream commit 6c5883a9ba296d2797437066592d15b2d202de7a ]

checkpatch.pl --strict reports a CHECK warning in dw-axi-dmac-platform.c:

  CHECK: Alignment should match open parenthesis

This warning occurs when multi-line function calls or expressions have
continuation lines that don't properly align with the opening parenthesis
position.

This patch fixes all instances in dw-axi-dmac-platform.c where continuation
lines were indented with an inconsistent number of spaces/tabs that neither
matched the parenthesis column nor followed a standard indent pattern.
Proper alignment improves code readability and maintainability by making
parameter lists visually consistent across the kernel codebase.

Fixes: 1fe20f1b8454 ("dmaengine: Introduce DW AXI DMAC driver")
Fixes: e32634f466a9 ("dma: dw-axi-dmac: support per channel interrupt")
Signed-off-by: Khairul Anuar Romli <karom.9560@gmail.com>
Link: https://patch.msgid.link/20260202060224.12616-2-karom.9560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 5d74bc29cf896..b9fbfeb873e76 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -342,8 +342,8 @@ static void axi_desc_put(struct axi_dma_desc *desc)
 	kfree(desc);
 	atomic_sub(descs_put, &chan->descs_allocated);
 	dev_vdbg(chan2dev(chan), "%s: %d descs put, %d still allocated\n",
-		axi_chan_name(chan), descs_put,
-		atomic_read(&chan->descs_allocated));
+		 axi_chan_name(chan), descs_put,
+		 atomic_read(&chan->descs_allocated));
 }
 
 static void vchan_desc_put(struct virt_dma_desc *vdesc)
@@ -353,7 +353,7 @@ static void vchan_desc_put(struct virt_dma_desc *vdesc)
 
 static enum dma_status
 dma_chan_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
-		  struct dma_tx_state *txstate)
+		   struct dma_tx_state *txstate)
 {
 	struct axi_dma_chan *chan = dchan_to_axi_dma_chan(dchan);
 	struct virt_dma_desc *vdesc;
@@ -491,7 +491,7 @@ static void axi_chan_start_first_queued(struct axi_dma_chan *chan)
 
 	desc = vd_to_axi_desc(vd);
 	dev_vdbg(chan2dev(chan), "%s: started %u\n", axi_chan_name(chan),
-		vd->tx.cookie);
+		 vd->tx.cookie);
 	axi_chan_block_xfer_start(chan, desc);
 }
 
@@ -1162,7 +1162,7 @@ static irqreturn_t dw_axi_dma_interrupt(int irq, void *dev_id)
 		axi_chan_irq_clear(chan, status);
 
 		dev_vdbg(chip->dev, "%s %u IRQ status: 0x%08x\n",
-			axi_chan_name(chan), i, status);
+			 axi_chan_name(chan), i, status);
 
 		if (status & DWAXIDMAC_IRQ_ALL_ERR)
 			axi_chan_handle_err(chan, status);
@@ -1451,7 +1451,7 @@ static int axi_req_irqs(struct platform_device *pdev, struct axi_dma_chip *chip)
 		if (chip->irq[i] < 0)
 			return chip->irq[i];
 		ret = devm_request_irq(chip->dev, chip->irq[i], dw_axi_dma_interrupt,
-				IRQF_SHARED, KBUILD_MODNAME, chip);
+				       IRQF_SHARED, KBUILD_MODNAME, chip);
 		if (ret < 0)
 			return ret;
 	}
@@ -1645,7 +1645,7 @@ static void dw_remove(struct platform_device *pdev)
 	of_dma_controller_free(chip->dev->of_node);
 
 	list_for_each_entry_safe(chan, _chan, &dw->dma.channels,
-			vc.chan.device_node) {
+				 vc.chan.device_node) {
 		list_del(&chan->vc.chan.device_node);
 		tasklet_kill(&chan->vc.task);
 	}
-- 
2.53.0




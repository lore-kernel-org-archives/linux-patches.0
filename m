Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831496;
	b=2Rd+RglorHqoNtx0FFyyGAXSU7kXl55BXOb78dH17iiadITWeoOrI0e5X7Lo7AV88fwP
	 c96jkk1ed6TFB7TUUv+xZmNeO+PtofpoE/Vbuczx1JE06ixxI2AaomrttxPCDBsFqBCBM
	 FZXhl3jPUM1M6gJqzLi8+6AT1Nhi90THgnNyq8QWwgV259w5sd3n/JMm0nQ/6p4W3lvxH
	 ZZxYvrR0ukoEeOTmeTPq7QpTZEfEuU52ZEY8bSCcCBxafdkxTTshKSL3ZCuZSuqhEZRPQ
	 usjH34I1El3zGa8tarEGa58ls80bY8EGcIWvwn4vauInDptEXr44ibHrQEmNJldXx2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8oLKSbDyQtzpD31ZAe+o2d7uAH9yKfC0AIjjAB+gSTY=;
	b=nN27NOtgKK66kdTiLH5YiCTZ3KNcH/VMc5xSCwRzPPZ9WVA0KFQfZy+WMI9P4rpZ1ZLt
	 HcxL3CWPLW9Ns1cWT+4oTzWt8OXSLrt/lg8cdFEHxoRR4Mn7Qa+BZeERKsYuWIOG4Axfq
	 blnCCQQwlt4OCrqxhT3m0CYUGmtuAALsAg4/dEEOc8+bmUhxqQVUbRa5xcMckgyM9xLfS
	 UCbIbWAr9wFcnrA5Rkqv2QvnXXBUYlvrwhuWboNrOY81VJsab3vi3adETjDmNokcC3m4W
	 nXege/ESn1VzwM1vfyIYjjKTUtJU8wofx6Zo01IyFQsqioec8ioyQCnYHoSBkhg/nWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdDJSR1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BCC606B2D7;
	Wed,  4 Nov 2026 22:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdDJSR1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F9A1F00919;
	Wed,  4 Nov 2026 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831496;
	bh=8oLKSbDyQtzpD31ZAe+o2d7uAH9yKfC0AIjjAB+gSTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdDJSR1QyRS649jw6tCS9Ij6GIsPaTyzpeq4AC6F5EjB8X/+bHNChFymx5yJo1E5I
	 1MvzgoP/xxqRWOwGjatUlBV6mJhIRjErz3tVECP0/nDGQm94GRBriQvXAX0k7+Vam4
	 AlbaZ6FHbO1XL/dvVBv1hH9HwXDPRk85kU/mmbK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 0738/1005] spi: spi-pci1xxxx: quiesce DMA engines on transfer timeout
Date: Wed,  4 Nov 2026 16:07:51 -0500
Message-ID: <20261104211104.151926790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

commit 0b591332a2bdc13d3f9163793131fe3651d1556a upstream.

If a DMA-mapped transfer times out waiting for DMA_TERM and neither DMA
abort interrupt arrived, pci1xxxx_spi_transfer_with_dma() returns
through the error label while both DMA engines are still enabled, the
done/abort interrupt status is still armed and the transfer state
(p->xfer, p->tx_sgl, p->rx_sgl) is still registered.

The ISRs keep firing afterwards: they reprogram the DMA engines from
p->tx_sgl / p->rx_sgl and signal completion through p->xfer and
p->spi_xfer_done, all of which the SPI core is free to unmap or reuse
once transfer_one() has returned, which is a use-after-free. A late
done interrupt can also start the next transfer queued behind the
failed one.

Stop both DMA engines, drain the pending done/abort interrupt status
and synchronize the DMA IRQs before dropping the in-progress state and
the transfer pointers, and re-enable the engines afterwards so that
subsequent transfers keep working. The engines are only turned back on
once both were confirmed to have stopped: re-enabling an engine that
failed to stop would cancel the pending stop request and let it keep
running into buffers the SPI core is about to unmap or free, which is
exactly the window this patch closes. An engine that failed to stop is
left disabled, as the abort paths already do.

The DMA interrupt status and mask registers are shared between the two
SPI instances, so the cleanup drains only this instance's done/abort
status bits instead of masking the interrupt lines, which would also
suppress the peer instance's completion interrupts.

Also make the DMA ISRs ignore interrupts while no transfer is in
progress so that a stray MSI after the cleanup can no longer act on
the cleared state.

No PCI1XXXX hardware was available for testing and QEMU has no model
of this PCIe part, so the timeout path was exercised with a userspace
replica of the timeout branch and the DMA ISRs, with the register and
interrupt accesses mocked: on the unfixed code both a wedged engine
that clears after the timeout and a late done interrupt touch the
freed transfer state, while with this fix applied neither does and an
engine that failed to stop is left disabled.  The module was also
loaded and unloaded in a QEMU x86_64 guest running a kernel with this
fix applied.

Fixes: 9538edeb72c9 ("spi: mchp-pci1xxxx: DMA support for copying data to and from SPI Buf")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261016020036.1333548-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pci1xxxx.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

--- a/drivers/spi/spi-pci1xxxx.c
+++ b/drivers/spi/spi-pci1xxxx.c
@@ -542,6 +542,8 @@ static int pci1xxxx_spi_transfer_with_dm
 	struct pci1xxxx_spi_internal *p = spi_controller_get_devdata(spi_ctlr);
 	struct pci1xxxx_spi *par = p->parent;
 	dma_addr_t tx_dma_addr = 0;
+	unsigned long flags;
+	bool engines_stopped;
 	int ret = 0;
 	u32 regval;
 
@@ -618,12 +620,72 @@ static int pci1xxxx_spi_transfer_with_dm
 			p->dma_aborted_wr = false;
 			ret = -ECANCELED;
 		}
+
+		/*
+		 * A timed out transfer leaves the DMA engines running and
+		 * the done/abort interrupt status armed with p->xfer,
+		 * p->tx_sgl and p->rx_sgl still registered.  Stop the
+		 * engines, drain the pending status and synchronize the
+		 * IRQs before dropping the transfer state, otherwise a
+		 * late interrupt makes the ISRs reprogram the engines
+		 * from or signal completion through memory which the SPI
+		 * core is about to unmap or free.
+		 */
+		writel(SPI_DMA_ENGINE_DIS,
+		       par->dma_offset_bar + SPI_DMA_GLOBAL_WR_ENGINE_EN);
+		writel(SPI_DMA_ENGINE_DIS,
+		       par->dma_offset_bar + SPI_DMA_GLOBAL_RD_ENGINE_EN);
+		engines_stopped =
+			!(readl_poll_timeout(par->dma_offset_bar +
+					     SPI_DMA_GLOBAL_WR_ENGINE_EN,
+					     regval, regval == 0x0, 0,
+					     USEC_PER_MSEC) ||
+			  readl_poll_timeout(par->dma_offset_bar +
+					     SPI_DMA_GLOBAL_RD_ENGINE_EN,
+					     regval, regval == 0x0, 0,
+					     USEC_PER_MSEC));
+		if (!engines_stopped)
+			dev_warn(&par->dev->dev,
+				 "SPI DMA engines failed to stop\n");
+
+		spin_lock_irqsave(&par->dma_wr_reg_lock, flags);
+		writel((SPI_DMA_DONE_INT_MASK(p->hw_inst) |
+			SPI_DMA_ABORT_INT_MASK(p->hw_inst)),
+		       par->dma_offset_bar + SPI_DMA_INTR_WR_CLR);
+		spin_unlock_irqrestore(&par->dma_wr_reg_lock, flags);
+		spin_lock_irqsave(&par->dma_rd_reg_lock, flags);
+		writel((SPI_DMA_DONE_INT_MASK(p->hw_inst) |
+			SPI_DMA_ABORT_INT_MASK(p->hw_inst)),
+		       par->dma_offset_bar + SPI_DMA_INTR_RD_CLR);
+		spin_unlock_irqrestore(&par->dma_rd_reg_lock, flags);
+
+		p->spi_xfer_in_progress = false;
+		synchronize_irq(p->irq[1]);
+		synchronize_irq(p->irq[2]);
+
+		/*
+		 * Turn the engines back on only once both are confirmed
+		 * to have stopped: re-enabling an engine that failed to
+		 * stop would cancel the pending stop request and let it
+		 * run into buffers the SPI core is about to unmap or
+		 * free.  An engine that failed to stop is left disabled,
+		 * as the abort paths already do.
+		 */
+		if (engines_stopped) {
+			writel(SPI_DMA_ENGINE_EN,
+			       par->dma_offset_bar + SPI_DMA_GLOBAL_WR_ENGINE_EN);
+			writel(SPI_DMA_ENGINE_EN,
+			       par->dma_offset_bar + SPI_DMA_GLOBAL_RD_ENGINE_EN);
+		}
 		goto error;
 	}
 	ret = 0;
 
 error:
 	p->spi_xfer_in_progress = false;
+	p->xfer = NULL;
+	p->tx_sgl = NULL;
+	p->rx_sgl = NULL;
 
 	return ret;
 }
@@ -695,6 +757,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma_
 	unsigned long flags;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the DMA RD INT and start spi xfer*/
 	regval = readl(p->parent->dma_offset_bar + SPI_DMA_INTR_RD_STS);
 	if (regval) {
@@ -723,6 +788,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma_
 	unsigned long flags;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the DMA WR INT */
 	regval = readl(p->parent->dma_offset_bar + SPI_DMA_INTR_WR_STS);
 	if (regval) {
@@ -755,6 +823,9 @@ static irqreturn_t pci1xxxx_spi_isr_dma(
 	irqreturn_t spi_int_fired = IRQ_NONE;
 	u32 regval;
 
+	if (!p->spi_xfer_in_progress)
+		return IRQ_NONE;
+
 	/* Clear the SPI GO_BIT Interrupt */
 	regval = readl(p->parent->reg_base + SPI_MST_EVENT_REG_OFFSET(p->hw_inst));
 	if (regval & SPI_INTR) {



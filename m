Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026899;
	b=Kn09g/CRFXDlknbJ32xnlky44srrv6dftZ5YQ0iH58zKwibadQutgqiHLJE4dUuXM629
	 6v1eNiP7om0O+6jUAVk1DqZPVdWp8yzngoSPsbxVNNV0LNLQJ2qfV9zOYFGh0Kq0/zZTh
	 PtjUPvjhbSWaAhkH53cKLJIV7E9iFlxu/JkaC0jrAv+UVWHe08NNb2cReSbH/YRVUY/Gw
	 zyHduWW9PRTMrm6+dNbTr6xTLqe4UU3RAOxLTpq6XSf7jTK08TTbNwpJ3JPGciWWasDVe
	 5BbQFTETylkjbywz/ULkwadCxMPsJd86YS0tBtqBWv9YmhJWUk8HI1Iefybd8zhnqUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H8FasYt+t8Gn2Z/EtyM43QkSpZgARikBdKZZyCOX+CE=;
	b=1PwHHWZDiiG4uVqm+odARjeB2k0871PuJvx2v2tpu4mPSVix7vTc0YdwPqUMQXOc8cgv
	 K0rjUpSv96l0XiVo64sLUMKVQMVMhZWhfu7YPg0ayfI+GTXeSJHtPXIccNGk4NHOQGyTg
	 M+3csupFT2LHo3fLOJaUgcarW5xvWuAEpcBN4ZKZ7wDp1jm/qoVz5Vwsa+S8JBbNaoSzI
	 +xC+HshhU96d2BzJ7OKbJd0XNT7U2KaK56aMjxYzWPFbQFuqNwlZstS6F6SdWpEtZN7A7
	 3ajEqYi92CJtt/ZVzUfiBMjk2x+zKGaHx1MhEz0ymbffoGjtVcxCgVcrGWhdFTuehMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eq9RGAwF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30C606A320;
	Wed, 18 Nov 2026 18:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eq9RGAwF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BC1F000C4;
	Wed, 18 Nov 2026 18:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026899;
	bh=H8FasYt+t8Gn2Z/EtyM43QkSpZgARikBdKZZyCOX+CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eq9RGAwFLNffZI6/FiMLxk9uXl/QsqFC7LzqOkI8tzY8LmHLTz9hnn/jiFeeVkoO3
	 HW+6kSbatk0c0Qnecij/J6zokhBbLo//2NFCbXnuuHhFzTe5nVYRFFTkjM9wQA4npf
	 /YKH0YjiAyj57QiLoYIz/PEQFdGEohj+1C6gPt2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1597/2151] spi: omap2-mcspi: handle DMA setup failures
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150220.056467647@linuxfoundation.org>
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

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit c126e07bde21c518f1356937ac240500d1bc81c0 ]

The DMA paths ignore failures from dmaengine_slave_config(), descriptor
preparation and dmaengine_submit(), and carry FIXME comments about
falling back to PIO. A failed setup can leave a half-started transfer
or wait for a completion that never arrives.

Check each step and clean up with dmaengine_terminate_sync() on error.
Prepare both descriptors before issuing either channel. Fall back to
PIO only for host-mode transfers that have a TX buffer, when no DMA has
been started and cleanup succeeded. RX-only and target-mode transfers
return the error instead, since the bus may already be clocking.

The FIFO is enabled before the DMA attempt, but the PIO path polls
per-word TXS/RXS and does not expect FIFO mode. Disable the FIFO, with
the channel off while its bits change, before falling back.

Tested on an AM642 board with a TI 6.12.57 vendor kernel built with
this patch and booted from RAM. On a McSPI bus using DMA, 200
iterations of 4096-byte TX and 1024-byte RX spidev transfers completed
with no errors, timeouts or kernel warnings. With a temporary change
that fails every DMA-sized TX setup, 60 spidev writes fell back to PIO
with no errors or timeouts. That test used a bus with no device
attached and did not show a difference with and without the FIFO
disable, which is based on reading the code.

Fixes: 53741ed8f0a3 ("spi: omap2-mcspi: add DMA engine support")
Link: https://lore.kernel.org/r/20250914022132.319227-1-alex.t.tran@gmail.com
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261015064341.1100422-1-sahaj123.sc@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 236 ++++++++++++++++++++++++----------
 1 file changed, 167 insertions(+), 69 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 921fc07d9bee7..3233f92be2375 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -414,10 +414,11 @@ static void omap2_mcspi_tx_callback(void *data)
 	complete(&mcspi_dma->dma_tx_completion);
 }
 
-static void omap2_mcspi_tx_dma(struct spi_device *spi,
-				struct spi_transfer *xfer,
-				struct dma_slave_config cfg)
+static int omap2_mcspi_tx_dma(struct spi_device *spi,
+			      struct spi_transfer *xfer,
+			      struct dma_slave_config cfg)
 {
+	int ret;
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
 	struct dma_async_tx_descriptor *tx;
@@ -425,31 +426,31 @@ static void omap2_mcspi_tx_dma(struct spi_device *spi,
 	mcspi = spi_controller_get_devdata(spi->controller);
 	mcspi_dma = &mcspi->dma_channels[spi_get_chipselect(spi, 0)];
 
-	dmaengine_slave_config(mcspi_dma->dma_tx, &cfg);
+	ret = dmaengine_slave_config(mcspi_dma->dma_tx, &cfg);
+	if (ret)
+		return ret;
 
 	tx = dmaengine_prep_slave_sg(mcspi_dma->dma_tx, xfer->tx_sg.sgl,
 				     xfer->tx_sg.nents,
 				     DMA_MEM_TO_DEV,
 				     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-	if (tx) {
-		tx->callback = omap2_mcspi_tx_callback;
-		tx->callback_param = spi;
-		dmaengine_submit(tx);
-	} else {
-		/* FIXME: fall back to PIO? */
-	}
-	dma_async_issue_pending(mcspi_dma->dma_tx);
-	omap2_mcspi_set_dma_req(spi, 0, 1);
+	if (!tx)
+		return -EIO;
+
+	tx->callback = omap2_mcspi_tx_callback;
+	tx->callback_param = spi;
+
+	return dma_submit_error(dmaengine_submit(tx));
 }
 
-static unsigned
+static int
 omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
-				struct dma_slave_config cfg,
-				unsigned es)
+		   struct dma_slave_config cfg, unsigned int es,
+		   unsigned int *count, bool *rx_submitted, bool *dma_started)
 {
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
-	unsigned int		count, transfer_reduction = 0;
+	unsigned int		transfer_reduction = 0;
 	struct scatterlist	*sg_out[2];
 	int			nb_sizes = 0, out_mapped_nents[2], ret, x;
 	size_t			sizes[2];
@@ -462,7 +463,8 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 
 	mcspi = spi_controller_get_devdata(spi->controller);
 	mcspi_dma = &mcspi->dma_channels[spi_get_chipselect(spi, 0)];
-	count = xfer->len;
+	*count = xfer->len;
+	*rx_submitted = false;
 
 	/*
 	 *  In the "End-of-Transfer Procedure" section for DMA RX in OMAP35x TRM
@@ -476,14 +478,16 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	l = mcspi_cached_chconf0(spi);
 
 	if (word_len <= 8)
-		element_count = count;
+		element_count = *count;
 	else if (word_len <= 16)
-		element_count = count >> 1;
+		element_count = *count >> 1;
 	else /* word_len <= 32 */
-		element_count = count >> 2;
+		element_count = *count >> 2;
 
 
-	dmaengine_slave_config(mcspi_dma->dma_rx, &cfg);
+	ret = dmaengine_slave_config(mcspi_dma->dma_rx, &cfg);
+	if (ret)
+		return ret;
 
 	/*
 	 *  Reduce DMA transfer length by one more if McSPI is
@@ -494,7 +498,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 
 	if (transfer_reduction) {
 		/* Split sgl into two. The second sgl won't be used. */
-		sizes[0] = count - transfer_reduction;
+		sizes[0] = *count - transfer_reduction;
 		sizes[1] = transfer_reduction;
 		nb_sizes = 2;
 	} else {
@@ -502,44 +506,56 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 		 * Don't bother splitting the sgl. This essentially
 		 * clones the original sgl.
 		 */
-		sizes[0] = count;
+		sizes[0] = *count;
 		nb_sizes = 1;
 	}
 
 	ret = sg_split(xfer->rx_sg.sgl, xfer->rx_sg.nents, 0, nb_sizes,
 		       sizes, sg_out, out_mapped_nents, GFP_KERNEL);
 
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&spi->dev, "sg_split failed\n");
-		return 0;
+		return ret;
 	}
 
 	tx = dmaengine_prep_slave_sg(mcspi_dma->dma_rx, sg_out[0],
 				     out_mapped_nents[0], DMA_DEV_TO_MEM,
 				     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-	if (tx) {
-		tx->callback = omap2_mcspi_rx_callback;
-		tx->callback_param = spi;
-		dmaengine_submit(tx);
-	} else {
-		/* FIXME: fall back to PIO? */
+	if (!tx) {
+		ret = -EIO;
+		goto out_free_sg;
 	}
 
+	tx->callback = omap2_mcspi_rx_callback;
+	tx->callback_param = spi;
+	ret = dma_submit_error(dmaengine_submit(tx));
+	if (ret)
+		goto out_free_sg;
+
+	*rx_submitted = true;
+	if (mcspi->target_aborted) {
+		ret = -EINTR;
+		goto out_free_sg;
+	}
+	*dma_started = true;
+	if (xfer->tx_buf) {
+		if (spi_controller_is_target(mcspi->ctlr))
+			mcspi_write_reg(mcspi->ctlr, OMAP2_MCSPI_IRQENABLE,
+					OMAP2_MCSPI_IRQSTATUS_EOW);
+		dma_async_issue_pending(mcspi_dma->dma_tx);
+		omap2_mcspi_set_dma_req(spi, 0, 1);
+	}
 	dma_async_issue_pending(mcspi_dma->dma_rx);
 	omap2_mcspi_set_dma_req(spi, 1, 1);
-
 	ret = mcspi_wait_for_completion(mcspi, &mcspi_dma->dma_rx_completion);
-	if (ret || mcspi->target_aborted) {
-		dmaengine_terminate_sync(mcspi_dma->dma_rx);
-		omap2_mcspi_set_dma_req(spi, 1, 0);
-		return 0;
-	}
+	if (ret || mcspi->target_aborted)
+		goto out_free_sg;
 
 	for (x = 0; x < nb_sizes; x++)
 		kfree(sg_out[x]);
 
 	if (mcspi->fifo_depth > 0)
-		return count;
+		return 0;
 
 	/*
 	 *  Due to the DMA transfer length reduction the missing bytes must
@@ -566,9 +582,9 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 		} else {
 			int bytes_per_word = mcspi_bytes_per_word(word_len);
 			dev_err(&spi->dev, "DMA RX penultimate word empty\n");
-			count -= (bytes_per_word << 1);
+			*count -= (bytes_per_word << 1);
 			omap2_mcspi_set_enable(spi, 1);
-			return count;
+			return 0;
 		}
 	}
 	if (!mcspi_wait_for_reg_bit(chstat_reg, OMAP2_MCSPI_CHSTAT_RXS)) {
@@ -583,19 +599,27 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 			((u32 *)xfer->rx_buf)[elements] = w;
 	} else {
 		dev_err(&spi->dev, "DMA RX last word empty\n");
-		count -= mcspi_bytes_per_word(word_len);
+		*count -= mcspi_bytes_per_word(word_len);
 	}
 	omap2_mcspi_set_enable(spi, 1);
-	return count;
+	return 0;
+
+out_free_sg:
+	if (!ret)
+		ret = -EINTR;
+	for (x = 0; x < nb_sizes; x++)
+		kfree(sg_out[x]);
+	return ret;
 }
 
-static unsigned
-omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
+static int omap2_mcspi_txrx_dma(struct spi_device *spi,
+				struct spi_transfer *xfer,
+				unsigned int *count,
+				bool *pio_fallback)
 {
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 	struct omap2_mcspi_dma  *mcspi_dma;
-	unsigned int		count;
 	u8			*rx;
 	const u8		*tx;
 	struct dma_slave_config	cfg;
@@ -603,10 +627,13 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	unsigned es;
 	void __iomem		*chstat_reg;
 	void __iomem            *irqstat_reg;
-	int			wait_res;
+	bool			tx_submitted = false, rx_submitted = false;
+	bool			dma_started = false, terminate_failed = false;
+	int			ret, wait_res;
 
 	mcspi = spi_controller_get_devdata(spi->controller);
 	mcspi_dma = &mcspi->dma_channels[spi_get_chipselect(spi, 0)];
+	*pio_fallback = false;
 
 	if (cs->word_len <= 8) {
 		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
@@ -619,7 +646,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		es = 4;
 	}
 
-	count = xfer->len;
+	*count = xfer->len;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = cs->phys + OMAP2_MCSPI_RX0;
@@ -637,31 +664,39 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	reinit_completion(&mcspi_dma->dma_rx_completion);
 	reinit_completion(&mcspi->txdone);
 	if (tx) {
-		/* Enable EOW IRQ to know end of tx in target mode */
+		ret = omap2_mcspi_tx_dma(spi, xfer, cfg);
+		if (ret)
+			goto out;
+		tx_submitted = true;
+	}
+
+	if (rx) {
+		ret = omap2_mcspi_rx_dma(spi, xfer, cfg, es, count,
+					 &rx_submitted, &dma_started);
+		if (ret)
+			goto out;
+	} else if (tx) {
+		if (mcspi->target_aborted) {
+			ret = -EINTR;
+			goto out;
+		}
 		if (spi_controller_is_target(spi->controller))
-			mcspi_write_reg(spi->controller,
-					OMAP2_MCSPI_IRQENABLE,
+			mcspi_write_reg(spi->controller, OMAP2_MCSPI_IRQENABLE,
 					OMAP2_MCSPI_IRQSTATUS_EOW);
-		omap2_mcspi_tx_dma(spi, xfer, cfg);
+		dma_started = true;
+		dma_async_issue_pending(mcspi_dma->dma_tx);
+		omap2_mcspi_set_dma_req(spi, 0, 1);
 	}
 
-	if (rx != NULL)
-		count = omap2_mcspi_rx_dma(spi, xfer, cfg, es);
-
-	if (tx != NULL) {
-		int ret;
-
+	if (tx) {
 		ret = mcspi_wait_for_completion(mcspi, &mcspi_dma->dma_tx_completion);
-		if (ret || mcspi->target_aborted) {
-			dmaengine_terminate_sync(mcspi_dma->dma_tx);
-			omap2_mcspi_set_dma_req(spi, 0, 0);
-			return 0;
-		}
+		if (ret || mcspi->target_aborted)
+			goto out;
 
 		if (spi_controller_is_target(mcspi->ctlr)) {
 			ret = mcspi_wait_for_completion(mcspi, &mcspi->txdone);
 			if (ret || mcspi->target_aborted)
-				return 0;
+				goto out;
 		}
 
 		if (mcspi->fifo_depth > 0) {
@@ -695,7 +730,43 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 				dev_err(&spi->dev, "EOT timed out\n");
 		}
 	}
-	return count;
+	return 0;
+
+out:
+	if (!ret)
+		ret = -EINTR;
+	if (rx_submitted) {
+		wait_res = dmaengine_terminate_sync(mcspi_dma->dma_rx);
+		if (wait_res) {
+			dev_err(&spi->dev, "failed to terminate RX DMA: %d\n",
+				wait_res);
+			terminate_failed = true;
+			ret = wait_res;
+		}
+		omap2_mcspi_set_dma_req(spi, 1, 0);
+	}
+	if (tx_submitted) {
+		wait_res = dmaengine_terminate_sync(mcspi_dma->dma_tx);
+		if (wait_res) {
+			dev_err(&spi->dev, "failed to terminate TX DMA: %d\n",
+				wait_res);
+			terminate_failed = true;
+			ret = wait_res;
+		}
+		omap2_mcspi_set_dma_req(spi, 0, 0);
+	}
+	if (spi_controller_is_target(mcspi->ctlr))
+		mcspi_write_reg(mcspi->ctlr, OMAP2_MCSPI_IRQENABLE, 0);
+
+	*pio_fallback = !dma_started && !terminate_failed;
+	return ret;
+}
+
+static bool omap2_mcspi_can_pio_fallback(bool cleanup_ok,
+					 const struct spi_transfer *xfer,
+					 bool is_target)
+{
+	return cleanup_ok && xfer->tx_buf && !is_target;
 }
 
 static unsigned
@@ -1208,6 +1279,8 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 
 	if (t->len) {
 		unsigned	count;
+		bool		pio_fallback;
+		int		ret;
 
 		if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
 		    spi_xfer_is_dma_mapped(ctlr, spi, t))
@@ -1221,10 +1294,31 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 					+ OMAP2_MCSPI_TX0);
 
 		if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
-		    spi_xfer_is_dma_mapped(ctlr, spi, t))
-			count = omap2_mcspi_txrx_dma(spi, t);
-		else
+		    spi_xfer_is_dma_mapped(ctlr, spi, t)) {
+			ret = omap2_mcspi_txrx_dma(spi, t, &count,
+						   &pio_fallback);
+			if (ret) {
+				bool is_target = spi_controller_is_target(ctlr);
+				bool fallback;
+
+				fallback = omap2_mcspi_can_pio_fallback(pio_fallback, t,
+									is_target);
+				if (!fallback) {
+					status = ret;
+					goto out;
+				}
+
+				dev_warn(&spi->dev,
+					 "DMA setup failed, falling back to PIO\n");
+				/* PIO does not use the FIFO enabled for DMA */
+				omap2_mcspi_set_enable(spi, 0);
+				omap2_mcspi_set_fifo(spi, t, 0);
+				omap2_mcspi_set_enable(spi, 1);
+				count = omap2_mcspi_txrx_pio(spi, t);
+			}
+		} else {
 			count = omap2_mcspi_txrx_pio(spi, t);
+		}
 
 		if (count != t->len) {
 			status = -EIO;
@@ -1240,8 +1334,12 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 out:
 	/* Restore defaults if they were overriden */
 	if (par_override) {
+		int restore_status;
+
 		par_override = 0;
-		status = omap2_mcspi_setup_transfer(spi, NULL);
+		restore_status = omap2_mcspi_setup_transfer(spi, NULL);
+		if (!status)
+			status = restore_status;
 	}
 
 	omap2_mcspi_set_enable(spi, 0);
-- 
2.53.0




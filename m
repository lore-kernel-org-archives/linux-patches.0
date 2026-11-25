Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623153;
	b=u3wBZbozugOsoMhs49DaP0rbP0chxKS9sJQfsFONYiSRLFk7rYNZ13KgqwZCpOu4QM94
	 4JuOX5Z8/GXZ7ub0l5S3LmXIj0jAcMR30z9Hok+ayksTN9bJn1MsWLL1kvHEc34NeaE1A
	 s6XIbSIlm9xRFLV0PYj8bPXcqQJ0yKZQNgb37NRiA9hRg1Nac6hb5Uyda/dFOMOV/vT/X
	 uUzwS0FWxMUoZI4tzoM+XWeH2ZlZE5RUeW0q+1mRyUMjRDa2Q+2xMcA5qzMbLaqfkd7zT
	 VMeM91lD0OH0qYitL7y/OZWn6AdGcbsExWdfEtnYjfLGGm7GRnn/kvIYuGKahh9EvRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMePgikqknaKYqsymG0HntIOuGQR9Ep7xIxIX2+iVKw=;
	b=fF+XBSx9Ax0wA/JTfX0wvAkYmyg5UJ7/rKrKPty8ORgPjpCVWwcoI5SjPsI0zK0syDqS
	 vNiX7oo9vwejFNMuaWe4CP9yIbGO8DeXaJUJH05JquBmhV6+6I6GPoqPUzITi0NvAFGET
	 UvHM2nvCytqngCID9piFRRAc36b8GqnRdcdg0ZyPX8cTdeSfituMbVZC8hU5nUURvzmLf
	 PNkFwyvx/ZtDqWirBzGAeYWtdkmGmZf5i+w/xpdEjLThvf7y44NljFzS52Lajnki/Ump5
	 xkX9PW39kJjAXJmabVQf8If7rq/tWWLz1BUv+zS2aOgPZmG/fu56h8jpwRIdAXA9NPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XsE/Refs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D33606A330;
	Wed, 25 Nov 2026 16:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XsE/Refs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E541F000D2;
	Wed, 25 Nov 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623152;
	bh=EMePgikqknaKYqsymG0HntIOuGQR9Ep7xIxIX2+iVKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsE/Refs5avDHFunsElQ9ikM4TrG1S3f9SeAor7l9CvCeae+fUwXx44LYh99w0rbr
	 K9Qpqsmygj0GSzuv0sTyCJbFcTQ8MT7CyVzIb1YygpyCNF5g6YZO/6Dtfy1dMdIV35
	 yafHrH4pefW81BBuFRBEYz3sfvoKt2bD8wtFTSpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vishwaroop A <va@nvidia.com>
Subject: [PATCH 6.18 767/990] spi: tegra210-quad: Track DMA mapping state
Date: Wed, 25 Nov 2026 15:35:34 +0100
Message-ID: <20261125143840.020770867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Vishwaroop A <va@nvidia.com>

commit 7b9e6f7bc13c0259b192d0a964e802d4ad53b8b8 upstream.

tegra_qspi_dma_unmap_xfer() assumes a streaming mapping is always
outstanding and recomputes its length from the live
tqspi->curr_dma_words. Nothing records whether tegra_qspi_dma_map_xfer()
mapped anything, so neither assumption holds.

For a multi-chunk transfer, handle_dma_based_xfer() unmaps the chunk that
just completed, recalculates the parameters for the next chunk, which
overwrites curr_dma_words, and re-arms the hardware. If
tegra_qspi_start_dma_based_transfer() then fails at its
tegra_qspi_dma_map_xfer() call, nothing is mapped. That early return also
sits above the smp_store_release() that clears tqspi->trans_status, so the
previous chunk's QSPI_RDY survives, and the re-arm's return value is never
checked, so handle_dma_based_xfer() returns IRQ_HANDLED without completing
the transfer.

The caller times out, tegra_qspi_handle_timeout() sees the stale QSPI_RDY,
concludes the transfer completed and calls handle_dma_based_xfer() again.
No DMA completion arrives, so num_errors is incremented and
tegra_qspi_dma_unmap_xfer() runs with nothing mapped. t->tx_dma then holds
either the DMA_MAPPING_ERROR sentinel or, if the RX mapping was the one
that failed, the preceding chunk's address that has already been released.
Behind an IOMMU the latter frees an IOVA that may since have been
reallocated.

Record whether a mapping is outstanding and the length that was mapped,
and return early from tegra_qspi_dma_unmap_xfer() when there is nothing to
release. is_dma_mapped is only updated under tqspi->lock, or on the timeout
path after synchronize_irq() and cancel_work_sync() have quiesced the ISR
and the bottom half.

Also skip releasing the TX mapping on the RX failure path unless a TX
mapping was created; t->tx_dma is uninitialised when t->tx_buf is NULL.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Suggested-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20261026111412.3843954-3-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra210-quad.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -215,6 +215,17 @@ struct tegra_qspi {
 	bool					is_packed;
 	bool					use_dma;
 
+	/*
+	 * Set while a streaming mapping created by
+	 * tegra_qspi_dma_map_xfer() is outstanding, together with the
+	 * length that was handed to dma_map_single(). is_curr_dma_xfer
+	 * only records that the last armed chunk took the DMA path,
+	 * which is not the same thing: a chunk whose mapping failed
+	 * leaves the DMA path flagged with nothing mapped.
+	 */
+	bool					is_dma_mapped;
+	unsigned int				dma_map_len;
+
 	u32					command1_reg;
 	u32					dma_control_reg;
 	u32					def_command1_reg;
@@ -584,24 +595,32 @@ static int tegra_qspi_dma_map_xfer(struc
 	if (t->rx_buf) {
 		t->rx_dma = dma_map_single(tqspi->rx_dma_dev, (void *)rx_buf, len, DMA_FROM_DEVICE);
 		if (dma_mapping_error(tqspi->rx_dma_dev, t->rx_dma)) {
-			dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
+			if (t->tx_buf)
+				dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma,
+						 len, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 	}
 
+	tqspi->dma_map_len = len;
+	tqspi->is_dma_mapped = true;
+
 	return 0;
 }
 
 static void tegra_qspi_dma_unmap_xfer(struct tegra_qspi *tqspi, struct spi_transfer *t)
 {
-	unsigned int len;
-
-	len = DIV_ROUND_UP(tqspi->curr_dma_words * tqspi->bytes_per_word, 4) * 4;
+	if (!tqspi->is_dma_mapped)
+		return;
 
 	if (t->tx_buf)
-		dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
+		dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma,
+				 tqspi->dma_map_len, DMA_TO_DEVICE);
 	if (t->rx_buf)
-		dma_unmap_single(tqspi->rx_dma_dev, t->rx_dma, len, DMA_FROM_DEVICE);
+		dma_unmap_single(tqspi->rx_dma_dev, t->rx_dma,
+				 tqspi->dma_map_len, DMA_FROM_DEVICE);
+
+	tqspi->is_dma_mapped = false;
 }
 
 static int tegra_qspi_start_dma_based_transfer(struct tegra_qspi *tqspi, struct spi_transfer *t)



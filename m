Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619865;
	b=k70qnq3K97RajPs4m0knlU77gqbZBh32HJrdDT78LaHU1gdHxrkCXb5Uz44TLjCtPXR2
	 n2II3HLoZkxwB5UCXheOtIeSftflEJWo9/EZjKNkIzGPLxtGTiaNE6UScU4yisGhKa8qw
	 3IfRTqW9k//4q8dMB9mTconu2TrE57BO7J6TeFpzTyPxQQ9xDBeC9wbVEdvV4fv9+PO9v
	 vnp+JxVZ2SpvKj8THxkHTqkgbP+zqwTmle46VZyQTnwHsiQAVjpM1UOboeKOnTFzgwN9N
	 0ZKZIPtpgYmybRSJmfAAkBfTfYLGWOAiiwG8hJZkfjACfv+D2dgSBNlERGEQwKcBW7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nE8tvQx1ke0I1US0qieeJpxlhf89RXhcjSHCrHjOJgI=;
	b=Ri8X/GU8PEKVbYj7eM7dgmRl4OOWJ96Wvz0uG2Uu72HmtZMy5H60jFl9cDBnTzeyzaek
	 ZK05JzKZdzAwBp2kyxCaMFR2svbQMHU0BaRpDX4v5HQGOyvjwLrcjAV5CGmVbwyeA3F7c
	 oYtUPYX645Xs9AoxtGKlx02XvMLi+D6WXP8OiPHBa2l+cJqmY+di6cT9Xrqa30M7lIr5m
	 p7LLlvicvB4jb5mvsEvAhOHFXddoG5fgiTEN0t0qMJvp833kLytTqTknyRtLZYE2276YK
	 ENVNAqcPtq9xbclpsIdKW2PC+3yRp5sYyI9h9ahFj0Gsw2xzdxzpPLoMaH+ZXbWeDmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg0EfkdC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CC5606A31E;
	Wed, 25 Nov 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg0EfkdC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C253F1F000C4;
	Wed, 25 Nov 2026 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619865;
	bh=nE8tvQx1ke0I1US0qieeJpxlhf89RXhcjSHCrHjOJgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gg0EfkdCaPIZs/0nfDHfmXIILOUghrt8/5H5wRRaDym59nD+akmW5UMIqAVfuxbns
	 nncv6aQdI2ARxdvN6g6YZmibS9JjSpl855Jw2gd34g2sOtFaRAlgEW5sNDwnxa+yqf
	 dufYoRMQ/fymm+Fy3UVkklYAsjYyABJWmDTaM6eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vishwaroop A <va@nvidia.com>
Subject: [PATCH 7.3 0731/1005] spi: tegra210-quad: Track DMA mapping state
Date: Wed, 25 Nov 2026 15:34:29 +0100
Message-ID: <20261125143838.885276584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619872;
	b=zVoeLu31xwye7Ah3MwjruSb2wBMcDx2YYL9bxgHDpXYPRTVfImBMyMQfwXKYKelycWK0
	 WDqkh3JTa+sfBKHmLkzo5EFrhw1eGr1h0fo4LPP0pqzF7jqe9KC+9TEuP7Hf3Ac5vYC0+
	 TMYPFlLNtWmnObdePNqLOi0uLcj4l/d9q61bg6ctgBvnrgpXtCugvE7IjjsY/dVQrcXnP
	 snHF7CikbUOXRxMBUm5or/Knl+wbEZM+ebUfPLuTm48tjy+EchvTxavCA2cm7lLi9f2kX
	 83DrlTdXLZpMf4Tl3et7T5Ho4DKTqecLInwfz4MrXfLiBStnVEGp0B2MlWRdCiuzkeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzMt+H/mLnu+1He1G8OvCfjUjZl/WWJEm0GcZqToABg=;
	b=WfkdnD46XXPQQ/QzadwNATSlioXQbBGpv/uBuTVodgLThjipybD5rHoKTJf0ZQTWNJSG
	 qEonWPIWIMYv8Tq/4AnrBeB7OzxKwXQf9NBqthVENL1sRIDghGxK0NGc0JOvLo14XP4Wa
	 2TDJdvlNAAGdslDtXgctaeAWPeIYPxDU2ZLUkFjR9Qj/q/qpgdjxP3YZzPRovnwZ1UHlE
	 M0j6FVEtnjXWFE4Q+yCrX9lcclpkvPuaJdylD6cmSKzPdk0cV4zKE7Q4gXtGqeBgcFJiv
	 H96PrtZOFc0UFkgnB9uhx3ZMWoG8ThAwwQB/mwDuX9yoyt33MmrIDWZBcqdouoIqdEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfe0WNuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44321606A323;
	Wed, 25 Nov 2026 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfe0WNuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310341F000C6;
	Wed, 25 Nov 2026 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619871;
	bh=BzMt+H/mLnu+1He1G8OvCfjUjZl/WWJEm0GcZqToABg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfe0WNuVUVN0AN3JlNVGkgkWTU9WGZj6H48fKJ/xH6Q6u9xVc4u4HpOyGOyFMzl6v
	 YrVkfnw2eb1doWlxoQIkxStjRQtcKO9LBlWdS093EPFkmYafMG8OvUvAzdJmnSdLBv
	 EN/nyKXFbAU4crxn3FRIqUza67Oq50vnzs7LfKRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 0732/1005] spi: tegra210-quad: Unmap DMA buffers on transfer timeout
Date: Wed, 25 Nov 2026 15:34:30 +0100
Message-ID: <20261125143838.908058036@linuxfoundation.org>
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

commit d04ad85dd8015713b0b2531b5b934fe67828d741 upstream.

tegra_qspi_start_dma_based_transfer() maps the client TX/RX buffers with
dma_map_single() via tegra_qspi_dma_map_xfer(). The matching unmap only
happens in handle_dma_based_xfer(), which runs from the interrupt bottom
half.

When wait_for_completion_timeout() expires and tegra_qspi_handle_timeout()
cannot establish that the hardware finished, it returns an error without
the bottom half ever having run. Both transfer paths then abort the
transfer with tegra_qspi_dma_stop(), reset the controller and clear
curr_xfer, but never unmap the buffers. Every genuine transfer timeout
therefore leaks the streaming DMA mappings for that chunk, which
gradually exhausts the IOVA space on systems with an IOMMU in front of
QSPI.

Unmap the transfer after stopping DMA on both timeout error paths. The
unmap is placed after tegra_qspi_dma_stop() so the DMA engine is
quiesced before the mappings go away.

The recovery paths that do reach handle_dma_based_xfer() unmap there
themselves. The preceding patch makes tegra_qspi_dma_unmap_xfer() a no-op
once the mapping is released, so this cleanup cannot unmap twice or run
against a chunk that was never mapped.

Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Cc: stable@vger.kernel.org # with "spi: tegra210-quad: Track DMA mapping state"
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20261026111412.3843954-4-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra210-quad.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1262,10 +1262,12 @@ static int tegra_qspi_combined_seq_xfer(
 					dev_err(tqspi->dev, "transfer timeout\n");
 
 					/* Abort transfer by resetting pio/dma bit */
-					if (tqspi->is_curr_dma_xfer)
+					if (tqspi->is_curr_dma_xfer) {
 						tegra_qspi_dma_stop(tqspi);
-					else
+						tegra_qspi_dma_unmap_xfer(tqspi, xfer);
+					} else {
 						tegra_qspi_pio_stop(tqspi);
+					}
 
 					/* Reset controller if timeout happens */
 					tegra_qspi_reset(tqspi);
@@ -1379,8 +1381,10 @@ static int tegra_qspi_non_combined_seq_x
 				WARN_ON(1);
 				dev_err(tqspi->dev, "transfer timeout\n");
 
-				if (tqspi->is_curr_dma_xfer)
+				if (tqspi->is_curr_dma_xfer) {
 					tegra_qspi_dma_stop(tqspi);
+					tegra_qspi_dma_unmap_xfer(tqspi, xfer);
+				}
 
 				tegra_qspi_handle_error(tqspi);
 				ret = -EIO;



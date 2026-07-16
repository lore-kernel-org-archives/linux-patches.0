Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFF9322A1F;
	Thu, 16 Jul 2026 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210102; cv=none; b=j0lmIYcTBvY6KYfvlZweSf5gQziv2kMMiZ10dsG5O6b9TxvIZmC/xhpr/inRCjhNZCg8WOWdVI0rV7jW2xTSdC3XgnERI3DJcvvrf+rAHL0YHFReLVtwXRMR/p7DFPynMadMkyPjw/QVPBF7OyM/soJkDnEouEtO7WljgWMoFOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210102; c=relaxed/simple;
	bh=cRbug4QBq9vy7AGMl2dJtsa5P/KLO3pozoSjCpMZQXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5ThcGSaaIXOvuXitZysSAvMW2gVa/V4jlbDEUL5aVuHMzqQJjtjFYdH2n/hOCyZFf+h8ricHpqSPgLpbOBoQk8o2gJuxFnCF/wczNHzQM4IjVGx6q4R+ytVF9WC4KJA8XdaLOEDo2sS0i3Yi07QmREem38cM7fmnxuD2uNqlmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8hIx0cC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8hIx0cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CC21F000E9;
	Thu, 16 Jul 2026 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210101;
	bh=WJ1Ups43LZV+A0ZuUBK91ohQ0S8JhdO+faJBkN9HHwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8hIx0cCGnrFP4s2/iQG4svfDKJVf5LtfHPdag/eEpvC0xt4QdM/bwHz+HPnp8ybl
	 wOMYNXLD8fyqd7cT/Jnb//Y7VRR9gMm9iqH/ZP3TPnU1otDp/ptSzBVmRkm9eiN2d+
	 WlQ0baJ//MiU9S0gsZ8UBokDfrhspARqLL6Vh00c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 401/518] spi: fsl-lpspi: replace dmaengine_terminate_all() with dmaengine_terminate_sync()
Date: Thu, 16 Jul 2026 15:31:09 +0200
Message-ID: <20260716133056.610332651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit e703ce47691b967fe9b4057fb1d062273211afa9 upstream.

dmaengine_terminate_all() has been deprecated, so replace it with
dmaengine_terminate_sync().

Fixes: 09c04466ce7e ("spi: lpspi: add dma mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20260525062357.3191349-2-carlos.song@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -647,7 +647,7 @@ static int fsl_lpspi_dma_transfer(struct
 				tx->sgl, tx->nents, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dmaengine_terminate_all(controller->dma_tx);
+		dmaengine_terminate_sync(controller->dma_tx);
 		return -EINVAL;
 	}
 
@@ -668,8 +668,8 @@ static int fsl_lpspi_dma_transfer(struct
 							transfer_timeout);
 		if (!time_left) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA TX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -678,8 +678,8 @@ static int fsl_lpspi_dma_transfer(struct
 							transfer_timeout);
 		if (!time_left) {
 			dev_err(fsl_lpspi->dev, "I/O Error in DMA RX\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -ETIMEDOUT;
 		}
@@ -688,8 +688,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->target_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA TX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}
@@ -698,8 +698,8 @@ static int fsl_lpspi_dma_transfer(struct
 			fsl_lpspi->target_aborted) {
 			dev_dbg(fsl_lpspi->dev,
 				"I/O Error in DMA RX interrupted\n");
-			dmaengine_terminate_all(controller->dma_tx);
-			dmaengine_terminate_all(controller->dma_rx);
+			dmaengine_terminate_sync(controller->dma_tx);
+			dmaengine_terminate_sync(controller->dma_rx);
 			fsl_lpspi_reset(fsl_lpspi);
 			return -EINTR;
 		}



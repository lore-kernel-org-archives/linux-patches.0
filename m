Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B9FC8C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7746EC433D2;
	Mon, 15 May 2023 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173583;
	bh=2FfGZjo7FUDhoZyMq1/9/RTqCi78hbp+/9MCOs6k9zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbMRUPy+9XbUKZi5rjLYGlqNzG+3bSC/Ao1tJPNX2480/ZYwia5OhS6dkCtnAh3yy
	 2ZLIfwiVeqn04bqUip5hC4Iiq6X4K+3xZ/Y5R9EvCnAEeOPtvYhurQP4x2arOH7ZES
	 LKMzSixdCvJQM+S4lCUxdON6vlqhqC2eRzRGfjts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/282] mtd: spi-nor: cadence-quadspi: Dont initialize rx_dma_complete on failure
Date: Mon, 15 May 2023 18:28:40 +0200
Message-Id: <20230515161726.479400492@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 48aae57f0f9f57797772bd462b4d64902b1b4ae1 ]

If driver fails to acquire DMA channel then don't initialize
rx_dma_complete struct as it won't be used.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20200601070444.16923-4-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2087e85bb66e ("spi: cadence-quadspi: fix suspend-resume implementations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
index 7e7736bbbfb3b..ad27d3e4c5dbc 100644
--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -1179,6 +1179,7 @@ static void cqspi_request_mmap_dma(struct cqspi_st *cqspi)
 	if (IS_ERR(cqspi->rx_chan)) {
 		dev_err(&cqspi->pdev->dev, "No Rx DMA available\n");
 		cqspi->rx_chan = NULL;
+		return;
 	}
 	init_completion(&cqspi->rx_dma_complete);
 }
-- 
2.39.2




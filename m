Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE313624BE;
	Tue, 16 Dec 2025 12:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887745; cv=none; b=C6EdtQKPruHzno9p3Rkhc2L3VQKyEEJLjLeTaIq7LFb2I1BkzVmDaS1/rJBSoH0/SdJfZCPXjgyDr9gtnCAm77uQvylRjg86qVUviJygLlV/M9szUTkiPnq+TRqkF+yfygez0BEhUH7LxOEe/lfqNBSRQQZduHkM3XC3MGsyTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887745; c=relaxed/simple;
	bh=dpZ30WiSNypazF1v/2AvuZZodCKu0jS5zPLQrYnOV2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9SUd1CtUpjLNWx8jbJG+v+771tvLZ99eTDQHl828rdtJZ+MSdFrKlKZU/A8UaGqLlrpTJjL25jp4O5lkEtJq2ZUydPToBvceCrg3HLgzJm522ZMBiJsjxuZF+Esi418UyXsoqwMhUIg2amklJgxJhCuqSe9OsTJjaUKAyiMY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwzLtV4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwzLtV4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F1C4CEF1;
	Tue, 16 Dec 2025 12:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887745;
	bh=dpZ30WiSNypazF1v/2AvuZZodCKu0jS5zPLQrYnOV2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwzLtV4zWlt37sShgOUJstoaP3jgIB1TqTZwR7hv+oWGMtM/uemlAavhCsRDNpa2f
	 J0UnfSnwd1kvOu1ZcP1lIOmk4m+YrFggiMtVyssm9ppF+YwZlZzOB0eh3Ru9ZHRFYf
	 2JpdjnW6cXihgvKiryWP5ZMbg1FelR1JnowN4V+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longbin Li <looong.bin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/614] spi: sophgo: Fix incorrect use of bus width value macros
Date: Tue, 16 Dec 2025 12:11:32 +0100
Message-ID: <20251216111413.141469701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longbin Li <looong.bin@gmail.com>

[ Upstream commit d9813cd23d5a7b254cc1b1c1ea042634d8da62e6 ]

The previous code initialized the 'reg' value with specific bus-width
values (BUS_WIDTH_2_BIT and BUS_WIDTH_4_BIT), which introduces ambiguity.
Replace them with BUS_WIDTH_MASK to express the intention clearly.

Fixes: de16c322eefb ("spi: sophgo: add SG2044 SPI NOR controller driver")
Signed-off-by: Longbin Li <looong.bin@gmail.com>
Link: https://patch.msgid.link/20251117090559.78288-1-looong.bin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sg2044-nor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sg2044-nor.c b/drivers/spi/spi-sg2044-nor.c
index af48b1fcda930..37f1cfe10be46 100644
--- a/drivers/spi/spi-sg2044-nor.c
+++ b/drivers/spi/spi-sg2044-nor.c
@@ -42,6 +42,7 @@
 #define SPIFMC_TRAN_CSR_TRAN_MODE_RX		BIT(0)
 #define SPIFMC_TRAN_CSR_TRAN_MODE_TX		BIT(1)
 #define SPIFMC_TRAN_CSR_FAST_MODE		BIT(3)
+#define SPIFMC_TRAN_CSR_BUS_WIDTH_MASK		GENMASK(5, 4)
 #define SPIFMC_TRAN_CSR_BUS_WIDTH_1_BIT		(0x00 << 4)
 #define SPIFMC_TRAN_CSR_BUS_WIDTH_2_BIT		(0x01 << 4)
 #define SPIFMC_TRAN_CSR_BUS_WIDTH_4_BIT		(0x02 << 4)
@@ -122,8 +123,7 @@ static u32 sg2044_spifmc_init_reg(struct sg2044_spifmc *spifmc)
 	reg = readl(spifmc->io_base + SPIFMC_TRAN_CSR);
 	reg &= ~(SPIFMC_TRAN_CSR_TRAN_MODE_MASK |
 		 SPIFMC_TRAN_CSR_FAST_MODE |
-		 SPIFMC_TRAN_CSR_BUS_WIDTH_2_BIT |
-		 SPIFMC_TRAN_CSR_BUS_WIDTH_4_BIT |
+		 SPIFMC_TRAN_CSR_BUS_WIDTH_MASK |
 		 SPIFMC_TRAN_CSR_DMA_EN |
 		 SPIFMC_TRAN_CSR_ADDR_BYTES_MASK |
 		 SPIFMC_TRAN_CSR_WITH_CMD |
-- 
2.51.0




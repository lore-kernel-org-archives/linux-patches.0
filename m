Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C093C355027;
	Tue, 16 Dec 2025 11:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885895; cv=none; b=qU+csZxznYbzlqaa5chgbaNheTfmIl6cl8/8r93H6Dj5mDPSd3t2nI2O8i+VGs2HwuaCuZUJjBnft3k8c0+z5M/QWKVMNazDfjnuBD+hDLOePiGMUfpW1zjgbGDWjlWcM9m8jU6oD2K0FRmZzuGc7V5bM7Abndv1fK/rAfKxI0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885895; c=relaxed/simple;
	bh=g7v6QniTIUoW2C7yiIwxuqD2IvVy+478n+SH3VD3FXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HR83IqOTtHfYgUK2GyfNCsCziKCLj40QoA7AWuX/EXy9h9ek5GE2j1y2PYFNloo5wm/Z9IIc2X7q9IMGbyn4BEb/6xVW+dg3T00EdPx8oU31oYREfN30oaxFJxjogJbPvz6uV5MZZ8hJqmy3GtPSiJRQsUD32CpdqIN1RuukXGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILFbP162; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILFbP162"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B9DC4CEF1;
	Tue, 16 Dec 2025 11:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885895;
	bh=g7v6QniTIUoW2C7yiIwxuqD2IvVy+478n+SH3VD3FXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILFbP162mKP6W4hCj/c7sa+OaXCuBA3d5pHP1fT8E4ky+SXCUjmpt+TzvssWOWVfa
	 OrJbcI3YEk3ntToC0brpU0ecPmMZ/5iHuTpNiGpfCyIHZPZH+Mguaq6XcloSCAs333
	 NA+XJ36nUwCDFwxjPmCKeGLEZJ1/1PXIHG0WjRoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longbin Li <looong.bin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 275/507] spi: sophgo: Fix incorrect use of bus width value macros
Date: Tue, 16 Dec 2025 12:11:56 +0100
Message-ID: <20251216111355.446168902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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




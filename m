Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055132;
	b=mCNWPyTmxJ0ExU0f8vKfthIZTue91+zPO3RU+xAl5nhGXolQ4jdQ9I9e8RBQSheZSWGC
	 W5sdrmaoJuN0+4jGnUctIWAd8Oeu3V7IX9sk7uvLF85m/ACeisgKMCnKnIcWhgHXaIOY9
	 vFOGZLt9tESGTKtMJyRaRF1z8CHL0tFJ7rKYC++gCgkm/dxsn2uHhfN/XdNhQnPGGxTMm
	 chIlBqq1S9lixOUW+uT9dhtyOhWU8ZbRRIgPcDKhdnieNPKYTOiJhH/g9mBKq5g2y7mjR
	 sgKT0VO6mRPLf1wB6dRHi8BsEzo5Osu/lZry9K+UPoO6/oR7Hk1luN3DMQTX1/r4Liw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k88BqesiutxRkyrsnAoVwNIW0yYTqtQtHJXHZVoc26c=;
	b=GL63opWQIm/57vFQL3mAfIy/JHehwfXOBHsuyLJl47BuE9j2Zlji2ZK10gKs8X72m0iP
	 uJ/d1gJv5B6EHcYzSfQclkWA7BKd/U/KawTHxrjqn9kp+NyQxD8CHY4QsGd/qdoW5SLv0
	 B4pldhD00aidzBtWP/yr+hs7/wb6Y6fKKkR8xd6Xg1/C5HPrBkdNoDwugPILCdgeuCPX9
	 xFyIinIP+tCqkem1VD4cfroyx9FUlO73Hb94yK3DhJbCx0HNppPWOEKUwRImrn+jPlVGI
	 pttLKu28yZQqJzP+jD/l514RGJH6awynsDI5Z3ZWabtAcZPvI002admNUyyBN4r40fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sU2JV7X1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4666606A320;
	Thu, 19 Nov 2026 02:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sU2JV7X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353D51F000C4;
	Thu, 19 Nov 2026 02:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055132;
	bh=k88BqesiutxRkyrsnAoVwNIW0yYTqtQtHJXHZVoc26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sU2JV7X14tkhFAWOxUou95pNIlTR1cMpQvJdPPZrwL3ZDvHqtrQl8GnQE2i5+LSpC
	 Tp6PSouZoDwYe94hzFwcetRbVAUQBydJIqRf7sm6i8R4JFw47Tq/7pjLCHiykEmKhb
	 HNMq0uDxPC9x2AVOBgeOUphKTcGr49qLQ87NZfBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1523/2214] ata: sata_dwc_460ex: Use devm_platform_*ioremap_resource() APIs
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150113.064776220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f713961de5057765bc663db72b7e540f27827750 ]

Use devm_platform_get_and_ioremap_resource() and
devm_platform_ioremap_resource() APIs instead of their
open coded analogues.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: e137035fcd66 ("ata: sata_dwc_460ex: Don't enable interrupt if libATA core registration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 1692c29227a02..7b0b320e4e825 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -241,7 +241,6 @@ static int sata_dwc_dma_init_old(struct platform_device *pdev,
 				 struct sata_dwc_device *hsdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct resource *res;
 
 	hsdev->dma = devm_kzalloc(&pdev->dev, sizeof(*hsdev->dma), GFP_KERNEL);
 	if (!hsdev->dma)
@@ -258,8 +257,7 @@ static int sata_dwc_dma_init_old(struct platform_device *pdev,
 	}
 
 	/* Get physical SATA DMA register base address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	hsdev->dma->regs = devm_ioremap_resource(&pdev->dev, res);
+	hsdev->dma->regs = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(hsdev->dma->regs))
 		return PTR_ERR(hsdev->dma->regs);
 
@@ -1224,8 +1222,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	host->private_data = hsdev;
 
 	/* Ioremap SATA registers */
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&ofdev->dev, res);
+	base = devm_platform_get_and_ioremap_resource(ofdev, 0, &res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
-- 
2.53.0




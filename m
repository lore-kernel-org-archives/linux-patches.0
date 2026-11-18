Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060642;
	b=RGrIS3mW6nelpjFZYTqqQ+YzYacdd01qa5DF4LPBD8iKjNjm58euXi05cikYVQ72Wzin
	 5Rxt8Ig/VW08XTZV+IbI3dEB03cCjb/flEMwpcCYGZRztxUgvSVwUMK+FA7E8QpR2f98x
	 NfEwE6PPA/Q9t4lnheTLY6M5HfRld7z9cs1pI6cmo0CNZqwM1LVHOUHI6VyyTYdEFIS/U
	 aQts3WHgxVN2vVUeWDAXQKFlzGS2W2NTjT1cA0ULuXSbiXeXU5qF+XsxN95fAGnwkZsBK
	 TJ94MSjidNMkBSeRowz7noZ2A5cXum/BwHNpRIOs5loc/iSvWP5wvr7KQeT7xI1Bi+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOW/7nnVI4YewiGCv9CoLv71KudVD0dbtdj+6AXYBUA=;
	b=IWYxljvpidBoKnOSYCOoF1A7ySFOfWhHymuW4O681842tLyyw5S0sULjCaxq40LPXyJg
	 EYF5tF9kIJluNyp36+I27EIR7mHe/kbWD5t4/c2fwVwpjwOfOqM1+jS5yhLu5UjgPdMpQ
	 0fqgLrnhj4na60ZuxlrG+0zfUi7YiKBvHZlE40VxnWkziu39yGl+IlkeSAZvcpO2aWYWw
	 IWlt3l4Scp8AObjtdoTF/AR08lqm9kTMMnLl8KCKizB9m0FwKBWR0X6R/86ppiqo0uycY
	 YwcZvjFX3heo+SNEN9vi4r96Bl2pdiMtCvSpcuENcg5wWgqXcXPoRysRjHp+W7e4RlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMqRA7kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465EA606A330;
	Thu, 19 Nov 2026 03:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMqRA7kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0E21F000C4;
	Thu, 19 Nov 2026 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060642;
	bh=qOW/7nnVI4YewiGCv9CoLv71KudVD0dbtdj+6AXYBUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMqRA7kXIsOlAEf6TN6wWIKocZUUZxDIGQBzCPFCsepV6GiTZZoYSQIb+MijyGtpV
	 WjH1wHlXQLC8w1Q0kBPieglYAo4FLHhfHFVvyiyUj4XMa0VSD/j/l5fap5PK7N0m/7
	 FFj7UkmmKPcmlofQZICIohB3X1ZFbIvcCteTOwvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1271/1848] ata: sata_dwc_460ex: Use devm_platform_*ioremap_resource() APIs
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150012.856688304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 26c3b287ac1f6..296ced0098b75 100644
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
 
@@ -1214,8 +1212,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
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




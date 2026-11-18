Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046223;
	b=tH5TwqDABe/ciMxOO4w/TJBHdWjyIW1GEk1IJI0qvSom+hmUFuz9x6z4sq9wKjMjtz0T
	 nDWcGDOB3X5NywzAxIt+x6VjXJTDORwzz5690SR0Uju8mKAlBKv6roTvddmdDdRL1PKR7
	 RuufuMCFhXqxYUWLmAlT9Vqy9eeaiS5EssfgUmrPzDZaEC7dkyLMuDqUz7bR6U5CQDluZ
	 LVt1jFG/JylnvOS6YDbSKV1HaTRon9q12gfE4U94imkRaX7/QSeIedHUFEBntC4lyJIs0
	 pxDB9VVS6SqeTa7t0y7ZjivP4bDS7LDg8BQfBjp9ugP5fDSCDCCymlR71qPxrLcyIcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i66bvC/9VTuTLxeFaJqsFOFWPiMSIC1kuXz179+bHLE=;
	b=EVnimnRkheUPQkPgaHMHmxwodjN7dq7TyFTvrh3WUjTHFQOWTPkn0mwgoYLNypJCJJaJ
	 fhCOhlDx+R0EB+WjPElU9hTWZe/7tbnkJMCTPhSYAbKGWEHVxw9k7vJXHlDUnkxC932Cc
	 mOp9ZJWBQSyJOdHao8tHRFaHtVUJp9HuiNTbxDvQJh7ehJMspm3c0Ox+w7SCkh25Mery+
	 V5GRBOxRJOM+ka2B/IsBBmLGVGc8lS2e8hJ9kuzPnJs+0rEr5ZoC1qm1RsSwtixCIzCpc
	 EJQYqi7fSviRVlSKUJwclWi3z4MqAyfP5agj+bqTWNwM3c48FRzFYpjwW4aoy4cNRsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcoOdaOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FED2606A31C;
	Wed, 18 Nov 2026 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcoOdaOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775351F000C4;
	Wed, 18 Nov 2026 23:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046223;
	bh=i66bvC/9VTuTLxeFaJqsFOFWPiMSIC1kuXz179+bHLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcoOdaOmwpxP0PqayA2CCsNbYFBQ/0vzruhXH/EepmLlnMqrirXJRwYxmJvYbcnaW
	 e5DV2f0xxdmOABdLwXzSnv/fUAXQ8dVKezxJhvKghmfsIWUK9G1UZgdA7IGrfciyJW
	 V83r3+LQERIvLabKABZeWgjaJwYhzxxM3D/F3CRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1164/2857] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118150243.500356303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0d66f9895f286d2fab396a71e6efeb95c4a7e5a6 ]

Replace the open-coded of_iomap()/iounmap() with the managed
devm_platform_ioremap_resource() helper. This fixes a mapping leak on
driver remove (the old code never called iounmap()) and simplifies the
error path by dropping the manual cleanup in ndfc_probe().

There is no overlapping memory-region concern introduced by this
change: each supported board DT describes a single ndfc node with a
unique 0x2000 register region, and the EBC parent uses dcr-reg rather
than a MEM reg resource, so the newly added request_mem_region() cannot
conflict with an existing reservation. Distinct chip selects map to
distinct 64-bit physical addresses, so CS instances do not overlap.

Fixes: a808ad3b0d28 ("[MTD] [NAND] ndfc driver")
Cc: stable@vger.kernel.org
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 47f6ef0c5d9bd..d2f4a2dfaebfa 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -184,10 +184,15 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 static int ndfc_probe(struct platform_device *ofdev)
 {
 	struct ndfc_controller *ndfc;
+	void __iomem *ndfcbase;
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len = 0;
+	int len = 0;
+
+	ndfcbase = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(ndfcbase))
+		return PTR_ERR(ndfcbase);
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
@@ -209,11 +214,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	ndfc->ofdev = ofdev;
 	dev_set_drvdata(&ofdev->dev, ndfc);
 
-	ndfc->ndfcbase = of_iomap(ofdev->dev.of_node, 0);
-	if (!ndfc->ndfcbase) {
-		dev_err(&ofdev->dev, "failed to get memory\n");
-		return -EIO;
-	}
+	ndfc->ndfcbase = ndfcbase;
 
 	ccr = NDFC_CCR_BS(ndfc->chip_select);
 
@@ -231,13 +232,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 		iowrite32be(be32_to_cpup(reg), ndfc->ndfcbase + offset);
 	}
 
-	err = ndfc_chip_init(ndfc, ofdev->dev.of_node);
-	if (err) {
-		iounmap(ndfc->ndfcbase);
-		return err;
-	}
-
-	return 0;
+	return ndfc_chip_init(ndfc, ofdev->dev.of_node);
 }
 
 static int ndfc_remove(struct platform_device *ofdev)
-- 
2.53.0




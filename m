Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063878;
	b=4gBqJOIdadwTBpN8BrOl2iK/vsvQVuZdraDZ7lShAwHlctZwYpk2eQzdIqTbriJm5GMT
	 GzW+us8s9mjITYsVqWJNI77e/FFgUpB4vqDiIqJZqZONi3F737rX7rVrsSFOdE8eM0p+J
	 8Eyo74WDd4fCBGm0idirJbC9Z3cxKVx5ZpLc908DItqSxt0Zl0Y6160RXlpI6gAwpuZ7j
	 FHTN7j0iF94L/zx19AiVEgdyUqnsrAHrKc5i5GlVFq0HnltQg2Wo/PSD54xEXi3A7MXgc
	 ZGuRcvTzeWYshIlkEyQIHs8p4fVpN9F7CCnPpN0S7AHP3ovBSb9FhBkjnEc4Lg3iarw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bnMKaffwmDTk9YpoQTsCZDEYuPtJ8UUyFfrrf7RW14c=;
	b=GERC+1JFElT8KZN4B8Wxi7LN4ICtWI99IkERX5RQPFzSKqfy2ViYxVNmsyk1gVyrYDHa
	 /d6//DG/rlu7f7Q4remxRJ1EJfkXxsZ3dVm0OSYW+14FAcWWzCo7KTxUIYxea6yGdZy/c
	 b1saKuuRFgZDvJMrPNFgHPuyiZMyyXPo136ZQLda9oix+eLojTKmPK8/61UGuZwM0IBxM
	 BjiQnfPCQ/AxGAtHTCd/qDuIyX2PoUmWiU8gwqWOv/N3Nu/ZF4KG4/IZfR4tgZn5Tf7dX
	 jgpa5+JNC62Iz86nzXoH5UCXjyLd2tyT9hgcdi0ZjU9udI5qZ5kv2BukZlmwY9Z8ZAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fTD/d8IZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A2606A32F;
	Sat,  7 Nov 2026 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTD/d8IZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5AD1F0089F;
	Sat,  7 Nov 2026 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063878;
	bh=bnMKaffwmDTk9YpoQTsCZDEYuPtJ8UUyFfrrf7RW14c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTD/d8IZ12T7e6cqnOHykXhL19GaCRet4xVv7jlLeOSNS+0HY94WKj9iaM4YRDstB
	 YK5pmxFi4iI6N8el8PqkSgp82quS/yVKb8u+ZDB2ESWpdhMq/qzsqT2ztu8RBSDNvg
	 iZeXaCbAIPBeWQNX5AoEDi1/dJqUwapME9BSQBKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0081/1257] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Sat,  7 Nov 2026 08:39:37 -0500
Message-ID: <20261107134941.612586739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a48274297d3b1..d6db04d48c45a 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -185,10 +185,15 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
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
@@ -210,11 +215,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	ndfc->ofdev = ofdev;
 	dev_set_drvdata(&ofdev->dev, ndfc);
 
-	ndfc->ndfcbase = of_iomap(ofdev->dev.of_node, 0);
-	if (!ndfc->ndfcbase) {
-		dev_err(&ofdev->dev, "failed to get memory\n");
-		return -EIO;
-	}
+	ndfc->ndfcbase = ndfcbase;
 
 	ccr = NDFC_CCR_BS(ndfc->chip_select);
 
@@ -232,13 +233,7 @@ static int ndfc_probe(struct platform_device *ofdev)
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
 
 static void ndfc_remove(struct platform_device *ofdev)
-- 
2.53.0




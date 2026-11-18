Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059400;
	b=TgYCQU3+BnFyQ9Df59iOYoWWLXDMxslvj60RNTVznaH9fOoZbJzKmsI6rB8hDHLh4uyu
	 G072xSt6TNvPpoNqr5tVAO+/b2HGqZLPASt8xDsMCklgMci/wUTU3LutbtEvaX0WZUd5J
	 AD5f+nW+CzSh87hmmOXRczHAOdLthaZlsJELCvC1rFwVFaOktDw5F1R0ExzDHS1ra0hMX
	 CHURri0BNWT/rLPJ0FkeAQ9MIGVGSegTfARNCIOG1hFxbhibKgCEWFd8kiad2rUWGppyu
	 swiLD41qlb96jcgVy4oSN3U2YOjIVL/mETdqSHnDM6T3kpK4FdkHOWLw1HXq8yTIdMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raFQc7s8ddNzVVwUXCA9iusdKmH+WkY4M/9c7/Ul+co=;
	b=FLFX38nSbKnTH4zynYMRQL/ivRHo0IYIzE+eDaCD/GZ6gUy/Biih51z/qfgLEE4klKgl
	 QBQDEJFttc182HLUNijlqjpmXpJgXJTAPSkmFQerz8uzA2SqP4wW/ep3MZpy43ldOavUH
	 cUIaKRMwbtS0X7I05LZ7Br/Zkht4jOx+EfOjIyeRD4Y5f8IqdsS5rxGwFACq9rImeIbgP
	 GjoQ+SYpE1Jes/RgfX3p9O2FkIWSolfk2aXU0HW80Dv3KXyT9oi7+Kk0zxLdikDRIyqkh
	 9ZgcUFTedj9AQ0F54XbpFyDp6VAMIW5SyOw8hDQVmfyShHoV8Wkenjgl1bD7uEzZx/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9rHfKXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DA1606A31C;
	Thu, 19 Nov 2026 03:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9rHfKXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF19D1F000C4;
	Thu, 19 Nov 2026 03:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059400;
	bh=raFQc7s8ddNzVVwUXCA9iusdKmH+WkY4M/9c7/Ul+co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9rHfKXoVAJfHsCEVZ6LTh96vdikKSrZtAGCRs41Pc1rXKnPTl36/Qf0VRwUVqVtK
	 g/JzPfiXqAKI6wwF2K4OX+MKu4PoPRy23UtJ4GZzT4r7F3kuFH3OL6sGN9j3RrPfAK
	 GnlGb/ENC/3IsuAaST9dzBrY7tvXO3nRSw6QgTAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0827/1848] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:47:45 +0100
Message-ID: <20261118145951.345729042@linuxfoundation.org>
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
index b9223cdaa8e34..97a2e36d812ac 100644
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
 		out_be32(ndfc->ndfcbase + offset, be32_to_cpup(reg));
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




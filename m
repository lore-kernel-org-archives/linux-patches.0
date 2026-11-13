Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590093;
	b=vUap/Ns0s8Lzva1vPnf0lxsseik7PjOTkvoFg116NljJl+p07FrXAicJT2cIN8KkirZk
	 4XsWX2JDpr1Ts8+JBgCsaOHXvFssUNFIaN/N9r7yWZLSKKA79XA73/OylcxK3YmwzOc4D
	 TAQZ8DDe86jAr0zCzhl/h4/dsr/smraFCKk+Gb1jHd0Wc/oX6DRYe+Moi2a+JsIgzIBJt
	 dKm/QUAhRM/G/Haizzj5/boiLF6E1HtE/WxUWElJlIClLHJo1knSgxaCTkoJ7Fan2h0mG
	 GG1qOGCzOi2OeWaznn2FWrU2FwzKwQSK9HaHWH7PXxPAGPi+ZHIBuxvSmOirpDMpkhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0Hc/ozZWflxpOpfJ2tdtn3ks/348z2nZnnpSCsrACI=;
	b=M3VXLOVVdWDmvXgMLFvoic/3FGWMcQTs3RKYoZmc3OsqQzQRZDc3tc4M+aqD4LwLZDf3
	 VUl5JYzsGiUChcX+XzdEmTLSLZgoeJlcZCOkBTi8GTB7PiXpHX1s2mSasmZVE89zmTGXY
	 c8UE79w2YGBU2VeV9wjhieHYeEoR14dtqntOBsOqTi2xMKkEtgQ+J6I6G54AhH6uE5ZBf
	 H4DgxDJ/PpJjbZJGaqoPkQjx7xCwRoWDM0voaFhZ/XyH/l0pfSFICRi4TCqV/ERhYeMWS
	 OSOx1VNf2jdTOqNyQWV3Ujzx1+tU1V8BCfhFU+K9CyTfc5bbcQlqq1lI3oMnR63tY9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujo9PnXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D851606A323;
	Fri, 13 Nov 2026 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujo9PnXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2A41F000C4;
	Fri, 13 Nov 2026 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590093;
	bh=i0Hc/ozZWflxpOpfJ2tdtn3ks/348z2nZnnpSCsrACI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujo9PnXEAP1H3khYcMvIUGJU6FVSpsjoivAzM3GGwgMM2zWdN2520ttwLJSWjtuPL
	 8yh6io/sI1Moe54Zi1w56RJrztYA3vC4vSZBNf0LEj0oGZxdgf1BjdRgT5FNXUs8Ws
	 g6voXf4zDy6alXy8FUnfeYsh6gAcsBKyGVTUOMD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/686] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Fri, 13 Nov 2026 10:43:45 -0500
Message-ID: <20261113153823.986786885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e1628d021a8b6..6f67bfe32a094 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046150;
	b=2l9UT2a2SRLYkRRQ9AXDd0AUgD6ge0GMtc46p0wWHqrB7Xo6rBYAtdXHQUUc474P9Fsi
	 nJlvagTO4ExouEVFnMQ5Ma5WBrm1m6VZHyJo0rIoa0UargcRfMTOxh3o16AhRmmeFOxgH
	 G78LinHSPqWHvnGtW3OoDqT4+LA4iege9Uw/vIN2G9GBrzyDdKY441/MH3eVB0rn6m6b4
	 7XYckT/G15uMp5a3CiG6q2A9FOOOC8vHkYY+rc06ZQa58IXvTGHqUdfdNDnZo0wCTlyOo
	 Y6y1I1V1wYx3J2mq8++0SVwLTVuZvsQpqibNK7ENwyKj9HlbOI5UfGQCWi+ZyEmNTJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jshfVg/kINrpP4cIfPdhL9Kavf5arm/Wor//Z8wdaZ0=;
	b=nF+hlFGVqn2XVMd/mWnXqDauo9AtlwZNPHcBPBL/kixP9wszdiUl6caIRhJSAfU7YnvY
	 RqcD/NYuDZZ1Zpry3uatrNevo+VYz8Lzp4i93YD3V+Y27O9DPIDtHaE8ZiOC65vyxAAl8
	 nqP+X6fTjjTaNamNinSnG2wMYt6seyNG2Bngheb4ALRZzursHw4lq3/lOk2/ES1UV0oNv
	 6RL7DzIAmSKk79lEy7KLY1r/OV2HfeJ8GOTDeTGQtZpuqWa8xlht6IgCJW/TX0h0+zsEl
	 XhFXvzKncY16Y5ta6FsRmxW55QWAEi/r+csAKjBH48QSKB6moj1ePEv3VCnmVISdiGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JWTuP0Y/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C048C606A31C;
	Wed, 18 Nov 2026 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWTuP0Y/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA5E1F000C5;
	Wed, 18 Nov 2026 23:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046150;
	bh=jshfVg/kINrpP4cIfPdhL9Kavf5arm/Wor//Z8wdaZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWTuP0Y/ShYmoODO1m1MybpyhfJoPNyxOWwOwTgeNelIAwei7X+H+kLDhdQXJlYbK
	 bQctoJZYN9EbZdgc13WiLVJJF7FlVp1Lnc2U4Qxt8tm/NENSTwAmOejguY/hzxx2t0
	 SEgdwQJ4sGik/KDS7DkXN4quK3+/i/XMXPeC0LhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1161/2857] mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST
Date: Wed, 18 Nov 2026 15:36:35 +0100
Message-ID: <20261118150243.391405318@linuxfoundation.org>
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

[ Upstream commit 4f2692a5383e4bdd43ae940cda012360f7217a2d ]

Replace ppc4xx-specific in_be32/out_be32 with generic ioread32be/
iowrite32be to make the driver portable. Add COMPILE_TEST dependency
to get build coverage on non-ppc4xx architectures.

While at it, replace 4xx with 44x. The latter was removed a while ago
and is only kept for compatibility.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/Kconfig |  2 +-
 drivers/mtd/nand/raw/ndfc.c  | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 900b121219394..ed828149c94cf 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -71,7 +71,7 @@ config MTD_NAND_AU1550
 
 config MTD_NAND_NDFC
 	tristate "IBM/MCC 4xx NAND controller"
-	depends on 4xx
+	depends on 44x || COMPILE_TEST
 	select MTD_NAND_ECC_SW_HAMMING
 	select MTD_NAND_ECC_SW_HAMMING_SMC
 	help
diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 338d6b1a189eb..7dfb7b2f2f3cf 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -43,13 +43,13 @@ static void ndfc_select_chip(struct nand_chip *nchip, int chip)
 	uint32_t ccr;
 	struct ndfc_controller *ndfc = nand_get_controller_data(nchip);
 
-	ccr = in_be32(ndfc->ndfcbase + NDFC_CCR);
+	ccr = ioread32be(ndfc->ndfcbase + NDFC_CCR);
 	if (chip >= 0) {
 		ccr &= ~NDFC_CCR_BS_MASK;
 		ccr |= NDFC_CCR_BS(chip + ndfc->chip_select);
 	} else
 		ccr |= NDFC_CCR_RESET_CE;
-	out_be32(ndfc->ndfcbase + NDFC_CCR, ccr);
+	iowrite32be(ccr, ndfc->ndfcbase + NDFC_CCR);
 }
 
 static void ndfc_hwcontrol(struct nand_chip *chip, int cmd, unsigned int ctrl)
@@ -69,7 +69,7 @@ static int ndfc_ready(struct nand_chip *chip)
 {
 	struct ndfc_controller *ndfc = nand_get_controller_data(chip);
 
-	return in_be32(ndfc->ndfcbase + NDFC_STAT) & NDFC_STAT_IS_READY;
+	return ioread32be(ndfc->ndfcbase + NDFC_STAT) & NDFC_STAT_IS_READY;
 }
 
 static void ndfc_enable_hwecc(struct nand_chip *chip, int mode)
@@ -77,9 +77,9 @@ static void ndfc_enable_hwecc(struct nand_chip *chip, int mode)
 	uint32_t ccr;
 	struct ndfc_controller *ndfc = nand_get_controller_data(chip);
 
-	ccr = in_be32(ndfc->ndfcbase + NDFC_CCR);
+	ccr = ioread32be(ndfc->ndfcbase + NDFC_CCR);
 	ccr |= NDFC_CCR_RESET_ECC;
-	out_be32(ndfc->ndfcbase + NDFC_CCR, ccr);
+	iowrite32be(ccr, ndfc->ndfcbase + NDFC_CCR);
 	wmb();
 }
 
@@ -91,7 +91,7 @@ static int ndfc_calculate_ecc(struct nand_chip *chip,
 	uint8_t *p = (uint8_t *)&ecc;
 
 	wmb();
-	ecc = in_be32(ndfc->ndfcbase + NDFC_ECC);
+	ecc = ioread32be(ndfc->ndfcbase + NDFC_ECC);
 	/* The NDFC uses Smart Media (SMC) bytes order */
 	ecc_code[0] = p[1];
 	ecc_code[1] = p[2];
@@ -113,7 +113,7 @@ static void ndfc_read_buf(struct nand_chip *chip, uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		*p++ = in_be32(ndfc->ndfcbase + NDFC_DATA);
+		*p++ = ioread32be(ndfc->ndfcbase + NDFC_DATA);
 }
 
 static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
@@ -122,7 +122,7 @@ static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		out_be32(ndfc->ndfcbase + NDFC_DATA, *p++);
+		iowrite32be(*p++, ndfc->ndfcbase + NDFC_DATA);
 }
 
 /*
@@ -222,13 +222,13 @@ static int ndfc_probe(struct platform_device *ofdev)
 	if (reg)
 		ccr |= be32_to_cpup(reg);
 
-	out_be32(ndfc->ndfcbase + NDFC_CCR, ccr);
+	iowrite32be(ccr, ndfc->ndfcbase + NDFC_CCR);
 
 	/* Set the bank settings if given */
 	reg = of_get_property(ofdev->dev.of_node, "bank-settings", NULL);
 	if (reg) {
 		int offset = NDFC_BCFG0 + (ndfc->chip_select << 2);
-		out_be32(ndfc->ndfcbase + offset, be32_to_cpup(reg));
+		iowrite32be(be32_to_cpup(reg), ndfc->ndfcbase + offset);
 	}
 
 	err = ndfc_chip_init(ndfc, ofdev->dev.of_node);
-- 
2.53.0




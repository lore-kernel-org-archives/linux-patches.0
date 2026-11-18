Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053124;
	b=vAuRLoUJ6ywQVXEL99cRnjJo3C5NQbhMk6TPSarjXPc4ssn4lJwTYE+F58LhqMP+5DHg
	 oK/q14I/vlZA+/U6MkBsS2gFw36cXH4y7ngTr/ZNe/iCMOH8R4YCB5JDcPcC5FPgX4XXV
	 aelmxKCQRl8X8InOHaZp4x4WvPbFMgv/Onzosn03xXufjFz6FVBIMF//bpxC3cXG0vxLm
	 ZYPnFAcpofVLKvPWkN/su4dPmQuNuA8SlbGsKHSn8/bKTT2hoPk/0RFEIldDL7Y8bqRik
	 ReIKom90FpTBMZu946P+DqADBHZ0bSdxjNjGxiOJJaF3gpSBVTd6y/Z80ZLVlvAA1Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ujmutLQ0hOMCSWo7puuUZpxoHHmHij4b2ub9GQ8jAtY=;
	b=fytjnTueLuAkeVnHnZVmA3Gv+hV8i6QVNFjgIDpsXczZhksAgEI689cc3gomCmC6RbN/
	 bp1Sst+SuYKL69VgHcwiEw9Vu+7yEuCshFSJD/gW72/ApoUXDC2sS0QimIv80g/UPmQjR
	 P3WW/zmy8tlymOMCgCjCvDnqdDMCWVne8YNHTtUo46eMqgeEb0yXrgkYwUrlL2TV65dVM
	 aO1xa5gFHn7VvnxD0Mq4htPbvJnSeNGbd6kG2tu1LBvAQjWem4YmeTEsCsuxLLHsy2DAq
	 +IOKnWHDDOazb1iZcRcxup8rQsxC7+ec8aRXE/ZCrhJ9hSG9jbYdxewWyUv4hY1BwxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U/baGsO1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC757606A330;
	Thu, 19 Nov 2026 01:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U/baGsO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4176E1F000C5;
	Thu, 19 Nov 2026 01:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053123;
	bh=ujmutLQ0hOMCSWo7puuUZpxoHHmHij4b2ub9GQ8jAtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/baGsO1+aZpabEfzk0pwZvpJwe26KnSlsbacjOfppUZg9Fc3XjwU1j25z2fiwCik
	 EDIWDiLO/RdaTAnAUponkV1waMVbaKrhJlN8UhPtUE9U9OzGn3JGVHX0xPBECdKFXy
	 HAsijuY6WWOC34O/wntAKSRsO2wJOHbNQlWeaiwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0808/2214] mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118150043.800546147@linuxfoundation.org>
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
index aa584aaf8ae3f..77655fdbfa9b8 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -70,7 +70,7 @@ config MTD_NAND_AU1550
 
 config MTD_NAND_NDFC
 	tristate "IBM/MCC 4xx NAND controller"
-	depends on 4xx
+	depends on 44x || COMPILE_TEST
 	select MTD_NAND_ECC_SW_HAMMING
 	select MTD_NAND_ECC_SW_HAMMING_SMC
 	help
diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 98d5a94c3a242..a35be06378662 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -44,13 +44,13 @@ static void ndfc_select_chip(struct nand_chip *nchip, int chip)
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
@@ -70,7 +70,7 @@ static int ndfc_ready(struct nand_chip *chip)
 {
 	struct ndfc_controller *ndfc = nand_get_controller_data(chip);
 
-	return in_be32(ndfc->ndfcbase + NDFC_STAT) & NDFC_STAT_IS_READY;
+	return ioread32be(ndfc->ndfcbase + NDFC_STAT) & NDFC_STAT_IS_READY;
 }
 
 static void ndfc_enable_hwecc(struct nand_chip *chip, int mode)
@@ -78,9 +78,9 @@ static void ndfc_enable_hwecc(struct nand_chip *chip, int mode)
 	uint32_t ccr;
 	struct ndfc_controller *ndfc = nand_get_controller_data(chip);
 
-	ccr = in_be32(ndfc->ndfcbase + NDFC_CCR);
+	ccr = ioread32be(ndfc->ndfcbase + NDFC_CCR);
 	ccr |= NDFC_CCR_RESET_ECC;
-	out_be32(ndfc->ndfcbase + NDFC_CCR, ccr);
+	iowrite32be(ccr, ndfc->ndfcbase + NDFC_CCR);
 	wmb();
 }
 
@@ -92,7 +92,7 @@ static int ndfc_calculate_ecc(struct nand_chip *chip,
 	uint8_t *p = (uint8_t *)&ecc;
 
 	wmb();
-	ecc = in_be32(ndfc->ndfcbase + NDFC_ECC);
+	ecc = ioread32be(ndfc->ndfcbase + NDFC_ECC);
 	/* The NDFC uses Smart Media (SMC) bytes order */
 	ecc_code[0] = p[1];
 	ecc_code[1] = p[2];
@@ -123,7 +123,7 @@ static void ndfc_read_buf(struct nand_chip *chip, uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		*p++ = in_be32(ndfc->ndfcbase + NDFC_DATA);
+		*p++ = ioread32be(ndfc->ndfcbase + NDFC_DATA);
 }
 
 static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
@@ -132,7 +132,7 @@ static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		out_be32(ndfc->ndfcbase + NDFC_DATA, *p++);
+		iowrite32be(*p++, ndfc->ndfcbase + NDFC_DATA);
 }
 
 /*
@@ -232,13 +232,13 @@ static int ndfc_probe(struct platform_device *ofdev)
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




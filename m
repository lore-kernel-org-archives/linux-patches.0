Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590893;
	b=Jf9d1CJjP+cuLWzLa5olbxH6kW4cymxnbcFTQuPf1HZoWR3SO54sSEf4M0p82qVW7Hyl
	 E9wi8Nph7JMn196ZE1VSn33TcJzRND75uAcwqLN9hWJjBcsYPGqciu53N4TYxtxTrDQex
	 wmFf8ijlG29+s7yfT60zU8aTd+SUPthXhZbKK02W18Mi6putLfoLT7ayNE71LNUzoBIho
	 WwGO/QOK04AiD1l7YCm7WQj3pRpDhhxnjO3g5NguvJtHYNTTayIIPd8BUJKOFQe5lhBtQ
	 DIIrvz9heCU13OeWWVxKPHIAGoShlnEDNAKUWcOtcAdiL+jjatU5MlChA1s1lb/rGKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+XxiHRDc++e8GLA6BV/U3p3RDwTmx5yFKlJ6nOT9Ba0=;
	b=cXmi1WkWqYZga+u/j/XHSLX3m0XPW1Ww0vPXNsXmYX6iT600ECv2UkcCCq51nFATeadC
	 8FxabArX7LFe7r0mpN3OAlnniuBMgPiQSSmNpNOFjR7l/xjyn9OuLuULVwEnFptAgHKwJ
	 L5z2BGEX4w9sGQnc4+Q+GB588NfOZ0mUTRiI1cGTmo0UZZ3FIxd79St/a0663RCEgL0G6
	 rYkwMdLfrNo18jE0XR8oLlmTCTUFKo7JQH3cIcQ9DCavmpchWxbnF8brqWmdNsCGoMTNd
	 nkNTEPNMORbn4XTSQ2rUSiVsPxAmfFcXfdSbK/5ocjQ/t9vqGUjzl5gr/usoPNG/72g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSIctpQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8540606D871;
	Fri, 13 Nov 2026 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSIctpQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FC31F000C5;
	Fri, 13 Nov 2026 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590893;
	bh=+XxiHRDc++e8GLA6BV/U3p3RDwTmx5yFKlJ6nOT9Ba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSIctpQjiYuWSXvSSbb8JfWbupDMA/0nTWmgwUcOweYtc5IKsyiQe7LZVB3J8ZfVW
	 WFp3vDyIlqg9Ru5gH/SDeRStH4T/GsUX6MY2LqXhuo4hCT4TvDqyFX/5WUEL1auAWa
	 /vIT7X0mQYj0NXMw7FdwmLwwXJseVJIs08Uc+znw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/670] mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST
Date: Fri, 13 Nov 2026 10:44:09 -0500
Message-ID: <20261113153814.796224972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d0aaccf72d781..0c39b4f346a69 100644
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
index 3bb32a7c6d679..29198c4af5e6d 100644
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
@@ -114,7 +114,7 @@ static void ndfc_read_buf(struct nand_chip *chip, uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		*p++ = in_be32(ndfc->ndfcbase + NDFC_DATA);
+		*p++ = ioread32be(ndfc->ndfcbase + NDFC_DATA);
 }
 
 static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
@@ -123,7 +123,7 @@ static void ndfc_write_buf(struct nand_chip *chip, const uint8_t *buf, int len)
 	uint32_t *p = (uint32_t *) buf;
 
 	for(;len > 0; len -= 4)
-		out_be32(ndfc->ndfcbase + NDFC_DATA, *p++);
+		iowrite32be(*p++, ndfc->ndfcbase + NDFC_DATA);
 }
 
 /*
@@ -223,13 +223,13 @@ static int ndfc_probe(struct platform_device *ofdev)
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




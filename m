Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037333;
	b=UlpWVlLWEuVOfrvWU/jff4dPGTwa/SFG5rbBNGjDL4HdQZddMvGsqm9qufnxhZxNR9G/
	 larIcyDxQbVzIMe4WLPfKO5HTQb5rtE9ISUn2b8j2q862qDPGLKYJYLwhOnj/zpVCpsZX
	 b1PbRwl8lWI9sTdeIERwnMItAlLW5ZuRJMQKMm80ECPqdwJgS4EhAl1Zdp0wk323cQPBn
	 yaU+EVFvmjiKY9y9F4B8iylT3ZhAFCz11rV/jt772R46kxmX2hlMOHlnh6BNkiDGZviO9
	 k4eW+bbcomiPUYLiID6gWy9ApDHqUmU2r7fz+xCLTkmi87aihEUXtYzwYdh+vZvLoog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/1pDvr88GynfkUwkcuwsr12YGW+KLX+H3f9Sa7wFy8=;
	b=4O56ca64XkhWyb3ryEVgC/kDIgjA68QSE3eWLR07hNv/1+ipx9b4aK6qdua15RDsCZKo
	 H5ninz2CLDd9OrStjCQLqv2AEeA/Ea4qXqjJwfFu5E9ue+i6IAOeb8jJ4Op5mkqp7qn+P
	 ZI4XMnYN53zeIBPMDDAuACME0WBYfDqrLS8wNtAfRIZjc3l9V6JYCG/CC0R+5D+MOlxnr
	 qkyPHuTN0UPrCITu7qBExE42LGrNf72O6QPgRBaFTZKN4EJyRTTyUtuPQOfHB1VkkE27e
	 g1kytBfAYY+0jPPrHve3o71xdywKwSMrdPSyDESb3Ml2BNtkRFk96mAw/T9xB+IYE7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/GYU2w2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC7606A32C;
	Wed, 18 Nov 2026 21:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/GYU2w2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062671F0093E;
	Wed, 18 Nov 2026 21:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037333;
	bh=w/1pDvr88GynfkUwkcuwsr12YGW+KLX+H3f9Sa7wFy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/GYU2w2QP1PLmpaF2d2WkQ10JfPjxVDVzv4tHz/ZBDsxrAUYGm5hDmnoCdXv6deM
	 5/EeVsziXF7EGaE4rAtYhk0i0yFec6OcjeKuwXkVL6cN80m4oR0NWcddcPBh/XzOl9
	 PXVELCw4VhEGprimRgJ603wjZzzcVzaLAimFARXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1367/3318] mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST
Date: Wed, 18 Nov 2026 15:33:09 +0100
Message-ID: <20261118150401.505488338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6142573085169..d2cd9d7b04228 100644
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




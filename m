Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034459;
	b=GuGzI3+ZIsFAoMb+SkFTynarsKgu0u//OVGyAkeInYiDgc+u/nlLWpOnDMSrEp6UCRhT
	 0mLq5xo/yx1MfCmcSprbrAXSz/7a2d8Hm5Nc6ZmpQmRNU6EmCgbO2BnMojX+AWuCdAZ4M
	 6NYo2R7FGOyFsP34RS6oCpwvTQ9cb4tPvSkQn4/hK1uMuxTgNcKn6X/zHePyoUxI28zWF
	 Xh4R7H3iu87ZsGTvdHpMmUfrCU+ChXlTotqmphcp3pPhQlm9vsL6FQINAZdumO2UNoNq/
	 5Pd4Hs2jtb09LRNa2siCuL1/iq+gSRp+f+/P237/ob5WHXElekhqM6xOeB2DZCaBxgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GWt+XQxCjHErzFWtszvW/oJdiQPmNNOlme/O5Bm3yLg=;
	b=pqmdmHHch37lW39bbZx9TfFSa6CO8yrxgbTMOIQpukpBY1Z9jqaPb2uZ5ioGB0/KfTvY
	 wKbmVyBh0tM5Z4or9oNWQqYAaVj0IBMgoy9FOMt/oIz1d8cMoEMt/K6ei6Bl78tj794c5
	 +2voI2jHoCXOwgpASd8uUGaEREbZzT3QPq98IEJ1r6XiMxQYavZFO+/SfEZU9bON3melt
	 +wgLuHBO+bON5xLaEBo2dYQHnglEe01cHL6PCodDIEgLCs46dGbk0ZXtlDvvXdjLEpnc8
	 7Ucm6OVHU/d2qwG2V1k7+v+xOxh7LYa7GwPALLDBFSTdMH5DfoFWL00TahOE83R0+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gigg62GC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C182D606A32F;
	Wed, 18 Nov 2026 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gigg62GC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E861F000C4;
	Wed, 18 Nov 2026 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034459;
	bh=GWt+XQxCjHErzFWtszvW/oJdiQPmNNOlme/O5Bm3yLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gigg62GCs6/cVircSmDgu8phT7wrN2FEFbfaGOG7wJjmVYzgQejpkJc1lywk68PRi
	 hwHrRffEaNHKa8wIUFyMFTnx/XWuYpYNoRhyK55tMPqIf4HI/eXJWKx9cV+RUjqBBi
	 v2kwpeuJ2OokSuMLy12aSWZ5I42PMku0z2DAfLK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0375/3318] mtd: rawnand: pl353: Add message about ECC mode
Date: Wed, 18 Nov 2026 15:16:37 +0100
Message-ID: <20261118150327.478856035@linuxfoundation.org>
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

From: Andrea Scian <andrea.scian@dave.eu>

[ Upstream commit 1e06dbfdfb851170b243d6498e442b449324c664 ]

This just add some information on kernel log about the selected ECC

Signed-off-by: Andrea Scian <andrea.scian@dave.eu>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 80ecacd054ff ("mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 198bffa25db8b..56c789ab8c1a1 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -973,15 +973,18 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
+		dev_dbg(nfc->dev, "Using on-die ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
 		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
+		dev_dbg(nfc->dev, "Using hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1552124CEEA;
	Sat, 12 Sep 2026 09:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205484; cv=none; b=HbFZZeGMEVYvnmx8RsoKUmC/ikhAysDSdWimT/M/LtKHvw/agI4fbEOfDMNOAFXyhz1lyeao8Hi6xrLDhCZ0MuF8rIMKEF4K8cOrHocR/APqZq357xvh2uJlJKZIDVLhRR33Cl6Hx02y0el8jlxW7VqciuK21FcFlv5CJBeJ2kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205484; c=relaxed/simple;
	bh=Qypgwtjmb1WFxYS71WccClSSOj5f3Eim0M4X0CqsIas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RETwke/0fjsUiHC9iIvYh0hHCTnpLhGWYIABrJTruPFOUzx399qkodq7FLqnmiImMBSEtNrpoxFMR0ZSlK8mQFRXucafjZxjV6l3hcLcRwCKVQtz4XodPugQ7uFW408G+xDMJov4ly0UF54ANrE/zNWL7mmyxMpShOxifvVQHrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksdukPKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksdukPKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321911F000FF;
	Sat, 12 Sep 2026 09:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205483;
	bh=D8WpSrtvulZTNf0DiH5q7zNkclyA3p4djYqf8sE+LBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksdukPKKRD+zEokmJ2h7Sot/0xlHi9/Nc8sEm4Ld+KMAF5Ur/IEtiCBrCYLuim2ZW
	 oOs8m5CFy9kyXGVT/SQfnWl0pxDmADFsw4cAzyrs74V8qwp8idhQd9AfONaElmp3iF
	 Lo7cyQyA4y91ntUyFmUjTpZhxRpeMk0Ej7GvpT9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0012/1518] mtd: rawnand: pl353: Add message about ECC mode
Date: Sat, 12 Sep 2026 08:36:21 +0200
Message-ID: <20260912065623.689226708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Scian <andrea.scian@dave.eu>

[ Upstream commit 1e06dbfdfb851170b243d6498e442b449324c664 ]

This just add some information on kernel log about the selected ECC

Signed-off-by: Andrea Scian <andrea.scian@dave.eu>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 80ecacd054ff ("mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -973,15 +973,18 @@ static int pl35x_nand_attach_chip(struct
 
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



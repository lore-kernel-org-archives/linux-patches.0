Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5151952E
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E306C433D2;
	Mon, 12 Jun 2023 10:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565952;
	bh=5R9LiLoBYNM2/LGFnBweI5hXtrSpCx5qtvgXCbVJnjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRPtc+Z0HfIh+oQzEGcSkscIrzC2KA2ShyplWcTAXidGC+XUsm2DOQi9bK56g/NLZ
	 8cm7eKn9iGfBPxIATD5ulGUEiZWlzvI9Z4roExzgSpN2y8lcA81MXfwWs/1EHKhpR9
	 DHVwKchcKWzQQVenCLv/bjtFC0suHfunBug0dmBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YouChing Lin <ycllin@mxic.com.tw>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	JaimeLiao <jaimeliao.tw@gmail.com>
Subject: [PATCH 5.4 44/45] mtd: spinand: macronix: Add support for MX35LFxGE4AD
Date: Mon, 12 Jun 2023 12:26:38 +0200
Message-ID: <20230612101656.405428537@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YouChing Lin <ycllin@mxic.com.tw>

commit 5ece78de88739b4c68263e9f2582380c1fd8314f upstream.

The Macronix MX35LF2GE4AD / MX35LF4GE4AD are 3V, 2G / 4Gbit serial
SLC NAND flash device (with on-die ECC).

Validated by read, erase, read back, write, read back and nandtest
on Xilinx Zynq PicoZed FPGA board which included Macronix SPI Host
(drivers/spi/spi-mxic.c).

Signed-off-by: YouChing Lin <ycllin@mxic.com.tw>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1604561020-13499-1-git-send-email-ycllin@mxic.com.tw
Signed-off-by: JaimeLiao <jaimeliao.tw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/macronix.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/mtd/nand/spi/macronix.c
+++ b/drivers/mtd/nand/spi/macronix.c
@@ -116,6 +116,22 @@ static const struct spinand_info macroni
 					      &update_cache_variants),
 		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout, NULL)),
+	SPINAND_INFO("MX35LF2GE4AD", 0x26,
+		     NAND_MEMORG(1, 2048, 64, 64, 2048, 40, 1, 1, 1),
+		     NAND_ECCREQ(8, 512),
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+					      &write_cache_variants,
+					      &update_cache_variants),
+		     SPINAND_HAS_QE_BIT,
+		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout, NULL)),
+	SPINAND_INFO("MX35LF4GE4AD", 0x37,
+		     NAND_MEMORG(1, 2048, 128, 64, 2048, 40, 1, 1, 1),
+		     NAND_ECCREQ(8, 512),
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+					      &write_cache_variants,
+					      &update_cache_variants),
+		     SPINAND_HAS_QE_BIT,
+		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout, NULL)),
 };
 
 static int macronix_spinand_detect(struct spinand_device *spinand)



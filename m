Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CF7350A05;
	Sat, 30 May 2026 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161382; cv=none; b=eGyO8+/qnV0vcnzSCsR+nPmewDY5bXv4t8OD3NhZ8sqCimjXs+lnSFMVGTlrbhNn92SpExoqdt1Cz26NFKRqggmcNuZ/ygfCWX6DVHw966bsDgyVSXsKhtYmBPUidOdRBsT7+/VfpVK2mQ/HdINgbBw1Oj6g47csG8xmhVr6/E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161382; c=relaxed/simple;
	bh=CW9R31PE9c2XL7ZbFjKMhG19u93sbi97Gcz0KMWnIEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8/dvtFqNvr/nEBnka1fCXsTs7eQTF4GGY6WbFC1ZxZs31zx+pfBSvAS6MQc6o2QJql+IXlI53L9MTTP2BnjzBOAnOrA5rBBtnfl9z1Na7Xn3GpKC1BfhmfvBPzGE1L9H2rQmuWQdVqhdNCM02rMfvOS/auOTMRIieSt95iZhxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZkE1DnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZkE1DnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD521F00893;
	Sat, 30 May 2026 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161381;
	bh=EDBkhVrGWDiD9gK0oyHdReowacaDc/WEI1TMo0Atk1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZkE1DnWTrJ6NTWBQyy/FZTzaN4qjCyh4WKTwzskXPS5czMXmAaiU4jD8L3fdiCGs
	 6b0Bt4ndJr+qNUFvsXaitsKFX8qrGS6+8x75/wMUnw7rFjo+8FCK0zELYQINV+F1My
	 thvzm7bF8KfbpxdU0ZGRH4TO+ZYIG+pzpp+hjQKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 608/969] mtd: spi-nor: spansion: Add support for Infineon S25FS256T
Date: Sat, 30 May 2026 18:02:12 +0200
Message-ID: <20260530160317.219749752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit 6afcc84080c415df81765c6d773edcba8fc30f6c ]

Infineon S25FS256T is 256Mbit Quad SPI NOR flash. The key features and
differences comparing to other Spansion/Cypress flash familes are:
  - 4-byte address mode by factory default
  - Quad mode is enabled by factory default
  - OP_READ_FAST_4B(0Ch) is not supported
  - Supports mixture of 128KB and 64KB sectors by OTP configuration
    (this patch supports uniform 128KB only due to complexity of
     non-uniform layout)

Tested on Xilinx Zynq-7000 FPGA board.

Link: https://www.infineon.com/dgdlac/Infineon-S25FS256T_256Mb_SEMPER_Nano_Flash_Quad_SPI_1.8V-DataSheet-v12_00-EN.pdf?fileId=8ac78c8c80027ecd0180740c5a46707a
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Link: https://lore.kernel.org/r/097ef04484966593ba1326d0a99462753d7d1073.1677557525.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 60 ++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 3ae59c7822039..5914a6074a11e 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -29,6 +29,7 @@
 	 SPINOR_REG_CYPRESS_CFR5_OPI)
 #define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
+#define SPINOR_REG_CYPRESS_ARCFN		0x00000006
 
 /* Cypress SPI NOR flash operations. */
 #define CYPRESS_NOR_WR_ANY_REG_OP(naddr, addr, ndata, buf)		\
@@ -229,6 +230,62 @@ static void cypress_nor_ecc_init(struct spi_nor *nor)
 	nor->flags |= SNOR_F_ECC;
 }
 
+static int
+s25fs256t_post_bfpt_fixup(struct spi_nor *nor,
+			  const struct sfdp_parameter_header *bfpt_header,
+			  const struct sfdp_bfpt *bfpt)
+{
+	struct spi_mem_op op;
+	int ret;
+
+	/* 4-byte address mode is enabled by default */
+	nor->params->addr_nbytes = 4;
+	nor->params->addr_mode_nbytes = 4;
+
+	/* Read Architecture Configuration Register (ARCFN) */
+	op = (struct spi_mem_op)
+		CYPRESS_NOR_RD_ANY_REG_OP(nor->params->addr_mode_nbytes,
+					  SPINOR_REG_CYPRESS_ARCFN, 1,
+					  nor->bouncebuf);
+	ret = spi_nor_read_any_reg(nor, &op, nor->reg_proto);
+	if (ret)
+		return ret;
+
+	/* ARCFN value must be 0 if uniform sector is selected  */
+	if (nor->bouncebuf[0])
+		return -ENODEV;
+
+	return cypress_nor_set_page_size(nor);
+}
+
+static void s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
+{
+	struct spi_nor_flash_parameter *params = nor->params;
+
+	/* PP_1_1_4_4B is supported but missing in 4BAIT. */
+	params->hwcaps.mask |= SNOR_HWCAPS_PP_1_1_4;
+	spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP_1_1_4],
+				SPINOR_OP_PP_1_1_4_4B,
+				SNOR_PROTO_1_1_4);
+}
+
+static void s25fs256t_late_init(struct spi_nor *nor)
+{
+	/*
+	 * Programming is supported only in 16-byte ECC data unit granularity.
+	 * Byte-programming, bit-walking, or multiple program operations to the
+	 * same ECC data unit without an erase are not allowed. See chapter
+	 * 5.3.1 and 5.6 in the datasheet.
+	 */
+	nor->params->writesize = 16;
+}
+
+static struct spi_nor_fixups s25fs256t_fixups = {
+	.post_bfpt = s25fs256t_post_bfpt_fixup,
+	.post_sfdp = s25fs256t_post_sfdp_fixup,
+	.late_init = s25fs256t_late_init,
+};
+
 static int
 s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 			const struct sfdp_parameter_header *bfpt_header,
@@ -454,6 +511,9 @@ static const struct flash_info spansion_nor_parts[] = {
 	{ "s25fl256l",  INFO(0x016019,      0,  64 * 1024, 512)
 		NO_SFDP_FLAGS(SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ)
 		FIXUP_FLAGS(SPI_NOR_4B_OPCODES) },
+	{ "s25fs256t",  INFO6(0x342b19, 0x0f0890, 0, 0)
+		PARSE_SFDP
+		.fixups = &s25fs256t_fixups },
 	{ "s25hl512t",  INFO6(0x342a1a, 0x0f0390, 256 * 1024, 256)
 		PARSE_SFDP
 		MFR_FLAGS(USE_CLSR)
-- 
2.53.0




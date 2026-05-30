Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597B1263F44;
	Sat, 30 May 2026 17:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161486; cv=none; b=IXwPp4RbO2+mFIH28SVMdrX5fWuh+38l9urWnf8mc93aCicPQ11CftlGgpV5fgQ3f2qaedXg4HifoAMoXL+K66aIuqdoEJ1croc8N5w5PxU4Di2+J5mppkTc07rAZbLkxxa/RITWSTnxBMa8Mo4EplJ9v5OqUSXKAljoKMoRlW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161486; c=relaxed/simple;
	bh=MPoVRjhy9Ul9zx0mPSulR9vwBuP28OwM4hKnywpABBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4+g6ryULsRze9zGHuKCnONT+CHKEtyt1Kp6md1T18MCqnx/CQLPc7x5n0GHU1ncDRN1YujsYe9a4zHjtEalhOamVcVL7w3ZxjkkUSXGzroKR9j+ilWdHaspDSPmYcyoUoxptv9aPJ2VBvv4OmxlwB47Tm1aErmNOFqK+0QCLmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7yauQjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7yauQjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589921F00893;
	Sat, 30 May 2026 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161485;
	bh=4jWHuuehYrX5Wq4ZGl+FYmIM7BPYW8SvxswT1LMJG+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7yauQjxeEdtsc7/3fJdbBH5yhnIhoGQt6RQBBQ3Tvp/eJ1Bb7hA4giFD85Qg0Zk4
	 HOwd9ilWFg1lMlqMDQ/OrJmhHPSuvw+YRzI6XXUs+vAfqydpzGyOODx/oKKlD40tAi
	 1l3aHqtFKK4mqUQZl2HDwCqOYTQJj3VqwxwLdcMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 607/969] mtd: spi-nor: spansion: Make RD_ANY_REG_OP macro take number of dummy bytes
Date: Sat, 30 May 2026 18:02:11 +0200
Message-ID: <20260530160317.193347721@linuxfoundation.org>
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

[ Upstream commit d628783c46d3c317deb0671ceb986be358fbaf69 ]

Currently Read Any Register op is used to read volatile registers without
any dummy cycles, but the op requires dummy cycles depending on register
type (volatiler or non-volatile), device family, and device configuration.
Add 'ndummy' argument to RD_ANY_REG_OP macro to support other use cases.

Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Link: https://lore.kernel.org/r/03756e9e3ac41d2016a71d2afb702398dd0b19ed.1677557525.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index faa8a49545be7..3ae59c7822039 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -37,10 +37,10 @@
 		   SPI_MEM_OP_NO_DUMMY,					\
 		   SPI_MEM_OP_DATA_OUT(ndata, buf, 0))
 
-#define CYPRESS_NOR_RD_ANY_REG_OP(naddr, addr, buf)			\
+#define CYPRESS_NOR_RD_ANY_REG_OP(naddr, addr, ndummy, buf)		\
 	SPI_MEM_OP(SPI_MEM_OP_CMD(SPINOR_OP_RD_ANY_REG, 0),		\
 		   SPI_MEM_OP_ADDR(naddr, addr, 0),			\
-		   SPI_MEM_OP_NO_DUMMY,					\
+		   SPI_MEM_OP_DUMMY(ndummy, 0),				\
 		   SPI_MEM_OP_DATA_IN(1, buf, 0))
 
 #define SPANSION_CLSR_OP						\
@@ -148,7 +148,7 @@ static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
 
 	op = (struct spi_mem_op)
 		CYPRESS_NOR_RD_ANY_REG_OP(addr_mode_nbytes,
-					  SPINOR_REG_CYPRESS_CFR1V,
+					  SPINOR_REG_CYPRESS_CFR1V, 0,
 					  nor->bouncebuf);
 
 	ret = spi_nor_read_any_reg(nor, &op, nor->reg_proto);
@@ -173,7 +173,7 @@ static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
 	/* Read back and check it. */
 	op = (struct spi_mem_op)
 		CYPRESS_NOR_RD_ANY_REG_OP(addr_mode_nbytes,
-					  SPINOR_REG_CYPRESS_CFR1V,
+					  SPINOR_REG_CYPRESS_CFR1V, 0,
 					  nor->bouncebuf);
 	ret = spi_nor_read_any_reg(nor, &op, nor->reg_proto);
 	if (ret)
@@ -202,7 +202,7 @@ static int cypress_nor_set_page_size(struct spi_nor *nor)
 {
 	struct spi_mem_op op =
 		CYPRESS_NOR_RD_ANY_REG_OP(nor->params->addr_mode_nbytes,
-					  SPINOR_REG_CYPRESS_CFR3V,
+					  SPINOR_REG_CYPRESS_CFR3V, 0,
 					  nor->bouncebuf);
 	int ret;
 
-- 
2.53.0




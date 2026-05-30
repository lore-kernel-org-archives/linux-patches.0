Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567F263F44;
	Sat, 30 May 2026 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161479; cv=none; b=VukS9POI7w0ahGDDppGTS9E4bdOdGxcdYHsN0P3OOZYBLy/EUqekRV6vvSfqtKT8neyiB5U+YZwWJW0GiHRSdKtJyQhk2iDTnJpQkG5Un67jU/FVC0y+5UQwXhV4/bsYUSPLjXuEJIOUGBs6vTsB0cyKHHbRxQwCzbttF+VcMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161479; c=relaxed/simple;
	bh=Y7Nz4Nh0Vcm01ahjCTPiK7vkqi7KJjw2hwW78POlXk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEJXT3RBAbcrQlCOPfkOVp6i0A9y9pi62s+hhIiPPv5S9QFoGHi1jd+eNNWPPtUySmkDcUZJMsehos6t8Fh3yuont0ZCdTcOX2/Z77UZNTgLzXDSvafiGS+dIL/RWmyIfMLM39y1nqI45499US5eFXeU0bgADzA/U8qQsD9qnwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfP823Am; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfP823Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0361F00893;
	Sat, 30 May 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161478;
	bh=mCtCGA8DTYN47al5T3SkFMozhhSdbK5OKVqS18mH6zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfP823AmPE2DWTV15ksNPUGhnqIPYxrrB3xoK+PKU/+X/qeiYiE9AsMv9yvNn4zBQ
	 WpqoEnKy/YpDLQU5bISQNPiApcHC1QkIIvbkMnwF0bTGvM7ZQeqCB28NX/oGkv/yRk
	 XSF1kOYpq7K4j9zP9bEhmkgV5m0EnIxnx9Nm3QWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Michael Walle <michael@walle.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 605/969] mtd: spi-nor: spansion: Rename s28hs512t prefix
Date: Sat, 30 May 2026 18:02:09 +0200
Message-ID: <20260530160317.136206444@linuxfoundation.org>
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

[ Upstream commit 06051322704bf38cbd721e14bdbd6e43c8e6d7e1 ]

Change prefix to support all other devices in SEMPER S28 family.

Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/8cf6bc9bffd50e486867c0817de1fa56c5d308ec.1661915569.git.Takahiro.Kuwano@infineon.com
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 7e7c68fc7776d..0109fccca7ea2 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -288,7 +288,7 @@ static int cypress_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 			cypress_nor_octal_dtr_dis(nor);
 }
 
-static void s28hs512t_post_sfdp_fixup(struct spi_nor *nor)
+static void s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
 	/*
 	 * On older versions of the flash the xSPI Profile 1.0 table has the
@@ -316,23 +316,23 @@ static void s28hs512t_post_sfdp_fixup(struct spi_nor *nor)
 	nor->params->rdsr_addr_nbytes = 4;
 }
 
-static int s28hs512t_post_bfpt_fixup(struct spi_nor *nor,
-				     const struct sfdp_parameter_header *bfpt_header,
-				     const struct sfdp_bfpt *bfpt)
+static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
+				   const struct sfdp_parameter_header *bfpt_header,
+				   const struct sfdp_bfpt *bfpt)
 {
 	return cypress_nor_set_page_size(nor);
 }
 
-static void s28hs512t_late_init(struct spi_nor *nor)
+static void s28hx_t_late_init(struct spi_nor *nor)
 {
 	nor->params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
 	cypress_nor_ecc_init(nor);
 }
 
-static const struct spi_nor_fixups s28hs512t_fixups = {
-	.post_sfdp = s28hs512t_post_sfdp_fixup,
-	.post_bfpt = s28hs512t_post_bfpt_fixup,
-	.late_init = s28hs512t_late_init,
+static const struct spi_nor_fixups s28hx_t_fixups = {
+	.post_sfdp = s28hx_t_post_sfdp_fixup,
+	.post_bfpt = s28hx_t_post_bfpt_fixup,
+	.late_init = s28hx_t_late_init,
 };
 
 static int
@@ -468,7 +468,7 @@ static const struct flash_info spansion_nor_parts[] = {
 		FLAGS(SPI_NOR_NO_ERASE) },
 	{ "s28hs512t",   INFO(0x345b1a,      0, 256 * 1024, 256)
 		PARSE_SFDP
-		.fixups = &s28hs512t_fixups,
+		.fixups = &s28hx_t_fixups,
 	},
 };
 
-- 
2.53.0




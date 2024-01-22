Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A412A17F;
	Tue, 23 Jan 2024 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968809; cv=none; b=TbW2OJSVys7zsoONECeTgVnpsBhsofXzGlnsR/32zeEntrowR8D9f6e36SMXG2PpilIVMVQrcogPQmd34JeyXML03f12kEhHZXi8ZJIvB1WhE29xQriaL1O4skQyVZt1qSOy4kCio7t4G7lvAIS8smwFKqtW6VqljN5mPG0+zE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968809; c=relaxed/simple;
	bh=VAdiwpNE2RKfuTUQ5+mUignes6MHI0OaSEYjedqAsR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeG1UMHWWQtwMuAQumna3rMX5Q/N8wzxFZkDsNrJyIU++CtZ73z+oVjzts8tYfkKTI1K0LeNsBJvJWVRJYwkYzwYH8FxGabmgGws9T3Tqk8HjQ7L5+zRBrB7IAWrlaXsakhGdGOCRMKqOadSJgcDd/jA+c/Gt+xAgGiTaolm9bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/VDgDlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/VDgDlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E458C433F1;
	Tue, 23 Jan 2024 00:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968808;
	bh=VAdiwpNE2RKfuTUQ5+mUignes6MHI0OaSEYjedqAsR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/VDgDlc9om2W4SsLJiv+RcHMNfhjo4bTwXib2B3PEbA0H6Ph83LRxPZIrF3S0+uP
	 TrMeKvd66NsIkbuUffNP0MrDdMCyEreQGOIvq0FpfglQb0cTqco6pWeeFpJPeeWsSH
	 ZCNy3kiF0ZP+Tge/boypEsrAcDB613lX2uc0/mcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/194] spi: sh-msiof: Enforce fixed DTDL for R-Car H3
Date: Mon, 22 Jan 2024 15:56:27 -0800
Message-ID: <20240122235721.645407043@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit e5c7bcb499840551cfbe85c6df177ebc50432bf0 ]

Documentation says only DTDL of 200 is allowed for this SoC.

Fixes: 4286db8456f4 ("spi: sh-msiof: Add R-Car Gen 2 and 3 fallback bindings")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://msgid.link/r/20231212081239.14254-1-wsa+renesas@sang-engineering.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 8f134735291f..edb26b085706 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -32,12 +32,15 @@
 
 #include <asm/unaligned.h>
 
+#define SH_MSIOF_FLAG_FIXED_DTDL_200	BIT(0)
+
 struct sh_msiof_chipdata {
 	u32 bits_per_word_mask;
 	u16 tx_fifo_size;
 	u16 rx_fifo_size;
 	u16 ctlr_flags;
 	u16 min_div_pow;
+	u32 flags;
 };
 
 struct sh_msiof_spi_priv {
@@ -1072,6 +1075,16 @@ static const struct sh_msiof_chipdata rcar_gen3_data = {
 	.min_div_pow = 1,
 };
 
+static const struct sh_msiof_chipdata rcar_r8a7795_data = {
+	.bits_per_word_mask = SPI_BPW_MASK(8) | SPI_BPW_MASK(16) |
+			      SPI_BPW_MASK(24) | SPI_BPW_MASK(32),
+	.tx_fifo_size = 64,
+	.rx_fifo_size = 64,
+	.ctlr_flags = SPI_CONTROLLER_MUST_TX,
+	.min_div_pow = 1,
+	.flags = SH_MSIOF_FLAG_FIXED_DTDL_200,
+};
+
 static const struct of_device_id sh_msiof_match[] = {
 	{ .compatible = "renesas,sh-mobile-msiof", .data = &sh_data },
 	{ .compatible = "renesas,msiof-r8a7743",   .data = &rcar_gen2_data },
@@ -1082,6 +1095,7 @@ static const struct of_device_id sh_msiof_match[] = {
 	{ .compatible = "renesas,msiof-r8a7793",   .data = &rcar_gen2_data },
 	{ .compatible = "renesas,msiof-r8a7794",   .data = &rcar_gen2_data },
 	{ .compatible = "renesas,rcar-gen2-msiof", .data = &rcar_gen2_data },
+	{ .compatible = "renesas,msiof-r8a7795",   .data = &rcar_r8a7795_data },
 	{ .compatible = "renesas,msiof-r8a7796",   .data = &rcar_gen3_data },
 	{ .compatible = "renesas,rcar-gen3-msiof", .data = &rcar_gen3_data },
 	{ .compatible = "renesas,sh-msiof",        .data = &sh_data }, /* Deprecated */
@@ -1317,6 +1331,9 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	if (chipdata->flags & SH_MSIOF_FLAG_FIXED_DTDL_200)
+		info->dtdl = 200;
+
 	if (info->mode == MSIOF_SPI_SLAVE)
 		ctlr = spi_alloc_slave(&pdev->dev,
 				       sizeof(struct sh_msiof_spi_priv));
-- 
2.43.0




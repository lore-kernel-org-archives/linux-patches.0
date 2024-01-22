Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E952712A16D;
	Tue, 23 Jan 2024 00:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971034; cv=none; b=M2h9WY8yaZB9cJnD1xfrcWHlggQQ676oFeQrP9R6dTaF/yrnQ8NWipQtYCwRujjFnQ1fZn91Upg4mRGo3LkFqMcLcgwQDuTjSSG5hGN0U3XyOEnSbLXLQ+r1V6sEXiXULW27xwD0o/mBdaUMAUDvTw/Xd1Ah23T1/e4oH6MFxd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971034; c=relaxed/simple;
	bh=rBTGz7WDcc4qwZOywEh+VLNqlgQ2FK4yyAKJskIjv6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6qGR0KD8EwqI68EIi0IODuk9issC2EEGRKn5Zi8Gyyc7jD2zZ6B1i1CqWRuWPsdLnv7CwiO617sdox5BooQRydl6dVlJMlz3uPajkB5rRuSToFChHnPX0oa8xEfaVQEyKm3Yge7IUjSTLQAH6wDKs4Y4biWOW2H2SH7rICwgmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igEyQzGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igEyQzGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370D8C43390;
	Tue, 23 Jan 2024 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971033;
	bh=rBTGz7WDcc4qwZOywEh+VLNqlgQ2FK4yyAKJskIjv6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igEyQzGxAkLbHcIyWOFMbSAFMobHc+J9DTcobCfdk4kloQS0OnUeFd6xO6Gx31C2p
	 DeaqAQSm/St6ikIRtmWCApOsLxhOKTs2Pd4sEGj69GUaoC2uvbpZYCKUMgWbXkCNHI
	 gWaF/p6TE6ji0gQ17Mt85uCSEPhjNR8T+VhZff2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/286] spi: sh-msiof: Enforce fixed DTDL for R-Car H3
Date: Mon, 22 Jan 2024 15:56:19 -0800
Message-ID: <20240122235734.834242698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b2579af0e3eb..35d30378256f 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -30,12 +30,15 @@
 
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
@@ -1069,6 +1072,16 @@ static const struct sh_msiof_chipdata rcar_gen3_data = {
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
@@ -1079,6 +1092,7 @@ static const struct of_device_id sh_msiof_match[] = {
 	{ .compatible = "renesas,msiof-r8a7793",   .data = &rcar_gen2_data },
 	{ .compatible = "renesas,msiof-r8a7794",   .data = &rcar_gen2_data },
 	{ .compatible = "renesas,rcar-gen2-msiof", .data = &rcar_gen2_data },
+	{ .compatible = "renesas,msiof-r8a7795",   .data = &rcar_r8a7795_data },
 	{ .compatible = "renesas,msiof-r8a7796",   .data = &rcar_gen3_data },
 	{ .compatible = "renesas,rcar-gen3-msiof", .data = &rcar_gen3_data },
 	{ .compatible = "renesas,sh-msiof",        .data = &sh_data }, /* Deprecated */
@@ -1274,6 +1288,9 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
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




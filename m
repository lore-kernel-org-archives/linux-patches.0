Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047814;
	b=HJTdl49sKXbTXwLg0f5rgAlUop2nCSjVQzvArqJ/g6OZdMd6GusIVOBpTJQ8wspRmOQC
	 MKA3NPAGzkmmbrQBQr0h1iGGci4RrWfGrrEBeftKr8C5w4HBtD5I9jVMBFO6xr0hjjfZw
	 Ml39eDL6iN9Ievx/jJiOzGWXRlq0wATxx0DhoK7iRk/9CS3IRrUl5yvi7wcJqCcWbfnAV
	 Wv2egrQYZF3aSL07fo7Gq2je7qDpjhUd+stGlgCWyKMAIvj9IHE/1hVO1wrPxV+GWKLKx
	 6+lte79H3cGiHG4vp8XVyCy0br9LlDDaTlmShrn2Fbj7NvyBjWfvGR9ldfCndn4rz9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpnIevpUUc8nsy+k4ux4Aq9bwJgGYYVru2Fk17qwOdc=;
	b=CzKJDRwcfg7oCjxPhRgT7BPtnnIuMgBwcEGSHIGN9zOQOAqCqfDpK9TJpkfcKeBh2whr
	 s8mP3GzftuFMFMAvtJ4NH7nQkA52XtCfGX7kd6GFWzGg/kZjW23LnSc+yj0+AIs4YnHmv
	 Q7JofPZic9QUMGB1EJbok/73uj80ZcyT3yLAlpT6aBpyIhHC5pC/1uv/qEg4V6Fx2L3pZ
	 ULH+oHbNcTpGAaTfaAIs/w2AXMEQuSkJZ78Zc8Tg2CYvmG9VcGZ1NX2R+/Yqp3XVc3hvb
	 FfQ8ht68pQSNVDALv9qUBu506cf8CnIiKCDgH/8gONSwdq+E2S/U2xtq8+biKyb5Bjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPcy1jaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC668606A31C;
	Thu, 19 Nov 2026 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPcy1jaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF0D1F000C4;
	Thu, 19 Nov 2026 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047814;
	bh=dpnIevpUUc8nsy+k4ux4Aq9bwJgGYYVru2Fk17qwOdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPcy1jaAafzQxMWqrDrfk6xp9RxBEcXeMLY5Nc5cI9y25iaCDXez2sVY1WgCyeP26
	 YXKyAzQ4hggfcv+s8pZ0q4I4zDbkBj7DHHdEHPEC2wsvmRhX/IyPQIpNyJrx+oCEEj
	 uQ1kj04kwJd3s6r/Z31P5Q8iFkTo43yUtvLj9wUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1732/2857] spi: sh-msiof: SITMDR1/SIRMDR1 bitfield conversion
Date: Wed, 18 Nov 2026 15:46:06 +0100
Message-ID: <20261118150303.678744458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6bae252a9452ca8496670230a7821c34450763a2 ]

Convert MSIOF Transmit and Receive Mode Register 1 field accesses to use
the FIELD_PREP() bitfield access macro.

This gets rid of explicit shifts.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/9685c54e752b8ef4256c9b281e9d8292e71d222e.1747401908.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 152867998da9 ("spi: sh-msiof: propagate setup runtime-PM errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 45 ++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 94f2e07065b70..aaeafa4cdaec9 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2014-2017 Glider bvba
  */
 
+#include <linux/bitfield.h>
 #include <linux/bitmap.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
@@ -84,20 +85,19 @@ struct sh_msiof_spi_priv {
 
 /* SITMDR1 and SIRMDR1 */
 #define SIMDR1_TRMD		BIT(31)		/* Transfer Mode (1 = Master mode) */
-#define SIMDR1_SYNCMD_MASK	GENMASK(29, 28)	/* SYNC Mode */
-#define SIMDR1_SYNCMD_SPI	(2 << 28)	/*   Level mode/SPI */
-#define SIMDR1_SYNCMD_LR	(3 << 28)	/*   L/R mode */
-#define SIMDR1_SYNCAC_SHIFT	25		/* Sync Polarity (1 = Active-low) */
-#define SIMDR1_BITLSB_SHIFT	24		/* MSB/LSB First (1 = LSB first) */
-#define SIMDR1_DTDL_SHIFT	20		/* Data Pin Bit Delay for MSIOF_SYNC */
-#define SIMDR1_SYNCDL_SHIFT	16		/* Frame Sync Signal Timing Delay */
-#define SIMDR1_FLD_MASK		GENMASK(3, 2)	/* Frame Sync Signal Interval (0-3) */
-#define SIMDR1_FLD_SHIFT	2
+#define SIMDR1_SYNCMD		GENMASK(29, 28)	/* SYNC Mode */
+#define SIMDR1_SYNCMD_SPI	2U		/*   Level mode/SPI */
+#define SIMDR1_SYNCMD_LR	3U		/*   L/R mode */
+#define SIMDR1_SYNCAC		BIT(25)		/* Sync Polarity (1 = Active-low) */
+#define SIMDR1_BITLSB		BIT(24)		/* MSB/LSB First (1 = LSB first) */
+#define SIMDR1_DTDL		GENMASK(22, 20)	/* Data Pin Bit Delay for MSIOF_SYNC */
+#define SIMDR1_SYNCDL		GENMASK(18, 16)	/* Frame Sync Signal Timing Delay */
+#define SIMDR1_FLD		GENMASK(3, 2)	/* Frame Sync Signal Interval (0-3) */
 #define SIMDR1_XXSTP		BIT(0)		/* Transmission/Reception Stop on FIFO */
 /* SITMDR1 */
 #define SITMDR1_PCON		BIT(30)		/* Transfer Signal Connection */
-#define SITMDR1_SYNCCH_MASK	GENMASK(27, 26)	/* Sync Signal Channel Select */
-#define SITMDR1_SYNCCH_SHIFT	26		/* 0=MSIOF_SYNC, 1=MSIOF_SS1, 2=MSIOF_SS2 */
+#define SITMDR1_SYNCCH		GENMASK(27, 26)	/* Sync Signal Channel Select */
+						/* 0=MSIOF_SYNC, 1=MSIOF_SS1, 2=MSIOF_SS2 */
 
 /* SITMDR2 and SIRMDR2 */
 #define SIMDR2_BITLEN1(i)	(((i) - 1) << 24) /* Data Size (8-32 bits) */
@@ -341,8 +341,9 @@ static u32 sh_msiof_spi_get_dtdl_and_syncdl(struct sh_msiof_spi_priv *p)
 		return 0;
 	}
 
-	val = sh_msiof_get_delay_bit(p->info->dtdl) << SIMDR1_DTDL_SHIFT;
-	val |= sh_msiof_get_delay_bit(p->info->syncdl) << SIMDR1_SYNCDL_SHIFT;
+	val = FIELD_PREP(SIMDR1_DTDL, sh_msiof_get_delay_bit(p->info->dtdl)) |
+	      FIELD_PREP(SIMDR1_SYNCDL,
+			 sh_msiof_get_delay_bit(p->info->syncdl));
 
 	return val;
 }
@@ -361,16 +362,18 @@ static void sh_msiof_spi_set_pin_regs(struct sh_msiof_spi_priv *p, u32 ss,
 	 *    1    0         11     11    0    0
 	 *    1    1         11     11    1    1
 	 */
-	tmp = SIMDR1_SYNCMD_SPI | 1 << SIMDR1_FLD_SHIFT | SIMDR1_XXSTP;
-	tmp |= !cs_high << SIMDR1_SYNCAC_SHIFT;
-	tmp |= lsb_first << SIMDR1_BITLSB_SHIFT;
+	tmp = FIELD_PREP(SIMDR1_SYNCMD, SIMDR1_SYNCMD_SPI) |
+	      FIELD_PREP(SIMDR1_FLD, 1) | SIMDR1_XXSTP |
+	      FIELD_PREP(SIMDR1_SYNCAC, !cs_high) |
+	      FIELD_PREP(SIMDR1_BITLSB, lsb_first);
 	tmp |= sh_msiof_spi_get_dtdl_and_syncdl(p);
 	if (spi_controller_is_slave(p->ctlr)) {
 		sh_msiof_write(p, SITMDR1, tmp | SITMDR1_PCON);
 	} else {
 		sh_msiof_write(p, SITMDR1,
 			       tmp | SIMDR1_TRMD | SITMDR1_PCON |
-			       (ss < MAX_SS ? ss : 0) << SITMDR1_SYNCCH_SHIFT);
+			       FIELD_PREP(SITMDR1_SYNCCH,
+					  ss < MAX_SS ? ss : 0));
 	}
 	if (p->ctlr->flags & SPI_CONTROLLER_MUST_TX) {
 		/* These bits are reserved if RX needs TX */
@@ -565,12 +568,12 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		return 0;
 
 	/* Configure native chip select mode/polarity early */
-	clr = SIMDR1_SYNCMD_MASK;
-	set = SIMDR1_SYNCMD_SPI;
+	clr = SIMDR1_SYNCMD;
+	set = FIELD_PREP(SIMDR1_SYNCMD, SIMDR1_SYNCMD_SPI);
 	if (spi->mode & SPI_CS_HIGH)
-		clr |= BIT(SIMDR1_SYNCAC_SHIFT);
+		clr |= SIMDR1_SYNCAC;
 	else
-		set |= BIT(SIMDR1_SYNCAC_SHIFT);
+		set |= SIMDR1_SYNCAC;
 	pm_runtime_get_sync(&p->pdev->dev);
 	tmp = sh_msiof_read(p, SITMDR1) & ~clr;
 	sh_msiof_write(p, SITMDR1, tmp | set | SIMDR1_TRMD | SITMDR1_PCON);
-- 
2.53.0




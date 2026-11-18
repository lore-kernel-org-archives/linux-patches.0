Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054616;
	b=sCzAwAyVPJxxQB1x7WqG9Vl50nbOKd2Ibojb19tUXzPm3/C39BjdUVJ4YLkLWh4cQG7L
	 YXt3geeih01VCuJS3MEoZWxNZW35sagSLosyQ5LifPfReCwFkzUI9TjH2lcsW6vq83jmq
	 ptVJrJpdJeDRsRhk5dJN2VFShogOrxjtlwGnDa5jVGiYoSnjbn6YbZnl6j2PsLlXloe/8
	 g0GEyeyUB/pk27Yo3dLrQ3+K3m8/9vHz7cVQaTqcSJXUm68esiz/DeTW7xsAr8uW7xkun
	 EITiwMeadme7q1z+7zjfGbn1M5vKWc2AdSrJNb/w4OVsEIHgjb+TPDDvX0Gc0YxQElw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d2aiY1lkah1/DVC/1zL69zkDQBF+p2x7+TWDasu++HI=;
	b=OcVCTr3Nu29vWLkcrK98MY5vHiAIxpZE5V4qql5pc3pABvkNMiK+btylJL3Dkp+MhiLo
	 BtzEAW/lv0S+sg3rVKxtbIetoVahzy77YDanBwtV7hq0W0GK5w200x2/SjFKEUbU6CiJz
	 zkInzM/zN9nRHJEr1oXDW5el8mlmliUtMqElxRSUq1kufB+SJqOP31oOZz69FN0KFvhhn
	 Y3dVZK+RfaGy1P6VehmiREu2vfCjmL0REsdUOxD0twZux9ISEBIF6PYBLovhosMuBZzxS
	 bLOX+r+EC7ZU8jrCnHMozLbuIPAE37XG5N3ZGhuuRkiDqsBaGBNiAWbnq+gkLikvSgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyM8FTgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C730606A330;
	Thu, 19 Nov 2026 02:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyM8FTgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CB11F000C9;
	Thu, 19 Nov 2026 02:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054616;
	bh=d2aiY1lkah1/DVC/1zL69zkDQBF+p2x7+TWDasu++HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyM8FTgFjOI1YEr7UYKsXycKaVgAXEw0ME3rizvv7zFa8n6NOqESsMU10/XJ4Ybs0
	 tXwFkbeAbqgEN60ySkqZ4CWwiC5+tTGTOsNzjDEJEVoyrzxBYK0I8A7HNOZfqrZvNX
	 e1U89NfboSObycJk/+uyjV8o8s8CGGzvyLaGh1aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1331/2214] spi: sh-msiof: SITMDR1/SIRMDR1 bitfield conversion
Date: Wed, 18 Nov 2026 15:50:07 +0100
Message-ID: <20261118150104.649821650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b63e792f296e6..2dca03b9221a3 100644
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




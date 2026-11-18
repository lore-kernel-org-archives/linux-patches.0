Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060224;
	b=AVfUxeUzS3pVSTY+6t8VIr3NXSqR9s2jTGLz4zKAgQ/ZQyMofIXklIz8MsD55dc/WUch
	 XHGBHFCIUIHcAZOM18zyoYPalHRR8RPJ5huZVD/eGcalSlSBkZTM2Qi5BEUvSykAZuWfR
	 TMJSyhEMyIs0ItN6+d8rFhZgqA9BDEJAZUxxMJdck8MsKt+gkRA4tDmrxl607w0c2nwRF
	 FHxujoYvXxDXctJzH5q3eeUI885e6s6ncexH/MzN2HSXAtmjrq18849jKVS+TnSBjLX6O
	 u7T88fyFja0iWFlLD23filfDWy9Wzi8weUl57od6RjKpd3ZNkqK0lFI2IN0imsKm07A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LhiUqpM1fayq1JeTssUgw9BazBPBwsRfbfrZ2JfAUWs=;
	b=UumNFXehxuJLzCnw0wj3prM3/zQELMjx/5+7OTJ4fTfUMMCcEHls3XvHx3c127ne0OSi
	 qNC6yoV9aknmXz5xuY6g4wrt5DO3t23A+5Cten/UvtRqAU48phkeVzL8IGVNXAFRYU+Ey
	 J05pFeUjqS+/T1mhato6NEjYMRw8Em5fCQTJ41gcFEI+B5FQmRtrYEyEaak2vPGp3qo71
	 TJ8NYMNWWjlxQYM5vbOWsIslNCrdYNlsQBcD8SotaCybFZoXQnFygU3ENdYbW9JuHv3ip
	 q6MT32g80Hypf8pCdAH2bFe4q9cC9JHBk7xZ8Q5lu0lH9TslU7sxepVS/2pr1FPJ8ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5AVNh51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBF606A320;
	Thu, 19 Nov 2026 03:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5AVNh51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC4D1F000C4;
	Thu, 19 Nov 2026 03:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060224;
	bh=LhiUqpM1fayq1JeTssUgw9BazBPBwsRfbfrZ2JfAUWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5AVNh51ecj5PTtBwFt+P9mCTommxBQgkVGYfW8hqyLJs5ABnrXJ6QgeU+FuIGpsa
	 v7T2gJIEWLbcdaUJpcnQPYOhu9nDCbqLRV8/UMIUPsbSVR8Urz1eo0xTYQ7bDxfgcG
	 appC6V45ip2pOZd5EjvIfU5VjAIjGArpex+VaE6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1123/1848] spi: sh-msiof: SITMDR1/SIRMDR1 bitfield conversion
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150006.325356893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6c026b193548a..715e96c05b381 100644
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
@@ -337,8 +337,9 @@ static u32 sh_msiof_spi_get_dtdl_and_syncdl(struct sh_msiof_spi_priv *p)
 		return 0;
 	}
 
-	val = sh_msiof_get_delay_bit(p->info->dtdl) << SIMDR1_DTDL_SHIFT;
-	val |= sh_msiof_get_delay_bit(p->info->syncdl) << SIMDR1_SYNCDL_SHIFT;
+	val = FIELD_PREP(SIMDR1_DTDL, sh_msiof_get_delay_bit(p->info->dtdl)) |
+	      FIELD_PREP(SIMDR1_SYNCDL,
+			 sh_msiof_get_delay_bit(p->info->syncdl));
 
 	return val;
 }
@@ -357,16 +358,18 @@ static void sh_msiof_spi_set_pin_regs(struct sh_msiof_spi_priv *p, u32 ss,
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
@@ -561,12 +564,12 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060868;
	b=bTDkZrZw04bD6Khadf/x43oMq5+Wu41tFDKnzI3mIC6SQEOTuB/s80GUnQrFAAnF+iZv
	 /T9Gz2gLt6T/+wG/Fj28dAIqFRnvq1UYgEK6G3QE1ptA6qqSHCBh124S40LA/iK4I7etY
	 bBxKBU9InHkjK+si87SzFrrp7bY+t4VTv7gLBmlIT3g/BSNh4dvo0LpB3MzlM9VRBEqD1
	 Mp/w/lhTgDK9XDC6PoRPmKK9u6nT/a9uvaQAjJZ58N/wn8LuEcGMNngxvOxgeyXOOKwQd
	 gxWOZEO7fOnOEG8hu/dXzxA1Peyaws7Os/8oUQAkeQWjyy1E9It/MwDrmFIazOGT8eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jWPJBzO1sv+IJYuf/ZidaYBap/NpD6OCy+OilhKUd/U=;
	b=BZVoudzTyHnjoDiM5JwXXV/nqWD+AMLpO8Y3ob/C95RGhve4D82XEMw34lAryp9G+6Xk
	 soMCfTqb5XmidfklvTRyQEivXkPuGhrKDhYQgBK0X1+rc+Y729FQtyYhCVCS3bHsfFBDU
	 8PO22tE1Nw/1ud3nfxbb309zf9oWFHU30anH9xCzjXKIL/0o3i5uuO/RtvFiGzDu484os
	 bAWRaR7ldksVJLK+QalEhY8SqFX31APaw1qWHtKOdulKWTHTsSTDjs0/O3y+boAATZ6j0
	 t4R9Cz/hViM7aPmNtIvOLBaXF3z5232nbC6thphDK1Hcap1+8JaM7jHBOipD0GadpWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dw9mGMv4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C74606D809;
	Sat,  7 Nov 2026 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dw9mGMv4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32021F0089F;
	Sat,  7 Nov 2026 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060868;
	bh=jWPJBzO1sv+IJYuf/ZidaYBap/NpD6OCy+OilhKUd/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dw9mGMv4PXFkEx1X1myRSb0nylOAY9+SXKyMspJR69Mz5dSMvIX4cyvh57YCCpY26
	 ocQgo5BuYa3QWUgEMLpAjDPv9Phngmchkm6U7wHYaMT8f5D1AKcBphI1f7qr2s3JoY
	 dHoNG6lFYAdQHsGbGkv6ewqZIfmhjebfVGoIbrcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0210/1536] pinctrl: npcm8xx: enable RMII outputs from RMII groups
Date: Sat,  7 Nov 2026 08:37:06 -0500
Message-ID: <20261107135003.555277939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Maimon <tmaimon77@gmail.com>

[ Upstream commit c6ccdc305589dd7c7976116e0870a23f291c5fa9 ]

NPCM8xx uses GCR_INTCR4 bits to release the R1, R2 and RMII3
transmit outputs from Hi-Z.

Those bits need to follow the mandatory r1, r2 and rmii3 pin
groups. The R1_OEn, R2_OEn and R3_OEn side groups are optional and
should not be required just to enable RMII transmit outputs.

Program the INTCR4 bits when the corresponding RMII groups are
selected and clear them again when those pins switch back to GPIO or
another shared function.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 61 +++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index f6a1e684a3864..430cabf3dc07b 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -25,6 +25,7 @@
 #define NPCM8XX_GCR_SRCNT	0x068
 #define NPCM8XX_GCR_FLOCKR1	0x074
 #define NPCM8XX_GCR_DSCNT	0x078
+#define NPCM8XX_GCR_INTCR4	0x0c0
 #define NPCM8XX_GCR_I2CSEGSEL	0x0e0
 #define NPCM8XX_GCR_MFSEL1	0x260
 #define NPCM8XX_GCR_MFSEL2	0x264
@@ -77,6 +78,9 @@
 #define NPCM8XX_GPIO_PER_BANK	32
 #define NPCM8XX_GPIO_BANK_NUM	8
 #define NPCM8XX_GCR_NONE	0
+#define NPCM8XX_INTCR4_R1_RMII_EN	BIT(12)
+#define NPCM8XX_INTCR4_R2_RMII_EN	BIT(13)
+#define NPCM8XX_INTCR4_RMII3_EN	BIT(14)
 
 #define NPCM8XX_DEBOUNCE_MAX		4
 #define NPCM8XX_DEBOUNCE_NSEC		40
@@ -1816,6 +1820,61 @@ static const struct pinctrl_pin_desc npcm8xx_pins[] = {
 	PINCTRL_PIN(251, "JM2/CP1_GPIO"),
 	};
 
+static u32 npcm8xx_rmii_output_enable_mask(unsigned int pin)
+{
+	switch (pin) {
+	case 178:
+	case 179:
+	case 180:
+	case 181:
+	case 182:
+	case 193:
+	case 201:
+		return NPCM8XX_INTCR4_R1_RMII_EN;
+	case 84:
+	case 85:
+	case 86:
+	case 87:
+	case 88:
+	case 89:
+	case 200:
+		return NPCM8XX_INTCR4_R2_RMII_EN;
+	case 110:
+	case 111:
+	case 209:
+	case 210:
+	case 211:
+	case 214:
+	case 215:
+		return NPCM8XX_INTCR4_RMII3_EN;
+	default:
+		return 0;
+	}
+}
+
+static void npcm8xx_set_rmii_output_enable(struct regmap *gcr_regmap,
+					   const unsigned int *pin,
+					   int pin_number, int mode)
+{
+	u32 mask = 0;
+	u32 val = 0;
+	u32 bit;
+	int i;
+
+	for (i = 0; i < pin_number; i++) {
+		bit = npcm8xx_rmii_output_enable_mask(pin[i]);
+		mask |= bit;
+
+		if ((mode == fn_r1 && bit == NPCM8XX_INTCR4_R1_RMII_EN) ||
+		    (mode == fn_r2 && bit == NPCM8XX_INTCR4_R2_RMII_EN) ||
+		    (mode == fn_rmii3 && bit == NPCM8XX_INTCR4_RMII3_EN))
+			val |= bit;
+	}
+
+	if (mask)
+		regmap_update_bits(gcr_regmap, NPCM8XX_GCR_INTCR4, mask, val);
+}
+
 /* Enable mode in pin group */
 static void npcm8xx_setfunc(struct regmap *gcr_regmap, const unsigned int *pin,
 			    int pin_number, int mode)
@@ -1854,6 +1913,8 @@ static void npcm8xx_setfunc(struct regmap *gcr_regmap, const unsigned int *pin,
 						   BIT(cfg->bit4) : 0);
 		}
 	}
+
+	npcm8xx_set_rmii_output_enable(gcr_regmap, pin, pin_number, mode);
 }
 
 static int npcm8xx_get_slew_rate(struct npcm8xx_gpio *bank,
-- 
2.53.0




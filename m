Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829637;
	b=BJoiOgfThsiQrToNxYG9pXJfcUt6YhUgniBFVFxfKSk7dNgG/bKopyy00IZtYaoSqlm6
	 Oc/1dJALxHayna/Kx40FyPxr97h/F+6SnUj4fjNNoe9QCHBw7D+yW/cVMwRwJr5hEsSqk
	 pM9f/4TG8X1H2d/eJR7eB8j1bQRwojQL0NiX/kFndpS2XNKr89qA1rSvHEctQH6/Nq4UM
	 owQSB5Mq9884s/AFi6PTDsZmdNpf1eekVnhxiSaGe/uyGQffoINH+sb6zTX75hjfrLI31
	 a/DaGkg8izrytgJ8s9xdHIUpzM6WeRQ943op6NxlqOYDEEpGghvqarhKyHZ0dYYj4bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WuADaK3OEMOpo91uyPOH+ZpfvgByc6Rlx6bDDgsODu8=;
	b=v25ktYSddFF2JCY0ds0pakCfozZVvmU6VcNkLzXFb51jVJEv83mOd1H2l+k+691haawz
	 jVtgbQ2vvHTNj9QSJoWIyd8yO/FrkEvHUSpFa3r1dXx5xT/Ic8r8akINpVY+KSlNxwtfE
	 ci5fAE1AwlStoihlZPOKRoUlVuB2udxQDa9basdHECyDgfAq7XUqTI2g2yk/0FnwI8jfK
	 xVH5C2E3oCiCLZoDxOHOAs75qayMW+dIsWMBsoYsRJs0xfchKO1kb76ryiX0DapL9QsPY
	 5gf/VFNobYgEPmzjm/2QpCTfgKlQJ9hwc/SV9qpKet7iS7GoA7NNEzb2a/h6TK571Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1Thj87k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77399606AC15;
	Wed,  4 Nov 2026 22:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1Thj87k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BD51F00A02;
	Wed,  4 Nov 2026 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829637;
	bh=WuADaK3OEMOpo91uyPOH+ZpfvgByc6Rlx6bDDgsODu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1Thj87ket8V/uNmSjUJ8379d+LBk08UUbRP1AQEgyirlJtdOt1lXUZzC53Ciz/Yp
	 cgMG/VoWjC7bq4XklFdI72YIuGWlABPStbwtS0DygRdfOjI2biBDV8ob8D6Cfl6Egu
	 0pqngEeIopGZFWKuWluRp+WHppbjiGREqPqdMczU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0248/1005] pinctrl: npcm8xx: enable RMII outputs from RMII groups
Date: Wed,  4 Nov 2026 15:59:41 -0500
Message-ID: <20261104211050.806160756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0aae1a2534594..c94441b2acdae 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -26,6 +26,7 @@
 #define NPCM8XX_GCR_SRCNT	0x068
 #define NPCM8XX_GCR_FLOCKR1	0x074
 #define NPCM8XX_GCR_DSCNT	0x078
+#define NPCM8XX_GCR_INTCR4	0x0c0
 #define NPCM8XX_GCR_I2CSEGSEL	0x0e0
 #define NPCM8XX_GCR_MFSEL1	0x260
 #define NPCM8XX_GCR_MFSEL2	0x264
@@ -78,6 +79,9 @@
 #define NPCM8XX_GPIO_PER_BANK	32
 #define NPCM8XX_GPIO_BANK_NUM	8
 #define NPCM8XX_GCR_NONE	0
+#define NPCM8XX_INTCR4_R1_RMII_EN	BIT(12)
+#define NPCM8XX_INTCR4_R2_RMII_EN	BIT(13)
+#define NPCM8XX_INTCR4_RMII3_EN	BIT(14)
 
 #define NPCM8XX_DEBOUNCE_MAX		4
 #define NPCM8XX_DEBOUNCE_NSEC		40
@@ -1796,6 +1800,61 @@ static const struct pinctrl_pin_desc npcm8xx_pins[] = {
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
@@ -1834,6 +1893,8 @@ static void npcm8xx_setfunc(struct regmap *gcr_regmap, const unsigned int *pin,
 						   BIT(cfg->bit4) : 0);
 		}
 	}
+
+	npcm8xx_set_rmii_output_enable(gcr_regmap, pin, pin_number, mode);
 }
 
 static int npcm8xx_get_slew_rate(struct npcm8xx_gpio *bank,
-- 
2.53.0




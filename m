Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502846EF96;
	Sat, 12 Sep 2026 10:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210394; cv=none; b=kY4BlBbitfalkJeN2yQEsxtoupVljh6DwNLyYeRIotXthzdNdy1wVCB9A2535eENqzS0ma52NDrhg/8D1W3mG3wlh1MUk5ly4A4r4D6q16dZ0AL6Xc6lkm1PjQyBAzRxa6mfJbgnjekwYCavOcE8kg5wDCW13YKrI12gM8IJft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210394; c=relaxed/simple;
	bh=aBDTgeMDHdw1F/v5IT1Gsf8P/V8qi/sXaz6AJW65ThQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8zOcUG9ugSrjwcgdz5YiEUtEFTRJctZI5Qhv37bBLCjeR4OZ0s2CwD4VhzhL/JYS8LAtfwbykJJW/xZaBnmp5cjqcA74HKo144sStkjQx17JyE4Kjnyd1cODUo3r6j3f7sicfOv4/9nEky+uen+edN/zbhktUl2V3T8aJC4j2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQsnrK+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQsnrK+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFA91F000FF;
	Sat, 12 Sep 2026 10:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210393;
	bh=XixShbPQR46JFILIRDDIEq+pC4Z98mki7IBxXfxohdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQsnrK+LmJLWZ3fmRKjuO+EOhKBlOm8C3gjovLm40odaKEJ02OhaL0Pw7netn2hQN
	 RKstXkhlFXygxo2qQB72wXWEuF+7bKgeXWqbloTj8gJCvnrYPJ9sKypm9vG6NyYHua
	 G3YKXzv2ylbemaAx0L3PGl2BvUUY8A6Tm+y8tNyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1010/1518] pinctrl: airoha: fix mdio bitfield names
Date: Sat, 12 Sep 2026 08:52:59 +0200
Message-ID: <20260912065646.302219690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit a8454680a6ce75fbbd8086bcb654eacf7897bc0f ]

Fix misprint in mdio bitfield name of GPIO_2ND_I2C_MODE register.

While at it also fix an7583 mdio. It should use an7583 specific
mdio bitfield.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index a33529b79c0ac..a33e18b4e0f0a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -49,7 +49,7 @@
 
 /* MUX */
 #define REG_GPIO_2ND_I2C_MODE			0x0214
-#define GPIO_MDC_IO_MASTER_MODE_MODE		BIT(14)
+#define GPIO_MDC_IO_MASTER_MODE_MASK		BIT(14)
 #define GPIO_I2C_MASTER_MODE_MODE		BIT(13)
 #define GPIO_I2S_MODE_MASK			BIT(12)
 #define GPIO_I2C_SLAVE_MODE_MODE		BIT(11)
@@ -66,6 +66,7 @@
 #define GPIO_2ND_I2C_MODE_MASK			BIT(0)
 
 #define REG_GPIO_SPI_CS1_MODE			0x0218
+#define AN7583_GPIO_MDC_IO_MASTER_MODE_MASK	BIT(22)
 #define GPIO_PCM_SPI_CS4_MODE_MASK		BIT(21)
 #define GPIO_PCM_SPI_CS3_MODE_MASK		BIT(20)
 #define GPIO_PCM_SPI_CS2_MODE_P156_MASK		BIT(19)
@@ -1001,8 +1002,8 @@ static const struct airoha_pinctrl_func_group mdio_func_group[] = {
 		.regmap[0] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
-			GPIO_MDC_IO_MASTER_MODE_MODE,
-			GPIO_MDC_IO_MASTER_MODE_MODE
+			GPIO_MDC_IO_MASTER_MODE_MASK,
+			GPIO_MDC_IO_MASTER_MODE_MASK
 		},
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
@@ -1026,8 +1027,8 @@ static const struct airoha_pinctrl_func_group an7583_mdio_func_group[] = {
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_SPI_CS1_MODE,
-			GPIO_MDC_IO_MASTER_MODE_MODE,
-			GPIO_MDC_IO_MASTER_MODE_MODE
+			AN7583_GPIO_MDC_IO_MASTER_MODE_MASK,
+			AN7583_GPIO_MDC_IO_MASTER_MODE_MASK
 		},
 		.regmap_size = 2,
 	},
-- 
2.53.0




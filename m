Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027347;
	b=0JDmjW+M2ArrC8P9JR97dT0LB6ozlxJ7Eu33XwxmkYPgvMS2ft3nXX4BL/VT5vGOs4qv
	 fxZ7vC8Js+c5EY6ZS32955Wf0IjsPz4dGcBUsAKbCpo3IRfaDeHZkcnErnWvHpEdls2dQ
	 kNRDERj0LdKWIiU6N4BtYp7ZwOjbV3a+MXuWgfKBQ+8To4p7w4OqhKVWfHpoJbte712LU
	 PzW5tfDRAxHauat2D6dMRUtKog8SeliJ+b8NCbdyjqGVgTJLJzRqGk87sSWvB+2NjYBN8
	 Xc9DH7l+i4/71Vij0K7MQoe4xdh72WyT75svz2z5/YF5sCjHFibKYguesmafTxHtDzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LnYp5TqBAQPDtg3zbnYS6wJq736fkQHg0gMv2cphup8=;
	b=mFZKvfGfAYbcTVAkIUxWZO86PQw7lulxEeOOhq7IKg1CJbi6d8o25mkyeic9S0ywzMfc
	 M53QJgMKLRSxTFJmKA1/rj6BG4rOdD1lHKzhgy5k5X1IL1AapcLNupiEsFHwDkLPlOT6g
	 Ef1+1HVeqpc0e1IeUF417158ZJ/YaYRdBx7GUbtBCEDbNZE/i3VOXVZYOly/Og7BW1CAK
	 TzgACthLiqQBY45ZX/8gdfsdYcEKx6vflA16HZvPpwRMfXet8D0MIBt3p9d6IJRV446Ur
	 87e4K7yNooD7Dsb9QLYLkKFFu5L6JbODNuUD04WUvZxiN/0WV8Lxq0sPYyFLRntOM9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8stNs9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FBE606A32C;
	Wed, 18 Nov 2026 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8stNs9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549731F000C4;
	Wed, 18 Nov 2026 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027346;
	bh=LnYp5TqBAQPDtg3zbnYS6wJq736fkQHg0gMv2cphup8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8stNs9WBBrimK6ocJi38DDdeh49k1jQ6lCyDKu1wnd4Scx9sSbV8eNB0jqfooRJL
	 GGt9q0eVB8WFqV3Dw3gpjfd5qKqCjHWnS5PMGtFdeQeGmYEKODOgi65NgO/Do+scyG
	 Yh7XDqhXpbs1inDCquwS8kJnrkB/6iPk88XG7tU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1757/2151] ASoC: tlv320aic32x4: move regmap_config into i2c and spi drivers
Date: Wed, 18 Nov 2026 15:58:12 +0100
Message-ID: <20261118150225.851077185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2ba6a4dba620bcee0f2210f532b25510a0872cf1 ]

Move regmap_config definitions to be static const structures in
tlv320aic32x4-i2c.c and tlv320aic32x4-spi.c instead of dynamically
modifying a shared base regmap_config at runtime during probe. Export
aic32x4_regmap_pages so both bus drivers can reference page ranges.

In addition, validate regmap initialization immediately upon creation in
both bus probe routines and remove the redundant error check from core
aic32x4_probe.

Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20260726010519.117805-4-dmitry.torokhov@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-i2c.c | 16 +++++++++++-----
 sound/soc/codecs/tlv320aic32x4-spi.c | 20 +++++++++++++-------
 sound/soc/codecs/tlv320aic32x4.c     | 13 ++-----------
 sound/soc/codecs/tlv320aic32x4.h     |  2 +-
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-i2c.c b/sound/soc/codecs/tlv320aic32x4-i2c.c
index b27b5ae1e4b20..90e03848a8903 100644
--- a/sound/soc/codecs/tlv320aic32x4-i2c.c
+++ b/sound/soc/codecs/tlv320aic32x4-i2c.c
@@ -16,17 +16,23 @@
 
 #include "tlv320aic32x4.h"
 
+static const struct regmap_config aic32x4_i2c_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = AIC32X4_REFPOWERUP,
+	.ranges = aic32x4_regmap_pages,
+	.num_ranges = 1,
+};
+
 static int aic32x4_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
-	struct regmap_config config;
 	enum aic32x4_type type;
 
-	config = aic32x4_regmap_config;
-	config.reg_bits = 8;
-	config.val_bits = 8;
+	regmap = devm_regmap_init_i2c(i2c, &aic32x4_i2c_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
-	regmap = devm_regmap_init_i2c(i2c, &config);
 	type = (uintptr_t)i2c_get_match_data(i2c);
 
 	return aic32x4_probe(&i2c->dev, regmap, type);
diff --git a/sound/soc/codecs/tlv320aic32x4-spi.c b/sound/soc/codecs/tlv320aic32x4-spi.c
index 92246243ff94d..4f842260e3252 100644
--- a/sound/soc/codecs/tlv320aic32x4-spi.c
+++ b/sound/soc/codecs/tlv320aic32x4-spi.c
@@ -16,19 +16,25 @@
 
 #include "tlv320aic32x4.h"
 
+static const struct regmap_config aic32x4_spi_regmap_config = {
+	.reg_bits = 7,
+	.pad_bits = 1,
+	.val_bits = 8,
+	.read_flag_mask = 0x01,
+	.max_register = AIC32X4_REFPOWERUP,
+	.ranges = aic32x4_regmap_pages,
+	.num_ranges = 1,
+};
+
 static int aic32x4_spi_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
-	struct regmap_config config;
 	enum aic32x4_type type;
 
-	config = aic32x4_regmap_config;
-	config.reg_bits = 7;
-	config.pad_bits = 1;
-	config.val_bits = 8;
-	config.read_flag_mask = 0x01;
+	regmap = devm_regmap_init_spi(spi, &aic32x4_spi_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
-	regmap = devm_regmap_init_spi(spi, &config);
 	type = (uintptr_t)spi_get_device_match_data(spi);
 
 	return aic32x4_probe(&spi->dev, regmap, type);
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 715a07ab97b9f..16488deee7f76 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -575,7 +575,7 @@ static const struct snd_soc_dapm_route aic32x4_dapm_routes[] = {
 	{"IN3_R to Left Mixer Negative Resistor", "40 kOhm", "IN3_R"},
 };
 
-static const struct regmap_range_cfg aic32x4_regmap_pages[] = {
+const struct regmap_range_cfg aic32x4_regmap_pages[] = {
 	{
 		.selector_reg = 0,
 		.selector_mask	= 0xff,
@@ -585,13 +585,7 @@ static const struct regmap_range_cfg aic32x4_regmap_pages[] = {
 		.range_max = AIC32X4_REFPOWERUP,
 	},
 };
-
-const struct regmap_config aic32x4_regmap_config = {
-	.max_register = AIC32X4_REFPOWERUP,
-	.ranges = aic32x4_regmap_pages,
-	.num_ranges = ARRAY_SIZE(aic32x4_regmap_pages),
-};
-EXPORT_SYMBOL(aic32x4_regmap_config);
+EXPORT_SYMBOL_GPL(aic32x4_regmap_pages);
 
 static int aic32x4_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				  int clk_id, unsigned int freq, int dir)
@@ -1355,9 +1349,6 @@ int aic32x4_probe(struct device *dev, struct regmap *regmap,
 	struct device_node *np = dev->of_node;
 	int ret;
 
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
 	aic32x4 = devm_kzalloc(dev, sizeof(struct aic32x4_priv),
 				   GFP_KERNEL);
 	if (aic32x4 == NULL)
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index f68a846ef61d2..0076c4807d0ee 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -16,7 +16,7 @@ enum aic32x4_type {
 	AIC32X4_TYPE_TAS2505,
 };
 
-extern const struct regmap_config aic32x4_regmap_config;
+extern const struct regmap_range_cfg aic32x4_regmap_pages[];
 int aic32x4_probe(struct device *dev, struct regmap *regmap,
 		  enum aic32x4_type type);
 void aic32x4_remove(struct device *dev);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042050;
	b=Z0bLorTW2uOjXYtbVupp7RNF8Grf2EJBqQ4y1WRRyDITPhKGSyXVlxV+MuK03TRKsz6A
	 xpQwRyHAM+f0q4rXkgNWkn8SfXL6k4+Yw45O1uzDXvx7V6yD+iDvHUOdcdt9BO6QLVO2i
	 MhiERn4TDk1LwDt2+vAz+03OYcSzwh1Vz6HuQVqrkkw69DjT4RbxrvGxSznWtjhgopwCR
	 0yg5VnqNjI0Y3BRYNET5NBwHZSuQy27kdp+aMuAz3fRyVyABb4TlwLbFCyUzU7b1lzftw
	 crAYLXF408phouF07Gslka+81LSoHMoZCLaXlugRxPCPgjJ7i9Q5+hlK14CGDIvTbEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QWXQycFIeQQBUPDXMXeVwacYE2UUTDk94xb4cf6WyQ=;
	b=Hi9lkspiC8oSMIoLNDPgyLgnLQUmw2W0NVbYkigcoAbt1m9NLfhhnlIHnA1K7Frs2psP
	 LmnOqP90R3N9/C8P5u4ZfyEvz9mI3QEypQUCwXQ7WeoITaUqJdTGzJ2v1zdYBjCr4MNVE
	 p998/Y31YXuHZE2c3NvTfFtd7cXWng+9HhdyL6RkEFFAUKu5ENuZN8QPGJ6YDF2dwFj8B
	 m2NITVotvQ6jlTfd+429DgRbd39hCyNn+LZUjDB1ptpb9h+Qi0FzFrHk5FfSmMnD59EGX
	 9s1JIx2hHCVbkijieorLnHcaZA/QV6B+9o99nSgdI3l8kZkj9xYP9AROnftFASXURkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lp1Spic7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FD8606A325;
	Wed, 18 Nov 2026 22:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lp1Spic7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450C31F000C4;
	Wed, 18 Nov 2026 22:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042049;
	bh=8QWXQycFIeQQBUPDXMXeVwacYE2UUTDk94xb4cf6WyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lp1Spic7pJMSFAnviI3ph0kgLo86mkROwAoaGBgZSiEc6A251eQ6tbZvVckzcrq1r
	 ZvP703p4MXAy74/Ecuuwobwk/URpHqCGsSRq2yiMXy228RLx5dyh+WGCW0phq1ZBUC
	 0hawNVHAllRBM6EmhKd73Ag2zRA75alWJWxO12tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3033/3318] ASoC: tlv320aic32x4: move regmap_config into i2c and spi drivers
Date: Wed, 18 Nov 2026 16:00:55 +0100
Message-ID: <20261118150451.168355353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5976c91766e0..1c99da3a5b976 100644
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
index 5c0c81da06dba..d28bc78b0b87b 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -576,7 +576,7 @@ static const struct snd_soc_dapm_route aic32x4_dapm_routes[] = {
 	{"IN3_R to Left Mixer Negative Resistor", "40 kOhm", "IN3_R"},
 };
 
-static const struct regmap_range_cfg aic32x4_regmap_pages[] = {
+const struct regmap_range_cfg aic32x4_regmap_pages[] = {
 	{
 		.selector_reg = 0,
 		.selector_mask	= 0xff,
@@ -586,13 +586,7 @@ static const struct regmap_range_cfg aic32x4_regmap_pages[] = {
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
@@ -1341,9 +1335,6 @@ int aic32x4_probe(struct device *dev, struct regmap *regmap,
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




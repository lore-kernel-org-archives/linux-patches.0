Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050177;
	b=hmww4d0jyRf+O8DYJPyebdPyv1CdBnjIq1klVeJPhggC7cAFLaIAUsyWCnSjUETiAFV6
	 VdNAXXAiW/5LO40ywdcvmlalACjpfIvZ1FQjJ4affJnZuR+oM5jq+UsOAKcc0dB53F5Lo
	 FWymwjjvBxMrJN3ohEr/cq+k/uETlpsoAm6lHbJ485Mg7vTNzONM1JSYRPca9wUGmYM+Z
	 E5pjtLtm3q4Qrt+99kEm0xzQlRrWuN7/33v4OSF9PsiJxm080M0iKR7TE8UEEsebeCyDp
	 rHQzvafkzJi5GIocUbfUTU6Kgaiz35DHNP6PF54ziPCIUynPHxjgENGn6nhKexYVnPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FomCzJvwUrV3BmM66AtC2bbhOHASWaWAfV62eUSors=;
	b=bXrczmDPyDvIdjRVzl4JrqUks0qBM6uOclbOD+6/AWxto+oNTDrxGb5DjccSXnORY2Mu
	 MtgZai5/eh2+um64rh7Xb6XhWUCyzH80IzZTlMmD6bzL4fT7uLRJl9i0a3XJXEnWCU33w
	 NkL8PEWjeeH6epbI9dW+rzQSqq0Sha9n8XH4/g+DOQDjFcMl+YYRK6kUs/fg1O2XKs25a
	 IpilVAoVWQyZ1Hh223Ht2YOjdk0fB5MgU2etjtIx86Tu6Qh0mJ4ackId2mIn5nHfVMng1
	 O0OCGAALJudWS4Z6exwzTlawIAKxtquzUfy9irUxIf+wLUYuPxLBi73gZYnqN1cGgQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vECB1tCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C025E606A320;
	Thu, 19 Nov 2026 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vECB1tCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11F41F000C6;
	Thu, 19 Nov 2026 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050177;
	bh=0FomCzJvwUrV3BmM66AtC2bbhOHASWaWAfV62eUSors=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vECB1tCchMBfJMc5lNpCIQU5m/q9qMeCKTd/EcGrp2uTjyKgdnvtm9Xwqa7moTLu2
	 DQ415kxcSYioYjj+V5t4Ifu8dUBvUwrw0TV8bvpHRbXdWuMReV2mvvRfKyJBmiWtUe
	 uJNnvXWys6nFgYNX/blyQHfNTbhl8rlQr5Ne45Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2614/2857] ASoC: tlv320aic32x4: move regmap_config into i2c and spi drivers
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150335.699115394@linuxfoundation.org>
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
index 1b807faea3d4f..e72488e2d51a9 100644
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




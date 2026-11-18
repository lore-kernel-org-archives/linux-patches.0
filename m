Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023258;
	b=OayHa7ip9F14jf9Y5szclHhRdLSVWIkge7o5lvrj5ZdIoU5BhQg+NXi8BMHn/asuuK7+
	 G5HBnijZXD2Hmek+IZVX4kVBY2y4zV4A70Epvx8bfOPzQ/sBkPRQBtt8JDR4Q5scTFmiJ
	 X7mfq4kmn35JVZluSgOgs6olydOF3HuPKUUkx1CXulZPf7Lca2HGF09Li5zLFB6aQWG1R
	 0cFWQN1C2k98YCGPnll9vOIOWH5nTNbUnnwl1U0VF6ms49QFU4o2i9PgKRBU2Kv7P2TCy
	 zUqu6+GfbwtwZfYPW3l0h7jECBxP6SS0Sod6KAzhP1MbKOYODwClNWy2hgzxUGuqaDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHSGhZHycA5rKgpn59FQuIN0fySeuNahd/sNnwsCxjs=;
	b=RLObnIqy8dXrHt8XZhM3z2YxUrVD/E80f45RMmHT9Dv2chLmJkx4zZsQSZ2KV8MAqwfZ
	 RAt1xsrl3TiyNV//aGCGJmRz9OtgHodmny4+wbBeKvwTdlGevfy+xj8cRTx/zf/b4GUN9
	 MubdEBX1Pt6DfjbH7Rvgw6+DZXRkDbiibgs9Pg+IklgOE4izZhIjlyk68gKaZOvBQ1F1a
	 0/50dmqixcaZBlZI/p1YPRBvkdlvXruHH/D0lSZYKql7N3/3GlQfeaDhs1rRCZf16JsQc
	 pvL52BSVigGYNTLIYRe49M5ryhWpCEFAojp6FGgsBKCdGA4pg4EpKeVXujxSUiHMKMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pm5qS/lf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB2E606A320;
	Wed, 18 Nov 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pm5qS/lf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087C81F000C4;
	Wed, 18 Nov 2026 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023258;
	bh=IHSGhZHycA5rKgpn59FQuIN0fySeuNahd/sNnwsCxjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pm5qS/lfAVehQod3A9PBDCQyFXHiI8or20yIzNNUDcboAw1wGSjaQEdes5SuozQCj
	 kxONJnE1hdc9EVm5In9gL9XRM91BeErfONy9q3LJf8UZ8NYWYRQd1+MkBRaAm3GMV0
	 IE4T6U7TP9IkJmJPPJVBKePg6akgBSH4/WlS7A0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0306/2151] ASoC: codecs: nau8822: add support for supply regulators
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118150133.061695334@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit f8e7cd48e5b3b38ec5e1542b73b670a7770d2d7c ]

NAU8822 has four power supply pins: VDDA, VDDB, VDDC, and VDDSPK, which
need to be online and stable before communication with the device is
attempted.

Request and enable these regulators at init time, if provided. Also wait
for 100 us after powering up the supply regulators before attempting to
access the device registers, as recommended by the datasheet.

This helps avoid -ENXIO errors when the codec is probed before the
regulators are ready.

Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260525-nau8822-reg-v2-2-7d37ae393e46@flipper.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9c343445b349 ("ASoC: nau8822: keep regcache offline while supplies are off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 46 +++++++++++++++++++++++++++++++++++---
 sound/soc/codecs/nau8822.h |  3 +++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 7c84e9e4b8b3c..978d44ea76eb0 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -108,6 +109,10 @@ static const struct reg_default nau8822_reg_defaults[] = {
 	{ NAU8822_REG_OUTPUT_TIEOFF, 0x0000 },
 };
 
+static const char * const nau8822_supply_names[NAU8822_NUM_SUPPLIES] = {
+	"vdda", "vddb", "vddc", "vddspk",
+};
+
 static bool nau8822_readable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -1058,6 +1063,7 @@ static int nau8822_suspend(struct snd_soc_component *component)
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 
 	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_OFF);
+	regulator_bulk_disable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
 
 	regcache_mark_dirty(nau8822->regmap);
 
@@ -1068,6 +1074,15 @@ static int nau8822_resume(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
+	int ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+
+	if (ret) {
+		dev_err(component->dev,
+			"Failed to enable regulators: %d\n", ret);
+		return ret;
+	}
+
+	fsleep(100);
 
 	regcache_sync(nau8822->regmap);
 
@@ -1155,7 +1170,7 @@ static int nau8822_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
 	struct nau8822 *nau8822 = dev_get_platdata(dev);
-	int ret;
+	int ret, i;
 
 	if (!nau8822) {
 		nau8822 = devm_kzalloc(dev, sizeof(*nau8822), GFP_KERNEL);
@@ -1169,6 +1184,13 @@ static int nau8822_i2c_probe(struct i2c_client *i2c)
 		return dev_err_probe(&i2c->dev, PTR_ERR(nau8822->mclk),
 			"Error getting mclk\n");
 
+	for (i = 0; i < NAU8822_NUM_SUPPLIES; i++)
+		nau8822->supplies[i].supply = nau8822_supply_names[i];
+
+	ret = devm_regulator_bulk_get(dev, NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to get regulators\n");
+
 	nau8822->regmap = devm_regmap_init_i2c(i2c, &nau8822_regmap_config);
 	if (IS_ERR(nau8822->regmap)) {
 		ret = PTR_ERR(nau8822->regmap);
@@ -1177,21 +1199,38 @@ static int nau8822_i2c_probe(struct i2c_client *i2c)
 	}
 	nau8822->dev = dev;
 
+	ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to enable regulators\n");
+
+	fsleep(100);
+
 	/* Reset the codec */
 	ret = regmap_write(nau8822->regmap, NAU8822_REG_RESET, 0x00);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to issue reset: %d\n", ret);
-		return ret;
+		goto err_reg;
 	}
 
 	ret = devm_snd_soc_register_component(dev, &soc_component_dev_nau8822,
 						&nau8822_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		return ret;
+		goto err_reg;
 	}
 
 	return 0;
+
+err_reg:
+	regulator_bulk_disable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	return ret;
+}
+
+static void nau8822_i2c_remove(struct i2c_client *i2c)
+{
+	struct nau8822 *nau8822 = i2c_get_clientdata(i2c);
+
+	regulator_bulk_disable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
 }
 
 static const struct i2c_device_id nau8822_i2c_id[] = {
@@ -1214,6 +1253,7 @@ static struct i2c_driver nau8822_i2c_driver = {
 		.of_match_table = of_match_ptr(nau8822_of_match),
 	},
 	.probe = nau8822_i2c_probe,
+	.remove = nau8822_i2c_remove,
 	.id_table = nau8822_i2c_id,
 };
 module_i2c_driver(nau8822_i2c_driver);
diff --git a/sound/soc/codecs/nau8822.h b/sound/soc/codecs/nau8822.h
index 13fe0a091e9ed..24799c7b5931b 100644
--- a/sound/soc/codecs/nau8822.h
+++ b/sound/soc/codecs/nau8822.h
@@ -211,6 +211,8 @@ struct nau8822_pll {
 	int freq_out;
 };
 
+#define NAU8822_NUM_SUPPLIES	4
+
 /* Codec Private Data */
 struct nau8822 {
 	struct device *dev;
@@ -219,6 +221,7 @@ struct nau8822 {
 	struct nau8822_pll pll;
 	int sysclk;
 	int div_id;
+	struct regulator_bulk_data supplies[NAU8822_NUM_SUPPLIES];
 };
 
 #endif	/* __NAU8822_H__ */
-- 
2.53.0




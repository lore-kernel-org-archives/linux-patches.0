Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050169;
	b=V5ResQYfauDq67xqvcbKGGM+ir9VCr7TGK64wz7FgPUN8rIKiSn7fxmUpxrdQWVQtZQg
	 nStWU84vQ1451Oy5aoHizhED6L7uxfEfFoWOi+Yq3JbcY7iTQ0AoQwGCT6+w/uVsmp294
	 cmBqd/fTr2cS9mMnIO5RHhyPKLO5kXzIxmXGn7nIiZlFt1gWIBGZtxsNdK4nNU0OvquWr
	 k1eirUKdr8542TbDEeuzQsSFaYl/XczDBoRn5UjG8QGcgthTylU9AXYBGxe1Yg7fu2y4m
	 7cU3uKXuqkIfKg6HJPLGiJAU63qiS9uy1asDHurRCIPddI2Sr9AXRPXgEsOa37ZBP5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pqu0JXO03PI2zontIwpBBa1z+IlqixUhUGL0GoC012o=;
	b=U9FqUjNLCOB14XYOmezOhU5pvP13fR+5O40sAwuS5p3ykgxtj540In1k4YlkhWlHt3KU
	 J2NqOb3g5t3T/p050cOe+q4o2BvS8qUkqjT60kd7QyHbD7wczb6ErGo7nqLC25/EHuY1O
	 a+PfJ1R7oHgN5OFHJRO+4ZS6UyaJeMbzTZFoFmtNjg3jXcCuBvcBxr9ckJabdeF53szzf
	 p8Ohm0V0ESdNVktGkRgvFtBzN/aSRqpledfEIO0+y5OOuthA0RiRUKqWeLyc2TSK5juZ1
	 KbR2oR/65XR2uGXG1hVrdTDrkqQenB90hobl/cR5qNQ/40JWTYTqI6V1IqPLpitImLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJy7njvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD56606A32A;
	Thu, 19 Nov 2026 01:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJy7njvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8090C1F000C7;
	Thu, 19 Nov 2026 01:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050169;
	bh=Pqu0JXO03PI2zontIwpBBa1z+IlqixUhUGL0GoC012o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJy7njvjcl/c9jyO6dYGzstegszJyu5wdqW7HBZHddl67IpU7ICDfPqVcbiwmkPxZ
	 ne/LjIRIIru1d1l5tCOvAS+O0+V/L3XdzU7IOq8M2EfB55fdA9Lm305lw0W4Ko5uyB
	 uFZxzaCZ9f1BQxJNPwptCk+JKcHQg86gy3wY9qqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2611/2857] ASoC: codec: tlv320aic32x4: Add enum aic32x4_type to aic32x4_probe()
Date: Wed, 18 Nov 2026 16:00:45 +0100
Message-ID: <20261118150335.591008748@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit cac1636e214930b01b2f8ac9867771486554271a ]

Add enum aic32x4_type to aic32x4_probe() and drop using dev_set_drvdata()
from tlv320aic32x4_{i2c,spi} drivers.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230831194622.87653-2-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-i2c.c | 7 ++++---
 sound/soc/codecs/tlv320aic32x4-spi.c | 7 ++++---
 sound/soc/codecs/tlv320aic32x4.c     | 5 +++--
 sound/soc/codecs/tlv320aic32x4.h     | 3 ++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-i2c.c b/sound/soc/codecs/tlv320aic32x4-i2c.c
index d1e543ca3521e..6983b9251525e 100644
--- a/sound/soc/codecs/tlv320aic32x4-i2c.c
+++ b/sound/soc/codecs/tlv320aic32x4-i2c.c
@@ -23,6 +23,7 @@ static int aic32x4_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
 	struct regmap_config config;
+	enum aic32x4_type type;
 
 	config = aic32x4_regmap_config;
 	config.reg_bits = 8;
@@ -34,15 +35,15 @@ static int aic32x4_i2c_probe(struct i2c_client *i2c)
 		const struct of_device_id *oid;
 
 		oid = of_match_node(aic32x4_of_id, i2c->dev.of_node);
-		dev_set_drvdata(&i2c->dev, (void *)oid->data);
+		type = (uintptr_t)oid->data;
 	} else {
 		const struct i2c_device_id *id;
 
 		id = i2c_match_id(aic32x4_i2c_id, i2c);
-		dev_set_drvdata(&i2c->dev, (void *)id->driver_data);
+		type = id->driver_data;
 	}
 
-	return aic32x4_probe(&i2c->dev, regmap);
+	return aic32x4_probe(&i2c->dev, regmap, type);
 }
 
 static void aic32x4_i2c_remove(struct i2c_client *i2c)
diff --git a/sound/soc/codecs/tlv320aic32x4-spi.c b/sound/soc/codecs/tlv320aic32x4-spi.c
index 03cce8d6404f8..81c05030dd3bf 100644
--- a/sound/soc/codecs/tlv320aic32x4-spi.c
+++ b/sound/soc/codecs/tlv320aic32x4-spi.c
@@ -22,6 +22,7 @@ static int aic32x4_spi_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
 	struct regmap_config config;
+	enum aic32x4_type type;
 
 	config = aic32x4_regmap_config;
 	config.reg_bits = 7;
@@ -35,15 +36,15 @@ static int aic32x4_spi_probe(struct spi_device *spi)
 		const struct of_device_id *oid;
 
 		oid = of_match_node(aic32x4_of_id, spi->dev.of_node);
-		dev_set_drvdata(&spi->dev, (void *)oid->data);
+		type = (uintptr_t)oid->data;
 	} else {
 		const struct spi_device_id *id_entry;
 
 		id_entry = spi_get_device_id(spi);
-		dev_set_drvdata(&spi->dev, (void *)id_entry->driver_data);
+		type = id_entry->driver_data;
 	}
 
-	return aic32x4_probe(&spi->dev, regmap);
+	return aic32x4_probe(&spi->dev, regmap, type);
 }
 
 static void aic32x4_spi_remove(struct spi_device *spi)
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 6829834a412fc..5c0c81da06dba 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1333,7 +1333,8 @@ static int aic32x4_setup_regulators(struct device *dev,
 	return ret;
 }
 
-int aic32x4_probe(struct device *dev, struct regmap *regmap)
+int aic32x4_probe(struct device *dev, struct regmap *regmap,
+		  enum aic32x4_type type)
 {
 	struct aic32x4_priv *aic32x4;
 	struct aic32x4_pdata *pdata = dev->platform_data;
@@ -1349,7 +1350,7 @@ int aic32x4_probe(struct device *dev, struct regmap *regmap)
 		return -ENOMEM;
 
 	aic32x4->dev = dev;
-	aic32x4->type = (uintptr_t)dev_get_drvdata(dev);
+	aic32x4->type = type;
 
 	dev_set_drvdata(dev, aic32x4);
 
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index d6101ce73f80d..f68a846ef61d2 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -17,7 +17,8 @@ enum aic32x4_type {
 };
 
 extern const struct regmap_config aic32x4_regmap_config;
-int aic32x4_probe(struct device *dev, struct regmap *regmap);
+int aic32x4_probe(struct device *dev, struct regmap *regmap,
+		  enum aic32x4_type type);
 void aic32x4_remove(struct device *dev);
 int aic32x4_register_clocks(struct device *dev, const char *mclk_name);
 
-- 
2.53.0




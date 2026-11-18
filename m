Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028682;
	b=PlrRX8tSrsv/DHvfETVvztUWjM69BNwLTWLV2V0alYpNh6xzlQoEI/BXxKMEw+ucmZq3
	 az2MY6bDi+7uZSN6V9lUPhTRHM8XBiNn2cK0r6K/Ednfg+Vo4dqpHKHfKv0EMN6TGthT3
	 TFETW5qmJKISlTnWG+pzwXZFoOIxyO64AXG3gJjmd8k3JFFqdqjo12ZsjiEMuTTT9QmxC
	 wnSFD0Ok4GOhgH7h8NnimzO79yCuaLxNGogMRCE18cJFEbAmW2F53Ua+Q8AAY8sg5jr6g
	 eJQ/3CcsHAKjWKN3v50XDgrhZEQEDME+imnAS4iz6oqFOM+/s3kPNRC9RnTqjwJbuYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VdG0LZIMQiPpn3OIUzdwBn7R5CWxR5NXwFSVOPC5RS4=;
	b=3wNk78lwbo0vGgv6ZHfQVeZHcgOhNg9NgrRdu1N4K0KFhk/sz8+DQvzGy2HZQdzIYyYP
	 fULwIka6AnsvXZRpN2rJqNjZfkbWv4AADd23cDtLSSYg7w6wjx3sK2kkNRtrhTSavt17+
	 YeBh58Bay6P+s6jQmJFe9/BoA5Jh8YkcTWFnSFr9zQqTS/jV7FbGTo6S+jUTEvUJ345bX
	 x3aIXrVObGwKbiVtHuX0y3Uorub/FySmqqY/H8crXmnVUM8EuHDJkz2Hp9O9rJBrULH8V
	 KQ+OlEx99no9nBUBUVd+tZUJGZgFUUffH89791L4r5oSMaLc9Fln9lA6h6fKS/EK/dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMV3bwRk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F6606A320;
	Wed, 18 Nov 2026 19:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AMV3bwRk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64BE1F000C7;
	Wed, 18 Nov 2026 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028682;
	bh=VdG0LZIMQiPpn3OIUzdwBn7R5CWxR5NXwFSVOPC5RS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMV3bwRk9s2V/PXnnKkKGcOEGTsIeEs0hNlyA5k27f8B11O7UfTzqGnOI11JuIKaT
	 +c3syi6jnyaAon45RKBeEnBErnL9lQ7nVaaV9cY5jT59JSSNj19nBDj6yUed8SBBfI
	 eASkK6nVxjZaEF85243cbsKkyP3TcnwJIEEdTRkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0083/1756] hwmon: (tmp108) Add helper function tmp108_common_probe() to prepare I3C support
Date: Wed, 18 Nov 2026 15:36:50 +0100
Message-ID: <20261118150011.577167418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 700f3250198d51093884254220a96777a922dd47 ]

Add help function tmp108_common_probe() to pave road to support i3c for
P3T1085(NXP) chip.

Use dev_err_probe() to simplify the code.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Message-ID: <20241112-p3t1085-v4-1-a1334314b1e6@nxp.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 7cd60538073e ("hwmon: (tmp108) Fix initial conversion delay and wait until ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp108.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/tmp108.c b/drivers/hwmon/tmp108.c
index 18e7c9d9bcbb8..d95957d808e1b 100644
--- a/drivers/hwmon/tmp108.c
+++ b/drivers/hwmon/tmp108.c
@@ -323,33 +323,19 @@ static const struct regmap_config tmp108_regmap_config = {
 	.use_single_write = true,
 };
 
-static int tmp108_probe(struct i2c_client *client)
+static int tmp108_common_probe(struct device *dev, struct regmap *regmap, char *name)
 {
-	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct tmp108 *tmp108;
-	int err;
 	u32 config;
-
-	if (!i2c_check_functionality(client->adapter,
-				     I2C_FUNC_SMBUS_WORD_DATA)) {
-		dev_err(dev,
-			"adapter doesn't support SMBus word transactions\n");
-		return -ENODEV;
-	}
+	int err;
 
 	tmp108 = devm_kzalloc(dev, sizeof(*tmp108), GFP_KERNEL);
 	if (!tmp108)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, tmp108);
-
-	tmp108->regmap = devm_regmap_init_i2c(client, &tmp108_regmap_config);
-	if (IS_ERR(tmp108->regmap)) {
-		err = PTR_ERR(tmp108->regmap);
-		dev_err(dev, "regmap init failed: %d", err);
-		return err;
-	}
+	tmp108->regmap = regmap;
 
 	err = regmap_read(tmp108->regmap, TMP108_REG_CONF, &config);
 	if (err < 0) {
@@ -383,13 +369,30 @@ static int tmp108_probe(struct i2c_client *client)
 		return err;
 	}
 
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, name,
 							 tmp108,
 							 &tmp108_chip_info,
 							 NULL);
 	return PTR_ERR_OR_ZERO(hwmon_dev);
 }
 
+static int tmp108_probe(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	struct regmap *regmap;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_WORD_DATA))
+		return dev_err_probe(dev, -ENODEV,
+				     "adapter doesn't support SMBus word transactions\n");
+
+	regmap = devm_regmap_init_i2c(client, &tmp108_regmap_config);
+	if (IS_ERR(regmap))
+		return dev_err_probe(dev, PTR_ERR(regmap), "regmap init failed");
+
+	return tmp108_common_probe(dev, regmap, client->name);
+}
+
 static int tmp108_suspend(struct device *dev)
 {
 	struct tmp108 *tmp108 = dev_get_drvdata(dev);
-- 
2.53.0




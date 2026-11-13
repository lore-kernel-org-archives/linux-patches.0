Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591549;
	b=ZLDjmNkgQnO9SBUp8zksuX7PFJnutZmAWy4DxMWX6Cs5r/SUVvELALq+OHgTxASrs92L
	 em/+sZ53jVu6CH5sXlPYhcaQz95UKVcvfb28HC3w/+YhkRSUyehGB4qrp+5ItgErFLbOi
	 e9KQljYw138cYSu05SISd5eQ3TUUftlEf3AWUgl3z+M64etxZrdtZT74dVF3LRsLxUJRC
	 CkmHU1XpdcyUahTkHF4f86y+KRkhmthaI7Yf66vEwbOggzhkMH9S1+p6VDgRww7Dr+MKg
	 zl+c6X9WaTM9UtWI8btllBRduW+zVyiOlYerXC7XMb1K7eThMppYvM9F9lB95kO87Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HvlKcoywN/9fe/oF2VnKYWsdYP7IgVmjyF/+qA+RZ8=;
	b=ANmotDqukvCcUiSeKFJOI8EDRhsP2llE3Gr8Wm++1CiFGBvrDE2POBWROusUfq5VbW+j
	 w2AhuxjHHKNTOn0jR8VXJE/PnVhSR113+0HESMrc4Bn5hM5XAhQmXjjSdnuBoh4ci1zWy
	 92o1LZBcs+fqP2uBkAuH52qMCKc3fTYLy1zf6oDRpL0lbUCEvzn8RluQ8V/tAjpsMQj0v
	 JxhFr+Fie/P6JtvBHARi8fr9ua3gH3SikjWKK3vfxYtYc4MHgw+SlmpuBGIKbNJVmDdOv
	 HoZeJpnGtBWl/Ca8UE4vYv5NevlPTkwl24QDnyYCtAAR0LbNzw3b/UvpdoLiCnngHpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTrtPnZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0CC607EE54;
	Fri, 13 Nov 2026 17:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTrtPnZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A6C1F000C6;
	Fri, 13 Nov 2026 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591549;
	bh=6HvlKcoywN/9fe/oF2VnKYWsdYP7IgVmjyF/+qA+RZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTrtPnZCn87Y4j3nqHafPUV5OTsQtWkTxo22IOftD7Uv7ZolATifdHE0t9VSwb9Lh
	 pYeAZ8C7Gs9lH6HQmw2R1G6jchZDjxwh1WPvFuhDKaNJnGhMAHY4mReo6lyFfwcLkw
	 5aUEmpYd4xiWOOk/h2snWOGF33w3g5mHYHHmVqLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 600/670] power: supply: Use devm_mutex_init()
Date: Fri, 13 Nov 2026 10:52:44 -0500
Message-ID: <20261113153832.150998220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7d715345a86941b9e6c8e520b40078692baed4a4 ]

Use devm_mutex_init() instead of hand-writing it.

This saves some LoC, improves readability and saves some space in the
generated .o file.

As an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  35803	   9352	    384	  45539	   b1e3	drivers/power/supply/rt9467-charger.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  34792	   9008	    384	  44184	   ac98	drivers/power/supply/rt9467-charger.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: db560f4b1c52 ("power: supply: bq27xxx: Ensure poll work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 11 +--------
 drivers/power/supply/mt6370-charger.c  | 11 +--------
 drivers/power/supply/rt9467-charger.c  | 33 +++-----------------------
 3 files changed, 5 insertions(+), 50 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index fc76fd9e2b96f..b0dec20fb37e8 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2150,13 +2150,6 @@ static void bq27xxx_external_power_changed(struct power_supply *psy)
 	mod_delayed_work(system_wq, &di->work, HZ / 2);
 }
 
-static void bq27xxx_battery_mutex_destroy(void *data)
-{
-	struct mutex *lock = data;
-
-	mutex_destroy(lock);
-}
-
 int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 {
 	struct power_supply_desc *psy_desc;
@@ -2168,9 +2161,7 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	int ret;
 
 	INIT_DELAYED_WORK(&di->work, bq27xxx_battery_poll);
-	mutex_init(&di->lock);
-	ret = devm_add_action_or_reset(di->dev, bq27xxx_battery_mutex_destroy,
-				       &di->lock);
+	ret = devm_mutex_init(di->dev, &di->lock);
 	if (ret)
 		return ret;
 
diff --git a/drivers/power/supply/mt6370-charger.c b/drivers/power/supply/mt6370-charger.c
index ad8793bf997e1..16ffa927147f6 100644
--- a/drivers/power/supply/mt6370-charger.c
+++ b/drivers/power/supply/mt6370-charger.c
@@ -761,13 +761,6 @@ static int mt6370_chg_init_psy(struct mt6370_priv *priv)
 	return PTR_ERR_OR_ZERO(priv->psy);
 }
 
-static void mt6370_chg_destroy_attach_lock(void *data)
-{
-	struct mutex *attach_lock = data;
-
-	mutex_destroy(attach_lock);
-}
-
 static void mt6370_chg_destroy_wq(void *data)
 {
 	struct workqueue_struct *wq = data;
@@ -895,9 +888,7 @@ static int mt6370_chg_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to init psy\n");
 
-	mutex_init(&priv->attach_lock);
-	ret = devm_add_action_or_reset(dev, mt6370_chg_destroy_attach_lock,
-				       &priv->attach_lock);
+	ret = devm_mutex_init(dev, &priv->attach_lock);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to init attach lock\n");
 
diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index be65b0f517210..be1ca7f61c0bb 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -1145,27 +1145,6 @@ static int rt9467_reset_chip(struct rt9467_chg_data *data)
 	return regmap_field_write(data->rm_field[F_RST], 1);
 }
 
-static void rt9467_chg_destroy_adc_lock(void *data)
-{
-	struct mutex *adc_lock = data;
-
-	mutex_destroy(adc_lock);
-}
-
-static void rt9467_chg_destroy_attach_lock(void *data)
-{
-	struct mutex *attach_lock = data;
-
-	mutex_destroy(attach_lock);
-}
-
-static void rt9467_chg_destroy_ichg_ieoc_lock(void *data)
-{
-	struct mutex *ichg_ieoc_lock = data;
-
-	mutex_destroy(ichg_ieoc_lock);
-}
-
 static void rt9467_chg_complete_aicl_done(void *data)
 {
 	struct completion *aicl_done = data;
@@ -1218,21 +1197,15 @@ static int rt9467_charger_probe(struct i2c_client *i2c)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add irq chip\n");
 
-	mutex_init(&data->adc_lock);
-	ret = devm_add_action_or_reset(dev, rt9467_chg_destroy_adc_lock,
-				       &data->adc_lock);
+	ret = devm_mutex_init(dev, &data->adc_lock);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to init ADC lock\n");
 
-	mutex_init(&data->attach_lock);
-	ret = devm_add_action_or_reset(dev, rt9467_chg_destroy_attach_lock,
-				       &data->attach_lock);
+	ret = devm_mutex_init(dev, &data->attach_lock);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to init attach lock\n");
 
-	mutex_init(&data->ichg_ieoc_lock);
-	ret = devm_add_action_or_reset(dev, rt9467_chg_destroy_ichg_ieoc_lock,
-				       &data->ichg_ieoc_lock);
+	ret = devm_mutex_init(dev, &data->ichg_ieoc_lock);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to init ICHG/IEOC lock\n");
 
-- 
2.53.0




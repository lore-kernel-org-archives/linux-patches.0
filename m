Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A638E8B9;
	Sat, 12 Sep 2026 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242613; cv=none; b=dxLjNDaLPaavDZOSGGNZMOqlBM4nA+2QDaHsOmu85YDc75Z/NvzfbsH5gMmlo1rAj2Vk4nHFUN1kI2YD7GlMOSiq1rZ9KK5qn//mhJk/I+sXQU5wuGnYnXDt7ZhrCH9ZOOtAHrySfr7eisEtf4fImL5bPHM+mpqJBUHnksEsb6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242613; c=relaxed/simple;
	bh=xHrtE21bMDbYblrqbf94D55h3wyej86yFFGnJQRYM/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P12IhQnAmp953fKVYZGFDgCu0YU76IPVhMQTrdzkeTveEC2HuIhaFp4BrGRU+bGtNy0CSUmLVRRz/ko0rJcQkMKKc2UQIQ1zmmXYhed68HfOGyEt6GqPEgFqd/FCY4evY3lewP0kLX354C/28KDuSy1+OcJfqOd+a8B9ZM2SJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLzmMjMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLzmMjMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB921F000FF;
	Sat, 12 Sep 2026 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242612;
	bh=/gHdQIdwioeSEvE3pkSjGwY+Bmri8powRL0k6EHehzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLzmMjMXJDHHEPEaMpWHngNBNqnrfxRrN7Q0scf8Hinu7GVD/VrqU4tg+EKIOWCyV
	 ngUJS7UJRW7pAKoBXpJvxNo7aCehxTGYlL1Z+HW2fEIjzsbyPu+m0WXpNG/NjXt/j3
	 7mrOg4tazaOP0V5Tn+6livM/QG33L5uVXHfbQd84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/798] misc: ad525x_dpot: Make ad_dpot_remove() return void
Date: Sat, 12 Sep 2026 09:01:31 +0200
Message-ID: <20260912065527.755736040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 85385a51ceadfe79ae3b1eb5848fab6c3b917ea8 ]

Up to now ad_dpot_remove() returns zero unconditionally. Make it return
void instead which makes it easier to see in the callers that there is
no error to handle.

Also the return value of i2c and spi remove callbacks is ignored anyway.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211012153945.2651412-12-u.kleine-koenig@pengutronix.de
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e3a8557e88eb ("misc: ad525x_dpot: use driver core groups for sysfs files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ad525x_dpot-i2c.c | 3 ++-
 drivers/misc/ad525x_dpot-spi.c | 3 ++-
 drivers/misc/ad525x_dpot.c     | 4 +---
 drivers/misc/ad525x_dpot.h     | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index bd869ec5edba4..0ee0c6d808c3b 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -69,7 +69,8 @@ static int ad_dpot_i2c_probe(struct i2c_client *client,
 
 static int ad_dpot_i2c_remove(struct i2c_client *client)
 {
-	return ad_dpot_remove(&client->dev);
+	ad_dpot_remove(&client->dev);
+	return 0;
 }
 
 static const struct i2c_device_id ad_dpot_id[] = {
diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index aea931dd272e6..a9e75d80ad362 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -92,7 +92,8 @@ static int ad_dpot_spi_probe(struct spi_device *spi)
 
 static int ad_dpot_spi_remove(struct spi_device *spi)
 {
-	return ad_dpot_remove(&spi->dev);
+	ad_dpot_remove(&spi->dev);
+	return 0;
 }
 
 static const struct spi_device_id ad_dpot_spi_id[] = {
diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 6f164522b0282..7e691e8bb37a9 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -740,7 +740,7 @@ int ad_dpot_probe(struct device *dev,
 }
 EXPORT_SYMBOL(ad_dpot_probe);
 
-int ad_dpot_remove(struct device *dev)
+void ad_dpot_remove(struct device *dev)
 {
 	struct dpot_data *data = dev_get_drvdata(dev);
 	int i;
@@ -750,8 +750,6 @@ int ad_dpot_remove(struct device *dev)
 			ad_dpot_remove_files(dev, data->feat, i);
 
 	kfree(data);
-
-	return 0;
 }
 EXPORT_SYMBOL(ad_dpot_remove);
 
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index ee8dc9f5a45a2..72a9d6801937c 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -209,6 +209,6 @@ struct ad_dpot_bus_data {
 
 int ad_dpot_probe(struct device *dev, struct ad_dpot_bus_data *bdata,
 		  unsigned long devid, const char *name);
-int ad_dpot_remove(struct device *dev);
+void ad_dpot_remove(struct device *dev);
 
 #endif
-- 
2.53.0




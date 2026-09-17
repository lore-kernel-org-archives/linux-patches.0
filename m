Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09A94B44A8;
	Thu, 17 Sep 2026 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667305; cv=none; b=APsas2jvA7mciixtLYjUHnbh2Ff4DZbxS2JBaeeA1iwsTmR/z162M5eft4XokBSfRsnDJmc//VikdGK9C33NQ9hQpzmfJKR6FpMZvDIWO94aig0wWPlcAhRZdvgi8zCLX9Un7eepSl+aRudhXlvmzkG9tBHbdSGwCl5Q2cF/rcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667305; c=relaxed/simple;
	bh=/cZOO+LbAcjMxQEJ9HRypVfoGLV7VQifEoZ/3/ehmsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sczyz++qAml9APCg6IS77Fo2FTBwKiyKXc1cMZXfUgzB3uINTch3IKomj4ZENGjMIxvg/ice8lwv0GvxjY7aiJ3TI669Mg0Prf2fD0HRa9naupFwK5BazGcvbDpIb+vjAIV3xwVhkD/zm3IQJ3zOKptVyOS1pRa65KH8ToMQC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnwvP2Zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnwvP2Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91EA1F000FF;
	Thu, 17 Sep 2026 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667304;
	bh=tXo2pTpzyLP4HCmAYLabFbnO8S07SC3JvUvxXhjtaO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnwvP2ZgewyUSCOCYT4T+iWsJ8FZTs5LI1bKjWDYyN4FfJ0l9AKpbK0tm/IAA/rfa
	 e+HzzZ9Br1WiUftbWP/X2/6W+Krfw4hAx0Nph4W4AU1HSZtmI4do7IiIiYyQ5cGkvn
	 TechCo9IwiiOWnrfUWiSflm+X3ORAozFwSs8V7KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tung <kevin.tung.openbmc@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0010/1102] iio: adc: rtq6056: add i2c_device_id support
Date: Thu, 17 Sep 2026 15:59:13 +0100
Message-ID: <20260917151539.681430657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Tung <kevin.tung.openbmc@gmail.com>

[ Upstream commit ce80292ead5bb42b50a6b63e44fd95c0edf9d334 ]

Add i2c_device_id table to support legacy I2C instantiation.
Update probe to use i2c_get_match_data() so device data can be
retrieved consistently for both OF and legacy I2C instantiation.

Signed-off-by: Kevin Tung <kevin.tung.openbmc@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/rtq6056.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rtq6056.c b/drivers/iio/adc/rtq6056.c
index 8172ea51c52ed..8297f4591b338 100644
--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -719,7 +719,7 @@ static int rtq6056_probe(struct i2c_client *i2c)
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EOPNOTSUPP;
 
-	devdata = device_get_match_data(dev);
+	devdata = i2c_get_match_data(i2c);
 	if (!devdata)
 		return dev_err_probe(dev, -EINVAL, "Invalid dev data\n");
 
@@ -862,6 +862,13 @@ static const struct richtek_dev_data rtq6059_devdata = {
 	.set_average = rtq6059_adc_set_average,
 };
 
+static const struct i2c_device_id rtq6056_id[] = {
+	{ "rtq6056", (kernel_ulong_t)&rtq6056_devdata },
+	{ "rtq6059", (kernel_ulong_t)&rtq6059_devdata },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rtq6056_id);
+
 static const struct of_device_id rtq6056_device_match[] = {
 	{ .compatible = "richtek,rtq6056", .data = &rtq6056_devdata },
 	{ .compatible = "richtek,rtq6059", .data = &rtq6059_devdata },
@@ -876,6 +883,7 @@ static struct i2c_driver rtq6056_driver = {
 		.pm = pm_ptr(&rtq6056_pm_ops),
 	},
 	.probe = rtq6056_probe,
+	.id_table = rtq6056_id,
 };
 module_i2c_driver(rtq6056_driver);
 
-- 
2.53.0




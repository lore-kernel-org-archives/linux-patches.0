Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE64E73C8;
	Thu, 17 Sep 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660908; cv=none; b=A8ugjXGb9dEc2V2zKWe1Ue2FOGB3L4ussxais6BmZNwZlIQO/mbyk4Dzc0xgei9EvFtI5RWVCLxpz1N19f3oseMjh3Fqz1z3AUyzdN1cfERsBG1C1EOldGukuuwePAzQBm9kqY507HQ+ALtRAZ7mWaHWYcQydEjVzS+FswWtRek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660908; c=relaxed/simple;
	bh=imz/iponcNdqeiEB+il9BtJXVQfh2/Zgla9Fhjmv8Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAeAnRan3K90DfE25RlvinpKCE262QomfaWCS988OCu0aG2lNRF6BsL3ThXXPyOeRk+fWTwxlx370MvWqb/oewhNjjoDh24IXzqYwBL1jEaEZEAjDawR0AfWxu+/WX0UoNbWF1V8Q9djeBf4UkvpnW3sjp5MvZwrGp52ajn7AW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQxLagYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQxLagYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FD31F000FF;
	Thu, 17 Sep 2026 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660906;
	bh=3pFlaFQxIIIRjlf3s+j30zgz/IegwvkH3gz6ggSkfqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQxLagYpvCtkvHcQkueKU5A3ewKl6WtdlmQm76AEPrdNlJpkSI750Sh/Z9yKHA1iQ
	 KnEN0eoIo/7N9mS7z0UdVnOCH7y6MEyq3KAYDxXfQdBy3KewsB0d2oJEblcbHTRNcY
	 En26mXRZQ4fnGxRbUzCUKEao1tEblOr+RMczHqRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tung <kevin.tung.openbmc@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0018/1250] iio: adc: rtq6056: add i2c_device_id support
Date: Thu, 17 Sep 2026 15:56:53 +0100
Message-ID: <20260917151552.421399230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 2bf3a09ac6b04..e2b1da13c0d31 100644
--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -728,7 +728,7 @@ static int rtq6056_probe(struct i2c_client *i2c)
 	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -EOPNOTSUPP;
 
-	devdata = device_get_match_data(dev);
+	devdata = i2c_get_match_data(i2c);
 	if (!devdata)
 		return dev_err_probe(dev, -EINVAL, "Invalid dev data\n");
 
@@ -871,6 +871,13 @@ static const struct richtek_dev_data rtq6059_devdata = {
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
@@ -885,6 +892,7 @@ static struct i2c_driver rtq6056_driver = {
 		.pm = pm_ptr(&rtq6056_pm_ops),
 	},
 	.probe = rtq6056_probe,
+	.id_table = rtq6056_id,
 };
 module_i2c_driver(rtq6056_driver);
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6D53816;
	Wed, 21 Feb 2024 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521824; cv=none; b=eOZBqMyyGL6+pu2Q+wym+I9RTb4KpBEkaInU7HT6DyFAlny/6g8tTna5/9Wof0VRSXv3BAnC8hB0ltmytV9d5g09m2j4UR0RyTEyCBLFO7otULZN+uAQ//gIfC4H+9jy6lCizqoUoTBqPhJ6FJHBGTJdtHcvqGWtTsvYR+2R/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521824; c=relaxed/simple;
	bh=Udat374/hcPiQBbep53njc/hy0MJro1y2z7n7MEyBnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERINOw+cjcy1jEtJPvWzhluEAxWXlLF0iab6sTupXN1aYciQJkOJSiriaMrgcuVDXXVGwit+CMcp1r3XBmmPTRgG7OQwK4gs4SSheZOrr4iqjXxW0cEfsQnHJegC6HedTIzcjxbOh4A577qyobc3C50zY8ojyqvsufd5epvR3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnii2/Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnii2/Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4399EC433F1;
	Wed, 21 Feb 2024 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521824;
	bh=Udat374/hcPiQBbep53njc/hy0MJro1y2z7n7MEyBnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnii2/Ap9C7ydfA/0M/qzISyIQvRgr2cZO6gFMi0+kjXPdPSzc1urbYtmLTDpqnGP
	 S09azkoni8sBHcg5Irej5woAm8OxFTj3J3HP4F3G3aoenntVNTgb5iWU21xqIh4y6U
	 huaSJesQH/L7jId6Y8L71COYOxIrG1zl+RFrvYQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.15 012/476] iio:adc:ad7091r: Move exports into IIO_AD7091R namespace.
Date: Wed, 21 Feb 2024 14:01:03 +0100
Message-ID: <20240221130008.326341612@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 8a0080af84d3fb2423f0b3b55eff666f545eb097 upstream.

In order to avoid unnecessary pollution of the global symbol namespace
move the core/library functions into a specific namespace and import
that into the various specific device drivers that use them.

For more information see https://lwn.net/Articles/760045/

An alternative here would be to conclude that we are unlikely to see
support for the other ad7091r parts in the near future and just merge
the two modules into one supporting just the i2c -5 variant.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220130205701.334592-3-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7091r-base.c |    4 ++--
 drivers/iio/adc/ad7091r5.c     |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7091r-base.c
+++ b/drivers/iio/adc/ad7091r-base.c
@@ -429,7 +429,7 @@ int ad7091r_probe(struct device *dev, co
 
 	return devm_iio_device_register(dev, iio_dev);
 }
-EXPORT_SYMBOL_GPL(ad7091r_probe);
+EXPORT_SYMBOL_NS_GPL(ad7091r_probe, IIO_AD7091R);
 
 static bool ad7091r_writeable_reg(struct device *dev, unsigned int reg)
 {
@@ -459,7 +459,7 @@ const struct regmap_config ad7091r_regma
 	.writeable_reg = ad7091r_writeable_reg,
 	.volatile_reg = ad7091r_volatile_reg,
 };
-EXPORT_SYMBOL_GPL(ad7091r_regmap_config);
+EXPORT_SYMBOL_NS_GPL(ad7091r_regmap_config, IIO_AD7091R);
 
 MODULE_AUTHOR("Beniamin Bia <beniamin.bia@analog.com>");
 MODULE_DESCRIPTION("Analog Devices AD7091Rx multi-channel converters");
--- a/drivers/iio/adc/ad7091r5.c
+++ b/drivers/iio/adc/ad7091r5.c
@@ -91,3 +91,4 @@ module_i2c_driver(ad7091r5_driver);
 MODULE_AUTHOR("Beniamin Bia <beniamin.bia@analog.com>");
 MODULE_DESCRIPTION("Analog Devices AD7091R5 multi-channel ADC driver");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(IIO_AD7091R);



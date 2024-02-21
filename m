Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7F78B53;
	Wed, 21 Feb 2024 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523638; cv=none; b=e3W7L3RwD2cN8QuNcDH0R90MH3gfJLjZlgzt9O/bUP/NCQ5xARQmNP84kg2bKlYOmKCSFsSjqIK91Uh78pkjqoXYrl/7Yf5dNIT1q5C7DljFu1DJUMwDcT2Qi9z7cRUj9OtGkaKgnTcy1AUflW3aJFNIvXv3AFJLDSn6S2uJTvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523638; c=relaxed/simple;
	bh=07BTzR+ZsmWnyI0YuryOfsUmnhUY8cSvs7dXaP2C0bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3OwslNA0ddZ/EyNj8iUE8LgmysMTBFBkkhlImMEHd5WVaufuSHnYjRJ81Dy5Ski9SmkuHEvCP2vaX6GBwv4Y9s6ONiKVWthYRDTsgNri5zk8wb6EkhCCMXNCzWi6VvHwN7nzcBv9TmJX6m9oe8lGMu3UTodBwhooltl54OP0p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5vyCXaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5vyCXaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9223BC433F1;
	Wed, 21 Feb 2024 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523638;
	bh=07BTzR+ZsmWnyI0YuryOfsUmnhUY8cSvs7dXaP2C0bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5vyCXaqRVNiyCJkYY3GU2h705R/b4VIWw6VcjFiH3Exu9oD2GBvGlMnnE19w32Rs
	 dH7xIEBUvvNAx+y1xZk8Xun6iA3jwy8ZBFbBltH+OQYXiQODsjWUtZkSCLLaO9M2p1
	 NXmjsHHdL6bz3N99tmL3mPbTbSx9D8vO+d8tgJYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 016/379] iio:adc:ad7091r: Move exports into IIO_AD7091R namespace.
Date: Wed, 21 Feb 2024 14:03:15 +0100
Message-ID: <20240221125955.400835572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068782DF9F;
	Tue, 20 Feb 2024 21:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464910; cv=none; b=C5Ik5/9H7TCeayFriP2KR7uYCKeGOrUyqkfGpa0gr3WhbgMaNrWhvaN5bi3md4uaNKa7ZCARHvrVd8uNT7l/BSz9s6qEZM4p4oy97pBGv8HZYeWCAtrsg1NtiMJsCR6d+9h8EWhDhQLKrxbuXXsF79tlM63D5t/65Tfo4LOL/JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464910; c=relaxed/simple;
	bh=GaGNJwup+kmiKtPUABicm6fJ2EZqWOH8LJv//m61OSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maw9MU9yvdrq6VgoglgWXjuG7ym+Gq6IIATopKzkpu16GvU6dukQmSHl5SRJ8xr8dTzS4KK/Wum39ay2rbsCN3lk2YPT7Q5TJJyFdom+FqDHwPjFZ2MUIUYLIJnJGd/IeHASViN9huEtowqtvan4n1DfNyHEFmDfWzD6A2qRKVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oszQWww8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oszQWww8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837A2C433F1;
	Tue, 20 Feb 2024 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464909;
	bh=GaGNJwup+kmiKtPUABicm6fJ2EZqWOH8LJv//m61OSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oszQWww88QIqdevtbetLrOwbcklqsQ9UhRee8eX2wagHYpAfQSHF8iagJUk1ueykX
	 /oWSZm89rdeMHZrmDu41SGzA7S/Faf36krLl6yd3gtweS297fgXxWGAimMKWe0nQCH
	 q+lPPMSLiaZ2f2Bv/Fe5/IPJg1Ric2cJ2D9XYsXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 176/309] iio: pressure: bmp280: Add missing bmp085 to SPI id table
Date: Tue, 20 Feb 2024 21:55:35 +0100
Message-ID: <20240220205638.662038710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Protsenko <semen.protsenko@linaro.org>

commit b67f3e653e305abf1471934d7b9fdb9ad2df3eef upstream.

"bmp085" is missing in bmp280_spi_id[] table, which leads to the next
warning in dmesg:

    SPI driver bmp280 has no spi_device_id for bosch,bmp085

Add "bmp085" to bmp280_spi_id[] by mimicking its existing description in
bmp280_of_spi_match[] table to fix the above warning.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Fixes: b26b4e91700f ("iio: pressure: bmp280: add SPI interface driver")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -91,6 +91,7 @@ static const struct of_device_id bmp280_
 MODULE_DEVICE_TABLE(of, bmp280_of_spi_match);
 
 static const struct spi_device_id bmp280_spi_id[] = {
+	{ "bmp085", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp180", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp181", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp280", (kernel_ulong_t)&bmp280_chip_info },



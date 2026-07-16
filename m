Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF001424677;
	Thu, 16 Jul 2026 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209041; cv=none; b=ETLRHnVmnYBkUdO8CU/R6LVRVkeV/WkWbAgdyrkzZzhyZC3aX99eYwTPd0xeHGZyGwFIdNIbSxId7Nea0+9wB8fS4yBFjQETF++4tumEhceU+mqhOr4bvOQIAYPe0Of/cME/4sOExFU+rQebJLX9A9CeSW7oV6NQeuz0h/OAlTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209041; c=relaxed/simple;
	bh=PQjxohLReOdoN8CuvZ3hoyUM8E9ihptvr+07NQyar2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7bsQ+cND0pWxNaZ+uBOej+lvVOqsiUCU1vyX/MkQ0MfEftcKFiKxBnrqZa4zBvfMylXtyQzuGRcbh7hviv+xVK2LtjVBAkcLE0OVQAcJ5JvNo9D7zU9u4ivrrgUwquX6Ov8LNro7j5Y+pCE4LeI4cMeDik3Eva3iVDCv3MCLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWy0vYT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWy0vYT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E351F00A3D;
	Thu, 16 Jul 2026 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209039;
	bh=H1RYel4xZPjR9uCQOgw4h4bvL973cFWBFhz++YspfVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWy0vYT0/bQvHCqqHgBpPPgaKSLFIGq7/PcuLj4BGSkQeNKHsQ2AYlFP/QQsOiFSF
	 WpjPQkiNHVTftNc17QaxgT/i2l1AZGsM1FeQc9ZDhYQgylvxQq9cPXiMi1MjmX7iYW
	 9QA+r8vxuCYeh8Ud8gfmVBM9oU83U5yxehlq1HDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 035/518] iio: adc: ad4062: add GPIOLIB dependency
Date: Thu, 16 Jul 2026 15:25:03 +0200
Message-ID: <20260716133048.547248621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit a5b7991d5a737df71a5e4230554481255af64ed4 upstream.

The ad4062 driver gained support for the gpiochip and now fails
to build when GPIOLIB is disabled:

390-linux-ld: drivers/iio/adc/ad4062.o: in function `ad4062_gpio_get':
drivers/iio/adc/ad4062.c:1383:(.text+0x3dc): undefined reference to `gpiochip_get_data`

Add a Kconfig dependency for this.

Fixes: da1d3596b1e4 ("iio: adc: ad4062: Add GPIO Controller support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -78,6 +78,7 @@ config AD4030
 config AD4062
 	tristate "Analog Devices AD4062 Driver"
 	depends on I3C
+	depends on GPIOLIB
 	select REGMAP_I3C
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER



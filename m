Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95C03195EF;
	Thu, 16 Jul 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210564; cv=none; b=edFEZwF1hk3Eqttv2VulXIhE2tmT0pY8DobZyefJsXL6irBF5pgLGQrhaELOOa2rnxYYI7xI4sjytmh1dAQ+w21gI9JvAJNt2qvDkCilI9kjq3RIs+6Bty9tCqAWcQiX4sRlzXg44C+GJ9MYp0IHcpYYx1r1L0HkbsFnrFvkjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210564; c=relaxed/simple;
	bh=0s+uqtmMB5EXxFAeaJ6xRLk7HmpJnxIPgj28jDaI3oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBHr1ybYjGflNOkGxHDtP3bd5WFZ5FYkKflNJSw6QbA+wE8aUnsxWgO4gXJ0heSvt37550TDrbwxnQ2fb9VzAt7QNdfPp6aIhLKlwSKzS7f0kv5iGhtVVsukmI5v7QOm7ShJ6u4bOfDtmDfOaEkTEGClu/P1PjVrV0JsjtkbbUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5HgpvM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5HgpvM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B161F000E9;
	Thu, 16 Jul 2026 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210563;
	bh=Z50H+hL5V3lI3BSER8awbZL1PNQc00YNCtHYg2PIbcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5HgpvM8ZOYXaK54/V7Zb3pvwNXV0knssJAWoSdQ0LfxHKjqwyujBITXMqlDCI31l
	 FIGvHMMIqmhP6dBnb7NkW/WCTYQYPYECLnSSO6MlwysNgo94aE1B6I2VGOizwntWoa
	 oGBBavjOcFscKDWwDB1j31ZRPELAm7GRLA9/ITT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 052/480] iio: adc: ad7779: add missing select IIO_TRIGGERED_BUFFER to Kconfig
Date: Thu, 16 Jul 2026 15:26:39 +0200
Message-ID: <20260716133045.837044964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit fd354554af1d2b33232ca6c8a3d79ed82413d715 upstream.

The Kconfig entry for the AD7779 is missing a
'select IIO_TRIGGERED_BUFFER' parameter, causing build failures.

Fixes: c9a3f8c7bfcb ("drivers: iio: adc: add support for ad777x family")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -404,6 +404,7 @@ config AD7779
 	depends on SPI
 	select CRC8
 	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	select IIO_BACKEND
 	help
 	  Say yes here to build support for Analog Devices AD777X family



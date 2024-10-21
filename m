Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80101EE02C;
	Mon, 21 Oct 2024 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507834; cv=none; b=j+5T39SXmWZjHD8RHSNfQynBOrQJBbj7FU2ICnSUe4HMOv4QvuIj4IHkzmgT30xPmDmxzW/PNz2FhV+WvdqzFqz3tsV1sEbx4k7UxOREqW4Gz4gxzG9FCKPT2uO7eO5bQLoR+VGa93wyVlcRqI0nA1M7hXulB2DX4sdD6L2vMS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507834; c=relaxed/simple;
	bh=npd9R+M6s9z+9Ks9yl+VAYyKMbEG33Eoyml8S2SWCP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUQ4xM1Bf2+EKhRh9nsPho2fLF7I2ZxniHBTc2L83HoL4C3xIbLzTwDkvFW7dJtkyyz6OzaCFmGNiJbwL6s9GS65efXaUOTWhXaOy8W47rLv3uBHKgNrXG8K1z8q0azxLfIKHJtA4HcyFihhGSr2wwvv1koxr7jS3r54SvmHxaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJWk9Y0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJWk9Y0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20B5C4CEC3;
	Mon, 21 Oct 2024 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507834;
	bh=npd9R+M6s9z+9Ks9yl+VAYyKMbEG33Eoyml8S2SWCP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJWk9Y0wEcPZv7jy81HTSeVpiGDTdPC7y7WOGGpe5xMj3u4iB4HwE5r/WeMe/bsbm
	 oIZ+O/Dkqn/QYxkPgjGOsShEj41BPzAZGpmvEmz4C3FnxHZW7c6xSWHIhDhNIDjM+G
	 W9axWtghLbcsQ4SzXXwBSWTKgnwwpupx9PJx1GT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 35/52] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:56 +0200
Message-ID: <20241021102243.000813057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit eb143d05def52bc6d193e813018e5fa1a0e47c77 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-3-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1138,6 +1138,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67CD1F4298;
	Wed,  6 Nov 2024 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898842; cv=none; b=eD3WgBbjaVqyPMi3o11CuR/WHfMdZ0Gzk3jZ2C7VJSm+ACnszOE50yWMHohSTUsifToUWAv9jaWECM+7OP302lDh4OkYKO3rU8J20op0JAHeLflXzTm36jQGKM9016qoZ6d5JE4iYGofRvVNmPI3To76wcd4fl3XkOCxAb9wgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898842; c=relaxed/simple;
	bh=T4OIWkDdJGOP6NidLkGwOwl8O6aDMuvw5+an22rn9KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ts48jcGdSJOYrBeH7DjDTAYjGtog0pkoNJ0zfpFkz+5IogmcvkFvS41r003POkHVnaUFiyaqFmrvNSMp8rTOtgffzp34xNSfiRbVn0FOpnKVxcaDhIuVDRjjtrUqp68I4oVFBoqZtah4wJVfkDT7KwKx6lhg1TeAtafywEfNKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdDijRPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdDijRPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD20C4CECD;
	Wed,  6 Nov 2024 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898842;
	bh=T4OIWkDdJGOP6NidLkGwOwl8O6aDMuvw5+an22rn9KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdDijRPY7PHlfgGEIthYZNtLtyIGrL2VqBG5lISVqhBYb+zgMM0zPEyCiH7sowC3e
	 xtIXwP/2sx+tGSfhaAZMqKnjlq/OI+EYRz5xRLUqy4EPJtm6sdQqcb2jyXd81W23Tp
	 mFQVKvclRsFOJBYlt3fcevOQQ7FdejXYMzDTuEtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 373/462] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Wed,  6 Nov 2024 13:04:26 +0100
Message-ID: <20241106120340.738474006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -992,6 +992,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961693375D9;
	Tue, 26 Aug 2025 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207753; cv=none; b=qyRgO8mo5xmzWZUHxznRUfUkuAxJB85JWE3gPVrA/Q/w9PMV+ek2F8uGYCj9Os6zSoZatkOR2dA6kUncJ8dsEPvrIkVLNKVJg6RLpp02chxN3Mngsu9tUyAEPz7bk/p3DtsOQoKf8cmW4dGOdOjNqCy7ghAUbO8Gmr4409/qYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207753; c=relaxed/simple;
	bh=8wkEq0amkOD9Bix6ko+SYiMVzNTx20ikrNPeU1JibGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VH9x1n3J1PXv6mlqN15xma8j+reX5cmu18M12hjpHWgxLi1pQHg+Cr//ufyAKjFdEhrtDQlxe96aAu0OrZySR4frzCMU4K0mNrpCQ95k31QS+4xWKuOS74mLBkWQww8+srwM5115Yg+wzlP4GYAR+pjLrbyHQi2aHtUl6Jzc/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy47P+oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy47P+oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAFBC4CEF1;
	Tue, 26 Aug 2025 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207753;
	bh=8wkEq0amkOD9Bix6ko+SYiMVzNTx20ikrNPeU1JibGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy47P+oyXut8xvphuS75ZqqoMUiMfdSa/GNZHJb8Mblp8VrLAK6ltjvRnX8hjevlL
	 4t3dR9l97bdvxtx/2ucOFeFs/2eu5Ds/jkYC3Om0yDDJISDCIjCP3qby8U4zKAUCel
	 0zajMcBxaIP6kCOI7dFYIUOC95ZSh6Ep500ejnL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 303/457] iio: adc: bd79124: Add GPIOLIB dependency
Date: Tue, 26 Aug 2025 13:09:47 +0200
Message-ID: <20250826110944.860462481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 8a6ededaad2d2dcaac8e545bffee1073dca9db95 upstream.

The bd79124 has ADC inputs which can be muxed to be GPIOs. The driver
supports this by registering a GPIO-chip for channels which aren't used
as ADC.

The Kconfig entry does not handle the dependency to GPIOLIB, which
causes errors:

ERROR: modpost: "devm_gpiochip_add_data_with_key" [drivers/iio/adc/rohm-bd79124.ko] undefined!
ERROR: modpost: "gpiochip_get_data" [drivers/iio/adc/rohm-bd79124.ko] undefined!

at linking phase if GPIOLIB is not configured to be used.

Fix this by adding dependency to the GPIOLIB.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508131533.5sSkq80B-lkp@intel.com/
Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/6837249bddf358924e67566293944506206d2d62.1755076369.git.mazziesaccount@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1257,7 +1257,7 @@ config RN5T618_ADC
 
 config ROHM_BD79124
 	tristate "Rohm BD79124 ADC driver"
-	depends on I2C
+	depends on I2C && GPIOLIB
 	select REGMAP_I2C
 	select IIO_ADC_HELPER
 	help



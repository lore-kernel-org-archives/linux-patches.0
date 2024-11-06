Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607301DF738;
	Wed,  6 Nov 2024 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898828; cv=none; b=kHfnxRqz+2oNG+jZY7XsniDYtNqWWTqSK0qHs4sSYCYpIF+aqvu+QU6Z+hrSn6ZcK3Mqwo4DPAq9bM0BiMQdL4KwGnRw9X87BSQ5FBlrYD9Zhbob/IC8l6CYR/ODTf5waqfEzYJFdd6oWQpUkQJ8kRdbJa7TAcGK2l0b9L2Fp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898828; c=relaxed/simple;
	bh=b18bJDCR9zxO1pVyWwrOJiMkh2I2YO4mj4LEmgVSe5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaQEQHn9MGv7RNzlM0crF0vF1E2lBGHnZdv6P1xzyoDsRc4kWr4au7/Vlf49YXfhurDNn9VOOejF2ggXEMpqVz/CbwjmZ0OHe4yaisDbKD5s9Q01Fr+1MVMjcC6Fsvhv2Llh0+VLAK1vbRFvjarx1kzpc0TL/EvKikuurJ32vHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW6UDqPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW6UDqPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A5FC4CED3;
	Wed,  6 Nov 2024 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898828;
	bh=b18bJDCR9zxO1pVyWwrOJiMkh2I2YO4mj4LEmgVSe5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW6UDqPg6xO1nzwEVeQGcT9ECExj3OgI2UQtxSe4JqY1opa16ZsAyFCpVRTCjp3rF
	 upaPmKOwnNzXB/0dBZBHy0V4Q2s+LbDWdwF/orPEhKEb7MS2hrek9XTm/+4Fyi2x8u
	 ZavTnFlIg7YllLBPpV+C0QqhScmzph0rtPZIcahY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 369/462] iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Wed,  6 Nov 2024 13:04:22 +0100
Message-ID: <20241106120340.642379730@linuxfoundation.org>
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

commit 4c4834fd8696a949d1b1f1c2c5b96e1ad2083b02 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Fixes: 2a86487786b5 ("iio: adc: ti-ads8688: add trigger and buffer support")
Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-4-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -980,6 +980,8 @@ config TI_ADS8344
 config TI_ADS8688
 	tristate "Texas Instruments ADS8688"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS8684 and
 	  and ADS8688 ADC chips



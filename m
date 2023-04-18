Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC562566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DD6C433EF;
	Tue, 18 Apr 2023 12:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820926;
	bh=1FNGvXZKJ/grg9RH+9AYoFkTUlsuj7fNAa6rpb5+/tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2wyjb2fr9UkvWOzlIAwCbwwE1O16dmZePLdUpAJ5AdsCz+lXHWqhFj4u/N+iwIIV
	 tuLfOY2DKxdHxSG1o+qspwK9v9mAHlY+x52GWujpWT31qXbclh7UBPIkG+V7ZSQ4gK
	 Pxd2ewktZT63V4qFnNlEIHvXSBue0m7p1pE9Ii+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	David Lechner <david@lechnology.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 25/92] iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip
Date: Tue, 18 Apr 2023 14:21:00 +0200
Message-Id: <20230418120305.706813029@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lars-Peter Clausen <lars@metafoo.de>

commit 363c7dc72f79edd55bf1c4380e0fbf7f1bbc2c86 upstream.

The ads7950 uses a mutex as well as SPI transfers in its GPIO callbacks.
This means these callbacks can sleep and the `can_sleep` flag should be
set.

Having the flag set will make sure that warnings are generated when calling
any of the callbacks from a potentially non-sleeping context.

Fixes: c97dce792dc8 ("iio: adc: ti-ads7950: add GPIO support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: David Lechner <david@lechnology.com>
Link: https://lore.kernel.org/r/20230312210933.2275376-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -635,6 +635,7 @@ static int ti_ads7950_probe(struct spi_d
 	st->chip.label = dev_name(&st->spi->dev);
 	st->chip.parent = &st->spi->dev;
 	st->chip.owner = THIS_MODULE;
+	st->chip.can_sleep = true;
 	st->chip.base = -1;
 	st->chip.ngpio = TI_ADS7950_NUM_GPIOS;
 	st->chip.get_direction = ti_ads7950_get_direction;



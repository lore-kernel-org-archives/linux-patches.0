Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798E1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647F1C433D6;
	Wed, 23 Nov 2022 09:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196161;
	bh=kkjYAi6GyHZFGIO3tZgWYZ//QSxKIu91Xoswk/75h30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy2bpQqEqYsov2fzcLphkp79/os3xuwAg4AcDnOxRl/08X2zq3ujg2k4LowOzQq+c
	 fyeMjmNy+Bch6UeTJL6Oo0/eysylkUnMIR9khrpndzCBKn0EQnOnpXsU3c8W2Dreax
	 mXKxHobdBeM3pEf3n/61H6WXAoFM7rChmlU0+f7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Sekar <sravanhome@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 137/181] iio: adc: mp2629: fix wrong comparison of channel
Date: Wed, 23 Nov 2022 09:51:40 +0100
Message-Id: <20221123084608.266469919@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saravanan Sekar <sravanhome@gmail.com>

commit 1eb20332a082fa801fb89c347c5e62de916a4001 upstream.

Input voltage channel enum is compared against iio address instead
of the channel.

Fixes: 7abd9fb64682 ("iio: adc: mp2629: Add support for mp2629 ADC driver")
Signed-off-by: Saravanan Sekar <sravanhome@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20221029093000.45451-2-sravanhome@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mp2629_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -73,7 +73,7 @@ static int mp2629_read_raw(struct iio_de
 		if (ret)
 			return ret;
 
-		if (chan->address == MP2629_INPUT_VOLT)
+		if (chan->channel == MP2629_INPUT_VOLT)
 			rval &= GENMASK(6, 0);
 		*val = rval;
 		return IIO_VAL_INT;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7751C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552E3C433C1;
	Wed, 23 Nov 2022 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197271;
	bh=kULyYoPvu00hdw6bXMFo/3Gdct49krBAENS9no4KVCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPRvH6TvWq7d7o7jr8bmdtM1Pyti8mJr3gT0nhK08gOnUtjLo1uyoBhLEmxtHfd8W
	 f3A4ppbGKlbMuPEFkty4oZJVT/R+8l9n682CDrbyY02HwBuPsZJmM05OyNNBU/ZpZh
	 2eRY3ix3XTkvLS+D1IHsEd47g/JbWy6hjBDGFOGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Sekar <sravanhome@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 247/314] iio: adc: mp2629: fix wrong comparison of channel
Date: Wed, 23 Nov 2022 09:51:32 +0100
Message-Id: <20221123084636.700387459@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
@@ -74,7 +74,7 @@ static int mp2629_read_raw(struct iio_de
 		if (ret)
 			return ret;
 
-		if (chan->address == MP2629_INPUT_VOLT)
+		if (chan->channel == MP2629_INPUT_VOLT)
 			rval &= GENMASK(6, 0);
 		*val = rval;
 		return IIO_VAL_INT;



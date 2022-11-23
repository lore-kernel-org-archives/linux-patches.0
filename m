Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0AC1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E49C433C1;
	Wed, 23 Nov 2022 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194082;
	bh=j/JTQIAE1GWBAnBCJNbxGvmRrWSFsFWJpR/Z13Ya33Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/kKs1C/S1GHJd9JyYQJnKOcAWWTbs4TUuWhZAmjSRyXZTq23chnc2xu9VqRGdewi
	 7IIO/baKRoCRc1w6ZOmGDXS1IKaR0W6pcyF8/oOiXwP10H0mOq9IVu8+gEXqHBeMvo
	 R7ukCoF3N7MJx3k+XmzjTnzFjCk0H4W48Yds/qyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitja Spes <mitja@lxnav.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 67/88] iio: pressure: ms5611: changed hardcoded SPI speed to value limited
Date: Wed, 23 Nov 2022 09:51:04 +0100
Message-Id: <20221123084550.949367163@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mitja Spes <mitja@lxnav.com>

commit 741cec30cc52058d1c10d415f3b98319887e4f73 upstream.

Don't hardcode the ms5611 SPI speed, limit it instead.

Signed-off-by: Mitja Spes <mitja@lxnav.com>
Fixes: c0644160a8b5 ("iio: pressure: add support for MS5611 pressure and temperature sensor")
Link: https://lore.kernel.org/r/20221021135827.1444793-3-mitja@lxnav.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/ms5611_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -95,7 +95,7 @@ static int ms5611_spi_probe(struct spi_d
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)



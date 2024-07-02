Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A649E1BE222;
	Tue,  2 Jul 2024 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940692; cv=none; b=f7BG9ZhX57xu3vqHrPAUfibIWJp+CqrvTCKZ8zziTYUQ1pZOYy1twGfOi5mmEIVKOyF76MuUeLLnR0b9oQzTOSY/0m0+rpE1bJJY4UaA3/d7TGrHEKW67aXda4mpew2gMVvzf44M4TXmg3dI6k3VBszqsROBewKz/We55pzKlto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940692; c=relaxed/simple;
	bh=MpePgJXuArxWeLf9hfJktHDaKIh+4ksqqZtFult4B98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=epy+u4DQaVZ22qFeX7deL5XkiaWSC7K0uOI4qPmXXuoxlMXOwq7GEs7NGDe3nbgzEu0d2msatUL83wk5NIiwAJNIfzX/RHY2ann77VVagbe0jd9Hh2zsnpISt8sQeQd0nD0RNCanNuCpqIILVTtW+JxldpLfd10HY4ZJbBKuz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PT4stOxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PT4stOxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054DCC4AF07;
	Tue,  2 Jul 2024 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940692;
	bh=MpePgJXuArxWeLf9hfJktHDaKIh+4ksqqZtFult4B98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PT4stOxIinVJr7va6PQSAkYERMGB8bDoRCzWkxUoBYfxFxiBhWa9SkAuIpEb/1O0o
	 ioX031vCDsciCG/550VwEtRoZMF8J9HKbf+7pyGcKWojoGzqv4KTNmT41my1Ye+M3q
	 hk4JmS+/E5mQdrB5hoQXE32RpDdwm539ewpwA58M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li peiyu <579lpy@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/163] iio: pressure: fix some word spelling errors
Date: Tue,  2 Jul 2024 19:01:55 +0200
Message-ID: <20240702170233.107217643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li peiyu <579lpy@gmail.com>

[ Upstream commit a2d43f44628fe4fa9c17f0e09548cb385e772f7e ]

They are appear to be spelling mistakes,
drivers/iio/pressure/bmp280.h:413        endianess->endianness
drivers/iio/pressure/bmp280-core.c:923   dregrees->degrees
drivers/iio/pressure/bmp280-core.c:1388  reescale->rescale
drivers/iio/pressure/bmp280-core.c:1415  reescale->rescale

Signed-off-by: Li peiyu <579lpy@gmail.com>
Link: https://lore.kernel.org/r/20231021070903.6051-1-579lpy@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 0f0f6306617c ("iio: pressure: bmp280: Fix BMP580 temperature reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 6 +++---
 drivers/iio/pressure/bmp280.h      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index a2ef1373a274e..4c493db7db965 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -920,7 +920,7 @@ static int bmp380_cmd(struct bmp280_data *data, u8 cmd)
 }
 
 /*
- * Returns temperature in Celsius dregrees, resolution is 0.01º C. Output value of
+ * Returns temperature in Celsius degrees, resolution is 0.01º C. Output value of
  * "5123" equals 51.2º C. t_fine carries fine temperature as global value.
  *
  * Taken from datasheet, Section Appendix 9, "Compensation formula" and repo
@@ -1385,7 +1385,7 @@ static int bmp580_read_temp(struct bmp280_data *data, int *val, int *val2)
 
 	/*
 	 * Temperature is returned in Celsius degrees in fractional
-	 * form down 2^16. We reescale by x1000 to return milli Celsius
+	 * form down 2^16. We rescale by x1000 to return milli Celsius
 	 * to respect IIO ABI.
 	 */
 	*val = raw_temp * 1000;
@@ -1412,7 +1412,7 @@ static int bmp580_read_press(struct bmp280_data *data, int *val, int *val2)
 	}
 	/*
 	 * Pressure is returned in Pascals in fractional form down 2^16.
-	 * We reescale /1000 to convert to kilopascal to respect IIO ABI.
+	 * We rescale /1000 to convert to kilopascal to respect IIO ABI.
 	 */
 	*val = raw_press;
 	*val2 = 64000; /* 2^6 * 1000 */
diff --git a/drivers/iio/pressure/bmp280.h b/drivers/iio/pressure/bmp280.h
index 5c0563ce75725..9d9f4ce2baa6e 100644
--- a/drivers/iio/pressure/bmp280.h
+++ b/drivers/iio/pressure/bmp280.h
@@ -410,7 +410,7 @@ struct bmp280_data {
 		__le16 bmp280_cal_buf[BMP280_CONTIGUOUS_CALIB_REGS / 2];
 		__be16 bmp180_cal_buf[BMP180_REG_CALIB_COUNT / 2];
 		u8 bmp380_cal_buf[BMP380_CALIB_REG_COUNT];
-		/* Miscellaneous, endianess-aware data buffers */
+		/* Miscellaneous, endianness-aware data buffers */
 		__le16 le16;
 		__be16 be16;
 	} __aligned(IIO_DMA_MINALIGN);
-- 
2.43.0




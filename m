Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064240;
	b=QOaPNXgjNy+g5gGshWsmQxuR9BegZ8UBa6+AXUJj5mj35FWiIuI5NouLKNy/ZEU47QGn
	 SVhYuxZAfF/EmQeoI7vH4saacNfH4oPTbl7BN3dEAyw76kvhv8m8v9+KHldorX+LV/9Om
	 yTtqUmn8gYyXDdsVMIuQQQYYjs5TRPHaOVtkZr2TiGLdHna3fSx8QlGiJLIv8yO8E2DEo
	 UtTP5L7qcgEHHRtFM0HeLGWCvKpE18Yy1r0f1vGesRolfhhwBalvInSflCB8LwUxg/j0x
	 lZT0OaX4RpJDAzgM+fojp9LWapCiXH/XAGYctbaB8qhN2ioqMhQmF6mv5Jxu4gsx7QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DnvALqDx3h+o1PA85e7RfY0TvNBwnu4CYK+S3BeM33U=;
	b=S6Bgv24NQMyRYyxHL35moejzr30bA9PhuqLVD8OAbQkE7bPc8i8KkvLLfwmikq6a85jm
	 SuXlM9zLfJVyzQmwXnGz6z3mVm/YUxik39rzniVId/RoWSswMnaA6WXxNYUlqqcqSZjcL
	 evNwpe6fiZZifUtebl2uwDzEHlx8IH+1+YVJQA9napkU3k5g5YaYHrB+CvDwjgRWihyBd
	 oQWHjHucBXGP7f1KrJvdK2Sf1uNSvWVAO5xYcyUk/4BIEEgOCRCrpd/kVXPt3ZigxTXAc
	 gjoUcE52HsVsOYUHrrfB/jnQ2znlkPupEZSAoerEfa6KCibPDSN23OLYuuZddSXokHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7rVZvqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDD606A332;
	Sat,  7 Nov 2026 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7rVZvqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF01F008A1;
	Sat,  7 Nov 2026 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064239;
	bh=DnvALqDx3h+o1PA85e7RfY0TvNBwnu4CYK+S3BeM33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7rVZvqOJgybGpFLwmlM2SSi1xnsXqyZ2KtgzTDGREGcxgE21JSQRL2AM6lLGQmHz
	 cCEg4J6pN5xueEoL2gFE6ObJ/tfYoDHmV3nyOdelspILLgG0Yd4NVJAkAQk+G90EMv
	 RFbIX2dROuq0EkcPu0AAEeU7HSXN8IfstAHahtzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0336/1257] iio: pressure: bmp280: validate SPI match data
Date: Sat,  7 Nov 2026 08:43:52 -0500
Message-ID: <20261107134948.686483377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 206fc54554c28d76c5d8f66091b846ef1dd88f64 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but bmp280_spi_probe() immediately dereferences the result.

Validate the match data before selecting the regmap bus.

Fixes: faac4dda9a91 ("iio: pressure: bmp280: Use spi_get_device_match_data()")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/pressure/bmp280-spi.c b/drivers/iio/pressure/bmp280-spi.c
index a02a621b80150..95d9635f47111 100644
--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -83,6 +83,8 @@ static int bmp280_spi_probe(struct spi_device *spi)
 	struct regmap *regmap;
 
 	chip_info = spi_get_device_match_data(spi);
+	if (!chip_info)
+		return -ENODATA;
 
 	if (chip_info->spi_read_extra_byte)
 		bmp_regmap_bus = &bmp380_regmap_bus;
-- 
2.53.0




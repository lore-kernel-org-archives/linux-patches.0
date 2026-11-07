Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064241;
	b=ROgQMVJnec8k7ditpcRATm6PZYSco/qDaNwOYlIi/izid60vAyIiHoCzr9LnKFLTdN/K
	 AQgNvOo/bcbs9kVDYsaHx5pH9eGKZxS/gRynKOvS4UlhJ/ADsgvW/h02dvye5R4w632vd
	 OzbKYdaXltMeeTBdF1k0Drx/08SzfPBfs+VaobiHaaLiA8EXKAbHi+ezl5yfTGRwFn772
	 TM2M8qi44A4owCK4ZtlMTa0iKg08498pbUAJbP49FUctGPSaRq1IuWHn57HWQvxQkNbrt
	 e/seI7sA5D5mF/lklpWXNs30qe8lHA66L47IFEnKDqIEjkL6K5ur7UsjiGSPDXxjWfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IuYNnVSieXY6iesFZXwe0jcLUF31I7QpuE2frtNH/yg=;
	b=Ywrj4WD7N8yqpc/T6b3ZhFfE7Utc6Si46mXd5hzX0PLSgi0B8cW8qwxCtDoqYtSXFqmM
	 ZKv3/MvlkITE6g+oMdzr9C6Uz+TCPMWuhpIHoNx9VElO2GevZ8k3vy/77XZc9QL8se/gM
	 2Af24TcmpRUKZ67lgR3uTPeTBHPZ1byVtUIba3BJKtKCYjZBzoEHCVFJ/223K/KmQGXJc
	 x9n5TAsP1iEL5XRIZQjAVeMb/jW9ZjFiUXrTRMMS0DcOzfczLxn4xgd5Wt6EQoTU9iGEX
	 b66WIvkA0YgIs8XYNMMcHicEVn7YzajV2WaNL2Pj5+YEZbrZhMgGAuxrvm8ZhZTGbbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehjocq9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B575606A332;
	Sat,  7 Nov 2026 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehjocq9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4511F008A1;
	Sat,  7 Nov 2026 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064241;
	bh=IuYNnVSieXY6iesFZXwe0jcLUF31I7QpuE2frtNH/yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehjocq9DsmYl8Qg8/LDM2F7S76t51KOXUO9EGlIamfJ7rSuqa1Dh2OfOMI6Xpe7Yw
	 5pRRL0w9/NEY2zZ6G53f5KrfbN7CohWUBMoNzMdREIEqSKAXNNInZ9fYlgICKrD4R9
	 g3I5Ik1Ic6rshrKCFFo8mwTqBvz29lahdMC1uawM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0345/1257] iio: adc: ti-ads7950: validate SPI match data
Date: Sat,  7 Nov 2026 08:44:01 -0500
Message-ID: <20261107134948.925463679@linuxfoundation.org>
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

[ Upstream commit 6bdeaf23ef8062f4c38c025c50e524f1e4d59647 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ti_ads7950_probe() also obtains the IIO device name by dereferencing the
result of spi_get_device_id(), which is NULL on the same override path.
The probe can therefore crash before dereferencing the chip information.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data and use the always available SPI
modalias for the IIO device name.

Fixes: ff0843ceb1fb ("iio: adc: ti-ads7950: remove chip_info[]")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads7950.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index d27c1f2885fd6..0d5708e0b831d 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -527,8 +527,10 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	st->spi = spi;
 
 	info = spi_get_device_match_data(spi);
+	if (!info)
+		return -ENODATA;
 
-	indio_dev->name = spi_get_device_id(spi)->name;
+	indio_dev->name = spi->modalias;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->channels = info->channels;
 	indio_dev->num_channels = info->num_channels;
-- 
2.53.0




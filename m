Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042924;
	b=vjHYJ+6r0xJNso445MguK3gZ/fiI32jVX1s1Fn/oljpKtrLDZXP/7AymxaidAvgy0Kjl
	 KAF1sIi3lkjVCP1L2TTDYUpzRVFIpdIg1cDsQal0lWr3UpKqRVc+oHflu0w4zEEYE9jYU
	 GFRqQ4jHdHn5zgfIezet3gz92VX3sVBctLpgUWWKUoYk0+Ta6B0WSZ0fTRyDwBfepnjy3
	 4Pbixo8oiF6aOwx0Z6y/jgncpFsUSBGi2cQ7ghOU4o0IBqf5Og9Ft1mT/ICm63pNxwMpA
	 1OrLe9XPHavfTmu3NCwAQiATgv6VM6xMSTrWS735mgz+EBW1Uz0Fqp+8LFzGd34yYsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DzjRJVYqvmwYZq2sFETbTt8XImWytexF0Mk6V2ixnSo=;
	b=ebxp9oaIVWPivyghqmNkldcM1YRHq5Kt3ZDpGVRw+04icm2Z19Ci2diGT9Y/59nTtads
	 fCu0hwPlo1pgsfCS9SbF1O5/mTU4N8QFno+ocv5J4UtMC2TGTegsE1j7RFLuZOaz1DhuI
	 XUDKXqNZKB2yROTIfO+bFUXyc9tusGnLhD9h5QGGFF8AXKzOxV9r+JhCyDlPbYQ6MHtsj
	 JoqcQlnmsIWblYsEE3ZW0pkpEywrt1RtDqfp9ihO9/HlZe2TjwDt0W1k2Ri9IEjvpffEL
	 fRwQR/zkvk11JA5Ut4DXT640jyWjHbHXM7DjD3tLdMifUKb2h6keb18KSb4hz+TiqOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxzkuLMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A0606A325;
	Wed, 18 Nov 2026 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxzkuLMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A2A1F000C4;
	Wed, 18 Nov 2026 23:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042924;
	bh=DzjRJVYqvmwYZq2sFETbTt8XImWytexF0Mk6V2ixnSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxzkuLMjH9GTf6NO1lKo5HGe+mAZEDf1vBX6NxRPNgi138/4ueQsaBxhGqiUtmS49
	 JeUNyQl3x3iqtypdbhefMw9epwY3UduXtWeQkU9wicLjnPjHBz6m8VAI3a1t3DYaWX
	 OGc2B/qj+V/92K+otAtNkchL4TIDXCFFxZApDsxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0029/2857] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Wed, 18 Nov 2026 15:17:43 +0100
Message-ID: <20261118150202.400536411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]

fxls8962af_fifo_flush() transfers the sample count the device reports in
BUF_STATUS into an on-stack buffer sized for FXLS8962AF_FIFO_LENGTH (32)
samples, but the count is a 6-bit field (0..63) that is only checked for
zero. A device, or an attacker on the I2C/SPI bus, reporting 33..63
overflows the buffer by up to 186 bytes: a stack out-of-bounds write.

Clamp the count to FXLS8962AF_FIFO_LENGTH before the transfer, mirroring
the clamp already applied in fxls8962af_set_watermark(). Conforming
hardware reports at most that many samples and is unaffected.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/fxls8962af-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index 8bd4eef12ac44..4317894947ceb 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -960,6 +960,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0




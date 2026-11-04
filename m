Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829307;
	b=fvA/w92/EqtQTSl2Y7zo7gm3W2kfdxCF5SoqGUlL4y2c0nLF/ygFjjkIgfUgOqnzsv9/
	 VfHRWn32QS9eM5AagDp0pvZ0hvr3VYKtpqaasr1kDOrYFRXTBKQWZebFd4rPFhg0R3yP4
	 xndGm0HoQeZaSZGbVfyF0ejZynjrtHjn9rN878yo/uHjLA1mCtPV6Yz0nIJSmDNY7ASPJ
	 pDue+WRRyVf3pDyhlkVC6p2frYYHbXncSfrxFJ7O8G16kbWYGdYmOnxgQ0Gvrh1h57Ps7
	 /Lj6aXVssuBvU962s/zDr/WCInOBE8vdYb31s3rbak9TkJqn3kwRWfjGjS5YrRgdBXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RE/RKLdcjGV0Usz16J2Gtu/3q/qySomVUVviDsv5Tx0=;
	b=K7cHAC6Iwm6QmtEcX++TwKQUS/AHGA2zd+2PU3jOGc16ATjkqoxR6Uzyek2ngz7IxnwN
	 7bNqJPrKVFDullEAkhRVnInVHp6yGhqhAfNbQTh/8tpqjs26ewKaoWeebImS5a6j+XT4T
	 ZL5HcBS/g3LwcRsCjrnsZxhxWh0fGHp/Zy1SlDQpEGj+n46OO+viGkG9am4lzzkrABAW3
	 k9jUUnLQzDBOs1OOiJ75Sjh9L62JMEF8KlQrSkuK14urpvz4jqpuKGOOMAj1cnrRiJInB
	 LP9lUlwPyYgxhRgPF1wUlqRW6PF7KXStxlpKF5smWpIHm/+sCC2fggQ7XNSpHFARkgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBQaDFfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA606074918;
	Wed,  4 Nov 2026 21:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBQaDFfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE041F00A02;
	Wed,  4 Nov 2026 21:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829307;
	bh=RE/RKLdcjGV0Usz16J2Gtu/3q/qySomVUVviDsv5Tx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBQaDFfAxuHG5GBFNgl6R/i352ImUUBO5RSM6OY48m78tvFLr0G5Q1zO1m0qncUe8
	 zWEJD3FqmsrZP2M3BIm29SJlHnkBxEfMWxIG/2oI5N6xexxoKQ1BeFIpiO+3Uds8z+
	 exk/GodQcnWDsqOrQSHPkVMoNgiDnNvztztQdO08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0042/1005] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Wed,  4 Nov 2026 15:56:15 -0500
Message-ID: <20261104211044.759471022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8763e91c63d2b..1ecffbf41f64f 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -970,6 +970,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0




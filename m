Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062891;
	b=ibRDL+PEyJX1ghl11tMiFAaBASzWuDURYItQUN35I2m1eAYsQgjp/6Z5xMZzAyHKWFn8
	 Xyk129r5a8wjBexEj5npbYTGwkMfOwKQk2oW+1UMZcvK4xYvWbRJEQR9WWP4S6P5gkgK/
	 JB887gCLNl475EQ4Sy7KoymJdGbRCfSuvL75Z2B2bn4ac2ZPP3OBBq41Qx9grAvqz/R1E
	 rwbGrPdNXi4R6cVu9weHmwXiyuZRwXE1xH9X+czN+FYE18WyENS73jvoLrC7M1pWQwqKX
	 fe1rCJ+lCsF8RyE20DKx7dt2MMNP4PRHqR0HC+488vTi0IeQkU7hoF6L2XpCNoEQxLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Afmx7QwV8Kb+XhG1BodMEjSG5ZfxzyJzDJzsbbBFwaw=;
	b=GWm05MQZBBaaWHLOQeqM4eL6l6cai4Ur6px1XqHkP5Wl4mijfm1J+snmMiK+Q6h6Nqs/
	 L3VmSqVPulfGQkJuQNjWHNjU0IiUETEXvefb6x3LnMXu9O2JRnMcY3qq5n2XYm4qoUqqq
	 CH9lqwf80OxdbW52n7A5Qu5fsDYd0GyaqBcOWcylgPCFPOo4QulK/ZxzQtbb/2a/ZLa03
	 9/iL98uYPMUUMdiCInwyBJmAUmxhUh5Ywi6S7C5+5dWbtr3xyryMVz5SHN8Afdo7UNT91
	 gJO5IWaCsKYg5+L9qO2CXfoaFLTHgbja/+O5i28HJud3V+fXtMDr74O2uHKUf8rNx8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RK+OrKZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427F2606A326;
	Sat,  7 Nov 2026 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RK+OrKZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C861F0089F;
	Sat,  7 Nov 2026 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062891;
	bh=Afmx7QwV8Kb+XhG1BodMEjSG5ZfxzyJzDJzsbbBFwaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RK+OrKZ/9v70mCOjeAiZj/RmNBixylBYzJNV2rEJT8US9XyyQajQeslTFQFovoDKM
	 8u7eOujS52ySufhqnVddLB8iXGN536jCQvcAfrtiETWgG/WUopaX8U1jkbogUJ23RM
	 v3EvLQgQqHopP35OMzlbUCb/1f/W/d8HdOWXzo4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shehryar Ahmad <shehryar.amd@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/869] iio: accel: adis16201: fix channel order for buffer mode
Date: Sat,  7 Nov 2026 08:47:31 -0500
Message-ID: <20261107134857.953069095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Shehryar Ahmad <shehryar.amd@gmail.com>

[ Upstream commit a4b9f1137b76faab6891ce0bd3f5c02dda7c392d ]

Reshuffle adis16201_channels to ascending scan_index order to avoid data
corruption during IIO core demultiplexing since the ADIS driver builds
the buffer in channel array order, while the IIO core demultiplexes it
in scan_index order.

This changes the raw buffer byte layout for existing adis16201 users
reading buffered data directly.

Fixes: 591298e54cea ("Staging: iio: accel: adis16201: Move adis16201 driver out of staging")
Cc: stable@vger.kernel.org
Signed-off-by: Shehryar Ahmad <shehryar.amd@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adis16201.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/adis16201.c b/drivers/iio/accel/adis16201.c
index 5127e58eebc7d..f0cf3783bcd9a 100644
--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -202,19 +202,19 @@ static int adis16201_write_raw(struct iio_dev *indio_dev,
 }
 
 static const struct iio_chan_spec adis16201_channels[] = {
-	ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT_REG, ADIS16201_SCAN_SUPPLY, 0,
-			 12),
-	ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT_REG, ADIS16201_SCAN_TEMP, 0, 12),
 	ADIS_ACCEL_CHAN(X, ADIS16201_XACCL_OUT_REG, ADIS16201_SCAN_ACC_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_ACCEL_CHAN(Y, ADIS16201_YACCL_OUT_REG, ADIS16201_SCAN_ACC_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
-	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(7)
+	ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT_REG, ADIS16201_SCAN_SUPPLY, 0,
+			 12),
+	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
+	ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT_REG, ADIS16201_SCAN_TEMP, 0, 12),
+	IIO_CHAN_SOFT_TIMESTAMP(7),
 };
 
 static const struct iio_info adis16201_info = {
-- 
2.53.0




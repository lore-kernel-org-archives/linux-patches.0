Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052288;
	b=Eeuvuaa7Czk0R0pl9kB1QemNqgRSgwQ3DQ7YIrjXTYBBNcs8wWIg9PeXMaS0WdJmiSGX
	 LycCEY4I/8vn0WM3qzFmOh5b0roWgsRrdB0yWK94ZlhP7kmYhEfwd7N5f7y2lFi21ITBe
	 FHyYMbXz6FZ9vSGHKQ5ZkYFdbgo3Tm+7iRRPbe5x8HaypL0yrfTM2a4srcV3ZYOVpwb3A
	 8TxW+wGVoPhVLpzS8XKng55RMMbF8g2KcrjM1KIVcMs6b9YEKUQwIs1+BvvGetIW/DFvY
	 tHRxxfRbg9lzu6sJu59xngj2LBT7iKJ/ctzzk9JyA/D1yjXgpKUkJy5YjBJ1Copsj1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoXXrlGWX6wyDK3CMfQEdpoYd0lVY/bgn8JJRjGhhsg=;
	b=QktXA7HACI9O0naeEuAIvZ4OG7z2vhdX1CndaY1yF0LMQIyPiWWc4Yjr3UddA6hsL0S7
	 nPu1WNPYD3qz0u0AXx6hI0GCl1dLIij1eKo361mVOh/iKMfCv0T2vJd6GYf4VsRPD6mSa
	 FB4d9dta19WYNtw72NJXygJyJr6u6WQ2a2uGsKZ9OTPoo31Mm2XGE0Up3ZtYAM844eyzB
	 8Gwl+Tf9It3oLNGPcFmCfJoNadjZifWZeWub3FOwraB/AhhTXWnUlmCGP9TTc+XnBGVz+
	 xxVDot/XFM/3uYJINMvXlJVXQaOE5cGmJhME1Z7sLIuZ/HzafkSmgb73HlklH8dpRVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeKAdlLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEB606A320;
	Thu, 19 Nov 2026 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeKAdlLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362971F000C4;
	Thu, 19 Nov 2026 01:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052288;
	bh=xoXXrlGWX6wyDK3CMfQEdpoYd0lVY/bgn8JJRjGhhsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeKAdlLn3WCjwonNdmcSOj3ZHqmppE1Gxjqv+YklCVSLcqQ+tT7e7zEgpnoeSYyqS
	 IKy866ZBjotZs2wZRlJMTn4chYinzJDRXbeZhr/ryQ2+jLe5hKdiqMyKRfqMFlhwWn
	 E+0YExHts4OwyiR6O6q39WH5Sprbem1bXE/e7quQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shehryar Ahmad <shehryar.amd@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0508/2214] iio: accel: adis16201: fix channel order for buffer mode
Date: Wed, 18 Nov 2026 15:36:24 +0100
Message-ID: <20261118150031.451376226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f063226a42f37..a41c861ff8c02 100644
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




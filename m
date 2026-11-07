Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064089;
	b=lyGh4qOGWwbc0fO53wQ0/KZVRziwlP9Hb8l+KywQnXul1uNWApDDBFJyHWyfa6Ol6IjI
	 S904CL9ABRSAUuzHiBaaHj5E7FwFQ1TW1wOUl8tMcQ+g3mAtPu8g7rYf+sx1D28nW1wIs
	 i6Qz31oCmvmiiri67MeO5Ih75J8U/4Tt2rGfpd23sPuQ5ZI9uXqjaEjIGXqIJ7PNrzgPY
	 JgVWDiwVd0Y7sDKd3+XGEc/WZYLkfw1iFvs0kcOU7P8buFpvFeMVYlN6rfLYecPvwcZs2
	 XFb/jd6/X7FZXJgUXBZUge5qQm/2KyQDeDoMn7berF2FXvoRQria2ISoT7vJ8vtYGDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDrZ6iMHoJJKv3fk/mljjbdcq/apkTVaAHHHRfwM1Bc=;
	b=o0eafjA4MRHdlg2C4unaY94DDlYur0P8XDvu82WoQkSHS1aG6pXt7zfv1sp7nWUCHi4E
	 +nyMER3JQ9giF7vZp/gxRvcv2juLLalgyNnsetu/uFrr985gsg9hzrY/fBZa4RmFt1JsY
	 e+nb2ndehjexUb3CEFLlcRDCxGItZZtv7fziQUntoXeKWQJkQjfVQvIdWdBZAgMC4aN7s
	 PXN2rUl9lFi5xWYj7bFqTXwxnPqW8M33S9Mrkip/iM24uTXp3KAF23TSURt1SObfikvYa
	 OiIhjBM++bdNZYBvXn2Fnko3KkxOQ4HTfMHyYYifJZksSqoaEOeUITsx49wxZriKmyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HzXft0Fa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A312606A9FB;
	Sat,  7 Nov 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HzXft0Fa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562881F0089F;
	Sat,  7 Nov 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064088;
	bh=YDrZ6iMHoJJKv3fk/mljjbdcq/apkTVaAHHHRfwM1Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzXft0Fa94kyaJcuOuS1xG+vnpr20C0C6/QsNGUIRg1owtZ6eI+CItmZypUDR56yn
	 ue7St7dNDRrQfTd3XEeX+0Mj08QQd0tFNT+SP+bk4/TQYi1kX46+KnWiFy5l1maFMO
	 j+Of6Wl2Lu/TvhkQU5TzVsxFkSFt6MYExIDvxHUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shehryar Ahmad <shehryar.amd@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0214/1257] iio: accel: adis16201: fix channel order for buffer mode
Date: Sat,  7 Nov 2026 08:41:50 -0500
Message-ID: <20261107134945.451042523@linuxfoundation.org>
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
index ba0f97944c6d5..834714fb94a50 100644
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




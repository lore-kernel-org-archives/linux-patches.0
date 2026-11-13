Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590570;
	b=fM9GZH+X/XBYMHAjfJPDpfIlQYTOD855SBobpQbX7/q0QUlWkw/atG1fdf87sHYF1749
	 dxweeDWvwQTtRqpRpiqRTpg+B8Z+DZWofM6FnTvkb38zU7v0MguQKzYGWX+Xk2heDiBiV
	 6RW2By3RIRwDciTwfwM3ngheN3QT5rRBUnirTnmVLb88T8DUCS+4XTghdbyQGqolnevx3
	 dYBZWr0nCQJU3tLWadgBAmNHa8tmW9D4qEXkhXVZ+XcWArNj2txcnTp78Tis9JA2V7Wyv
	 5fPNK/x4urWCFbWPGRuAAvq/PzM368EWCUFILGOKDI69LdI751laQC6AaWCAiGjt0xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3GeItGdJeb2OlMC7pP9IpO8YMyVDD1wI1h5vIqFDi0=;
	b=0/mrEzOvDlrNsyX+fckt9Brsu2xHocyItVujgKj9Rz0auhmLhnrj83TzFh6wtD5aO/UT
	 K5PvlmKzPZq+KSxidY1lKfIkeTtOv2zvdGRQVe2gl5FQRBaUWgfMRhXoECZ6khJ7lsk7u
	 RQFNNwTDq4qyeYi8A7Ng5z0kASni530Kx4c2gHaI261cxOtgJp/QBjVMfCnrbMG8+Ac8q
	 mBdkvJU034OdEVbEwSG4RWqr6EjukKAP5p9GXcqr/cl3niQ3TUbSkRIGlWjqhPORnytj4
	 wE6iMC6iwGXKBAuJpaWC9zZDSpm8r3GQbawT5H3U7SqH/P9aqtPJm+p78ctbEW2wqZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ju6eSp+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF33606BD1D;
	Fri, 13 Nov 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ju6eSp+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5901F000C6;
	Fri, 13 Nov 2026 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590570;
	bh=d3GeItGdJeb2OlMC7pP9IpO8YMyVDD1wI1h5vIqFDi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju6eSp+Y23lP/M75rPBuRW2HZ3ZvHASzqR72SHoQnsSoFsdDIp6/zS4m7oRy91t6f
	 Y+hHuLsCt4Cdr4T9d6YkLib2oezyWyDlqZ1vBZyV8hIzc8q2LJ/qNqoJxTxgnH8+NP
	 0FjaW7KbWPGWmwlbM8ZBHR6McNr//pxW0L1LawHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 503/686] iio: adc: ad7192: Revert "properly check spi_get_device_match_data()"
Date: Fri, 13 Nov 2026 10:50:36 -0500
Message-ID: <20261113153837.952658079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0309e66abea141f3ec339b064b8f8b8003d2a634 ]

This reverts commit b7f99fa1b64af2f696b13cec581cb4cd7d3982b8.

The added code is currently a dead code. Moreover, the driver is not
designed to have any defaults effectively making driver data a mandatory
information to work with. Taking all together, revert unneeded change.

Discussion at #1 concluded in agreeing a new policy on this for IIO.

Link: https://lore.kernel.org/linux-iio/20260217080514.1288115-1-andriy.shevchenko@linux.intel.com/ #1
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7f7a119a370e ("iio: adc: ad7192: reject devices without match data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 530e1d307860e..8b1664f6b102c 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1402,9 +1402,6 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret == -ENODEV ? avdd_mv : ret / MILLI;
 
 	st->chip_info = spi_get_device_match_data(spi);
-	if (!st->chip_info)
-		return -ENODEV;
-
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = st->chip_info->info;
-- 
2.53.0




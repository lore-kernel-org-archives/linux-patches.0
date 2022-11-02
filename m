Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865CE633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935C3C433C1;
	Wed,  2 Nov 2022 03:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360367;
	bh=Xiq+yoqtCH5OIrveJXVFAWKVLq1SB3aPFD5eXn2j2yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00a5JPuA9ApJ59JzWyc2h8QIez3nfOvYUqAUw6ViMR/FHkX72D/1ltz3ZfUVPi2xA
	 5kwSmAlylnoqe5bwhphbcHGsy/Ifpx/RXlA/Phl0Xwa/6gCWyme7Q32uQFFm7aHXso
	 jUkl54YxL1NmECwmPSaU/OsSKUjrv1e21czIEo1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreeya Patel <shreeya.patel@collabora.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 25/60] iio: light: tsl2583: Fix module unloading
Date: Wed,  2 Nov 2022 03:34:46 +0100
Message-Id: <20221102022051.910071313@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shreeya Patel <shreeya.patel@collabora.com>

commit 0dec4d2f2636b9e54d9d29f17afc7687c5407f78 upstream.

tsl2583 probe() uses devm_iio_device_register() and calling
iio_device_unregister() causes the unregister to occur twice. s
Switch to iio_device_register() instead of devm_iio_device_register()
in probe to avoid the device managed cleanup.

Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Link: https://lore.kernel.org/r/20220826122352.288438-1-shreeya.patel@collabora.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -867,7 +867,7 @@ static int tsl2583_probe(struct i2c_clie
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);



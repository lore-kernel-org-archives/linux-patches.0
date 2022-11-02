Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC11629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F63C433C1;
	Wed,  2 Nov 2022 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359802;
	bh=vlF/1e49mw8FB3TrsE3Bo5T4w7hBLeJygDFJeFTOmOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETaOUa26DYJuX7YC+fKVKSa63DJIfE3PqtvzfZeV8LQhMybqpqnpB4l8sMHcOQ/3o
	 JExJwYay4B+X2tQQKltfglvDT1N2YUej4wKJ1nugZ76rt5+uSwb6N83aJogmEa8gly
	 q+MgY/YwTHldtOtvlHiP8meqiVoc1ln6dCtsPG8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreeya Patel <shreeya.patel@collabora.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 36/78] iio: light: tsl2583: Fix module unloading
Date: Wed,  2 Nov 2022 03:34:21 +0100
Message-Id: <20221102022054.051555498@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
@@ -866,7 +866,7 @@ static int tsl2583_probe(struct i2c_clie
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);



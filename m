Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031652;
	b=mOAB6mQr7HuPBJejdePk+zTRu+4IiHuoOGvYptNE8uKQkKebmnFuR10sGRfXF/sZYhVd
	 VGqC3xlX+OdMTunhXeyxcRnN6a8NoCj7GDRr6Qg+RSEB66KQdjhacaCqfPukv/yp5K3PZ
	 fH0UPnVsxlmPpugyvVvELk79lgQh1NLE1CGqSiVTiUkRItowQeviwPUBTPvtRN0MonXvk
	 u3RgnUGiDZmAgoCa+7acS372ODtuMeJinfKtCzwio2vdUGdvQSKWCOLcG2uHaiygK6RO8
	 U5l2f/rDFFSwdIPrZKUBmsVxETA5jbS9WI7HIe8gc3pSbNS6v9W4bfKC/SFuPafIa9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGq/iDbfvmGG/D6fXDLUSAQX8t6Lb3bJzfHHUDGkaPI=;
	b=LV3a0xdyVxAhlnOOmxw/jd6dGbs3gHcIdzR88iqvJfbXjV8alhSVGeAzyeIpOrU4Qqun
	 ijTB0kC2c80IafwM/WPMnowo/ERL8jHmSA9nFQpVMX1GUJSZyM2HqBDCA+JhmGDZJPiHn
	 Tta8Ro+MmqjLumoqnOO3KUa7QBWf0sC9JwLGUD05WJnUjq2NHJ0Mn+EzQXEc5AKypJNi4
	 Au10vD4fXEwY1wfpvSRguMXvYGN03u/g2c8bHh6MHuIKy43oeAdzLOOYPWCsyd94ziTre
	 M4RBgk9ax4UfQ4NwKeRlFEjymSeOFcl4k333caWu1/Ob2ufqQHGOpib+2ZCvUZDi/8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XItYnaON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CBF606A320;
	Wed, 18 Nov 2026 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XItYnaON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61FC1F000C4;
	Wed, 18 Nov 2026 19:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031652;
	bh=QGq/iDbfvmGG/D6fXDLUSAQX8t6Lb3bJzfHHUDGkaPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XItYnaONiHrI6WKpmbKU5LPq/JLRb//X0bVumKZXe+IDcUuUnCWIf4pOu4ZFEbd0K
	 VNQ1R/fGy5ApsUQOf3p3vQ450H4uKasWf1r57oCWM/nj5gqyiTdbeBouZwt8HqV1VL
	 MwLUhbr4h91vYxuOKK29QYMPwofnOl4CfssU6VpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1132/1756] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:54:19 +0100
Message-ID: <20261118150055.138753325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit fe26c195c265c033e474d015061a0183c7a02193 ]

cdev_add() can fail. The driver currently ignores the return value and
reports probe success even when the cdev was not registered, leaving a
chrdev region allocated with no working file operations.

Check the return value, emit an error, and unwind the chrdev region and
platform device on failure.

Fixes: 635adb6cd25c ("[PATCH] scx200_gpio: use 1 cdev for N minors, not N for N")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260803015450.2050900-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/scx200_gpio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 700e6affea6f7..3ec17832e9c9d 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -107,10 +107,16 @@ static int __init scx200_gpio_init(void)
 	}
 
 	cdev_init(&scx200_gpio_cdev, &scx200_gpio_fileops);
-	cdev_add(&scx200_gpio_cdev, devid, MAX_PINS);
+	rc = cdev_add(&scx200_gpio_cdev, devid, MAX_PINS);
+	if (rc) {
+		dev_err(&pdev->dev, "cdev_add err: %d\n", rc);
+		goto undo_chrdev_region;
+	}
 
 	return 0; /* succeed */
 
+undo_chrdev_region:
+	unregister_chrdev_region(devid, MAX_PINS);
 undo_platform_device_add:
 	platform_device_del(pdev);
 undo_malloc:
-- 
2.53.0




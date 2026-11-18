Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056130;
	b=h+xl8IvknjLfIZWX0mHMvBgGxiVM6qlrHV0boqKs2hghFp9P+mi3B8qC9ZgCgyZCpJGy
	 BzCij7VDr+vEuv0WasVb2vA0LDRFpAUHP7JX4gqo6AtfsXeqnk+fhGeyhGsoc3j3rI4Au
	 TbkK9KhaJNMzbhgAAVNU87+eYOSYBBQ7WSFPxfjGO7cyhN2uDY/7zw9usnsj03u+bkJru
	 7f9EqvWnZtJwY7hrcT9HNr6nReb9IaiMIYC/psc7TViCPRxJKeAmeBvvMnpRmLV7/tQgb
	 mDcfwQuzsisXqiRA/t+2ocSrXJwcg/oNqDczB3oJmwpEoc2g4IrTzZs+pfsltIUNofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHlnK12/aVapmtnGHUN0LYH4PzbbY/PHshXgpZY2gX8=;
	b=XbtnlE89oOIjJAHBoKcsp8iSBQDtn2X8SSyZMrbYbe6LtRwORccMuDLDKZxOCU8NRRbU
	 A6tf1+J7WKSECDfS7tD0p8g3NOnriVJMkupVMigVgWTQvqwVnr7wU1i+rt1guMoWemw/f
	 CV0v39wgO/7C8fis9D19Tm74Yks6WEjwf0FUf57jkJ/GfO8ULWOGOJz4//8l5psWtFqot
	 Y1Vr1HEt/ebp+OIu/inNyUXBVhuBDiLgOwBYTMTv02GQqKDmus6aRAIlXYZxFkHz66WbA
	 E7DtAyC4faN4OjVHUg1qmdWMKhn5QLXZCUDN1JE0hmHoY+S3jawe7T1svit99wdDMlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BVl8Vp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BE7606A320;
	Thu, 19 Nov 2026 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BVl8Vp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759331F000C4;
	Thu, 19 Nov 2026 02:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056130;
	bh=uHlnK12/aVapmtnGHUN0LYH4PzbbY/PHshXgpZY2gX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BVl8Vp6gt/i0gEZRP64AG+YTEPhyqSUYHI2Ri9xdQfgT+3OX9TRTId/Q3bjmmBtF
	 skbbKt17ITQFeLwjaEr9f7lZnX6JNuzF83ZGrq9cGNZRhVDFMFe3X/KtQ+D6IABSH8
	 DuYGS862909U0XMRBmcV3Uh1LIPR1PO/fVszyJ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1878/2214] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:59:14 +0100
Message-ID: <20261118150126.391378752@linuxfoundation.org>
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
index 9f701dcba95c7..4f6b1039417d6 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -108,10 +108,16 @@ static int __init scx200_gpio_init(void)
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




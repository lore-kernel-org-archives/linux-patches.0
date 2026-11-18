Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019834;
	b=am+v5v03h5aWotwqNJAD1kTHhD+hzAeKvwps4RG1+17LreYOQiq3YGOhQId6e4iFS+TE
	 LCz9LDepD8kdwr/dEB7NPsCBJJ1IKAe6DctSpicPPySFUCMPoH9qpPkXQlhXNHr72VizO
	 H52/fm5vFHeZ1066TvSdnswihPpb8BYlrzY8rzu6t1aZU5xlmGQTfI7lWTXCkhy281Dn4
	 0RbYpl9qD/bpoDzdK+QVYbyVdgvbxprQRQ8vu39NwONvy+kONz42Cy+7yxf7Hvt6hgGQC
	 okKikA7ng7kSzifuoGXIxXaoub89oxZL1wBc1ynQUEZ1Tf+58+96D+bS7CjJ/PTrNig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QWurdKROi/9VuMFlSCsGd3TjnTNZ3ZxZ0QZJ2x0umug=;
	b=gKnOFQ5ilThHgeyO0QkmIp/u31NOoLSWRTcQFyU6QXlCLhMAwhL71qFoUMVQDyY4EJ+W
	 ovvx6p6O5FtFKc4cFT7U0ZNut6FlpU638wkxlRiZCtMbKJN/Yz2nzygXxrWa6HSuq0yJf
	 bi7pMHmeRWkUnpni1Euu1OsJo7eUGpbEqYIrxCCI5pHhFD5p2mVHjb1Eytm/Uew29SxbA
	 cX1Jsh7EAA4NRf1TaEsP8pRuIIMFhOy8v2uurY7Dlf//RP5vm/pS2N3ItzNpcz6Mh7pQf
	 31LvY4+Pj0TZTT8Od6QZrU1qWhlyTfVekAFxnNuBVLQZfNS/TTsqJHmMDTVVlZoxYfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iL2wXahO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E760A2616;
	Wed, 18 Nov 2026 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iL2wXahO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB51F000C6;
	Wed, 18 Nov 2026 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019834;
	bh=QWurdKROi/9VuMFlSCsGd3TjnTNZ3ZxZ0QZJ2x0umug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iL2wXahOBD7QRihnuSWvTJn7w0MP0I5rZ25a54HImjyYktVq2HtLJED+x5pPUUweq
	 cvhCpAf8Etl4VD8ovYIfoBzKW2d0oLxqB3ATWsfGd/RUb1sg66+dHIY/COBh/iUHBo
	 +NkIeJmLQAbwTb6b9kNtAEVO8Mwxus3T3ee7ONIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1736/2651] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:49:36 +0100
Message-ID: <20261118150350.089087206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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




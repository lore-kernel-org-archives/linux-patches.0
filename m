Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041405;
	b=Ie2bSu1kEBeQK8sWYRyfbPPay6FfU+K/gj4fBdipFw07pmj/Gf1gvxfQ+bVIFkVqX13i
	 dD7jDYOdX5XkFW1YfvZgGYvEUBks3/FY77iu5ww2q+imqCvf9C04fxcKVq1ygHVER8fyh
	 lwqlk0eQz9ByOWClGAJRsTcNnqmO/g7RNs1K7geEEPBrGxj2izKLfLyv58B7g3gstnaeQ
	 lAnEpjewJ6cD/ka6NFPuKMgW2wZ8rVR1m5jdlD9A4IgiLdwq3nXDsa/qKh8jqiE4ERHss
	 zp/ooi5dum7Kp8n+TApxzSX6mQo52uV6GjKltl0kVOKKbSDzjgyG8LfmIZmoCIeqWPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D/JogC1oDX4xJNc2sR+HGW2Bfyvh6OOt0Fykjm1ukw0=;
	b=da8wNv+THs6FMee7rEwV3qAeQ+RNLVuYHYi5KZNtrgFYsNt21JwfgFlHeqCJ3UAVSL3+
	 8mkUkRk/4EiigLbAkeB3t+giq+1B5vEg3rEAhQHTRr4U/lWdIPXjV2YGq7pkl8j458KKk
	 DqY8XmDd6TS6dg6XojXE4vn0XiaSFY2kqtXH3/oD+vvbRw7GElJ3uaxtCqDubjY3NKap5
	 YCGEYj4gH0vEIoQ9T6qFV4Ev8pE/oN5joUrg/wgSxWoWzUt270PFFB8fPhwpGxn5AAMmK
	 ktyY936/1L87DYy09tS9ooMQ5cWUk0dpfkHc9+QtbX+fSP+1vEtBZ41xVJCeIMA1ubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+wBQrC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A089F606A325;
	Wed, 18 Nov 2026 22:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+wBQrC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2C41F000C4;
	Wed, 18 Nov 2026 22:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041405;
	bh=D/JogC1oDX4xJNc2sR+HGW2Bfyvh6OOt0Fykjm1ukw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+wBQrC3e+WUCJj7w1d/oJGulrQc2eq3PaN9oiSKibLs5k27yK7kYdPRgLAADTand
	 rp95Ej29750YZAqamMqdZBsEZssEXJI1y7ZWpXvn2ouP8IdYo7Jq2PSBHvrvA8GfJc
	 f8MxK6T+3hRfdtv3ivniE/aotDkBScKyF+sFIzbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2800/3318] char: scx200_gpio: check cdev_add() return value
Date: Wed, 18 Nov 2026 15:57:02 +0100
Message-ID: <20261118150444.677569731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




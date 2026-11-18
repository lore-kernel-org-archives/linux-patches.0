Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059160;
	b=W8+albcfITqhrvqK++IhYpqNs1H4gu9iJg88jYx68RM2owSI1NUa6ZRfwaDMJ2j/7a3J
	 PrYCHaw1onXu2XBzWf8dr5aptYfj/K5sJ5aA3Oj7tEHfY7JevE5x5XkaUR2dnFad6U6iS
	 sDqMjRuoK3wS2JP9F2Dpl4d/KeKgFecNLTgwvYVWGvZ93jQztxihP0d34CvCAf75WWSD3
	 TFWaOwgVNHDf7r/wMF0BlRb4ywNPmF9adY1BUiJl/iUS92AVr5cdzvKmTxAzqEvCJwRAA
	 2oCIXhgbEun+oDWLtT6V1bhhEcPWJs6FeKXP8oEfp9up+YWTt5IKvu2YZotJUEmfLmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eYjAmCBwqvbQDfh0ktVCAB02Mh3jlmWR52U1xoYl1jg=;
	b=n4rqFkHZOqdThoYO4OLUB1aiJdoI4/WPoY4TSffetqkMoe571nwGxUpTrtkBaK4km8AX
	 WaLSAvwH/PEeO96zgS+ALkr4lZ8T9K5ZblJf6rjLkmz+Ek6HyysIp4jczh9t23lN7K8Cw
	 Oa0E9gGOg6pqeYqNKXlJFSF8QvcNVd6/J9Xo0Xh1wZZZlrgqfwqBSfSws5wG0FIbZTAI6
	 ON+8nV9dDp0WALIrYWipTPzfwiEdhqnD4/wetF+q40ef17vDI4UvDcyr4TVebL8l8nJsy
	 nPRA1Fi6QBwvALaGu/phpErzvFenO1kBn6yBI9bZbtwyJz7Osb0ImjTBOjPwB+mcmDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tl+VxWmj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0F8606A31C;
	Thu, 19 Nov 2026 03:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tl+VxWmj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0DD1F000C4;
	Thu, 19 Nov 2026 03:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059159;
	bh=eYjAmCBwqvbQDfh0ktVCAB02Mh3jlmWR52U1xoYl1jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tl+VxWmjbarQFS7wQ7USvxb+MFlurQbLsk9dVhrEnnkFvqdPZ646I2o5zNntAjnN3
	 l71HZP8rZbN0XCHdVfDkMmEpTlFgHUtuvnAUI4KYQDbnghKaV0zedr4+Bh4zstCbjj
	 tBK7Tn3JUdgHEpcPXkhqksZ3ztMgNwJrrPgW5afw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0742/1848] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118145947.405778453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit d21746bafdb8e1a5fc9bdcb86f603d827a500a62 ]

The three controllers that use the EP4 input URB allocate it before
checking the endpoint type and before registering the input device. On
failure they jump to exit_free_idev, which clears cdev->input_dev but
leaves cdev->ep4_in_urb set. The card teardown then calls
snd_usb_caiaq_input_free(), which returns early because input_dev is
NULL, so the URB is never freed.

Release the URB before dropping the input device on the error path.

Fixes: 6da7a2aa899f ("ALSA: usb/caiaq: Add support for Traktor Kontrol X1")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261104025341.1527407-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index c12eeb9710002..6a5adb8d1e6a7 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -830,6 +830,8 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 	return 0;
 
 exit_free_idev:
+	usb_free_urb(cdev->ep4_in_urb);
+	cdev->ep4_in_urb = NULL;
 	input_free_device(input);
 	cdev->input_dev = NULL;
 	return ret;
-- 
2.53.0




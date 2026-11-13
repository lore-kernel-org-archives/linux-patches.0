Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590483;
	b=BxwxZl9MnZWeCEQ6qmI03+XO1eXXuVKldPl2TZxWv1CZmKoXmKYYcEWlmrQcNGeJ0XGk
	 DQEeY+xVH3HRPOAlCzzwfbW3SZ/wtV3exo4SyE9aYE3RBiJO2utK00udUBjpH9xg+qV04
	 FMXQzHRDlOiWtbndIg5UzgzhRUU3HQ2hbH/10CuPoXTUGTOENOTzm7H4dzV0y7wVgrCVR
	 VShzGgqs+0pPXxGx4xA84f2ikoZ71USeIxxcuxcssaD6yEocwkVfzDe3bHiwQBAU89RaZ
	 XPWfeUKubeV+0Yow9Qal5FUSAnMC+c5r6xbKIAc49R+dmB+IEd6VrYD9iUb5ikRCkwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CD4NcZtv9Is8vgDSxdCxZeuzUUNJqWRPg+yTiulG65o=;
	b=rdvozksIcoc5La+FUJS6nJIhmcAlaQI9c/kRmP0+s1x1YpWNmUDklrR5kdbWynk6zBPw
	 mcRy2NhXIUIqnlVf4q1qP10SVn0QdyOLSbrxnIDCVnUyRDno4I7OJxdJFA2XLBEivSL51
	 xIgXiaElww97KLL2+EsOT0Ft7WOSU+DEJ5ezv/HIxb6yuHq30CuDDz4AeqggztXbn3P13
	 EPj6+UVO+EgHd/X3BKaYZgmrjgDq4oVpPnDvhiDLKu3cIF2JCbvxUEv6FCb2+hB3SwA0l
	 XR81PCCn1N+464/XzG8ZwwTcAHpYA/S1g2s7SPOpmRqzhqW8Q1B4at5efwia3Moxymw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8Zb6efz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E8606B819;
	Fri, 13 Nov 2026 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8Zb6efz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC841F000C6;
	Fri, 13 Nov 2026 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590482;
	bh=CD4NcZtv9Is8vgDSxdCxZeuzUUNJqWRPg+yTiulG65o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8Zb6efz3HTsMPu/fYEvvdjOAarnsXGi5gujtoklXO0WJ3ZAmccn2XfiEbmPUdzve
	 fZNIZjaF7J9DMb8qzWfRL5OwWI4Vx1ZL7ZZrEl71AFHqWPPcOaMnXEq1XWg70ovGuN
	 ax1zX9wZETcwhLmhGNKq8z9Q+/+LyOYDaBqwlvlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/686] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Fri, 13 Nov 2026 10:49:27 -0500
Message-ID: <20261113153835.618950326@linuxfoundation.org>
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




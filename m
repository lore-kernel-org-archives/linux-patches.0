Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210794;
	b=2Kvh3m4WK+CTFN+ysmZgbaJEoJ2DdbZAj6NKjt3YTKbE2y4C9xbs6fz0P8wAEISE3+23
	 wtOirFWfNILMxlkZ+5nPvVo3awcoPNEHS2McfguF2Zv0KH8EsCZHkW+0x7gDJhD3LlUNA
	 phnvvFoRT6Crh15umc2NzvtPbAvqZ2+AIHuovPryHQqy18X39sjdX+6rX+eOZEl8PkM6m
	 8KaqicooK02oSTFZivK2EO53FgYtU7A/pzK9vfcWscLWzHOcVqipqUWiAn2IXGVe3WWZv
	 QoVAJbM17y7EGHkCFwhXtAbgjtiOKmOOlmFYaa5f4DYM7OQppd9OOyUdJ0EdbM0HHJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXdPv+03LpphR1TM11YDC0I3w/yXNuIxim6J/4s7qIY=;
	b=jfDQ2/6WayMUTPWPfOe7SCLGcZ9vWzstcD2gO34JzIIJ9Cz1dP2cKbDEEIhga/yrQUot
	 Vr1nneuhJbgD0dbujsjk/PIp3iEUlgwzr6z7bwuTW0pSMhXotYdvuj+A5iRY7RN8WZ++B
	 YIyol5fgJFmWU5YBAEs6Aa83Z57hBFQ4vzFcxvukOcwQNf1+p3UkiVGYOVgBENnaEqQ+6
	 j76gkWPBz9VpuFLKt2OzJifiv+xQlq8FFuazuiY0UWYIb/XdozBV/KYYAfiB7vzeOfc9a
	 RpoLbXejSCvU8USHklrFylL45AfG/FC2wPioCJ4zpnLN1UR4whpJwQ4KJbvzytKXYGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpEerohK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83115606A31E;
	Wed, 28 Oct 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpEerohK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36A51F01828;
	Wed, 28 Oct 2026 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210794;
	bh=LXdPv+03LpphR1TM11YDC0I3w/yXNuIxim6J/4s7qIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpEerohKtEKTha7GcOdaj0ZJQS6DpNzjQf9CFYKm4ACiD1/yAuQhS60HKCRApeOQK
	 S9BRgfB6GSualNKHAjZ62pC0iVW/bmKr8P2a/Kr9inqEv0u2vyMeCKvWwyfB3bWxRL
	 bCvHGrI6xmV8W9GwYqezvZtPmTqRy4CfEM3KXWNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 151/571] ALSA: caiaq: unregister the input device when probe fails
Date: Wed, 28 Oct 2026 17:54:58 +0100
Message-ID: <20261028170011.598750796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit 0b7bd20f6379bc5e431fd74d866390f5b5b63f3c upstream.

setup_card() registers the input device, whose name and phys point into
struct snd_usb_caiaqdev, and then goes on to snd_card_register() and
snd_usb_caiaq_control_init(). If either fails, snd_probe() calls
snd_card_free(), which frees the device state but leaves the input
device registered: card_free() only clears the pointer, and the input
device is unregistered from snd_disconnect() alone. Reading its "uevent"
attribute afterwards dereferences freed memory:

  BUG: KASAN: slab-use-after-free in string+0x4a9/0x4f0
  Read of size 1 at addr ffff8880208f5043 by task caiaq/4967
   add_uevent_var+0x183/0x3a0
   input_dev_uevent+0x162/0x900
   dev_uevent+0x2f1/0x870
   uevent_show+0x1ca/0x3a0
   ...

Unregister the input device on the probe error path, as
snd_disconnect() does. snd_usb_caiaq_input_disconnect() is a no-op when
no input device was registered.

Reproduced with a raw-gadget Audio Kontrol 1 and a temporary hack that
makes snd_usb_caiaq_control_init() fail.

Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2a123f6269da57ffefaa
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260925170717.22462-1-ngocthang2710.1999@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -562,6 +562,9 @@ static int snd_probe(struct usb_interfac
 	ret = init_card(caiaqdev(card));
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "unable to init card! (ret=%d)\n", ret);
+#ifdef CONFIG_SND_USB_CAIAQ_INPUT
+		snd_usb_caiaq_input_disconnect(caiaqdev(card));
+#endif
 		snd_card_free(card);
 		return ret;
 	}



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212726;
	b=QB66d9xSjwMeX5RaSWmc0LS1Hn/SJG0snTch5+hSoMqhjAjvYr300eu5/8ieSpABplES
	 U6POTL6NzvN2Qv5AmvPkMywdOwnaIJfYP0Yw4JKcOxzdxpWztnuUV5saTPJWuprhca/UF
	 DELVsFRDB9mle1SVhI4hEyQBZ9eFwfHsXZN749yhFiQWFWhqDvzyZy0zgSJVOeBc7vDgC
	 JscA5Ar5IWuHwwacvMeSjukKF/x4733Wf9ztcexbiGIWJq8RLV7CPKYEUHrp4MCmh/tpf
	 EeoSvbvSy0ARoOkzjcaB1qpfbsyTUMhtg3+F5Uh1JLUZ6ezwm4UFYXI3cFkMCgXt4yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uzo4UDgTtu0m4UVe4hT4QZ6bRrX1hnNpT5dQAEgRWlI=;
	b=VITbxsIo6iL93V+yMZdVJIGcpZ6OKwtcZL0I63NzTA5B0x73BkR9gPcmnQbTjh8iXFMs
	 1vSmmVOQJVLUt5RQ0N0be5f91mE4auwoR/h8dI4HAtC6zSiR7EUgG661Zp2dl1XWh7hTd
	 lgQAVO0zE6aDX4gPJJWKZIi1ybhdD1cmE7KGP+uqFYOQ/XJ5qZYBaRRiqOSsVYzheWVsL
	 pijNwznleGnhtbslWCoyKrA8omtaaxGsuffxnFO9/oIvn6sL3/5PtFQsq/uyccrTzFx9z
	 afzB3J+wtr6uThQpcATiYJI+8QasEmg9zGbJhDiNvnKXJE/ZOltePwiQJmU9IpUKfDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjXjAtKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751C3606A321;
	Wed, 28 Oct 2026 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjXjAtKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C8A1F01825;
	Wed, 28 Oct 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212726;
	bh=Uzo4UDgTtu0m4UVe4hT4QZ6bRrX1hnNpT5dQAEgRWlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjXjAtKTDFymkog7nQWNZ0xeiYRdEyczv2O/1sWqnAdADHgx8Zklyt2UkVAipUzjV
	 MdpulxwS2CiHkqzduFeSmCmzTvcO0A7VZdqDub/MZF5wf5IjmTD88RhdPxck4UBuaM
	 pfiCZz33EhB3GeqX/1LmRu07cwW5jiI1bP4bL2XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0201/1887] ALSA: caiaq: unregister the input device when probe fails
Date: Wed, 28 Oct 2026 17:38:17 +0100
Message-ID: <20261028170503.810307568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



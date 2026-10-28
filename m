Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208528;
	b=L5N5u5AcyDX+RujVOXsyJVVA1edHWBRL1Evf+M7StEx2u/TZX38vr2Y9QyFYnwSJv4vv
	 J8Go8xZz5Eb1LSUJ5vW7NJcbKqU6HpMUPw4Is5UCwtqCrGGiB+dTAyRJjxIFC9QyW7Oez
	 7F5bjF9Aon7g7Qx/Nvd+BkQcZiiysfWfN2UJqEa94TOlw3w2cMmtte9+ef05sG7DookgR
	 V0j7AqIPoiUbVfx3J7hohsoLkuHbQlonJBn+4jceZeG6A+Z8W+Wt92LT9nkJ+A+j8QvUc
	 92z1jdNlWs1Tr7BWV98PYqv1c+NrjtK8BpfT4XSWMBWE/bvx3Y1lwqPxhbuyuq3FDcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4+71FMSNEQNeGTl18CzBpC3Enezqeh5Cn90Vg+RjzQ=;
	b=M1n5kp6/70mlupxqhTTnkOb7VjLP49UdKQOQ6XQSCiAGhHO5BFTML83xZmGZGNC7eu9n
	 K8qngPjPOrz5Fn/N2e8jduyZC9fuHfh0oZTtSaV44uZ4VbLH/1ohhSgSyhqP4CX63oc8B
	 0vZX31mOuDbXlA2M4Z3PF/Enjfm80MY02p01a0EuvoPM1+bk7bd2EVsbN5Eii+LDiKRE7
	 lPpe22XlkY3i+TR/n85QjhxGiYCXGyFTLOCXq0MDPQnqqIMJSBf6r9b2jdXvKH1HTySB0
	 H7IcaU5DSoo8Y4wbhSnSx3J3JP2CZEKAtmTRdhM2QLso3naj7OCUE/L3d/xOYtAQ7Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNiwAnjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08597606A31A;
	Wed, 28 Oct 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNiwAnjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7451F01825;
	Wed, 28 Oct 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208527;
	bh=D4+71FMSNEQNeGTl18CzBpC3Enezqeh5Cn90Vg+RjzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNiwAnjLREsGWb41ekFIY2EMfsAI0ah9Dhr9zEROCMLq52aKlyWw5EEVQ7L9GY61z
	 MT+LzdALFfIYQZm0wPJQGjQoJvhves5/d0Q4TbdyFLyhSjG8aCBFR9ht8t59FHxn4i
	 vRjwUSFHBewVaWv0XQqe8wfji8qQsLHkAGOihuHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 152/516] ALSA: caiaq: unregister the input device when probe fails
Date: Wed, 28 Oct 2026 17:55:04 +0100
Message-ID: <20261028170007.108839922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -576,6 +576,9 @@ static int snd_probe(struct usb_interfac
 	ret = init_card(caiaqdev(card));
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "unable to init card! (ret=%d)\n", ret);
+#ifdef CONFIG_SND_USB_CAIAQ_INPUT
+		snd_usb_caiaq_input_disconnect(caiaqdev(card));
+#endif
 		snd_card_free(card);
 		return ret;
 	}



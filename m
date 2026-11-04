Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829184;
	b=zGTTgMrsAD0k9nZS6IMev5Ct6dtLdM2LKV0unD4WB/CF0gI1xObgSZkXqrFiM8nfbJeQ
	 KRACwZDlnT4KCzrJTck6MaIWuBO45WVTNYN21hS+AqVdy796bouOQzrVtbQ8PaOPcdmDp
	 jb580ESRzh9WFbrYmkbWw7N4jjERuy5A8fcEO19IhPq3pIcW5ES1q2V7/n/+uNLb4VjQD
	 8Cn9R7HDvnvlDqlDI0k2RFFWpDRzjXwiB/LnhrdCz0ZWtUjafjSOoEvDBp5VP79hCwMqa
	 LwQ40lsrm49grNsEeayJ4QeJKaX3LA2f8B4XjjVKul5nmL5pXMD6Tp8JLqgD3Ctsmlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6ZiJQSYRmeZ/sqS1Rd92ux5Er1MjUmiWi54afVzqSM=;
	b=XBY6I6IdwkmEp83QYnecdX2oFmbB+EO4n6JMUYGwnZJuACdWDedIvCK6L1LNm86bQYWJ
	 Iijt+I/zUWbwAe1A4f92wRDYditrUic00uUWUxGoUh1fE00t4imoPeaH/X/NjKernhVVl
	 wDDAorkiyCxgWm0Iy5bnUeJj3XIIolhveioY6EtGyvzKm5kFe+vlfZNsYXPJAFd0je57u
	 hC7xg1JQoXomIXbHr3BmWWX+FaDvX7i6Mr/WMUhqprAIzl28KdtqCg9UOOsO6b/k+vOjL
	 uGPiZR6cpsbhcs9W60jSugwt1nm7ULUChx/tL8o5rasccf0I1EypEv/2Rn63+LP5IbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1NKTYRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BBC606D806;
	Wed,  4 Nov 2026 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1NKTYRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC7C1F0093A;
	Wed,  4 Nov 2026 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829183;
	bh=J6ZiJQSYRmeZ/sqS1Rd92ux5Er1MjUmiWi54afVzqSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1NKTYRxztC3BXfyrvbTW+CQG1jyLVVv4xQKMFyVYi7D3+1QJ6KbAMgTBHPxeLnZe
	 7FSo98OIxGXl6L4fpXEjjY4pUqkqjm8J3PMUBV79r5PGuoahgab6s8fvdlmn5+sgVV
	 dXDD9UG5eKlYGsDA/nzl5zKtGN4tzmxrahOJmqIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Tanz <gabor.tanz@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 499/547] HID: quirks: Always poll the Anne Pro 2 with product ID a292
Date: Wed,  4 Nov 2026 16:11:23 -0500
Message-ID: <20261104211052.562209997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Gabor Tanz <gabor.tanz@gmail.com>

commit cbc13a78a89d087252947d0a51048e576cfcb3ef upstream.

The wired Anne Pro 2 identifying as 04d9:a292 stops delivering keyboard
input after a period of inactivity. Unplugging and reconnecting the
keyboard restores input.

Keeping ObinsKit running prevents the problem. A read-only userspace
reader that keeps USB HID interface 1 open also prevents it, as does
usbhid.quirks=0x04d9:0xa292:0x00000400 without either application running.

Commit ca28aff0e1dc ("HID: quirks: Always poll Obins Anne Pro 2
keyboard") added HID_QUIRK_ALWAYS_POLL for product ID a293.
The variant identifying as 04d9:a292 exhibits the same symptom.
Apply the quirk to this product ID as well.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gabor Tanz <gabor.tanz@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -747,6 +747,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292	0xa292
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293	0xa293
 
 #define USB_VENDOR_ID_IMATION		0x0718
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -102,6 +102,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_ELITE_PRESENTER_MOUSE_464A), HID_QUIRK_MULTI_INPUT },



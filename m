Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061790;
	b=l4IBsLf6U+sjUkt0GJ1vFRq+omK1+F614s1z4DuqbRotWyBhX6d6v+BlgO5D3bylr54h
	 BCQ8sqpmEdeMwowrq1OiMgS7ECccPJbl8nII6QYc4LaX8uXndx+ZZsFuWd7bgt2Pd21n8
	 QEGXxfMB6rSGjuLfTp1aNSMgP1Lr7UHP29zB+VmiEzbqy0S/jnh6JbGm25MoNKd5Og2Hj
	 vQugJ5kZCWC5wUDM8jM5MCzGwhkbCN+2weR9OXFKZpLVwG1Td96RfeX4JBBmx8PufuliP
	 yBxDDJBfXvFOn0i/ZcRLjPGTaBD1pL/fSRX2MXldHttM1wpphQbIfq/mr2Y/jXqHdlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KXvDsAwqB8JoMWctBvHvY1J9nwRdtJDvUE81cY+gLQw=;
	b=fHFaBmJgt8K9fJEyNbQUBMS3hb0xmDu1X2nG8OvOOz6wdJHni9oik4P16d7o0Sq4ADQK
	 aHnT4WNVSxUiBFubxFRnuTFuwwxQSC2LSW6rLz6DZaNfcNOfTbNvJUH7dfezXkySTah0X
	 AY6A/djyxywXyUBmmXzPFVZ/k249nNF1eU4JebQkDj05YAld2+jv/ZT2okfDwXpeV4Eib
	 oGk0RHspQi3GdkA2KYZBGRP5RmhNueZ6WO2zxljT2YvIC1iM317XB9FxiIZRIHP+jVyO/
	 yFpRmjUNRkN24nBUeZeyNC2Tx21TGbk4oigT8MetskB92iWscfBIpGqjfOxrweZtMog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7HWGkDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461BF606A32E;
	Sat,  7 Nov 2026 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7HWGkDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E980D1F008A1;
	Sat,  7 Nov 2026 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061790;
	bh=KXvDsAwqB8JoMWctBvHvY1J9nwRdtJDvUE81cY+gLQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7HWGkDE0LhObjZgDJzNz0UeyyaxXgP6TrUcMApUUOVFRSENkzHovXr0QNSgrxn2C
	 39siXNiXzHeAHYDlVkpgLEWtmknBCCs2QuP89Xcotxde9YBGTyPNYY8L4DI14LJncV
	 5a5QDVVamdNaNhe5QDsIqoqCohqmcBn9Jj2E0iws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Tanz <gabor.tanz@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0819/1536] HID: quirks: Always poll the Anne Pro 2 with product ID a292
Date: Sat,  7 Nov 2026 08:47:15 -0500
Message-ID: <20261107135020.550277734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -711,6 +711,7 @@
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



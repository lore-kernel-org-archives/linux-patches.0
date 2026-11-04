Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831858;
	b=fW+nwYsFJRH+xNuCarNjG8dtlY2+VI7RgCre3KgOVdYfb0xQytXmYtP38jOzI2Rth6yB
	 w8pTt/b8ckm7x080KHBbN1AWXkzZeKCw9gCxoF0EITHoeroMsJFlqojo4EKvySgGcH2p4
	 lkTtbP7siICg0+BCmuBD1HvX1LPBF4talXWPjLsrQvktMjO0R4LsSO/pR7SlKKdTjx4Pk
	 yJ+YCrd7G+pkRHZiD1usLAvjyGr1dmnHgG5L/XpTcWRK+nEKT6vYnZ1bxoqZcLRh61UI+
	 9NbeDbKIrjA+UV2xPPoakfAAw498UxL4TRFhpFBD7q/aIQ59aFEKMZfEytlifK6s3Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RrXpXGjiItVPmp3gku5s12yBocuRHd9Bu+HthuGvQrs=;
	b=vmQ2QdrXf2eYf68Wy3lAb0JUouGHiRQ5gqphrqwcpaT604mVPfJZFYRL+dPY0KwJgcyK
	 2o0MJEQ6y78DdoS8J6dcybeh2esM5SpcY3gz4zFWCXS+7FaeyWMe+GnLtzD1h+r4O7d/3
	 shi+1o6yN15jB7LRrQcHwZg8Ags0HCsfq5u465mucWC1O4t808k70ZzwE0lJShvmobfBB
	 DM01umm5AQDKpIXJ2VjHjj0WD6mUFIdrZ5TXZU6rBLNaim4c0mN9Mfmg4w8neM+mj08vN
	 wnl2c3APHwGx3dwHWAUvbaN6CAZ/WJYd825smIns246Bv+VsG6nkoHQVh7R9dsDzz1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4rgZCUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C4B606AB27;
	Wed,  4 Nov 2026 22:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4rgZCUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5481F00919;
	Wed,  4 Nov 2026 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831858;
	bh=RrXpXGjiItVPmp3gku5s12yBocuRHd9Bu+HthuGvQrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4rgZCUpzSXoCFSloBmoLOAbAEt2Nz7Twa69opKDbmqbbN4z7aQvUwbAjwxK1IrF4
	 Z4XOPv/XtTnISiQ0IkcoNANbfnPHOBWlKW6PNXHQpP/o06ozB8ZmyQzVszD9i/3dgf
	 kNqB0F+FfvhNlBkkPm9MTUQqCQpJtKz26TaHNvIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Tanz <gabor.tanz@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0958/1005] HID: quirks: Always poll the Anne Pro 2 with product ID a292
Date: Wed,  4 Nov 2026 16:11:31 -0500
Message-ID: <20261104211109.921316208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -719,6 +719,7 @@
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



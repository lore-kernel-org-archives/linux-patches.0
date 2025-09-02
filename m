Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0830DD31;
	Tue,  2 Sep 2025 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820037; cv=none; b=Djhl8eNUNNaC+ObWNOGQHlPUuAmgNoIeOHKgsXCexc0QIb9Z2At9iE+s/xH1Rgc2DkpXs2bI25yXRNotGoIZij7w7OYPEBM5tekUyRYfXvT+DVs8X7hZk6yFWnGbLwbmhzN1bjl+dyKB8r1/wm+DfgyhL8AHoCgGPGgYE+s1DA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820037; c=relaxed/simple;
	bh=EETJNm6FhTAfB1ET+V8E2T6b6FZ4Iftq7tKj91c/tj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1trt7tP0XJZbLN2FV8OrBXceRUgGz6ZkAWLw4CdLBWf1b75Aafo4OuvV07zgKVVWIqI9O8crYX84MN67RqD3O9L7+UKBKqCFYSTkDDe7RMQxogoehHWbDdZ4gxxhbI4F+j6htwshw/9x5ucqRf2VIa6++r64IJ6Xp93P6jH8wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=so6916Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="so6916Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E436C4CEED;
	Tue,  2 Sep 2025 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820037;
	bh=EETJNm6FhTAfB1ET+V8E2T6b6FZ4Iftq7tKj91c/tj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=so6916LkK2SuGQhoqUZwlqwhW2I9fHOIiTQJ7WAAHC6WrM3bxvSp+TLHURDfLnvtD
	 0qOjvc9V0kreiLBmw3VqBFZyNE6Wwvrj86TG0IZowqqTYEHvW4XwBzUYQImSi/qjZ7
	 WuZBpMetPptlXoox7nD1PebjACq9p4Xb1M5XMCno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Coffin <mcoffin13@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 74/95] HID: logitech: Add ids for G PRO 2 LIGHTSPEED
Date: Tue,  2 Sep 2025 15:20:50 +0200
Message-ID: <20250902131942.450445136@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Coffin <mcoffin13@gmail.com>

commit ab1bb82f3db20e23eace06db52031b1164a110c2 upstream.

Adds support for the G PRO 2 LIGHTSPEED Wireless via it's nano receiver
or directly. This nano receiver appears to work identically to the 1_1
receiver for the case I've verified, which is the battery status through
lg-hidpp.

The same appears to be the case wired, sharing much with the Pro X
Superlight 2; differences seemed to lie in userland configuration rather
than in interfaces used by hid_logitech_hidpp on the kernel side.

I verified the sysfs interface for battery charge/discharge status, and
capacity read to be working on my 910-007290 device (white).

Signed-off-by: Matt Coffin <mcoffin13@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h            |    1 +
 drivers/hid/hid-logitech-dj.c    |    4 ++++
 drivers/hid/hid-logitech-hidpp.c |    2 ++
 3 files changed, 7 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -900,6 +900,7 @@
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_2		0xc534
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1	0xc539
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1	0xc53f
+#define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2	0xc543
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_POWERPLAY	0xc53a
 #define USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER	0xc548
 #define USB_DEVICE_ID_SPACETRAVELLER	0xc623
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1983,6 +1983,10 @@ static const struct hid_device_id logi_d
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1),
 	 .driver_data = recvr_type_gaming_hidpp},
+	{ /* Logitech lightspeed receiver (0xc543) */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_2),
+	 .driver_data = recvr_type_gaming_hidpp},
 
 	{ /* Logitech 27 MHz HID++ 1.0 receiver (0xc513) */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4624,6 +4624,8 @@ static const struct hid_device_id hidpp_
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC094) },
 	{ /* Logitech G Pro X Superlight 2 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC09b) },
+	{ /* Logitech G PRO 2 LIGHTSPEED Wireless Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xc09a) },
 
 	{ /* G935 Gaming Headset */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0x0a87),



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC892571C6;
	Thu, 17 Apr 2025 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913041; cv=none; b=tkSJJXQPLfLqIrz87HHwJ9ZQ3psxNSIrv3kOOXuw/go99GF4kNb4v/6n998SY6KObKCNZ2hl6cbSgD15r9SAPp9fR9bhOscU4BKwZKYye7Nlh+FvOxdOZ12ywI8vzhBtJFCcxMWLS3rNFier0cTO98jz6vlhnjX2Q3VVVWiPREg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913041; c=relaxed/simple;
	bh=yoXtX/Kd38sALJXJ/aNAp0dsdEkjtQ/kgoDY91PXoEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DkGrKI8sWZX0WUHr84BzYdlQwEHt+kxxPp3uuDIsLEjehzFtFcaKU6NuUkI4Trok++oUBFg4281Vea7mXipAaPqN6KUfQbyQf813YXuvvOxiAqL3UAqrsk4XbsAhZVfyWejVMQRuCFWgCbIJbjrgB3M/XuyaB4R1abXvAGhXhYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cfZW6Rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cfZW6Rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A54C4CEE4;
	Thu, 17 Apr 2025 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913041;
	bh=yoXtX/Kd38sALJXJ/aNAp0dsdEkjtQ/kgoDY91PXoEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cfZW6RwwKY7wIcRiCC6uXMRmZwaP34iMPbKR3zb2z8UR4Iw2gZE3EY11wFeBj2UM
	 ph9KEraLV9a9oJjEa4U4hgiMmBc5YlDBETgDo9GJ4Gli9V3MrJbPWy6AZUiu/mcUsf
	 BGmfZYAqMndBsfJN7m/ZRdzLiky+xh0nsjDQl06M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 208/449] HID: hid-universal-pidff: Add Asetek wheelbases support
Date: Thu, 17 Apr 2025 19:48:16 +0200
Message-ID: <20250417175126.345188287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit c385f61108d403633e8cfbdae15b35ccf7cee686 ]

Adds Asetek vendor id and product ids for:
- Invicta
- Forte
- La Prima
- Tony Kanaan

v2:
- Misc spelling fix in driver loaded info

v3:
- Chanage Oleg's name order

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h             |  6 ++++++
 drivers/hid/hid-universal-pidff.c | 10 +++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d54b2b302ad7b..288a2b864cc41 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -190,6 +190,12 @@
 #define USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT 0x8102
 #define USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY 0x8302
 
+#define USB_VENDOR_ID_ASETEK			0x2433
+#define USB_DEVICE_ID_ASETEK_INVICTA		0xf300
+#define USB_DEVICE_ID_ASETEK_FORTE		0xf301
+#define USB_DEVICE_ID_ASETEK_LA_PRIMA		0xf303
+#define USB_DEVICE_ID_ASETEK_TONY_KANAAN	0xf306
+
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
 #define USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO	0x0186
diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 1b713b741d192..5b89ec7b5c26c 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -4,7 +4,7 @@
  * hid-pidff wrapper for PID-enabled devices
  * Handles device reports, quirks and extends usable button range
  *
- * Copyright (c) 2024, 2025 Makarenko Oleg
+ * Copyright (c) 2024, 2025 Oleg Makarenko
  * Copyright (c) 2024, 2025 Tomasz Pakuła
  */
 
@@ -104,7 +104,7 @@ static int universal_pidff_probe(struct hid_device *hdev,
 		goto err;
 	}
 
-	hid_info(hdev, "Universal pidff driver loaded sucesfully!");
+	hid_info(hdev, "Universal pidff driver loaded sucessfully!");
 
 	return 0;
 err:
@@ -179,6 +179,10 @@ static const struct hid_device_id universal_pidff_devices[] = {
 		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_LITE_STAR_GT987_FF),
 		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_INVICTA) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_FORTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_LA_PRIMA) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_TONY_KANAAN) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, universal_pidff_devices);
@@ -194,5 +198,5 @@ module_hid_driver(universal_pidff);
 
 MODULE_DESCRIPTION("Universal driver for USB PID Force Feedback devices");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Makarenko Oleg <oleg@makarenk.ooo>");
+MODULE_AUTHOR("Oleg Makarenko <oleg@makarenk.ooo>");
 MODULE_AUTHOR("Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>");
-- 
2.39.5




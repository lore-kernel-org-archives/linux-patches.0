Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C5257AE7;
	Thu, 17 Apr 2025 18:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914349; cv=none; b=f6SpR9+rLxaj84KDOV9tywL6XJ7pfWD114Nr6niAClV4yCm8xE8hxyWVoT8dlgAE6pd+4UxWo1jzPK6mHm98IfT753vFK2Fi4TT6CJTPYG22i/yeYENM7Uwi0kNh1GEkwOLqL0vsFc34R7iJP1sams9fU08PHipGlZWnt1RViRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914349; c=relaxed/simple;
	bh=/luoMvqlRUIX5D3Pu7Msl3izke7E+DxfiGpnpPJgT70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rArIc9PO+MQNLCn/U1x1a8WygdUo8DhEm3dysZmWhceApjhEXZeYBGc0CZu8K+zu89yjCCa7huoqW4S3pLNCwo+cnLXi1IpR5XgN7g5WuMgAatcpLWCvyBs6jo79nP+PZxPg55Z5fGdWcOGB2MQDpSyzUKVvYxPDqYUHXbtIs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHE6YaWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHE6YaWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB29C4CEE4;
	Thu, 17 Apr 2025 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914348;
	bh=/luoMvqlRUIX5D3Pu7Msl3izke7E+DxfiGpnpPJgT70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHE6YaWx0m9pp+LbjwRjzHaTiY3wcG07o/XtUAq3elxzLksShtROmkb0UuWdU1gRS
	 9e6fw44Lr8+kzQ/irEuVYHGkhukxastvrtdRVQZ90eghfE70mS1idn4HcirpQEzXic
	 8T0ae0NblibvGHO479kZ0EWJIhjtZo3kUFGtBZZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 186/414] HID: hid-universal-pidff: Add Asetek wheelbases support
Date: Thu, 17 Apr 2025 19:49:04 +0200
Message-ID: <20250417175118.928327577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e1e002df64de2..db88831633466 100644
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




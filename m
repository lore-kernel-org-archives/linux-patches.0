Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46152E7641;
	Tue, 15 Jul 2025 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587155; cv=none; b=EKSJJrAAhyAnaJebytnL3ql1ZOAJjQ9+SmzoOnLJIu8VG/dEw+no0yihYpDWEqpv16eqBjshpVQX3G6AfD61eO775u7vVGcfbbfJmYmU0V346zlWxi29xswzcmGew1zdLRtWW6T07d/MM4cRQRsr0XYyTVZqlV8fnGR9jdSsUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587155; c=relaxed/simple;
	bh=G0mBA+q4pweg9EvI44fQZfbH0ihnhifscASyGE+eZjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzRllPmwCTT5BRxZGXYcVtPpTpQWX3I4tXsbRgl/7mVzUWEmVYesK5pCKc9XilGRdmEiCaIi4jifCcUQ9miWRz7r5e1XyEuMD0yM+9jife/JfKap708Q2Ap73eY09vre6w1mPHnavjJLKo+pZJxMszK6sDguRirgT/6wXQPqb/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulZuD4u8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulZuD4u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587E3C4CEF6;
	Tue, 15 Jul 2025 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587155;
	bh=G0mBA+q4pweg9EvI44fQZfbH0ihnhifscASyGE+eZjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulZuD4u8wnC1yuwIc9YwBIlZDpAsN6NFze4lh5gZ0mljTsKNjPg8nQ0/JFOnb+p6q
	 An4I/UiEO3xjRT9b4nDXxsBH2dz38ejDLf+YsTsCHQc0ot9mn3Fy7WQ5GDs3T6vIme
	 jYCqfDqWVrwSa2SgV2ISBRISUln2Pv6HwczFbPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 186/192] HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY
Date: Tue, 15 Jul 2025 15:14:41 +0200
Message-ID: <20250715130822.387081528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 1a8953f4f7746c6a515989774fe03047c522c613 ]

MARTLINKTECHNOLOGY is a microphone device, when the HID interface in an
audio device is requested to get specific report id, the following error
may occur.

[  562.939373] usb 1-1.4.1.2: new full-speed USB device number 21 using xhci_hcd
[  563.104908] usb 1-1.4.1.2: New USB device found, idVendor=4c4a, idProduct=4155, bcdDevice= 1.00
[  563.104910] usb 1-1.4.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  563.104911] usb 1-1.4.1.2: Product: USB Composite Device
[  563.104912] usb 1-1.4.1.2: Manufacturer: SmartlinkTechnology
[  563.104913] usb 1-1.4.1.2: SerialNumber: 20201111000001
[  563.229499] input: SmartlinkTechnology USB Composite Device as /devices/pci0000:00/0000:00:07.1/0000:04:00.3/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1.2/1-1.4.1.2:1.2/0003:4C4A:4155.000F/input/input35
[  563.291505] hid-generic 0003:4C4A:4155.000F: input,hidraw2: USB HID v2.01 Keyboard [SmartlinkTechnology USB Composite Device] on usb-0000:04:00.3-1.4.1.2/input2
[  563.291557] usbhid 1-1.4.1.2:1.3: couldn't find an input interrupt endpoint
[  568.506654] usb 1-1.4.1.2: 1:1: usb_set_interface failed (-110)
[  573.626656] usb 1-1.4.1.2: 1:1: usb_set_interface failed (-110)
[  578.746657] usb 1-1.4.1.2: 1:1: usb_set_interface failed (-110)
[  583.866655] usb 1-1.4.1.2: 1:1: usb_set_interface failed (-110)
[  588.986657] usb 1-1.4.1.2: 1:1: usb_set_interface failed (-110)

Ignore HID interface. The device is working properly.

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 898fe03074c64..116436be5e287 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1525,4 +1525,7 @@
 #define USB_VENDOR_ID_SIGNOTEC			0x2133
 #define USB_DEVICE_ID_SIGNOTEC_VIEWSONIC_PD1011	0x0018
 
+#define USB_VENDOR_ID_SMARTLINKTECHNOLOGY              0x4c4a
+#define USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155         0x4155
+
 #endif
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 0731473cc9b1a..7a363fdf31edf 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -904,6 +904,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SMARTLINKTECHNOLOGY, USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155) },
 	{ }
 };
 
-- 
2.39.5




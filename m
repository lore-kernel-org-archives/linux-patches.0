Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652983346AF;
	Thu, 12 Mar 2026 20:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346993; cv=none; b=p6eVfa9fk4HDqQUoPwBPvG86zIBz84zWPvregxotZIcodEOAE8XamzCLEQOa+sI27q+tyTN0egRkXcGTlSnbr2TR3vLKndeL8MhZfbdfgz3H+qzvYT2X9w+ZY4ZzT1L30XsBFASuCKj6OHS6IU4oeIm13FZ8lr8hzVPIeEbVZT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346993; c=relaxed/simple;
	bh=sSrKjMBROPZLDNqcr2ug99rnm12z/Uejx4HPXl1btd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyVHrsr8ezpt2qD+OTjnHd563S5i2zgoUA5sxhaIaH2d5fRUuaojGqJnf02EgVRs+jKf4+0iyWQ6e80V1VhXNe/gb8OYPnPgbTmvn9MJzBvucSVLhFHtYN0U61RU8WmBX0HQ8EOHdUcFLV2MGZVNH+ck1/eAr5HxK61aKcSlOxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcCWaJBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcCWaJBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAB6C4CEF7;
	Thu, 12 Mar 2026 20:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346993;
	bh=sSrKjMBROPZLDNqcr2ug99rnm12z/Uejx4HPXl1btd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcCWaJBiU//FTLTCQD1kiABLDk4YslTeL+ppm5abGE+DIxmr1gs8x5hrBBYT4ZUOS
	 GMwG8BF2/khDW+TlCBSPn6MmmJPHYi6KXtKiK/dTa0FIp09JXbc3nikRlkl+cqPWuv
	 xX5NDop5YFUhNd/OFuHXOnavR9yl6biZs22+1BJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/265] HID: multitouch: add device ID for Apple Touch Bar
Date: Thu, 12 Mar 2026 21:09:22 +0100
Message-ID: <20260312201024.625617672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 2c31ec923c323229566d799267000f8123af4449 ]

This patch adds the device ID of Apple Touch Bar found on x86 MacBook Pros
to the hid-multitouch driver.

Note that this is device ID is for T2 Macs. Testing on T1 Macs would be
appreciated.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: a2e70a89fa58 ("HID: multitouch: new class MT_CLS_EGALAX_P80H84")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig          |  1 +
 drivers/hid/hid-multitouch.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index f283f271d87e7..586de50a26267 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -730,6 +730,7 @@ config HID_MULTITOUCH
 	  Say Y here if you have one of the following devices:
 	  - 3M PCT touch screens
 	  - ActionStar dual touch panels
+	  - Apple Touch Bar on x86 MacBook Pros
 	  - Atmel panels
 	  - Cando dual touch panels
 	  - Chunghwa panels
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b7c2640a61b4a..5aed9e320d306 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -216,6 +216,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_GOOGLE				0x0111
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
 #define MT_CLS_SMART_TECH			0x0113
+#define MT_CLS_APPLE_TOUCHBAR			0x0114
 #define MT_CLS_SIS				0x0457
 
 #define MT_DEFAULT_MAXCONTACT	10
@@ -402,6 +403,12 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_SEPARATE_APP_REPORT,
 	},
+	{ .name = MT_CLS_APPLE_TOUCHBAR,
+		.quirks = MT_QUIRK_HOVERING |
+			MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE |
+			MT_QUIRK_APPLE_TOUCHBAR,
+		.maxcontacts = 11,
+	},
 	{ .name = MT_CLS_SIS,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
@@ -1842,6 +1849,11 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret != 0)
 		return ret;
 
+	if (mtclass->name == MT_CLS_APPLE_TOUCHBAR &&
+	    !hid_find_field(hdev, HID_INPUT_REPORT,
+			    HID_DG_TOUCHPAD, HID_DG_TRANSDUCER_INDEX))
+		return -ENODEV;
+
 	if (mtclass->quirks & MT_QUIRK_FIX_CONST_CONTACT_ID)
 		mt_fix_const_fields(hdev, HID_DG_CONTACTID);
 
@@ -2332,6 +2344,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
+	/* Apple Touch Bar */
+	{ .driver_data = MT_CLS_APPLE_TOUCHBAR,
+		HID_USB_DEVICE(USB_VENDOR_ID_APPLE,
+			USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY) },
+
 	/* Google MT devices */
 	{ .driver_data = MT_CLS_GOOGLE,
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_GOOGLE,
-- 
2.51.0




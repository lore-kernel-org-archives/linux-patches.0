Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76063876D3;
	Tue, 10 Mar 2026 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142018; cv=none; b=J4ZAZ0dsgzRuv1Y6zl8Zv2+Ovj3oDbGCn1wnurxnfbt9phZUHsg+nb3P0dbNZlZ5y8Rvj7+XZtCpfwK2QXO3BKanj6Mcl5PDanJTI0K6Ym0o6r604pJzx1qUaFmbteSEX0LRHl9Q9aXmc0/PdyLUXT5k1RfuHdoarxdTHI6Fle0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142018; c=relaxed/simple;
	bh=zjtWGoXSUb3USZW5Lvw/lPX6wxHC1M4yR5FQXaM4hUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgymqf2zLtgvcFM4OJjUh+bRcpoW/NcRqcUR2gEM19526vp/01nal6r9VnijziNwCbf2+Dpr1dS74iuAUfkv/7GC8ZxcNTB5ILOYMqzjnJ0W7Afk5g9VcXY1EdTd+itxGHU23y8LZhRuSiKlUhaOZYrel5Vpb06oKpDsqULTPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uP4eRNw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uP4eRNw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EFFC19423;
	Tue, 10 Mar 2026 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142018;
	bh=zjtWGoXSUb3USZW5Lvw/lPX6wxHC1M4yR5FQXaM4hUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP4eRNw5bLBNClZ6KqX8iWWDXjg29HBD5dKTZrnrI48LP58aFsBEGcLhdKQp64i6E
	 4LJT9VWZRrsD5N87nAWMcTmQvilqfsOX+z/BayU5EejF9erg0q70XywXuPJMZ4THrU
	 4RZt1MOPYR7eAYmdgzWzgTFFjd2OA+4ElzTaUreOwtTG3K+4O8wtboiI/tronuIH+H
	 AYyaBjPMh71JVQUvXn8N1RKbxMxO60SWMDy1ILSCyTjbS8RHlp4FHgrPZILN1U7z2a
	 VGPJ+6kx3iFCyoHJn+gZsAEcS7uw24RKgj15ECTnXl3Jr1jFWXcTZMUowQ1xntSVSl
	 Eeod18mH/zlYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Werner Sembach <wse@tuxedocomputers.com>,
	Jiri Kosina <jkosina@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 145/314] HID: multitouch: Keep latency normal on deactivate for reactivation gesture
Date: Tue, 10 Mar 2026 07:16:44 -0400
Message-ID: <c7a2b87b28dff2afe410b978f3dd44ac22dc927b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Werner Sembach <wse@tuxedocomputers.com>

commit ec3070f01fa30f2c5547d645dbb76174304bf0e4 upstream.

Uniwill devices have a built in gesture in the touchpad to de- and
reactivate it by double taping the upper left corner. This gesture stops
working when latency is set to high, so this patch keeps the latency on
normal.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
[jkosina@suse.com: change bit from 24 to 25]
[jkosina@suse.com: update shortlog]
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4dcb1d43df27a..1f8accb7ff435 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -77,6 +77,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 #define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
 #define MT_QUIRK_YOGABOOK9I		BIT(24)
+#define MT_QUIRK_KEEP_LATENCY_ON_CLOSE	BIT(25)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -212,6 +213,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU	0x0018
+#define MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE	0x0019
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -332,6 +334,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_KEEP_LATENCY_ON_CLOSE,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -841,7 +852,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			if ((cls->name == MT_CLS_WIN_8 ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU ||
-			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
+			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP ||
+			     cls->name == MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
 				app->quirks |= MT_QUIRK_CONFIDENCE;
@@ -1752,7 +1764,8 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	int ret;
 
 	if (td->is_haptic_touchpad && (td->mtclass.name == MT_CLS_WIN_8 ||
-	    td->mtclass.name == MT_CLS_WIN_8_FORCE_MULTI_INPUT)) {
+	    td->mtclass.name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+	    td->mtclass.name == MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE)) {
 		if (hid_haptic_input_configured(hdev, td->haptic, hi) == 0)
 			td->is_haptic_touchpad = false;
 	} else {
@@ -2065,7 +2078,12 @@ static void mt_on_hid_hw_open(struct hid_device *hdev)
 
 static void mt_on_hid_hw_close(struct hid_device *hdev)
 {
-	mt_set_modes(hdev, HID_LATENCY_HIGH, TOUCHPAD_REPORT_NONE);
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	if (td->mtclass.quirks & MT_QUIRK_KEEP_LATENCY_ON_CLOSE)
+		mt_set_modes(hdev, HID_LATENCY_NORMAL, TOUCHPAD_REPORT_NONE);
+	else
+		mt_set_modes(hdev, HID_LATENCY_HIGH, TOUCHPAD_REPORT_NONE);
 }
 
 /*
@@ -2451,6 +2469,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 
+	/* Uniwill touchpads */
+	{ .driver_data = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_PIXART, 0x0255) },
+	{ .driver_data = MT_CLS_WIN_8_KEEP_LATENCY_ON_CLOSE,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_PIXART, 0x0274) },
+
 	/* VTL panels */
 	{ .driver_data = MT_CLS_VTL,
 		MT_USB_DEVICE(USB_VENDOR_ID_VTL,
-- 
2.51.0


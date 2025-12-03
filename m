Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604735BDB9;
	Wed,  3 Dec 2025 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780116; cv=none; b=oHMsNI3KUAgInv/OIffuR3iuviHr+CZcJykFVDX1sxH7cAqGKQtu7FIMZCmpL1KDTvkhbJ5Elhatp6+DjH58a/3osl41GghcvC8xwuHCkyq9hMLio9GLwMSA3NGlaknM3w/Tg0lehUNK/mro/0EY3tYBVCEomsWcqosfZkbhukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780116; c=relaxed/simple;
	bh=UGLLZrFATmWQ9HfB9ThpVbPjqLRHejoO2KPV1lSuNpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klUYpTlcgGgsXSej3/u6Rcuf9AjmqGIe/MPRg9tFDCNzuYuaYIhxLFewyJUE42sbCo2AYx8IJWdUlKWqWU5379W3eRXYnIcsWehQxNYOBSYfsg4WipqHzGgBwnXUE7gp+4d9R4EklWf4iIwGT4VAUz0GJ7bgSWcmeTum1KicSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4I2m6ZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4I2m6ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B51AC4CEF5;
	Wed,  3 Dec 2025 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780116;
	bh=UGLLZrFATmWQ9HfB9ThpVbPjqLRHejoO2KPV1lSuNpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4I2m6ZQEsfoKkeijTLACTivXYLKCfsewtOwqVoSEbXrciWhx7Pwklmfjpd4ksvXm
	 kUP1Y39SrV6ZsFMx01tCdPPfUeAFyNeanOEbLdK/UolRt8XQzsBNNitEvFBYSzN+Mx
	 LIA1VAFZliDO60Sewg6SWatbXqGPmTTPLByrsoiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	staffan.melin@oscillator.se,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 428/568] HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155
Date: Wed,  3 Dec 2025 16:27:10 +0100
Message-ID: <20251203152456.371134539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit beab067dbcff642243291fd528355d64c41dc3b2 upstream.

Based on available evidence, the USB ID 4c4a:4155 used by multiple
devices has been attributed to Jieli. The commit 1a8953f4f774
("HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY") affected touchscreen
functionality. Added checks for manufacturer and serial number to
maintain microphone compatibility, enabling both devices to function
properly.

[jkosina@suse.com: edit shortlog]
Fixes: 1a8953f4f774 ("HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY")
Cc: stable@vger.kernel.org
Tested-by: staffan.melin@oscillator.se
Reviewed-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    4 ++--
 drivers/hid/hid-quirks.c |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1460,7 +1460,7 @@
 #define USB_VENDOR_ID_SIGNOTEC			0x2133
 #define USB_DEVICE_ID_SIGNOTEC_VIEWSONIC_PD1011	0x0018
 
-#define USB_VENDOR_ID_SMARTLINKTECHNOLOGY              0x4c4a
-#define USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155         0x4155
+#define USB_VENDOR_ID_JIELI_SDK_DEFAULT		0x4c4a
+#define USB_DEVICE_ID_JIELI_SDK_4155		0x4155
 
 #endif
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -888,7 +888,6 @@ static const struct hid_device_id hid_ig
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SMARTLINKTECHNOLOGY, USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155) },
 	{ }
 };
 
@@ -1045,6 +1044,18 @@ bool hid_ignore(struct hid_device *hdev)
 					     strlen(elan_acpi_id[i].id)))
 					return true;
 		break;
+	case USB_VENDOR_ID_JIELI_SDK_DEFAULT:
+		/*
+		 * Multiple USB devices with identical IDs (mic & touchscreen).
+		 * The touch screen requires hid core processing, but the
+		 * microphone does not. They can be distinguished by manufacturer
+		 * and serial number.
+		 */
+		if (hdev->product == USB_DEVICE_ID_JIELI_SDK_4155 &&
+		    strncmp(hdev->name, "SmartlinkTechnology", 19) == 0 &&
+		    strncmp(hdev->uniq, "20201111000001", 14) == 0)
+			return true;
+		break;
 	}
 
 	if (hdev->type == HID_TYPE_USBMOUSE &&



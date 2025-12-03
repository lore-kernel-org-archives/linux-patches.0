Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82A5315D47;
	Wed,  3 Dec 2025 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776543; cv=none; b=cjECu8OSA4VXk36FOMkpOsP9cHQOTnNLAHAeqIUDauIsHv2jfpwqctquCV2oDUMFboaTwikraLfIkxJn1iowO1D0Mbz3+9Z6znp/I/XI5sQbHpOjJde1CUjAoNQTSQ+Kfv84+mJ2hngm6eEW4lfeXeOrVEhHQI50NEXOQRTO0es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776543; c=relaxed/simple;
	bh=1f5PpyVO/RZwhiTz2jApXl0Rv5AWO9RUbCpGbFP5KuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1ZSGFcAB0XRaPo9UpPxFO5zU7t+mwFwj6mKhCfmJ933bf+AkMYUHLFd2FGjJvQ60+51yQvtEIrZYhw4KVbM7SFCZ0dwCBwi6E0XFH+O9FsI5bvdIUhx+GLs10I7Hhcq289F/JRKLINiB4pfX2r1xNl59+LvVaR+DlXnXX4MBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MenR4e6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MenR4e6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAFCC4CEF5;
	Wed,  3 Dec 2025 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776543;
	bh=1f5PpyVO/RZwhiTz2jApXl0Rv5AWO9RUbCpGbFP5KuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MenR4e6ayom4q/9xqpbscrt5ucEZjnIFlkyAvK2b52aUHj5spMgd2mntI0jl+49qV
	 2hK5t/1hrt4dF9OBGtfcWOos0rEl/dUzWgqXc4uqAPSv/Ln7fJ3P+EdQlsCVd4QNAl
	 HrxDmoNyWyWlDbpghTmCRjLSWHW9d/n3dRwQwaR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	staffan.melin@oscillator.se,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 215/300] HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155
Date: Wed,  3 Dec 2025 16:26:59 +0100
Message-ID: <20251203152408.587644737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1365,7 +1365,7 @@
 #define USB_VENDOR_ID_SIGNOTEC			0x2133
 #define USB_DEVICE_ID_SIGNOTEC_VIEWSONIC_PD1011	0x0018
 
-#define USB_VENDOR_ID_SMARTLINKTECHNOLOGY              0x4c4a
-#define USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155         0x4155
+#define USB_VENDOR_ID_JIELI_SDK_DEFAULT		0x4c4a
+#define USB_DEVICE_ID_JIELI_SDK_4155		0x4155
 
 #endif
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -876,7 +876,6 @@ static const struct hid_device_id hid_ig
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SMARTLINKTECHNOLOGY, USB_DEVICE_ID_SMARTLINKTECHNOLOGY_4155) },
 	{ }
 };
 
@@ -1025,6 +1024,18 @@ bool hid_ignore(struct hid_device *hdev)
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



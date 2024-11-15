Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6B2BB1B;
	Fri, 15 Nov 2024 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653995; cv=none; b=WlO2MqBiBhyK000JPvSyDxzryMKkPEUmbelPr0qhUkAt0Ie9idWzoxDkhzWtyb52a0eqHZN9BqzHdhoD9R/ozHMnZJhvR4ZPy7z1GwawzqWGeDhfGzUI86x6HzXl4ReBByt7Eg3cubEeMmNaaFPFnV1E43U0IWA/IAlPu0aA4lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653995; c=relaxed/simple;
	bh=QY0Yq71lHHJZzym8GLGc5jAxGL4MVq7RaF5iT2RpMlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHooPwzwg8/emCs6CpHejaWyKsdPQ473SdTH5rA3cbF3Fw9mJkMIZKfH1GPhTetbE/57/S/HNrgPoVAbJ7B4mNHXOsdVK5yFpjNrWLn8XbCpWVOPGaZiuraV7XwQ6WRurITMhKyrOtp3oPN4ozcFFsrg59uIfCMN6Ep1+N+TP/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8S27ZIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8S27ZIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863DAC4CECF;
	Fri, 15 Nov 2024 06:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653995;
	bh=QY0Yq71lHHJZzym8GLGc5jAxGL4MVq7RaF5iT2RpMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8S27ZIrR0BLTMOiMWIGUaRTgO45N+ZK29VMzJ6ebVWGTLr1R0WnCJDUwTtj1lbYl
	 5hMAUgyLazq+C0pBTqxAGAJPvw4rm5GH1vB15UwuhI+89YCjVnh9Csr7MKy8xUj+yC
	 UtQYxFfkpt8HhuOJVQxVShhselCo9Wi2796XrXI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Izhar Firdaus <izhar@fedoraproject.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/22] HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard
Date: Fri, 15 Nov 2024 07:39:00 +0100
Message-ID: <20241115063721.690670074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 51268879eb2bfc563a91cdce69362d9dbf707e7e ]

The Thinkpad X1 Tablet Gen 3 keyboard has the same Lenovo specific quirks
as the original  Thinkpad X1 Tablet keyboard.

Add the PID for the "Thinkpad X1 Tablet Gen 3 keyboard" to the hid-lenovo
driver to fix the FnLock, Mute and media buttons not working.

Suggested-by: Izhar Firdaus <izhar@fedoraproject.org>
Closes https://bugzilla.redhat.com/show_bug.cgi?id=2315395
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 44fd4a05ace38..9536f468b42c5 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -343,6 +343,7 @@ static int lenovo_input_mapping(struct hid_device *hdev,
 		return lenovo_input_mapping_tp10_ultrabook_kbd(hdev, hi, field,
 							       usage, bit, max);
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		return lenovo_input_mapping_x1_tab_kbd(hdev, hi, field, usage, bit, max);
 	default:
 		return 0;
@@ -431,6 +432,7 @@ static ssize_t attr_fn_lock_store(struct device *dev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_led_set_tp10ubkbd(hdev, TP10UBKBD_FN_LOCK_LED, value);
 		if (ret)
 			return ret;
@@ -614,6 +616,7 @@ static int lenovo_event(struct hid_device *hdev, struct hid_field *field,
 		return lenovo_event_cptkbd(hdev, field, usage, value);
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		return lenovo_event_tp10ubkbd(hdev, field, usage, value);
 	default:
 		return 0;
@@ -896,6 +899,7 @@ static int lenovo_led_brightness_set(struct led_classdev *led_cdev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_led_set_tp10ubkbd(hdev, tp10ubkbd_led[led_nr], value);
 		break;
 	}
@@ -1136,6 +1140,7 @@ static int lenovo_probe(struct hid_device *hdev,
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		ret = lenovo_probe_tp10ubkbd(hdev);
 		break;
 	default:
@@ -1202,6 +1207,7 @@ static void lenovo_remove(struct hid_device *hdev)
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
 	case USB_DEVICE_ID_LENOVO_X1_TAB:
+	case USB_DEVICE_ID_LENOVO_X1_TAB3:
 		lenovo_remove_tp10ubkbd(hdev);
 		break;
 	}
@@ -1247,6 +1253,8 @@ static const struct hid_device_id lenovo_devices[] = {
 	 */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X1_TAB) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X1_TAB3) },
 	{ }
 };
 
-- 
2.43.0




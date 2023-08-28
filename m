Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8CD11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E9FC433C8;
	Mon, 28 Aug 2023 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219004;
	bh=dFKWNgWC/Q5piAJdLQ2krzfNYtPqy6RYe/HFn3kGf+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfE3b/gBgSLd4dogRe6ExI0zZvxQNdn77qslincjOTK8nbkRW/EPx1E8kA4Iuf7Fb
	 K2hFAJbA7PdHXj2NEVSEI20YxD8/ExpX4SnBTRwJtRJAnWZD8XcwiK88dF5jzt3YhB
	 VLSInnrESAvdcIJin+gKCKe7QQqDJF2M5QTDcCVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Morandini <marco.morandini@polimi.it>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/158] HID: add quirk for 03f0:464a HP Elite Presenter Mouse
Date: Mon, 28 Aug 2023 12:11:47 +0200
Message-ID: <20230828101157.682096181@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Morandini <marco.morandini@polimi.it>

[ Upstream commit 0db117359e47750d8bd310d19f13e1c4ef7fc26a ]

HP Elite Presenter Mouse HID Record Descriptor shows
two mouses (Repord ID 0x1 and 0x2), one keypad (Report ID 0x5),
two Consumer Controls (Report IDs 0x6 and 0x3).
Previous to this commit it registers one mouse, one keypad
and one Consumer Control, and it was usable only as a
digitl laser pointer (one of the two mouses). This patch defines
the 464a USB device ID and enables the HID_QUIRK_MULTI_INPUT
quirk for it, allowing to use the device both as a mouse
and a digital laser pointer.

Signed-off-by: Marco Morandini <marco.morandini@polimi.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 479516bbb61bf..64842926aff64 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -581,6 +581,7 @@
 #define USB_DEVICE_ID_UGCI_FIGHTING	0x0030
 
 #define USB_VENDOR_ID_HP		0x03f0
+#define USB_PRODUCT_ID_HP_ELITE_PRESENTER_MOUSE_464A		0x464a
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A	0x0a4a
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e5dcc47586ee4..83c3322fcf187 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -96,6 +96,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_ELITE_PRESENTER_MOUSE_464A), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A), HID_QUIRK_ALWAYS_POLL },
-- 
2.40.1




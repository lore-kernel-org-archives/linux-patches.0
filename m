Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4151EBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A332CC433EF;
	Tue,  7 Mar 2023 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213764;
	bh=a/j6JldgqL6Aj5Bz2yKD6WuWapdRTSuKKEJ1x1gC1PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9Ajuf6e4O8QOJANzA/kztfKKWdACpQ5+wzoqoTVfV7QLYefKMrgyta03IaKPfIWz
	 F1b+Y0Wh+rLqNUDURzAhHPoh8yvtRCpsruwSzERP0tI1ZROnBT/RwoEXncquI1ATYz
	 l54MyruajNBHDAaPNpjYPkwCyspFNMoaWsbXWpwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Grosse <andig.mail@t-online.de>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 612/885] HID: uclogic: Add support for XP-PEN Deco Pro MW
Date: Tue,  7 Mar 2023 17:59:06 +0100
Message-Id: <20230307170028.894492889@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 9266a88156d1fbb8e50d6eeff7bac44ad4eaecc2 ]

The XP-PEN Deco Pro MW is a UGEE v2 device with a frame with 8 buttons,
a bitmap dial and a mouse. Its pen has 2 buttons, supports tilt and
pressure.

It can be connected using a USB cable or, to use it in wireless mode,
using a USB Bluetooth dongle. When it is connected in wireless mode the
device battery is used to power it.

All the pieces to support it are already in place. Add its ID and
quirks in order to support the device.

Link: https://github.com/DIGImend/digimend-kernel-drivers/issues/622
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h            | 1 +
 drivers/hid/hid-input.c          | 2 ++
 drivers/hid/hid-uclogic-core.c   | 3 +++
 drivers/hid/hid-uclogic-params.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c662994d73381..2235d78784b1b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1299,6 +1299,7 @@
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01	0x0042
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2	0x0905
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L	0x0935
+#define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW	0x0934
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S	0x0909
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW	0x0933
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06	0x0078
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index fd8fe2594a61f..c3f80b516f398 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -378,6 +378,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 7c05d38d3afad..bfbb51f8b5beb 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -511,6 +511,9 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
+				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW),
+		.driver_data = UCLOGIC_MOUSE_FRAME_QUIRK | UCLOGIC_BATTERY_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 492a30f83575a..0cc03c11ecc22 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1669,6 +1669,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L):
+	case VID_PID(USB_VENDOR_ID_UGEE,
+		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S):
 	case VID_PID(USB_VENDOR_ID_UGEE,
-- 
2.39.2




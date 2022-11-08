Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D88B15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD511C433D6;
	Tue,  8 Nov 2022 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915940;
	bh=5wXwzbux59iYsUfokYO5oxpN/m+VJCsCbJL5hsvTLAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiFtGlgGLW2Uoue/dJx9YlfiNOCfKFiyipvuEYyvtwwq+CUGR70gphT30/ot9oXUT
	 c3Fr0mC5WCdMRfsA+F8tipEIV4MdDN++zRKKe6A02uWlBG8nkJzss1WcNHlzXxUA+O
	 QHK6JRQTdi8dwAJYa58btSoflpeviwEV/H14JldM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roderick Colenbrander <roderick.colenbrander@sony.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/144] HID: playstation: add initial DualSense Edge controller support
Date: Tue,  8 Nov 2022 14:38:06 +0100
Message-Id: <20221108133345.728620537@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roderick Colenbrander <roderick@gaikai.com>

[ Upstream commit b8a968efab301743fd659b5649c5d7d3e30e63a6 ]

Provide initial support for the DualSense Edge controller. The brings
support up to the level of the original DualSense, but won't yet provide
support for new features (e.g. reprogrammable buttons).

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221010212313.78275-3-roderick.colenbrander@sony.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h         | 1 +
 drivers/hid/hid-playstation.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index cb2b48d6915e..a5aac9cc2075 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1109,6 +1109,7 @@
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_2	0x09cc
 #define USB_DEVICE_ID_SONY_PS4_CONTROLLER_DONGLE	0x0ba0
 #define USB_DEVICE_ID_SONY_PS5_CONTROLLER	0x0ce6
+#define USB_DEVICE_ID_SONY_PS5_CONTROLLER_2	0x0df2
 #define USB_DEVICE_ID_SONY_MOTION_CONTROLLER	0x03d5
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
 #define USB_DEVICE_ID_SONY_BUZZ_CONTROLLER		0x0002
diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index ab7c82c2e886..bd0e0fe2f627 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -1282,7 +1282,8 @@ static int ps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_stop;
 	}
 
-	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER) {
+	if (hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER ||
+		hdev->product == USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) {
 		dev = dualsense_create(hdev);
 		if (IS_ERR(dev)) {
 			hid_err(hdev, "Failed to create dualsense.\n");
@@ -1320,6 +1321,8 @@ static void ps_remove(struct hid_device *hdev)
 static const struct hid_device_id ps_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS5_CONTROLLER_2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ps_devices);
-- 
2.35.1




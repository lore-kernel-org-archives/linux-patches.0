Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB23307D;
	Fri, 24 Nov 2023 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLBPf5HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A66C433C7;
	Fri, 24 Nov 2023 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853985;
	bh=drAZr0RIM0M8T3eJJFjagyRE87LYCbCeuqcvcOzMUUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLBPf5HUuK3P+gu4AN6zDcD6yAc/+d64VQsc8mLeGiV3UqZe/xetY0IAFa6CKYV+G
	 +l0Qr+Ex/8eZuR4B1Y48WGpgAO+hlfQpDD2lQgAiI9EsWgoNJdRQZmr1kcsdNjGMif
	 9pRfS8e9EKXpTJQVaqxhk7xP9+Q4S+pmcmgXoCA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Michaud <alainm@chromium.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/159] Bluetooth: btusb: Add flag to define wideband speech capability
Date: Fri, 24 Nov 2023 17:55:27 +0000
Message-ID: <20231124171946.463376956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit 3e4e3f73b9f4944ebd8100dbe107f2325aa79c6d ]

This change adds a new flag to define a controller's wideband speech
capability.  This is required since no reliable over HCI mechanism
exists to query the controller and driver's compatibility with
wideband speech.

Signed-off-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: da06ff1f585e ("Bluetooth: btusb: Add 0bda:b85b for Fn-Link RTL8852BE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 79f77315854f4..c42324ae8eeff 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -57,6 +57,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_IFNUM_2		0x80000
 #define BTUSB_CW6622		0x100000
 #define BTUSB_MEDIATEK		0x200000
+#define BTUSB_WIDEBAND_SPEECH	0x400000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -332,15 +333,21 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x1286, 0x204e), .driver_info = BTUSB_MARVELL },
 
 	/* Intel Bluetooth devices */
-	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW },
-	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW },
-	{ USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW },
+	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x8087, 0x07da), .driver_info = BTUSB_CSR },
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL },
 	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL },
-	{ USB_DEVICE(0x8087, 0x0a2b), .driver_info = BTUSB_INTEL_NEW },
-	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL },
-	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW },
+	{ USB_DEVICE(0x8087, 0x0a2b), .driver_info = BTUSB_INTEL_NEW |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Other Intel Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
-- 
2.42.0




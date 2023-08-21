Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0609211729
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8D5C433C9;
	Mon, 21 Aug 2023 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648110;
	bh=j2/SJBiFhWFnYATV/tALmd+Ax6GAELMae4O70ON35mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNKDE80BwubfOnUbt69F9pQlrC2DvIQwRRoNaP9TEaNylsMClNDEVG+8LkXDF4COT
	 sLbCutsD1i+D+0atZtHmd5iYuHgdkI+QEwriowvOA4eOg06sc78p0DUdM5z3tNec1o
	 MdugDRpCDc+8cwgN4rJiF6fiamFdnlPcm0LUX6I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 031/234] HID: logitech-hidpp: Add USB and Bluetooth IDs for the Logitech G915 TKL Keyboard
Date: Mon, 21 Aug 2023 21:39:54 +0200
Message-ID: <20230821194130.112167727@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: stuarthayhurst <stuart.a.hayhurst@gmail.com>

[ Upstream commit 48aea8b445c422a372cf15915101035a47105421 ]

Adds the USB and Bluetooth IDs for the Logitech G915 TKL keyboard, for device detection
For this device, this provides battery reporting on top of hid-generic

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index f7e06d433a915..dfe8e09a18de0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4608,6 +4608,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC086) },
 	{ /* Logitech G903 Hero Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC091) },
+	{ /* Logitech G915 TKL Keyboard over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC343) },
 	{ /* Logitech G920 Wheel over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G920_WHEEL),
 		.driver_data = HIDPP_QUIRK_CLASS_G920 | HIDPP_QUIRK_FORCE_OUTPUT_REPORTS},
@@ -4630,6 +4632,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* MX5500 keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb30b),
 	  .driver_data = HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS },
+	{ /* Logitech G915 TKL keyboard over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb35f) },
 	{ /* M-RCQ142 V470 Cordless Laser Mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb008) },
 	{ /* MX Master mouse over Bluetooth */
-- 
2.40.1




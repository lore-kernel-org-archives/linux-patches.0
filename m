Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6391A3178;
	Thu, 17 Apr 2025 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912833; cv=none; b=teYFO2jsb0LbmFZ0DwmetDy61gbib1Tjq1sftNT2w8agfAgCHT9ztsvhSiM76raR/RrXhlMJwbi5e/PRKJj0RLabdI/o571a1+sbscsp3RiI10mq5dRrNphxxlcSANbE9piozHBGpjQiC61a6L95ECRpyRbMnN8jAOlP7L1HADk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912833; c=relaxed/simple;
	bh=ISjdJaq+T7kNkVAzL+aIsMwh82GzlVRdhpVgoSXXFAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n74sY9RAZ9PgpXucPgFyw6mbaLS1AlCizSuLdaTPiIc6j+C77O6AgC4tDaQZS+OWoocGTcL4gEbC6LZRcuN//Ibw7wHm/co32kAd+8QDwW03qs3g0JAS7a6yiG18S4v16Jc+OH94ppfSAt2qrvcjv7W0Y6/ylcFrRXXnQXMCkdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSKxi6+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSKxi6+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22E2C4CEE4;
	Thu, 17 Apr 2025 18:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912833;
	bh=ISjdJaq+T7kNkVAzL+aIsMwh82GzlVRdhpVgoSXXFAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSKxi6+TwhYUzdj28vZbBsRkHyfptR2gmfWiHFM/dsluUr+CWXYZ+5YxYYisfp1Ie
	 ca9CGbCVa+qYpayIYtQOvi0SzrvJwEcmPRbZ9jTD0XjQUcMGJPdogg42T7DJDoEi3E
	 D9I9YYM+N9In+J+217RAcCBJWmq1sYXmS0XB7l94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 140/449] Bluetooth: btusb: Add 2 HWIDs for MT7922
Date: Thu, 17 Apr 2025 19:47:08 +0200
Message-ID: <20250417175123.601417040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit a88643b7e48506777e175e80c902c727ddd90851 ]

Add below HWIDs for MediaTek MT7922 USB Bluetooth chip.
VID 0x0489, PID 0xe152
VID 0x0489, PID 0xe153

Patch has been tested successfully and controller is recognized
device pair successfully.

MT7922 module bring up message as below.
Bluetooth: Core ver 2.22
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: hci0: HW/SW Version: 0x008a008a, Build Time: 20241106163512
Bluetooth: hci0: Device setup in 2284925 usecs
Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is advertised, but not supported.
Bluetooth: hci0: AOSP extensions version v1.00
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: MGMT ver 1.22
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11

Signed-off-by: Jiande Lu <jiande.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1295a979a3264..bfd769f2026b3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -668,6 +668,10 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe102), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe152), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe153), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x3804), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x38e4), .driver_info = BTUSB_MEDIATEK |
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE7E1487CD;
	Thu, 12 Dec 2024 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016947; cv=none; b=By6if+GqTkDCdMaIbsCsMkv34UNWf7XJZTvyY+4LD3Pr/yNj9PreJb9Y/Hj6Gau5TgPqqSfs9eOa7cvksH+5Y+5bJVZMrPL4tTzM8qFsOkUhxCyExwptFb669d9S5DnAEcXRftbMuxLrxp28vE728EfeYRAr6c0ZlA5I3rzdq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016947; c=relaxed/simple;
	bh=WosE5hh9Sv/fFx56qNr4f4210NgzNSdJlxeEBOocEeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuCc3zB6MMZ7xa0EOMMciRSrmery+6QFnJu5rYdGumsJbg0laG4rWrEzmsP4F7juxVTRQ+z8LRYZzBZ5dWwfYmr4+XWzVpMoApM7Uyz1kMJEA/I/5BgS2pcQyOhiS17kiOUt477+9Kd+gNFvOHWs8gzjU+tUMw1HRoUOvPXAQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvjHXLIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvjHXLIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9166BC4CECE;
	Thu, 12 Dec 2024 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016947;
	bh=WosE5hh9Sv/fFx56qNr4f4210NgzNSdJlxeEBOocEeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvjHXLIbfoiktE04uEvt3/qbiqi4ee75/tZaxctKUqS5THjC/GcbOqcSnw4oot+5x
	 oYLvJZ03aWSaS01Qw/VK4/YBjKu/xGyLJ/dVgZFf2ensDqQzVorRFIMp/iysyn6Dh0
	 N51JL9frECbgb7CpRSeJtfpEHQY2aLO5klx9mAcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/466] Bluetooth: btusb: Add USB HW IDs for MT7920/MT7925
Date: Thu, 12 Dec 2024 15:58:30 +0100
Message-ID: <20241212144320.263298446@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit a94bc93a305bdcb20cc62978c334cace932b1be0 ]

Add HW IDs for wireless module. These HW IDs are extracted from
Windows driver inf file and the test for card bring up successful.
MT7920 HW IDs test with below patch.
https://patchwork.kernel.org/project/bluetooth/
patch/20240930081257.23975-1-chris.lu@mediatek.com/

Patch has been tested successfully and controller is recognized
devices pair successfully.

MT7920 module bring up message as below.
Bluetooth: Core ver 2.22
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: hci0: HW/SW Version: 0x008a008a, Build Time: 20240930111457
Bluetooth: hci0: Device setup in 143004 usecs
Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection
command is advertised, but not supported.
Bluetooth: hci0: AOSP extensions version v1.00
Bluetooth: hci0: AOSP quality report is supported
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: MGMT ver 1.22
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11

MT7925 module bring up message as below.
Bluetooth: Core ver 2.22
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: hci0: HW/SW Version: 0x00000000, Build Time: 20240816133202
Bluetooth: hci0: Device setup in 286558 usecs
Bluetooth: hci0: HCI Enhanced Setup Synchronous
Connection command is advertised, but not supported.
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
 drivers/bluetooth/btusb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c247fffbd6361..b44c990bab422 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -565,6 +565,16 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x043e, 0x3109), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Additional MediaTek MT7920 Bluetooth devices */
+	{ USB_DEVICE(0x0489, 0xe134), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3620), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3621), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3622), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional MediaTek MT7921 Bluetooth devices */
 	{ USB_DEVICE(0x0489, 0xe0c8), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
@@ -638,6 +648,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe11e), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe139), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3602), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3603), .driver_info = BTUSB_MEDIATEK |
-- 
2.43.0




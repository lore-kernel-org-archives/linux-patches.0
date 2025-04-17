Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FDE2571B3;
	Thu, 17 Apr 2025 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914152; cv=none; b=oDvu5WVi9XjU4sR4AW2b1+M8sIQjsfPgythZdFRQPqb9oGJTe5Lzmg7Enb73tjDYCKj+XNAkpp2NQufJNJzv8V3rVM9RtMiNkufnxZeItgsyka2/DBpaGf9DINm1aXn0pGKW9uvhZCLhtd5EZtfgimWcGjPxgAJ7c3ncBFwnqqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914152; c=relaxed/simple;
	bh=Q45N6U4S/7rLyrMxe9IfBqMFtkQ5FnLHS1NlLGvK8V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2HR+QljkpkzYoR70niP+zhX2tFdFUPJ9SYLpWr7TavJSehtV0ZLJFVh6wwaohKsn/BJ0nnIulHCXdlpY56fEmt7JZ8Q7XEXj0PGkHMry/NPbPADYNH7adhxLu3Ewp4j3Qxp4dXaESmGHdjN7VMZGCURWkC5WifOH861SXX5JUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXWqbjZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXWqbjZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F9C4CEE4;
	Thu, 17 Apr 2025 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914152;
	bh=Q45N6U4S/7rLyrMxe9IfBqMFtkQ5FnLHS1NlLGvK8V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXWqbjZyJ2qFXR25PJQFeU+DdPxyxQwOq4YYabblWVSpsa26p5dyXucoxaOzC0XqI
	 CGOqIiBDjFlqM+dD/GQ4xCZFEtA9H1vOfKv4aAyB15WMYC+uFc+MZbaCv3o+jYcbz2
	 Ja9HyVHE9tvB+e6OA1xOcWeXHv5PlXxan2uy5UlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 124/414] Bluetooth: btusb: Add 2 HWIDs for MT7922
Date: Thu, 17 Apr 2025 19:48:02 +0200
Message-ID: <20250417175116.422909035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 11005d7d9cc0f..842c71d445dc0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -662,6 +662,10 @@ static const struct usb_device_id quirks_table[] = {
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




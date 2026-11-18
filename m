Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022650;
	b=tSh973cvqXSlD3b97udjAzjmgl389cDD+JmqKc8WqzAlQnEKTo+kojOpxlnVFFMFIU0o
	 ApOXAdI8yuZXkT4/HT+PjtwEXJf145tw9aW1wrt+nDxEHnMAGxyKzKMfzGQr/K/QcJ7Ho
	 ctKTOoa5gSuxzP0gnMV9mQFCLPST6oMmy1QTlw1m8wOo2mbYAq2xALUR2g1PjUSetlT53
	 8oOHpGZA1W094iYxgrDGJKX/jloEiezqr2dw2hndCqpeYQdZ5RSwUJV+BncC2h0ciZ3sp
	 0AuwVYUbPDQrSRGTG1gJVr/fOBYs7Xwzmh+Wa1Vm5vGrRf6T2hEwXU0PMc2tE+XhEQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EmNvydQ875RMrauadephmuVyFuFB3m9UATS3k1dS9Mk=;
	b=2og5ci+yymwtPabEnwZdLv9OBwv+wygvHRoNom7r9L1SKk4EWggz5caOAMp335zYJfC3
	 8ual4M+MW/wEPzwfKaxE2RaQdoE6ap7Jg0R53UmwJYsG9IQheG3VMM9IZe/iJE9d5HWP4
	 C5X35ccwxDCOogw44ffdska6RyFvwxETZPRJAJByfZTGC8Ns+zJ03BRpWhtTturC3agZI
	 SH9alT0MGXEglmFDXMPzHQZk1VWRSpYsi/6eP48KzMntqfNXlqLiPpd2iy76JhDLqwgn2
	 yaXkQvRQg1HzqTQbMv866z6aDmE1P2t6/17SgsKRUvEf4Ec9DilNeafs+IdmC2wnzZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KKafuqYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988B60A260A;
	Wed, 18 Nov 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KKafuqYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D36E1F000C9;
	Wed, 18 Nov 2026 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022650;
	bh=EmNvydQ875RMrauadephmuVyFuFB3m9UATS3k1dS9Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKafuqYQkl3w2G/FMRYTrESQyzBgCkRZ9DPxLGPkicyULc/D064fRUlgO+GRxMlW5
	 uT2/xZZWqiV+4zyDDRdaJsY6bi0Qw8qcW2Or56iqsGQ/9gkR4l5SF59hKwst67RhY6
	 ujiHjYNAXM5Ixz3AjpqfIR3j7A60chILvovrkEpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Tsvetinskiy <andrew.tsvetinskiy@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0051/2151] Bluetooth: btusb: drop BROKEN_EXT_SCAN quirk for 0bda:a728
Date: Wed, 18 Nov 2026 15:29:46 +0100
Message-ID: <20261118150123.593325419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit df5e35f1663abc2702cf9f9e7eba024129ac5df1 ]

Commit 5ead2063611a ("Bluetooth: btrtl: fix RTL8761B/BU broken LE
extended scan") set HCI_QUIRK_BROKEN_EXT_SCAN on every RTL8761B, and
commit ca0583c24661 ("Bluetooth: btusb: limit RTL8761B BROKEN_EXT_SCAN
quirk to 0bda:a728") kept it on 0bda:a728 on the assumption that the
USB id separates dongles with broken extended scan from those with a
broken legacy scan path. It does not. An 0bda:a728 unit (RTL8761BUV,
fw 0xdfc6d922) on 6.18.51 fails the same way the UB500 and 0bda:8771
did: LE Set Scan Enable (0x200c) times out with -110 and btusb resets
the device. With the flag removed from the table entry, scanning works
on that unit.

Two dongles with the same USB id need opposite settings, so the device
table cannot key the quirk either. The costs are not symmetric. Without
the quirk, the unit it was written for gets -EBUSY on LE Set Extended
Scan Enable (0x2042) while a connection is up. With it, 0x200c times
out and btusb resets the device on three reported units, two of them in
a re-enumeration loop.

Remove the flag and the table entry. 0bda:a728 matches the generic
Realtek entry again and runs without the quirk, as before v7.2.

Reported-by: Andy Tsvetinskiy <andrew.tsvetinskiy@gmail.com>
Closes: https://lore.kernel.org/all/CAE4bxw+ofDFVx0aTHqCrzns9oP1CRQDm_wzeyHPeMBYOhSpcuA@mail.gmail.com/
Fixes: 5ead2063611a ("Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan")
Fixes: ca0583c24661 ("Bluetooth: btusb: limit RTL8761B BROKEN_EXT_SCAN quirk to 0bda:a728")
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Adapted the patch to the Bluetooth USB driver's original source filename. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 5b8b71efffac9..1ee552949b95f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -67,7 +67,6 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
 #define BTUSB_BARROT			BIT(28)
-#define BTUSB_BROKEN_EXT_SCAN		BIT(29)
 
 static const struct usb_device_id btusb_table[] = {
 	/*
@@ -633,10 +632,6 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0489, 0xe130), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-	/* Realtek 8761BU Bluetooth devices */
-	{ USB_DEVICE(0x0bda, 0xa728), .driver_info = BTUSB_REALTEK |
-						     BTUSB_BROKEN_EXT_SCAN },
-
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
@@ -4349,9 +4344,6 @@ static int btusb_probe(struct usb_interface *intf,
 	if (id->driver_info & BTUSB_INVALID_LE_STATES)
 		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_LE_STATES);
 
-	if (id->driver_info & BTUSB_BROKEN_EXT_SCAN)
-		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
-
 	if (id->driver_info & BTUSB_DIGIANSWER) {
 		data->cmdreq_type = USB_TYPE_VENDOR;
 		hci_set_quirk(hdev, HCI_QUIRK_RESET_ON_CLOSE);
-- 
2.53.0




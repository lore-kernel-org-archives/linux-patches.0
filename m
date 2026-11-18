Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015014;
	b=F4g703UbZm4pwOlo10K1yUET8LgPw9MOvTET5p/0LF3l1IPdjXQ1K0HrLT81sm3/AfI1
	 voPzJjVU4X9K4EvmXTynIB5PJBAmGvb8FoLh5b56lb4xJI2EvIsfuNSB0fWrOoim35FwS
	 LzEMMitvsQACtEj0xCGL+4nr+5VfSPiFhtrnD8nLLosJ789UQz1hNnw6TCraSIa0XjbTi
	 bJhE16zl6XclQsdB1WfodhfzbKovmV9u87IP05ET4Dfa72KkFtaSIGqnr9pMpGGiQj/DH
	 IafRGaRQxhYdYmKnveSovouYxV+D1L7/jW1sYkcVG6zGU6kai/3dNJAMbkMe6i7F7rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UBvhBwTZ/7kgtIBD+HFmCvSg6jUlcdqo4PxkA1Tx1Zg=;
	b=Nq5Xb9HYGMBCHpecLZUa0UH32x7SNJtE/r1+z4ld0RGdPoQeMVdYXkZe0yFqr9tRvKN4
	 3SycoobcBCsGZF1dnnSeAE2jrbQ+7bYn8mkdGKtl9uHUC4QXlkBKCIRdGHfyNYEsJh2ed
	 U91SXrKR8ivPV3KcLjpPCxWN2aTSTKrNvn61Q6DM9JiF9vG2gmq9oqHUk38VE9ZmSW/MG
	 5WIZwTLtYevtfz2NjcQp1JgZm7ofSUYWeAZS8TOYHaze+ATH4IQwCde7fu9vFpQ9mXEu+
	 9kWcrZNyJAhRzNEVmvLRykrCRzOOnZk+1KosWXxCCy9xWrv53SzE1y7EhH56F+uhDMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKkxYzzl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096E4606A32A;
	Wed, 18 Nov 2026 15:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKkxYzzl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3081F000C4;
	Wed, 18 Nov 2026 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015013;
	bh=UBvhBwTZ/7kgtIBD+HFmCvSg6jUlcdqo4PxkA1Tx1Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKkxYzzlDl9Wd9HlrT4cq9c3z1edhnH6XZMqjkjrxDoL3jHzsrxFO8DWiPT0udywQ
	 dp22El3+VvBgOxTCYf+ARVSMJq90250tjYC0X5VyOaVoEfVpmfNIenRmRpKkyaklrN
	 0AiDSD1CORp7fjM2MsQRkxe4FbO61SJ9mc3EFQog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Tsvetinskiy <andrew.tsvetinskiy@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0022/2651] Bluetooth: btusb: drop BROKEN_EXT_SCAN quirk for 0bda:a728
Date: Wed, 18 Nov 2026 15:21:02 +0100
Message-ID: <20261118150248.784501544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to account for the missing BTUSB_QUALCOMM definition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/bluetooth/btusb_main.c b/drivers/bluetooth/btusb_main.c
index ece1fd426f12b..d0e5ab764e9dc 100644
--- a/drivers/bluetooth/btusb_main.c
+++ b/drivers/bluetooth/btusb_main.c
@@ -68,7 +68,6 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
 #define BTUSB_BARROT			BIT(28)
-#define BTUSB_BROKEN_EXT_SCAN		BIT(29)
 
 static const struct usb_device_id btusb_table[] = {
 	/*
@@ -636,10 +635,6 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0489, 0xe130), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-	/* Realtek 8761BU Bluetooth devices */
-	{ USB_DEVICE(0x0bda, 0xa728), .driver_info = BTUSB_REALTEK |
-						     BTUSB_BROKEN_EXT_SCAN },
-
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
@@ -4492,9 +4487,6 @@ static int btusb_probe(struct usb_interface *intf,
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




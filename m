Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DB4256C6E;
	Thu, 17 Apr 2025 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912739; cv=none; b=rJuO3cPTZd/+y7MC3+/8zd9i2CKQeoXe4w0bayZSAVigZSEVH1T9/sF3wPw7+GM2Wns2U/AipGG7M44a1et+OOsBU9qchsrrTQ7jKc6tm1Yu8k+MaOcMJO8sBH4s1TsPCt6RKwVaewnWK0rP/0Ode91P325Te5XmmXET/fAFJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912739; c=relaxed/simple;
	bh=LLge9MFSFOFuAUEYKvF/nHtAv+MPVjMfaZPnbDZ/a+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pealcd26loTPMGtdzqn0Hte7ROwCcprbKbfUUDssznZBrUvM2fkUeC0blfdtWJ0O+bVZNoNbctgTN44Vwa8U5NviFwqNUsN/Yq0EIusbAz3rudoU8w7zzbvJzvLMXDElGBsS+c1vwmDaC2Um2XFUFDOtbHEonPxlC2XmLXar6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKO2X+vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKO2X+vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D016C4CEE4;
	Thu, 17 Apr 2025 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912738;
	bh=LLge9MFSFOFuAUEYKvF/nHtAv+MPVjMfaZPnbDZ/a+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKO2X+vf4zwVxeRCJGOXB2jW3DLiwMuRIgOxj/hOl9P59XB//+3f3PZQ6LBuUSyKR
	 pM6gGxD2hBLLm7pEhruipa22tGettaY8gZJlE2km8YFM2BqSF2CTpEXbTY/WYhN4/A
	 Sv/AhzyFgZjnjnUXYKaREh73pG2h2j57ZXKpDH4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Schulze <max.schulze@online.de>,
	David Hollis <dhollis@davehollis.com>,
	Sven Kreiensen <s.kreiensen@lyconsys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 109/449] net: usb: asix_devices: add FiberGecko DeviceID
Date: Thu, 17 Apr 2025 19:46:37 +0200
Message-ID: <20250417175122.352730531@linuxfoundation.org>
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

From: Max Schulze <max.schulze@online.de>

[ Upstream commit 4079918ae720e842ed7dff65fedeb9980b374995 ]

The FiberGecko is a small USB module that connects a 100 Mbit/s SFP

Signed-off-by: Max Schulze <max.schulze@online.de>
Tested-by: Max Schulze <max.schulze@online.de>
Suggested-by: David Hollis <dhollis@davehollis.com>
Reported-by: Sven Kreiensen <s.kreiensen@lyconsys.com>
Link: https://patch.msgid.link/20250212150957.43900-2-max.schulze@online.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 57d6e5abc30e8..da24941a6e444 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -1421,6 +1421,19 @@ static const struct driver_info hg20f9_info = {
 	.data = FLAG_EEPROM_MAC,
 };
 
+static const struct driver_info lyconsys_fibergecko100_info = {
+	.description = "LyconSys FiberGecko 100 USB 2.0 to SFP Adapter",
+	.bind = ax88178_bind,
+	.status = asix_status,
+	.link_reset = ax88178_link_reset,
+	.reset = ax88178_link_reset,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
+	.rx_fixup = asix_rx_fixup_common,
+	.tx_fixup = asix_tx_fixup,
+	.data = 0x20061201,
+};
+
 static const struct usb_device_id	products [] = {
 {
 	// Linksys USB200M
@@ -1578,6 +1591,10 @@ static const struct usb_device_id	products [] = {
 	// Linux Automation GmbH USB 10Base-T1L
 	USB_DEVICE(0x33f7, 0x0004),
 	.driver_info = (unsigned long) &lxausb_t1l_info,
+}, {
+	/* LyconSys FiberGecko 100 */
+	USB_DEVICE(0x1d2a, 0x0801),
+	.driver_info = (unsigned long) &lyconsys_fibergecko100_info,
 },
 	{ },		// END
 };
-- 
2.39.5




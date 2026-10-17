Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACBD3AFB07;
	Sat, 17 Oct 2026 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256196; cv=none; b=TtgZ282bleBMjbsdx4JVeR6SHuWHb0HPB6s7Z93Ysc3oq+EhgWOTDRjt5ZvitbCnnrwKlCHIN2M2jtaoqetaLiqs5AmxeA9YZK+OsWzNY8aPVXNQmEhTzWB5eFt8iRzqX6u/guEV+QFIdwsTjN7gyQ3OEqs2zGu7ZIdop+S5BRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256196; c=relaxed/simple;
	bh=eUG0jNZLanl+14104K3vorU23ssQDJ9IDiAPkSOpvhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR2/N8QDgzgKtbbgTuvXw/u6XahBGetvVmwhCAJkl3q9tnT2fHOB3uSzCLQWOu5pRdqTAxnr54LwGeVsaf3hpw0o+Pr37mygxWxrUPyQy7p0m6dvPDwWa+8x3fwVk3jAN8XbBpdcb0VPlOahYqtJimUIgyrLckGg012/9lsWbGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzxmwzOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzxmwzOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0298B1F000C4;
	Sat, 17 Oct 2026 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256195;
	bh=krge7mAQULBSfJEL8FXs6AAOCVqm2INIui8lDdc6qbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzxmwzOkxzTNHQQiVI+LaJSJSLWMLdaPPvbi29Azc6UhG00acDUCvEXpbhfIrEMVO
	 EjlM6rYwqht1xqklRgkoNSmH2xCzVUlyQzm1in5qsH9vLfKhq2rAxjbhmpPwH3xRLi
	 2AMiyK48aiMR10D8Yj+eFzBZ1m/T8EIH0p8l+jTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tibor Harcsa <silurust@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0154/1674] Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table
Date: Sat, 17 Oct 2026 17:40:26 +0200
Message-ID: <20261017160435.117232111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tibor Harcsa <silurust@gmail.com>

[ Upstream commit dc16388d45ecbd3be0d8c9424dbbaa2c81806578 ]

Add the USB ID (13d3:3503) for the IMC Networks Qualcomm Atheros
QCA9377 Bluetooth controller to the btusb quirks table. This device
requires Qualcomm Rome firmware and wideband speech support to function
properly; otherwise, BLE scanning fails with HCI unexpected event
opcode 0x2005 errors.

The device reports the following in /sys/kernel/debug/usb/devices:

P:  Vendor=13d3 ProdID=3503 Rev= 0.01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Tibor Harcsa <silurust@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ced60cd806fbd..95becfdb0d2e9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -305,6 +305,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3501), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3503), .driver_info = BTUSB_QCA_ROME |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* QCA WCN6855 chipset */
 	{ USB_DEVICE(0x0cf3, 0xe600), .driver_info = BTUSB_QCA_WCN6855 |
-- 
2.53.0




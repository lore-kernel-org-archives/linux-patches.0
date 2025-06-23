Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F21AD3FA;
	Mon, 23 Jun 2025 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715609; cv=none; b=cvO7JAACgDYT5WWTbWwucFWIaX226kshr1cfi889cThnsRGuZL4Et9T2j9PZg85Nar3XCsjqetqB/1QMYOt9MU9jVp8TmQzd/8hoQF8Q2BJgomqda23lCF/Uae6/CFUaUiARVisz2jQ4MO4i8rW1yWT2edGkXzjC3qzMdcxDUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715609; c=relaxed/simple;
	bh=uLv4O3N48JAD3YeadlRVTSiO21B14xuPoN9TOL42B8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SId1HA6lX0vS7V4lfxmI4qyWv1j5IIdS399RsMoWH98PB6hISLZoB14kvSvM86c57GM/2xpTyH5IJ8NdTWz9BshaCHxxxiERyFXEboiSMnJTpOY8GwHT/uNOvyAG4/zYx060C11h3Esc4478Ry+itI/k4WkF5BzBtOuxNn9aE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M85hYzm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M85hYzm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB01DC4CEEA;
	Mon, 23 Jun 2025 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715609;
	bh=uLv4O3N48JAD3YeadlRVTSiO21B14xuPoN9TOL42B8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M85hYzm+NXPyEFoaJ3edT9z3gptOxia76XmvthyF/ntcYf3e5/T2k09kz7QAJskgR
	 uly73lQG5lcZwBLj5JLAgjci8QBA9EiYo8qyCUk+SVKO/QX6ENC7zAditPiFvLI/5t
	 3VMUf6IQGACDzNVjlJyLaSnUXGlP/L4zYWKKepJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liwei Sun <sunliweis@126.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/414] Bluetooth: btusb: Add new VID/PID 13d3/3584 for MT7922
Date: Mon, 23 Jun 2025 15:05:33 +0200
Message-ID: <20250623130646.914007411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liwei Sun <sunliweis@126.com>

[ Upstream commit 71d9d3522aec301e4a1c4eae4b5e0656fc4a7262 ]

A new variant of MT7922 wireless device has been identified.
The device introduces itself as MEDIATEK MT7922,
so treat it as MediaTek device.
With this patch, btusb driver works as expected:
[    3.151162] Bluetooth: Core ver 2.22
[    3.151185] Bluetooth: HCI device and connection manager initialized
[    3.151189] Bluetooth: HCI socket layer initialized
[    3.151191] Bluetooth: L2CAP socket layer initialized
[    3.151194] Bluetooth: SCO socket layer initialized
[    3.295718] Bluetooth: hci0: HW/SW Version: 0x008a008a, Build Time: 20241106163512
[    4.676634] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.676637] Bluetooth: BNEP filters: protocol multicast
[    4.676640] Bluetooth: BNEP socket layer initialized
[    5.560453] Bluetooth: hci0: Device setup in 2320660 usecs
[    5.560457] Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is advertised, but not supported.
[    5.619197] Bluetooth: hci0: AOSP extensions version v1.00
[    5.619204] Bluetooth: hci0: AOSP quality report is supported
[    5.619301] Bluetooth: MGMT ver 1.23
[    6.741247] Bluetooth: RFCOMM TTY layer initialized
[    6.741258] Bluetooth: RFCOMM socket layer initialized
[    6.741261] Bluetooth: RFCOMM ver 1.11

lspci output:
04:00.0 Network controller: MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter

USB information:
T:  Bus=01 Lev=01 Prnt=01 Port=04 Cnt=02 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3584 Rev= 1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000
C:* #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 3 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
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
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:* If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Liwei Sun <sunliweis@126.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index af2be0271806f..7be13d3c82bcd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -672,6 +672,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3568), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3584), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3605), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3607), .driver_info = BTUSB_MEDIATEK |
-- 
2.39.5




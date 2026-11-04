Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830856;
	b=RTi1HxYteOsk1RbKnMgIS4DmuqTwVw1XCcA4grGLMX3g0AbxXlKXeWI25Q8yZ0x93xm1
	 mvAQAC8uEWxE1ngNCCBVaEs/7QjBOSvn2gU62wmLl2aXLF9lffL0FwLC597O6u61ySJHF
	 zzA7mJOKupbE9pUrDnHkY5aBxBtDVr0nWtTWpqvwAEE8uVdyEwezAuIcd7CzgLvhqnb1l
	 KKxmVOX0SNxzo8Ay10EAETeI5CcNRA2Adl10pNhDn16Ax8FUDayrgt3XtGzZG2G4YbS/Y
	 H01ZkoW5c8i0hU26sjznCNCd1mrYivsEdTcIZVcS+VlLog8L2iRqyhd+g+6THE+ZfYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPXCvUojbTBhuVwK8h3gH9UAs0bu6/1y6nPqfwMidwA=;
	b=j2pWPGzh00dBbYvpbq9AoDYFVjttCNBJqf6iUnMEOwwZRiKR1aGrs0wcEzEx2zDZ1iH7
	 t1xosmhm1BnJLmPyZVeGiC36BGTX1TI1yj/bOiaoY8cPLkFKuqN/IMrsaNhRBFRBRISAx
	 X8YqKPCzz5qd0bMTL36RRC+s4Hq2fRA9DFGB8WsA7aEFwNHWcxP4w3R0fZXdhoJmTudFG
	 OPa4uHKZetc43STeFkLTq126/mqMSl7t/91chswNVHxzhiGuAT/D5lIT+FFYKB25LsYyj
	 iNWFYY2haPrbJETLOfghmkxBDq5b64ioYI7FpCBBAXM65O2uhF3j1rKqAIwJUvtlheg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQTX+zw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC87606CA39;
	Wed,  4 Nov 2026 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQTX+zw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB8A1F00919;
	Wed,  4 Nov 2026 22:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830856;
	bh=JPXCvUojbTBhuVwK8h3gH9UAs0bu6/1y6nPqfwMidwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQTX+zw+lXfsYqA14QmyZdAILv1SZPLt2ctLGB3mi4swBrLbC/td82c+vc2oCojC7
	 1WStcdBzPHNSLaD129RZIQ9rVQQAJLFhkHx55BN1CoXbU6rOgYbFAhyTTxW8juEmHg
	 KPJb7snN8d9WQ6n1j8ZmoPzTcuNCKfSiB0wZdQZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Evgucci <monesss315@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0345/1005] Bluetooth: btusb: Add USB ID 13d3:3625 for MediaTek MT7922
Date: Wed,  4 Nov 2026 16:01:18 -0500
Message-ID: <20261104211053.632270794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Gustavo Evgucci <monesss315@gmail.com>

[ Upstream commit 849a3bf1489093996859ba0c3c1c0cd314d6ff96 ]

The IMC Networks MT7922 Bluetooth adapter with USB ID 13d3:3625 is not
recognized as a MediaTek device because it is missing from the btusb
device ID table. As a result, btmtk firmware loading is never triggered
and the HCI reset command times out with -ETIMEDOUT.

Add the device with BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH flags,
consistent with the neighboring 13d3:3627, 13d3:3628 and 13d3:3630
entries which use the same chip.

Tested on: MediaTek MT7922 (Wi-Fi 6E combo card, IMC Networks BT USB
interface), kernel 7.0.11-arch1-1.

/sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=01 Prnt=01 Port=12 Cnt=03 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3625 Rev= 1.00
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
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Gustavo Evgucci <monesss315@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 59fff918fd2de..9257341b01399 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -788,6 +788,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3613), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3625), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3627), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3628), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0




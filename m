Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA0F347BCB;
	Tue,  6 Jan 2026 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719789; cv=none; b=o1dW2cax+4TVEa23RuBI8JFa1o0Dg/XR+YDJ8fjq7KEyu7Y6nbLUSrkMsJis3mJefDxKHsGgyoyMiTBqmNpeNZDlo7S9OBSfg5FGzIsXdsD2dp75T7wYF4Flye5HPHgy/1drfMXx5Rw10j8f5eYWa3HOBTW41n2OQXz4O8MQhx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719789; c=relaxed/simple;
	bh=aA77rem3ittOXDyqT2/nyLUCiQNdKTtgyAKtAIDg610=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpru9sFcEi1c+qshUL+uj9MFxFFRuUD7ROTg/pnNx6UwDCLn9LTV2mpRh2nnwYxuXVhu/R1VAPDoA7GCe6Hz57gSGk3ysHH7OAWLHDeCoMxCdwxebZYKCnuDtvjFfwzpms334Eqzxi9+Qb0VXogJlAts8w/428pn9gK0WOZbvc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCZOBSyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCZOBSyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9517CC116C6;
	Tue,  6 Jan 2026 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719789;
	bh=aA77rem3ittOXDyqT2/nyLUCiQNdKTtgyAKtAIDg610=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCZOBSyYRiPLaDVhdXd5TBd2D6qWSO+Crxo5Lc8OgKCsJv4SfAuQM7+yPLKwdUTmv
	 zl2jm6VuMOblsynxqOa3E83dIpjSasSzBrX81/lcw6aC3tegLDUGpTTcPV7/JwZd6W
	 bRsCbGt7+Yn+Yy34w9Z0eDjNRhb3Hsgk6JEMjf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/567] Bluetooth: btusb: MT7920: Add VID/PID 0489/e135
Date: Tue,  6 Jan 2026 17:57:03 +0100
Message-ID: <20260106170452.861090483@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit c126f98c011f5796ba118ef2093122d02809d30d ]

Add VID 0489 & PID e135 for MediaTek MT7920 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e135 Rev= 1.00
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
I:* If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:  If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9dc3a50c5e833..78dc9012c5d75 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -611,6 +611,8 @@ static const struct usb_device_id quirks_table[] = {
 	/* Additional MediaTek MT7920 Bluetooth devices */
 	{ USB_DEVICE(0x0489, 0xe134), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe135), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3620), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3621), .driver_info = BTUSB_MEDIATEK |
-- 
2.51.0




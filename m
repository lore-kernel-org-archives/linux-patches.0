Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3657F4C62;
	Mon, 23 Jun 2025 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713334; cv=none; b=GAxEwTbZjjiIDWuZRmTfn2KFZJFfZ+a/E54uQ1gnrsMakWfBolszkPmJQpsw3HBVfGYAQQG32qaZCHEj3tg1kRQNSpkR35QhWYfP+JEEWeXLb96xNJs1AA6uEiqTExvimy0CxMnw/AgROdwTzegSn503957EyCRPWItxhx6wpMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713334; c=relaxed/simple;
	bh=OkEHCcMRLJcup6jgN4c8tU+Y3wPsOio+zmt2hmmALN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncqKkAv2J0oM8Vo9pJVmj0HX1WK2FsZnT2LUtrLOU3+qzqIO1KqSnGIvVhlW28o/a13ZooLH7Q83+EOSuomndeMeTgmWaEVD+teNmusRh1t4GWXn/ihOy83DsYe+fE2YTKKm7DVGco9iDrgbTv+HMiMZrfxys+TnOcR9hOLE7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsqgudFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsqgudFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1C5C4CEEA;
	Mon, 23 Jun 2025 21:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713334;
	bh=OkEHCcMRLJcup6jgN4c8tU+Y3wPsOio+zmt2hmmALN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsqgudFAzRe4/NE/o8HnASRgwDBp5WZliHLvJ8xhSHpZG3bZnIp8DUAk5iHBLHod/
	 UitnvwH+XyTuQzM59PYXfFwq81hGg/kA1Y7DrDMlsHruuMKoVtItq+UZh+ryoHEqYJ
	 1QBuv5bw2+VzOY4Nv11HfyU+/3VCODSbJyMblD44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Li <lihao1@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 321/592] Bluetooth: btusb: Add RTL8851BE device 0x0bda:0xb850
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130708.075585250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit c4dbb1bdada90168dd5fa2f7e4553cb0e1dad3c8 ]

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below:

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=b850 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Co-developed-by: Hao Li <lihao1@uniontech.com>
Signed-off-by: Hao Li <lihao1@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c7c3cd0dcd49e..ef9689f877691 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -513,6 +513,7 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8851BE Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
 
 	/* Realtek 8852AE Bluetooth devices */
-- 
2.39.5




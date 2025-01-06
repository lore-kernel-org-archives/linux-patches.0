Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE52149C7B;
	Mon,  6 Jan 2025 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177068; cv=none; b=Ardk454zyZblsTdA+uPEN5i+flSJp56HwqFWbflq0PT3TRQ1Xk+Ref8IfbI78Qz4CPq+ZN4ES0OzhPaaJe0papsrF2H4Vp2GYnjQw7F7hPfw9W6uZ2F6ZA16qt6wMfBC0l/0jiJHmu6ZBjlCNNJ9D0mcea2feIJVwnmcXin/B5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177068; c=relaxed/simple;
	bh=IRFYzqsidqU3Kw+bWCyCO2QVp9HbnNXtqGwPO/l5BdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6UAPetVBfJUPiBiJMHD+vMVtFsiR2GgEuwEvjfj0Ad+PrbuVMt9JGihp+s1/i+G5mNRJrU36reVSneP/5OFVU+RFCNeFs730WLQMy8MiDvnhhFXyasOkk9pdmKTnYdAkZAm16O1nd8eluAasSwNsuD3Ep3A230HPvuHnogLuYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LaqePTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LaqePTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B87DC4CED2;
	Mon,  6 Jan 2025 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177068;
	bh=IRFYzqsidqU3Kw+bWCyCO2QVp9HbnNXtqGwPO/l5BdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LaqePTNpyrpn6Gq5Xf2mP2MCIEQbW+Rzeg2iV3Nv0QaE+J5J+FTOKw14e8igdpRE
	 LZcUi0y9cUPtGy/HCZgw/9QjTbHgYeS/YlLVdyYDy/0CfYgzpwJJJOCVJ29zZdf8Ff
	 M1ZJ64x/LNPTUz0BIvF50HJ7kbUFW4+4UVUTZSkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyang Wang <wjy7717@126.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/222] Bluetooth: Add support ITTIM PE50-M75C
Date: Mon,  6 Jan 2025 16:14:04 +0100
Message-ID: <20250106151152.120009549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyang Wang <wjy7717@126.com>

[ Upstream commit 00b1c3c4b682ba4b4f9fc46e047b537e668576af ]

-Device(35f5:7922) from /sys/kernel/debug/usb/devices
P:  Vendor=35f5 ProdID=7922 Rev= 1.00
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
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Jingyang Wang <wjy7717@126.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: faa5fd605d20 ("Bluetooth: btusb: Add new VID/PID 0489/e111 for MT7925")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fe5e30662017..6b0d9d9f3004 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -658,6 +658,9 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x04ca, 0x3804), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x35f5, 0x7922), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
-- 
2.39.5




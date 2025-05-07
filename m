Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A381482F5;
	Wed,  7 May 2025 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644331; cv=none; b=IpOwPaztPu4t/YuSyASAFkIjQaolA0c3Z3CnVPAZmoqwp+Aao2FjtBOhX353UpdebpnQOPO0gyXTeHJXhc10CLeFtdkvBM3iDFkBK9b6MWnqFiXNXpYU7FrmeRAoR1AJn6CGP6O7Uf81g6qZaDnTD93sRmM+4u2MS0RnAeiTw6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644331; c=relaxed/simple;
	bh=p0FH8Ulu1tIT68VGnbeYgvXQW7r3avB9WYKvi3iGh4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIugXxTQsrodZ18Wino5iASUb4e1kcC8nEnZFk+LvOF68OC/UKBXrsuYDuWgHxS6dcuksBUUaYuAxTJCvFV5CpTNBkYGxETaWr+PM0vSS1U4O5zjx4Xu8TF8SZqhqKYYmqFGltOV6Ngg27qMjZTtZbUL8Hmxjp4yvkS9T9Es4Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwW/VfMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwW/VfMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A760AC4CEE2;
	Wed,  7 May 2025 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644331;
	bh=p0FH8Ulu1tIT68VGnbeYgvXQW7r3avB9WYKvi3iGh4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwW/VfMTRKnOwzqTz4ZMI3oE4yOlXsa07U1JZLttIJIs3XcTzDyw8m07HtGhiDgAc
	 nYB9FT7bJHWlspMn/f+l+XE8vd6ydU5LPWFyiq/RmW6p4tEMfR9W0zvOpZ9LkCBgg6
	 FcnFXjCd5HAQ1KNsc+hlT3JdiYnqNqCnfp4HxEJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Alexander Tsoy <alexander@tsoy.me>
Subject: [PATCH 6.12 001/164] Bluetooth: btusb: add Foxconn 0xe0fc for Qualcomm WCN785x
Date: Wed,  7 May 2025 20:38:06 +0200
Message-ID: <20250507183820.851428457@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit add1b1656f909c41aa0186fe75e7a42e2c0d2188 ]

Firmwares are already in upstream.

kernel boot log as following:
Bluetooth: hci0: using rampatch file: qca/rampatch_usb_00190200.bin
Bluetooth: hci0: QCA: patch rome 0x190200 build 0x5656, firmware rome 0x190200 build 0x43fb
Bluetooth: hci0: using NVM file: qca/nvm_usb_00190200.bin

Paired BT headphone, output is good.

T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e0fc Rev= 0.01
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
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
I:  If#= 1 Alt= 7 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  65 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  65 Ivl=1ms

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -371,6 +371,8 @@ static const struct usb_device_id quirks
 	/* QCA WCN785x chipset */
 	{ USB_DEVICE(0x0cf3, 0xe700), .driver_info = BTUSB_QCA_WCN6855 |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe0fc), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = BTUSB_BCM92035 },



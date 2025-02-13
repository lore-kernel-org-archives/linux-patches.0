Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548B91DC745;
	Thu, 13 Feb 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458778; cv=none; b=N1gNwgfIsstWk5ZJL4UueYhhlFkWSJ6Et6dcfxX0GDH+4PUjnmGrkXxpaqrdCsd0DYyVkmkz7FJJE/37mOY/U1/wNqYTTjhJskYdFiwtDnStgCD2RciFBMExY9Cy6sHzJ4VOW2RRuAan/9grlJDti3j8RAtKGL6JjTqEegelp1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458778; c=relaxed/simple;
	bh=fmS5C1LRCqYc8QZJLDCBNVGBky4t9/jap1whUIq5lV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/rvSkulIIv5/WbApV7fzR7xXvDU/KVE9X7J5XguzV7SfzYqg0c57+EexU7kMEjuarFeJllT1/ysp72rpCICJqdlL/pNklkOJ9p/FKxKxPw7eCqmrR3sFk+LdXocpvKWCyV75ybhFISbHpcWRl2XvWLN/SGlcuPQRqojaZyu3Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1YY76AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1YY76AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43DEC4CED1;
	Thu, 13 Feb 2025 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458778;
	bh=fmS5C1LRCqYc8QZJLDCBNVGBky4t9/jap1whUIq5lV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1YY76ALhzBlvXWAhMYM3R35u9f4c6daH2QehK9BL3e+Epkb4p9Q0FcFpnOCf1zNT
	 r6AROIkSQlFqVwqLK8sZVuztMAO5MHil6Rcof5clIJ/FhN9URaRvurumjJ1d8bnq/w
	 yV1mCRWozmphUBnvJ0n9gzThMBtDjstABns1HOR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ajhalaney@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/443] Bluetooth: btusb: Add new VID/PID 13d3/3610 for MT7922
Date: Thu, 13 Feb 2025 15:24:01 +0100
Message-ID: <20250213142443.547601967@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ajhalaney@gmail.com>

[ Upstream commit 45e7d389bf2e52dfc893779c611dd5cff461b590 ]

A new machine has a Archer AX3000 / TX55e in it,
and out the box reported issues resetting hci0. It looks like
this is a MT7922 from the lspci output, so treat it as a MediaTek
device and use the proper callbacks. With that in place an xbox
controller can be used without issue as seen below:

    [    7.047388] Bluetooth: hci0: HW/SW Version: 0x008a008a, Build Time: 20241106163512
    [    9.583883] Bluetooth: hci0: Device setup in 2582842 usecs
    [    9.583895] Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is advertised, but not supported.
    [    9.644780] Bluetooth: hci0: AOSP extensions version v1.00
    [    9.644784] Bluetooth: hci0: AOSP quality report is supported
    [  876.379876] input: Xbox Wireless Controller as /devices/virtual/misc/uhid/0005:045E:0B13.0006/input/input27
    [  876.380215] hid-generic 0005:045E:0B13.0006: input,hidraw3: BLUETOOTH HID v5.15 Gamepad [Xbox Wireless Controller] on c0:bf:be:27:de:f7
    [  876.429368] input: Xbox Wireless Controller as /devices/virtual/misc/uhid/0005:045E:0B13.0006/input/input28
    [  876.429423] microsoft 0005:045E:0B13.0006: input,hidraw3: BLUETOOTH HID v5.15 Gamepad [Xbox Wireless Controller] on c0:bf:be:27:de:f7

lspci output:

    root@livingroom:/home/ajhalaney/git# lspci
    ...
    05:00.0 Network controller: MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter

and USB device:

    root@livingroom:/home/ajhalaney/git# cat /sys/kernel/debug/usb/devices
    ...
    T:  Bus=01 Lev=01 Prnt=01 Port=10 Cnt=03 Dev#=  4 Spd=480  MxCh= 0
    D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=13d3 ProdID=3610 Rev= 1.00
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

Signed-off-by: Andrew Halaney <ajhalaney@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 41132d02fd7d9..744c34a5e4774 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -612,6 +612,8 @@ static const struct usb_device_id quirks_table[] = {
 	/* MediaTek MT7922 Bluetooth devices */
 	{ USB_DEVICE(0x13d3, 0x3585), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3610), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* MediaTek MT7922A Bluetooth devices */
 	{ USB_DEVICE(0x0489, 0xe0d8), .driver_info = BTUSB_MEDIATEK |
-- 
2.39.5




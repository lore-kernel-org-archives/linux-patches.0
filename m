Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA373D6664;
	Fri,  4 Sep 2026 05:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499269; cv=none; b=DZVN4w4DC3xcmMGtcz/0WnavuHrRHUgMPOHD3SBB1DFIKnrAmcbik8Xgob6zgqKmTl2lSsbE5vSCITXt2WwRQ+w691HpepcZobK9zHeonmPpISRcfILY6v86xdB4bc0muACw7SuDGKxGdtkuZDWuPIyLA7vxfGmohk2nb1j49VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499269; c=relaxed/simple;
	bh=3qX0aGIyR+nSYq7NtW/OFtS/XoGrkDo7GLgbuZFwtpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyiQq2soDO77TrGNHGQB/PtxGo9oe7DlmKbltf6y4rYnEZjVy95rNThCZrGJf7k0FMj8WprYo11ALlJu//pcUF+nq7pirWX4/ZSBy5UFvUqPnQO7vOOxFAyEuhLUZ4HOsogmdbNAT1q74stANWuT2AD8six8O4FiCD6n00zLgS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B4Qog4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B4Qog4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77FC1F00ACA;
	Fri,  4 Sep 2026 05:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499267;
	bh=fsaMh9YBRKySe32l8zDT4SHlYpBanVmFYoy+zbJtmwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0B4Qog4BzE36cX0jkgMccAumjY5+EyLJfGQ/7gB3X2nNkxGZSwbyDz0fg2ESaMrwL
	 3tj0U2MThVjJmKPjHHQLamIOr44NeMKtCAk8jBxEDTwEoaMpROkG5rDv3EV87IA/T0
	 sd2Isgz+ViPQ8an5tUrJP3T18RQD7Vnp9HcEWHKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Zwerschke <cito@online.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 314/713] Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU
Date: Fri,  4 Sep 2026 06:54:42 +0200
Message-ID: <20260904045810.872012956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Zwerschke <cito@online.de>

commit 980084de4d9b25193398d89a1c0430ba3501b683 upstream.

Add the vendor/product ID (0x0b05, 0x1bef) to the usb_device_id table for
the Realtek RTL8761CU-based ASUS USB-BT540 adapter. It binds via the
generic Bluetooth class today, so BTUSB_REALTEK is never set and the
rtl8761cu firmware is not loaded, leaving the controller non-functional.
With the entry the driver loads rtl_bt/rtl8761cu_fw.bin (already shipped by
linux-firmware) and the adapter works (tested: A2DP and ASHA).

Similar to commit bc597f0cc44f
("Bluetooth: btusb: Add TP-Link UB600 for Realtek 8761BUV").

Device info from /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 22 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0b05 ProdID=1bef Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Controller
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
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

Cc: stable@vger.kernel.org
Signed-off-by: Christoph Zwerschke <cito@online.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -850,6 +850,10 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Additional Realtek 8761CU Bluetooth devices */
+	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },



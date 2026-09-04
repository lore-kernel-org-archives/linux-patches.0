Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F084E3ECBCF;
	Fri,  4 Sep 2026 05:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500911; cv=none; b=H7MHfEgoDuC8wAImmEO5hbKtrnsNdhHNd1m2L/a8KQYjC7snFHDO36H7oESvwVFWL1nVMTCLIkVqpQEONO/+GENyH2TbFFjdR2oUFnRepJJsihosTb5U9+P9W/c4GQM/RQD2wmsJRuaikvP1dSEQS/zEUX5pDBeYLxuIyEMe6Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500911; c=relaxed/simple;
	bh=7zqwvXDALoCBUmx2P6UyNis22F1J5BfQPdI4GdXDQ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhaH3BtxkHJbAHYX9SvzpYZtKldDQEbKQ3RNRMciBpgnUFCnQhDP5Eo6SXNfHzgjMQL2yZ3sxRr7XzzmemH4iJsH485/HtnpDDoByLaF8uWFS7NK9TSU/rwgHs2Y6ilUZHpHK0/BtxPUm0MfUBUucGVqRuCpZbmtrBkxYasaCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIXcjevV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIXcjevV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451171F00A3D;
	Fri,  4 Sep 2026 05:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500909;
	bh=GpBdm13ufNRiZMN1JdSPTJmiVSQvoRd8lWEe52Map98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIXcjevVFLyVlm+iR76Wc1sdFDKP5XG0mB5PqdSZU0SNKJ0w6iyP/8yY06EZ3DiIf
	 YADW3hCrPTyOUq2JQ+6X8cLs8IkT9xdH+hJx/2GZVnGv/3utPzqEQAXswvZnFl6RU3
	 aYTF6j2RIM9yksQ0BKN+fFdxJjbPhuOk9JQv1fHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Zwerschke <cito@online.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 224/552] Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU
Date: Fri,  4 Sep 2026 06:56:21 +0200
Message-ID: <20260904045754.572032923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -805,6 +805,10 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Additional Realtek 8761CU Bluetooth devices */
+	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },



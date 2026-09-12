Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBF6361DA6;
	Sat, 12 Sep 2026 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227053; cv=none; b=XhZa9sJbcC/tro+GmK4r0MIzrE5b7aYrjLXRc1qvDJq6pWh6/PYihhmn7GyK7RTLqWBoEGqfgRSyreFGWJJTfiI2yGMyG8xwNSh1c8G4C0BGgd1vq2W6Oteg9RtQuQGz4KPbuhOlOhYqrJvOvYZ8e588mxUTvW2C3LrNuxsOAHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227053; c=relaxed/simple;
	bh=kl0m1ukeRlQwaTBj0iCBTJMAEjv3th3Z0+EhwklMUwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO5EGRyAUez4RnJerRHLtORDoQEKTrdAR9ZBSyt75k7npDsOQBo31MR8VSmThwQLiBj94FNy2oVTxkWOjHgGtnrv/eCCI6Kps1ZNBJsbsGxisQZycgRxuaZ/wyiCuCh0sAaNHynp7mVUybGlunFrJwN935LXAQCeGhyCm8VPwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFKATQ/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFKATQ/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE911F000FF;
	Sat, 12 Sep 2026 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227052;
	bh=egn/4lbrMBpV6IpxGiuJVVl5jcS+l7d/VBpEW2WEIMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFKATQ/fBHfUsSSuAZ6Xp1z06lmvE7HeOk5b4CbHDJw1TZaAk9XHsTKjpG768ZBcT
	 kwwAi2zMktLoyfG8SSV98VivP38tMIDUvaiaU5bq+tozmc2FKAm/Lk/saLWIz6xEot
	 1OwpfSqjuxkK16lue0N3sXO3MADaFze3t9oKT6Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Zwerschke <cito@online.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0100/1191] Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU
Date: Sat, 12 Sep 2026 08:47:08 +0200
Message-ID: <20260912065550.427173601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,6 +670,10 @@ static const struct usb_device_id blackl
 	{ USB_DEVICE(0x7392, 0xc611), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Additional Realtek 8761CU Bluetooth devices */
+	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },



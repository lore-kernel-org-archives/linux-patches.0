Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C42FE582;
	Tue, 12 Aug 2025 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026827; cv=none; b=fzoFHDe+sDcpr0+6Mtx4WocdbVx3/n/6x+PMUWOj11vN0AKmso6/kg5w3+aTLk6gQVHJ7vLc2yjv4UTNzESLHHLrBgPqC0X4J8c8rJ3WeKczUD2Fk1uGGv1ZYGTIeVhmeLaf3x2GRY+tnDwojI+c+WaRNVUH7yslj5PcKWWFcjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026827; c=relaxed/simple;
	bh=5O6Q9l+99JHboXQibLDhUsBzvJhGhD7XDBNSDtj6lgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RraMT8qpv/7Hfk9c0NH/37p5DSGkw2G4LPp4TglNghxfH/Gws652Yvj4aa998oo/eqEEsA5E7pKXM1VPfUUDKzN34/eznC/VGKSSje+gCLpbNe62Pw9dpsdPzOFnq9Lm94+RVhfoviSm0JApkNnV9+V2nWsxADapAJjCFLmF9Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zeoe1fMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zeoe1fMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FEBC4CEF4;
	Tue, 12 Aug 2025 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026827;
	bh=5O6Q9l+99JHboXQibLDhUsBzvJhGhD7XDBNSDtj6lgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zeoe1fMG9Hu0y8q6C5ab7BwSbGoAdPaLkEpKfb1Lw/zBEI5dmJDN6gcI2Jy0ZyVAb
	 4YvXh7UMrxgw0Q7n5Cx2OtuMfzh7m9hKAHCDYA4YKnA75p+s7EPld2IthVOtgb5Bi6
	 01ESJJ4nosSzND7BkcBQO2OBbpc+6WHwZV6GSLH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.15 453/480] Bluetooth: btusb: Add USB ID 3625:010b for TP-LINK Archer TX10UB Nano
Date: Tue, 12 Aug 2025 19:51:01 +0200
Message-ID: <20250812174416.081671241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Zenm Chen <zenmchen@gmail.com>

commit d9da920233ec85af8b9c87154f2721a7dc4623f5 upstream.

Add USB ID 3625:010b for TP-LINK Archer TX10UB Nano which is based on
a Realtek RTL8851BU chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below:

T: Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 9 Spd=480 MxCh= 0
D: Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=3625 ProdID=010b Rev= 0.00
S: Manufacturer=Realtek
S: Product=802.11ax WLAN Adapter
S: SerialNumber=00e04c000001
C:* #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=500mA
A: FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
I: If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
I: If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 25 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 25 Ivl=1ms
I: If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 33 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 33 Ivl=1ms
I: If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 49 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 49 Ivl=1ms
I: If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E: Ad=03(O) Atr=01(Isoc) MxPS= 63 Ivl=1ms
E: Ad=83(I) Atr=01(Isoc) MxPS= 63 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 8 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8851bu
E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Cc: stable@vger.kernel.org
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -516,6 +516,10 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
 
+	/* Realtek 8851BU Bluetooth devices */
+	{ USB_DEVICE(0x3625, 0x010b), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0x2852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },



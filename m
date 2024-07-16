Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E561DDCE;
	Tue, 16 Jul 2024 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146273; cv=none; b=FbqBlrX1DImq4MxooQAi9CIWxZpRubSSb8dI8rrY0lMzYdvWUg5LVnz/FHcRh+KtZ5M6Bdt6a3NS1Xxxvj1ZqnNI3Vv3NkDDi2AIvqubko54yn6rlV4bsTEjdK0lie6pSiMLzyc0DQIuR1qJ9h+UNH3yot3LuYJybubYdH5c9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146273; c=relaxed/simple;
	bh=5R3sOBhCFwYVN3vt0M98FkAFjmw6PDcwQCmaFoO7CYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkis5lFGISlGNuePZ6Hbaz0RqjWcErldGtjxjGsSqqVqgDKQ5rgTO/A34G6sI99DuqN4be7XZEa5m0MsZ7L8EDEM/n8lbIcgemqKqxmmfOT6llKh1Ix1iV/t3CqJ7aZEOE9Bs8w0dX+Pjj842fbt6wQC0CwOVMdEJXhsBWSDpUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMX2StkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMX2StkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793D4C116B1;
	Tue, 16 Jul 2024 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146272;
	bh=5R3sOBhCFwYVN3vt0M98FkAFjmw6PDcwQCmaFoO7CYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMX2StkUV2P8c20ZSn56sqyT84xHdN+lOoJTdBudpSF71w1aFHhi8/9p9AIYlwzJW
	 uX/n3Ruvk9ZPHMKy6R5wtCWAwpH5bHejRJklE3rrEMnLBTMxJfWJx0wsp/crLKGWGg
	 rYfmiC/DMcOVQsWALm2aHFKcODO8TLkMIKnIlKcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mank Wang <mank.wang@netprisma.us>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 111/144] USB: serial: option: add Netprisma LCUK54 series modules
Date: Tue, 16 Jul 2024 17:33:00 +0200
Message-ID: <20240716152756.796165675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mank Wang <mank.wang@netprisma.us>

commit dc6dbe3ed28795b01c712ad8f567728f9c14b01d upstream.

Add support for Netprisma LCUK54 series modules.

LCUK54-WRD-LWW(0x3731/0x0100): NetPrisma LCUK54-WWD for Global
LCUK54-WRD-LWW(0x3731/0x0101): NetPrisma LCUK54-WRD for Global SKU
LCUK54-WRD-LCN(0x3731/0x0106): NetPrisma LCUK54-WRD for China SKU
LCUK54-WRD-LWW(0x3731/0x0111): NetPrisma LCUK54-WWD for SA
LCUK54-WRD-LWW(0x3731/0x0112): NetPrisma LCUK54-WWD for EU
LCUK54-WRD-LWW(0x3731/0x0113): NetPrisma LCUK54-WWD for NA
LCUK54-WWD-LCN(0x3731/0x0115): NetPrisma LCUK54-WWD for China EDU
LCUK54-WWD-LWW(0x3731/0x0116): NetPrisma LCUK54-WWD for Golbal EDU

Above products use the exact same interface layout and option
driver:
MBIM + GNSS + DIAG + NMEA + AT + QDSS + DPL

T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  5 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=3731 ProdID=0101 Rev= 5.04
S:  Manufacturer=NetPrisma
S:  Product=LCUK54-WRD
S:  SerialNumber=b6250c36
C:* #Ifs= 8 Cfg#= 1 Atr=a0 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=0e Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 7 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=80 Driver=(none)
E:  Ad=8f(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Mank Wang <mank.wang@netprisma.us>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2333,6 +2333,30 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0115, 0xff),			/* Rolling RW135-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0101, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WRD for Global SKU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0101, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0101, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0106, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WRD for China SKU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0106, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0106, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0111, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for SA */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0111, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0111, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0112, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for EU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0112, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0112, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0113, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for NA */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0113, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0113, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0115, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for China EDU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0115, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0115, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Golbal EDU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0116, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x40) },



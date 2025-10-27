Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7067832C329;
	Mon, 27 Oct 2025 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590925; cv=none; b=XGOkTtucVbhlS65P+gM7gV5ecRL7xwgA9m/C7meKiXrGy64dr7/SN2Ew5lLEqVx2x7kEL/H5I3FreWEvCI91rY+VOlj5Fu/GJG6NA6Pli2rJG+pjBloIYQ+YOBB455ibY/bWjfEOxMRyKP8rDUCxQjzH0R1zISpP1Hp0qMHOA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590925; c=relaxed/simple;
	bh=YbKyjmNLcc0oHpMNUKf3Mc9jVZZDEzLsu8bIwipHKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyI362SmerRTifFCEq7lcip1lOODGZ8IeqrvNB95p8kdWpXkx9ewlxA7lQEz7ZAowijQA/Z5oYDzQTmCYF62xMRtGuJbGt34dpdSHeWAmT4T4emSq7XbFikrgxOU/0k0KHdTj6gLBxt+u4RjZzjs1Y2vUgIHf+ylpXeHPN0okk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC9u0Gd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC9u0Gd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAA4C4CEF1;
	Mon, 27 Oct 2025 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590925;
	bh=YbKyjmNLcc0oHpMNUKf3Mc9jVZZDEzLsu8bIwipHKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC9u0Gd4SVEJDFkNCaKKPvkhBsnLY4R3yTh84daqczJr+QdvNH3XMn61WY0kMsEvh
	 +smzL0qDwZ3RuxOMEI4Wd5QR9DGd0tjsjsdTXu4/b+aD7L8mCQyiBLGHNlhZzvYyHc
	 0c4FWJn0CpwClfyvrcny3xpYlyLAXPq/9bekps/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinhard Speyerer <rspmn@arcor.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 201/224] USB: serial: option: add Quectel RG255C
Date: Mon, 27 Oct 2025 19:35:47 +0100
Message-ID: <20251027183514.176249828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

commit 89205c60c0fc96b73567a2e9fe27ee3f59d01193 upstream.

Add support for Quectel RG255C devices to complement commit 5c964c8a97c1
("net: usb: qmi_wwan: add Quectel RG255C").
The composition is DM / NMEA / AT / QMI.

T:  Bus=01 Lev=02 Prnt=99 Port=01 Cnt=02 Dev#=110 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0316 Rev= 5.15
S:  Manufacturer=Quectel
S:  Product=RG255C-GL
S:  SerialNumber=xxxxxxxx
C:* #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=86(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -273,6 +273,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_EM05CN			0x0312
 #define QUECTEL_PRODUCT_EM05G_GR		0x0313
 #define QUECTEL_PRODUCT_EM05G_RS		0x0314
+#define QUECTEL_PRODUCT_RG255C			0x0316
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_RM520N			0x0801
@@ -1271,6 +1272,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG650V, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG650V, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0xff, 0x40) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },



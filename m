Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05239D3D0;
	Tue, 13 Oct 2026 12:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895286; cv=none; b=K5nKSgYm8U5zjY+6uChcjxcYUQzYbwrsTF9U1rExo1jyaPMCeqUTiKMn+c4IrJEPLE0UVIhD20g1gkP8Ak7SX6CPs+A9moSxkorSeXYoD7U0y2vZiUa60g/hB0ecZ4/EhNJ8NIh58oiOYDMicpBIUeNlvMHHK5aoZqH6RgowtZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895286; c=relaxed/simple;
	bh=FR8ly30nySzRPTWYW5GrW8o3udCsDrStfBnFSZks4vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImTIEOpFJDf7A9G5GjEFaCh6HHQs+0tSO3L9QLyl5RISuWf1kzaOTgFQ0rRgU3c3d4io4n1QR0p8wUz3Vv1R/Znzvx2KdKS8L+me6r9M8RNy4DysZA7FgwGn8O2dnigweAdUt3FaGTp2qMWSxI3W0ZYRGhV0YCRNamQAPXaFh50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oi70dKJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oi70dKJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94CF1F000FF;
	Tue, 13 Oct 2026 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895285;
	bh=7qbXIqG+eHbIkHCh1oRbLKMyQaU3jxjIMyxCdCQdLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oi70dKJIijdW/7n0VusagCJF65Vc0VJcqLWQqezkfWNYEmk+r8TI4jZovvZKHfWnY
	 fU1yUxvbEExTNX0V80Kiy2C9ZYw+3FpGCsDL1TXRChr1AepE3USIGnPggh35LtgtsR
	 D7p439rvZ5JQyUQtRVSq6fhgboFqjU42FomuNBqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Szelinsky <github@szelinsky.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 221/497] USB: serial: option: add Quectel EG060W
Date: Tue, 13 Oct 2026 13:36:28 +0200
Message-ID: <20261013112913.139506036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlo Szelinsky <github@szelinsky.de>

commit cd243401994880b8b6810c53177bce56eebaece5 upstream.

Add Quectel EG060W with product ID 0x6004.
The three vendor-specific interfaces are DIAG, NMEA and AT; the CDC-NCM
data interfaces are handled by the cdc_ncm driver.

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=6004 Rev= 3.18
S:  Manufacturer=Quectel
S:  Product=EG060W-EAAA
S:  SerialNumber=123456789ABCD
C:* #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=  2mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=0d Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0d Prot=00 Driver=cdc_ncm
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=01 Driver=cdc_ncm
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=01 Driver=cdc_ncm
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Cc: stable@vger.kernel.org
Signed-off-by: Carlo Szelinsky <github@szelinsky.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -281,6 +281,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_EC200U			0x0901
 #define QUECTEL_PRODUCT_EG912Y			0x6001
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
+#define QUECTEL_PRODUCT_EG060W			0x6004
 #define QUECTEL_PRODUCT_EC200A			0x6005
 #define QUECTEL_PRODUCT_EG916Q			0x6007
 #define QUECTEL_PRODUCT_EM061K_LWW		0x6008
@@ -1269,6 +1270,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200A, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG060W, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG912Y, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG916Q, 0xff, 0x00, 0x00) },



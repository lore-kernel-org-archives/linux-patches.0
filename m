Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211064;
	b=DWo4HeaiRXURCTNhNBDdKCUZ3G1LNvWLsNkcMqXCdr7Tr2B/YaA1baVcWYNodWNzFSpP
	 jzJMFNm7GB9oWiJ17Wop7GxninywGAGhfl24Ttt4ErTUkaRrLjxeGsW03OKaqAeNg6E98
	 Obg/Xh0UBkt1POe3r30h20ZBcdbOHczpAoYKCXpacl5YnvKqkygp+Vk/9xr33Y0JxWnxb
	 WfzUweWxwiAMgdYAkWArPBkEbsSDQv+NZRqW9WIK9wfQpxYGBewY1t3wCoRSlOlQfJKdl
	 Tu4z3zrMfpiFImQXk4w/S05k8I7igJbDxeKfOavwkVPdh3hCz1KfS/dYIGK4c6Oar5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7jSevFCL0guqvA3zixwM61ThbeVGUvmpfoZjgsRzkY=;
	b=jbgTVlNyYHb4L4aBFEB2P8qTaz6T6341R7muueBKaVkf0Nzusky/2a9WsdMxJXypFHag
	 JCr511JvNQKEVNW8WJuawlgciYKuYsJBxd+v1ea6p0/5f4wTbuLwVug+ONUauixBJcsRV
	 qURHJwcpoac/e7/NaM1pjWBV2WUUDwwqsjEBSIjqoSQKNJoThGLgEHQ8Iyy4gfg3++MNL
	 mEC71bnbgk+E8n+6wjzvJZapqH0jf2TGlHTULcwFjheLliZpWiH6yhFuOdtOpX60ukzNh
	 v0ewFekQ0oTniXs30VWVaUkewnNxeEpFE8tKcaAm7G7V6s8A7WDr/UhIfM4Fafda7ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtJs3Qql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08AA60A2607;
	Wed, 28 Oct 2026 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtJs3Qql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3852B1F01825;
	Wed, 28 Oct 2026 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211063;
	bh=Z7jSevFCL0guqvA3zixwM61ThbeVGUvmpfoZjgsRzkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtJs3QqlCI5zHz12SigGjKzQkDBvWdGT3+aAyrUEJdOclwD2SRLsh91DTUvGok3oX
	 AahjY08/cV5ZWR7VX5OIHyRgLfbR6wzDgf3oICBEds5g9u/zuy1PIAA7Cxh3h8EbKq
	 cpucIGRcZUalTgPcRkws32kom++J9n0nLDWpzFjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Szelinsky <github@szelinsky.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 246/571] USB: serial: option: add Quectel EG060W
Date: Wed, 28 Oct 2026 17:56:33 +0100
Message-ID: <20261028170013.843465117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212928;
	b=WBz2ivw21AB83Mis+wafYaHl/9WqBpAwFU6O5AUYVgpSOl2sXkfs1hZ5OggGZeACCQIN
	 k9UHt+dJKu7Km/oAJsAzQtWEXSL2qtE2a9oT215Py6j2ofB6WOyjRTxYEXbM8K8b8toEE
	 NwrHeoXsyKfY8r2ZHLNeJoFZ4iSdYtuRIAae4B4V2X4cUT40CXfVIjdqWkHvnRbcBHnMp
	 NAcJyyzIQK1frlEVgzLFONf3j+ERxeG9a1lTdb/TeGy1W5gADPJV/mheWhVS8UwSw2ZBt
	 IiLdSL5BBbJlcV9ZIM8Wbm4LAsdgA/yqeoCzwLzTFkvMcuqeHGzNnjSCq/araugoQLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Eks/hqXkJSO6vQFagU1uYDs7JzyEWr8hSzAl8h5I30=;
	b=xDOMGC562vmj3Vqu/eDEa3KWwr7KJ36XnDQhFcjpc8N1A+3XPodFw1rM3+5CDDfXB1Y9
	 y6iVrgQKs5rzymZJS7OratKiqSQCkgB7JLvVsaU784/J0DYkc1hzvoL8mjBJe+TZI1/tK
	 N+/Qnrj+iv1sGZP27/fAlS1W8kPdmUDf/6N0dR7rJEHiqFHNVpe69VIzGB1+FJuczkKfn
	 YZ8xpgiAFSKYlAsvpPntvTzOU0CfNa27eQPrruHT3UYBkyes5K81bXMEKf3+2JWabyqhm
	 ZtzJq0a7GP1o7DQQpwwyLfoSTVYe14P7xjW0aF5YsXal69XkLT3UJKHCtsp8VXdxkRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDUwlwBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53036606A31D;
	Wed, 28 Oct 2026 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDUwlwBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AE61F01825;
	Wed, 28 Oct 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212928;
	bh=4Eks/hqXkJSO6vQFagU1uYDs7JzyEWr8hSzAl8h5I30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDUwlwBdoIMhRdZfXLJc6XmTGNatiAxwDzPfdn9gJ5L/NFDcVoDIpAUd4wmEMscj6
	 a7lMr/bZIn13z9DgpbF5m17MskpMUjuMHOTFWzVw5Z6sRL343sz/BwHcCcSzPO8V1R
	 s3SfcvhPtGYgEZLrnud7jxh9iZvCn81CEyT/1+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Szelinsky <github@szelinsky.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0325/1887] USB: serial: option: add Quectel EG060W
Date: Wed, 28 Oct 2026 17:40:21 +0100
Message-ID: <20261028170506.628382277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



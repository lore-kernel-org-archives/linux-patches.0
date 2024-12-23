Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D337219E98B;
	Mon, 23 Dec 2024 16:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970490; cv=none; b=DDvQ0BazdJsKrLuDnB6dnoY76SIT7Oegqk2W8l3JpbckrU1nUy06EQdUSgKEg0814N8wEzjbhTFIhtt/N0uKtp0BV1amTO8y97eo5vZTVefpCFvyurqTlJbqoEYNoNqEwcZU135rkCEMRo1a6XcL0Vv02F7rqz+fEKZpwrnDl2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970490; c=relaxed/simple;
	bh=i0yN4FbpF+3/+qJEfmqIkzFqdj5Ffa2nMqhPMqysaJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXySgNV4gX313KMUXjoXLsQHpH4mqIHNVvUnHrcCnp6xoVg8FPZF+piWXabWCZRdDf88gxDDDL56UImSZRzsw2nU5cXB8fKN9+UnEz6AVlfHwDwvIEheGuhWjTuwykQ8ccs68tuWpjp/XkJjQ2r/TvFC6I6nRAkq5y6AiVIpBQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuLNxXbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuLNxXbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED6C4CED3;
	Mon, 23 Dec 2024 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970490;
	bh=i0yN4FbpF+3/+qJEfmqIkzFqdj5Ffa2nMqhPMqysaJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuLNxXbMpniKLFxYqfpzYG5PrqNkpbCGaBbSiQXYDmsL2QDLyOXHPrI61v0XmMzAl
	 K/srKhFKAxKekGS5H/t3Pci8Xtal6QiWlHyKKw5jfQ/tuFw7ioTOsiQGntGeJydYX9
	 TzksVD4E8BSkejvqzlpD8ES5ByFaGkcKF2QvwhwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hrusecky <michal.hrusecky@turris.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 068/116] USB: serial: option: add MeiG Smart SLM770A
Date: Mon, 23 Dec 2024 16:58:58 +0100
Message-ID: <20241223155402.211683105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hrusecky <michal.hrusecky@turris.com>

commit 724d461e44dfc0815624d2a9792f2f2beb7ee46d upstream.

Update the USB serial option driver to support MeiG Smart SLM770A.

ID 2dee:4d57 Marvell Mobile Composite Device Bus

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2dee ProdID=4d57 Rev= 1.00
S:  Manufacturer=Marvell
S:  Product=Mobile Composite Device Bus
C:* #Ifs= 6 Cfg#= 1 Atr=c0 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=03
I:* If#= 0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=88(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=4096ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0e(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Tested successfully connecting to the Internet via rndis interface after
dialing via AT commands on If#=3 or If#=4.
Not sure of the purpose of the other serial interfaces.

Signed-off-by: Michal Hrusecky <michal.hrusecky@turris.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -625,6 +625,8 @@ static void option_instat_callback(struc
 #define MEIGSMART_PRODUCT_SRM825L		0x4d22
 /* MeiG Smart SLM320 based on UNISOC UIS8910 */
 #define MEIGSMART_PRODUCT_SLM320		0x4d41
+/* MeiG Smart SLM770A based on ASR1803 */
+#define MEIGSMART_PRODUCT_SLM770A		0x4d57
 
 /* Device flags */
 
@@ -2382,6 +2384,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, TOZED_PRODUCT_LT70C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM320, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM770A, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x60) },



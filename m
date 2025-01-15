Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8030248BA1;
	Wed, 15 Jan 2025 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937692; cv=none; b=lVJBYvqOHnsnEDMM7ctszJY32U4ChVTIG/h1pOmui7cF7e03UBkd/dkCqEm/Yp6mJ8AnojvmCzu4SHhFzLH72IIL1cCZ8KACWC8JMwCenqUZCF/0IOvwHVXuttdVap17jU+qdVGJJJJEatikcknmsDa6O99lq7avs9zjKYqUjO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937692; c=relaxed/simple;
	bh=NHYERWe9/VckxbKmBBSlxE5He4lKzsrjP/VpbUvN6e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8bedOO9AA8F00RaYtkvZ18d3ElpZcw6Godvy5pQ4qGASEPeP316u7Jwqz8vghN6rfvH2QFHn6JVJbRiv67Wz9F8daJVgDbZ9ujIfjZmspSQGW5gc/zSXBOCRlA3ku4SN06AwaVvCcm5xGV2dfX0+PLEO40bBrWICjVomY+Tt/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra+U74bE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra+U74bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E9FC4CEE1;
	Wed, 15 Jan 2025 10:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937692;
	bh=NHYERWe9/VckxbKmBBSlxE5He4lKzsrjP/VpbUvN6e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ra+U74bEvyCLi5sFjWpX8G9osl0vNs13kGUecze3RV90W7q8lYhnWgix84ovudsTU
	 9KppXlfEHLiow+c8oClCXrIjUjrYX7rHTrWsXfuRygaLpNDE1UV/SiWHGp0LDK7hd7
	 cWVuVS2exou0swvM7FN2te7Yj6J023mXeN8Aw98Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 52/92] USB: serial: option: add MeiG Smart SRM815
Date: Wed, 15 Jan 2025 11:37:10 +0100
Message-ID: <20250115103549.606713622@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

commit c1947d244f807b1f95605b75a4059e7b37b5dcc3 upstream.

It looks like SRM815 shares ID with SRM825L.

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2dee ProdID=4d22 Rev= 4.14
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=123456
C:* #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/lkml/20241215100027.1970930-1-amadeus@jmu.edu.cn/
Link: https://lore.kernel.org/all/4333b4d0-281f-439d-9944-5570cbc4971d@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -621,7 +621,7 @@ static void option_instat_callback(struc
 
 /* MeiG Smart Technology products */
 #define MEIGSMART_VENDOR_ID			0x2dee
-/* MeiG Smart SRM825L based on Qualcomm 315 */
+/* MeiG Smart SRM815/SRM825L based on Qualcomm 315 */
 #define MEIGSMART_PRODUCT_SRM825L		0x4d22
 /* MeiG Smart SLM320 based on UNISOC UIS8910 */
 #define MEIGSMART_PRODUCT_SLM320		0x4d41
@@ -2405,6 +2405,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM320, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM770A, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x60) },



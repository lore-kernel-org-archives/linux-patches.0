Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A4728387;
	Sun,  1 Sep 2024 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208108; cv=none; b=GpLE4cBAJcthjro4+6pyrhdaPymg4EoLTJxuQuM7A0eTVRYX4HwWOavDzE+HjYgP1hVdiVKhojPlCVgGpejKycMXB7Nku90Z5NAPR4uoTFEX4NIRRECng1Qc3k5GAFZsEDn6sTkgXW+MlBFvBIcbQ7ogrIP6TOimV5wo7RNHrOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208108; c=relaxed/simple;
	bh=FGQFXL4qI712IwoATlskeAXW8EzOH9HrLBaXcBzaeCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTIwbS+j3aFvbXm40daHo8dLI912G7Nm1/mRRlJ2hOItUtex+xGuyWjPZsWblWhlwz191gYPC3XSjtoenWAQEDJbFcLdxV5QhVjRPQThsHKouFt09ycXKr8sI0qSW5Q7xCa61/2dX1ZTKsGAK5uQuZEeuEU3F9/HJxy7mII8U20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoPZ8ujJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoPZ8ujJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CF1C4CEC3;
	Sun,  1 Sep 2024 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208108;
	bh=FGQFXL4qI712IwoATlskeAXW8EzOH9HrLBaXcBzaeCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoPZ8ujJhEI8bh+8G8k/q+PIjGx3QYfrj3dL2IWUzVg/pA1esaIw6v0Wi5hWE48WV
	 YK778+WWPhjDusYwH8PcS4d+Q0vH0rUjETn9IMbIya81BWD0DJisWHTbs7DlqtYrdj
	 EoEL+EGQ0JTU7NWMeK9AXWCoP8z3bPbSvpXaix9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZHANG Yuntian <yt@radxa.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 76/93] USB: serial: option: add MeiG Smart SRM825L
Date: Sun,  1 Sep 2024 18:17:03 +0200
Message-ID: <20240901160810.598824411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: ZHANG Yuntian <yt@radxa.com>

commit 9a471de516c35219d1722c13367191ce1f120fe9 upstream.

Add support for MeiG Smart SRM825L which is based on Qualcomm 315 chip.

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2dee ProdID=4d22 Rev= 4.14
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=6f345e48
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: ZHANG Yuntian <yt@radxa.com>
Link: https://lore.kernel.org/0041DFA5200EFB1B+20240803074619.563116-1-yt@radxa.com/
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -619,6 +619,8 @@ static void option_instat_callback(struc
 
 /* MeiG Smart Technology products */
 #define MEIGSMART_VENDOR_ID			0x2dee
+/* MeiG Smart SRM825L based on Qualcomm 315 */
+#define MEIGSMART_PRODUCT_SRM825L		0x4d22
 /* MeiG Smart SLM320 based on UNISOC UIS8910 */
 #define MEIGSMART_PRODUCT_SLM320		0x4d41
 
@@ -2366,6 +2368,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, TOZED_PRODUCT_LT70C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SLM320, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEIGSMART_VENDOR_ID, MEIGSMART_PRODUCT_SRM825L, 0xff, 0xff, 0x60) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);



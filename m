Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612912D1F1;
	Mon, 23 Dec 2024 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969971; cv=none; b=ivkr+sLYiFJjTh7OT8jjaWpLe2RN27n31m4mE/pDKeZrWFQUiPSkLjNmlg2aLo4/32PEoTZhNoLPxmwnX4KQccOw6aaf+I5f2yOGssTVAS+X3Yyv/NlFWvnJXhtuRqQm0qVmRPM3A1ZtN2HYMvBvW3qdBPmbQ0KIxB9RASEEzik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969971; c=relaxed/simple;
	bh=da/lXYR0axQNUzSnJw1jMH8vd4g1AdSoZsXdu4uvRYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEonywcNDOk2PI2+h/+2A7+7bxS3AqHBXl4Wj8GTmnXXvtrNVgEuZ9LvTi4fsFpV1NVQe27V3RQmAyGUtobfhYaMn0CynZB1RhQi9UTrdUTDhm9kj86CsVvJvDuzAZtH9VbJb5FpSrWSqN9kT/XxU8d9dGL2mWvbMmEMX4Bd76A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5WHz8y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5WHz8y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B2C4CED3;
	Mon, 23 Dec 2024 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969971;
	bh=da/lXYR0axQNUzSnJw1jMH8vd4g1AdSoZsXdu4uvRYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5WHz8y+5nejYsCZU/CUIh5fc/4GvrwSwvmKv3VkoFHdBniZootzpCRYHdXS6q/k/
	 NLqsfbFhjOYYAKkrEn86S9N8N21HtCORPOHXf/2VyQVsJ5X51GRHcoQjNgFZ+FRVuJ
	 SWFPqcz28kRhSDXz5F/LdkWm2M0rli3Tjav3bKKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wu <wojackbb@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 079/160] USB: serial: option: add MediaTek T7XX compositions
Date: Mon, 23 Dec 2024 16:58:10 +0100
Message-ID: <20241223155411.745915387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wu <wojackbb@gmail.com>

commit f07dfa6a1b65034a5c3ba3a555950d972f252757 upstream.

Add the MediaTek T7XX compositions:

T:  Bus=03 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#= 74 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0e8d ProdID=7129 Rev= 0.01
S:  Manufacturer=MediaTek Inc.
S:  Product=USB DATA CARD
S:  SerialNumber=004402459035402
C:* #Ifs=10 Cfg#= 1 Atr=a0 MxPwr=500mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=0e Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
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
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 8 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 9 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

-------------------------------
| If Number | Function        |
-------------------------------
| 2         | USB AP Log Port |
-------------------------------
| 3         | USB AP GNSS Port|
-------------------------------
| 4         | USB AP META Port|
-------------------------------
| 5         | ADB port        |
-------------------------------
| 6         | USB MD AT Port  |
------------------------------
| 7         | USB MD META Port|
-------------------------------
| 8         | USB NTZ Port    |
-------------------------------
| 9         | USB Debug port  |
-------------------------------

Signed-off-by: Jack Wu <wojackbb@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2249,6 +2249,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x7127, 0xff, 0x00, 0x00),
 	  .driver_info = NCTRL(2) | NCTRL(3) | NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x7129, 0xff, 0x00, 0x00),        /* MediaTek T7XX  */
+	  .driver_info = NCTRL(2) | NCTRL(3) | NCTRL(4) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
 	  .driver_info = RSVD(1) | RSVD(4) },



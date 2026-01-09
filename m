Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E520359F86;
	Fri,  9 Jan 2026 11:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959328; cv=none; b=aAYfb25/OZdhZBK1os/1WbqsdOnhFHPQfzLv7UP/PdtcoYTb3QxenuwryjQxx/xyynR354ru+MkzOKMhSHn+YVKzyI1DPnR9O2Uy13agvMNc2apiju0IygCJVhNwPYKVDvYp+LHgoYyvFJLQUxI6D88XLJDnlzu04ksNgZplnoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959328; c=relaxed/simple;
	bh=p/ZkMNa3H8rLsYwbVeXD4SOnIauRUG4Gd/MImOgzqyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfMOJumD7uzf+J+v0QyBtLxnfjPrKWd2fK5tHRz3pxR6/dFPC7Bej38eQAXJPM90/GOVxxXvGy8wOsNlv2Yb9Zu9+NlLPt7We+D9x26U3J5TUOFmgEBI3BAoqmnWKlD4BM9gvnP4HnhAbYZJ6zA2osFIwJKwxGZTLBMaohrvrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXaO0gIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXaO0gIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D0C4CEF1;
	Fri,  9 Jan 2026 11:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959327;
	bh=p/ZkMNa3H8rLsYwbVeXD4SOnIauRUG4Gd/MImOgzqyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXaO0gIrd0kmqK8Q1nkk2Wa+urK25JMOU/+Ovxoz5lUZEiuMPV4dwCzOWp1bgm5lg
	 WVepyMXvzCxsJN11U2vXLuwuZNldFKpYtq4vFz6D++klZJ5KOj3xkbjJuSyWQQon0u
	 THOJTYmb5Ig0nzFaRKmzECnKfUYBHJxVZoP6UpJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 014/737] USB: serial: option: add Foxconn T99W760
Date: Fri,  9 Jan 2026 12:32:33 +0100
Message-ID: <20260109112134.531158236@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

commit 7970b4969c4c99bcdaf105f9f39c6d2021f6d244 upstream.

T99W760 is designed based on Qualcomm SDX35 (5G redcap) chip. There are
three serial ports to be enumerated: Modem, NMEA and Diag.

test evidence as below:
T:  Bus=03 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  4 Spd=5000  MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e123 Rev=05.15
S:  Manufacturer=QCOM
S:  Product=SDXBAAGHA-IDP _SN:39A8D3E4
S:  SerialNumber=39a8d3e4
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

0&1: MBIM, 2:Modem, 3:GNSS(non-serial port), 4: NMEA, 5:Diag

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2376,6 +2376,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe0f0, 0xff),			/* Foxconn T99W373 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe123, 0xff),			/* Foxconn T99W760 MBIM */
+	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe145, 0xff),			/* Foxconn T99W651 RNDIS */
 	  .driver_info = RSVD(5) | RSVD(6) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe15f, 0xff),                     /* Foxconn T99W709 */



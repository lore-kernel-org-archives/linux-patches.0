Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008D183CA6;
	Wed, 17 Sep 2025 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113456; cv=none; b=MJt5tbjOQjIocU3RaT8lsv6LlwSd3+bJxszE5SbWXw2xM8K9zVuGkI2yshhK7DYSe8ULw6D/76Bo152m19jm1zlzVSgPOCzK98ytWCMArelJGhLZdT7pfTxqf+8/9hJR5a+F0tmjruPDHf98JLFv8AjR1ohv7cJJofPVfVFFSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113456; c=relaxed/simple;
	bh=qvXhm8nT1VglFFGdRPINSUgWweNsCp3BoQbDQTey8oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4V9RSEb+0ixxovufEk9FahxepFGO+yAgCMudsB2pXnfFlroZTZXXctZSgP8uFNXCgMfaQCKgr/7GIdT/xZ0gd2NeCT11W21WYe30uWMbq+RLZ+jYEk4ZvkMo5a1IZDHwsSFtxqAvi5/5jnImExZcpLjNNE+VTNNs0QvExizKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8soyahu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8soyahu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21812C4CEF0;
	Wed, 17 Sep 2025 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113455;
	bh=qvXhm8nT1VglFFGdRPINSUgWweNsCp3BoQbDQTey8oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8soyahuYigtWsEOR1w3kMGo0vG0HMPV8nlGCTP2FGYkkHQrTR0aeBleV8eyUyEE5
	 ih1LfHLo+EASwCsb7bP1y46Is/9QCzjIsS8M4BDFYM1Vo4Egrn8cB8WOPJM8iFppvB
	 5BhoTFx76QLGqffKwD7sjpYnEkpLhSvrHsNWo23g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 092/140] USB: serial: option: add Telit Cinterion FN990A w/audio compositions
Date: Wed, 17 Sep 2025 14:34:24 +0200
Message-ID: <20250917123346.549749437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit cba70aff623b104085ab5613fedd21f6ea19095a upstream.

Add the following Telit Cinterion FN990A w/audio compositions:

0x1077: tty (diag) + adb + rmnet + audio + tty (AT/NMEA) + tty (AT) +
tty (AT) + tty (AT)
T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#=  8 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1077 Rev=05.04
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN990
S:  SerialNumber=67e04c35
C:  #Ifs=10 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=20 Driver=snd-usb-audio
I:  If#= 4 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=03(O) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 5 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=84(I) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 9 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8c(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

0x1078: tty (diag) + adb + MBIM + audio + tty (AT/NMEA) + tty (AT) +
tty (AT) + tty (AT)
T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#= 21 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1078 Rev=05.04
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN990
S:  SerialNumber=67e04c35
C:  #Ifs=11 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#=10 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8c(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 2 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 3 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=20 Driver=snd-usb-audio
I:  If#= 5 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
I:  If#= 6 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=84(I) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 9 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

0x1079: RNDIS + tty (diag) + adb + audio + tty (AT/NMEA) + tty (AT) +
tty (AT) + tty (AT)
T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#= 23 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1079 Rev=05.04
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN990
S:  SerialNumber=67e04c35
C:  #Ifs=11 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=ef(misc ) Sub=04 Prot=01 Driver=rndis_host
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#=10 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8b(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8c(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=20 Driver=snd-usb-audio
I:  If#= 5 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
I:  If#= 6 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=20 Driver=snd-usb-audio
E:  Ad=84(I) Atr=0d(Isoc) MxPS=  68 Ivl=1ms
I:  If#= 7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=88(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 9 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Cc: stable@vger.kernel.org
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1369,6 +1369,12 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990A (PCIe) */
 	  .driver_info = RSVD(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1077, 0xff),	/* Telit FN990A (rmnet + audio) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1078, 0xff),	/* Telit FN990A (MBIM + audio) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1079, 0xff),	/* Telit FN990A (RNDIS + audio) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1080, 0xff),	/* Telit FE990A (rmnet) */
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1081, 0xff),	/* Telit FE990A (MBIM) */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623E42C1594;
	Mon, 17 Aug 2026 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975528; cv=none; b=kE3BqdR6xRKHKeoO2gqe4CGHcFyWl0Xytv+4NP1cqRiUjntgXKsMSntdx5j75EIkBDw9pcT2rsrbB62vLFzgf42mwj8ck5tfWpDFSLmSMsfonjGMU1e06CtQho09cK4IIGct7XOD0hAf5xnT+T5N0h2j2vNG4rjUUUic4M1RddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975528; c=relaxed/simple;
	bh=Qpr1RStmWJBVdQYNUIL9X05+nYWjb0u4OkwZOrhdWO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwI73P2XR1RrWOyR0yEO7eVDTm5TFZ133uJVmx0/wco7BeHAdAN1HW0oLzGbFp0ZFb/RMqbhYZqI/IY5EoKXNvsdxpXSnnjIkksdA2VpXYgwVhUhvAHX/8QFFvIIgmKa/A/PfJiBQyeOKMGDJAGFnl6n0T/xACtD8cQFFMvwDkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTr9Rbaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTr9Rbaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1AC1F000E9;
	Mon, 17 Aug 2026 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975527;
	bh=TsLHHDIovXjAtxpvx8d/wwg/DtOGWIe72EXObPs8oms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTr9RbaaTBID0OW5g+1pL3ylBx2dMqdMWMJE7A36jl8jt4JNTs4LHz+BXWrTfOGFc
	 ejQZ5UIt1iy2O4zrAGDkcgrpaLR8J38V60751zvfJg1DQIMWHtaqCt9Tea+O7zg/1j
	 xVU30pRtDgH21irDY68oSDvwY/ofsiCBznzAl0nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 057/389] USB: serial: option: add TDTECH MT5710-CN
Date: Mon, 17 Aug 2026 15:28:16 +0200
Message-ID: <20260817132541.299384079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

commit 55645e4f3c6022ffb160ad3617d2b624eaa38501 upstream.

Add support for the TDTECH MT5710-CN (5G redcap) module based on the
Huawei HiSilicon Balong chip.

T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=3466 ProdID=3301 Rev=ff.ff
S:  Manufacturer=TD Tech Ltd.
S:  Product=TDTECH MT571X
S:  SerialNumber=0123456789ABCDEF
C:* #Ifs= 6 Cfg#= 1 Atr=c0 MxPwr=  0mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=0d Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0d Prot=00 Driver=cdc_ncm
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=01 Driver=cdc_ncm
I:* If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=01 Driver=cdc_ncm
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=06 Prot=13 Driver=option
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=06 Prot=12 Driver=option
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=06 Prot=1c Driver=option
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=06 Prot=14 Driver=option
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Interface: ECM / NCM + DIAG + AT + SERIAL + GPS

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2497,6 +2497,7 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x1003, 0xff),			/* Rolling RW135R-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x3466, 0x3301, 0xff) },			/* TDTECH MT5710-CN */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x40) },



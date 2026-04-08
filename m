Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB3D2641FC;
	Wed,  8 Apr 2026 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673968; cv=none; b=ouphyAH2quxC5RGKp12l5jwsPkibFycSFN7C4qCzdBovgbTj7+JagvkZI8WDLknZSOQBdJgi2+U4bS6iveEKuq0icSQfqt/eaONiUOtOY/mBHkceIlKXK9fDqVGEAvD+oGtU98h7Wkh8iZbHEXW5YEKtAqxL309hHndfB3mPUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673968; c=relaxed/simple;
	bh=gxAEjpREyoS+pxZH2xpMBW396G1316QKTm6W1MFnQRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A280TwpJPdODA1/Qfpxnr/BHhjkvlcQMIaYqgLNjJxClxMr7gN/ZQ5utAvAzauL4Pai/pipSW+AO5TY595WC6R//16AUft0UhLtM23iyMByTGoAwZv6kExkl6yDgF+hAKd2nxgXZwXoSUXMxLKnQyViUvOVhePSJz2KRwWNNnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIDH22NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIDH22NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A65C19421;
	Wed,  8 Apr 2026 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673968;
	bh=gxAEjpREyoS+pxZH2xpMBW396G1316QKTm6W1MFnQRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIDH22NCbHGKsbfdzCpUdJftUV/20erWupRJH5lrJMgGLHjzMB90fGz3dDhL3mNfx
	 mL//8XbQhSFwoknEGtTOCxCGVYFIYwYRu2PsyXo/jSKBg+QnpQSZj6ZXX62xyuSwp1
	 VmoS+RN51LAoCcgp6JugVp4xdbN1ITQyfPLv/+bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wanquan Zhong <wanquan.zhong@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 141/242] USB: serial: option: add support for Rolling Wireless RW135R-GL
Date: Wed,  8 Apr 2026 20:03:01 +0200
Message-ID: <20260408175932.365019180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Wanquan Zhong <wanquan.zhong@fibocom.com>

commit 01e8d0f742222f1e68f48180d5480097adf7ae9f upstream.

Add VID/PID 33f8:1003 for the Rolling Wireless RW135R-GL M.2 module,
which is used in laptop debug cards with MBIM interface for
Linux/Chrome OS. The device supports mbim, pipe functionalities.

Here are the outputs of usb-devices:
T:  Bus=04 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=33f8 ProdID=1003 Rev=05.15
S:  Manufacturer=Rolling Wireless S.a.r.l.
S:  Product=Rolling RW135R-GL Module
S:  SerialNumber=12345678
C:  #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Wanquan Zhong <wanquan.zhong@fibocom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2464,6 +2464,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0302, 0xff) },			/* Rolling RW101R-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x0802, 0xff),			/* Rolling RW350-GL (laptop MBIM) */
 	  .driver_info = RSVD(5) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x33f8, 0x1003, 0xff) },			/* Rolling RW135R-GL (laptop MBIM) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x30) },	/* NetPrisma LCUK54-WWD for Global */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0x00, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3731, 0x0100, 0xff, 0xff, 0x40) },



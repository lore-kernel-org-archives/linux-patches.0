Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C16E14388A;
	Tue, 23 Apr 2024 21:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908793; cv=none; b=sDMYWFh7C8y8D04UjtKYktQe6XOfpJNwzKvpqkFNX+QYBID9BzMP2C2VPfgoq0XzNOkekxpKNZ0KPZb2hIBFCIy18iAsS+kQUgNk5wJ0Gtr7DX8s5qanMs0Kn48JEInnKQGIbFNBY/33UXpEvuYEpm5Z2IrngACMIcqNImSYYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908793; c=relaxed/simple;
	bh=3Sjl6kfgwYzZeJBYH1Oomb0l243v+FrNboBXfc6vXio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7a9FRG5NKL45CgVsRqoeZiMiZZLZfDRmr24aX49plgYxfLDGq7E4nfBUBpzS9DE6g5wfpPXr5aHiu7cx7qaGHxRACNn8kua8jnJy3MBduCC+Kbm8AgOfRd6o1hLieT47VHUABI88mwlh9yLJps+bQ7AugZ7UesrHuodFwXadAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ65nTSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ65nTSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525DCC3277B;
	Tue, 23 Apr 2024 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908793;
	bh=3Sjl6kfgwYzZeJBYH1Oomb0l243v+FrNboBXfc6vXio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJ65nTSN8xFlIhZEPhvdAKAiJFFuEI+RdQg02JjjeR4ebecOc6NxMDHjEbJ/xE6no
	 JyxM60E9BVdnnxr3xc7hLpaMxoGMSKf/em0F1XUt4R9iDmfZ+oLSTormom6w1v183n
	 Qxgm3vBeGix6XDh4tpfQnTzshfEPIP4E3li8maz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bolan wang <bolan.wang@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 46/71] USB: serial: option: add Fibocom FM135-GL variants
Date: Tue, 23 Apr 2024 14:39:59 -0700
Message-ID: <20240423213845.743514677@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bolan wang <bolan.wang@fibocom.com>

commit 356952b13af5b2c338df1e06889fd1b5e12cbbf4 upstream.

Update the USB serial option driver support for the Fibocom
FM135-GL LTE modules.
- VID:PID 2cb7:0115, FM135-GL for laptop debug M.2 cards(with MBIM
interface for /Linux/Chrome OS)

0x0115: mbim, diag, at, pipe

Here are the outputs of usb-devices:
T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#= 16 Spd=480 MxCh= 0
D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0115 Rev=05.15
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=Fibocom Module
S:  SerialNumber=12345678
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: bolan wang <bolan.wang@fibocom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2272,6 +2272,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0115, 0xff),			/* Fibocom FM135 (laptop MBIM) */
+	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a2, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a3, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */



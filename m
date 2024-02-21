Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104D04D5B7;
	Wed, 21 Feb 2024 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523179; cv=none; b=cMOiaQ6g6hzbIRG3DnJLtckNVtBXtv3gbFW6KXV4aHup6DCSV87FVGNEM4GBLJT+Ib8v7Rq0AQXvUBBeZ/NXI3dDONgeaxsMiK1nZ1Z/sy70cHa/dd7ROLmbtnsARyIIwRuU646afSMuCUozn/BzIP2PItcI3+XezxM/ir/VdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523179; c=relaxed/simple;
	bh=iSR2UAhcaD61vLSHrDPNeGLWZTHO1sbDxtz3HHXU2q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNbm2zPs8QOCPe7H4C6kKkln8D+XAcArW6OKpbNl9StYjFuRKA4gABNduEr1qgb2eHexm5iykJUTNlkEST7yKtU5FBXJdcQnGl9gC5/933LyyUk6/4LmFFtsyUcvIgNrEcueCeonU8uM48dk0+5eRiIvHKgjjgYKASi1204vgxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIUTMGQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIUTMGQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82360C433C7;
	Wed, 21 Feb 2024 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523178;
	bh=iSR2UAhcaD61vLSHrDPNeGLWZTHO1sbDxtz3HHXU2q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIUTMGQtTqzjabxKkmdh7rx2bEFAw6722INLNPyoIdKuUmEgqBbtoIMqgGQoZVkLH
	 1CHtVFYNTQW+Ftc5pEGL4NVsi0sUa1VpyHvequMwBsn6VWuwVvUxe/DAVypz+bYYUD
	 fF0znKVimei7laZCg1s/IH0qANt0s3F6shV9epEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puliang Lu <puliang.lu@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 332/476] USB: serial: option: add Fibocom FM101-GL variant
Date: Wed, 21 Feb 2024 14:06:23 +0100
Message-ID: <20240221130020.287275389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Puliang Lu <puliang.lu@fibocom.com>

commit b4a1f4eaf1d798066affc6ad040f76eb1a16e1c9 upstream.

Update the USB serial option driver support for the Fibocom
FM101-GL
LTE modules as there are actually several different variants.
- VID:PID 2cb7:01a3, FM101-GL are laptop M.2 cards (with
MBIM interfaces for /Linux/Chrome OS)

0x01a3:mbim,gnss

Here are the outputs of usb-devices:

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2cb7 ProdID=01a3 Rev=05.04
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=Fibocom FM101-GL Module
S:  SerialNumber=5ccd5cd4
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

Signed-off-by: Puliang Lu <puliang.lu@fibocom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2269,6 +2269,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a2, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a3, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a4, 0xff),			/* Fibocom FM101-GL (laptop MBIM) */
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */



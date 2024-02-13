Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0685F54E;
	Tue, 13 Feb 2024 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845528; cv=none; b=A5Xilv9wQpTCvUUbXEZjExxMumR6pTLE6QiYafWydv5b+FeWvq3P+zF6RHvfnyk3TBn9Iu5BlJAjUq83dB4VdKWeWlWYNl/TrLkeZy/e7r3P5LmMv3oNkamiYQwxh+mxK7YVntOon7KE7QpknRpdwQR4j+KqdjgNwjMIDeYzEyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845528; c=relaxed/simple;
	bh=uCwFoZ546f34TLGCTIU6ka1Fl+rvVJAu+h+cPyajwu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0vqoCi3NtagWFir+/HnhMR1JnjEN/ZwFKm/vr6w8rTTChfOhGE5LbmuAwrEpOQdjygaGqgVvY5Hz0Gy9sZ0t6LGte7lvIXtYJNcrobrIUFNoNIHPVDhmrzRqGO2uYgMILqe7rzb7VrHr0/GLNv11XzYLH5H64EoXxS4ySRMcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTx+nwm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTx+nwm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E61C433F1;
	Tue, 13 Feb 2024 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845528;
	bh=uCwFoZ546f34TLGCTIU6ka1Fl+rvVJAu+h+cPyajwu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTx+nwm1qSTo0VmLLNyNpLxmAFDWzv0JRqAB+6qCDa81c5JnWfMxtW+sEchK14/Ng
	 D2cZeQW112cgnLxAdof5nEBbXBLlOjB+Zfaeg0PM3Y7jiH5WAwAGeHn9vX4h8C/6rl
	 n4rJAZ3pwZw1NHyuCNuvm7kr2EsCYUjNKAq21y6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puliang Lu <puliang.lu@fibocom.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 103/121] USB: serial: option: add Fibocom FM101-GL variant
Date: Tue, 13 Feb 2024 18:21:52 +0100
Message-ID: <20240213171855.998979713@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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



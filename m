Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2720C4E532F;
	Fri,  9 Oct 2026 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557399; cv=none; b=NzZZ6AR/IJWPiikpdeqFl9qEzxPqEbSqBC23+FcSrL3YmkxCTDJiRq/EmwyzVV/m8kn7SESJDpDlFvQIaF3N5tV/xASA62/erY0RkJ1lR89QRgJ0LQfDdSkff6fT2i686ukQvuI2dsFGxOypQcdeNtiuuKh7PrOuVzTC1NnkCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557399; c=relaxed/simple;
	bh=zaguBDcHMUsZgN9RTdzUwMqhoBLvBsCizNlV7KMf8OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9du9/VgZnc2ovVKmujiHRHtUH7tPTZLj7DHVH6Y1g1wTCi7vE19I1L8t30BoLvcefpQTnQVQwotg8wUmEhDL+2ljOVHIoEYQp678K26s9SGt9p+Nt0nbS9MlA6EzlcZAyvHvCTl2Ulwuo5tt/OL0TK4HTb6+jiLy0XfwF9HQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ishHiDD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ishHiDD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8531F000FF;
	Fri,  9 Oct 2026 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557398;
	bh=/+4v1cCjYA5iBf4ifQsXBmSqgmx+6YfKZEtL7xP8quc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ishHiDD23wnWY+3TcQRuHevTW84XIoTZ6+37uZXwmlcklcN2T3fZZiRksOjX2DcKg
	 kQzQ3oNuEtSDyqYcBOpmZci+Vi+4EV2hqkSYW5r5pEgiKCB7VKw7mYr4HfjDyL5bNa
	 sRbBYKhpxarMvo2jDQ9ehVCT1U3mQr8RXGfAkau8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Lin <ian.lin@jetone.com.tw>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 349/428] USB: serial: option: add Compal EXC-T1 support
Date: Fri,  9 Oct 2026 16:11:26 +0200
Message-ID: <20261009140953.827649564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Lin <ian.lin@jetone.com.tw>

commit b51faf3f2e307f114854bbe6d495f03cd5370686 upstream.

The Compal EXC-T1 is a Qualcomm MDM9207-based LTE modem which reports
"EXC-x1" as its USB product string. It exposes diagnostic, modem, AT,
and NMEA ports as vendor-specific interfaces with subclass 0x10 and
protocols 0x01 through 0x04.

Add exact interface matches for these four ports, leaving the ff/ff/ff
interface unbound.

Relevant output from usb-devices:

T:  Bus=03 Lev=02 Prnt=03 Port=03 Cnt=01 Dev#=  6 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04b7 ProdID=4d22 Rev=03.18
S:  Manufacturer=CEI
S:  Product=EXC-x1
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=10 Prot=01 Driver=option
I:  If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=02 Driver=option
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=03 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=04 Driver=option
I:  If#= 4 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=10 Prot=05 Driver=qmi_wwan

Tested on a Compal EXC-T1 modem using an Ubuntu kernel build. The four
serial interfaces bound to option and exposed ttyUSB3 through ttyUSB6.

Assisted-by: Codex:GPT-5
Signed-off-by: Ian Lin <ian.lin@jetone.com.tw>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2436,6 +2436,10 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe167, 0xff),                     /* Foxconn T99W640 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x01) },	/* Compal EXC-T1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x02) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x03) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x4d22, 0xff, 0x10, 0x04) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },



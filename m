Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B01DA4D;
	Tue, 16 Jul 2024 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145019; cv=none; b=n4jG/avdZAdBOM+yg21+wCnPn/5iESs+jg1kU4FboMQ5SV5oVioihw3T2poWSL0yoSTjqzVSMyONyKwWSLMTPIJjiuFMzbjtTpjnWCsXaqMJQTJHsRnEJxqb7xMY8xvEMQAtGp/y/e047pcrgCFgIXcT5Mt1SRcqgTGJ6yChUKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145019; c=relaxed/simple;
	bh=fV8aoi2DHEkUOflzk8En5YGWI9Y5ABP/SqzTyJfH5gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV5b9A3K9XTzjYmxxn2CWU7aABxf2JvQ+jlPDA5pjzTM9VsxUGGgxXLzkD4HEhaKRV7HI3f4ytek1zR0H76Y9AICKuqnN2KOutKv6VTMXgZeESDlclj0BoQILt95+Yyrzq/Q/davGSGWXP5AZ7lojbuHQuZxVf39GgD9P+BYd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiiKJQ+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiiKJQ+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E079C116B1;
	Tue, 16 Jul 2024 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145018;
	bh=fV8aoi2DHEkUOflzk8En5YGWI9Y5ABP/SqzTyJfH5gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiiKJQ+2DONFIV24NlpWLWBiLss1l14sjRoD5vt7nvcAmJhJ106Jatcb7uClRIIsH
	 0kNnRHBk1ngyjmLPcSXdwx0HsLUbe9CyXJlPmwhzg4Y9pRrcSz6UP5kORQtAr0+JOz
	 LhxswRF9pLuB8fjO5BP8g7iSyL8PUk5U9RyFIIms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.9 072/143] USB: serial: option: add support for Foxconn T99W651
Date: Tue, 16 Jul 2024 17:31:08 +0200
Message-ID: <20240716152758.746841663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

commit 3c841d54b63e4446383de3238399a3910e47d8e2 upstream.

T99W651 is a RNDIS based modem device. There are 3 serial ports
need to be enumerated: Diag, NMEA and AT.

Test evidence as below:
T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e145 Rev=05.15
S:  Manufacturer=QCOM
S:  Product=SDXPINN-IDP _SN:93B562B2
S:  SerialNumber=82e6fe26
C:  #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=ef(misc ) Sub=04 Prot=01 Driver=rndis_host
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
I:  If#=0x6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)

0&1: RNDIS, 2:AT, 3:NMEA, 4:DIAG, 5:QDSS, 6:ADB
QDSS is not a serial port.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2294,6 +2294,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe0f0, 0xff),			/* Foxconn T99W373 MBIM */
 	  .driver_info = RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe145, 0xff),			/* Foxconn T99W651 RNDIS */
+	  .driver_info = RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */



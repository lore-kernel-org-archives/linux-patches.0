Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C512D2495;
	Mon, 17 Aug 2026 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979028; cv=none; b=FyvhrRoQc+Fmciwxj5m5bW7EWdHW3W5sZh3DvS9O6z1wuXPJP0aPxNfGOX/5YqiAJyANO6+BBzHaguYzsHh9LcGhVaY3PElnd+L6dPyfsnGJeGagN7DuUbwKVZ3OziC1OLz2qPcgy8Qod/igASlRg65wrVTWK0MuWBH18Wxfc/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979028; c=relaxed/simple;
	bh=ncxGrjC298uHEgNsXDbkXS33Q3I1AGE6yHPtzFoOsvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyRRCzyaGWPGclrBFWFTpqUViTQXNwLMiy4gckyMqxVS6aIGS4ChDnkcVBjDULAdm/c9NIEcbkMn9cXuzpTC6En7Ka7C5Z49FqJ+rqH4nEHhGPOWckzvtsA1rc4ThTvYMHvRf5JJopWy2Rm4jGgX1qGHlfBrJpyknbAtwtlVLSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAX0VZ51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAX0VZ51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D581F000E9;
	Mon, 17 Aug 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979027;
	bh=HlDbEDwLc+ADNXTKx9pUshdqGmQW2czbvF6iYfCFV7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAX0VZ51X/MkGTwq2wFxAfSHBtODApczNAHwlzVweGp9gAuLwkQM8OOL6aK5PEZWq
	 64yjlF16H/z9SPhZWVLFmvvIEPj8CEHaORapTT97K92mEhp4j+Xy4/NCIpryHUFujK
	 g4PqyCAxcakcRB1Yi5xuuSmJeIWGTWqFU1SDa/tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Pambor <timpambor@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 084/609] USB: serial: ftdi_sio: add support for E+H FXA291
Date: Mon, 17 Aug 2026 15:26:20 +0200
Message-ID: <20260817132546.402560550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Pambor <timpambor@gmail.com>

commit fad0fd120e29041b3e6cdf41bb12e3184fb524a2 upstream.

The Commubox FXA291 by Endress+Hauser AG is a USB serial converter
based on FT232B which is used to communicate with field devices.

It enumerates using the FTDI vendor ID and a custom PID.

usb 1-9: New USB device found, idVendor=0403, idProduct=e510, bcdDevice= 4.00
usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-9: Product: FXA291
usb 1-9: Manufacturer: Endress+Hauser
usb 1-9: SerialNumber: 00000000
ftdi_sio 1-9:1.0: FTDI USB Serial Device converter detected
usb 1-9: Detected FT232B
usb 1-9: FTDI USB Serial Device converter now attached to ttyUSB0

Signed-off-by: Tim Pambor <timpambor@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1075,6 +1075,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
 	/* Abacus Electrics */
 	{ USB_DEVICE(FTDI_VID, ABACUS_OPTICAL_PROBE_PID) },
+	/* Endress+Hauser AG devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_EH_FXA291_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -314,6 +314,11 @@
 #define FTDI_ELV_UIO88_PID	0xFB5F	/* USB-I/O Interface (UIO 88) */
 
 /*
+ * Endress+Hauser AG product ids (FTDI_VID)
+ */
+#define FTDI_EH_FXA291_PID	0xE510
+
+/*
  * EVER Eco Pro UPS (http://www.ever.com.pl/)
  */
 



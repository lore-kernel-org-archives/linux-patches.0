Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BCC3E00B6;
	Mon, 17 Aug 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975522; cv=none; b=q3moj0xRZfsb3/t8Q1Wki9TulwcDPoIOYl6YGttfLaGJm+PrvKfDwyNYwblulgALcz4SfRnCUcQ3nAckkairQNGvEfqNZv9DK7mXpRC/hSdY6urG7gOr1aEDCiGABqW4U96EUef+OBf328g0KLO9eu54y/CHtzIxnBJ6DFapUKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975522; c=relaxed/simple;
	bh=dMpgOepcTV6mf2yrGPh1F1Wdck8AEv+UosP1rtmOqAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNK5IKOBuD0OiJy60p4lLscOTKotIMuQfz3gpFaA6V1SgWO/+F97kTd3RgJ2j4oq1jJH/+JUDEQBtpmSud6EKeMBDwXSLJzVEku2mYweCm3qOhTwIEzqd5qaCVEiJ2zwPpfyDIG6Fznw9irkZcZ3Oib7ACjLffj6dY+FJywIJqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srZYO5Vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srZYO5Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A0F1F00A3A;
	Mon, 17 Aug 2026 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975521;
	bh=9v0BriXCBEZW2shd+K1j11NIEg3GzFlfCjkBIzigCXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srZYO5VhMQJuG0cxC0JQKpDWpiABwdGTmpQdde/fOzZ2yBk/Z4jmhy0eCIZtkfdO6
	 n+cP/TrnVQVfWPK4fCVhhx8BitjPbBJA3uGGK5lgELqIzfx69AAmGI0VoUELuvnf8N
	 NCMlcyj4faznTIlOFBzsbjF8+mlxxTSWPHZ0f5OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Pambor <timpambor@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 055/389] USB: serial: ftdi_sio: add support for E+H FXA291
Date: Mon, 17 Aug 2026 15:28:14 +0200
Message-ID: <20260817132541.205489198@linuxfoundation.org>
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
@@ -1053,6 +1053,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
 	/* Abacus Electrics */
 	{ USB_DEVICE(FTDI_VID, ABACUS_OPTICAL_PROBE_PID) },
+	/* Endress+Hauser AG devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_EH_FXA291_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -307,6 +307,11 @@
 #define FTDI_ELV_UIO88_PID	0xFB5F	/* USB-I/O Interface (UIO 88) */
 
 /*
+ * Endress+Hauser AG product ids (FTDI_VID)
+ */
+#define FTDI_EH_FXA291_PID	0xE510
+
+/*
  * EVER Eco Pro UPS (http://www.ever.com.pl/)
  */
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C1943E9DF;
	Thu, 30 Jul 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421587; cv=none; b=YnQvH/f1zhjhG3MuLRQIsBZuI4ScbYu9dAkg/eMAMz9rrCIhZrQYZ24XmJlV8CphVcymrd1oZoUz9yGRkuCN1oH9/HysOZdZ2Qd1j7huh3tcsNlLBLehZjj1dBvApDiDLoSFvIwbzybxCJXqW8nkuuprp94fF9guecIVW5Hkd6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421587; c=relaxed/simple;
	bh=WxvdT42gfn4DrePqiBDocSCHhLXFZKrtLk0ylHggQ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8X+sXUlV4FKe8hdgho46lDVmPhs9uAw8/tsbDUxRjPBfsZgQtzuwnimVZi/iQRDcj8duAm1MDCgA3zOwUx7yNzc+AQPmQT0/P6wD5Z35dmGwtlxTYDkmix7HAdQ2wbzWhhfPPZqjyDFyJ4NcBb1KW4ka+Ewe2HIwGQyFd4d9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVJi2AS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVJi2AS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2DA1F000E9;
	Thu, 30 Jul 2026 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421584;
	bh=1vsXbGeW22lyFqlvm/TmJi/z925/E/HOFP4ksMJbxDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVJi2AS4EsugDm1mZV0W4mbRHDFnll1bWxieqACDVfgSDf57XSwL/bSlw2muX0XBx
	 Q5M58Sui/NvkdjdS3uy3sDSlkQkGOSn/z6rICd4IfQfjjgnpZwq386jV4aetPJZsEA
	 AnKEDGhJdJd6OA+HoSSQtp/a52Tjk5R9CV849Xtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Pambor <timpambor@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 153/744] USB: serial: ftdi_sio: add support for E+H FXA291
Date: Thu, 30 Jul 2026 16:07:06 +0200
Message-ID: <20260730141447.538887517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1073,6 +1073,8 @@ static const struct usb_device_id id_tab
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
 



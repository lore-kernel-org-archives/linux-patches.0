Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEC36D50D;
	Thu, 30 Jul 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423757; cv=none; b=NZKPPInN4k42/2hQVd0NwEyy7nHp3SNPlwr8yQf+5u/ezdYfq/zrGzY1Z+lHirvmSwr1or25DhGQ3GaHZcG+4s3BFu1Z0hmP53ffItv/jCWzj7/9yZYc3I/2Ifa2vP6r4YJqdiadEdUSjz10WuXRMTWs6c9nkomYWve1sGdOXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423757; c=relaxed/simple;
	bh=soyLnmZ6D96wbYRJKBeQtW1sJk5clUYkAM8GsJXfRJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQVS0K/YwEO+kGrr7WWRBVIcfKvzTY7lLNZRr6FgLrV9sjmPmsU0OlPAfp143MV6Thrb2wU2+NZd/XsoDz64528QjVN2BJWOOguxTieB6Np8EmW+FSug55N7ARjCROLkFLMv/fGKGLdV1ZCnea/5+u0Dk0hzYUtkd9xyP+gPNXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtEFExeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtEFExeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E901F000E9;
	Thu, 30 Jul 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423755;
	bh=6BSzehSKlgb3i8cK3y3F1B9LSB1wTEO0fO9atdBq7mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtEFExeLkjlTBtPfI+1Ss2S6ugJvavM5aeGUW7ftZSAsVzPpQgPQgsTbc0wMworb2
	 choq1TLHjE3v1x2kdCUBJQFV/aNt7uSRTSyw1Cnfw4p2mjau2Qi7RKNnVq12M1R/ni
	 ZYHDYmptUNJ9OlgbCA2mDGX5FFdFXXr3EIfKdq50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Pambor <timpambor@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 154/675] USB: serial: ftdi_sio: add support for E+H FXA291
Date: Thu, 30 Jul 2026 16:08:04 +0200
Message-ID: <20260730141448.410190639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5D41D625;
	Thu, 30 Jul 2026 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425604; cv=none; b=KZ5V9uEWxOr/+W0Pa9yEmm7G8hadHwb/0dYDDKDImwmjjRT6TK1Aavd21iQVxWqUK6JlCqB1TMtkTQ0Tr/JUpH7bnLQayMhIDGeeo6kdvH0jDv1JJcq3xgg8vZVRNx2LEZGrEDw6/nPUDHoXYbIIDh1lEQ5YIxZ6rYAVx/8LQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425604; c=relaxed/simple;
	bh=p0vrWzPXlee3wqwrNC79vTpiTSqlxan3Cxt20PiIcRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPHDU/IFqHrabWGrigIcikI5vg644qhK8vWy0FS0Lo4v3WtI6mkGIVRX9flQH+XpngzfNBU5oa9oqRLUNRdSMOfQFxLkQ7Lr8KMFuy3NUUmLxawmx5FFnG+a8LB93818OWAanPHB5cH0Bj2QtjWv9Hrxte/MlgVaV30Otz1ofdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYt50kjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYt50kjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A4B1F000E9;
	Thu, 30 Jul 2026 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425603;
	bh=ZpB665K7G992bkLH/gNwSPpGeepMvzToOe3+nZoy2Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYt50kjJ4XTj9nmf6zFzLQU0l/0UnS1W+gLY5G8T50nLGJt0NQfPI2MCu2vPn+54N
	 ibtiJQO8wmee9zoBG/248yPzBlNdSnSva8Vba98dQcMctvYMDRe2HKug8EuxQ0dt77
	 tvxmIvwI6d1XjY4xKe4HmhYJYSf1UWZjN4yG+oTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Pambor <timpambor@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 126/602] USB: serial: ftdi_sio: add support for E+H FXA291
Date: Thu, 30 Jul 2026 16:08:38 +0200
Message-ID: <20260730141438.634331330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
 



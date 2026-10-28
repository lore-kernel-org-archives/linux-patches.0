Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208736;
	b=QxSg+T+0l4U5BEDEdSS60DoV/9mUpGU9pidJIiMBHYiz8HWLo7C67jnYvSTWqtqoLBkL
	 cqFdyVlVHe3/t1LfI+rkXBpdQF4BkpTFZoa+rJjBMeXa9TywSjKX7BlzDO/mzPGCanms3
	 M6umnF69fdWU/1YVt4mf2OBEZChlektIFUEiwoq5W2SKSReCBsxHSQkCJR8//Fb9tKEg5
	 Bxa6tPCZEeTWraRapeo+TRJvA0mdiAdvNO95Fq8gFct0xTzLSfPuwO5X9K5Ba8nNlYygN
	 cERqAX/AjkdW3kOGygNDUHSqg5uL/1lwDxrpUALnXPjUtXQg9Kj6zNqkDrA5uZiwiAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wzSU08GEN8BcGUhcZdgtFWT0FgAFIsjjn7ISSxWRKQ4=;
	b=RHnGzqZ1PR3TiVkTqwYm108iauvVHPcvWhHDalTlFpEO7uTUDk3f3oIqfq40WX4XwrqH
	 eiw4/ujGdE4LbmvSEmEEuADwPJ6kDpbwAjVyz9fRIYoQdHHSrkCNiTaqYexaio8fqCciw
	 mxZwKKQMHcgjrIaWbjNt7/VvnR/vWuABVe0p0REJ3XUBmRX0wBoh5fIpqOGF8OW2MlBWB
	 K5+iMXZ+A6ku/rqqMzWQzLi2xfKRylJotTk/x3Fupbzgq1DuPJXmRrNxYpkd/fDcZt+YC
	 171C+UW4YIxBRPpgKDLoA9nDXHy55SPR8rkCgsMf04UZQYYsaRkueIoZJhy9WD9pvlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvE7QBGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034DC606A31A;
	Wed, 28 Oct 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvE7QBGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A601F01825;
	Wed, 28 Oct 2026 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208735;
	bh=wzSU08GEN8BcGUhcZdgtFWT0FgAFIsjjn7ISSxWRKQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvE7QBGQgOp5u/5r2J8W+3HAr3gy69+W2mjQ1ailQ6gfP5+rMh0+fwZTdNMLYsCdZ
	 +Tox3pPiU8d7sBbERtji9y6PLXCCUPDf9Sp5X/RDIm06/yaqK6eN6TUhvOhsZ0Rj6p
	 oaQrgSuTCn5z2YlNWWXnUIcU+mYBYv6xihpjQHlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Carrat?= <jeremy.carrat@icloud.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 223/516] USB: serial: cp210x: add Corsair AX1500i Power Supply
Date: Wed, 28 Oct 2026 17:56:15 +0100
Message-ID: <20261028170008.785932010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Carrat <jeremy.carrat@icloud.com>

commit d84e27d87738634b92001500435ae4dadba10a13 upstream.

The Corsair AX1500i power supply exposes its Corsair Link monitoring
interface on a mini-USB port through an on-board CP2103, using a
Corsair-specific product ID. Without the ID in the table no driver binds
and no tty is created.

Tested by forcing the driver association with

  echo 1b1c 1c02 > /sys/bus/usb-serial/drivers/cp210x/new_id

and then setting the serial port to 115200 8N1. Adding the ID is sufficient
to talk to the device: the tty reaches a USB-to-SMBus bridge sitting behind
the UART, which identifies itself as "USB to SMB Bridge (Firmware by Ross
Fosler)" version 0.9 and relays PMBus reads to the power supply controller.
Input voltage and current, input and output power, internal temperature and
fan speed were all read back on an AX1500i.

  [    7.806181] usb 3-14: New USB device found, idVendor=1b1c, idProduct=1c02, bcdDevice= 1.00
  [  698.526754] usbcore: registered new interface driver cp210x
  [  698.526767] usbserial: USB Serial support registered for cp210x
  [  698.527863] cp210x 3-14:1.0: cp210x converter detected
  [  698.529263] usb 3-14: cp210x converter now attached to ttyUSB0

The related AX1600i (1b1c:1c11, iProduct "USB API") is expected to be the
same kind of device but has not been tested here, so it is not added.

Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Carrat <jeremy.carrat@icloud.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -227,6 +227,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1B1C, 0x1C02) }, /* Corsair AX1500i Power Supply */
 	{ USB_DEVICE(0x1B93, 0x1013) }, /* Phoenix Contact UPS Device */
 	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */



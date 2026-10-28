Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211047;
	b=FPk5c5Mig8zGq2nLJGi3lWuedo4LgywJWJkfX7h6dET/qNZAWO4i9MvUQ55yjJ0hh6ml
	 aAVbKYV+btdBYkSdyAI4i3cXqmA01cO0coWDS/Aq/cKbBHaWmWyhRXIFBf+FVSvonaPh0
	 gv2u7dSQPtnULEfoSdNf3b1fNWdjcnmXEVgFMsRVW/GwVyK2y9UjAoAv+1yb368E37it0
	 LNxMS40lNofXDxl8WCd6TnXg/lQvUlKAcys91Bs+r0bKUbC5CF5651vlnfmYFL7+8ZBZm
	 TYhenKqCSTuLo/bJVKXhzm1+6+ruOPt5NDgmp844/C9a8Npmd9Lr+TFOAi9YfyiLYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mOX0q4dUtnv4O0KH9LhiM6CiCRWjwx1y04YGPdmUpHM=;
	b=ZJDpQpnl5CYLGYt3/31DhgGa5hNkL9QyJ0QEwt8E+qcgBAXhC5RLjqhR2rB1cbH23QaU
	 K3eu9fSCNyFIXW1pAHNPx2WcBIzdu9InUcL7Z08k1yDxO3MIn1nL1Xmm8NlwmGYGhem77
	 PftOziUi/Ie9sZThkMp5gPCl2nj7ja3t7/ERdeMZpPu0DnDIMAOGc6towTmIGzbf2Uag2
	 iSUq/QODpq4I+4yeaSShB0GtRq2aSpSwG8rCq5eqt+s8kBtvNLGT+7Ryor7Wl2NsjOJtS
	 tDRgArQoTer/jCPrbBuVQWhTTGkGtN1DeuZAbN4e9YHEuR9A3Rsud/esWVMLShTHeXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhM8abY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089CA60A5BFE;
	Wed, 28 Oct 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhM8abY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578561F031E6;
	Wed, 28 Oct 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211046;
	bh=mOX0q4dUtnv4O0KH9LhiM6CiCRWjwx1y04YGPdmUpHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhM8abY7Ox+NOaSPubbB+7RsQ5Ab80u2OrESim7UnFc0tmpeKqwJWPXR++9GIn4Mo
	 Lm+yt07ZGZoaUShGoTAR78TshxxR9ZKuK1K0aYaNj5XrSE4idTRB8yuSMVTKDqs5tT
	 HvKW0O8bPa3m4anDfdjHRkhPiMliHZtZo8ZSabrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Carrat?= <jeremy.carrat@icloud.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 241/571] USB: serial: cp210x: add Corsair AX1500i Power Supply
Date: Wed, 28 Oct 2026 17:56:28 +0100
Message-ID: <20261028170013.724230814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,6 +223,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1B1C, 0x1C02) }, /* Corsair AX1500i Power Supply */
 	{ USB_DEVICE(0x1B93, 0x1013) }, /* Phoenix Contact UPS Device */
 	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */



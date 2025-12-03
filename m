Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58834DB67;
	Wed,  3 Dec 2025 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780918; cv=none; b=iLltf5hPUoim2nGoXKqkzSqk5RaxxdheHwElPDC6/W7NONEmoMTv/rX8q2+YaE8xBqWmerzBFia4MDUkDF25So0ES433Z4RpJr5LpgSCQftXcsgX6FSAPkMTBqRB8oohzkAOfYtelNyGhFxBY358UIURfSUUL9J8h9LWLnUDAfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780918; c=relaxed/simple;
	bh=hBWAgzI8pWOsAip4xrtbrINqoHcM7qhnU2nH6c5Yl5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nE1OdkXMnhEarZvXgf+Eo1dBCxSEKAxdvsMAFt+0ZMU4STMpwh3I+bV/WBQHX+uBWMVdqLXij93ZfOy4DlcHVQIlIx2vwt6HREjTbvbdJn2NXw3ceGZV2v4ryNk4MHcIhJihtR2npUhl/TBiovot4d5aqJGes//gyh82oSap+FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6ydeJ82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6ydeJ82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155ADC116C6;
	Wed,  3 Dec 2025 16:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780918;
	bh=hBWAgzI8pWOsAip4xrtbrINqoHcM7qhnU2nH6c5Yl5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6ydeJ82R/Wo9b9pLjBcYcH33ZaPZM5SARRuTtX8LxTabNlXGGgV5+XqfQNzq5Scw
	 3+QxzXuV3Z/R+k4eDRpYswCij5hQzBEFZCbU8hJ1yHtc1WibblUymlVDbGEo8kJ4Uq
	 LlMhLmMgaFU4J8rHfdPOK41MBLlRtyu2dBqFU0ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Suvorov <cryosay@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 101/132] USB: serial: ftdi_sio: add support for u-blox EVK-M101
Date: Wed,  3 Dec 2025 16:29:40 +0100
Message-ID: <20251203152347.027462918@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Oleksandr Suvorov <cryosay@gmail.com>

commit 2d8ab771d5316de64f3bb920b82575c58eb00b1b upstream.

The U-Blox EVK-M101 enumerates as 1546:0506 [1] with four FTDI interfaces:
- EVK-M101 current sensors
- EVK-M101 I2C
- EVK-M101 UART
- EVK-M101 port D

Only the third USB interface is a UART. This change lets ftdi_sio probe
the VID/PID and registers only interface #3 as a TTY, leaving the rest
available for other drivers.

[1]
usb 5-1.3: new high-speed USB device number 11 using xhci_hcd
usb 5-1.3: New USB device found, idVendor=1546, idProduct=0506, bcdDevice= 8.00
usb 5-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1.3: Product: EVK-M101
usb 5-1.3: Manufacturer: u-blox AG

Datasheet: https://content.u-blox.com/sites/default/files/documents/EVK-M10_UserGuide_UBX-21003949.pdf

Signed-off-by: Oleksandr Suvorov <cryosay@gmail.com>
Link: https://lore.kernel.org/20250926060235.3442748-1-cryosay@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1074,6 +1074,7 @@ static const struct usb_device_id id_tab
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
+	{ USB_DEVICE_INTERFACE_NUMBER(UBLOX_VID, UBLOX_EVK_M101_PID, 2) },
 	/* FreeCalypso USB adapters */
 	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_BUF_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1614,6 +1614,7 @@
 #define UBLOX_VID			0x1546
 #define UBLOX_C099F9P_ZED_PID		0x0502
 #define UBLOX_C099F9P_ODIN_PID		0x0503
+#define UBLOX_EVK_M101_PID		0x0506
 
 /*
  * GMC devices



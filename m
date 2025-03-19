Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBC71E5B8A;
	Wed, 19 Mar 2025 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395108; cv=none; b=VjmSlIaiViQ6rA2aR5gxo/jUHny1PjenuOmaIRFTFc4KV0SyISq+5BaD3ennh9LTnuE3BTplsOeSDmW1JlUAWPe+KBXTz3mi+IOyKJ3NwEuGvmA6FrgyCuDtVthwxxA7x+tZW49TAnvPHwxTPJZdKKSDZgd82rQhVN6hIZoacYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395108; c=relaxed/simple;
	bh=1+DasE7nnkIlMmDgrtGv7vI8GznylRCobX9vVd6DUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1QGr7R9iAUrx6unOLmG5FRXLi2UmMJIEsgy0Mys+qsSkMxDptYhTK1k5fEEUfizvoqmVgBzn8ceu0Y5EYxL7L5W4Mayli6ivCf1WrSZu1YR8Uy7kYntpVOcR882iei6og+y41jIRrPcCmPzKY30VDSzSSWmKZekp3skmYnccFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Izuf4XnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izuf4XnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A06C4CEE4;
	Wed, 19 Mar 2025 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395107;
	bh=1+DasE7nnkIlMmDgrtGv7vI8GznylRCobX9vVd6DUL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izuf4XnBsUGaSp4667Hf2O8j1VqhNDUrK9jYZhtr/FeTkbS8HuIMtTKaukxR+kMBW
	 NmIxEmn/lYEZMhiJFRLFAwKDhGd0XjQ26R7U+lF/YWgT5P63841J2iunqG2o6OCulH
	 zgNLq6v4FdvfBjEnvKRXfhJiyeE6hnYQw3kpql7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Daniele Palmas <dnlplm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 161/231] USB: serial: option: match on interface class for Telit FN990B
Date: Wed, 19 Mar 2025 07:30:54 -0700
Message-ID: <20250319143030.817459094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

commit 9a665fe3d967fe46edb4fd2497c7a5cc2dac2f55 upstream.

The device id entries for Telit FN990B ended up matching only on the
interface protocol. While this works, the protocol is qualified by the
interface class (and subclass) which should have been included.

Switch to matching using USB_DEVICE_AND_INTERFACE_INFO() while keeping
the entries sorted also by protocol for consistency.

Link: https://lore.kernel.org/20250227110655.3647028-2-fabio.porcedda@gmail.com/
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Daniele Palmas <dnlplm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1410,22 +1410,22 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(0) | NCTRL(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c8, 0xff),	/* Telit FE910C04 (rmnet) */
 	  .driver_info = RSVD(0) | NCTRL(2) | RSVD(3) | RSVD(4) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d0, 0x60) },	/* Telit FN990B (rmnet) */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d0, 0x40) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d0, 0x30),
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x30),	/* Telit FN990B (rmnet) */
 	  .driver_info = NCTRL(5) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d1, 0x60) },	/* Telit FN990B (MBIM) */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d1, 0x40) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d1, 0x30),
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x30),	/* Telit FN990B (MBIM) */
 	  .driver_info = NCTRL(6) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d2, 0x60) },	/* Telit FN990B (RNDIS) */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d2, 0x40) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d2, 0x30),
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d2, 0xff, 0xff, 0x30),	/* Telit FN990B (RNDIS) */
 	  .driver_info = NCTRL(6) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d3, 0x60) },	/* Telit FN990B (ECM) */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d3, 0x40) },
-	{ USB_DEVICE_INTERFACE_PROTOCOL(TELIT_VENDOR_ID, 0x10d3, 0x30),
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d2, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d2, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d3, 0xff, 0xff, 0x30),	/* Telit FN990B (ECM) */
 	  .driver_info = NCTRL(6) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d3, 0xff, 0xff, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d3, 0xff, 0xff, 0x60) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),



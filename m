Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FBF3BF303;
	Thu, 15 Jan 2026 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497252; cv=none; b=t38kQkpUy/7YNxeUboFpy1xYjgwB8XoLXgb4Zoab8Bj8gq2/xJO+FQmtOGwczyDNDIYOkl903oA5t1eeQ4EPKseVNamzAYfCFGRox/sCdt4B687ZJfw1JlUKIGDVwKTE9FJDUJxXZ/BIDWX5T9ubVIlInJovh961ms4BweQ1rxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497252; c=relaxed/simple;
	bh=SeH6I710LZsg+grZloBeJYkh5H8Df/PrqbixhGMZpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lY4TF6REFKOkVHG4VdWjtjNK/1azUxgLfxe5vnhNzVdIYR6q7QUdciqU/FsZjZC6CDxx7b3PaMorfh44xB1WFq8cNy/kC21W84KmY0FICsgGdbxQ4dTrAH3s5l8IWtfGiT9JGytWVSI+ajwdfGNC5ZC8QRYtRh8b/C9/zvxgHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO9iKcXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO9iKcXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F34DC116D0;
	Thu, 15 Jan 2026 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497252;
	bh=SeH6I710LZsg+grZloBeJYkh5H8Df/PrqbixhGMZpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO9iKcXbU7MeaUcEQvZSjoNGFmLOExqhVBdsWKILGp4mRaEUUGUilxXMe3WpZ9OpF
	 gGR5ChYyiW7supk/tEnaTAz+m74hFu/zICtlBdzhU9+2NRzZqv3UhRRR2WYIZlXix8
	 bhL8TEigglCXdPy1aZWu5PtabiN4UlBhc3r5CjG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 017/554] USB: serial: option: move Telit 0x10c7 composition in the right place
Date: Thu, 15 Jan 2026 17:41:23 +0100
Message-ID: <20260115164246.865164985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 072f2c49572547f4b0776fe2da6b8f61e4b34699 upstream.

Move Telit 0x10c7 composition right after 0x10c6 composition and
before 0x10c8 composition.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1445,6 +1445,9 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c6, 0xff),	/* Telit FE910C04 (MBIM) */
 	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
+	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c8, 0xff),	/* Telit FE910C04 (rmnet) */
 	  .driver_info = RSVD(0) | NCTRL(2) | RSVD(3) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c9, 0xff),	/* Telit FE910C04 (MBIM) */
@@ -1455,9 +1458,6 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x60) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
-	  .driver_info = NCTRL(4) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x30),	/* Telit FN990B (MBIM) */
 	  .driver_info = NCTRL(6) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x40) },



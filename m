Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9E32ABC0;
	Mon, 13 Apr 2026 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099527; cv=none; b=pBX6mQ4SVnoYrmb/iMxiZAkB6wN3bPLhBqONikbPoqvBbvPfbSysRxVKHmgIj4bvRHbzTScrgUkyozmdWqRfLqJ37b6krI4k14bFFgSD64LFfTPv0NL/1UjDsTalpJZ4MYh8NE9AXca5XIuvqYxkMOF/6Q0X0nt3qA4J0D+MbLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099527; c=relaxed/simple;
	bh=+W6Sp36lJcWuHczdGqicwpB/23IoLhRDBbmm1CGZS60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K913ogIsB5D/muCPCbySdQqEQXZUKC02XII2gWWK9yHZmW9MjH/Xc9m01nv3AlPHdE+Sf8C3f7HW4zhGVNCIiogSOl/Jgacix1TOutmhY1hhyBW3IVtRtLNYNiPaP1DeBkAzlIbJzXc8mL9pjk1BD/yaQqplPjFE3njRuCfzWrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmXNe3A/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmXNe3A/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1900AC2BCAF;
	Mon, 13 Apr 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099527;
	bh=+W6Sp36lJcWuHczdGqicwpB/23IoLhRDBbmm1CGZS60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmXNe3A/x9FkmI8OoBhYkYlrJNamQfY8XyjX0Hy1itAHd93zMVSZHjnDQOFBUQy3P
	 bbeTGrpqw/vCdiA58ERWJwlomhYLk9OXG7ExmhhyvmRovDu917B4K55iPZMk1NUZMK
	 jg1eYHOQoY60XocOyz5FQRzf9DVQTCSqjP6c5PTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frej Drejhammar <frej@stacken.kth.se>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 374/491] USB: serial: io_edgeport: add support for Blackbox IC135A
Date: Mon, 13 Apr 2026 18:00:19 +0200
Message-ID: <20260413155833.037033927@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Frej Drejhammar <frej@stacken.kth.se>

commit 0e01c3416eb863ee7f156a9d7e7421ec0a9f68a0 upstream.

The Blackbox 724-746-5500 USB Director USB-RS-232 HUB, part number
IC135A, is a rebadged Edgeport/4 with its own USB device id.

Signed-off-by: Frej Drejhammar <frej@stacken.kth.se>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    3 +++
 drivers/usb/serial/io_usbvend.h  |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -73,6 +73,7 @@ static const struct usb_device_id edgepo
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_22I) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_412_4) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_COMPATIBLE) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_BLACKBOX_IC135A) },
 	{ }
 };
 
@@ -121,6 +122,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_8R) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_8RR) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_EDGEPORT_412_8) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_BLACKBOX_IC135A) },
 	{ USB_DEVICE(USB_VENDOR_ID_NCR, NCR_DEVICE_ID_EPIC_0202) },
 	{ USB_DEVICE(USB_VENDOR_ID_NCR, NCR_DEVICE_ID_EPIC_0203) },
 	{ USB_DEVICE(USB_VENDOR_ID_NCR, NCR_DEVICE_ID_EPIC_0310) },
@@ -546,6 +548,7 @@ static void get_product_info(struct edge
 	case ION_DEVICE_ID_EDGEPORT_2_DIN:
 	case ION_DEVICE_ID_EDGEPORT_4_DIN:
 	case ION_DEVICE_ID_EDGEPORT_16_DUAL_CPU:
+	case ION_DEVICE_ID_BLACKBOX_IC135A:
 		product_info->IsRS232 = 1;
 		break;
 
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -211,6 +211,7 @@
 
 //
 // Definitions for other product IDs
+#define ION_DEVICE_ID_BLACKBOX_IC135A		0x0801	// OEM device (rebranded Edgeport/4)
 #define ION_DEVICE_ID_MT4X56USB			0x1403	// OEM device
 #define ION_DEVICE_ID_E5805A			0x1A01  // OEM device (rebranded Edgeport/4)
 



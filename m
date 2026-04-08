Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3013D75C9;
	Wed,  8 Apr 2026 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673940; cv=none; b=IN8bHVjyA7AC6JmiGogQQAd7IsyL5jf6Dt/17tCnz/dXNh0cCCmHNrs/JjfQN3bQgoKP7S8ZXeGtfsiRQbX4ox/XDwO4lLL/MOeqxzDk11b+2EEMmTiWGyS6BDgnEK+YUig8X3ME7PYBBPuUoMzmLbkdGC25w0rlCXKr6iDoMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673940; c=relaxed/simple;
	bh=wazmvySSb9QS8q0hDoKB30/SlXo3yoSZOWuddTqt16E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiPT0wVYgw+oA1mm9rItVmn7LU56Btb4ggP2N70tQseTb8U+QWHfPwbqWdb72wtjvvpRVcfoTPmmjZw4npQJrOhnTivJjMH2hZpqB92puienJMnLLFXAcitC2HgKetBkiR9sR9YbN+J62CefwBJQeTWALby0x/NpZDOkEQyHO0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nye2jNlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nye2jNlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54A7C19421;
	Wed,  8 Apr 2026 18:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673940;
	bh=wazmvySSb9QS8q0hDoKB30/SlXo3yoSZOWuddTqt16E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nye2jNlov794Nj5TsITR9VVkSL/VC7P+oPYiCyMeOLeyD55EB2EXJuYlj+h1cn0ms
	 /VwOHtwzvS71Zjc7vWYC6fgys7Mam3/UDr90u15O0gAkdEjP0YW4AzrREuUyt7BOHS
	 EROqKkhOs6WKnKHZYZ7JWstYp7PQlyFbu+b1sXdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frej Drejhammar <frej@stacken.kth.se>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 140/242] USB: serial: io_edgeport: add support for Blackbox IC135A
Date: Wed,  8 Apr 2026 20:03:00 +0200
Message-ID: <20260408175932.328116457@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
@@ -470,6 +472,7 @@ static void get_product_info(struct edge
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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6782B9BC;
	Tue, 23 Jan 2024 01:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972128; cv=none; b=G5AIC6hXtd0W3CrXyh2V64N8jC3n230jdMXhtSssdVouVxOEwVDax044jvUU0oWyLec2UDpqakIBkLcUbwIEK8O5qRofTpIXIkdlgJ6+K5/LTwFE83wDVrg5V7WCmSPAm0Vg8IlzYNAIRZOPmOtvSMcmhq+X6NKloAIQK1JPG7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972128; c=relaxed/simple;
	bh=hEU1ln/764O/EuE7v4soC2GhtBYVKBNayYx6Tjl2mh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYIGGpg6QNONMkI/M/Arc5RAqZxUhH2GkSAq6Tl2+ykeoLnvx8GS1HWjtj5edG6xBEqecA6EpoHtvnkgInpa2JjztsgZbLxQAGzWFjHN1FH3VnDOqRzPfDIzwLv68Avj7EKdoq4xaj2f9fr9RQFVj8uupRoj039zFwmhePyFuCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZZtha3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZZtha3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5581FC43394;
	Tue, 23 Jan 2024 01:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972128;
	bh=hEU1ln/764O/EuE7v4soC2GhtBYVKBNayYx6Tjl2mh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZZtha3UCyM+DAc15QX+fiTI1Z3++GM4a4BOzDZkZI5KRWKjE+LyrjCT8qnGH6NJS
	 2xZN47Z+0470Us902J1JBAeKTRN9CaVR/ZO1yg0qIsyXsOefgWsuWgnk5eIPBPF+rB
	 stj0Iuz/2Nrvrav/HSkk5bCYAozh0rS9d15+53WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 061/374] parport: parport_serial: Add Brainboxes device IDs and geometry
Date: Mon, 22 Jan 2024 15:55:17 -0800
Message-ID: <20240122235746.738200256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cameron Williams <cang1@live.co.uk>

commit 6aa1fc5a8085bbc01687aa708dcf2dbe637a5ee3 upstream.

Add device IDs for the Brainboxes UC-203, UC-257, UC-414, UC-475,
IS-300/IS-500 and PX-263/PX-295 and define the relevant "geometry"
for the cards.
This patch requires part 1 of this series.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/AS4PR02MB7903A4094564BE28F1F926A6C4A6A@AS4PR02MB7903.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/parport_serial.c |   56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -285,6 +285,38 @@ static struct pci_device_id parport_seri
 	{ PCI_VENDOR_ID_SUNIX, PCI_DEVICE_ID_SUNIX_1999, PCI_VENDOR_ID_SUNIX,
 	  0x0104, 0, 0, sunix_5099a },
 
+	/* Brainboxes UC-203 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0bc1,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0bc2,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+
+	/* Brainboxes UC-257 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0861,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0862,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0863,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+
+	/* Brainboxes UC-414 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0e61,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc414 },
+
+	/* Brainboxes UC-475 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0981,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0982,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_uc257 },
+
+	/* Brainboxes IS-300/IS-500 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x0da0,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_is300 },
+
+	/* Brainboxes PX-263/PX-295 */
+	{ PCI_VENDOR_ID_INTASHIELD, 0x402c,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, brainboxes_px263 },
+
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci,parport_serial_pci_tbl);
@@ -550,6 +582,30 @@ static struct pciserial_board pci_parpor
 		.base_baud      = 921600,
 		.uart_offset	= 0x8,
 	},
+	[brainboxes_uc257] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 2,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+	[brainboxes_is300] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 1,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+	[brainboxes_uc414] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 4,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+	[brainboxes_px263] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 4,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
 };
 
 struct parport_serial_private {



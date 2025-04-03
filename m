Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468E2512FA;
	Thu,  3 Apr 2025 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693807; cv=none; b=izZqsq7w5RSFw+acNENsdBzUpc/iGWyOkKN3Q+vvHZyWwj3M50TTz1bdKt4upkoDHvaGYoUyP5h9MgOYPMJ4xDBXgQ0vdLOT4xCs8jsggIoFPsfr6B5HQPp7tYtkfFqbGvURpAXp2+DUg3tsSULB/cyq/Vyx5/390hOnEnB8Js8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693807; c=relaxed/simple;
	bh=iqqofYLwV6SnD2NaqXJjYAC5KDbnzjJYvTfsLOOacAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFAyUejQ2I2oGJP8gF2jQsUnGP3TLasJntqwgSo2qapv5b9iJ3Tke5eGLjy7WUhg3Mfz9dYbuPphDoMWZVQdpNyivShthdMHA9KsmBkr8VaFSYp4UyMx0xnjJ4U/Q8xkYYUeFWMSh/A8dk2xMO/vnknUUp02/O8V9euhS3Wez3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1ELfjDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1ELfjDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B4C4CEE3;
	Thu,  3 Apr 2025 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693807;
	bh=iqqofYLwV6SnD2NaqXJjYAC5KDbnzjJYvTfsLOOacAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1ELfjDSyXULGl4EvDgL/rOYQPU9ZuTQufcXah3LBpp+ODidB3UDM50Dm9dZSfGz2
	 oQgzfsRQMPFKuCMSCPT6UF4bUY8UKlC8+M7BYT0N1JPvPi222NKp1PBhf58vt/wByx
	 F9AtnXh8WX0GK5IeVq5X31hWuzyf94jTshDxlwWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.14 11/21] tty: serial: 8250: Add Brainboxes XC devices
Date: Thu,  3 Apr 2025 16:20:15 +0100
Message-ID: <20250403151621.464073906@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Williams <cang1@live.co.uk>

commit 5c7e2896481a177bbda41d7850f05a9f5a8aee2b upstream.

These ExpressCard devices use the OxPCIE chip and can be used with
this driver.

Signed-off-by: Cameron Williams <cang1@live.co.uk>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/DB7PR02MB3802907A9360F27F6CD67AAFC4D62@DB7PR02MB3802.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2728,6 +2728,22 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_oxsemi_tornado_setup,
 	},
 	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4026,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4021,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8811,
 		.subvendor	= PCI_ANY_ID,
@@ -5615,6 +5631,20 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_oxsemi_1_15625000 },
+	/*
+	 * Brainboxes XC-235
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4026,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
+	/*
+	 * Brainboxes XC-475
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4021,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
 
 	/*
 	 * Perle PCI-RAS cards



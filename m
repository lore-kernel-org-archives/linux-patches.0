Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A224CEE5;
	Thu,  3 Apr 2025 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693861; cv=none; b=Ip/pVmwrzlUl+16NGAMUavfHg8TNx6Yw8HScQcMpNDRZR76YAXFW7ZKOkLiHq2hi/XemMjRWSU6CYZvB2yIfMCmKEN6isBJYny4ooBF38tgYjk7U85dXkPqfNN8jmKupo/rQ5wbMnnqM6O5zhIMndq6fcjeC0agclFfTGjqxJhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693861; c=relaxed/simple;
	bh=Gx+KUTx8dfsRvwAeHYXyabRoaCFB0NWVrJEDGNErjFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEH+fvmbUYXjAX3aVWrm75WfTzqyHuafQ886iSTVeo+Ht7tUPEn1dWsxa+spVCVUmpbFERa6QwvLaWatSuYqYzqN90gdfZLxy+HKcSVO4nV6t7FNrxSzYrAotAiWz5oVx7p+0vwbjlk78TAtvLDA8ceAzl5EHT28+YUiQpB91xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lw+L8hyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lw+L8hyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A00C4CEE3;
	Thu,  3 Apr 2025 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693860;
	bh=Gx+KUTx8dfsRvwAeHYXyabRoaCFB0NWVrJEDGNErjFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw+L8hyqqlDDl31Igt+7bgwmdYLj6RPPKsh6SMXhfl2qGzZ9jPgR2cSwnhqPP40RU
	 l5MCDdHdZJ57CgQ8V/ltVpgyL9PUdt9+n0WniT6vi67eGiyAD/MUgHARaF1WXjWXA8
	 tDvg7TuvWcF2jcDeMBECU+TZMxIFZwQiqynyBExs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 11/22] tty: serial: 8250: Add Brainboxes XC devices
Date: Thu,  3 Apr 2025 16:20:21 +0100
Message-ID: <20250403151622.363632203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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
@@ -2688,6 +2688,22 @@ static struct pci_serial_quirk pci_seria
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
@@ -5575,6 +5591,20 @@ static const struct pci_device_id serial
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



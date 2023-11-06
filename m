Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98022EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxvRxdEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C203C433C8;
	Mon,  6 Nov 2023 13:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277386;
	bh=qfWNYSNLXJyIVxctsBcWN7DJScUVgfUNotFIs9XxtZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxvRxdEpJJikIFdYmhJp95MhOe0XthJXHkFANPd6eHAnIK5N0QIaJ7zbtm7+dh5fl
	 WE4LxGbd/sBSAkFUGQj/sqjjShDsSF11iNQmq9ot8OWnaYCEOqbhtcU/wDhJ05DzK0
	 VnL8r9tcLjn1RltLL25plh6oEw/YDunV842VQvH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 5.15 126/128] tty: 8250: Add Brainboxes Oxford Semiconductor-based quirks
Date: Mon,  6 Nov 2023 14:04:46 +0100
Message-ID: <20231106130314.889334237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

commit e4876dacaca46a1b09f9b417480924ab12019a5b upstream.

Some of the later revisions of the Brainboxes PX cards are based
on the Oxford Semiconductor chipset. Due to the chip's unique setup
these cards need to be initialised.
Previously these were tested against a reference card with the same broken
baudrate on another PC, cancelling out the effect. With this patch they
work and can transfer/receive find against an FTDI-based device.

Add all of the cards which require this setup to the quirks table.
Thanks to Maciej W. Rozycki for clarification on this chip.

Fixes: ef5a03a26c87 ("tty: 8250: Add support for Brainboxes PX cards.")
Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB7899D222A4AB2A4E8C57108FC4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |  147 +++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2719,6 +2719,153 @@ static struct pci_serial_quirk pci_seria
 		.init			= pci_oxsemi_tornado_init,
 		.setup		= pci_oxsemi_tornado_setup,
 	},
+	/*
+	 * Brainboxes devices - all Oxsemi based
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4027,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4028,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4029,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4019,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4016,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4015,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x400A,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x400E,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x400C,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x400B,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x400F,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4010,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4011,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x401D,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x401E,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4013,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4017,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTASHIELD,
+		.device		= 0x4018,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_oxsemi_tornado_setup,
+	},
 	{
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8811,



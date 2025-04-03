Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D4F250C02;
	Thu,  3 Apr 2025 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693753; cv=none; b=sKWXM8fCGug0URVncOpoYwJJZh7WqnQbWZ+KTamQsyqTIKYmUTD9O/f69PjdjpVoNwNtw8g/13AUwuIxAUrcFuZMXE7xoeFuQGCn+lKQ9AMlSCPWmdPwu3iGiqqgHEugYalKCPEeWuyXUlvnnelGt4q9QtVpzrcox/AJHT394mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693753; c=relaxed/simple;
	bh=UWQNiqRHXOJ8vG5kQEhTDiArkjbFQG3SlRx1W6ziaXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqo2OEWY9FsGflnvFhdIHjS1p/5IwcT0H0eL+iD4b7oDxpycIn155HVgfwWQz9FfN8x1z2PYUQfGYlaK6dfP3ZlsD5vkrymvfC4QP/dzd06OraXZkKIbr/m4VnfpPef1MW+zbKxusgtfPr8WDTcRw8FF7xcCvpYBczrk6sh2aCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdBOx4hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdBOx4hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC149C4CEE3;
	Thu,  3 Apr 2025 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693753;
	bh=UWQNiqRHXOJ8vG5kQEhTDiArkjbFQG3SlRx1W6ziaXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdBOx4hn4D7ZaMQkJKSZA6hPc4m+VEttHCx8IwzJ3mRfFoh1UQYhakXwXJJpDoMKN
	 +Y3TkCnvksl+HT5AINT0ekRl6rwDVK1lnCGsS2PcRfCJLcXnAS0w/uLmUJ+kBJqRso
	 BK5c0QZfWkwAYGUkcxCeCq5Wzc6E0ny+mCsYNt/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 13/22] tty: serial: 8250: Add Brainboxes XC devices
Date: Thu,  3 Apr 2025 16:20:08 +0100
Message-ID: <20250403151621.309714911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2597,6 +2597,22 @@ static struct pci_serial_quirk pci_seria
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
@@ -5489,6 +5505,20 @@ static const struct pci_device_id serial
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F652641CC;
	Tue,  8 Apr 2025 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112713; cv=none; b=Z0UmhFboqDwavqWAtDB84a83HGQevLan54wj8Diy51MDHHJG840G2vrq43/YLtIDIw8mMZJdtSHMdLzW5MwBrKLDQpJkg2QOFUGg+CqWdBy2pqDv+W2OxOcHIvKXLdmZAowt1YiAEklT0nMHCB8l9AhjFBL01Owb9MYGFTrI/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112713; c=relaxed/simple;
	bh=l4jp40eoBndLVAMb45+0spEwmOOoLmXVZTWRGBO+01w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+bWEzlWaCaP0CsmvwLNV7Pa8uGbenwQzUXvH0aLE3vfofVURc4F159op6pug2Xg+BZPQck+s3FVtUjr30SFb+CatTbn31fjQavqilQCvFTbn8BsgC6AWL2K+mDV6uyZv8IOw3DD4jAd6vZ/GAeOncN0ULC0lPnbgrZz32vOHOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmccTOAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmccTOAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE81C4CEEB;
	Tue,  8 Apr 2025 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112713;
	bh=l4jp40eoBndLVAMb45+0spEwmOOoLmXVZTWRGBO+01w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmccTOAg+Z5fDlqhJQQ8nrN7tz06H8Lo+w5NTUoky3hn9lFMWgVK8PTKc0K2FCQ61
	 mVYTQH4vllAZ34574dWikjU3R0UiRYae1A/G+CQIgGnFDetREpLiE0wrt9u1++GRIb
	 k64eAalbzKoJnMt8/KKbunNFwhNCHl09nv6GyS2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 121/279] tty: serial: 8250: Add Brainboxes XC devices
Date: Tue,  8 Apr 2025 12:48:24 +0200
Message-ID: <20250408104829.614035872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2869,6 +2869,22 @@ static struct pci_serial_quirk pci_seria
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
@@ -5898,6 +5914,20 @@ static const struct pci_device_id serial
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



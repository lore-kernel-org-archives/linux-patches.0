Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045253;
	b=mikM4sX74aLjb9tZEMpzgE94kThnAGDjA33TEw3pY0MOh0FoWwJ7PDe40vFbuPfSGYUV
	 tO34OB+wKPQV0vnVlUOw5Opf7NrMppJWNa7ZB4XfLydRDb8tCwQsLx5PUNeWHCBV3VuJk
	 UzNv8OrUDB2uul0fjlqIOoWySW4ovtTGG00GjTeN2VKkHES4USTSxDmy5DGJVNKf6bSD3
	 gn/oATKq324oHu19kzCLZtvOjgBK8d4BZNFmL0Kh5tPJOEqS/41gFLdtNB9qK9Fx9e/UJ
	 iYWWZiclKqTkMYt452POUIyJoWUHZ6jsiqYThfRRwbOSga67lA3PWAzWai3C5/p27mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lbmXLymR1V8WmHSwQGgGTntDoWj8YxZ8oXqocJadVAY=;
	b=YYla6Z+iwhKS9IeD7R4tZUdYFrAVUkNdT0LDGl1SZYW9/cTpD2kXo3vqLyTP+eRdpnBy
	 yw9Uq6NxLQDI1HosPDw4h/DwUWw+qQOly/uGmp38Cg25ezMrWCvAX9RGMbGV60Nsdh0UN
	 7rJNMiIompATcns4C5TPrAn4Dm2CrskQksTOwzilZf62NloyqLbBEeB6Jc/1jQ0TH9mZV
	 8cHF399n3813FEtE/VFPh5zSKbvshSRywaxfDkaiF/lkIZD/dca4bBObKHsS5DY433FZs
	 3e55ZM+jcm9K4jkrtV1w2rKuIJpt0ZQaw154eNRB/Kfc95lswc5h04qSVouxeDpH7mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8RqabW2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1057606A31C;
	Wed, 18 Nov 2026 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8RqabW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415461F000C4;
	Wed, 18 Nov 2026 23:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045252;
	bh=lbmXLymR1V8WmHSwQGgGTntDoWj8YxZ8oXqocJadVAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8RqabW22iZUMNu8xqGF6IyUoNL3jbY2W54NLPvN7n6WdSc4TwL31N+AmK6P8kGI4
	 WF2DjmVNErrJIzWveWBCiat6oA00ZqJ3ICuaNttjGImtBV51gil0xMN4TyqnmKzjJj
	 Fy5rer7KMxjnkOBZ4rqfvAW+Q7oz1H28bwkbPAjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0857/2857] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Wed, 18 Nov 2026 15:31:31 +0100
Message-ID: <20261118150232.423331851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 5f30217ec296fb5742f6fd306586dbca5b81b4eb ]

With MSI, the ULi M1575 EHCI controller (10b9:5239) intermittently stops
executing its asynchronous schedule. Control transfers time out ("device
not accepting address", "device descriptor read/64"), the port is handed to
the companion OHCI controller, and the device ends up at full speed. On a
configured hub the stall shows up as hub descriptor and status read
failures. Only re-initializing the controller recovers it.

On a Sun Ultra 45, 65 of 800 controller initializations stalled with MSI
and none of 200 with INTx. Each initialization is an unbind and bind of
ehci-pci on the EHCI function, with MSI or INTx selected through its
msi_bus attribute; with this quirk, 0 of 100 cycles of the same loop
stalled. The stall reproduces on a kernel that already contains commit
0b60557230ad ("usb: ehci: Prevent missed ehci interrupts with
edge-triggered MSI").

The OHCI functions (10b9:5237) keep MSI. They showed no stall, and the hub
enumerated through them on MSI during the EHCI failures, so only the EHCI
function is quirked.

The illumos EHCI driver also disables MSI on this chip, in
ehci_register_intrs_and_init_mutex() in
usr/src/uts/common/io/usb/hcd/ehci/ehci_util.c.

Until USB HCDs started trying MSI first in v5.9, the controller always used
INTx. Disable MSI so it uses INTx again on this chipset.

Fixes: 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI devices")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930191100.6127-1-kaloz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8cb96ffa04510..ab89ac0cab833 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1837,6 +1837,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+/* ULi M1575 EHCI (10b9:5239): MSI stalls the async schedule */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5239, quirk_no_msi);
 
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
-- 
2.53.0




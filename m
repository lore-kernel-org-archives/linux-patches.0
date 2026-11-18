Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052441;
	b=NfZBjuB47o9e1DrKLIfVJc7AEhvQoPPuYP3VOPs981JGxOKilpN9ijKy0OyvHqS4C1cb
	 HdnqstPkJKhwNOpvMaNhhs80MLx9FRHhsg+4gNcKjBj1rvluj811gN/C1hT1/hExt+nnW
	 mbAWdkoa8Z56EZIeVJ652gw/s+K2DrE7Gkx6301/yg4ryxYIKh601ommc2ldjNIA5xE0z
	 eo3qdzdp936J/OsfGooELPYZsl/nMXo/mG98R8sSbkZp6rNM61GW8gSvOKpIhiJV3k7e6
	 vRGVccMNz8a9D6RA00j9pB+Wsg4DcMrBCeBNrGPHqHV/fZ78Lvu6WiUANCDlanNFf7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfBc8UOv7LSXSyWC1W8xUXhCC/1tgP4yegog12sB1WA=;
	b=CBLxmeXtBEYurCHhmCL77wx+8NQKgrxEmcyL2M+LhX4aSa821RbdR5143BE4u4WTegFo
	 PqasGD9DzZJvlke5C1AQI7/0ewtzRQIu/5mEwVvjXy56tQnMXbMF4SLqZSJpSxA804HdI
	 vCoMAMTj5FsgXGAC8PLsRfImrzBR4fL4xnNAaSneQdunzX8kzfnVfK/OXcI0lfEGiAG2L
	 NSHaGUZYmrnfZeQSR1RxVD3UDwGDhObjlJPHuDC4kScLTybrYRI5SsjuGNAZ7oFaWPotn
	 Ig2aockrl4RX/Cy5BZ/Q4OAV7Vu4y7ADeACIWOn460/N540wSBm6/8Jja+dnIvvC5WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gJl5WwWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE044606A320;
	Thu, 19 Nov 2026 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gJl5WwWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3931F000C4;
	Thu, 19 Nov 2026 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052441;
	bh=YfBc8UOv7LSXSyWC1W8xUXhCC/1tgP4yegog12sB1WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJl5WwWvUxZ3N9iNi4sihlj/IJpg2pDbskEO5LsB2C/h5n/2B6H1TLKeZbyzmTypH
	 Kkl5ztv0LOLXLuTLG7y5GLbY00lb8rXoCewZT5GfjALGqSi5TATCyguw2OszYNw8ta
	 3qLcEjKiUpKEdLrGCaAsby8LprnCwgbMmbiAdFBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0563/2214] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150033.517978456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5859414d478c1..6afeb2bcea285 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1828,6 +1828,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+/* ULi M1575 EHCI (10b9:5239): MSI stalls the async schedule */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5239, quirk_no_msi);
 
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
-- 
2.53.0




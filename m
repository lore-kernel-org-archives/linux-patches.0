Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036224;
	b=vHH7U/S+ipvXCrntMKuhDgz67zDvinryWs3Wq5CU7yMisxSSznHVxn/bRTD2DjehGyAs
	 TooFeCMLK9lBbXZJS8Z8y7OnMQEUSu673ijdhlJSwqQzh5hNPIXaMI0xaXMOTOafq0zWg
	 Wt1Q3n+vzyRLZ2+bgoPCbbgsO/iVuB1SYli6SaWNjpwGCAgUj+5BhbxeGdwylg3LgQW2I
	 Q8r5eT8hUdmXTtxzTuBWUK5/GV3E/5Kwb/5rmVQuEtslLpG5oiyD1JbskfsjXmzPXN1gz
	 lI1hUWsXKcabQagvBG3GZ5TNKJpg2hj3V5/T4zjwVD4p+bF15pN+9U/i9gN2dVcEPsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Amm1UgoQECYBd51Bs78KFxnuK/yAdsLYPkhFBgwQh8=;
	b=LqRZi9KF39OGfee/Bq02Zu/7xBQU5oAul13G05H+6Q7NwCKm1k/SW1WFm602aoAwECVl
	 eSiCSM5X2c/rtFkwFm4psu+jWVDT/GfovqageTeCa6OXqOEJNCLzUzpx6Dh6RsnEZ66/u
	 /4uNd6WtS22BvgJJ4bjWEe1iX7AHQFKJHkqBCZQ3fQE93YJXDoLdem2kXlRkuOhxbAYFI
	 V9LEa26vwsaA0L+vDz4n2oyarfpbhx/t5oJBwoIBrSzesjCdBL81Yq+6a+HapSjAsmGSd
	 a+NOITEb5t7azLDqkoneBMadEiupojd2BBziseT3FXE4zkdRUtZV/+NI6dliGg3VpIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AB3qmHnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66259606A320;
	Wed, 18 Nov 2026 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AB3qmHnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EABA1F000C4;
	Wed, 18 Nov 2026 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036224;
	bh=2Amm1UgoQECYBd51Bs78KFxnuK/yAdsLYPkhFBgwQh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AB3qmHnugGfvu+EjfWma70hHt5ZkyJNIzYQ3PmxhxiwoeHbl+Hk1wlfUEkKGY9JBd
	 iGVX1o247AYKm/0a0u4Eafaj004jI83ym7cE+l9RS9WVhonFmLgR4Z/IRk2G9P5wZj
	 URrMLNaFHeXeRLjnxw/XYnacgTxtJRG5/yb761/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0984/3318] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Wed, 18 Nov 2026 15:26:46 +0100
Message-ID: <20261118150349.283319756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6fd425ef7f8cd..6bef92be41f91 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1934,6 +1934,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+/* ULi M1575 EHCI (10b9:5239): MSI stalls the async schedule */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5239, quirk_no_msi);
 
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
-- 
2.53.0




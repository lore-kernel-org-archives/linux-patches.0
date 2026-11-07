Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063087;
	b=LcFEZCLg2HICKLNcAwkvppfYvBWWml1jgux4Z2hRMFo8DVs4ou9b8WQ/bR/gKzlWwWcz
	 D2MAxPvUKzWgtGDSPW1ATzizPW4SEbl3SooUZdxzezNGxUdxHG50jkJRxH5ij44CKnfhT
	 rAjyXwG95sHI9aru+9f2nPtAxlThd+vSxHHaM1FY/6A4NtY4pskKIP+UMWCL0CL2ros2C
	 kMGMLnw8ITcButiCSZtjhgzDZ0iO5FmPsPIW0om6YQkgDTNZK1bu+BNTE1qT14e2aM4OI
	 WQXeNRsXfhu9ie1JTxiJolUKfGsgvp6OKntrWbGJVt1SIvtQJmvVmooU1ASj0Qtjx4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EIJ657k37unXa8rTH6Ah5E6JObMirTDSYmS77e6fO9s=;
	b=1abLpYkUf5OvVo0G2co2DPLvCJlw2XquFbNylL4sD2xhF5uaa7WBJaW+/SRvut2UeLtC
	 blUyeIsAGWJBVaWFmvNBJz55zehngZUHFMTcyZWfl2mZPk6O4HjNRuDsB6KgcSPnYkriQ
	 ZaMx3fow7Jcv5C8q2iJPfvOJX7Q7VCOgnQNYx7CRC/lND9kZ/kwXfNjpdDnrK2O8VcpCQ
	 6dYQUkUAm7dU09CxK441G8IdJlNL3jtDP5PKiy0JEak752zkVfXdUILO++OvdC8XCnfeg
	 6/+lCVCeqr/YlPdHc/ETkmenl/EjV8tsuGa6PnQgk1LpaehaiPUAe2ALdvCpbXtxyqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiCwaNL4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF2606D814;
	Sat,  7 Nov 2026 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiCwaNL4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14EE1F0089F;
	Sat,  7 Nov 2026 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063087;
	bh=EIJ657k37unXa8rTH6Ah5E6JObMirTDSYmS77e6fO9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiCwaNL47Sa02RgkXPts+S17mbeoYSavxNXeW8wMPdMdA1fLWiR68CyIGNreuiZ3L
	 92zgk62iVyn1ZQ26ITST0jGVVGpf/clzGcxfbnkcfIud14oW9d4JpxQTybQGxuKL0p
	 xc9FX+/z4lUD1cPstGhYkmgRzXpmxlj2PYJpOArI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/869] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Sat,  7 Nov 2026 08:50:07 -0500
Message-ID: <20261107134903.476614598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 199f2a762b22a..d29ff1da29b17 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1944,6 +1944,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+/* ULi M1575 EHCI (10b9:5239): MSI stalls the async schedule */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5239, quirk_no_msi);
 
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
-- 
2.53.0




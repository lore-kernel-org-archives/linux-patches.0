Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062167;
	b=hD2Ee3GF7o9j+3VASe1XpJvvZi6URtu1xmQ4an8s2WuQf0fyPpRKJZ4aas8H8wIDDV4P
	 3+Uvdw3zbh+vQlsuswrFNHWlr33UNssyx76xWOGwiP+3IFOmWYmUa0agBAPKDiAZTo2FW
	 s9orho0PrcTslpV8+gxXyD6NXWN81z87CuWah/PsuOx6mbuJkYN1LaUubf8sXP+Edz10+
	 mh6nR3+CouNmXFgmXjvaH8crwnkokPkBgE27IH8C35boJx4Dvn/xkWRbhnskcSk9kSr+e
	 uMjGv+QoIK59XjitTq4KV0v5zIfNbGnWWthf8KQQb/nGsNcdKGmo65y4O5uvnnftdMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RurZX5PIH3Akj/Ap9f5AkClpB3DmpmnGdCN/xX3RuTw=;
	b=occLi8nvRnmRfxle3mFcUOArvHiBMfSba7u0R8C1fFSBgujO1QR0QjXmtRoet6L55J3r
	 0PRdxXPChimltXivszUc7drZCS6vpZwQzfdKBOmmSs4dsJZxy96CJLSW21SM1dUxM+XnN
	 hw9eQh+SNCbvTw3hlbvLcEXbYqnnWygt/OeoHMSHlNC/0lKyhfQ59Yq0ML8wdEfzoRPvg
	 AleHscdQvWUjZpqqPpxTONNf1h9Z10VCGzWma94XQp4yCnobMHf1inPyNiy4LTOveGJtD
	 eeD+Z3+zQGRrY+dm7uH1O7Ua86bmuN6tP3AuQsve+am9KaBDo3aqRf6lZy1Ql4OEBvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWobFHxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C24606A326;
	Sat,  7 Nov 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWobFHxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5380A1F0089F;
	Sat,  7 Nov 2026 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062166;
	bh=RurZX5PIH3Akj/Ap9f5AkClpB3DmpmnGdCN/xX3RuTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWobFHxwAxFqA1NiPrSXQAJh7m0rw4ABrKviV3vtOMYNCOq51UKzGQG0/MIth+gXE
	 JdeuyCnGCVGvHNaMTbk2WfpwtsB668tJKdbl+zzGmCDgMwIcKAJ9IR+D4fN5Pm0L+C
	 iuWLRekF/yxoZXiXa79lqntJdrs5TQMaD8BzNPg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1129/1536] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Sat,  7 Nov 2026 08:52:25 -0500
Message-ID: <20261107135029.423692086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a71b054d5f3c9..af9ef2b60b8ed 100644
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




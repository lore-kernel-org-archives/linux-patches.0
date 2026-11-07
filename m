Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064416;
	b=cF6FtrPtinVsalKztW10g7PdK4Uc2ZpjSukXXKng4N6hEApLWyZh2KfGX+3LuVTdF++n
	 Z4rMi28qesRKnDcYF2LZrVvLmoFeFanfhaOnBv1pQXO+vSpXCkZRCkCKy5MpJ0sbIq6in
	 7XIFaAEHDAuqBkgAb9vHZ9i11OK0wE4ylpMsIKTC4tz4czrhAnAtYn69omvfdvtBimJlx
	 BQ50y4EOp+Q9DQE0W+XWW29lRQRP7QNlmwtCOCdD4oFTjqEZpYEbk+nLZQ4V6wMC9jYpB
	 r2u55kbDoRYe4ZW2H88+Fb1yvPKl7dABlu0loqU26mb4rqWC7GsaHqrnbfCsAqLLGkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fy7y9EyJCa/MfK+azw/1fDtlCYuse1WnO9pUH1BusE8=;
	b=Q38SC2y02DXfYreKhDLej19Xk+XYUqb+rGBnGEAUNNNv+LXIpi8izitIhxBxa1A7UuMY
	 7xKn+FACMvaMdyWz9IuMc3GigXdemUaVIZrEKe7E1nV8JF3955B/ApqdLjS24yBFpqQ+R
	 IJU+Xwqb/ktntnebmzTx6TEBF8tDJbsxscmTeQ2gJmxwv1Dq6Fb8Rn8xzA4MBkOHxCx5p
	 c5R0Ui7Z6IG6YjHDvWezGEKVlY6/xtc56HOnsVPfYAV0tlD3R4vqcyOCTK36NUwQG8feW
	 F4n4SvGuPORVkpUkalqoQruMubsz3EsGLT9J/iy0bNTpMxmPW/g/pyKb5gDFXFvI9Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYzuf0Lv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB5606A333;
	Sat,  7 Nov 2026 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYzuf0Lv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5D51F0089F;
	Sat,  7 Nov 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064415;
	bh=Fy7y9EyJCa/MfK+azw/1fDtlCYuse1WnO9pUH1BusE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYzuf0Lvr3ew+0K6t8IDeBRRmWPbQG7dHIwIY/kCZoiA24B+7Cyn7a4KnvZ8gnR5n
	 aAQnqjks6uNf6M/lkU2CSrj02+TyYX2nnL8SnT3TKPQRUqs85C5pNOR//aFx/WcRu4
	 NyuA/+HiQ96D0JY4vFAlJjLvwDhxzB7TpJB+iHfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0427/1257] PCI: Disable MSI for ULi M1575 EHCI controller
Date: Sat,  7 Nov 2026 08:45:23 -0500
Message-ID: <20261107134951.286465862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 866493aceef0c..edf035d251cc2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1945,6 +1945,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+/* ULi M1575 EHCI (10b9:5239): MSI stalls the async schedule */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5239, quirk_no_msi);
 
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
-- 
2.53.0




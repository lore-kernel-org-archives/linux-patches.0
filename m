Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212169;
	b=PYEud8CvY81nhz5Ns7FpV0tv/9lX3nSxXYUL23LbjLIZiI2CVTYe4bbpREYW+Mt63ryF
	 3RtxZnoeTKns62FUk/gThvRlK4YQcxAwbqO/ZjnnoYnLK9OEQnFgBwLfsequHbd3FC0Un
	 bx9QkHFIJih1qepBwRICcjFqlygL1yfzS7P5DOK1IACIqA0lfmD/AXXAYywuMBR+T3zoO
	 VgXDK9R3AEBT5XcEhexirzrjhOlN5gkSFjM2b26YgurBRuLjIKHWXIEK7gZOXp9ZLSgHL
	 zNBYwf9NxRXq1EdCt/NjGYXWjVbUSOo+nc1V0TC2X6FMgdAt/PuZeeyuBQ8w6pmD6GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PFnwG6BUgj939iiRV0iZajlUBN3e/4g5j8jdiZ2VO1A=;
	b=GSxOvrp3QdGmGVJdkxOdzFzl6ICR7XGkh7nYYBywSw7qg5+62BBRp4t8lUxYf4TqGYrA
	 gPHOmQouBEXucFZJYoZ3CQkw6T6ABBYkrQmopyZXPFPqZW3TPBlP1bUdvfw6y6a5vGb9E
	 grUgAXiNPSSnH9qplpe3ztQWv0EX2kg3a6cfxNPICoHaBS5AcW9uAmPNoW4pwmmiybXTw
	 gQU57pOSLKDiKJuAB9daDDnJcA9ZLe6Jmum99LK9fBhhcQYxUl1BBo1bjYH6yfiZnVA2q
	 CGcmxU2V9LWK0hnScFJSvUrZ/u7vnApApffJvzRMBrf0zV85NhTSNXrU1lTJn9K7fOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tjOnm5b/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F688606A31A;
	Wed, 28 Oct 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjOnm5b/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFEC1F01825;
	Wed, 28 Oct 2026 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212169;
	bh=PFnwG6BUgj939iiRV0iZajlUBN3e/4g5j8jdiZ2VO1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjOnm5b/dNQgmoTrl/9eFyNYteAWlZKCXCtSrlqioAOtOIzg/LLoavvEZSwC+HiHy
	 mUcog7hpqC896dST5WOBl3lO1IHDnRnzHrnkeBjzzFj6yBACPTMvT5Usq8ydX/QT0N
	 Xrzyfi0yAmg/Lv9eLrsB7Q8FhaIGQfNdn0G3VNpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0060/1887] usb: xhci: bail out of setup if the controller is inaccessible
Date: Wed, 28 Oct 2026 17:35:56 +0100
Message-ID: <20261028170500.593438140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 78203d5b54a40f0e36196ebf31c9c7a380fc8811 ]

xhci_gen_setup() locates the operational registers using the capability
length read from the very first register:

	xhci->op_regs = hcd->regs +
		HC_LENGTH(readl(&xhci->cap_regs->hc_capbase));

If the controller is dead or has dropped off the bus, that read returns
~0, HC_LENGTH() truncates it to 0xff, and op_regs ends up 0xff bytes
past the page-aligned MMIO base, i.e. unaligned. The first access
through it, xhci_halt() -> xhci_handshake() reading op_regs->status, is
then an unaligned readl() on device memory. arm64 faults on unaligned
device accesses, so instead of xhci_handshake() catching the all-ones
value and returning -ENODEV, setup oopses:

  xhci-pci-renesas 0005:08:00.0: Unable to change power state from D3cold to D0, device inaccessible
  xhci-pci-renesas 0005:08:00.0: xHCI Host Controller
  xhci-pci-renesas 0005:08:00.0: new USB bus registered, assigned bus number 1
  Unable to handle kernel paging request at virtual address ffff80030a770103
    ESR = 0x0000000096000021
    FSC = 0x21: alignment fault
  Internal error: Oops: 0000000096000021 [#1]  SMP
  pc : xhci_halt [xhci_hcd]
  Call trace:
   xhci_halt
   xhci_gen_setup
   xhci_pci_setup
   usb_add_hcd
   usb_hcd_pci_probe
   xhci_pci_common_probe
   xhci_pci_renesas_probe

This was hit with a Renesas uPD720201 that failed to power up ("Unable
to change power state from D3cold to D0, device inaccessible") yet still
reached the HCD probe path.

Read the capability register once, and if it reads back the all-ones
value (as xhci_handshake() and xhci_reset() already test for), abort
setup with -ENODEV before op_regs is derived from it. Reading it once
also avoids re-reading a register that may change under a concurrent
hot-removal.

Fixes: 66d4eadd8d06 ("USB: xhci: BIOS handoff and HW initialization.")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ dropped the phantom hcs_params1 local declaration since this tree lacks the later refactor that introduced it ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 104ee26b27aa4..6cfc8205d10db 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5365,6 +5365,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	 */
 	struct device		*dev = hcd->self.sysdev;
 	int			retval;
+	u32			hc_capbase;
 
 	/* Accept arbitrarily long scatter-gather lists */
 	hcd->self.sg_tablesize = ~0;
@@ -5385,15 +5386,19 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	mutex_init(&xhci->mutex);
 	xhci->main_hcd = hcd;
 	xhci->cap_regs = hcd->regs;
-	xhci->op_regs = hcd->regs +
-		HC_LENGTH(readl(&xhci->cap_regs->hc_capbase));
+	hc_capbase = readl(&xhci->cap_regs->hc_capbase);
+	if (hc_capbase == U32_MAX) {
+		xhci_warn(xhci, "Host controller not accessible, removed?\n");
+		return -ENODEV;
+	}
+	xhci->op_regs = hcd->regs + HC_LENGTH(hc_capbase);
 	xhci->run_regs = hcd->regs +
 		(readl(&xhci->cap_regs->run_regs_off) & RTSOFF_MASK);
 	/* Cache read-only capability registers */
 	xhci->hcs_params1 = readl(&xhci->cap_regs->hcs_params1);
 	xhci->hcs_params2 = readl(&xhci->cap_regs->hcs_params2);
 	xhci->hcs_params3 = readl(&xhci->cap_regs->hcs_params3);
-	xhci->hci_version = HC_VERSION(readl(&xhci->cap_regs->hc_capbase));
+	xhci->hci_version = HC_VERSION(hc_capbase);
 	xhci->hcc_params = readl(&xhci->cap_regs->hcc_params);
 	if (xhci->hci_version > 0x100)
 		xhci->hcc_params2 = readl(&xhci->cap_regs->hcc_params2);
-- 
2.53.0




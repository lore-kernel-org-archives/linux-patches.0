Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B20247DF9;
	Tue, 29 Apr 2025 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945511; cv=none; b=haEB8chjRjt1YwvkjaOTdfoQfiecIIAuWnXGcnyynmFCyYNvW3irk5jJiKf+910smvOpwMuwcJrXgiz9gN9Pe6ig9rabbQeRt8AX51yvxRmR5PdnGKT6pyNUsRUatgdoOr31UgCSEof7RbiDz+0lWBKsy+UyMsBAyGdytaCciVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945511; c=relaxed/simple;
	bh=30Fge9rsALukdcua7z3ZPogNAJPP3egD3BXqJ2lso7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1/5N7//NNL0dZw5b80TinGaQ/0jG6psonKu/B5WVi6Rtq+4L1mPJxCAWH4L/EIcpfWcCpJGB7RhRvJ6gOrUHTKDcnm3pq/A+nvg+fuH9f2PFeY4BLqZ7GG1SFYlL9TEB+68vgIb5qkm07D2j9FxRc2XZowfj6YFq0BYEZbrzd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBHDUM9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBHDUM9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2814C4CEE3;
	Tue, 29 Apr 2025 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945511;
	bh=30Fge9rsALukdcua7z3ZPogNAJPP3egD3BXqJ2lso7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBHDUM9cPCUOfR+pB6iP0IXgmXdprMNGKx+yecZaqsLuaSnYwRzDx1fNW4zFT2+tV
	 Iw0b1KXkqP+VcQGJ1Ks4kJvR6Bb0Px7hOfmWtGVFkN/vcV4T3DWihsf2poWVWPVhkg
	 pr5/ZEvtYXUAwTQancCL9ZDu5nB9igfytk9OEVqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/179] PCI: Rename PCI_IRQ_LEGACY to PCI_IRQ_INTX
Date: Tue, 29 Apr 2025 18:41:18 +0200
Message-ID: <20250429161054.939945498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 58ff9c5acb4aef58e118bbf39736cc4d6c11a3d3 ]

Rename PCI_IRQ_LEGACY to PCI_IRQ_INTX to be more explicit about the type
of IRQ being referenced as well as to match the PCI specifications
terms. Redefine PCI_IRQ_LEGACY as an alias to PCI_IRQ_INTX to avoid the
need for doing the renaming tree-wide. New drivers and new code should
now prefer using PCI_IRQ_INTX instead of PCI_IRQ_LEGACY.

Link: https://lore.kernel.org/r/20231122060406.14695-2-dlemoal@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: 919d14603dab ("misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7edc6de9e88c2..f2f92eb950cc6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -935,11 +935,13 @@ enum {
 	PCI_SCAN_ALL_PCIE_DEVS	= 0x00000040,	/* Scan all, not just dev 0 */
 };
 
-#define PCI_IRQ_LEGACY		(1 << 0) /* Allow legacy interrupts */
+#define PCI_IRQ_INTX		(1 << 0) /* Allow INTx interrupts */
 #define PCI_IRQ_MSI		(1 << 1) /* Allow MSI interrupts */
 #define PCI_IRQ_MSIX		(1 << 2) /* Allow MSI-X interrupts */
 #define PCI_IRQ_AFFINITY	(1 << 3) /* Auto-assign affinity */
 
+#define PCI_IRQ_LEGACY		PCI_IRQ_INTX /* Deprecated! Use PCI_IRQ_INTX */
+
 /* These external functions are only available when PCI support is enabled */
 #ifdef CONFIG_PCI
 
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC2A2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301800; cv=none; b=jUCmk+kzQec5aQjBaLMkQfrNFYx7BzAHpnLYEUF8E4qVcCv6KS9mvjNP907zaonjbQ0B7aKLZxkow6cvaygxqZq2MIUfteeV4sjKABmgYlaBkVR40LvqhHjpODWwJptKhZc9lVpbRExdLyrq7FN6i9xaEIam6lofVRYwjvBIjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301800; c=relaxed/simple;
	bh=5PiASFQsJWQgiv6PWm/NMwHR3XCc3/ufA26wUL3OQ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fb1Z5Yd272v1ZaMD6X6lYdJf++zhSbxp20MFJkV9sfD9aDynxwoRkCuKOkfmivz0j8zdqwRNpGHesF+xENS2YUCiQwJav/rs2XzuNJXbKDbNJODk31DtxYlLBdR046N7/4RGxPserSvXWzsJaumExAlLcfjVk9f0+ZwHZ+rXhbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eq3B6nzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eq3B6nzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC37C116D0;
	Sat, 28 Feb 2026 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301800;
	bh=5PiASFQsJWQgiv6PWm/NMwHR3XCc3/ufA26wUL3OQ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq3B6nzI95ghBrmHRZ3doosV8/+oBKJwSRH1wNIV192gxLXMHr2wPv60L9K/fTHC6
	 7gtxOCLhu4NZWprKQvh/RiuMRwf8Kddfgtra3Q3Sa6DQ3gjPdeqpqlKHU18DbPaWP3
	 lQNq4dpalovrx+y46rTUsesGbrZIWgGaIOuZAc1mKEy77yrSr+UIShBsHOsKAPt9ib
	 uHYrnanrEWBoN9fFt/OpW0vLDVSytJ5df6xVh4VSIPdfNYfKzZdTn32jeG11oFqCGH
	 tUbfIuMsKr6cYVGZ3y4J5/AdhLINvTEtCoOZTGQz96uVMjRUVmSsNS0PPzDcCbdtDv
	 UEc+g5VBxS+ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/385] PCI: Add defines for bridge window indexing
Date: Sat, 28 Feb 2026 12:57:14 -0500
Message-ID: <20260228180011.1568201-212-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit e4934832c588f72bcc139d3ca0acc490c63a821c ]

include/linux/pci.h provides PCI_BRIDGE_{IO,MEM,PREF_MEM}_WINDOW defines,
however, they're based on the resource array indexing in the pci_dev
struct. The struct pci_bus also has pointers to those same resources but
they start from zeroth index.

Add PCI_BUS_BRIDGE_{IO,MEM,PREF_MEM}_WINDOW defines to get rid of literal
indexing.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250829131113.36754-12-ilpo.jarvinen@linux.intel.com
Stable-dep-of: 9abf79c8d7b4 ("PCI/ACPI: Restrict program_hpx_type2() to AER bits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h   |  4 ++++
 drivers/pci/probe.c | 10 +++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index c951f861a69b2..50da47c3fe72d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -80,6 +80,10 @@
 #define PCIE_MSG_CODE_DEASSERT_INTC	0x26
 #define PCIE_MSG_CODE_DEASSERT_INTD	0x27
 
+#define PCI_BUS_BRIDGE_IO_WINDOW	0
+#define PCI_BUS_BRIDGE_MEM_WINDOW	1
+#define PCI_BUS_BRIDGE_PREF_MEM_WINDOW	2
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8d85810ab2f1f..9e419f14738a2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -539,9 +539,13 @@ void pci_read_bridge_bases(struct pci_bus *child)
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
 
-	pci_read_bridge_io(child->self, child->resource[0], false);
-	pci_read_bridge_mmio(child->self, child->resource[1], false);
-	pci_read_bridge_mmio_pref(child->self, child->resource[2], false);
+	pci_read_bridge_io(child->self,
+			   child->resource[PCI_BUS_BRIDGE_IO_WINDOW], false);
+	pci_read_bridge_mmio(child->self,
+			     child->resource[PCI_BUS_BRIDGE_MEM_WINDOW], false);
+	pci_read_bridge_mmio_pref(child->self,
+				  child->resource[PCI_BUS_BRIDGE_PREF_MEM_WINDOW],
+				  false);
 
 	if (dev->transparent) {
 		pci_bus_for_each_resource(child->parent, res) {
-- 
2.51.0


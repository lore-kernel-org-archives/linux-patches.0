Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB17383C86
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302142; cv=none; b=arBAYfQZaWEKFdhy+HTJzisG8hxUAj7mqbKjZAkwmscifj9DSgkpvm3tVfpz2T3ChJq9chu4YaJstz0/xcxzckxrwtLPOvDOJT6WUIHwbhbAj0PxCdw7aUA1rLJ+WltXwT8a+q0R+n2MfjKL6e1VMSS6tdmICNnF2vrM/su9vGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302142; c=relaxed/simple;
	bh=ZgJNHNOdWkNeKXYflL+Jkyus/G665j7ZBPGpbf32loA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6o40HYhpfOmPageyUuY6uHBGmbrWrzXq+vQI467wKeJ/wofhMIoLYPgftk7jgpzsytFFwYYclo6YIOixMvMn3K+YRZxYa1S36d+TBRNp8kDWuLo14w6CHioSNyxzfUPObItvIpA4LEn4FfozwGQ0XSZ/HSkxuyIEldyVEzAGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYtTg10g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYtTg10g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73194C19424;
	Sat, 28 Feb 2026 18:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302141;
	bh=ZgJNHNOdWkNeKXYflL+Jkyus/G665j7ZBPGpbf32loA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYtTg10gkKHnPvbiEEbgr2fG2uFYnMjRKEl7e9JjQUZXSSm68j6zjc3msRCpAw3jJ
	 zmYjzZlaCOo1ghm1reaTThQAnFMI7G1bIGlBmmPR+uh1WiAKTMye9BtA3GuM4eK7uL
	 AtoYi4rW0e1bmGfiGDg2l/47YFPV2BA5kTq63gigpku55DLk1QRF+OID/Rz4uSLat5
	 XhjDqZNcp6+xRT2QEV1nrsFUHUngOI9+X62QdYGLGshvTdMb0rCCspgoAjIRyvF3AV
	 RO20oy/pPEd1+IqaQwr0wazfb91NfmcxzlP6bEKRHa8AfOmM22ebRb1/VHjCw6UhCJ
	 xZ2zNkvfYwamA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/283] PCI: Add defines for bridge window indexing
Date: Sat, 28 Feb 2026 13:04:37 -0500
Message-ID: <20260228180709.1583486-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 95603147e73c8..d333be3877b2e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -40,6 +40,10 @@
 #define PCIE_MSG_CODE_DEASSERT_INTC	0x26
 #define PCIE_MSG_CODE_DEASSERT_INTD	0x27
 
+#define PCI_BUS_BRIDGE_IO_WINDOW	0
+#define PCI_BUS_BRIDGE_MEM_WINDOW	1
+#define PCI_BUS_BRIDGE_PREF_MEM_WINDOW	2
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8a2f1e57bee19..cc56bf47c4a3f 100644
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


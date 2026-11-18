Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030370;
	b=I9IMtAzhdrpZye5BBysoMHEZrMMiWCdI3EPjVORf8wBhnhgWyTqE6TGuW8i26pnpRee2
	 jgtlXu3y6jCh4S2BB68KPbDdiEETi1TKZ9FjpVPeq+mWZiTieLJUc8zwo1s80nx9Oye3l
	 tHqOuwVl6l66FxsJqjoHj2BlYlxIZyzybMT+UA8C77djREQaTEPFn4m/DWMBtyHX85f1u
	 IVpew9Eiji8M6Pi0Esu/JTCdECZl9sxKwYMEOjJkgRe9ognOZ99/Dx7IN3Ub1CmtOKcGY
	 XBCoH0K2+/9RKnmXQwbxEEZn8l9YVYoxebtzw6xSUsKyL31H36eBktw8whyduAL1wZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DY1BW8ryS0s818iis3gD9csIpQ55A9SQf48ikfLVBUM=;
	b=t+/8eg6t4SvdBySM0n5SIPMq3N7DJb+jz7EzdKSgVJPeijwvEvRTUg9g5lAM5F1DoQiU
	 fI0i0O8SZJc3W7ZWKo8aNd2juuUJuz53hYwWHCd4A5yYeQP63ojr+13aNY/1UTUbdtxMx
	 Ul4A4OV58com1DxWoYmHMVA11UN9Qc8B0bjUNlWcun4/otsSxHneoDLwr3xuiysPmURzb
	 2hEKERZuiYi+SJf4f+7d3VD7PRWUgymDcfgBMWXDuGr5RgSKieqC9zBa1KLEpp+ghOMRT
	 33/L+NHrKbUlMdfxQ+KiY9hqIW9CLmHGKcKLCUR0ZzCouYeUL5ZKPIVIGRpjBauz5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y43G5uft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DBF606B101;
	Wed, 18 Nov 2026 19:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y43G5uft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE441F000C5;
	Wed, 18 Nov 2026 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030370;
	bh=DY1BW8ryS0s818iis3gD9csIpQ55A9SQf48ikfLVBUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y43G5uftFyl6JEMaXJP/3pOqAjrqvK5rA48dFF4t2k8PF2g1kflDCtPtIKQqvS8u6
	 TeBeR3I1AsdmmxQbaFIi0Y99X0AHT7x9fgN3+74yg16z/2LO6B32UCRxsJ9ELgp7NL
	 SXt4QKz0F/9F/PkVMdyYTQmRGRNtIpGxiwrI2c1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Odell <loganodell@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0679/1756] PCI/IOV: Read VF config values that need not match PF
Date: Wed, 18 Nov 2026 15:46:46 +0100
Message-ID: <20261118150036.288424496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Logan Odell <loganodell@google.com>

[ Upstream commit ae43799529c480510dcc14bd0ed141a1d85b9259 ]

Per PCIe r7.0, sec 7.5.1.1.5 and 7.5.1.2.3, VF Revision IDs and Subsystem
IDs may differ from the PF's.  Read these values from VF config space
instead of using cached values from VF 0.

Per 7.5.1.1.6 and 7.5.1.2.3, VF Class Codes and Subsystem Vendor IDs must
be the same as the PF's.  Use the PF's value instead of reading from VF
config space.

Per 7.5.1.1.9, the Header Type for a VF must be 0, so hardcode that
assignment.

Fixes: cf0921bea66c ("PCI/IOV: Use VF0 cached config registers for other VFs")
Signed-off-by: Logan Odell <loganodell@google.com>
[bhelgaas: commit log, move "rev" decl inside block that uses it]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260910173648.1304517-1-loganodell@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c   | 25 -------------------------
 drivers/pci/pci.h   |  4 ----
 drivers/pci/probe.c | 15 ++++++++++-----
 3 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index d595a345a7d47..829c2be7ba956 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -153,29 +153,6 @@ resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
 	return dev->sriov->barsz[resno - PCI_IOV_RESOURCES];
 }
 
-static void pci_read_vf_config_common(struct pci_dev *virtfn)
-{
-	struct pci_dev *physfn = virtfn->physfn;
-
-	/*
-	 * Some config registers are the same across all associated VFs.
-	 * Read them once from VF0 so we can skip reading them from the
-	 * other VFs.
-	 *
-	 * PCIe r4.0, sec 9.3.4.1, technically doesn't require all VFs to
-	 * have the same Revision ID and Subsystem ID, but we assume they
-	 * do.
-	 */
-	pci_read_config_dword(virtfn, PCI_CLASS_REVISION,
-			      &physfn->sriov->class);
-	pci_read_config_byte(virtfn, PCI_HEADER_TYPE,
-			     &physfn->sriov->hdr_type);
-	pci_read_config_word(virtfn, PCI_SUBSYSTEM_VENDOR_ID,
-			     &physfn->sriov->subsystem_vendor);
-	pci_read_config_word(virtfn, PCI_SUBSYSTEM_ID,
-			     &physfn->sriov->subsystem_device);
-}
-
 int pci_iov_sysfs_link(struct pci_dev *dev,
 		struct pci_dev *virtfn, int id)
 {
@@ -310,8 +287,6 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->no_command_memory = 1;
 
-	if (id == 0)
-		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
 	if (rc)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f60d0eb600645..a61b387aa5220 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -445,10 +445,6 @@ struct pci_sriov {
 	u16		driver_max_VFs;	/* Max num VFs driver supports */
 	struct pci_dev	*dev;		/* Lowest numbered PF */
 	struct pci_dev	*self;		/* This PF */
-	u32		class;		/* VF device */
-	u8		hdr_type;	/* VF header type */
-	u16		subsystem_vendor; /* VF subsystem vendor */
-	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
 };
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5ff2ad01235c4..a8e963dcd661a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1808,8 +1808,13 @@ static u32 pci_class(struct pci_dev *dev)
 	u32 class;
 
 #ifdef CONFIG_PCI_IOV
-	if (dev->is_virtfn)
-		return dev->physfn->sriov->class;
+	if (dev->is_virtfn) {
+		u8 rev;
+
+		if (pci_read_config_byte(dev, PCI_REVISION_ID, &rev))
+			rev = 0;
+		return (dev->physfn->class << 8) | rev;
+	}
 #endif
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	return class;
@@ -1819,8 +1824,8 @@ static void pci_subsystem_ids(struct pci_dev *dev, u16 *vendor, u16 *device)
 {
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn) {
-		*vendor = dev->physfn->sriov->subsystem_vendor;
-		*device = dev->physfn->sriov->subsystem_device;
+		*vendor = dev->physfn->subsystem_vendor;
+		pci_read_config_word(dev, PCI_SUBSYSTEM_ID, device);
 		return;
 	}
 #endif
@@ -1834,7 +1839,7 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn)
-		return dev->physfn->sriov->hdr_type;
+		return 0;
 #endif
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type);
 	return hdr_type;
-- 
2.53.0




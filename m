Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024803;
	b=DKgW1Go2eDz6FYheW1T87QRPB/S9OMQCaaypF56oHZ4zGMlungH6ZyRUI4TymyqVBLQ4
	 Kx5RyGVRqAHh3sVLJ2Anxs7HyqfCtbojJ1tPIOczDRmVdWvIucgjD/v23R19s6+VdBd4y
	 n3bvCh6x+V4YiP3VP0LkJHMlfxgC4ATxnL4JGE5t/v7NI2O2EGkSyo+531IptmUfFtspY
	 R8m1K5XeqIJOQ4+9jM7ZimYxq0K3a0nTOG55fY5ALpWYYP3UCXL9I07EpcMmhwzwZMAL2
	 nDudfjK+ogvyOP9MHbDzBqeTmQBgUotQjPRLStEtfFFlNuPmDQ7+A2XEmE2km4YDwqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TYn1EgTqjsqJzocP4DAU3QqJlVQSHgugK+549DKc7Lo=;
	b=f9xwD6/zRx1ybiWL3lcPuVblNMeIzj0+Tk1bbBDeMn9uuwzWr54cpxz8zApy8at0DZ4o
	 LCt4ZWdz8wpBx0Bx8sT61vnzDEYzZTxyHiHEexSpWWSikW1tsNKTLbkXIy0WzuPgQ3tVK
	 aeu/cDkbdkUjOHg2i6FWp+GaYlD5vA08IsLa57YG9zvMnJx2U0j4wdsq5+4QSvDq6hbdf
	 mSCX4rB1y+gUT39AV7m6GEZVgmVOXqwRa7WU8hYbd/uuItOwObvkLUx20A9lZ9G5nqAC7
	 mnQjCay69XJZGJASDK1AQYp7R610gwT2P0B2wAS2GEgOhafUx/WNjseAVu5EAqtRzHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/7VU1PL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341B606A32A;
	Wed, 18 Nov 2026 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/7VU1PL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4611F000C4;
	Wed, 18 Nov 2026 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024803;
	bh=TYn1EgTqjsqJzocP4DAU3QqJlVQSHgugK+549DKc7Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/7VU1PLZPNc7mScXV97YDFtIzN+qEuBvKGiBqWFnDJ/Hx8fC1iilzVRIns0w1vb+
	 VZe/AysGBKfN/eacbRGlzDPev8J8nsPfDtstLkbKKZ6ftE00nJmve0VrQRBmzONfb8
	 hZ6uxnTMMuu3smOnH+YT1G297wMg3pB7muVgt1iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Odell <loganodell@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0853/2151] PCI/IOV: Read VF config values that need not match PF
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118150153.325175928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 277a239e26e6c..e44958be4c54d 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -179,29 +179,6 @@ bool pci_iov_is_memory_decoding_enabled(struct pci_dev *dev)
 	return cmd & PCI_SRIOV_CTRL_MSE;
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
@@ -329,8 +306,6 @@ static struct pci_dev *pci_iov_scan_device(struct pci_dev *dev, int id,
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->no_command_memory = 1;
 
-	if (id == 0)
-		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
 	if (rc) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fd302523f5a04..3c37eac6273d5 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -617,10 +617,6 @@ struct pci_sriov {
 	u16		driver_max_VFs;	/* Max num VFs driver supports */
 	struct pci_dev	*dev;		/* Lowest numbered PF */
 	struct pci_dev	*self;		/* This PF */
-	u32		class;		/* VF device */
-	u8		hdr_type;	/* VF header type */
-	u16		subsystem_vendor; /* VF subsystem vendor */
-	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	u16		vf_rebar_cap;	/* VF Resizable BAR capability offset */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 082c51ce88936..8ba97205be82a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1873,8 +1873,13 @@ static u32 pci_class(struct pci_dev *dev)
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
@@ -1884,8 +1889,8 @@ static void pci_subsystem_ids(struct pci_dev *dev, u16 *vendor, u16 *device)
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
@@ -1899,7 +1904,7 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn)
-		return dev->physfn->sriov->hdr_type;
+		return 0;
 #endif
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type);
 	return hdr_type;
-- 
2.53.0




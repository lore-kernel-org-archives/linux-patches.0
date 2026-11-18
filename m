Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017890;
	b=shIEN87zPN1z1xTFKTp53WVpV0y0sTI8SjfSU+WD/XYJAtDZ/uM4F54upO2YrO5sWsuC
	 j+mBsWscF4vmlvWGwOty4qlB6D0MGUsPi1k/EMIpVZE8qjzZUG4xkKNLHNe2hO6QIprtZ
	 tPMqUgdgpUIDtLy+Du/V1+VVjtkmpLOxeTMJPhmlOWBDnBNqsoWExd7natj3OxBlmFLjE
	 iVbBHVn9ACaa+poYBsgDHZe6aBWNUVmtHBQ0Hg9MjLI0VuCFdMFNHxzIuRk99QoVSK6Nj
	 EfiObhP5fpoCvqx/mT7CguLuw/r8DEOoXXrUuvts82+yndLRI9pL0EVGg6UPV8QDmlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MwYaOWmjt3uSfsdI/Yp5HrOIJ9Ynmmoxk2BZrzsU08=;
	b=mI7v9IGiBbNnoZrG+muyAHrQtz14/9U1zucCJze/NPrvkOhKWNjeje/a9tZQrFoBMqu3
	 LmTBuJ+vUWauGV2tHnh0A1uFbx87/NJTYghDiKhvDKECrY4sEf6nVVkZOjc6H7KWmLgWM
	 cE5u+fG0GgthAdT0KTdyqIcsagd0iWLCDfNcEJ8jwyRuMOI6dqkear7kOaQcZrTeXSxNi
	 ndtuc2ongT0mHfYWVp9C3RHjhUCRODA5NiyWu3LOh8HEvV4iGbfmSr6eLyqDxrnA6objY
	 UFYtNSjY1JZ0w9HDyDvi0tX+kxDl5Bw+Js+hzdNDJvtkeWXR7Nnv+aa021kSImnBU0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI8PwWVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095EF606A31C;
	Wed, 18 Nov 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hI8PwWVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6DB1F000C4;
	Wed, 18 Nov 2026 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017889;
	bh=1MwYaOWmjt3uSfsdI/Yp5HrOIJ9Ynmmoxk2BZrzsU08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI8PwWVGIJcbbe6IDq+sTSmpcDsfxRG29U46buXlKSeStJaOcKf43aEVqGc/2LreQ
	 AvVVnlxtnDosVdqGxoYvx4FV4md1p+0selk7xNsnd1LmXN/H4x8orudklb6dq3NniD
	 nNwtzahuFp8YlI49TLeYREZpxjbKJYW9ciQ3JvT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Odell <loganodell@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1004/2651] PCI/IOV: Read VF config values that need not match PF
Date: Wed, 18 Nov 2026 15:37:24 +0100
Message-ID: <20261118150324.058025868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9d408fb8ac250..9185934a900f2 100644
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
index ba3c3fddddc23..5b3dd1adbf35e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -711,10 +711,6 @@ struct pci_sriov {
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
index 52a79b033b069..7738ebffb6091 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1892,8 +1892,13 @@ static u32 pci_class(struct pci_dev *dev)
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
@@ -1903,8 +1908,8 @@ static void pci_subsystem_ids(struct pci_dev *dev, u16 *vendor, u16 *device)
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
@@ -1918,7 +1923,7 @@ static u8 pci_hdr_type(struct pci_dev *dev)
 
 #ifdef CONFIG_PCI_IOV
 	if (dev->is_virtfn)
-		return dev->physfn->sriov->hdr_type;
+		return 0;
 #endif
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type);
 	return hdr_type;
-- 
2.53.0




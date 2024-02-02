Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB5318057
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849857; cv=none; b=cOxaqI+nRvylsqzPSGZq8BwibOA7o1fKrfgkr0x6ZYwz00VjgfOsWxq5VWi+ZcO+mAua79LUX5I//l1PnAgDWlxhBXDqQCWotaj1s3fM50u7uu10pDziVTndR+l2seA6pwEODuuxQsKkNVaWsMDuQ0EyNxPsIvho3YU32pzKrLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849857; c=relaxed/simple;
	bh=UPkU4CgiMaVZ/F/r+r3Za8ed6ay66IJYSHKlYHufPks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNq7bpk0982NQv1XkBji+At7BgNfHdHRadFUbAmOlwpfVMLBsUcthjGN9cZbwjTFuyqvVMw9jtn91FEwScu3X3vamnxTlEo7LSfqfHgYrgvsKxL/PvT2/peqZrP9TzbtZJuGahv4HcDy08TEQ1vJ9M4MYDRfnkLfJlQG7cbG+h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cGBCLNGF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cGBCLNGF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849856; x=1738385856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UPkU4CgiMaVZ/F/r+r3Za8ed6ay66IJYSHKlYHufPks=;
  b=cGBCLNGFZtnCbyBfiK6pNb9QqmVQkraULco/5L7UWxVTVp0EaY7QXZDY
   L4vprYhqwKMFSf875gyKxn9L7qbE9L7J0Z8XbWzb41bFF560I/uo2eu5Q
   FglMrB2KI9dagpwd9locAinwATlNwOXY4RD3YNxMOM+lB8opa4zG9JEoK
   YBlyIK+zR5aJhuj91p1Y9qIiU/hYn7hvopk1/LnEOplZAraDoWVHmky+A
   3SbS6kVuPoQRkaFw7LGsJF7sERF8PTtzUC9tigbPkD0bB9N/21QpiDzGG
   XLWzvXcO+f+BY/cUt7NaNgJtkdKGnsnPHsr8x8abA7dl0sc1Ag/TmsPz5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615852"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615852"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339801"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339801"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types use same signature
Date: Thu,  1 Feb 2024 20:57:09 -0800
Message-Id: <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have
flows that can be shared.

For INTx, MSI, and MSI-X interrupt management to share the
same enable/disable flow the interrupt specific enable and
disable functions should have the same signatures.

Let vfio_intx_enable() and vfio_msi_enable() use the same
parameters by passing "start" and "count" to these functions
instead of letting the (what will eventually be) common code
interpret these values.

Providing "start" and "count" to vfio_intx_enable()
enables the INTx specific check of these parameters to move into
the INTx specific vfio_intx_enable(). Similarly, providing "start"
and "count" to vfio_msi_enable() enables the MSI/MSI-X specific
code to initialize number of vectors needed.

The shared MSI/MSI-X code needs the interrupt index. Provide
the interrupt index (clearly marked as unused) to the INTx code
to use the same signatures.

With interrupt type specific code using the same parameters it
is possible to have common code that calls the enable/disable
code for different interrupt types.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 37065623d286..9217fea3f636 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -257,13 +257,18 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	return ret;
 }
 
-static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
+static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
+			    unsigned int start, unsigned int count,
+			    unsigned int __always_unused index)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
@@ -332,7 +337,8 @@ static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
 	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
 }
 
-static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
+static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
+			      unsigned int __always_unused index)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
@@ -358,17 +364,20 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
+static int vfio_msi_enable(struct vfio_pci_core_device *vdev,
+			   unsigned int start, unsigned int count,
 			   unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag;
-	int ret;
+	int ret, nvec;
 	u16 cmd;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
+	nvec = start + count;
+
 	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 
 	/* return the number of supported vectors if we can't get all: */
@@ -701,11 +710,11 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	unsigned int i;
 
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_intx_disable(vdev);
+		vfio_intx_disable(vdev, index);
 		return 0;
 	}
 
-	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
+	if (!(is_intx(vdev) || is_irq_none(vdev)))
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
@@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		if (is_intx(vdev))
 			return vfio_irq_set_block(vdev, start, count, fds, index);
 
-		ret = vfio_intx_enable(vdev);
+		ret = vfio_intx_enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
 		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_intx_disable(vdev);
+			vfio_intx_disable(vdev, index);
 
 		return ret;
 	}
@@ -771,7 +780,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
-		ret = vfio_msi_enable(vdev, start + count, index);
+		ret = vfio_msi_enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
-- 
2.34.1


Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C8D26E05
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5B9EOnP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610494; x=1728146494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mm/55LXHi28066oVFk7+DbJoQjq6buhXunb9T8tkOO0=;
  b=k5B9EOnP2rm1BwOXrepVsYaoMIZyNxifWWkFqtoqcHybxeG+zPgjDmhc
   bHE2qbXelFOQTFk1FTGEuNPvqGUugEmr4WRoKShfR1JlW1eBFEMfpzibW
   18DMSXWXIRujigjWl8tHlH9O7UEWovC9mR+hj0KAIyYPsBZ2D0Dg/Qc84
   BPRL/DmxohwRdq7vwQgD7xusmxOxRLuSXdl+mIj7zj8kDYjQxlws+q4Fh
   c3wqCgyZgwA85PZVfAqv9/9QvcqbB2KjCcRaomON+oYkVYsboXwiwJSIA
   2yj9uGKslkTYLGEXMwYOH68hIbwtSlzQ+RBWbia9jOmPSua45PW2J2Mkx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063162"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063162"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892845"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892845"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	jing2.liu@intel.com,
	ashok.raj@intel.com,
	fenghua.yu@intel.com,
	tom.zanussi@linux.intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH V2 03/18] vfio/pci: Use unsigned int instead of unsigned
Date: Fri,  6 Oct 2023 09:40:58 -0700
Message-Id: <e69a5968e7a6d0344be9df2d0a650ea241426c4c.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

checkpatch.pl warns about usage of bare unsigned.

Change unsigned to unsigned int as a preparatory change
to avoid checkpatch.pl producing several warnings as
the work adding support for backends to VFIO interrupt
management progress.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 37 ++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b5b1c09bef25..c49588c8f4a3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -553,8 +553,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
  * IOCTL support
  */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -584,8 +585,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
-				  unsigned index, unsigned start,
-				  unsigned count, uint32_t flags, void *data)
+				  unsigned int index, unsigned int start,
+				  unsigned int count, uint32_t flags, void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -604,8 +605,9 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned index, unsigned start,
-				     unsigned count, uint32_t flags, void *data)
+				     unsigned int index, unsigned int start,
+				     unsigned int count, uint32_t flags,
+				     void *data)
 {
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
@@ -647,8 +649,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
@@ -755,8 +758,9 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 }
 
 static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!pci_is_pcie(vdev->pdev))
 		return -ENOTTY;
@@ -769,8 +773,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -780,11 +785,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
-			    unsigned index, unsigned start, unsigned count,
-			    void *data)
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (index) {
-- 
2.34.1


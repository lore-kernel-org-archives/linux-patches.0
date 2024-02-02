Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E864317C64
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849856; cv=none; b=gwjgpfP4dPew+FaVJEKBVL8QAVSnT8D0Lj5ZAYXntlbPuC3XBCevePlfMHclVYJ4y49lGLW+L7+B+6ZWXol6UII9NiYn9djHRVsLAvE0k27x8GBQUpKOFBt86Kxv0ky6Jgy/HQ6ERGA8BajWT8tEEQc9YYV5NcOYOKSL7zv+LZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849856; c=relaxed/simple;
	bh=BJ/iiqpnrpLGQqepNldAyRvzSYt7cnd2BvmP/2lcET0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pg8Jn5YGeBwFSw13ALJQPY72qQVXm2r6gsN/jwkEejiaKa4IJaUdWYr8vi1FzvkGk6+RCRgNrry6RReJ8w6TOVoRSbDEoyv+4fGZIgyZwQp3Hcwhito053nquq4IUkFCOD1Gh0CJ7eO0lqfqySM5g2VQ09kfD+Jof9A5C0ZKAQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/BSTwG3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/BSTwG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849855; x=1738385855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BJ/iiqpnrpLGQqepNldAyRvzSYt7cnd2BvmP/2lcET0=;
  b=n/BSTwG3Npr3mWVt4UTpJn/Vron7Qg6AE1EmSva+DO3iSVvnjkHFapY7
   o6GbVVsM4RVEwumSzE2y+RW4mdmOqywVtz8a+Nqm/kaZu8im7MCENbc6a
   dXZXl6evooO/M1UiB47px0GsgDLLNi9///n+Fr0z75I/SoZXlEn6k3kSz
   mh/sBzb+/omvFMfjWz0SjZC7pEItBIuECCYH5qXJQoXei4kSGjyRIFEGo
   Xmw3xK2QFTUaGEMWi/YyZLYJYILbFGOu7udYT/QdU+9dKV3rcRkwdK3LX
   5ZkOuKJnHHm9vDqnjbXcFw3R3C5cLOU39AUUlOw2ZIsRcLSfwax0mJD+V
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615841"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615841"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339792"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339792"
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
Subject: [PATCH 12/17] vfio/pci: Remove msi term from generic code
Date: Thu,  1 Feb 2024 20:57:06 -0800
Message-Id: <0550572e64505df6ecff0b08f1eca869a79f6acf.1706849424.git.reinette.chatre@intel.com>
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

vfio_msi_set_vector_signal() and by extension vfio_msi_set_block()
are no longer specific to MSI and MSI-X interrupts.

Change the name of these functions in preparation for them
to be used for management of INTx interrupts.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 07dc388c4513..7f9dc81cb97f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -557,7 +557,7 @@ static struct vfio_pci_intr_ops intr_ops[] = {
 	},
 };
 
-static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
+static int vfio_irq_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd,
 				      unsigned int index)
 {
@@ -617,7 +617,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
+static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
 			      unsigned int start, unsigned int count,
 			      int32_t *fds, unsigned int index)
 {
@@ -626,12 +626,12 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
-		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
+		ret = vfio_irq_set_vector_signal(vdev, j, fd, index);
 	}
 
 	if (ret) {
 		for (i = start; i < j; i++)
-			vfio_msi_set_vector_signal(vdev, i, -1, index);
+			vfio_irq_set_vector_signal(vdev, i, -1, index);
 	}
 
 	return ret;
@@ -648,7 +648,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
 	xa_for_each(&vdev->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, index);
+		vfio_irq_set_vector_signal(vdev, i, -1, index);
 		vfio_irq_ctx_free(vdev, ctx, i);
 	}
 
@@ -786,14 +786,14 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		int ret;
 
 		if (vdev->irq_type == index)
-			return vfio_msi_set_block(vdev, start, count,
+			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
 		ret = vfio_msi_enable(vdev, start + count, index);
 		if (ret)
 			return ret;
 
-		ret = vfio_msi_set_block(vdev, start, count, fds, index);
+		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
 			vfio_msi_disable(vdev, index);
 
-- 
2.34.1


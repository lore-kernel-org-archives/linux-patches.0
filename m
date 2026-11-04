Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804713;
	b=XmRL2KoeerRFNilrkAiUJSgZN3qWHdRHgAzAePwKDw8rsMkds7TrONg2g8L5x7uHTDav
	 d7PSNnObsyV73QglWMcd17A932/ynCUvL1h5xBBMJjHzcUVsUfDa05YUAb6RwiIqapOng
	 HBdfebpwLNVHBH/UNjb3/lNb+ZmtuISdNQTtogtkgdE3VVxMA60KrHqYkTorRATI0Jf8t
	 8Egmn1mCyevCmKSWUjjOiH67JFTUb0QdBxjcbz+dgsPLPWzTqVFh+z8aAlfqE9UjICwhY
	 TYcyn5J7pXFR2H/BR9mEuW9TZYVka/DS480MT6mg0cvnmM7lGtxcREvijswZIS/3/nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=13EqTD2QbG1JqJ0MW+s6uc/67bvuoP8Vw5ARNLeLJOo=;
	b=b4RsyzdlG99lL973slDY2ZhAjye/bfS4l1uu93vhJZqF/Q68nl/IoQ+xepj8E5KR+1Vs
	 j8tmg1DlD+hByTX5nT0DKakT5FygHBkMpbpUz37yPu7uvaq7XTP/ILKApnT2mjZkbVo6g
	 AZ98t7Ghao3/JNDhDlSXNHNamMUt2v70isBgu/w0m7JCdSYFD/YJRn1Lel0lHW53nla3+
	 qbvd2A+tP5mX/KJGUzJcUJ9dVVF6rnJP5/N8qpeaYJxPSeaJ1VtDVRJ2G5sNPGXU01/VR
	 xA4ddxMxjf+shgXnlACwsX6NwE5GsyYwUt3vDNa+cFKc+2+zRNySCMsZ1/zO2PtYV4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgdY+4WK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1783606D82C;
	Wed,  4 Nov 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgdY+4WK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007A21F00919;
	Wed,  4 Nov 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804712;
	bh=13EqTD2QbG1JqJ0MW+s6uc/67bvuoP8Vw5ARNLeLJOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgdY+4WKzsKaRxuv+8jpnjpbCfjNuk02pLhhVGx5dMzK0flBdBisXukGW9TOM7AFn
	 QAUUvHtlM4uy/SYYZnOZla2aLYbNt82TK8N941iEK0G1wr1dVruQqOHziiMzxhvEyl
	 mQ0/SRzLzKYMnu/c1Goj3xNsmp1/ZRCmEZ0jVQ+nAsNlb7O3aIKG/BSOMoB313B5QJ
	 SGYOfQi7y8NHrL45P0FAUULNlIhxVt7RCdZYdMxBkKBbuadzROAlWe4+jhYCvxa2a2
	 G+lpfYDcK0C15vzSZpDZpgLTZxIoNcV+UFW9tJ5UPZYhF/hygMLq7fuKkINN/h3gtv
	 hcrz5AuZcR2Gg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v4 16/25] vfio/pci: Check whether BAR state changes are allowed before reset
Date: Wed,  4 Nov 2026 20:33:13 +0530
Message-ID: <20261104150322.3516320-17-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
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

Add checks in vfio_pci_ioctl_reset(), vfio_exp_config_write() and
vfio_af_config_write() before resetting the device. Check PCIe and AF
FLR request bits before vfio_default_config_write() updates vconfig, so
a rejected request returns -EBUSY without changing virtual state.

Use vfio_pci_begin_bar_state_change() and
vfio_pci_end_bar_state_change() around function resets. These retain the
existing memory_lock protection while allowing reset to be rejected
before BAR mappings are removed.

In vfio_pci_dev_set_hot_reset(), check every device in
dev_set->device_list while holding the existing dev_set->lock. Reject
the reset before acquiring runtime-PM references for the device set or
removing BAR mappings if any device fails the check.

vfio_pci_bar_state_change_allowed() currently returns true. Later
patches reject resets while a device supplies guest_memfd backing.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 38 ++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c   | 20 ++++++++++++++--
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 5b97f64ab3ba..537e7f8bc884 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -733,6 +733,24 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
+/* Config accesses are split into aligned byte, word or dword chunks. */
+static bool vfio_pcie_flr_requested(int offset, int count, __le32 val)
+{
+	if (offset == PCI_EXP_DEVCTL && count >= 2)
+		return le32_to_cpu(val) & PCI_EXP_DEVCTL_BCR_FLR;
+
+	if (offset == PCI_EXP_DEVCTL + 1)
+		return le32_to_cpu(val) & (PCI_EXP_DEVCTL_BCR_FLR >> 8);
+
+	return false;
+}
+
+static bool vfio_af_flr_requested(int offset, __le32 val)
+{
+	return offset == PCI_AF_CTRL &&
+	       (le32_to_cpu(val) & PCI_AF_CTRL_FLR);
+}
+
 /*
  * It takes all the required locks to protect the access of power related
  * variables and then invokes vfio_pci_set_power_state().
@@ -915,6 +933,10 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 				  offset + PCI_EXP_DEVCTL);
 	int readrq = le16_to_cpu(*ctrl) & PCI_EXP_DEVCTL_READRQ;
 
+	if (vfio_pcie_flr_requested(offset, count, val) &&
+	    !vfio_pci_bar_state_change_allowed(vdev))
+		return -EBUSY;
+
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0)
 		return count;
@@ -936,12 +958,14 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 						 &cap);
 
 		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
-			vfio_pci_zap_and_down_write_memory_lock(vdev);
+			ret = vfio_pci_begin_bar_state_change(vdev);
+			if (ret)
+				return ret;
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
 			if (__vfio_pci_memory_enabled(vdev))
 				vfio_pci_dma_buf_move(vdev, false);
-			up_write(&vdev->memory_lock);
+			vfio_pci_end_bar_state_change(vdev);
 		}
 	}
 
@@ -1000,6 +1024,10 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 {
 	u8 *ctrl = vdev->vconfig + pos - offset + PCI_AF_CTRL;
 
+	if (vfio_af_flr_requested(offset, val) &&
+	    !vfio_pci_bar_state_change_allowed(vdev))
+		return -EBUSY;
+
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0)
 		return count;
@@ -1021,12 +1049,14 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 						&cap);
 
 		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
-			vfio_pci_zap_and_down_write_memory_lock(vdev);
+			ret = vfio_pci_begin_bar_state_change(vdev);
+			if (ret)
+				return ret;
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
 			if (__vfio_pci_memory_enabled(vdev))
 				vfio_pci_dma_buf_move(vdev, false);
-			up_write(&vdev->memory_lock);
+			vfio_pci_end_bar_state_change(vdev);
 		}
 	}
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 99778cf0cc3c..f31fbd980f3e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1307,7 +1307,9 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	if (!vdev->reset_works)
 		return -EINVAL;
 
-	vfio_pci_zap_and_down_write_memory_lock(vdev);
+	ret = vfio_pci_begin_bar_state_change(vdev);
+	if (ret)
+		return ret;
 
 	/*
 	 * This function can be invoked while the power state is non-D0. If
@@ -1324,7 +1326,7 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	ret = pci_try_reset_function(vdev->pdev);
 	if (__vfio_pci_memory_enabled(vdev))
 		vfio_pci_dma_buf_move(vdev, false);
-	up_write(&vdev->memory_lock);
+	vfio_pci_end_bar_state_change(vdev);
 
 	return ret;
 }
@@ -2503,6 +2505,20 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	mutex_lock(&dev_set->lock);
 
+	/*
+	 * Check every device before acquiring runtime-PM references for the
+	 * device set or removing BAR mappings. Generic ioctl dispatch already
+	 * holds a PM reference for the target. Holding dev_set->lock prevents
+	 * gmem_attached from changing during these checks and the reset.
+	 */
+	lockdep_assert_held(&dev_set->lock);
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
+		if (!vfio_pci_bar_state_change_allowed(vdev)) {
+			ret = -EBUSY;
+			goto err_unlock;
+		}
+	}
+
 	pdev = vfio_pci_dev_set_resettable(dev_set);
 	if (!pdev) {
 		ret = -EINVAL;
-- 
2.43.0


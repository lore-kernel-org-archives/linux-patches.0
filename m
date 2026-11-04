Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804725;
	b=jM07AcCUZUJIqgNN9Td6tCl3X7605HWJlVNPbUZ/Hw+xUI5H0QYliF6yzQnmFSAqMhWo
	 okmqqfXUIDJqHCOl/NSqVG58SH8h6cAQ8jjgLe/iywZ2Ijjjkt/I09AP/v0XhDqTrOHr3
	 iR1mYryn/TdS6iOPFvUNntoya5yPgHmFkZsi5YN7YNScWuaRKS7AAvT8Z1LldS0eyJIwx
	 pBrQQbfQjbeS8RnpzJiyAA7r4b1kHMVIfjzEmjkpNqBLMgE8SbrKgcjxVas+tRK3rLvhy
	 F0Lws+Pk8+/4DGWGQGU2TYAqe3IO4x3bSp6hP+gL3AbyymSD/CWE5i7Fo+8OiekcAew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=K4Ybsg7NuVBeZdLOID1aKeaghXNozmS8Xb6Owb/3lWY=;
	b=yJ6uTxeoV0X+EP7JRFuMCW0oFLa4EEZweTfXU/7fJSB+lIv0G9GrkrPTURLbQha++dab
	 ktX70KqTlQvGVlwCwZiR+ygcm+FioSr0mUw02qSKjSZC8qsOSbuUU3tSm517Qgq5mOpoH
	 0OLu1FiLIPNQClbD3+B5edtYZKgliKmzjbqUcoRA6Z4nyEPJ+VKIzGH6YFSXc+lyy89J2
	 qV4PTCwMc+EqLaoe9XPV0Zdp0qghPzVc6dTvQeQtK+9TvqBasF0gKjnqH+kX6PmfiprRu
	 36dhWsUJP1o1Gi1ppFUHLBKWDZuUbF9aDM1gsQR4lrMJwEkAaTtwHmYJV2SmeplXZcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjVrTQA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED4B606A339;
	Wed,  4 Nov 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjVrTQA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4807C1F000C1;
	Wed,  4 Nov 2026 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804724;
	bh=K4Ybsg7NuVBeZdLOID1aKeaghXNozmS8Xb6Owb/3lWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjVrTQA2WIl27oYZuhYzrM9yHOrMG9lsLWuObTzpUqdrQ2juTItYk809fTG0mi1m3
	 fJLLAkj9CwsQVlLlQra9eHsp9q3NSeS2ziGEaPh9wXqTNwdt0Ss/iTTQNHqNcYk0dx
	 9vr5SkwYfHOiR8RfQJLbRrvkhfUE7k2FmtVD6m0TlGTy3klRV11LEZVinZdUvrbbYw
	 /CHECkpo7YN9b5b5W5BPIdsG3S7reQrVlvOV/fmNsOnbysqwRwLp/IJJdzq6gxRN0R
	 gPSITSCEGFC5/4stcumOSmsEgPcUVKqpZ8owgiCQpZCYFnIL1wbQvlScSeFMXyT52V
	 h4jHRfA7g/d7w==
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
Subject: [RFC PATCH v4 18/25] vfio/pci: Track userspace BAR mappings
Date: Wed,  4 Nov 2026 20:33:15 +0530
Message-ID: <20261104150322.3516320-19-aneesh.kumar@kernel.org>
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

Track userspace mappings of PCI BARs so a later patch can reject
guest_memfd attachment while such mappings exist.

Count the initial mmap explicitly because vm_ops->open() is not called
for it. Use the VMA open and close callbacks to track duplication and
unmapping, keeping the count nonzero until the last mapping is unmapped.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++++
 include/linux/vfio_pci_core.h    |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6612728a21a4..d4f9ce6b5dc6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1814,7 +1814,23 @@ static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
 	return vfio_pci_mmap_huge_fault(vmf, 0);
 }
 
+static void vfio_pci_mmap_open(struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+
+	atomic_inc(&vdev->mmap_count);
+}
+
+static void vfio_pci_mmap_close(struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+
+	atomic_dec(&vdev->mmap_count);
+}
+
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
+	.open = vfio_pci_mmap_open,
+	.close = vfio_pci_mmap_close,
 	.fault = vfio_pci_mmap_page_fault,
 #ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
 	.huge_fault = vfio_pci_mmap_huge_fault,
@@ -1896,6 +1912,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
 			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
+	/* Initial mmap does not invoke vm_ops->open(). */
+	vfio_pci_mmap_open(vma);
 
 	return 0;
 }
@@ -2205,6 +2223,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 		return ret;
 	INIT_LIST_HEAD(&vdev->dmabufs);
 	init_rwsem(&vdev->memory_lock);
+	atomic_set(&vdev->mmap_count, 0);
 	xa_init(&vdev->ctx);
 
 	return 0;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 2f3fa2787737..6001fda0e001 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -8,6 +8,7 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#include <linux/atomic.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
@@ -150,6 +151,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	atomic_t		mmap_count;
 	struct list_head	dmabufs;
 };
 
-- 
2.43.0


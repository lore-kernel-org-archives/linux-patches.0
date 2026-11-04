Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804762;
	b=RUhz2uRK4XCBXvg9seUsKOPEELei2yD5gZM6Wpo6TO/zd0d01b9ipIkpS6JrIGLNhz1g
	 X2XFBP2sleleTZd6Vk526OGtb8xIX4NIJ+jP+WCOdKHEG2V4lGI+Uw1XAZs7REQwZ16ot
	 Z7ux9LliKPzYRSMLagqQgyAuiHcCK1xMRi72hKITGKFlaRV3Gjrb/axtrB8CcrRO36SqR
	 mKmlj41IIO2Xhe7QIVc96G/Boko1QNviqykzbz1jpP2WquXBftLtEwEXwTbpSnML2aOYa
	 xQXaf7GzFVLBFR5PBYYG3r5nP12Rq5+Tz6KXkb0hznJFXtkXdllWfWq+YHcaIFMu1rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bQScCPsstcI1x3czxLA/N1iLoPpFtUtJIthleDIaRyI=;
	b=HoHcOmaqLutL360ne4RujtKTKzrNcuZrCxNv/6lYOvIiJ+TGiA75VhxKSs65FEVqeuf7
	 Tb10pQh3XrQN7tAplX71QvoQRQhG/ksXJlxYa2DfJYEG6WNiuPIWy6Wh5OyStlPNynMX0
	 OrK1rk7Yqp+zkz1JwfSZMUcijqWeKaFaExcqyV6m/fQZuTsmgvkYUcmAHpA4IZBZhXl3I
	 Q2RjBj1pEayjtL4+/USpzFrpT9mTnQq5OOLz/CMXQrvKdlzvMi4GSwYejjrDpVqoqtvEG
	 /zF0leylJkjEXH/nZefvYjOHOm3OagkZJfbgINyX0IYQDnWfvwAmrcqqZw5YmsUEXNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HFwC/v98";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1707606D81A;
	Wed,  4 Nov 2026 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFwC/v98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86991F000C1;
	Wed,  4 Nov 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804761;
	bh=bQScCPsstcI1x3czxLA/N1iLoPpFtUtJIthleDIaRyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFwC/v98QdrDlJOoHSVKLX7jEAKVrqwEIwJCx5SFmnEwZykVGjghi4QI1sNio1y+7
	 qXFpInb7wQA0VmcIiFFGPqOVpXO+gL32ahD61xWUyAddsK4FuAoyb/Y5H3x++CULM0
	 RBv170vRcSCaYmDg2/qsmwg5IBdZ0KTWtcsAILdPheHpBgO59MD64VKK8DiS9CRY7D
	 iqJQuZGmjI8bSn6IrqquR542KODWceH4z9lx0K8Fdbr5pa2tItsc+TPoueiLzVUo80
	 Tmojl3Y6kiNenm8EbOEXU67q21ocqapPpCQ9k3ZPkA7bQixDcroUoA9nNdI5zLlBiM
	 cptuRPoAaVO4w==
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
Subject: [RFC PATCH v4 24/25] vfio/pci: Add a guest_memfd resource provider for MMIO BARs
Date: Wed,  4 Nov 2026 20:33:21 +0530
Message-ID: <20261104150322.3516320-25-aneesh.kumar@kernel.org>
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

Allow a VFIO PCI device file to supply MMIO BAR PFNs to guest_memfd.
Validate BAR ranges before memslot setup and provide PFNs for shared
faults and private conversion.

Require page-aligned, nonempty ranges within the BAR and guest_memfd
file. Reject memslots requesting dirty logging or read-only access,
which this provider does not implement.

Existing VFIO mappings, dma-buf exports and ioeventfd handlers can
access BARs without guest_memfd attribute checks. Private conversion
cannot revoke those accesses, so reject setup with EBUSY while any
exist.

Require an IOMMUFD vDEVICE associated with the same VM as guest_memfd.
Keep that vDEVICE referenced until release and pass its device ID and
mapping-owner handle to guest_memfd for KVM device mappings.

Require D0 and hold a runtime-PM reference until release to keep BARs
accessible. Reject setup while userspace allows runtime suspend.
Block direct VFIO BAR access, reset, low-power entry and userspace
changes to Memory Enable or Bus Master Enable while the device
supplies BAR PFNs to guest_memfd.

Use the vDEVICE mmio_lock to prevent device unlock from racing with
conversion, invalidation and attribute updates. PFN lookup holds
memory_lock for read while checking BAR access.

MSI-X configuration remains allowed. Userspace must keep the table/PBA
pages shared while host MSI-X is active.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/Kconfig         |  11 ++
 drivers/vfio/pci/Makefile        |   1 +
 drivers/vfio/pci/vfio_pci.c      |   3 +
 drivers/vfio/pci/vfio_pci_gmem.c | 327 +++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_gmem.h |  17 ++
 drivers/vfio/pci/vfio_pci_priv.h |  15 +-
 include/linux/vfio_pci_core.h    |   4 +
 7 files changed, 375 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.c
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185e..e5dedf3e4a65 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -55,6 +55,17 @@ config VFIO_PCI_ZDEV_KVM
 
 	  To enable s390x KVM vfio-pci extensions, say Y.
 
+config VFIO_PCI_GMEM
+	bool "VFIO PCI device guest_memfd resource provider"
+	depends on VFIO_PCI && IOMMUFD && KVM
+	depends on KVM_GUEST_MEMFD
+	help
+	  Allow the VFIO PCI device fd to provide BAR PFNs to guest_memfd,
+	  including confidential-device range conversion through its
+	  existing IOMMUFD vDEVICE. This requires a capable TSM backend.
+	  Shared access is revoked before private range mapping and is
+	  restored only after private mappings and device state permit it.
+
 config VFIO_PCI_DMABUF
 	def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
 
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 6138f1bf241d..351af00acb3f 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -3,6 +3,7 @@
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_GMEM) += vfio_pci_gmem.o
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e7c012febe91..64068e7aa61e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -147,6 +147,9 @@ static int vfio_pci_init_dev(struct vfio_device *core_vdev)
 }
 
 static const struct vfio_device_ops vfio_pci_ops = {
+#if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
+	.gmem_provider_ops = &vfio_pci_gmem_provider_ops,
+#endif
 	.name		= "vfio-pci",
 	.init		= vfio_pci_init_dev,
 	.release	= vfio_pci_core_release_dev,
diff --git a/drivers/vfio/pci/vfio_pci_gmem.c b/drivers/vfio/pci/vfio_pci_gmem.c
new file mode 100644
index 000000000000..11f6ae44cd49
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_gmem.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+#include <linux/guest_memfd.h>
+#include <linux/iommufd.h>
+#include <linux/kvm.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/vfio_pci_core.h>
+
+#include "../vfio.h"
+#include "vfio_pci_priv.h"
+#include "vfio_pci_gmem.h"
+
+/**
+ * vfio_gmem_resolve_bar_range() - validate and resolve a VFIO BAR interval
+ * @ctx: attached VFIO provider
+ * @offset: byte offset in the VFIO region namespace
+ * @size: interval length in bytes
+ * @bar: output BAR index
+ * @bar_offset: output byte offset within that BAR
+ * @pa: output starting physical address
+ *
+ * Return: 0 on success or -EINVAL for an ineligible interval.
+ */
+static int vfio_gmem_resolve_bar_range(struct vfio_pci_gmem *ctx, u64 offset,
+		u64 size, u32 *bar, u64 *bar_offset, phys_addr_t *pa)
+{
+	struct pci_dev *pdev = ctx->vdev->pdev;
+	resource_size_t start, len;
+	u32 index = offset >> VFIO_PCI_OFFSET_SHIFT;
+	u64 off = offset & ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
+
+	if (!size || !PAGE_ALIGNED(offset | size))
+		return -EINVAL;
+
+	if (offset >= ctx->gmem->size ||
+	    size > ctx->gmem->size - offset)
+		return -EINVAL;
+
+	if (index >= PCI_STD_NUM_BARS)
+		return -EINVAL;
+
+	start = pci_resource_start(pdev, index);
+	len = pci_resource_len(pdev, index);
+
+	if (!ctx->vdev->bar_mmap_supported[index] ||
+	    !(pci_resource_flags(pdev, index) & IORESOURCE_MEM) ||
+	    !PAGE_ALIGNED(start))
+		return -EINVAL;
+
+	if (off >= len || size > len - off)
+		return -EINVAL;
+
+	/* The interval must not cross into the next VFIO region. */
+	if (size > (1ULL << VFIO_PCI_OFFSET_SHIFT) - off)
+		return -EINVAL;
+
+	if (check_add_overflow(start, off, pa))
+		return -EINVAL;
+
+	*bar = index;
+	*bar_offset = off;
+	return 0;
+}
+
+/**
+ * vfio_gmem_has_private_mmio() - check for private BAR ranges
+ * @data: attached VFIO provider context
+ *
+ * Return: true if the core has committed private BAR ranges.
+ */
+static bool vfio_gmem_has_private_mmio(void *data)
+{
+	struct vfio_pci_gmem *ctx = data;
+
+	/* The caller holds mmio_lock, including before attach() returns. */
+	return READ_ONCE(ctx->gmem->has_private_ranges);
+}
+
+/**
+ * vfio_gmem_attach() - prepare a VFIO PCI device to supply guest_memfd backing
+ * @inode: guest_memfd inode supplied by the core
+ * @file: open VFIO device file supplying the BAR namespace
+ * @gdev: device memory context supplied by guest_memfd
+ *
+ * Require @file to be bound to IOMMUFD. Reject the request if VFIO BAR
+ * mappings, dma-buf exports or ioeventfd handlers already exist.
+ *
+ * Require the device to be in D0 and retain a runtime-PM reference to
+ * prevent runtime suspend. Obtain the existing IOMMUFD vDEVICE after
+ * checking that it belongs to the same VM as @gdev. Keep both references
+ * until vfio_gmem_release().
+ *
+ * Generic VFIO keeps @file referenced until vfio_gmem_release() returns.
+ *
+ * Return: Provider context on success, or an ERR_PTR() on failure.
+ */
+static void *vfio_gmem_attach(struct inode *inode, struct file *file,
+		struct guest_memfd_device *gdev)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_pci_core_device *vdev =
+		container_of(df->device, struct vfio_pci_core_device, vdev);
+	struct vfio_pci_gmem *ctx;
+	struct iommufd_vdevice *ivdev;
+	int ret;
+
+	if (!gdev)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	ctx = kzalloc_obj(*ctx);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->vdev = vdev;
+	ctx->gmem = gdev;
+	ctx->mapping = inode->i_mapping;
+
+	lockdep_assert_held_write(&vdev->vdev.gmem_lock);
+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
+	/*
+	 * Require access to be granted and the file to be bound to IOMMUFD.
+	 * The acquire pairs with smp_store_release() after vfio_df_open()
+	 * so the device setup is visible before proceeding.
+	 */
+	if (!smp_load_acquire(&df->access_granted) || !df->iommufd) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	/*
+	 * Reject setup if dma-buf exports or ioeventfd handlers can access
+	 * BARs outside guest_memfd.
+	 */
+	if (!list_empty_careful(&vdev->dmabufs) || vdev->ioeventfds_nr) {
+		ret = -EBUSY;
+		goto fail;
+	}
+
+	/*
+	 * Reject setup while userspace allows the device to runtime suspend.
+	 */
+	if (READ_ONCE(vdev->pm_runtime_engaged)) {
+		ret = -EBUSY;
+		goto fail;
+	}
+
+	/*
+	 * Reject the request if any VFIO BAR mapping exists
+	 */
+	if (atomic_read(&vdev->mmap_count)) {
+		ret = -EBUSY;
+		goto fail;
+	}
+
+	/* Runtime suspend must stay excluded until provider release. */
+	ret = vfio_pci_core_pm_pin_d0(vdev);
+	if (ret)
+		goto fail;
+
+	ivdev = iommufd_device_attach_mmio_provider(vdev->vdev.iommufd_device,
+						    gdev->kvm, ctx,
+						    vfio_gmem_has_private_mmio,
+						    &gdev->binding.owner);
+	if (IS_ERR(ivdev)) {
+		ret = PTR_ERR(ivdev);
+		goto fail_pm;
+	}
+	gdev->binding.vdev_id = ivdev->virt_id;
+	ctx->ivdev = ivdev;
+	return ctx;
+fail_pm:
+	pm_runtime_put(&vdev->pdev->dev);
+fail:
+	kfree(ctx);
+	return ERR_PTR(ret);
+}
+
+/**
+ * vfio_gmem_prepare_memory_region() - validate a memslot BAR interval
+ * @data: attached provider context
+ * @offset: byte offset in the VFIO region namespace
+ * @size: range length in bytes
+ * @flags: requested KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY flags
+ *
+ * Check the entire interval and the BAR's existing iomap. BAR reservations
+ * are released by VFIO teardown.
+ *
+ * Return: 0 on success or a negative error code.
+ */
+static int vfio_gmem_prepare_memory_region(void *data,
+		u64 offset, u64 size, u32 flags)
+{
+	struct vfio_pci_gmem *ctx = data;
+	phys_addr_t pa;
+	u64 off;
+	u32 bar;
+	int ret;
+
+	if (flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY))
+		return -EINVAL;
+
+	ret = vfio_gmem_resolve_bar_range(ctx, offset, size, &bar, &off, &pa);
+	if (ret)
+		return ret;
+
+	return PTR_ERR_OR_ZERO(vfio_pci_core_get_iomap(ctx->vdev, bar));
+}
+
+/**
+ * vfio_gmem_get_pfn() - obtain a BAR PFN for guest_memfd
+ * @data: provider context returned by vfio_gmem_attach()
+ * @index: page index in the VFIO region namespace
+ * @pfn: receives the BAR PFN
+ * @max_order: receives zero for base-page mappings
+ *
+ * Called with the guest_memfd inode's invalidate_lock held. Take memory_lock
+ * for read while checking BAR access and resolving the PFN.
+ *
+ * Return: 0 on success, -ENXIO if BAR access is disabled, or a range or BAR
+ * mapping error.
+ */
+static int vfio_gmem_get_pfn(void *data, pgoff_t index,
+		unsigned long *pfn, int *max_order)
+{
+	struct vfio_pci_gmem *ctx = data;
+	struct vfio_pci_core_device *vdev = ctx->vdev;
+	phys_addr_t pa;
+	u64 off;
+	u32 bar;
+	int ret;
+
+	if ((u64)index >= (ctx->gmem->size >> PAGE_SHIFT))
+		return -EINVAL;
+
+	lockdep_assert_held(&ctx->mapping->invalidate_lock);
+	guard(rwsem_read)(&vdev->memory_lock);
+	if (!__vfio_pci_memory_enabled(vdev))
+		/* Retrying cannot change the decode state frozen at attachment. */
+		return -ENXIO;
+
+	ret = vfio_gmem_resolve_bar_range(ctx, (u64)index << PAGE_SHIFT, PAGE_SIZE,
+					  &bar, &off, &pa);
+	if (ret)
+		return ret;
+
+	/* Userspace can fault the BAR before a memslot has been installed. */
+	ret = PTR_ERR_OR_ZERO(vfio_pci_core_get_iomap(vdev, bar));
+	if (ret)
+		return ret;
+
+	*pfn = PHYS_PFN(pa);
+	if (max_order)
+		*max_order = 0;
+	return 0;
+}
+
+/**
+ * vfio_gmem_lock() - exclude TDI transitions during mapping changes
+ * @context: attached provider context
+ *
+ * Called with the inode invalidate lock held for write. Hold the vDEVICE
+ * MMIO mutex through guest invalidation, architecture conversion and
+ * publication of the private-range summary. Revocation, memslot unbind and
+ * final file cleanup use the same exclusion without changing attributes.
+ */
+static void vfio_gmem_lock(void *context)
+{
+	struct vfio_pci_gmem *ctx = context;
+
+	lockdep_assert_held_write(&ctx->mapping->invalidate_lock);
+	iommufd_vdevice_mmio_lock(ctx->ivdev);
+}
+
+/**
+ * vfio_gmem_unlock() - release provider exclusion after mapping changes
+ * @context: attached provider context
+ */
+static void vfio_gmem_unlock(void *context)
+{
+	struct vfio_pci_gmem *ctx = context;
+
+	lockdep_assert_held_write(&ctx->mapping->invalidate_lock);
+	lockdep_assert_held(&ctx->ivdev->mmio_lock);
+	iommufd_vdevice_mmio_unlock(ctx->ivdev);
+}
+
+/**
+ * vfio_gmem_release() - release a provider after successful core cleanup
+ * @data: provider context to release
+ *
+ * Detach from the pinned vDEVICE, drop runtime PM and free the context.
+ * Generic VFIO pins the source file through this call and clears attachment
+ * state after release returns.
+ *
+ * The caller holds gmem_lock for write and dev_set->lock. Detachment takes
+ * the vDEVICE MMIO lock.
+ */
+static void vfio_gmem_release(void *data)
+{
+	struct vfio_pci_gmem *ctx = data;
+	struct vfio_pci_core_device *vdev = ctx->vdev;
+
+	lockdep_assert_held_write(&vdev->vdev.gmem_lock);
+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
+	iommufd_vdevice_detach_mmio_provider(ctx->ivdev);
+	pm_runtime_put(&vdev->pdev->dev);
+	kfree(ctx);
+}
+
+const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops = {
+	.attach = vfio_gmem_attach,
+	.prepare_memory_region = vfio_gmem_prepare_memory_region,
+	.device_memory = true,
+	.lock = vfio_gmem_lock,
+	.unlock = vfio_gmem_unlock,
+	.get_pfn = vfio_gmem_get_pfn,
+	.release = vfio_gmem_release,
+};
+EXPORT_SYMBOL_GPL(vfio_pci_gmem_provider_ops);
+
+MODULE_IMPORT_NS("IOMMUFD");
diff --git a/drivers/vfio/pci/vfio_pci_gmem.h b/drivers/vfio/pci/vfio_pci_gmem.h
new file mode 100644
index 000000000000..3ed53ae0c18a
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_gmem.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VFIO_PCI_GMEM_H
+#define VFIO_PCI_GMEM_H
+
+#include <linux/guest_memfd.h>
+
+struct iommufd_vdevice;
+struct vfio_pci_core_device;
+
+struct vfio_pci_gmem {
+	struct guest_memfd_device *gmem;
+	struct vfio_pci_core_device *vdev;
+	struct iommufd_vdevice *ivdev;
+	struct address_space *mapping;
+};
+
+#endif /* VFIO_PCI_GMEM_H */
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 43d74c46e841..54e7c0fe0b0e 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -11,17 +11,26 @@
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
-/* Later patches reject BAR state changes while guest_memfd uses the device. */
+/*
+ * Exclusive BAR ownership excludes destructive state changes. File
+ * operations hold gmem_lock; reset of a device instead holds
+ * dev_set->lock. Either stabilizes gmem_attached, whose publication and
+ * removal hold both locks.
+ */
 static inline bool
 vfio_pci_bar_state_change_allowed(struct vfio_pci_core_device *vdev)
 {
-	return true;
+	lockdep_assert(lockdep_is_held(&vdev->vdev.gmem_lock) ||
+		       lockdep_is_held(&vdev->vdev.dev_set->lock));
+	return !vdev->vdev.gmem_attached;
 }
 
 static inline bool
 vfio_pci_bar_access_allowed(struct vfio_pci_core_device *vdev)
 {
-	return true;
+	lockdep_assert_held(&vdev->vdev.gmem_lock);
+
+	return !vdev->vdev.gmem_attached;
 }
 
 struct vfio_pci_ioeventfd {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 4ebd29069034..485f953345bd 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -156,6 +156,10 @@ struct vfio_pci_core_device {
 	struct list_head	dmabufs;
 };
 
+#if IS_ENABLED(CONFIG_VFIO_PCI_GMEM)
+extern const struct guest_memfd_provider_operations vfio_pci_gmem_provider_ops;
+#endif
+
 enum vfio_pci_io_width {
 	VFIO_PCI_IO_WIDTH_1 = 1,
 	VFIO_PCI_IO_WIDTH_2 = 2,
-- 
2.43.0


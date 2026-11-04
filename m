Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804737;
	b=xt/csOXW7vVua9IPU8qTUA6V3QhP1vCGp8LvaTaJhJ14ONBIdWC3KKPfH30H3K4cf9KP
	 lt7KZ+6S+tM1jtTOLlZHMEq1AiZhImIT7rpGfD0s2A/9PbQisUaEs7tcjIQHAWvjUDy+4
	 kHua7Q0cMdxHRvBUSD9E/7RFez6EdwE9jhpFkhhAj2Z9tgeNmAXuw9DKWviZ6YBI+yOXI
	 SbTrhRVPuStOh3N5T706uhMXVmZmgdyUU3EgM8CJj/4I/mo7mfHpUY+glCFHWw0VoML60
	 /syyMJFn09Pwjf9cjT5v/Ri7qMspfSyEIivIAPz02PRyFrDYvhsGPnMwzqjFfHqC3Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OfHRgaXZqSxqsm3is7DGxgnfe85zZdPObdvrLpJIvtc=;
	b=WCqxe3Ymx8w6VQJtQOKHkiL4m0sSmM0xFitFFFbyKQCh9Ax2ojL0ff45wtwBlhqYziu2
	 YaNVsUOOxMZwnRRbkQqYtiwq/YE7IioQxUa4AbHAWX2Z96jXSeBocNjuAjeGDzp7sEK+g
	 /yLoFzhVuScJUxZo1SkSUuqrjpR0G2KHFzu4J9T3JJ8pRS2wKOPjXQHSSExFAwLLuzpj2
	 bKvtRdcAd98K+/kvIjEAsuYAnyEoKlz/9Gv8BAZcMEvNBExnDsGXaDV+mLGBo14mtG5tV
	 QIlL7GpZ93Up5g37L+jHAp+8YT40lzNB2Y1zjib6k6upDOLbaY+OUc3JcKBxAK+Q0Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ot1NzJ2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE17606A328;
	Wed,  4 Nov 2026 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ot1NzJ2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6971F0093A;
	Wed,  4 Nov 2026 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804737;
	bh=OfHRgaXZqSxqsm3is7DGxgnfe85zZdPObdvrLpJIvtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot1NzJ2ZVJjEGe6J6bViJ7onW2CjRbtMHoSgEXrfygVXVlIO8iMMhSk5qCn7Sh9Mg
	 pipqi8oH75w3LrKmpZfa3OCo842e9DVENMffMBBKClnplFb9o85gwfgQGX6dBPuGf0
	 H2628jvcsNL/FjTxfPHCtnWodIWbPtX2nHXkXtx0qHpJ8UiekMZ3SsQpIB5dt6J60s
	 17TwfAQWqHeqc39hz4PXy3lVdYFccZDhzyvnGixS5jjzVPlTe8dCg0WgseFD5SDzHG
	 w6nvcn+XqpG/EFdizMA5621SayKqDO5iTXZYlBouQbGcxW+HlKZA3ZFB9k+XNxbTtC
	 /aircmc/57ZgA==
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
Subject: [RFC PATCH v4 20/25] vfio: Dispatch guest_memfd provider operations through the device file
Date: Wed,  4 Nov 2026 20:33:17 +0530
Message-ID: <20261104150322.3516320-21-aneesh.kumar@kernel.org>
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

Forward guest_memfd provider operations and the supplied device context
through the VFIO device file to the device driver. Validate the driver
callbacks before attachment. Keep a reference to the VFIO device file
until the driver's provider release callback returns, so the device and
driver operations remain available throughout cleanup.

Reject non-VFIO resource files and providers without device PFNs, whole-
range validation, mapping exclusion and release support. BAR
addresses are device PFNs rather than allocatable RAM folios; accepting
folio callbacks or incomplete exclusion callbacks would allow a backing
type that cannot honor device mapping and revocation rules. A driver
without this contract returns EOPNOTSUPP at attachment rather than
exposing its regions through a partial provider.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/vfio_main.c | 108 +++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h     |   4 ++
 2 files changed, 112 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ff49f2fdb602..838242f82fd2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
+#include <linux/guest_memfd.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
 #if IS_ENABLED(CONFIG_KVM)
@@ -248,6 +249,110 @@ struct vfio_device *_vfio_alloc_device(size_t size, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(_vfio_alloc_device);
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+struct vfio_gmem_provider {
+	const struct guest_memfd_provider_operations *ops;
+	void *data;
+	struct file *file;
+};
+
+static void *vfio_gmem_provider_attach(struct inode *inode, struct file *file,
+				       struct guest_memfd_device *gmem)
+{
+	const struct guest_memfd_provider_operations *ops;
+	struct vfio_gmem_provider *provider;
+	struct vfio_device_file *df;
+	void *data;
+
+	/* Reject other file types before interpreting their private_data. */
+	if (file->f_op != &vfio_device_fops || !gmem)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	df = file->private_data;
+	ops = df->device->ops->gmem_provider_ops;
+	/* Every provider must support attachment and release. */
+	if (!ops || !ops->attach || !ops->release)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* VFIO requires device PFNs, range validation and mapping exclusion. */
+	if (!ops->get_pfn || !ops->device_memory ||
+	    !ops->prepare_memory_region ||
+	    !ops->lock ||
+	    !ops->unlock)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* VFIO provides PFNs, not folios. */
+	if (ops->alloc_folio || ops->invalidate_folio)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	provider = kzalloc_obj(*provider);
+	if (!provider)
+		return ERR_PTR(-ENOMEM);
+
+	data = ops->attach(inode, file, gmem);
+	if (IS_ERR(data)) {
+		kfree(provider);
+		return data;
+	}
+
+	provider->ops = ops;
+	provider->data = data;
+	/* Pin the driver operations through release(), including its return. */
+	provider->file = get_file(file);
+	return provider;
+}
+
+static void vfio_gmem_provider_release(void *data)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	provider->ops->release(provider->data);
+	fput(provider->file);
+	kfree(provider);
+}
+
+static int vfio_gmem_provider_prepare_memory_region(void *data,
+		u64 offset, u64 size, u32 flags)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	return provider->ops->prepare_memory_region(provider->data, offset,
+						    size, flags);
+}
+
+static int vfio_gmem_provider_get_pfn(void *data, pgoff_t index,
+		unsigned long *pfn, int *max_order)
+{
+	struct vfio_gmem_provider *provider = data;
+
+	return provider->ops->get_pfn(provider->data, index, pfn, max_order);
+}
+
+static void vfio_gmem_provider_lock(void *context)
+{
+	struct vfio_gmem_provider *provider = context;
+
+	provider->ops->lock(provider->data);
+}
+
+static void vfio_gmem_provider_unlock(void *context)
+{
+	struct vfio_gmem_provider *provider = context;
+
+	provider->ops->unlock(provider->data);
+}
+
+static const struct guest_memfd_provider_operations vfio_gmem_provider_ops = {
+	.attach = vfio_gmem_provider_attach,
+	.release = vfio_gmem_provider_release,
+	.prepare_memory_region = vfio_gmem_provider_prepare_memory_region,
+	.lock = vfio_gmem_provider_lock,
+	.unlock = vfio_gmem_provider_unlock,
+	.get_pfn = vfio_gmem_provider_get_pfn,
+	.device_memory = true,
+};
+#endif
+
 static int vfio_fs_init_fs_context(struct fs_context *fc)
 {
 	return init_pseudo(fc, VFIO_MAGIC) ? 0 : -ENOMEM;
@@ -1449,6 +1554,9 @@ static void vfio_device_show_fdinfo(struct seq_file *m, struct file *filep)
 #endif
 
 const struct file_operations vfio_device_fops = {
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	.gmem_provider_ops = &vfio_gmem_provider_ops,
+#endif
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
 	.release	= vfio_device_fops_release,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2436b8bd600a..10fd5015ce1d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -88,6 +88,8 @@ struct vfio_device {
 	struct dentry *debug_root;
 };
 
+struct guest_memfd_provider_operations;
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -118,9 +120,11 @@ struct vfio_device {
  *         if none was provided.
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
+ * @gmem_provider_ops: Optional driver guest_memfd resource operations
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
  */
 struct vfio_device_ops {
+	const struct guest_memfd_provider_operations *gmem_provider_ops;
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);
-- 
2.43.0


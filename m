Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804743;
	b=pxrZBE+7pzjtRq6W7LKfHE++aBN52kseX2jfPHSXtkrHYv+EIo1ZCccCJPyDEFmadfwm
	 pwdHj9+CfitSy1cBGjz/fY9jul7bG6KfXJvpZpmUBGaHXRpFg+y/3x0jkY2Tkob87VZBG
	 s/U+cV7OG6ZqICO1hx94VOpbK9erGpE26nfMrulYSFZ7zrSt0GaVXI4wOJ7d0JRfMfOQZ
	 dWO7e/MgFeeB+v+BEUJlJaZpc0YeybY7KhKv0jGooL6mCeHDxKjvqXAlebAmgZ1PG0vjt
	 WfeFpbRerjn9PlTwVhaanj7G4ZgB2d/P+QjkVFp6kk1TsLhSIK0klrITkcB4SFjxVUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XtwrP+9WG0tv+esqn1OMvIE4RAJMiQncGuinvZmD9Fk=;
	b=o0f9mY2Pew0UCwAR4NnUijzhGgPZT473ct0PZH/5pIBiyqEEg3jnLLnZrZW4rVK7BbjU
	 sUw2/DvKYI4cUgptNrsjO7j93M0Ymymf4RIvD7AeDUEKA5LTG+I+ZjMmAFbj+rI4QHx+K
	 e/BHHRvL37vj7YmvQ5dWkesLNhrwNMLpIXN/C8S6ke+sPTKH1brZhoiJPUId8um43G4XU
	 W5Htkt1c0DL1EXc5h94E41cRDdSo2SJ42dO89Bt+YD7d4It0LOPvY5l63NOjmvKSa0aTk
	 gTgLK2SPRRqZ5fhcuuowV/TyQvLBHqRqk5BZolgcPB/XSWV2+Pd/BG3TKLCSquRSzgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LegUeoE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C3606A31B;
	Wed,  4 Nov 2026 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LegUeoE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B391F000C1;
	Wed,  4 Nov 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804743;
	bh=XtwrP+9WG0tv+esqn1OMvIE4RAJMiQncGuinvZmD9Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LegUeoE0jvEl5m+YOgT/PD4mjKMmc+PuRDY0NEq11U20TY+iLXIX0GOSRI/aZut/a
	 msSGHp51+yoexNH+r3bOyAWcWJ4kcb1BQifh/9W8sxMMc2IZoRmdN6EbXhbIk9GfaB
	 kJJgwh7X5UwxsJk8CT8IUVsEMNlXkhkxu5J1lbXR9GvbX1vqgprFZHONAqpRmAEcjI
	 z5GwRoWuQiH5agMOc+42RveihP/E8apj+S0HCKrG/x3TKX3YAiSOOh4oOsSRHRnT1u
	 F4nHIL9aX36+9mSERiMgWjYZHqlZn249h6sbZ+u6KYY9MXZVBe5WvagYuq/GmSrgSW
	 t+YDkMl0iqvpA==
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
Subject: [RFC PATCH v4 21/25] vfio: Serialize guest_memfd attachment with device file operations
Date: Wed,  4 Nov 2026 20:33:18 +0530
Message-ID: <20261104150322.3516320-22-aneesh.kumar@kernel.org>
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

Attaching a VFIO device to guest_memfd must not race with VFIO file
operations that access its BARs or create mappings. The attachment state
must apply to every open VFIO file referring to the same device.

Hold the device's gmem_lock for reading across read, write, mmap and
normal ioctl dispatch, and for writing across provider attachment and
release. File operations already in progress finish before attachment
proceeds. Later operations observe the updated gmem_attached state while
holding the same lock, allowing driver checks to reject BAR access.

Hold dev_set->lock across the driver attach/release callbacks and updates
to gmem_attached as well. This lets hot reset check every affected device
for an attachment under the device-set lock without racing attachment or
release. Driver callbacks run with both locks held and must not reacquire
them.

Return EBUSY for VFIO mmap while guest_memfd is attached, including mmap
through another open VFIO file. Such a mapping would insert BAR PFNs
without checking guest_memfd attributes

Keep read, write and ioctl dispatch available to the driver. The PCI
checks reject operations that access BARs or disrupt their mappings while
preserving configuration queries, unrelated ioctls, feature probes and
cleanup.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c |  2 ++
 drivers/vfio/pci/vfio_pci_core.c   |  3 +++
 drivers/vfio/vfio_main.c           | 28 +++++++++++++++++++++++++++-
 include/linux/vfio.h               |  4 +++-
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 014f865c1eaf..2cd855cc50bc 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -599,6 +599,8 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 		}
 
 		/*
+		 * vfio_device_fops_write() holds gmem_lock for read, keeping
+		 * gmem_attached unchanged across this write.
 		 * Check BME and Memory Enable changes while holding memory_lock
 		 * for write, before updating hardware or vconfig. Return an
 		 * error rather than silently masking a rejected write.
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2789bfab4415..b8e574194f07 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -378,6 +378,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
 	 * semaphore.
+	 *
+	 * vfio_device_fops_unl_ioctl() holds gmem_lock for read,
+	 * preventing provider setup during this operation.
 	 */
 	ret = vfio_pci_begin_bar_state_change(vdev);
 	if (ret)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 838242f82fd2..787d9a661f75 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -289,12 +289,21 @@ static void *vfio_gmem_provider_attach(struct inode *inode, struct file *file,
 	if (!provider)
 		return ERR_PTR(-ENOMEM);
 
+	guard(rwsem_write)(&df->device->gmem_lock);
+	if (df->device->gmem_attached) {
+		kfree(provider);
+		return ERR_PTR(-EBUSY);
+	}
+
+	/* Publish attachment under both locks for device-set reset admission. */
+	guard(mutex)(&df->device->dev_set->lock);
 	data = ops->attach(inode, file, gmem);
 	if (IS_ERR(data)) {
 		kfree(provider);
 		return data;
 	}
 
+	df->device->gmem_attached = true;
 	provider->ops = ops;
 	provider->data = data;
 	/* Pin the driver operations through release(), including its return. */
@@ -306,7 +315,13 @@ static void vfio_gmem_provider_release(void *data)
 {
 	struct vfio_gmem_provider *provider = data;
 
-	provider->ops->release(provider->data);
+	struct vfio_device_file *df = provider->file->private_data;
+
+	scoped_guard(rwsem_write, &df->device->gmem_lock) {
+		guard(mutex)(&df->device->dev_set->lock);
+		provider->ops->release(provider->data);
+		df->device->gmem_attached = false;
+	}
 	fput(provider->file);
 	kfree(provider);
 }
@@ -1447,6 +1462,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
 		return vfio_df_ioctl_bind_iommufd(df, uptr);
 
+	guard(rwsem_read)(&device->gmem_lock);
+
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
@@ -1495,6 +1512,8 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	guard(rwsem_read)(&device->gmem_lock);
+
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
@@ -1512,6 +1531,8 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	guard(rwsem_read)(&device->gmem_lock);
+
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
@@ -1527,10 +1548,15 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 
+	guard(rwsem_read)(&device->gmem_lock);
+
 	/* Paired with smp_store_release() following vfio_df_open() */
 	if (!smp_load_acquire(&df->access_granted))
 		return -EINVAL;
 
+	if (device->gmem_attached)
+		return -EBUSY;
+
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 10fd5015ce1d..ceab68b76300 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -120,7 +120,9 @@ struct guest_memfd_provider_operations;
  *         if none was provided.
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
- * @gmem_provider_ops: Optional driver guest_memfd resource operations
+ * @gmem_provider_ops: Optional driver guest_memfd resource operations. VFIO
+ *                     calls attach/release with gmem_lock held for write and
+ *                     dev_set->lock held; callbacks must not reacquire them.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
  */
 struct vfio_device_ops {
-- 
2.43.0


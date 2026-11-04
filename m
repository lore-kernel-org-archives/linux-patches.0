Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804755;
	b=RYSOxr/Ifwmnh3X+w8C8JDSlHlkn/QopRvE6BjfjwRz8KWBqrdxeqKCllfeNUARfzRPT
	 UbM/kCzz4FwBq0SJoRAb9oE1+vhmW3jX4AtGgNrfZroVMZukAYaKdH2fPNvlE8wBocpS0
	 vnAykMvjA2ozRtW2hbrgV8Lq5iI/iUULJKzfQzCn+Od+KbsntNsg6V3T+ZXIxwl0TdbE8
	 mETKqy6cn7EdNvr+m9nmvSHxtLaDhP1e6dcXeQi7yOS3tXyFeb/icYT54aosEBJZA+A2x
	 GG7IlbXQ994sLUVQJB5cTItFx/BusGdvwAEZDxrpQo/hE5zJYJf0M899ecI9xOCXqmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MYG2ULraUpu9OXW6R0IfVg5ZHAPzyrlBv8Zg4i/U04o=;
	b=tkyPNO2hWTxIQzHGe/NM0IEs/FoSXerT6pTcEFehx/3E7S4W915gM8GOaOqDxbWVyCPg
	 VcglQoL2NHZGAcWC6XRaHjib2P5Y/wvtkjHnBlXo6GDBVQE0uX9Gut3eW7hNXfNAmJzm6
	 atN41nM5dhojBIJjGhbReTCmoRtGAizDATFeWFQJ+33odhTxKQ+X0fDWwWLtkJvjwlTjr
	 ynU/QCVsVzmfoC+JkNTLLXTbUH5yZPphATXvsnByS8CHfbUHte9COAaB+JYXJ7Za7c6PC
	 Uto52VFTAR6tILtgQlcDIUweswjRp0eQ3dO6UtftS/R8HNIDug3hh+XnYTnApdPYsuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TwdJdhXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BB606A31B;
	Wed,  4 Nov 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TwdJdhXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9BB1F000C1;
	Wed,  4 Nov 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804755;
	bh=MYG2ULraUpu9OXW6R0IfVg5ZHAPzyrlBv8Zg4i/U04o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwdJdhXBFEY10wdjHTSItSilUmwaD0G8ErBLAnTjbL1eunTB5YEb8QQMta350mgH8
	 IRdv+HOypmPbEx0EcidUL0SEXJVfa+X8KvpTN4EBELAkZKA8TW0RkMmXVJDBc0izPF
	 WsweKMR71SFL79lThLdf/Ra8Wub4KHzQZtb4E1ux5pn0P3Z4vysg+CVidrDSjfwmDx
	 QWBDuDO3UCIHtZBsq3fpSBPgZiSv35PASONyD6KvNCuZnMDxWMW/RFHo/S2G+9cGKA
	 5Fz6hF0DhbDXrJBiV3YkfpbPlGu7/0PLtfI9ff331F9U2dwAyY5PguguH6Zk4PBuID
	 /aF6BNzlVGaKQ==
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
Subject: [RFC PATCH v4 23/25] iommufd: Support MMIO provider attachment to vDEVICEs
Date: Wed,  4 Nov 2026 20:33:20 +0530
Message-ID: <20261104150322.3516320-24-aneesh.kumar@kernel.org>
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

Allow a device MMIO provider to attach to the existing vDEVICE after the
backend validates its association with the VM. Keep the vDEVICE and
IOMMUFD context alive until the provider detaches.

Add a per-vDEVICE MMIO mutex to serialize provider attachment and
detachment, and allow providers and backends to use the same lock for
memory conversion and device state changes. Provide a callback to query
whether private MMIO ranges remain.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev
Cc: patches@lists.linux.dev
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/iommufd/viommu.c | 86 ++++++++++++++++++++++++++++++++++
 include/linux/iommufd.h        | 26 ++++++++++
 2 files changed, 112 insertions(+)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 6479083be095..09dedd4ece6d 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -290,6 +290,7 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_unlock_igroup;
 	}
 
+	mutex_init(&vdev->mmio_lock);
 	vdev->virt_id = virt_id;
 	vdev->viommu = viommu;
 	refcount_inc(&viommu->obj.users);
@@ -527,3 +528,88 @@ int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(ucmd->ictx, &viommu->obj);
 	return rc;
 }
+
+struct iommufd_vdevice *
+iommufd_device_attach_mmio_provider(struct iommufd_device *idev,
+		struct kvm *kvm, void *data,
+		bool (*has_private_mmio)(void *),
+		unsigned long *owner)
+{
+	struct iommufd_vdevice *vdev;
+	int ret;
+
+	if (!idev)
+		return ERR_PTR(-ENODEV);
+
+	guard(mutex)(&idev->igroup->lock);
+	if (idev->destroying)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	vdev = idev->vdev;
+	if (!vdev)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!vdev->viommu->ops ||
+	    !vdev->viommu->ops->vdevice_get_mmio_owner)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	guard(mutex)(&vdev->mmio_lock);
+	if (vdev->mmio_provider_data)
+		return ERR_PTR(-EBUSY);
+
+	ret = vdev->viommu->ops->vdevice_get_mmio_owner(vdev, kvm, owner);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* IOMMU_DESTROY must wait for the attached gmem provider to detach. */
+	ret = iommufd_try_inc_users(idev->ictx, &vdev->obj);
+	if (ret)
+		return ERR_PTR(ret);
+
+	iommufd_ctx_get(idev->ictx);
+	vdev->mmio_provider_data = data;
+	vdev->has_private_mmio = has_private_mmio;
+	return vdev;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_attach_mmio_provider, "IOMMUFD");
+
+void iommufd_vdevice_detach_mmio_provider(struct iommufd_vdevice *vdev)
+{
+	struct iommufd_ctx *ictx = vdev->viommu->ictx;
+
+	scoped_guard(mutex, &vdev->mmio_lock) {
+		WARN_ON(iommufd_vdevice_has_private_mmio(vdev));
+		vdev->mmio_provider_data = NULL;
+		vdev->has_private_mmio = NULL;
+	}
+	refcount_dec(&vdev->obj.users);
+	iommufd_ctx_put(ictx);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vdevice_detach_mmio_provider, "IOMMUFD");
+
+void iommufd_vdevice_mmio_lock(struct iommufd_vdevice *vdev)
+{
+	mutex_lock(&vdev->mmio_lock);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vdevice_mmio_lock, "IOMMUFD");
+
+void iommufd_vdevice_mmio_unlock(struct iommufd_vdevice *vdev)
+{
+	mutex_unlock(&vdev->mmio_lock);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vdevice_mmio_unlock, "IOMMUFD");
+
+/**
+ * iommufd_vdevice_has_private_mmio() - check for private MMIO ranges
+ * @vdev: vDEVICE whose private MMIO state is being checked
+ *
+ * Return: true if the attached provider has committed private ranges.
+ */
+bool iommufd_vdevice_has_private_mmio(struct iommufd_vdevice *vdev)
+{
+	lockdep_assert_held(&vdev->mmio_lock);
+	if (!vdev->has_private_mmio)
+		return false;
+	return vdev->has_private_mmio(vdev->mmio_provider_data);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vdevice_has_private_mmio, "IOMMUFD");
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 4d5995956cce..0c57073b0f99 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -7,9 +7,11 @@
 #define __LINUX_IOMMUFD_H
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/mutex.h>
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/xarray.h>
@@ -26,6 +28,8 @@ struct iommufd_device;
 struct iommufd_viommu_ops;
 struct tsm_dev;
 struct page;
+struct kvm;
+struct iommufd_vdevice;
 
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
@@ -72,6 +76,19 @@ int iommufd_device_replace(struct iommufd_device *idev, ioasid_t pasid,
 			   u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev, ioasid_t pasid);
 
+/* The returned opaque vDEVICE pins its IOMMUFD context and physical owner. */
+struct iommufd_vdevice *
+iommufd_device_attach_mmio_provider(struct iommufd_device *idev,
+		struct kvm *kvm, void *data,
+		bool (*has_private_mmio)(void *),
+		unsigned long *owner);
+void iommufd_vdevice_detach_mmio_provider(struct iommufd_vdevice *vdev);
+void iommufd_vdevice_mmio_lock(struct iommufd_vdevice *vdev);
+void iommufd_vdevice_mmio_unlock(struct iommufd_vdevice *vdev);
+DEFINE_GUARD(iommufd_vdevice_mmio, struct iommufd_vdevice *,
+	     iommufd_vdevice_mmio_lock(_T), iommufd_vdevice_mmio_unlock(_T))
+bool iommufd_vdevice_has_private_mmio(struct iommufd_vdevice *vdev);
+
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
@@ -132,6 +149,11 @@ struct iommufd_vdevice {
 	/* Supported vDEVICE operations; set by vdevice_init(). */
 	u64 supported_ops;
 
+	/* Serialize attachment and conversion of device memory. */
+	struct mutex mmio_lock;
+	void *mmio_provider_data;
+	bool (*has_private_mmio)(void *data);
+
 	/* Clean up all driver-specific parts of an iommufd_vdevice */
 	void (*destroy)(struct iommufd_vdevice *vdev);
 };
@@ -179,6 +201,7 @@ struct iommufd_hw_queue {
  *                    which case the core re-invokes the op for the remainder.
  *                    The data structure of the array entry must be defined in
  *                    include/uapi/linux/iommufd.h
+ * @vdevice_get_mmio_owner: Validate the VM and return its MMIO owner.
  * @vdevice_size: Size of the driver-defined vDEVICE structure per this vIOMMU
  * @vdevice_init: Initialize the driver-level structure of a vDEVICE object, or
  *                related HW procedure. @vdev is already initialized by iommufd
@@ -217,6 +240,9 @@ struct iommufd_viommu_ops {
 		const struct iommu_user_data *user_data);
 	int (*cache_invalidate)(struct iommufd_viommu *viommu,
 				struct iommu_user_data_array *array);
+	/* Owner lookup runs with vdevice->mmio_lock held. */
+	int (*vdevice_get_mmio_owner)(struct iommufd_vdevice *vdev,
+		struct kvm *kvm, unsigned long *owner);
 	const size_t vdevice_size;
 	int (*vdevice_init)(struct iommufd_vdevice *vdev);
 	size_t (*get_hw_queue_size)(struct iommufd_viommu *viommu,
-- 
2.43.0


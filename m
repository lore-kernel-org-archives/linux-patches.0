Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804732;
	b=KtLA6JK4gAsPRciaonQhotsUVv0Na06WyXRqD1Yu5UDFNRfxKK/U0k2AmKyMhUvfGwGZ
	 1WerAsU5RGpHCMJRGdGQ0+iwu1c+RAqXFshTE1qMhik5r/F2KZrDyTzD1MaPC7BrM5lW1
	 4ejHkGgvk7hLiP4jXYEuJ6hXO13NRWBWzwI+wBSSl9YtE1VKW79IyjCJYaw0296n9z/nf
	 TJ8wn3uXGR2SFnBpxyYjUleGzYqfXXHWaN+VcqurqPQuD5QNbexdYtqw3XFSQ4GUbG/BS
	 /ClhRSyQqtCmTnkvT4KWBi7fjTQ8JUfVFlHhrOlrXVoWpeYJwCFvOQXqXyi5LWQCtaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NhCjuJGM358LrsWpzir5ZpNUbD/XvAk/1Sv+dmkkuDc=;
	b=HmIw6jKraq01NLAfxZDFQm1Bd0/subDHOtKvU3jGbmfarQPrKex/Qx3gWa0KfUryEAhP
	 4RunvV42C98jmZGEC7GflZL+6uG3gp8+OzRAyKcX/LrJ18QwX7UDzK21wO7aT22ykoY4g
	 Wd1mYPG9UWGOxhTJ/aOQcrhwiCla7JPaYyoyiliArwvCHWtaZRAiSLkHWMp3C1Qni4Ie9
	 5QW92St8dX+mtRL5QtmWDLpJTwAzcU49DwsphqacVJOMYvMH4l7TOU/fZ3LjQKmNcZrj/
	 FUVt5TNb7u5ofWDsW+pWO01HWDO57OtAHfftRiDGIbvPqLHi0RlfhaiJpsG4H+YuRbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SFPWn+/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45E7606D805;
	Wed,  4 Nov 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SFPWn+/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B11F000C1;
	Wed,  4 Nov 2026 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804730;
	bh=NhCjuJGM358LrsWpzir5ZpNUbD/XvAk/1Sv+dmkkuDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFPWn+/p5tpAIwYdfyaoCt8zXGBUltVGMPWbLzjctE3z0g6Er6huYdC84CVpf9bQF
	 cgatq5pPfa+qvaQZqqf+BiCeQ8cysg8WBbpK7i+wwDCE88Z5ROzst0bqvGkqLTfB4E
	 vuH1oPfP/AfWjVoWXKRT2nxFKrSvkLxrKOIAtbRYrI5D7AcnZKJUU0tdO/hr3eJTMQ
	 /zfPTZiza0hKNleRNoFVQTzfuyINWtOgvhAMyYmquz1EhhyiDCdJcj+zqb+EdfrB8p
	 WugXtYzlHYr5fpEsL9ooWak2yqOf40+DcZ5Vvi0uv48rNCnzAuyEklCjKsFIfogM3X
	 YOQpoRVSUfouA==
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
Subject: [RFC PATCH v4 19/25] vfio/pci: Restrict host BAR access for guest_memfd providers
Date: Wed,  4 Nov 2026 20:33:16 +0530
Message-ID: <20261104150322.3516320-20-aneesh.kumar@kernel.org>
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

Exclude direct VFIO BAR access for the lifetime of a guest_memfd
provider. Access through the provider is checked and revoked by
guest_memfd; the following VFIO paths would bypass that protection:

* PCI read/write dispatch can reach MMIO BARs directly, I/O-port BARs
  through port I/O, and ROM, VGA or driver-specific region accessors.
  Reject all non-config read/write with EBUSY at dispatch, rather than
  relying on low-level MMIO checks which do not cover I/O-port BARs.

* An ioeventfd registration installs a kernel handler that writes its
  configured BAR address when signalled. Deny new registrations with
  EBUSY because those writes do not fault through guest_memfd or check
  private attributes. Preserve removal so an existing handler can be
  drained before attachment.

* A BAR dma-buf export supplies PFNs to another kernel/DMA user outside
  guest_memfd revocation. Deny export with EBUSY while preserving
  feature probes; attachment also rejects existing exports.

ROM region discovery is itself a hardware access: pci_map_rom()
enables/maps the ROM and reads it to validate its size. Report no ROM
access or size while attached rather than running that path. Other
region discovery returns metadata without authorizing read/write or
mmap. Require custom capability discovery callbacks to avoid BAR access
while attached.

Allow IRQ configuration, including MSI-X SET_IRQS. The PCI core may
program, mask or tear down the hardware MSI-X table. Userspace must keep
the table pages shared while host MSI-X is active and reject private
table/PBA mappings when unsupported; the kernel does not enforce that
sharing policy. Generic ioeventfd BAR writes remain excluded
independently.

Generic VFIO excludes mmap. Existing VMAs and persistent BAR users
prevent provider attachment, so low-level BAR helpers need no additional
guest_memfd admission checks.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c   | 15 +++++++++++++++
 drivers/vfio/pci/vfio_pci_dmabuf.c |  4 ++++
 drivers/vfio/pci/vfio_pci_priv.h   |  6 ++++++
 drivers/vfio/pci/vfio_pci_rdwr.c   |  4 ++++
 include/linux/vfio_pci_core.h      |  1 +
 5 files changed, 30 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d4f9ce6b5dc6..2789bfab4415 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1169,6 +1169,10 @@ int vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 		info->flags = 0;
 		info->size = 0;
 
+		/* Discovering ROM size maps and reads the ROM. */
+		if (!vfio_pci_bar_access_allowed(vdev))
+			break;
+
 		if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
 			/*
 			 * Check ROM content is valid. Need to enable memory
@@ -1298,6 +1302,12 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 			return PTR_ERR(data);
 	}
 
+	/*
+	 * VFIO_DEVICE_SET_IRQS remains allowed while guest_memfd uses the device.
+	 * MSI-X configuration can access the hardware table through the PCI core,
+	 * bypassing guest_memfd access checks. Userspace must keep the table pages
+	 * shared while host MSI-X is in use.
+	 */
 	mutex_lock(&vdev->igate);
 
 	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
@@ -1638,6 +1648,11 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	int ret;
 
+	/* Non-config-space access needs the BAR access check. */
+	if (index != VFIO_PCI_CONFIG_REGION_INDEX &&
+	    !vfio_pci_bar_access_allowed(vdev))
+		return -EBUSY;
+
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..8cec6c93c049 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -237,6 +237,10 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	if (ret != 1)
 		return ret;
 
+	/* The dispatch gmem_lock excludes attachment through export completion. */
+	if (!vfio_pci_bar_access_allowed(vdev))
+		return -EBUSY;
+
 	if (copy_from_user(&get_dma_buf, arg, sizeof(get_dma_buf)))
 		return -EFAULT;
 
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index f7b3178cc890..a2501759e805 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -18,6 +18,12 @@ vfio_pci_bar_state_change_allowed(struct vfio_pci_core_device *vdev)
 	return true;
 }
 
+static inline bool
+vfio_pci_bar_access_allowed(struct vfio_pci_core_device *vdev)
+{
+	return true;
+}
+
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
 	struct vfio_pci_core_device	*vdev;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index df8848087681..80392392b2db 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -410,6 +410,10 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 	struct vfio_pci_ioeventfd *ioeventfd;
 	void __iomem *io;
 
+	/* Removal is allowed, but new handlers would bypass guest_memfd. */
+	if (fd >= 0 && !vfio_pci_bar_access_allowed(vdev))
+		return -EBUSY;
+
 	/* Only support ioeventfds into BARs */
 	if (bar > VFIO_PCI_BAR5_REGION_INDEX)
 		return -EINVAL;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 6001fda0e001..4ebd29069034 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -46,6 +46,7 @@ struct vfio_pci_regops {
 	int	(*mmap)(struct vfio_pci_core_device *vdev,
 			struct vfio_pci_region *region,
 			struct vm_area_struct *vma);
+	/* Must not access BAR memory while guest_memfd uses the device. */
 	int	(*add_capability)(struct vfio_pci_core_device *vdev,
 				  struct vfio_pci_region *region,
 				  struct vfio_info_cap *caps);
-- 
2.43.0


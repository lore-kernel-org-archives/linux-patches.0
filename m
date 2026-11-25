Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594503;
	b=fpBVuRnBIcn5lKMAgsT+haz7epV7ooM50U+lEzVhDM/kxv0IkCLenu696At6HX9DaHqY
	 EOJ9QPLujDvLJIDDs+Xcy5nGUholaqUnyp+BtptUNUnIZlyAQOTUudi1it9RRrKGTY26z
	 ZYZe50T7M7pe+u7IAH97eYtcGjOSqwrMogkUqIHpUJby/ULJMRjwPDE7FuPxDgdn9lDZw
	 DLCbyGYQyxeXlpFvKWaFAgKk1fRCLYr0m+nvuSG9pWAhVOEDJzWHmJ61B008PUWkgaGRj
	 LQ3eB28H8U067w+ffZ6ye2+wrSWfiuwJLmgBHi6w6SwwdI2Ki1xcUrYnXmf7hFSDpng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RmRIoUEFiPoUEXuldiyZqTnO2hYW9+vnNYyBXZkr9gw=;
	b=5iF5PLA+B4g15XXU4fWFgekkw5Fhnwi5TDW0XT8cK44UTO8ug21TLI7NCtq6G7YwGmsE
	 I1NUhtuEVF5Qg5gaVoLhGMkY3ZeSsJL6Fj2z/PTieLBfkot26SulKEc0SapuXfn3Qunu6
	 b5c9NPxCjUhd7/sigXGOo2jrVPfelvYohl/Cxf9YXnaW9RWD4i1Vty5NmN1TJ6jboKU1a
	 opBg771ZAMbb732+g52fmydAjpBVkk66w5qOTVJUC/N+HD2XDM6HiEitVDpjtI+5hQ6oN
	 WqV3lNRyxjiAfUPEsHdvw9wxtKlbKNEogFzrSHSKTEep5UVF1M38JfPANhegocuiMaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRNNH02v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943D606A335;
	Wed, 25 Nov 2026 08:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRNNH02v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB751F000EE;
	Wed, 25 Nov 2026 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594502;
	bh=RmRIoUEFiPoUEXuldiyZqTnO2hYW9+vnNYyBXZkr9gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRNNH02vCsZQlhTDmr0/lmM6uzmstmR8CJ04jVNRWQ2WgNrB1P/Z/VvWNnd2T0WyV
	 IHwhjDqn21u4cNA+xRxO9BpZs2zzK2Z3doZkqQm58BfHSW5XmNyCbJ5zAkQoO/d4AI
	 GVbTqroDOEEh40MOxdLTTw9SvqhjlC/YQtSvl4r/La3xkqQis9O1+iOlQPyhKq491A
	 AyEV7L6+MGVViWWTVvOSxDmiyIBzhLCa1+6IZTn7N1V6+73haciEAEG7CB6mSQ5lgj
	 QovK3tfVCLFat3Zk1A6Mca5DIiDuiUnM9kEpUxGrMt01CtqPSGiXs/zF4BRYASndlf
	 poWGZK6Ef1lfg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v10 16/18] iommufd/viommu: Allow vIOMMUs without a parent HWPT
Date: Wed, 25 Nov 2026 13:41:19 +0530
Message-ID: <20261125081121.379481-17-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125081121.379481-1-aneesh.kumar@kernel.org>
References: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

VIOMMU_ALLOC currently requires a nesting parent HWPT_PAGING even when
the selected vIOMMU implementation has no use for one. This would force
implementations such as the following Arm Realm vIOMMU to create an
unused parent.

Add IOMMUFD_VIOMMU_NO_HWPT so an implementation can opt out. Require
hwpt_id to be zero in that case and pass a NULL parent domain to its
initialization callback. For implementations requiring a parent, verify
that it supports nesting and belongs to the selected physical IOMMU
driver before invoking viommu_init().

Reject nested domain and hardware queue allocation for a vIOMMU without
a parent. Nested domain allocation also requires physical IOMMU backing.
Document the two allocation modes in the UAPI.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/userspace-api/iommufd.rst | 45 +++++++++++-----------
 drivers/iommu/iommufd/hw_pagetable.c    |  7 ++++
 drivers/iommu/iommufd/viommu.c          | 50 +++++++++++++++++--------
 include/linux/iommufd.h                 | 12 ++++--
 include/uapi/linux/iommufd.h            |  3 +-
 5 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/userspace-api/iommufd.rst
index 763b23339480..7a1e69ec4a5a 100644
--- a/Documentation/userspace-api/iommufd.rst
+++ b/Documentation/userspace-api/iommufd.rst
@@ -82,11 +82,11 @@ Following IOMMUFD objects are exposed to userspace:
   * Direct assigned invalidation queues
   * Direct assigned interrupts
 
-  Such a vIOMMU object generally has the access to a nesting parent pagetable
-  to support some HW-accelerated virtualization features. So, a vIOMMU object
-  must be created given a nesting parent HWPT_PAGING object, and then it would
-  encapsulate that HWPT_PAGING object. Therefore, a vIOMMU object can be used
-  to allocate an HWPT_NESTED object in place of the encapsulated HWPT_PAGING.
+  A vIOMMU object may encapsulate a nesting parent HWPT_PAGING object to
+  support HW-accelerated virtualization features. Whether a parent is required
+  is determined by the selected vIOMMU implementation. A vIOMMU can be passed
+  as ``pt_id`` to ``IOMMU_HWPT_ALLOC`` to create an HWPT_NESTED object only if
+  it encapsulates a nesting parent HWPT_PAGING.
 
   .. note::
 
@@ -226,9 +226,9 @@ creating the objects and links::
      flag is set.
 
 4. IOMMUFD_OBJ_HWPT_NESTED can be only manually created via the IOMMU_HWPT_ALLOC
-   uAPI, provided an hwpt_id or a viommu_id of a vIOMMU object encapsulating a
-   nesting parent HWPT_PAGING via @pt_id to associate the new HWPT_NESTED object
-   to the corresponding HWPT_PAGING object. The associating HWPT_PAGING object
+   uAPI, provided an hwpt_id or a viommu_id of a parent-backed vIOMMU object
+   via @pt_id to associate the new HWPT_NESTED object to the corresponding
+   HWPT_PAGING object. The associating HWPT_PAGING object
    must be a nesting parent manually allocated via the same uAPI previously with
    an IOMMU_HWPT_ALLOC_NEST_PARENT flag, otherwise the allocation will fail. The
    allocation will be further validated by the IOMMU driver to ensure that the
@@ -245,25 +245,28 @@ creating the objects and links::
       of the object passed in via the @pt_id field of struct iommu_hwpt_alloc.
 
 5. IOMMUFD_OBJ_VIOMMU can be only manually created via the IOMMU_VIOMMU_ALLOC
-   uAPI, provided a dev_id (for the device's physical IOMMU to back the vIOMMU)
-   and an hwpt_id (to associate the vIOMMU to a nesting parent HWPT_PAGING). The
-   iommufd core will link the vIOMMU object to the struct iommu_device that the
-   struct device is behind. And an IOMMU driver can implement a viommu_alloc op
-   to allocate its own vIOMMU data structure embedding the core-level structure
-   iommufd_viommu and some driver-specific data. If necessary, the driver can
-   also configure its HW virtualization feature for that vIOMMU (and thus for
-   the VM). Successful completion of this operation sets up the linkages between
-   the vIOMMU object and the HWPT_PAGING, then this vIOMMU object can be used
-   as a nesting parent object to allocate an HWPT_NESTED object described above.
+   uAPI, provided a dev_id identifying the device used to select the vIOMMU
+   implementation and, if the selected implementation requires a nesting
+   parent HWPT_PAGING, an hwpt_id. The hwpt_id must be zero for an
+   implementation that does not use a parent. A physical-IOMMU implementation
+   links the vIOMMU object to the struct iommu_device behind the device. Other
+   implementations, such as a TSM associated with the device, can provide their
+   own backing and device association. An implementation can allocate its own
+   vIOMMU data structure embedding the core-level structure iommufd_viommu and
+   some implementation-specific data. If necessary, it can also configure its
+   virtualization resources for that vIOMMU (and thus for the VM). A
+   parent-backed vIOMMU can be used as a nesting parent object to allocate an
+   HWPT_NESTED object described above.
 
 6. IOMMUFD_OBJ_VDEVICE can be only manually created via the IOMMU_VDEVICE_ALLOC
    uAPI, provided a viommu_id for an iommufd_viommu object and a dev_id for an
    iommufd_device object. The vDEVICE object will be the binding between these
    two parent objects. Another @virt_id will be also set via the uAPI providing
    the iommufd core an index to store the vDEVICE object to a vDEVICE array per
-   vIOMMU. If necessary, the IOMMU driver may choose to implement a vdevce_alloc
-   op to init its HW for virtualization feature related to a vDEVICE. Successful
-   completion of this operation sets up the linkages between vIOMMU and device.
+   vIOMMU. A physical-IOMMU implementation requires the device to be behind the
+   same iommu_device as the vIOMMU. Other implementations validate the device
+   association while initializing the vDEVICE. Successful initialization sets
+   up the linkage between the vIOMMU and device.
 
 A device can only bind to an iommufd due to DMA ownership claim and attach to at
 most one IOAS object (no support of PASID yet).
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 859eadf05f1d..deb8a94d8b75 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -306,6 +306,13 @@ iommufd_viommu_alloc_hwpt_nested(struct iommufd_viommu *viommu, u32 flags,
 		return ERR_PTR(-EOPNOTSUPP);
 	if (!user_data->len)
 		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!viommu->hwpt)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (viommu->backing != IOMMUFD_VIOMMU_BACKING_IOMMU)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!viommu->ops || !viommu->ops->alloc_domain_nested)
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 909ef86f39a9..e176bc2f5235 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -19,7 +19,9 @@ void iommufd_viommu_destroy(struct iommufd_object *obj)
 	if (viommu->backing == IOMMUFD_VIOMMU_BACKING_TSM)
 		tsm_put_device(viommu->tsm_dev);
 
-	refcount_dec(&viommu->hwpt->common.obj.users);
+	if (viommu->hwpt)
+		refcount_dec(&viommu->hwpt->common.obj.users);
+
 	if (viommu->kvm_file)
 		fput(viommu->kvm_file);
 	xa_destroy(&viommu->vdevs);
@@ -33,7 +35,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		.uptr = u64_to_user_ptr(cmd->data_uptr),
 		.len = cmd->data_len,
 	};
-	struct iommufd_hwpt_paging *hwpt_paging;
+	struct iommufd_hwpt_paging *hwpt_paging = NULL;
+	struct iommu_domain *parent_domain = NULL;
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
 	struct iommu_device *iommu_dev = NULL;
@@ -95,15 +98,27 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_idev;
 	}
 
-	hwpt_paging = iommufd_get_hwpt_paging(ucmd, cmd->hwpt_id);
-	if (IS_ERR(hwpt_paging)) {
-		rc = PTR_ERR(hwpt_paging);
-		goto out_put_idev;
-	}
+	if (ops->flags & IOMMUFD_VIOMMU_NO_HWPT) {
+		if (cmd->hwpt_id) {
+			rc = -EINVAL;
+			goto out_put_idev;
+		}
+	} else {
+		hwpt_paging = iommufd_get_hwpt_paging(ucmd, cmd->hwpt_id);
+		if (IS_ERR(hwpt_paging)) {
+			rc = PTR_ERR(hwpt_paging);
+			goto out_put_idev;
+		}
 
-	if (!hwpt_paging->nest_parent) {
-		rc = -EINVAL;
-		goto out_put_hwpt;
+		/*
+		 * A parent HWPT requires physical IOMMU backing. The parent must
+		 * support nesting and belong to that IOMMU's driver.
+		 */
+		if (!hwpt_paging->nest_parent || !iommu_dev ||
+		    hwpt_paging->common.domain->owner != iommu_dev->ops) {
+			rc = -EINVAL;
+			goto out_put_hwpt;
+		}
 	}
 
 	viommu = (struct iommufd_viommu *)_iommufd_object_alloc_ucmd(
@@ -119,7 +134,9 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	viommu->type = cmd->type;
 	viommu->ictx = ucmd->ictx;
 	viommu->hwpt = hwpt_paging;
-	refcount_inc(&viommu->hwpt->common.obj.users);
+	if (viommu->hwpt)
+		refcount_inc(&viommu->hwpt->common.obj.users);
+
 	INIT_LIST_HEAD(&viommu->veventqs);
 	init_rwsem(&viommu->veventqs_rwsem);
 
@@ -136,8 +153,10 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		viommu->iommu_dev = iommu_dev;
 	}
 
-	rc = ops->viommu_init(viommu, idev->dev,
-			      hwpt_paging->common.domain,
+	if (hwpt_paging)
+		parent_domain = hwpt_paging->common.domain;
+
+	rc = ops->viommu_init(viommu, idev->dev, parent_domain,
 			      user_data.len ? &user_data : NULL);
 	if (rc)
 		goto out_put_hwpt;
@@ -148,7 +167,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 out_put_hwpt:
-	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
+	if (hwpt_paging)
+		iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
 out_put_idev:
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 	return rc;
@@ -472,7 +492,7 @@ int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	if (IS_ERR(viommu))
 		return PTR_ERR(viommu);
 
-	if (!viommu->ops || !viommu->ops->get_hw_queue_size ||
+	if (!viommu->hwpt || !viommu->ops || !viommu->ops->get_hw_queue_size ||
 	    !viommu->ops->hw_queue_init_phys) {
 		rc = -EOPNOTSUPP;
 		goto out_put_viommu;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 77c1a2944c3b..cfa68c169fe7 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -6,6 +6,7 @@
 #ifndef __LINUX_IOMMUFD_H
 #define __LINUX_IOMMUFD_H
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
@@ -157,17 +158,19 @@ struct iommufd_hw_queue {
 	void (*destroy)(struct iommufd_hw_queue *hw_queue);
 };
 
+#define IOMMUFD_VIOMMU_NO_HWPT	BIT(0)
+
 /**
  * struct iommufd_viommu_ops - vIOMMU specific operations
+ * @flags: Properties needed by the core before vIOMMU initialization
  * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
  *                   @dev corresponding to @viommu_type. Driver should return 0
  *                   if vIOMMU isn't supported accordingly. It is required for
  *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
  *                   driver-level vIOMMU structure related to the core one
- * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
- *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
- *               resources shared/passed to user space IOMMU instance. Associate
- *               it with a nesting @parent_domain.
+ * @viommu_init: Initialize the selected driver-level iommufd_viommu for @dev.
+ *               @parent_domain is the nesting parent, or NULL for an
+ *               implementation that does not use a parent HWPT.
  * @destroy: Clean up all driver-specific parts of an iommufd_viommu. The memory
  *           of the vIOMMU will be free-ed by iommufd core after calling this op
  * @alloc_domain_nested: Allocate a IOMMU_DOMAIN_NESTED on a vIOMMU that holds a
@@ -210,6 +213,7 @@ struct iommufd_hw_queue {
  *                      does, it should set it to the @hw_queue->destroy pointer
  */
 struct iommufd_viommu_ops {
+	unsigned long flags;
 	size_t (*get_viommu_size)(struct device *dev,
 		enum iommu_viommu_type type);
 	int (*viommu_init)(struct iommufd_viommu *viommu, struct device *dev,
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b64f6330468e..31371ccd1ef2 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -1138,7 +1138,8 @@ struct iommu_viommu_tegra241_cmdqv {
  * @flags: Must be 0
  * @type: Type of the virtual IOMMU. Must be defined in enum iommu_viommu_type
  * @dev_id: The device's physical IOMMU will be used to back the virtual IOMMU
- * @hwpt_id: ID of a nesting parent HWPT to associate to
+ * @hwpt_id: ID of a nesting parent HWPT to associate to. Must be zero when the
+ *           selected vIOMMU implementation does not use a parent HWPT
  * @out_viommu_id: Output virtual IOMMU ID for the allocated object
  * @data_len: Length of the type specific data
  * @__reserved: Must be 0
-- 
2.43.0


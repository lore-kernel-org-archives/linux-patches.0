Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594391;
	b=laDkxVa5yyyl0xSyeLQjgwifcM9qnOvxL7eDuEa4ztLRCKBgCrWT616hdcDMRgKaVuZd
	 hCYIQVIg9ROWLkWp3erRN4DTsXWNpGxX79p/yuAy44UcnIg3OsQRVgE6sdCH8cpqL67+K
	 CCyLcc1R0CjKnP0LkQOfPyw4ASPV1QcVOT+cBfm054tJ68rPejEam9yylssnlAeaNaeHh
	 BOTgXW36L+dLmmGdwpqPM11ydZyyBLBbn3EynKyxZHgfGi12yVIUPp3THz8c5z8QlQrdG
	 3ga1m13Hp0G+J8pYfDt6eLmmKymLHzbT49GEEDMLrVxRWyFBYZ3ya0i+DUONJRWfXwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ma42EVCHLw9oNHye491Hpe6SPSvAVSqF8kVWbk1Okp8=;
	b=hP6dJs3sQBvo02paI2vnH+mIn757yosbW0kiNdQa0OoBgovfqf1wkROdNeFu9VPdJ+Y+
	 Z6/rmaI/XgNhAR9vEBqL7fT3R5iIONsn3DNHXGUdnu3JJ2ZlUhWsk6plNgTkNWW1BDKQD
	 CcaidJu43riglrvZ+RfV304OG5DxRA0nmp7FT+Dv6toGaKxXLUbiYuWTc2HYxkKB/xcgx
	 FjmlboiIhab1M+tjRRfu80lqCiDTlUXQ50iFqSlJMFi5dV25J94Pc8CgPKXbsPikE1iPU
	 cB5bvWxcECQCBTVCxK52sOVMD0ESZ3/M3xDvYvuBrLJhhhBJE0fEGs3wy6omdnHnhmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qayoz6LT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16756606A31E;
	Wed, 25 Nov 2026 08:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qayoz6LT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56661F000EE;
	Wed, 25 Nov 2026 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594390;
	bh=Ma42EVCHLw9oNHye491Hpe6SPSvAVSqF8kVWbk1Okp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qayoz6LT/pcKgird1wjDuGcFPqJrgj+sBgsyP1l88ILpWrfiTwRzgqmze39sCk7AS
	 T1KaANOo2EO9ckQh8rXADlhzjapuc5N8SHEGTd1iZPqjdjeY/ZloG0j766mvPgGYL+
	 Qj/C+aOPp0d+18SA2JQOcpOeRO/9Uv2qIzr2m+NspVnyHkxZg30GJp361bDyW7XTuw
	 9Df8YSADX0dZH3V3gkSlwZSbdDZ1bMhiQSxU67P/U7K7TIi7Lw+Lp2KzOGMD8NKvfP
	 cbpcwe9mfSeBLM5M8PfKyeGkTVo4T3E03EsXlmYesC8UhPcq5QFwXddSNysv4J36rb
	 eyKYueBy2K5RA==
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
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v10 07/18] iommufd/viommu: Keep a reference to the KVM file
Date: Wed, 25 Nov 2026 13:41:10 +0530
Message-ID: <20261125081121.379481-8-aneesh.kumar@kernel.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

The TSM vDevice operations need access to the KVM associated with the
device's vIOMMU. Save the device's KVM file in the iommufd_viommu when the
vIOMMU is allocated, and take a file reference so it remains valid for the
lifetime of the vIOMMU.

Release the reference when the vIOMMU is destroyed.

Reject vdevice allocation when the device's KVM association differs from
the vIOMMU's, including when only one has a KVM association. Allow
allocation when both associations are NULL.

Based on an original patch by
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jacob Pan <jacob.pan@linux.microsoft.com>
[nicolinc: hold kvm's users_count]
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
[aneesh.kumar: Switch to use kvm_file]
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/iommufd/viommu.c | 10 ++++++++++
 include/linux/iommufd.h        |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index f7951057a1e5..0dbd382eeb98 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
  */
+#include <linux/file.h>
 #include "iommufd_private.h"
 
 void iommufd_viommu_destroy(struct iommufd_object *obj)
@@ -11,6 +12,8 @@ void iommufd_viommu_destroy(struct iommufd_object *obj)
 	if (viommu->ops && viommu->ops->destroy)
 		viommu->ops->destroy(viommu);
 	refcount_dec(&viommu->hwpt->common.obj.users);
+	if (viommu->kvm_file)
+		fput(viommu->kvm_file);
 	xa_destroy(&viommu->vdevs);
 }
 
@@ -82,6 +85,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	}
 
 	xa_init(&viommu->vdevs);
+	if (idev->kvm_file)
+		viommu->kvm_file = get_file(idev->kvm_file);
 	viommu->type = cmd->type;
 	viommu->ictx = ucmd->ictx;
 	viommu->hwpt = hwpt_paging;
@@ -171,6 +176,11 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_viommu;
 	}
 
+	if (idev->kvm_file != viommu->kvm_file) {
+		rc = -EINVAL;
+		goto out_put_idev;
+	}
+
 	iommu_dev = iommufd_device_get_iommu_dev(idev);
 	if (!iommu_dev || viommu->iommu_dev != iommu_dev) {
 		rc = -EINVAL;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index b03ce0187454..c15d80f611b9 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -103,6 +103,7 @@ struct iommufd_viommu {
 	struct iommufd_ctx *ictx;
 	struct iommu_device *iommu_dev;
 	struct iommufd_hwpt_paging *hwpt;
+	struct file *kvm_file;
 
 	const struct iommufd_viommu_ops *ops;
 
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817242;
	b=ISgl1dqjWGuO24MrO46kmjiCAlT9wvAHnucmFEdHUwDHPoXK12oQea0PwO8svSWlPSeQ
	 6UPSya+kHEnlJPIWSl/coxzTwDWF2gq40tla22UoIJUgmo8mM03GZk7C1ZKdKO/RFH2ln
	 Ps5+ORWxj2A6tAPUnVLMcKh5jbRDN7CElnIhVbI2/V6le0mzxtqE15ap+quuH6+ZpIihA
	 ka/SzU5vEKRHcBU6XoW5gHWxzvPKXQQAEEeyCjGWu7s17sWHqe38kyY3RmHax4FdbxeHV
	 OZIlK9GO/IKMJN8swFECddV1ZQdYknBjBJAN4uxTxDn6Y6KXzsuYkF32LgdhJeXz77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=D2hWxMmxiFVTiKjC+qIVH/QKRKvHkoyqwwHnjaEYXpU=;
	b=jfDvY2ZzKvk+UYFbfqQeR2Xoou9kO428cT847DXX7U40WkKfprpP5x2aRInAR2mQByHW
	 f3alMZnxAnRjYxqxBUFTfK+aAGkzX0Z/CBkl7nAecDdNd0Ei9YJ1VYW7+WcBhDBt084s3
	 5IHpCdEtK4JpUFaYh36zJwt7Od/L3BKQGdOdzH6lSf31waHWqXdGcA/SDQibQZepsTvuI
	 flaDr6ZhzWHwALWSdh1jKYXcfRlUFYlnnHjMkqITQ9Tf2VNYAyuaoe1yMJKKV25mzMoWy
	 5ndQNKHQe0LKyUyssWljH2ScX1ex3NbkTZeCWxDJbl2F7AgByxiqFbxvKL8IrefticQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Rb/gK10A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19284606A323;
	Mon, 16 Nov 2026 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rb/gK10A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B680C1F000C8;
	Mon, 16 Nov 2026 08:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817241;
	bh=D2hWxMmxiFVTiKjC+qIVH/QKRKvHkoyqwwHnjaEYXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rb/gK10AFfK6OqdV7dWElfG4+xVFur4//H5stBj+X5co8I4aB9GIP9qXljoviz5kq
	 0sFHoVnpAuy7JnD76RO5vd8tVfD5ASJrU8UCIeMks8TWGraRN94W7o5lWxhw8/44Fz
	 8+htcqGUt4odHGP6kil1Gp2PQxBwccAjEvdAOKwfQ9gk6ZXSPWauM0omoSFZCAr62N
	 KSeI1VMx7fxl8hq5oLIocaoRdOoJP/MF29oYF+9QGecQMMbgypHhWY9NBTgfBz+XtX
	 60q/ryfsXTlGMnLXZsdTPR/Lt/4NzUzwDXvuAIJXuAP9ose6HWCsO9iolJgxIGYWad
	 W3Bhm+V24vkWA==
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
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v9 05/13] iommufd/viommu: Keep a reference to the KVM file
Date: Mon, 16 Nov 2026 13:49:27 +0530
Message-ID: <20261116081935.85372-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116081935.85372-1-aneesh.kumar@kernel.org>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
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


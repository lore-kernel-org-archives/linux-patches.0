Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1600F433D5
	for <patches@lists.linux.dev>; Wed, 30 Oct 2024 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305494; cv=none; b=ikjcMh8uPg/ZnRooqZLunSPBGxj/LHL1QQE0Nsg1WVN0Zw0d7EuUleeGgFalh+eTG6tEDsKpE52WX9ZePiHSycTtGBPuoeR1teS7uCsXBZuXlI3AiBFm4fpfdFZcPeO2Agd1aE1WGljCTtHwDqpeLO5XOaTJm0X/A/M4l4bNKng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305494; c=relaxed/simple;
	bh=kdxsp+FvuAUbZvIT1RpMFDU46BVfWQTsZ9w7Hgn6y/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZAlJCA1z+gJ2E5/rSIxtGhXvZZ/48zCVxujGRTlLFdRaBBY+Pm2VcLQKjYf6eFWWSYLNtQ+wqFuhX2YsGl/bj8XhxKltiy57ajPlf+WxHKq9gTyTZj+UfFNcg8ZV8B0rpb/qEhD9REK0zHLQ1JuZbU4eouXB4EWD4UXdoBzG4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEhQxBYX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEhQxBYX"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so261675e9.0
        for <patches@lists.linux.dev>; Wed, 30 Oct 2024 09:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730305489; x=1730910289; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rirf9ShYmRb5CMlpaICloXmtFMhlyQIKSk5nv7X8RPs=;
        b=LEhQxBYXSJo8qqR25XCZATCdNtwidL8SxT4L9iyv3Cr7ZhtMhwj6+6myR7AQv7+AAm
         erq+cbVdP8YJRMe9LknBqtkOUsP1/37Ed0aLr8Ty27fTW3jidg9VKMEZCeRL4fzNTb4r
         fY7sgfMsjyNdDXBsYuMjHRNVgNDFuqgtFFi/NAAyphSmULPGacDu6j8K5nMCuTzC4BrO
         T5u9nFls7hBrfG3xJT4suJQcLjK6+54vrrY/melArAJvUe/5ghogTpXNti4rS5Imjptk
         zSUBFePMHJY41K2DnlAzBGNg4c7XqJkKyvXFtWzUNWBa4SjesAvYZYZWQCxfXatbiiy6
         aveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730305489; x=1730910289;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rirf9ShYmRb5CMlpaICloXmtFMhlyQIKSk5nv7X8RPs=;
        b=T1+l8+jFSEL4re0WIp/KRCxiy+K2W0FpgwThZyRwC8u875hB3nyHxU/ArKwDnJVsOq
         jgG8KaRZ7ZsUQlsCddZw7frw14oLDoXyUrpYeairmbEz88TSsmSNi53hj3GjKxLL3QC4
         pPgkykRjcaaA4hFQGEvquddKm+zrkQQQavLldGq8Z5KGG96MMpDIoBesjQjjiDpriiPb
         LmpE/fTNHjcPCgxmtINCSV/u2nJDSw4ngvzNoR7asKtu3IeVgJGhYBlJiWpUV9JX/VXB
         jepLZDGma3s1rbW1nBQyNkbRZINpMj+kRaHKYDg3u8h+RTZoh4vFo3h8AjsEdN0LHQCi
         qn2A==
X-Forwarded-Encrypted: i=1; AJvYcCUZ8WsdV/lgM0FQ11FgdYAVi+f4dAXAIU4rfi1KexKIdbzRgS0zt3O2Q7RNvRrDHZLDR55XwvVq@lists.linux.dev
X-Gm-Message-State: AOJu0YyuNfCSWvV5IwGNLFnwbVvwKFKnsg4ZqEYIi9k4lD8P+/zZyLhf
	sBY3T5GqsiX9qi6HKJG4B7MKfogtX4Cz8292rj6hvlrlSwsn5EPKaQdd4Pfy9g==
X-Gm-Gg: ASbGncsjtSLBq4hMFmwd50wRUB2krKj+YP2QTxrjjJSzD0mKFFe3xk1wRR7VxYaK0OA
	AjCUP7cV99N7mrQawyc+hNEFQ46Pmr5AzLdLttvMM9bdgqbb1gDt+JPPAXgb7Z5I2iiaAEdf2bv
	/53XhfRsH0aCFdAqz1aRjPUZrZL06h+8sRqUa7WdMesZtnF7mOQhmNrgFHbCnBFE/jmadunnh6I
	iRro4eBgJ1JB/KCa12MJx2TGjMir6bMhgABcEiULut/sCzKUpSx41ykoXxrreC818ELcntogmnO
	bZiGdtRJ1w==
X-Google-Smtp-Source: AGHT+IGfLN42zYs7WkhqHVTz5dvbQRdyqXTi/om8YzP4B4GGUgm47RZgeS3TcYJgArt8TPOM7QN0Fg==
X-Received: by 2002:a05:600c:c16:b0:42b:a8fc:3937 with SMTP id 5b1f17b1804b1-431b3cdeb36mr11221675e9.4.1730305489275;
        Wed, 30 Oct 2024 09:24:49 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd91834asm26571265e9.7.2024.10.30.09.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:24:48 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:24:44 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 5/9] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZyJdzBgiP70MOtcP@google.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <5-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Wed, Oct 09, 2024 at 01:23:11PM -0300, Jason Gunthorpe wrote:
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
> instance need to be available to the VMM so it can construct an
> appropriate vSMMUv3 that reflects the correct HW capabilities.
> 
> For userspace page tables these values are required to constrain the valid
> values within the CD table and the IOPTEs.
> 
> The kernel does not sanitize these values. If building a VMM then
> userspace is required to only forward bits into a VM that it knows it can
> implement. Some bits will also require a VMM to detect if appropriate
> kernel support is available such as for ATS and BTM.
> 
> Start a new file and kconfig for the advanced iommufd support. This lets
> it be compiled out for kernels that are not intended to support
> virtualization, and allows distros to leave it disabled until they are
> shipping a matching qemu too.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/Kconfig                         |  9 +++++
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 31 ++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++++
>  include/uapi/linux/iommufd.h                  | 35 +++++++++++++++++++
>  6 files changed, 86 insertions(+)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index b3aa1f5d53218b..0c9bceb1653d5f 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -415,6 +415,15 @@ config ARM_SMMU_V3_SVA
>  	  Say Y here if your system supports SVA extensions such as PCIe PASID
>  	  and PRI.
>  
> +config ARM_SMMU_V3_IOMMUFD
> +	bool "Enable IOMMUFD features for ARM SMMUv3 (EXPERIMENTAL)"
> +	depends on IOMMUFD
> +	help
> +	  Support for IOMMUFD features intended to support virtual machines
> +	  with accelerated virtual IOMMUs.
> +
> +	  Say Y here if you are doing development and testing on this feature.
> +
>  config ARM_SMMU_V3_KUNIT_TEST
>  	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
>  	depends on KUNIT
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> index dc98c88b48c827..493a659cc66bb2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
>  arm_smmu_v3-y := arm-smmu-v3.o
> +arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
>  arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
>  arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> new file mode 100644
> index 00000000000000..3d2671031c9bb5
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + */
> +
> +#include <uapi/linux/iommufd.h>
> +
> +#include "arm-smmu-v3.h"
> +
> +void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct iommu_hw_info_arm_smmuv3 *info;
> +	u32 __iomem *base_idr;
> +	unsigned int i;
> +
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return ERR_PTR(-ENOMEM);
> +
> +	base_idr = master->smmu->base + ARM_SMMU_IDR0;
> +	for (i = 0; i <= 5; i++)
> +		info->idr[i] = readl_relaxed(base_idr + i);
> +	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
> +	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);

I wonder if passing the IDRs is enough for the VMM, for example in some
cases, firmware can override the coherency, also the IIDR can override
some features (as MMU700 and BTM), although, the VMM can deal with.

Also, PRI and ATS are gated by configs, I’d be worried if the VMM can make
ome assumptions just from the IDRs.

Maybe for those(coherency, ATS, PRI) we would need to keep the VMM view and
the kernel in sync?

Otherwise, LGTM.

Thanks,
Mostafa

> +
> +	*length = sizeof(*info);
> +	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
> +
> +	return info;
> +}
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 38725810c14eeb..996774d461aea2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3506,6 +3506,7 @@ static struct iommu_ops arm_smmu_ops = {
>  	.identity_domain	= &arm_smmu_identity_domain,
>  	.blocked_domain		= &arm_smmu_blocked_domain,
>  	.capable		= arm_smmu_capable,
> +	.hw_info		= arm_smmu_hw_info,
>  	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
>  	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
>  	.domain_alloc_user	= arm_smmu_domain_alloc_user,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 06e3d88932df12..66261fd5bfb2d2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -81,6 +81,8 @@ struct arm_smmu_device;
>  #define IIDR_REVISION			GENMASK(15, 12)
>  #define IIDR_IMPLEMENTER		GENMASK(11, 0)
>  
> +#define ARM_SMMU_AIDR			0x1C
> +
>  #define ARM_SMMU_CR0			0x20
>  #define CR0_ATSCHK			(1 << 4)
>  #define CR0_CMDQEN			(1 << 3)
> @@ -956,4 +958,11 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
>  	return ERR_PTR(-ENODEV);
>  }
>  #endif /* CONFIG_TEGRA241_CMDQV */
> +
> +#if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
> +void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
> +#else
> +#define arm_smmu_hw_info NULL
> +#endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
> +
>  #endif /* _ARM_SMMU_V3_H */
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 72010f71c5e479..b5c94fecb94ca5 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -484,15 +484,50 @@ struct iommu_hw_info_vtd {
>  	__aligned_u64 ecap_reg;
>  };
>  
> +/**
> + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> + *
> + * @flags: Must be set to 0
> + * @__reserved: Must be 0
> + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> + * @iidr: Information about the implementation and implementer of ARM SMMU,
> + *        and architecture version supported
> + * @aidr: ARM SMMU architecture version
> + *
> + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> + *
> + * User space should read the underlying ARM SMMUv3 hardware information for
> + * the list of supported features.
> + *
> + * Note that these values reflect the raw HW capability, without any insight if
> + * any required kernel driver support is present. Bits may be set indicating the
> + * HW has functionality that is lacking kernel software support, such as BTM. If
> + * a VMM is using this information to construct emulated copies of these
> + * registers it should only forward bits that it knows it can support.
> + *
> + * In future, presence of required kernel support will be indicated in flags.
> + */
> +struct iommu_hw_info_arm_smmuv3 {
> +	__u32 flags;
> +	__u32 __reserved;
> +	__u32 idr[6];
> +	__u32 iidr;
> +	__u32 aidr;
> +};
> +
>  /**
>   * enum iommu_hw_info_type - IOMMU Hardware Info Types
>   * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
>   *                           info
>   * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
> + * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
>   */
>  enum iommu_hw_info_type {
>  	IOMMU_HW_INFO_TYPE_NONE = 0,
>  	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
> +	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
>  };
>  
>  /**
> -- 
> 2.46.2
> 

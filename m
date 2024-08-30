Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11478199FA2
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725031429; cv=none; b=sScAYbee4lAWpzBhdHq1ufUXowjnxxLnWXcYGiCd4aNeKfzvVdVBKeuR+FkzrFVuJ74onUmg8DBUBb4b1hygkx2rhewDWMb3NdG/tN+kndhq5FXB11brQPWvEq7flQpyCaqi4KPuZv6ITDRhD7E3MfdGMAsra8n3EzBW851N+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725031429; c=relaxed/simple;
	bh=6vx2gq56ZM4qeqxj6ucMe1zrs+h9CSZFZQVXtBHV2qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrsbWjx2y1EuQrCI90Hf6FvOyh8+pFgY9A5i6cj1GVAbhPY0uNaE/FskxMHb3BDLIVAESpjSZIe5RIZWa9g5GD/iz+BCk9mIBeJXpQ/DV8RcCiSnq14mL9O/Cz/PylIgSgN7uA8PGQxdPL+VRO+dklQxFKzy1Uc/wvXh3CbWZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3LQiGfQx; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3LQiGfQx"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso52995e9.1
        for <patches@lists.linux.dev>; Fri, 30 Aug 2024 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725031426; x=1725636226; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOU46aVnTgnZrtLuHoe3iJX7qiC4mddr2CSB3vbflRc=;
        b=3LQiGfQx3BO06REg31i0i6wEXd7pcEk+DSwiwH1zU1ue5m1rRkQpFQgsDS/v8uaS91
         HSxjH6gU2xKJcsA14AXZuLprn3QpSLh60tYVXLMVzqa7L/NHcJNNE7Pd/O31rCy9iBOe
         uC/Rxsx+0e5cyJ5xjn7o1X1Az3gVJUaTaDiTlEjr+6elXYYED2ebIvX0YwEhzWzMFT//
         KdBZ58LCFLG/pxQ7iWSbCxEs9WJgnzOCui1I3IA4dfMwupWwgpZYjf6itgFXKNrWc7tR
         3zEvvGdOvseRCjlGDsS3kDerVTqGUYzF0VDdjEJwPoTDg0o3G1J+eCT1bDUSqck+LkDg
         893w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725031426; x=1725636226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOU46aVnTgnZrtLuHoe3iJX7qiC4mddr2CSB3vbflRc=;
        b=wNfet0cjMizmc/+U++bIXl45l2j1a0DKE/2zBaOmKdkxbomRaPx/ikNMUst8Pm66dY
         eJcsS2fU2Sv8uMjp0Si9bUWeDabvavkX1SSDADrRTnrbgdpidwZnFdhpHeVnyluPOqJx
         ah3J2mZxwHGIYQdB1A6BdmR92QRdu/hL+HA+GumXen8e4my2LGfMRHhOJYIAH5Qh4IP+
         i6J89l5v7N5LFEKgh9HMvmRJtq6M2CQF4mb0+eEgHdded9iIJpPigGGOKH/o9BBs7ON9
         0aThclSu7SqQjpqnBRCcGx03JrndPDnW+PcawR+ce8pBRxXq7K6CBk6j7OyTbAcW5slu
         vXEA==
X-Forwarded-Encrypted: i=1; AJvYcCWbtFieFQlrHQzq0W39nNOc44tVqRgQAtXXpUaWW5Fj2AcgG3w5p6O8h8udmWxVZS+FF5ibI9ng@lists.linux.dev
X-Gm-Message-State: AOJu0YxhByijvqDtgzdbwzhiyiC958v3Zz9FLybTKQwcU7Z5d+rYdLSS
	LJAogf6nfNpFMi0a+tWMOkSiT1JsrvseqNptVqPJoEmp4XbTIGQIBgVDU4BZqg==
X-Google-Smtp-Source: AGHT+IHDqRWS3lPGg0daxRyt2QBSUBhTzWgO4oFzGsmOgI5ybD+dtAarfBs2yjdiu5Fpbo6UhaT9Bw==
X-Received: by 2002:a05:600c:384f:b0:426:6edd:61a7 with SMTP id 5b1f17b1804b1-42bbb6a35c2mr1103455e9.7.1725031425900;
        Fri, 30 Aug 2024 08:23:45 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6e27364sm48924815e9.34.2024.08.30.08.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 08:23:45 -0700 (PDT)
Date: Fri, 30 Aug 2024 15:23:41 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZtHj_X6Gt91TlUZG@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 27, 2024 at 12:51:36PM -0300, Jason Gunthorpe wrote:
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
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
>  include/uapi/linux/iommufd.h                | 35 +++++++++++++++++++++
>  3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c2021e821e5cb6..ec2fcdd4523a26 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2288,6 +2288,29 @@ static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
>  	return ret;
>  }
>  
> +static void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
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
> +
> +	*length = sizeof(*info);
> +	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
> +
> +	return info;
> +}
> +
>  struct arm_smmu_domain *arm_smmu_domain_alloc(void)
>  {
>  	struct arm_smmu_domain *smmu_domain;
> @@ -3467,6 +3490,7 @@ static struct iommu_ops arm_smmu_ops = {
>  	.identity_domain	= &arm_smmu_identity_domain,
>  	.blocked_domain		= &arm_smmu_blocked_domain,
>  	.capable		= arm_smmu_capable,
> +	.hw_info		= arm_smmu_hw_info,
>  	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
>  	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
>  	.domain_alloc_user	= arm_smmu_domain_alloc_user,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 45882f65bfcad0..4b05c81b181a82 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -80,6 +80,8 @@
>  #define IIDR_REVISION			GENMASK(15, 12)
>  #define IIDR_IMPLEMENTER		GENMASK(11, 0)
>  
> +#define ARM_SMMU_AIDR			0x1C
> +
>  #define ARM_SMMU_CR0			0x20
>  #define CR0_ATSCHK			(1 << 4)
>  #define CR0_CMDQEN			(1 << 3)
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 4dde745cfb7e29..83b6e1cd338d8f 100644
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
There is a ton of information here, I think we might need to santitze the
values for what user space needs to know (that's why I was asking about qemu)
also SMMU_IDR4 is implementation define, not sure if we can unconditionally
expose it to userspace.

Thanks,
Mostafa
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
> 2.46.0
> 

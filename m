Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795149865;
	b=sAXkSm+yKccbvU9ePkrZtZ1Nzr1b8MAdNly/A9VZ4EBwS/1ivAb7/eKKpdoIln0pJNhx
	 GSlazwB4/JThax+3eTyg5YZzYR/coQ3P3SslQOaBXGMzVvTV3J+I2rjGUSpDjy933fPxX
	 wCahXTx83Op6o7p/qwImf5Gp6YXyTrvwY9t2QswAZAfscg42QxJho6uZPn0OwIC40KxE1
	 X3FZFQDkTkMvLGFmaZMaB0IzXTcDQcV35yDhARDFDDVxWcP2AY9TwxMcc7iPk+4WqG9DB
	 Gh4fFgaipYnJWDoO5jTNTWzxbuKa38F3N3G9qtEb5sHp3tJBgdXhAw4g19lreQfJOhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795149865;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Cc:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PT0FK9wWU0tkRsvayMQ1N9RgAm8dfnFyjV1OONVZR3Y=;
	b=swUjn49XNPL0iZfqaohqwsuYTgfjfTcgpK8yW1xUo/xR2ZIz4FJpUPT86hilWp1E0HUh
	 FdYo54alanol2u2gQc/fWqk9PxXVt+3nb8lEvwtTdnYASQnWCuN62S/E8l93TThB7NX8C
	 6yZexhe2CwQ9mBIFw2v57y+J6hMQkXnUkZWP/gf8YaJrAWSPoUe0cqiIqbkKlJfTMI4zw
	 tYxO56NFRw3xaFX+265PMwnpk3skTZ06jtooYCvvGDq9zQakLOLG3RF3CuaJCPEMlSD+e
	 BISjWvIuAhUwTshul3yZqnfs1qKKl1uQRv58xzdBPGeGJOpbD04b75jzLHEw+2pf3Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DR0FNyfi;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646E606A320;
	Fri, 20 Nov 2026 04:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8646E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DR0FNyfi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795149864; x=1826685864;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y/i10jyYjFWeI3DRZs4bsQaJGnLxtLrgwJ61Ht7xyRw=;
  b=DR0FNyfiJbgVMvIiDbiObMPhvOgv11ebf+6ZrmDb4Ghzi0NGAlPENyQr
   Mjt4hA6zEL3OnXgVc5HZP/wbxGKjsdHluR5EpuHtvUj+VXNYpegost5L6
   FNP5xBPEQaomV9Y0zwBFEcWFJ7EEs7e/lLiD1N4lsSu2IJuH1awi0zc3E
   3RsBw6aVqC+S639YFyniScQSHXulefvSMxrLetOit3cgVnpKa2G9e3iw7
   K1olt2PeqMMkQL+fGaRPQlg68n0/N6HcL2zF+98rlWCkbr6yyxBo9bFQT
   X3i31IFUyGL4W19DRluwRhsKt9hvRA8DCEYBprXKGAHz7TDGSYhNjARjg
   A==;
X-CSE-ConnectionGUID: NYnLrOy7S82/PVSlAJtoRA==
X-CSE-MsgGUID: ZoGQk7VhThixyOC3WxXH/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4101319"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="4101319"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 20:44:22 -0800
X-CSE-ConnectionGUID: H3ytyTdhTSWu5lchEfXTeQ==
X-CSE-MsgGUID: QpvzWzgNR6iJN9JsRdkisQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="11037850"
Received: from unknown (HELO [10.238.1.144]) ([10.238.1.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 20:44:14 -0800
Message-ID: <2e8a853f-9e7b-4cce-b578-2dac0c564eb5@linux.intel.com>
Date: Fri, 20 Nov 2026 12:44:10 +0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Alex Williamson <alex@shazbot.org>,
 Alexey Kardashevskiy <aik@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Krishna Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Nicolin Chen <nicolinc@nvidia.com>, Robin Murphy <robin.murphy@arm.com>,
 Samuel Ortiz <sameo@rivosinc.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Steven Price <steven.price@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, iommu@lists.linux.dev,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 09/13] iommufd/viommu: Select vIOMMU operations before
 allocation
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-10-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261116081935.85372-10-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
> Physical IOMMU drivers currently provide the vIOMMU size and
> initialization callbacks through iommu_ops. The initialization callback
> then selects and installs the corresponding iommufd_viommu_ops.
> 
> Add iommu_ops::get_viommu_ops() to select the operations from the
> physical device and requested vIOMMU type before allocation. Move the
> size and initialization callbacks into iommufd_viommu_ops. The core can
> then validate the selected operations, allocate the driver structure,
> initialize it, and install the operations.
> 
> Convert AMD, Arm SMMUv3, Tegra CMDQV, and the selftest backend to the
> new interface.
> 
> The current code requires a valid parent HWPT before calling
> viommu_init(), which selects the vIOMMU operations. A later patch adds
> an operations flag indicating that a vIOMMU type does not require a
> parent HWPT. Selecting the operations earlier allows the core to check
> that flag before deciding whether to look up and validate a parent HWPT.
> 
> Temporarily disable AMD vIOMMU allocation by returning NULL from
> amd_iommufd_get_viommu_ops() while the vIOMMU interfaces are being
> updated.
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Vasant Hegde <vasant.hegde@amd.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Thierry Reding <thierry.reding@kernel.org>
> Cc: Krishna Reddy <vdumpa@nvidia.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-tegra@vger.kernel.org
> Cc: iommu@lists.linux.dev
> Based on original patch by Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   drivers/iommu/amd/iommu.c                     |  3 +-
>   drivers/iommu/amd/iommufd.c                   | 18 ++++++---
>   drivers/iommu/amd/iommufd.h                   | 11 ++++--
>   drivers/iommu/amd/nested.c                    |  4 +-
>   .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 37 +++++++++++--------
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  7 ++--
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 16 ++++----
>   .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 24 ++++++++----
>   drivers/iommu/iommufd/selftest.c              | 31 +++++++++++-----
>   drivers/iommu/iommufd/viommu.c                | 32 ++++++++--------
>   include/linux/iommu.h                         | 20 +++-------
>   include/linux/iommufd.h                       | 14 +++++++
>   12 files changed, 129 insertions(+), 88 deletions(-)
> 

[...]

> diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
> index 0d162a3fdc98..2eba1562a704 100644
> --- a/drivers/iommu/iommufd/viommu.c
> +++ b/drivers/iommu/iommufd/viommu.c
> @@ -33,7 +33,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
>   	struct iommufd_viommu *viommu;
>   	struct iommufd_device *idev;
>   	struct iommu_device *iommu_dev;
> -	const struct iommu_ops *ops;
> +	const struct iommufd_viommu_ops *ops;
>   	size_t viommu_size;
>   	int rc;
>   
> @@ -49,23 +49,25 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
>   		rc = -EOPNOTSUPP;
>   		goto out_put_idev;
>   	}
> -	ops = iommu_dev->ops;
> -	if (!ops->get_viommu_size || !ops->viommu_init) {
> +	if (!iommu_dev->ops->get_viommu_ops) {
>   		rc = -EOPNOTSUPP;
>   		goto out_put_idev;
>   	}
> -
> -	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
> -	if (!viommu_size) {
> +	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
> +	if (!ops) {
>   		rc = -EOPNOTSUPP;
>   		goto out_put_idev;
>   	}
> -
>   	/*
> -	 * It is a driver bug for providing a viommu_size smaller than the core
> -	 * vIOMMU structure size
> +	 * It is a driver bug to omit the required operations or provide a size
> +	 * smaller than the core vIOMMU structure.
>   	 */
> -	if (WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
> +	if (WARN_ON_ONCE(!ops->get_viommu_size || !ops->viommu_init)) {
> +		rc = -EOPNOTSUPP;
> +		goto out_put_idev;
> +	}
> +	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
> +	if (!viommu_size || WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
>   		rc = -EOPNOTSUPP;
>   		goto out_put_idev;
>   	}
> @@ -104,16 +106,12 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
>   	 */
>   	viommu->iommu_dev = iommu_dev;
>   
> -	rc = ops->viommu_init(viommu, hwpt_paging->common.domain,
> +	rc = ops->viommu_init(viommu, idev->dev,
> +			      hwpt_paging->common.domain,
>   			      user_data.len ? &user_data : NULL);
>   	if (rc)
>   		goto out_put_hwpt;
> -
> -	/* It is a driver bug that viommu->ops isn't filled */
> -	if (WARN_ON_ONCE(!viommu->ops)) {
> -		rc = -EOPNOTSUPP;
> -		goto out_put_hwpt;
> -	}
> +	viommu->ops = ops;
>   
>   	cmd->out_viommu_id = viommu->obj.id;
>   	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ef5043752a36..f27064917df7 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -46,6 +46,7 @@ struct iommu_dma_msi_cookie;
>   struct iommu_fault_param;
>   struct iommufd_ctx;
>   struct iommufd_viommu;
> +struct iommufd_viommu_ops;
>   struct msi_desc;
>   struct msi_msg;
>   
> @@ -669,16 +670,8 @@ __iommu_copy_struct_to_user(const struct iommu_user_data *dst_data,
>    *		- IOMMU_DOMAIN_DMA: must use a dma domain
>    *		- 0: use the default setting
>    * @default_domain_ops: the default ops for domains
> - * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
> - *                   @dev corresponding to @viommu_type. Driver should return 0
> - *                   if vIOMMU isn't supported accordingly. It is required for
> - *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
> - *                   driver-level vIOMMU structure related to the core one
> - * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
> - *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
> - *               resources shared/passed to user space IOMMU instance. Associate
> - *               it with a nesting @parent_domain. It is required for driver to
> - *               set @viommu->ops pointing to its own viommu_ops
> + * @get_viommu_ops: Return the vIOMMU operations supported by @dev for a type.
> + *                  Return NULL if the type is unsupported.
>    * @owner: Driver module providing these ops
>    * @identity_domain: An always available, always attachable identity
>    *                   translation.
> @@ -729,11 +722,8 @@ struct iommu_ops {
>   
>   	int (*def_domain_type)(struct device *dev);
>   
> -	size_t (*get_viommu_size)(struct device *dev,
> -				  enum iommu_viommu_type viommu_type);
> -	int (*viommu_init)(struct iommufd_viommu *viommu,
> -			   struct iommu_domain *parent_domain,
> -			   const struct iommu_user_data *user_data);
> +	const struct iommufd_viommu_ops *(*get_viommu_ops)(
> +		struct device *dev, enum iommu_viommu_type viommu_type);
>   
>   	const struct iommu_domain_ops *default_domain_ops;
>   	struct module *owner;
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index d1fd7888fc91..5f5c67b24134 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -148,6 +148,15 @@ struct iommufd_hw_queue {
>   
>   /**
>    * struct iommufd_viommu_ops - vIOMMU specific operations
> + * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
> + *                   @dev corresponding to @viommu_type. Driver should return 0
> + *                   if vIOMMU isn't supported accordingly. It is required for
> + *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
> + *                   driver-level vIOMMU structure related to the core one
> + * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
> + *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
> + *               resources shared/passed to user space IOMMU instance. Associate
> + *               it with a nesting @parent_domain.
>    * @destroy: Clean up all driver-specific parts of an iommufd_viommu. The memory
>    *           of the vIOMMU will be free-ed by iommufd core after calling this op
>    * @alloc_domain_nested: Allocate a IOMMU_DOMAIN_NESTED on a vIOMMU that holds a
> @@ -190,6 +199,11 @@ struct iommufd_hw_queue {
>    *                      does, it should set it to the @hw_queue->destroy pointer
>    */
>   struct iommufd_viommu_ops {
> +	size_t (*get_viommu_size)(struct device *dev,
> +		enum iommu_viommu_type type);
> +	int (*viommu_init)(struct iommufd_viommu *viommu, struct device *dev,
> +		struct iommu_domain *parent_domain,
> +		const struct iommu_user_data *user_data);
>   	void (*destroy)(struct iommufd_viommu *viommu);
>   	struct iommu_domain *(*alloc_domain_nested)(
>   		struct iommufd_viommu *viommu, u32 flags,

For changes in iommufd/viommu common code,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

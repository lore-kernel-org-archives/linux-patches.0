Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3293FBF0;
	Wed, 12 Nov 2025 06:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762927381; cv=none; b=dsQKFxzKzhgJX2RVqhJRmf6lMdlICQ81PvvDYOpk5xukekclIAMGXkVH9tAiKMT25FebwxQOH+/23NsSs84pQZdJBNgsnZKYVFe/YzGKRrXyUrg17GEC3lQaAyQuUkdISuGJHd0QzfYLCWx5Bxq1yCgvYj7huYJIlM33B4LF2V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762927381; c=relaxed/simple;
	bh=5P785U/6nIR5hmheHhi3SEIcKPyZPlJEhzUt1w6Lq7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajKyxrgt9da24UKzjVk8FNTyZbFhm7qhho7YCsug5mnT9XXpsqlByNfK2HqovRy2dKqQsaqUJdKxe3lUydCAvhgg5tghoLwhTaq8GOs2FMc+m+oJ0ZZ/fUHZo486p+OGw6dFGgVbrhYn9RxfbQPX0+ep4UokeBg0OJGG8e+18Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFcMwVhH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFcMwVhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762927379; x=1794463379;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5P785U/6nIR5hmheHhi3SEIcKPyZPlJEhzUt1w6Lq7I=;
  b=oFcMwVhHKBIgYjEBlDIzQxuUfbluayiPAldPXMm211ntr4UMFdk5mz6q
   PnVyXllorQkc7Pml2jAejxJuTiDne7Lqx64bCQctRJ1MCBNM09uiQseUy
   t1MX8LO7ModSXpWIAovaSfXjGJD6D9gIEq5XSAeUPESqt6j4wOgTQ7OBd
   NrPAWXyoDq9JXu2g4KkxNq80vMgqcoVEdTVwO63WnwcpscEAl5SprrpIy
   tKZodCx9zpslZ5vCSky+hQt6NqoeqJ8uaFzapQbfoRyGdrZXrM4RCUTPn
   RysTKAZ5ToYq8XDJVQoWAbNiiQzRO24E/CCwA0n/pkINx6on4PlupC5iQ
   A==;
X-CSE-ConnectionGUID: S1NmX6Q5R5mSnF1W8Higwg==
X-CSE-MsgGUID: lENJRYjDSrCWxsXbCjl86Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64920255"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64920255"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:02:59 -0800
X-CSE-ConnectionGUID: h2IRcZemTGuOgw+Cz+mqmA==
X-CSE-MsgGUID: SUtSziV9Qu6Uwss2XMdTJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189864807"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:02:55 -0800
Message-ID: <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
Date: Wed, 12 Nov 2025 13:58:51 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, afael@kernel.org,
 bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org,
 etzhao1900@gmail.com
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/25 13:12, Nicolin Chen wrote:
> There is a need to stage a resetting PCI device to temporally the blocked
> domain and then attach back to its previously attached domain after reset.
> 
> This can be simply done by keeping the "previously attached domain" in the
> iommu_group->domain pointer while adding an iommu_group->resetting_domain,
> which gives troubles to IOMMU drivers using the iommu_get_domain_for_dev()
> for a device's physical domain in order to program IOMMU hardware.
> 
> And in such for-driver use cases, the iommu_group->mutex must be held, so
> it doesn't fit in external callers that don't hold the iommu_group->mutex.
> 
> Introduce a new iommu_driver_get_domain_for_dev() helper, exclusively for
> driver use cases that hold the iommu_group->mutex, to separate from those
> external use cases.
> 
> Add a lockdep_assert_not_held to the existing iommu_get_domain_for_dev()
> and highlight that in a kdoc.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>   include/linux/iommu.h                       |  1 +
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  5 ++--
>   drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
>   3 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 801b2bd9e8d49..a42a2d1d7a0b7 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -910,6 +910,7 @@ extern int iommu_attach_device(struct iommu_domain *domain,
>   extern void iommu_detach_device(struct iommu_domain *domain,
>   				struct device *dev);
>   extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
> +struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev);
>   extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>   extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
>   		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index a33fbd12a0dd9..412d1a9b31275 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3125,7 +3125,8 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
>   		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
>   		       struct arm_smmu_cd *cd, struct iommu_domain *old)
>   {
> -	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
> +	struct iommu_domain *sid_domain =
> +		iommu_driver_get_domain_for_dev(master->dev);
>   	struct arm_smmu_attach_state state = {
>   		.master = master,
>   		.ssid = pasid,
> @@ -3191,7 +3192,7 @@ static int arm_smmu_blocking_set_dev_pasid(struct iommu_domain *new_domain,
>   	 */
>   	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
>   		struct iommu_domain *sid_domain =
> -			iommu_get_domain_for_dev(master->dev);
> +			iommu_driver_get_domain_for_dev(master->dev);
>   
>   		if (sid_domain->type == IOMMU_DOMAIN_IDENTITY ||
>   		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 1e322f87b1710..1f4d6ca0937bc 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2217,6 +2217,15 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
>   }
>   EXPORT_SYMBOL_GPL(iommu_detach_device);
>   
> +/**
> + * iommu_get_domain_for_dev() - Return the DMA API domain pointer
> + * @dev - Device to query
> + *
> + * This function can be called within a driver bound to dev. The returned
> + * pointer is valid for the lifetime of the bound driver.
> + *
> + * It should not be called by drivers with driver_managed_dma = true.

"driver_managed_dma != true" means the driver will use the default
domain allocated by the iommu core during iommu probe. The iommu core
ensures that this domain stored at group->domain will not be changed
during the driver's whole lifecycle. That's reasonable.

How about making some code to enforce this requirement? Something like
below ...

> + */
>   struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
>   {
>   	/* Caller must be a probed driver on dev */
> @@ -2225,10 +2234,29 @@ struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
>   	if (!group)
>   		return NULL;
>   
> +	lockdep_assert_not_held(&group->mutex);

...
	if (WARN_ON(!dev->driver || !group->owner_cnt || group->owner))
		return NULL;

> +
>   	return group->domain;
>   }
>   EXPORT_SYMBOL_GPL(iommu_get_domain_for_dev);
>   
> +/**
> + * iommu_driver_get_domain_for_dev() - Return the driver-level domain pointer
> + * @dev - Device to query
> + *
> + * This function can be called by an iommu driver that wants to get the physical
> + * domain within an iommu callback function where group->mutex is held.
> + */
> +struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +
> +	lockdep_assert_held(&group->mutex);
> +
> +	return group->domain;
> +}
> +EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
> +
>   /*
>    * For IOMMU_DOMAIN_DMA implementations which already provide their own
>    * guarantees that the group and its default domain are valid and correct.

Others look good to me.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4383947B0;
	Mon, 30 Mar 2026 06:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774852876; cv=none; b=iFel+vfkg9MADYTibC+Coo5EMs+L0QWxJW71ehkyUwBhMXgXz+c5/9X0kelPClLCUe/vkYhIsRXOLfIw9Q/Tf6Eb6MIhkL6q4eZ2rS/6YzBJr/heHfYDz9i11GpjNmbyuP5wozLlDeNxOvIIQk3l5c/74bfpUV5BxkYMOFIuqJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774852876; c=relaxed/simple;
	bh=4HjDnyV3MTzNJNe15FYvHBKZZrbpySX7xBDMA55ZHfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OzOY7G7aixMiSTx9X/f+3ViYeBjP6yQkNzjXqemjY4YaLWm60sYj1iNpUPS4IHgE4cngbHGRSS2vdl4GVqSbc7mzovaBJFRECmicY+GfENrVEpSEkCKp0qgJ/v9oX5f4l3o0nrg2gQVn457icSST713JyIE959KAWVfLLPS8jMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FuO+23zW; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FuO+23zW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774852875; x=1806388875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4HjDnyV3MTzNJNe15FYvHBKZZrbpySX7xBDMA55ZHfo=;
  b=FuO+23zW3yqov6R8G2VZ7kghpC7KGl6JBDs5WsdawHIMgShRAKajLHIG
   CyLGtrW9u5NEwmLwTtj/sBSvgpHo+mgM+zRbk+vfGZ5tEHt8S++rxl6f2
   cVJaZXsVF+KrkqBUDhXlGdAoG9kkSfsKO9QWKs66vdh/wGYJm4awWxUUe
   dUPX2b9gU/zcRX5IKkvicjAe9vkeK0kB/ZSpIfLsPlkaq86WO/yVJFV8k
   FJ2WzN1kUhoGBeJpLqpHPXEUgTnlt7cH3+7pqVedhTa+jQTIlvbd//4oM
   ZT5yRb6V5bqjnYLJOy1jT6PbFHh8mgonmEWWcS3zrWjfgXG1bP97fM+5T
   A==;
X-CSE-ConnectionGUID: tg76RRqmQfShjkqwOx6fWQ==
X-CSE-MsgGUID: W9QxE3YSTjOXncqajqd/oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="86530540"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="86530540"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 23:41:14 -0700
X-CSE-ConnectionGUID: zmJ2iy+OSVKRplDMHanOxg==
X-CSE-MsgGUID: Ta3uCVHFR0KftB9XhEH2uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="230766920"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 23:41:12 -0700
Message-ID: <ef82f6be-fecf-469b-9df0-88a7a004923a@linux.intel.com>
Date: Mon, 30 Mar 2026 14:39:50 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/intel: Split piotlb invalidation into range and
 all
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <1-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/26 23:25, Jason Gunthorpe wrote:
> Currently these call chains are muddled up by using npages=-1, but
> only one caller has the possibility to do both options.
> 
> Simplify qi_flush_piotlb() to qi_flush_piotlb_all() since all
> callers pass npages=-1.
> 
> Split qi_batch_add_piotlb() into qi_batch_add_piotlb_all() and
> related helpers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/intel/cache.c | 20 +++++++++++++-------
>   drivers/iommu/intel/dmar.c  | 19 ++++---------------
>   drivers/iommu/intel/iommu.h | 37 ++++++++++++++++++-------------------
>   drivers/iommu/intel/pasid.c |  6 +++---
>   drivers/iommu/intel/prq.c   |  2 +-
>   5 files changed, 39 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
> index 249ab5886c739f..e08253980a6ee7 100644
> --- a/drivers/iommu/intel/cache.c
> +++ b/drivers/iommu/intel/cache.c
> @@ -330,15 +330,17 @@ static void qi_batch_add_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid
>   	qi_batch_increment_index(iommu, batch);
>   }
>   
> +static void qi_batch_add_piotlb_all(struct intel_iommu *iommu, u16 did,
> +				     u32 pasid, struct qi_batch *batch)
> +{
> +	qi_desc_piotlb_all(did, pasid, &batch->descs[batch->index]);
> +	qi_batch_increment_index(iommu, batch);
> +}
> +
>   static void qi_batch_add_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid,
>   				u64 addr, unsigned long npages, bool ih,
>   				struct qi_batch *batch)
>   {
> -	/*
> -	 * npages == -1 means a PASID-selective invalidation, otherwise,
> -	 * a positive value for Page-selective-within-PASID invalidation.
> -	 * 0 is not a valid input.
> -	 */
>   	if (!npages)
>   		return;

The WARN_ON(!npages) logic is removed from the previous
qi_flush_piotlb() (see below ...). Could it be added here to keep the
"npages != 0" check?

>   
> @@ -378,8 +380,12 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
>   	u64 type = DMA_TLB_PSI_FLUSH;
>   
>   	if (intel_domain_use_piotlb(domain)) {
> -		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid, addr,
> -				    pages, ih, domain->qi_batch);
> +		if (pages == -1)
> +			qi_batch_add_piotlb_all(iommu, tag->domain_id,
> +						tag->pasid, domain->qi_batch);
> +		else
> +			qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid,
> +					    addr, pages, ih, domain->qi_batch);
>   		return;
>   	}
>   
> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index 69222dbd2af0ea..6f496fc6a5ff1a 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -1550,23 +1550,12 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
>   	qi_submit_sync(iommu, &desc, 1, 0);
>   }
>   
> -/* PASID-based IOTLB invalidation */
> -void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
> -		     unsigned long npages, bool ih)
> +/* PASID-selective IOTLB invalidation */
> +void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid)
>   {
> -	struct qi_desc desc = {.qw2 = 0, .qw3 = 0};
> +	struct qi_desc desc = {};
>   
> -	/*
> -	 * npages == -1 means a PASID-selective invalidation, otherwise,
> -	 * a positive value for Page-selective-within-PASID invalidation.
> -	 * 0 is not a valid input.
> -	 */
> -	if (WARN_ON(!npages)) {
> -		pr_err("Invalid input npages = %ld\n", npages);
> -		return;
> -	}
> -
> -	qi_desc_piotlb(did, pasid, addr, npages, ih, &desc);
> +	qi_desc_piotlb_all(did, pasid, &desc);
>   	qi_submit_sync(iommu, &desc, 1, 0);
>   }
>   
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 599913fb65d59e..40759587729953 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -1082,31 +1082,29 @@ static inline void qi_desc_dev_iotlb(u16 sid, u16 pfsid, u16 qdep, u64 addr,
>   	desc->qw3 = 0;
>   }
>   
> +/* PASID-selective IOTLB invalidation */
> +static inline void qi_desc_piotlb_all(u16 did, u32 pasid, struct qi_desc *desc)
> +{
> +	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
> +		    QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) | QI_EIOTLB_TYPE;
> +	desc->qw1 = 0;
> +}
> +
> +/* Page-selective-within-PASID IOTLB invalidation */
>   static inline void qi_desc_piotlb(u16 did, u32 pasid, u64 addr,
>   				  unsigned long npages, bool ih,
>   				  struct qi_desc *desc)
>   {
> -	if (npages == -1) {
> -		desc->qw0 = QI_EIOTLB_PASID(pasid) |
> -				QI_EIOTLB_DID(did) |
> -				QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
> -				QI_EIOTLB_TYPE;
> -		desc->qw1 = 0;
> -	} else {
> -		int mask = ilog2(__roundup_pow_of_two(npages));
> -		unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
> +	int mask = ilog2(__roundup_pow_of_two(npages));
> +	unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
>   
> -		if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
> -			addr = ALIGN_DOWN(addr, align);
> +	if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
> +		addr = ALIGN_DOWN(addr, align);
>   
> -		desc->qw0 = QI_EIOTLB_PASID(pasid) |
> -				QI_EIOTLB_DID(did) |
> -				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
> -				QI_EIOTLB_TYPE;
> -		desc->qw1 = QI_EIOTLB_ADDR(addr) |
> -				QI_EIOTLB_IH(ih) |
> -				QI_EIOTLB_AM(mask);
> -	}
> +	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
> +		    QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) | QI_EIOTLB_TYPE;
> +	desc->qw1 = QI_EIOTLB_ADDR(addr) | QI_EIOTLB_IH(ih) |
> +		    QI_EIOTLB_AM(mask);
>   }
>   
>   static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
> @@ -1168,6 +1166,7 @@ void qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
>   void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
>   			u16 qdep, u64 addr, unsigned mask);
>   
> +void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);

[...]

>   void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
>   		     unsigned long npages, bool ih);

qi_flush_piotlb() has been removed by this patch. Therefore above
declaration should also be cleaned.

>   
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 9d30015b894057..89541b74ab8ca3 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -282,7 +282,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
>   	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
>   
>   	if (pgtt == PASID_ENTRY_PGTT_PT || pgtt == PASID_ENTRY_PGTT_FL_ONLY)
> -		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
> +		qi_flush_piotlb_all(iommu, did, pasid);
>   	else
>   		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
>   
> @@ -308,7 +308,7 @@ static void pasid_flush_caches(struct intel_iommu *iommu,
>   
>   	if (cap_caching_mode(iommu->cap)) {
>   		pasid_cache_invalidation_with_pasid(iommu, did, pasid);
> -		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
> +		qi_flush_piotlb_all(iommu, did, pasid);
>   	} else {
>   		iommu_flush_write_buffer(iommu);
>   	}
> @@ -342,7 +342,7 @@ static void intel_pasid_flush_present(struct intel_iommu *iommu,
>   	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
>   	 */
>   	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
> -	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
> +	qi_flush_piotlb_all(iommu, did, pasid);
>   
>   	devtlb_invalidation_with_pasid(iommu, dev, pasid);
>   }
> diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
> index ff63c228e6e19d..ed98b1cb06fecf 100644
> --- a/drivers/iommu/intel/prq.c
> +++ b/drivers/iommu/intel/prq.c
> @@ -113,7 +113,7 @@ void intel_iommu_drain_pasid_prq(struct device *dev, u32 pasid)
>   		qi_desc_dev_iotlb(sid, info->pfsid, info->ats_qdep, 0,
>   				  MAX_AGAW_PFN_WIDTH, &desc[2]);
>   	} else {
> -		qi_desc_piotlb(did, pasid, 0, -1, 0, &desc[1]);
> +		qi_desc_piotlb_all(did, pasid, &desc[1]);
>   		qi_desc_dev_iotlb_pasid(sid, info->pfsid, pasid, info->ats_qdep,
>   					0, MAX_AGAW_PFN_WIDTH, &desc[2]);
>   	}

Others look good to me. Thanks for the patch.

Thanks,
baolu

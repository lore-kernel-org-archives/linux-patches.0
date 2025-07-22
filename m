Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0FD1922ED;
	Tue, 22 Jul 2025 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753166770; cv=none; b=pxd8Jz2YQ9Ehpf6E+JWgemFJ0TDAjXEehqmYILYUap7yxnDrw3to/ydxE87kF5hRjhwNffXmABAfYSehVqwM18v+mPx83m4h2+25+ndLd8Yd12N8dyWPUkG2862y0AhVqiC6OH4tWj2hA1VIZBQgu3W+lDaDSJAylopB3eek+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753166770; c=relaxed/simple;
	bh=3mTTJObDtexFHWh1hVvddrHKb/Rf8dunMzDPUoi0i0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ad0P3mCLy0WexzJUMKOznjCy4F/LO2J2gCeAcHYRBMbbaMEjklLGXoNhf2tVPafE2IjwRnbo8hv0e5+PZe3sVqcb1dYdEVnhIDvN7dQpy4bkcFdiw3zRrp6uE2nPgbEXINoH1fYA0PXxcBVuqmlTGH8afL8jMyTYhJBAV8xY9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7a9R8IW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7a9R8IW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753166767; x=1784702767;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3mTTJObDtexFHWh1hVvddrHKb/Rf8dunMzDPUoi0i0U=;
  b=k7a9R8IWiHk29DBio3PZVSuEZxXNaT/MOtbBXH+/i3BjBb4zFs0270g5
   e6LXKxc8kbnBDqsp6WmJ/hWuwGLPVywTlrzufG5vRnXX2wPmojaKrHFUv
   KFzQzLJUERcrDkl8a8nc5lDim0TCymKWxHPxvPjr49miKdser/LxHyH1L
   Se5m23ajaR2XDfRBRNnCRb83EYfEJoM6qN9x5GUx0A7WKAqxyUHCHgjRN
   WfwO1gd4u6OXtptnZJbORNZhhwYmuT/FTGAst59u2z+Qli572B3lALrI5
   KAnHUJI17l/JPJViq+cqa186rxMgkKBH5XwWIPXaz9g0U7NPCLONpHCPh
   w==;
X-CSE-ConnectionGUID: 5yYMimKMTGmE1MVkUvaxAg==
X-CSE-MsgGUID: 2egEKe+RQuOIyLFLsdWshQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="72971196"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="72971196"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:46:07 -0700
X-CSE-ConnectionGUID: I39hvSTZT2+10vJG4x9UDA==
X-CSE-MsgGUID: BUf5TGATT0a7jD2nYx6EDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="196121862"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:46:04 -0700
Message-ID: <e46aeb10-b596-4bb7-8f52-638a07bdbc6f@linux.intel.com>
Date: Tue, 22 Jul 2025 14:44:01 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 03:57, Jason Gunthorpe wrote:
> Replace the VT-D iommu_domain implementation of the VTD second stage and
> first stage page tables with the iommupt VTDSS and x86_64
> pagetables. x86_64 is shared with the AMD driver.
> 
> There are a couple notable things in VT-D:
> - Like AMD the second stage format is not sign extended, unlike AMD it
>    cannot decode a full 64 bits. The first stage format is a normal sign
>    extended x86 page table
> - The HW caps can indicate how many levels, how many address bits and what
>    leaf page sizes are supported in HW. As before the highest number of
>    levels that can translate the entire supported address width is used.
>    The supported page sizes are adjusted directly from the dedicated
>    first/second stage cap bits.
> - VTD requires flushing 'write buffers'. This logic is left unchanged,
>    the write buffer flushes on any gather flush or through iotlb_sync_map.
> - Like ARM, VTD has an optional non-coherent page table walker that
>    requires cache flushing. This is supported through PT_FEAT_DMA_INCOHERENT
>    the same as ARM, however x86 can't use the DMA API for flush, it must
>    call the arch function clflush_cache_range()
> - The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday for the
>    second stage when it uses 128 bit atomic stores for the HW context
>    structures.
> - PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around ERRATA_772415_SPR17
> - A kernel command line parameter "sp_off" disables all page sizes except 4k
> 
> Remove all the unused iommu_domain page table code. The debufs paths have
> their own independent page table walker that is left alone for now.
> 
> This corrects a race with the non-coherent walker that the ARM
> implementations have fixed:
> 
>       CPU 0                               CPU 1
>    pfn_to_dma_pte()                    pfn_to_dma_pte()
>     pte = &parent[offset];
>     if (!dma_pte_present(pte)) {
>       try_cmpxchg64(&pte->val)
> 					pte = &parent[offset];
> 					.. dma_pte_present(pte) ..
> 				        [...]
> 					// iommu_map() completes
> 					// Device does DMA
>       domain_flush_cache(pte)
> 
> The CPU 1 mapping operation shares a page table level with the CPU 0
> mapping operation. CPU 0 installed a new page table level but has not
> flushed it yet. CPU1 returns from iommu_map() and the device does DMA. The
> non coherent walker fails to see the new table level installed by CPU 0
> and fails the DMA with non-present.
> 
> The iommupt PT_FEAT_DMA_INCOHERENT implementation uses the ARM design of
> storing a flag when CPU 0 completes the flush. If the flag is not set CPU
> 1 will also flush to ensure the HW can fully walk to the PTE being
> installed.
> 
> Cc: Tina Zhang <tina.zhang@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/intel/Kconfig  |   4 +
>   drivers/iommu/intel/iommu.c  | 903 ++++++-----------------------------
>   drivers/iommu/intel/iommu.h  |  99 +---
>   drivers/iommu/intel/nested.c |   5 -
>   drivers/iommu/intel/pasid.c  |  29 +-
>   5 files changed, 182 insertions(+), 858 deletions(-)
> 

[...]

> @@ -3338,7 +2805,9 @@ static struct iommu_domain *
>   intel_iommu_domain_alloc_first_stage(struct device *dev,
>   				     struct intel_iommu *iommu, u32 flags)
>   {
> +	struct pt_iommu_x86_64_cfg cfg = {};
>   	struct dmar_domain *dmar_domain;
> +	int ret;
>   
>   	if (flags & ~IOMMU_HWPT_ALLOC_PASID)
>   		return ERR_PTR(-EOPNOTSUPP);
> @@ -3347,19 +2816,72 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
>   	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
> -	dmar_domain = paging_domain_alloc(dev, true);
> +	dmar_domain = paging_domain_alloc();
>   	if (IS_ERR(dmar_domain))
>   		return ERR_CAST(dmar_domain);
>   
> +	if (cap_fl5lp_support(iommu->cap))
> +		cfg.common.hw_max_vasz_lg2 = 57;
> +	else
> +		cfg.common.hw_max_vasz_lg2 = 48;
> +	cfg.common.hw_max_oasz_lg2 = 52;
> +	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
> +			      BIT(PT_FEAT_FLUSH_RANGE);
> +	/* First stage always uses scalable mode */
> +	if (WARN_ON(!ecap_smpwc(iommu->ecap)))
> +		return ERR_PTR(-EINVAL);

I don't follow here. Why WARN_ON and return failure when hardware
doesn't support a feature?

> +	if (ecap_smpwc(iommu->ecap))
> +		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);

My understanding is that if hardware possibly walks the page table
incoherently, we need to set up the PT_FEAT_DMA_INCOHERENT feature;
otherwise, there is no need.

If that's correct, perhaps what we need here is:

	if (!ecap_smpwc(iommu->ecap))
		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);

The Intel iommu driver always enforces page walk coherence in the PASID
table entry if the capability is supported.

> +	dmar_domain->iommu.iommu_device = dev;
> +	dmar_domain->iommu.nid = dev_to_node(dev);
>   	dmar_domain->domain.ops = &intel_fs_paging_domain_ops;
> +
> +	ret = pt_iommu_x86_64_init(&dmar_domain->fspt, &cfg, GFP_KERNEL);
> +	if (ret) {
> +		kfree(dmar_domain);
> +		return ERR_PTR(ret);
> +	}
> +
> +	if (!cap_fl1gp_support(iommu->cap))
> +		dmar_domain->domain.pgsize_bitmap &= ~(u64)SZ_1G;
> +	if (!intel_iommu_superpage)
> +		dmar_domain->domain.pgsize_bitmap = SZ_4K;
> +
>   	return &dmar_domain->domain;
>   }

[...]

>   static struct iommu_domain *
>   intel_iommu_domain_alloc_second_stage(struct device *dev,
>   				      struct intel_iommu *iommu, u32 flags)
>   {
> +	struct pt_iommu_vtdss_cfg cfg = {};
>   	struct dmar_domain *dmar_domain;
> +	unsigned int sslps;
> +	int ret;
>   
>   	if (flags &
>   	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> @@ -3376,15 +2898,48 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
>   	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
> -	dmar_domain = paging_domain_alloc(dev, false);
> +	dmar_domain = paging_domain_alloc();
>   	if (IS_ERR(dmar_domain))
>   		return ERR_CAST(dmar_domain);
>   
> +	cfg.common.hw_max_vasz_lg2 = compute_vasz_lg2_ss(iommu);
> +	cfg.common.hw_max_oasz_lg2 = 52;
> +	cfg.common.features = BIT(PT_FEAT_FLUSH_RANGE);
> +
> +	/*
> +	 * Read-only mapping is disallowed on the domain which serves as the
> +	 * parent in a nested configuration, due to HW errata
> +	 * (ERRATA_772415_SPR17)
> +	 */
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
> +		cfg.common.features |= BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE);
> +
> +	if (WARN_ON(!iommu_paging_structure_coherency(iommu)))
> +		return ERR_PTR(-EINVAL);
> +	if (!iommu_paging_structure_coherency(iommu))
> +		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);

Similarly here.

> +	dmar_domain->iommu.iommu_device = dev;
> +	dmar_domain->iommu.nid = dev_to_node(dev);

Thanks,
baolu

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DA39C016;
	Mon, 30 Mar 2026 07:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854765; cv=none; b=b/4fxRT/wBH9tOT/+lvB+3qc47QvGPcsP2qK6FecNHGNNh7u0Dt0XZsfi1iLTFdMkpEoiDoX4XvdQ+CjhhaiLI9W0emZV60QEJPKvRq7Z0EJc28Rou+LacHYvNZOILLrXU/kl0kcHz99iNon3zBYVcZBrFUWNH7af7CvJfLtR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854765; c=relaxed/simple;
	bh=I1d2RB1gDSz0e3EcVP4sVWvytWmay7FRINv2m6cCnCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhVji9JzNQdLGrt5j6W8b175WmiVb58X86+sUX93SXHy773fgRLqSebbpPzKru7FyYLPCmPHQ6sihCTAr2TT78blZuFx7FAmJ401ihenaMw8Hr6mFyVPJjVI3sGFjCJfE0B2W58ii+C2qi7HE5AGx9fH5mLFXwRs0TBgbNf+QR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fgFLPDnk; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fgFLPDnk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774854764; x=1806390764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I1d2RB1gDSz0e3EcVP4sVWvytWmay7FRINv2m6cCnCI=;
  b=fgFLPDnkLoiNvI+aGlnOznv7RyM37JILffEjseK7jdsqpnjjUOSe8xFE
   S+jZHBF1gvk8gf19I2Kb2BV98yilFIEN3i5isv4KP9Wpma9il4CeK8+Tx
   AXBj9Fowta4m5zLDRNGkf51iwOwqAoOiAB7s0jNu3TQiz4MttYwUl0QwX
   wb8k9uFFFvBfp1fq9kvk7rP7xMxhj48b/OSmz8UZW0DwteC2HfN33D/ii
   cwy+obEkTgRzWIH0pENhl6uNylFN/gW51trDiGrTiyPL6IybudAeIMK2c
   +immef8CUpzXOZARd5FIJsAtqrqcUGrQ+vB9oKDtqzDL709cUJUekOwjR
   g==;
X-CSE-ConnectionGUID: s28AaA6ISzOkbkOIJ7j9yw==
X-CSE-MsgGUID: C1rqSAz8Qc2vPqMyaLZGIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="79441321"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="79441321"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 00:12:43 -0700
X-CSE-ConnectionGUID: 6X3tG9B8TFKt/aEUnfkuPQ==
X-CSE-MsgGUID: 3Cex4zdrQpOZVEHy1pkbUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="249162425"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 00:12:39 -0700
Message-ID: <dd8038b7-ecf6-45c5-973e-3e1798c0a453@linux.intel.com>
Date: Mon, 30 Mar 2026 15:11:17 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] iommu/vtd: Pass size_order to qi_desc_piotlb() not
 npages
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <2-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/26 23:25, Jason Gunthorpe wrote:
> It doesn't make sense for the caller to compute mask, throw it away
> and then have qi_desc_piotlb() compute it again.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/intel/cache.c | 10 ++++------
>   drivers/iommu/intel/iommu.h | 16 ++++++----------
>   2 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
> index e08253980a6ee7..74ee2002fb9c85 100644
> --- a/drivers/iommu/intel/cache.c
> +++ b/drivers/iommu/intel/cache.c
> @@ -338,13 +338,11 @@ static void qi_batch_add_piotlb_all(struct intel_iommu *iommu, u16 did,
>   }
>   
>   static void qi_batch_add_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid,
> -				u64 addr, unsigned long npages, bool ih,
> +				u64 addr, unsigned int size_order, bool ih,
>   				struct qi_batch *batch)
>   {
> -	if (!npages)
> -		return;
> -
> -	qi_desc_piotlb(did, pasid, addr, npages, ih, &batch->descs[batch->index]);
> +	qi_desc_piotlb(did, pasid, addr, size_order, ih,
> +		       &batch->descs[batch->index]);
>   	qi_batch_increment_index(iommu, batch);
>   }
>   
> @@ -385,7 +383,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
>   						tag->pasid, domain->qi_batch);
>   		else
>   			qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid,
> -					    addr, pages, ih, domain->qi_batch);
> +					    addr, mask, ih, domain->qi_batch);
>   		return;
>   	}
>   
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 40759587729953..7a92472985ee02 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -1092,19 +1092,16 @@ static inline void qi_desc_piotlb_all(u16 did, u32 pasid, struct qi_desc *desc)
>   
>   /* Page-selective-within-PASID IOTLB invalidation */
>   static inline void qi_desc_piotlb(u16 did, u32 pasid, u64 addr,
> -				  unsigned long npages, bool ih,
> +				  unsigned int size_order, bool ih,
>   				  struct qi_desc *desc)
>   {
> -	int mask = ilog2(__roundup_pow_of_two(npages));
> -	unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
> -
> -	if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
> -		addr = ALIGN_DOWN(addr, align);
> -
> +	/*
> +	 * calculate_psi_aligned_address() must be used for addr and size_order
> +	 */
>   	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
>   		    QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) | QI_EIOTLB_TYPE;
>   	desc->qw1 = QI_EIOTLB_ADDR(addr) | QI_EIOTLB_IH(ih) |
> -		    QI_EIOTLB_AM(mask);
> +		    QI_EIOTLB_AM(size_order);
>   }
>   
>   static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
> @@ -1167,8 +1164,7 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
>   			u16 qdep, u64 addr, unsigned mask);
>   
>   void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);
> -void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
> -		     unsigned long npages, bool ih);
> +

Could we move this cleanup to the previous patch?

Otherwise, looks good to me.

>   void qi_flush_dev_iotlb_pasid(struct intel_iommu *iommu, u16 sid, u16 pfsid,
>   			      u32 pasid, u16 qdep, u64 addr,

Thanks,
baolu

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E514F9D9;
	Fri, 15 Nov 2024 03:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731640812; cv=none; b=tB2XaJP7s7DMmJXD1Rgln3tINfQLIwJbb5UJ5SgU68+48HmBQ+in5YcXUPhlkwgWNiXbgFKNkimeb2UMu31+jBrE4YD4dfTRFYU4TrUb0BMwX1x31sHW3wy+rrPqWc2t6XoGpGaQ3V7FO7Ehdp8kfbC8c1lakSAxJosgdOTkheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731640812; c=relaxed/simple;
	bh=EmmauIawg383LKUBt/6r/yNcNhvgcVIZnj39fkNbIv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOT1O6woK1Iz/JSBPz7/fuKGvCbc3daCOeCi0MabUXNWrymwvU9pAtmZhng7iSjmCX0XTK0rnrNxcg2IO8974DfiUM0cOPr3cdjzRSCqpC9t3KGZitaXzWGQq9/jKEj1WEUZ2D8XiDVymWd0fNSSodoKPGw5dKVHrCkuzuiyU2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KuxVc71l; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KuxVc71l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731640810; x=1763176810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EmmauIawg383LKUBt/6r/yNcNhvgcVIZnj39fkNbIv8=;
  b=KuxVc71lgwa9ezoyad055MKb3YyGlWYEquLOLRgqGX1TEdUqbW6li4jo
   9KgQjr1HuQNDapOyyaYGXe/zLaKNGpPhl5zM30NrgvuVCcp68/cky77R2
   FiDboKBNdJ0t0NTJYAjHJwc1C7kc5vvKPJSrHDNztdduuFphGcbYkQxFE
   HiZng8GHHN8jxEZQZ/RWDt0EsbteLCbDXWZVAzQaviMQvjF65uliGt9JU
   60d+R9ua/SBppB688Xgog3Qw5G514h8r69BXPdP3IPAGOrRapX43Z0bIx
   i5ZrZZLOU/kIlkovkyF+r9coYDOqAHowiI4dhdCxzYJ5fJ1eyaeUcchxv
   A==;
X-CSE-ConnectionGUID: u8qSZTZCSyufpL8TeZYZWg==
X-CSE-MsgGUID: rEhCG+2RQdWNL+K0WQHLhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="43014889"
X-IronPort-AV: E=Sophos;i="6.12,155,1728975600"; 
   d="scan'208";a="43014889"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 19:20:09 -0800
X-CSE-ConnectionGUID: AtpwSsV+RnaGl0XhBl2YSw==
X-CSE-MsgGUID: J2He9sEdRqWy3hAuDWdm3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,155,1728975600"; 
   d="scan'208";a="89166020"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 19:20:07 -0800
Message-ID: <9c065d9d-ec97-4d3c-a2af-0dd4fe40ad5a@linux.intel.com>
Date: Fri, 15 Nov 2024 11:19:03 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Add ops->domain_alloc_nested()
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <1-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 03:55, Jason Gunthorpe wrote:
> It turns out all the drivers that are using this immediately call into
> another function, so just make that function directly into the op. This
> makes paging=NULL for domain_alloc_user and we can remove the argument in
> the next patch.
> 
> The function mirrors the similar op in the viommu that allocates a nested
> domain on top of the viommu's nesting parent. This version supports cases
> where a viommu is not being used.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c          |  9 +++------
>   drivers/iommu/intel/iommu.h          |  6 ++++--
>   drivers/iommu/intel/nested.c         | 11 +++++++++--
>   drivers/iommu/iommufd/hw_pagetable.c |  8 ++++----
>   drivers/iommu/iommufd/selftest.c     |  7 ++++---
>   include/linux/iommu.h                |  9 +++++----
>   6 files changed, 29 insertions(+), 21 deletions(-)
>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

with below minor suggestion.

[...]

> diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
> index 42c4533a6ea21d..aba92c00b42740 100644
> --- a/drivers/iommu/intel/nested.c
> +++ b/drivers/iommu/intel/nested.c
> @@ -186,14 +186,21 @@ static const struct iommu_domain_ops intel_nested_domain_ops = {
>   	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
>   };
>   
> -struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
> -					       const struct iommu_user_data *user_data)
> +struct iommu_domain *
> +intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
> +				u32 flags,
> +				const struct iommu_user_data *user_data)
>   {
> +	struct device_domain_info *info = dev_iommu_priv_get(dev);
>   	struct dmar_domain *s2_domain = to_dmar_domain(parent);
> +	struct intel_iommu *iommu = info->iommu;
>   	struct iommu_hwpt_vtd_s1 vtd;
>   	struct dmar_domain *domain;
>   	int ret;
>   
> +	if (!nested_supported(iommu) || flags)
> +		return ERR_PTR(-EOPNOTSUPP);

How about making it like

         if (!nested_supported(iommu) || (flags & 
~IOMMU_HWPT_FAULT_ID_VALID))
                 return ERR_PTR(-EOPNOTSUPP);

         if ((flags & IOMMU_HWPT_FAULT_ID_VALID) && !info->pri_supported)
                 return ERR_PTR(-EOPNOTSUPP);

?

--
baolu

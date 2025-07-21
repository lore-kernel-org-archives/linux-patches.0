Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D688DF4F1;
	Mon, 21 Jul 2025 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753087270; cv=none; b=M9APmh0zaPCu9KBfkF8z/X7Z5QI0TdzTnsFs+hz++RiswBY9rD4hsvj6OJ/XGfvxBT4cgnaTh6hEBqtdZw9YRHVmpPcjOdq9fVFnOAAdk5BwY2ndTtQ1OCsTLtjR+twkuiVud3RCRc6YOP09kZaX+4xuRQ4lZdHA7Fbo8JlYyoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753087270; c=relaxed/simple;
	bh=yhdbVoA6G31ypH6Hzi6F5nyXwF6JKWxD59x9aU/23yQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=H50rXk9kPk0UO2Vw/iiAhbHtdMm+IQ4mwG0AtQzD81K7DqOqXvBZrnDZgzBP1+AP83JP0Tr7sASqrRN6FpXVU4fYgHGAMhlZq0olQOxw387plke3DNyuTaohc5mFOrqYmqS5duwh1ltyJPXFjTkQ0JasO9j0ADs/lXi7bS0qV8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZe9bg/Z; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZe9bg/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753087269; x=1784623269;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yhdbVoA6G31ypH6Hzi6F5nyXwF6JKWxD59x9aU/23yQ=;
  b=jZe9bg/ZqlH9OHFrzzgs5U+ph+WgT5nE6tSqoU37L6exyH3pTZbfBtvu
   gJPZ2S1sIg/d4v/KHBmx24fDCwn1u7AV0YZ0Uyo5HYcfnwGMhd+Rhc7/Z
   Nzv+Ad9NrnIAUjK/5LuYvQUwoyV8K5SYZ2noADgathHrEFXdL8z5MTSs+
   ZgQg3KfpDuarVOMnxY8iyWd+wMEa/5bFI28Z4oObuhOV7u1ZxABuswl8B
   MF2tBgbLe2kkZcQ+NxbostNB6EfKOGnzFaonsRmywW4W6k9oB0kMlYMTz
   ho1A7IvHcOvbKr3aitr0rDXp90qjC37uTb2NSLvV01YrDNNH50h4v/mwl
   w==;
X-CSE-ConnectionGUID: +JjfrUoQTfGQbCy/wgJn9A==
X-CSE-MsgGUID: UiBaHK44Sf6UCzupSrf7KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11498"; a="57913004"
X-IronPort-AV: E=Sophos;i="6.16,328,1744095600"; 
   d="scan'208";a="57913004"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 01:41:08 -0700
X-CSE-ConnectionGUID: 97xDEV/xRtqM92QXpat5Vw==
X-CSE-MsgGUID: 9S7HUu/dTS66MGiBOC0w7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,328,1744095600"; 
   d="scan'208";a="162819795"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.243.252]) ([10.124.243.252])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 01:41:06 -0700
Message-ID: <00c5972b-a5d9-4604-aea6-cc0d8e2601a0@linux.intel.com>
Date: Mon, 21 Jul 2025 16:41:03 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/2025 3:57 AM, Jason Gunthorpe wrote:
> @@ -98,4 +101,36 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
>   	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
>   }
>   
> -#endif	/* __IOMMU_PAGES_H */
> +int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
> +int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
> +                                      struct device *dma_dev);
> +
> +#ifdef CONFIG_X86
> +#include <asm/cacheflush.h>
> +
> +static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
> +						void *virt, size_t offset,
> +						size_t len)
> +{
> +	clflush_cache_range(virt + offset, len);
> +}
> +static inline void
> +iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
> +				 struct device *dma_dev)
> +{

Do we need to clear iopt->incoherent for X86, given that
iopt->incoherent is set in the start path? If no need, can you please
add a comment to explain it?

> +}
> +#else
> +#include <linux/dma-mapping.h>
> +
> +static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
> +						void *virt, size_t offset,
> +						size_t len)
> +{
> +	dma_sync_single_for_device(dma_dev, (uintptr_t)virt + offset, len,
> +				   DMA_TO_DEVICE);
> +}
> +void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
> +                                      struct device *dma_dev);
> +#endif
> +
> +#endif /* __IOMMU_PAGES_H */

Thanks,
baolu

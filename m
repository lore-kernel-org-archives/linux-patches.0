Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32C42CCC9;
	Wed, 11 Jun 2025 04:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749617466; cv=none; b=SnrADV+kSb8aGDVkxQjqE66STcBw+oc+JLvy6BJoKIJM6BP7uyhRSTT3lHE6kk1y4zPnvAr3GvHI2y3ODsxhq5rvcK2Jo2jG8ajSIg7P6jWHOD7+SfcbR2xSfPiTChpRkvLLx1LlqDBdAEv1TIgLgEHqXxKJhBM5Zsj8Sl8ndgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749617466; c=relaxed/simple;
	bh=tQJqHS9D3oD2yrr4hr6rV32IS13ZgiCeQMLhGvBLfyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4TE5/e6EH3kAAytMBS6Cl0nFzDGgh07GBpR5YTNT+Ek0A81vK3FsWAc9Ywu20C0OV1PLoI4DxibWreAHfRg26FCI5wjiNdlyNtMpcldo7TJzKsUncHt68eAzJ/soBDtLUOH1nagrmgNjI/hGYRO/Z/P7ewZDhLOoVfpJ7YwuSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uo4eb20j; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uo4eb20j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749617464; x=1781153464;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tQJqHS9D3oD2yrr4hr6rV32IS13ZgiCeQMLhGvBLfyg=;
  b=Uo4eb20jEkgTWw4c56tjnZzzHHd0Mw6FqopQ1Rp2Oa24l2AfjICGlsSy
   w7FNzR1P1Mw3w069Gsm6twVJtQ/aP4xysurQdIm4NMTiXwZUluvEjrrbY
   VYetmi9PYMaPg6k9hUMOeokOfqhbkWHFDyxBY4qNS/QMwVjNwZxit4H38
   xK6DNlBL2qLZbwotzFJAj222tFVjRPjYnKYLEX+qYIkhUrYnWlvTJN3g0
   CTBtZsvb4H0UO6lsIXaAy/lUr6kkGttHwsjE6VzCYZbo8AVkDb3y3w85B
   TXbKLkXnwmpJITSAZRBI0ScktUum6J01VyvRUykLWWAnmZ1wsy/fEAboC
   w==;
X-CSE-ConnectionGUID: 9Xi8S9YhQQeLLQeDr0ezHw==
X-CSE-MsgGUID: oAM9rYVxTSyzWKN7rBCiBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51884971"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51884971"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 21:51:04 -0700
X-CSE-ConnectionGUID: EazqtwJTQnKI3qJRQ2vXxw==
X-CSE-MsgGUID: VijVnaRzRU2eFOQvmbJeog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="170236807"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 21:51:02 -0700
Message-ID: <da8a6938-c45f-4923-af52-1a34702f1b0a@linux.intel.com>
Date: Wed, 11 Jun 2025 12:50:11 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, patches@lists.linux.dev,
 Wei Wang <wei.w.wang@intel.com>
References: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
 <20250610235125.GP543171@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250610235125.GP543171@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 07:51, Jason Gunthorpe wrote:
> On Tue, Jun 10, 2025 at 03:12:43PM +0800, Baolu Lu wrote:
>>> +	/*
>>> +	 * FIXME this is locked wrong, it needs to be under the
>>> +	 * dmar_domain->lock
>>> +	 */
>>>    	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>>>    		return -EINVAL;
>>
>> Perhaps we can use group->mutex to fix this in the future?
> 
> It is part of the iommu_domain, there is no clear group->mutex that
> is affiliated with a domain, there can be multiple devices attached..

Fair enough.

> Maybe we should change the enforce coherency away from a function op
> and into a domain creation flag. Then it won't change at run time,
> fixing this race, and we don't have the issue of possibly having PTEs
> with the wrong bit already mapped into the domain.

That's a better approach. enforce_cache_coherency is only used in vfio
and iommufd, where the cache coherency is enforced just after the domain
is allocated.

> When this was first done that was harder, but now I think we have
> enough infrastructure to do it easily..

Yes. I can follow up with a patch series for broad discussion if you
don't want to include it in this series.

Thanks,
baolu

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD818CC1C;
	Wed, 30 Jul 2025 01:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753840288; cv=none; b=St1RWBLQIdgpHnc3Xv87O4nGHzW7bBib/209pS1mEqVC9rDPf+WWQBD1rgHm8M4uqAaIPMT/Zr4Oj1ul9+tHgcEnWO1e/nT2iB+xt/54GCghk/qVHg2yrhaIonDM46naRNZWb4T3/7TEvuOuhs9zWoWacMa3+3EfdTEROso87oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753840288; c=relaxed/simple;
	bh=chE0nrptDiMGRwfHI6m+QULdM9SQGcKdEzKcM0LjWr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuaXlN5/K4fltbz+Fognmgvii93gdceUqRWelMcRItuRZ4TAQiB4JWRaYGTam2zv1johH4sztoTI++KS/LHWaI9LZNJ0vWbGwRzlRqxDYW8gtWd17kYD9kL3t73TZZRoI9OXHtUs2tHIWhHUAMFLiDCGdN4XqRhlid0gmcNTPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S/VNYNJ6; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/VNYNJ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753840287; x=1785376287;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=chE0nrptDiMGRwfHI6m+QULdM9SQGcKdEzKcM0LjWr4=;
  b=S/VNYNJ6dT5yf4IyeDqVUwWuZvOXJcfhCqn06QX7NkPVd3Ekt8sY+ZyY
   +mS2M2dRMkSn1ZkDCwC3aRJbmaFNxOH7NY6rNqOrO5wqy1S2VFbHaN29A
   aTVjvBQPpllReco806i5N6QXrzWMS2hjI2sRav8gIRLWcM1WUp9tpcXoF
   5t7EQm78Irw3ppUST8O+zzLw5R8fzt+dDj39kD25JSaHhXYDk6c5jUuD6
   yF8lH7CAf8VMkzYzpH1CfosewmRKknUMSJebO//MYRukhOjxCvKkiTo7l
   owA/8y61jMdi3ur3tIC5VZdkhHDS9Maw+aFbmsQAvBfTzLC37hGyMJSH1
   Q==;
X-CSE-ConnectionGUID: /bLnr92QT16m6UWGflRlZQ==
X-CSE-MsgGUID: ADseGT4CRA2pOIJTucNaMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="66828996"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="66828996"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 18:51:26 -0700
X-CSE-ConnectionGUID: CpwUweFlQACPdurvCHXT4g==
X-CSE-MsgGUID: Yigpge2UTX+ybyzDipC/ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167110844"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 18:51:23 -0700
Message-ID: <e94c33e4-7ef3-4777-aa28-852f4a013580@linux.intel.com>
Date: Wed, 30 Jul 2025 09:49:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <00c5972b-a5d9-4604-aea6-cc0d8e2601a0@linux.intel.com>
 <20250729223240.GC82395@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250729223240.GC82395@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 06:32, Jason Gunthorpe wrote:
> On Mon, Jul 21, 2025 at 04:41:03PM +0800, Baolu Lu wrote:
>> On 7/17/2025 3:57 AM, Jason Gunthorpe wrote:
>>> @@ -98,4 +101,36 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
>>>    	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
>>>    }
>>> -#endif	/* __IOMMU_PAGES_H */
>>> +int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
>>> +int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
>>> +                                      struct device *dma_dev);
>>> +
>>> +#ifdef CONFIG_X86
>>> +#include <asm/cacheflush.h>
>>> +
>>> +static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
>>> +						void *virt, size_t offset,
>>> +						size_t len)
>>> +{
>>> +	clflush_cache_range(virt + offset, len);
>>> +}
>>> +static inline void
>>> +iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
>>> +				 struct device *dma_dev)
>>> +{
>> Do we need to clear iopt->incoherent for X86, given that
>> iopt->incoherent is set in the start path?
> No.. When I wrote this I felt we may as well keep x86 fast since it
> doesn't use the DMA API and did it like this:
> 
> static void __iommu_free_desc(struct ioptdesc *iopt)
> {
> [..]
> 	if (!IS_ENABLED(CONFIG_X86))
> 		WARN_ON_ONCE(iopt->incoherent);
> 
> To largely ignore the incoherent flag.
> 
> So:
> 
> 	/*
> 	 * For performance leave the incoherent flag alone which turns this into
> 	 * a NOP. For X86 the rest of the stop/free flow ignores the flag.
> 	 */

Okay.

I was just thinking about that: this field overlays struct page, so it
makes more sense to clear it before repurposing it. It's fine as long as
there's no functionality issue.

Thanks,
baolu

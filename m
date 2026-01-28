Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969FF156236;
	Wed, 28 Jan 2026 06:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769580554; cv=none; b=sPsvu/IUw6VNRrP10KNeOALhcB/BDwTox0ZziaRD86REDFOTHVAKrAXk8Jn77TGyh7IPoGNswgUy0/760s+IqrzxgYr6Xu+s05XNxJLS7pUmj/l1hJbOw7Xte7eUPMIZ4z9/C4QG2Pm8neg+vv28loUmJILfKhKkA4onR/xZXpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769580554; c=relaxed/simple;
	bh=s/okfIUZSLkkp0Oiwe2WaXA9B0yTq5rYfKf2znL3eUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mdzrcEW3Mt3yWeRuBy22hjxY6WrgEeoGxaz+fwv+G7ft5XtJWSGX7mQoEolsim9FrnwoEll2SS9tZzF70iKIPJdLcEeVOv/THeNTpXzdyfkCazZaj/VFDV/LAY3I2OFTdA/iocK/aZprDlqPLZOoS/WCQJ3VaBaseJknrtae3B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YyzBYcBH; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyzBYcBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769580553; x=1801116553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s/okfIUZSLkkp0Oiwe2WaXA9B0yTq5rYfKf2znL3eUo=;
  b=YyzBYcBHperEKP72NjPxbBfY+rjTpwPgRr09jv5RwFHCMWvYA71un33e
   Ww2aRXuKlWIcmlOHu1RV7M7raHEAO9QyURdlMk2xI26ke1sj70kmgs93I
   +lLII/C7dLO0DjDS0ajeIGMokFu6KG7FPI/HsekbNVNXQavZC/qL1nbwK
   FBZ72YlHqRtZ+6sfEISp8kaP2eVnOR7HUOIDN0uhRvTDEd06G4hbZqGfT
   mRYSwyT8/vZoxC9CeKr9k6JOjx6zud90P7kysdE6yd8CKs8pgc6/X/Yh6
   i7PSjttrcXw4Qwt8JdNJECFN17WE++WQ9DcH0RrXrPpUCxlx8SNGZJiQ9
   A==;
X-CSE-ConnectionGUID: Su2jdGGhQ+yKWU5FfUd70A==
X-CSE-MsgGUID: v4o01gnARuOCs7wmn1YigA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70829596"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70829596"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:09:12 -0800
X-CSE-ConnectionGUID: fyQ2ql9CTGO8LwO3DdF25A==
X-CSE-MsgGUID: tNXscwK2QjaBAS+o+mt2Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208249072"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:09:09 -0800
Message-ID: <daf9e672-15c0-4726-9f2c-47f5018b126f@linux.intel.com>
Date: Wed, 28 Jan 2026 14:08:51 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommupt: Only cache flush memory changed by unmap
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Matthew Brost <matthew.brost@intel.com>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/25/26 05:00, Jason Gunthorpe wrote:
> The cache flush was happening on every level across the whole range of
> iteration, even if no leafs or tables were cleared. Instead flush only the
> sub range that was actually written.
> 
> Overflushing isn't a correctness problem but it does impact the
> performance of unmap.
> 
> After this series the performance compared to the original VT-d
> implementation with cache flushing turned on is:
> 
> map_pages
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,    253,266   ,     213,227     ,   6.06
>       2^21,    246,244   ,     221,219     ,   0.00
>       2^30,    231,240   ,     209,217     ,   3.03
>   256*2^12,   2604,2668  ,    2415,2540    ,   4.04
>   256*2^21,   2495,2824  ,    2390,2734    ,  12.12
>   256*2^30,   2542,2845  ,    2380,2718    ,  12.12
> 
> unmap_pages
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,    259,292   ,     222,251     ,  11.11
>       2^21,    255,259   ,     227,236     ,   3.03
>       2^30,    238,254   ,     217,230     ,   5.05
>   256*2^12,   2751,2620  ,    2417,2437    ,   0.00
>   256*2^21,   2461,2526  ,    2377,2423    ,   1.01
>   256*2^30,   2498,2543  ,    2370,2404    ,   1.01
> 
> Fixes: efa03dab7ce4 ("iommupt: Flush the CPU cache after any writes to the page table")
> Reported-by: Francois Dugast<francois.dugast@intel.com>
> Closes:https://lore.kernel.org/all/20260121130233.257428-1- 
> francois.dugast@intel.com/
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/iommu_pt.h | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)

Thanks for fixing this.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

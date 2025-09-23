Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A7B111A8;
	Tue, 23 Sep 2025 02:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758594748; cv=none; b=Nf5fGrEWquHvruKoDwYOF8Lsmn9U90CZiQ6RIKkmncvwEQXPB7Got6MFO/ZPVYMdcqUUenl5BcGkFCg/R86l5HZKiiGGjgQQ+uty6smERWP0iclyBtAGBP3Anci0nx/7DJDcGqgjQqZsegLLE2+LH8Xw/xtbOnwa2G3XZYGzW9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758594748; c=relaxed/simple;
	bh=AfaN8+MdlqEi2NIL3FGawBocJ1A092PgoSxv0CvMzEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KoqR72jJWhbLjUC/Mk7nNrHcP6Bh6ZmmK6zKKqhKlELXRggnRDP4QGtXkNftMJvBWxxn/Sm133tIhQjlWv/bo03SyLtIOauhSe9xLxCoFyf5tsESeOsteOSeu0SQmw64WQaAnk4o89Ic251JV+5WxNfuUHcJQyCB6mUKEhdwUpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EdgMLqCr; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EdgMLqCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758594746; x=1790130746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AfaN8+MdlqEi2NIL3FGawBocJ1A092PgoSxv0CvMzEo=;
  b=EdgMLqCr3sF4m88Oz9+WbCloW/VOzSCKxKWZfL6+hMbw+PmX6m1QGpfT
   nCsvG+pDtrHuz32Q+3/sYKx77m/eQPq3J7VY7npSG0obnr8uBU4XIRBtD
   YIpqmuH+3LsBdwOwg2sl5p7nR/Lo0fAx15ECi+w4RC7rBnrcF/T5DPKeO
   LT4AZ8psmW16Z3bEISlGjIPTYgGlJGUmP2NOHhNAt8R7qBhQ4QzwIQSQa
   43CU7jY9aBzzmtLjUD/4txghmMmSuQKbEgQ5MsrORz1n6VhOviYEztFyy
   zp02XozlrveJ6Zn0SESsSWfhMhQ89U+W6ll+r5bS44jvTxf7hgU3y3GX8
   Q==;
X-CSE-ConnectionGUID: lbOpGbRtQKOkrMtiI90F6g==
X-CSE-MsgGUID: 37wA0RHATvmiwUsM2NXlMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71489288"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="71489288"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:32:24 -0700
X-CSE-ConnectionGUID: JvGrshjPTimKhPU5K8JEow==
X-CSE-MsgGUID: CSM4AF1rT9+wT9SBqqo6cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="175772412"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:32:22 -0700
Message-ID: <ba1ab9cc-327c-45ff-9982-5d11551060c3@linux.intel.com>
Date: Tue, 23 Sep 2025 10:29:21 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to
 the page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <00a3fff5-bf1e-461b-9673-14725e3cd6e4@linux.intel.com>
 <20250922144447.GB1391379@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250922144447.GB1391379@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 22:44, Jason Gunthorpe wrote:
> On Mon, Sep 22, 2025 at 10:31:49AM +0800, Baolu Lu wrote:
>> On 8/27/25 01:26, Jason Gunthorpe wrote:
>>> @@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
>>>    			return -EADDRINUSE;
>>>    		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
>>>    				      &map->attrs);
>>> +		/* No flush, not used when incoherent */
>>>    		map->oa += PAGE_SIZE;
>>>    		return 0;
>>>    	}
>>> @@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
>>>    	PT_WARN_ON(map.leaf_level > range.top_level);
>>>    	do {
>>> -		if (single_page) {
>>> +		if (single_page &&
>>> +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
>>>    			ret = pt_walk_range(&range, __map_single_page, &map);
>>>    			if (ret != -EAGAIN)
>>>    				break;
>> I don't follow the single_page logic here. Why is single_page exclusive
>> with PT_FEAT_DMA_INCOHERENT? To my understanding, PT_FEAT_DMA_INCOHERENT
>> has no relationship with how the page table is organized. Could you
>> elaborate a bit?
> It is this comment above:
> 
>                  /* No flush, not used when incoherent */
> 
> __do_map_single_page() doesn't implement the coherency logic. As an
> agressive inline I didn't want to bloat it.

But, is that functionally correct, though? In the incoherent case, even
if a leaf page entry is changed, the cache should be flushed so that the
hardware can see the change. Basically, I don't understand why
__do_map_single_page() is "not used when incoherent". I must have
overlooked something. :-)

Thanks,
baolu

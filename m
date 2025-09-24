Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAD32A1CA;
	Wed, 24 Sep 2025 03:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758683324; cv=none; b=bpHImioR46X64FC4bS1RyNRITbOrYbvf7UJEl0aJCHjhb7DhF1Gmb+GA9rkWRdEOBAwK8r5dRmzaCLG3V3xQwoh6uf06Tb2MQ19SYVTYLmbTqaEDx8bVm8l3dEjYeNW0oNeamY68xAMbZQppEjWiVb9xG+/tASAmZWvJyUuCHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758683324; c=relaxed/simple;
	bh=yhZLYAHHV96NOzvStX/hljZZw4EmPiKHqqmmGE16iZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRyvqH88yfrGwND7Jw6kMLnH5qodJdD+iDI8W6vdBZEXdsqpxSYsB4g2gy5gfsTi+ix3qpFDP9HZXRL6r3rU/zTBP8uGmrun+pfj80InJWjyb6mahoDadKuwJOX7TbE7W5fntU50lfycHCxHBZYsPf+k7e1HrhDCxY6kks16e1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MsjsKbWr; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MsjsKbWr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758683323; x=1790219323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yhZLYAHHV96NOzvStX/hljZZw4EmPiKHqqmmGE16iZY=;
  b=MsjsKbWrwq7u9B26dP9Gx3hxpVk7T3oNgL+v1xS7SHQSZFRPqK/qC/LD
   a3JlaroJqr5CNfCizj00UPnZ1Sa6p2JnZ/oc42ucfu49l5l7gkmxxEiMd
   HJKXLvD+uyASdnYBt0Bp5KuG9dJFn7f5YBX0FsOndVgHX8EFHi5YMEWu0
   7IJatjjSoQxrtUNXnlRmD5roBRkELJ+Zpq1nnzmpw3y6ADUTOxNvVvETd
   C3+7e3kiCAR2+feBnoz4SAEm4grZTELujAXCJ/s2/7/u34JVNFqiKegXF
   iy9K542+GbMQvM3OPBQWE3jp+EnNIAsOEg5XqYlEXmDRj0SGGE8axnJ4b
   A==;
X-CSE-ConnectionGUID: EN8pHCA2R6KLChO1UceLbw==
X-CSE-MsgGUID: NRUzQwM6SRKPB9oGtOmtOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="86414485"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="86414485"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 20:08:42 -0700
X-CSE-ConnectionGUID: 7axq7ugcS9eJDaFjOAmZww==
X-CSE-MsgGUID: Pa1NQKhNQ8Ct8TrIcVAk0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="207670601"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 20:08:39 -0700
Message-ID: <13fe8484-c010-44ad-ba9a-a742da791f03@linux.intel.com>
Date: Wed, 24 Sep 2025 11:05:36 +0800
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
 <ba1ab9cc-327c-45ff-9982-5d11551060c3@linux.intel.com>
 <20250923141340.GO1391379@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250923141340.GO1391379@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/25 22:13, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 10:29:21AM +0800, Baolu Lu wrote:
>> On 9/22/25 22:44, Jason Gunthorpe wrote:
>>> On Mon, Sep 22, 2025 at 10:31:49AM +0800, Baolu Lu wrote:
>>>> On 8/27/25 01:26, Jason Gunthorpe wrote:
>>>>> @@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
>>>>>     			return -EADDRINUSE;
>>>>>     		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
>>>>>     				      &map->attrs);
>>>>> +		/* No flush, not used when incoherent */
>>>>>     		map->oa += PAGE_SIZE;
>>>>>     		return 0;
>>>>>     	}
>>>>> @@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
>>>>>     	PT_WARN_ON(map.leaf_level > range.top_level);
>>>>>     	do {
>>>>> -		if (single_page) {
>>>>> +		if (single_page &&
>>>>> +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
>>>>>     			ret = pt_walk_range(&range, __map_single_page, &map);
>>>>>     			if (ret != -EAGAIN)
>>>>>     				break;
>>>> I don't follow the single_page logic here. Why is single_page exclusive
>>>> with PT_FEAT_DMA_INCOHERENT? To my understanding, PT_FEAT_DMA_INCOHERENT
>>>> has no relationship with how the page table is organized. Could you
>>>> elaborate a bit?
>>> It is this comment above:
>>>
>>>                   /* No flush, not used when incoherent */
>>>
>>> __do_map_single_page() doesn't implement the coherency logic. As an
>>> agressive inline I didn't want to bloat it.
>> But, is that functionally correct, though?
> It is functionally correct because it is never called on incoherent
> configurations 🙂
> 
>> In the incoherent case, even
>> if a leaf page entry is changed, the cache should be flushed so that the
>> hardware can see the change.
> Yes, and since the code doesn't do this it isn't called in that case
> otherwise it is a functional problem.
> 
>> Basically, I don't understand why
>> __do_map_single_page() is "not used when incoherent". I must have
>> overlooked something. 🙂
> Basically it is an optimization and we disable the optimization on
> incoherent. It is disabled because implementing the flushing would
> bloat the code undesirably.

Oh, I see! __do_map_single_page() is actually a fast path. We disabled
this fast path for the incoherent case due to the cache flushing
behavior. Thanks for the explanation.

Thanks,
baolu

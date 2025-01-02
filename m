Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BECB652;
	Thu,  2 Jan 2025 03:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735787647; cv=none; b=npCu5A9zupEYOUgz51ANFsPfs2/1VkOqz/4sXgPTChaSlNo6SelGzPTQB1NvYV8fdvxrU/UJ9YV3/FmveT/eJXcy+HzS4Mv4XtfGlkyc2USDhYwhO3+1Ze764KZIUQS52W+lCCyaGG+5vW8uQUmDLtGjyTukJwulD4wh96doK+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735787647; c=relaxed/simple;
	bh=Zc/lf1jUAiyMQr8+O7GXo0HmCQyW0r3Y4Xm16kBfNCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjlEgEIpLv/EIYwWlrM9Fz6cMe9ob/Sz52YoXcUsHPJLhNa5A2/sw0y3zyB2XneBiMBsYuDPvycWqRWTJAhz05ESsGBaVoBxlgLAcBa5yAo73yrZX+ymBU9rqk1chRVOHCa4EJZqeeQTdn/rv1a5qiZSF7M8CI71gcn5yZeKTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YcDdDvHm; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YcDdDvHm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735787646; x=1767323646;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zc/lf1jUAiyMQr8+O7GXo0HmCQyW0r3Y4Xm16kBfNCg=;
  b=YcDdDvHmDclOPwX/y1mUFz43qkeODI9ArLMQ30KK3kxh6U/MwDgkrFqE
   XzsaZ5B2m2qy3pfsSrMnv2UBQNqHNkQnQJLmcGcUl52eL5zaeLink6bfU
   NBGq0fYoOWu275TFeo/s4xhHpDHmO1nvioUTnv8FWE+yDYdnrhx+mgVTR
   aYMNEFWUwaMN5kloh3e31ATEPzNoo8XT+EW76xKNOUbA/CajxWWGEfiJO
   r6YZmDjmjQZIxz2Md5r9TBQvAefKduD6pKzkW8vz6IDEGnYVSmGNeWSo8
   A0r4ASbbYyVTtCvzTQDRdRPnheLdiZOt2HZhXRhGuaNfqzX3bx3b3ghst
   w==;
X-CSE-ConnectionGUID: 3l5ly/JHRVWxHYdEBpsDNQ==
X-CSE-MsgGUID: CvO4Fn/XTI+XQk8SOtS++A==
X-IronPort-AV: E=McAfee;i="6700,10204,11302"; a="35326976"
X-IronPort-AV: E=Sophos;i="6.12,284,1728975600"; 
   d="scan'208";a="35326976"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2025 19:14:05 -0800
X-CSE-ConnectionGUID: bP78EZaSSreieNNJM2aPwA==
X-CSE-MsgGUID: UAOGeQ96S+iwRZT9lPiKLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,284,1728975600"; 
   d="scan'208";a="101884029"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2025 19:14:03 -0800
Message-ID: <c2d29b55-127a-4b0e-9153-58c494fbc14f@linux.intel.com>
Date: Thu, 2 Jan 2025 11:12:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/vt-d: Remove domain_alloc_paging()
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/24 04:14, Jason Gunthorpe wrote:
> This is duplicated by intel_iommu_domain_alloc_paging_flags(), just remove
> it.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 16 ----------------
>   1 file changed, 16 deletions(-)

Queued for v6.14. Thanks!

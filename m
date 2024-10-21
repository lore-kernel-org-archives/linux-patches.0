Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2744C171CD;
	Mon, 21 Oct 2024 05:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729487949; cv=none; b=MfolWO0d0u2M+zjKxuIPoHGmeLKRfxUGViVIacPSw7e3RdfAit54bzYZo6pk4qSGxnS7qPdbvbW2J2JvrKSLB1+1pAqLIuoYaAPgv1Hh7qsa0TdUOE/Ni0QVXri0+GC609cYdIhzygMp4HiwH8QRAKmjo7LVCl8y1EdPLRzys0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729487949; c=relaxed/simple;
	bh=/+0TmvQgn9hMWa5pa22v9YMtPWzMD7iF4wenTuwsu2s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mo4HgKG3e9AzJzrDrv2KOfXAULBR1/SLISaVqLFZV3OZ9vKxOKlLc9/jmbib7bq9TR5nvDjHtVKvI8g0CKUpzFdJ+5o9maGqB6xbp+sUx5Lfa6b7DHbgLlfXVdu5V2ehQ084kT3J7xyMJcLgk58Pxj0PWEM0QFcBha3dElKV3nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZ1ZsPFO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZ1ZsPFO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729487948; x=1761023948;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/+0TmvQgn9hMWa5pa22v9YMtPWzMD7iF4wenTuwsu2s=;
  b=iZ1ZsPFO56Y3VpLkNN+nvDBRcZKXdzuOADSYe1qC7C/fBZpqPzYGoqBT
   Ec1SCL7w4g7PFiB5k7QyOCdIHy3PVnEC3qo2dyIYmd8h9pZAQepCE6nht
   bHFwsVOas4aoQAfR9RTQ/enxqYDI18C8aGavGI9gAytmwmDqqVLwbtC+9
   jS1PcPnZlOvCFPC+aULFayv5urYGkI4uG7rDWRlSADteuiszhUNIPH3ws
   +Y01SXICQ11tqOqIVzqNSZy5CWPjMB7IAo+5aqTdG+h2C38bfQZwzepE9
   IwgViSthPxKb5mNGYIe/H0qOosZfMjbnyzG5deUkH9bvkwdeW9WYSD8ky
   Q==;
X-CSE-ConnectionGUID: 2Chw+mimTR2xsO4o2ap63Q==
X-CSE-MsgGUID: /2Ep/UavR4i5KOQf2e2eMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46421613"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46421613"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:19:07 -0700
X-CSE-ConnectionGUID: 59m5WRKWTZSv0IQo5A617g==
X-CSE-MsgGUID: YExLnss2TSWat4KLRqfaUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,219,1725346800"; 
   d="scan'208";a="79350544"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:19:05 -0700
Message-ID: <9892d0e6-554b-4c15-b012-813edc3e0427@linux.intel.com>
Date: Mon, 21 Oct 2024 13:19:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Remove useless flush from
 iommu_create_device_direct_mappings()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
References: <0-v1-bb6c694e1b07+a29e1-iommu_no_flush_all_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-bb6c694e1b07+a29e1-iommu_no_flush_all_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/19 1:01, Jason Gunthorpe wrote:
> These days iommu_map() does not require external flushing, it always
> internally handles any required flushes. Since
> iommu_create_device_direct_mappings() only calls iommu_map(), remove
> the extra call.
> 
> Since this is the last call site for iommu_flush_iotlb_all() remove it
> too.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c |  4 ----
>   include/linux/iommu.h | 10 ----------
>   2 files changed, 14 deletions(-)

It's fine for the intel driver, so

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

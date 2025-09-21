Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F7226CFC;
	Sun, 21 Sep 2025 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758448463; cv=none; b=ppZiTJ9dGgA/rAJ5lOj/YxRRTBuVdCOvhpNG0xmmJ1TCEIjX7fuH3H7NnIx4rr0ZKNyAg6XbGoETzoZr325/2RH0uRQT1TZ2gwwqCpMhnL71PaL7O1GnaXOhcQqCEMHBt+SLHifiWCREISUa+c8oUzzegzIVl9qvb046hHPIwF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758448463; c=relaxed/simple;
	bh=S9kFNiU/TsLMpGfbfyUN6IbULHvch78ajpEs1fk0n14=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aIvZ25hOzF5P+MoIS534frx+rb/usG3KlnMTkwzVrjQSy4kRJYSxZk5Ni7V3wbTF3dgki66Jvqb94Qpt3BYBoxetqkpuE89hUjSTz0nGudSXir4k2dpuNa9Z4F/ZUkyIHnZgFBWjH9qy8vpoHHuWhpy1PbuM+G/Qugp0kowBDW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vh4B41k6; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vh4B41k6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758448462; x=1789984462;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S9kFNiU/TsLMpGfbfyUN6IbULHvch78ajpEs1fk0n14=;
  b=Vh4B41k6nT4IpMJa8wKvHCbOzcUip8uUZEp3ccgXXEdZx6VaQImAYqfL
   J7+ymgDG/ykyNheE5IIb7reeNuyt39F6xJMEV8jY8mlqk/Gu6nl2EOvS1
   luvEPgfTsOB4gb27BjLhfFwcE6E3pFEh1hz/SkQfyM/vJsYr+wLjrHkgm
   gafcIRGRQ6ES0DeW76FcEuoh7icX+pmedP41DdHdeXFxDtuvrQXLQIEtK
   3HLQaUVxbWYT8tkPLMLTtjQTr8sTYytQTV9g1Bfy7P3FCvHxw59hf8hBM
   iU/maphny1ePDMAHXcsOqIzh7By/ZXnD6OOTYKFdNQXOtI/xUpjfIJ/hc
   A==;
X-CSE-ConnectionGUID: J5PncKIZTMCY3kYHULnmdg==
X-CSE-MsgGUID: wHl2tzYDSUKDDFGIjmcS2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="64560106"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="64560106"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 02:54:21 -0700
X-CSE-ConnectionGUID: EH5qZSVTQa6hMI3rPZ1rvA==
X-CSE-MsgGUID: tdoI1qJKQqKvqysxpo5CSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="177039600"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.235.53]) ([10.124.235.53])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 02:54:19 -0700
Message-ID: <debe1f51-e070-4efe-b88d-5111df9c9874@linux.intel.com>
Date: Sun, 21 Sep 2025 17:54:01 +0800
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
Subject: Re: [PATCH v2 01/10] iommu/pages: Add support for a incoherent IOMMU
 page walker
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> Some IOMMU HW cannot snoop the CPU cache when it walks the IO page tables.
> The CPU is required to flush the cache to make changes visible to the HW.
> 

nit: how about make the subject like this,

iommu/pages: Add support for incoherent IOMMU page walkers

?

> Provide some helpers from iommu-pages to manage this. The helpers combine
> both the ARM and x86 (used in Intel VT-D) versions of the cache flushing
> under a single API.
> 
> The ARM version uses the DMA API to access the cache flush on the
> assumption that the iommu is using a direct mapping and is already marked
> incoherent. The helpers will do the DMA API calls to set things up and
> keep track of DMA mapped folios using a bit in the ioptdesc so that
> unmapping on error paths is cleaner.
> 
> The Intel version just calls the arch cache flush call directly and has no
> need to cleanup prior to destruction.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/iommu-pages.c | 117 ++++++++++++++++++++++++++++++++++++
>   drivers/iommu/iommu-pages.h |  45 +++++++++++++-
>   2 files changed, 160 insertions(+), 2 deletions(-)

For the helpers and their implementation for the VT-d driver,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

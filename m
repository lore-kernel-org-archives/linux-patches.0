Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E022FFDD7;
	Mon, 22 Sep 2025 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758539829; cv=none; b=lKQwO0Esi/h9+YNEFhp2bwnUKDxDKDx2KPl75NKcHL8uouFtOdB07l+uUiVal51DLuXC46lbEAVipfL/Gj4ORftLQ4Wy7ujP+voMp8cesMCb8gsf7B3TWiZSb/5fNTIemFOpihiZDV+aYV7g6cx2kYue7gX3nHlVFYsBH1JX75Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758539829; c=relaxed/simple;
	bh=lH9VwiNy6Nu7QO4PMzso5D1oOtUAcurDD/Uxg6ZQsi8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CBEKVP5GXJ4qY8P5keR3HA4JDw2F2nqxg7Utz4WOK6VSGFTYV+SZGYsTxrE2NdCi6uCOR/UxtbRuUzjqGxkImqTavgRRTjiOIuvqk2brDEPd2T8H5n94Jem0oojs0CHEHyb2hpshmnLE3vftEvZ+VZPVN2xwccCxMlOqOOiwCUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3xf/D5c; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3xf/D5c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758539827; x=1790075827;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lH9VwiNy6Nu7QO4PMzso5D1oOtUAcurDD/Uxg6ZQsi8=;
  b=b3xf/D5c3Lb3kMZ3t9Ib/iK5ZWLTaQV9CKyW9+dxybexaMvqv7xI9Hz0
   2N9evrC7vdX7IDFFAN3IQR9iOP9kSglSM8pm1jolmh1k68u9ofU2DF9k3
   3zN30r0qgxa9Qtczf7fXB1ienKCwlBsJQapYqM2j7LEspkHyno11udlYj
   lDMlrOhBjUeTmYeaD63J4U9/OX72PCXlpZGuZX4HvGwIIp0Y3LtUSyUrc
   N+6w3o5fiPZMLsFfjJmiU7+f62+xFccPJgCslFKHcE9xWuTNmscByXfJ1
   M5cCfKIGOOdEbxHK2K4OtuKfzd3PxY3aJEwBq6HSKLljddTFQwP8bklck
   w==;
X-CSE-ConnectionGUID: mmZ0OAD1QeKxQrdfIIpHxQ==
X-CSE-MsgGUID: scQH9J86Qq+v+aI9jJQUkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="48376615"
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="48376615"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:17:07 -0700
X-CSE-ConnectionGUID: yPl64IL+QcKr4LyVmSYJTg==
X-CSE-MsgGUID: c2gtXOMIS/+mqOy7tMErXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="176065717"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.235.53]) ([10.124.235.53])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:17:04 -0700
Message-ID: <6a42747d-1115-4667-bd01-78f6629332b3@linux.intel.com>
Date: Mon, 22 Sep 2025 19:17:02 +0800
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
Subject: Re: [PATCH v2 08/10] iommu/vt-d: Use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <8-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> Replace the VT-D iommu_domain implementation of the VTD second stage and
> first stage page tables with the iommupt VTDSS and x86_64
> pagetables. x86_64 is shared with the AMD driver.
> 
> There are a couple notable things in VT-D:
> - Like AMD the second stage format is not sign extended, unlike AMD it
>    cannot decode a full 64 bits. The first stage format is a normal sign
>    extended x86 page table
> - The HW caps can indicate how many levels, how many address bits and what
>    leaf page sizes are supported in HW. As before the highest number of
>    levels that can translate the entire supported address width is used.
>    The supported page sizes are adjusted directly from the dedicated
>    first/second stage cap bits.
> - VTD requires flushing 'write buffers'. This logic is left unchanged,
>    the write buffer flushes on any gather flush or through iotlb_sync_map.
> - Like ARM, VTD has an optional non-coherent page table walker that
>    requires cache flushing. This is supported through PT_FEAT_DMA_INCOHERENT
>    the same as ARM, however x86 can't use the DMA API for flush, it must
>    call the arch function clflush_cache_range()
> - The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday for the
>    second stage when it uses 128 bit atomic stores for the HW context
>    structures.
> - PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around ERRATA_772415_SPR17
> - A kernel command line parameter "sp_off" disables all page sizes except
>    4k
> 
> Remove all the unused iommu_domain page table code. The debugfs paths have
> their own independent page table walker that is left alone for now.
> 
> This corrects a race with the non-coherent walker that the ARM
> implementations have fixed:
> 
>       CPU 0                               CPU 1
>    pfn_to_dma_pte()                    pfn_to_dma_pte()
>     pte = &parent[offset];
>     if (!dma_pte_present(pte)) {
>       try_cmpxchg64(&pte->val)
> 					pte = &parent[offset];
> 					.. dma_pte_present(pte) ..
> 				        [...]
> 					// iommu_map() completes
> 					// Device does DMA
>       domain_flush_cache(pte)
> 
> The CPU 1 mapping operation shares a page table level with the CPU 0
> mapping operation. CPU 0 installed a new page table level but has not
> flushed it yet. CPU1 returns from iommu_map() and the device does DMA. The
> non coherent walker fails to see the new table level installed by CPU 0
> and fails the DMA with non-present.
> 
> The iommupt PT_FEAT_DMA_INCOHERENT implementation uses the ARM design of
> storing a flag when CPU 0 completes the flush. If the flag is not set CPU
> 1 will also flush to ensure the HW can fully walk to the PTE being
> installed.
> 
> Cc: Tina Zhang<tina.zhang@intel.com>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/Kconfig  |   4 +
>   drivers/iommu/intel/iommu.c  | 896 ++++++-----------------------------
>   drivers/iommu/intel/iommu.h  |  99 +---
>   drivers/iommu/intel/nested.c |   5 -
>   drivers/iommu/intel/pasid.c  |  29 +-
>   5 files changed, 175 insertions(+), 858 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

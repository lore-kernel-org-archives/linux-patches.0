Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A332D6E70;
	Sun, 21 Sep 2025 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758461398; cv=none; b=ialJekqMqpFIafH5oxFffUJR8I62GAUUEkSR8fMiJV4dvXzf56ZMmYHoHssjRDz2R/R3qTvD66dvniDAyDTbbt0QUDT6l6bhr5r3mm2QtUffd7j5Ub9MbmF9wCog7Q/VeILCoWcq75sOnVg4w/SlQn1ocgfecNAVnt1dghrkd3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758461398; c=relaxed/simple;
	bh=iSU+DSkShu/BCEZvAfS6J9+nPQocQSDIaiLbbg18Beo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dP885TttW0xoXsH58kKf4ad4ze8MJdDxQG5ddIZ8vXjkuPNu5unts/2ubMjXFolLCyB4bm+W35cVp+M29KyHstXaDlI1Bs7Y8ulzIFbxEbt8vDT+gL8VcK0qhNkVtmlmlK1HlUi/6oPo3fpX4ROoqlrky/+jDgC1KiemKefUpE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YuqmX8Kf; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YuqmX8Kf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758461397; x=1789997397;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iSU+DSkShu/BCEZvAfS6J9+nPQocQSDIaiLbbg18Beo=;
  b=YuqmX8Kfz+cWs6kABgNZ4Vj90NFwXdwWIhw2AP3ZXN6Ljvp8z06tpH+5
   ijENAB3d+bJ3rg/wY+/2Gaj3/1Pa7nTDwR2RQx/9hoKfK/iH0nvSeZYc3
   lX51d/mcnx2Vi9uDbGWRLU4eo6QDdOlL1tDqxg5R6mt9hhnuvI0aQxYtj
   Svk1SKnprxnC3QNmKUqMQppaPrI0gya7tYOia+iyrJwElYfgjpRBCP36N
   gH0IyeCxhldiGWO5rNReFvP3sbAo1xxdaE6NHnoJeFvwxSHrJlVld+8i3
   n7vzuvia3Xa+WZsb32Nmq3u/SNv8yOp1CHe9Fm+jBQ6mElQLkPCNyMc5z
   Q==;
X-CSE-ConnectionGUID: uNuTjoiESuuLaHCrgbPEtg==
X-CSE-MsgGUID: 3cKFGDHtREKunyTl1ELL3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60900121"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="60900121"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 06:29:56 -0700
X-CSE-ConnectionGUID: tWW1N6HqRrejaaE180kG1A==
X-CSE-MsgGUID: CHirtJMSQ9e8nHclpjcumQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="176330475"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.235.53]) ([10.124.235.53])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 06:29:52 -0700
Message-ID: <9766f1a2-6542-4672-86e7-be2d78c0ac52@linux.intel.com>
Date: Sun, 21 Sep 2025 21:29:50 +0800
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
Subject: Re: [PATCH v2 03/10] iommupt: Use the incoherent start/stop functions
 for PT_FEAT_DMA_INCOHERENT
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> This is the first step to supporting an incoherent walker, start and stop
> the incoherence around the allocation and frees of the page table memory.
> 
> The iommu_pages API maps this to dma_map/unmap_single(), or arch cache
> flushing calls.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/iommu_pt.h    | 81 ++++++++++++++++++++------
>   drivers/iommu/generic_pt/kunit_iommu.h |  1 +
>   drivers/iommu/generic_pt/pt_defs.h     |  3 +
>   include/linux/generic_pt/common.h      |  6 ++
>   include/linux/generic_pt/iommu.h       |  7 +++
>   5 files changed, 81 insertions(+), 17 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

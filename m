Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FF12B9BA;
	Mon, 22 Sep 2025 03:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758510550; cv=none; b=UmiS3E/9sQMempd6TcH9QZQrEGZWK2U12Z/X+l8TB8t8vgvBEVRc8ozpmFfl+u/BDM0rhBGrez8doiaNo46GMEbnbaiJdBFs/hdLwnlnrjYZK97votbxAgdm33nc7MmyHIo7nj9OmqLRx6kDeTaIoNkZf7LdhXD/c+lvoJmo8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758510550; c=relaxed/simple;
	bh=bDwOMABZ/cxyOpg5fMmG2FPWeyrxUl0QOtttpvA4H6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/t5Q1lTr7d/8zxk79gs1IdeebmD6wqh9SKX1Dj2kvsl6eeS+wi6NuLJS1eRN8SCfqCEWokmxbb+o8nLPb1MQeDtWS7UJmzU/Dk1HirQ3g4uQC/QrPLgvoLxdyE60aVFfdXqVtllDFvGXWFt2yxiPc8kO1owQD9GNrlz7ZM8qd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZMl0vyz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZMl0vyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758510548; x=1790046548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bDwOMABZ/cxyOpg5fMmG2FPWeyrxUl0QOtttpvA4H6k=;
  b=AZMl0vyzTSc7cbcheJ2Dh0MCkck0J+c3SCC+jAyhBgzBrQdfnW9AAykH
   Yd1kWg62BUHWSMNgLEiphnLw++HT5HnKu00tAdaOIfqdyq0rXW7EdsITI
   9cKX4ozU/LBmmVc25NNGDAz6rz4JcCOmn4cFhHLb6svvNMiW14VaI2Tlb
   ADPp96iJbDULFVqOgH0lG5WvSXkBNHIpuajzKAFYZEjwwu0GzSMNh+SQc
   V5uBcx/C53Ue30rZxm4MAqPEp+fM7kwY85NfgUTQPL/aMoyadcv3R9qg9
   H8WYqK2Thf6py8tgmAKg9WYPE2utKQYHSLlqwyFKk1Ll+101jA7pEKDPi
   g==;
X-CSE-ConnectionGUID: HWEH/KgEQW+fRp4yMiqZpw==
X-CSE-MsgGUID: fDJAjMNBQ3Ops/G/+5SxBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71871679"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71871679"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 20:09:07 -0700
X-CSE-ConnectionGUID: cToZSKiZQT2ZhcuPJ8UGeQ==
X-CSE-MsgGUID: 8f05MjsqSsO8vivp5ti7rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175933314"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 20:09:05 -0700
Message-ID: <3c8005bf-ee63-4a2d-9934-b4ffcb11a152@linux.intel.com>
Date: Mon, 22 Sep 2025 11:06:05 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] iommupt: Add the Intel VT-D second stage page
 table format
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/25 01:26, Jason Gunthorpe wrote:
> The VT-D second stage format is almost the same as the x86 PAE format,
> except the bit encodings in the PTE are different and a few new PTE
> features, like force coherency are present.
> 
> Among all the formats it is unique in not having a designated present bit.
> 
> Comparing the performance of several operations to the existing version:
> 
> iommu_map()
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,     53,66    ,      50,64      ,  21.21
>       2^21,     59,70    ,      56,67      ,  16.16
>       2^30,     54,66    ,      52,63      ,  17.17
>   256*2^12,    384,524   ,     337,516     ,  34.34
>   256*2^21,    387,632   ,     336,626     ,  46.46
>   256*2^30,    376,629   ,     323,623     ,  48.48
> 
> iommu_unmap()
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,     67,86    ,      63,84      ,  25.25
>       2^21,     64,84    ,      59,80      ,  26.26
>       2^30,     59,78    ,      56,74      ,  24.24
>   256*2^12,    216,335   ,     198,317     ,  37.37
>   256*2^21,    245,350   ,     232,344     ,  32.32
>   256*2^30,    248,345   ,     226,339     ,  33.33
> 
> Cc: Tina Zhang<tina.zhang@intel.com>
> Cc: Kevin Tian<kevin.tian@intel.com>
> Cc: Lu Baolu<baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/.kunitconfig      |   1 +
>   drivers/iommu/generic_pt/Kconfig           |  11 +
>   drivers/iommu/generic_pt/fmt/Makefile      |   2 +
>   drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
>   drivers/iommu/generic_pt/fmt/iommu_vtdss.c |  10 +
>   drivers/iommu/generic_pt/fmt/vtdss.h       | 289 +++++++++++++++++++++
>   include/linux/generic_pt/common.h          |  18 ++
>   include/linux/generic_pt/iommu.h           |  11 +
>   8 files changed, 363 insertions(+)
>   create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
>   create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
>   create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

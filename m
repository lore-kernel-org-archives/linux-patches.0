Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29892153FD;
	Wed, 26 Feb 2025 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573756; cv=none; b=atzVotXv8mIB5r4JSiscJwvLNojGSV7LUkjtI9TKhIYX0zCtC0AhGqqXLVMh81hIHg33V/feYz0+3dG8ou3hqEskXJyt1nZqJ92DS5PDsHSeSvhMVrcx2TXD4/Oi56rra/1STKx8AHVehgcD2l7fxG9wJ9Ec+5MoOPyDMpT68eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573756; c=relaxed/simple;
	bh=WkXc7BocQbpip7ciVHNFAiTeTqJtNYIch4zaYSdoITI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i1Dcud8CmP3A1muf2FwVvrKJv9c9wwpuCQbeMH1/qYK9Ms9msih/HDVRd6PVtXst5Dom7erMg1tLQWNtXGo7hh5V7c8LV9xRBJBLdKyXo5BxlpiSjwN1R/AfijdW6DZ17WArCNz/ePWUpM5bok1vUF2XFpBSBdbfIFR/uqF2d9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdDlRf/X; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdDlRf/X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740573755; x=1772109755;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WkXc7BocQbpip7ciVHNFAiTeTqJtNYIch4zaYSdoITI=;
  b=GdDlRf/XjPticAJwwgcqbdBEQ5Te2mca7GqASFuXGS1goojPEH0Tl+o4
   MEdviSXqHTj8Tc93z4vC8Xm8swYScjQoGAtX2Mx5xATHkOsotl5i26uGj
   br92FvPj+USmO8e1O1RhLtfm3raFGw6kjYXfbTmp5S6pHPVjZh9ya3wx8
   O8vBaBT70jJN0VOM10JxDV1n/PkXCutmqZsV1DFV17oCGfNk9/swkrrZ1
   VWw8BD5WFVctU1jGxPUVmoKX7vtCfMmvNLRiNkIegC3wXLAbProZRiFRU
   la582XF9fDZ4iE08PGIbO7gOTtuoQfEE8k+3DlyqRv7Zh5LxkYUyDixeM
   A==;
X-CSE-ConnectionGUID: aF90sED1Rf6gxw9U25AQGg==
X-CSE-MsgGUID: V87YsNbCSVW/40WRSR8v7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41543448"
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="41543448"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:42:34 -0800
X-CSE-ConnectionGUID: qzXgd/NORXi327/S3f15AA==
X-CSE-MsgGUID: bn1g+MruTuG+TRPKXFaDnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="139911002"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.105]) ([10.124.240.105])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:42:26 -0800
Message-ID: <fafdcc71-b246-4855-a088-24854b124b21@linux.intel.com>
Date: Wed, 26 Feb 2025 20:42:23 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Bagas Sanjaya <bagasdotme@gmail.com>,
 Joerg Roedel <jroedel@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 patches@lists.linux.dev, David Rientjes <rientjes@google.com>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 14/23] iommu/pages: Move from struct page to struct
 ioptdesc and folio
To: Jason Gunthorpe <jgg@nvidia.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, David Woodhouse <dwmw2@infradead.org>,
 Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Robin Murphy
 <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>
References: <14-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <14-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/26 3:39, Jason Gunthorpe wrote:
> This brings the iommu page table allocator into the modern world of having
> its own private page descriptor and not re-using fields from struct page
> for its own purpose. It follows the basic pattern of struct ptdesc which
> did this transformation for the CPU page table allocator.
> 
> Currently iommu-pages is pretty basic so this isn't a huge benefit,
> however I see a coming need for features that CPU allocator has, like sub
> PAGE_SIZE allocations, and RCU freeing. This provides the base
> infrastructure to implement those cleanly.

I understand that this is intended as the start point of having private
descriptors for folios allocated to iommu drivers. But I don't believe
this is currently the case after this patch, as the underlying memory
remains a struct folio. This patch merely uses an iommu-pages specific
structure pointer to reference it.

Could you please elaborate a bit on the future plans that would make it
a true implementation of iommu private page descriptors?

> 
> Remove numa_node_id() calls from the inlines and instead use NUMA_NO_NODE
> which will get switched to numa_mem_id(), which seems to be the right ID
> to use for memory allocations.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/iommu-pages.c | 54 ++++++++++++++++++++++++++-----------
>   drivers/iommu/iommu-pages.h | 43 ++++++++++++++++++++++++++---
>   2 files changed, 78 insertions(+), 19 deletions(-)

Thanks,
baolu

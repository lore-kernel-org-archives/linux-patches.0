Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C591E492;
	Wed, 26 Feb 2025 12:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740572775; cv=none; b=dtK4QVfMA5RSkv5h1LN0C3aw4Zfh9r0cR8CmK7jpp3GnWOmH5e2pLTqtW2UkEwq/bMkPiC0adWcTfsDpwfobzbdsVBSRvEXx5iWOImft7ZoJMgZmODm2EuzOR151QZycrQJy7juCV2omHJU/kRkis+RVniSPtKc0HYtLS9PsATI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740572775; c=relaxed/simple;
	bh=4swnzxuk3Mp34U728sCFthX69jILu8ATPWa0zFUvrcM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YxDhRBR6biXWaAH3dpisA58xm+Pcvak0dWZAuYrYxbp8a9m3QydMI4n6D+jD9iU8/NtfDiHuIZUiyOXHj0QOc3HMsWtAB5EXWkzu9Ad5ICK4g31BcNMGc3GUFSBRJVzHjFcdoxfGcyvFF36q3XEPWkgfZmyPusoq4ozORpnLflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UA/zAxUE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UA/zAxUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740572772; x=1772108772;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4swnzxuk3Mp34U728sCFthX69jILu8ATPWa0zFUvrcM=;
  b=UA/zAxUE66fv200DReYCotc3lDV5/zz6WGRAJ6j3+78GYdCIxQ4FTfFe
   uOyBMp2kgFoGTP8vduYIJKRSDe5raaZYF2R5LPV58DHzUFDxf7+8v+dpB
   sRXzK8bdk65vrLzE0LmT+FXF0y0uYw6E6OEwklsIyGa6jjyY97q4HQg9B
   u2K0+jZYhPknGOnZ6cqvZYMzD2oaifD6c5qh9K1m+BJOkE1qoz8K2NANR
   6VzTbT6zLZx/02EGoND/1/kOxvUqDhE5oGSAadCZyFVOXqzRy8AAPOLhq
   NifZT5TSBvw38B0BhLT2Y7nkScl+hXT346mNa1Dp6zwzno9UYN+AW1wiP
   g==;
X-CSE-ConnectionGUID: 7+eKIg5JSBqiOXzQ3AeJ2Q==
X-CSE-MsgGUID: yEk2BwNeRLKpLkhAxPPUuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="45195958"
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="45195958"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:26:11 -0800
X-CSE-ConnectionGUID: 762ere5SQUeDKcp4Fzyz1A==
X-CSE-MsgGUID: aMfDjXFLSPyglZBn67P2Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="117177990"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.105]) ([10.124.240.105])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:26:03 -0800
Message-ID: <44963756-16e6-4a12-b2a8-2901b961342c@linux.intel.com>
Date: Wed, 26 Feb 2025 20:26:01 +0800
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
Subject: Re: [PATCH v3 22/23] iommu/pages: Remove iommu_alloc_page_node()
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
References: <22-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <22-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/26 3:39, Jason Gunthorpe wrote:
> Use iommu_alloc_pages_node_sz() instead.
> 
> AMD and Intel are both using 4K pages for these structures since those
> drivers only work on 4K PAGE_SIZE.
> 
> riscv is also spec'd to use SZ_4K.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/amd/io_pgtable.c    |  8 +++++---
>   drivers/iommu/amd/io_pgtable_v2.c |  4 ++--
>   drivers/iommu/amd/iommu.c         |  2 +-
>   drivers/iommu/intel/iommu.c       | 13 ++++++++-----
>   drivers/iommu/intel/pasid.c       |  3 ++-
>   drivers/iommu/iommu-pages.h       | 13 -------------
>   drivers/iommu/riscv/iommu.c       |  7 ++++---
>   7 files changed, 22 insertions(+), 28 deletions(-)

For change in intel iommu driver,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

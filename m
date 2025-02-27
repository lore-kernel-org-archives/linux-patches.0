Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62A2186E2D;
	Thu, 27 Feb 2025 05:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740633668; cv=none; b=iYSoHcH4BqS6VCCr0Zi1QKkXmST17dQurhxHwz3QVMrHKCZNFmIyyXh5NGmtEQM5nC+kWTb4PSSqPDsyPnM6uI+abZDvPddbk1PfF6d5d5YwZGHIIw+no9LHTnh4rwinlAiNs2JZCm9lgYWAX4ueLh7+8EyrjyoDurrxD0vFXhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740633668; c=relaxed/simple;
	bh=PQtjihnmxnJNt9cGH7dsXgv0bEF3d3LqLBB92T9bDY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWhxiLB+6/+X6Zp5nnF8ltTIThpohzXFfwjac0TCNsa4oeIBFMsBuSag4REcPOF8sHU8rOXOQ8GP6Pa6dscXCmwPJdml9pbr+fcPSg6Qd8f301BNGOhMV1pLfwcYEfRQEaekdReUQjizRVHEntMZjTxpkU9rryN+sybbGPkWUzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkcO6Uq4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkcO6Uq4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740633666; x=1772169666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PQtjihnmxnJNt9cGH7dsXgv0bEF3d3LqLBB92T9bDY8=;
  b=QkcO6Uq40NqJDKdRzFmlfPbpFWOmb1YUkWFaoqMIADOUfqJbcC0gdGxv
   t87IOpayWAYMs0U/YdK1QJiwjd7f4j60KoDF0SpyWOXdk2BerQsSfTcQe
   j6fWsQWLZZpOjUq5U9wNi31u2g4+n2xHhKUF7VbJNXzzI/qInfvllDqJz
   2PXQUnRoEwLLGdjp1xFUoGay60yT38VJn+dPtc+ZL54iwTU9ILL2UFKsD
   wUsqNcZmAnDu5fdHDWnVyMXjbWUHqvMt364JLwN/dmQqZhTepLC2fuSFd
   pRLdkQHUAOSe89GSuC+LVQl41dFuGnQvXM+nkUunjDH4Y2MtD4SAkxdbc
   g==;
X-CSE-ConnectionGUID: UnmPFd7aQCSwI814rnj/fw==
X-CSE-MsgGUID: U/qJTFY9TP6NAG1gMIoYdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41638788"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="41638788"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:21:06 -0800
X-CSE-ConnectionGUID: IDSQ03WOT0Sf2y1g0JuloQ==
X-CSE-MsgGUID: X4xnN020QO2lRkAamUgJOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="117561589"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 21:20:59 -0800
Message-ID: <397fbef1-3aef-4421-bd68-107e289a95aa@linux.intel.com>
Date: Thu, 27 Feb 2025 13:17:42 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <14-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <14-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> This brings the iommu page table allocator into the modern world of having
> its own private page descriptor and not re-using fields from struct page
> for its own purpose. It follows the basic pattern of struct ptdesc which
> did this transformation for the CPU page table allocator.
> 
> Currently iommu-pages is pretty basic so this isn't a huge benefit,
> however I see a coming need for features that CPU allocator has, like sub
> PAGE_SIZE allocations, and RCU freeing. This provides the base
> infrastructure to implement those cleanly.
> 
> Remove numa_node_id() calls from the inlines and instead use NUMA_NO_NODE
> which will get switched to numa_mem_id(), which seems to be the right ID
> to use for memory allocations.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534426983A;
	Wed, 26 Feb 2025 06:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551516; cv=none; b=uTnZZ0jeSHBHfkl8qcdyi2KcJxSJXsTBskLmo41pE+/YsTx4tdovy8oOS3KPkNNIVR+xx6UzTVtkQJHLwAoKLO2cY2y7/eO+l0YbAvdOjlA4BOA24C2uAajubG/9uVFplXQEQ1XGsFMwymcGZP0DXrepf9/VHKpjjzexiyeDqpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551516; c=relaxed/simple;
	bh=yeNE9l/7kc4iO6oQlttdFI0ImAydMtnQ59bQsp4kneY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qnxmc5Vxu/GJ57nxgjoqXRJJJyLwJFUHhY5tGuCbyMQiNZtxN0fSxzH2n2FvuWa7JuFHh+EM6XNrLqTb+dtSwM1YmVveRqDZOpK4KpMuFkSfexLe1233ODPGQAc9Zx12lpCuQ35QqQuNBr5kIzZquiOYWTCY3Pz15nPzn8LnPTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BekXEztv; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BekXEztv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740551513; x=1772087513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yeNE9l/7kc4iO6oQlttdFI0ImAydMtnQ59bQsp4kneY=;
  b=BekXEztvSNaSPBzHMzUw/F8auvj4ztL1yfvAOu8j+xalkeWZDqotZ9op
   h5UdnTUk+hCNvrWSdBQEnUZ/qNwb4fVv9zCOEp47Lb2ORytZJOR8osqQ0
   FlYn4WeA/47xPoHv9y+2i+X2RXaVWdWo41b5ZqxipYevtrfYAmz2kzdWb
   +rRjYSXwXyxl0fc2KAE5d9NG/kHx23D9B19vIlfWBebrX2N+j8O2NZ198
   DoNBMvigSW4U29N6BA/+oBDd0/mgN1HjeAOmP6hGcudMAM1YxWtbegpKX
   XMC3XLKEDYhuPae1j0qQggX5Fvj+rripDZiadT2dt3rloJ3ST0mbkNPUY
   A==;
X-CSE-ConnectionGUID: Y2/k4C7gT3Oj/SnFhzJeDA==
X-CSE-MsgGUID: mDo73p80Tfin6K7LQ0Vzug==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41087728"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41087728"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:31:52 -0800
X-CSE-ConnectionGUID: 53+y1LNORqyqi7R5eDgD0w==
X-CSE-MsgGUID: IVNVYYLWRaGC3MlipK1v+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="116418952"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:31:45 -0800
Message-ID: <20bd43f3-c1e4-4469-b5c7-9724607d6e57@linux.intel.com>
Date: Wed, 26 Feb 2025 14:28:25 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/23] iommu/pages: Make iommu_put_pages_list() work
 with high order allocations
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
References: <4-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> alloc_pages_node(, order) needs to be paired with __free_pages(, order) to
> free all the allocated pages. For order != 0 the return from
> alloc_pages_node() is just a page list, it hasn't been formed into a
> folio.
> 
> However iommu_put_pages_list() just calls put_page() on the head page of
> an allocation, which will end up leaking the tail pages if order != 0.
> 
> Fix this by using __GFP_COMP to create a high order folio and then always
> use put_page() to free the full high order folio.
> 
> __iommu_free_account() can get the order of the allocation via
> folio_order(), which corrects the accounting of high order allocations in
> iommu_put_pages_list(). This is the same technique slub uses.
> 
> As far as I can tell, none of the places using high order allocations are
> also using the free list, so this not a current bug.
> 
> Fixes: 06c375053cef ("iommu/vt-d: add wrapper functions for page allocations")
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41E623A9;
	Sat, 15 Feb 2025 09:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739610819; cv=none; b=QmVJahp+oGLGmG4R5eikz1jpGb8v+Wph1PqBflOLXVsBN9ytz5DgOOqxDbBBJRu9h0pJITVs85J3QKvlkoi7H8v7x2rsxpY+hnIRkWaygH2RFv+fWXZAiCNlH+WT0hPJo0QKIsqjrlcdTSAM5jmShddj6Hap7x/k+8GtA83EDFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739610819; c=relaxed/simple;
	bh=G/Qt6dZjMBOmDsbuyaRv6OzX+guIhg98BM2jS68/vTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHqtP6BAU/s7llGbza3vyTeFlxhKz/E+iZmpxb/hC+Du/WFeWky0mKIfo06SOWeeg1sL9OnVRHqGxqW3tnJYu1Igkg+nGK4RCiVM08zN/A+2pTWbxZXfn1O6KqzW3y5qSCVJjnDYiAzdRIbyBNjjGq7QFYSvfUkHZA2/7hTkDz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEXNpWtk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEXNpWtk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739610818; x=1771146818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G/Qt6dZjMBOmDsbuyaRv6OzX+guIhg98BM2jS68/vTk=;
  b=lEXNpWtkQ/pY+MJgCLoW9+7sYNgcJiv1O6uI0KMnqYpZSPogozPategN
   spHl5DAjdGlwtL2GjZvdVkhTjYg7xF539nPleAxmhQY+YPC0Y0ldQwQGr
   si6Fkcv5F7lwHbTycmObtxRoXb2ZPss+efUdZOrMHd4ZYkWpxt7ERYBvd
   /FeOQ+qohkcjFoqdjl7pWthMGzyskpwVku4NvGWLCXOloNIhRUm0rJPOy
   t8C0yNpntUgRMMSQziiFPEFyq6SV6jvJXGw51Q+7TTYHRRsRtYO9brpBu
   HJGPNAy3rCANKCqc5jX5SToOVxTXD4PS9IprrQUYgW4LMBHN2VgN7C35O
   g==;
X-CSE-ConnectionGUID: /E0iXX5pQaKWlljliXp2gA==
X-CSE-MsgGUID: Ya548ZAXQq6cPjEjp6FHXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="40279508"
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="40279508"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:13:37 -0800
X-CSE-ConnectionGUID: OjCkaXbcS1WOq7oKO+qQrA==
X-CSE-MsgGUID: ncWbRhG0QRqp+uOwSydKkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="118688305"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:13:28 -0800
Message-ID: <d68dd230-96c1-44c2-b8f5-59f87fcca25a@linux.intel.com>
Date: Sat, 15 Feb 2025 17:10:32 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/23] iommu/pages: Move the __GFP_HIGHMEM checks into
 the common code
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
References: <15-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <15-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/25 01:07, Jason Gunthorpe wrote:
> The entire allocator API is built around using the kernel virtual address,
> it is illegal to pass GFP_HIGHMEM in as a GFP flag. Block it in the common
> code. Remove the duplicated checks from drivers.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/io-pgtable-arm.c  | 2 --
>   drivers/iommu/io-pgtable-dart.c | 1 -
>   drivers/iommu/iommu-pages.c     | 4 ++++
>   3 files changed, 4 insertions(+), 3 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF694267AF2;
	Wed, 26 Feb 2025 06:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551345; cv=none; b=ORz/7dgJnKIOeGCHTnalMhRRZQwcokfcEEI3COY/hVHKlJnfmTRym+F6T0qWEesKmuJa4OpxazH47kseyJLR36PSXWFVNYgG7HjmThhE4wVVytjq1RVEi6gn0S5JP95RxNLhUKiaWy0bASyCl5UJnzxd0mXHwqN5IFCepZLPHdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551345; c=relaxed/simple;
	bh=lXhU7sd67KpdS+ygAGbHgQMDj+NU0WLx7YcQjO+y+Dw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cvNCN2VeWk7d0Xrr3LzLTwivs7xG/sTICdJctO/fO27fZoqSqckvWTMQyRGlmPgVdHZJpuQD6xq9ntppr8kT2nJcHJOYOznsqR4cIP5sP0dTxCH+0M7gncYgxiyvGZ1Z5wUO+Mj5kdMPtZlvQ20u9U92XVC9O6PoXA8J8yF8dPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DFr/5DLe; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DFr/5DLe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740551343; x=1772087343;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lXhU7sd67KpdS+ygAGbHgQMDj+NU0WLx7YcQjO+y+Dw=;
  b=DFr/5DLeJxygtylYdBlVk/USakt+72UKMkQV6nOF/yrSk9ssVD9MKoVo
   Rf2OfX9Igy1dfngwjtpcsXco9lA9EK1sMzEKfkn6gaquOcPkrAS921uz4
   pJj7lFwunCvI352aUtbKIVdXoQvl+9ZW+Xh4fhmVeCcDWJyJeE6Dg3Wtx
   Mv6ACeG6qO03w+RFJ50RYenwZRDfjsE0i2OKshR3y/Gp0KSyotj9L7BY7
   Suq59YSb3gy9unMocZ3v//zfqj9s7mK8IiJj9ed4ouNZlTg29x3ddKYzP
   t8KloUh88DSJ/JveVLxP2BRHUAB7mAEp8ieCq5NNUZ+JQi8XTyZH/2Nr/
   Q==;
X-CSE-ConnectionGUID: U8cM8FV7RGyXpjWWBnBRSQ==
X-CSE-MsgGUID: FyDGv3i6RzyGPV6CEU5zrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41298302"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41298302"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:29:02 -0800
X-CSE-ConnectionGUID: 2JLYeRJ8SYy4f0Hre3l56g==
X-CSE-MsgGUID: UbYTX0nDQsG2v0uK0Z0EBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147525482"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:28:55 -0800
Message-ID: <a76deb10-314d-4b49-8dc6-8372564266ae@linux.intel.com>
Date: Wed, 26 Feb 2025 14:25:40 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/23] iommu/pages: Remove
 __iommu_alloc_pages()/__iommu_free_pages()
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
References: <3-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> These were only used by tegra-smmu and leaked the struct page out of the
> API. Delete them since tega-smmu has been converted to the other APIs.
> 
> In the process flatten the call tree so we have fewer one line functions
> calling other one line functions.. iommu_alloc_pages_node() is the real
> allocator and everything else can just call it directly.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F7192D63;
	Wed, 26 Feb 2025 06:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740552395; cv=none; b=FHj1kTgFZMojxSoCIpCk75RTcV0iPifmAuYIKFGBHrQnL3NdbvnHwh/mUWZcvH5lULdoGwIVHGjDm4areCkl6eAjlrZJw6Qo/yd2GVoax35cvm9fj2dqpH+vzU4rnh6kWe9KGOlRRKp3cLuuHxJolC7uGOX998gKBLA6dwyEER8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740552395; c=relaxed/simple;
	bh=DcJW8rnikbMnBHMjyLqT5C+TmnYl/QP63LXAKlFTjQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q8wNwN2vG5LAy2/G7ugY51fucEvEOR4qpks2J0ugSsWusLspQ+HvKCckkqW77DbNGOT4ivwZncieMgueahhW3GcRJ0YoaUHpsWROmpfq21kuuY/la2I9ZC76pC45bKLpRm2kSSevoqvWyUN+lvRQooHbl6HcWDCRF4DDnKxl+18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KeKA8mn9; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KeKA8mn9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740552395; x=1772088395;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DcJW8rnikbMnBHMjyLqT5C+TmnYl/QP63LXAKlFTjQA=;
  b=KeKA8mn9/yko5cO/ZXhr0n15l9jRRSwSjBZP7eLNUrTdH1xp/ztMcFAk
   7CSpjD0O0YfJK1E0vKDvK365wMGhOay1i/2lol9gyjeUyHKtfns6zmfFS
   vNfdyYXgw6BiRs6P2Aq8UIfiyJcHVyoyQ10q1aOjZIJurxo1uHrCSNuUV
   ezV1ZqAK1Soc+DAoDilNqynGmbxsPmhe1tj2knbxO7/CWeIj2slew3Xrq
   uRGzfQ/r4uNlAPui3jTbPDSla1B8Ee53/7a4sRlcQ8wSCRPzzUP+ueixH
   r6OUZE+oBCkMOb5tOPSlyZcmrWPkSgR4HQXKAXPx4xlAkslEZ3zNnigw/
   Q==;
X-CSE-ConnectionGUID: j556L88mR8uNE3N0SzhmQg==
X-CSE-MsgGUID: SPwKFNC7Sc6711JiM7QQ5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41300219"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41300219"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:46:33 -0800
X-CSE-ConnectionGUID: vhSj9HPxQdixfCU6Udz2DQ==
X-CSE-MsgGUID: f6KHA8H/TGKMHtiGBJpThQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147528550"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:46:24 -0800
Message-ID: <cdab4b5f-f943-4091-a03c-252769221fcd@linux.intel.com>
Date: Wed, 26 Feb 2025 14:43:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/23] iommu/pages: De-inline the substantial functions
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
References: <7-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> These are called in a lot of places and are not trivial. Move them to the
> core module.
> 
> Tidy some of the comments and function arguments, fold
> __iommu_alloc_account() into its only caller, change
> __iommu_free_account() into __iommu_free_page() to remove some
> duplication.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

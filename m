Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D6268FE5;
	Wed, 26 Feb 2025 06:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740552017; cv=none; b=LW0iu9w+HOdD6bF+sI52Jz9HHJIQOavxNMiBcEcwhWnHsSJ/TGTdG5rkUtRWBcBFoyV6Pfqhnsj3GPEXL84JiO/AVQMldfAWCWvb4KcyxAthDVC+fWrfUDj26nIpxhbczQlUEd13qsvv8L7KBpkIwv+St1Ouh1RHubN6+IVeIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740552017; c=relaxed/simple;
	bh=LhlJYnqquo1shJKupI/Fa8GBn0+W1Px9NHZAejazzu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMd0NUWO5wcDauXBxfU80xgMZceJg2JTBYiLNIL/hqplZDuQBGKdKfch9rYbv6l3Le9nuQaFgM2f75PayD6gKGGPohwFpIHrkM4RK5PclkEcntEuh8/+yhwVO7XIEXVkY6ZubMy3AAlXFQu3onUJQtMB3uijkPbOE84AE6u1C8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXM3CcYq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXM3CcYq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740552016; x=1772088016;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LhlJYnqquo1shJKupI/Fa8GBn0+W1Px9NHZAejazzu4=;
  b=gXM3CcYqEA/+eQWDOaanJXEMkeYc4oFExxF0GGpuJ9q+R8DY15OalFyi
   fqwCZJKoMJnc9wnAQrS5GEN0ckIMsT9sCHk5Obvkk7xou3cgSxyETUBt6
   NluJGkw96zC0ytwRagQrU0e1+QawesAVx1cAiuzlDZsFGG5fA1rdDv+QO
   ly5rQtyTH8Y9I2DgQi9JRebFXM2REyDfzWVJkD6VOzjAjEv2aVgSUlY+P
   A+IH1Ya5FkqHQBxTrTOGdnhS2e7WzAhmpwDPhVxRBxD0BdVZQa10zXvxD
   P4540cvBrDomeINROtuiiw1a7ZMuQyZCrpQ9ysVhMcI5jNDUIXlkNW5KF
   w==;
X-CSE-ConnectionGUID: E1x9sy+rSdejz6Ve7gewSg==
X-CSE-MsgGUID: tbTbXnWwRDKmgAURPMJtDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41088305"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41088305"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:40:15 -0800
X-CSE-ConnectionGUID: BfdrDOJVTkOUWSLCJpkdNQ==
X-CSE-MsgGUID: 9n2T3c9ATAi3EHRCb1cr8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="116810796"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:37:27 -0800
Message-ID: <94b38478-9ec7-4d42-b989-cbcfb65927eb@linux.intel.com>
Date: Wed, 26 Feb 2025 14:34:12 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/23] iommu/pages: Remove iommu_free_page()
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
References: <6-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> Use iommu_free_pages() instead.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

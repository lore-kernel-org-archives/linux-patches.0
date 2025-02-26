Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF07214817;
	Wed, 26 Feb 2025 12:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740572653; cv=none; b=i9mGLJ7u3L7EUrRRlUsVFLQps4stjjr1yR16RzDavBFKjH/FgH97sngXK1xztAW8lQhLe71I0PO+XWIGJGNYD1QqKLAVJqvdkGbuWYpn9XLk4GkCsOSw0By5nLJtKsjzAqRC+CMx9r50zyddTQR1UAlFqh3+K/G9oY6np3qsuVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740572653; c=relaxed/simple;
	bh=P9888PT4GlbGGm/Br9DmxmDaQSRLXoZLVYOYGsAgjmY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KPnY+cjcNsTEXUi74/t8EU9BooaBpMq152VjPGaboK7Idu2dxt+vZT/Y7yA9VhaTBwZotlGO86M0LsudSpzI5c6UmNIiEUse2GzpkF0VxllqwXJEOCTg+lGpoYG95JOTr/xyybEOt2/7LfMaOzq7ymOg6BMddZVsytlGqDulCKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTNcSLuu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTNcSLuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740572652; x=1772108652;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P9888PT4GlbGGm/Br9DmxmDaQSRLXoZLVYOYGsAgjmY=;
  b=HTNcSLuuCnkjr12kdolK7FvPQ4a6nMG/x28YDZCQYlVv3YWpj55aOEhS
   sJBpaT2AbUk+gn1bKPB8VCa5psW0bQfBrX4ClVT2O7BHRdZI8U/P13AXO
   lmM0FVJ0i+Dngt+kySa8yd1IwFCtpAapStyTWEnuvblHyBUtLABsU78RC
   bujUzrMCkDqC6EnmK79wM7UeO3kvrcbfRwzap5IqJtJmNNe5RUxMXPL3m
   q2vaWXpJoP80O2TqSMFhR1hhG2epFX1mhwr5ki2tBL4/P/qqWfwesqSyc
   G34f20iSWM7caqj7rRgwzG++ZfGZjkTowDRaG+4vkOE4s+vWfM/ILf3L/
   g==;
X-CSE-ConnectionGUID: hTwY1SnlQGKgCh1LXRZe4w==
X-CSE-MsgGUID: H5RxPgJFR9GsXo5P31WaKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41541450"
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="41541450"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:24:11 -0800
X-CSE-ConnectionGUID: wzzbivYHT0KOHQkWAqrFjQ==
X-CSE-MsgGUID: mecjk28SRGKVrI7hEWbiJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="139907373"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.105]) ([10.124.240.105])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:24:03 -0800
Message-ID: <e50cf21d-49b1-4c9c-8e85-41d70e6fdb5b@linux.intel.com>
Date: Wed, 26 Feb 2025 20:24:01 +0800
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
Subject: Re: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
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
References: <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/26 3:39, Jason Gunthorpe wrote:
> Convert most of the places calling get_order() as an argument to the
> iommu-pages allocator into order_base_2() or the _sz flavour
> instead. These places already have an exact size, there is no particular
> reason to use order here.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/amd/init.c        | 29 +++++++++++++++--------------
>   drivers/iommu/intel/dmar.c      |  6 +++---
>   drivers/iommu/io-pgtable-arm.c  |  3 +--
>   drivers/iommu/io-pgtable-dart.c | 12 +++---------
>   drivers/iommu/sun50i-iommu.c    |  4 ++--
>   5 files changed, 24 insertions(+), 30 deletions(-)

For changes in intel iommu driver,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

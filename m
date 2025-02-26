Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2581F2192E1;
	Wed, 26 Feb 2025 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740572543; cv=none; b=bYdvSBd1jIgQfNP9hC+X9Ux371g2cEaWn+fpKT/B8wIM/GhSYBA7f1ydq1jsJnr33tNDE8SWM8XGVJYx36GnaKBYdbJ0k2pks9X9EMEIHdfCwI9RXnjfMBh0SxkKHft+WbC2HLXlnv41FoJTsFrYpz5UZrwhuyPd9VEgy0ITqhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740572543; c=relaxed/simple;
	bh=lFhxRXpv6QTFcMfVUvDqKANeqKNOPbO6YgonBgCYQJI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RxndwLWCCL5hu87V/4UGzq3BtNPZFj+j6eAh20/XMc2MNq4YUV+6JR6SlefukmcZ7aIuvcdG6pPJkvoLwo061Ce9yU1YXhsXbc/UPFS2hl02iwr0zLmGCkWdJxsmGu/+9AAWFm8kbfCfmoiUuiz3GVnnQYvunIEIhDAS6cQk1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKxa+tzr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKxa+tzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740572542; x=1772108542;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lFhxRXpv6QTFcMfVUvDqKANeqKNOPbO6YgonBgCYQJI=;
  b=bKxa+tzriX9SBviBJdHIMUH6iCJgBJEvxhkwM1m5hArCp2Sz5MP6G7P3
   /hy5lb/BLJayYYMINt46SKFzoUdQlIt8ko/mrQ5FOGDn4h36gC1uH6JM+
   eggHeaGCT0ohkZmGD5tXr4+vI/+2p7Epp9DEVBlks+pio6OI8KzFthkij
   hf9HMNSJQBQNf/28iWlZijwCKwmGbwwWciUoChVuIaN+IDtZDrBL7HOEQ
   YOmglOS33jEHb+R8XvCyL0FeEhHwfufZQMuB+9GM0KVKT1tDzOFufQSnm
   oQf3V6/jwlZdbTuF7pPnpmG7KhmjHr594ORgAfp9zh/6Z0lSR1bYaZxXq
   Q==;
X-CSE-ConnectionGUID: +MzoPnBKQbGep6v6v3he3g==
X-CSE-MsgGUID: N5nTX+1OQHOm85QuGJm0jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63877919"
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="63877919"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:22:21 -0800
X-CSE-ConnectionGUID: hCu3EQHDT2qlP3dV1KuKQw==
X-CSE-MsgGUID: vpSaOO0DSI+Av8u8OcxQ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="116691259"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.105]) ([10.124.240.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:22:13 -0800
Message-ID: <caff123f-0910-4949-8512-acb77c6f0a8b@linux.intel.com>
Date: Wed, 26 Feb 2025 20:22:10 +0800
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
Subject: Re: [PATCH v3 16/23] iommu/pages: Allow sub page sizes to be passed
 into the allocator
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
References: <16-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <16-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/26 3:39, Jason Gunthorpe wrote:
> Generally drivers have a specific idea what their HW structure size should
> be. In a lot of cases this is related to PAGE_SIZE, but not always. ARM64,
> for example, allows a 4K IO page table size on a 64K CPU page table
> system.
> 
> Currently we don't have any good support for sub page allocations, but
> make the API accommodate this by accepting a sub page size from the caller
> and rounding up internally.
> 
> This is done by moving away from order as the size input and using size:
>    size == 1 << (order + PAGE_SHIFT)
> 
> Following patches convert drivers away from using order and try to specify
> allocation sizes independent of PAGE_SIZE.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

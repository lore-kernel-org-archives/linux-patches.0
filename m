Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2F268FC8;
	Wed, 26 Feb 2025 06:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551990; cv=none; b=dpWTvCHM8GqkJqxXXTOzY7+0KZE09JzlfdWxV/ZV52ZO04XKmXYLSZMut05Iy1nmMeLKqPgaIpGCCUNKvh+VzYkKouJYUySwNykgUVch01VGq7Kf/b5/yZwAArhFAiKy0ARD4yMBk3UH/Ed0oWH/WtpYaeWYCCOfc+POpi1ea24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551990; c=relaxed/simple;
	bh=wEZYyMMMYY0p/InDFAWstpwiUT9Y8kIbFfE8GirQgHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgMM8R/+lyV4bCxvTqf3tQtub8JZ0QBJJxtUsA441AbkrtkgiO7nNL86H796P6sOv4b1dBQxv3hVTkqOUZY0Czk7sKYtJUWyoMyz0sm+UkSSINPyZuS8/RXLdr7F5Jt9qdCqsVTD4B64Xn5+l8GoV5FSL1kKZo47k//tL+YBdZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2J7sN5T; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2J7sN5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740551989; x=1772087989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wEZYyMMMYY0p/InDFAWstpwiUT9Y8kIbFfE8GirQgHM=;
  b=Z2J7sN5T+Pm5D4SEJxAaShuQZnjiWtCS6PGYa7AChH4yoUvXJRPwNaMH
   9N2Ft8BKQAZcFMu4kBtG27EubQiev5S2482dex9NmO5PhiS29kxvgEX+a
   +M2xhdAnwomCApiyrOsv6OiG5PqAvTHj/gZORnx2vzOxr2uiosOFyRmGO
   5+omYyfSSt/oh2Qb2V7tWHaHLbwKtyeACE9QFdRM2/4dKVZyNlcSFIynb
   0HSxbXwS91ptyTQQhHivj/7kULrIonsfUVArQBi4d6mbNesmJHMim9DWf
   p0WgMdEAJOKPsiHjmmnZkzmqwh0V3/UnSeU+o0Wvj7+wLPf0nnDUSR1Zs
   Q==;
X-CSE-ConnectionGUID: E+dr/rEMQZG/JDuV5gHzlA==
X-CSE-MsgGUID: YS380KKCTw6hy8P0ghDExw==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41088243"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41088243"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:39:48 -0800
X-CSE-ConnectionGUID: gk0tSm0GSMuWy8te+oesQA==
X-CSE-MsgGUID: B4sm4s2nRNO85JsKQGxg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="116810017"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:35:53 -0800
Message-ID: <a60cb386-0387-4889-8f9b-88f01cf9408a@linux.intel.com>
Date: Wed, 26 Feb 2025 14:32:38 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/23] iommu/pages: Remove the order argument to
 iommu_free_pages()
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
References: <5-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> Now that we have a folio under the allocation iommu_free_pages() can know
> the order of the original allocation and do the correct thing to free it.
> 
> The next patch will rename iommu_free_page() to iommu_free_pages() so we
> have naming consistency with iommu_alloc_pages_node().
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

For changes in intel iommu driver,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

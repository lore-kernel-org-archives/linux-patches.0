Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573B434545;
	Wed, 30 Apr 2025 02:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745980633; cv=none; b=hFxFpcX7FvZKWt+M7zeiH0rcc50wTxAGOEWgCpxyvjjvrsaAHbaNXtb770TqbtGNB91v4NMtpiCkOuuGqNsnFqHVANszSg9AwbhNQfXpInOiPNQ4y6HKgO3ZLISlKZzojW05CmD0qLTb72FRJjeMw0ly8NZACbVwk0rQwxw8GvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745980633; c=relaxed/simple;
	bh=UeVWVQMtCSgoY6I17XEsqNEXKT0TWbHaFTIMLOeTnTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E56n228goyoSAXxOhpFWC2KLQVS8csCsq4kC74nRfcQ0aQFqCk/Wox3cUg2geCq01QypWbua7rOUS+krIVDVhkFawPqRKWltaBOcpnHMAjlU433HVIfMfAO14PJY36s7l8OCkDeGHar7GDzUvcNtgj+RpigxJ4UjcHJnP7JZ/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RsGi18MN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RsGi18MN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745980632; x=1777516632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UeVWVQMtCSgoY6I17XEsqNEXKT0TWbHaFTIMLOeTnTs=;
  b=RsGi18MNF8jGZalT5uwWEr7+XwHGKafTsSeLz/yTc84l1CVW8nb6eQGn
   bJ5FJSZOGdHd3qCWfIEZHesxJGcPvsgwyCTM9Rs7iv2vYhNSpQNw+1DkH
   hT+41b02Igg2vBsZ1GTXYHAStTougPRAkcRhKN02U9FiuNf6F2UI182dh
   fibc0UebK422qSdSPFDtQyoQ8NwXcQvSAkIE4w1KMepXqzyTBWLvjZbkt
   h3GIjj1rlbYDH+Qmf4kpYsGKajeeI6qA/RTWeJ3+Ki4VyYCJmE/5H/lE1
   03k5aWTVaHL7VGQnXJOCL3OZkfKZLRlTBoUS+WWnKKDS4hhXjArOAIvvP
   A==;
X-CSE-ConnectionGUID: R4sf0fRGTneoXFUXRXqVvQ==
X-CSE-MsgGUID: xhXryxAsTla99pI9NZIkXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51445225"
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="51445225"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 19:37:10 -0700
X-CSE-ConnectionGUID: rPKpQb86Qv+hi9Gbn/bOCw==
X-CSE-MsgGUID: eN7Ab3jZTbWZDraScrUmnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="134508430"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 19:37:00 -0700
Message-ID: <0a5f2f46-f474-49d3-baee-59f2ad0a6f0a@linux.intel.com>
Date: Wed, 30 Apr 2025 10:32:46 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] iommu: Remove ops.pgsize_bitmap from drivers that
 don't use it
To: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
 Janne Grunau <j@jannau.net>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, Krzysztof Kozlowski <krzk@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Neal Gompa <neal@gompa.dev>,
 Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Rob Clark <robdclark@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
 Niklas Schnelle <schnelle@linux.ibm.com>, Sven Peter <sven@svenpeter.dev>,
 Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 virtualization@lists.linux.dev, Chen-Yu Tsai <wens@csie.org>,
 Will Deacon <will@kernel.org>, Yong Wu <yong.wu@mediatek.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
Cc: patches@lists.linux.dev
References: <3-v1-7c5282b0c334+2db-iommu_rm_ops_pgsize_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v1-7c5282b0c334+2db-iommu_rm_ops_pgsize_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 22:34, Jason Gunthorpe wrote:
> These drivers all set the domain->pgsize_bitmap in their
> domain_alloc_paging() functions, so the ops value is never used. Delete
> it.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/apple-dart.c       | 1 -
>   drivers/iommu/intel/iommu.c      | 1 -
>   drivers/iommu/iommufd/selftest.c | 1 -
>   drivers/iommu/riscv/iommu.c      | 1 -
>   drivers/iommu/virtio-iommu.c     | 6 ++----
>   5 files changed, 2 insertions(+), 8 deletions(-)

For intel vt-d driver,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

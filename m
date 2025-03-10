Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617121A23BE;
	Mon, 10 Mar 2025 02:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741573466; cv=none; b=NlYHrf05Y/mQolXJne25JzB7PPgiNbg9wPfjntAlIShAVmLbE2+7CPzfdG+xe66I7+yw5LyxIf7gFoZTD+yJWi7RUVesm6mIHhh3PiF+PnQxoy2w8SP53JQEW/24tJVpV21sGOMj8aUOxMlMwErFeCast3CKhPscnvJPEbtTBnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741573466; c=relaxed/simple;
	bh=WKFaRGNbm41ygiDOYwuZyQiHlC64X9yBshoJhOG//8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=maSA61ozKasp4NjRUlBaz61hXuGH3w6RVk7NLBNb+jk7keo5z0RFj08b3bATQgVThCeO2G0pbUgTH9cXlW+aC0moaLsdjX35ZHCi4d1eDeplnLVIOYEjps9I+20Q0oj0IOLqbjpssBcWsfp44wiN5oLQeQy7JKLNkyb5L4GPnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jnMlHSSF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jnMlHSSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741573463; x=1773109463;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WKFaRGNbm41ygiDOYwuZyQiHlC64X9yBshoJhOG//8I=;
  b=jnMlHSSFwCSoSxg9WKFmeAiZG8gycT6bCJQWCDO/I3IFI8KD34U7WPFX
   iCxurxqJG2A4DewW6JddKpHXppSP6lsaygkVRoO5fr8+WLIMUowBffZST
   uZdKjJ5oEC7AEo4ad8uhXQihb1dVjoPVeXtx30NhissLz8CEBEb/1tKdA
   +lrKAziR77JL6d158ktQ70dxxypsPmhyut2+WS63XJrAuanGTiRZocCXK
   KP/KhJ6ja4HvBdwOW1GzJzpmOTJQTXFTbMw4TbCFHQ/+84ODELq50NuWH
   y5UpVeTr2kgO5nYOtoMeN2ZFdL/ueEk3P8coAyLVn8GZXZok4qKwjTavv
   Q==;
X-CSE-ConnectionGUID: OTTb0LIaQzKcfmDAl3/t6w==
X-CSE-MsgGUID: e1lHuOU8Q5+iwQCm1qYt/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="65000964"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="65000964"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 19:24:22 -0700
X-CSE-ConnectionGUID: EBcI4p/gQFCFWXYHUd2zOQ==
X-CSE-MsgGUID: kuyCE67oS6CBdcD22w3xyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124459380"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 19:24:15 -0700
Message-ID: <2db8d0c9-f6df-48f3-8bbb-4592e86d92fa@linux.intel.com>
Date: Mon, 10 Mar 2025 10:21:03 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/23] iommu/vtd: Use virt_to_phys()
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
References: <8-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> If all the inlines are unwound virt_to_dma_pfn() is simply:
>     return page_to_pfn(virt_to_page(p)) << (PAGE_SHIFT - VTD_PAGE_SHIFT);
> 
> Which can be re-arranged to:
>     (page_to_pfn(virt_to_page(p)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT
> 
> The only caller is:
>     ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT)
> 
> re-arranged to:
>     ((page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT) << VTD_PAGE_SHIFT
> 
> Which simplifies to:
>     page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT
> 
> That is the same as virt_to_phys(tmp_page), so just remove all of this.
> 
> Reviewed-by: Lu Baolu<baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c |  3 ++-
>   drivers/iommu/intel/iommu.h | 19 -------------------
>   2 files changed, 2 insertions(+), 20 deletions(-)

Queued this cleanup patch for iommu/vt-d.

Thanks,
baolu

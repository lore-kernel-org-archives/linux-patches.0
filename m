Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253DE18A6B2;
	Sat, 15 Feb 2025 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739609560; cv=none; b=QZ77JAxrTJoMbYuGf42lDZfqi3mijwqnc6EI5RyKjUVTQbBVrTGb4TzZ/UJWo1jpNIXAkzon+2soZ9rWcCSboWdZGiQdEL6Z6bZ3zIj6aGqGnct6GKB+Ki0oKS89hrXKkiK1CqLjOopUWdPOpd+oE1PZSM/q+R1Tap5xAcruWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739609560; c=relaxed/simple;
	bh=7GL2U5SpT2VoHIZNpeGTc6jbEWPVggoPMzS2SMqOKM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nTddzukuhdcXmTKKAGATzTgXw0NswOgpt2fMxaJpakCiHk/hCAM7UAsDe0FshpjAjnxb55Z4yWze0csDjaJXlUL9eR3z82ae75kbpioLnCIG75zDC9f3db+PgrbUC+Udmi5NbC1IyMnqLbMhsSrmZ5Pj1v9vtGwkL8kH2l7nU4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/LsGibK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/LsGibK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739609558; x=1771145558;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7GL2U5SpT2VoHIZNpeGTc6jbEWPVggoPMzS2SMqOKM8=;
  b=M/LsGibKDgjEgsPzsDLXBdkbOrdWYSa7zQpLG3kUan74hVR7Oo54iTlS
   HbWNzBBEEUmb8ExuxPC1Jcfaw2u1l0EqMawfgQeIvoYuIoJPh42y+kCCc
   7sjnH9ysSqkZbNEOTjE5Jv9D78Hdb2wR3GVjiUoSpimDvnAjBICMm2r2q
   vz/tM2W1QOa1EW02TCmUwg1Z1rRg68CUx87CkvZxrgElfeVd7TIV2Y+iT
   Pmhlk4Rbles0F6N/2tsOSnlY125oaHDmaAw3PWlcJ9NVc3GYKjsnuZ20W
   f8wxfWJqR7muR8pQLi8NRmeTZTCyOrn6mTd4jbRUq/5kAzntidJxhK6ie
   Q==;
X-CSE-ConnectionGUID: yOo3V98QQS+JlieQGFKxrQ==
X-CSE-MsgGUID: KwG1+olXQWy0jNEmG54MFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="57764862"
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="57764862"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 00:52:37 -0800
X-CSE-ConnectionGUID: vye0sqE8QmCQ4YPGfHOQQg==
X-CSE-MsgGUID: h5vIpSbnRHO9zzjW9Kx4YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="114287785"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 00:52:30 -0800
Message-ID: <bd54b742-16c8-4b55-95cb-5cb6847cec07@linux.intel.com>
Date: Sat, 15 Feb 2025 16:49:34 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/23] iommu/vtd: Use virt_to_phys()
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
References: <8-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/25 01:07, Jason Gunthorpe wrote:
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
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

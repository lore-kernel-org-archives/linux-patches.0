Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A21624F3;
	Wed, 26 Feb 2025 07:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553582; cv=none; b=iW9exsYdx5tOv4VFRNaya2yf3DkFhnLRSZotM7AjlEWEb1Csq0hP31TFZG0El7dKz46XIyWBpBjR7NRPjm8GZUKStPhkyAKeBuMwibNhdnNLb0QbkCy+Hv0W088aWKjzSkqjI6VKF+zcPG8DeP94Et+S0q3DiMorfAYpnfYJr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553582; c=relaxed/simple;
	bh=W5m8VXXaCJzooM7nBsw1fkyJLmefcSUyEyU2R1fyCSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WUbKcGMpKQ6KI0dKMwqvvbZeVMCDrAzuC1aEW0pGNfGGiQObAtXR1RJyMCia45LPgREGspr7/4XeTzeL4f075ytJZaLYeVpVxVjJzdn3nDr0t/E6hW+WQ0c9uk2xLmmbRK4LAwugNenm+NHgC38OxahZen0Ocup0KYdU3lLN5Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MThRaYb/; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MThRaYb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740553581; x=1772089581;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W5m8VXXaCJzooM7nBsw1fkyJLmefcSUyEyU2R1fyCSM=;
  b=MThRaYb/MD3R9bSbWTl5MdSSFldXfiLiD298pBpXCX+/NmeQGygdlT/f
   ZxO6VqfaAF5uYJXuof4nY+RDtSDNhmBDZfd4J/UdwTKb90qpBGxDdw+gk
   wLJZuLmrdo66ZnCfM13a4TBYB4WGu4myPq2B90zA9qO8asip8KCRM4i4P
   iyGIPcXE8MwnF7JGZaZPHzA5O4je+43M8uA/R5Lu5eUMC/pjrUfLJFOSn
   x7p0KABW38suS3S5vV0JEwfyaWuiv8rehg9ZM+HvxVnGs7K53sFwRBBTh
   8XzwHtEB1b8Sk5X3efiTLpRItgJQZCCDwxNgCj6fGumcS+76NDCXhrpns
   A==;
X-CSE-ConnectionGUID: iJfPzNPFS2WlKDHSUhd5Ng==
X-CSE-MsgGUID: RcdK0DvnTpu5clbizFwUgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="45300918"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="45300918"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 23:06:20 -0800
X-CSE-ConnectionGUID: o2XeqybiSAuGJr9XU9Ilgg==
X-CSE-MsgGUID: 55W0no9QSx2jxxin+p8ALw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="121717131"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 23:06:12 -0800
Message-ID: <7e70dfea-1be1-4699-b238-2d63fbfc2bc5@linux.intel.com>
Date: Wed, 26 Feb 2025 15:02:57 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/23] iommu: Change iommu_iotlb_gather to use
 iommu_page_list
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
References: <12-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <12-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> This converts the remaining places using list of pages to the new API.
> 
> The Intel free path was shared with its gather path, so it is converted at
> the same time.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

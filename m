Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF855258;
	Mon, 21 Jul 2025 10:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753092129; cv=none; b=dOK9aUViS4M/49yXhFix7kBlR6BTwhfCL1achZkHkTMGoqh9K2d+8YtAQ4rpTprf9xba0SJZ53Lwp5n6+Lu+Y06LRq5G66rqjDf3ISUoSJSgBH5VHUVLMmZutNEotfnsDqLg4+33EhVWKxWZpZyZZ3JRU1JM1KNBrW21THW0KXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753092129; c=relaxed/simple;
	bh=ksH7ebEAtjs/iHeHidUL03//oeQLtORgv7ufvNf6S0s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qbfjWgzqwuhbTLC4AXq4zG/zgmXvbYbP/9hDh7F0lx5M/geYgg2UW2VSfC/bzlIFQDRDac4b+nDAFizQCitOoeSVo6QLEhV9tmB7q7t3e8FAnFWHV8RVdK3YCEBP5GeEGVZOYyeCm2Mw6kOYuEiELqF7Pl05BfSuEWbZ769A9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q2Ld3ZjE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q2Ld3ZjE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753092129; x=1784628129;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ksH7ebEAtjs/iHeHidUL03//oeQLtORgv7ufvNf6S0s=;
  b=Q2Ld3ZjEfXjGvjJVut+Nde8DOoffBef2hjGU24KnGWOQ4wIbg7+w51rQ
   lPd8YyY6WYFTCIWOD+SRYxZ5S/jRWIBQmMGUYoLICEYTA1sro1POb3X8g
   yOZesveI99C8oNa9D/AWzTZov06Ncip9p+6sACMqFcSXKPu2eqEEyOkL5
   Y//RkWA0hNyMXntLaK/zeygEpXQ31828FcP1nkycFu1opkgKlOLrV4gZm
   pKutyzfVHaa0y2Ei1rloniLvz7N2mZ5vplip/ov2AfD4aKjlA6dKeTwO6
   B5dQbL0H4qCHDtZKq/Ee6L6m1wdaLCoGjxrgnveYONpGFsLvpglp1OYD5
   w==;
X-CSE-ConnectionGUID: 5w1iWtYtRGCJvFMNDW1ldA==
X-CSE-MsgGUID: hHLUfCDmQhSlj3h2dxDQtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11498"; a="66649111"
X-IronPort-AV: E=Sophos;i="6.16,328,1744095600"; 
   d="scan'208";a="66649111"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 03:02:08 -0700
X-CSE-ConnectionGUID: Sjiqaau/T/Ocl5/aFKq56Q==
X-CSE-MsgGUID: h2wxkY/+Sj+tm7wrAPWkNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,328,1744095600"; 
   d="scan'208";a="158109314"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.243.252]) ([10.124.243.252])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 03:02:03 -0700
Message-ID: <2fd44619-dde4-44af-b48e-71293fbcfd4c@linux.intel.com>
Date: Mon, 21 Jul 2025 18:02:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 6/9] iommupt/x86: Set the dirty bit only for writable PTEs
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <6-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/2025 3:57 AM, Jason Gunthorpe wrote:
> AMD and VTD are historically different here, adopt the VTD version of
> setting the D bit only on writable PTEs as it makes more sense.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/fmt/x86_64.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

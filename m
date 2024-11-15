Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7249E52F71;
	Fri, 15 Nov 2024 03:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731641063; cv=none; b=Szec9DLQsmFHfds2/Aa6a/dVxwmlqtmjH1nvDkDdSJiF1wo/u7gJFJ+v+zK6JBcGaEy7iZkLziE2Ysr8+NImK5yf2mJgIDEeYQMF1Ng5vij7fDQydwbIACV6Y7t50fEMa+YxVxlKX/q9RyJacXGgKpuE1ryjrPJ+RmTRVBaFCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731641063; c=relaxed/simple;
	bh=8QTLKulU08ztsSRY97lKpfpwjYQSjInkq5JQac5Ipcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epWn8+opWZdmP1atCPqk1z4JYqDG6LisgZQfBpTQo58I/rWbPAEeTVxedP1lD9kdos4u1B/MrCyDFMDvwaIi6AfTRwR4DFCegiXjG3tkP3+7ZXj1k8S2iwAYFJiJ8C5OCEllLWoD6ZEQ2DsmaWt7S5C7pNnpQeGUDOlRKK0DYHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UeQIt2IC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UeQIt2IC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731641061; x=1763177061;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8QTLKulU08ztsSRY97lKpfpwjYQSjInkq5JQac5Ipcw=;
  b=UeQIt2ICWTMqSujkQF720eLI7L8a/gqkJhULfgz1IF1evfiHNi6YZWRR
   rGn8zSXeKSsP8VMct4Hge4JXWCt3I+wLzSOsMWgTTwILIKJO5IalcO3vF
   925FrNJMPle4cv4tMk1lyMTCbKfEUPaKoXVOOBIBA5wneYPyqgAFzhkvV
   zRaA4WM42nRco+w4ty4HmWNO/47rQe8j+a7XDh3JEartqErGuEzLUWNQO
   wXtRH0pjMZUxbMOPBVfZCWvAH9s7dFBHNseTsvYIKeYf8drfIaHQn++CF
   91LVyeCpFNdIBv9RMmzXBOB+YXr9b/SUod925lTqOf5ADn5pI4s+KMl49
   g==;
X-CSE-ConnectionGUID: nS19FSs+TK2T6BLYdnoNsg==
X-CSE-MsgGUID: 4Rv+z3OQQ8GMHSVHqWdJww==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="35547979"
X-IronPort-AV: E=Sophos;i="6.12,155,1728975600"; 
   d="scan'208";a="35547979"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 19:24:20 -0800
X-CSE-ConnectionGUID: bz14ucyiSAKh7VeVs8wqJA==
X-CSE-MsgGUID: Pp7bmtyYTW64DjWErzO2FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,155,1728975600"; 
   d="scan'208";a="88819369"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 19:23:53 -0800
Message-ID: <e9981960-a7f0-4e0f-991a-0b96e1d57cd5@linux.intel.com>
Date: Fri, 15 Nov 2024 11:22:50 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iommu: Rename ops->domain_alloc_user() to
 domain_alloc_paging_flags()
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <2-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 03:55, Jason Gunthorpe wrote:
> Now that the main domain allocating path is calling this function it
> doesn't make sense to leave it named _user. Change the name to
> alloc_paging_flags() to mirror the new iommu_paging_domain_alloc_flags()
> function.
> 
> A driver should implement only one of ops->domain_alloc_paging() or
> ops->domain_alloc_paging_user(). The former is a simpler interface with

s/user/flags/

I think domain_alloc_paging and domain_alloc_paging_flags will
eventually be merged into a single domain_alloc_paging with flag
support.

> less boiler plate that the majority of drivers use. The latter is for
> drivers with a greater feature set (PASID, multiple page table support,
> advanced iommufd support, nesting, etc). Additional patches will be needed
> to achieve this.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

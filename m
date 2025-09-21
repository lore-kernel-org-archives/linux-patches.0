Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA491C01;
	Sun, 21 Sep 2025 10:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758450115; cv=none; b=OJBuS7wVvNRiqGCxpENdH00RZszyeeMFZrODjy7RcpwKAlaKCkhV9CEZhK5/sEEoFncs8p3GEhtGSNxA6JK20uWxPmH238cfe0PboxaVhMpjMcODBnztdiPCatVBAgSZZVEl6MW/MKTUza5fN39iLKjsR9LAGOry1MtOLwBixjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758450115; c=relaxed/simple;
	bh=odjqz9lqqnCoNlE22G131J95/VTke+fpRqKgVwfVKQA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C01oqcHU2ANEa0X2n67+Nvk0DY0Ih0MDw/85tT4jc/CAGe/XyigoGVdm/Kiti7mW0S2il56SWg3FxSB6DRA3qfL1Ki3ZMzeB8i1TG8jC8Lv4/QihUp4LFsbv9ECIMkwxX4UOmMxXA6dNkftSnz7Og+jFopXE2sKEWIyzlcW5/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCwDN/Sy; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCwDN/Sy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758450113; x=1789986113;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=odjqz9lqqnCoNlE22G131J95/VTke+fpRqKgVwfVKQA=;
  b=HCwDN/Sy2eKv6zF0mGXcgrdbqvpuOWPaSlvB4LH90sdujThFTVjEsrkA
   u+1dz80EfOEYdyqb5065B/k8yViYLWgrxdVfIs0/aZw93IVpcpzejTYIF
   PeUf0mtgiG3ufhiQYvT8VUPQOyh7tgWAzjFXmFyEz6z+kSXAIghLqb2nm
   cFnpZzCVHnjNIXrpngx9lI9mmJmP0NHF1tfhlG/itOttRwIjSQ5MjFDZ+
   sZi/dRD86/64qOAEQeOh3H2p9LAlvXeBEWyfe+gHKOr323hOTOK9fqRR8
   lT91t5+1GsYMGdj5eG8SkLvuTWZgmsuDQ6dkkO6zqRr+AKE9fG8wq02Uy
   w==;
X-CSE-ConnectionGUID: 7hJMsy4mR/SJtU568315mQ==
X-CSE-MsgGUID: olhTPbVuSHWllBTLxO6/0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="71364571"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="71364571"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 03:21:52 -0700
X-CSE-ConnectionGUID: lbTwN54LRoOEbeT0ALzzAg==
X-CSE-MsgGUID: h0RVhgFGS6CDzK7/LdvtZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="181497049"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.235.53]) ([10.124.235.53])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 03:21:50 -0700
Message-ID: <1735e8c7-bfda-4765-a2eb-4498cd68c735@linux.intel.com>
Date: Sun, 21 Sep 2025 18:21:48 +0800
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
Subject: Re: [PATCH v2 02/10] iommupt: Add basic support for SW bits in the
 page table
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> SW bits can be placed on items, including table entries, single OA's and
> individual items within a contiguous OA. They are guaranteed to be ignored
> by the HW. The API is very basic since the only use case so far is a
> single bit.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/pt_common.h       | 29 ++++++++++
>   drivers/iommu/generic_pt/pt_fmt_defaults.h | 62 ++++++++++++++++++++++
>   2 files changed, 91 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9282D5436;
	Fri, 28 Nov 2025 06:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764313108; cv=none; b=fMDXttPLVmGtUa3cT0g5QxMVP/sv9sVS/+ZYs4kBCKOkv+CZiTVR+SbAGJUr5rNVHyUVp/OXjaARAPuTeXloJVN5PoE2HRVn7vCzhRca30K69GrP+sW3U+jFllVquB0MRIeXbUjB3zcdlRhCZLmoghhxxxaZVmYhAiynjDFekhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764313108; c=relaxed/simple;
	bh=sOuAjBvEgm/R9Etp027UJr6YaJe4Wv2+KJf3XpIHqGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJtPruSyW7ef81gCZmstDWU7XUijmnqwDyRmK1pbAhmlqA1HXiwMwNYH9VXBFOPhC+dSlFKaFxnopJzGhFNni41qztgi6ADUIdkIaghvzCi/jet3NrNvUBfXmpmvRAgYwCiLXtXMR8pdPWx6R23ityDXAr7oyb5enS1y0U8CNhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SlDEIyPq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SlDEIyPq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764313106; x=1795849106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sOuAjBvEgm/R9Etp027UJr6YaJe4Wv2+KJf3XpIHqGQ=;
  b=SlDEIyPqM1bRK53WsORZk/v4yqQpgR0jc7xxVgEQGmyD0lgZMkQaMRaq
   NXU9iaZee1hffENeVSxnbdjtmG0c46IAVdYVOSTleQOb8Y453hW3UyHCw
   hcc8mjLUk3jpjGTbYHYWhLJH5ys8kV8lC4eWHHfLU85ZBexbuYsXmSBg/
   3bvY4Sv1GHxAZZ/pRJqzm291BzbuO/yTZkKaKLEqbSey62DgL6ZGDP6aq
   qzroNGSj7VBx97aLab27zP6JfmvmjwhZCOwloUw8wh4GvULLRtTIVjWvY
   C4qLMpkAgQvrbuFNDb1a6UYdT90o6jkZrYZgxxj1KG18R5TvalKmVJyYX
   w==;
X-CSE-ConnectionGUID: jH4quBIOSLGW5ml8NQyZTw==
X-CSE-MsgGUID: sy44GNHuTvGjHQF8rgx7yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="68939094"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="68939094"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 22:58:25 -0800
X-CSE-ConnectionGUID: PXe3CtMMR5CngCGRc0aSyw==
X-CSE-MsgGUID: 5VWY8tG7Q8et75D76qXCdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="193839300"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 22:58:23 -0800
Message-ID: <c583ed29-34a0-4ab2-bd2c-2fa94ea1a647@linux.intel.com>
Date: Fri, 28 Nov 2025 14:54:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommupt/vtd: Allow VT-d to have a larger table top
 than the vasz requires
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>,
 Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>
References: <1-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/25 07:54, Jason Gunthorpe wrote:
> VT-d second stage HW specifies both the maximum IOVA and the supported
> table walk starting points. Weirdly there is HW that only supports a 4
> level walk but has a maximum IOVA that only needs 3.
> 
> The current code miscalculates this and creates a wrongly sized page table
> which ultimately fails the compatability check for number of levels.

s/compatability/compatibility/

> 
> This is fixed by allowing the page table to be created with both a vasz
> and top_level input. The vasz will set the aperture for the domain while
> the top_level will set the page table geometry.
> 
> Add top_level to vtdss and correct the logic in VT-d to generate the right
> top_level and vasz from mgaw and sagaw.
> 
> Fixes: d373449d8e97 ("iommu/vt-d: Use the generic iommu page table")
> Reported-by: Calvin Owens<calvin@wbinvd.org>
> Closes:https://lore.kernel.org/ 
> r/8f257d2651eb8a4358fcbd47b0145002e5f1d638.1764237717.git.calvin@wbinvd.org
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ED1156228;
	Wed, 19 Feb 2025 02:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739933971; cv=none; b=K+tZMECwXi6t/d8RBgf3JBMcNDQOBF+9AtoE6JwpmT7bUq4mc2e0RMOuUDC84yorIHnqOBXlJC16nGnmKiRxeT9PfXWjmb5SmEacMvuNE9VU2cGEkjvTjqkk68YES0tNbo+lXvuGw7WRMCLNHB94oI/BzfqisHtkOiYnNi8xbvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739933971; c=relaxed/simple;
	bh=rOMFbl3z2EdNZq26KKAZFNR9PZtZbOBVCWnC4y2z5Us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tdNwk3zyvXqkoVti0+MgvO1LWuF0OmEdKofwZc3AIRIKoPLcvVVlKhBn8H7uFRQpfsXGiyoJRJ6JZNaiw1DoeNd1wOrRtKuse2kKzThMbEBAFVBuqnZUXwaOiJkrYcXVXr+L5ygpUfn4oPVo8kj7x8hpR4aDqjmgaKOaAIYIGpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWb89XwX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWb89XwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739933970; x=1771469970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rOMFbl3z2EdNZq26KKAZFNR9PZtZbOBVCWnC4y2z5Us=;
  b=cWb89XwX4WiW/Us0lQSQ1A+3h65LQyfmSFc9HBhtKBfAM1m1bkICR3ud
   Xe7PIASmjUvU2m2WXeLMYT1GQY0X4wFeWm4Pd+GKJTC/XPaAzWIja9upY
   cBy75tzZZ2PUam3Jai92J2IrRhYxiVJaDEONAl38tqmlhIO3vQ2O0F+/Z
   3DggkAyknIg+rFywqZLnafDGV8qwlOSId2bxpu91qcmeBscareg5oBFRZ
   l+aujq9mdFrzVrmRPQm9tK3ZtBX4jqN0EBueQ66ieZug5rKaz9lwbhLrL
   364+kopLosg9MlloqnbQIhYLEekNweDOlwBm3BysRr44a0rz60TO10VlX
   g==;
X-CSE-ConnectionGUID: NfPJi3MBQWWOBJSamckOqg==
X-CSE-MsgGUID: bCxO3ZFhSxC0z3HvkVvANw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40515891"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="40515891"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:59:29 -0800
X-CSE-ConnectionGUID: TBYZGMlXQXKSyTkYi9M/6A==
X-CSE-MsgGUID: 7HleMqibRqa4OaCc6SPD+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="114437430"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:59:21 -0800
Message-ID: <25d9f6de-5cc0-41ec-bdbc-0cf5f66743cf@linux.intel.com>
Date: Wed, 19 Feb 2025 10:56:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/23] iommu/pages: De-inline the substantial functions
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
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
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <7-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
 <84fd4500-a12c-40d6-a532-e2956ed1c35e@linux.intel.com>
 <20250218201924.GJ4183890@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250218201924.GJ4183890@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 04:19, Jason Gunthorpe wrote:
> On Sat, Feb 15, 2025 at 04:48:04PM +0800, Baolu Lu wrote:
> 
>>> +#include <linux/gfp.h>
>>> +#include <linux/mm.h>
>>> +
>>> +/**
>>> + * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
>>> + *                          specific NUMA node
>>> + * @nid: memory NUMA node id
>>> + * @gfp: buddy allocator flags
>>> + * @order: page order
>>> + *
>>> + * Returns the virtual address of the allocated page. The page must be
>>> + * freed either by calling iommu_free_page() or via iommu_put_pages_list().
>> nit: ... by calling iommu_free_pages() ...
> Got it
> 
>> and
>>
>>   s/page/pages/g in above comments?
> There is alot of historical confusion here because it was all designed
> around alloc_pages() which allocated a list of contiguous pages that
> could be subdivided. When this moved to GFP_COMP and later to
> folio_alloc() the subdivision is no longer possible. So it is not
> "pages" at all anymore, but a single "[compound] page".
> 
> So the module name is called "iommu-pages" but aside from the free
> list functions everything else acts on a single [compound] page only.
> 
> If you think about it too much it makes no sense but I didn't want to
> rename every function. I tried to keep it so that "iommu pages" was
> part of othe module name, and function designators, but the comments
> talk about a singular [compound] page
> 
>>> +static void __iommu_free_page(struct page *page)
>> It's more readable if renaming it to __iommu_free_pages()?
> Ah.. Well, it captures the module name but nothing it does acts on
> multiple things, since it is internal I used the other name
> 
> How about I rename it later on to:
> 
> static void __iommu_free_desc(struct ioptdesc *iopt)
> 
> ?

No problem. It actually depends on you. Since this is only used locally,
the iommu drivers won't use it. So, anything that helps understand what
it does is okay. :-)

Thanks,
baolu

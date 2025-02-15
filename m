Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF19018C01E;
	Sat, 15 Feb 2025 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739609475; cv=none; b=ThNZdG7XA+juV6q++96wwdXUeTbHcQIoZI42xupJEkui6pdEUv8dcxP9jiIDfLyLAjbNJNX0+1avAQGV1Vg1i7k6NykwpomrBUHz1Yy5gzlyST2rts8M5g7lZlczYRIqjzrHMVnSf4v9AxmqDns5xgEVfdFEbaCRyxsXzuFI2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739609475; c=relaxed/simple;
	bh=bOL7hyxwdyA5NZF7YWFX1w7MgDLf45Pn8T+oWqiAy80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWFkOiLzZdOeeh9V07ek5D9T+aYkN3JumAu00vDDi/jVOCCRJSCUEJrPl/WdVbPPYxSxg9nO/IH8Pr14MtFGHdbg/PwZoYrY1UxbQjfc+kfTFOZp5l+ywNyCEDq+f5wGqAEqiNDRzIc8ike4QbkzxMzDsN6tNPyFuX0v1JGAxQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/luwkOS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/luwkOS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739609473; x=1771145473;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bOL7hyxwdyA5NZF7YWFX1w7MgDLf45Pn8T+oWqiAy80=;
  b=j/luwkOSeWKokaacvlHoaKSz3XIbxKaT6KNpBc5knprsH0FtP37rKKL1
   XFWJvygAVK6VUJ2te4RxpxNsNc6G1WWDld4wInPhbiKa1COPqs18F8FvX
   LRV9suf+ry+Zr8HrGUJgckqbO9m9T7i1zVEUVnNTLC3yRedkW2SR52zs9
   X2MQQg6hfIQKllFzNbWOAuz8wd8Cog7vzgqOLYCjn5DkNYUBZ5D0jh6UI
   N0U/T9gOBRgqcoQQqv/5M/Sd2kh5fL8ZcW7H0cilsUsBoJBkBay9VuyJ7
   JPu0zJjZ28oWX0pW5mLmV1eR2cGwmUy/gEY8wDlibnSEsQS8+yiV8dK9Q
   g==;
X-CSE-ConnectionGUID: /T8rA8YWQqyccbl4TeTSTQ==
X-CSE-MsgGUID: WIZCxhhiQmq76y1oTS3M8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="57764818"
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="57764818"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 00:51:12 -0800
X-CSE-ConnectionGUID: /r+F0jx4RVKMBSVF09lU6w==
X-CSE-MsgGUID: r0L1deRvR9Cz9JN551mbGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="114287640"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 00:51:04 -0800
Message-ID: <84fd4500-a12c-40d6-a532-e2956ed1c35e@linux.intel.com>
Date: Sat, 15 Feb 2025 16:48:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/23] iommu/pages: De-inline the substantial functions
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
References: <7-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/25 01:07, Jason Gunthorpe wrote:
> These are called in a lot of places and are not trivial. Move them to the
> core module.
> 
> Tidy some of the comments and function arguments, fold
> __iommu_alloc_account() into its only caller, change
> __iommu_free_account() into __iommu_free_page() to remove some
> duplication.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/Makefile      |   1 +
>   drivers/iommu/iommu-pages.c |  84 +++++++++++++++++++++++++++++
>   drivers/iommu/iommu-pages.h | 103 ++----------------------------------
>   3 files changed, 90 insertions(+), 98 deletions(-)
>   create mode 100644 drivers/iommu/iommu-pages.c
> 
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 5e5a83c6c2aae2..fe91d770abe16c 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -1,6 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-y += amd/ intel/ arm/ iommufd/ riscv/
>   obj-$(CONFIG_IOMMU_API) += iommu.o
> +obj-$(CONFIG_IOMMU_SUPPORT) += iommu-pages.o
>   obj-$(CONFIG_IOMMU_API) += iommu-traces.o
>   obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
>   obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
> diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
> new file mode 100644
> index 00000000000000..dbf7205bb23dcc
> --- /dev/null
> +++ b/drivers/iommu/iommu-pages.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, Google LLC.
> + * Pasha Tatashin<pasha.tatashin@soleen.com>
> + */
> +#include "iommu-pages.h"
> +#include <linux/gfp.h>
> +#include <linux/mm.h>
> +
> +/**
> + * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
> + *                          specific NUMA node
> + * @nid: memory NUMA node id
> + * @gfp: buddy allocator flags
> + * @order: page order
> + *
> + * Returns the virtual address of the allocated page. The page must be
> + * freed either by calling iommu_free_page() or via iommu_put_pages_list().

nit: ... by calling iommu_free_pages() ...

and

  s/page/pages/g in above comments?

> + */
> +void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
> +{
> +	const unsigned long pgcnt = 1UL << order;
> +	struct page *page;
> +
> +	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
> +	if (unlikely(!page))
> +		return NULL;
> +
> +	/*
> +	 * All page allocations that should be reported to as "iommu-pagetables"
> +	 * to userspace must use one of the functions below. This includes
> +	 * allocations of page-tables and other per-iommu_domain configuration
> +	 * structures.
> +	 *
> +	 * This is necessary for the proper accounting as IOMMU state can be
> +	 * rather large, i.e. multiple gigabytes in size.
> +	 */
> +	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
> +	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
> +
> +	return page_address(page);
> +}
> +EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
> +
> +static void __iommu_free_page(struct page *page)

It's more readable if renaming it to __iommu_free_pages()?

> +{
> +	unsigned int order = folio_order(page_folio(page));
> +	const unsigned long pgcnt = 1UL << order;
> +
> +	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
> +	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
> +	put_page(page);
> +}

Thanks,
baolu

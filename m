Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62851E5B85;
	Wed, 26 Feb 2025 09:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561361; cv=none; b=qZDZo+ThyAvV8R+6vr9jgq8swcMZxl82uM7oXerCbf2pYxnetD3jdsTxGJWUAIOEdy9l803jMjsBIMIRJ4b02ZDycVY9rEJWdOoWW332HiMIWzWQaZICyXUVGjxe9lA4YvtFmaV1f2TRyKSFUK5qXzcwettz3sPSLHzatY+cLBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561361; c=relaxed/simple;
	bh=HmmdzVTTi/DjoKLcmrxW1fMIoviGanIxaCaW6zxswLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=RJabUx0ptYLwCoDvTI8ZVMxoWe6Vw9ndJSvPE1wWKGr3BTEzoonwLnu4BCqcDy+1KErJBuqMFSFz7ZZ2MBzdwOOvBdacu9LvlR+UP1Jy0u3Wji/fWJgRC8oBV1cRxYnoSyhUfz9+/8PoPS3jdqQWLmK6B6uR3OC/Ld8fKoy8K3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pd0qKB6S; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pd0qKB6S"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250226091557euoutp0161733e589313a5d360143bf659ed2ac4~nt1UUMSFJ0235702357euoutp018;
	Wed, 26 Feb 2025 09:15:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250226091557euoutp0161733e589313a5d360143bf659ed2ac4~nt1UUMSFJ0235702357euoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740561357;
	bh=jfJCJyoMIpaltaIU+7lWbslcg8FIPqfxsGd8Aa/3U4g=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=pd0qKB6SEv3qSWA5608B8oO2iGWR7WjfUjY2eZgAJKutotBUbf09dxzRJ6HokEIfl
	 SENoGO7kGj+s5+5W9pcnL1jlx+tZjJeceP8qzzOTwn25j197LEY2e5ro61VeUURHeg
	 tpP39Yc9WB7YuWNRDkkxYYqX3jPJHhQLSkY8WSSc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250226091556eucas1p29db20e03f1f9ea1782103d1167564e1b~nt1T3fxAv0815308153eucas1p2U;
	Wed, 26 Feb 2025 09:15:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id B1.88.20397.CCBDEB76; Wed, 26
	Feb 2025 09:15:56 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250226091555eucas1p1320cf0ed08b514c5259710476a930e60~nt1TNvpGD1197611976eucas1p1P;
	Wed, 26 Feb 2025 09:15:55 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250226091555eusmtrp1d211ba6163f39cbff93c4ff3e854775d~nt1TMYUVW3155431554eusmtrp1P;
	Wed, 26 Feb 2025 09:15:55 +0000 (GMT)
X-AuditID: cbfec7f5-e59c770000004fad-b0-67bedbccae7f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 40.E0.19920.BCBDEB76; Wed, 26
	Feb 2025 09:15:55 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250226091552eusmtip1c4c7761f98c6c76160fa00aed2a5042b~nt1QGGXF83166531665eusmtip1L;
	Wed, 26 Feb 2025 09:15:52 +0000 (GMT)
Message-ID: <1a6f693d-5ebe-46f5-be89-5edc0e77e316@samsung.com>
Date: Wed, 26 Feb 2025 10:15:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/23] iommu/pages: Remove iommu_alloc_page/pages()
To: Jason Gunthorpe <jgg@nvidia.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse
	<dwmw2@infradead.org>, Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>, Jonathan
	Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Krzysztof
	Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org, Hector Martin <marcan@marcan.st>, Palmer
	Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Sven Peter
	<sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>, Tomasz
	Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu
	Tsai <wens@csie.org>, Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, David
	Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <21-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVBUVRjGO/fevbsws3BlKY5Wg22YxQRCinMaya9JvUMzGs1kTM0oK1wX
	AlbbZROKmdD4WlAEwYKLLjvm8CEbrCxugYTthrBAgkAZ8hFfWwQIhECwLLKxXCz++z3v+5zz
	vO+ZOQLcbYjcJIiUxTJymSRaTDoThgZrq8/PPXVSv3N5G9GA2kCiqpZMgG7ZWD6y/uqCLp8F
	SJ99i0TZpTk4sg+N89DiLEIjheUA/bJcC1ASe41AqgIdH+U0X8VQW9sKVQ4/4CHDTBKJHg/Y
	cZTXVoeh3LoaEqlmWRK1PNDw0WjneRw1WxNQp7kDoBTWFaVcv4kh498WHhoZUq3kLWgAWuqx
	Y8haoybQbFEqQJk/vIespjYMJfUGINvCFXLvFtpiVGN0cscTktaqtYDWDZXx6EejowT9U9os
	n65m+/i0plJJ60u86cobKpJWNwXT+utf0H/p8wH9TVE1SV/4cpKku9iQdzd+6BwYzkRHfsrI
	t+0OdY4wTzwEp9u3xjWNDfISQfLmdOAkgNQOqG9IxNOBs8CNKgGwbzIHcGIWwLQ7lXxOzACo
	q1nkPT1iaDWuuYoBNKdp18Q0gAU1D/kOl5DaDTPU7atMUFugyngb5+obYFO+hXDws5Qn7O/O
	W/WIqCCoKrBjjovcKZsADo2WrzZwqg/AcZU3xx6w21KIOZik/GH6RDrpYCdqPzSXZGKcxxN+
	N3FldSNILTjD5OoLODf327CvW7fGIjjWWMXn+AXYknOe4A6kAqix9WOcyAIwcaQbcK5dsLd1
	cSVOsBLxGqyo2caV98Hi0mrMUYaUC+ya2MAN4QIvGb7GubIQpqW4ce5XINtY/l+s8X4HngXE
	7Lp3Ydetya5bh/0/VwOIG8CDUSpipIxiu4w546uQxCiUMqlv2KmYSrDyDVqWG+e+ByVj074m
	gAmACUABLnYXOkXWSt2E4ZL4zxj5qeNyZTSjMIHnBYTYQ3jtTrLUjZJKYpkohjnNyJ92MYHT
	pkRMlHD74uay6SP5J94kXpW9tEBdMvZOZsyFNptkP0Lvk4qLuQcihkVhHTfvBum3nhz+pP+P
	R74fHTv3VsjH/kvyg/mHXvynwbCdbfxgyis8v6Ki+J7yeNbv0aHio7Ga4GH7y/cfl9aH7Aya
	yhApc+Ldz8abeDqZX2B7SsBcqDbsOXNQXPAOs6g06mjC8J9qS175VOoemesRUS6e0aWNzD4s
	sN39bXDc6/CMPevqt4EZFwP2uN7r8fCMTjzIjyt8Y2R/lnC+VqeNaqvau9PPph4QaZrGijo/
	T0ga/KrlgNd81644TeSJqqVn6oURRv93fLqMGt/3LcfOzE+yh163Lvvsq39SNiAVE4oIib83
	LldI/gU/varkdQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t/xu7qnb+9LNzi3StfiwbxtbBZbTvcx
	Wmz9PYvd4udVPoupjYwWmyduZbOYuHIys8X/R69ZLX59sbB4Pn8do8WVf3sYLVpmLWKx6Jy9
	gd1i8qm5TBbnzwNZmx5fY7XY9rmFzeLTg//MFjPO72OymLJvF5tF55dZbBanry1gt3h5uYfZ
	4tTPGovLJy4xWrTN4rdoW7KRyeLghyesFs8fdQLt+7GA0eLP7f9MFj93zWOx+LKsndGib2+Q
	xc9D55ksWu6YWvz+MYfNQdXjycF5TB6tl/6yeayZt4bRY8Oj1aweb16+ZPE43PGF3WPnrLvs
	Hgs2lXpsXqHlsWlVJ5vHvJOBHpuX1Hu82DyT0WPxsp1sHr3N79g8bsyKCJCM0rMpyi8tSVXI
	yC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL0Ms48fYmY8FF9YqTrx6y
	NjC2KnQxcnJICJhIbDt3kLGLkYtDSGApo0T/l8vsEAkZiZPTGlghbGGJP9e62CCK3jNKLLw8
	nQUkwStgJ9E97yJYA4uAqkTnwd3MEHFBiZMzn4DViArIS9y/NQOsRljAS6Jz9n8mEFtE4C+H
	xMR+b5ChzAJ3GSUOLV7PBpIQEpjKKHFslQ+IzSwgLnHryXywBjYBQ4mut11gNZwCThInVvQx
	QdSYSXRt7WKEsOUltr+dwzyBUWgWkjtmIRk1C0nLLCQtCxhZVjGKpJYW56bnFhvqFSfmFpfm
	pesl5+duYgSmvm3Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYf
	YjQFBsZEZinR5Hxg8s0riTc0MzA1NDGzNDC1NDNWEud1u3w+TUggPbEkNTs1tSC1CKaPiYNT
	qoFpXur+pXc6TXhT/bYZpk0InGB9IsTsWvpbcd5APuNKY8XdpYqxy5mNlbWz12b3d7e+k19p
	122ov7wzeJZ7k5jY0+vafy7qLDWZrPbX2VNdL2X9dt/WZ+/aP2Y5GNXynNZmaF5UUaMT717x
	x+1sn6iJl987u/dO8QzW0Q/chWOyVv5rdziy5/jmKtmTd86xBtwN1rG8slGg40SSzZsbS2d/
	S7jv5fn8WCFv08TYphK3SYaC3IvfddqdmSN2VrdNONatdf/9n8s/KU7SOh65djPjDTWuGT7C
	Da1igRmrC5b/9me7vDX/7Skdmx3pZQZbZPz2nNXaHrJ7donPvNAYafP3J0vXRH8+t/yUsMIi
	ayWW4oxEQy3mouJEAGWS78wGBAAA
X-CMS-MailID: 20250226091555eucas1p1320cf0ed08b514c5259710476a930e60
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250225194054eucas1p14df0adad570f01d8a8f93a0042555a51
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20250225194054eucas1p14df0adad570f01d8a8f93a0042555a51
References: <CGME20250225194054eucas1p14df0adad570f01d8a8f93a0042555a51@eucas1p1.samsung.com>
	<21-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>

On 25.02.2025 20:39, Jason Gunthorpe wrote:
> A few small changes to the remaining drivers using these will allow
> them to be removed:
>
> - Exynos wants to allocate fixed 16K/8K allocations
> - Rockchip already has a define SPAGE_SIZE which is used by the
>    dma_map immediately following, using SPAGE_ORDER which is a lg2size
> - tegra has size constants already for its two allocations
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
For exynos-iommu:
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/iommu/exynos-iommu.c   |  4 ++--
>   drivers/iommu/iommu-pages.h    | 26 --------------------------
>   drivers/iommu/rockchip-iommu.c |  6 ++++--
>   drivers/iommu/tegra-smmu.c     |  4 ++--
>   4 files changed, 8 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 1019e08b43b71c..74337081278551 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -902,11 +902,11 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
>   	if (!domain)
>   		return NULL;
>   
> -	domain->pgtable = iommu_alloc_pages(GFP_KERNEL, 2);
> +	domain->pgtable = iommu_alloc_pages_sz(GFP_KERNEL, SZ_16K);
>   	if (!domain->pgtable)
>   		goto err_pgtable;
>   
> -	domain->lv2entcnt = iommu_alloc_pages(GFP_KERNEL, 1);
> +	domain->lv2entcnt = iommu_alloc_pages_sz(GFP_KERNEL, SZ_8K);
>   	if (!domain->lv2entcnt)
>   		goto err_counter;
>   
> diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
> index 3c4575d637da6d..4513fbc76260cd 100644
> --- a/drivers/iommu/iommu-pages.h
> +++ b/drivers/iommu/iommu-pages.h
> @@ -100,20 +100,6 @@ static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
>   	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
>   }
>   
> -/**
> - * iommu_alloc_pages - allocate a zeroed page of a given order
> - * @gfp: buddy allocator flags
> - * @order: page order
> - *
> - * returns the virtual address of the allocated page
> - * Prefer to use iommu_alloc_pages_lg2()
> - */
> -static inline void *iommu_alloc_pages(gfp_t gfp, int order)
> -{
> -	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp,
> -					 1 << (order + PAGE_SHIFT));
> -}
> -
>   /**
>    * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
>    *                          specific NUMA node
> @@ -141,16 +127,4 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
>   	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
>   }
>   
> -/**
> - * iommu_alloc_page - allocate a zeroed page
> - * @gfp: buddy allocator flags
> - *
> - * returns the virtual address of the allocated page
> - * Prefer to use iommu_alloc_pages_lg2()
> - */
> -static inline void *iommu_alloc_page(gfp_t gfp)
> -{
> -	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, PAGE_SIZE);
> -}
> -
>   #endif	/* __IOMMU_PAGES_H */
> diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
> index 798e85bd994d56..5af82072b03a17 100644
> --- a/drivers/iommu/rockchip-iommu.c
> +++ b/drivers/iommu/rockchip-iommu.c
> @@ -730,7 +730,8 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
>   	if (rk_dte_is_pt_valid(dte))
>   		goto done;
>   
> -	page_table = iommu_alloc_page(GFP_ATOMIC | rk_ops->gfp_flags);
> +	page_table = iommu_alloc_pages_sz(GFP_ATOMIC | rk_ops->gfp_flags,
> +					  SPAGE_SIZE);
>   	if (!page_table)
>   		return ERR_PTR(-ENOMEM);
>   
> @@ -1064,7 +1065,8 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
>   	 * Each level1 (dt) and level2 (pt) table has 1024 4-byte entries.
>   	 * Allocate one 4 KiB page for each table.
>   	 */
> -	rk_domain->dt = iommu_alloc_page(GFP_KERNEL | rk_ops->gfp_flags);
> +	rk_domain->dt = iommu_alloc_pages_sz(GFP_KERNEL | rk_ops->gfp_flags,
> +					     SPAGE_SIZE);
>   	if (!rk_domain->dt)
>   		goto err_free_domain;
>   
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 844682a41afa66..a9c35efde56969 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -295,7 +295,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
>   
>   	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
>   
> -	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
> +	as->pd = iommu_alloc_pages_sz(GFP_KERNEL | __GFP_DMA, SMMU_SIZE_PD);
>   	if (!as->pd) {
>   		kfree(as);
>   		return NULL;
> @@ -695,7 +695,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
>   	if (gfpflags_allow_blocking(gfp))
>   		spin_unlock_irqrestore(&as->lock, *flags);
>   
> -	pt = iommu_alloc_page(gfp | __GFP_DMA);
> +	pt = iommu_alloc_pages_sz(gfp | __GFP_DMA, SMMU_SIZE_PT);
>   
>   	if (gfpflags_allow_blocking(gfp))
>   		spin_lock_irqsave(&as->lock, *flags);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


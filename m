Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3D7243965
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741784350; cv=none; b=T/Kjr0oCnLcN8WawxMVRE/ME50050Bnl2Iv+9iraBiiIc5TcSeIaFLcj5I+T0bCz07HzEa27I7sRk9kPbXfIUoBR+kd+IXTHmC33Zaa8TFx/TxR7yMv0ZnNCZ1VbPeJH4I1HVEnbIHC02a62kC1cnqYQka4akot22hOdOi67vzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741784350; c=relaxed/simple;
	bh=OXwVk7cSVE+TDqEc3HVraviwVrXEEbqZxuHx7kPXpwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3bu1vKa0pFdhGXe2Je4/+jHD9iZpz38QzZPT5OKCQuXcp+/6To54TJJRC2ARVtAE9jf6c3TDFlE6TcnODDfAp9yjQZDSfRX1CRo8ZD45uUGBVYlE7ZDXYYDT/Ei7eh3ASvkrTj1S69qToKq3mFaU0L7zMc0MpbdadNZnbIyQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D9Qz6xkS; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D9Qz6xkS"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-438d9c391fcso45265e9.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 05:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741784345; x=1742389145; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4hVHQpBdFL8A1OMCaWXXGUDiGHIY98dt+fAh5aFuAqk=;
        b=D9Qz6xkSOrH0IqrYZ9Obk6GawBoUfMbuO9z0siGRbezV/t7WTxAeeo74IEkSQsF+Bk
         2PJSFo5Wnlt6UGbdLC8sBs1CUAFFqOPceQSVAAgswovtLCJg/iaovRMXhGuk3jOjGR3n
         OivJNmEUgeRDXLnFH6Xc2Ku4t4L01dMe6iHMbCff+5Mty4681527opc+0LSSIeoG16Od
         DhJYVZ6ngaWDld8kPGjZnmdIBJ3ZEtSrRS3PHlc22EHemD1YwW/BUSe7IOuNyvSRrlM3
         +qW1p5njtIaqyQ3rb7Sp844lCJCqOkMnJ2Crf3mBY7eHbxCWoIhuHkNuh6Sh29iwzdk2
         LY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741784345; x=1742389145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4hVHQpBdFL8A1OMCaWXXGUDiGHIY98dt+fAh5aFuAqk=;
        b=Ydqwz+qnsHymlx0nBZ3UaQ3D+aNq7AqLmcESXK2FSgha1vvY5elxejCqSidARvtKIs
         AkouxodcNYZDsl+PO/Zhk9LBUEEn+grmpntTt32wAUC5t1IExg7F4St2TdEJM8ZzoJZb
         75s7yDLwzUt4N3JbpC1KKaN1kqAxxRCgn6Q+LU9gUKxCrpZt/dJhYLVl0HO8i5eAMHew
         lEC6WwqtJdQfnJv6AHA0n0tEPEHenJzTGV+GW1OhB06zCpdkETjfj12GlZRvQyGTqYiQ
         Yh4FfDHf3VdTNU8XZcRUOLDHeJ1fFjn7D6fSEY27rxSTPrZvB98oBhCy7Y1um4YejFio
         oJvg==
X-Forwarded-Encrypted: i=1; AJvYcCWR2xeKt+NwtHnLBwctUZxM3pj9gWvM5Tkc6XuEft4iop3B+XcX7wdGfB2eRSKHuKRd1e64LVGZ@lists.linux.dev
X-Gm-Message-State: AOJu0YysbbNj8MXpQUzJoNVm0ydNgA9TVAvfmG9w6mVVEEKkSfMZwrzc
	Cie6EQ6czmbVUJfLQlXrLw5T0dgKRz7vPmCZ2UczZqTuA3HD1bumKwWVwvUccw==
X-Gm-Gg: ASbGnctSl9ocUEECJY2+AN2zY5EIvR5wL0Sp2HipjVjXm7X+TcvWnorgukh7v5g6OCZ
	YP/BejUHOv92dQSG7FEzvPLz7EbuBWtBTqjBvqbNJTlUEJAaFo1bbZiOzSOffFlWRHvqCuORABd
	DJtMRn3xt2/B+QtI8NykJ2suoWycvj5EmlgN5dmn2vqDtMkOUz7gc6TACKK7W+67as7LFagS2Om
	P3OzIG4ivAY9ugv4eFanvjADn1DI3nTx8IZMTWapqa8DDpVXgSjOMufSIhe5kpq7W0jNJX76tOb
	OXayrqN2bAwbefFCwKr43YDYd5tmSbz9bhGoDnU+5MSH50rffVVEHSqMd16OcLuNFQy+wbRjX8A
	Xy2nu
X-Google-Smtp-Source: AGHT+IGv3VwL/nDTfZJkT02Z+Ln6cpEc0JtjX8qb40ZbVAGSWsBoi80OOQ8vIb/VOjdd5NkKwgkkDw==
X-Received: by 2002:a05:600c:1c11:b0:439:9434:1b66 with SMTP id 5b1f17b1804b1-43d0a5e3299mr1028055e9.1.1741784344924;
        Wed, 12 Mar 2025 05:59:04 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3947a24449bsm1688998f8f.45.2025.03.12.05.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 05:59:04 -0700 (PDT)
Date: Wed, 12 Mar 2025 12:59:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
Message-ID: <Z9GFFBvUFg7a9WEg@google.com>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>

On Tue, Feb 25, 2025 at 03:39:37PM -0400, Jason Gunthorpe wrote:
> Convert most of the places calling get_order() as an argument to the
> iommu-pages allocator into order_base_2() or the _sz flavour
> instead. These places already have an exact size, there is no particular
> reason to use order here.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/init.c        | 29 +++++++++++++++--------------
>  drivers/iommu/intel/dmar.c      |  6 +++---
>  drivers/iommu/io-pgtable-arm.c  |  3 +--
>  drivers/iommu/io-pgtable-dart.c | 12 +++---------
>  drivers/iommu/sun50i-iommu.c    |  4 ++--
>  5 files changed, 24 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index e3f4283ebbc201..a5720df7b22397 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -635,8 +635,8 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
>  /* Allocate per PCI segment device table */
>  static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
>  {
> -	pci_seg->dev_table = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
> -					       get_order(pci_seg->dev_table_size));
> +	pci_seg->dev_table = iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32,
> +						  pci_seg->dev_table_size);
>  	if (!pci_seg->dev_table)
>  		return -ENOMEM;
>  
> @@ -716,8 +716,7 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
>   */
>  static int __init alloc_command_buffer(struct amd_iommu *iommu)
>  {
> -	iommu->cmd_buf = iommu_alloc_pages(GFP_KERNEL,
> -					   get_order(CMD_BUFFER_SIZE));
> +	iommu->cmd_buf = iommu_alloc_pages_sz(GFP_KERNEL, CMD_BUFFER_SIZE);
>  
>  	return iommu->cmd_buf ? 0 : -ENOMEM;
>  }
> @@ -820,14 +819,16 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
>  void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
>  				  size_t size)
>  {
> -	int order = get_order(size);
> -	void *buf = iommu_alloc_pages(gfp, order);
> +	void *buf;
>  
> -	if (buf &&
> -	    check_feature(FEATURE_SNP) &&
> -	    set_memory_4k((unsigned long)buf, (1 << order))) {
> +	size = PAGE_ALIGN(size);
> +	buf = iommu_alloc_pages_sz(gfp, size);
> +	if (!buf)
> +		return NULL;
> +	if (check_feature(FEATURE_SNP) &&
> +	    set_memory_4k((unsigned long)buf, size / PAGE_SIZE)) {
>  		iommu_free_pages(buf);
> -		buf = NULL;
> +		return NULL;
>  	}
>  
>  	return buf;
> @@ -922,11 +923,11 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
>  	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
>  		return 0;
>  
> -	iommu->ga_log = iommu_alloc_pages(GFP_KERNEL, get_order(GA_LOG_SIZE));
> +	iommu->ga_log = iommu_alloc_pages_sz(GFP_KERNEL, GA_LOG_SIZE);
>  	if (!iommu->ga_log)
>  		goto err_out;
>  
> -	iommu->ga_log_tail = iommu_alloc_pages(GFP_KERNEL, get_order(8));
> +	iommu->ga_log_tail = iommu_alloc_pages_sz(GFP_KERNEL, 8);
>  	if (!iommu->ga_log_tail)
>  		goto err_out;
>  
> @@ -1021,8 +1022,8 @@ static bool __copy_device_table(struct amd_iommu *iommu)
>  	if (!old_devtb)
>  		return false;
>  
> -	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
> -						     get_order(pci_seg->dev_table_size));
> +	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
> +		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
>  	if (pci_seg->old_dev_tbl_cpy == NULL) {
>  		pr_err("Failed to allocate memory for copying old device table!\n");
>  		memunmap(old_devtb);
> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index c812c83d77da10..4c7ce92acf6976 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -1681,7 +1681,6 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>  {
>  	struct q_inval *qi;
>  	void *desc;
> -	int order;
>  
>  	if (!ecap_qis(iommu->ecap))
>  		return -ENOENT;
> @@ -1702,8 +1701,9 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>  	 * Need two pages to accommodate 256 descriptors of 256 bits each
>  	 * if the remapping hardware supports scalable mode translation.
>  	 */
> -	order = ecap_smts(iommu->ecap) ? 1 : 0;
> -	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
> +	desc = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
> +					 ecap_smts(iommu->ecap) ? SZ_8K :
> +								  SZ_4K);
>  	if (!desc) {
>  		kfree(qi);
>  		iommu->qi = NULL;
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 08d0f62abe8a09..d13149ec5be77e 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -263,14 +263,13 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
>  				    void *cookie)
>  {
>  	struct device *dev = cfg->iommu_dev;
> -	int order = get_order(size);
>  	dma_addr_t dma;
>  	void *pages;
>  
>  	if (cfg->alloc)
>  		pages = cfg->alloc(cookie, size, gfp);
>  	else
> -		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
> +		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);

Although, the current implementation of iommu_alloc_pages_node_sz() would round
the size to order, but this is not correct according to the API definition
"The returned allocation is round_up_pow_two(size) big, and is physically aligned
to its size."

SMMUv3 has special alignment with small number of entries at the start level,
according the manual:
	A 64-byte minimum alignment on starting-level translation table addresses
	is imposed when TG0 selects 64KB granules and the effective IPS value
	indicates 52-bit output. In this case bits [5:0] are treated as zero.

And according to the Arm Arm (ex D24.2.195 in Version L)
	- Bits A[(x-1):0] of the stage 1 translation table base address are zero.
	... The smallest permitted value of x is 5.
Which 32 bytes

For a case as (which is valid in Linux)
- S1 with IAS 40-bits and 4K, start level has 2 entries (16 bytes) but alignment
  must be at least 32 bytes.

- Similarly with 16K and 48 bits.

I'd say we can align the size or use min with 64 bytes before calling the
function would be enough (or change the API to state that allocations
are rounded to order)

Thanks,
Mostafa

>  
>  	if (!pages)
>  		return NULL;
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index ebf330e67bfa30..a0988669bb951a 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -107,13 +107,6 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
>  	return paddr;
>  }
>  
> -static void *__dart_alloc_pages(size_t size, gfp_t gfp)
> -{
> -	int order = get_order(size);
> -
> -	return iommu_alloc_pages(gfp, order);
> -}
> -
>  static int dart_init_pte(struct dart_io_pgtable *data,
>  			     unsigned long iova, phys_addr_t paddr,
>  			     dart_iopte prot, int num_entries,
> @@ -255,7 +248,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  
>  	/* no L2 table present */
>  	if (!pte) {
> -		cptep = __dart_alloc_pages(tblsz, gfp);
> +		cptep = iommu_alloc_pages_sz(gfp, tblsz);
>  		if (!cptep)
>  			return -ENOMEM;
>  
> @@ -412,7 +405,8 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
>  	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
>  
>  	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
> -		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL);
> +		data->pgd[i] =
> +			iommu_alloc_pages_sz(GFP_KERNEL, DART_GRANULE(data));
>  		if (!data->pgd[i])
>  			goto out_free_data;
>  		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index 6385560dbc3fb0..76c9620af4bba8 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -690,8 +690,8 @@ sun50i_iommu_domain_alloc_paging(struct device *dev)
>  	if (!sun50i_domain)
>  		return NULL;
>  
> -	sun50i_domain->dt = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
> -					      get_order(DT_SIZE));
> +	sun50i_domain->dt =
> +		iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32, DT_SIZE);
>  	if (!sun50i_domain->dt)
>  		goto err_free_domain;
>  
> -- 
> 2.43.0
> 

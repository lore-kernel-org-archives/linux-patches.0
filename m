Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCAB23E23F
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 11:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741779869; cv=none; b=CUN9x7q3dxEQlC/GfMAYwXB1qb/z+f8T+dG0hN7IL4CiMZxvZsIkmTB+T+PJuj5jPcR+Zss/Yv5Egr+k3RxEYIKXHzhR1FjPkf4uu3iP4/59iemYHvG5bg3V8k/P+TQ2kzS6KNTFlx4P79ut5FvIa2wJ6Np8zEbGRN5NhvV4lWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741779869; c=relaxed/simple;
	bh=P0NPEuvXehyb3R0NE0N+AWhENmnBjnIVY29yhuJ+xh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bigaREsq8sywzXi6ZxQt22mUaChW7tmuyfzhXA6fGzgXVA95NKYUviF3j0EKqwMyIPFcTU1b5fjcfkgfMYMA9dLavkutWMtiww+L4Q+0ubY1MPCnGZf7Y8zTran4clt6F2EzvZq4dpKFgLsA4Gq+8R0vccNXC9EVUZy6lHfvBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLimvH4y; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLimvH4y"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-438d9c391fcso41015e9.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 04:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741779865; x=1742384665; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztC6TyGPn8HN7qvx3r0adwSfOw9X1SdqpmyY8+RWC3k=;
        b=ZLimvH4yCJV06ZcqeIwxMQdLpqgXp/nXLtFif+s7Wma3HaK7tMSI6j+vWt6GyRwtd2
         /H8YCWvqZtR31PrUn7t6lwILqKIPUVNOgmdAiY8jwjGCpc1JX9pQ04eXb9QXFt7zmxr1
         f84irVVk65Q+1YEiTYeRhkq3m+8r4DwuJw9RvrsLMgII+HpYOgKc/lXGfoCtmkgdo9Zd
         PcxcdblwnqJpvSONuAQYxuyu7ukK+5SwYaw4zIsGKV0/h++4V98WZTg2E+2IHoYB8b59
         HvU0VIIrvKgq0u44dcJVCj0YLZ9Jx6qRxlh1JioreeujFfh0SZy+wvvYJgxUvbfLp92r
         0hkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741779865; x=1742384665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztC6TyGPn8HN7qvx3r0adwSfOw9X1SdqpmyY8+RWC3k=;
        b=D3JKcQfY9BgZo1NEnC1kZyplp2uJd2O/lTN5fhhWLNA2hs29TV2OOjlt26dCm30/w9
         6ATp+66pWIuI0Z5flgjn+I07GRhxLpM4ueA4vnMaFzSOfHANmPef2TyRAosl+BS44lrC
         VbqmSwsHi7wSx6Aeaym2bHPEBLWnAyLebIm2SKxVzr7ECZ2c0pY708CC3ETptN76BtFE
         e6A8PFJGugYjFmvbBwj25WA7jde7q6dZSElpFZwYp7yNPLXGnnG6RU51WWrxf0T/sezg
         +JHiyoj1ezOVFOEkdDEcTX+b4XFCa+oF+dScD3W/lPRz6Ry90nDWYk8fsRwfPt00Mqf1
         WUIA==
X-Forwarded-Encrypted: i=1; AJvYcCVcsvmvlSrLCDzwQMARkMQRWwFBwme+usbQB4wJXUMEqsjzCGru7cop/Ogq+vFHvp9T/QnaSYip@lists.linux.dev
X-Gm-Message-State: AOJu0YwX/6QoooZwVF63zWnuIc4yrrE1mm8u9ANSQLYaHC10XbLzosCb
	kEwgWgH0Rw8uqC+Y7JXlRNdeTOl7RHAmBc7ODAnIYJmd1AHLuMBtFj57mv4O2w==
X-Gm-Gg: ASbGncv2FlRwy0wEMjnVQ1qbGZHSVpfPhYTvGJDrG7TIFbPD5w30DCybLxdJ2P3qKqP
	LptY9D/b1ZNpegLkDyfn0dvrHzVdxsnJxlWu+YSjneC2nXR8YEBotEW+IbVUioXN6WRw6t4HZWD
	jnoVHe1N+A3ToVO9riX8Lmwc8qYsR/benUZ7zsySv68sJ2cplaNdf7xWmLWe7cW4D3pOSazeIWn
	maG1tA2ojn5ftFZ4qs9zrIXRifKapoQCfj0zvdKqpo0LpjX+ADPRJH79iFjPUOrxM8uthDDzz3J
	hQ684/bKZZBc5bA3vAameXtwP7y+G0WZtkVHRa4QX2vYHT/U5zBgekm7jUQKzuME5tZa3gm+1cw
	zVvuv
X-Google-Smtp-Source: AGHT+IFOC+WzkzIkaDYmFvYURyzlmZIIdd06+VT8kwhTpj+efwMx5qrVlyUWLRP/E95iBlLvUPXLVA==
X-Received: by 2002:a05:600c:c84:b0:43b:c396:7405 with SMTP id 5b1f17b1804b1-43d0a5fd606mr1026575e9.7.1741779865249;
        Wed, 12 Mar 2025 04:44:25 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a72ea88sm19001575e9.7.2025.03.12.04.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 04:44:24 -0700 (PDT)
Date: Wed, 12 Mar 2025 11:44:20 +0000
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
Subject: Re: [PATCH v3 06/23] iommu/pages: Remove iommu_free_page()
Message-ID: <Z9FzlCfkRzDnvHuJ@google.com>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <6-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>

On Tue, Feb 25, 2025 at 03:39:23PM -0400, Jason Gunthorpe wrote:
> Use iommu_free_pages() instead.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  drivers/iommu/amd/init.c          |  2 +-
>  drivers/iommu/amd/io_pgtable.c    |  4 ++--
>  drivers/iommu/amd/io_pgtable_v2.c |  8 ++++----
>  drivers/iommu/amd/iommu.c         |  4 ++--
>  drivers/iommu/intel/dmar.c        |  4 ++--
>  drivers/iommu/intel/iommu.c       | 12 ++++++------
>  drivers/iommu/intel/pasid.c       |  4 ++--
>  drivers/iommu/iommu-pages.h       |  9 ---------
>  drivers/iommu/riscv/iommu.c       |  6 +++---
>  drivers/iommu/rockchip-iommu.c    |  8 ++++----
>  drivers/iommu/tegra-smmu.c        | 12 ++++++------
>  11 files changed, 32 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index f47ff0e0c75f4e..73ebcb958ad864 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -955,7 +955,7 @@ static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>  static void __init free_cwwb_sem(struct amd_iommu *iommu)
>  {
>  	if (iommu->cmd_sem)
> -		iommu_free_page((void *)iommu->cmd_sem);
> +		iommu_free_pages((void *)iommu->cmd_sem);
>  }
>  
>  static void iommu_enable_xt(struct amd_iommu *iommu)
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index f3399087859fd1..025d8a3fe9cb78 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -153,7 +153,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
>  
>  out:
>  	spin_unlock_irqrestore(&domain->lock, flags);
> -	iommu_free_page(pte);
> +	iommu_free_pages(pte);
>  
>  	return ret;
>  }
> @@ -229,7 +229,7 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
>  
>  			/* pte could have been changed somewhere. */
>  			if (!try_cmpxchg64(pte, &__pte, __npte))
> -				iommu_free_page(page);
> +				iommu_free_pages(page);
>  			else if (IOMMU_PTE_PRESENT(__pte))
>  				*updated = true;
>  
> diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
> index c616de2c5926ec..cce3fc9861ef77 100644
> --- a/drivers/iommu/amd/io_pgtable_v2.c
> +++ b/drivers/iommu/amd/io_pgtable_v2.c
> @@ -121,10 +121,10 @@ static void free_pgtable(u64 *pt, int level)
>  		if (level > 2)
>  			free_pgtable(p, level - 1);
>  		else
> -			iommu_free_page(p);
> +			iommu_free_pages(p);
>  	}
>  
> -	iommu_free_page(pt);
> +	iommu_free_pages(pt);
>  }
>  
>  /* Allocate page table */
> @@ -159,7 +159,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
>  			__npte = set_pgtable_attr(page);
>  			/* pte could have been changed somewhere. */
>  			if (!try_cmpxchg64(pte, &__pte, __npte))
> -				iommu_free_page(page);
> +				iommu_free_pages(page);
>  			else if (IOMMU_PTE_PRESENT(__pte))
>  				*updated = true;
>  
> @@ -181,7 +181,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
>  		if (pg_size == IOMMU_PAGE_SIZE_1G)
>  			free_pgtable(__pte, end_level - 1);
>  		else if (pg_size == IOMMU_PAGE_SIZE_2M)
> -			iommu_free_page(__pte);
> +			iommu_free_pages(__pte);
>  	}
>  
>  	return pte;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index b48a72bd7b23df..e23d104d177ad9 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1812,7 +1812,7 @@ static void free_gcr3_tbl_level1(u64 *tbl)
>  
>  		ptr = iommu_phys_to_virt(tbl[i] & PAGE_MASK);
>  
> -		iommu_free_page(ptr);
> +		iommu_free_pages(ptr);
>  	}
>  }
>  
> @@ -1845,7 +1845,7 @@ static void free_gcr3_table(struct gcr3_tbl_info *gcr3_info)
>  	/* Free per device domain ID */
>  	pdom_id_free(gcr3_info->domid);
>  
> -	iommu_free_page(gcr3_info->gcr3_tbl);
> +	iommu_free_pages(gcr3_info->gcr3_tbl);
>  	gcr3_info->gcr3_tbl = NULL;
>  }
>  
> diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> index 9f424acf474e94..c812c83d77da10 100644
> --- a/drivers/iommu/intel/dmar.c
> +++ b/drivers/iommu/intel/dmar.c
> @@ -1187,7 +1187,7 @@ static void free_iommu(struct intel_iommu *iommu)
>  	}
>  
>  	if (iommu->qi) {
> -		iommu_free_page(iommu->qi->desc);
> +		iommu_free_pages(iommu->qi->desc);
>  		kfree(iommu->qi->desc_status);
>  		kfree(iommu->qi);
>  	}
> @@ -1714,7 +1714,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
>  
>  	qi->desc_status = kcalloc(QI_LENGTH, sizeof(int), GFP_ATOMIC);
>  	if (!qi->desc_status) {
> -		iommu_free_page(qi->desc);
> +		iommu_free_pages(qi->desc);
>  		kfree(qi);
>  		iommu->qi = NULL;
>  		return -ENOMEM;
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index cc46098f875b16..1e73bfa00329ae 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -571,17 +571,17 @@ static void free_context_table(struct intel_iommu *iommu)
>  	for (i = 0; i < ROOT_ENTRY_NR; i++) {
>  		context = iommu_context_addr(iommu, i, 0, 0);
>  		if (context)
> -			iommu_free_page(context);
> +			iommu_free_pages(context);
>  
>  		if (!sm_supported(iommu))
>  			continue;
>  
>  		context = iommu_context_addr(iommu, i, 0x80, 0);
>  		if (context)
> -			iommu_free_page(context);
> +			iommu_free_pages(context);
>  	}
>  
> -	iommu_free_page(iommu->root_entry);
> +	iommu_free_pages(iommu->root_entry);
>  	iommu->root_entry = NULL;
>  }
>  
> @@ -744,7 +744,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
>  			tmp = 0ULL;
>  			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
>  				/* Someone else set it while we were thinking; use theirs. */
> -				iommu_free_page(tmp_page);
> +				iommu_free_pages(tmp_page);
>  			else
>  				domain_flush_cache(domain, pte, sizeof(*pte));
>  		}
> @@ -857,7 +857,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
>  		      last_pfn < level_pfn + level_size(level) - 1)) {
>  			dma_clear_pte(pte);
>  			domain_flush_cache(domain, pte, sizeof(*pte));
> -			iommu_free_page(level_pte);
> +			iommu_free_pages(level_pte);
>  		}
>  next:
>  		pfn += level_size(level);
> @@ -881,7 +881,7 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
>  
>  	/* free pgd */
>  	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
> -		iommu_free_page(domain->pgd);
> +		iommu_free_pages(domain->pgd);
>  		domain->pgd = NULL;
>  	}
>  }
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 00da94b1c4c907..4249f12db7fc43 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -96,7 +96,7 @@ void intel_pasid_free_table(struct device *dev)
>  	max_pde = pasid_table->max_pasid >> PASID_PDE_SHIFT;
>  	for (i = 0; i < max_pde; i++) {
>  		table = get_pasid_table_from_pde(&dir[i]);
> -		iommu_free_page(table);
> +		iommu_free_pages(table);
>  	}
>  
>  	iommu_free_pages(pasid_table->table);
> @@ -160,7 +160,7 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
>  		tmp = 0ULL;
>  		if (!try_cmpxchg64(&dir[dir_index].val, &tmp,
>  				   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
> -			iommu_free_page(entries);
> +			iommu_free_pages(entries);
>  			goto retry;
>  		}
>  		if (!ecap_coherent(info->iommu->ecap)) {
> diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
> index 88587da1782b94..fcd17b94f7b830 100644
> --- a/drivers/iommu/iommu-pages.h
> +++ b/drivers/iommu/iommu-pages.h
> @@ -122,15 +122,6 @@ static inline void iommu_free_pages(void *virt)
>  	put_page(page);
>  }
>  
> -/**
> - * iommu_free_page - free page
> - * @virt: virtual address of the page to be freed.
> - */
> -static inline void iommu_free_page(void *virt)
> -{
> -	iommu_free_pages(virt);
> -}
> -
>  /**
>   * iommu_put_pages_list - free a list of pages.
>   * @page: the head of the lru list to be freed.
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index 1868468d018a28..4fe07343d84e61 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -1105,7 +1105,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
>  	if (freelist)
>  		list_add_tail(&virt_to_page(ptr)->lru, freelist);
>  	else
> -		iommu_free_page(ptr);
> +		iommu_free_pages(ptr);
>  }
>  
>  static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
> @@ -1148,7 +1148,7 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
>  			old = pte;
>  			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
>  			if (cmpxchg_relaxed(ptr, old, pte) != old) {
> -				iommu_free_page(addr);
> +				iommu_free_pages(addr);
>  				goto pte_retry;
>  			}
>  		}
> @@ -1393,7 +1393,7 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
>  	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
>  					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
>  	if (domain->pscid < 0) {
> -		iommu_free_page(domain->pgd_root);
> +		iommu_free_pages(domain->pgd_root);
>  		kfree(domain);
>  		return ERR_PTR(-ENOMEM);
>  	}
> diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
> index 323cc665c35703..798e85bd994d56 100644
> --- a/drivers/iommu/rockchip-iommu.c
> +++ b/drivers/iommu/rockchip-iommu.c
> @@ -737,7 +737,7 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
>  	pt_dma = dma_map_single(dma_dev, page_table, SPAGE_SIZE, DMA_TO_DEVICE);
>  	if (dma_mapping_error(dma_dev, pt_dma)) {
>  		dev_err(dma_dev, "DMA mapping error while allocating page table\n");
> -		iommu_free_page(page_table);
> +		iommu_free_pages(page_table);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> @@ -1086,7 +1086,7 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
>  	return &rk_domain->domain;
>  
>  err_free_dt:
> -	iommu_free_page(rk_domain->dt);
> +	iommu_free_pages(rk_domain->dt);
>  err_free_domain:
>  	kfree(rk_domain);
>  
> @@ -1107,13 +1107,13 @@ static void rk_iommu_domain_free(struct iommu_domain *domain)
>  			u32 *page_table = phys_to_virt(pt_phys);
>  			dma_unmap_single(dma_dev, pt_phys,
>  					 SPAGE_SIZE, DMA_TO_DEVICE);
> -			iommu_free_page(page_table);
> +			iommu_free_pages(page_table);
>  		}
>  	}
>  
>  	dma_unmap_single(dma_dev, rk_domain->dt_dma,
>  			 SPAGE_SIZE, DMA_TO_DEVICE);
> -	iommu_free_page(rk_domain->dt);
> +	iommu_free_pages(rk_domain->dt);
>  
>  	kfree(rk_domain);
>  }
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index c134647292fb22..844682a41afa66 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -303,7 +303,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
>  
>  	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
>  	if (!as->count) {
> -		iommu_free_page(as->pd);
> +		iommu_free_pages(as->pd);
>  		kfree(as);
>  		return NULL;
>  	}
> @@ -311,7 +311,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
>  	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
>  	if (!as->pts) {
>  		kfree(as->count);
> -		iommu_free_page(as->pd);
> +		iommu_free_pages(as->pd);
>  		kfree(as);
>  		return NULL;
>  	}
> @@ -608,14 +608,14 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
>  		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
>  				     DMA_TO_DEVICE);
>  		if (dma_mapping_error(smmu->dev, dma)) {
> -			iommu_free_page(pt);
> +			iommu_free_pages(pt);
>  			return NULL;
>  		}
>  
>  		if (!smmu_dma_addr_valid(smmu, dma)) {
>  			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
>  					 DMA_TO_DEVICE);
> -			iommu_free_page(pt);
> +			iommu_free_pages(pt);
>  			return NULL;
>  		}
>  
> @@ -656,7 +656,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
>  
>  		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
>  				 DMA_TO_DEVICE);
> -		iommu_free_page(pt);
> +		iommu_free_pages(pt);
>  		as->pts[pde] = NULL;
>  	}
>  }
> @@ -707,7 +707,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
>  	 */
>  	if (as->pts[pde]) {
>  		if (pt)
> -			iommu_free_page(pt);
> +			iommu_free_pages(pt);
>  
>  		pt = as->pts[pde];
>  	}
> -- 
> 2.43.0
> 

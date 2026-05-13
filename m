Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2097A4CA265
	for <patches@lists.linux.dev>; Wed, 13 May 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685116; cv=none; b=aBji5tr84Fr1iyuIbLnrIOVy0Ws5XHNG7ezrfnfvYuYYgzVF2M+7CF1Lc7ui1D6bz47FoinSbdKLXkQr9FpNarwtAvBuQDWJnxh97GtpRzQW8l9xMz1YNarfhwNNbkIajEVKPL90pGOrz5bUB2JwidtDCQLsznudWbZ/buRPOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685116; c=relaxed/simple;
	bh=Lfm5qwtvKGVGvwVglM1WEBRrmbR9xt1BsC+h44z8tCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AByXZXpvJFTCev0WvO0TsX2r4RBebcutlVO6TQIi8o4fniBWdjD941l/dgZtzEpiQt9HeY5Yp84vhSnJBiUN4D0iSCl04+PWIUQYqQ9P5loVyl0yATuSR6hX6YqV9kMqRQVaiOVmfH5ZaC2/sY87IADdgjQIEufg/zqa+NKMwbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MOKZYydo; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MOKZYydo"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50e61648f10so12891cf.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778685114; x=1779289914; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fWAe8c+ElCoD6sU6NETEOpCBbfD46C5Crtt3s27wLQM=;
        b=MOKZYydo2K7xUxqe0x/jRAwioPUBE9Irdf9BrAq5l+Oyi0B7ETRFe8t3/iaK0ZcijK
         yR5d+KlH8UHBoDlfy29b6vVkw4THq3nFaOtzF52Z12JiQ0bww2U2w0mC42Ff7foAICGJ
         vU92r1XI6R/4OjKFlLDPxN1kV2QyYZRBZ0XL3FIsGxh9ssICwPPnNQjzgHTnMuKI6t+o
         s76lzQxJv36sABq71u0hcimGlwp/pJHqk4TtHSbKv0XRhy73QIiT9iRsRGtPYvJHINjm
         Z2oaKNeZTNyflIePVbWE3MeFWi1qlBpISQdrQ4RKCcwnvqgDlHD8bvC487TkduosyFXC
         qNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778685114; x=1779289914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWAe8c+ElCoD6sU6NETEOpCBbfD46C5Crtt3s27wLQM=;
        b=OJjuXWdXvE4Qyh91ke8I29guUi70Cg4SFcmwEERx/LhcFdL8TlUwQGP3oJ+AJt13Vg
         G1JGAohTPLeBmFy5MRYx//wQvE5a1KNbPNGCmfpGOwBrqZrJ+jbcBaKU3wkUj5F9fbDP
         iPJq5jBiHICbe3cHF0ExVd2KAadRXX/JA8R4GVYANA2f+1btVAQFOviH4M/sOO/I41K8
         GrPna7Yl+1GfocBtvrqkeOF5YuH6Se3Zex60t+zkawiL2kiQPv8vqWEW3uLVTI1R8BQ1
         V63jZvn5nCKq5E169RxxCRhd6GqwOe7d3FP2rZkG2TgW9zYfhzJSmXSJAHoj/Fl13kJ4
         WcAw==
X-Forwarded-Encrypted: i=1; AFNElJ8ULd0OwqtKr6J75TpTQCpE+rQUi5ww6UkpDNgCGki2gbg4a6fn82usn1BnxY8oykrPRrusW8s2@lists.linux.dev
X-Gm-Message-State: AOJu0YxPlKE4aTkB/G+Gqxv0wy1p/qnbw4dQauN5031IJejAsZ5nmxRD
	CerRYOEo40CFVKfg6gGI7N5dNUP7UKH/sGa/ctXFRJx4Pn3jic+sci/EAmJOH6gxxw==
X-Gm-Gg: Acq92OHBOnrkKpjYAJDkTJOr3pZqkWPZZk08YYufxcYlR1nxc4cttjnNkdHDTG1H+I5
	1s0OLOgJXNk80fV4ZQgbNLv8XWEQeCZsz3Z9n1QAh5bg0i9R9LR2aHU6v1MeXVJu7KCpLnD57Dy
	jq/vVilxk2Q/KaMSiDZUPmy1vwHhUyYH3Q4pqiQ1A+KryNsR+Ra//NvXO0x380bVWDrWb2RGww4
	yrTTjfWjsj3pF+M9YiGg0xx62UJoIJ+wOvv6OD2SK+EcTgHSkpMlK/Xr6h5cMq1T8WV9fP2Pf2g
	fjLZ5GJF9xUjeox04Yld/R/TCCD0fGQQmDLCQtAx3m2V2Qp8amy++Mx2sd47ELuGCs8IGHH5l1E
	KmtSuawBYtigRKoY/jlmvUfIru8HO7xCsE1P9/1nUOeeKyENptKk+ib4I9rJa/eTsjRagcyr8hW
	pSRYmzD56AZ44H5kuolZhSOClUSfKD32vyFSf2+ONEAmffzRiaUJ9OxCtgVq42a1T/rIo=
X-Received: by 2002:ac8:5996:0:b0:509:1d4b:f86f with SMTP id d75a77b69052e-5162b156ecemr16742311cf.14.1778685113161;
        Wed, 13 May 2026 08:11:53 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53d450dcbsm376655416d6.45.2026.05.13.08.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 08:11:52 -0700 (PDT)
Date: Wed, 13 May 2026 15:11:44 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 2/5] iommu: Fix up map/unmap debugging for iommupt
 domains
Message-ID: <agSUsGB2MabPq_qm@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:14PM -0300, Jason Gunthorpe wrote:
> Sashiko noticed a few issues in this path, and a few more were
> found on review. Tidy them up further. These are intertwined
> because the debug code depends on some of the WARN_ONs to function
> right:
> 
> Lift into iommu_map_nosync():
> - The might_sleep_if()
> - 0 pgsize_bitmap WARN_ON
> - Promote the illegal domain->type to a WARN_ON
> - WARN_ON for illegal gfp flags
> 
> Then remove the return 0 since it is now safe to call
> iommu_debug_map().
> 
> Lift into __iommu_unmap():
> - 0 pgsize_bitmap WARN_ON
> - Promote the illegal domain->type to a WARN_ON
> - iommu_debug_unmap_begin()
> 
> This now pairs with the unconditional iommu_debug_map() on the
> mapping side. Thus iommu debugging now works for iommupt along
> with some of the other debugging features.
> 
> Fixes: 99fb8afa16ad ("iommupt: Directly call iommupt's unmap_range()")
> Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/iommu.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 6e53cfad5dc001..e334588a2476b4 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2583,19 +2583,9 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
>  	size_t orig_size = size;
>  	int ret = 0;
>  
> -	might_sleep_if(gfpflags_allow_blocking(gfp));
> -
> -	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> -		return -EINVAL;
> -
> -	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
> +	if (WARN_ON(!ops->map_pages))
>  		return -ENODEV;
>  
> -	/* Discourage passing strange GFP flags */
> -	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> -				__GFP_HIGHMEM)))
> -		return -EINVAL;
> -
>  	/* find out the minimum page size supported */
>  	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
>  
> @@ -2657,6 +2647,15 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  	struct pt_iommu *pt = iommupt_from_domain(domain);
>  	int ret;
>  
> +	might_sleep_if(gfpflags_allow_blocking(gfp));
> +
> +	/* Discourage passing strange GFP flags or illegal domains */
> +	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
> +			 !domain->pgsize_bitmap ||
> +			 (gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> +				 __GFP_HIGHMEM))))
> +		return -EINVAL;
> +
>  	if (pt) {
>  		size_t mapped = 0;
>  
> @@ -2666,11 +2665,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  			iommu_unmap(domain, iova, mapped);
>  			return ret;
>  		}
> -		return 0;
> +	} else {
> +		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
> +					       gfp);
> +		if (ret)
> +			return ret;
>  	}
> -	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
> -	if (ret)
> -		return ret;
>  
>  	trace_map(iova, paddr, size);
>  	iommu_debug_map(domain, paddr, size);
> @@ -2702,10 +2702,7 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
>  	size_t unmapped_page, unmapped = 0;
>  	unsigned int min_pagesz;
>  
> -	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> -		return 0;
> -
> -	if (WARN_ON(!ops->unmap_pages || domain->pgsize_bitmap == 0UL))
> +	if (WARN_ON(!ops->unmap_pages))
>  		return 0;
>  
>  	/* find out the minimum page size supported */
> @@ -2724,8 +2721,6 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
>  
>  	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
>  
> -	iommu_debug_unmap_begin(domain, iova, size);
> -
>  	/*
>  	 * Keep iterating until we either unmap 'size' bytes (or more)
>  	 * or we hit an area that isn't mapped.
> @@ -2761,6 +2756,12 @@ static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  	struct pt_iommu *pt = iommupt_from_domain(domain);
>  	size_t unmapped;
>  
> +	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
> +			 !domain->pgsize_bitmap))
> +		return 0;
> +
> +	iommu_debug_unmap_begin(domain, iova, size);
> +
>  	if (pt)
>  		unmapped = pt->ops->unmap_range(pt, iova, size, iotlb_gather);
>  	else
> -- 
> 2.43.0
> 

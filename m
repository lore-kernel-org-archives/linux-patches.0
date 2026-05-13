Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE4447DFBF
	for <patches@lists.linux.dev>; Wed, 13 May 2026 15:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685235; cv=none; b=UmnvNyXFR7v5TySLjvueoEgKUcszzSBc6WBXWrRd6egn0fPE14srwk6NhWLbrmx02B7T0q7ukgNjJqXSeX0FTav+aJv/fkHe2pRtT1gpbh59T9dz6cCtIf038cJnkJ6m05nH7VKV+LUhcOIotphHIhBw+qZFtQZ4V4Q1tZuzIEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685235; c=relaxed/simple;
	bh=9zHffo3S0bw1RySXVZoK66sIg5ouIst+aOuVoIjjFsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsyR8DngmdyzuPfr1zcp1SljYdq6Ez2SmbaKNNhMEqb5CxsJzA0iuHt0grTIig1ZjfQKXsfHu3CVlsch4wY1/zCYzSKuudJm+A0lpNZnPRrMxOy5P9plmzIM/t/gLlGCzljVa3IJgkjUs52nXQ8J1mJt0/Ezc5iW1IcgwSEr1yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vQC1Epdc; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQC1Epdc"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso1015e9.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 08:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778685232; x=1779290032; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1AfmyKrxvqScsqmboxj2hvUOAUvpypNoCC8X5gzigVM=;
        b=vQC1EpdclRMdIRF4vGWF4SJIX3cuZ/iiRuzrSIrxbOIpV/T5gidpHD8XgGEsT3kF/j
         Aqhdo9N8LG8gsAahsyYFwZd//g0nQKacPD0odgupOwOX0xzwE+mmSRdNTCN3XBrlHl46
         Mla8G6IaxioPo3n96F044WqgHDN95+9Oa0dlEtaYjYLeCFTE8ZFAdvYOoUPP0VllZdfX
         e2OG1IioIhW8uPXm1wT9orU0ISGMSGjcdN389AIsGvr/sZVB8T73qoS/QDixLdYjqOEp
         ogSZkgbHNpg8F5K6PfOqm0oFTALiqsJwUuJZAw6YAxMEwVA6nlLQU4N92DhjXY/0ogIi
         3POw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778685232; x=1779290032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1AfmyKrxvqScsqmboxj2hvUOAUvpypNoCC8X5gzigVM=;
        b=cjtdq/2g1sQvr5+PFRJqxqsYeFozguWE7nTtQGX3KmKOsqlwlp3Cdt3ZHiVE7Ssm6R
         qmiavgSTHoLEvOrOiqJhqQmr0Rqh2REKP0W6p8uR+xKs5G1r/33vxixOjWbG6ZdGPQfv
         QWPgQDOxrRqTeGGuCpInlwzY3p8stssavnJcTd8QgMehGGETw7GxzQNnsUHdhv7tHpGY
         iLr1fa/vreOehyxRM0RKUp+5muIMStKo2asqX4AAmZOnZ5n6GMkLUidDENXpESfTbQg+
         xnYpVtpTSWTXiw6R4iV0R/HdVA3BWSM6IaFxtPUPUPqf9eu1wTrt4KaiwVBreEUZgN4v
         wotw==
X-Forwarded-Encrypted: i=1; AFNElJ9uiLLLvv+wvFdaM+bIGkE7ASAbY95C6Pa4CIv315AAR67i50W7iVjnWTAO7/bFQTGMCioNuwpc@lists.linux.dev
X-Gm-Message-State: AOJu0YwCVDNHnFYTfRc9k5DgDYuV06fxlRZOhq3yVlErGAAqm0ohzcuf
	VKIK/gj2JE2ZogOnkYd96ao8Slj2X1mSJ8HY4Z0aSanBSjruemBBck2rv5LgD4yQIg==
X-Gm-Gg: Acq92OGevTMJ9Rwrc4X3f4eOJVXZlNMV9IZmhaZt4GDRElSVmiSLUuSDnMUBiXyhlOi
	TpjIUASJsxe/jfcuVy4jFGnRZOL18TIepv+553iHJPzVb69DmBcW8JRwVvMxD8JCQnJiH14PPCv
	S6QrO1Skcl/mmL/vgAT7kYTyw+1PsdUdTNALJUjYMqhrf22/xGKcaPfkht45Zc0CKgcqOFZJyQ6
	Yicp2mY7pY01KYBTtRY0F2p5oxxZvYnd1HM2V4voxoZy70zDLkfbVIIKn3UUXsd0MqgqKZYChzJ
	EP4rhNRYxv+7bIRG573gX5eBZbkB9+2zlPRdCpIPiDAazFfySjVddZ/ENbyoy49+bhwyfVhh0Va
	nZBOTk0GhT4k2Kvr8JHp7SdNXd1ZySHI5xEY4u93xGvvMyZ3158uIfFD8fR10DrkSA7Q/TKD+nt
	9a6KeUdad+0mvxQ18gVLyHR0N2oFl2d3LsvlopH2LNr+QXwwTPovb0748YCs4p/Q4atJw=
X-Received: by 2002:a05:600d:6401:10b0:475:d905:9f12 with SMTP id 5b1f17b1804b1-48fc91218abmr868245e9.4.1778685231954;
        Wed, 13 May 2026 08:13:51 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fd6278b17sm235225e9.0.2026.05.13.08.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 08:13:51 -0700 (PDT)
Date: Wed, 13 May 2026 15:13:41 +0000
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
Subject: Re: [PATCH rc 3/5] iommu: Handle unmap error when iommu_debug is
 enabled
Message-ID: <agSVJeBx849TqOBM@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:15PM -0300, Jason Gunthorpe wrote:
> Sashiko noticed a latent bug where the map error flow called iommu_unmap()
> which calls iommu_debug_unmap_begin()/iommu_debug_unmap_end() however
> since this is an error path the map flow never actually established the
> original iommu_debug_map() it will malfunction.
> 
> Lift the unmap error handling into iommu_map_nosync() and reorder it so
> the trace_map()/iommu_debug_map() records the partial mapping and then
> immediately unmaps it. This avoid creating the unbalanced tracking and
> provides saner tracing instead of a unmap unmatched to any map.

There is usually littel coverage in such paths, I have been thinking
of creating some test-suites on the IOMMU and io-pgtable/SMMUv3 level
to cover some of the failure cases and some of the tricky page table
operations, the problem is that there are many things to cover (starting
from the crashes/logical issues till TLB invalidation correctness of
some operations).

I will try to post something when I get some time.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> 
> Fixes: ccc21213f013 ("iommu: Add calls for IOMMU_DEBUG_PAGEALLOC")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 49 +++++++++++++++++--------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index e334588a2476b4..e5fa9875900228 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2575,12 +2575,11 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
>  
>  static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
>  				    unsigned long iova, phys_addr_t paddr,
> -				    size_t size, int prot, gfp_t gfp)
> +				    size_t size, int prot, gfp_t gfp,
> +				    size_t *mapped)
>  {
>  	const struct iommu_domain_ops *ops = domain->ops;
> -	unsigned long orig_iova = iova;
>  	unsigned int min_pagesz;
> -	size_t orig_size = size;
>  	int ret = 0;
>  
>  	if (WARN_ON(!ops->map_pages))
> @@ -2603,31 +2602,25 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
>  	pr_debug("map: iova 0x%lx pa %pa size 0x%zx\n", iova, &paddr, size);
>  
>  	while (size) {
> -		size_t pgsize, count, mapped = 0;
> +		size_t pgsize, count, op_mapped = 0;
>  
>  		pgsize = iommu_pgsize(domain, iova, paddr, size, &count);
>  
>  		pr_debug("mapping: iova 0x%lx pa %pa pgsize 0x%zx count %zu\n",
>  			 iova, &paddr, pgsize, count);
>  		ret = ops->map_pages(domain, iova, paddr, pgsize, count, prot,
> -				     gfp, &mapped);
> +				     gfp, &op_mapped);
>  		/*
>  		 * Some pages may have been mapped, even if an error occurred,
>  		 * so we should account for those so they can be unmapped.
>  		 */
> -		size -= mapped;
> -
> +		*mapped += op_mapped;
>  		if (ret)
> -			break;
> +			return ret;
>  
> -		iova += mapped;
> -		paddr += mapped;
> -	}
> -
> -	/* unroll mapping in case something went wrong */
> -	if (ret) {
> -		iommu_unmap(domain, orig_iova, orig_size - size);
> -		return ret;
> +		size -= op_mapped;
> +		iova += op_mapped;
> +		paddr += op_mapped;
>  	}
>  	return 0;
>  }
> @@ -2645,6 +2638,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
>  {
>  	struct pt_iommu *pt = iommupt_from_domain(domain);
> +	size_t mapped = 0;
>  	int ret;
>  
>  	might_sleep_if(gfpflags_allow_blocking(gfp));
> @@ -2656,24 +2650,19 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  				 __GFP_HIGHMEM))))
>  		return -EINVAL;
>  
> -	if (pt) {
> -		size_t mapped = 0;
> -
> +	if (pt)
>  		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
>  					 &mapped);
> -		if (ret) {
> -			iommu_unmap(domain, iova, mapped);
> -			return ret;
> -		}
> -	} else {
> +	else
>  		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
> -					       gfp);
> -		if (ret)
> -			return ret;
> -	}
> +					       gfp, &mapped);
>  
> -	trace_map(iova, paddr, size);
> -	iommu_debug_map(domain, paddr, size);
> +	trace_map(iova, paddr, mapped);
> +	iommu_debug_map(domain, paddr, mapped);
> +	if (ret) {
> +		iommu_unmap(domain, iova, mapped);
> +		return ret;
> +	}
>  	return 0;
>  }
>  
> -- 
> 2.43.0
> 

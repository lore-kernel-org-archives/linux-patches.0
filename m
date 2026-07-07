Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E27380FFB
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783425471; cv=none; b=QD9r7Iw4Kz1vF7UB8srXu/UCb26EiS2qUbFadHcO5xyAfHiCRbp33cEsik1vNhifgPfrAFBmGNybs7vg0l78a89DFJ9OZR4thMToD/kiSUF1w3u72YQ3fzcf9PDL++tE3YR7WXlIaSZyLIr3ObVWa0REYOP8iuha6q7bVCozY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783425471; c=relaxed/simple;
	bh=bYyIxzQ/EtEx+7SnF9gPUBLzz72p3bOo/OFVmbuhkR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZWvUJO3cSX2rlEGLYIHER6HLrLWlwCNWDA94fgbvpMdcpRDjjei9uHvNILqdNb+xxyeaPpRpaJPD4rxje6cuzkbNrhO8ePXhDRKfwrW7P+ySIecE1qjwSsNBEP3n3wxykTHYFRCKN+poV5rwvwNRgQgYPr+ncx+qIpBgJhhKKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPXTzKcB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPXTzKcB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso29085e9.1
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 04:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783425468; x=1784030268; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NTfR+wHBxAreRe0VNbdWPjK32qxCiRZ4OQnybQ+8rCc=;
        b=EPXTzKcBwimqeJTBKmRCEizyolUBNRVEswzdNCrhb6JhAFMEPEkF57FyxkVUdzfKjW
         qdVwomc149AHkzLNipzcJ+3hFI39lnxMacPou0+kww2mN/u8htbX/p5JrWMgPjg4Ac0b
         8u9I3TDlEUFt4RnE1JXqwg3JdS4ZsW7NcacPKMmYXMFW2gx8Omr7C6PlKyx7CDs4jVmP
         wY6Nmmi7081tH4Fty2ETwU7QiH32D76P0Bd0OwPIhhTvB49U05ZEsSsEgNECSe9LO43a
         uU+N+TYKVgM794VZQvxJeCQGLceAk/iU1KOu/rfnnXCPxZHd+ON9186wvkdFG8gs4zq9
         n+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783425468; x=1784030268;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTfR+wHBxAreRe0VNbdWPjK32qxCiRZ4OQnybQ+8rCc=;
        b=aJNMmYKPa2sLH2TLXVc3afh0tEtOIaA2ShFMeP+n5QbX9tT60HhI627MC8KQG+twTH
         7s4/B6kuT+k+kuVY27auITdBCJFSUfTYwxDnsxgbUrJXnd1y3gzqJ6h+a4vygt0vuQl5
         rfAExxzotT+3+ZZC1U0OWgOIoJ/3zJ3h4WXTYs74yX/4RQhEZaL1S6+TlvYfIv7suu9+
         2nqBgkWn7WTZ0cJs8Hq173ivYd91u3cqd0blYUFzI1xpA2J71P8Oq6V62ptmCmm9CnMI
         wVeMvUw4zUorNQJt6x5KGgPl+x0czjdJO0Y1+T1CMPcvL2dZE71rWTdwyLhKLgtxVjzi
         p54g==
X-Forwarded-Encrypted: i=1; AHgh+RrJtjVtEvzwd3kLfIRw3zqFXqakO/n/A/2yek9o7Wo7/ob+CF62IKqKQAaEY+0D7q7xrJjBixLw@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxac8GDKr97qDA/VswSjNjSBcOvxu/aNBY2qhAlPU8OBh9AZir
	k7GDVwsg2E6AkSOH2BWMz7x2iW2cDG+faPLbEjPvHFwhEnLx5xTp0/78ihmbGJKdYA==
X-Gm-Gg: AfdE7clI2e3yliMYuGWjDg9v6fgufqszCh4i1Hlbq3vNFXJZ3FtBwKThicnkjhzICwh
	sxGkcL+OwQ/yhSqRPvyZckbZDQXGiINLC3fDfUovN6hciEobHV6sm0uBqCZQodQPod41zQp4YGA
	nF0PccTuyPBTjWzVU2oueJrPELbUKGyKpx7hvUgZzyX3nK1+3lI9R4OnAcHk7cbywn4sKtLV+bY
	lRlM0Pdm2WhUm7ujJ2q1r6xGJM8rkQAK1AwlpUzUvuB/ru3r7qWS9f6ihQLjFtsQQP731VevVhR
	hvPYOEH0bMmQMxtuDEjtNxZu7ZPr7wfZPGzxxbuPEJBBmWuN6E9xrk484Q+GZNTa6+Skumw+xfo
	l9Wt2GZ60ZpXLTybea71HIOkAk9+75iipRaQ4W9vrrOCoU0t+noRKtKuEZoIRyyjnG31+9jmgnu
	pOaPs70WZ0hO9TfFlbjHzcbxyy1amiViThqhyr2M5MpxYT4KhR
X-Received: by 2002:a05:600c:e489:20b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-493e10ce831mr496815e9.4.1783425468224;
        Tue, 07 Jul 2026 04:57:48 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f4ef53sm56007625e9.8.2026.07.07.04.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:57:47 -0700 (PDT)
Date: Tue, 7 Jul 2026 11:57:41 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <akzptWVIihnH79Hb@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:43PM -0300, Jason Gunthorpe wrote:
> Each of these has their own unique situation, populate the tlbi right
> at the top and pass it into arm_smmu_domain_inv_range(). They will
> diverge further when the iommupt invalidation scheme is introduced.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 51 +++++++++----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 13 +++--
>  3 files changed, 45 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 5d4dde3d1cfe87..e6001913e2b043 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -139,16 +139,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
>  {
>  	struct arm_smmu_domain *smmu_domain =
>  		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> -	size_t size;
> +	struct arm_smmu_tlbi tlbi = {
> +		.smmu_domain = smmu_domain,
> +		.iova = start,
> +		/*
> +		 * The mm_types defines vm_end as the first byte after the end
> +		 * address, different from IOMMU subsystem using the last
> +		 * address of an address range.
> +		 */
> +		.size = end - start,
> +		.iopte_granule = PAGE_SIZE,
> +	};
>  
> -	/*
> -	 * The mm_types defines vm_end as the first byte after the end address,
> -	 * different from IOMMU subsystem using the last address of an address
> -	 * range. So do a simple translation here by calculating size correctly.
> -	 */
> -	size = end - start;
> -
> -	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
> +	arm_smmu_domain_tlbi(&tlbi);
>  }
>  
>  static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index fbe3e5dc42f964..2e477f15080148 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2661,25 +2661,12 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
>  	}
>  }
>  
> -void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
> -			       unsigned long iova, size_t size,
> -			       unsigned int granule, bool leaf)
> +void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
>  {
> -	struct arm_smmu_tlbi tlbi = {
> -		.smmu_domain = smmu_domain,
> -		.iova = iova,
> -		.size = size,
> -		.iopte_granule = granule,
> -		.leaf_only = leaf,
> -	};
>  	struct arm_smmu_invs *invs;
>  
> -	if (!size || size == SIZE_MAX) {
> -		tlbi.single.use_full_inv = true;
> -		tlbi.range.use_full_inv = true;
> -	} else {
> -		arm_smmu_tlbi_calc_single(&tlbi);
> -	}
> +	if (!tlbi->single.use_full_inv)
> +		arm_smmu_tlbi_calc_single(tlbi);
>  
>  	/*
>  	 * An invalidation request must follow some IOPTE change and then load

The rest of the comment still refers to the old name
arm_smmu_domain_inv_range()

> @@ -2709,14 +2696,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  	smp_mb();
>  
>  	rcu_read_lock();
> -	invs = rcu_dereference(smmu_domain->invs);
> +	invs = rcu_dereference(tlbi->smmu_domain->invs);
>  
>  	/* Only precaculate RIL if it will be used. */
>  	if (invs->has_range_inv) {
> -		if (!tlbi.range.use_full_inv)
> -			arm_smmu_tlbi_calc_range(&tlbi);
> +		if (!tlbi->range.use_full_inv)
> +			arm_smmu_tlbi_calc_range(tlbi);
>  	} else {
> -		tlbi.range.use_full_inv = true;
> +		tlbi->range.use_full_inv = true;
>  	}
>  
>  	/*
> @@ -2727,10 +2714,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  		unsigned long flags;
>  
>  		read_lock_irqsave(&invs->rwlock, flags);
> -		arm_smmu_domain_tlbi_inv(&tlbi, invs);
> +		arm_smmu_domain_tlbi_inv(tlbi, invs);
>  		read_unlock_irqrestore(&invs->rwlock, flags);
>  	} else {
> -		arm_smmu_domain_tlbi_inv(&tlbi, invs);
> +		arm_smmu_domain_tlbi_inv(tlbi, invs);
>  	}
>  
>  	rcu_read_unlock();
> @@ -2750,8 +2737,14 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>  				  size_t granule, void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = cookie;
> +	struct arm_smmu_tlbi tlbi = {
> +		.smmu_domain = smmu_domain,
> +		.iova = iova,
> +		.size = size,
> +		.iopte_granule = granule,
> +	};
>  
> -	arm_smmu_domain_inv_range(smmu_domain, iova, size, granule, false);
> +	arm_smmu_domain_tlbi(&tlbi);
>  }
>  
>  static const struct iommu_flush_ops arm_smmu_flush_ops = {
> @@ -4018,14 +4011,18 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
>  static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
>  				struct iommu_iotlb_gather *gather)
>  {
> -	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_tlbi tlbi = {
> +		.smmu_domain = to_smmu_domain(domain),
> +		.iova = gather->start,
> +		.size = gather->end - gather->start + 1,
> +		.iopte_granule = gather->pgsize,
> +		.leaf_only = true,
> +	};
>  
>  	if (!gather->pgsize)
>  		return;
>  
> -	arm_smmu_domain_inv_range(smmu_domain, gather->start,
> -				  gather->end - gather->start + 1,
> -				  gather->pgsize, true);
> +	arm_smmu_domain_tlbi(&tlbi);
>  }
>  
>  static phys_addr_t
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 9d262ef6076225..5f97d1a63ebbfd 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -1169,13 +1169,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
>  		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
>  		       struct arm_smmu_cd *cd, struct iommu_domain *old);
>  
> -void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
> -			       unsigned long iova, size_t size,
> -			       unsigned int granule, bool leaf);
> +void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi);
>  
>  static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
>  {
> -	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
> +	/* Prefilled for invalidate all */
> +	struct arm_smmu_tlbi tlbi = {
> +		.smmu_domain = smmu_domain,
> +		.single.use_full_inv = true,
> +		.range.use_full_inv = true,

Those were introduced last patch, but I am wondering if use_full_inv
should be a common field instead of having it in both single and range.

Thanks,
Mostafa

> +	};
> +
> +	arm_smmu_domain_tlbi(&tlbi);
>  }
>  
>  void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
> -- 
> 2.43.0
> 

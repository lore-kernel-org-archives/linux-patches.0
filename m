Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C16E17597
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516902; cv=none; b=XOpZFx5vzTy3o+Z0dvpCLjt5ZzZDZLeiJ9FtgF3HCnjeqrEufexDMU6F0AeDP/akSa4Ij3yjaQLPtw3qeeIwJ8Bezm2k2iqM8K1nD998vAvYuxqJlwltQMasHrPWD/OrYh8tK8BnAaEmDlro+rgARbGGDtI8dfia+HTBMP0ebSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516902; c=relaxed/simple;
	bh=R+jDvWtyrjG2OM7iDEB4WKKq+nY6RPTFbp8Br2Pc0OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACUVrc3oZwV8zdAPEWWAbRHlQm2m8yqJm7w+1jcLyTrUtIiXAnYNRTK9XNQ//4Ws6y4LGTG+b9VnLDamX71f0ttoVblwmrsRBlC0/v3VdEU2nb5rUdQ5CbMVelkPz19J+RQhAmm82jjf/Tpm14Dme5PjF/CfcvdPzJGJx3txLK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lARXnf4U; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lARXnf4U"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso15515a12.0
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516899; x=1718121699; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5sDyHX8QmmV3/QPRkJPGCst6kWW/P8hQxMehL8hNX3Y=;
        b=lARXnf4UIxkfNVHRzMVbn2M3KiRJl+FLSlRMph7OxEd3FzMoLKCg5XhtL6UIeGsgph
         PKqJPqzzrsg79GmMfdddcsfKoeONTsnbczYvgHMxLP1uoLZZSDWo9AO6m+hXa1+Ohfuz
         J14h0LYlUfi/K5Bb4BfV0bkFhjXwc8/3Epw3cS9IaHWjsKTQoEOy8Ssvw4qR+RLyvMhq
         9RGx4se1MFIZ0+j99e8UnjqKj8Pu5pBxxtBvW4co/qv1K/emmFDz5nXOJXMDcwDVgI3R
         TSZLEqf6qZwMffQiTfO66//vI0QOXxJyJcl2Z436KC2jk2lgpHBA8dO3rZKGixs8q8r2
         SwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516899; x=1718121699;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sDyHX8QmmV3/QPRkJPGCst6kWW/P8hQxMehL8hNX3Y=;
        b=tYgxwW0fm71AzSFNhe8fITFfwVLwA8BFMa5g4vKgH18T04pHt5ZYoMMxwYuPx+HwH4
         XGBAQ0Aa0q19OndT5sFMB+Rc7KgotPGeLNY0IFLlHqFmCqcK2zDMAli/1LmraLX0fEuL
         pT/NDH6fczQWVTKD3VQOYo4TYzocHenOIerephL54HBuLXRrZWNALSP28pOvzEYOH6/r
         RymAla5t4oH6mGMVecW9Csil3DPyLsIMHFJzWhJn2p3lhHwa044MSAmbq6nVkcb+LqXR
         SstCQwQeueLvRfpniailXfiKMQahuE2dlqGca4Ne++dBAtP8CFP8KAjRWSqtLwa0cMzz
         5/PQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyLhGcKRWsCC9cvdB1WD81sZp5eAV76yNZzNa1RpOWfs3Cnx0eFCGuMSF5fHtYjjhGfAxnt5Ckj8eKPTupTdBL/mkWivcITw==
X-Gm-Message-State: AOJu0YyNB8b9hkKk7omIoyDMF2gGWlcO1rJXw6tuqqNuBDy3ZGEcsUNO
	ZUdVvY/wEbG/93TESXEgHUUuRzEUFQaKteY7s/sQr1MYOGyC9ZtNZrap9QjMRQ==
X-Google-Smtp-Source: AGHT+IF/Y8fneq1ZfCQ8Xb1nbB2+gLqpJQuXXgr/ND/41kEm1jE0lksXx31VmwPCgMLeHPLBErO9xg==
X-Received: by 2002:aa7:d752:0:b0:576:b1a9:2960 with SMTP id 4fb4d7f45d1cf-57a805b202bmr134474a12.5.1717516898500;
        Tue, 04 Jun 2024 09:01:38 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c0f47sm11988161f8f.8.2024.06.04.09.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:01:38 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:01:34 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 3/7] iommu/arm-smmu-v3: Shrink the strtab l1_desc array
Message-ID: <Zl86XhrWGcBTLFAl@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <3-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:29PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level stream table is (at most) 128k entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (1M), and one of struct arm_smmu_strtab_l1_desc which holds
> the CPU pointer (3M).
> 
> There is no reason to store the l2ptr_dma as nothing reads it. devm stores
> a copy of it and the DMA memory will be freed via devm mechanisms. span is
> a constant of 8+1. Remove both.
> 
This caught my eye before, I imagine(although I was not there) there was some
thought about having different spans per SMMUs maybe, but that’s not the case.

> This removes 16 bytes from each arm_smmu_l1_ctx_desc and saves up to 2M of
> memory per iommu instance.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 14 +++++++-------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 ---
>  2 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d27dd0600bf1df..735dd9ff61890e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1448,12 +1448,12 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
>  
>  /* Stream table manipulation functions */
>  static void
> -arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
> +arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma, u8 span)
>  {
>  	u64 val = 0;
>  
> -	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
> -	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
> +	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, span);
> +	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
>  
>  	/* The HW has 64 bit atomicity with stores to the L2 STE table */
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
> @@ -1655,6 +1655,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  {
>  	size_t size;
>  	void *strtab;
> +	dma_addr_t l2ptr_dma;
>  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
>  	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
>  
> @@ -1664,9 +1665,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  	size = (1 << STRTAB_SPLIT) * sizeof(struct arm_smmu_ste);
>  	strtab = &cfg->strtab.l1_desc[sid >> STRTAB_SPLIT];
>  
> -	desc->span = STRTAB_SPLIT + 1;
> -	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
> -					  GFP_KERNEL);
> +	desc->l2ptr =
> +		dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma, GFP_KERNEL);
>  	if (!desc->l2ptr) {
>  		dev_err(smmu->dev,
>  			"failed to allocate l2 stream table for SID %u\n",
> @@ -1675,7 +1675,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  	}
>  
>  	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
> -	arm_smmu_write_strtab_l1_desc(strtab, desc);
> +	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma, STRTAB_SPLIT + 1);
>  	return 0;
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 4769780259affc..280a04bfb7230c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -577,10 +577,7 @@ struct arm_smmu_priq {
>  
>  /* High-level stream table and context descriptor structures */
>  struct arm_smmu_strtab_l1_desc {
> -	u8				span;
> -
>  	struct arm_smmu_ste		*l2ptr;
> -	dma_addr_t			l2ptr_dma;
>  };
>  
>  struct arm_smmu_ctx_desc {
> -- 
> 2.45.2
> 

Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35DE15E97
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516336; cv=none; b=SZCwslUoSxG9++RfqK7xIw2N88bPMXrkxWRwuUMvlaY8TXchr22l8VaaUuJ04y3wJipG8BvoElErXQI4K2lN0bO6mky5aK7raDlgmY5zpncXzk6ilPPolgUNIzuVE/Xe2+mCKjkz38Jig5f6AvEo/SVA9NWhd+5ufvbfjb5gBLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516336; c=relaxed/simple;
	bh=TOps5EdBi75u5ZcYuVYrOvbwiftCi2guW3u/3eQwrNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgTEJkVW6mS5YkUghPksGJm2vp6ipRB1Gj7XXp64RYnnyLvKZYxUYn3xFU4XfdBlvS09+hg4bPez/aqIT88+Eyk7XAEQ44j6+bpyATdCH7PI8Qyu6HyV8cowM3/KKrRdDjTg3siJge6+OEsALQ+lxzmTxYd96o969JPXAeyr1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xraZNUGl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xraZNUGl"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4213a2acc59so106955e9.1
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516332; x=1718121132; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XCdS47Jjik47nX2nSjJ2PEp6CsHEP/Y97QHuIuLAPao=;
        b=xraZNUGlP98tn30F4jzeV7rGWWQL2Tc8YFqYCfOL2/CaFSCPXWD2D2uXjh5ctHD5Fb
         sCtCKSvKZiq09B3MYpWZvPPAKVjR8/7Tynq/4LfWlDgsTg8QpjFbFi2FnE8k91ykiX4r
         Ggnqe55gMPZGXBVb91NjOK22sy11/KbAyq4grlzt/ffI9K1VhEd9XxsUcIBiGCnZKOs/
         4566RrhwXKsGRY6AQt65wIOaxqvBMcOz2wv6f3JmiXURl4zzuzE2wU/4dlgUKL3AF1j/
         EVu1h0QUF/Jal8pSYL62ckzQ+yeizbhziqIEhJoCVVpClp22xR/OQgiKAHIg1LssCvwG
         jU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516332; x=1718121132;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCdS47Jjik47nX2nSjJ2PEp6CsHEP/Y97QHuIuLAPao=;
        b=o3cdfJDJ9Lhs9BTBRGA4+p8kzj+eZx2z654OcwkXyceph6Zh4DNyFCyb1XaSP9kTw7
         TpwW6/+ldr1htJaiE2+gdWoGGicb8BgfMUG5Br0TxErP0CcH7C5/BQw5JpgKkAKGv90R
         2S1v6nMcxtvO7TG61Rxy7LRAlmMrJpTHqK2SA0TfuD5VUdD6gPLyLTyJ7QZei7MkaHa2
         GCY/2zTdWbekU32vAhAznJzAmvvKchgR1SIRbvZvpC3DHp+hM+GGDRtg5I6rUq7jjuxS
         mSJ9LcVrVnwqUvJJ+iTIaiLpr7oXclJIXmZ0OgLmyVKhlEWnZUyeje5UzeBwPSeIM3+A
         qyGw==
X-Forwarded-Encrypted: i=1; AJvYcCXbHNiv3zdKYn8AONFrqd4SisloO4lawpZL8yCk8TAEXJUt3AMySz+u+KZyllNeIf8g73iX8ouFstBEK8YSgm3y+QMH9SXE3g==
X-Gm-Message-State: AOJu0YwHkKiq242RkbDegBX9jToFKFU9AUTCrnPZxHcfj04ghOP1RENq
	q8VdqVw/QTV+JPKxN92qkf1mMcfftPsUFKrqlrxa8VKbt0R7iWZOkrk1spqqIw==
X-Google-Smtp-Source: AGHT+IFOCUx5Ay7RqRiZBzGJp1w//hF8q5ga1kKSPjgi4QBVSW7P23SXxDegTK2FAV28330J45fUdw==
X-Received: by 2002:a7b:c8d7:0:b0:41b:4c6a:de6d with SMTP id 5b1f17b1804b1-4214b21954cmr2343775e9.5.1717516331925;
        Tue, 04 Jun 2024 08:52:11 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4214beb7fa9sm26018005e9.48.2024.06.04.08.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:52:11 -0700 (PDT)
Date: Tue, 4 Jun 2024 15:52:07 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <Zl84JwoxGFOLzKSC@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:
> This is being used as both an array of STEs and an array of L1
> descriptors.
> 
> Give the two usages different names and correct types.
> 
> Remove STRTAB_STE_DWORDS as most usages were indexing or sizing an array
> of struct arm_smmu_ste.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  9 +++++----
>  2 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index ab415e107054c1..6b4f1a664288db 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1661,8 +1661,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  	if (desc->l2ptr)
>  		return 0;
>  
> -	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> -	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];

I believe also STRTAB_L1_DESC_DWORDS isn’t needed as l1_desc has the same size.
Especially I already see sizeof(*cfg->l1_desc) used in some places instead of the macro.
So we can remove it also as STRTAB_STE_DWORDS.

> +	size = (1 << STRTAB_SPLIT) * sizeof(struct arm_smmu_ste);
> +	strtab = &cfg->strtab.l1_desc[sid >> STRTAB_SPLIT];
>  
>  	desc->span = STRTAB_SPLIT + 1;
>  	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
> @@ -2409,8 +2409,7 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
>  		return &cfg->l1_desc[idx1].l2ptr[idx2];
>  	} else {
>  		/* Simple linear lookup */
> -		return (struct arm_smmu_ste *)&cfg
> -			       ->strtab[sid * STRTAB_STE_DWORDS];
> +		return &cfg->strtab.linear[sid];
>  	}
>  }
>  
> @@ -3225,17 +3224,15 @@ static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
>  {
>  	unsigned int i;
>  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -	void *strtab = smmu->strtab_cfg.strtab;
>  
>  	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
>  				    sizeof(*cfg->l1_desc), GFP_KERNEL);
>  	if (!cfg->l1_desc)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < cfg->num_l1_ents; ++i) {
> -		arm_smmu_write_strtab_l1_desc(strtab, &cfg->l1_desc[i]);
> -		strtab += STRTAB_L1_DESC_DWORDS << 3;
> -	}
> +	for (i = 0; i < cfg->num_l1_ents; ++i)
> +		arm_smmu_write_strtab_l1_desc(
> +			&smmu->strtab_cfg.strtab.l1_desc[i], &cfg->l1_desc[i]);
>  
>  	return 0;
>  }
> @@ -3267,7 +3264,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
>  			l1size);
>  		return -ENOMEM;
>  	}
> -	cfg->strtab = strtab;
> +	cfg->strtab.l1_desc = strtab;
>  
>  	/* Configure strtab_base_cfg for 2 levels */
>  	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
> @@ -3285,7 +3282,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>  	u32 size;
>  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
>  
> -	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
> +	size = (1 << smmu->sid_bits) * sizeof(cfg->strtab.linear[0]);

nit: maybe be consistent with "sizeof(struct arm_smmu_ste)" which was used earlier
this patch and "sizeof(cfg->strtab.linear[0])"

>  	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
>  				     GFP_KERNEL);
>  	if (!strtab) {
> @@ -3294,7 +3291,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>  			size);
>  		return -ENOMEM;
>  	}
> -	cfg->strtab = strtab;
> +	cfg->strtab.linear = strtab;
>  	cfg->num_l1_ents = 1 << smmu->sid_bits;
>  
>  	/* Configure strtab_base_cfg for a linear table covering all SIDs */
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 1242a086c9f948..4769780259affc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -206,10 +206,8 @@
>  #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
>  #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
>  
> -#define STRTAB_STE_DWORDS		8
> -
>  struct arm_smmu_ste {
> -	__le64 data[STRTAB_STE_DWORDS];
> +	__le64 data[8];
>  };
>  
>  #define STRTAB_STE_0_V			(1UL << 0)
> @@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
>  };
>  
>  struct arm_smmu_strtab_cfg {
> -	__le64				*strtab;
> +	union {
> +		struct arm_smmu_ste *linear;
> +		__le64 *l1_desc;

I agree with Nicolin, that it is confusing to have both l1_desc,
I guess a rename is sufficient.

> +	} strtab;
>  	dma_addr_t			strtab_dma;
>  	struct arm_smmu_strtab_l1_desc	*l1_desc;
>  	unsigned int			num_l1_ents;
> -- 
> 2.45.2
> 

Thanks,
Mostafa

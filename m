Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651315E97
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516571; cv=none; b=pnL/D5cpMdZEgxLxsW6oL5XbD5fCGZ/rAwVf2UoswJgFdnIcyalix+91jmgp7HWoVJWUBtA3Gxaw5S26fh8/Zzz79SZ7fpyepaEfYQTpOmZ3Gu5XfF8EQiKPx4+5IoE8i/ECvMUCZSb7Xh4FonG0vssuyWvfFENQ26/fRoKkm/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516571; c=relaxed/simple;
	bh=QItl/PKg+wwAMDiPxK9zBoZTc6Wj9x9La9g18aR8r00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jy85YRXjgab8pNF9EEpFhsOBnNkLmY/LXqFVY2CyHvl7rMZ2w9bTnQ6wW8eSEUpfzUNHMDyRopB4O5jyzSELyoQ9BIus0+SFQSukfJoszRZF8MQ7tTEB5DQymSUeXquznEyRUZ8hStPhghdW1CVwllCKNvqDF6MF1OicDR5hCTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UlT2Gqjh; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UlT2Gqjh"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4213a2acc59so107735e9.1
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 08:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516569; x=1718121369; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d7Sgp9L6slntE6nZTy+7vKK0+zJTJ2LPyv+9VPLgyrQ=;
        b=UlT2GqjhmiT1Ok7J+MtleWoEVUEAEC4BV/2UcDaXLotEG/k8E8GLB86gi5dwNgW3jl
         PvetxkPnxvYe5tQkU3cLCT2sd+0u9YKd1GhWtz+okKw3JKL9noecLpgD5BOLjWjP/VxL
         JKakD0Kj3s/H5o18lDsI0HS4iiDZd6XVqws64I8fMxUk+3r5OCohfGyHWPzJQ6bQoDxr
         rVsW/rzFDX3QQ2mVRu7dkuFck4Av2TK7UkgDnvpJCyWQc18/ZXOrQwR5AbegEt29Lnq/
         lKsz2OqQQAFtenPbcIIJA0F0wAFSmUTnGvg5fwZ1zkfIlxULa6O8NThaYvPofSqE0BqH
         zcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516569; x=1718121369;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7Sgp9L6slntE6nZTy+7vKK0+zJTJ2LPyv+9VPLgyrQ=;
        b=uHPyDnmaGqoeggbhCYSJ2+4caBEc2mwnOi6n4dMDQGsMFc5zIzgV2RxiQ80vdzsHzN
         yfl6UOZ+22ZEIQjx6pKxfOrnSFIwogoR3YneeBg66NAr+V49IS3g4NOjZpT4watPE/eW
         0gspMRHfuPIuj5O25UvlE22KskgCy+hBeuwrI0G1GI69Q/YW++LNsVBQQ5dlIyE0W4OZ
         0nJRY3YyxLJu17D1socyGyGYF1vd/lL6pvK+LMCzqptc7kwwSR1jAVDfPdm6UPhVRviy
         yfHpFfEM+S/It71QLw3wWaj2ZBnEeawFuv7/wuhUoBplwrnw9E0qJAIi9BkNDzCs0R73
         u98g==
X-Forwarded-Encrypted: i=1; AJvYcCXFUzqIj/w9f6p8RKf04h5n9SZMYKffhsImzeEfYMfL/MsCUC8pSmU524R9DxDVDMoxhkl39Lxd+RPMVPlMOLu75MrAn1MSXw==
X-Gm-Message-State: AOJu0YyGqJMhitdcIVhAYkCf2vEepajOdEMXnwjtCmwxQ3JZ6fFnw+Hf
	1JAiomGWbIaA6x15K+g0CKu3EgBBK7ME/KkvEC0KFEcj31/r08fR463RM4dL7g==
X-Google-Smtp-Source: AGHT+IEd0pzHoP5jvawRJjsZ+1PlUhqKmRf0LfUuo7vArLwPTh4pkSqjwEUKKAPDDlnZpwywPSy9lw==
X-Received: by 2002:a05:600c:5122:b0:41c:ab7:f9af with SMTP id 5b1f17b1804b1-4214b1cc21dmr2318855e9.3.1717516568484;
        Tue, 04 Jun 2024 08:56:08 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04d9364sm11958910f8f.53.2024.06.04.08.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:56:08 -0700 (PDT)
Date: Tue, 4 Jun 2024 15:56:04 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 2/7] iommu/arm-smmu-v3: Do not zero the strtab twice
Message-ID: <Zl85FOpIrQSeto4W@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <2-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:28PM -0300, Jason Gunthorpe wrote:
> dmam_alloc_coherent() already returns zero'd memory so cfg->strtab.l1_desc
> (the list of DMA addresses for the L2 entries) is already zero'd.
> 
> arm_smmu_init_l1_strtab() goes through and calls
> arm_smmu_write_strtab_l1_desc() on the newly allocated (and zero'd) struct
> arm_smmu_strtab_l1_desc, which ends up computing 'val = 0' and zeroing it
> again.
> 
> Remove arm_smmu_init_l1_strtab() and just call devm_kcalloc() from
> arm_smmu_init_strtab_2lvl to allocate the companion struct.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looking at the code for dmam_alloc_coherent(basically dma_alloc_coherent)
I see that the memory is zeroed for both DMA direct and IOMMU, however
I don’t see that documented (in DMA-API.txt).

Assuming that’s guaranteed to be zeroed (maybe we should update the docs
if I am not missing something)
Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 +++++++--------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6b4f1a664288db..d27dd0600bf1df 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3220,23 +3220,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
>  				       PRIQ_ENT_DWORDS, "priq");
>  }
>  
> -static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
> -{
> -	unsigned int i;
> -	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> -
> -	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
> -				    sizeof(*cfg->l1_desc), GFP_KERNEL);
> -	if (!cfg->l1_desc)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < cfg->num_l1_ents; ++i)
> -		arm_smmu_write_strtab_l1_desc(
> -			&smmu->strtab_cfg.strtab.l1_desc[i], &cfg->l1_desc[i]);
> -
> -	return 0;
> -}
> -
>  static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
>  {
>  	void *strtab;
> @@ -3272,7 +3255,15 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
>  	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
>  	cfg->strtab_base_cfg = reg;
>  
> -	return arm_smmu_init_l1_strtab(smmu);
> +	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
> +				    sizeof(*cfg->l1_desc), GFP_KERNEL);
> +	if (!cfg->l1_desc) {
> +		dev_err(smmu->dev,
> +			"failed to allocate l1 stream table (%zu bytes)\n",
> +			cfg->num_l1_ents * sizeof(*cfg->l1_desc));
> +		return -ENOMEM;
> +	}
> +	return 0;
>  }
>  
>  static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
> -- 
> 2.45.2
> 

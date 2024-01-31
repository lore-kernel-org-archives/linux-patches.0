Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15778128397
	for <patches@lists.linux.dev>; Wed, 31 Jan 2024 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712659; cv=none; b=n0OYbsolMYVm45s0yba2ASzfU2yqhP+w6t3/vn5FrIqzGuQ/Asp3bLcrQib2ANNdytQKUuEmQ5BE0097QpdOC7Uccz8/nkkDgB8lE/VmfZKwJk7bGkhPmdtJBcBapFoxwyBvyc+GxG6ow+iVHKlz3npQ3Cftcr9pt0bwg0BiH8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712659; c=relaxed/simple;
	bh=xgOdRMaG3Pgg3ku1P3D7T1J0tmTH6xEhcsoxyHY6r7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYlLyQl99lDeUnJgQM8VPY2mt2aIXIl+ycQnvX52GKNXCArvzIKuN6cMkGOk5AO6zJL+Xkpn3jQz6rsdGxLH9gbK0kc5mDn74+MFow+PdNqSjtcrGIHMxkHzDqrySDg+3Nrjqp8JXZ+T8kmtEaPr8+CdNTs0psl3RttA6exgV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mpTOpm31; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpTOpm31"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40ef9382752so57765e9.0
        for <patches@lists.linux.dev>; Wed, 31 Jan 2024 06:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706712647; x=1707317447; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mj9o72Uu+u3Jg2sBnlokmzzI9TdhCCGHOPgYXiSZ7ts=;
        b=mpTOpm31O1feDCkP6EsmmFjfhHQ9Ju6LsBNcQesg7bGFBcdWe3rzs3a0rmxE9f9E8G
         9EHdz3fMhcrktS2nGkmH2/HIzTwZcYhElYK2mldSGIK64LIqV9Xt6wT+s6tQSwqjAXJH
         8+Vhp3VyaRbZDirlgX8N2F+Rwe9QhkjSO7EzMVsVB++N9k7b8drP1yswGrxpuVcZhv6F
         kbft8USFbhSWv88GOhhBMUHqhEeLNiEM548FIt18zPhJ8AdoueZQ8EaFI4FPL5XCgfKj
         LJ35LqH2Tfa/LWPjLhS1hr8BZ5oMYG4pBiPPNOjHRaXYwPT2v53y2u6ohra7+9+OTCnw
         PfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706712647; x=1707317447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mj9o72Uu+u3Jg2sBnlokmzzI9TdhCCGHOPgYXiSZ7ts=;
        b=br3SHr93bWB9KrKyt8J64LCZIBQYPvOjye4OhQlmlR7yTeG4QCFeysSIIZ1DUqEp/m
         pg3wH5A25sM/ygP1mgC+m3P3L+X+5YRtq2CMPt+HAuww7+mvDq201ZOW+XY45spTd/bI
         gOo9T3fwiDGE/5URdkhA4zDmgfEntJukcEQA9iuRIVBGdxCUyngkgUByTWk7itQM8dO/
         fn9JdZ0i4+mCzMQxW7QVvoQc8eTXe9YD98nBc+FBCQ+mJc6PtS/jYHa8e8BL78cYNgmH
         yfD9b2Wj/rpgEYp6G5JZOZiG7Uqw5sIRujygaG5kSunDCgeyuQV8n2BxYWMvFTpccjon
         z3Uw==
X-Gm-Message-State: AOJu0YwCdOGKHSxGbE+BnRIzo/529Z7xD6yURDeyLe+dc1zDtiaYAczl
	bkXNBx92kTZs3HcRk6IF4gSvqiNBWyttol0YJK7g0IRPs5BoGHxvZQ7jEqe74Q==
X-Google-Smtp-Source: AGHT+IHURklEBJZx4g6k++pHQrvnXf4L//mJqp4WaOKbdy5G4YmyS55O/jQDQjUG13C97dB4yc6JJg==
X-Received: by 2002:a05:600c:500e:b0:40e:e7ce:da68 with SMTP id n14-20020a05600c500e00b0040ee7ceda68mr392313wmr.0.1706712647069;
        Wed, 31 Jan 2024 06:50:47 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVSvqDY4blbO59tnB02MgpuQGwvT9cGGXpQeF3LeFiR2SpWmVWMtznTu9zN0V77AloLcNaegxgW6MMlEyYSVP3v2jwpPjxhaT/obpSwB6TE+hvIYiUJ15oWA6Z+W+kBUOfUgxSnfOse5GKRiv12ZGmVYt0AfBXsCA4UUBdJUREREH7ZJaSoK2fxwITG3uQbAGjNoKg20R/kd+kaEE0s84U1FvSpxAFKGC5Dhz3e/GnsCTw62eHIpbr9wopwXrsV0mO0V15oIcJR5wimAPpBnejcW/xVKocCbx7Mvniyn6xy4SqSINuQhpAllNvWSNxaNl5eU/i2Jg0cWy6oeRJnn41gW6jwC5TDEB12HbmACNauqcz+moZmCguP
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c358c00b0040fafc8bb3asm1829317wmq.9.2024.01.31.06.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 06:50:46 -0800 (PST)
Date: Wed, 31 Jan 2024 14:50:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 04/16] iommu/arm-smmu-v3: Move the STE generation for
 S1 and S2 domains into functions
Message-ID: <ZbpeQt_nyCiFRrcv@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Thu, Jan 25, 2024 at 07:57:14PM -0400, Jason Gunthorpe wrote:
> This is preparation to move the STE calculation higher up in to the call
> chain and remove arm_smmu_write_strtab_ent(). These new functions will be
> called directly from attach_dev.
> 
> Reviewed-by: Moritz Fischer <mdf@kernel.org>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 115 +++++++++++---------
>  1 file changed, 62 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index df8fc7b87a7907..910156881423e0 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1516,13 +1516,68 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
>  		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
>  }
>  
> +static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> +				      struct arm_smmu_master *master,
> +				      struct arm_smmu_ctx_desc_cfg *cd_table)
master already include cd_table in "master->cd_table", why do we need to
pass it separately?
> +{
> +	struct arm_smmu_device *smmu = master->smmu;
> +
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
> +		FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt) |
> +		(cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
> +		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
> +
> +	target->data[1] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
> +		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> +		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> +		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
> +		((smmu->features & ARM_SMMU_FEAT_STALLS &&
> +		  !master->stall_enabled) ?
> +			 STRTAB_STE_1_S1STALLD :
> +			 0) |
> +		FIELD_PREP(STRTAB_STE_1_EATS,
> +			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
> +		FIELD_PREP(STRTAB_STE_1_STRW,
> +			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
> +				   STRTAB_STE_1_STRW_EL2 :
> +				   STRTAB_STE_1_STRW_NSEL1));
> +}
> +
> +static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> +					struct arm_smmu_master *master,
> +					struct arm_smmu_domain *smmu_domain)
Similary, master already has the domain in "master->domain".
> +{
> +	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
> +
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
> +
> +	target->data[1] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_1_EATS,
> +			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
> +
> +	target->data[2] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
> +		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
> +		STRTAB_STE_2_S2AA64 |
> +#ifdef __BIG_ENDIAN
> +		STRTAB_STE_2_S2ENDI |
> +#endif
> +		STRTAB_STE_2_S2PTW |
> +		STRTAB_STE_2_S2R);
> +
> +	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +}
> +
>  static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  				      struct arm_smmu_ste *dst)
>  {
> -	u64 val;
> -	struct arm_smmu_device *smmu = master->smmu;
> -	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
> -	struct arm_smmu_s2_cfg *s2_cfg = NULL;
>  	struct arm_smmu_domain *smmu_domain = master->domain;
>  	struct arm_smmu_ste target = {};
>  
> @@ -1537,61 +1592,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  
>  	switch (smmu_domain->stage) {
>  	case ARM_SMMU_DOMAIN_S1:
> -		cd_table = &master->cd_table;
> +		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
>  		break;
>  	case ARM_SMMU_DOMAIN_S2:
> -		s2_cfg = &smmu_domain->s2_cfg;
> +		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
>  		break;
>  	case ARM_SMMU_DOMAIN_BYPASS:
>  		arm_smmu_make_bypass_ste(&target);
> -		arm_smmu_write_ste(master, sid, dst, &target);
> -		return;
> +		break;
>  	}
> -
> -	/* Nuke the existing STE_0 value, as we're going to rewrite it */
> -	val = STRTAB_STE_0_V;
> -
> -	if (cd_table) {
> -		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
> -			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
> -
> -		target.data[1] = cpu_to_le64(
> -			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
> -			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> -			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> -			 FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
> -			 FIELD_PREP(STRTAB_STE_1_STRW, strw));
> -
> -		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
> -		    !master->stall_enabled)
> -			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
> -
> -		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
> -			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
> -			FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax) |
> -			FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt);
> -	}
> -
> -	if (s2_cfg) {
> -		target.data[2] = cpu_to_le64(
> -			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
> -			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
> -#ifdef __BIG_ENDIAN
> -			 STRTAB_STE_2_S2ENDI |
> -#endif
> -			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
> -			 STRTAB_STE_2_S2R);
> -
> -		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> -
> -		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
> -	}
> -
> -	if (master->ats_enabled)
> -		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
> -						 STRTAB_STE_1_EATS_TRANS));
> -
> -	target.data[0] = cpu_to_le64(val);
>  	arm_smmu_write_ste(master, sid, dst, &target);
>  }
>  
> -- 
> 2.43.0

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

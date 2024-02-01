Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD5515D5AF
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706787275; cv=none; b=L9FvK/w7Uq/AndDDD4kwLdvWTFxlI5LAvRhSGja+5jQiY0tz1fZ1lBh3v3pzgIyE4TFF4qKstC0wp6791Z0VqkW7MrUyFKF6BHZEZdrUVwvTqVoTOXf3d+U7XMhB0DroOxYBuELrLzz0zL6ESblItRW6U6z05kBFaTBOJtysgkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706787275; c=relaxed/simple;
	bh=kScjRLEoGqNkrK4BtVa8jvKYt1MquXz244qrDNAk5c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5yBGWnWCleFKStjTY4Cd2i/jBx5cB8+TyFkS2bZgeusmwyckjzwgmRd2iCRI/Fcn5RQsFmio9OwgPF+ZRLhZnV26tJNYrAJkHyUzhGJSXIGGngyIkahE31iqSXfz0L21WG47ur1lETDPI7/NoJ6/9lCdBNAEjkZiwtYLtDm2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QVzSBAaL; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QVzSBAaL"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55f85a2a43fso9617a12.1
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 03:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706787271; x=1707392071; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cwdhwoJv0upsGTffobk3GyaXqxANI4HVSiNrgLd7H9g=;
        b=QVzSBAaLIxpU2Zoblf0U0QbH3lkGBE06pYkTUZdA4KR7vAw4mHdYtjjHz6ivhr8h7v
         lQJjyu4e68cPY+ysA/1DOJroOK+fv494iSmmMVy+OdnWgqRhqhor5IYnyBOG3V8yCyic
         gw9nvgZKbokLBosxxh/73WTi89DZe3ixet5aYD0TSRtyqZWp8Y3WWhX30unbP34ZEfuS
         WR5WcmRQri0LVeiGegRgNvL7we7g5XmJRKwSczQT86QLTnzM2+JxTR9R/uKHH6h6MuMa
         PQ4rvvorDdUQT7YP0cf8bm8hLjUfepIJXO9P8hSxtDbLuS30s481l4oaSfjOaIdtjRTN
         CBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706787271; x=1707392071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwdhwoJv0upsGTffobk3GyaXqxANI4HVSiNrgLd7H9g=;
        b=OOBixGLUnZ3RzzPAABvlfAd4y3wbJE8EQaLTQ35aJ+0URwH4kABc4tBmnx8uVDFRFO
         S92UIkjikl39DjuyrmfKkwzhPeDckzl3sc9cMAhP9DSTVetbTvEF39oaoW3WAbBqt9mt
         PrEZ1UWo6DN+6UmxQGlEnDQdorFSW9iQA4IoqO9HlJ000htLr+/HnLiIMP1htEwYwau/
         9jfWjsgDvXnq/yFXo7xudNjS4Bx1JJZyjs7fz2dTNJwDkLiSMJNXKmV0sMpspXV9AajP
         1Y8hO0+T/5ttdzP9ZVRtmRzrPZ4k7/cYccrbUPy9wGDiKdj2lV+oD0QEPsBMZSMksuTu
         uClw==
X-Gm-Message-State: AOJu0YxADEPlsJ9pi5Umb+RdQIdxM0ERxPxA58nF0aB/tWJtVN36D51f
	Umsjz+4THRgm691qmvNwbdQ1cA+iYQyT2CFJFGudE0zTsaxqdJemgBRk6/Rvcg==
X-Google-Smtp-Source: AGHT+IHp5KhXwzylECbOOpOhQgHLxeXsk2Ap6Wjl+iEgu9HBxMQJVprXeZaZFPB6vmtvWPHYHrFh1g==
X-Received: by 2002:a50:cd02:0:b0:55f:a1af:bade with SMTP id z2-20020a50cd02000000b0055fa1afbademr67546edi.4.1706787271265;
        Thu, 01 Feb 2024 03:34:31 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWAD8h6GWYLmNJCBgNGsd4RS5rEIsQag4qHjia+2wpx664broHgisk+OeTTNFckjiuhJS4TUh5vFoXBXkDseAh/A8mDgB+tQuikvIp8BMcgAMUT1D08hlA1X6+CCb+qx/umIkx0TKfb/aZZKMzyMVMhVfLhi5XrJFYp4aPKZesnKnAw2g501AIcxKhG/YOmOUg+I6EDYlcA1Gvv9+iu7NJm65BfosmbJTArtuI9ng8bDGtsknglNnxgQufrTpkcTLEJAQbLiVdNxCLutniMAl7f8xGbHVlKdyqILAT8N1Y9wwVDAHXSHXe1vZsFT5Vlkd7H5zOQHELLclSp4swBEH1SluQWgEzsIkJJS+yyc73tp6TodAGLzrsu
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id w16-20020a05600c475000b0040e549c77a1sm4165318wmo.32.2024.02.01.03.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:34:30 -0800 (PST)
Date: Thu, 1 Feb 2024 11:34:25 +0000
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
Subject: Re: [PATCH v4 05/16] iommu/arm-smmu-v3: Build the whole STE in
 arm_smmu_make_s2_domain_ste()
Message-ID: <ZbuBwSvDEowh4vjr@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <5-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Thu, Jan 25, 2024 at 07:57:15PM -0400, Jason Gunthorpe wrote:
> Half the code was living in arm_smmu_domain_finalise_s2(), just move it
> here and take the values directly from the pgtbl_ops instead of storing
> copies.
> 
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 ++++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 --
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 910156881423e0..9a95d0f1494223 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1552,6 +1552,11 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  					struct arm_smmu_domain *smmu_domain)
>  {
>  	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
> +	const struct io_pgtable_cfg *pgtbl_cfg =
> +		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
> +	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
> +		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
> +	u64 vtcr_val;
>  
>  	memset(target, 0, sizeof(*target));
>  	target->data[0] = cpu_to_le64(
> @@ -1562,9 +1567,16 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  		FIELD_PREP(STRTAB_STE_1_EATS,
>  			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>  
> +	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
> +		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
>  	target->data[2] = cpu_to_le64(
>  		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
> -		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
> +		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
>  		STRTAB_STE_2_S2AA64 |
>  #ifdef __BIG_ENDIAN
>  		STRTAB_STE_2_S2ENDI |
> @@ -1572,7 +1584,8 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  		STRTAB_STE_2_S2PTW |
>  		STRTAB_STE_2_S2R);
>  
> -	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
> +				      STRTAB_STE_3_S2TTB_MASK);
>  }
>  
>  static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
> @@ -2328,7 +2341,6 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
>  	int vmid;
>  	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
> -	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
>  
>  	/* Reserve VMID 0 for stage-2 bypass STEs */
>  	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
> @@ -2336,16 +2348,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
>  	if (vmid < 0)
>  		return vmid;
>  
> -	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
>  	cfg->vmid	= (u16)vmid;
> -	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
> -	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
> -			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
>  	return 0;
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 65fb388d51734d..eb669121f1954d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
>  
>  struct arm_smmu_s2_cfg {
>  	u16				vmid;
> -	u64				vttbr;
> -	u64				vtcr;
>  };
>  
>  struct arm_smmu_strtab_cfg {
> -- 
> 2.43.0
>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

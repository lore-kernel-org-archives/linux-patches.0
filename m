Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31783CA6
	for <patches@lists.linux.dev>; Wed, 31 Jan 2024 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712032; cv=none; b=AgTo7fWkcBPy5G2BHwq/R9SQkoZLMPxHeUXD4xf+K+lP2CKZ2+BO98bsI3l0tjpUIT4ST/km39AR2T/jYK4qNDF+tIiGhj+QJt6LWUzxQ3EMF6r51L8RcGL8/Rr4FQUgVg75+sVC63L8JwQ3UUJzzh6Av5jm9NfLPQccRVLcQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712032; c=relaxed/simple;
	bh=CnFRdoxT1SoEgJ+0kvftxN4mU3SbsiFmWXCuDNpxG8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJ8bIk0F7y4IX/WvxKlax3gQOwMIDpmCVXZXgs8IpRFYTRtRCS5kCvlfeS67Kva5ma/5nSxFo6xPRjauQfGkgeksYvesgpsMuHeKXRkRcBoOz+joFa9yR3KbROfKNEJD10X5FJLTJAKoWG7dPJJdxwWIvxtrcvfItcXrQ2C7wAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bTgzICsV; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bTgzICsV"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40ef9382752so57075e9.0
        for <patches@lists.linux.dev>; Wed, 31 Jan 2024 06:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706712028; x=1707316828; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Atx/A/Kd3wBowOOB5SPB5s3413xE127qaDJyNH22uRE=;
        b=bTgzICsVYBlBaKWN5cIaakDLaSxVg1XcBTQaw2BH1N+bEhY4ocW5CSSHFEIlR0pqrT
         v/R703AvJXgj98Hkz77nzStcQGaBwso8cuUSutOrLd4rGcaJrx6rurF2vRobFJQLzNg8
         X0tWCa+ligSHwp5vBQX+GBi9wcFMKZr61MLEbeDR2O4uMUi4PF+8U05WYtb6KnDnL9/T
         QTFqHiktWWBy+otsWD/aAjzdtcuj9AQftdTRolu7TVusqeqwTd4sFxnD+LJMetii1gHl
         YTtwV8dA9miQDfJ2V6BlFxYEMgGKRlrwP7ny6xj89WgXM/VAsS5Qwcg/hQkkltCymqR3
         +71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706712028; x=1707316828;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Atx/A/Kd3wBowOOB5SPB5s3413xE127qaDJyNH22uRE=;
        b=rR3eCp8yaUwj7XLgSPskv01VC+Nr2+9WgpZm0SGTpMH9Ogr1HKaGSOPDypuqZTJU7c
         8SkJRH9kZVKIbh8tmVwIOnEFkp9x9s5ynC8UE/NIn40EQ0TqNadnNXT7McGWINrAcVnz
         i2SOoXZitpBRx9uNWL/0O4rm0inBz6E73JeC14hLSkxaEARPTskyw9ycV0HmOkALB1pJ
         bpWSEF3W0XX2RMmx0Pj4TJikPdPVd7ooLciN7S9ipfnqqpZo4F39Pzd0M4DUWi4rZQkE
         mrmrckVhcIJuVZpcIQURniVBe16VibrqeDrO8D1pHk4vuScNM7LV+hF8xK7r0VKzHmVA
         6zRg==
X-Gm-Message-State: AOJu0YxqeX0VQGhtHyMCt9tFE5zfiWemaGWTh8FjZdoFDJo7HoXN1sFC
	AxsM7x64u4NcraaRvio7TiQ6Mjkr650DGiSz7fBA9e5vjR+frr92816eXZ9bOg==
X-Google-Smtp-Source: AGHT+IFGRt09c6PIlbuscZsW9acxH4MnSEQpbtHlnr1JNGy8lWeZDj43fMMk3YtpQqNOOURR2IHc5Q==
X-Received: by 2002:a05:600c:1d87:b0:40f:b527:8bac with SMTP id p7-20020a05600c1d8700b0040fb5278bacmr89654wms.6.1706712028512;
        Wed, 31 Jan 2024 06:40:28 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWQVE9hQOeqiOMK6vLLmfMU/tchY9ZDvRnuK3KoaYw9q1E6Ggp1DCZRXFnNf7ZrLg9HOjy7TYJhths1jd2JwKjdkxsiOHPzmNrQoJSpJx/u96KBSF+5ur9oMD9RG2M9nZlyPUcf3Px0pQQE5NIlB4NgafdhYD3xUn+d44xTncbMAMHgNj0bZMUu+zdy+ucy1DdzGFlmpiOEQx5CTH53RHFA1EhIJPhiRa3uI4e2Vr0drAYOenTjoeGzXrvGUBq9g85BL2wC5yei2mJRZ+/I8uHntm4+jqIoYERNjBUlienCAVUZfCa95u73N5/2iGQckyK4dvXSFLI648BVxzYQpqKNmcy8PbpMqHRXXhiomEmpLqLtJigtr02r
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id bq28-20020a5d5a1c000000b0033af3ef600asm6983955wrb.86.2024.01.31.06.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 06:40:28 -0800 (PST)
Date: Wed, 31 Jan 2024 14:40:24 +0000
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
Subject: Re: [PATCH v4 02/16] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <Zbpb2JSgnRuHGIo-@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <2-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Thu, Jan 25, 2024 at 07:57:12PM -0400, Jason Gunthorpe wrote:
> This allows writing the flow of arm_smmu_write_strtab_ent() around abort
> and bypass domains more naturally.
> 
> Note that the core code no longer supplies NULL domains, though there is
> still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
> NULL. A later patch will remove it.
> 
> Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
> and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
> simply invoke arm_smmu_make_bypass_ste() directly.
> 
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++----------
>  1 file changed, 47 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 690742e8f173eb..38bcb4ed1fccc1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1496,6 +1496,24 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  	}
>  }
>  
> +static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> +{
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
> +}
> +
> +static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
> +{
> +	memset(target, 0, sizeof(*target));

I see this can be used with the actual STE. Although this is done at init, but
briefly making the STE abort from “arm_smmu_make_bypass_ste”, seems a bit
fragile to me, in case we use this in the future in different scenarios, it
might break the hitless assumption. But no strong opinion though.

> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
> +	target->data[1] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> +}
> +
>  static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  				      struct arm_smmu_ste *dst)
>  {
> @@ -1506,37 +1524,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  	struct arm_smmu_domain *smmu_domain = master->domain;
>  	struct arm_smmu_ste target = {};
>  
> -	if (smmu_domain) {
> -		switch (smmu_domain->stage) {
> -		case ARM_SMMU_DOMAIN_S1:
> -			cd_table = &master->cd_table;
> -			break;
> -		case ARM_SMMU_DOMAIN_S2:
> -			s2_cfg = &smmu_domain->s2_cfg;
> -			break;
> -		default:
> -			break;
> -		}
> +	if (!smmu_domain) {
> +		if (disable_bypass)
> +			arm_smmu_make_abort_ste(&target);
> +		else
> +			arm_smmu_make_bypass_ste(&target);
> +		arm_smmu_write_ste(master, sid, dst, &target);
> +		return;
> +	}
> +
> +	switch (smmu_domain->stage) {
> +	case ARM_SMMU_DOMAIN_S1:
> +		cd_table = &master->cd_table;
> +		break;
> +	case ARM_SMMU_DOMAIN_S2:
> +		s2_cfg = &smmu_domain->s2_cfg;
> +		break;
> +	case ARM_SMMU_DOMAIN_BYPASS:
> +		arm_smmu_make_bypass_ste(&target);
> +		arm_smmu_write_ste(master, sid, dst, &target);
> +		return;
>  	}
>  
>  	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>  	val = STRTAB_STE_0_V;
>  
> -	/* Bypass/fault */
> -	if (!smmu_domain || !(cd_table || s2_cfg)) {
> -		if (!smmu_domain && disable_bypass)
> -			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
> -		else
> -			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
> -
> -		target.data[0] = cpu_to_le64(val);
> -		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
> -						STRTAB_STE_1_SHCFG_INCOMING));
> -		target.data[2] = 0; /* Nuke the VMID */
> -		arm_smmu_write_ste(master, sid, dst, &target);
> -		return;
> -	}
> -
>  	if (cd_table) {
>  		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
>  			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
> @@ -1582,21 +1594,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  }
>  
>  static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> -				      unsigned int nent, bool force)
> +				      unsigned int nent)
>  {
>  	unsigned int i;
> -	u64 val = STRTAB_STE_0_V;
> -
> -	if (disable_bypass && !force)
> -		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
> -	else
> -		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
>  
>  	for (i = 0; i < nent; ++i) {
> -		strtab->data[0] = cpu_to_le64(val);
> -		strtab->data[1] = cpu_to_le64(FIELD_PREP(
> -			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> -		strtab->data[2] = 0;
> +		if (disable_bypass)
> +			arm_smmu_make_abort_ste(strtab);
> +		else
> +			arm_smmu_make_bypass_ste(strtab);
>  		strtab++;
>  	}
>  }
> @@ -1624,7 +1630,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  		return -ENOMEM;
>  	}
>  
> -	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
> +	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
>  	arm_smmu_write_strtab_l1_desc(strtab, desc);
>  	return 0;
>  }
> @@ -3243,7 +3249,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>  	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
>  	cfg->strtab_base_cfg = reg;
>  
> -	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
> +	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
>  	return 0;
>  }
>  
> @@ -3954,7 +3960,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
>  	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
>  
>  	list_for_each_entry(e, &rmr_list, list) {
> -		struct arm_smmu_ste *step;
>  		struct iommu_iort_rmr_data *rmr;
>  		int ret, i;
>  
> @@ -3967,8 +3972,8 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
>  				continue;
>  			}
>  
> -			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
> -			arm_smmu_init_bypass_stes(step, 1, true);
> +			arm_smmu_make_bypass_ste(
> +				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
>  		}
>  	}
>  
> -- 
> 2.43.0
>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

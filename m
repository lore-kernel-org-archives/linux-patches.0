Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2C15DBA0
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706789898; cv=none; b=W+DWTKBwPoPDe39KkW6Vo8uq1o9jjTZXzr7QT0U/fzamBUpU95qf4oSpY8P9txszrDroaR3LPGqPEDAJ4uQNeh2b7GsUzH6QzQvmdfVm+/du10c8BAVpiXTm//BIhyOh5Oei2s1QQfcJP86J33FX+DGSu8Bc8DRBYExT+H2S6L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706789898; c=relaxed/simple;
	bh=/1cRaREVz8xT34hQ2yr+zfryBpN8OQHocvvm7ZLPpnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qyD9FmX5LkGBHaFJbRsmbiupzzHFtLlhjWgQ8fMyYJrrOeSqqz4j+411uqBEH6Owb9MtPeyEXCnzYrBgzzp6raVCcchWCki04qng4g+OtdE1ayZtSbQ2knTDLYQt7PctZK1YNBXMDy1LiAFUTtgFFHXdxRfxe4A+cWmFoj8SeC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tO/W1jkM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tO/W1jkM"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40fba1866fdso33105e9.0
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 04:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706789895; x=1707394695; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=etlYPvb4uOjdfz/Zs8jzDsz/Zvk0DcrwunGCl+SdTFk=;
        b=tO/W1jkMbBbhQd5vAHkSJkH+Qk4xF4n8kBUZla4GAWrtEB6BtCYvIw+xkdU8V0+nSd
         L2KEfmW5ZtQb+mlAgqMy0qwfFUHFtnKeD/mdLMd/wi8DO6ugkeTo4AjrwsY3aLBVQp9D
         DbfiXy4IDAhgqszoc8A6DLkCCNfVONOUO3LZ51zyvx77CLu5XObHKLrgSH2C+0cwJYrv
         NXYS7RKYpaA2JFA2JyzxtAmztI2HONqdnRxuWy0M63fomUvcaZob+QroCQF5h97opApq
         ZbEzgVKWt0+/K6KyGFNGguUuare+mfytcPJGvX9NjYzG7ee3kMU8M6BVdEFxLFvjipIC
         xR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706789895; x=1707394695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etlYPvb4uOjdfz/Zs8jzDsz/Zvk0DcrwunGCl+SdTFk=;
        b=wUrg1quA2eTaWfFIHoJWsE1s52hzkX48lmuaxJ5rKvlIvbA40o9zkO5Ay63wDLiF3M
         u+tze8JoN9QYsFK9W2NG2dg1XQonmPbLQej3bK1P+uU8BtVpfqiH4W321kie437tdhyb
         b5n13WHx9FRj/DivNlex+rON6dcCzEOTieXt6ybIosp/ZynLyLEm8jFdRaF/hN1FR3Bd
         SICRx7wqxC/w2V5bxDrPM7z9emUh65anXgMF+ARBi8RypjOBueaALZxpxQIBia6lRp5f
         6D1BIPOgoRTihaQNQnlCqnckVW5C47rJ8XZ5KlIZmG49nN5cKF1wNY94wOlctYjF0cPj
         MnAA==
X-Gm-Message-State: AOJu0YxTxk9sO+uVg3nlnxu8pGYCl/yVSv5pf0wMWc0f+cEwFLdpoyZR
	rVppzFBsrjGH8yrsH7VfHTiqjV9UPsHXPBjrrjT8u93BOg5MePbu2J/K8953qQ==
X-Google-Smtp-Source: AGHT+IH4n+wXp33JvUNh1CjnR39qfCbYHdkrCfVHZ8bVkGTaBcNE54nTX17nUCCe5TU5kIZolzN4rQ==
X-Received: by 2002:a05:600c:b8b:b0:40e:f8fa:1dd2 with SMTP id fl11-20020a05600c0b8b00b0040ef8fa1dd2mr145491wmb.6.1706789894956;
        Thu, 01 Feb 2024 04:18:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXCDCsNICh+ywfn69HqrWUJdmj4HMdNklHHAWPDNYP7USkFX8lsXUaUIvDbBXiEFd51hNBw7T5kjZBdk7NTrYxdmmPSqNkfcx90gFyzFXbdIs3OuNX1K7V9BpXjqgBduN80JMInZajcXSwqAY5y0HWvEH+8NHLXSOnISZxDhyE6Rhw/zqJh2gi1gV8Yqd2I4UDUGlsKTFvKGn+o5VC7AKuhhCjjZJHNyUeZlE9gBi8KhN/ZEBsWQucJaJGuVyMnmlRA20kt29u+CjRhnuSTEP3xiUSpEFG4jGcSVCTWb4uYtkMswEubsRIt2RnTFEmr1j1AVZwVC8sdC6O8syr5+BkLW48Y2ixv0GmS/7TsmbzFd4iK06+rOJym
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d5291000000b00337d980a68asm13613302wrv.106.2024.02.01.04.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 04:18:14 -0800 (PST)
Date: Thu, 1 Feb 2024 12:18:10 +0000
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
Subject: Re: [PATCH v4 07/16] iommu/arm-smmu-v3: Compute the STE only once
 for each master
Message-ID: <ZbuMAq-phWP5KZ3D@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <7-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Thu, Jan 25, 2024 at 07:57:17PM -0400, Jason Gunthorpe wrote:
> Currently arm_smmu_install_ste_for_dev() iterates over every SID and
> computes from scratch an identical STE. Every SID should have the same STE
> contents. Turn this inside out so that the STE is supplied by the caller
> and arm_smmu_install_ste_for_dev() simply installs it to every SID.
> 
> This is possible now that the STE generation does not inform what sequence
> should be used to program it.
> 
> This allows splitting the STE calculation up according to the call site,
> which following patches will make use of, and removes the confusing NULL
> domain special case that only supported arm_smmu_detach_dev().
> 
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 ++++++++-------------
>  1 file changed, 22 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 539ef380f457fa..cf3e348cb9abe1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1588,35 +1588,6 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  				      STRTAB_STE_3_S2TTB_MASK);
>  }
>  
> -static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
> -				      struct arm_smmu_ste *dst)
> -{
> -	struct arm_smmu_domain *smmu_domain = master->domain;
> -	struct arm_smmu_ste target = {};
> -
> -	if (!smmu_domain) {
> -		if (disable_bypass)
> -			arm_smmu_make_abort_ste(&target);
> -		else
> -			arm_smmu_make_bypass_ste(&target);
> -		arm_smmu_write_ste(master, sid, dst, &target);
> -		return;
> -	}
> -
> -	switch (smmu_domain->stage) {
> -	case ARM_SMMU_DOMAIN_S1:
> -		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
> -		break;
> -	case ARM_SMMU_DOMAIN_S2:
> -		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
> -		break;
> -	case ARM_SMMU_DOMAIN_BYPASS:
> -		arm_smmu_make_bypass_ste(&target);
> -		break;
> -	}
> -	arm_smmu_write_ste(master, sid, dst, &target);
> -}
> -
>  static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
>  				      unsigned int nent)
>  {
> @@ -2439,7 +2410,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
>  	}
>  }
>  
> -static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
> +static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
> +					 const struct arm_smmu_ste *target)
>  {
>  	int i, j;
>  	struct arm_smmu_device *smmu = master->smmu;
> @@ -2456,7 +2428,7 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
>  		if (j < i)
>  			continue;
>  
> -		arm_smmu_write_strtab_ent(master, sid, step);
> +		arm_smmu_write_ste(master, sid, step, target);
>  	}
>  }
>  
> @@ -2563,6 +2535,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  {
>  	unsigned long flags;
> +	struct arm_smmu_ste target;
>  	struct arm_smmu_domain *smmu_domain = master->domain;
>  
>  	if (!smmu_domain)
> @@ -2576,7 +2549,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  
>  	master->domain = NULL;
>  	master->ats_enabled = false;
> -	arm_smmu_install_ste_for_dev(master);
> +	if (disable_bypass)
> +		arm_smmu_make_abort_ste(&target);
> +	else
> +		arm_smmu_make_bypass_ste(&target);
> +	arm_smmu_install_ste_for_dev(master, &target);
>  	/*
>  	 * Clearing the CD entry isn't strictly required to detach the domain
>  	 * since the table is uninstalled anyway, but it helps avoid confusion
> @@ -2591,6 +2568,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  {
>  	int ret = 0;
>  	unsigned long flags;
> +	struct arm_smmu_ste target;
>  	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
>  	struct arm_smmu_device *smmu;
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> @@ -2652,7 +2630,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	list_add(&master->domain_head, &smmu_domain->devices);
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> +	switch (smmu_domain->stage) {
> +	case ARM_SMMU_DOMAIN_S1:
>  		if (!master->cd_table.cdtab) {
>  			ret = arm_smmu_alloc_cd_tables(master);
>  			if (ret) {
> @@ -2666,9 +2645,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  			master->domain = NULL;
>  			goto out_list_del;
>  		}
> -	}
>  
> -	arm_smmu_install_ste_for_dev(master);
> +		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
> +		break;
> +	case ARM_SMMU_DOMAIN_S2:
> +		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
> +		break;
> +	case ARM_SMMU_DOMAIN_BYPASS:
> +		arm_smmu_make_bypass_ste(&target);
> +		break;
> +	}
> +	arm_smmu_install_ste_for_dev(master, &target);
>  
>  	arm_smmu_enable_ats(master);
>  	goto out_unlock;
> -- 
> 2.43.0
>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

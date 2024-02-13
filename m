Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D815B5EE95
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707839142; cv=none; b=SpmN6pjffXPjz/qjMGUr3LNW0XhZOWCJJxO+KlY3KI4qWolXIgvuFyIrWGxNEXg2bSDZMMSBUrSJeWMCJbjp1LvhixalyBVMJ3MHSLZw74I5ghLJJSzIE4Y4AZ7sWdfz6ntwTkiHEF2o7nM+f7Bh7p/i7JoFMXK7o4H/bXaVR9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707839142; c=relaxed/simple;
	bh=p2Ne6ieAUSyzVxpunAz6Xx/O5VGZZQOq1WMLyvLSmy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b++4auY4vbgxSafZcVb39C282WacLx6uo0sAqdByY7FtkJEucp0TuWClWf9qioxVSsBM5ACqbIjUoQzuAkRqDNVT0qyHmhbOgPGma6SWK1iMPmPJclEmWXXMnnank0KTaQzu1Pg+gmTYUZkGCjZiSMMMQjJHZqqMnJQ1bX1smNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=puhounHx; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="puhounHx"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-410c9f17c9eso58535e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 07:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707839139; x=1708443939; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdE8AsRwFb0gP05F4tbQ9BZCrEG5/tGeZG6PUCDuRyU=;
        b=puhounHxInSx/3iFPnY1FtKF0LrQlroeH+Fzpma/04OUbHTr8CfJ84wr41s5K3dfWt
         BG1WpPuWMzfh2w9PecB9LbGp1B5TnPAX+eT0h05/PRnn3uTL9AKi5NGAlHIrpSH5N3q1
         18v/jqidblpYsDjZmDwYtPTSFrz5dWEXpp9nxnDPUQ2zTAPNsibfiaquKdY96T1FdRJ8
         f8X1C9/kpiJWMZbrW5T4vnemncpBxMMg1vyVvjc73gUck3vpuwBB98vnMUQhfD3JuP9V
         5ebj0Rhns1DyZXyv0671ELlmrWoZhYy5sk85M6bdSQslTGmMI7m7G44rEFY6VgTD2EGp
         ndkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707839139; x=1708443939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdE8AsRwFb0gP05F4tbQ9BZCrEG5/tGeZG6PUCDuRyU=;
        b=gW6Fazjyeg7bgOd6lr0w3rtwR5w3+p8sfOv0OlIsGPhCauG6CbSP9fmVJEFX6ryNIA
         smiPBgoGYVWuWabR5le+XwSjyLYeSHi0r5dEIKSvhLYENQLf6iAw+YEOgUmPgO/0hbwI
         UObWAAcdLBXwm2v8XOHFkI+Jc5X+G1e4aLpIVofNe7zpC07KaPnbeqHoiy5cLCcAVBdW
         elzvqT9wzcbf8CvrcUW2E4ieQmmGR8Q6HZRLY4L0hw8P6AoIwTtal/AsYJWkTN5+R2Eq
         ZMKdXZ1goFtTE+6VNFGCrh8dZiDVohDTQVQlmw6jfXb1zTzdgHRNcwsXlI/5cNB554lb
         VDfw==
X-Forwarded-Encrypted: i=1; AJvYcCWldxCEIoDkyuUdr1PgKkXHZFDtg3Nsl5RqZ/MLIplcv/K+29ttGUovc80Z0NACdBTMM9dc7mHTyJOPrwp/NYnBjXoolNKeog==
X-Gm-Message-State: AOJu0YxZb+0e8W9XtsCgS+zTRltcv+Jhzz4F28Z6tmVnw14kV2hxMTQz
	fsFiHbaq0v55bKwuS4rfkmUsP2MmxMlWB5ZaqN/1OeyiICmHvO49WLgBMZYMBQ==
X-Google-Smtp-Source: AGHT+IFxoeKa3OTAxaNsO+mmDDhMChpjiPQgXcTp+v8Z1ZiHvEuYhFO4mFCriNtZobQmR1RZo+pMvg==
X-Received: by 2002:a05:600c:a3a3:b0:411:62c:b4ae with SMTP id hn35-20020a05600ca3a300b00411062cb4aemr128735wmb.7.1707839138912;
        Tue, 13 Feb 2024 07:45:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVV96b9s5qGlG18E562U0K/jhVyBjfPg5wT9KEFgL0gRX6FSk6j4vi3fPaYopubvQONtIsbPZ7fF0orfMLNb24rvHrdrvAOWQSrd1tklmwISXfmhn+1n21TphfjAuOVbZYJpAt8D4iNEC2bwtW0BwaZC5RHMCTTmAehDkMIpkX7Wd9o8oWPlVVekkUywEVd1xUcYlsKFt7Q4Jp0v37ul7mUZC8kjXv1jumZIzG6A72y6RGn23u36407QhjWjC5GAcfcrBMblbAnItJtRfzoOTo67sTDGTftxZbr7DAiJrz1Ra8o1/Yb8vGmOxm+DTavufbPpp8yidp/PGuXadXmUMgaMmj6fTwWx7Pavjp0FANWhlgYOrNeoMW3g1c11Q/CUq1ar87hYzEP2PcuwIiITqjdWCdmDr72BivQ1teCuEo8KcNPodf3TM3kES0DFwmWpBNUI6n0PTC7NHG3LpyyLC9YX6dYG4+WTCD35h5yaPE1YPANaV3u0Q==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id fc9-20020a05600c524900b00410727c315fsm12036539wmb.16.2024.02.13.07.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 07:45:38 -0800 (PST)
Date: Tue, 13 Feb 2024 15:45:34 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 11/17] iommu/arm-smmu-v3: Remove
 arm_smmu_master->domain
Message-ID: <ZcuOnnrWN3ZxJY8x@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <11-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:48AM -0400, Jason Gunthorpe wrote:
> Introducing global statics which are of type struct iommu_domain, not
> struct arm_smmu_domain makes it difficult to retain
> arm_smmu_master->domain, as it can no longer point to an IDENTITY or
> BLOCKED domain.
> 
> The only place that uses the value is arm_smmu_detach_dev(). Change things
> to work like other drivers and call iommu_get_domain_for_dev() to obtain
> the current domain.
> 
> The master->domain is subtly protecting the domain_head against being
> unused, change the domain_head to be INIT'd when the master is not
> attached to a domain instead of garbage/zero.

I don't this the problem here, neither the reason for initialising the
domain_head, can you please clarify the issue?

> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++-------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 133f13f33df124..a98707cd1efccb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2560,19 +2560,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  
>  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  {
> +	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
> +	struct arm_smmu_domain *smmu_domain;
>  	unsigned long flags;
> -	struct arm_smmu_domain *smmu_domain = master->domain;
>  
> -	if (!smmu_domain)
> +	if (!domain)
>  		return;
>  
> +	smmu_domain = to_smmu_domain(domain);
>  	arm_smmu_disable_ats(master, smmu_domain);
>  
>  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -	list_del(&master->domain_head);
> +	list_del_init(&master->domain_head);
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
> -	master->domain = NULL;
>  	master->ats_enabled = false;
>  }
>  
> @@ -2626,8 +2627,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  
>  	arm_smmu_detach_dev(master);
>  
> -	master->domain = smmu_domain;
> -
>  	/*
>  	 * The SMMU does not support enabling ATS with bypass. When the STE is
>  	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
> @@ -2646,10 +2645,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	case ARM_SMMU_DOMAIN_S1:
>  		if (!master->cd_table.cdtab) {
>  			ret = arm_smmu_alloc_cd_tables(master);
> -			if (ret) {
> -				master->domain = NULL;
> +			if (ret)
>  				goto out_list_del;
> -			}
>  		} else {
>  			/*
>  			 * arm_smmu_write_ctx_desc() relies on the entry being
> @@ -2657,17 +2654,13 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  			 */
>  			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
>  						      NULL);
> -			if (ret) {
> -				master->domain = NULL;
> +			if (ret)
>  				goto out_list_del;
> -			}
>  		}
>  
>  		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
> -		if (ret) {
> -			master->domain = NULL;
> +		if (ret)
>  			goto out_list_del;
> -		}
>  
>  		arm_smmu_make_cdtable_ste(&target, master);
>  		arm_smmu_install_ste_for_dev(master, &target);
> @@ -2693,7 +2686,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  
>  out_list_del:
>  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -	list_del(&master->domain_head);
> +	list_del_init(&master->domain_head);
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
>  out_unlock:
> @@ -2894,6 +2887,7 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>  	master->dev = dev;
>  	master->smmu = smmu;
>  	INIT_LIST_HEAD(&master->bonds);
> +	INIT_LIST_HEAD(&master->domain_head);
>  	dev_iommu_priv_set(dev, master);
>  
>  	ret = arm_smmu_insert_master(smmu, master);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index cbf4b57719b7b9..587f99701ad30f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -696,7 +696,6 @@ struct arm_smmu_stream {
>  struct arm_smmu_master {
>  	struct arm_smmu_device		*smmu;
>  	struct device			*dev;
> -	struct arm_smmu_domain		*domain;
>  	struct list_head		domain_head;
>  	struct arm_smmu_stream		*streams;
>  	/* Locked by the iommu core using the group mutex */
> -- 
> 2.43.0
>
Thanks,
Mostafa

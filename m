Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F1F5EE7E
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707838842; cv=none; b=CEP5WcBQQaJ8Bf01gIa4Y3qjj9/KyGBCuqiHhCdGJ7JnYKDPotGQbDobtUz4zb6sPjpgJhCOi2bKj9K85+omwzO8R+kDIN146YE8ZrSOi34PibNP5Juzyvhq+egO17aaUgH0m844KBPcDT53iByXnYa0Tg6/4+Gc//KAvPVKuGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707838842; c=relaxed/simple;
	bh=SoC1vM1VWakmCflx+5ZYE3kFhf/c+HSXrbodhC3Rzxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLOcnCEw8DNoZ2jBXrkPuPpy8vmL6FvWEaBnSIzoWSxRQZ2Yy4MyFsAHBprt7umhDYOOXD1w2WbWoFOddl6xMEdTZFnmpkcEb28rQgYXO0ou72V+wpVGHcQ6SHqXvrd3Q9lGIlk+wR9ChKA+hmWFesWp2v+iBlrXOk0NEgVvEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tLH1ljW3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tLH1ljW3"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-410acf9e776so56485e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 07:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707838839; x=1708443639; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ckjCyD/nsa1f3rcx1KK7c4kftMivqCtjqGo13iwhLzg=;
        b=tLH1ljW3ZeoI4u1RiPvO0Xjhz6v77M6QNdAQd90sVwWuWS0/jnsofzVFGcB4/0qqIG
         l/DXDUreaMxD7If8O+4vF3hzmWess2iydMMPFkt39E0Az7zvmi87HLlOup1JUNtIySNI
         VCbnMs1jfKZCUsqvou56/Ir/jeUuFYZPG7Pqu0Lk7TvJvYbETr9uuLCMJ09ZxK/vjG5D
         HViTIIibWO9LN1+7/WvAng+mUaiT2SSesex0OcpGMkQ5fBCmh9uYLBAbad/QXlo2y3JG
         70MeIE+KWi5scFEvi/o3UW5j3PtO3VVmjkoNtxugB0deuWU3uNiazYOGI3nzCf9nlmk/
         CDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707838839; x=1708443639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckjCyD/nsa1f3rcx1KK7c4kftMivqCtjqGo13iwhLzg=;
        b=c1/N/JgitcsfagJlXMQKRuh4M4ZsM37+zhYxiCNuUSAVzRcgHdrS03FVf26mqEuLuZ
         xRhKKsMKVpfnhYulpU9wJv6kXRm8EpXadhOuIWBTkSYgbtfzrafvCsgLBty+D/oDS7QG
         vjoRZIv9+VYUNfhnN6vD9dZWDqatRwJBGogagMXXRzJ+ry0E6qZrErYyo9sYtWsA4aKL
         Bz19SqA3R760zgCQRb7mlU0mbrpjrQEXghKHjiFYaDqPOdVEBxXuIGRvCckOywoDyobI
         K7NSxBgx38os9RC9O7YCgdwGmVVM/qzpQyIgjwkzPoyqh9IT7Y0F4o9uSrWDb9/0eHhi
         N43g==
X-Forwarded-Encrypted: i=1; AJvYcCUkJt2oqCOnZt93zN+hZlsIsqbsxZpfuWTn3UPVpJ9RdoCZOW3Jdt8IGsyyaBIdGTPep9Vi2RELg7XoVS8ig2gzjsRejIVd0A==
X-Gm-Message-State: AOJu0YwVvQvpfTakIHgZLbdjaVkWbMvPwjUsYbenRNfs5y8tR5FUi8cw
	nFqmkUMqhMfgaiS4rkEPpG5GjejcVFV0SnVY7EnemksVYdyxoQZ5Cr1Guu+CkQ==
X-Google-Smtp-Source: AGHT+IGpd6a9Zg9B9baiQAK1R/O2Do8/dtv6gxf3/IPYPXqf3rE06gr2c0mvqSJ2l7HKBd8LAj44cw==
X-Received: by 2002:a05:600c:5190:b0:411:b159:1705 with SMTP id fa16-20020a05600c519000b00411b1591705mr164498wmb.4.1707838839044;
        Tue, 13 Feb 2024 07:40:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXEVL1Ot+nXfCHWHyKLsaARTUgcPFNiSoIsTJZDyvlUzN9DtyffOO+01OE78gYNakhblrTTU4JEHfwfpYRcVvXDhoeU5e9JQ648LBk9Yg0t2yfMu32Pr3VNdP1nJEDYIbGeyl4MgZarvIX574z37V1BwYucYFOkNYeIHu8GRd6OGJ7HWHvsIn4xyyINOe546zl1KUd0m0C7O+GsKA3MzB+tw9ooRa3swLYHbH64JZe7MrSdvywQ/VGeLbNORM8k0DMhGU/gCHIioMElnSPHQXSDremqeXZJ63idAnNqYFAWmBsF/mm1cqmiHUk6IzTxLTmcGEV3JzB9em69GmDC0izse+we+Wd25hsO4wzmuao4Y2NA/DP2W1DVt+ZTYEagZ0OfBYJ9L2jIg/rIgjjMwmExAC4mPrzk93Ws1gyOsVYPm8C3tSbGHbIB+NcZFsT1NFFdtN6kUnQT6jfrtKbB0Bmueg3mmOEmHx3mAhsVdM3ZAxMmyJob4A==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id jx6-20020a05600c578600b0040ffd94cd27sm11909083wmb.45.2024.02.13.07.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 07:40:38 -0800 (PST)
Date: Tue, 13 Feb 2024 15:40:34 +0000
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
Subject: Re: [PATCH v5 08/17] iommu/arm-smmu-v3: Do not change the STE twice
 during arm_smmu_attach_dev()
Message-ID: <ZcuNcka3q3nUOpFM@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <8-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:45AM -0400, Jason Gunthorpe wrote:
> This was needed because the STE code required the STE to be in
> ABORT/BYPASS inorder to program a cdtable or S2 STE. Now that the STE code
> can automatically handle all transitions we can remove this step
> from the attach_dev flow.
> 
> A few small bugs exist because of this:
> 
> 1) If the core code does BLOCKED -> UNMANAGED with disable_bypass=false
>    then there will be a moment where the STE points at BYPASS. Since
>    this can be done by VFIO/IOMMUFD it is a small security race.
> 
> 2) If the core code does IDENTITY -> DMA then any IOMMU_RESV_DIRECT
>    regions will temporarily become BLOCKED. We'd like drivers to
>    work in a way that allows IOMMU_RESV_DIRECT to be continuously
>    functional during these transitions.
> 
> Make arm_smmu_release_device() put the STE back to the correct
> ABORT/BYPASS setting. Fix a bug where a IOMMU_RESV_DIRECT was ignored on
> this path.
> 
> As noted before the reordering of the linked list/STE/CD changes is OK
> against concurrent arm_smmu_share_asid() because of the
> arm_smmu_asid_lock.
> 
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 1138e868c4d73e..340f3dc82c9ce0 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2562,7 +2562,6 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  {
>  	unsigned long flags;
> -	struct arm_smmu_ste target;
>  	struct arm_smmu_domain *smmu_domain = master->domain;
>  
>  	if (!smmu_domain)
> @@ -2576,11 +2575,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  
>  	master->domain = NULL;
>  	master->ats_enabled = false;
> -	if (disable_bypass)
> -		arm_smmu_make_abort_ste(&target);
> -	else
> -		arm_smmu_make_bypass_ste(&target);
> -	arm_smmu_install_ste_for_dev(master, &target);
>  	/*
>  	 * Clearing the CD entry isn't strictly required to detach the domain
>  	 * since the table is uninstalled anyway, but it helps avoid confusion
> @@ -2928,9 +2922,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>  static void arm_smmu_release_device(struct device *dev)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct arm_smmu_ste target;
>  
>  	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
>  		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
> +
> +	/* Put the STE back to what arm_smmu_init_strtab() sets */
> +	if (disable_bypass && !dev->iommu->require_direct)
> +		arm_smmu_make_abort_ste(&target);
> +	else
> +		arm_smmu_make_bypass_ste(&target);
> +	arm_smmu_install_ste_for_dev(master, &target);
> +
>  	arm_smmu_detach_dev(master);
>  	arm_smmu_disable_pasid(master);
>  	arm_smmu_remove_master(master);
> -- 
> 2.43.0
> 
I am still reviewing patch-1 and the hitless machinery (also I think -or hope-
this can be simplified), with the assumption that
arm_smmu_install_ste_for_dev()/arm_smmu_write_ste() will do the right thing,
that good looks good to me.

However, as it changes the current behavior of the driver where disable_bypass
used to override require_direct, I am not sure if this would break any existing setups.


Thanks,
Mostafa

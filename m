Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74715762FC
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134438; cv=none; b=DESTbZ0JqDh15GQc8pKLoxmp2VLoq/QyJsAX0YN0p3Zzl+ZvUz7EC+wFHxqRACDo6Rh1uObUr1d9yrtN+tKkRKy/xAEcc8U2cnT1z7PyjSNSNaZI/mdDEM/FVl/ij2k4UR6IVcytR99HEhmXla+u84Hpp6HOdpepiMLCxQ4qRDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134438; c=relaxed/simple;
	bh=5clcENVPl84v7thAD523MC8hq38AuZBiMpmV/P8IXN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0gU5P2eJs3Fid0M7rcSHn7zFp6LB6wqWivqtfnBAy1HTP960zabSxMUSN7uvd1zpTE5GGTwScCRCfhHpZYW+XFmWljMs87DLmwsvRxo9ASDs/VKvLHZeLWfJjAchxMz6fvJSyRN8MeC8mOf5jLLnmbKZGD1AI6kHaoMrcLP5a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GasikVqr; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GasikVqr"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso14885e9.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 12:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711134435; x=1711739235; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LYZVGNnxMtJXmO/rMtm5YPA7SokYhXE01EEUSWS+tyg=;
        b=GasikVqrJktaOYlx370eaM9zq74Oi//j4eAfMYZfW5fKGW8bYlhrEfJCqe0D7klKke
         RZZ6pUnH/ZYjnd00+jXuzzlG1NenMBImzkYnO9OrTGsr6dXNLyVTguFsIMfc02SFiR8S
         8oFFXmD2HPzM4f3MQlomohcIkSbV7lh26Rb8MwsnoZJ7SZbnDxCBqPXCun9U5xsRKeZf
         iWlQkoMIwsT87zNxzmxUxvDVrD5FjqAr6HOyUjNUT1SOxxcWRnTHR5a3ync85S8hDOsO
         EQI7zW+BidPh9CU42K4oaX8ILl/7SjMVG4KA/flD4Ow7OXjK8rvsqQryK8OYlsSKbxLR
         krQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711134435; x=1711739235;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYZVGNnxMtJXmO/rMtm5YPA7SokYhXE01EEUSWS+tyg=;
        b=VUOekaaOUvvdvbWHaa+HCM7VfEf2LI3Q2zQ+P095f8zXxVflxN4wVjs/erxSgl/icj
         7WFSB5awjaq01zydfSvPH//oNIZC3+1ugjjWHTVgCjTMT7H7AO25kU2BMqhw4yUf1eqr
         QA20sF6UOYXfMnlnzkh14NMCmHRv5t2jqU5eIUvgtakIvCuBQVnSC8jG0hV0cSgdPaTJ
         AfKZDU+0OzUg541u/vyqd6p0VHzDWChWJyofCxPpHYU+YmZrNtOXS5kVhfMbqJtwUBvO
         zTHPlkjYpuKbMrJ4OmI6tCNHYGsj7EP6zwQtQj0AtYt9qS5cx/2sxja/wusiJQ4asNWP
         NgWg==
X-Forwarded-Encrypted: i=1; AJvYcCU/tc1RTgfGhuNjzx2IPe1dVQG8KLi5MrxhbslTAUGJQ4I0HWCqBoG8ghjc6GG3OLwDmmryF8l067lvtXcsH9d+govFoHuGjg==
X-Gm-Message-State: AOJu0YxTExoRSi9btLI1EnD/aO2BirqQurrFWoG1uiT7DIZLkP6i3xml
	4VVbdxxmK4h/dCBfAGhg1ooEt0wwmi+SH/YESBlzObgl6tcpDtyfALfoBplHWg==
X-Google-Smtp-Source: AGHT+IHNc62m491wU+HcWk/9byQ0VfDf2/ltTaBrjP1Nag9akn0HzUFm/eSmTJ1AFlgyZ9X7wmhRpA==
X-Received: by 2002:a05:600c:1d22:b0:414:76df:2d42 with SMTP id l34-20020a05600c1d2200b0041476df2d42mr414216wms.4.1711134434744;
        Fri, 22 Mar 2024 12:07:14 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id u12-20020a056000038c00b0033e456f6e7csm2773566wrf.1.2024.03.22.12.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 12:07:14 -0700 (PDT)
Date: Fri, 22 Mar 2024 19:07:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the
 cdtable into arm_smmu_get_cd_ptr()
Message-ID: <Zf3W3lo8dXZuKbgm@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:56PM -0400, Jason Gunthorpe wrote:
> No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
> able to return an entry in all cases except OOM

I believe the current code is more clear, as it is explicit about which path
is expected to allocate.

As there are many callers for arm_smmu_get_cd_ptr() directly and indirectly,
and it read-modify-writes the cdtable, it would be a pain to debug not
knowing which one could allocate, and this patch only abstracts one
allocating call, so it is not much code less.

For example, (again I don’t know much about SVA) I think there might be a
race condition as follows:
arm_smmu_attach_dev
	arm_smmu_domain_finalise() => set domain stage
	[....]
	arm_smmu_get_cd_ptr() => RMW master->cd_table

arm_smmu_sva_set_dev_pasid
	__arm_smmu_sva_bind
		Check stage is valid
		[...]
		arm_smmu_write_ctx_desc
			arm_smmu_get_cd_ptr => RMW master->cd_table

If this path is true though, I guess the in current code, we would need some
barriers in arm_smmu_get_cd_ptr(), arm_smmu_get_cd_ptr()

> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e25dbb982feeee..2dd6cb17112e98 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -106,6 +106,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
>  
>  static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>  				    struct arm_smmu_device *smmu);
> +static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
>  
>  static void parse_driver_options(struct arm_smmu_device *smmu)
>  {
> @@ -1231,6 +1232,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  	struct arm_smmu_device *smmu = master->smmu;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  
> +	if (!master->cd_table.cdtab) {
> +		if (arm_smmu_alloc_cd_tables(master))
> +			return NULL;
> +	}
> +
>  	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
>  		return (struct arm_smmu_cd *)(cd_table->cdtab +
>  					      ssid * CTXDESC_CD_DWORDS);
> @@ -2719,12 +2725,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		struct arm_smmu_cd target_cd;
>  		struct arm_smmu_cd *cdptr;
>  
> -		if (!master->cd_table.cdtab) {
> -			ret = arm_smmu_alloc_cd_tables(master);
> -			if (ret)
> -				goto out_list_del;
> -		}
> -
>  		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
>  		if (!cdptr) {
>  			ret = -ENOMEM;
> -- 
> 2.43.2
>
Thanks,
Mostafa

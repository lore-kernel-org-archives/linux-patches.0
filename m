Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE11B5821
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725031628; cv=none; b=eHOSXuy+Q+n0Dyoh0Qc2zipGYgCDx50ZxA3b1z0eZrcq18jBBAzpilz17+lGUTQCyts3UylWeVwTiZXb66sHBp5MheLxXaZ/nJDArKuDHj3rL4iH90OgBvBZUGIpZLpo0ErEhS0RXeqiveVSoZzEt5te+adc2m4U08pU4yFadWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725031628; c=relaxed/simple;
	bh=eW7ITzzwk9ygkd2IBGeFmo01XiG9+lP5rghpWtFyhxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isQkSwgJb4RSDpRY21hQDtc25ZEdr5mzGmJZ/NjHck0Ka3RuRmBnGqZ1Xar5MQVpEnAk6nXZ4yKQ0KqoG+q9ryMYdMBbkpbrSNII3PqDgr4dIQ8oV1Nf282XEk5Dyg+5+/UeN3wmdH/YxIDmWzCTylfrTsz5gMTVkIb8xucCQy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZNt+F279; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZNt+F279"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42ba8928f1dso56115e9.1
        for <patches@lists.linux.dev>; Fri, 30 Aug 2024 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725031624; x=1725636424; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H3AaOlacpjrdS6dYgrqk+vOy/n/WnhMvz5SZv0q3vtA=;
        b=ZNt+F2797tAHgm2KgdgPTW+Cr2Uoqk0L49we7heTcIL/e/o4quRKzec3tDO6ciBpmy
         EVwUHhQ2bTufbaOvK5UGnoVzPfo2CviOC53X4SD9QamgBs/qaJI9I0v+O9nYP+op7Rs0
         S7tdcqSVNlLrxHMojGxcMU3oxTEH/RAWXEdGd+bO+yf+0KQ8ycsUCdHAMaYFTKCg1MNb
         KZq7RnhdIUdctt4LzZdr6t4DbCWEW25CFREMWuyebBEITRiJzrEppLHuJPw8gReKT0Ao
         UJGo06AI4YK0gyPTeWP/gMv1uq6786lPrpcbktH87hM+nW+9OYuHj9UQOlDM4M62Vpjq
         t0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725031624; x=1725636424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3AaOlacpjrdS6dYgrqk+vOy/n/WnhMvz5SZv0q3vtA=;
        b=P2I7ceXU9hQZ74K+kuUoqN2KUQ45dLJ8+8yaNLtrEzJ4J39Y2yQJIXBzfXrkpR+QGH
         LIN9NouzxLzIjaTFR9ATukc5BF5tg83spapcD95TSJW8muhitcMPSOQnmecIcTpP2NRK
         ILKEnnyZ4lFOmsWVZhnJQ1m+w7MPSyckpC+F0ia7lSPbh9O3FHSa2oGnj1nihZ8GytJW
         T5TYrawGK1IplQXkD9w/+eT9TO2L8hSL0c4fK/AKQEWeI8+xCVVOa1UefmdaMPALIxRx
         QPIALdU2PNGG6yofkL7JsAfIcusXJYf6omXrvkny4e5g0VSVnMsakVcTI3BxZL00Nt4B
         ZVUg==
X-Forwarded-Encrypted: i=1; AJvYcCWn0EamfGLj8LHSNM14I/1Gi6dOvoZ5WHsxcL81Mwpv76HRT3lPuzOym0DfLi3pUas99SiszPhA@lists.linux.dev
X-Gm-Message-State: AOJu0YwaiSHlbrQFkcgq+zzDKUCOXfzVwutwLf3pblZYmbXip8T/N09r
	SUYs+Z8xWZ1Y3k+zYtWYSlniy/mxkDxldVU6mncn/tY/7jgzQkRi/dLk7BDZHw==
X-Google-Smtp-Source: AGHT+IGXR29Kld8IDQGNVEA4AoJiwGiXxRFNMNP4VkTKAZ9VuEsRIqNCnFf+Xrf87qSHJgw8pR22qg==
X-Received: by 2002:a05:600c:1da1:b0:42b:892a:333b with SMTP id 5b1f17b1804b1-42bbaa2b0a9mr1463235e9.2.1725031624257;
        Fri, 30 Aug 2024 08:27:04 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba7b4271fsm78764955e9.29.2024.08.30.08.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 08:27:03 -0700 (PDT)
Date: Fri, 30 Aug 2024 15:27:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <ZtHkxFrojjXplvvn@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 27, 2024 at 12:51:37PM -0300, Jason Gunthorpe wrote:
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
> 
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index ec2fcdd4523a26..8db3db6328f8b7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  			   const struct iommu_user_data *user_data)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
>  	struct arm_smmu_domain *smmu_domain;
>  	int ret;
>  
> @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  	if (!smmu_domain)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> +		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
> +			ret = -EOPNOTSUPP;
I think that should be:
	ret = ERR_PTR(-EOPNOTSUPP);

Thanks,
Mostafa
> +			goto err_free;
> +		}
> +		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +	}
> +
>  	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
>  	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
>  	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
> -- 
> 2.46.0
> 

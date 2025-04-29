Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC426A0CA
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745963054; cv=none; b=VnTuIVmNbclVbbqtkyU7TkXANi6Qh3zWKbO3PoTfyOxaReP/ZoeTIqsHIcqTtLD/uyoiBnylEu2IvhIQArOEcnZ0mm+akEm6u+bTc1BQ1KY8rsPMG/dJ7gyMhGai+egJnfoNrNeDSypMn1jk1nCsCZZQFTGT/zkmqqEC3ex74ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745963054; c=relaxed/simple;
	bh=woal7ohbjfSc1j5RViMLKYP0aErf7+Ky5j5wTig+x8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8unJi4kqnU1MbEo1BkmaOek+rzN2w4enY1GqL4ET7bDa/08VRBR7PJgu2A7BmhHOqf5D+OptUcmmo6bAXqXD9MNy7BLPjo3az0KB4N6tgQ5OjMuL/ukzT1aYrrJYSR7jMO3MD5l6qxDN8cOCeCZRpzoBZsGETNCRUUvqRMI9qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UrKNxAf1; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UrKNxAf1"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2240aad70f2so241855ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 14:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745963052; x=1746567852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EjhyY3r971ECUhfqqbl7u+2Mh/jYqDkZEBXpIERaB8I=;
        b=UrKNxAf1QR1FuOSYNHANbomdTDzXgBtDwPPe1ekwfp/8R+sa2IkYy1VF4PPJ0Mb27K
         3J9/BPvPpQCIIWWxrOWgCeiOhx6PNRXKY3OiXSz0BoBW6NCNUu9vITCPjKtD1dKQZPxJ
         P+S0aGp0TpcTfGp200t8EQ1rm+mfrcxVTyqJ05sEcYUw7QnO0NC8MJ/ySi/dF7riId2e
         LzjqlAXrYququArs4413E35rLppLhHoq1JTU5d3DfHeiQOJpgF+28z+o6MfD1jqFIdDG
         ZMYLH8gwEtpWJUIvx8M2hvFZbPwKe454MKedfDAyGw+aT2XfmMxjtR7nqGopBNnm8uuM
         XSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745963052; x=1746567852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjhyY3r971ECUhfqqbl7u+2Mh/jYqDkZEBXpIERaB8I=;
        b=agk1YAa3b+jvuj/PzXJHf0G1qdFVIf4mAftTDTNe6tWUmgwW1ZhlIsu6Zx+uFKQmOP
         zhzoepIfe3mzTNzZETkreemTgx+GQYzslmivWiOjw7Sm7dj+Uyw3AHNy7tn3ke8Ogzeh
         H/y48IxCy47BNtqtYVKfya8pOOJA+8se3+jzumUWFbq8DErO9awLWI8ok6Ha7P5pYKWB
         xcZ31KcKZ+Evix4YnAiue6ORYAWKGXS8IlgU6TAl9kusAHMXTUfgT7+QA9b8NcK/8SqS
         OrOA5crnRgANnRzXxfYu1rhQ19ekclyIZunOmRqMmUQaNZ9Fhx1W+BUC1CTYUYACyUiv
         vkhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqoRUFsmmZ1t2kNHU7ZOkI2N/AnsXPRQcDZoSBJ/fPcw3r+vjt/Mu5+/1D5d8jmxPFDoQD7SQu@lists.linux.dev
X-Gm-Message-State: AOJu0YyGfpkUAKdBS1MJoAQUnNs8dCzHLHQzG9lmVMser8d6XGOPa2k/
	fEgE94bJlfHzHw5SujI3YwRpWDWBiHKj6749WDFL/T5vPN+2F4g8Tb1bAPeMnA==
X-Gm-Gg: ASbGnctqUitFI5knBT6EDR9rgCwLZ1clGQ//+gOacjbJvakB120NpHOvenswIG3roEc
	ctbEKquEpeFqYv+JkOMVzG7CIG25pKOZScGxox+KfdQSSVy2RSykJZ3g6sKfesApaMi71fXlJFv
	3TE8MiUvAV9blWmXUwWSqG5NEsElZ6gs+w3TYBtw0uRGPjTwJ0AVfDku2Bs1FnWEsnUPZaoOeVe
	+lsyeGfbDKXuOt6AXA8iIBiGvnjtWJKzag2tOSySonhlypIWrXK1LRNyfJI73XuX7i9na3FaG7e
	Np46ExaYm1QrlmpPAzRM6KiVYKwAO203J3n9jmebpuA7sQaeZxeThjuU+Awe6GA5Txh04nyh
X-Google-Smtp-Source: AGHT+IGRVChNm/D/6XmLJRuqupUIJJIIhE6A6CeVKWfGeNxHpzqOmQegP9ON+cIaJRAsz/EcrzoqDw==
X-Received: by 2002:a17:902:db12:b0:224:6c8:8d84 with SMTP id d9443c01a7336-22df3f77cffmr1031875ad.4.1745963051511;
        Tue, 29 Apr 2025 14:44:11 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5f86esm25958a91.44.2025.04.29.14.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 14:44:11 -0700 (PDT)
Date: Tue, 29 Apr 2025 21:44:00 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 17/22] iommu/arm-smmu-v3-iommufd: Support
 implementation-defined hw_info
Message-ID: <aBFIIJPmjIOecCMj@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <56f048cdc9cd8bf1569434633d709d07a78e9430.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56f048cdc9cd8bf1569434633d709d07a78e9430.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:12PM -0700, Nicolin Chen wrote:
> Repurpose the @__reserved field in the struct iommu_hw_info_arm_smmuv3,
> to an HW implementation-defined field @impl.
> 
> This will be used by Tegra241 CMDQV implementation on top of a standard
> ARM SMMUv3 IOMMU. The @impl will be only valid if @flags is set with an
> implementation-defined flag.
> 
> Thus in the driver-level, add an hw_info impl op that will return such
> a flag to use the impl field.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h      |  1 +
>  include/uapi/linux/iommufd.h                     |  4 ++--
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c  | 16 +++++++++++++---
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index a5835af72417..bab7a9ce1283 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -726,6 +726,7 @@ struct arm_smmu_impl_ops {
>  		struct arm_smmu_domain *smmu_domain, struct iommufd_ctx *ictx,
>  		unsigned int viommu_type,
>  		const struct iommu_user_data *user_data);
> +	u32 (*hw_info)(struct arm_smmu_device *smmu, u32 *impl);
>  };
>  
>  /* An SMMUv3 instance */
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 06a763fda47f..b2614f0f1547 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -554,7 +554,7 @@ struct iommu_hw_info_vtd {
>   *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
>   *
>   * @flags: Must be set to 0
> - * @__reserved: Must be 0
> + * @impl: Must be 0
>   * @idr: Implemented features for ARM SMMU Non-secure programming interface
>   * @iidr: Information about the implementation and implementer of ARM SMMU,
>   *        and architecture version supported
> @@ -585,7 +585,7 @@ struct iommu_hw_info_vtd {
>   */
>  struct iommu_hw_info_arm_smmuv3 {
>  	__u32 flags;
> -	__u32 __reserved;
> +	__u32 impl;
>  	__u32 idr[6];
>  	__u32 iidr;
>  	__u32 aidr;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index a8a78131702d..63861c60b615 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -10,7 +10,9 @@
>  void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct arm_smmu_device *smmu = master->smmu;
>  	struct iommu_hw_info_arm_smmuv3 *info;
> +	u32 flags = 0, impl = 0;
>  	u32 __iomem *base_idr;
>  	unsigned int i;
>  
> @@ -18,15 +20,23 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
>  	if (!info)
>  		return ERR_PTR(-ENOMEM);
>  
> -	base_idr = master->smmu->base + ARM_SMMU_IDR0;
> +	base_idr = smmu->base + ARM_SMMU_IDR0;
>  	for (i = 0; i <= 5; i++)
>  		info->idr[i] = readl_relaxed(base_idr + i);
> -	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
> -	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
> +	info->iidr = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
> +	info->aidr = readl_relaxed(smmu->base + ARM_SMMU_AIDR);
>  
>  	*length = sizeof(*info);
>  	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
>  
> +	if (smmu->impl_ops && smmu->impl_ops->hw_info) {
> +		flags = smmu->impl_ops->hw_info(smmu, &impl);
> +		if (flags) {
> +			info->impl = impl;
> +			info->flags |= flags;
> +		}
> +	}
> +
>  	return info;
>  }
>  
> -- 
> 2.43.0
> 

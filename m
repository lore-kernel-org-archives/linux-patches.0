Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6D32550CC
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745962582; cv=none; b=RBNkAJjncxuvGqybDduz/wVNJ+bHlLNuT5L/Ljjv9ozYt+k4dHDPZ9gOWEbUEu6hMDwCcp//07QJS+wG8bLGJ4F+XXY7BArz1jAo2YDn+Vbjc5ThFQL2YyPXvvu7vFgt03pk3GaiNVYhk6PYzpZsGlrX6wyErW1Y6CZkM+9nRWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745962582; c=relaxed/simple;
	bh=pjG0WRYPmuFXgp5l4sOIxBPQ0JCTtzB9fn/bSzP4aws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phXdd4iT58CNkCGW3DcrM+3psP6Pk7KYcKE+YhRYlxbP6ZlA5iveLmJgSQxJXwOGrjhaO/tIRyFJAGCpdY7QvIiR1w2WKa1XmNb+yDuQbE+hOKenuaL21FSIZ86xCOOizHGlGNV0kjNR1Fk5+Yq6vQCJEqhoD/DEReo8BSWFzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CCRUrEJn; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CCRUrEJn"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2264c9d0295so238305ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 14:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745962580; x=1746567380; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFHhD4L18F4DbheB1ANr+oLMK0ky8CpJtw12v2WCTVo=;
        b=CCRUrEJng05XUkBo50iIH5tihCSCm4Ig/+trwl+LmFMN6nNBZy4E5q04GmoXxJf20N
         F0rWuqpFtsMwV6xZV4qSr1eFfCAlyQ05i+tm3AFS27G8tspa4rISG2KFqb97EvmFWBVb
         2xjrwoEPNmdOBa30mSopsA5+jmiuDf77cKRz7+yO6sbDY5NB0DjPwAA5VEgPXFabCVSh
         6nanD5Vh20WEdmGfpx+eaX/zH4nwu14qV2VSBCOaQB2GVNPQWn/5R0JQktlg7itN8uCS
         wmjOlJZVBabD7Ft6emD+Pi/aUevuI45vNuC1V2FA4Kj0KuF0/tuuXFMMBrQdjRcwOyft
         q+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745962580; x=1746567380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFHhD4L18F4DbheB1ANr+oLMK0ky8CpJtw12v2WCTVo=;
        b=Bb5wo/E/S2kLv845T0E4atbTN/6z2RqmKjBIqIAhkyXhLjMJg9ydATG+gAkxyOU0IB
         KWG7cF2R+XC26iVmjjbtP2TZwNPX00RdX4JGOJuLtr+GQlg32Nwe3SJSt9P+PCvb0ujh
         C4QYE4WDlDGEjpq7Mcf5wy/EZb04mJC/Ube9gV1k7gZNvQtXhMiJQW3TiU5K+B/g6G80
         1F+5etlyqLjrd+AQnGI41kLvwbJmGCXeI6F3Y0FkUTGDBR37qzl6z+aaw205BvEUISa4
         G28z64IbqUxAmama/INUZ6hCcZVA2J/RhD7rVewei03d57ox4cSy95fqg0bQLkBmyNQH
         jaDg==
X-Forwarded-Encrypted: i=1; AJvYcCUyNyCJYGYeqpe8Uz0CNXzSq3qLA6W/A2qFoIIGHbfHc1WC7KtrTeuGRV/e7Uv6CT176CdQ+z54@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx9aX1pLJeuDuph169K69GYDt8AQwlfiyQ7YeWv6i4c5FvwP2s
	eiXUh7prRgwgL9FJfMvSBwEw56jRz5rNPP9lmRvbF/RHmtp9ejZS91o+XRDpgg==
X-Gm-Gg: ASbGncvxhUpFHwPIzIkXyn3myQ5YSdCABrbl+oElaiZdicKo8lsZMy9bzFo1a87IRHm
	y56tUj+y9GciSoZPBXtGbMZxPb2LF9iKJrpSD+6z5SBym8eyGBoDoyUBcyXtkG7nM0KdpmS+Q0K
	vYI+lray28qNZv8pVscawdxsnj0qKZ8X5nbnSZFQfY3mv5A1fMirdChVfwYcVylmIbrz+gyLMOI
	n6FT90BOLBfIH540RyhXNOMt6PsW9eOUhYIvCYVSJtuQDloNOKq3QQiaZX30ccp6E6Q+RWMSqCw
	qluIs92AnW3pgYd8hgk49FrzRNvNHBRTlMoLFl/lw9cPxAL1pfREUwjfpYUmmoRkISmjBCLg
X-Google-Smtp-Source: AGHT+IHMqNgjircjCmAkmKl5VbBskPIbU47nTYxADS2hK6tD9L6Ge4YAR4USLtbPpDWqfiuVVAQ0lQ==
X-Received: by 2002:a17:903:144f:b0:21f:3f5c:d24c with SMTP id d9443c01a7336-22df3dda537mr1044155ad.0.1745962580224;
        Tue, 29 Apr 2025 14:36:20 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4d76d34sm108297185ad.39.2025.04.29.14.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 14:36:19 -0700 (PDT)
Date: Tue, 29 Apr 2025 21:36:09 +0000
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
Subject: Re: [PATCH v2 16/22] iommu/arm-smmu-v3-iommufd: Add vsmmu_alloc impl
 op
Message-ID: <aBFGSRGcIsCDU1Zj@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <73b1fc34b07f2ac42d542dd996c7119ae5f8939c.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73b1fc34b07f2ac42d542dd996c7119ae5f8939c.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:11PM -0700, Nicolin Chen wrote:
> An impl driver might support its own vIOMMU object, as tegra241-cmdqv will
> add IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV.
> 
> Add a vsmmu_alloc op to give impl a try, upon failure fallback to standard
> vsmmu allocation for IOMMU_VIOMMU_TYPE_ARM_SMMUV3.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewd-by: Pranjal Shrivastava <praan@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 ++++++
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 17 +++++++++++------
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 6b8f0d20dac3..a5835af72417 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -16,6 +16,7 @@
>  #include <linux/sizes.h>
>  
>  struct arm_smmu_device;
> +struct arm_smmu_domain;
>  
>  /* MMIO registers */
>  #define ARM_SMMU_IDR0			0x0
> @@ -720,6 +721,11 @@ struct arm_smmu_impl_ops {
>  	int (*init_structures)(struct arm_smmu_device *smmu);
>  	struct arm_smmu_cmdq *(*get_secondary_cmdq)(
>  		struct arm_smmu_device *smmu, struct arm_smmu_cmdq_ent *ent);
> +	struct arm_vsmmu *(*vsmmu_alloc)(
> +		struct arm_smmu_device *smmu,
> +		struct arm_smmu_domain *smmu_domain, struct iommufd_ctx *ictx,
> +		unsigned int viommu_type,
> +		const struct iommu_user_data *user_data);
>  };
>  
>  /* An SMMUv3 instance */
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index 66855cae775e..a8a78131702d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -392,10 +392,7 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
>  		iommu_get_iommu_dev(dev, struct arm_smmu_device, iommu);
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>  	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent);
> -	struct arm_vsmmu *vsmmu;
> -
> -	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> -		return ERR_PTR(-EOPNOTSUPP);
> +	struct arm_vsmmu *vsmmu = ERR_PTR(-EOPNOTSUPP);
>  
>  	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
>  		return ERR_PTR(-EOPNOTSUPP);
> @@ -423,8 +420,16 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
>  	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> -	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
> -				     &arm_vsmmu_ops);
> +	if (master->smmu->impl_ops && master->smmu->impl_ops->vsmmu_alloc)
> +		vsmmu = master->smmu->impl_ops->vsmmu_alloc(
> +			master->smmu, s2_parent, ictx, viommu_type, user_data);
> +	if (PTR_ERR(vsmmu) == -EOPNOTSUPP) {
> +		if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> +			return ERR_PTR(-EOPNOTSUPP);
> +		/* Fallback to standard SMMUv3 type if viommu_type matches */
> +		vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
> +					     &arm_vsmmu_ops);
> +	}
>  	if (IS_ERR(vsmmu))
>  		return ERR_CAST(vsmmu);
>  
> -- 
> 2.43.0
> 

Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6856B6F
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517255; cv=none; b=ucq9rt44+c6wd2mn2yYXvgGRrHOdqKvuoRwNObGvDs6umES2vZ4JSRGOmolpcBnkW7CcZ15NC4hYIekri1d3b0rvzthOrhNygUIARdyPG/uqiIrmrYQtbKQuOGAJ4UXG5mAgnNwPPSxb9BZQj82x/oIZ6qJU66IrbJ+DH143VzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517255; c=relaxed/simple;
	bh=7sEHSgHTH1wi9BL399o4pIcn6bpHm9mxHfuKif9hxvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZ5CbKbuHoAZGyVmD/ogrX7GwuQxiNC1/rOLjzVFnGSZrz8MT/OL87cl7nYoIgnsuIimhLeCKajG35Il6qQcqiBL21b0kmv7k2LOkBAlR/CuG3L72eJGVe2C/6zEAG1kFV4AhUhhbv9/BVRtjD6ModfMz0I/2M/iWTUXlTN72bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1PAuJcD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1PAuJcD"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4213a2acc59so108765e9.1
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 09:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517252; x=1718122052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j6IBMlbCwbxtgXzmlYBvTO7Gmj2Kf/XCsg/PolHHAtc=;
        b=m1PAuJcDNLBqrrtquQSKhqjB2CIaaE4LsVfrAeXkNHaA2WLNZC/9pJGEGevjTTgH9X
         sXF4Xl6SOyl6IqTY6qk/SaLBu/EU7R0GW5WUAaVZXkKgteYjN4wDIPR10xbllMsJoxsA
         z9pa0C8wnWAQQNe+iYYGdOPfgNET45vTOBmod+s7DwEJHZ2DKTDRrQ7oPyEeGEpDBXFU
         Hop4zRwyEi79+mRX/BIljic9q6nBgixrxex5Z/WD5OIJrHegxTsa7qZlfDYFouoh0kPO
         40LnWIh1n8jwXDVBlT+6p2081w5azzyafDc1vDyWsVn2yh8pNug5KuNd2+XNPgbNH+6W
         QJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517252; x=1718122052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6IBMlbCwbxtgXzmlYBvTO7Gmj2Kf/XCsg/PolHHAtc=;
        b=uKOI39eUwzsuxqrCuO4yBXQrD6HlP9lYBE5B1bHNKgPIXvmVuiDJFjsAtoKCEpzCXm
         sdHLk+xnGq1vnqLlj4shL/dLjOmw35Y7zeseMZ5KWYpXqA2QQnzRO2J7qZ3M3i9JC98V
         AGsVltsQu6/Z/4kMGSFFw3ecHqAzm3v/TDbcBinXGFHoVQuJds02sHct8FYF3e9bgvvk
         nOWDXpa/bd6HEtr7MfHk9grgRfy/5V3XFao2sCPHDurtry7RPd1lcfJTDmjKJowYtBMR
         HnkELhAPCJKVdCusJRGSIkLu59H/5DJ/hlz96UzYTOZLcZrUC87aqI7lUcMayNAMQss/
         M4LQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAu3ToOEMBdjl03o/LQNrlEyX/OdvSWcw6aLcIhWuWFCeX1ZNTsE9FlbEwT5VfqTmMYPObQ4XqePFyLFVc/CyTD7ttnbRgaw==
X-Gm-Message-State: AOJu0YwhazXrMvfwy/hdRXclUKpRTc3ZeKOxLJQkiUyCoOJ2yA+VjEvV
	/sbouZCw4ngSgx4+qvQmyIbgVOmuO3S7u9XHnJC+J99MCKmCLoFS0q2iRSITAg==
X-Google-Smtp-Source: AGHT+IGSdGh6/lK/tR/YkD9ol9SDg56kySSbj8FeCuBClEo8QYaxGvXB6ZFkC6gtdkLBtZglpOa7yQ==
X-Received: by 2002:a05:600c:214e:b0:41a:444b:e1d9 with SMTP id 5b1f17b1804b1-4214947b4f8mr2953025e9.4.1717517245740;
        Tue, 04 Jun 2024 09:07:25 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421381c650csm117293755e9.27.2024.06.04.09.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:07:25 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:07:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 4/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_ctx_desc_cfg.cdtab
Message-ID: <Zl87uRwIJyfMW1xs@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <4-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:30PM -0300, Jason Gunthorpe wrote:
> This is being used as both an array of CDs and an array of L1 descriptors.
> 
> Give the two usages different names and correct types.
> 
> Remove CTXDESC_CD_DWORDS as most usages were indexing or sizing an array
> of struct arm_smmu_cd.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 60 ++++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 17 ++++--
>  2 files changed, 41 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 735dd9ff61890e..24c286a0834445 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1170,7 +1170,7 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
>  					struct arm_smmu_l1_ctx_desc *l1_desc)
>  {
> -	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
> +	size_t size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
>  
>  	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
>  					     &l1_desc->l2ptr_dma, GFP_KERNEL);
> @@ -1198,12 +1198,11 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  	struct arm_smmu_l1_ctx_desc *l1_desc;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  
> -	if (!cd_table->cdtab)
> +	if (!arm_smmu_cdtab_allocated(cd_table))
>  		return NULL;
>  
>  	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
> -		return (struct arm_smmu_cd *)(cd_table->cdtab +
> -					      ssid * CTXDESC_CD_DWORDS);
> +		return &cd_table->cdtab.linear[ssid];
>  
>  	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
>  	if (!l1_desc->l2ptr)
> @@ -1220,7 +1219,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
>  	might_sleep();
>  	iommu_group_mutex_assert(master->dev);
>  
> -	if (!cd_table->cdtab) {
> +	if (!arm_smmu_cdtab_allocated(cd_table)) {
>  		if (arm_smmu_alloc_cd_tables(master))
>  			return NULL;
>  	}
> @@ -1236,7 +1235,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
>  			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
>  				return NULL;
>  
> -			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;

Similarly to patch 1, I believe we can get rid of CTXDESC_L1_DESC_DWORDS entirely.

> +			l1ptr = &cd_table->cdtab.l1_desc[idx];
>  			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
>  			/* An invalid L1CD can be cached */
>  			arm_smmu_sync_cd(master, ssid, false);
> @@ -1342,7 +1341,7 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
>  	struct arm_smmu_cd target = {};
>  	struct arm_smmu_cd *cdptr;
>  
> -	if (!master->cd_table.cdtab)
> +	if (!arm_smmu_cdtab_allocated(&master->cd_table))
>  		return;
>  	cdptr = arm_smmu_get_cd_ptr(master, ssid);
>  	if (WARN_ON(!cdptr))
> @@ -1352,8 +1351,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
>  
>  static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  {
> -	int ret;
> -	size_t l1size;
>  	size_t max_contexts;
>  	struct arm_smmu_device *smmu = master->smmu;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> @@ -1366,8 +1363,14 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
>  		cd_table->num_l1_ents = max_contexts;
>  
> -		l1size = max_contexts * (CTXDESC_CD_DWORDS << 3);
> +		cd_table->cdtab.linear = dmam_alloc_coherent(
> +			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
> +			&cd_table->cdtab_dma, GFP_KERNEL);
> +		if (!cd_table->cdtab.linear)
> +			return -ENOMEM;
>  	} else {
> +		size_t l1size;
> +
>  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
>  		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
>  						  CTXDESC_L2_ENTRIES);
> @@ -1379,24 +1382,15 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
>  			return -ENOMEM;
>  
>  		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
> +		cd_table->cdtab.l1_desc = dmam_alloc_coherent(
> +			smmu->dev, l1size, &cd_table->cdtab_dma, GFP_KERNEL);
> +		if (!cd_table->cdtab.l1_desc) {
> +			devm_kfree(smmu->dev, cd_table->l1_desc);
> +			cd_table->l1_desc = NULL;
> +			return -ENOMEM;
> +		}
>  	}
> -
> -	cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
> -					   GFP_KERNEL);
> -	if (!cd_table->cdtab) {
> -		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
> -		ret = -ENOMEM;
> -		goto err_free_l1;
> -	}
> -
>  	return 0;
> -
> -err_free_l1:
> -	if (cd_table->l1_desc) {
> -		devm_kfree(smmu->dev, cd_table->l1_desc);
> -		cd_table->l1_desc = NULL;
> -	}
> -	return ret;
>  }
>  
>  static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
> @@ -1407,7 +1401,7 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  
>  	if (cd_table->l1_desc) {
> -		size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
> +		size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
>  
>  		for (i = 0; i < cd_table->num_l1_ents; i++) {
>  			if (!cd_table->l1_desc[i].l2ptr)
> @@ -1421,13 +1415,17 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
>  		cd_table->l1_desc = NULL;
>  
>  		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
> +		dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab.l1_desc,
> +				   cd_table->cdtab_dma);
>  	} else {
> -		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
> +		dmam_free_coherent(smmu->dev,
> +				   cd_table->num_l1_ents *
> +					   sizeof(struct arm_smmu_cd),
> +				   cd_table->cdtab.linear, cd_table->cdtab_dma);
>  	}
>  
> -	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
>  	cd_table->cdtab_dma = 0;
> -	cd_table->cdtab = NULL;
> +	cd_table->cdtab.linear = NULL;

nit: AFAIU, arm_smmu_cdtab_allocated() was added to check the cd table existence
regardless the config.
So, I think we should be consistent, as here it is set as linear, while it can be 2lvl.

>  }
>  
>  bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
> @@ -2955,7 +2953,7 @@ static void arm_smmu_release_device(struct device *dev)
>  
>  	arm_smmu_disable_pasid(master);
>  	arm_smmu_remove_master(master);
> -	if (master->cd_table.cdtab)
> +	if (arm_smmu_cdtab_allocated(&master->cd_table))
>  		arm_smmu_free_cd_tables(master);
>  	kfree(master);
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 280a04bfb7230c..21c1acf34dd29c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -279,10 +279,8 @@ struct arm_smmu_ste {
>  #define CTXDESC_L1_DESC_V		(1UL << 0)
>  #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
>  
> -#define CTXDESC_CD_DWORDS		8
> -
>  struct arm_smmu_cd {
> -	__le64 data[CTXDESC_CD_DWORDS];
> +	__le64 data[8];
>  };
>  
>  #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
> @@ -312,7 +310,7 @@ struct arm_smmu_cd {
>   * When the SMMU only supports linear context descriptor tables, pick a
>   * reasonable size limit (64kB).
>   */
> -#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / (CTXDESC_CD_DWORDS << 3))
> +#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
>  
>  /* Command queue */
>  #define CMDQ_ENT_SZ_SHIFT		4
> @@ -593,7 +591,10 @@ struct arm_smmu_l1_ctx_desc {
>  };
>  
>  struct arm_smmu_ctx_desc_cfg {
> -	__le64				*cdtab;
> +	union {
> +		struct arm_smmu_cd *linear;
> +		__le64 *l1_desc;

As patch-1 also, I think naming is confusing.

> +	} cdtab;
>  	dma_addr_t			cdtab_dma;
>  	struct arm_smmu_l1_ctx_desc	*l1_desc;
>  	unsigned int			num_l1_ents;
> @@ -602,6 +603,12 @@ struct arm_smmu_ctx_desc_cfg {
>  	u8				s1cdmax;
>  };
>  
> +static inline bool
> +arm_smmu_cdtab_allocated(struct arm_smmu_ctx_desc_cfg *cd_table)
> +{
> +	return cd_table->cdtab.linear;
> +}
> +
>  struct arm_smmu_s2_cfg {
>  	u16				vmid;
>  };
> -- 
> 2.45.2
> 

Thanks,
Mostafa

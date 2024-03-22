Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA4E78264
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134918; cv=none; b=SsXUVGO+gqskMcua71K/Gb8Mq+GJMoSPty+CEfzyymAyQOg5CeSBXAq7uE1EwL9qg55ZPOpWiqxIx6+QoIS4uasXW9CgEW3dZ1nx1tYqYwAP71y2t7FjoQzAUgBEtQNgIXIP00xAZjz26FENWpDoNA7eCKYSuZTx8xCItS/UUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134918; c=relaxed/simple;
	bh=nquismUMtJbdmPgTSsZdryuDeqLxycmHVim+dtrmKe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPDtVRYN6554Dv53db6MfiFpQ+p7bQ3MgbjhHoRCkFnkVapqhOmU2w2MjJjcEslZrbeXjtDwCxZ+D82lOGJ4gsVdyuiMsPmtiRn4nJwTj1fkISmxnN2lIHm2A3GZ849O5bmSQdJcl+CIlRWI+Yuw5uvV7LBcbntNfhIhJ2YCDiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UjrEyny6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UjrEyny6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso15235e9.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711134916; x=1711739716; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iBmwPWfj+P0UyE+jUv3x1rbO+OO3VlNB3fzoExTZCpI=;
        b=UjrEyny6wn7gvweu3B7Oph5ENnkuj26xBxj0RSfWYrJmMvU+jsDPsMn+4D+6JV3hVx
         /LqrkxuxEvquGnnjZTXnsvhtuM8Dcnmmax2VOPiuJuEHy0BoSFl+Xo9l/HekmHIZPJ5c
         bTAQIhSNkVKL2G4xqWLsZlBNfQD0gk/YFc8ylS9dF+AIDmlaf1UWVEMOlPMSe6A6Fm0Z
         wl+JY2hiu1KKrzURBpcBG+N5tsIO7yiXbYbWskYPTY7diFFIzrRskPG8vQzqpwWx+ob5
         qw7QYz3QpctnTbKt0qyf0MWNR2qMGik+kP+JYdZEhOqqjwetLQKHcSXvWe4c2/QhKaeH
         5ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711134916; x=1711739716;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iBmwPWfj+P0UyE+jUv3x1rbO+OO3VlNB3fzoExTZCpI=;
        b=XkVLp7P4RMJ2tCBgmfqsZfnDKfBfYyUUel31ZIyYrB+FFpvRbd3FArIahH1CkXXsul
         KSB5Vae9wdYFga/QOs0DKM+Avze18V5vqoeO7UFpS5y6NI7ozPhOdqqylj02IAh/UkJZ
         zqbpfnFhwqNUjauU4j2yh1MK8U4S2FiA7dpfght6ichDVjeggxj9K4VZkf/jjhZK55hR
         remKl0OWv+yuspCchMUf/HEOAkuyQ4zDYRhAM4tFEC3A7h+5i4BEUwSFq64EuKc16k6w
         6qrtt5yADJDzEAssfh2Add2H8NtxLRDGn9hil/6omJUo9xG+3schhp/6/bunX2o0oB4S
         i16A==
X-Forwarded-Encrypted: i=1; AJvYcCWJRUxixnUMdjvsldgbQbPEsX3UX9hpiesfcwuuj5GuhcCaBPVC164OREVvvwEibPw5Z+M71G6eVLfkpKPwppjgHxyp0egyKg==
X-Gm-Message-State: AOJu0YxqCzPixkBbJBCFKBUqVBidzzvfWG/ocfbx20lZr+L6JyrMROvG
	Z00X/J/bMRZO4hUdtRLlM9O06VUJytMV91zYwnPei5JBvNpXARnbBV0dWK5vXA==
X-Google-Smtp-Source: AGHT+IFCfF66X3KOP2ZhTbkhD7eO1ULUJHDki2BPmbB/rZoGnUCW/kWVXFNirPzcY13hMF06gu5a/Q==
X-Received: by 2002:a05:600c:3b94:b0:413:f266:c654 with SMTP id n20-20020a05600c3b9400b00413f266c654mr520651wms.1.1711134915484;
        Fri, 22 Mar 2024 12:15:15 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id v9-20020a5d43c9000000b0033ec9007bacsm2679247wrr.20.2024.03.22.12.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 12:15:14 -0700 (PDT)
Date: Fri, 22 Mar 2024 19:15:11 +0000
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
Subject: Re: [PATCH v5 09/27] iommu/arm-smmu-v3: Allocate the CD table entry
 in advance
Message-ID: <Zf3Yv4kzZH49RNq0@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:57PM -0400, Jason Gunthorpe wrote:
> Avoid arm_smmu_attach_dev() having to undo the changes to the
> smmu_domain->devices list, acquire the cdptr earlier so we don't need to
> handle that error.
> 
> Now there is a clear break in arm_smmu_attach_dev() where all the
> prep-work has been done non-disruptively and we commit to making the HW
> change, which cannot fail.
> 
> This completes transforming arm_smmu_attach_dev() so that it does not
> disturb the HW if it fails.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 2dd6cb17112e98..39081d828a2132 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2676,6 +2676,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	struct arm_smmu_device *smmu;
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  	struct arm_smmu_master *master;
> +	struct arm_smmu_cd *cdptr;
>  
>  	if (!fwspec)
>  		return -ENOENT;
> @@ -2704,6 +2705,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	if (ret)
>  		return ret;
>  
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> +		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +		if (!cdptr)
> +			return -ENOMEM;
> +	}
> +
>  	/*
>  	 * Prevent arm_smmu_share_asid() from trying to change the ASID
>  	 * of either the old or new domain while we are working on it.
> @@ -2723,13 +2730,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	switch (smmu_domain->stage) {
>  	case ARM_SMMU_DOMAIN_S1: {
>  		struct arm_smmu_cd target_cd;
> -		struct arm_smmu_cd *cdptr;
> -
> -		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> -		if (!cdptr) {
> -			ret = -ENOMEM;
> -			goto out_list_del;
> -		}
>  
>  		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
>  		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> @@ -2746,16 +2746,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	}
>  
>  	arm_smmu_enable_ats(master, smmu_domain);
> -	goto out_unlock;
> -
> -out_list_del:
> -	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> -	list_del_init(&master->domain_head);
> -	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> -
> -out_unlock:
>  	mutex_unlock(&arm_smmu_asid_lock);
> -	return ret;
> +	return 0;
>  }
>  
>  static int arm_smmu_attach_dev_ste(struct device *dev,
> -- 
> 2.43.2
>
I believe this is fine, I couldn’t break it. With the comment on the previous
patch, where we explicitly allocate the CD here and not inside
arm_smmu_get_cd_ptr().

Reviewed-by: Mostafa Saleh <smostafa@google.com>


Thanks,
Mostafa

Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E206C5F574
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707838745; cv=none; b=qcZX25CG7jCnp32zEdbczOdyF1geuLM8V9HwGJRld5emdcmYq0mZZeOr7fXmY94+BVqvOJXMcdXH13pY6lOnmFasBFUoGjzIj1wkeiNBSpD30q7OlH7gTnwhQ3iNQ2PTcxr9dtRpU5vc4sVL9lP9kQDYOfccVaTC5XfVchdIoKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707838745; c=relaxed/simple;
	bh=L1Lus6uaMIL3OY6Dg1PFhHKAkVF/O0Gj/XjTib5m130=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5CGsTjnoakP0iQf78nSMe6NhRvYq3h2tfS8fxDv3azH3kl8toNeF0K9IOxssGkPXhfS/aiSHb/OMBXECZJkgaKKcnzPSBak3hi2Sc4/h4NPiT+RPxV3sX+n8zMflT1chsKug00vGdh1OpzvDfONJJGf10akdhv+m64KYFoqnqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R8R+OgFF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8R+OgFF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40f0218476aso56485e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 07:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707838742; x=1708443542; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ahN0nmrpb9Pg2/fqwLNzPwdlfnOoMk8HeVysrNU2Hkg=;
        b=R8R+OgFFbLFcqSsMSIzRGe1gvMeN+7bll/lBaBxE5q311Zg1aJMX5boRoabRkoFs/y
         NX9xLDN+uJbA3Yd71PrF3T3Na5vQx3qTLMbVGFlehvP3LyTGEG/gFNP/I7xTT3OeUSJs
         I4+RyXsQ9vfUmBsrmyuIqHDhwbKYprTXAAGhorFvr+qzwqWY4yx3XYcMXed6AaAnqtRO
         NUwAU0q7uYYhFdZbY+HQwIT8aGtwNPp2PwcOzfz8If9cT3FiFBfRTOzz7DKVx5EBP/zl
         DosZ/58B07X3ULjw9m+COrvyuxIrugZze3v1SpsEXbKVO7zwTXNEM5Wnrz04Rt3RjNIS
         YIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707838742; x=1708443542;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ahN0nmrpb9Pg2/fqwLNzPwdlfnOoMk8HeVysrNU2Hkg=;
        b=ICgXFG71WKDw2VAEayrPXn/MqZkkkw6izGktB1CLJIQgMwUq1hbupOxzrEqtUf2drB
         QY3SwcXoOC2fsKvIThdx7wcEE7Xn4upjqGprnlrwtj5J0BFXQDo+nplv1B348DjefD7N
         t1eX+Wlrvjc8If722mW1BMGwjfKE2+3BGdSAfAZ360AKyccMc+kB6OROFXSFsRYSqk7v
         zgvs6DKyBDbISteZTrQ3uJsjQi0lcnP3q/e+8xrDSmeYiStHa7BWOq8yLGL12nZDV1HL
         inL/tng0LHuZaNCDqlyyTDWkIgluf0fSFS7RGuUxgzbjvfuwzeAvPNbjZjfETh21d+Dw
         lG+g==
X-Forwarded-Encrypted: i=1; AJvYcCVPILciHJlQOtZ4KZCXyI5fSbsBq5toqwma3SCrAxhlQNczsUG7aZIIvAsheDgn3B76cB7S9vFlgXutWXFCSJneEPF7OwpGuQ==
X-Gm-Message-State: AOJu0Yx9fHp0t3gHKkgI7LHwZfxuAJjMEocO1vLye2Gpf8j/CjffBxSc
	MMF5ghFuOO8lQsTXZkUv77/7CXzkM8RlDarUlR4zAqLZQtwXRMT7+YGJHdLGFg==
X-Google-Smtp-Source: AGHT+IE0BU+kteu4xy3hpmJ4do7EkKNyGdY32im6cPy0bJisixaZyEIG/V2mOJb9jwVfQ8HO/5E0qA==
X-Received: by 2002:a05:600c:6014:b0:411:c78a:748 with SMTP id az20-20020a05600c601400b00411c78a0748mr91089wmb.5.1707838741801;
        Tue, 13 Feb 2024 07:39:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUdBtwYXsCMSLcXzB/hmOPLaOMVNI6/JirIc920WYcRWfF7hwSMpXfnnueJB7M0PZ0xfL7musl1vnFEhI5YKV8Rgi0EDm7zgKbKFCobNeKaMHert3Pib7qesGtKXsJUzAEoZdmtn3p/HZ0KNppCLNcYzIm1rO4Gf2GPBKGJdsy8r29FrZTmuP3F8CPWtPiw4TRNcT4dVgyUo7LPDGKAFdz8FDF+R4qNoELKx6/N69zMvfy0RY2Anre9TwfRZmNRw1qq0qH5w89MSehqf3+KXt6V7UnWRCimSkJn2IX9QA65GTw3WhTtkx+8G+aHRUDtTeQ1lh3KKaZXO+wR8sCmPD9f+gGRhYqmMEtF7LknACYdJLoZGIJQ87qJypbTvGgaUV3rIhgMMSsuOF2DXvtkn9gUeOHioV1YNtII9uMpARAUgzbUmR5VtQ1KgSGZAG8F82TuHbrzkntCa4KfB1yye0END5o+alKPTkBDmFyePh5v0yeJkIEfIA==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id q17-20020a5d61d1000000b0033940016d6esm9776711wrv.93.2024.02.13.07.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 07:39:01 -0800 (PST)
Date: Tue, 13 Feb 2024 15:38:57 +0000
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
Subject: Re: [PATCH v5 06/17] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock
 during all of attach_dev
Message-ID: <ZcuNESWmrC9jZ9lM@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <6-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:43AM -0400, Jason Gunthorpe wrote:
> The BTM support wants to be able to change the ASID of any smmu_domain.
> When it goes to do this it holds the arm_smmu_asid_lock and iterates over
> the target domain's devices list.
> 
> During attach of a S1 domain we must ensure that the devices list and
> CD are in sync, otherwise we could miss CD updates or a parallel CD update
> could push an out of date CD.
> 
> This is pretty complicated, and almost works today because
> arm_smmu_detach_dev() removes the master from the linked list before
> working on the CD entries, preventing parallel update of the CD.
> 
> However, it does have an issue where the CD can remain programed while the
> domain appears to be unattached. arm_smmu_share_asid() will then not clear
> any CD entriess and install its own CD entry with the same ASID
> concurrently. This creates a small race window where the IOMMU can see two
> ASIDs pointing to different translations.
> 
> Solve this by wrapping most of the attach flow in the
> arm_smmu_asid_lock. This locks more than strictly needed to prepare for
> the next patch which will reorganize the order of the linked list, STE and
> CD changes.
> 
> Move arm_smmu_detach_dev() till after we have initialized the domain so
> the lock can be held for less time.
>

This seems a bit theoretical to me also it requires mis-programming as the master
will issue DMA in detach, but as this is not a hot path, I don’t think overlocking
will is a problem.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 417b2c877ff311..1229545ae6db4e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2639,8 +2639,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		return -EBUSY;
>  	}
>  
> -	arm_smmu_detach_dev(master);
> -
>  	mutex_lock(&smmu_domain->init_mutex);
>  
>  	if (!smmu_domain->smmu) {
> @@ -2655,6 +2653,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * Prevent arm_smmu_share_asid() from trying to change the ASID
> +	 * of either the old or new domain while we are working on it.
> +	 * This allows the STE and the smmu_domain->devices list to
> +	 * be inconsistent during this routine.
> +	 */
> +	mutex_lock(&arm_smmu_asid_lock);
> +
> +	arm_smmu_detach_dev(master);
> +
>  	master->domain = smmu_domain;
>  
>  	/*
> @@ -2680,13 +2688,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  			}
>  		}
>  
> -		/*
> -		 * Prevent SVA from concurrently modifying the CD or writing to
> -		 * the CD entry
> -		 */
> -		mutex_lock(&arm_smmu_asid_lock);
>  		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
> -		mutex_unlock(&arm_smmu_asid_lock);
>  		if (ret) {
>  			master->domain = NULL;
>  			goto out_list_del;
> @@ -2696,13 +2698,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	arm_smmu_install_ste_for_dev(master);
>  
>  	arm_smmu_enable_ats(master);
> -	return 0;
> +	goto out_unlock;
>  
>  out_list_del:
>  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>  	list_del(&master->domain_head);
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
> +out_unlock:
> +	mutex_unlock(&arm_smmu_asid_lock);
>  	return ret;
>  }
>  
> -- 
> 2.43.0
> 

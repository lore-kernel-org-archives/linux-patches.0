Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B5C5B672
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707838982; cv=none; b=D47cRFqRbmd2R8/E1yc9Apr/N6lnIi2ruEEROIQVBWcCm3R/c04EFm8kenCMP5+Ooqm2sg40+k5AfITzPrf46P268eLcHQMS6EOU4jgveaS3KLl1N7HxXyFDq4EjCzd0zCVxEdu0qzR6V78/9lEvAa8LVWsjU9x58MqX/ANS3B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707838982; c=relaxed/simple;
	bh=6/AT8iJeTcyl0pH7C+fpkpyARJZx4RvtTWgT4hA4oP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LD8NVGuZ3Ig9iGX+wV8nsWIP0LGhEn9bDMEuxpw+qlhHsWsdjmxPFW8hxn0z8Z+DRBebvKgwkNZku8w4QCAK4KrK/zra2CsmLQ/7CrtzOTasZ5UVOAsjf7m1Sw0LN6y/0ZGTfAlmG0JFE0tD1/Pm0hLaAmO+TpZMVQ9k/ZMCzOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=031i9T6I; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="031i9T6I"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36427a3c284so3085ab.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 07:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707838980; x=1708443780; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IQj4uDUjleUNCBs7Qf2PtjvmRXZjXT8PKaV2xAnFLBE=;
        b=031i9T6ID2zcaRleSVS4wJe+BoSrTo4lS4Q9/k+TPKTCHmsa44jO0mpKs5eJlnppbZ
         dqS2A6r3ZnS1+4LoIrRUandUKkrNbAISQvVyPVp0PBA6OWH5L+9SlewL9wd4R8yTERs9
         SNkfi8B2NdWOBwtf+x52av8t/x9a6VFvvZ9K5auN9vbk/fCaKiX9ZFbbNE9kBavPn/td
         olHoRxw2PZPzhuXYSj8lm/RX1ySvOLufvLdyzgbOO80AMMCc1hLlEwMHhfC4gqEQ4YS3
         Y0AJXKFhPYvD1GalyMJEZqJu6Otg4M7JK02aWbx7AAtxPwbRWIHdgwgkerljuA3KiFu1
         6mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707838980; x=1708443780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQj4uDUjleUNCBs7Qf2PtjvmRXZjXT8PKaV2xAnFLBE=;
        b=tWYuBuBw0oR1Ox/9EYqjC1VfdDQeVoE9SsAjU0lwVvthjv/YuW9XQwTz9YEwwjmcyp
         yIJMjGqDJUKF1ZbGzmfq3EXoCdi96uAVsFKvf9Zv8+c9+LmnOvAKeGxm8xsw7wC+V96x
         izXgfuP4iVRkxNlgEuh5pu6PD+RePHIp0719dsKOYmbEQkFrwJ7iM9VW8EOUC7xyZn+A
         Abq+FwZVv8Ljx7OGpp4j74gJA+yFUoq80LM57Su3kGrFQ1que5WeE9gYnIEZR7PaV3W2
         PIkUMrkZdSAYCH8r6o4ui+2oickE+6nJOOofQDe4hLGuO+sPlAfKgvqlWTfhCH9Wfo94
         PP5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhO9PwjhqG3KwyfH6mLrclKpFQX0Kn/wXNrmMueywBtYzlOHpTjylytH9rArZL3g6mPBnDVYNp93BVXT9COg//h7UzXsUNug==
X-Gm-Message-State: AOJu0YzNrdNAlnvP99p8wjgnnWs5Ef0/zS5eod+RTfAT+OwaV51EltEd
	6FQyNIj4+qoc7n5Gs4vMuf4Au9qp6VdEcvQmQpXgAIJcnfIBQYSFTj6DySvCWg==
X-Google-Smtp-Source: AGHT+IHrmt2yIYNczd9dlMrOYLjL0HvWgFOQEgQ4dUIGRMglwxWo6MZ5EwZZ07CEHSW7fv6EX0rvOg==
X-Received: by 2002:a05:6e02:2:b0:363:ca7e:91d with SMTP id bb2-20020a056e02000200b00363ca7e091dmr157249ilb.21.1707838979628;
        Tue, 13 Feb 2024 07:42:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvxD2AtspGmOWuZJ2M5EAm6FsThntWIjcBIt6gmDrpuNhYqzgUWgZy8OmLxEJXlRa4YNKfovhu1N0OA22phRbZcdaYsmA95Ig58UygBl9asphYwptHxRyuhbtg0FZpcjTtZ8RDU+wIY1H/auMWliWvvxrkZFu03a8r9VF6dvoeJ75yFoUbWMcI+scdMlbZXULtdcIpHJMGPnp2gmavIxa6PSyJfB7ikoMSAkNxah3QC+sOBQwOlVv5rfzP23zLIoaBzzgatPtNfTyANKVTlVaN4DR7uxn+id0Q3tSTN5e/4+8KU7PnpzGeo85GSvESxcJbLdbofhg4Vf0UaULka6lj7o6iVb4z58C4fYvncRTxxav3u+jclq4XBuRA4ZjrvZhGn296hCxqPfuJp7VykFyImyxLXUBiLXqXNrx0KbugFJmkwZ17lnVwOlphOjHrB4pqihVQl5/hJK8oQdaCZ2j0jwgElwsPsDKdis8OHrVd9o8HCi9hpQ==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id l186-20020a0dfbc3000000b005ffc15cea80sm1775540ywf.26.2024.02.13.07.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 07:42:59 -0800 (PST)
Date: Tue, 13 Feb 2024 15:42:53 +0000
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
Subject: Re: [PATCH v5 09/17] iommu/arm-smmu-v3: Put writing the context
 descriptor in the right order
Message-ID: <ZcuN_YZBzxJ2wvAg@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <9-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:46AM -0400, Jason Gunthorpe wrote:
> Get closer to the IOMMU API ideal that changes between domains can be
> hitless. The ordering for the CD table entry is not entirely clean from
> this perspective.
> 
> When switching away from a STE with a CD table programmed in it we should
> write the new STE first, then clear any old data in the CD entry.
> 
> If we are programming a CD table for the first time to a STE then the CD
> entry should be programmed before the STE is loaded.
> 
> If we are replacing a CD table entry when the STE already points at the CD
> entry then we just need to do the make/break sequence.
> 
> Lift this code out of arm_smmu_detach_dev() so it can all be sequenced
> properly. The only other caller is arm_smmu_release_device() and it is
> going to free the cdtable anyhow, so it doesn't matter what is in it.
> 
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++++-------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 340f3dc82c9ce0..2a6ac0af932c54 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2575,14 +2575,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
>  
>  	master->domain = NULL;
>  	master->ats_enabled = false;
> -	/*
> -	 * Clearing the CD entry isn't strictly required to detach the domain
> -	 * since the table is uninstalled anyway, but it helps avoid confusion
> -	 * in the call to arm_smmu_write_ctx_desc on the next attach (which
> -	 * expects the entry to be empty).
> -	 */
> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 && master->cd_table.cdtab)
> -		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
>  }
>  
>  static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
> @@ -2659,6 +2651,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  				master->domain = NULL;
>  				goto out_list_del;
>  			}
> +		} else {
> +			/*
> +			 * arm_smmu_write_ctx_desc() relies on the entry being
> +			 * invalid to work, clear any existing entry.
> +			 */
> +			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> +						      NULL);
> +			if (ret) {
> +				master->domain = NULL;
> +				goto out_list_del;
> +			}

Instead of having duplicate
           if (ret) {
               master->domain = NULL;
               goto out_list_del;
           }

In the if and the else, we can just move it outside.

>  		}
>  
>  		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
> @@ -2668,15 +2671,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		}
>  
>  		arm_smmu_make_cdtable_ste(&target, master);
> +		arm_smmu_install_ste_for_dev(master, &target);
>  		break;
>  	case ARM_SMMU_DOMAIN_S2:
>  		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
> +		arm_smmu_install_ste_for_dev(master, &target);
> +		if (master->cd_table.cdtab)
> +			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> +						      NULL);
>  		break;
>  	case ARM_SMMU_DOMAIN_BYPASS:
>  		arm_smmu_make_bypass_ste(&target);
> +		arm_smmu_install_ste_for_dev(master, &target);
> +		if (master->cd_table.cdtab)
> +			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> +						      NULL);
>  		break;
>  	}
This invalidates the CD while the STE is in bypass/S2 which is a new behavior
to the driver, I don’t see anything from the user manual about this, so I
believe that is fine.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

> -	arm_smmu_install_ste_for_dev(master, &target);
>  
>  	arm_smmu_enable_ats(master);
>  	goto out_unlock;
> -- 
> 2.43.0
>

Thanks,
Mostafa

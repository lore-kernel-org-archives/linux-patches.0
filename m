Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452184DA09
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 12:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706789762; cv=none; b=VyQZv9oIMxjKUgRUuwfI4xrUoolQ1vQDD5BRZIXfoQosb3Xt6l0pEOgV1bwyck76pNzEuomf4GtWcU+fFdg+OxY+NmYLMjjaYktbzzPYr9n3FCcllKB3nDwIXEgazq9JEggjGFV5I8S1KUInhKxyV0LfoNweL5poS0JZQpxDV7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706789762; c=relaxed/simple;
	bh=SFsL/oGqWpgc6lFN1WEaTjkfK9CV44kWOLq3bM4OCYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nC6YIh7IjTslGetVQwWbAeP3Rtl+Y9mL8Az4b7mgIAMR40AHBwqgp57Asojwo7RRPONjoqoLJ4ZoHPRUtgM2K4X76220hSa51f9knH1Ha3Ed9fxyLK7aMLYENbjA2CsVsW0rna3O6sOcIdFICvEDDNh/ohbHg3iD8zD0OmKPryA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUpHUfrA; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUpHUfrA"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55f85a2a43fso10213a12.1
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 04:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706789758; x=1707394558; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cve+q1TZtCVqvyVnUQyH2Cq09HKM/U+2tnIu1KSKKcg=;
        b=OUpHUfrAHVNXUjx+oBZSJcTYxZUb3mfIRzdOs/qAWa17GtLKs//fuxgWrJAap5XBsO
         f+r8DBVRr53LNg534XClqRTadIEeri7X0MfycIpkYd0Pd47sEQoeNFkx7AhaIu//7e4I
         yPuLplMf4koPXHt80PtrK0/5AER+ef+7XGcvpVGb53ZkPl/csnSkbSpDqoRCSVxmG4ez
         +mrJTAZQsBUdWrTdujvfWCVKABoHB6mH7S98807JbsAdrBAUW/lvY+NxgmKxM2zhYcEk
         OXEvUGC+rA4IlUUzPFqe1UfSOwaZYxvL0oYM48p9TcGTdjyQxZg0iq2imXWljOEldDZ3
         mP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706789758; x=1707394558;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cve+q1TZtCVqvyVnUQyH2Cq09HKM/U+2tnIu1KSKKcg=;
        b=R2zV7xWhDpE40KPwdf6UbdlRr+8kqaqWFAjgPmwMbg6ymHd+iYpkNsg8vQEN9UIm5G
         2a3S8K/CVI1/ObW2WOYijZoh14Q4Tx6Gi6zw9I4Z0Cd4MuoiJv1xVxaW403rgaWiQJD5
         mp7n8CZsrdu2BQ8RT2EopNZaVeGRkEWH+3KbjUeO3gxXum3+29NeFtQPEJjjKe8VITIB
         2ZTRk5j631BypD6v9zjpQ0N+9FgrLTbH2X5yi7Ic4JD8YNbPs9l9D6BWJHY2QwCS0aW5
         pEGPtpfhZLWUaVn8kmsgLX5aIare/T42GEmxODNYnLWp8pHH6CoEGo3jrfYirFuBO44+
         jj0A==
X-Gm-Message-State: AOJu0Yw1kY97tjpfnp3vL21scWbzyPb1tdrcDWWomHArjZkUWIe8E7Lq
	HeVQ/Xy2j42+pynB6bVaSWvrEZ5eShDrPmji1hVhMyx2zd/+WnB0CNCj98GsRA==
X-Google-Smtp-Source: AGHT+IHy1BHTCsh/42eBIgRQC6BQGnV05xiXKU8/nomBidZfv5pBBsK0ygZYeANcbrgw5sK9uzanEg==
X-Received: by 2002:a50:d54e:0:b0:55f:b5a3:e2b4 with SMTP id f14-20020a50d54e000000b0055fb5a3e2b4mr122757edj.7.1706789758212;
        Thu, 01 Feb 2024 04:15:58 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWgcgdkyotuywgnji7Lsr9mrvbMtY2+6Pmuodeoib/LTzKufe2dpr7/6JVlZPI9S/1LXXZaPqQ8egGQBtwyrvrh9AdpIuW9LjrWJLgLXNLP6pOBgWjRYSKM/dzZ5KNzJG4V6/BltYOhve+IVvASamxZXLnkf01ojn+jqb/YHU/TAFMjCImrpqRe+cXrmIaSiEucMQVQ7sUTxdCbzev8oePxvX3LG8hYiQIgrgQNkfKbS8tHvkfDyX0jg0TPEffckSHbFGN9NauYv4OpOTdM+hkIWFU84CnGguuPopMs/V0jEW+uxMWy1tlJAkgJCoRo5pVl7+UEMtlZd0Sxp9uPPduiI0zyOJ49tXJxBuU/yX0t+bQ1+RHsi5Qg
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c198f00b0040ee51f1025sm4283470wmq.43.2024.02.01.04.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 04:15:57 -0800 (PST)
Date: Thu, 1 Feb 2024 12:15:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 06/16] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock
 during all of attach_dev
Message-ID: <ZbuLeWDvhhufT7Pa@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <6-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Thu, Jan 25, 2024 at 07:57:16PM -0400, Jason Gunthorpe wrote:
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

I don’t see the race condition.

The current flow is as follows,
For SVA, if the asid was used by domain_x, it will do:

lock(arm_smmu_asid_lock)
Alloc new asid and set cd->asid.
lock(domain_x->devices_lock)
Write new CD with the new asid
unlock(domain_x->devices_lock)
unlock(arm_smmu_asid_lock)

For attach_dev (domain_y), if the device was attached to domain_z
//Detach old domain
lock(domain_z->devices_lock)
Remove master from old domain
unlock(domain_z->devices_lock)
Clear CD
//Attach new domain
lock(arm_smmu_asid_lock)
Allocate ASID
unlock(arm_smmu_asid_lock)

lock(domain_y->devices_lock)
Insert new master.
unlock(domain_y->devices_lock)

lock(arm_smmu_asid_lock)
Write CD
unlock(arm_smmu_asid_lock)


In case
1) domain_x == domain_z(old domain)
Write to the CD is protected by domain_x->devices_lock, so either:
    a) The device will be removed, so SVA code will not touch it, and the
    detach will clear the CD.
    b) The device CD will be updated from the SVA with the new code, but then
    it will be removed from the domain and cleared.

I don’t see any case where we end with a programmed CD.

2) domain_x == domain_y(new domain)

Similarly the device would either see the new CD(new asid) or the old CD
then the new CD.

Can you please clarify the race condition? as it seems I am missing something.

> Solve this by wrapping most of the attach flow in the
> arm_smmu_asid_lock. This locks more than strictly needed to prepare for
> the next patch which will reorganize the order of the linked list, STE and
> CD changes.
> 
> Move arm_smmu_detach_dev() till after we have initialized the domain so
> the lock can be held for less time.
> 
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
> index 9a95d0f1494223..539ef380f457fa 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2612,8 +2612,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		return -EBUSY;
>  	}
>  
> -	arm_smmu_detach_dev(master);
> -
>  	mutex_lock(&smmu_domain->init_mutex);
>  
>  	if (!smmu_domain->smmu) {
> @@ -2628,6 +2626,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
> @@ -2653,13 +2661,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
> @@ -2669,13 +2671,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

Thanks,
Mostafa

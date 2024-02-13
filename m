Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD455C15
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707831020; cv=none; b=FegWNfux1mrEoDnUruIpS6K8VoNdhK1aQfpadIEnp2+J5I7XHuj2IMUH6d3aqSu9yguSXHTQwCwEWGXtTjTi7whb0dZc7X/kc1imJPEPOZ3/tZzzcCmMe7XoVsHwf3fhBcpg17/4KqXC6Meol6A3p4lLuFzeehdEBGS/iAT/ShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707831020; c=relaxed/simple;
	bh=w6rrzEkQ9sbIscG9qMmeS4EQKw9vsBSJYh5Dt5G2eI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjY2qmhPIPaLmni4+pLVRrC4xmu3EmPnwVTTZuNPkiky/ORQTKT9Uze7DYpondjiRVwHqR5N/3lI+nLerWeczqyS0FH/XysSg4fjy0uWWp1vaN+DS6fSmHGsg3Ln9bNJCzjO/WQvSMwAWv96mZimOcV9ERhWsciURfsGBkX91IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IwIfayb5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IwIfayb5"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40f0218476aso45895e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 05:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707831017; x=1708435817; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O57At8ub1ZMuG7YEr2MIUoA58g/Pbzb5DNgQL9CZLkQ=;
        b=IwIfayb5/f9YBj/QPSJTP5QB+aUQRYVQqbiuNjVvowL6Qt0u8iAdE9e2PKUVN1ZLgZ
         WkQvyURWX0zSMDUH+pPZGFCfymit7BznYoOT9DxT+wspV6vR98pOrOHeMuV+Fpbez+fS
         7JVQdN/frjDTitQwP6/Ujfe2MuS2Ll3EAZRTrR8bOkpOhMW8BZbazMndyJeudwFmnvLK
         Z5458AH+j59AlBtfotFIt+esd9FasU51b9KZB+GogD6qcHAzwyeCZvbOUOC/BT7QDfVs
         M9nxFUUcfYm78Ie3yUH0uIAX+iQ8+luULFJyxPiv/ODtG+D4PCpOdJfhaRg2vyLkBwPU
         68AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707831017; x=1708435817;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O57At8ub1ZMuG7YEr2MIUoA58g/Pbzb5DNgQL9CZLkQ=;
        b=TycSCv71/0IJCutQ5F0PxZXX8VZd3dr+uaZLQGvI5vmp4K3Ko92eAZtIgPSij40Liy
         xbjj1ABMg5iG4anFvVq02y0/3c88pKyMDY28yeo+x7CQ/Obkb1luLOPkwCf4cgvJA7ht
         MMXnfmvUkRy2YBzShakwHDzHkxa2tHC9nwBUq9sVsKcgH2Zqlnc7qqmXD9XU9VInhdqU
         qKoUQMK7HctEuxd6pP2iSw/BLjzsBNbrm918SZ7AzhvIVs1L8yeWxMSCHtoSVVwu+nR6
         U7WyRXH8adMfqgUzTj/vsWSQOmE3tyxOqCWyt90ui/SXOdPl+Eq8zIw4HbTT5D1mEVeH
         sMBw==
X-Forwarded-Encrypted: i=1; AJvYcCU419xgAM8W7ndDOWNCdjUAKWaGNRg0DnP88fWjPpU8ZCrOf/sZWFQaeXQo8pa7Pm8vKSugMzAV2eHv7p85IJbn+qgYtcZxrg==
X-Gm-Message-State: AOJu0Yy6+n658mWqGDo51K1/DTA/Ob09v7kZ7ywLPHK8r0ZdQXUpbH67
	HC3m61aS3BFqWBo908c7EXQKp99SVuUj/vn4dWEc2QnSh/5m4j2G6Q0sbpK47A==
X-Google-Smtp-Source: AGHT+IGF0dhTwroiWf8vlWCf7u4PKcJxAHiYK+2Wh+kByR3QQ/sxWLo6/VMaMMw5XsHixhdtlG+FHw==
X-Received: by 2002:a05:600c:6014:b0:411:c78a:748 with SMTP id az20-20020a05600c601400b00411c78a0748mr62990wmb.5.1707831017106;
        Tue, 13 Feb 2024 05:30:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAdKXQ26cQxSJUyCo1H22riFhZXv1ncgK7wxOLzPegEQPz2Kg5auPXocgYVu/gq48SsiY1Q03GMZia/PJbmSKig2fiumfArnIVBj5EA842/FzfvqTTv6iWEqbHNnxI0jD0xzxbG5txBw3F9BpxVVIqA68x/VCt6VhwBR/+87GNoRvQFDA3szyL9Wxw8PKJ4UUrmdYAQY2UCqULc2YfMy9TlT7TLyPW7rKU7b586N4meLpizaWNpQ290nzoF4aY8DrADaMWmX3Uy936YaY81hSMKBd3xemUP0sn/zdOTaobgj6Qsw1gkHxP6cESi8S34HIdbEoRDxNuWRTp9QnwLRWC8l6f4uhqshIf59PmptUWlVsDLMuioVCF
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id g19-20020a05600c4ed300b004103e15441dsm12054525wmq.6.2024.02.13.05.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 05:30:16 -0800 (PST)
Date: Tue, 13 Feb 2024 13:30:12 +0000
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
Message-ID: <Zctu5HOJOPaTNBt-@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <6-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZbuLeWDvhhufT7Pa@google.com>
 <20240201132443.GP1455070@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240201132443.GP1455070@nvidia.com>

On Thu, Feb 01, 2024 at 09:24:43AM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 01, 2024 at 12:15:53PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Thu, Jan 25, 2024 at 07:57:16PM -0400, Jason Gunthorpe wrote:
> > > The BTM support wants to be able to change the ASID of any smmu_domain.
> > > When it goes to do this it holds the arm_smmu_asid_lock and iterates over
> > > the target domain's devices list.
> > > 
> > > During attach of a S1 domain we must ensure that the devices list and
> > > CD are in sync, otherwise we could miss CD updates or a parallel CD update
> > > could push an out of date CD.
> > > 
> > > This is pretty complicated, and almost works today because
> > > arm_smmu_detach_dev() removes the master from the linked list before
> > > working on the CD entries, preventing parallel update of the CD.
> > > 
> > > However, it does have an issue where the CD can remain programed while the
> > > domain appears to be unattached. arm_smmu_share_asid() will then not clear
> > > any CD entriess and install its own CD entry with the same ASID
> > > concurrently. This creates a small race window where the IOMMU can see two
> > > ASIDs pointing to different translations.
> > 
> > I don’t see the race condition.
> > 
> > The current flow is as follows,
> > For SVA, if the asid was used by domain_x, it will do:
> > 
> > lock(arm_smmu_asid_lock)
> > Alloc new asid and set cd->asid.
> > lock(domain_x->devices_lock)
> > Write new CD with the new asid
> > unlock(domain_x->devices_lock)
> > unlock(arm_smmu_asid_lock)
> > 
> > For attach_dev (domain_y), if the device was attached to domain_z
> > //Detach old domain
> > lock(domain_z->devices_lock)
> > Remove master from old domain
> > unlock(domain_z->devices_lock)
> 
> At this moment all locks are dropped and the RID's CD entry continues
> to use the ASID.
> 
> The racing BTM flow now runs and will do your above:
> 
> arm_smmu_mmu_notifier_get()
>  arm_smmu_alloc_shared_cd()
>   arm_smmu_share_asid():
>     arm_smmu_update_ctx_desc_devices() <<- Does nothing due to list_del above
>     arm_smmu_tlb_inv_asid() <<-- Woops, we are invalidating an ASID that is still in a CD!
>  arm_smmu_write_ctx_desc() <<-- Install a new translation on a PASID's CD
> 
> Now the HW can observe two installed CDs using the same ASID but they
> point to different translations. This is illegal.
> 
> > Clear CD
> 
> Now we remove the RID CD, but it is too late, the PASID CD is already
> installed.
> 
> ASID/VMID lifecycle must be strictly contained to ensure the cache
> remains coherent:
> 
> 1. All programmed STE/CDs using the ASID/VMID must always point to the
>    same translation
> 
> 2. All references to a ASID/VMID must be removed from their STE/CDs
>    before the ASID is flushed
> 
> 3. The ASID/VMID must be flushed before it is assigned to a STE/CD
>    with a new translation.
> 
> We solve this by requiring that the arm_smmu_asid_lock must be held
> such that the smmu_domains->devices list AND the actual content of the
> CD tables are always observed to be consistent.
> 
> Jason

I see, thanks a lot for the detailed explanation. 
Maybe this can be added to the change log, so it’s documented somewhere.

Also, I guess this is mainly theoretical, as it requires the detached device to
issue DMA while being detached?

Thanks,
Mostafa

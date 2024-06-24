Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4F1EA90
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719266451; cv=none; b=KxHanW2IEM6yGzVPMR1pDcP37K6kxrjZJZWo2u1fpqhOfCB1tQnUglZDc7nhVdFahtp/qLJu7fXyZE9zkl4yKT/Dnqs9H+bEAlk0rhUhJDsxIkRYfsMREY9g92Uya5wLdCHWXcDj+xlbsl3QoBmIGmBAOK8tW3lfxpB7Ltla7OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719266451; c=relaxed/simple;
	bh=2xgvQxfKDYYKHdwbqGr6aj+ZVlY6zEkXkPra0awLJmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Xgwq72dJdLak2KuwWFs9Qao5zE/4/AbyqIZGU2fjmbpunWC5l6iYHPNiYkR+HUI23qSmXAnjTDX89TIw8Uac9HGfF9BpLFzLGRcmovMu0ayd8ty422kXhcDMyzmVyDSRYF1iw+iuNN1CTotHQ5ugYNKCSBD7UVTYd0RNp5r3GR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwOpgLSi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwOpgLSi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719266448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AMy93E/6RDeqTW8YF5j9Etfag3YQAretpuNps4oyD0=;
	b=LwOpgLSixLJh2/FPG3eEV3ogVryiTsho5LTZzLV/Tun+yEbaLYN77xFRuwWb8aiJmeq5LJ
	Z2/wBmmMwWVUMwTlLqwKcu+HJtEtMvx9c108WTVzlr/1w52M8QSvSS6HBBqN7iLwFZxCpW
	+r3RHrr6zNrRGTSZ4CdJy2mh3KfRroY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-bGXxlE0ZPVy9zUsVL_7Q9w-1; Mon, 24 Jun 2024 18:00:47 -0400
X-MC-Unique: bGXxlE0ZPVy9zUsVL_7Q9w-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b4febeeb1bso71725466d6.1
        for <patches@lists.linux.dev>; Mon, 24 Jun 2024 15:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719266446; x=1719871246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AMy93E/6RDeqTW8YF5j9Etfag3YQAretpuNps4oyD0=;
        b=Kn/s1KGxLGO6esRvQsPU0g2F07icrcSVMiMDO6OBgR/pRqaz6alFBYo1Eak1lcnWjP
         3GIhbrC42azxtDZBEJVBE3s2vX++yP8onmOWiAWDMt4zhOOLycvF9FtMSL3sxJwC2JzO
         8Cx0Rza7QSph6rbKt4waLdzhMQAayUPIyJJHRWka+F6YdCi6J8yhzrAKL3huG8g6KLie
         91w//0zKux1FskletLM+3B3xK6I6IWUn/YR9X7L/1b6lbRWtdb4+zAjmq/RvEWaCy5O0
         qvoXKfLEOz3s+Z2q1T+eNgZOsGBhsepe2VpqqlrjFvqycXX+91ngWUHQb3qoh1hbb2g7
         d1jw==
X-Forwarded-Encrypted: i=1; AJvYcCVPBOSRf9Js4Czm34V8587gqbESk6K/1gu7AF53KCGxp6ktXRQiTXPk8AhQ9LKKj4m8ReV/7OYc7nXCvNpeFknUWgxGBvcAqg==
X-Gm-Message-State: AOJu0Yyml6m4nOxrGQhgNdHnrjQSSkwb2VH/0sAyskSH/fNtkwomw/xv
	/n5j/J8How6xtTICMIUmgTn09CRemt4bCA5uWLFGzIgKDeLFMhOi3D5Z3xxI7EW2ANHCyXMlOGV
	baPPIhSUJ7pVSriOwQU5deU4DJCIAlEpflXd6CWOYwM/XvxURCFG8rLE=
X-Received: by 2002:ad4:5d4e:0:b0:6b5:40c:dfcc with SMTP id 6a1803df08f44-6b53bfdc130mr80326266d6.51.1719266446429;
        Mon, 24 Jun 2024 15:00:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGGavFgSVf/NgSKmV4ZpIuyflzpFXwlIpHXShwDcEDTfxV74+uTwR0khPnBobzGqeyJhmziA==
X-Received: by 2002:ad4:5d4e:0:b0:6b5:40c:dfcc with SMTP id 6a1803df08f44-6b53bfdc130mr80325776d6.51.1719266445870;
        Mon, 24 Jun 2024 15:00:45 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ef4def5sm38033086d6.110.2024.06.24.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 15:00:45 -0700 (PDT)
Date: Mon, 24 Jun 2024 15:00:44 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 00/14] Update SMMUv3 to the modern iommu API (part
 2b/3)
Message-ID: <e3hvs7xpbuki7crn6tbyatzcofmk3yayblz5jbagek6urmq6zu@bm2dqfmqdiua>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 09:15:45PM GMT, Jason Gunthorpe wrote:
> Continuing the work of part 1 and 2a this part focuses on the PASID and
> SVA code bringing these functional improvements:
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
>  - Streamlined SVA support using the core infrastructure
> 
>  - Hitless, whenever possible, change between two domains
> 
> This requires some reorganizing how the invalidation is tracked, a
> flexible linked list containing the SSIDs as well as the ATC information
> is used instead of a single master.
> 
> The revised invalidation infrastructure is used to build generic support
> for attaching any sort of domain to any SSID, including the necessary
> maintenance of the invalidation list and the global ATS state. This
> mechansim is used again in part 3 as part of the nesting series.
> 
> The ATS ordering is generalized and consolidated so that the PASID flow
> can use it and put into a form where it is fully hitless, whenever
> possible. This is necessary as changes to single PASIDs or RIDs can not
> change global state like ATS without impacting other, still attached,
> PASIDs or RIDs.
> 
> Next simply replace the entire outdated SVA mmu_notifier implementation in
> one shot and switch it over to the newly created generic PASID layer and
> generic invalidation logic. This avoids the messy and confusing approach
> of trying to incrementally untangle this in place. The new code is small
> and simple enough this is much better than trying to figure out smaller
> steps.
> 
> Once SVA is resting on the consolidate PASID layer it is straightforward
> to make the PASID interface functionally complete by supporting S1DSS to
> allow concurrent change of the RID while a PASID is attached and allow
> supporting PASID over an IDENTIY RID.
> 
> This continues to support lazy allocation and installation of the CD table
> by continuing to use the CFG mode for IDENTITY/BLOCKED when when the PASID
> table is empty.
> 
> Finally enable attaching any S1 domain to a PASID, not just SVA.
> 
> It achieves the same goals as the several series from Michael and the
> S1DSS series from Nicolin that were trying to improve portions of the API.
> 
> This is on github:
> https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> 
> v8:
>  - Rebase on v6.10-rc2
>  - Make arm_smmu_sva_domain_alloc NULL when SVA is disabled so the core
>    code sees a NULL function pointer
>  - Update comments around arm_smmu_attach_prepare()
>  - Rename struct attach_state -> arm_smmu_attach_state and document
>    better, include more common function paramters in state
>  - Consistently use ats_enabled everywhere, replacing disable_ats in state
>  - Move the note about ATS bypass/abort to arm_smmu_attach_prepare()
>  - Remove temporary cd_table.in_ste check in arm_smmu_sva_set_dev_pasid()
>  - Improve comments and clarity of logic in arm_smmu_attach_commit()
>  - Shorten arm_smmu_mmu_notifier_free()
>  - Fix domain -> sid_domain typo in arm_smmu_remove_dev_pasid()
> v7: https://lore.kernel.org/r/0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com
>  - Second half of the split series
>  - Rebase on Joerg's latest
>  - Accommodate ARM_SMMU_FEAT_ATTR_TYPES_OVR for the S1DSS code
>  - Include the S1DSS kunit tests
>  - Include hunks to adjust the unit tests to API changes from this series
>  - Move 3 BTM related patches out of this series, they can go in the BTM
>    enablement series.
>  - Move the domain_alloc_sva() conversion to the first patch, and rebase
>    on the accepted core code change
>  - Use the new core APIs for the PASID ops
>  - Revise commit messages
> v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com
> 
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Cc: Michael Shavit <mshavit@google.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Moritz Fischer <mdf@kernel.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (14):
>   iommu/arm-smmu-v3: Convert to domain_alloc_sva()
>   iommu/arm-smmu-v3: Start building a generic PASID layer
>   iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
>   iommu/arm-smmu-v3: Make changing domains be hitless for ATS
>   iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
>   iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
>   iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
>     interface
>   iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
>   iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
>   iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
>   iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
>     used
>   iommu/arm-smmu-v3: Test the STE S1DSS functionality
>   iommu/arm-smmu-v3: Allow a PASID to be set when RID is
>     IDENTITY/BLOCKED
>   iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
> 
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 431 +++-----------
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 116 +++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 561 ++++++++++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  52 +-
>  4 files changed, 664 insertions(+), 496 deletions(-)
> 
> 
> base-commit: c3f38fa61af77b49866b006939479069cd451173
> -- 
> 2.45.2
> 

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>


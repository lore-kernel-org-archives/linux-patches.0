Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD6646AC
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIUcQPFz"
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-67a9e59e1b5so59608076d6.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 17:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701827620; x=1702432420; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WF0zb0TZTsACwR1koj3GHJ0g9xK3Yw40DA0v34OkQWI=;
        b=rIUcQPFzNd1V/pnItbCc/a2hshpLt+IbqtjUyedPzUzzWBKsxy+i4pf4UF97WNDxiy
         zdbVqa8s67VhuSTEO6CUJvTNiuOjbyKKmEiFlb7uQxVD1yqvVMIB8amTMcxGazZt2oOI
         3zAN4QUgAY/rwGgxckGxVBT3UreGtKSCp4K1EwfqtnVr5B9rIxRFUqb5GaVMaPwK1V6g
         vrB45Mr16D0s+Wb/+APIvg/cAk7smlNEr1Dtqyf5+iGghGdCuMusDoAgGGXPEZd9CEUw
         CAv37aKiEJpGMgo7mbfmIjn9quRXZ3db3s6soWQ/+zo1jxqvkrXLQHgcbh5Bj3CY22uo
         cbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701827620; x=1702432420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WF0zb0TZTsACwR1koj3GHJ0g9xK3Yw40DA0v34OkQWI=;
        b=dImWFW08ugbJJvRNyHIOBnxzpPY1GSiUPb7BsNaYyE/kBbLBcynkE76BaOM6OJv0Pb
         9P/f2Nl0mupwzLoTSqjNgTQmU/qNBLmEkzjJuUocIPbaS3usmV5QG+oB8ne2P5Q/DZ7r
         DpphJ11GRJACBQln2C75XAVYCU+gvaYlrmW9ijze4Ml01hPT2uNoTFRbqz3q2bZjjWKP
         gb+l6G6bzFnWA9nkNyWgYRZSXvPI+F6oWiMLUHP9pip1eMBtpaZ6DpyeRzgfhemMepF8
         rWsz77/zhpiUGQr+CYicwu1zyHLRp5Ric7l7MYkmBnmsY+N6XVDjK9Hcj4aHaV80QppI
         kOOg==
X-Gm-Message-State: AOJu0YzXbzfQKL/b/oa9DKEdvh2IJC2CJzQJkXumqncgmd0c1KpgBNBx
	HL8ynCwBq4f0KylEVq15LoGeQFaC8F/p
X-Google-Smtp-Source: AGHT+IFQS/QRtXt0EUqefufu0Zn/eM7b8YHeCDl8xRh8AdtVoKcskpac+q85tiAK6Cmtjz0G29BBdaPgmikA
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a0c:e912:0:b0:67a:b419:5443 with SMTP id
 a18-20020a0ce912000000b0067ab4195443mr1250qvo.5.1701827619921; Tue, 05 Dec
 2023 17:53:39 -0800 (PST)
Date: Wed, 6 Dec 2023 01:53:37 +0000
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Message-ID: <20231206015337.edefoajnku374qpm@google.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
From: Moritz Fischer <moritzf@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Jason,

just got back to actually having access to my machine...

On Tue, Dec 05, 2023 at 03:14:32PM -0400, Jason Gunthorpe wrote:
> The SMMUv3 driver was originally written in 2015 when the iommu driver
> facing API looked quite different. The API has evolved, especially lately,
> and the driver has fallen behind.

> This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> the most comprehensive implementation of the API. After all parts it
> addresses:

>   - Global static BLOCKED and IDENTITY domains with 'never fail' attach
>     semantics. BLOCKED is desired for efficient VFIO.

>   - Support map before attach for PAGING iommu_domains.

>   - attach_dev failure does not change the HW configuration.

>   - Fully hitless transitions between IDENTITY -> DMA -> IDENTITY.
>     The API has IOMMU_RESV_DIRECT which is expected to be
>     continuously translating.

>   - Safe transitions between PAGING -> BLOCKED, do not ever temporarily
>     do IDENTITY. This is required for iommufd security.

>   - Full PASID API support including:
>      - S1/SVA domains attached to PASIDs
>      - IDENTITY/BLOCKED/S1 attached to RID
>      - Change of the RID domain while PASIDs are attached

>   - Streamlined SVA support using the core infrastructure

>   - Hitless, whenever possible, change between two domains

>   - iommufd IOMMU_GET_HW_INFO, IOMMU_HWPT_ALLOC_NEST_PARENT, and
>     IOMMU_DOMAIN_NESTED support

> Over all these things are going to become more accessible to iommufd, and
> exposed to VMs, so it is important for the driver to have a robust
> implementation of the API.

> The work is split into three parts, with this part largely focusing on the
> STE and building up to the BLOCKED & IDENTITY global static domains.

> The second part largely focuses on the CD and builds up to having a common
> PASID infrastructure that SVA and S1 domains equally use.

> The third part has some random cleanups and the iommufd related parts.

> Overall this takes the approach of turning the STE/CD programming upside
> down where the CD/STE value is computed right at a driver callback
> function and then pushed down into programming logic. The programming
> logic hides the details of the required CD/STE tear-less update. This
> makes the CD/STE functions independent of the arm_smmu_domain which makes
> it fairly straightforward to untangle all the different call chains, and
> add news ones.

> Further, this frees the arm_smmu_domain related logic from keeping track
> of what state the STE/CD is currently in so it can carefully sequence the
> correct update. There are many new update pairs that are subtly introduced
> as the work progresses.

> The locking to support BTM via arm_smmu_asid_lock is a bit subtle right
> now and patches throughout this work adjust and tighten this so that it is
> clearer and doesn't get broken.

> Once the lower STE layers no longer need to touch arm_smmu_domain we can
> isolate struct arm_smmu_domain to be only used for PAGING domains, audit
> all the to_smmu_domain() calls to be only in PAGING domain ops, and
> introduce the normal global static BLOCKED/IDENTITY domains using the new
> STE infrastructure. Part 2 will ultimately migrate SVA over to use
> arm_smmu_domain as well.

> All parts are on github:

>   https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

> v3:
>   - Use some local variables in arm_smmu_get_step_for_sid() for clarity
>   - White space and spelling changes
>   - Commit message updates
>   - Keep master->domain_head initialized to avoid a list_del corruption
> v2:  
> https://lore.kernel.org/r/0-v2-de8b10590bf5+400-smmuv3_newapi_p1_jgg@nvidia.com
>   - Rebased on v6.7-rc1
>   - Improve the comment for arm_smmu_write_entry_step()
>   - Fix the botched memcmp
>   - Document the spec justification for the SHCFG exclusion in used
>   - Include STRTAB_STE_1_SHCFG for STRTAB_STE_0_CFG_S2_TRANS in used
>   - WARN_ON for unknown STEs in used
>   - Fix error unwind in arm_smmu_attach_dev()
>   - Whitespace, spelling, and checkpatch related items
> v1:  
> https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com

> Jason Gunthorpe (19):
>    iommu/arm-smmu-v3: Add a type for the STE
>    iommu/arm-smmu-v3: Master cannot be NULL in
>      arm_smmu_write_strtab_ent()
>    iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
>    iommu/arm-smmu-v3: Make STE programming independent of the callers
>    iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
>    iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
>    iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into
>      functions
>    iommu/arm-smmu-v3: Build the whole STE in
>      arm_smmu_make_s2_domain_ste()
>    iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
>    iommu/arm-smmu-v3: Compute the STE only once for each master
>    iommu/arm-smmu-v3: Do not change the STE twice during
>      arm_smmu_attach_dev()
>    iommu/arm-smmu-v3: Put writing the context descriptor in the right
>      order
>    iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
>    iommu/arm-smmu-v3: Remove arm_smmu_master->domain
>    iommu/arm-smmu-v3: Add a global static IDENTITY domain
>    iommu/arm-smmu-v3: Add a global static BLOCKED domain
>    iommu/arm-smmu-v3: Use the identity/blocked domain during release
>    iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to
>      finalize
>    iommu/arm-smmu-v3: Convert to domain_alloc_paging()

>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 729 +++++++++++++-------
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
>   2 files changed, 477 insertions(+), 264 deletions(-)


> base-commit: ca7fcaff577c92d85f0e05cc7be79759155fe328
> --
> 2.43.0


For whole series:
Tested-by: Moritz Fischer <moritzf@google.com>

Cheers,
Moritz

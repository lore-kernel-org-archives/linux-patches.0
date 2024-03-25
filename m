Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0FE13C9C2
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711362144; cv=none; b=pum5RPOgRXVt/zKPDilfj2Xv0l/HhJ8KtZs2xk6aqhelpuKWf1uztNTyzxTdKOhgWYzE7b5CJWJGbeI9p3kDWkIPvR4J6UGEPLFn4gOxyiSgUuyCK+X8IkJGBL729R+Lzd+kJSSr/3SqYCGjnF9ul3sc/KvcuygLiQoj0GkVtN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711362144; c=relaxed/simple;
	bh=Snm7dY4fpW9d3rInoxovZZMdot/B+cW3ZkTFuN6iIo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDdvleC85BqV4qR95ODjlciRGqxxMOgYB8WpbkOY1m2Ohp7a778T5VTdTpcPXwt548/cEUe0A0ez2+q6eQGrDPCLyVTbZDfgohpAuhcviKuxeGTsl5lfj6Y5c1R2v1Ralt4Pl951Op8mvfs+UE/xB6uupv6fKmmS2Yx5el9cEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yOv7QEON; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yOv7QEON"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso92095e9.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 03:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711362139; x=1711966939; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eYJAb1EH3G8Sg4vgH7U3KzGwW3Hv5yMhjFNKhma8djI=;
        b=yOv7QEONF8JTgWvjTW9RXQ1dobOSE7SYUBVfern6JYsjU48YSPun+dswCsPRUqQbnY
         SG6gwQyKJZMAgjhuwgggc0ObnZOBHihiLbBbCGdLrzv+sYIQK+C9Ax0SIzxLmkuQ96HK
         KrDfIdmpX6zWBljrsB7D18ZfSf+cy8LHq+ndNMCns2qF6LRsTx4eWvBGiv8McNKoncA+
         6mLJCUo9d5EUqahTPPNntjXuH7MruKBuBPU8Jh2ES32+Rq2latBC1W5TYo5T+aLLS3tl
         G9lN9Qy3sOz3warOdInJb/2PMXcqr1JT8KeMRcel5fcR3UVJdnX/Xs/7LiWDgB8iao16
         rjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711362139; x=1711966939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYJAb1EH3G8Sg4vgH7U3KzGwW3Hv5yMhjFNKhma8djI=;
        b=rhAWSHf5rHPNB3lD5wp26dzcTfZY6LIJXRdr9GZXEDfDn0ke4YCmv0z46N8NWs2Z1c
         hAe22vXe2odSA1DRKjLcF9f6Rv8Sq0i4Dh8jJWz4GoROUW6yXFjpa+EjjQHzCX1sBxSp
         T/tdXOX7KbZNk4TVZ+OvNZREq5tR6Ru1xqDI0IpTMUQY44JC2QqoD5t3lrVjpuPjh72I
         lD0SJiTzYArXkIGaH7zdoibqHXMvbtzT6lzvcEcn0qkNPJVk6iUNr2Us477oLZdFugaY
         /Q5MxdIjkApkugltb4s6wb8g0rsAGvC0vDKN/+E6Ff+SKgi4y7nGnQg01w2TZGwmxVbG
         mSaA==
X-Forwarded-Encrypted: i=1; AJvYcCUgAcS3gSeKeCuk5uS+KaagdkGcn+LRUeBv57yjFUrw4bOjT2wlb74JLzBpjt1YKMu0lnhvKMMiwZPo0IxfveJQ4ycRGHGQ/g==
X-Gm-Message-State: AOJu0YzdjTmHiJ3CjUyie7bz5Ww+IYQlUbSVZGofnV8S9rMVqQgdfgiO
	YifonlBliA9Sh4ynRM7sBdOWNyZqCMJEPjmnJgqJ8K7cCM7cJssU3/MQjNT8Rw==
X-Google-Smtp-Source: AGHT+IGgSLN83cNyLrymref5dGbA8UBb5UbimV+dBZJvAPTaX1jrW8ujIdTWT5O5zb/phfY3ugjREw==
X-Received: by 2002:a05:600c:560c:b0:414:7f46:95f with SMTP id jr12-20020a05600c560c00b004147f46095fmr413022wmb.5.1711362138990;
        Mon, 25 Mar 2024 03:22:18 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id bi25-20020a05600c3d9900b0041486b5aac0sm4530068wmb.10.2024.03.25.03.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 03:22:18 -0700 (PDT)
Date: Mon, 25 Mar 2024 10:22:15 +0000
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
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <ZgFQVy-gIJJKL2IG@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> Continuing the work of part 1 this focuses on the CD, PASID and SVA
> components:
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
> Making the CD programming work like the new STE programming allows
> untangling some of the confusing SVA flows. From there the focus is on
> building out the core infrastructure for dealing with PASID and CD
> entries, then keeping track of unique SSID's for ATS invalidation.
> 
> The ATS ordering is generalized so that the PASID flow can use it and put
> into a form where it is fully hitless, whenever possible. Care is taken to
> ensure that ATC flushes are present after any change in translation.
> 
> Finally we simply kill the entire outdated SVA mmu_notifier implementation
> in one shot and switch it over to the newly created generic PASID & CD
> code. This avoids the messy and confusing approach of trying to
> incrementally untangle this in place. The new code is small and simple
> enough this is much better than trying to figure out smaller steps.
> 
> Once SVA is resting on the right CD code it is straightforward to make the
> PASID interface functionally complete.
> 
> It achieves the same goals as the several series from Michael and the S1DSS
> series from Nicolin that were trying to improve portions of the API.
> 
> This is on github:
> https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

Testing on qemu[1], with the same VMM Shameer tested with[2]:
qemu/build/qemu-system-aarch64 -M virt -machine virt,gic-version=3,iommu=nested-smmuv3,iommufd=iommufd0 \
-cpu cortex-a53,pmu=off -smp 1 -m 2048 \
-kernel Image \
-drive file=rootfs.ext4,if=virtio,format=raw  \
-object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 -nographic  \
-append 'console=ttyAMA0 rootwait root=/dev/vda' \
-device virtio-scsi-pci,id=scsi0  \
-device ioh3420,id=pcie.1,chassis=1 \
-object iommufd,id=iommufd0 \
-device vfio-pci,host=0000:00:03.0,iommufd=iommufd0

I see the following panic:

[  155.141233] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  155.142416] Mem abort info:
[  155.142722]   ESR = 0x0000000086000004
[  155.143106]   EC = 0x21: IABT (current EL), IL = 32 bits
[  155.143827]   SET = 0, FnV = 0
[  155.144266]   EA = 0, S1PTW = 0
[  155.144721]   FSC = 0x04: level 0 translation fault
[  155.145432] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000101059000
[  155.146234] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  155.148162] Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
[  155.149399] Modules linked in:
[  155.150366] CPU: 2 PID: 371 Comm: qemu-system-aar Not tainted 6.8.0-rc7-gde77230ac23a #9
[  155.151728] Hardware name: linux,dummy-virt (DT)
[  155.152770] pstate: 81400809 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=-c)
[  155.153895] pc : 0x0
[  155.154889] lr : iommufd_hwpt_invalidate+0xa4/0x204
[  155.156272] sp : ffff800080f3bcc0
[  155.156971] x29: ffff800080f3bcf0 x28: ffff0000c369b300 x27: 0000000000000000
[  155.158135] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[  155.159175] x23: 0000000000000000 x22: 00000000c1e334a0 x21: ffff0000c1e334a0
[  155.160343] x20: ffff800080f3bd38 x19: ffff800080f3bd58 x18: 0000000000000000
[  155.161298] x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8240d6d8
[  155.162355] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  155.163463] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[  155.164947] x8 : 0000001000000002 x7 : 0000fffeac1ec950 x6 : 0000000000000000
[  155.166057] x5 : ffff800080f3bd78 x4 : 0000000000000003 x3 : 0000000000000002
[  155.167343] x2 : 0000000000000000 x1 : ffff800080f3bcc8 x0 : ffff0000c6034d80
[  155.168851] Call trace:
[  155.169738]  0x0
[  155.170623]  iommufd_fops_ioctl+0x154/0x274
[  155.171555]  __arm64_sys_ioctl+0xac/0xf0
[  155.172095]  invoke_syscall+0x48/0x110
[  155.172633]  el0_svc_common.constprop.0+0x40/0xe0
[  155.173277]  do_el0_svc+0x1c/0x28
[  155.173847]  el0_svc+0x34/0xb4
[  155.174312]  el0t_64_sync_handler+0x120/0x12c
[  155.174969]  el0t_64_sync+0x190/0x194
[  155.176006] Code: ???????? ???????? ???????? ???????? (????????)
[  155.178349] ---[ end trace 0000000000000000 ]---

The core IOMMUFD code calls domain->ops->cache_invalidate_user
unconditionally from IOCTL:IOMMU_HWPT_INVALIDATE and the SMMUv3 driver
doesn't implement it, that seems missing as otherwise the VMM can't
invalidate S1 mappings, or I a missing something?


[1] https://lore.kernel.org/all/20240325101442.1306300-1-smostafa@google.com/
[2] https://github.com/nicolinc/qemu/commits/wip/iommufd_vsmmu-02292024/

> 
> v5:
>  - Rebase on v6.8-rc7 & Will's tree
>  - Accomdate the SVA rc patch removing the master list iteration
>  - Move the kfree(to_smmu_domain(domain)) hunk to the right patch
>  - Move S1DSS get_used hunk to "Allow IDENTITY/BLOCKED to be set while
>    PASID is used"
> v4: https://lore.kernel.org/r/0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebase on v6.8-rc1, adjust to use mm_get_enqcmd_pasid() and eventually
>    remove all references from ARM. Move the new ARM_SMMU_FEAT_STALL_FORCE
>    stuff to arm_smmu_make_sva_cd()
>  - Adjust to use the new shared STE/CD writer logic. Disable some of the
>    sanity checks for the interior of the series
>  - Return ERR_PTR from domain_alloc functions
>  - Move the ATS disablement flow into arm_smmu_attach_prepare()/commit()
>    which lets all the STE update flows use the same sequence. This is
>    needed for nesting in part 3
>  - Put ssid in attach_state
>  - Replace to_smmu_domain_safe() with to_smmu_domain_devices()
> v3: https://lore.kernel.org/r/0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebase on the latest part 1
>  - update comments and commit messages
>  - Fix error exit in arm_smmu_set_pasid()
>  - Fix inverted logic for btm_invalidation
>  - Add missing ATC invalidation on mm release
>  - Add a big comment explaining that BTM is not enabled and what is
>    missing to enable it.
> v2: https://lore.kernel.org/r/0-v2-16665a652079+5947-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebased on iommmufd + Joerg's tree
>  - Use sid_smmu_domain consistently to refer to the domain attached to the
>    device (eg the PCIe RID)
>  - Rework how arm_smmu_attach_*() and callers flow to be more careful
>    about ordering around ATC invalidation. The ATC must be invalidated
>    after it is impossible to establish stale entires.
>  - ATS disable is now entirely part of arm_smmu_attach_dev_ste(), which is
>    the only STE type that ever disables ATS.
>  - Remove the 'existing_master_domain' optimization, the code is
>    functionally fine without it.
>  - Whitespace, spelling, and checkpatch related items
>  - Fixed wrong value stored in the xa for the BTM flows
>  - Use pasid more consistently instead of id
> v1: https://lore.kernel.org/r/0-v1-afbb86647bbd+5-smmuv3_newapi_p2_jgg@nvidia.com
> 
> Jason Gunthorpe (27):
>   iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong
>     PASID
>   iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
>   iommu/arm-smmu-v3: Add a type for the CD entry
>   iommu/arm-smmu-v3: Add an ops indirection to the STE code
>   iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
>   iommu/arm-smmu-v3: Consolidate clearing a CD table entry
>   iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
>     function
>   iommu/arm-smmu-v3: Move allocation of the cdtable into
>     arm_smmu_get_cd_ptr()
>   iommu/arm-smmu-v3: Allocate the CD table entry in advance
>   iommu/arm-smmu-v3: Move the CD generation for SVA into a function
>   iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
>   iommu/arm-smmu-v3: Start building a generic PASID layer
>   iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
>   iommu/arm-smmu-v3: Make changing domains be hitless for ATS
>   iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
>   iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
>   iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
>     interface
>   iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
>   iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
>   iommu: Add ops->domain_alloc_sva()
>   iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
>   iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
>   iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
>   iommu/arm-smmu-v3: Bring back SVA BTM support
>   iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
>     used
>   iommu/arm-smmu-v3: Allow a PASID to be set when RID is
>     IDENTITY/BLOCKED
>   iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
> 
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  639 +++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 1036 +++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   79 +-
>  drivers/iommu/iommu-sva.c                     |    4 +-
>  drivers/iommu/iommu.c                         |   12 +-
>  include/linux/iommu.h                         |    3 +
>  6 files changed, 1024 insertions(+), 749 deletions(-)
> 
> 
> base-commit: 98b23ebb0c84657a135957d727eedebd1280cbbf
> -- 
> 2.43.2
> 

Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452043AC1
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708612735; cv=none; b=fbxxoHalp5yGAbUlpmSRSaKekEClyrYueK3iHAdeD9zVg5b7DTyI74YhENmGuFdLao1nenOApE2jolYYs5k1Nn0AoXd3opZRQtEAd8HlMRwiVx+jQjo2umod0AsK/e43oe46BNUoFpqzKOqVCojRXV1c8GWZomLgUEIXCk4RSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708612735; c=relaxed/simple;
	bh=gXpVCT236m7c9mgGspoPBoreMNrUsL60NmgBUtytq44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ce6+3dYEK48EIPyZoha1H5PfYnmpni5MGgt7v0IQ1SVc/h3hd4/WHXbUWyiZ12VV73jPkVu//m3JF5w/mvj276g1pBePiZ4Dyb+K/kK1eWVVdwM34aeSOy5rl0f+TaoWFYzmwMyixba8dI5Z225nNmzj5XsxisB81yfYaHuIRBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aN7ppSNm; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aN7ppSNm"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d22b8801b9so27141971fa.0
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 06:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708612731; x=1709217531; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W12Rm4/pcl8dI66AREmijRFXMJZzKHswmB4AV6VJFU0=;
        b=aN7ppSNmLsoacnxCkmf1OiXSgA3AF5TPkyL6Kzt4VmG3/xRAf1AhE3zLZcjhczYMCT
         ANHpqbleNKtcn6EiEEufWVyKP0VUyf1ufDaPq6G6Y4/G7QHlV4UzJbH4IPgVQryO3m0l
         fE9Gtf3F0YM/xbWHuuAA4VsJhlE63agWq00zPSPAx2uuscb3D4hgUNtjcMxpOCRhgXRD
         lzg/vC/HpPO0ENMNyvPdc2xqy2/R0AuovckUqHgulBONlLRlydadG35v5MAOKjUcrqCD
         wAQdfmDrrhKaswwSLZsc1saDlYnpMMh3Ui7vOf3br9N1rClcHBNnXfAGNwX6fB+pODWz
         IXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708612731; x=1709217531;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W12Rm4/pcl8dI66AREmijRFXMJZzKHswmB4AV6VJFU0=;
        b=acZPxK6xMls1YwelGtMPpoGDaDnZ8ikKvxzyB/qBLKt+RdOKHjvVE7pAfp/5ZS56s9
         U3ZEfXi8RN4XrCSIcqkeqbo+IrHfj0ktY1lFuGBhQ89CD1pfjsxDe0RZ1RLrxvisZ8yL
         VNC0dG8uWACoCDsEcmTbphPocppAfsRfWgzJGgzmjz/oXdxu94i40WvAb34DTLAS8HUX
         Kph0rWz7Px/dplharja31q7uC3CbcDG0Tir7tP5lNO9VsNyHuPW8N6QBup74tEba4qwi
         ocbdXHde1t8MwjI67GBvvYhIIf67GAM2RnHQTbNtkYrreZgVC7uoFd6zNuwZdrpL4Zmi
         EEaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjL5EBwOJ8cILqKZS04NGlUOTWrA2ZnQyPEnd2t5qL3mRFwPuvhtw+fys90RTv3nrzsIG+oLKeWwrT6V/jp/s+E/s8C0dE0w==
X-Gm-Message-State: AOJu0YzyVJtxSv/KWzjuprjgMSJubmcmvg+S0vVKhBWzJYYKh5wa3vzb
	eKt9m3t5AeGnBUzjBcw6tQsjsVf52iY6zLHlig2E9uXbFsb/iPUdDfGyKDGV/lamsHBKyf2BgDW
	RfLowFo4aRiqOM9QoH6nKDErvhX6O5eajtMtrGQ==
X-Google-Smtp-Source: AGHT+IG242Ib2O55xSLLHZDBVyccWc91VnkytDFfmXbn/n8ByOmXYcE2qBFBks1IzaeqsZ566eG1QMw6q7RZcLLdN4o=
X-Received: by 2002:a2e:9d86:0:b0:2d2:65ff:3b78 with SMTP id
 c6-20020a2e9d86000000b002d265ff3b78mr494507ljj.35.1708612731065; Thu, 22 Feb
 2024 06:38:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
In-Reply-To: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 22 Feb 2024 22:38:39 +0800
Message-ID: <CABQgh9F3dWpE+2g14qq=fhdRNWgs4huBOgiDTQXQXuG=UzNv-g@mail.gmail.com>
Subject: Re: [PATCH v3] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Michael Shavit <mshavit@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Feb 2024 at 08:27, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> If the SMMU is configured to use a two level CD table then
> arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> iterate over the device list - thus it will trigger a sleeping while
> atomic warning:
>
>   arm_smmu_sva_set_dev_pasid()
>     mutex_lock(&sva_lock);
>     __arm_smmu_sva_bind()
>      arm_smmu_mmu_notifier_get()
>       spin_lock_irqsave()
>       arm_smmu_write_ctx_desc()
>         arm_smmu_get_cd_ptr()
>          arm_smmu_alloc_cd_leaf_table()
>           dmam_alloc_coherent(GFP_KERNEL)
>
> This is a 64K high order allocation and really should not be done
> atomically.
>
> At the moment the rework of the SVA to follow the new API is half
> finished. Recently the CD table memory was moved from the domain to the
> master, however we have the confusing situation where the SVA code is
> wrongly using the RID domains device's list to track which CD tables the
> SVA is installed in.
>
> Remove the logic to replicate the CD across all the domain's masters
> during attach. We know which master and which CD table the PASID should be
> installed in.
>
> Right now SVA only works when dma-iommu.c is in control of the RID
> translation, which means we have a single iommu_domain shared across the
> entire group and that iommu_domain is not shared outside the group.
>
> Critically this means that the iommu_group->devices list and RID's
> smmu_domain->devices list describe the same set of masters.
>
> For PCI cases the core code also insists on singleton groups so there is
> only one entry in the smmu_domain->devices list that is equal to the
> master being passed in to arm_smmu_sva_set_dev_pasid().
>
> Only non-PCI cases may have multi-device groups. However, the core code
> will repeat the calls to arm_smmu_sva_set_dev_pasid() across the entire
> iommu_group->devices list.
>
> Instead of having arm_smmu_mmu_notifier_get() indirectly loop over all the
> devices in the group via the RID's smmu_domain, rely on
> __arm_smmu_sva_bind() to be called for each device in the group and
> install the repeated CD entry that way.
>
> This avoids taking the spinlock to access the devices list and permits the
> arm_smmu_write_ctx_desc() to use a sleeping allocation. Leave the
> arm_smmu_mm_release() as a confusing situation, this requires tracking
> attached masters inside the SVA domain.
>
> Removing the loop allows arm_smmu_write_ctx_desc() to be called outside
> the spinlock and thus is safe to use GFP_KERNEL.
>
> Move the clearing of the CD into arm_smmu_sva_remove_dev_pasid() so that
> arm_smmu_mmu_notifier_get/put() remain paired functions.
>
> Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 38 ++++++-------------
>  1 file changed, 12 insertions(+), 26 deletions(-)
>
> I suggest taking these two patches as well which will further help this code:
>
> https://lore.kernel.org/linux-iommu/12-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com/
> https://lore.kernel.org/linux-iommu/2-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/
>
> Michael should check it, and Nicolin or Shameer should do a quick sanity check
> on their SVA HW.

Just tested on SVA HW, and NO issue.

Thanks

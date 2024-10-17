Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07201CAA4
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729130020; cv=none; b=dc8LapqZy9BrlpamlQDkVu8fyeQxzRqZF9OGVsLOH9MTfcS0M0XZCfO8wzTTbAWMfgp22sylvEHhy+OLr+tpsySQhFTDQQBU0xyZ3snCr3AnBjXh7VpNRxS3OLmA0npYEqUyNCBk+bmdL6Xphx2BaHHzJhoJH56V/Lj5N82Y7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729130020; c=relaxed/simple;
	bh=T8K6e1vE2wCLDVf7N8pVhUM3BmOSL3JyhQ3sMTdPLa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=niBDAMRHwsy4fidZ1aYsV6du2jyKgT11neny73NV93lgxH+tlb3mL8JTg3vPfOnes9wDt+Db9i3MTVYN3/m6W/xkaGtI722lrjiOSOteRK3885vz3X9yAJhc251wBA1DRhQRFbeWw5JI27sfwk+4JwIUUX6RjyTe+irWSO2kfK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xvZFPfjn; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xvZFPfjn"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e1543ab8so711251e87.2
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 18:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729130014; x=1729734814; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PLiuItL1UL/0YbxnoapkbJfbI3ajFc+JHUChCko5gAM=;
        b=xvZFPfjnOdB0ypNnYusgxlse68h57xtDYUlD0O7pc6puUfb6vjT8l3YH+xDNlMlkTU
         cRZ/027kyT4tWxKU7GJZ7nh7aTEev/dGL33HP2oAr2Vha85NkCfdRgMA7S/bPtVo64e8
         iD393cfz8BgSmZOxL8hR7vsKIHkGBuyWQEwo15/JnW09tZwcsvDTJzYgt5x/LDzV95Pq
         Kv66i166LS3FDaMXr0OvkQsYh5K2QjaZKkZWeDUq83vnXyLYDm1U/ijUMSLGd0vZuWjM
         5RBcQq/s2oo1CwRch+tFxWJpfoX8OIZXqjC3Z40+C/wMDrZwYPAQhi82Jj4ynyQndqbX
         bb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729130014; x=1729734814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLiuItL1UL/0YbxnoapkbJfbI3ajFc+JHUChCko5gAM=;
        b=KOGvDEXu6xmigfNz6xzPpAcEjB4gCqpk6r0UK3541bXxXmsyaXexyblHI/A5Fq708L
         81toRKnCN93qJd953m1CbBoMTCN7OQjsbv67rAJPpxV4U8FaG4dBHhcO1ymy9PgYXRvW
         R0CSW1zTkXYWfrndx47iw9Bh4A6mqsnzEcXf6ZN3Q3qDqtCQTD//6fAWz6wzzxiMUjOI
         r9/n9/7ppzMOGuWxberG+w00QB5NdvO00logIm1+YfuSLgHNWOaQMK3MaQB57eTybY2R
         Pclrm8o/d+Y5ifLPXNLFa/2X4j3+LeqK+wGlqrEIrZGc4yqg40/KcmB9uhA46Ht14Q1x
         H3+w==
X-Forwarded-Encrypted: i=1; AJvYcCX6TM1QUVaIjfYGqf847ZElglVJSflyMbk3pEyqcAa84AHnMvkLzPdp+QjXX6TN60aEbVydBA4n@lists.linux.dev
X-Gm-Message-State: AOJu0YyEumMdnifnlFhcqyrFV0b2k0xsyYk75mKd7VHosSSyDrFxSeEv
	AcpfTa+J1CGK3ew3vxcFrxcOLlzrKtU3ALW9j8t8rnyDAzotlEkRzTOKv6E07CITenFcCiKKQSd
	9iomnV9Qqv/dCzf/tEb9tvbEWhfx6Kmi8bkxBfg==
X-Google-Smtp-Source: AGHT+IHmRyfMbHywLHUFamzust4bs2j0uBfSYysgkZSLZifh1MxXQEHcbM8EVQlN/EZKeVoV9osv3HRdY3nD8AfzzMA=
X-Received: by 2002:a05:6512:1252:b0:539:e0e6:cf42 with SMTP id
 2adb3069b0e04-539e571ce19mr12017134e87.43.1729130013488; Wed, 16 Oct 2024
 18:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia> <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com> <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
 <20241015130936.GM3394334@nvidia.com>
In-Reply-To: <20241015130936.GM3394334@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 17 Oct 2024 09:53:22 +0800
Message-ID: <CABQgh9GF9vm=9Yv2AWe5wbN-mfr6Grn9=+c5zTgOvaMU+3bNSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 21:09, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Oct 15, 2024 at 11:21:54AM +0800, Zhangfei Gao wrote:
> > On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
> >
> > > > Have you tested the user page fault?
> > > >
> > > > I got an issue, when a user page fault happens,
> > > >   group->attach_handle = iommu_attach_handle_get(pasid)
> > > > return NULL.
> > > >
> > > > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> > > >
> > > >   __fault_domain_replace_dev
> > > > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > > > &handle->handle);
> > > > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> > > >
> > > > not find where the code attach user pasid with the attach_handle.
> > >
> > > Have you set iommu_ops::user_pasid_table for SMMUv3 driver?
> >
> > Thanks Baolu
> >
> > Can we send a patch to make it as default?
> >
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
> >         .viommu_alloc           = arm_vsmmu_alloc,
> >         .pgsize_bitmap          = -1UL, /* Restricted during device attach */
> >         .owner                  = THIS_MODULE,
> > +       .user_pasid_table       = 1,
>
> You shouldn't need this right now as smmu3 doesn't support nesting
> domains yet.

I am testing with  .user_pasid_table = 1 and IOMMU_NO_PASID
It works for user page faults.

>
>                         if (!ops->user_pasid_table)
>                                 return NULL;
>                         /*
>                          * The iommu driver for this device supports user-
>                          * managed PASID table. Therefore page faults for
>                          * any PASID should go through the NESTING domain
>                          * attached to the device RID.
>                          */
>                         attach_handle = iommu_attach_handle_get(
>                                         dev->iommu_group, IOMMU_NO_PASID,
>                                         IOMMU_DOMAIN_NESTED);
>                         if (IS_ERR(attach_handle))
>                         ^^^^^^^^^^^^^^^^^^^^^ Will always fail
>
>
> But I will add it to the patch that adds IOMMU_DOMAIN_NESTED

OK, cool.

Thanks

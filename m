Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B9B18A6BB
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126376; cv=none; b=bkJdjluK/y9GTCAZD/immsiXZl5CX9dToKKagko9CEw9ZKLnoNYlZ2O6q385nXNW7Oa2b1j2N+sc4EAzzqzwkoMnh+o9vfYJ63YyC2AwASZGZ8sFwOrBLiV4o9cYo/Oif37aSgamTGtwuWEsIzRJzY2WBlolPRskyBGIJLrGfgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126376; c=relaxed/simple;
	bh=FzBKh+AU40CN9oHzR3BSVFgBams1zQxhZ8kcZSCD9k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILVUseFPbnDoYftcNqNw91ktTSs9X1zAsdDwD6qzkqCOA2Se1i9guDTzR2wuBMqAL75p86gp6TISg9Y2WuU2YKtMoj5EyJpBquCAblSQ2cD+8Bv5QkqUKBMfLy7rQhXvcBweESz+s6Xgxc3FmJtnquZ+p6U1dlmrn6MNVy6jrvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=icc7yQDL; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="icc7yQDL"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53654e2ed93so747035e87.0
        for <patches@lists.linux.dev>; Thu, 12 Sep 2024 00:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126373; x=1726731173; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mORgeThFItSKRVvwL2eU52STgrT61e2xyY47HCtu0j0=;
        b=icc7yQDLEC2KxcaOTNz+se27hbS/GyLjMcad6M3+zf5+/iqwxPqNtPLgGn24IiQbxE
         qeWwWPYh9yn4IRxw1oFKiDKvIctmHA0mHNvK4lGaJ2AwAxrNhwBS3hzEOHGJY9ja8NgX
         YkT+f3COP3pvIm/PcTE5qXLgeMHPz8Cs7XpXYOf17BH26SfXY307sM8x1T+yJEF8Iilk
         m5EgXExAI8e6JigwnlplRRtFkO0ZxmB+VHItN+NKnw9ob0KuZoC31OsoVUSaBYFr16Wb
         qe5ydeBB3eUg20ELQ7cP7rhFlUl+fvc/iWOtrv1yevbl94FEq32rraLOi94Kg76/Q1sq
         4e2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126373; x=1726731173;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mORgeThFItSKRVvwL2eU52STgrT61e2xyY47HCtu0j0=;
        b=Kaqaj+EPRBoZsDky6UK2qjjgWHvn6RJf2nPSQdeDvBa2K0lPcq0W2nOBg+X8y15B8K
         UsPtZxV1KRIjT9BKvoc4nsWgmejvDaW4YOe5AyDFSGfOl0EyMFKeJb0I1xwrQ8CVvp6J
         r1n4bpLPuh9MGd0JaEnR/aS2n8uiNQr0C4CVM5lQDsy1f8R8EjiHfli521SXg4SLe3DQ
         ahqtU61TPk7Ajz0crc1RjkRPomGCshNYFHoQc8iFxB7ADUYn0XTFGCLgCZ/+joZeKKU5
         H2eMsnCCUN5XNUbX0mFFWCI9dOytOBHxM01L+CcHvM0snqHXtyusCuXHwLFZ0o6QG9R4
         b1NA==
X-Forwarded-Encrypted: i=1; AJvYcCUjR+puvIpFq/m60wz+4DgtwZOtYVfGu1McBc5+9qw8Xcq03JGugj8iQTvlR8YXaUMilmN0YWr2@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5QrMIpOpNk1EWXi4Yovs+Z9By7+oa/a70cjxQrlPLmEbaz1pa
	miZ83/h9Fosbln5yB67Yc2KjjA+HeTj33uOhhA1FaZ1hmH2OZxbz9zmuunny6ozi3VgIdFITEBe
	hGMZdRl2T0YEQSnB9rHLlUcWNU6OsQ2FIYcFwAg==
X-Google-Smtp-Source: AGHT+IE2qH+DDo5DbegofrZD/Jk3qp04GIJFuzg8g/g2YGLkO7heSfzNnSID+VNatE+0Yyh1SXo2NwGwNJsgxGu/4kI=
X-Received: by 2002:a05:6512:ac9:b0:535:d4e9:28bb with SMTP id
 2adb3069b0e04-53678feb448mr861902e87.46.1726126371795; Thu, 12 Sep 2024
 00:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia> <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
In-Reply-To: <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 12 Sep 2024 15:32:40 +0800
Message-ID: <CABQgh9H2+uTgsQxgLSuua7h0kxSwfYZE1=GM1TA4H30jNsM9OQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, 
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev, 
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

On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
>
> On 9/12/24 11:42 AM, Zhangfei Gao wrote:
> > On Wed, 28 Aug 2024 at 05:32, Nicolin Chen<nicolinc@nvidia.com>  wrote:
> >> On Tue, Aug 27, 2024 at 12:51:30PM -0300, Jason Gunthorpe wrote:
> >>> This brings support for the IOMMFD ioctls:
> >>>
> >>>   - IOMMU_GET_HW_INFO
> >>>   - IOMMU_HWPT_ALLOC_NEST_PARENT
> >>>   - IOMMU_DOMAIN_NESTED
> >>>   - ops->enforce_cache_coherency()
> >>>
> >>> This is quite straightforward as the nested STE can just be built in the
> >>> special NESTED domain op and fed through the generic update machinery.
> >>>
> >>> The design allows the user provided STE fragment to control several
> >>> aspects of the translation, including putting the STE into a "virtual
> >>> bypass" or a aborting state. This duplicates functionality available by
> >>> other means, but it allows trivially preserving the VMID in the STE as we
> >>> eventually move towards the VIOMMU owning the VMID.
> >>>
> >>> Nesting support requires the system to either support S2FWB or the
> >>> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> >>> cache and view incoherent data, currently VFIO lacks any cache flushing
> >>> that would make this safe.
> >>>
> >>> Yan has a series to add some of the needed infrastructure for VFIO cache
> >>> flushing here:
> >>>
> >>>   https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> >>>
> >>> Which may someday allow relaxing this further.
> >>>
> >>> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> >>> this.
> >>>
> >>> This is the first series in what will be several to complete nesting
> >>> support. At least:
> >>>   - IOMMU_RESV_SW_MSI related fixups
> >>>      https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
> >>>   - VIOMMU object support to allow ATS and CD invalidations
> >>>      https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
> >>>   - vCMDQ hypervisor support for direct invalidation queue assignment
> >>>      https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
> >>>   - KVM pinned VMID using VIOMMU for vBTM
> >>>      https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
> >>>   - Cross instance S2 sharing
> >>>   - Virtual Machine Structure using VIOMMU (for vMPAM?)
> >>>   - Fault forwarding support through IOMMUFD's fault fd for vSVA
> >>>
> >>> The VIOMMU series is essential to allow the invalidations to be processed
> >>> for the CD as well.
> >>>
> >>> It is enough to allow qemu work to progress.
> >>>
> >>> This is on github:https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> >>>
> >>> v2:
> >> As mentioned above, the VIOMMU series would be required to test
> >> the entire nesting feature, which now has a v2 rebasing on this
> >> series. I tested it with a paring QEMU branch. Please refer to:
> >> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
> >> Also, there is another new VIRQ series on top of the VIOMMU one
> >> and this nesting series. And I tested it too. Please refer to:
> >> https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/
> >>
> >> With that,
> >>
> >> Tested-by: Nicolin Chen<nicolinc@nvidia.com>
> >>
> > Have you tested the user page fault?
> >
> > I got an issue, when a user page fault happens,
> >   group->attach_handle = iommu_attach_handle_get(pasid)
> > return NULL.
> >
> > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> >
> >   __fault_domain_replace_dev
> > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > &handle->handle);
> > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> >
> > not find where the code attach user pasid with the attach_handle.
>
> Have you set iommu_ops::user_pasid_table for SMMUv3 driver?

Thanks Baolu, Nico

Yes, after arm_smmu_ops = {
+       .user_pasid_table       = 1,

find_fault_handler can go inside attach_handle =
iommu_attach_handle_get(IOMMU_NO_PASID);
qemu handler also gets called.

But hardware reports errors and needs reset, still in check.
[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0

Thanks

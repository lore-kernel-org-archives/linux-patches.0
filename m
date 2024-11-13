Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D302AD0C
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459716; cv=none; b=Mjc4VZEESX41QEmKMuuAH1RqtfnFRkKhfRa3H+gC9sZRnvRiR6at1i9j+WkHCmRMLBnZduUF/sTcA08kpJS0E6+FPXITc6DkpBBHicSljP6l1JdcLy/si1KalhXLT9+5bMLc9eCWNuuBiPGCEvjSsI9YhLYhWhtFamaf2Qm0DmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459716; c=relaxed/simple;
	bh=5v0Pumd1wdfkWfYkDyIym/XT5Jsmn2z22aIpke3ZD48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwcHocURC/4pMmgYLU9pFNDdjcFQIbX9alfc0GsV5zlAA0e5xe0N09Ca8nTechyueDGBtQcPUREM7UoRbMYYZrys3gw9jFHmo+4NI4v9zt8ZVBXsIxgDWVJD43liZpPM1dA3ICQi/XeSRiEMd9EbIpG60S3yPbaou5kc2bNgegc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WUAlv8Oe; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WUAlv8Oe"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53d9ff8f1e4so372436e87.2
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 17:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731459713; x=1732064513; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X/yyOuGNVIzT+zYvh4v3hplD3RNbNSCQhrz/FBYBpRw=;
        b=WUAlv8Oee8KJ+cX44lXGDjCwRCu/OVC5DjG6etP3FC+thz79YMprikjJJsgCueear9
         QzpE1xqnsPhx7a6rb805QcHH3j1N6cXAGzDlTKv5+tf2RdjslT/NBKW6ai91o1map5wb
         TRql401a1WZzcFtwoCqnzYINF8od3X33HitbgtWSZd22+VEsvx+QxrQP2qiRfEdSR9cH
         i5T40LP9Xj1jUTfEuPIdyXgWODyVOtAdQAWmPvyPciq9lPgSKcnDWQIL8iEaCQtJraE9
         ik/5FY5o8JEgGMAEGX5QpxqTXortJKvCiN7U5Q8PK1SjNIUDmv/fN+mkfDe0csE8iQoq
         E6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731459713; x=1732064513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/yyOuGNVIzT+zYvh4v3hplD3RNbNSCQhrz/FBYBpRw=;
        b=vnTA4EcMkaxUFk47Zn3PTpIDYm8jFq8lKZO90izHdxfInj4lhh7VSoTt8gQWyvB1vZ
         feEgKOkzI2DWJElJMLy6PeDeO+ZCBjnjATo5kfc2vMSDw4x2c5V7E3wp/OGYwr6jWtz8
         jSPZM4Z3YSY+kXKAiYNVPH/kWhuGCnQ+1KIxLL+7WtFTK1jVDY73/kxZHKx40X3Ykwpw
         QE0JwL2qlj1Z6ijHHzXjXEmrFyBXYrNtzmnieoHOzEbclNheX88m9iqbVtNqz1SUL1ga
         cHA/gg1sLWUBr7DNy/2l+C2SeRLx0lAHU7Nf67RAkCencr5LfB3Lh+WnA7n2VX4MFmU9
         fw5w==
X-Forwarded-Encrypted: i=1; AJvYcCWsBafONXTpZwEAETStVUBuTAx1L5s1+CiG3MQN2iAPVdw+nX7ABw7S5gZMS4ms3Q/Y3GhY8ctn@lists.linux.dev
X-Gm-Message-State: AOJu0Yzu11Wy8vyHBLmEhgkO3z2o6cVNZkqAkEMX5aKHhrYQwTXrtN1u
	e0k+EXYe0A/XN89Xrh2+gLspEUb63pmYPpDdZqMgNKzoa49kLXPBkvmyKZuGtbJHhQXH7qQmW6v
	T8XoNtk8GHEqOQIbg5hwfE+dPs16CtD4yi/yx3Q==
X-Google-Smtp-Source: AGHT+IGrTpBP4XZN2inszS5LiWIDhaTOAjWYv1IN45jLudjPrpRKEn2OnUUglHnQBM+zZuWyWdAuDjaQVoneTf1/DNk=
X-Received: by 2002:a05:6512:ba0:b0:539:e436:f1cd with SMTP id
 2adb3069b0e04-53d862d38c5mr9315032e87.16.1731459712927; Tue, 12 Nov 2024
 17:01:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com> <20241112182938.GA172989@nvidia.com>
In-Reply-To: <20241112182938.GA172989@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 13 Nov 2024 09:01:41 +0800
Message-ID: <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Nov 2024 at 02:29, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > Jason Gunthorpe (7):
> >   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
> >   iommu/arm-smmu-v3: Use S2FWB for NESTED domains
> >   iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED
> >
> > Nicolin Chen (5):
> >   iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
> >   iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object
>
> Applied to iommufd for-next along with all the dependencies and the
> additional hunk Zhangfei pointed out.

Thanks Jason, I have verified on aarch64 based on your
jason/smmuv3_nesting branch

https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
https://github.com/Linaro/qemu/tree/6.12-wip

Still need this hack
https://github.com/Linaro/linux-kernel-uadk/commit/eaa194d954112cad4da7852e29343e546baf8683

One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
which you have patchset before.
The other is to temporarily ignore S2FWB or CANWBS.

Thanks

Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E84324B28
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 03:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962529; cv=none; b=SmyN5/PUxuontx8W/R396B5h4tx8fnJ0LqvggUjxP048KAWO1NFEzjpDlM+yueEWMAjOM7/bRRPI4uEzEw3NNhtHX5eyccnXf+tPS868Q3Keo2diTHb4/cRgJDDbwToPriuA+ZGeupNU0dN9Sfu/i5XfVBpC5ZYX2DpBanRPhc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962529; c=relaxed/simple;
	bh=DjLX5fBkgJU8CT8xqfpFI/dbFLVg02xVhUhJ9U952wA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dhc0w3coXqNrkV73bZc5wex+fuoaQj4dOzVs7+hoUoJyOzPbN+EtI5Ad8sg3hljzHSryWwFclOfyJhISziDtVfmU0xByyQO/4xofPVdxcLzBjttgPs9UcbC7gT+znhL5VSu5rA9lUzrXL5ZCw0ToTeQ5T5bnnxu59exgvrbJFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mle7hv7P; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mle7hv7P"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e7e73740so1996367e87.3
        for <patches@lists.linux.dev>; Mon, 14 Oct 2024 20:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728962526; x=1729567326; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgc3X3B5k3iTM1+4K9yayTFXC9bD3mynK1laekJ4N5Y=;
        b=mle7hv7P7y/8KqeiK4W83Bkqx50hqhdJV4063qs+KjbAC301qnz1wkHUjZQ3Q7VLNz
         yCS2b6V4lOhadTov+DxR3KZugYnSqq7EDAx9I1guJ/lFG6QVmQDjGI5Nk1TW+rZUTGG0
         wWhsxSBNs7vA+MQxW9WsjSedbvEEE8ZMwyh/AlYOWd9CUOfgPTLCScQ+tFXYSOwB1H1w
         iT3qYUtW8/aa3WqAxNZb6hXSF00WljlJJjxRadhBBHy3QSEKvyYT2XOVTpOJ59ln1YHy
         MuwbqYg4BVymIvyCd/AQqdRgL2FZTmb3JwW/aPQ1d7DO05EzHJXOQULiaT+rS1Tbs8Q3
         d8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728962526; x=1729567326;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jgc3X3B5k3iTM1+4K9yayTFXC9bD3mynK1laekJ4N5Y=;
        b=hRN0HWSjUPJbD1XnMKloCUoQ5Cis60nuXSrrsPkV/AVf24+zC+ejcbUchsuIowXN37
         pPOKa3Feexo7hPExsjGdo2t63tdwNZJwiBiSIn2OdoaAJ3IKv/wNTWcq4tsQXqSUuFLB
         0orOiZJG0XQZOFL1rHltdTd9UfVFbIUcPYzXCe+ABY4OFzNGZdnOjKNlyoZk9Hck6dC5
         I4twNFm6W2USdNc/mLA6SUiUeTov2LOP9rj0Sv2u1gzgdPG77pihsgLTi4/JwaW6XBal
         w5QBZ0TC34RyxPmE5tKqVEEFXIA++1tjOnMtGq7jRsFPx9msxGkaxfmtVvtXCgUZoK/i
         sYlA==
X-Forwarded-Encrypted: i=1; AJvYcCWT8EYf8eyMejBcW0wD6a9QPAlb3J1JZLvR/3+xqGyoNJRHH33Jg08YTk3DH0T1S+C1vACZ6JNH@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy74esGR3Ai75Q2v9FPw9sbSEgWRn/j+TCY/xJ3c9WMjmrHU1I
	KSYRFNzLJP+cn4TiuYEyn9OPDvQt/U+RS7Tx0qCRJa3QazRpQcP4UFpqAWJQMUtSRv+rx0CqKn5
	t7HhtoNRXcz8gTSPhb5RIoDipz0xm5r1y1m90ZQ==
X-Google-Smtp-Source: AGHT+IF5KKFkOMyYhkCoT9zofFw4RA3mLNEAwadNBcjduiYPc6MyoAx/qz66sum4SmIdy3qH5oAV2Lmd2pGB9QF/oXw=
X-Received: by 2002:a05:6512:2581:b0:539:e1ea:c298 with SMTP id
 2adb3069b0e04-539e1eac668mr5428955e87.22.1728962526175; Mon, 14 Oct 2024
 20:22:06 -0700 (PDT)
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
Date: Tue, 15 Oct 2024 11:21:54 +0800
Message-ID: <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
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

Thanks Baolu

Can we send a patch to make it as default?

+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
        .viommu_alloc           = arm_vsmmu_alloc,
        .pgsize_bitmap          = -1UL, /* Restricted during device attach */
        .owner                  = THIS_MODULE,
+       .user_pasid_table       = 1,


Thanks

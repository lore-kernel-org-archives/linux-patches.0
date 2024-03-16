Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187E41C687
	for <patches@lists.linux.dev>; Sat, 16 Mar 2024 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710612551; cv=none; b=K2sdY0efbitJG7i17zFrhSjI8DfKHaI52zqXBR8bKZr/apsTroiD4Voe50rP9VMTvCGx3/4RfSu9Npbs5+clLsbU49XpXv5WemFiukqDEhO7b8g5f/anSFNi39tgUAxhq1GGHCBqkRp072fJisSezHNBspWOSxdysXBaezJgvWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710612551; c=relaxed/simple;
	bh=M7W36AatepxpI7O/RYN4Jn7eJzFKlEBpR4hpZSIFnfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BLGMnFFIO5YU35wvRDRgP2rcMcbBRJk3rIjaRWXfrySFa6uLOdnYcZMbm4FYldKnIeg/Mj3b1sH9lfdEfSv5MHJvIWguB7c5DMTohGj897wkyoK/0aSa1WVuyKMRWuFdE/kLU0+TZzhQVBBDittKsoAy32NlGHjvtVQXYNF4RxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ashH/6JZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ashH/6JZ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cbba6f571so61192167b3.1
        for <patches@lists.linux.dev>; Sat, 16 Mar 2024 11:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710612548; x=1711217348; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZOJ0NGBpMpECnkD/VQIyE+fDv/YQu1vFH8W0copv1o=;
        b=ashH/6JZSx1+KquLxjUAtlTlJEcorvJQUr9HgoflkouV+Y7wFYbPFmZDnEoKFQLyXR
         TPVnwP/xmCq/U+aaIo9WAKF1C7ndZf+zmOxWso/kVJ7CEIOBGgMk5rkfH2IkCiFvZM9J
         FKfkiIC1TG475bhXAhGpSxE5UQHEa+l7DMow21gRIaWUBntq1UX/t2Lfn7TCMtHJM7C/
         rk7pAEEqGOWwKgx9s/YBfNNBiLxKIfF0OwczTl15FqaNdpamK4qVxEQ7LmOCvlbMteVA
         HOH1u33T9KNLgjY0ySByj8QOYQruO1+DQL7Esp7ymNIGxo9waW5+wK79b/Q2JFelT+Es
         GDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710612548; x=1711217348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZOJ0NGBpMpECnkD/VQIyE+fDv/YQu1vFH8W0copv1o=;
        b=jdus2XNI2CR//H6p8Oh/GzC9QI4qpFgjM+yToPwYoDX073vIvNKn9hubVf+K/6Up0v
         rt7TQSgbui6rHx9/gHRN/oPV6MqNKbm/rLwkatd0lVYGX3F2Zjtj3byX7xLyIQTrd/Uv
         yPO6avYzyEHfi0wi3BNt+BQybOrXhmLp4bQJ1cy7Pr2rX+GAWWUoajID/B2SlSLRQQPq
         7ONzGucYBB8YuXlWDJsTtELtkSdIzMv+g2/n0UsO7LnaqeGEtUazyKseJ6XToGfuX91l
         ZdFiOlPsqD4XRF6oE0ZKupZtLQPSlDaM31LKFhe8ndKLB5llCzcoP59B9o70UQKiNGtG
         HU3g==
X-Forwarded-Encrypted: i=1; AJvYcCXSzyoX698ZSnAJ8kgmSez2uRpIfSsI9PeYP7EYl1eMSZQrZw3MdzmExGi+exhEXmp7gtx28G+kKXVPNJ01cGeaGSdINomhIQ==
X-Gm-Message-State: AOJu0YzEgnCTMMuxJfGP1vWN7UzINyPbITcTT59oadLLx0R59uFxPDSw
	DQWb6CZ991N4xlxny0odJ/nchELueqRwtmsOKKzbhHoOQcA75lQxSPJUDS0Kh8ImKSZHFtrPeXq
	9i2UtvA==
X-Google-Smtp-Source: AGHT+IF/87+SyaxRYuFWEJM5b0xude9H3KA3kNZ6OvcJC93YOurGx6gSCgAPGka/YmjB3TvZd+wEIU5A/MOr
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a81:5295:0:b0:60c:29b9:78e3 with SMTP id
 g143-20020a815295000000b0060c29b978e3mr1660353ywb.6.1710612548651; Sat, 16
 Mar 2024 11:09:08 -0700 (PDT)
Date: Sat, 16 Mar 2024 18:09:07 +0000
In-Reply-To: <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Message-ID: <3ibp3i7bbpxl4tb3ghmqkl4uay62fx7rq6s5y5rp6c2264mdht@p3skloafagxv>
Subject: Re: [PATCH v5 02/27] iommu/arm-smmu-v3: Do not ATC invalidate the
 entire domain
From: Moritz Fischer <moritzf@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Mon, Mar 04, 2024 at 07:43:50PM -0400, Jason Gunthorpe wrote:
> At this point we know which master we are going to change the PCI config
> on, this is the only device we need to invalidate. Switch
> arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().

> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Moritz Fischer <moritzf@google.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c  
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d1bc151a5dff8c..9e9233331c4636 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2447,7 +2447,10 @@ static void arm_smmu_enable_ats(struct  
> arm_smmu_master *master,
>   	pdev = to_pci_dev(master->dev);

>   	atomic_inc(&smmu_domain->nr_ats_masters);
> -	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
> +	/*
> +	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
> +	 */
> +	arm_smmu_atc_inv_master(master);
>   	if (pci_enable_ats(pdev, stu))
>   		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
>   }
> --
> 2.43.2


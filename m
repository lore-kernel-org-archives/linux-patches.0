Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EBB605B1
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129871; cv=none; b=sLM+CIrq/d2R4G9TcPYEG848PKXGq13Xbl3rQTaZOSKam3utn5r0rI5e0Mbx7t9/VJV6YhKsXwaIsgO/uyGvsJdqYIU9VSMc5jQufFz03n/SKjd/iAz3VhWa2ejb5UTsXIZsD28wKMDsiyMhVPKkzD4T8zLBcFBSbirdWpyYB2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129871; c=relaxed/simple;
	bh=B26xAHkjaWc8Ytd0vcrUSK8pxm6Eyu4Y89+p93t+Qbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k17ioNCA7VUqBmF/2rHPgG6Ck4UXqY7UazIuAuLMRkxGfT8uljwzXr38VeLZNPo0lfNqwSy0PSB/YfJ3a0uGZhz1Do4itDuIMZ64vnERGTaLVOFwxJAzYEi0BM1mrvvnTFGnkcVBS9RVUgLAFXH5wrWFPTWkxDgWdRS95UoeLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XV23DjkS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XV23DjkS"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso8215e9.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 10:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711129868; x=1711734668; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TD8wow2OS08EXkll41wG+2OWJgdRcKgoxTd9QmAS51w=;
        b=XV23DjkSGv9p4hU98vyhRp9ptYeAcLEiDUnOo4iROSMp2nonqTGCnZ69XQKyTNJSs7
         CDGNMB6SuWHCznjM7rboTACauHv6Q4cJ+3Uvy1MXR4J02kleHr72fw/+E+c3QKt3UsS2
         sYq7O3v3rE0i7/YCUqNdp+gl/LqqAf86FRrQaH3mTO93B+M93tiXhhOKpS6Zrhi7VRA9
         Qn+oeBDNG14bDvcpBMmkbAceRircBMN5lX7XNO6Pv6dXpx27M8xQTj3Iw7jsTJ6BDg+t
         JeH3Ui6X/d5t7sTr255rYpyI2OzblBdloVrWePulF2W51igfkCIfnx3VN7YToBcJnmR2
         ua1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711129868; x=1711734668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TD8wow2OS08EXkll41wG+2OWJgdRcKgoxTd9QmAS51w=;
        b=g+0xn/kOOMY2SdV7B0m6uHCbFewKVamv+7QrLTyX2yRzAo4NdvyODOpd8Z7u6IFGKI
         iHluGGRxFbmcj05uJumkPreMGUFMxBeXhwl6APnGDdhtiR9Je/J3l2MQ8r2KuwcXOc0I
         0W9Gdj4zCc0DF3e5yB79DKGRKhFnyGZappyhrueAn4lNc5c4SLJ6yKbJu0MjN+tEJIWr
         sQWnu5hYoYgh0iaoZCps0hzkJaykWsTy1RzYFN3t4+3evepvhiyhNG/r2oKAokiZJFwA
         iC7jM184PQF8rytJsIr1ewu/4+0h8qNvW7TqJVaYjpz15jtTqJFGxKi0s7GgfRNx30Dn
         qabg==
X-Forwarded-Encrypted: i=1; AJvYcCVPCeQYg7QBlTYGLGEC6RwKZNy+MKStiJjDDjp1d5LdZ1gSXOjcTifANDX5Fr13wyMPMW8zEwURiFA3L1z6Xh1Ht8l1m1iblg==
X-Gm-Message-State: AOJu0YwzSKhL88tmeevcgU4PX421NDiHJMpaLqyVs9qn+2OBgPdeMOQE
	ZX2uEdOboiDHc8F+dvnzyvxznlX1kW0RARcrQgvQQOlOvOzaFbWCJqfm8Lyi4A==
X-Google-Smtp-Source: AGHT+IF+yj96IjCX1EMz/Pt0bDbPQTk6WDPsn7ok0J8RLbHozW2+cvsxJL8Ng4N/Lk7Z45oOH64boQ==
X-Received: by 2002:a05:600c:4856:b0:414:1400:a776 with SMTP id j22-20020a05600c485600b004141400a776mr499710wmo.5.1711129867768;
        Fri, 22 Mar 2024 10:51:07 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id a13-20020a056000050d00b0033e239040d8sm2527556wrf.84.2024.03.22.10.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 10:51:07 -0700 (PDT)
Date: Fri, 22 Mar 2024 17:51:03 +0000
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
Subject: Re: [PATCH v5 02/27] iommu/arm-smmu-v3: Do not ATC invalidate the
 entire domain
Message-ID: <Zf3FB3N0yjALqscA@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:50PM -0400, Jason Gunthorpe wrote:
> At this point we know which master we are going to change the PCI config
> on, this is the only device we need to invalidate. Switch
> arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d1bc151a5dff8c..9e9233331c4636 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2447,7 +2447,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
>  	pdev = to_pci_dev(master->dev);
>  
>  	atomic_inc(&smmu_domain->nr_ats_masters);
> -	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
> +	/*
> +	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
> +	 */
> +	arm_smmu_atc_inv_master(master);
>  	if (pci_enable_ats(pdev, stu))
>  		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
>  }
> -- 
> 2.43.2

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08EF2BAE3
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711631899; cv=none; b=oT212AwgzxKP6vRA+x3qVbtgq4MmWcNqpc32XRGEifIdKocbPoBp3bF1C8ZUbIP22xKLuxWYHnr7nvoNwSmsvy8CWHgPUm5iRQro/OJ9bjDsfMU2+ZyXFF5MWIkY3uhMbWGHeXT7DDsSPQe4cSSdz8KLgqTSg9g9uOMOJjWcgOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711631899; c=relaxed/simple;
	bh=m9Xq5g3ZIfAlKNLnX3jBhbUBxEU3DFQEizqgxV2mYAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfG6L43vDuVuIzZv7vT9BsXs9djfhzsycd38hCjRhYg8yGmvSn7fZsky6BcA5x9c4nDHIXM6Xu9VQksnI5S8R/suyoKE7X/HsiGj3Ik62ZtAnC2Inhj34XaLey7Z/7fu7FMDUZ+Pyfr5bomCcckqnyxqZcGSxVlkhWMWI9r+gh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PAuay5rl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PAuay5rl"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41549a13fabso26415e9.1
        for <patches@lists.linux.dev>; Thu, 28 Mar 2024 06:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711631896; x=1712236696; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KRxD2qE2SiE5U4r15yWiOr1p4ZGvqGTpNga6hUR8pFQ=;
        b=PAuay5rlNfUAstYrYWSn4zjogFFtL/ZNqeKZrxjnXvrBi9yf0EVo4Ukk7pQLU2+sid
         FukwWsZHX2IUQcr56hsrimnsOaOVyV75fqag2KG/0lDMRTX+TUTia1ot6LcylZLNNdQf
         nF8L5wwe9JJmhxdyFanbex2gTX08d6/is4DI1FJo0YgWDrJExrAa4O07xPfGQZZkg1kL
         Ai/FZuYhuSY6wJvsjSAdYQVKTtRUySqnzB2skDbR8i1/pd3gZ4MoWr8feyYTUydRbl8f
         2utjoxq9K+Bv2r8x/29C2vS5vgCXNOcp1Ub5gE/dh2RIEHFi4yg9sBI2tN7YsxSYxHkR
         iqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711631896; x=1712236696;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRxD2qE2SiE5U4r15yWiOr1p4ZGvqGTpNga6hUR8pFQ=;
        b=bl/DbgzDbWgd3asjtac0IQBAKuK7YcSzQ8gTmI7BL1B66cshsjP7EnhAXi1iWBNB9d
         IJLXtUlw5Z8EzlP9on4DHcEfIOqfnafqCfFNFZt/aCPiAwsAfcSS2ioL2SjYHmnQSqGU
         /1MoO56IJsPpsiYEMdVXJJ4esj+fd16bQBRt1JboDAtDmoPaq0qINBD6rtvHQMSSZWKG
         20i6gGj+EVaZeCbRYiLPtz6V5y+Q2LgKvCRdwB6mJPX5yluZoDCg6EahfVSjKA9+dVfv
         lWmNcTwNfHA8R3et8Lz36jBh1mwl+lC18gg/UsVylFD9Xa/keZHOTdMhhnXAVE7bHuDW
         qZ+w==
X-Forwarded-Encrypted: i=1; AJvYcCWE7Pn0aR0mwxk0EGIWPNoKRgGinKQEzbUFrvCSwyvO3ogZfPwQveCVGdouJiasKT0wkqVKUoWraVAYP3mMAkNskUYCxD/Sug==
X-Gm-Message-State: AOJu0YycDrUnpJj98bygZybJ4dxlUKLaNzHA5A797VZmqqzTcezawBbc
	oAaXK+W0Wvj+hku6JrZzOU86aoTb88KP6fNjqcqbF1xRW6ZA9GjSqUp+KsfeUQ==
X-Google-Smtp-Source: AGHT+IGfN0vIqHAcz8qETmuQ8hKB2UR3XHLQnh1dVfD7Xd8Xs5tFMQBmY7N6uswYUuSEJZ6jXZsYlw==
X-Received: by 2002:a05:600c:6546:b0:414:7f46:95f with SMTP id dn6-20020a05600c654600b004147f46095fmr152048wmb.5.1711631896097;
        Thu, 28 Mar 2024 06:18:16 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id bd11-20020a05600c1f0b00b00415460a63ebsm1581636wmb.29.2024.03.28.06.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:18:15 -0700 (PDT)
Date: Thu, 28 Mar 2024 13:18:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Tony Zhu <tony.zhu@intel.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 03/29] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <ZgVuErNrG9EcbPbX@google.com>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Wed, Mar 27, 2024 at 03:07:49PM -0300, Jason Gunthorpe wrote:
> The SVA code is wired to assume that the SVA is programmed onto the
> mm->pasid. The current core code always does this, so it is fine.
> 
> Add a check for clarity.
> 
> Fixes: 386fa64fd52b ("arm-smmu-v3/sva: Add SVA domain support")
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>

I think there might have been a mix up, this was patch 01 in v5,
I didn’t add a tag on it. I don’t have a problem with the patch.
I just think (based on my limited understanding and rules in[1])
that it is not a fix as (mentioned in the last thread) the only
caller in the tree calls it properly.
But that’s up to the driver/stable maintainers.

[1] https://www.kernel.org/doc/html/next/process/stable-kernel-rules.html
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 2cd433a9c8a0fa..41b44baef15e80 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -569,6 +569,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>  	int ret = 0;
>  	struct mm_struct *mm = domain->mm;
>  
> +	if (mm_get_enqcmd_pasid(mm) != id)
> +		return -EINVAL;
> +
>  	mutex_lock(&sva_lock);
>  	ret = __arm_smmu_sva_bind(dev, id, mm);
>  	mutex_unlock(&sva_lock);
> -- 
> 2.43.2
>

Thanks,
Mostafa

Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46BC2629D
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 01:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731632881; cv=none; b=CsWMWI8ng31vdTpUe3nfqK0GQbHJvegVlGxSkKThITPScPQIFcPLJ1363tc+Yb4oJe5aQoqgH6AgV/PFeA1j6a5YFJivkFwEnKI/XA4yDb1s/npWUi8UQnSLAPgCbv4vEted5Ra+UbIjg+j0JnN4Hy4UiBpqtNOusYLywO5cqFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731632881; c=relaxed/simple;
	bh=EF+n0oMq+jkaOCVSeKijMw8NCSV9S6MQgJOLuMQdQSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGxhGPVNZfbf2FqFYfmAVB2ggc9XMPfLqiIs2E9910l2VfOoAZZy7eM5EQLg0AFUfRS/rxOeq0bWwfhiZqQnSe1OLu6AKduKp165+ZaIHTYzNCKdCuztOg7CG1R1KUqcx4qgbEPNlDUs/sxEX0FRI4z4p/wGuVFCgqiPZ0MoZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=SuPUWyGX; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="SuPUWyGX"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6ea0b25695dso11653917b3.2
        for <patches@lists.linux.dev>; Thu, 14 Nov 2024 17:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1731632878; x=1732237678; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3aWXJDvKxrgbp/6ctsqOes9P0Tv5Ujk4CBOngYzj++k=;
        b=SuPUWyGXE3hEYrduXHlQx5Hzcwe27UStXU/egYsss4w7A7NRsEuVmvJBGSqxqFIdvF
         IWFwo38/FSaVhLdNQDkEfyPlZHFsm4pEW4+if1716GfA/FGQMCKdup5ZsttysBmY/KDk
         07hdXMxz5JHrdqFhiYTrJJYkBbdZvqXyFX4t/8fiwuB7iVyiZSKcn05zNocMwKZgZlB3
         hjjubggvdf1mrk8hTgzPbfzJxF2LBgzanzTkUg1WvU2F2cq/ZZKmXonUmMc+CceO1OI9
         PUPAcPH2osMUvmU0zGEKDglFhNYvbs8JSnWa87141jv5R0hL6bVr2qLi0XtYFfUAtH+i
         P/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731632878; x=1732237678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aWXJDvKxrgbp/6ctsqOes9P0Tv5Ujk4CBOngYzj++k=;
        b=dNAV7jXQkWlIrJGc8rK42rodcpZgpfInVq4+MxagdyVAkRxqpMiJgdOrpZjsF9f0pf
         0HTWIuG3uUrf5/L8QAs/Q/6qO6NvFMU8zXA2QRu1m7jk3ve5vad3scsawzwv80xMjX2o
         02JMMGjKWA0blVE/JbDh2w7ZDOzwxNT+Mot33UGKtvQF7rr9IKxoVlD0U5Ez6uTBKEW1
         Muj///8Z/yx965hKw8a4wX3uJzz9JrqRE+zGwBIz0fPB/6hv1kTJc8Wo3Bb94MQ1KrgW
         1oo6NoBVFDLF0FxUEd4m0YQCI+7TKBqJUxVT55U4aq9pGl6bZ2kTHXBq2UBHsE/qzYEi
         ZjKA==
X-Forwarded-Encrypted: i=1; AJvYcCUU1Hvt3pImb/wHPzXjd9Hp4rCjjy61JPY+/6N7GRLlEPqs32oukyRAEI1TShJO2ALbuXigdRo7@lists.linux.dev
X-Gm-Message-State: AOJu0YyLcCCROlQOQh07XXa1a8Hrr/roePNxXgSc90hNHBFwlQ37qzOt
	CTBMTveLoEBT1BpaD2gr865+yGE/mEeibImz0KLVq3aS24tyQyDK2bZL8fXEvzE=
X-Google-Smtp-Source: AGHT+IFbzaNJ9yX/vZFqwFt8LqRMXX16nQ2JQuel0sEYgbV2jhBLReqJAN+HyqsCdlHeN/ugBBKRhw==
X-Received: by 2002:a05:690c:604:b0:6ee:381b:eb74 with SMTP id 00721157ae682-6ee55c2bad7mr11848267b3.22.1731632878617;
        Thu, 14 Nov 2024 17:07:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b35ca2f72esm107056085a.78.2024.11.14.17.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 17:07:57 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tBkoW-00000002KO4-3Gj3;
	Thu, 14 Nov 2024 21:07:56 -0400
Date: Thu, 14 Nov 2024 21:07:56 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Import IOMMUFD module namespace
Message-ID: <20241115010756.GB173265@ziepe.ca>
References: <20241114-arm-smmu-v3-import-iommufd-module-ns-v1-1-c551e7b972e9@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114-arm-smmu-v3-import-iommufd-module-ns-v1-1-c551e7b972e9@kernel.org>

On Thu, Nov 14, 2024 at 10:42:29AM -0700, Nathan Chancellor wrote:
> Commit 69d9b312f38a ("iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC")
> started using _iommufd_object_alloc() without importing the IOMMUFD
> module namespace, resulting in a modpost warning:
> 
>   WARNING: modpost: module arm_smmu_v3 uses symbol _iommufd_object_alloc from namespace IOMMUFD, but does not import it.
> 
> Commit d68beb276ba2 ("iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE
> using a VIOMMU object") added another warning by using
> iommufd_viommu_find_dev():
> 
>   WARNING: modpost: module arm_smmu_v3 uses symbol iommufd_viommu_find_dev from namespace IOMMUFD, but does not import it.
> 
> Import the IOMMUFD module namespace to resolve the warnings.
> 
> Fixes: 69d9b312f38a ("iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 2 ++
>  1 file changed, 2 insertions(+)

I guess the build bots don't run ARM64 all mod config?

Thanks, applied

Jason

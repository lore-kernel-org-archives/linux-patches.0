Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA47C3F7A99
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775042618; cv=none; b=CY35ourceazpin9WpOs4sXDTvTKmFhIPLo4VEFbAvX6Hlcoo/UVvyqmgAdNT+pdFjF2Y4snYpR9FChYeMG0ii8MYUXxhCin6f3kEV9z2yEG98qjpIG3cmf5iTvGVUtCCx3PWOZhS6lxLAo11cxIVkMeG8ZhJVffjyw6JWoxQS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775042618; c=relaxed/simple;
	bh=tZ1qpc9jFWedWE8AwUzwx8Nqnc2oEi5R0JG7PTZIt4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7Be6tCY/K7Vwdy0uCL+9e2qxA0izXup3la/r4mcanv2lGjfpI4yzOTlQ6MxVvTopD7RXFDobuYiGiTGZyhQdp75J7q5OIbzDAiEXVvywI2cIXRVPqV5pq7qAeio1bXjgqELFEN04cPTEiVSfp5P65VP7zGRYKECpek5Fh9Xuds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tFfA36T0; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tFfA36T0"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b0b260d309so166185ad.1
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 04:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775042616; x=1775647416; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+wLwW3RwfZlMNchucl4Q1BjkgKkbbVmuqcbZXsSlons=;
        b=tFfA36T0L/p/3B8WwNcVd/ZnKEw0/jmZ1FVHVH6vUT7bZOQPdCKOKpyym+Xi5AdYle
         +snvjJAW+VNqWpeos7Gdi9EXGemBRm91eNQ1AZVSnCXr/35xgy5hpLdBS4ebfORwLcHz
         CfIOB8+8DbhgaTx9VKpREnvLoxSghZ+VJH6tYr5Xj/diZeXQoQzq6KTtkw05FfiwkESN
         Q+xJ+xQt17mW41J7dqeLdoNukoH0smHXLk6d+zrlpbcIKNQQlV6ig5lguYjfOzOjl98b
         PKrE0IiU49AXE33FPK9/JOCbLW3fgw5ndgDvKiA3EIYJohjS5sbqwXAFZgFcJRQporbV
         +21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775042616; x=1775647416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wLwW3RwfZlMNchucl4Q1BjkgKkbbVmuqcbZXsSlons=;
        b=i9RnylUgKL7G8AGlQ/W+LtaefLjfj9VDOp/u+cLYi+q1tVBEg34pKprfVZJHrrwu/R
         sfqLHBZFXUSybD/xvavvB6Jgsx2dGvEG1+lqLo7O/WY7yVLIOUTtWOG4XmyIpvlxn8ju
         xvlQjn2C69LWr7hnhxYo/ZY4vthGQFDGiKkw1dOnwmjj8rr8rqg5GchVyoDdQ/0hTTjd
         06VtN5HRhM/RkUzk2yVyCmws+oKtKVEVQS5ogEzjSI2iSYKSh2mLg38aeCRnMcFpizE+
         VjyFIDOYg6IKdLILUJDV+4uVy6Ez8XYYS7i51v1hccgmH9PlKQgMnFdAC/SSkgM96yVG
         TtPg==
X-Forwarded-Encrypted: i=1; AJvYcCUNb5iV8gc4TqZoiscTGuTqf8raKi9fVZcTVTeATMfrd73sTUxWcTAsQRQfsAK7Yew+21XkRNEV@lists.linux.dev
X-Gm-Message-State: AOJu0YxA7fpbUKFbiD/9KsTiTYCxGvU6oFJDp3t3kskQ+1L7e+GCrNYG
	6ZoFkYQ9EpmjZVaHmvme5hZvrdnHBHqW+1Rk8J1V2YnQ4hfntXzh7RWMS9ZQFGrd1g==
X-Gm-Gg: ATEYQzzyjNBDPM/Y/J7cZexpiKEXrhl26PFtM0lnB5aRKXMRBY4tRPHEnoXVbYvyhT0
	nwgMnuvSngrbdeodgT0k1aKjszqN2nxE2A2JrxqmE9i9usIHtECzrsMYu5Unznl7XMyANj54qOd
	Bz1Siaf4/OfzSqrbyFxg0DvsYqdqYiqQMR9c//SZrcu7Zbdb5yhVSFm6H7r4rrmmFjG/9zeofG6
	V8g9wZ7Q4kh+Kxlx6qvTYwbsHeTqKS/JaIr2uakKx38b0CTr6TONpfXaYjyslQVKkzoAWUWN+lU
	MGf4OCEdztakue6f9GyQRkzc9aUj8v+f8ykDLwPT7Ep7EUGaYxdE+T3ygmY1fwu7q0lirtOGbfy
	u6w1jwL+0jZlmDnHldZiiB7TulmvBylpizzXLFCGyk+WcbYPdcXRfu1eOj6EpNj0+TF4x/9Plqa
	y6PxzAf2BDjU1m8mphXJUR/aTYKij1pjlnYFuSftAHAmIvckwdZrTIqLjvYw==
X-Received: by 2002:a17:902:ccca:b0:2ae:44db:570c with SMTP id d9443c01a7336-2b26b2b089amr2189835ad.12.1775042615401;
        Wed, 01 Apr 2026 04:23:35 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe606dd2sm6533691a91.3.2026.04.01.04.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 04:23:34 -0700 (PDT)
Date: Wed, 1 Apr 2026 11:23:23 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev, Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>, Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>, patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
Message-ID: <ac0AKyvHMYHlqL5i@google.com>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>

On Tue, Mar 31, 2026 at 04:56:22PM -0300, Jason Gunthorpe wrote:
> The fixed commit assumed that the gather would always be populated if
> an iotlb_sync was required.
> 
> arm-smmu-v3, amd, VT-d, riscv, s390, mtk all use information from the
> gather during their iotlb_sync() and this approach works for them.
> 
> However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio,
> apple-dart all ignore the gather during their iotlb_sync(). They
> mostly issue a full flush.
> 
> Unfortunately the latter set of drivers often don't bother to add
> anything to the gather since they don't intend on using it. Since the
> core code now blocks gathers that were never filled, this caused those
> drivers to stop getting their iotlb_sync() calls and breaks them.
> 
> Since it is impossible to tell the difference between gathers that are
> empty because there is nothing to do and gathers that are empty
> because they are not used, fill in the gathers for the missing cases.
> 

I believe the problem is a fundamental disagreement between the core
layer and these drivers. The core assumes an empty gather means there
is no work to do, while these drivers expect a sync regardless. With
this, it seems we're forcing the drivers to lie to the core by 
populating a gather they don't actually use just to trigger the sync.

I was wondering if, as a longer-term direction, having an explicit flag
for these drivers to indicate they always require a sync would be a
cleaner way to handle this than the trivial population?

Just a thought, not a hard disagreement with the current approach..

> io-pgtable might have intended to allow the driver to choose between
> gather or immediate flush because it passed gather to
> ops->tlb_add_page(), however no driver does anything with it.
> 
> mtk uses io-pgtable-arm-v7s but added the range to the gather in the
> unmap callback. Move this into the io-pgtable-arm unmap itself. That
> will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
> ipmmu-vmsa).
> 
> arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
> already have the gather population because SMMUv3 requires it, so it
> becomes consistent.
> 
> Add a trivial gather population to io-pgtable-dart.
> 
> Add trivial populations to sprd, sun50i and virtio-iommu in their
> unmap functions.
> 
> Fixes: 90c5def10bea ("iommu: Do not call drivers for empty gathers")
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/r/8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/io-pgtable-arm.c  | 4 +++-
>  drivers/iommu/io-pgtable-dart.c | 3 +++
>  drivers/iommu/mtk_iommu.c       | 1 -
>  drivers/iommu/sprd-iommu.c      | 1 +
>  drivers/iommu/sun50i-iommu.c    | 1 +
>  drivers/iommu/virtio-iommu.c    | 2 ++
>  6 files changed, 10 insertions(+), 2 deletions(-)
>

Acked-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

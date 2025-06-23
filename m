Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D6279DA2
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750691645; cv=none; b=U4yc/EYCnBuUUEcLz6cMyZO11RkhmZENzuGFrGkgz3s25rhftVDeYlc7HYkrwd3bRydT18ytOidEyIETn2GBpAEx5OBF7QZ61xuR5KKNwHwXxtEOXYi70kThgTLIOs9n0BDhlTpqZsHjIlMuneXZt1/h8oGkFJ2CCLJ/L02CmyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750691645; c=relaxed/simple;
	bh=T97FIRu7KTdXAKAuE2uiR/N85Qp0pQvg5x4paRRjBE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LS00plfoOETJK6QebFoK/fV+fXhaHHOXuw5tHlqBzIBq1eQEk+jUvUI/KyJpg97ANCmNi1AjC1xB/iRKRFHTb/6L7NpWV0xVco9TK0I1vubF0GBlHgZ1C3VI9JfgIDSnJAN1knqTHNsCnURN48VEA8rGaz1GGqx/2hYhDeddPaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZ2HHS+8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZ2HHS+8"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235e389599fso345355ad.0
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 08:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750691644; x=1751296444; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sQjNcvHYakrNgjIQGLE/wyS2yfZF4798fujbYGUPWpc=;
        b=lZ2HHS+8iV9qToBbN9H7BKcz9WrbWe74+R+stKoQ8S++Q0mQ/4CKX+HZZnr/p5/lvo
         1gFcNYRLVS2lmTQbyw9nTZCsxGZbIoqn4wij3lZ7kBZc/yPyga2FEXOJQog7qRkSc7EY
         BxoLKl0g6krhruBvlz8o2GX9+IIqohNjgCVbDis+xIVPoPiQi+MTAfu0YrZe4SGx8Jm1
         IrzGi1vpJINQT/OTEQVDzZg01xUkXCX5ojulw2q/j+7ETuGcWuJ1x4b4etje2xjdf4Cw
         aumQZPHX+vC7lAd/+WsFQAwBUASDGwGdfo8NeBkIs5I7W6KhnK2FKerCxfcK3CIsxfLy
         WZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750691644; x=1751296444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQjNcvHYakrNgjIQGLE/wyS2yfZF4798fujbYGUPWpc=;
        b=NnKZK82wGfW1q9JpJnSZQIq99O4yGgqDimQ4d7gHCDl513A44Jnza4wSt9uBPhQoY6
         WYlKj9OHpFaMvbc+qvUx3NDI2c3AXahqNTNMzj1mlicaNLYFOAsiInfQdioaBQy3VJJx
         Kjesf3lB0APsE2hEa4gCLwK03Q0yH9QiKh1ozdNxV+ritEODOoseiFCc/8C/imH//Rrr
         RD92jO0gK9NPu+dtrHJTZR+Sc76+2ALooAm+5Byj/45u/7RitLPECmWybsgFzecsWUG4
         quLF1JFWTG7rJg0kIqFbVzf3NGMnGk+KtduXh9fa3ak9b5VkgIXvlllzI2/7eYgGRTj4
         xfHg==
X-Forwarded-Encrypted: i=1; AJvYcCXz8FDb2ZmvwybH4kQE9Szt7KKymnCMfp5Qa28wy6vWJd0TZ7MziXVu3jX09KJflK6xqG6gclnZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwVsORE21Mvdbz24abT1ByabomfB4Ta5ZtPuS3Iriqb27ynYpQZ
	D5TvuTIUybd48h/kwtgJpesFRcYGjNeRQx33tfCyMZxwHAtKQwFOnm9IPwaIsdQfnQ==
X-Gm-Gg: ASbGncs6vrIej95Ta/4Ghu7oFUnUhhG7yWleJ5N1KLXUZGAm+XTBgkn0/QiYawEO2Bq
	O4m+7lHLTXn5tzXWXki47hTZE2+a3oly3hYWPpMz98WG9XkYWY+KqNRBr90pBjwOPWT3+QSohlF
	BeROf2wy0OJaCpD9L5J3jLGtYxdaJL3JjN/3YWc7/fjLqAOSXrugvK4OHpUVMdNHr5wsUTmpH75
	aF7n+82xE4/ajDlO2xcD+JBV5U82hBsdMulSgGnSZYnu4Gw5VgpLFLGVrkNhT6DWq40pc3hBwUA
	2n03GNB2V+8O6Is8whkZeveAZTjJ46fjmOM+HCBqFnYvQrHMmIf/5VvMvBE1f92rMaI3Sx8WN49
	n44Dd5j7gtUQxbRhcDFdrt0SK2PAleBY=
X-Google-Smtp-Source: AGHT+IFjZuHSmjWz3mlyiiORGjulfaekm2TrngIFHZiE0ZqJkNGQDEFi3n1LBmgMIlW05C9z3Da4aQ==
X-Received: by 2002:a17:902:e951:b0:224:6c8:8d84 with SMTP id d9443c01a7336-237e478a96fmr4808555ad.4.1750691643222;
        Mon, 23 Jun 2025 08:14:03 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a23e6fbsm11004566a91.14.2025.06.23.08.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 08:14:02 -0700 (PDT)
Date: Mon, 23 Jun 2025 15:13:51 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kevin.tian@intel.com, corbet@lwn.net,
	will@kernel.org, bagasdotme@gmail.com, robin.murphy@arm.com,
	joro@8bytes.org, thierry.reding@gmail.com, vdumpa@nvidia.com,
	jonathanh@nvidia.com, shuah@kernel.org, jsnitsel@redhat.com,
	nathan@kernel.org, peterz@infradead.org, yi.l.liu@intel.com,
	mshavit@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v6 20/25] iommu/arm-smmu-v3-iommufd: Add hw_info to
 impl_ops
Message-ID: <aFlvLw0SHgYiA614@google.com>
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <f36b5e42bac83d0cdf5773cad1c3a44c3eaed396.1749884998.git.nicolinc@nvidia.com>
 <aFP4zHIVT6epJeLb@google.com>
 <20250619185325.GB17127@nvidia.com>
 <aFTWQ4v6aZABpzeV@google.com>
 <aFZE+MhTOCvbkKbH@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFZE+MhTOCvbkKbH@nvidia.com>

On Fri, Jun 20, 2025 at 10:36:56PM -0700, Nicolin Chen wrote:
> On Fri, Jun 20, 2025 at 03:32:19AM +0000, Pranjal Shrivastava wrote:
> > My point is that in-case someone passed INTEL_VTD type, we would end up
> > calling impl_ops->hw_info and then the impl_ops->hw_info shall check for
> > the type to return -EOPNOTSUPP. Either we should clearly mention that
> > each impl_op implementing hw_info *must* add another type and check for
> > it
> 
> Let's add this:
> 
> @@ -721,6 +721,11 @@ struct arm_smmu_impl_ops {
>         int (*init_structures)(struct arm_smmu_device *smmu);
>         struct arm_smmu_cmdq *(*get_secondary_cmdq)(
>                 struct arm_smmu_device *smmu, struct arm_smmu_cmdq_ent *ent);
> +       /*
> +        * An implementation should define its own type other than the default
> +        * IOMMU_HW_INFO_TYPE_ARM_SMMUV3. And it must validate the input @type
> +        * to return its own structure.
> +        */
>         void *(*hw_info)(struct arm_smmu_device *smmu, u32 *length, u32 *type);
>         const size_t vsmmu_size;
>         const enum iommu_viommu_type vsmmu_type;
> 
> And I found that we could have another patch changing "u32 *type"
> to "enum iommufd_hw_info_flags *type" to avoid some duplications
> in the kdocs.
> 

Yea, that sounds good. Thanks!

> Thanks
> Nicolin

Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150E31C245C
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 03:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750390354; cv=none; b=PIrhMQXe20WsTwMD9L/VWQlvbpWoL4M+ZKc7EnGn3QvozyVKPx8ybOVQJ3fV5cqm9IBysFTmkm58HKz3UXVEcSxjg2y9u9x25Jzufdwh3Djqspg5VoaDDxL1+WaTDVEWujGJxULVr+qHYHOKnEoAzIXaSWEpAlGPzGLXqb8mOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750390354; c=relaxed/simple;
	bh=9Hg5pobEE7M3tPGS8XdU/oGbneOqIPiRWFR/3Cld4kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRObwhVv+Yjcf4PVpWcWtXzqNsp0LU02nZe4IMVze9/gYXanNJR2VwIfmTU1BU3jYSItiripEqkHcVTQpiEcJd9z3fIsIcvu0IsxiwuEnrihuF9s/XPJJ79KOSki2Mh0cNysv+ZSIPojR0F1qWEMa4FmZA5s1q4mLd8yQIVmH3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MxbS3juN; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MxbS3juN"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2348ac8e0b4so228755ad.1
        for <patches@lists.linux.dev>; Thu, 19 Jun 2025 20:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750390352; x=1750995152; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qa/VDd/mSdDHpuvSCZ3/ODd1JXeFiiam1MgWlPeSiGs=;
        b=MxbS3juNazFI5is62dE1QGwkxbnh1/mTssw8Zt2VwoJ1UMaM17CpAQH+9awzNOPr4V
         9EfDJ8RMeHNvLhq0+tb39Xa7iKQK2971LrlciLuJQXthl2FwXbj0nHLMCuqkRLfG2eED
         pfTVV/qqJAT02CqdQBJqQYE2h8vuRuNC7SZlDYQYOX1bkYCg79wcATGO374WVKG1Pge8
         9Q7o3vOHI5iGV4v04FoLoHrTv5S5/h+TeFvzZexmE4ZOyK9kF1DMW0Si1RAtnSMpEQPl
         7dWreDngW5+AAaBCDtWtLR1g5/CV9bV1HvEzBK5WuueK5qGKa65TGW4ad08d/b2eJx0V
         /NPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750390352; x=1750995152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qa/VDd/mSdDHpuvSCZ3/ODd1JXeFiiam1MgWlPeSiGs=;
        b=g+2I8KxJGOqgbQ4/6bwjkml7JUY9+dbIjP8G3iZmFB6W48Xao969Hh+hDz5jBrgGcJ
         48xKmHg9BQYDAo4rkwYBi3HlTttujha6/aop+iaW5q0IgdcRKJxfWoyluz8ydYoy7jwI
         VQf8iQYNYTL6HyMvCYLfDhzg/8ayfPsTp2BldzANFv1roJVvxZX4RZeKdoDt3ZMGhNSm
         7hHKrJY5k755HdmqaR645C2mXpVQhCDdIqpdce4Idp3SkZCqgh2oITFIs/fgWaHV6FZs
         mDlFt33t6epABKKyFam1NtjMRb37R1yI2GdVkKXlusDs9k3Y3tNsed774pA3fkiijXsF
         bitA==
X-Forwarded-Encrypted: i=1; AJvYcCVXoIpe2S1lMDxPno8XAhs53vWdCU0oDbtqCYW4fD/bZT09c175yrOjVUC3mEpfLeTD2nXBj/uB@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy1uyVyjY3n0ZKGtI7GNjHj/QLQ/HNHZG0Nvk2cZsqGbbC5mzv
	g7j9CLamu62O8Ytuw4jppNTHIL/DaLu3C9m5mpW8fpvakNePZAHhMYSDp0OE3V366w==
X-Gm-Gg: ASbGncsH7msOW3L53NWsYO3n3QU4kwIUbbc/OOBfYj30nfB1kqTJUi/L3AcyjxZ5V4x
	AH/d2HLEaUQQvN2bONWIrC0miHtR4qq/ueTIQUl+Z5x79sjeTMkOU9z9Vg97XVdem69S+gCrAkV
	jLVuZK5TsYxrxdNbGV8fvp7mCbrJnH17OfA5RrtlSAVJ4DyZ6uN2KMEgfuXQtUeM/hDYYF0c1JU
	/8bBOti0mznmBCjOWeQV3OWvr98lvDtRUsCixwiXn3eL5Gd9oZKSxgYj7crbz4UHfwugVOCIug1
	8dC35OJmwbR5x4mbHo199gFlcSfIyQ3dI56dFfDEiE3/xVB+ZNW+okMBdPLgAvmMGOyT+xSSRbu
	2z/90rfbmlswg6DW8Ph9KWJ3zHny1JgE=
X-Google-Smtp-Source: AGHT+IERsl+HTUr1rqxITuYHKylDMvSd/CxPtRuNjbrAMl+KyO4xPzytclG3wi1xtC95QCov1vt9OA==
X-Received: by 2002:a17:903:1667:b0:215:f0c6:4dbf with SMTP id d9443c01a7336-237cc9fd3d7mr4672645ad.14.1750390351828;
        Thu, 19 Jun 2025 20:32:31 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d83ce860sm6966175ad.65.2025.06.19.20.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 20:32:31 -0700 (PDT)
Date: Fri, 20 Jun 2025 03:32:19 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, will@kernel.org, bagasdotme@gmail.com,
	robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, zhangzekun11@huawei.com,
	iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org, linux-kselftest@vger.kernel.org,
	patches@lists.linux.dev, mochs@nvidia.com, alok.a.tiwari@oracle.com,
	vasant.hegde@amd.com, dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v6 20/25] iommu/arm-smmu-v3-iommufd: Add hw_info to
 impl_ops
Message-ID: <aFTWQ4v6aZABpzeV@google.com>
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <f36b5e42bac83d0cdf5773cad1c3a44c3eaed396.1749884998.git.nicolinc@nvidia.com>
 <aFP4zHIVT6epJeLb@google.com>
 <20250619185325.GB17127@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619185325.GB17127@nvidia.com>

On Thu, Jun 19, 2025 at 03:53:25PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 19, 2025 at 11:47:24AM +0000, Pranjal Shrivastava wrote:
> > I'm not sure if I get this right.. if the user (while porting a VMM or
> > something) mistakenly passes *type == IOMMU_HW_INFO_TYPE_INTEL_VTD here,
> > they'll get impl-specific info?
> 
> It should call the impl hw_info which should fail?
> 
> +static void *tegra241_cmdqv_hw_info(struct arm_smmu_device *smmu, u32 *length,
> +				    u32 *type)
> +{
> +	if (*type != IOMMU_HW_INFO_TYPE_TEGRA241_CMDQV)
> +		return ERR_PTR(-EOPNOTSUPP);
> 
> If impl ops is null/etc then it fails:
> 
> +             if (!impl_ops || !impl_ops->hw_info)
> +                     return ERR_PTR(-EOPNOTSUPP);
> 
> Where does IOMMU_HW_INFO_TYPE_INTEL_VTD return something?
> 

I mean, the check in the driver (for e.g. arm-smmu-v3) is:

 if (*type != IOMMU_HW_INFO_TYPE_DEFAULT &&
     *type != IOMMU_HW_INFO_TYPE_ARM_SMMUV3)

     // call impl_ops

My point is that in-case someone passed INTEL_VTD type, we would end up
calling impl_ops->hw_info and then the impl_ops->hw_info shall check for
the type to return -EOPNOTSUPP. Either we should clearly mention that
each impl_op implementing hw_info *must* add another type and check for
it OR we could have sub-types for implementations extending a main type
somehow?


> > I agree in that case the impl-specific
> > driver needs to check the type, but shouldn't we simply return from here
> > itself if the type isn't arm-smmu-v3?
> 
> Then how do you return IOMMU_HW_INFO_TYPE_TEGRA241_CMDQV?
> 

The current version is just fine with a doc string mentioning type
checks within impl_ops->hw_info OR we could have sub-types for
implementations extending some architectural IOMMU. 

I'm just trying to avoid weird bug reports in the future because some
impl didn't check for their type.

> Jason

Thanks
Praan

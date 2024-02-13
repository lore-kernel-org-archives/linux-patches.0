Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0325565
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707842810; cv=none; b=lmBiPICRPcsXL1aBd0+Jigq3+1OZopzwKbmG6w1E7F7Vs5FXsURcIiy60CuOcWX9RpIZ/cdNx6Y8Qapq/6ule2ETHgoTdcMVLAAsNCHupFi+abEi2CArU9IgjThO84DuPkaI+XIwOE5zaN3TANWqoiXlIRn1C9HtlAY/KG+eFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707842810; c=relaxed/simple;
	bh=tpR6mme3U+c+hWwnrFLNhjYtJU3ak8FHR/XxFoZpt7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inS/jKXQvxci/6sucMORYXVkJ3U3JjMKw6t3egIBuP9Dlw1aXuwh6IhqmZ3HKVeEZfJ542PrehgccXqpKzo73w/WX6oXyQUxmXbJPujeNRv2gsJUXGR2ZpcuSY5Cu39zMzDtxmJnk69M4MxwDgj+iQZL5MC2CNXebM1B6Loplpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHeX5IWT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHeX5IWT"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-410cf70a057so64275e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 08:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707842807; x=1708447607; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ucHnqK65dNySMm0vCRPbNkUFL42gA9gziXTQqFiNUvw=;
        b=QHeX5IWTqEp+oKym4UQAeP7/PDKOs+/EgOlZZpKG1DlC0tkcI1LHaHXEFcRGGDLPSt
         ElFMcVRan4UpH47qaWhD4wjtmAReAOme3CjUhob2le194oBAIeOJvo2Iy2p7AympXHv8
         9QqhwdHJ/YRGEnbaV1Up7/L7QL15CBP1qOJNSmmZsWZNtszXa98wxus7Yx1Y/DEE6+wa
         inzqZpt0mFUSLXrYi7XMnMZGlXrpwBhWy73Ld2/X8+qYno8m3RDVLJc+YzbSCwgpkaER
         EkoYdZpuQebBHG0Lj1jO3f/4+OqpdwT7e9PgP+yofp3IGPqetBWRf1XlP0NB0dLCGXxj
         k/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707842807; x=1708447607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ucHnqK65dNySMm0vCRPbNkUFL42gA9gziXTQqFiNUvw=;
        b=f+n55UQgctz0RLxBbQiEUcGHR9eWzvPxPq8oXui6jIvabh553Ccvxhi6Hh9GInu7h+
         oVF6JrQ9BagYBZU8j0PAJjb+0/vdqvs6wIIE46hrYJfgfv9lPQie+ZQ6z5NQ0KRgW6tw
         0amuCuCMkOZkWmIgH7LdnBCZKINU8lOmhOhTCsYOomOSwds1sy9cFY645od9YKZoQsl2
         EpkhQIk+TfXUCXvWmqr7iTDdFU+XtXKrawnwa9/OVZt4d3kpA82cVvOY3d1EEzLhpm62
         KYPoTMurfmDUGPnjYPwNlr5kdBCiMGWWuMOrH3OzHJfu9hSAqfWuCqUNzES3lWGlLDec
         vEgg==
X-Forwarded-Encrypted: i=1; AJvYcCVLXE5vCP4JqNduzQjVJQWo3Stv4p2s66n5OLqPQwMu4O7U2djZGqi9W0Q0Lp1CouA1PP6a+NHHZt+pBM7QhCTd6mly9GlmZg==
X-Gm-Message-State: AOJu0Yymw+8ER5PbMinGEB1jz60COaYga17yG7RAfnzD/6h2gSBd+dFF
	rKggkeENj3gQwEcxu0q6ezRKyvSlgjt/ZtR4rF287nSlHELIaSZ+x/HBHaSi7w==
X-Google-Smtp-Source: AGHT+IG6slvUXaUw0vRKI8A9me0rjK09WsK8zsiKRNl9I6idacUaF6C041HykWyYM6oWpHYw96xUNw==
X-Received: by 2002:a05:600c:b86:b0:410:87e5:42da with SMTP id fl6-20020a05600c0b8600b0041087e542damr20895wmb.2.1707842806913;
        Tue, 13 Feb 2024 08:46:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWhWvrxvC7bBlOC2fdVAat9ianVn3v5ImA51f/ekh2Bn+WN6B+PRgMutn59Rh/G5n3wTsJ5N4htSPrmBzmmAbFz7eyO91qB/xLy9rcUWz8DHzWHN8VLO7V/+ydIILmXKrcSLvUHccEs+Z8BJdWUHbYm6KWQS3AZWvzuGCNo1UcQudJpAwLZny/dlVCWPIPxUsFQfyktpplDMmcA6OvQeozfvuRsm8tITPhGEH44YbUMRCctToqftPG30SjW7urn95FS0hlu8UnE/7uYHPbrIVYSsDzALRRkbh8uEfKkl6+JDfI/+0/j8zoNI9fxoHAAJj5cTJ7eT6k39+fsjqKRvR0hYubmkWBHXgU4GLrJLW4hIOM+sGUzIRMdBUomtsW8X4q7jS99vGKdFUjcVUKOAqTtwIrhy6vhc1cqqFT9AB/n6/gt1aIGHBtlFv8rQJPkTrahN1pDsuBrvgKewcS0H04/FkjAN2LlRrumoqSHllKsTHg+7RgEtA==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id m41-20020a05600c3b2900b00411d0b58056sm886307wms.5.2024.02.13.08.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 08:46:46 -0800 (PST)
Date: Tue, 13 Feb 2024 16:46:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 03/17] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Message-ID: <Zcuc8g-G4dCxieUl@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuMx0w6MDWpkLne@google.com>
 <20240213161601.GB1088888@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213161601.GB1088888@nvidia.com>

On Tue, Feb 13, 2024 at 12:16:01PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2024 at 03:37:43PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Feb 06, 2024 at 11:12:40AM -0400, Jason Gunthorpe wrote:
> > > Logically arm_smmu_init_strtab() is the function that allocates and
> > > populates the stream table with the initial value of the STEs. After this
> > > function returns the stream table should be fully ready.
> > > 
> > > arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
> > > any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> > > ensures there is no disruption to the identity mapping during boot.
> > > 
> > > Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
> > > already executes immediately after arm_smmu_init_strtab().
> > > 
> > > No functional change intended.
> > 
> > I think arm_smmu_init_strtab is quite low level to abstract FW configuration in it.
> > For example in KVM[1] we'd re-use a big part of this driver and rely on similar
> > low-level functions. But no strong opinion.
> 
> I'm happy to drop this patch, if no strong opinion I will leave it
> 
> > [1] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/
> 
> I saw this but I didn't try to figure out too much what it is
> doing.. It looks like a new iommu driver that re-uses alot of the
> datastructures of SMMU but has a different HW facing API based on
> hypercalls?

Yes, this is an implementation for the SMMUv3 driver in EL2 in KVM that is needed
for DMA isolation for Protected KVM(pKVM) as the host is untrusted in this case and
can attack the hypervisor through DMA.

This is similar to the kernel driver but with a bunch of tricks such as page table
allocation, power management and more.

Also we have some plans to extend it to KVM guests, (Initially I was considering
KVM-VFIO device but now with the new iommufd stuff, it might fit in there)

> It seems interesting, but my knee jerk reaction would be that a new
> iommu driver proposal needs to implement the new iommu core APIs, not
> the old stuff. IMHO, when this progresses past a RFC it needs to come
> as a proper submission of just the iommu driver, in the normal way.
> 
> I also wonder about the wisdom of sharing so much code. Code sharing
> is not unconditionally good if it doesn't have a robust abstraction..
>

The idea is that as the hardware is common and most of the dt binding also,
we shouldn’t really reinvent the wheel, so this series moves the common code
for the page-table library to be shared with EL1/EL2 and for HW/FW probe and
init to be shared between the kernel drivers and adds a lot of the infrastructure
for IOMMUs in the hypervisor.

Thanks,
Mostafa

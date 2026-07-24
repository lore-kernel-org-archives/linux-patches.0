Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B8377A90
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784921456; cv=none; b=CSvyfNhOX4icAwEI236H/v6cmfQtl9Sxkx0aIWzbPV7MntM8iHQ/cVl7dNjsYO2QpTcwXDbSbGhOnpvxwk+VyeqCiDXBzANyw1KCXzVFzThO289kaPa29UTLFpD6cKZQSUdJqeVi9/CF0IYqSlkqm/EO35mDi2d+QB81UDY3QcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784921456; c=relaxed/simple;
	bh=yq0tR9Yube9b7CYNkxubagoJauADeRUs64fe+jfXpS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvLZmB4jTlr+wcAGGzHln3G8oHazQKKrCF3GK/ldUTy4iLvDwNOhLZ7J5MD69jLE8K/g2cv95dQlUt24x6xNTHYHMwXyiOOrpNF0FA4LvHOXgIp7xYygrwa/LLb3T8uyoQdzLwJZe+sLH7mEy2QYgIRdzkhR+IRUYH8WbvLIaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNcbmLSP; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNcbmLSP"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954bb689dfso425e9.1
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784921445; x=1785526245; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qMYgbX2E5STWJ3B50MJvZqK+f3UjOUURTR7CU8KzNb4=;
        b=VNcbmLSPF8yptmIxGETvSmIzjXF/TgpXr0wkeBniLvX0qAvcO2BaBIcSsGcAWS/jmO
         xhHwue4ca4v9EpYyGyqq9u+xX23Hh1EvkLz/5nTvO0dcRBqpyyGHmolhBhjqH1/qrNos
         bdIK2jau4rIoPe9ivo9VkGzL0NrKD+fp8Gb0wCnGgJ0iZAhky4IefnYJ2JM3OSUs4UOH
         c/3KgqyAqByavoWDI2ks6BZ8/AEx/nloulPgt02QRVSsVvulP3L6nqP2zAGzSNmpu1Le
         h8QrFiRvj8ZlfLvH+WKJ0Mgue8a5UO2dYjIQ/aU6RkyZGoMR6Inmwu0gYW+MJ2N95iqv
         EfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784921445; x=1785526245;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qMYgbX2E5STWJ3B50MJvZqK+f3UjOUURTR7CU8KzNb4=;
        b=WLBTYXjQaJkixRSuNbnmrpDOhv0Tg3e8puoIuBX48l46QrptfPoYmAkgneRBmZZ0dm
         DBcHQorSwK9xlX+BwSw/cbzwOMbSTfZqwX5lwhaQFwCQMLvtaKfsw5fxWrntAoCLX3eV
         1xZ19bRcPXoKNCqDzdL9x3H7Sw1AKGgISv84gKLdu8RBsZj6AaiPN2YwUrKwx3bNGZQo
         yM+QmMQpkCiE0eElPLzLSqfdN74jUNkbQj1EnN4pzUziES4M0HG+yQkqSrJqs1QcKUUp
         eLhltS89EAngKUZvWPz7wcn1qB6lYFwzE0PrBVp9yVCor3XOMCPiBnEpxxQF1ncjMXAi
         2OFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpvV5mhgY6xAciRawJPYyNhaGMj3K6/PKoGxaknjjUOgoBYf0BxXdDUW77QMVcK8rbM/NRrTFY8@lists.linux.dev
X-Gm-Message-State: AOJu0YxkL0IcaJsDgdW7hl+f8GZhIH7iiAkVlQP7ydFFqnXlzkdL3Ade
	UTXpxfs7x7KlxPZ1Jtgq2LY3cDtnng7VuUeF6Ie5MuCSz/byRMlbA33oRiJ8PASy6T5b0LoIIPo
	eLiMBhw==
X-Gm-Gg: AR+sD13H+txDbTQS5P9/XY/DeTLWfL3wrJCCiDwU8vJ8YJpGKQAX/S4hxOEtX6t4cnI
	Legw1TPO7915DNjcg9aMhawNmU4/AdVrkj8iJvF5LbuH2hR/pahgAfRJ73PNHoW8jItPxQAdyuT
	IXmRLWpHsJxgVfnOXD7ln/Xh3twUYOtryu8NoyNvK9P61iRi1k95M1hPdkJRNHX2vXoOiurqVwV
	zWLSrFf1SP7aT9PztxZSvpcR/Va5At/nmWMci1kPuJaP/djZvYT7+A6cBNAVVUoEtZveEARhRAk
	dgn4j5tqi7N8yNWKDk/40mfkHzb74KTx6Y0mimpZLKVuLkejjXxykUVqtwKOV3+dBtLr64upeO/
	7pvDKHf41EsTZUoYnxxy/ulMYwRpS0Nktr+fdaRYLIQmVBdbpugBvuAEt5HaeEASL7OQ0DRxTUv
	pql4rO9i9dSRgMMWeg/lp2owoauvzxJTm9P9hNOA==
X-Received: by 2002:a05:600c:8709:b0:493:be38:fa5a with SMTP id 5b1f17b1804b1-496b4d388e8mr268615e9.10.1784921444576;
        Fri, 24 Jul 2026 12:30:44 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85a2573csm25874209f8f.0.2026.07.24.12.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:30:43 -0700 (PDT)
Date: Fri, 24 Jul 2026 19:30:39 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 6/7] iommu/arm-smmu-v3: Use the generic iommu page table
Message-ID: <amO9X2vBl3_jIttb@google.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <6-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:29:12PM -0300, Jason Gunthorpe wrote:
> Switch to use the iommupt provided page table. This is fairly
> straightforward now since the page table construction and hwinfo are very
> similar to io-pgtable-arm.
> 
> The struct pt_iommu_armv8_hw_info is a direct replacement for 'tcr' and I
> have a kunit compare test validating that the fields have identical values
> for identical configurations.
> 
> Quirks are replaced by features
>  IO_PGTABLE_QUIRK_ARM_HD -> PT_FEAT_ARMV8_DBM
>  IO_PGTABLE_QUIRK_ARM_S2FWB -> PT_FEAT_ARMV8_S2FWB
> 
> SMMU features are mapped to iommupt features:
>  ARM_SMMU_FEAT_COHERENCY -> PT_FEAT_DMA_INCOHERENT
>  ARM_SMMU_FEAT_VAX -> PT_FEAT_ARMV8_LVA
>  ARM_SMMU_FEAT_S2FWB -> PT_FEAT_ARMV8_S2FWB
> 
> Remove the iommu_flush_ops entirely, iommupt only uses gathers for
> invalidation. Wire the tlbi directly to the gather.
> 
> Remove the trampoline for map/unmap/iova/read_and_clear_dirt. iommupt
> directly provides the domain ops. Domain initialization is largely moved
> into iommupt common code.
> 
> Change the kunit to fully create a page table to generate the tcr bits for
> testing.
> 
> Compared to io-pgtable-arm iommupt has a number of key differences:
>  - CONT support, including always using RIL to avoid errata 3673557
>  - Unmap yields a single gather which generates a single tlbi operation
>     * free_list is always used to free after invalidate
>     * walk cache and leaf invalidation are combined for non-RIL cases
>       instead of being duplicated
>     * non-RIL cut over to all-invalidate covers walk invalidation now too,
>       umap -> single gather -> single all invalidate.
>     * RIL flushes the walk cache and leafs together with a good TTL hint.
>     * RIL always generates one command from any gather.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/Kconfig                     |   4 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  45 +--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 256 ++++++------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  11 +-
>  4 files changed, 110 insertions(+), 206 deletions(-)
> 

[...]

> -
>  static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
>  {
>  	u32 features = (ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY);
> @@ -2831,7 +2785,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
>  	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>  		return arm_smmu_master_canwbs(master);
>  	case IOMMU_CAP_NOEXEC:
> -	case IOMMU_CAP_DEFERRED_FLUSH:

Why this is removed? That would drop support for FQ domains.

Thanks,
Mostafa

>  		return true;
>  	case IOMMU_CAP_DIRTY_TRACKING:
>  		return arm_smmu_dbm_capable(master->smmu);

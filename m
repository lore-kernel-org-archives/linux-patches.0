Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6683FF1C7
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783427119; cv=none; b=rMRKx0/7SctL66tai8iCdMJ2B9kHLL1vFcfDQs85rMde2RoM5v8AdNlTyggiYIH26hgl2eYppwxGa8c8zYqpDgKAGZgHo7ss5+V9xbxc1lKeKnNphduaMaLWJNdUmTJDRrD+LnLpAJCx3ZYPRUlpxu+uElxgtdAUitVOrVnkp1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783427119; c=relaxed/simple;
	bh=bkS05jk3WJCL6+WtPkaVFwjew5+GA6ULhsFQoHwLjp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br8WQJHbKd14A9h4MfHcckm3simtL0sVmLDkjnP1xSZLUA5uDcQOs3LVMlyqXkqtXAt9VlUConqj1hJU9e1mjGnNynhPImTHGoTlbwZEdBOah19fumwrcgYzDcwvAyXY8XTb2ViE08J43BXccV6NgyqNdCgOmLAzYO3i2L6SRac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WtJCn4gK; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WtJCn4gK"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so36805e9.0
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 05:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783427117; x=1784031917; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BNIu1nT9O5TEzBCIb6SZPpMwQbKBprZzCJQi10hmSNQ=;
        b=WtJCn4gKYNbsAfH3duNjcM2wz1c71NNl3WZWSasuFomsCGbrljfUSdU9d5pP4RlSSG
         ddLzmcWeQQwXNryR97/8R7TpR45FE+Eru9Mf85nE3WySVM9TG36cljEryPWyVH5rhBRy
         v9PfoJ0ALYSSb4symscHCGK6+wQbtrmkpv1oMnCzpySfJDAGSEOJJleEZur7E5FWmQnU
         aqbLEn13UJ0Sxn9klo3PtpTP9FOSn6NTZSulmtP+cPBuvylfZObv7g8kSLlY/zEO80El
         xEZ/xj42IYpLGfbHaJVxt9KMPBBfWls6yPFHRcICHlFK52DQ4UtnxRtfgBdsf6R9xFOV
         +IWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783427117; x=1784031917;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BNIu1nT9O5TEzBCIb6SZPpMwQbKBprZzCJQi10hmSNQ=;
        b=hF3BhtNUe+GdWOwPsTdzyttinudGPiyNqpAeNSVqeqqHpVcImIjjVCy1kdqFg4rJR8
         RpdijQdSgqNoa26PFdlKRIGg8TFmkmu52PVNMY0jhyEe3K2K6epsu0IgJhk03tNYTz4f
         hf0BAcs5H99OE3oykE0+UFK+Jt2rqdyuY5GdJ9DAfTIelqXQcCb4sOh7XPSi3qlXANkf
         3flZOBsF/XCH+dAidpQcJ6nZDZElaQwSIvBGoxd3zIvCHCfeSTRMijAOJXxNNDlgYIT0
         uHZsLk+LjuQTxWD/Ikj4ACoCGJDbPkrC3QJ+FUMU+hYBdvfuLuVe4f7d0wb8bjZWG1XS
         jt8A==
X-Forwarded-Encrypted: i=1; AHgh+Rqbl4pkqjBYoaHhdt6DoBMQ8wf7t30UvYJQgHsQF5Gow62QbqM3fXj82SIgleZh6HEwcLxqZ3lf@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo4zNNQ+3NINlzicsNca7+w7216UgJ5F/1OOOa5KOZ+tA7gjOe
	impJR2vTEfJNFyAsXy/Tp6J49pMW3Ok6wGHmP4WGnN8Y7TQmc8hfcKz1jw88dbTX7A==
X-Gm-Gg: AfdE7cnPhScSlYswWpF8eXQBXZcexfyCRkt2R9CWaC/gcbSYj+dkQIJcFYPKBDkPmLg
	mAzMMTfpKPxu2Cit44pBNM7N2z9tpRSva3/dyzPCmehOemg3vrjJpv4/+cFzyhU/6SeBwHuqtpY
	cC86SbktIGX8A3GrXv772oCI2fGOYzzVWEVogL9zndoPS8P0j1IyxHgXk2IyycBgBAPw5vlu1Y5
	WbrgDQnrtZYPqzq2qPfK/TdL8N/kYnaP/rDnn5/LoGTeNfRT3mCEtVj5+ZW84IvpwPwrGcZEO1B
	NnIjjeBUfeXury6YYBYxYKV628FsqXLdffBLLOovSWriveJO8CWCYKxaunHbM2RxMMjnFhT4Zpr
	am7y3z8MAkQPwmD4kPZ4B5jSiqgAJPynjLutY8USvdRSq2NwNwPgzvJpLMDRje9+4w7plGa8En1
	eH3kAmRiHZDGLWg6tBYK80lVWXyOo4XcEc6yN4Bqo8P2UvMuRs7LF0pG/qzcI=
X-Received: by 2002:a05:600c:1c0d:b0:492:203f:a378 with SMTP id 5b1f17b1804b1-493e121b8cdmr1231235e9.8.1783427116023;
        Tue, 07 Jul 2026 05:25:16 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f3677asm48472185e9.4.2026.07.07.05.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:25:14 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:25:08 +0000
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
Subject: Re: [PATCH v2 0/8] Organize the SMMUv3 invalidation flow so iommupt
 can use it
Message-ID: <akzwJFpHTsgMrOYI@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:37PM -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table, the precursor patches have been merged now:
> 1) Organize the SMMUv3 invalidation flow so iommupt can use it
> 2) Use the generic iommu page table for SMMUv3
> 
> The whole branch is here:
>    https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> ]
> 
> iommupt has a design that focuses on building a single iommu_iotlb_gather
> for arbitary batches of map/unmap operations. The gather uses the free
> list and it captures invalidations of tables, leaves and supports mixed
> levels.
> 
> The introduction of PT_FEAT_DETAILED_GATHER provides some additional
> information that is useful for ARM: the damage bitmaps for the table and
> level changes.
> 
> Prior to switching SMMUv3 over to use iommupt prepare for this by
> reworking the internal invalidation to work on the same data format that
> iommupt will produce. Bridge the invalidations generated by io-pgtable
> into the new format. The conversion is simple enough, io-pgtable generates
> invalidation operations that have only a single set bit in
> table_levels_bitmap/leaf_levels_bitmap, so we can convert the io-pgtable
> provided size into the proper level leaf or table bit.
> 
> When iommupt uses this mechanism it will fill in full bitmaps reflecting
> the union of all invalidations contained in the gather, and this series
> provides an implementation that can work this way.
> 
> Like the other drivers the general algorithm focuses on trying to issue a
> single command per gather or at most 512 single invalidations. If that
> isn't possible then it falls back to full invalidation. Since table and
> leaf invalidation are combined together there is no waste of invaliding
> tables prior to performing a full invalidation.
> 
> On its own this provides value as the invalidation has a number of
> rough spots:
> 
>  - Non-leaf invalidation actually expands into a TLBI for every
>    translation granule because the inner logic doesn't special case the
>    walk vs leaf condition. Now that a table_levels_bitmap is used to
>    describe the walk invalidation it properly generates a RIL with optimal
>    TTL or only one single invalidation.
> 
>  - RIL doesn't calculate perfect hints for SVA because the SVA rules are
>    different from the io-pgtable-arm rules that the RIL algorithm works
>    with. SVA can now express the combined leaf and table invalidation that
>    the MM callback represents and get the right TTL, with an optimization
>    for the common 4k only scenario.
> 
>  - RIL didn't generate a single invalidation like VT-d and AMD do,
>    instead it tries to generate an exact coverage with many
>    smaller invalidations. Switch it to match the other drivers single
>    range approach for performance and consistency. Since ARM has a much
>    more flexible range definition the over invalidation is far smaller
>    than other systems.
> 
> The approach is to introduce a new struct arm_smmu_tlbi which
> describes the invalidation, pre-compute into the tlbi the single and
> range commands from the start/last and bitmaps, and then apply the
> correct pre-computed command to each of items in the invalidation
> list.
> 
> The RIL and single calculations are revised to use the new bitmaps
> and accurately generate TTL/stride/etc.
> 
> Some of this design is to support another series to remove the batch on
> the stack. Now that we have the invalidation list and the tlbi it is
> simple to just expand the invs list directly into commands instead of
> using the temporary on-stack batch array. Eventually removing batch will
> save ~1k of stack usage here.
> 
> v2:
>  - Rebase to v7.2-rc1
> v1: https://lore.kernel.org/all/0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com/
> 
> Jason Gunthorpe (8):
>   iommu/arm-smmu-v3: Pass the parameters for the invalidation in a
>     struct
>   iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
>   iommu/arm-smmu-v3: Optimize range invalidation for latency
>   iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
>   iommu/arm-smmu-v3: Precompute the invalidation commands
>   iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
>   iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
>   iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE

I quickly went through the series, and left few comments.
As discussed before regarding the TLB invalidation logic sharing
with pKVM [1], I still think after these changes both drivers can
share some logic on the level arm_smmu_tlbi_calc_range() (+ tweaks).
I am planning to post my series by this week, I will keep it based
on upstream and I can rework my series later if this one gets merged
first.

Thanks,
Mostafa

[1] https://lore.kernel.org/all/20260501111928.259252-5-smostafa@google.com/

> 
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  32 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  30 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 439 ++++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  54 ++-
>  4 files changed, 382 insertions(+), 173 deletions(-)
> 
> 
> base-commit: 4c73a6222c248384513c4f465e547df80b280a06
> -- 
> 2.43.0
> 

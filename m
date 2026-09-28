Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620294AA035
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595315; cv=none; b=BCySaf1SB9AeW4T9/tUukjtnPCOXTkPGktASA0T6xUTjfkXn8W91go2QpT6hF/PGg1RGUbVVllHwmiiAHY0DZjn7w6GMRX6+YnMkvRqDkyUUTp7bLpX0OqRQxUJWq0P16npwdIq+9iM4UpVVZUUQn0Cho6W7l4PaL8DBRWwnsxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595315; c=relaxed/simple;
	bh=Sgb/qwXpmQngxdKfzdWp2Tw8ZOcFCpzKxu2JQCTmjco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOw/ZWtC7yq7LdrqAWeOqDY/e3v+kpCQLlv+wyQmtH6dQvM8p1xkNRSSdgUAGCauMpt+vXUTzYJkLyH1htmzcNmjP336GwCTfcD5BwsrSfT3QaQvSlcURUmd2iZGpa6CMjFk8A7WSO5q3v+nRxM5Y6biFFHklN1kTEo+6zmS6hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IY57Zrgm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IY57Zrgm"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d8facae850so80195ad.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 04:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790595313; x=1791200113; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AHgrG2jneIj+c6tmDkqbazBsM333la4Thr0x2hp0ezw=;
        b=IY57ZrgmixLghAatJtn2IjVz4MyHkhCePPYvCww9TlL8sl31DMMQ6ZggOKfz7C7mS3
         Xmzk9n38S74jWXkUzSBePTg2esNkThSxg5JYAt99pI7arsqsgWFUTCTecW2lJCFzMfJ5
         5v1a10Fs9SXW4WcZAA8aHW80xBTqKdZiVR3RaVRl3Q3JQgELRjYv1UmXD9kaR1RCSYaj
         xd6IFBB3W3yXoPIbPXP82fg6v+8d9Rk14h4227qKmYo8YB5DioVYVifkew3SlGuLXVyr
         EnWx/JMvm4TRYpOLsiFkL7MHqdO1fFaGvFgOdaWdBhW8ZAKO5EQz6s6tOPRz0pBmYwKW
         zGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790595313; x=1791200113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AHgrG2jneIj+c6tmDkqbazBsM333la4Thr0x2hp0ezw=;
        b=suLHf5zUCljrcKfcaf/kTsTTv54nzU9iLU9CrwOi8YwxUT27t3rDjmPWCvU9pVEZSR
         jzNWYGxCjdqc4JDsPho83xfinkxFs2kTKznYCiVzTU0mH2X/KgmjIGhoL4fqOXuZsuOr
         FzoQLqOP+etWezFfbWBnpa9AoTF2f+zBtDQ7MScU5beGmT5gPr3DEc8nTXNaE5032tlg
         sBtVsb4oph3ARlEnRil3I6YeClpiPBFo5tsVmQoycoO3kN27n7dxjCHSXzT3BSnrlop8
         4mmRlm0JXNjQSpuckZn2WfAvtlMnC/JQCjCH0WYiSJb2bQlgXOG2mFh1/nFBpScgPND3
         u+Lw==
X-Forwarded-Encrypted: i=1; AKwUvBwcH+hQvWvIfuxlSWsJoNb/5AwiUU99/b6OPpvDQu/eWBiXqJklcmH4a1S3zU6cUHHvS7iid0XK@lists.linux.dev
X-Gm-Message-State: AFq9FYIR7IkX/DCZfsuAz48l3KM09Iz4/7Sgg1JaL+JH6OphBtv//lWt
	AhaK2xIDoD4XP/QTbJFJ7oA4N83ITATfrjaBflGgECXtQdTbkNkZEVlfFRcXvB9EuA==
X-Gm-Gg: AYBFou2yX1ye3AYWfcMl3OsjTg8baub5X1ulVAgyi8n8ms+vB6vCQqrIiI2ARnbRBUc
	b/X/kqE9cDu9h4SHXgyKnUhjCQH9UC1rhE+TCZVMscu7MTKjE4ToV5PevH9AJBBmaUzu0tZheeo
	qYFJRF42plFzNByB35pm3MgkbWwdEyoZ+kL8CcQBZoD22fWroqOWJYnq/uCpCCDwVix6e8Ky0jz
	Y8LBSi2oGnkQUgTM6QA0evOpapRZTZdX/ssdcfBPcV7db+RAbV1U3r19b9dQJeg2W+gEwBEKPjB
	4kMOnh2L9gNDXc1dWJbcxGFkU8/PaycjME17O5tgUTeQzSi+eO6x9bJl4TE6K9x0MgTqFhcgGin
	srN+C8HmM3eGxkGU2aCDf9iP/lag6vxoL54C3QQZqVCaHDi3EXW8oaAo7HCRQBIM0mG7dSJDH6U
	lbpO+OrCfVOqK2W5o/u0At2Bk1AgeiJDJBtmJjcGpFTtaCTeizW21dsvYfJ207kIrJZ1TgtE3pP
	EmpAP+25nllMUwma8p2Yd+il7bYUAlpb+NG
X-Received: by 2002:a17:902:e892:b0:2c7:9e6a:1a8d with SMTP id d9443c01a7336-2dfa62274fcmr6365335ad.12.1790595312887;
        Mon, 28 Sep 2026 04:35:12 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913dbc34sm39183265ad.13.2026.09.28.04.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:35:12 -0700 (PDT)
Date: Mon, 28 Sep 2026 11:35:04 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <arpQ6KINJE4velBl@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <1-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:09PM -0300, Jason Gunthorpe wrote:
> The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> invalidation of a CONT PTE grouping in the SMMU. The recommended work
> around is to use a range invalidation that spans the entire CONT. The only
> user of CONT in the kernel right now is through SVA sharing a CPU page
> table that contains a CONT created by the mm.
> 
> Previously it was thought that this errata was dealt with because the
> driver always uses range invalidation. However, there is a subtle detail
> in the errata that the invalidation range must fully enclose the entire
> CONT for it to work.
> 
> It seems that two sequential range invalidations, with a split point
> falling inside a CONT grouping, will not prevent the errata.
> 
> The SMMU's range invalidation generation algorithm does not produce a
> single invalidation for a single SVA invalidation request, nor does the mm
> carefully align the SVA invalidation ranges to accommodate the splitting
> of the invalidation into several ranges.
> 
> Thus, when processing a SVA invalidation, the range invalidation splitting
> routine can generate a range invalidation that is split in the middle of
> the CONT and risk under invalidation from this errata. This condition
> could be triggered by a malicious userspace manipulating the TLB gathers
> via mmap/mprotect/munmap.
> 
> Update the errata list to the include the S3 variation, detect the IOMMUs
> that have it, and then have SVA invalidations use a simplified version of
> the over invalidation algorithm from the tlbi rework series. This ensures
> that a single range invalidation is issued for a single MMU notifier
> callback and now the range invalidation is guarenteed to cover any posible
> CONT.
> 
> Future work to add CONT to iommu_domain page tables should either use this
> one-invalidate/one-range invalidation algorithm or disable CONT support in
> the iommu_domain.
> 
> Cc: stable@vger.kernel.org
> Cc: Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
> Fixes: 3f1ce8e85ee0 ("iommu/arm-smmu-v3: Share process page tables")
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/arch/arm64/silicon-errata.rst   |  3 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  7 ++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 91 +++++++++++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +
>  4 files changed, 88 insertions(+), 18 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <peaan@google.com>

Thanks,
Praan

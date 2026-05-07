Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC863C1995
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145978; cv=none; b=gir1nJJe1scueiOBaqOmszhN1PCWsn9634oQhDWbcV+v1XhKUJox+VOBm8jiUAmb80YDkRXi96btGnLhs8Il2Wi8xBerR2gxyi5JnqB9nvaI1Ff6LabyFkO+6jloTXDKHUK7DjQJuSWf+xSfex0pPumvwUoo6eJUTV+ukek+UIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145978; c=relaxed/simple;
	bh=vYJLKQq99o9j2d0X8mxUuCgo33Tys51drYCrIkMtYFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8kNBABlQx/aSQOzzRzFmvIKfO+ImL7mhhzxiy47936fUcrZ5q1/uY6ZTXK4Jif++l/paVXHHr2YxblGwyvErHe6B/+vTUpE5JUtVM58P1AB+Cq8pHKH5vStJO8cH28x07m4SlaDPtCKtoEQp+MOhfAPaTAMqnax7+QYJNEgVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RS7yVBww; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RS7yVBww"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so68495e9.1
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145975; x=1778750775; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlD/sZLAbq1YNiDypmu5ohGMtt+/3desZPPRaicZ4+Q=;
        b=RS7yVBwwe+fOy5URY6ZB3LdtMnyyShSjXWH2517sEkX0unYMWqm+De47nn64ozcKv+
         aVxwctTAfG6BbbY09N1OgEYYfdTPSZZR6h9fV2Az8MRYJenCVyDSZJ5S6YFWrqNaj5VE
         Q8yVDEcoNDhAZrJn4uUWWBhUqn7HAKlbEfchOVexZ5X7epyiUxTbnNaRwlIUZY++ngcR
         KKXq/ryMMmaqsJZWOHeT1b7KzE0oSZpKdUHdZ/YTFP+E7UDx7TXd9l+b4vUQ36UNISrG
         nD2Lzh1sg1vDO6zKxDyOqdG0CkYnxCV68CgWnTLtoN3i8xxA3xBARIpbOOSi4lfGs936
         CXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145975; x=1778750775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IlD/sZLAbq1YNiDypmu5ohGMtt+/3desZPPRaicZ4+Q=;
        b=Gaok2zqEFYk7hwN777qZtZ7/6lYuOZ6vp14xj5AxW4BcJDJV139L3BtUuMwfikyskN
         vVUAU3/YFnkt+Z6Me5nlV3mHbHxRRa/b0Kmrya4cWi/fVfG624w78eJP5FINTZh6sgdF
         AJrhjLvooCkCPLbXqVdSSgBZ6a1SEq/dcMGMbuaw0tVzdZy+L8+7quW8yg9QJgQ8aSif
         1KW+lVkoz6IUDyYvwadQOy4ebePuBqiPhavwixMJFattBhDxOjo3Wg4Xc7ECttTYWz6Y
         TWuwIEUDuQggiFAFooCInHyejo5rokF0BDPcO28icfxtIQqYhVxRHPBO/HWcYNE3C/ER
         S1SA==
X-Forwarded-Encrypted: i=1; AFNElJ+/0XLi6dw53GGN9e1X/34hp9EjnzfDUlUDScixCRZ8BTnezkmmIHOd/NNjdPvFNLciRS741ty2@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgftq5UZVLALGPn5vvXcMK8gffkGG0HaaALCmlAVGL9+JQB/eB
	WsLKXwwGmOY56lQ78lpNBJ5JCw5cNhfK5oI/MRAx3AD2dZXRqnA5KkizteMfhRIEdg==
X-Gm-Gg: AeBDievq2nR2KocwFGkK9oKew8YC3b3qRsmhz4WtK3YIq9V3sKE0gGab2PulF6/NgSk
	+DaseXt+qoAcxWXtoZsPrW2GDRBuCHUPfg9iui3ymwn544ky7kx10oRLRwz09GllmS/c2asxOHS
	CAFPmJVaQjEk21RGBg/4Qui012Er5rztNXYspHuQ2Fsgtt8QhTm0HtCyt/FaBBxaFrfOCumJIl1
	e1RW/wRv820K6z+Y4u3JMROwb8u9olPxZLHgDxoH1IbUnWYUowMzxB8ST/boSjDfTaKo51QJVnx
	qrj0VItaR/V/fnoAr9eEsOAIzGw6KToJcq8e/u3/FgMPZJZ63+c3c7xd/lh8yAXH+Idj/rhb/M+
	RhEFQdIEdjc51jMOoXSPc+l9GDiKBiZ7dpruJOA8ldRN9SNZroQIPsT4yV6y3MJtht4pLsynkWH
	o0SmD15HikwojSynbVM6HPPFSyp/73uCQuYqX1jozo4T20ITJbYSvQxj9uiFGg7nDlFtSr6OVRv
	gG2xmWLchgdnZF8
X-Received: by 2002:a05:600c:3b88:b0:489:1adc:f017 with SMTP id 5b1f17b1804b1-48e52ef5224mr3387525e9.5.1778145975038;
        Thu, 07 May 2026 02:26:15 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53907a00sm99399225e9.12.2026.05.07.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:26:14 -0700 (PDT)
Date: Thu, 7 May 2026 09:26:10 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 0/9] Remove SMMUv3 struct arm_smmu_cmdq_ent
Message-ID: <afxasmHvZVl1iQgz@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:09AM -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table:
> 1) Introduction of new gather items and RISCV usage
>   https://patch.msgid.link/r/0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com
> 2) Remove SMMUv3 struct arm_smmu_cmdq_ent
> 3) Organize the SMMUv3 invalidation flow so iommupt can use it
> 4) Use the generic iommu page table for SMMUv3
> 
> The whole branch is here:
>    https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> ]
> 
> The invalidation logic has this multi-step process where it first
> writes the command into a 32 byte struct arm_smmu_cmdq_ent, then it
> calls a function which converts it into a 16 byte HW struct, and
> sometimes it then edits the HW struct a little bit before passing it
> off to the batch or submission functions.
> 
> Instead just generate the HW struct directly by moving the FIELD_PREP
> blocks out of the big case statement and into helper functions. Call the
> right function in all the places that were building arm_smmu_cmdq_ent.
> 
> Add a type for the CMDQ entry similar to the STE/CD types that wraps the
> two u64s for clarity and use it everywhere.
> 
> This is intended to have no functional change. It makes the following
> patches work better and removes a bunch of LOC. I've run several AI tools
> with instruction to look for functional changes, which did find one subtle
> mistake in PRI response.
> 
> The removal of arm_smmu_cmdq_build_cmd() also achieves what Mostafa is
> doing in the pkvm series by making the command formation entirely header
> based with the arm_smmu_make_cmd_*() mini inlines.

I was able to rebase my pKVM series on top of this and it works fine with
just the helpers in the headers, so splitting of the build command is not
needed anymore for pKVM.

I also did test the whole series with just the upstream kernel on my
Lenovo setup.

Tested-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> This series has no dependencies. Several people have already tested this
> on various ARM systems along with the full iommupt conversion.
> 
> Jason Gunthorpe (9):
>   iommu/arm-smmu-v3: Add struct arm_smmu_cmd to represent the HW format
>     command
>   iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq selection functions
>   iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq submission
>     functions
>   iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds to struct
>     arm_smmu_cmd
>   iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from
>     arm_smmu_cmdq_build_cmd()
>   iommu/arm-smmu-v3: Directly encode simple commands
>   iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
>   iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
>   iommu/arm-smmu-v3: Directly encode TLBI commands
> 
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  24 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 475 +++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 248 +++++----
>  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  16 +-
>  4 files changed, 350 insertions(+), 413 deletions(-)
> 
> 
> base-commit: 1338d1bd1ea27bfe2cd1c4494547d409016a6644
> -- 
> 2.43.0
> 

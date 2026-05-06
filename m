Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA23D2F12B3
	for <patches@lists.linux.dev>; Wed,  6 May 2026 23:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778110877; cv=none; b=CUHk7t5PNpQ9H9YpXEs9o2eho+zcdev7FaAWEPEGU3TTtM+bQ8G7nBQIeHmKhJPKYNgxDJIzAo41N4ldxC2qaQNnyzzHGqRK0WdN+239+lgFYqfinLWVBamXPYKSKKVERbFdeIo+DtcAego34J0q1UGAKb3qp8i+bS6KDmM/YPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778110877; c=relaxed/simple;
	bh=o0Srmy8jgIvvOfgyisrTtf/fJrmdBVr4h8Ys4jXIB1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQ3jopIygEbjeUnORoNZeMvDvqYyhWrnt9JC372RQ+epi46JaXsOXKW43ar2f92syZJ84mpw8Saa33pOzXE0yNagbnvnciLIJ0b2qlp7MRKCXizjFif7ZTPnLNoWvG0SKbRGYNxlrjxsbWwxAC32+9jqpn3fjgvLhr50b3PhP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hPFQ0fqY; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hPFQ0fqY"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ba180a022dso24325ad.1
        for <patches@lists.linux.dev>; Wed, 06 May 2026 16:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778110876; x=1778715676; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o0Srmy8jgIvvOfgyisrTtf/fJrmdBVr4h8Ys4jXIB1k=;
        b=hPFQ0fqYsby1yyCiJ/ZLLYYlVDwOo80bOoC7ssfQNs3PLpq+UnsppLgwu3BUV1A2B0
         KbWaxUL5W2pwfFF7tzUu0jvpSYTvJJho38XNQ5znSKiMqq/NKjJrA8DkVG1YB2t5xQOu
         wFUvGNtL/AYYzmhV3t+bRhX/cAnZjrdsYDeiPcyzt050Xy2x1F52P2r5gtFqoHWmh4hh
         aLlo78fUScAsrdIgl2wtth48spQ1XtZL16Cs5OBuIeRGp4cNuVGPMKb9DbI1UR7RBSa5
         bqJr8tJfXoOVsoIBJx3WzprDswNGVDaqIn1NBqmEa70ShnhzyhYClLvnFjqC9EqZvard
         0ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778110876; x=1778715676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0Srmy8jgIvvOfgyisrTtf/fJrmdBVr4h8Ys4jXIB1k=;
        b=Y94+XIC1WNskIin1OFaEc8GesNN5n/EDRiv+pKKXSyYViP0odzKSCPgtWeTuhPeZri
         4J4UwDoInam4vbyhEPb38JKaAcx/IGPg7Xes2sdy/q32/6fGSQo/3p/h5mEthsHYLOsO
         +npdfXId2pbxypobqvPhJdgiyySUlnA53zVqPxDIHKT1zSMKLPvfQLytxEwKe3XxO7Cr
         zhltAC5Wd+GhF/r+i5m9YV0/w82J2R3giAWHniAsj/lDEMlY15eUkjDQAS/LyUhkrvT9
         t8pGM5fYciOn8Lc41+NA1PEZm/U5i4oTNh/dFlWtAFvho9G0k4V7Gbf0mlZI2d2VOGVK
         nNYg==
X-Forwarded-Encrypted: i=1; AFNElJ9MR4ixFPdp5bzpMyPPO3aGopPftj6ejSUfdQPE6kIRa28yLMKj9inHmDohcwyhlrAvWv5BX4Jq@lists.linux.dev
X-Gm-Message-State: AOJu0YxTxPQVyjZDSMMPj3+z1eIIe7d0DLllXndbc4ak1TsUBGnJM8q/
	NAdQZOMZYmgSwB5Pabbosm4xIcvNHDUPD5PvX+MIkeZaAARF2GPHrGZQYkHMY/qaDg==
X-Gm-Gg: AeBDiesPKZIb56sE5m6NrLFom2Ga+gRa7/dlClslmWsuwCz/iVGGlax0Y+7n3lly/jt
	XXByEiD0vTP2txStW52Ix4T3s9BgB5E+JBKxpXnZ5xSJGEGSgbIEAb6c5bZbZsx5B8Eds82kcD0
	yzMqAlI4Y8hMjrMg5ZfCabemg4Ec/9NpmsQiN/V27ksjwO3e0XPBQ2u1LpV2qmkAoa8F1lEBsFA
	ScHwm4J4YaDaWpvJ19YZt95uUK6yzl8wCX4ioshnA3guqIrCl8kJAhUOFscbVZmJQB8/JBBxD77
	D0Juxa8mmif+9928KeuGRBzwubySetZIrtOPHIVTrXLaCIlhIuuy0vVCX7/RZu2NCIHEnKvP8n1
	Xerk0CARaoGuOjs5taGfgbHfE9ptsgBc6nQzappA8xBthV1D8p8523GSK5JhX79sBoKpxxqwtRS
	/0F+9N5pqg/uCH5WUsRHiUvlcAJ3cS5pmpejm8ixGzPOIo7a4s4iR+gEhbSrNoSn6jUhhFGSKOC
	dF69+y4
X-Received: by 2002:a17:902:d414:b0:2b4:60e6:44bc with SMTP id d9443c01a7336-2bab641edaemr956085ad.13.1778110875628;
        Wed, 06 May 2026 16:41:15 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b08cc8c9sm1629410a91.6.2026.05.06.16.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 16:41:15 -0700 (PDT)
Date: Wed, 6 May 2026 23:41:11 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org, 
	linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to
 represent the HW format command
Message-ID: <afvRefDGTuqNsfGM@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:10AM -0300, Jason Gunthorpe wrote:
>Like STE/CD, add a wrapper struct around the u64 array to represent the
>already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
>because the command submission path will have the swap to le64.
>
>This makes the API clearer when a u64 is referring to a formatted
>command and makes the following changes easier to follow.
>
>Move the command constants out of the struct and into an enum alongside
>the rest of the constants defining the HW format so the entire HW format
>is self contained and independent of struct arm_smmu_cmdq_ent.
>
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 48 ++++++++++++---------
> 1 file changed, 28 insertions(+), 20 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

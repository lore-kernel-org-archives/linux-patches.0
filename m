Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049D51EFFB7
	for <patches@lists.linux.dev>; Fri,  8 May 2026 20:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778272519; cv=none; b=Ql2ZsVFM/DvsYLmeRlzGQ0o9TasKSxU3IVkCKrC6i+br+rtHRQxZ+XPYF01dsy5kSOHG7ZYH9GdVgl7aCNzmUhJoPbvDchp7MOOeutGjHbIMtSdp7Y/P+4Wsyy2OUTXgVASYJ6oFk/au6F3rWcw9izSe2fLPVkA9Yhfjsgdctx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778272519; c=relaxed/simple;
	bh=/RXh760jgpmBXWYza11o+sjayeAl1AGvqWbQvG3+uvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcTGf21D9Ob9ynGMCzJmXVkVz/qIhGF/UiTsK9Sf32X2QR0mZ3pQJv0IEjxAoEQrAgU8jiOEbjF9w+QgITnXtJP78PTfCihOoUwOMpUMDbv1YYmv4JdVHSbGwi779Ulzcq47LjnRVmMh+YyzPcPOvR8kNZGeyCCsxhvHYBQLjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oG17tuWf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oG17tuWf"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba180a022dso1315ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 13:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778272517; x=1778877317; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/SXlitbk32WOyBlu30f95rRaQhj+JA3b3XmJB516F7k=;
        b=oG17tuWfYsxwiY489+TIweoPnQpb9KQcuVaY6NGJE8yJZeg/P7xul16vR6VqS07wjH
         OolhszmXXiRAfCKsIi5DCFP/DZ9qx/JWdTcMuECXU8cIY7Ga7rz1QHxuPmDqlWboyvch
         0bxU0ioLdx1niAHt/WrNfGbIcvB02H41d3SD9ra/9L0YFXWnM7xugolTnleN4RJcUe4s
         FTCIZrzRSo5u89k4/Xv/ikEIAxbxhGZK08X+iz+A1ePaQEAnqYHv6a7mO7baFOULkqi2
         R2WcUmkr+Vt7Ief3rs9PRPjNNfgufKQeiM0ilHEkX3t7qm+qJn7t/5kKJ7KYbrezNwu4
         o6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778272517; x=1778877317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/SXlitbk32WOyBlu30f95rRaQhj+JA3b3XmJB516F7k=;
        b=ryjkWlkmzmjvTH9zkzcxJeaTcoQGRSSpmNktibS/6jal6WTHgfP5kkBfrQLhxZZ99E
         sd1hQGkfTP76Qk7Vfff7dYb3MlSURi0Zcckt2dH0rWwGSQz0mb47ulHn72bTQauDUH0D
         JVM9kC8Dg+JUKcNxZZ0DFx4FKYmOY1Q9gE5qkGZ8Ur7ormiqBsYKg2TSGBWl5Jv8I5Ee
         +hSt6a3bKSMDgq1Yn6adhpAr/fFWBptCai4T3+8SdVgvSpqdKST8GtNd99pij96SUocv
         YdNkLFiJaic/ng8SAtsFCIDQLzgsVMhu1sWud5d1+Z/DDANYENwVVPGr8McaiAFh84Op
         ksCg==
X-Forwarded-Encrypted: i=1; AFNElJ+vfxjtvhBswCBd+w8QMAPmpRVh2qoUslKYNiLiyP9QBbh1aWZ4aqgYbFVG1ADsu2Hst1ObI2cU@lists.linux.dev
X-Gm-Message-State: AOJu0YwiWyHMWZmqZnR+He7MhIFMjbhEfpnOPIzhJVqh9tPNsosbVgT5
	wwP5BflMl1/pyb0uR9vJZWFT4P5IADE8z2PeW/hckZNTrJbL5FaW78kYg9V5YfOP/w==
X-Gm-Gg: Acq92OFj/6v9A0+0bDfqg+Yt48syoOYWjogVFdw8xkobu5fU0lFCIz/1BCgbLZDLIGa
	jgym7K31GTmJb1VydotJWTpuihc97jiV7qXQA8NWroxjBpcuquj0fsstvKerlqBbbanZRMxmayV
	K3QD/uKcdwRjdegNUqqh3ldGVu1EsT/U+6+n9glGpVHj0Bq0vbyjc7udFw/WcikpBdoepxLOY4+
	9X+xyOoHC6TO+DkW9hXZW91aehNGdSz2kcsQPeC1dVn+JxNjQ8KumAVK/Fb0kLZTyGv4d5+gesi
	vUgZ33MNRQmd1eGU3mukN28pCXvbxDB+qGgKi6nrptFA56ARzj1cohLIQ8HzsLapXFhElFny3yC
	4j95D19pHfw6XlI28JuBaSxtiOlrF/CHJhBCDou7dyqSnWnLRHgMCIjBsbxTvJT1GuW9I5Cczes
	ZfwJAatPPA4Ns36qOElPZGNLhzV7YU6Z7Dhqalbswc+qfyPqDPdytbtcFkIbap4nCqUJ63
X-Received: by 2002:a17:903:3884:b0:2ba:30f:33e0 with SMTP id d9443c01a7336-2bc747f25cbmr741565ad.20.1778272516852;
        Fri, 08 May 2026 13:35:16 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367c1f48517sm689352a91.10.2026.05.08.13.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 13:35:16 -0700 (PDT)
Date: Fri, 8 May 2026 20:35:09 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 3/8] iommupt: Add PT_FEAT_DETAILED_GATHER
Message-ID: <af5I_Xps4Ma-qUDx@google.com>
References: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
 <3-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>

On Fri, May 08, 2026 at 11:53:02AM -0300, Jason Gunthorpe wrote:
> Generating the ARM SMMUv3 and RISC-V invalidation commands optimally
> requires some additional details from iommupt:
> 
> - leaf_levels_bitmap is used to compute the ARM Range Invalidation
>   Table Top Level hint
> 
> - leaf_levels_bitmap is also used to compute the stride when
>   generating single invalidations to invalidate once per leaf
> 
> - table_levels_bitmap also computes the ARM TTL for future cases when
>   there are no leaves
> 
> Put these under a feature since only two drivers need to calculate
> them.
> 
> This is also useful for the coming kunit iotlb invalidation test to
> know more about what invalidation is happening.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

The conditional gathering via PT_FEAT_DETAILED_GATHER looks nice.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

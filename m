Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63DA244E8C
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 12:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741783549; cv=none; b=QntCtxRb2naCJ3h7j44Pyn2zkCO5qKpZxXW7OTFseOSbVLKpNTW3vfsmuUaYE7RMHoPWBO5BgBjSklPZKWeis9bn/BHUNVE/YCg69eFtcUmuhoirjVSbTjFeidR0a8HnQDbwqjaZteBlT8F8SlzNNtmnAsA0b7GQfMHRbJgrPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741783549; c=relaxed/simple;
	bh=w7qxWcK6Y+lr9flaT5izlqxkohZLAMbvmvIVsbTBCwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovsHC2MnKci86rqyD2HgFqPVCsyzqbCMiRp/pIrCSRIYci458U5DwrrM2ENxX9fimdVVAOwym+vPbYkothzWa47wedPONvJCbSsiwuziCr5Vq7A0QYnnYP940Ry4ZuvVvButxpPvC7TBPww11cfjhgvGV8byHcsdfqszkEppCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sQ0KLx9a; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sQ0KLx9a"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-438d9c391fcso44105e9.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 05:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741783545; x=1742388345; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7nXrf8enrrb8z3uABVuZMTlrSLNofRDk6iKufuqXac=;
        b=sQ0KLx9axjSqYZ21A7AsgAa2NRLb5oRlWbylx4wUq+RYI9jE4anYSuxuc1BAQmWdT5
         glGBtD78kJHgEEJUUIHAxZr7EOFQ6GZr1dpz1fjyI+LdeiSWtgMJa1iPJ664tkiBxaJW
         G5pmdzW2/WpV+Y2fNXM3jZJAD4Q7Dp8jChwlIRc2VF0sbayTObo8Pzx/OfYY+Cx7ZNRC
         7iVwVHB3cwT7rd4wPnfJgqEBw1rIY32xuF7New1n/3FzlsONW6LLam2QG0YA651gS5MP
         8Rpo9UgNkERh1uqRXb8myY/ZvOrCvCGEvOvkGOtORB+nBSwUxJEFouqZ60LRCNwrJFgu
         6qtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741783545; x=1742388345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7nXrf8enrrb8z3uABVuZMTlrSLNofRDk6iKufuqXac=;
        b=WO3gRGrSVkBZJBilUb7Cu7I4zZIw4WkOJ8y4zoZKmql29RQHP1a2zjKknNeVjMLttv
         W9NQcjGus5ZceodYTo5tCpjtE/I2zijwOPkkG/3p/cOlLCQwqKcpDkcrYi0i3iTBmwxU
         zqP2dGdN6Xy82XeZjiAZdMgxTQb/D8NzKT77RaG3rRD2gpqNMT1jwdm5dLam3v6Ix2u+
         XyLBgxwpSQqkcaEBRX2ebxW9DX+xalyskO5EsPSe39J0op3GnTfAJNOCWPaHu16807tV
         DisWzlFUVRh3qVNZ8plN47C1MBjwdgdXl8jAFaA30jFzqp+XZ6a2lRhFN5wxW5Zv+Jak
         TDTA==
X-Forwarded-Encrypted: i=1; AJvYcCWmaT8E/J2ix+8GF36rFtkXpnhv+pjYOVVJm246LV5KK3dFsMehOpt68zDDZrZe7c3TjlvWT6Ah@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfv2DClgr+MfxYdrua15DoBgGugzlhIahDDTwF3109l584c0Ow
	L5w+UY1VBJ0wJNAin6X3s1giL1CFm6PbqvKMLwQM/jk3pesfRqWBzSc7BpRP3A==
X-Gm-Gg: ASbGnctLQEWWWAvWoiO0PhZhDTnCkN9Pa2alA0abncGjhzKXph3HkFG5T9BggLKzoEP
	F+2c6X9cq4WFyZbnpJGLmSMevh0OwGgTqroNNluUfp0ur8LGHT+vjezAFTqTbaVNUUgLiJldW/V
	ZUIFmlF5VKm1rKyI6MrYuRbRGfeFD75Mzs4IP4iyNzF50EmtJfjNKGa1yuA3jIcjatvFlQjmPku
	HnWfYbbIR8MssUs2ugxFVJF2uhkEmbtbSnAZP2lBhWusBf4gGh36ZPBWI2JdolEhYqJKeM18tdk
	Yxx0C+EEuKlrKQ5weP47SUwWE/tulbh6N7eMr06hRuTbSiYzq3CLoS0990P2oYzHIZ8FTwCRnct
	1JmlUjrjbF8iKCbU=
X-Google-Smtp-Source: AGHT+IGl6ij5XGs/qN6P6iUkVVrm0h4AAzKswiqP0QsBVlB9onr8dRHcRoIgJqJfm8N1ML/DsO9qAQ==
X-Received: by 2002:a05:600c:5801:b0:43b:bfe9:8b43 with SMTP id 5b1f17b1804b1-43d09ea3748mr1245205e9.4.1741783544916;
        Wed, 12 Mar 2025 05:45:44 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a8c5d0fsm20697625e9.32.2025.03.12.05.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 05:45:44 -0700 (PDT)
Date: Wed, 12 Mar 2025 12:45:39 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 15/23] iommu/pages: Move the __GFP_HIGHMEM checks into
 the common code
Message-ID: <Z9GB8_j_8a4xCTsT@google.com>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <15-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>

On Tue, Feb 25, 2025 at 03:39:32PM -0400, Jason Gunthorpe wrote:
> The entire allocator API is built around using the kernel virtual address,
> it is illegal to pass GFP_HIGHMEM in as a GFP flag. Block it in the common
> code. Remove the duplicated checks from drivers.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/io-pgtable-arm.c  | 2 --
>  drivers/iommu/io-pgtable-dart.c | 1 -
>  drivers/iommu/iommu-pages.c     | 4 ++++
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 62df2528d020b2..08d0f62abe8a09 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -267,8 +267,6 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
>  	dma_addr_t dma;
>  	void *pages;
>  
> -	VM_BUG_ON((gfp & __GFP_HIGHMEM));
> -
>  	if (cfg->alloc)
>  		pages = cfg->alloc(cookie, size, gfp);
>  	else
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index 7efcaea0bd5c86..ebf330e67bfa30 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -111,7 +111,6 @@ static void *__dart_alloc_pages(size_t size, gfp_t gfp)
>  {
>  	int order = get_order(size);
>  
> -	VM_BUG_ON((gfp & __GFP_HIGHMEM));
>  	return iommu_alloc_pages(gfp, order);
>  }
>  
> diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
> index 3077df642adb1f..a7eed09420a231 100644
> --- a/drivers/iommu/iommu-pages.c
> +++ b/drivers/iommu/iommu-pages.c
> @@ -37,6 +37,10 @@ void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
>  	const unsigned long pgcnt = 1UL << order;
>  	struct folio *folio;
>  
> +	/* This uses page_address() on the memory. */
> +	if (WARN_ON(gfp & __GFP_HIGHMEM))
> +		return NULL;
> +
>  	/*
>  	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
>  	 * alloc_pages_node() did.
> -- 
> 2.43.0
> 

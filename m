Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F90735F170
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784921213; cv=none; b=D2e0IYDYTyoctStc9JjhrVkH+XYrW3gHjU80zYMxSz3rxpvCjye+jnjcMDp4vmyoAEaFM/qGIyrlLurMsNTRdj+rsvrXUWGrUfU1mJd4P01efZORdh9P/oeanoQcs5AutRRieuiDQ/sWD/edo+iBLW5DOkdqAlWeWsIUjyZZvrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784921213; c=relaxed/simple;
	bh=vkRogr9oggjEuTRViiJhIfUW2mACYKv/qWblc7p7oc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0dJCq9JXSrsET9h9U/mxdQul17N138uB77k2+8q8jIZ6KD8aa+agRrWAdcgx09hRQCUpL4kRW6YnuwsVNQNM1IKJ+o8H46Y2zWbz/duXkxmFGWUXTutLAn77M9YXyRK8yDbX5S+dzvdHKi3p35lUzMummRzrpL3xM2IKyVUxgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KepfJfeI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KepfJfeI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954d5d814fso11465e9.0
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784921210; x=1785526010; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k8xIqxOa0Y2SU3wgjx14WiXI07z60EtLxeh3n9UetUk=;
        b=KepfJfeIttwzwBLUyUluIH2ORBIfUEgkjzglwr8s1I3TKe5ILm9iSRDZqWGuzmleVq
         FS8a1lfRwVnA6QZV81s0uIEPBHgVTibQgJezdhFr7Aj5mpopj4gfocSaX0Fo4eIY+4qu
         hAiLygQm5ZjuQ7jYdm4BqgL9aVCf1hZDcQ9UwtbZybDDQik/3OBngxkNzxnAnCUR2iXu
         gUfuv1vL3dNUiaD+YtIyW70VP/AxDqVwPd/L/QAgOAQyRjjFfaqgY5Ue8OpxpABbxlOU
         foyR8nN5TjmWrL774dTvcw9gpA1YCrn/7NdNeu4bIxsxsAs9Yd5vzUw/XbFNYTNofZWC
         rfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784921210; x=1785526010;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8xIqxOa0Y2SU3wgjx14WiXI07z60EtLxeh3n9UetUk=;
        b=pBoN+if/pjnn4evbv3SrXvcar4Dv9ZNBaKGD/7Tg8YT6PotAYTn8MagzIYJ5gBaIQq
         ff5q5O1ayH1TaAiGbPHkHdVsFT5XPThtVG6LHDAxcql5s/9t90NLE76ET6jJuzcW0RzQ
         omM8h0LKoCSvfOdNDPC5/GS6h06D9HkCa4pVQOl7Kxu4TgtgDKe8tCmnI4XENuEv5FuS
         5YWB63zx2IP5D297htMckOhc27sgOdeXpzK9J+yhqkasVY7tI/D8B50NIFB96UAFprmy
         d3/go1lRnnIYilaqM2ZHBbPcjmEQHUm5ftZBIb3eqUjsB090CgsYETRZpeJvMvZZ6bd3
         Rllw==
X-Forwarded-Encrypted: i=1; AHgh+RoL502CFACcjlVcleMxAgERm/+vzvBXNZwCp4ZKZAQ1UCHd+NY7Jr5++wG0i1I0sob3FuMNBev8@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0wcTUrgiiJxfTqaJBMvQlVodQKYcBl8o5lQAq2QdaCsmEgsri
	aoEeRkV67P3hfR51SzkNbM8pbGbNyb7yc/X0yQj0U2kz98VjImRlTOXOBpF5JX6nQQ==
X-Gm-Gg: AR+sD12X5SidqrJ+bipRRxiHNLnySQMJQ2/Gso5nlruU3dutKJFJ4z+FQ2tGSJooQqV
	OJu43IScxyhWAPw/yHkFzG/uU/OfZ5qmnZLnXdWxioQuSa5IRgapj70rC35hKvzuUkein7Yu8c4
	dAfewCxQ+tGWc4aeKRhxy3yQ1TlpjE1u4vxAm67ZzT7XfcR1TI/sieR4bXAFUPw3PGaLmPzkh9C
	r1ExpSFMqaHvLTMjXfF2uKYSrZAvLi/Jd7J99hXpLddnSHYasG38YSPD5HVYTqlOvonYg+u4oBO
	+dupRtENCoj8UXqY21D3jIvlbGXR7qNNml4lEuPnw/EtfGNlcVrPHS7ZjLfHZtzSX479tg4klnF
	gJoJiuKqFUmwS3Brt422h6FQIgmZxJByOM81NIZ8wuQkFOo5Mott2gtkYHNnKRdMDdaCu0rMqv1
	hbh2APY+y8SdaVZgi1LMs/Cz9JgtT3d7rWOfupuw==
X-Received: by 2002:a05:600c:656:b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-496b4cf18e5mr153555e9.4.1784921210084;
        Fri, 24 Jul 2026 12:26:50 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb5a46sm25674153f8f.9.2026.07.24.12.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:26:49 -0700 (PDT)
Date: Fri, 24 Jul 2026 19:26:45 +0000
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
Subject: Re: [PATCH 5/7] iommu/arm-smmu-v3: Move the DMA API comment to
 flush_iotlb_all
Message-ID: <amO8dYdZ5RNJ-7ye@google.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <5-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:29:11PM -0300, Jason Gunthorpe wrote:
> arm_smmu_tlb_inv_context() is the wrong flush_all for this comment,
> it is only called during io-pgtable destruction not during the dma-iommu
> operation. Move it to arm_smmu_flush_iotlb_all() which is the flush
> that is triggered by the dma-iommu lazy flush thread.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 +++++++++++----------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 5087603ea18e62..dd22c0f881bfba 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2392,21 +2392,6 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = cookie;
>  
> -	/*
> -	 * If the DMA API is running in non-strict mode then another CPU could
> -	 * have changed the page table and not invoked any flush op. Instead the
> -	 * other CPU will do an atomic_read() and this CPU will have done an
> -	 * atomic_write(). That handshake is enough to acquire the page table
> -	 * writes from the other CPU.
> -	 *
> -	 * All command execution has a dma_wmb() to release all the in-memory
> -	 * structures written by this CPU, that barrier must also release the
> -	 * writes acquired from all the other CPUs too.
> -	 *
> -	 * There are other barriers and atomics on this path, but the above is
> -	 * the essential mechanism for ensuring that HW sees the page table
> -	 * writes from another CPU before it executes the IOTLB invalidation.
> -	 */
>  	arm_smmu_domain_inv(smmu_domain);
>  }
>  
> @@ -4078,6 +4063,22 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  
> +	/*
> +	 * If the DMA API is running in non-strict mode then another CPU could
> +	 * have changed the page table and not invoked any flush op. Instead the
> +	 * other CPU will do an atomic_read() and this CPU will have done an
> +	 * atomic_write(). That handshake is enough to acquire the page table
> +	 * writes from the other CPU.
> +	 *
> +	 * All command execution has a dma_wmb() to release all the in-memory
> +	 * structures written by this CPU, that barrier must also release the
> +	 * writes acquired from all the other CPUs too.
> +	 *
> +	 * There are other barriers and atomics on this path, but the above is
> +	 * the essential mechanism for ensuring that HW sees the page table
> +	 * writes from another CPU before it executes the IOTLB invalidation.
> +	 */
> +
>  	if (smmu_domain->smmu)
>  		arm_smmu_tlb_inv_context(smmu_domain);
>  }
> -- 
> 2.43.0
> 

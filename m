Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E73FADED
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 11:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424753; cv=none; b=CRQq2+O+pNps3r0YTaVjFGgFvmgO3T8BWIAtatSIIATJfgbsh+iQfQucMM6Hay2qTqooJQ5rMpMiyOLvVBhBDZcidNFUS+MUO/nogsseGF+J0jL+vKgN4h4CSrUSHkLLhy4lA9lyvTBQZvYE73lOfwWf9Nv0AzEoOWIghY68yBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424753; c=relaxed/simple;
	bh=U1zRZA757u+fv0JMlGa/t+wuWzMlXcCu0ncHTr55sz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQ9YT03ajZnSuaUjmOyYVHA2ZcdbrzdevAZdxNTyYZ7gpFVlkrmVgh1Dman9KTjQsiB1pWbw04kDd1PIT65CO9TlQ+0Od6oR99r1g71ksOTSwrttp3dMAAG2vv4CrKqli6vy/CkKQcCtRHDenVhh2QzrHrc23wxULQLoBds1qN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GFVcfa1h; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GFVcfa1h"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so34635e9.0
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 04:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783424749; x=1784029549; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eT2u2uECc/JyT//Y0MUNfLJ3f6c5Vk9vkYH8un7LuaA=;
        b=GFVcfa1h3BOrHrZ4QarE61CWfSzLfgVLrzSafGhdQ+4pM+nXrTmPJLsBRP8uK9YVqo
         7KKrLEx4l5U+yli78veiynR/MCTToRTQlHYaeXj6wd28eaWJwBACSz2eaOMUv+lDyp3v
         5VzW1inMGsPn4i8tgR3/MIDKAIgSs34IRlL2ul4c6j6Gb992/DkH0XbNee5cJ9FQ3Myt
         cDenbh7jIl2+V8UkmB/fjojw3F/qv3bkA8NjADJy4DsMDsedKLEfU6PpITvtoZTD63Tr
         A32KNouKQ2FZOfZOgKv+TmroPveprr5Ou8DUhAumMR3T9QIjZNzXHgWO37c/QyYjHHql
         SFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783424749; x=1784029549;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eT2u2uECc/JyT//Y0MUNfLJ3f6c5Vk9vkYH8un7LuaA=;
        b=Cmv7c0vJsfopQGm8Brz9qEcSf+l9dC2KZlDemXjHIK8ZwjofKyF2Ioh6mDALMdkOs/
         109IGxMcTZK6L59B/YWA/+7t2p2Zyb5ggxcmGC49WZ/4rPKksxuCysm/H82YPBAjMgRH
         qVs9uz7vmYytG7dFcjpVJ2MRp7LU0tTOBhA033g/zfYeGkKsxLIl7R8oq5YpE1dsnhx6
         0o/3C3AAtEWorCtTvySkDStVx9j7gwTeNmOB8eTOrZc+vzNxIHgzcS9g8ghB5nbzapNP
         90Ow5f2+HmfJknXT7VARQ5cgrkaOkb2vFenrtHm4pEW7tbYvToHo2dWWA65XV2NmkKuz
         Wb4g==
X-Forwarded-Encrypted: i=1; AHgh+Rp0cnNvTIWLFNxIBVaav1OfhMXDsqMw1M9/Omj2yG3dtC0kWsoHgrSmTX86PWhcBQXg3UeCHfJE@lists.linux.dev
X-Gm-Message-State: AOJu0YwqlnUAYyTbSY5I+blSCsi0vxIKzkvVCI/GblaDQ/EstD5UhJFs
	LcWN8iju2Y5DhgDJ7r1jFuV/jz3GxlNF9XeZkZO8n6ny3yNpJiqtSWxq0Hk879vVaw==
X-Gm-Gg: AfdE7cnB2fNNJYWwUsqdpMZ3F+5iyyBH5PBJ3m3y6tpOXjyNpTHPPeUBTs6GjF0phCd
	P7OreBD2FGx1cgX4mwVGVhYEyMhaxcA4rVv0tI+UakZ+NexhdWk+5/lCxMbsKOLzFjoeutK3a71
	orTPoUnHBvGAbdpHi00aiZ4Ug+vrhLUVI0lXd0wFUev4MXIz3M4QJdLORXcgPmeIaVXjTVdARLd
	kaTWfbGaEJ5jg9qVkSUs2flQ/P+IGkyS7EwIL+0vmF9dmHQRfGGdsC4PxZqL7RmndjQcvA/8w1t
	ogzxl/MWVKyWe5xatmIAlGtmj+UqP6oNX1eakNTbUzMPtWoVPbBaZeOJxMJZQFdyI96LMNKCFf1
	dJMdafIMeNty8F7j6IZn/mr8MuUjNiWSaFsHp585poF7+vfr1qcfQ9ra0/M2/YuO4J+8hxqew1b
	WNTl4g4i7DXYJPug6zSx7dQUqhVtekLvyu/czqqLEXMPnUlTi+
X-Received: by 2002:a05:600d:8654:20b0:48a:623c:8859 with SMTP id 5b1f17b1804b1-493e15301b5mr647595e9.7.1783424749113;
        Tue, 07 Jul 2026 04:45:49 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e01c9faesm37268395e9.1.2026.07.07.04.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:45:47 -0700 (PDT)
Date: Tue, 7 Jul 2026 11:45:40 +0000
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
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <akzm5BoV0rToJ7ij@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:40PM -0300, Jason Gunthorpe wrote:
> The server IOMMU drivers focus on invalidation latency by default,
> over-invalidating if necessary, to round the invalidation range up to a
> single command. I think this represents a trade off for DMA non-FQ and SVA
> where stalling the operation is overall worse than re-loading the IOTLB.
> 
> For instance AMD and VT-d both round the range up to the largest aligned
> power of two and invalidate that. This causes over-invalidation but that
> is preferred on real HW over trying to issue a number of smaller
> range invalidations.
> 
> Only if a para-virtualizating hypervisor is detected do they switch to
> using more accurate invalidation. This also triggers using
> iommu_iotlb_gather_is_disjoint() (ie PT_FEAT_FLUSH_RANGE_NO_GAPS) to
> remove over invalidation from the gather. A pvIOMMU has a hypervisor that
> will walk the IOPTEs and resync them. Over invalidation, especially
> significant over invalidation, can incur a big latency cost reloading alot
> of page table. x86 IOMMUs have aligned range restrictions so there are
> some pretty nasty corner cases that can trigger huge over invalidation.
> 
> Currently SMMUv3 doesn't support detecting a hypervisor, and it
> unconditionally runs in a NO_GAPS mode. This makes some sense for the
> single invalidation flow where there is little reason to push single
> commands across a gap.
> 
> When we get to RIL hardware, this doesn't look so good. On real HW the
> best option is the same as x86: issue a single RIL per gather and optimize
> for latency. SMMUv3 has a significant advantage as its RIL does not have
> alignment limitations so it's single-command over-invalidation is capped
> at < 1/32 of the gather's size, making it much more suitable for a
> pvIOMMU.
> 
> However even with RIL SMMUv3 still uses NO_GAPS and it breaks down the
> gather into several exactly sized RILs to avoid any over-invalidation,
> costing latency on real HW.
> 
> When the HW has RIL support follow the x86 approach in SMMUv3 and
> calculate a single RIL per gather that will cover the required
> invalidation.
> 
> Calculate the smallest SCALE such that NUM can cover the range to minimize
> over-invalidation. Always use a RIL command if RIL is possible working
> around the spec limitations to form a valid one. If RIL is not possible
> then do full invalidation.
> 

That may be beneficial for servers, but I am not sure about other use
cases, we already know that the invalidated entries are unmapped
and not used. However, over invalidating might impact live DMA which
would be bad for workloads sensitive to translation latency (as
embedded cameras, displays for example). Maybe this can be configured
instead (via cmdline)

> At least one invalidation errata is avoided by 'always use RIL'.
>

Can you please clarify what that means?

> Since the normal path is now the only one with a loop, split them into two
> functions and fold a simplified version of arm_smmu_inv_size_too_big()
> directly into the normal flow in a way that directly limits the number of
> single invalidation commands generated, again focusing on controlling
> latency.
> 
> The end result is any gather is converted into either:
>  - One invalidate all
>  - One range invalidate op
>  - At most 512 single invalidation ops
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 257 ++++++++++++--------
>  1 file changed, 153 insertions(+), 104 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d22012466e3965..1ad642e09eb92d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2395,124 +2395,166 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  	arm_smmu_domain_inv(smmu_domain);
>  }
>  
[...]
> +	scale = fls64((num_tg - 1) / 32);
> +	if (scale > 31) {
> +		/*
> +		 * Range too large for a single command, use full invalidation.
> +		 */
> +		return false;
> +	}
> +
> +	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
> +	if (tg_lg2 == 14 && ttl == 1)
> +		ttl = 0;
> +
> +	/* Verify address alignment for the TTL hint */
> +	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
> +		ttl = 0;
> +
> +	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
> +				    cur_tg << tg_lg2,
> +				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
> +				    scale, ttl, tg_enc);
> +	return true;
>  }
>  
> -/* Used by non INV_TYPE_ATS* invalidations */
> -static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
> +/*
> + * One TLBI command per IOTLB entry, assuming the entries are all at least
> + * iopte_granule sized. Returns false if too many commands would be needed which
> + * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
> + * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
> + */
> +static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
> +					   struct arm_smmu_cmdq_batch *cmds,
> +					   struct arm_smmu_cmd *cmd,
> +					   struct arm_smmu_tlbi *tlbi)
> +{
> +	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
> +	unsigned long iova = tlbi->iova;
> +	unsigned long i;
> +
> +	if (!num_ops || num_ops > 512)

Is there a reason that was added instead of keeping the old formula?

Thanks,
Mostafa

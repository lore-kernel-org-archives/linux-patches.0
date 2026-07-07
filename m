Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED53F44D0
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423113; cv=none; b=qAHOhBClTM1V/2KtEJEuuzNTBrpSc0N83YsAohjDNJia9TLTC9gjT0OjJeM+m5UO861Oe7z0dZv2TAl2pUZDvfjMry3ky1IGfR+AH9w/blS8AtHKeBjXmvTEySVlqbH8zG6hXBts42aGE29/GX6N0eqzaqnJOEue0fbpDtssD/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423113; c=relaxed/simple;
	bh=UWi0gG9gvWB26Oz4ForF3pNb2bVahsSQn8sEmpML4A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlKriyfPSUd2kusj2Y03fcEN0/JRDapTH3BXSeWKsI5KW5pc1XWquy38LOh8ek0PJ2aWkHW95Z9EKURmIkTuU9wUQZag4T1HiucVgAqGvPV2cPG/juYJUyGGQUmkD1nrwc63EXzW1+tAGeGQX9+pjhHbxoKhA9TlYxnTVh6SqDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eSkdivcH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSkdivcH"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso27485e9.1
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 04:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783423110; x=1784027910; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w6IJ44fHla9q8jik3/kgaIVLbHkWW80AbYg/MgWLN94=;
        b=eSkdivcHQiGiydEH8TTYiloh1ehC8aDGQYGK/x+KnXixm1QA4A2QmTL3MKRZ586BBl
         yIra7HrrKMJG2mXlqTcTWNq1MwkGh1Fu0P9tsI/zMnzl9aw4OHt6s6SbfQW7BM70+arv
         0ZqVj/wJ7hwnYgbTqPGMTR1Oq9CHdRc93Wx/FaH6uDtT5qdPxGjLjmh7GzPLKYEqz1Lw
         MnRbqgxFB20irESIrDCu60IvQW/PcfV0fwkkYYB9+Bf0i99VlJ3IrnpA+qeOvnigLS8u
         lGTqRlWK/fDkbaNNZ8QfiGzZbvDMuc0Dwoj/m3SeVUMPuvUBqHZ0JGbN1pRJSLKNn3p+
         VYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783423110; x=1784027910;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w6IJ44fHla9q8jik3/kgaIVLbHkWW80AbYg/MgWLN94=;
        b=lWzTr98t5utscs/VHYl1dfkHjidqFYkAbq0FLyRA6jvsqirjThCdhNvrxaBly/2YR2
         oX1008/r/TvxphO31F8STG8DTRehB1MEpQdqtgxNauqy2Jhzox8u+RiXKujfk1Yaj5ul
         6BFh/R/9hxubKOiyLiTlQMlnEoiA21+bw2OC2c2r9T2D8mSbPvgqj3AeesSb9ksUglXT
         aQQfgEu9j7AWoYugyaLW55WZFL6E2F/wTqmiiraIjnfIOn8m/uhEVLxT1o8tFpDOexLK
         PliQMFAdGIC9c05u50909y21Fjj64sGF3/3OOLynekT0l3THDwnsKfcO+GT6xq6nlhJG
         tq4g==
X-Forwarded-Encrypted: i=1; AHgh+RrbJeV3Rcw8BHQo9Opi1LgdhGQxeGmBnh+UZTSlSEk9T9uE55DAWgtJ55S5sI/uL0C0WVoJV5GC@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5rpbn0pENEWf0w6hxsl61qUkk9CTNHwIBuZwRNdWC8rMxvCfC
	LIaMPZTwLrelLCF4qeIg9X42cCCXghKQ3GpdamQha6/PUp4yhxZ2cWbquNJzhprY3w==
X-Gm-Gg: AfdE7cmfOmWOPpezIb3oXr4Vo66YQnIE0JbAI+mz7s3h55sZBvhkUTTAtnmZ9mqhWgJ
	pxnWing4QKZJbWaNkcDrOW6q3s81t84NzNhjS9dYMRFf47P2/4gL7xtYVJonQryr++OExnNdXne
	xgX9jlw8qmmrZz1Sn1o1+yBUspXgFnByWyLJNVIoZxfnkuie/hnP8fQlJLxdNtCaKhE87S+Ahpj
	mqd1NNBGm2J2VCYUJZ8TTxjb9kODsO9RtCCqOLfCGnQ8zTuPf5MzPcyrAovqY94Sgfj+kEgjdwK
	FEdH6K6eDOPXS8F2aI1BZvyMf4ltm19bizjupiYUaiRc26QR086wc1yYrZzAUq1Eqlb1J0AvZr7
	e1nH1rMI1h/ayIlaSIriHOZ0QvZHrPXYFQo3TDljOgpHlBuv8dtp0sHF19lC18Go9KhVpHKjcam
	Gmaf0q3Zely9nPqwJc3yx+HdGn/saot7MbDRf5GUICmF3ajdEe8QRcULPJdZ0=
X-Received: by 2002:a05:600c:604a:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-493e14ef934mr536545e9.2.1783423109000;
        Tue, 07 Jul 2026 04:18:29 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0078d49sm52669675e9.0.2026.07.07.04.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:18:28 -0700 (PDT)
Date: Tue, 7 Jul 2026 11:18:22 +0000
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
Subject: Re: [PATCH v2 1/8] iommu/arm-smmu-v3: Pass the parameters for the
 invalidation in a struct
Message-ID: <akzgfisqFzfLGW51@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <1-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:38PM -0300, Jason Gunthorpe wrote:
> These parameters go to a lot of different functions and the next
> patches will add more. Put them into a struct to keep things tidy.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 75 +++++++++++----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++
>  2 files changed, 46 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index a10affb483a4fe..0c875771b46d2f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2298,8 +2298,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
>  	return IRQ_WAKE_THREAD;
>  }
>  
> -static struct arm_smmu_cmd
> -arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
> +static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
> +						   struct arm_smmu_tlbi *tlbi)
>  {
>  	size_t log2_span;
>  	size_t span_mask;
> @@ -2321,8 +2321,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
>  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
>  	 * ATC entries within the address range.
>  	 */
> -	page_start	= iova >> inval_grain_shift;
> -	page_end	= (iova + size - 1) >> inval_grain_shift;
> +	page_start = tlbi->iova >> inval_grain_shift;
> +	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
>  
>  	/*
>  	 * In an ATS Invalidate Request, the address must be aligned on the
> @@ -2397,20 +2397,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  
>  static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  					  struct arm_smmu_cmdq_batch *cmds,
> -					  struct arm_smmu_cmd *cmd, bool leaf,
> -					  unsigned long iova, size_t size,
> -					  size_t granule, size_t pgsize)
> +					  struct arm_smmu_cmd *cmd,
> +					  struct arm_smmu_tlbi *tlbi,
> +					  size_t pgsize)
>  {
> -	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
> +	size_t inv_range = tlbi->iopte_granule;
> +	unsigned long iova = tlbi->iova;
> +	unsigned long end = iova + tlbi->size;
> +	unsigned long num_pages = 0;
> +	unsigned int tg = pgsize;
>  	u64 orig_data0 = cmd->data[0];
> -	size_t inv_range = granule;
>  	u8 ttl = 0, tg_enc = 0;
>  
> -	if (WARN_ON_ONCE(!size))
> +	if (WARN_ON_ONCE(!tlbi->size))
>  		return;
>  
>  	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
> -		num_pages = size >> tg;
> +		num_pages = tlbi->size >> tg;
>  
>  		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
>  		tg_enc = (tg - 10) / 2;
> @@ -2423,8 +2426,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  		 * want to use a range command, so avoid the SVA corner case
>  		 * where both scale and num could be 0 as well.
>  		 */
> -		if (leaf)
> -			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
> +		if (tlbi->leaf_only)
> +			ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg - 3));
>  		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
>  			num_pages++;
>  	}
> @@ -2462,7 +2465,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  		 * command and something would be very broken if iova had them
>  		 * set.
>  		 */
> -		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
> +		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
>  			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
>  			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
>  			       (iova & ~GENMASK_U64(11, 0));
> @@ -2472,13 +2475,13 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  	}
>  }
>  
> -static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
> -				      size_t granule)
> +static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
> +				      struct arm_smmu_tlbi *tlbi)
>  {
>  	size_t max_tlbi_ops;
>  
>  	/* 0 size means invalidate all */
> -	if (!size || size == SIZE_MAX)
> +	if (!tlbi->size || tlbi->size == SIZE_MAX)
>  		return true;
>  
>  	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
> @@ -2491,19 +2494,17 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
>  	 * invalidation feature, where there can be too many per-granule TLBIs,
>  	 * resulting in a soft lockup.
>  	 */
> -	max_tlbi_ops = 1 << (ilog2(granule) - 3);
> -	return size >= max_tlbi_ops * granule;
> +	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_granule) - 3);
> +	return tlbi->size >= max_tlbi_ops * tlbi->iopte_granule;
>  }
>  
>  /* Used by non INV_TYPE_ATS* invalidations */
>  static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  				       struct arm_smmu_cmdq_batch *cmds,
>  				       struct arm_smmu_cmd *cmd,
> -				       bool leaf,
> -				       unsigned long iova, size_t size,
> -				       unsigned int granule)
> +				       struct arm_smmu_tlbi *tlbi)
>  {
> -	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
> +	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
>  		struct arm_smmu_cmd nsize_cmd = *cmd;
>  
>  		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
> @@ -2512,8 +2513,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  		return;
>  	}
>  
> -	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
> -				      iova, size, granule, inv->pgsize);
> +	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
>  }
>  
>  static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
> @@ -2532,9 +2532,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
>  	return false;
>  }
>  
> -static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
> -					unsigned long iova, size_t size,
> -					unsigned int granule, bool leaf)
> +static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
> +					struct arm_smmu_invs *invs)
>  {
>  	struct arm_smmu_cmdq_batch cmds = {};
>  	struct arm_smmu_inv *cur;
> @@ -2564,18 +2563,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
>  		case INV_TYPE_S1_ASID:
>  			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
>  						     cur->id, 0);
> -			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
> -						   iova, size, granule);
> +			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
>  			break;
>  		case INV_TYPE_S2_VMID:
>  			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
>  						     0, cur->id);
> -			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
> -						   iova, size, granule);
> +			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
>  			break;
>  		case INV_TYPE_S2_VMID_S1_CLEAR:
>  			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
> -			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
> +			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
>  				break;
>  			arm_smmu_cmdq_batch_add_cmd(
>  				smmu, &cmds,
> @@ -2586,7 +2583,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
>  			arm_smmu_cmdq_batch_add_cmd(
>  				smmu, &cmds,
>  				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
> -							iova, size));
> +							tlbi));
>  			break;
>  		case INV_TYPE_ATS_FULL:
>  			arm_smmu_cmdq_batch_add_cmd(
> @@ -2617,6 +2614,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  			       unsigned long iova, size_t size,
>  			       unsigned int granule, bool leaf)
>  {
> +	struct arm_smmu_tlbi tlbi = {
> +		.iova = iova,
> +		.size = size,
> +		.iopte_granule = granule,
> +		.leaf_only = leaf,
> +	};
>  	struct arm_smmu_invs *invs;
>  
>  	/*
> @@ -2657,10 +2660,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  		unsigned long flags;
>  
>  		read_lock_irqsave(&invs->rwlock, flags);
> -		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
> +		__arm_smmu_domain_inv_range(&tlbi, invs);
>  		read_unlock_irqrestore(&invs->rwlock, flags);
>  	} else {
> -		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
> +		__arm_smmu_domain_inv_range(&tlbi, invs);
>  	}
>  
>  	rcu_read_unlock();
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index c909c9a88538bf..a364d847c22a92 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -802,6 +802,13 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
>  	return new_invs;
>  }
>  
> +struct arm_smmu_tlbi {
> +	unsigned long iova;
> +	size_t size;
> +	unsigned int iopte_granule;
> +	bool leaf_only;
> +};
> +
>  struct arm_smmu_evtq {
>  	struct arm_smmu_queue		q;
>  	struct iopf_queue		*iopf;
> -- 
> 2.43.0
> 

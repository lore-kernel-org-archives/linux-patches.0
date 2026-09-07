Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB0483BDE
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792271; cv=none; b=KFEuEpV0ULuEw70x4uqmCb13Hd2tvt1SE16O611WjS7+CFytwohNZ0wmlxmDGIJ2lfptsssn6xqQXD6PEYnwk4JcPtJ1IeqRHbcUIBwhKk75rKmrpFqquyGW9+/bfDKFH2yqOIHrZRCqF2jYAvPpoOCSLxP6YXEfna26bgXGYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792271; c=relaxed/simple;
	bh=LuRsaqnzbPvgQXUxSbPyzsuc1LcOmnOgimGO7TVAD58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWUEy0ex5KULlLaH8FAZndLJU36l45+F2z03g5y62J0jNj0spXAryl9HgvmR/HRsp7F0ufr8DZzmWP/txOqHEvaeLhRFs4a9ZZesKVgIm6ojon/SCONumPVSH+ZXK6mFHcxM1+/pwPuKKt/dJHNpTYc6k5PkV1no1vmGalAEcUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qquF4bCN; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qquF4bCN"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cda5e048fso76395e9.0
        for <patches@lists.linux.dev>; Mon, 07 Sep 2026 07:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788792267; x=1789397067; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6LeP7MeAYKc+4gd66ZIjlck1w7e0lfL9pyApNXhT4Go=;
        b=qquF4bCN+oNQBrjKsIJlpcZ5g5Xp36uR+91uwdQUhxKHpjLrCvgDC2Es2LX0N9A4Z8
         SfGX2j3OqRxiN0UyMBz1zk2CsKMZFIa9MiE1uuyew7tBqQCwgt/AtoojfcbObaddB8WN
         Dupo03QKtLgH2R+gIUE1bw4BKgiBzavv4vNL/qjSKTKshr/f97ajqVTeO/cEkwvBw3VO
         i2Qsl12ftZOZ8G86q/nl2M/n9eCpAKp5V8E9Ck5kgprvt8U3PAwbfftGzqk/b7DcQJic
         yxhnkp344lHlHbncoS3xbvCV7/pgbA++vGAQ7N26Wu/ypXB/kV74SSZlCD4h6vVqd4pz
         C9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788792267; x=1789397067;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6LeP7MeAYKc+4gd66ZIjlck1w7e0lfL9pyApNXhT4Go=;
        b=YFwkFI0yVvZVX3I6iiraL1zpWedyM67x03PDtqatiNU1iKSzOiC37ga/XcSkLZihpm
         cZwKoeHaq/MppAKILk+E/JW/F1HjqSoVtOHPxMS50rnYC/99J0RLCrVrOakojzTAZEPz
         QJtM60s4F+Y4mlEjI3Li3yZtgUWKAqPcrXv07W4U0AiYd0Io7b0LHb2cSQWpLA/WkPf1
         mp1DhvqdvLAqKFco9/U554n4RNv4tinfKbaGgEYeZk8YvFq7kLakLRBPLc+S8CHCvTGW
         ilBSWhPRMHXwBIF+IOtcegFmlRgcakyJSEbCCy/ABNWIsZ+Fm8cjarfrGLtvKMu8Itbk
         NIsw==
X-Forwarded-Encrypted: i=1; AKwUvBzKbIa3+Qaj2apMJ+3Le8PWdcG+puh5X+MbjatWvF5FnCbFFZtYPYIbwu/MK8o5wdfUtr915w0B@lists.linux.dev
X-Gm-Message-State: AFuF++lq/iWUbi7FqouiJnnv9WGPybRXmOjeLwRO76bgLI+J2sV2KPQQ
	jbZvH98b04iEqTfUMb8dvvMlp53B6/9/lLcG0fa/45mOyfEf2xw7oTYI3wwCk8JAUg==
X-Gm-Gg: AYBFou21OJoMxd5WOogxz1rlaYxtX8ygtIcpE1bfQ2kSBkgBQQ73laOeZRw9Dox/ovl
	cAOleG6EU4iWeEkasxWDzsuYVwXiMc88eggvxnL/F+hLtOyopSq+NBPaSLwUoEk849pT5FGhpF5
	heYZbDMorvDrthb4gFFYSk7/WmpgITU+ttFyInokDWt8EgEwa+Us8OyIJKTBlKKwNhsl6IGY8m+
	GWJK186woaryyYSvDdZbtmx3w8uaP2ClW2zQqCUco14gUGKgA2oXM7zY5wSNGhHLkn1yDY5LbCb
	7LefrhY6ItFxcK3eZ38wrscWI1wzldXhJjkzEwOBRvlPbytCsS+5xz0udRvimETzeyWhZ83EdTC
	sjVeZHBesXswf6ingpK13bTC/RBEjxyXwy3ZK1eXqsekkjQ0TcvmQ12PeMgbG/uZxITHGPXvjz0
	Udn9DKAy/n0fNEeHL0M7+6ACLfOIEcyDmK2qcGbYO4eBk7YIa5uWjnjgZxLoIuTfdRLlz+ZVtLe
	tP2p312+p1bnWtb+tXQi5N2rsZUbOTdS4JqmkS3
X-Received: by 2002:a05:600c:c3cb:20b0:499:a6a5:a687 with SMTP id 5b1f17b1804b1-49d00ab6427mr1494785e9.0.1788792266833;
        Mon, 07 Sep 2026 07:44:26 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588135600sm25224381f8f.2.2026.09.07.07.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:44:25 -0700 (PDT)
Date: Mon, 7 Sep 2026 14:44:22 +0000
From: Mostafa Saleh <smostafa@google.com>
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
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 9/9] iommu/arm-smmu-v3: Support the DS expansion of
 RIL's SCALE
Message-ID: <ap7Nxijs1xq7RRs_@google.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <9-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>

On Tue, Sep 01, 2026 at 02:49:58PM -0300, Jason Gunthorpe wrote:
> If DS is supported then SCALE can go up to 39. Compute a scale max that is
> compatible for the entire invs list.

I see in some places scale is still assumed to 32 as in:
- arm_smmu_ril_init_end
- arm_smmu_tlbi_calc_range

Would those need to be updated also?

Thanks,
Mostafa

> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 ++++++++++++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b99229a5bbacca..2a159be751891e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1060,9 +1060,16 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
>  		invs->has_ats = true;
>  
>  	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
> +		unsigned int scale_max;
> +
>  		invs->has_range_inv = true;
>  		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
>  			invs->has_full_cont_ril = true;
> +
> +		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
> +		if (!invs->range_inv_scale_max ||
> +		    scale_max < invs->range_inv_scale_max)
> +			invs->range_inv_scale_max = scale_max;
>  	}
>  }
>  
> @@ -2625,7 +2632,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
>   * covered by one command.
>   */
>  static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
> -				     bool single_ril)
> +				     bool single_ril,
> +				     unsigned int scale_max)
>  {
>  	u8 tgsz_lg2 = tlbi->tgsz_lg2;
>  	unsigned int ttl = arm_smmu_compute_ttl(
> @@ -2647,7 +2655,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
>  	 * address beyond alignment to tg (so long as TTL=0).
>  	 */
>  	first.scale = fls64((num_tg - 1) / 32);
> -	if (first.scale > 31) {
> +	if (first.scale > scale_max) {
>  		/* Range too large for a single command do full invalidation */
>  		tlbi->range.use_full_inv = true;
>  		return;
> @@ -2917,7 +2925,8 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
>  			arm_smmu_tlbi_calc_range(
>  				tlbi,
>  				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
> -					invs->has_full_cont_ril);
> +					invs->has_full_cont_ril,
> +				invs->range_inv_scale_max);
>  		}
>  	}
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 6582203eb7425f..8b251a188810c9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -760,6 +760,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
>   * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
>   * @has_range_inv: flag if any entry's SMMU supports range invalidation
>   * @has_full_cont_ril: flag if any entry's SMMU requires the CONT RIL workaround
> + * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs
>   * @rcu: rcu head for kfree_rcu()
>   * @inv: flexible invalidation array
>   *
> @@ -791,6 +792,7 @@ struct arm_smmu_invs {
>  	bool has_ats;
>  	bool has_range_inv;
>  	bool has_full_cont_ril;
> +	u8 range_inv_scale_max;
>  	struct rcu_head rcu;
>  	struct arm_smmu_inv inv[] __counted_by(max_invs);
>  };
> -- 
> 2.43.0
> 

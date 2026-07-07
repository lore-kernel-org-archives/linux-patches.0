Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339473EB0EE
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 11:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423491; cv=none; b=b4irQ++t5ISrVg94TIbMoNKTI7r1LANgQqIvePkgQjQs0KBgKVUMOPdesbTG//UXj1LiSPWa9iVJ8KwQ9TxQTwKUcHLzrKm72d8B1GZEAxX0O7VW/KkanPB73Usvigatlqi9649SG/ac8JIx0Lkcy4iBTlxeCTYiY4IApYYmYe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423491; c=relaxed/simple;
	bh=DrU75j4aPdyIe1KGThKxf/CUTwPbzDvnN/ERBbMWJwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SipOrSK6ahyiv3zUne05F/OSXDS9wrOJTUUs5n+GQ0RXfLKHIDql2w1Jqc8fA64jlEVPlGiOkY8xG+A5keTB4F6pLQLamuaWmEid+FPIZM6c7jcDOO2Bwgl4Nap2Lgw01doXUb0k+EeI34Ye0mIR7P5vdcBz8UtEvnQ3cyW3T9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IIXjlpQK; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IIXjlpQK"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so33905e9.0
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 04:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783423487; x=1784028287; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VV+gJB5ebBMdY4lrxfExKBx0DMSngEYrND59Gya7WaU=;
        b=IIXjlpQKkzQv5dy1qR3B101z8dy/4zKLez8qeqKFPcjA7ul7JIDufzoiFF3hQWR+it
         5ctiSvBub/Nr/E4yr2OkqjB+0NKwPAeeg1fgyu1jt+H/4RSUh0YuJLCSBlcx3v5OgGIp
         sLO4gu9h1FUrPZmXLDr0KNfTEYgcg4xHO+lvxlrhW6gVOHytEy/8NAJDHnCox219LeO9
         yVdSJRVFSzPRQbDuUx7v2XiS8uycJRpBvIIbrvwcmc/6U5N6aPI3RGuEZdfkoSOY7B3a
         LzqFpgxxI5KUMbb0d3lF3TdYm8eNj23JFV+MI3LE+0U5/KoCzuJMzQ4aj46GWsHlVqRb
         HQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783423487; x=1784028287;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VV+gJB5ebBMdY4lrxfExKBx0DMSngEYrND59Gya7WaU=;
        b=FVM6y8BCcnO7NRJhm4KuRyrBceyaLsZkGPt3LoQVfDLn97Vwk4s3tiliOec+WfEUn3
         MO3xac8Ejy/LXOXxgsWFuO/jZlm/ZrHfNGeH++WXsNPpYbbQlplhBiA4s1YxklySAI9z
         8MWtfuS0SMM6eKMEQrGzw2GvBoVeEcLzr1v/Vb3Snl1z060re36BhrwHRB9LVOi0ZpAZ
         qCjjw0ZaU1jBc6DWviw8/IrGx/udbIkcTd8WA7twkLwdtusbOLJ/nEivPyEvbIy+bvFE
         huElwp/cx+AGzTmMQPvWR+8RivE0TnBXS+ZzyCqLt9PV+7X/xVFJUh0fIQPcZ5XjbQju
         AmWw==
X-Forwarded-Encrypted: i=1; AHgh+Rpyspauh32IWYkGRuXJVuX9IVTYinETPkHM5OrsVEyADx71d5G/lkvUL4SZpvfji4oDMTybyZ3A@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8TYIJKoVCt6eYkXPRzx8smAgHSaY8U0j+3qYG9fzZvM7muSH3
	EvsPhThq11NzNl/Dga2Feo0hXWtZn2ghEww2u3IlC6K2JgszxWcJivk/t/or+L1slA==
X-Gm-Gg: AfdE7clnpW2Obuqu/Obq1oClgue5CR+EvvJrp9w+ZnGgPlmMpeB5ceLBzFOyLQc9g6C
	wbIyXhBiqs4NQjnr/kCd4cok8V6A9sR+narZWtHPrin47l+nJiNoZcCubsF2ENGK/xOVwW+5zkl
	rNoryRZK6KBLbWwCqfbWogkq7Ed6tSCB3hs5MrErLPCJXgb3FhrpXepK0SghpU/pjBpstETHE1l
	MhUGyv56hPC7VQs7xdWRocunsYpWBOOdRm+dyp6Lvcxc0/vVfRyaccVgJyXXFe7keR97T/5lK5S
	ZDYw/nxOPMWL+1m/rAsJIWKpUJvBeBkzUMedsjWzZxAMJHBHoS6Tc2v85ycBc+jDXMCHu8lRUs7
	CsYlen8ENFocscudnLDuMTzbywz4htea6UQapS8IPksa5ZHlF9/wvpNwcmkyp+LiJTwko2VurlP
	kTozuzyBQQv5izj1FkDccjruh3ZCFWtNrsWJjIBrE6mha8uB3I
X-Received: by 2002:a05:600d:6409:10b0:492:668f:410c with SMTP id 5b1f17b1804b1-493e122aa8dmr648535e9.10.1783423487138;
        Tue, 07 Jul 2026 04:24:47 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0078d49sm53005485e9.0.2026.07.07.04.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:24:46 -0700 (PDT)
Date: Tue, 7 Jul 2026 11:24:38 +0000
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
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <akzh9qFEfi2umwDW@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:39PM -0300, Jason Gunthorpe wrote:
> pgsize is a constant property of the domain, it is the base translation
> granule of the page table (4k, 16k, 64k) in log2.
> 
> Store it to the struct arm_smmu_domain based on how the page table was created.
> 
> Add smmu_domain to the tlbi and just get tg from the domain.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 27 ++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 ++-
>  3 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 1ed8a6f29dc445..5d4dde3d1cfe87 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -334,6 +334,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
>  	 * ARM_SMMU_FEAT_RANGE_INV is present
>  	 */
>  	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
> +	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
>  	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
>  	smmu_domain->smmu = smmu;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0c875771b46d2f..d22012466e3965 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2398,14 +2398,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  					  struct arm_smmu_cmdq_batch *cmds,
>  					  struct arm_smmu_cmd *cmd,
> -					  struct arm_smmu_tlbi *tlbi,
> -					  size_t pgsize)
> +					  struct arm_smmu_tlbi *tlbi)
>  {
>  	size_t inv_range = tlbi->iopte_granule;
>  	unsigned long iova = tlbi->iova;
>  	unsigned long end = iova + tlbi->size;
>  	unsigned long num_pages = 0;
> -	unsigned int tg = pgsize;
> +	unsigned int tg = tlbi->smmu_domain->tgsz_lg2;
>  	u64 orig_data0 = cmd->data[0];
>  	u8 ttl = 0, tg_enc = 0;
>  
> @@ -2513,7 +2512,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  		return;
>  	}
>  
> -	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
> +	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
>  }
>  
>  static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
> @@ -2615,6 +2614,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  			       unsigned int granule, bool leaf)
>  {
>  	struct arm_smmu_tlbi tlbi = {
> +		.smmu_domain = smmu_domain,
>  		.iova = iova,
>  		.size = size,
>  		.iopte_granule = granule,
> @@ -2870,6 +2870,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>  		return -ENOMEM;
>  
>  	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
> +	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
>  	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
>  	smmu_domain->domain.geometry.force_aperture = true;
>  	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
> @@ -3104,15 +3105,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
>  
>  static struct arm_smmu_inv *
>  arm_smmu_master_build_inv(struct arm_smmu_master *master,
> -			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
> -			  size_t pgsize)
> +			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
>  {
>  	struct arm_smmu_invs *build_invs = master->build_invs;
>  	struct arm_smmu_inv *cur, inv = {
>  		.smmu = master->smmu,
>  		.type = type,
>  		.id = id,
> -		.pgsize = pgsize,
>  	};
>  
>  	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
> @@ -3164,28 +3163,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
>  			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
>  {
>  	const bool nesting = smmu_domain->nest_parent;
> -	size_t pgsize = 0, i;
> +	size_t i;
>  
>  	iommu_group_mutex_assert(master->dev);
>  
>  	master->build_invs->num_invs = 0;
>  
> -	/* Range-based invalidation requires the leaf pgsize for calculation */
> -	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
> -		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
> -
>  	switch (smmu_domain->stage) {
>  	case ARM_SMMU_DOMAIN_SVA:
>  	case ARM_SMMU_DOMAIN_S1:
>  		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
>  					       smmu_domain->cd.asid,
> -					       IOMMU_NO_PASID, pgsize))
> +					       IOMMU_NO_PASID))
>  			return NULL;
>  		break;
>  	case ARM_SMMU_DOMAIN_S2:
>  		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
>  					       smmu_domain->s2_cfg.vmid,
> -					       IOMMU_NO_PASID, pgsize))
> +					       IOMMU_NO_PASID))
>  			return NULL;
>  		break;
>  	default:
> @@ -3197,7 +3192,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
>  	if (nesting) {
>  		if (!arm_smmu_master_build_inv(
>  			    master, INV_TYPE_S2_VMID_S1_CLEAR,
> -			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
> +			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
>  			return NULL;
>  	}
>  
> @@ -3208,7 +3203,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
>  		 */
>  		if (!arm_smmu_master_build_inv(
>  			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
> -			    master->streams[i].id, ssid, 0))
> +			    master->streams[i].id, ssid))
>  			return NULL;
>  	}
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index a364d847c22a92..2fc695817671fe 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -734,7 +734,6 @@ struct arm_smmu_inv {
>  	u8 nsize_opcode;
>  	u32 id; /* ASID or VMID or SID */
>  	union {
> -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
>  		u32 ssid; /* INV_TYPE_ATS */
>  	};
>  
> @@ -803,6 +802,7 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
>  }
>  
>  struct arm_smmu_tlbi {
> +	struct arm_smmu_domain *smmu_domain;

The smmu_domain is only used for the tgsz_lg2, can’t we add that
directly instead? Decoupling the invalidation form the domain would
make it easier for KVM to re-use the code.
I see by the end of the series the only difference would be
arm_smmu_domain_tlbi() which need to the domain for the RCU, but that
can be passed instead as all the callers are have the domain already.

Thanks,
Mostafa

>  	unsigned long iova;
>  	size_t size;
>  	unsigned int iopte_granule;
> @@ -1050,6 +1050,7 @@ struct arm_smmu_domain {
>  	spinlock_t			devices_lock;
>  	bool				enforce_cache_coherency : 1;
>  	bool				nest_parent : 1;
> +	u8				tgsz_lg2;
>  
>  	struct mmu_notifier		mmu_notifier;
>  };
> -- 
> 2.43.0
> 

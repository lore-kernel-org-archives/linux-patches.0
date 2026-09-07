Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3285E361947
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790940; cv=none; b=moEsEA6cHmQ8UdIvp8U1bIwKcleW42GXtS8/A8LQV/bCrPDqs73SmfqLANf980U7l5/blkEttgsO0yh0eBYAQc0dG0bd50J6cSmNRN3KSi6Fz2SIugUr/nYwm8iRko62GOBa+dlDZPaEihhWbmDN2YG+tWWeOrz33/h2ulcDBq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790940; c=relaxed/simple;
	bh=L5giwHFItNxyBQ4HYY6/uL44rLGUGPvpnizGzE2uDCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCvm1ZnsNUvu/8vkwSJBR76mHQ//YDOtMau7MaU05SUSkLrXKmSwnnn2IlV55BFSvPR02n0gqyi+n/d1IqAOMUl1941XO2J4K7qnITKpMm9DbDbIFhC2zX/K8K/3EHWmOaacNYCo/eY6iHpEP2nrl/AvWAOqtTbZ8xmZmwpJcgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rIpLPbPA; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIpLPbPA"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5d8fd8d88so15184a12.0
        for <patches@lists.linux.dev>; Mon, 07 Sep 2026 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788790936; x=1789395736; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+65O/Mn9btfawvfMn+qubKzpEX/dBj5nAHgdBd6jOu0=;
        b=rIpLPbPA6fLDqfkhNGjACR7RObWZ/unqgHsCbEbBZnKJBdgE5Ez0zhe1HW2hPqqPVb
         jO/PKvrotdGB72t8A1NAPq2N0PSzsi6h28J8n1leQuntbogCivnM/MoscyswsQcbf7gj
         IehRXnXrrkATufhINzaZI/IYt4rQYglgGoem/gbVnXmprBUyv5vmid3qEM6CvVxMDHkl
         pz5SGrN9By5vijAl4x250dgwbIaVO+MfsIyZ97gaLBbjS7yJWLPq14gERvEJ/96bD5Pc
         dKv3TaAEQvW3r1PKvc/ge8nZvn00Bo2iKSrOuKLHDwAi2qcZnJ9viXwYraIs0OjZCk7K
         w6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788790936; x=1789395736;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+65O/Mn9btfawvfMn+qubKzpEX/dBj5nAHgdBd6jOu0=;
        b=HiwWovG9EEfObyGD2HPy/ah2xHoEIFJdvXR+rKUi9f7Bxv6MpS/GkdcxW7bFG4O52z
         xCrdFbN0clCs6NBh20uyMbJsHFbcMYNHS6RCo5T7qkO4C1BV6t/JRwCly27X1BHja24z
         sx86OiaA1XbmdOET4fnpZjlRH8ILQGkb5ZvbPB6vmH/zo9KupesgZgDQZgw4RIpjz3rI
         uI+KHYB/2a7Vpjdn93sQ4mib9lo+vz4yu0ckPwUhkvZL67EgypNoDf6WjUpKMFZ6rwfg
         CSId6CUJM3jOlqoXCHLhipEqQCUrtIlDeYAWZ4E6W2Ij9q59nI88fSoXRt3nAfv0/TZT
         Joqg==
X-Forwarded-Encrypted: i=1; AKwUvBzEGwMq0ZTGUbs0Sxeo7jchWOo21dPplKJ5UeWvErKcECE6EcyWNjAjRYTbUb+kZ5oiJRc+i2eI@lists.linux.dev
X-Gm-Message-State: AFuF++nWqRV9BfcUIEM9qdbb3n+Il6gHOMRgS5nC0wYveFchLFluwdCP
	lf1OA6L9Dmx6gSjXdIWzxvB/Gji/flgLrHQrFw5zO15ceTJD8GfatpXjZNHzn8htmw==
X-Gm-Gg: AYBFou1yABRba/zaAO2yc9zZsxF5JtiHceMgjhxr4G5TYHSkgOWBWlCaiMCGqe4QlwB
	QgV2bv6xb01tfmgsylkcEV+VywjUxmTILlZ+w1xo5X8IDDDzJazZOlUtJx3nDKhPQcA+AXZndjZ
	RqKJcY/ZDUQ5KfacPXcIDmZEzmmvS/EF2RkHEO7393CMSmEs+oyPmpTI4P9PvYArujrDH9n2Z/o
	UAKJtDtWOQfhD/Lk5W6nl84vxLleNHvNc3XEghNbVTrVC0eloG21Hobpiu5F3z+wpEEfFZfhVqn
	2wm2uMRUItqvSqsbbg5twa9Eti8Scp2T60nurUk21q4QTUYxijVk2fe2kdY6kKex58al+Wnl/HB
	HLeRf0Hc/Wr1eUaY0CgqncKNguVlMYbtDhW8RtKjVoZrZzo1B1w/snYavoWf3M02Ndkn936sz+I
	EYr0P46aVhDWA4sEq50QhsH832yT+plX6AzpOadefZCIOnYJdo6w0n4hFrM93lzd3TvmAH/I/i3
	YGvgl5QTO8/lk4N0U6jsJGBLjB8lA==
X-Received: by 2002:aa7:d8d6:0:b0:6a6:6ded:b4b6 with SMTP id 4fb4d7f45d1cf-6a7f689d0femr62664a12.13.1788790935870;
        Mon, 07 Sep 2026 07:22:15 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26263cb042sm348714166b.47.2026.09.07.07.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:22:14 -0700 (PDT)
Date: Mon, 7 Sep 2026 14:22:11 +0000
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
Subject: Re: [PATCH v5 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <ap7Ik0c5xQi647xy@google.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <3-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>

On Tue, Sep 01, 2026 at 02:49:52PM -0300, Jason Gunthorpe wrote:
> pgsize is a constant property of the domain, it is the base translation
> granule of the page table (4k, 16k, 64k) in log2.
> 
> Store it to the struct arm_smmu_domain based on how the page table was
> created.
> 
> Pass it around in the tlbi.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 29 ++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 ++++---
>  3 files changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index a0c9078646fb55..7acb70d060ec4e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -345,6 +345,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
>  	 * ARM_SMMU_FEAT_RANGE_INV is present
>  	 */
>  	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
> +	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
>  	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
>  	smmu_domain->smmu = smmu;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 03723bb00de412..6413eb4021ce22 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2463,14 +2463,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  					  struct arm_smmu_cmdq_batch *cmds,
>  					  struct arm_smmu_cmd *cmd,
> -					  struct arm_smmu_tlbi *tlbi,
> -					  size_t pgsize)
> +					  struct arm_smmu_tlbi *tlbi)
>  {
>  	size_t inv_range = tlbi->iopte_size;
>  	unsigned long iova = tlbi->iova;
>  	unsigned long end = iova + tlbi->size;
>  	unsigned long num_pages = 0;
> -	unsigned int tg = pgsize;
> +	u8 tg = tlbi->tgsz_lg2;
>  	u64 orig_data0 = cmd->data[0];
>  	u8 ttl = 0, tg_enc = 0;
>  
> @@ -2609,12 +2608,12 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
>  		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd,
>  						 tlbi->iova, tlbi->size,
> -						 inv->pgsize))
> +						 tlbi->tgsz_lg2))
>  			goto full_inv;
>  		return;
>  	}
>  
> -	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
> +	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
>  	return;
>  
>  full_inv:
> @@ -2722,6 +2721,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  			       unsigned int granule, bool leaf)
>  {
>  	struct arm_smmu_tlbi tlbi = {
> +		.tgsz_lg2 = smmu_domain->tgsz_lg2,
>  		.iova = iova,
>  		.size = size,
>  		.iopte_size = granule,
> @@ -2978,6 +2978,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>  		return -ENOMEM;
>  
>  	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
> +	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
>  	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
>  	smmu_domain->domain.geometry.force_aperture = true;
>  	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
> @@ -3217,15 +3218,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
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
> @@ -3277,28 +3276,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
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
> @@ -3310,7 +3305,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
>  	if (nesting) {
>  		if (!arm_smmu_master_build_inv(
>  			    master, INV_TYPE_S2_VMID_S1_CLEAR,
> -			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
> +			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
>  			return NULL;
>  	}
>  
> @@ -3321,7 +3316,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
>  		 */
>  		if (!arm_smmu_master_build_inv(
>  			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
> -			    master->streams[i].id, ssid, 0))
> +			    master->streams[i].id, ssid))
>  			return NULL;
>  	}
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index d3e81056f24afc..3e7f94339ab60e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -736,10 +736,9 @@ struct arm_smmu_inv {
>  	u8 size_opcode;
>  	u8 nsize_opcode;
>  	u32 id; /* ASID or VMID or SID */
> -	union {
> -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
> -		u32 ssid; /* INV_TYPE_ATS */
> -	};
> +
> +	/* Only used by INV_TYPE_ATS */
> +	u32 ssid;
>  
>  	int users; /* users=0 to mark as a trash to be purged */
>  };
> @@ -810,6 +809,8 @@ struct arm_smmu_tlbi {
>  	size_t size;
>  	/* page or block size of the leaf iopte */
>  	unsigned int iopte_size;
> +	/* Base Translation Granule of the page table */
> +	u8 tgsz_lg2;
>  	bool has_cont;
>  	bool leaf_only;
>  };
> @@ -1060,6 +1061,7 @@ struct arm_smmu_domain {
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

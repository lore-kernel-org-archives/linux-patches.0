Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7833C0619
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145703; cv=none; b=pk4jdGaAzC6jL0ez4Q9jNzAKONeAbXCwQh5rRfgmXQnQMq27A018ifXH+qV2sEPAoA61NWnUhQzx1SEo9RAsrZFUvRS3meU83QgQcajxMXbiE+l9KZxfS7H1xUCkPQ5yW5040nr6SD05OjmtXeEqg1iXxUw8zfL6Tjy7eHNko7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145703; c=relaxed/simple;
	bh=WxBCtqpKKW7waaUP8Vrq5Hqx5TZRDhnRcpzXY8zIYrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlsWnzLjVwD8HvgWbsZDYqTBP7mGc6bcPkpiqjNcBk87JU4pSljMFGnIx7/rEPGN8pJD5njUmBkelb9DzoscXQgTxr6CuDODXww+SQHR9Q01DVNeGiXiYDiLCnhevihjX+53oxbFWmQlzld8TjF3WlKeYbbXxxuf+Ve72JRpQWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sr92jJCq; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sr92jJCq"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48d1c670255so77555e9.0
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145694; x=1778750494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lZOdgNov1BxqyJ4K4hjZNDZI6MstUmVOQY9xgpKGQf0=;
        b=Sr92jJCqd7yuc5TDPOXG9/yG5eu3pZESImndFkRquluTsqagV3uM+AK/3eiuH4tSgK
         ELtYzvxHmrLicEJKRhGtORhW09xSLUbZnjZ5iiCfLFRDgK5/tctQIerNYxUETZFmOdPw
         mq99hchWIOLqDagMCUOxbWB+yvuD/N8ap/L6lqzohb5BDrx6DTEkoQQYMSPx7fl6HI9A
         2HhvF4lUdqCcsHrbrXPRITI7OCVrwTgQP5ZaBy02PCFuiOKifYKcQNy32coUteWswmA3
         e1+BaJ8brpCFHWt49CzEbe36sY2kDgg7IjRK+ly+VKphhNuXFUieUhnR4TnbPDoMAzvS
         ulyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145694; x=1778750494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lZOdgNov1BxqyJ4K4hjZNDZI6MstUmVOQY9xgpKGQf0=;
        b=EFxtkk5XSXfZ5MzJwwzgSjqj/MsTaP9Byj3bXZERc06P8rKdFKBgZrZJ3OXfWjpdlC
         D1N8LFQv3SGmqC4LqxwjaQe2UbDiISk2rKfUMmgXXR4pEoG3zY6IEBU8WV0d0FjGhH3N
         EZ41ZM01V4ivrIkZgteyQkhIRZf1MlHDcFWFXfJ8S9MtSR2JK/AGOUO4IJT5mOtmC/zf
         zJZob2C3lRk3leSv0awsKCBDWBpOAA/SyDee5XOYmoCixnnE+VCl9S4mPXVKpur6Y1w9
         8kUJc9nx9prnoG4XwhA1xSRUPfq3n1mZii7vDYI7zhfEW6Zq4EedccRarOmd2PT/72l8
         RNQg==
X-Forwarded-Encrypted: i=1; AFNElJ9rLz5QLM//ZEUv8ibViH/LJi1BU+u4g6IltdnCBulWeNVC2mSgSZhxPbtkcT82IUY2OYBYgJ52@lists.linux.dev
X-Gm-Message-State: AOJu0YzkW+72wdoZ/BfvAMIMXLOSixxD6P4qilyInLDvxX5LrHwc6mSa
	6JSjKsgLo1Zx/SZw0F1/JP9Wcfo7b/I3Y/45CrbhhV5ZsorStaMz60NjW6gUW8PM+A==
X-Gm-Gg: AeBDiet0EcOJBpCsyBHMAL9oTOHxDU0qgCbsog/QzPSCm/E4WKsWy+DnXUian3uYqdp
	6AX1w1vGydp2IsZ75nH1ZaYRN8vGz6dPA0GNmoP0O6evKKZfRGLSAEiv5PNY6dMTcj9e54A3PMk
	HpfdsWH3yB8HY2V7F9iQ7MZ0LBgvsCsl/D4HCE/5W/9smxNxql14VzmJJ+/lIOTUj1JnUnhSx1j
	GUxnufFPoZEaNk6eprZZ4lVdvKnDhROr6+wGg7cD+am0N4Jp+Ck+/B17+i/X0RHJlu56VFOaiS1
	0yD9ESN3ZgZgy5YE9NheL2yxUMEJWQKWJO+S6r6T39gYw6NjJCphpJi8GY1zE00N8wWHBsBBdFp
	hxc/0l5JI4sDwlw0MTSfKQCtCFFtgNHVml9iwAz2LU1oGya8BcIU519DI0I5yWsVpt3mfUfiZjr
	cey6HZVd/+sx/euh9Vl/zs3yN209ccCU97S/mJspa/YEB1NfEFslcdHQYQKmxJGhK3jS/JRPANY
	d2lnQ==
X-Received: by 2002:a05:600c:2284:b0:488:960f:60b8 with SMTP id 5b1f17b1804b1-48e5d64bc85mr779165e9.6.1778145693237;
        Thu, 07 May 2026 02:21:33 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-453509db3ccsm2354347f8f.36.2026.05.07.02.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:21:32 -0700 (PDT)
Date: Thu, 7 May 2026 09:21:28 +0000
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
Subject: Re: [PATCH 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 selection functions
Message-ID: <afxZmOP6m_Khatj8@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:11AM -0300, Jason Gunthorpe wrote:
> Start removing the use of struct arm_smmu_cmdq_ent, starting at the
> lower levels of the call chain. Change the functions that determine what
> cmdq to issue the batch to into using struct arm_smmu_cmd directly.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 47 ++++++++++++-------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ++--
>  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 ++--
>  3 files changed, 38 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e8d7dbe495f030..5cdeaec890592f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -371,12 +371,12 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
>  }
>  
>  static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu,
> -					       struct arm_smmu_cmdq_ent *ent)
> +					       struct arm_smmu_cmd *cmd)
>  {
>  	struct arm_smmu_cmdq *cmdq = NULL;
>  
>  	if (smmu->impl_ops && smmu->impl_ops->get_secondary_cmdq)
> -		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, ent);
> +		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, cmd);
>  
>  	return cmdq ?: &smmu->cmdq;
>  }
> @@ -924,16 +924,16 @@ static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
>  				     struct arm_smmu_cmdq_ent *ent,
>  				     bool sync)
>  {
> -	u64 cmd[CMDQ_ENT_DWORDS];
> +	struct arm_smmu_cmd cmd;
>  
> -	if (unlikely(arm_smmu_cmdq_build_cmd(cmd, ent))) {
> +	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
>  		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
>  			 ent->opcode);
>  		return -EINVAL;
>  	}
>  
>  	return arm_smmu_cmdq_issue_cmdlist(
> -		smmu, arm_smmu_get_cmdq(smmu, ent), cmd, 1, sync);
> +		smmu, arm_smmu_get_cmdq(smmu, &cmd), cmd.data, 1, sync);
>  }
>  
>  static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
> @@ -948,42 +948,55 @@ static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
>  	return __arm_smmu_cmdq_issue_cmd(smmu, ent, true);
>  }
>  
> +static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
> +					 struct arm_smmu_cmdq_batch *cmds,
> +					 struct arm_smmu_cmd *cmd)
> +{
> +	cmds->num = 0;
> +	cmds->cmdq = arm_smmu_get_cmdq(smmu, cmd);
> +}
> +
>  static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
>  				     struct arm_smmu_cmdq_batch *cmds,
>  				     struct arm_smmu_cmdq_ent *ent)
>  {
> -	cmds->num = 0;
> -	cmds->cmdq = arm_smmu_get_cmdq(smmu, ent);
> +	struct arm_smmu_cmd cmd;
> +
> +	arm_smmu_cmdq_build_cmd(cmd.data, ent);
> +	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
>  }
>  
>  static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
>  				    struct arm_smmu_cmdq_batch *cmds,
> -				    struct arm_smmu_cmdq_ent *cmd)
> +				    struct arm_smmu_cmdq_ent *ent)
>  {
> -	bool unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
>  	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
>  			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
> +	struct arm_smmu_cmd cmd;
> +	bool unsupported_cmd;
>  	int index;
>  
> +	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
> +		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> +			 ent->opcode);
> +		return;
> +	}
> +
> +	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
>  	if (force_sync || unsupported_cmd) {
>  		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
>  					    cmds->num, true);
> -		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
> +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
>  	}
>  
>  	if (cmds->num == CMDQ_BATCH_ENTRIES) {
>  		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
>  					    cmds->num, false);
> -		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
> +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
>  	}
>  
>  	index = cmds->num * CMDQ_ENT_DWORDS;
> -	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
> -		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> -			 cmd->opcode);
> -		return;
> -	}
> -
> +	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));

Maybe this would be better squashed with other arm_smmu_cmdq_batch
patch to avoid this memcpy, but no strong opinion.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa
>  	cmds->num++;
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 092179f689e9f1..6d73f6b63e64a9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -641,13 +641,13 @@ struct arm_smmu_cmdq {
>  	atomic_long_t			*valid_map;
>  	atomic_t			owner_prod;
>  	atomic_t			lock;
> -	bool				(*supports_cmd)(struct arm_smmu_cmdq_ent *ent);
> +	bool				(*supports_cmd)(struct arm_smmu_cmd *cmd);
>  };
>  
>  static inline bool arm_smmu_cmdq_supports_cmd(struct arm_smmu_cmdq *cmdq,
> -					      struct arm_smmu_cmdq_ent *ent)
> +					      struct arm_smmu_cmd *cmd)
>  {
> -	return cmdq->supports_cmd ? cmdq->supports_cmd(ent) : true;
> +	return cmdq->supports_cmd ? cmdq->supports_cmd(cmd) : true;
>  }
>  
>  struct arm_smmu_cmdq_batch {
> @@ -815,7 +815,7 @@ struct arm_smmu_impl_ops {
>  	void (*device_remove)(struct arm_smmu_device *smmu);
>  	int (*init_structures)(struct arm_smmu_device *smmu);
>  	struct arm_smmu_cmdq *(*get_secondary_cmdq)(
> -		struct arm_smmu_device *smmu, struct arm_smmu_cmdq_ent *ent);
> +		struct arm_smmu_device *smmu, struct arm_smmu_cmd *cmd);
>  	/*
>  	 * An implementation should define its own type other than the default
>  	 * IOMMU_HW_INFO_TYPE_ARM_SMMUV3. And it must validate the input @type
> diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> index 83f6e9f6c51d6b..b4d8c1f2fd3878 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> @@ -367,9 +367,9 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
>  
>  /* Command Queue Function */
>  
> -static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
> +static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmd *cmd)
>  {
> -	switch (ent->opcode) {
> +	switch (FIELD_GET(CMDQ_0_OP, cmd->data[0])) {
>  	case CMDQ_OP_TLBI_NH_ASID:
>  	case CMDQ_OP_TLBI_NH_VA:
>  	case CMDQ_OP_ATC_INV:
> @@ -381,7 +381,7 @@ static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
>  
>  static struct arm_smmu_cmdq *
>  tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
> -			struct arm_smmu_cmdq_ent *ent)
> +			struct arm_smmu_cmd *cmd)
>  {
>  	struct tegra241_cmdqv *cmdqv =
>  		container_of(smmu, struct tegra241_cmdqv, smmu);
> @@ -409,7 +409,7 @@ tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
>  		return NULL;
>  
>  	/* Unsupported CMD goes for smmu->cmdq pathway */
> -	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, ent))
> +	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, cmd))
>  		return NULL;
>  	return &vcmdq->cmdq;
>  }
> -- 
> 2.43.0
> 

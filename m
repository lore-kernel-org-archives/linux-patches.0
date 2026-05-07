Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5AD3C0637
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145770; cv=none; b=jX084452HDFP0uusN5dWk5lQOU4vYuk5OQftjrJaCLOmbuCDP4MnFiPuTC+EgA8IxnOz9lY/Yn54lFvB9KUaoicb0a0gTzLX2+rhS5MKmHsVaw5Tu25VMSOITvaVtahBVZK7Ox/Y11p9OjpQhtUGNS0JPERdEvT1htURQgg+L08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145770; c=relaxed/simple;
	bh=X/riaerK2B9wqEzaGMdpVfgWuA/hSQK7JkY9v8yS0zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SL83ppEaYL53Cn8MTuzKQYccoXb359aGnICQMk8wlR+w0JfHupF6LDa8scmpmF3IHYNy7M3zmFNCmhxZhp3zKYcihQY9yI3tq4aIEovAGtZ3+eWD2SnXSeWNa4N1G6EQ9OyhuMS8mAmanae/DgijFhxYLl09gOM7OT82Z5BvApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nkPEZW/L; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkPEZW/L"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so65315e9.1
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145766; x=1778750566; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0u/Qu/p/GxovAtDgoUKiY948exYbbPVF+jkYx7O6D0=;
        b=nkPEZW/LCuB1jqlBFfWHYyhGNV7e/K5/BT8kiK+tNIAIjzPaPiVUJRZzi2yp1Gj1qd
         //o8tkMou/UoUGd7TH169mxKffGdzasAO63w0VFuUuDi9V09e2zkJb0A8Q8WYgyWgEsT
         scQ2R+bRVO7VfgMF1mdBO9MtUhYjDlR9nvjLRKqWbFWBsHAsLh/zypzLYgR6wmvWnp46
         nTeoQl5mUitbrNd8HPgm2qv9td1C3cm/QdUA5nSoETlGGBfCOaQMjpLZeIWTLapqwlv8
         kyfk3XIYwvNUjEdH3QY5jrBjxu3KTYlGPUoHxVd4wsjdBatgNj8TH9rDobqkXaVEN6EB
         pYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145766; x=1778750566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K0u/Qu/p/GxovAtDgoUKiY948exYbbPVF+jkYx7O6D0=;
        b=C4wDmoM5Hlw4nJc9aWyENEb+mTDiQt8Ayg9VAsuR6vRN790Imapz+jprTWQkcpGudu
         F4BrwhdUBZAIdZx7McgPNPe/cqRnlN0cQumSXIK4rUJP17W9LAjGpF8NJ03QGQLWFXmy
         ec0nJwUdsS+EJ6XYgdJnJX/FguKzyMUOrygrjtxC0OuOLx+zNRIrzWv5cJXgAr2vVO4l
         wUs0Jh2l1ZS+yomhbHTnCaqywXKOjQKCB3oxdU66kpQiyYOCmZiRWCnerKXKH9uZnLDP
         KkxMftF+oFQmQGysP5M/UO/lrrO1f4UGDlnKPu8YozVKnrQBfmG0uLUl8hyBtgaLqut6
         c50g==
X-Forwarded-Encrypted: i=1; AFNElJ8PGBi7nULxbiMmwz5smcjTVV7WPbLVmPmcL9CtP549yK7IB7PzwuT6fP06NbZD80DHpEQmUKiB@lists.linux.dev
X-Gm-Message-State: AOJu0YwfLJu524VGgQ6TphnFTIBTi8LSX6H+olVn9lFJxvItgqcOw64Q
	ebTPY5C/WVE2s2mcfhwdMoKWpeeJULjcngSDTV2Zo7AwenGPRPQ07ZKCaWxLEoNgAA==
X-Gm-Gg: AeBDietSQvDCCGIcu9fG1PQm0nspy47Vluqawa/aksERaP0g8KvbaVZtxJ9jgbH2sr1
	ZeKBGYWopxRZCR2DLq3j0n4m45t/ESQF4MLh210Wgs+Wf8v9f1KLm0c3kJspTosXoppYa9HDwAx
	/PpIz1w2uhJAWrcJ1mraUfE4M4TS4mvH5d0smclfIkVkkcJ/3R9fVWDb8XKDep8B6PO40WiaPkk
	ndRgOIX4ADyOSGhViFKKcp2paP+5aEPxT5UGhkrrbZfCsaWoSpYu/xNgCIcLNq92JzCJWTPMlmN
	bhNyWEFzrJ6dxjtvKmhzBvmKpP8unJD6TtxxFUeU3m8ZK4Kbp23/OTDQ3okDX6JPhEG8Jt8mRd0
	yZ23eCxO35nAOOUGAnQcntM4EHyOG0r7Im3AMlBzi0PBzuiSkHjSiCrkgfyfXUFn4xzLW26XXas
	Cl+pLsbnz3HFJyLU+fBJGuVNBiS192z5l5BIZv6PoYO4LQ4R5lBnELTQVz5hRnRUau/f+PxK9v8
	sE1Zw==
X-Received: by 2002:a7b:c314:0:b0:48a:5f32:62d0 with SMTP id 5b1f17b1804b1-48e5d650751mr689475e9.12.1778145765677;
        Thu, 07 May 2026 02:22:45 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53907e8asm108444175e9.13.2026.05.07.02.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:22:45 -0700 (PDT)
Date: Thu, 7 May 2026 09:22:41 +0000
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
Subject: Re: [PATCH 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Message-ID: <afxZ4cVoK2zF4QCT@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <6-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:15AM -0300, Jason Gunthorpe wrote:
> Add make functions to build commands for
> 
>  CMDQ_OP_TLBI_EL2_ALL
>  CMDQ_OP_TLBI_NSNH_ALL
>  CMDQ_OP_CFGI_ALL
>  CMDQ_OP_PREFETCH_CFG
>  CMDQ_OP_CFGI_STE
>  CMDQ_OP_CFGI_CD
>  CMDQ_OP_RESUME
>  CMDQ_OP_PRI_RESP
> 
> Convert all of these call sites to use the make function instead of
> going through arm_smmu_cmdq_build_cmd(). Use a #define so the general
> pattern is always:
> 
>    arm_smmu_cmdq_issue_cmd(smmu, arm_smmu_make_cmd_XX(..));
> 
> Add arm_smmu_cmdq_batch_add_cmd() which takes struct arm_smmu_cmd
> directly to match the new flow.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 213 +++++++-------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 109 +++++++---
>  2 files changed, 151 insertions(+), 171 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index ef0907b1a2204f..f9c25ca9a9e7b8 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -277,23 +277,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
>  	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
>  
>  	switch (ent->opcode) {
> -	case CMDQ_OP_TLBI_EL2_ALL:
> -	case CMDQ_OP_TLBI_NSNH_ALL:
> -		break;
> -	case CMDQ_OP_PREFETCH_CFG:
> -		cmd[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, ent->prefetch.sid);
> -		break;
> -	case CMDQ_OP_CFGI_CD:
> -		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
> -		fallthrough;
> -	case CMDQ_OP_CFGI_STE:
> -		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> -		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
> -		break;
> -	case CMDQ_OP_CFGI_ALL:
> -		/* Cover the entire SID range */
> -		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> -		break;
>  	case CMDQ_OP_TLBI_NH_VA:
>  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
>  		fallthrough;
> @@ -333,26 +316,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
>  		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
>  		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
>  		break;
> -	case CMDQ_OP_PRI_RESP:
> -		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
> -		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SSID, ent->pri.ssid);
> -		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SID, ent->pri.sid);
> -		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, ent->pri.grpid);
> -		switch (ent->pri.resp) {
> -		case PRI_RESP_DENY:
> -		case PRI_RESP_FAIL:
> -		case PRI_RESP_SUCC:
> -			break;
> -		default:
> -			return -EINVAL;
> -		}
> -		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_RESP, ent->pri.resp);
> -		break;
> -	case CMDQ_OP_RESUME:
> -		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, ent->resume.sid);
> -		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_RESP, ent->resume.resp);
> -		cmd[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, ent->resume.stag);
> -		break;
>  	case CMDQ_OP_CMD_SYNC:
>  		if (ent->sync.msiaddr) {
>  			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
> @@ -924,25 +887,24 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
>  	return ret;
>  }
>  
> -static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
> -				     struct arm_smmu_cmd *cmd,
> -				     bool sync)
> +static int arm_smmu_cmdq_issue_cmd_p(struct arm_smmu_device *smmu,
> +				     struct arm_smmu_cmd *cmd, bool sync)
>  {
>  	return arm_smmu_cmdq_issue_cmdlist(
>  		smmu, arm_smmu_get_cmdq(smmu, cmd), cmd, 1, sync);
>  }
>  
> -static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
> -				   struct arm_smmu_cmd *cmd)
> -{
> -	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, false);
> -}
> +#define arm_smmu_cmdq_issue_cmd(smmu, cmd)                      \
> +	({                                                      \
> +		struct arm_smmu_cmd __cmd = cmd;                \
> +		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, false); \
> +	})
>  
> -static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
> -					     struct arm_smmu_cmd *cmd)
> -{
> -	return __arm_smmu_cmdq_issue_cmd(smmu, cmd, true);
> -}
> +#define arm_smmu_cmdq_issue_cmd_with_sync(smmu, cmd)           \
> +	({                                                     \
> +		struct arm_smmu_cmd __cmd = cmd;               \
> +		arm_smmu_cmdq_issue_cmd_p(smmu, &__cmd, true); \
> +	})
>  
>  static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
>  					 struct arm_smmu_cmdq_batch *cmds,
> @@ -962,14 +924,41 @@ static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
>  	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
>  }
>  
> +static void arm_smmu_cmdq_batch_add_cmd_p(struct arm_smmu_device *smmu,
> +					  struct arm_smmu_cmdq_batch *cmds,
> +					  struct arm_smmu_cmd *cmd)
> +{
> +	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
> +			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
> +	bool unsupported_cmd;
> +
> +	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
> +	if (force_sync || unsupported_cmd) {
> +		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> +					    cmds->num, true);
> +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
> +	}
> +
> +	if (cmds->num == CMDQ_BATCH_ENTRIES) {
> +		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> +					    cmds->num, false);
> +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, cmd);
> +	}
> +
> +	cmds->cmds[cmds->num++] = *cmd;
> +}
> +
> +#define arm_smmu_cmdq_batch_add_cmd(smmu, cmds, cmd)               \
> +	({                                                         \
> +		struct arm_smmu_cmd __cmd = cmd;                   \
> +		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &__cmd); \
> +	})
> +
>  static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
>  				    struct arm_smmu_cmdq_batch *cmds,
>  				    struct arm_smmu_cmdq_ent *ent)
>  {
> -	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
> -			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
>  	struct arm_smmu_cmd cmd;
> -	bool unsupported_cmd;
>  
>  	if (unlikely(arm_smmu_cmdq_build_cmd(&cmd, ent))) {
>  		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> @@ -977,20 +966,7 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
>  		return;
>  	}
>  
> -	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
> -	if (force_sync || unsupported_cmd) {
> -		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> -					    cmds->num, true);
> -		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
> -	}
> -
> -	if (cmds->num == CMDQ_BATCH_ENTRIES) {
> -		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> -					    cmds->num, false);
> -		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
> -	}
> -
> -	cmds->cmds[cmds->num++] = cmd;
> +	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
>  }
>  
>  static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
> @@ -1003,32 +979,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
>  static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
>  				   struct iommu_page_response *resp)
>  {
> -	struct arm_smmu_cmdq_ent cmd = {0};
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> -	int sid = master->streams[0].id;
> -	struct arm_smmu_cmd hw_cmd;
> +	u8 resume_resp;
>  
>  	if (WARN_ON(!master->stall_enabled))
>  		return;
>  
> -	cmd.opcode		= CMDQ_OP_RESUME;
> -	cmd.resume.sid		= sid;
> -	cmd.resume.stag		= resp->grpid;
>  	switch (resp->code) {
>  	case IOMMU_PAGE_RESP_INVALID:
>  	case IOMMU_PAGE_RESP_FAILURE:
> -		cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
> +		resume_resp = CMDQ_RESUME_0_RESP_ABORT;
>  		break;
>  	case IOMMU_PAGE_RESP_SUCCESS:
> -		cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
> +		resume_resp = CMDQ_RESUME_0_RESP_RETRY;
>  		break;
>  	default:
> +		resume_resp = CMDQ_RESUME_0_RESP_TERM;
>  		break;
>  	}
>  
> -	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
> -	arm_smmu_cmdq_issue_cmd(master->smmu, &hw_cmd);
> -
> +	arm_smmu_cmdq_issue_cmd(master->smmu,
> +				arm_smmu_make_cmd_resume(master->streams[0].id,
> +							 resp->grpid,
> +							 resume_resp));
>  	/*
>  	 * Don't send a SYNC, it doesn't do anything for RESUME or PRI_RESP.
>  	 * RESUME consumption guarantees that the stalled transaction will be
> @@ -1552,19 +1525,14 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  	size_t i;
>  	struct arm_smmu_cmdq_batch cmds;
>  	struct arm_smmu_device *smmu = master->smmu;
> -	struct arm_smmu_cmdq_ent cmd = {
> -		.opcode	= CMDQ_OP_CFGI_CD,
> -		.cfgi	= {
> -			.ssid	= ssid,
> -			.leaf	= leaf,
> -		},
> -	};
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_cfgi_cd(0, ssid, leaf);
>  
> -	arm_smmu_cmdq_batch_init(smmu, &cmds, &cmd);
> -	for (i = 0; i < master->num_streams; i++) {
> -		cmd.cfgi.sid = master->streams[i].id;
> -		arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
> -	}
> +	arm_smmu_cmdq_batch_init_cmd(smmu, &cmds, &cmd);
> +	for (i = 0; i < master->num_streams; i++)
> +		arm_smmu_cmdq_batch_add_cmd(
> +			smmu, &cmds,
> +			arm_smmu_make_cmd_cfgi_cd(master->streams[i].id, ssid,
> +						  leaf));
>  
>  	arm_smmu_cmdq_batch_submit(smmu, &cmds);
>  }
> @@ -1857,17 +1825,10 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
>  {
>  	struct arm_smmu_ste_writer *ste_writer =
>  		container_of(writer, struct arm_smmu_ste_writer, writer);
> -	struct arm_smmu_cmdq_ent ent = {
> -		.opcode	= CMDQ_OP_CFGI_STE,
> -		.cfgi	= {
> -			.sid	= ste_writer->sid,
> -			.leaf	= true,
> -		},
> -	};
> -	struct arm_smmu_cmd cmd;
>  
> -	arm_smmu_cmdq_build_cmd(&cmd, &ent);
> -	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(
> +		writer->master->smmu,
> +		arm_smmu_make_cmd_cfgi_ste(ste_writer->sid, true));
>  }
>  
>  static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
> @@ -1892,17 +1853,9 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
>  
>  	/* It's likely that we'll want to use the new STE soon */
> -	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
> -		struct arm_smmu_cmdq_ent
> -			prefetch_ent = { .opcode = CMDQ_OP_PREFETCH_CFG,
> -					 .prefetch = {
> -						 .sid = sid,
> -					 } };
> -		struct arm_smmu_cmd prefetch_cmd;
> -
> -		arm_smmu_cmdq_build_cmd(&prefetch_cmd, &prefetch_ent);
> -		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> -	}
> +	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
> +		arm_smmu_cmdq_issue_cmd(smmu,
> +					arm_smmu_make_cmd_prefetch_cfg(sid));
>  }
>  
>  void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> @@ -2327,22 +2280,10 @@ static void arm_smmu_handle_ppr(struct arm_smmu_device *smmu, u64 *evt)
>  		 evt[0] & PRIQ_0_PERM_EXEC ? "X" : "",
>  		 evt[1] & PRIQ_1_ADDR_MASK);
>  
> -	if (last) {
> -		struct arm_smmu_cmdq_ent ent = {
> -			.opcode			= CMDQ_OP_PRI_RESP,
> -			.substream_valid	= ssv,
> -			.pri			= {
> -				.sid	= sid,
> -				.ssid	= ssid,
> -				.grpid	= grpid,
> -				.resp	= PRI_RESP_DENY,
> -			},
> -		};
> -		struct arm_smmu_cmd cmd;
> -
> -		arm_smmu_cmdq_build_cmd(&cmd, &ent);
> -		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> -	}
> +	if (last)
> +		arm_smmu_cmdq_issue_cmd(
> +			smmu, arm_smmu_make_cmd_pri_resp(sid, ssid, ssv, grpid,
> +							 PRI_RESP_DENY));
>  }
>  
>  static irqreturn_t arm_smmu_priq_thread(int irq, void *dev)
> @@ -3464,7 +3405,7 @@ static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
>  
>  	cmd.opcode = inv->nsize_opcode;
>  	arm_smmu_cmdq_build_cmd(&hw_cmd, &cmd);
> -	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &hw_cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, hw_cmd);
>  }
>  
>  /* Should be installed after arm_smmu_install_ste_for_dev() */
> @@ -4827,8 +4768,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
>  {
>  	int ret;
>  	u32 reg, enables;
> -	struct arm_smmu_cmdq_ent ent;
> -	struct arm_smmu_cmd cmd;
>  
>  	/* Clear CR0 and sync (disables SMMU and queue processing) */
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
> @@ -4875,20 +4814,16 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
>  	}
>  
>  	/* Invalidate any cached configuration */
> -	ent.opcode = CMDQ_OP_CFGI_ALL;
> -	arm_smmu_cmdq_build_cmd(&cmd, &ent);
> -	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(smmu, arm_smmu_make_cmd_cfgi_all());
>  
>  	/* Invalidate any stale TLB entries */
>  	if (smmu->features & ARM_SMMU_FEAT_HYP) {
> -		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
> -		arm_smmu_cmdq_build_cmd(&cmd, &ent);
> -		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +		arm_smmu_cmdq_issue_cmd_with_sync(
> +			smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_EL2_ALL));
>  	}
>  
> -	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
> -	arm_smmu_cmdq_build_cmd(&cmd, &ent);
> -	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(
> +		smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NSNH_ALL));
>  
>  	/* Event queue */
>  	writeq_relaxed(smmu->evtq.q.q_base, smmu->base + ARM_SMMU_EVTQ_BASE);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 1fe6917448b774..10b3d95d9ee660 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -437,6 +437,12 @@ struct arm_smmu_cmd {
>  #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
>  #define CMDQ_PRI_1_RESP			GENMASK_ULL(13, 12)
>  
> +enum pri_resp {
> +	PRI_RESP_DENY = 0,
> +	PRI_RESP_FAIL = 1,
> +	PRI_RESP_SUCC = 2,
> +};
> +
>  #define CMDQ_RESUME_0_RESP_TERM		0UL
>  #define CMDQ_RESUME_0_RESP_RETRY	1UL
>  #define CMDQ_RESUME_0_RESP_ABORT	2UL
> @@ -475,6 +481,77 @@ enum arm_smmu_cmdq_opcode {
>  	CMDQ_OP_CMD_SYNC = 0x46,
>  };
>  
> +static inline struct arm_smmu_cmd
> +arm_smmu_make_cmd_op(enum arm_smmu_cmdq_opcode op)
> +{
> +	struct arm_smmu_cmd cmd = {};
> +
> +	cmd.data[0] = FIELD_PREP(CMDQ_0_OP, op);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
> +
> +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_prefetch_cfg(u32 sid)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PREFETCH_CFG);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, sid);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_ste(u32 sid, bool leaf)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_STE);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid);
> +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_cd(u32 sid, u32 ssid,
> +							    bool leaf)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_CD);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, sid) |
> +		       FIELD_PREP(CMDQ_CFGI_0_SSID, ssid);
> +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, leaf);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_resume(u32 sid, u16 stag,
> +							   u8 resp)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_RESUME);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, sid) |
> +		       FIELD_PREP(CMDQ_RESUME_0_RESP, resp);
> +	cmd.data[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, stag);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_pri_resp(u32 sid, u32 ssid,
> +							     bool ssv,
> +							     u16 grpid,
> +							     enum pri_resp resp)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_PRI_RESP);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_0_SSV, ssv) |
> +		       FIELD_PREP(CMDQ_PRI_0_SID, sid) |
> +		       FIELD_PREP(CMDQ_PRI_0_SSID, ssid);
> +	cmd.data[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, grpid) |
> +		       FIELD_PREP(CMDQ_PRI_1_RESP, resp);
> +	return cmd;
> +}
> +
>  /* Event queue */
>  #define EVTQ_ENT_SZ_SHIFT		5
>  #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
> @@ -535,12 +612,6 @@ enum arm_smmu_cmdq_opcode {
>  #define MSI_IOVA_BASE			0x8000000
>  #define MSI_IOVA_LENGTH			0x100000
>  
> -enum pri_resp {
> -	PRI_RESP_DENY = 0,
> -	PRI_RESP_FAIL = 1,
> -	PRI_RESP_SUCC = 2,
> -};
> -
>  struct arm_smmu_cmdq_ent {
>  	/* Common fields */
>  	u8				opcode;
> @@ -548,19 +619,6 @@ struct arm_smmu_cmdq_ent {
>  
>  	/* Command-specific fields */
>  	union {
> -		struct {
> -			u32			sid;
> -		} prefetch;
> -
> -		struct {
> -			u32			sid;
> -			u32			ssid;
> -			union {
> -				bool		leaf;
> -				u8		span;
> -			};
> -		} cfgi;
> -
>  		struct {
>  			u8			num;
>  			u8			scale;
> @@ -580,19 +638,6 @@ struct arm_smmu_cmdq_ent {
>  			bool			global;
>  		} atc;
>  
> -		struct {
> -			u32			sid;
> -			u32			ssid;
> -			u16			grpid;
> -			enum pri_resp		resp;
> -		} pri;
> -
> -		struct {
> -			u32			sid;
> -			u16			stag;
> -			u8			resp;
> -		} resume;
> -
>  		struct {
>  			u64			msiaddr;
>  		} sync;
> -- 
> 2.43.0
> 

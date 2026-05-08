Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2105733F8A2
	for <patches@lists.linux.dev>; Fri,  8 May 2026 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778228856; cv=none; b=oG6Se1p2NQS0ra+7NB4Zy53sgTODvK3GZzRXd18g9ZXCreOnWGPcETv3ieWr5oSKQ3y6VIge82G5gjRcA3pPN7s7ixySrvEmSt0qSSeMdESXXI+6hz3gAIkoLkx3X+aiU/spXPE710FLtURKXEg0ik/JH4lku64Xx19HdU0QITY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778228856; c=relaxed/simple;
	bh=TPaZ33vKz8ckmmfqhsRhAsbf/FyT1EBhjrMlFwobtPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKU5jK6TXLWrnM+4fEcsIuC7DBazrok/ZFLmLNbigHsCYB4Wpbcl/qqGrcMahca3FepvITJIL0hvMkCcFAjpOm2UCfRoFQodizEcZUDbPoI4wQasvi3oKcuuPma3jvAihU0JJ6VeeLIIo7k/p+R+Wjt2cF6VkZgMpmeseOp1W8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UoDlhmEp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UoDlhmEp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b46da8c48eso62225ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 01:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778228853; x=1778833653; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TI/RPl3Hg34kw3CTOvuA/w8S/bd5TVv8Y9GL2bltAt8=;
        b=UoDlhmEpo1fpIMNFCiACejj4pIYMiPj2DIk5HmcYa6G8zSsm8fq4wm4+t/aWSvK75v
         5PL+EXP41nyDYvwd5q32CB31cnxr8JrqVUieIjo86urOfUoVsxubMnmn9zQfqdX2Tddr
         YlpHenNLJXvORQh65aWC7K1l7HD6zQSp7xhnjylcb/C3LYN2HICrADU1MSJElSxNKCFE
         HaPo14+H6hx9LIZ80MnUYu+knM9GoeYRvHYoqnTyCxiaV7y4Yo/0DZelCFEpq090g2y+
         5XRWtvmn/k2qJQ8O6UzHKUdrWSMcxaQluuE2zl05ct1Qnx82wDZbV+/0LkDtFf7qeBx8
         DOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778228853; x=1778833653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TI/RPl3Hg34kw3CTOvuA/w8S/bd5TVv8Y9GL2bltAt8=;
        b=F2YRZsTBIfyg6+GdlV0rLMGlmTMO8Cyp7JZQqsmpda962hMZynmXHKlduobWfpJlu3
         zLGWoWTj9vvANEKRlvSNsCFopgMtiV2d+Ng0+OZerLVF570zRXyGeD4ImL/GnG0hoB4s
         hCTqHOvgIs2iXrzi//uaHZjscpdEPdapergwHX6fieYIKNK8gzwRCgcmv64EXyssoei8
         PdTXEZyDo8Ye0N0Bcpucx4YayTx2ls8JYt3HcIriHuYQ9t2ZmdQk4C1n+zWjd4PxgSR4
         MHw2ljGCjFY6fP6xExXLL6PbmofMqasoryer44MsJnrXxE14C+i/qrAkcRmh5N0ENjsM
         mxLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/fKRXeh4uHzGx8bTx8WycAxqmU/g34ThvPo+k1LxKjxdeNwoIv0XgGLyK6zZYaJcbv7jQvyf5M@lists.linux.dev
X-Gm-Message-State: AOJu0YzWAZCkcqNQtuKaUP+CABVugAPvjjLxyR25z6DVxZu9uTakcPQN
	SNmdOdLVoC5WdQiCmjjpeYiObZpiXRIVbUvKAbL5AETruWoN22aviUZktjZKW0cIJA==
X-Gm-Gg: Acq92OEoYmLBc/UI1vgkZwF3ndE2Gt9GUyYFqYeggebpyDzE9jzSeXfMULSsmTlZvrw
	QxKVNFokMVHLcnYBroobzqd5YtCK/C159JkKDyEO63Fwsn/wHeTigb+BCEahJ7grJLOWqhvAaD/
	MMHIgoYiS6zluRJiyVwIG24juNMlz2hS8QDMsz0YdHEFtp4MgOo5p7PMonhrFXrNYy/BgmwUY+G
	bAklcGL5DzWoG4No1XQ/+HW/s5rMEM4futzD4XDZ9MKzvgxj2r05o/4iXPEVUDdo9uFSxDi+7sq
	EmFsiShMc9HCVIoZeLK5b6L2nN0peh5acRUlmGfJYL9jErnj1GNm9vXG6vgWuALTXLrH0eCHrqN
	ChTUWJpzmiv7phT+K5E5tr4IWTjboCDcyAn9sCo5J1FmSdHDEildjOOjyvwkZg10NwvPSpbhd/E
	rKS2LQ2QCZeCurEYwee/pdCEWDr9SpbLlDqNSKwPvr433Yx1tXxQceGR30UFWiPzMZZsRK
X-Received: by 2002:a17:903:94d:b0:2ba:3b89:c3a5 with SMTP id d9443c01a7336-2bae9e68555mr3019705ad.12.1778228852902;
        Fri, 08 May 2026 01:27:32 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1eac3afsm14480765ad.71.2026.05.08.01.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 01:27:32 -0700 (PDT)
Date: Fri, 8 May 2026 08:27:26 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 submission functions
Message-ID: <af2ebtfgOPzJMXFK@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <3-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:12AM -0300, Jason Gunthorpe wrote:
> Continue removing struct arm_smmu_cmdq_ent in favour of the HW based
> struct arm_smmu_cmd. Switch the lower level issue commands to work on
> the native struct by lifting arm_smmu_cmdq_build_cmd() into all the
> callers.
> 
> Following patches will revise each of the arm_smmu_cmdq_build_cmd()
> call sites to replace it with the HW struct.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 53 ++++++++++++---------
>  1 file changed, 30 insertions(+), 23 deletions(-)
> 

[----- >8 ------]

>  /* Should be installed after arm_smmu_install_ste_for_dev() */
> @@ -4823,7 +4826,8 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
>  {
>  	int ret;
>  	u32 reg, enables;
> -	struct arm_smmu_cmdq_ent cmd;
> +	struct arm_smmu_cmdq_ent ent;

This shouldn't be uninitialized, we only seem to be setting ent.opcode
later in the function. Since arm_smmu_cmdq_build_cmd reads other fields
of ent to build the cmd, we are potentially sending stack garbage in ent

At all other places we're correctly initializing ent. So, I believe only
in device_reset we must change it to struct arm_smmu_cmdq_ent ent = {};

> +	struct arm_smmu_cmd cmd;
>  
>  	/* Clear CR0 and sync (disables SMMU and queue processing) */
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
> @@ -4870,16 +4874,19 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
>  	}
>  
>  	/* Invalidate any cached configuration */
> -	cmd.opcode = CMDQ_OP_CFGI_ALL;
> +	ent.opcode = CMDQ_OP_CFGI_ALL;
> +	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  
>  	/* Invalidate any stale TLB entries */
>  	if (smmu->features & ARM_SMMU_FEAT_HYP) {
> -		cmd.opcode = CMDQ_OP_TLBI_EL2_ALL;
> +		ent.opcode = CMDQ_OP_TLBI_EL2_ALL;
> +		arm_smmu_cmdq_build_cmd(cmd.data, &ent);
>  		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  	}
>  
> -	cmd.opcode = CMDQ_OP_TLBI_NSNH_ALL;
> +	ent.opcode = CMDQ_OP_TLBI_NSNH_ALL;
> +	arm_smmu_cmdq_build_cmd(cmd.data, &ent);
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  
>  	/* Event queue */

With ent initialization in device_reset addressed. 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7EE363C6C
	for <patches@lists.linux.dev>; Fri,  8 May 2026 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778226474; cv=none; b=ptUzKZhwO2aaqMAOClOxSU3QHF6+skmoy1jUf/JI3otDqN/hU9uaj0jlXCVrYSvNViGZgKoEjjNZdHju3hl3I/A+qGmN0f2HSoaKZEn91+jA7JbBiJHW2AG+1MMTUc3clKY5h24onvZWnq8WneOUhrE5kDMTU0tPnLgDt+RZgNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778226474; c=relaxed/simple;
	bh=TQkxJTwAMpIhyHALy4TZ9HpXN3wXNYKSPGmWIYgcn9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jl9HveVSuDmcSpogpLJFzecbGrhlBHvzVtjY2rWPPPTihugRy40cm0IcuN46p06uIBTgwMVnxxHXgNZ3kdklTkgjazPFX+pz2h8K8OExhBJbIPifZRD4Xtp0OEDFo5YIgsXlrO7jbTtHMfQrzUUgg0UyLubx5mIdhrciBgKnbQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c04Yd7aC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c04Yd7aC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b46da8c48eso59405ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 00:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778226473; x=1778831273; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BBiPzLiMNb5Ft+ivB2cbnFlSBWl3wYEHINWOHyDQ95Q=;
        b=c04Yd7aCPfJz0drsDrlY5mpGKbRIvD/tDLxlRhWJt1OShxwEFz6rWigdyKgvBPTOdp
         //3GCf9kdOBSxV5MTq1HUO7f9eukQLn8qzccQ3Ud2YdKDb0xq8dW5WEoGE7Pa1yVM0Cb
         uD14mpCM7z3i7qkq1Hid0Q8hYH3bXE7W/yPC6dr/PiMlVXx3/ZAx+eDB/SmsiGTt5uEA
         lXNHqveW85fUDY0nAKu+kf8AoUzRJ6V4NCxyOepVwQi1abk7G6FnJGOmYgmL5Y5A84sA
         jv1DOWdbXR92ppMMttq8S8m2SzyRW86cl9QsDPFwZt7T95mgiVQlv+jUX/mT2hMi6r+6
         mNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778226473; x=1778831273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBiPzLiMNb5Ft+ivB2cbnFlSBWl3wYEHINWOHyDQ95Q=;
        b=WgoKRjcl3g/4mp3Og8vekE8ywWP/+GHYS0FFuNFt3YydM3JZU85BAIC6wJLltXm0HH
         gIihljpe13nqV8iaUtabZH/maouNaTMA8z86DFWQvREhqZDKMll8uqO0tpAiWifux55K
         1x28e7db24Bbff+cjyJNkhBFQpX/uKbzTfcB/ysDTSCR2/sDBYg16hQQiO7qO5i2SSJC
         VAM3hI/tFRt67cs4rQFohowdt/YaWDpQ91qSSDgtGefiH/UJIqR5UMCbSBHpNCA6CgMK
         5jFWIol4QxvY5TEm6PfkAtIQl92l86Y4ywm/TPFuUI+hPCCuhAe8xfopaJlPyM3mCOv1
         y1pQ==
X-Forwarded-Encrypted: i=1; AFNElJ/bNl0mTdU/MI4wkjfUHwdly6qkIaFJ0iBG1Zbbp+Bq8C5j6HxcokitU+q7+9B75zDh9TeWtQnH@lists.linux.dev
X-Gm-Message-State: AOJu0YzhBoUxGBXzyJyUfzuP4xLnA+Z4yBym+M9ZzyO9lOBvgKVbgzZ9
	l6TQJT/hKev+sUQYn5uN2LAbX+cIiH5+u74lZPnS+ZLUd84gyVS7TGiwnyJz3F43bw==
X-Gm-Gg: Acq92OFACzfqPJSWqcA9O7TvG4Z3Q1F1CUwqQbXMQBNv0NvPquqb9IOqV5PlJUkenvJ
	HKTad7jHc+FAddMcqXSUEzeG9jVsAUwKJSeav9PTOF9E566WOOk5Ol3ONuLZ8fdCMZKedRacbYM
	sHEWICXGutXyiILZODDRVev6eJWjnQxh7abMB7jksfrVd+JoD5yOnldywpfSLHqeK6exXBsqSmL
	xmat07rjWN+QksqoIIqP8wtUuteQF+BlxeXiyWKrcRAwtUeAepKf7tGFPOWnvu5DEug3Sxnk54A
	qkJx7EV2mG7+HbDHqD9Pg5MVcHN+PCVXmQVkix98KVynEBr3PdVXKd5Zp8upN25ru83jvpOWt/3
	rKrO9ocX6oziL6pKmqE8QAXiaiqAzNX9BZJ+n3WSlKcYwZH4Ei9g8YM+YkY5l+yYVeZdbZs78dH
	WlmiuEBGXSO9tWE2dH12iZ0lQ4P9+2oLkKsRKndBLhbAC4mjP66WEqY6XYl3TsXC2OjfpM
X-Received: by 2002:a17:902:f7d2:b0:2ba:743d:259a with SMTP id d9443c01a7336-2bae9e6919emr2193705ad.16.1778226472162;
        Fri, 08 May 2026 00:47:52 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965d35b3bsm10490147b3a.24.2026.05.08.00.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 00:47:51 -0700 (PDT)
Date: Fri, 8 May 2026 07:47:45 +0000
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
Subject: Re: [PATCH 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 selection functions
Message-ID: <af2VIXhI0ryEbWn7@google.com>
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

[...]

>  	index = cmds->num * CMDQ_ENT_DWORDS;
> -	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
> -		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> -			 cmd->opcode);
> -		return;
> -	}
> -
> +	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
>  	cmds->num++;
>  }

The memcpy is a temporary step and goes way in Patch 4.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

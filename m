Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913F3E4C80
	for <patches@lists.linux.dev>; Fri,  8 May 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259515; cv=none; b=LHbvXThRFTgayqU/cffWRGP2F699pG/Um5CkTLsGBVF1f5qiABtpC3QOhpwNAznUv26efL2E5A7zaOR3eokohdZqD+PfR8nBsEwN1lMt2TDbyY5GyaStIHdZXAui+pBs4ZxdhIcuoZ9d7SQU6OYbItfhEFQzCGRvHZmIn+qeYfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259515; c=relaxed/simple;
	bh=TXzKoWrdKyhBoDCUbFaxZvqjmPvY5sPeHYgWnhJ8hfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ep8xEbnA9ACjqXFgUrq4324WfEYL4Fl9HKA2aBVL9ddQd1Sn20HqgzL6QW5g66E3nX+vTZQgeOoJXNGLvP8Lbu6TER70V4KN5JEhDVU4ys5ezzeCi65QBBMVekopEHOZSUabFo6d7H84fFQLDrtZi0TMMtFa26d0aCQ20bHCHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ei3CsR4A; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ei3CsR4A"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso725ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 09:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778259513; x=1778864313; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4Q1eWfw8uO06O3f0d5ochR+epxjNtDwxTshSdkC+mc=;
        b=ei3CsR4ASHG7/piZUqjBhBFhr1C1cHNjMfH/P6Sl8/n/LoCJxb+pjCN+FeeOnoh4g/
         DqEg1nU41FbMaA7hpae1SdnVTEsQZuZBqsYPZ5ne2Z1WBvJQ/t1tvozeLq6AjPEfQm47
         uA+PqEzfuTc+dnyz1wmyo6uFULJLvjlBEGDfrp9eWGk4YrXU1oW1/zkHOnPwUFqTNpea
         qnzWxAeNycrMjQeeOvgdg1AUAh7c3zoBThCuPsYAaNzx+Eo5bB4CBn/jJHLQuuR6ISkV
         bUrCm7Gy9yoihibwvp+vb3/J0kH8+9I01Lk/kqt0XK6tmb0j52WZamHi5lMnUFR/ol3e
         n3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259513; x=1778864313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4Q1eWfw8uO06O3f0d5ochR+epxjNtDwxTshSdkC+mc=;
        b=EabN3bn6OQVS8Jqda1JA9LDLpceIywzVaI7RXWtfV3JsmZJtHobMa+oleyMWABehFu
         tyANwphWQLwd9G9RNB17jId/Boc+XrL91k0k9UX7ZQZCYtiD+weE+TCXYVjW5dgtW1g/
         w50TxJayVY3iYTEHPZWSD8rERNQ3hyUj+JBRakCkv7f4SB1a8iU56ILcmcS5GJZTYA82
         zFwRWFa9jHVFo+O9VGACrt7bPW31PV+5opVXwZd6N/qJUAazBGcCBUakt32ODWPDmHvb
         zfeyCCgGfnJNJr25cXu3fsWAxEekkT4qnZcJ+Mvy9x4gZIYNemJGBQWIDq77lYSl4n1B
         B9TQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ivclGH8AJacdKiLFbr2hMLDRIKnSzx1Vj6iO9NR64m/C4VAXnLwfxRKBhizSS1eC0hymqh0QU@lists.linux.dev
X-Gm-Message-State: AOJu0YyNGr2bSVRP58AWHmxH++0Gi37YvReN0eKwmzHDHjDmy5p5rhTS
	Xc2j0FpWKpGgp4rInf/4DMr/N0FRQ31ZHWZiYvSUO9+TPONoeh1Oq5+/6n5EeBe5LA==
X-Gm-Gg: Acq92OH8toY0uzRtHmxPj3mXfu+cIhcULP+D+kaJEFWqSt177ELtHzQ48n9PdsRhzAL
	lqUxR11HXR+Zo8DkRXDcQA6BFWUOMpEuzxkuaR2iCKrzzDXN9Bbc5CWhgekZLi7dIk4j3kHH6L5
	X08pvltcs4eWWwrJcOFSvVVBKkkZbyg+dVQzz4B5uRRG0z8J4xpxX0w/OIsxxYc+nLho9weSp6O
	XpeYU8DpjAgthqeY/vN5dWQGDl+/duHdX3qS9qadZ0U1RDb5CTUuPHsCdsM8ZnewxqtPKWUxEcn
	EcpEU0XxPFrTJEaM2wXDLXzOm1AtR2Nzy7Qr6hbC0cYSD5+MYRyR8hClPbF9CaK4uZ8Lc+S1KlB
	io7EDxbpSHqx4IxLpInbjgTFoJxn+ulnS1eQzDo+KUo1csgcKy/pM2TscMdPSloyqjhjcvZlshf
	7I8BaFlZTarPWH2e4cFbv0FVLkjmK6nPj9b27I0ElCe928+ddYi+K+izJXdH4xV+TxC4js
X-Received: by 2002:a17:902:da87:b0:2ba:f71:57a8 with SMTP id d9443c01a7336-2bae9e663eamr3999045ad.10.1778259512872;
        Fri, 08 May 2026 09:58:32 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2700dsm29924885ad.2.2026.05.08.09.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 09:58:31 -0700 (PDT)
Date: Fri, 8 May 2026 16:58:25 +0000
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
Message-ID: <af4WMaG8sSJeNkb2@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2VIXhI0ryEbWn7@google.com>
 <20260508155432.GE9254@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508155432.GE9254@nvidia.com>

On Fri, May 08, 2026 at 12:54:32PM -0300, Jason Gunthorpe wrote:
> On Fri, May 08, 2026 at 07:47:45AM +0000, Pranjal Shrivastava wrote:
> > On Fri, May 01, 2026 at 11:29:11AM -0300, Jason Gunthorpe wrote:
> > > Start removing the use of struct arm_smmu_cmdq_ent, starting at the
> > > lower levels of the call chain. Change the functions that determine what
> > > cmdq to issue the batch to into using struct arm_smmu_cmd directly.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 47 ++++++++++++-------
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ++--
> > >  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 ++--
> > >  3 files changed, 38 insertions(+), 25 deletions(-)
> > 
> > [...]
> > 
> > >  	index = cmds->num * CMDQ_ENT_DWORDS;
> > > -	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
> > > -		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> > > -			 cmd->opcode);
> > > -		return;
> > > -	}
> > > -
> > > +	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
> > >  	cmds->num++;
> > >  }
> > 
> > The memcpy is a temporary step and goes way in Patch 4.
> 
> To be clear patch 4 still has the memcpy:
> 
> -	index = cmds->num * CMDQ_ENT_DWORDS;
> -	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
> -	cmds->num++;
> +	cmds->cmds[cmds->num++] = cmd;
>                            ^^^^^^^^^^^
> 
> The compiler just builds it.
> 
> The flow evolution is:
> 
> Now:
>  struct arm_smmu_cmdq_ent (stack) -> arm_smmu_cmdq_build_cmd (batch) -> memcpy (queue)
> Here:
>  struct arm_smmu_cmdq_ent (stack) -> arm_smmu_cmdq_build_cmd (stack) -> memcpy (batch) -> memcpy (queue)
> Done:
>  struct arm_smmu_cmd (stack) -> memcpy (batch) -> memcpy (queue)
> 
> So the net result is the same before/after this series, we just carry
> an extra stack copy till the last patch.

Right that makes sense. N

Thanks,
Praan

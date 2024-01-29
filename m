Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA50A6F09C
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 20:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706561333; cv=none; b=YAiZt32L/UwUB0W+SH5EWj/ef/mqsPIWaFbgOm3tHSkAz328WSX60PvNiOi59qBovPu1MgBCHjOBcliwzBp+KiEpp7fz9YCZ4a6B6koVV0+yDlraKqrUbxUc6amNx6p5tuE5lFwXWBYQ4XqXfJlr/T60rL/RlZQ89/IGAwZD08E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706561333; c=relaxed/simple;
	bh=B1MBniST+Sbm632DxSlCrgPWJ+R8kBkamS8NNRHZp2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH7jKJz8KARvUKT2J/M8DxkM4CyulIHEJMds3mjRycBvOmjuTn1m7NHXGpJwitPQVzYe4/JeT3G+3o7Aqtn6wD+57g/p+txgNNGEKmNT41aOmerOThqH1v8qLOuMEq5O8pZeZjFvvhKPVZr6lkD2qC0JPUYbFnqbM/k5bjVb9o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yEffboQ/; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yEffboQ/"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40eb95cbe52so765e9.1
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 12:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706561330; x=1707166130; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3F5GnN+/IUcj+Z4ZqTBAvOJiZgoZ51JVzcjoKvSrxe4=;
        b=yEffboQ/3z+W22N22WTT3gALJYTgkU5pf0JwBt99aLXN5uFECascZtk9elyzcJ3bMq
         u3y0WD84caUIWLCc9Yifvd5N8o3KEkKmUWrVHzLPF+hgJThu1VdZtCbrnASrNl9e+kou
         HqP8OlW6ujC/wEqizKtev6yNanoAw1Ia/hLkhtJzS2E2jk80KiyUzppkHGcd3lIelO0Z
         mlhH4blOWNIZrxrT3ygCI1pdR/a2nnxDzvcnRDBtkMpYWeEvde95H0KfAqF4hqc/tp4V
         rMq+rWvZa+jEzIqjyewlB1i/h2AYE03V0pqGW9ZfiWLEgkmHjqSt19228D5Rp/k0/ahu
         8CrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706561330; x=1707166130;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3F5GnN+/IUcj+Z4ZqTBAvOJiZgoZ51JVzcjoKvSrxe4=;
        b=fnog46TmGQHgXDk/t+ZlblVYpzRPrYUzF2+vikBUpJb59wV7h35TjCNmDtyVXvzwx3
         LvbxWo+GluGU0mNTOE5MRLERkjDiUmUvhgohPF8KcUb8TvXQOR/XsZrJ8uqD0/OREh9Y
         LyoIVXl+HKCS0fIPCqY+Ik3YBTZA3/pgkHYtugks9jJlOs0z/ssgGSUCC0iGoMp6Nkb7
         dqds63qNBEf0hpUYzcIhRsFuUpz5mjrLy8Xugn5EcKFLF1IXVcAva/19jdjKR8wI4Baq
         MEhgywpraqTYRdCXkM7rQWsP2d6rlqShSaavPypHHF0uaM4d4ltwgz6iapa53BVrqaKr
         d7xw==
X-Gm-Message-State: AOJu0YzUIcHgpYRjxCO4zwfcMfEOS3z4VpJG5duMGwZsZgWHho0tTjGy
	J3F471kC8+kp7+dcXC4l5HnnBbaEFpZarO9qjuqV1oxn7JQ4gBy+3kazl2tX1Q==
X-Google-Smtp-Source: AGHT+IHMWYdgXgD2GKGEzHM894wvJ2P8FKS33Rz60s4bE7e1Ubef8mLiFyC5armNDk7XxF9hl+mAtw==
X-Received: by 2002:a05:600c:3d8a:b0:40d:87df:92ca with SMTP id bi10-20020a05600c3d8a00b0040d87df92camr33647wmb.3.1706561330024;
        Mon, 29 Jan 2024 12:48:50 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b0040efa513540sm2647263wms.22.2024.01.29.12.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:48:49 -0800 (PST)
Date: Mon, 29 Jan 2024 20:48:45 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <ZbgPLYN30I1V3axi@google.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbf4NyiZtmjslDFf@google.com>
 <20240129194910.GB1455070@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240129194910.GB1455070@nvidia.com>

On Mon, Jan 29, 2024 at 03:49:10PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 29, 2024 at 07:10:47PM +0000, Mostafa Saleh wrote:
> 
> > > Going forward this will use a V=0 transition instead of cycling through
> > > ABORT if a hitfull change is required. This seems more appropriate as ABORT
> > > will fail DMAs without any logging, but dropping a DMA due to transient
> > > V=0 is probably signaling a bug, so the C_BAD_STE is valuable.
> > Would the driver do anything in that case, or would just print the log message?
> 
> Just log, AFAIK.
>  
> > > +static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
> > > +				      const __le64 *target,
> > > +				      const __le64 *target_used, __le64 *step,
> > > +				      __le64 v_bit,
> > I think this is confusing here, I believe we have this as an argument as this
> > function would be used for CD later, however for this series it is unnecessary,
> > IMHO, this should be removed and added in another patch for the CD rework.
> 
> It is alot of code churn to do that, even more on the new version.
> 
> > > +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > > +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
> > > +	case STRTAB_STE_0_CFG_ABORT:
> > > +		break;
> > > +	case STRTAB_STE_0_CFG_BYPASS:
> > > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > > +		break;
> > > +	case STRTAB_STE_0_CFG_S1_TRANS:
> > > +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > > +						  STRTAB_STE_0_S1CTXPTR_MASK |
> > > +						  STRTAB_STE_0_S1CDMAX);
> > > +		used_bits->data[1] |=
> > > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> > > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> > > +		break;
> > AFAIU, this is missing something like (while passing smmu->features)
> > 	used_bits->data[2] |= features & ARM_SMMU_FEAT_NESTING ?
> > 			      cpu_to_le64(STRTAB_STE_2_S2VMID) : 0;
> > 
> > As the SMMUv3 manual says:
> > “ For a Non-secure STE when stage 2 is implemented (SMMU_IDR0.S2P == 1)
> >   translations resulting from a StreamWorld == NS-EL1 configuration are
> >   VMID-tagged with S2VMID when either of stage 1 (Config[0] == 1) or stage 2
> >   (Config[1] == 1) provide translation.“
> > 
> > Which means in case of S1=>S2 switch or vice versa this algorithm will ignore
> > VMID while it is used.
Yes, In that case we would consider S2VMID even for stage-1 instances only,
even though it should never change and in that case the algorithm will have
the same steps. I guess it might still look confusing, but no strong opinion.

> 
> Ah, yes, that is a small miss, thanks. I don't think we need the
> features test though, s2vmid doesn't mean something different if the
> feature is not present..
> 
> > > +static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
> > > +			       struct arm_smmu_ste *ste,
> > > +			       const struct arm_smmu_ste *target)
> > > +{
> > > +	struct arm_smmu_ste target_used;
> > > +	int i;
> > > +
> > > +	arm_smmu_get_ste_used(target, &target_used);
> > > +	/* Masks in arm_smmu_get_ste_used() are up to date */
> > > +	for (i = 0; i != ARRAY_SIZE(target->data); i++)
> > > +		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
> > In what situation this would be triggered, is that for future proofing,
> > maybe we can move it to arm_smmu_get_ste_used()?
> 
> Yes, prevent people from making an error down the road.
> 
> It can't be in ste_used due to how this specific algorithm works
> iteratively
> 
> And in the v4 version it still wouldn't be a good idea at this point
> due to how the series slowly migrates STE and CD programming
> over. There are cases where the current STE will not have been written
> by this code and may not pass this test.
> 
> Thanks,
> Jason

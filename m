Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29572212B2B
	for <patches@lists.linux.dev>; Thu,  1 May 2025 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746136007; cv=none; b=ddSJkVo7orFWuMkNgzlGWtMbZ1ntuYSUTAHtVGr3VIvbh3/bxc08iKn//ozhHFGWpGqtfjLVBXJGZ9Zh3ghgwO71IsNEBCM1PQeciNDJgHPV6JXIsRGFu5hH735aZgNBJLE4rgPQUPQdkDQ++2eC0GqHVLavP7c5gQ9EAB4PYmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746136007; c=relaxed/simple;
	bh=zREa4RUqnytl3tRJyZ1VEkek+EoTDe7j9JuQy8pDoNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsgojBHGPD3EJTLD7BTYIgyffMfLckVGBa1pMGF1kBKA9kaS2T/Yg2q3y5syBxwQnAVu6ylvghuV6sPoWBd/W6xNnGbqjgxQcPgfbB808UGeNP2ZyUbwROH+7qocFwwn+j0xfak7RwRmhZ7LsJWPKhy10qFS1jPevb9HicNi4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KC6Q3W66; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KC6Q3W66"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240aad70f2so60705ad.0
        for <patches@lists.linux.dev>; Thu, 01 May 2025 14:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746136004; x=1746740804; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9r6A8pjeBdT9CIMooiOuLDzT6g9hy9vPLljDSfADzUo=;
        b=KC6Q3W66jqf/0X1SthWpV0T3eOVln0fhabGMnmOTtGrjaacCodwQccGuRFAvBqBe0C
         BR1EM2Kn5xmZ+AFrLmo4+SYQe50URKczfpODsrRDZb0eP7fZeNtBdxHcBxIm3XdDFFY4
         VKDVZozRNw9pSpt3LhB3R1i3rw/4uzhI+QGLp/leAtcBvYVLNhoAfDwAVj5qj94bpSrK
         xo/LEQHwTYTBFPFJ+iy96egzEspljLG4KVpWdL6U7MORsvaCJ/2iVUnLmrV7XDGo4h5T
         IVmAqKlNC8dRXhG7TMJ25I31TQ768D4U05Pdo68Xo2EI+MsrigyEGTqI4qBQyNiE3n/T
         l6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746136004; x=1746740804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r6A8pjeBdT9CIMooiOuLDzT6g9hy9vPLljDSfADzUo=;
        b=vshIXt67SWnulqeHYH3nuvNXgHAj+DpWBLy7ubuOkM25GLBX5pbMREkMtjCeK8R5xH
         cmQOjbORJdWVARXrUl/0CmGxMNUmiOP+fkB6CO0ud7Z1hx4x9oPBxEaAUtoe+o+cXUx2
         9JBPtXlD3jPz+nhrn6mP2xUCw75Si3nW6+GR/hQB9ullm7u94bkHoeBTks5yS+UkAM3a
         oEpNT6ono5DBxT/Z84IbZdYabffuMWCcLOc82CCa++1Y0uGurRW8/CYUoOJ1b4Aa7c0T
         UhTiwuorPoHuYX3mqhdwZOQD0+iL/t5P+hgHN7NHQMk4+gBkiqNryUbxE8pdut17Z0kd
         9xEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOk5uN4+aGwOjCoAo/2NZRnRwBv/FxExDlEKDt8gDTiLAlcZbuKTfqYm4jJJhIunGEohQu2GTA@lists.linux.dev
X-Gm-Message-State: AOJu0YypcJQBV0dFbBOhQZNmqH1R5NCllFEF/hywjuNdrnuIZQM+ujXX
	C8idhjN8qdFWpmCoyzcqgmAD0PY6IsTf0C95LHBTUJLb3Ymwd8v5L5TbOcZm+A==
X-Gm-Gg: ASbGncvPIBK9nHSAKrTA6ryMTUMzGmFi2ackfy6zmHmM9HqJCswRRO0HVMDhMBZIqSy
	xzws6BhdBBxSAXLxB2Myk4qmUKs5NTYO6z3C7T2muYiKo4q5jdZjoBPkNPD/hK6S+HQUYxA80ZI
	Veo/SiyK9rG9SMKPBPbuxS6KTu7nCC2Oyow0qqGQY/junjw27Pu3Qe2jVFimnamrkcW8MuOpG6z
	w+H86VmzSrzQYFtaA+lgKTV8XLGLwMp7eYEyj0QKri7KJG8RF3Te+hBKbkz30oxaPe0cr3Bl3Rb
	sOlPmdLJHAUT21XbdveTgzTzgzArGvi9Kc5cF7F6qvACOItitDiN5acjp3ys86RQVGktYvoA
X-Google-Smtp-Source: AGHT+IFwvKnjZtLoQ4bY59+1gUvZDTEb4mowMJ0K70YKwsiOKp0lgYtmDTG0AdFCxAuctUKRuXVbug==
X-Received: by 2002:a17:902:db02:b0:21f:631c:7fc9 with SMTP id d9443c01a7336-22e03c81070mr3938175ad.0.1746136004118;
        Thu, 01 May 2025 14:46:44 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa8611424sm129648a12.73.2025.05.01.14.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 14:46:43 -0700 (PDT)
Date: Thu, 1 May 2025 21:46:32 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 21/22] iommu/tegra241-cmdqv: Add user-space use support
Message-ID: <aBPruHaehW4yU-ez@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <b81b2332f793a9ffccc528d821f2ed3ac051f9e0.1745646960.git.nicolinc@nvidia.com>
 <aBKdMaFLPFJYegIS@google.com>
 <aBKmk6PNFreeyfLh@Asurada-Nvidia>
 <aBLGUby2dIiYCe7S@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBLGUby2dIiYCe7S@Asurada-Nvidia>

On Wed, Apr 30, 2025 at 05:54:41PM -0700, Nicolin Chen wrote:
> On Wed, Apr 30, 2025 at 03:39:22PM -0700, Nicolin Chen wrote:
> > On Wed, Apr 30, 2025 at 09:59:13PM +0000, Pranjal Shrivastava wrote:
> > > >  enum iommu_viommu_type {
> > > >  	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
> > > >  	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
> > > > +	IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV = 2,
> > > > +};
> > > 
> > > This is a little confusing.. I understand that we need a new viommu type
> > > to copy the new struct iommu_viommu_tegra241_cmdqv b/w the user & kernel
> > > 
> > > But, in a previous patch (Add vsmmu_alloc impl op), we add a check to
> > > fallback to the standard type SMMUv3, if the impl_ops->vsmmu_alloc 
> > > returns -EOPNOTSUPP:
> > > 
> > > 	if (master->smmu->impl_ops && master->smmu->impl_ops->vsmmu_alloc)
> > > 		vsmmu = master->smmu->impl_ops->vsmmu_alloc(
> > > 			master->smmu, s2_parent, ictx, viommu_type, user_data);
> > > 	if (PTR_ERR(vsmmu) == -EOPNOTSUPP) {
> > > 		if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> > > 			return ERR_PTR(-EOPNOTSUPP);
> > > 		/* Fallback to standard SMMUv3 type if viommu_type matches */
> > > 		vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
> > > 					     &arm_vsmmu_ops);
> > > 
> > > Now, if we'll ALWAYS try to allocate an impl-specified vsmmu first, even
> > > when the viommu_type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3, we are anyways
> > > going to return back from the impl_ops->vsmmu_alloc with -EOPNOTSUPP.
> > 
> > That's not necessarily true. An impl_ops->vsmmu_alloc can support
> > IOMMU_VIOMMU_TYPE_ARM_SMMUV3 potentially, e.g. an impl could just
> > toggle a few special bits in a register and return a valid vsmmu
> > pointer.
> > 
> > It doesn't work like this with VCMDQ as it supports its own type,
> > but for the long run I think we should pass in the standard type
> > to impl_ops->vsmmu_alloc too.
> > 
> > > Then we'll again check if the retval was -EOPNOTSUPP and re-check the
> > > viommu_type requested.. which seems a little counter intuitive.
> > 
> > It's just prioritizing the impl_ops->vsmmu_alloc. Similar to the
> > probe, if VCMDQ is missing or encountering some initialization
> > problem, give it a chance to fallback to the standard SMMU.
> 
> I changed to this and it should be clear now:
> 
> +       /* Prioritize the impl that may support IOMMU_VIOMMU_TYPE_ARM_SMMUV3 */
> +       if (master->smmu->impl_ops && master->smmu->impl_ops->vsmmu_alloc)
> +               vsmmu = master->smmu->impl_ops->vsmmu_alloc(
> +                       master->smmu, s2_parent, ictx, viommu_type, user_data);
> +       if (PTR_ERR(vsmmu) == -EOPNOTSUPP) {
> +               /* Otherwise, allocate an IOMMU_VIOMMU_TYPE_ARM_SMMUV3 here */
> +               if (viommu_type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> +                       vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu,
> +                                                    core, &arm_vsmmu_ops);
> 

This looks good! Thanks!

> Thanks
> Nicolin

Praan

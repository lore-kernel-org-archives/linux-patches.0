Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC5145FEA
	for <patches@lists.linux.dev>; Sat, 27 Apr 2024 22:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714256386; cv=none; b=D1Yho8mHtfaPwignkwj08Tnf/F64/6rS9VcF8dbG4ZvffH1wE0+USLUmVvO2WIdhyS77HLydEp7qCY8lNcfTjgfBK2uCOWyUKZo20MeNZrqGhn3mHMa9iOb8qLKqlfgLK8d1I4oEx49PU/15UjtZsySHT6XfdHg0yKmX/OrIQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714256386; c=relaxed/simple;
	bh=zt+W3q+Hvk19yWapYFFCiZ+hsTgrOUeWeyvEmbZm2Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2QRvNOoF9FEgsc2mWvwfI4BNw4xv04GBRB4W9fZKCKe5xNKi37V10S/88JpCucKmfKV0rmdrxERBU0BErb7We47lY4OqJWAD9S1NrSgqQNKSQ+qcaHwZRQkpHZOnv0WjshVZeL7VKGgkYLR89rZx7L+OXVfH4YmKI8sJEjbBrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QAPq51ZN; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QAPq51ZN"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5188f5dd62dso1533e87.0
        for <patches@lists.linux.dev>; Sat, 27 Apr 2024 15:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714256382; x=1714861182; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h3EqdV1cLUjuhm5Iq+lAUnqb4b0RY2+WR64uEdCo72o=;
        b=QAPq51ZN5WhY+fg31Ls0NY5Q9XE0px31NkKqtce1Xk86XZ3Cg4QJJzQisF3GkutG5w
         9hEVGRwKRvW7504E8hBcqu7f4QZLjW4GDmccuYwDCSnDYWl9wpjI0rnnRmtSM74EL03A
         gsn7V0il+fqKU0EVFUyylttFRKXv4AR62y7R2XSUzFfXuUPUNsygzFCPAvGaENAKFp7m
         5yZrHu6q8TnbAS1DPAqK2vJACeZNqY5y72Zk8GW3fvqNJOa0XDcOPqI3AwxJXPILLLkt
         RBWYcoYflXPe8m/+l05qwXOuwE1WOvX/HNBIxWnE3NUJp7YV0HDsEmx9egi4AVtTCVs/
         R31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714256382; x=1714861182;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h3EqdV1cLUjuhm5Iq+lAUnqb4b0RY2+WR64uEdCo72o=;
        b=vjZKTbTpNekQe/6iKBNDycbIkOwhOYMAw3lnSsmDYetPb2tK6YEmhO4KxAOECHe5/z
         05et+8wcW1fNp7Qg5kYjPuuFQhkERQbt3MgIMfAYA52TK8ZhKeZofaeo7gjsaNylaYlN
         Y3UrJC+BuFKGOGMudq4PE4aFoDr85YtpAPAQ+nJeKlJY0s/XHiHC+SePAN6RV27HYBzI
         e5kXCKHAnNOFE7DakfWSyZj8Y4BiblNed2lT3aG7x4kiSrO9LFjtbXU9saKRO1CsscpI
         Vlo3bAysr8qUroU8TS3k5aflNQ9qh877TuNQQS6uLKMPA9XN1qzzWXwm4Iov3PmhL2Va
         TLcA==
X-Forwarded-Encrypted: i=1; AJvYcCU9kMGyxfey2/cOQj+9nxY16md2XN1ShGfI2B7hisTtm7JgrdrRbCPoqC3WJlFxoqpqi2a4OAODW8386zHSpbYGAfeAxeQODQ==
X-Gm-Message-State: AOJu0YziOwWBUU397qHVbYN6yTTPmZCQAPiwPitMHYAn42YA+cTfQ3+X
	bhTreheUyJ/AHmSKgYVW+8x1A4BEKxXHMcMLs2XdpXdDtJEgagVGBzMkNcE9sA==
X-Google-Smtp-Source: AGHT+IG+6yrjzRA8FcBXQd6yCX5t+zowVD9Nanhc4t+NuiGe4rpqSbSc/uueQ2J/GTaL2DXAlYJ6wg==
X-Received: by 2002:a19:e048:0:b0:51d:68cb:e505 with SMTP id g8-20020a19e048000000b0051d68cbe505mr11781lfj.4.1714256382275;
        Sat, 27 Apr 2024 15:19:42 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id l7-20020adffe87000000b0034c7330da82sm4130390wrr.80.2024.04.27.15.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 15:19:41 -0700 (PDT)
Date: Sat, 27 Apr 2024 22:19:37 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Message-ID: <Zi15-dcNj6E0k4jK@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLerRK1pXvt-HML@google.com>
 <20240422142053.GD49823@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240422142053.GD49823@nvidia.com>

On Mon, Apr 22, 2024 at 11:20:53AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 19, 2024 at 09:14:21PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Apr 16, 2024 at 04:28:16PM -0300, Jason Gunthorpe wrote:
> > > Only the attach callers can perform an allocation for the CD table entry,
> > > the other callers must not do so, they do not have the correct locking and
> > > they cannot sleep. Split up the functions so this is clear.
> > > 
> > > arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
> > > doing any kind of allocation.
> > > 
> > > arm_smmu_alloc_cd_ptr() will allocate the table and any required
> > > leaf.
> > > 
> > > A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
> > > once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
> > > called in the wrong context.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
> > >  1 file changed, 39 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index f3df1ec8d258dc..a0d1237272936f 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -98,6 +98,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
> > >  
> > >  static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
> > >  				    struct arm_smmu_device *smmu);
> > > +static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
> > >  
> > >  static void parse_driver_options(struct arm_smmu_device *smmu)
> > >  {
> > > @@ -1207,29 +1208,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> > >  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> > >  					u32 ssid)
> > >  {
> > > -	__le64 *l1ptr;
> > > -	unsigned int idx;
> > >  	struct arm_smmu_l1_ctx_desc *l1_desc;
> > > -	struct arm_smmu_device *smmu = master->smmu;
> > >  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> > >  
> > > +	if (!cd_table->cdtab)
> > > +		return NULL;
> > > +
> > >  	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
> > >  		return (struct arm_smmu_cd *)(cd_table->cdtab +
> > >  					      ssid * CTXDESC_CD_DWORDS);
> > >  
> > > -	idx = ssid >> CTXDESC_SPLIT;
> > > -	l1_desc = &cd_table->l1_desc[idx];
> > > -	if (!l1_desc->l2ptr) {
> > > -		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> > > -			return NULL;
> > > +	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
> > 
> > These operations used to be shift and bit masking which made sense as it does
> > what hardware does, is there any reason you changed it to division and modulo?
> > I checked the disassembly and gcc does the right thing as constants are power
> > of 2, but I am just curious.
> 
> I generally prefer the clarity and succinctness of / and % instead of
> hacking up bit operations that the compiler will generate
> automatically anyhow.
> 
> If bit extractions should be used it is better to wrap it in
> FIELD_GET() than open code it..
> 
> > > +static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
> > > +						 u32 ssid)
> > > +{
> > > +	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> > > +	struct arm_smmu_device *smmu = master->smmu;
> > > +
> > > +	if (!cd_table->cdtab) {
> > > +		if (arm_smmu_alloc_cd_tables(master))
> > > +			return NULL;
> > >  	}
> > > -	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
> > > -	return &l1_desc->l2ptr[idx];
> > > +
> > > +	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
> > > +		unsigned int idx = ssid >> CTXDESC_SPLIT;
> > 
> > Ok, now it’s a shift, I think we should be consistent with how we
> > calculate the index.
> 
> Sure. Change that to / will make CTXDESC_SPLIT unused except in
> computing CTXDESC_L2_ENTRIES so that can be simplified too:
> 
> -#define CTXDESC_SPLIT                  10
> -#define CTXDESC_L2_ENTRIES             (1 << CTXDESC_SPLIT)
> +#define CTXDESC_L2_ENTRIES             1024
> 

Sounds good, I don’t think it matters much as long as its consistent, but
anyway the split is defined by the spec to be either 6, 8 or 10.
So split size has to be a power of 2.

> 
> > > @@ -1357,7 +1380,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
> > >  	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
> > >  		return -E2BIG;
> > >  
> > > -	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> > > +	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
> > 
> > The only path allocates the main table is “arm_smmu_attach_dev”,
> 
> There are two places that allocate the leaf, arm_smmu_attach_dev()
> (for the RID) and arm_smmu_sva_set_dev_pasid() (for a PASID)
> 
> At this moment all the paths are relying on the above to allocate the
> leaf. The next patch makes arm_smmu_attach_dev() allocate the leaf
> itself. A few more patches also makes the PASID path allocate the leaf
> itself, when the above is removed.
> 
> > I guess it would be more robust to leave that as is and have 2
> > versions of get_cd, one that allocates leaf and one that is not
> > allocating, what do you think?
> 
> I'm not sure what you are asking? We have two versions. One is called
> alloc and one is called get. That have different locking requirements
> on the caller so they have different names. I would not call them both
> get?
> 

My point is that arm_smmu_alloc_cd_ptr() doesn’t only allocate the leaf,
but also the L1 through arm_smmu_alloc_cd_tables()

IMO, arm_smmu_alloc_cd_ptr() should only allocate leafs. And inside
arm_smmu_attach_dev() it calls arm_smmu_alloc_cd_tables().
This makes it clear which path is expected to allocate the L1 table.

And arm_smmu_get_cd_ptr() will remain as is.

Thanks,
Mostafa

> Thanks,
> Jason

Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4051D541
	for <patches@lists.linux.dev>; Sat, 17 Feb 2024 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708172777; cv=none; b=bzzhI7KvOuEcmtJ7mt1/jABToigMuY+tENzH5DajRtYN8mUE1sALG60DYvDZu5FV5A70CtWNXeQx3R77dWdOATNLbyJ5LpA8I0qUoxNxkOL8uI78kBJ+ou+5GqmYiJUG7+9zfmuCjWCfClgWIIQMwP6N13nRnFSCOZfOyCzAElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708172777; c=relaxed/simple;
	bh=pbynjLr3v6Fu0Qo/w6J/hwBSBa5Zq41dmFhrUrNa1jY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=giFm+/gwXV3mWOGK+BMSkddTBbTxqlYAPM/s/rRaLTDXTvzUb2CwNGhZA6DiPhljx+WJ6RbPpmgydsnDtIYukqFkkybsjmEYO7q8WGWayFlW1WP0QEsS+fouHErSmGBPem3RDiBE+iPnFE/D91HNke5hUUj22c0mEognYhKRZD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1z5afRn; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1z5afRn"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-42dd91764bfso101641cf.1
        for <patches@lists.linux.dev>; Sat, 17 Feb 2024 04:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708172774; x=1708777574; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXCKScGIQDtTbQCtATFjsyGo/97nxn13IC2ARMA3nrE=;
        b=F1z5afRnhMd5L3w//B7CsE1J9+ikyBhTXFV/xgIKzWuaB1QigU7Re7B7RkS1gvcUap
         QdaX1+Zqmwr+PmpzrVy7Sam3R07S1LgUWTCV8f0vLesoV/dhX56koTmbZ4JtAk5N+WzT
         ZEnT+QcFT43yat1gzpar71GVED/K/hpZz4UN8k1ODD4mx4Tm0fWlcm+YAhMgBrQRc2ZF
         8tLuyDLGVyFTgwVxiBnphBRxMf563JESOdIFcu8Ytj7rB0yW4ZDaAs6N2O15XVAhvC8W
         d9Tmrw561oijn0/qxAzBzrtzS+0LMLy/ZZvKegaEr82llXpVh4A2hqIww1RDieIeQCC1
         k1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708172774; x=1708777574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXCKScGIQDtTbQCtATFjsyGo/97nxn13IC2ARMA3nrE=;
        b=v6vH15cXEwWja9Km+9DSLdGt5poGbrB6vtYLkKx2vLu2LyiFyQdu9T/pEmjI1mO0BM
         YN/Aq/x38sVsdWyMQ36jGhfcd67qZcjPShcgQ6k9Vf92f7+I2+ApOhCmqrAI/vtYKd4Q
         vZJiefayCIPA9H9QMQsLzBAZkteU+bH3W4onh9OHwf5sRTTK8sVmn9+4wvzSMUpi76+B
         rFng7dCs5dL1Xo3kpJXe8phWF4Mmd8Kh8zuVJgdt5djkVcxeN0UARsbZ3Atw7/zFQyb6
         Um5slL8lEV5LmFg/7Nb6i3+e3ptWNdBjFaWHTZYZxwVAoL6tD7jVfrSaGAskb3eet4Tv
         +CPA==
X-Forwarded-Encrypted: i=1; AJvYcCUb3sGp8HPL6V1IrTr0SEDkEQmBuchjQzilXBtuQMPKOy9ttvCuj2Ju5RStmCgcfjSq6PS2du1zVIs8RfVsupSNtFdbyLc7/g==
X-Gm-Message-State: AOJu0Yw1OAq8RBfLjAdgGfIS8KA0aFSMfWTbymLbGPozaCTDD1JSlwLW
	6nsna+vaUpjN8ART6s+vY8jQe0VhIWkUY2kRJV7uja9wEfG627gfvRFwdG0Ge02bZVqqnuqNrUF
	fK3EgkN+Y82Tjanne1RF2O/hGvsfBO+9ITlbe
X-Google-Smtp-Source: AGHT+IHTJ0MS/huKWjduSflxP8DupD5W3Jd6SRhRbQ5lloQ2ok3kPphtKjPXDOdESYbyg/Nj5ShV0vebCvvbsZYGiA0=
X-Received: by 2002:ac8:5a10:0:b0:42c:77c1:83ac with SMTP id
 n16-20020ac85a10000000b0042c77c183acmr152413qta.6.1708172774089; Sat, 17 Feb
 2024 04:26:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck> <20240216123606.GA13330@nvidia.com>
In-Reply-To: <20240216123606.GA13330@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Sat, 17 Feb 2024 20:25:36 +0800
Message-ID: <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com>
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 8:36=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 16, 2024 at 12:05:12PM +0000, Will Deacon wrote:
> > On Thu, Feb 15, 2024 at 10:56:57AM -0400, Jason Gunthorpe wrote:
> > > If the SMMU is configured to use a two level CD table then
> > > arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> > > GFP_KERNEL. Due to recent changes this is being done under a spinlock=
 to
> > > iterate over the device list - thus it will trigger a sleeping while
> > > atomic warning:
> > >
> > >   arm_smmu_sva_set_dev_pasid()
> > >     mutex_lock(&sva_lock);
> > >     __arm_smmu_sva_bind()
> > >      arm_smmu_mmu_notifier_get()
> > >       spin_lock_irqsave()
> > >       arm_smmu_write_ctx_desc()
> > >     arm_smmu_get_cd_ptr()
> > >          arm_smmu_alloc_cd_leaf_table()
> > >       dmam_alloc_coherent(GFP_KERNEL)
> > >
> > > This is a 64K high order allocation and really should not be done
> > > atomically.
> > >
> > > At the moment the rework of the SVA to follow the new API is half
> > > finished. Recently the CD table memory was moved from the domain to t=
he
> > > master, however we have the confusing situation where the SVA code is
> > > wrongly using the RID domains device's list to track which CD tables =
the
> > > SVA is installed in.
> > >
> > > Remove the logic to replicate the CD across all the domain's masters
> > > during attach. We know which master and which CD table the PASID shou=
ld be
> > > installed in.
> > >
> > > At the moment SVA is only invoked when dma-iommu.c is in control of t=
he
> > > RID translation, which means we have a single iommu_domain shared acr=
oss
> > > the entire group and that iommu_domain is not shared outside the grou=
p.
> > >
> > > For PCI cases the core code also insists on singleton groups so there=
 is
> > > only ever one entry in the smmu_domain->domains list that is equal to=
 the
> > > master being passed in to arm_smmu_sva_set_dev_pasid().
> > >
> > > Only non-PCI cases may have multi-device groups. However, the core co=
de it
> > > self will replicate the calls to arm_smmu_sva_set_dev_pasid() across =
the
> > > entire group so we will still correctly install the CD into each grou=
p
> > > members master.
> >
> > Are you sure about this paragraph? arm_smmu_mmu_notifier_get() will ret=
urn
> > early if it finds an existing notifier in the 'mmu_notifiers' list for =
the
> > domain, so I don't think we'll actually get as far as installing the CD=
,
> > will we?
>
> I think the paragraph is the right analysis, the code just isn't
> listening very well..
>
> Lifting up the arm_smmu_write_ctx_desc() into the caller will fix it.

Calling arm_smmu_write_ctx_desc requires the CD which we get from the
mmu_notifiers list...which makes it a bit more complicated than that.
But it does sound doable with some work (perhaps keeping it in
arm_smmu_mmu_notifier_get for now and changing the early return
logic?).

>
> Also Michael should look at it (I recall we talked about this once)
> and Nicolin should test it.


Just to make sure I follow why we're pursuing this instead of the v1
rc patch: in the non-PCI multidevice group scenario, the first call to
set_dev_pasid would only have pre-allocated for the current master but
arm_smmu_mmu_notifier_get would then still write
arm_smmu_write_ctx_desc to other masters?

>
> BTW, I have no idea if non-PCI cases exists, everyone I know is doing
> PCI SVA.
>
> Jason

Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B343AC0
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 12:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710332031; cv=none; b=SpTJNPor/g/55jEMoHC/xMVe1Ad5TUmJD86jv8erITl0rhq/vnVhP3fHvcqwLxMVstVC0Vvbtmi2380/s6LYkzrFe1cwuLk4TVTxm32bVoSlBi+C6ju/+rq9VoUyv6sxnpjAcku5yt5x3/jptPC25ZUiT1BqnRtbaPIkPDEnKjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710332031; c=relaxed/simple;
	bh=We/AqJo9hlwNvxYiAWT0ji/cHWRTr3rMUnwUD5mg0VY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K3hu8bRALZ2e3Q+/DKerPxkvSUxVYkXQ2At03nN3kCg+dOKyQxUWf0mucViC3wLBppxfrHW5r7BcE72sQGwFazmEejNNSzk85c8HOcn8mRzZJjjn2lJIZDFSPRqJKSGwqw7rKbvrlOtqVDTXjp+jwGXByyg0M2IB7HDV1/WMnHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d8XWacMz; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8XWacMz"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-428405a0205so261281cf.1
        for <patches@lists.linux.dev>; Wed, 13 Mar 2024 05:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710332029; x=1710936829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dq86sGc7kgbDi1Ozz/5XKtC5jE0ZqJpFQ1cl3Fy4Q2Q=;
        b=d8XWacMzyhXkUqY4bL5qYfAzbS3KQ2Nrb0YDbRLrRgBOtvirjBAMaiCLg1YPWUEAMo
         XPXJa/IC4yPa37E4D8qqGbaZ9I94P5tdjIkf/Mgp0ZtsKFZArAdtZbW8T7zOuaU6G2oD
         udzI7lDpYipHhQgJlTYDzYfFnD0dyxW0Z9oEgkFQKzPN3wON6QUvp2FuwISaHh+lnE0A
         RFdxRqUMXNMN32Ut7W3KyPgkYhsOCdO5RYkaqvpJthJqsgVedtBN2kO1s0YDw52mVay6
         8emXojiU61wdwuuaY7UYTMFhU3QtvDk7Gexe1BfLxwIyPr+vLiRquHyKw69lu9BCgsce
         brdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710332029; x=1710936829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dq86sGc7kgbDi1Ozz/5XKtC5jE0ZqJpFQ1cl3Fy4Q2Q=;
        b=MKgUEvE1bPTlFbec+aUAtJ8edKsnVn+HCQ0de7u2fGFww09XTYjItgeM8NSYae4HMt
         W6+0gQ9Xhd6TMB+c7IO+BQ35E896GZT6OtbeSKOVmPD5y1eCGWAC7oIIYAwjuLPIZRwo
         EWmKepTgpyIKlMtpj8u9/H2e3N+RxxpCDvB48nw5w53dZznEPZLT6xzFmjoxaCNaZhXn
         W2alYwYwBpQ4S+WHVYD+8Avw+gzViNGSdVupgE5lqu/5NDLLtO6kpR4sHgwqZJfrCFf2
         WOq9psIDVVJGkjXhTg4LIULUzR3Mq4R30pNUDB3KyorzLMuVsGKw+u/5bwRll828OkNs
         OESQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqjp2QrukRd4PttLQf0kutyvUAJcyXRFur8I2nfdZQC+E2uLGAeoggtUgQZMH78bscIQiiwdm+pz6fc0SnT8S/0jNlA4YpeA==
X-Gm-Message-State: AOJu0Yx+f2KgZHxcpUfmOXf1RwebJfx8MfRPGDBu2+Kzb+xz6ymUNXhj
	Z6Boxn1pLCkHgLF1TthMIE9Shkz9DrQV/v7H7rTUSvTHKWpIGaGxfc5xefc4Hb+w366H1jv0Kx5
	6xMlU10aHbb7qs9vELCAkZcmuCvBoqHxO71C0
X-Google-Smtp-Source: AGHT+IGge+uN95azTWzuq6D12tYisFcwkc/srRJjUzcC3FDQGrB33HBmJxoiURnXIth5SyJ1ogVML4RxH0knsEBSUfo=
X-Received: by 2002:ac8:5198:0:b0:42f:5938:a50 with SMTP id
 c24-20020ac85198000000b0042f59380a50mr237977qtn.23.1710332028711; Wed, 13 Mar
 2024 05:13:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 13 Mar 2024 20:13:12 +0800
Message-ID: <CAKHBV25_FzGHY8zEsXtR=vsTi3k2F8Pm4nY9wYRKudJmnk2LWw@mail.gmail.com>
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move the CD generation for S1
 domains into a function
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 7:44=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain=
,
> and reorganize all the places programming S1 domain CD table entries to
> call it.
>
> Split arm_smmu_update_s1_domain_cd_entry() from
> arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
> chain separate from the unrelated SVA path.
>
> arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
> attached to RIDs and refreshes all their CDs.
>
> Remove the forced clear of the CD during S1 domain attach,
> arm_smmu_write_cd_entry() will do this automatically if necessary.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
>  3 files changed, 75 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index bb9bb6fd7914ce..6acc65f6d00a71 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct ar=
m_smmu_domain *smmu_domain
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  }
>
> +static void
> +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> +{
> +       struct arm_smmu_master *master;
> +       struct arm_smmu_cd target_cd;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +               struct arm_smmu_cd *cdptr;
> +
> +               /* S1 domains only support RID attachment right now */
> +               cdptr =3D arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +               if (WARN_ON(!cdptr))
> +                       continue;
> +
> +               arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> +               arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +                                       &target_cd);
> +       }
> +       spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +}
> +
>  /*
>   * Check if the CPU ASID is available on the SMMU side. If a private con=
text
>   * descriptor is using it, try to replace it.
> @@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
>          * be some overlap between use of both ASIDs, until we invalidate=
 the
>          * TLB.
>          */
> -       arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd)=
;
> +       arm_smmu_update_s1_domain_cd_entry(smmu_domain);

Not to be too nitpicky, but is calling this
arm_smmu_update_s1_domain_cd_entry the right choice here?  Yes the RID
domain has type "ARM_SMMU_DOMAIN_S1", but CDs are also stage 1
translations.

>
>         /* Invalidate TLB entries previously associated with that context=
 */
>         arm_smmu_tlb_inv_asid(smmu, asid);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 3fb4a1523d1d3f..e25dbb982feeee 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1222,8 +1222,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
>         WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>
> -static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *m=
aster,
> -                                              u32 ssid)
> +struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> +                                       u32 ssid)
>  {
>         __le64 *l1ptr;
>         unsigned int idx;
> @@ -1288,9 +1288,9 @@ static const struct arm_smmu_entry_writer_ops arm_s=
mmu_cd_writer_ops =3D {
>         .num_entry_qwords =3D sizeof(struct arm_smmu_cd) / sizeof(u64),
>  };
>
> -static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int =
ssid,
> -                                   struct arm_smmu_cd *cdptr,
> -                                   const struct arm_smmu_cd *target)
> +void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> +                            struct arm_smmu_cd *cdptr,
> +                            const struct arm_smmu_cd *target)
>  {
>         struct arm_smmu_cd_writer cd_writer =3D {
>                 .writer =3D {
> @@ -1303,6 +1303,32 @@ static void arm_smmu_write_cd_entry(struct arm_smm=
u_master *master, int ssid,
>         arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data=
);
>  }
>
> +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> +                        struct arm_smmu_master *master,
> +                        struct arm_smmu_domain *smmu_domain)
> +{
> +       struct arm_smmu_ctx_desc *cd =3D &smmu_domain->cd;
> +
> +       memset(target, 0, sizeof(*target));
> +
> +       target->data[0] =3D cpu_to_le64(
> +               cd->tcr |
> +#ifdef __BIG_ENDIAN
> +               CTXDESC_CD_0_ENDI |
> +#endif
> +               CTXDESC_CD_0_V |
> +               CTXDESC_CD_0_AA64 |
> +               (master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> +               CTXDESC_CD_0_R |
> +               CTXDESC_CD_0_A |
> +               CTXDESC_CD_0_ASET |
> +               FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
> +               );
> +
> +       target->data[1] =3D cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK=
);
> +       target->data[3] =3D cpu_to_le64(cd->mair);
> +}
> +
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
>  {
>         struct arm_smmu_cd target =3D {};
> @@ -2689,29 +2715,29 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
>         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>
>         switch (smmu_domain->stage) {
> -       case ARM_SMMU_DOMAIN_S1:
> +       case ARM_SMMU_DOMAIN_S1: {
> +               struct arm_smmu_cd target_cd;
> +               struct arm_smmu_cd *cdptr;
> +
>                 if (!master->cd_table.cdtab) {
>                         ret =3D arm_smmu_alloc_cd_tables(master);
>                         if (ret)
>                                 goto out_list_del;
> -               } else {
> -                       /*
> -                        * arm_smmu_write_ctx_desc() relies on the entry =
being
> -                        * invalid to work, clear any existing entry.
> -                        */
> -                       ret =3D arm_smmu_write_ctx_desc(master, IOMMU_NO_=
PASID,
> -                                                     NULL);
> -                       if (ret)
> -                               goto out_list_del;
>                 }
>
> -               ret =3D arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &=
smmu_domain->cd);
> -               if (ret)
> +               cdptr =3D arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +               if (!cdptr) {
> +                       ret =3D -ENOMEM;
>                         goto out_list_del;
> +               }
>
> +               arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> +               arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +                                       &target_cd);
>                 arm_smmu_make_cdtable_ste(&target, master);
>                 arm_smmu_install_ste_for_dev(master, &target);
>                 break;
> +       }
>         case ARM_SMMU_DOMAIN_S2:
>                 arm_smmu_make_s2_domain_ste(&target, master, smmu_domain)=
;
>                 arm_smmu_install_ste_for_dev(master, &target);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 87a7b57f566fbc..d32da11058aab6 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -750,6 +750,14 @@ extern struct mutex arm_smmu_asid_lock;
>  extern struct arm_smmu_ctx_desc quiet_cd;
>
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
> +struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> +                                       u32 ssid);
> +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> +                        struct arm_smmu_master *master,
> +                        struct arm_smmu_domain *smmu_domain);
> +void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> +                            struct arm_smmu_cd *cdptr,
> +                            const struct arm_smmu_cd *target);
>
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssi=
d,
>                             struct arm_smmu_ctx_desc *cd);
> --
> 2.43.2
>
Reviewed-by: Michael Shavit <mshavit@google.com>

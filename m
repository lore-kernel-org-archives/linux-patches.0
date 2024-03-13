Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1501CA80
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710329477; cv=none; b=qUWeAU1vxv7zlK4qW/rr8Gy3saZeYbVGug7mvFnUJEgmI/YwJkLiWfPSPu5mnUQxcvz82lsF0g9qVRdtDSXUQxBafuBSUDkmMwkNiKaIVsdKb+n3G9XdmJhuIi1Y0WW/0Cm+hcKHgyR9ITiiZzYN/SijhvRUTlyOuLMarFb/EXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710329477; c=relaxed/simple;
	bh=sU1OLAj7W9StPl+lskGeuuiRXPT9xqAVdrl7NMQRHCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TFf5DaYi1dbqaBKlrUC8+nQAlZkTz6/kUUheaiL3Km5mWiqIphXnSxhtCHDBbmRBTOKR0tUBwTZu40+KBMHRi6qH498poN0tekYRaRfOskha9RTP2sPCZ5QO1IgOmRFsmiMNdjG/9olFknvloPLKOeap0t0PJjRuh89RJxlkKc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IHazhEsK; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IHazhEsK"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-43095dcbee6so49861cf.0
        for <patches@lists.linux.dev>; Wed, 13 Mar 2024 04:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710329474; x=1710934274; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bD45xEK7JUnfoqUmbxEu7GfiQ7GTxbNE69iuOGrjEw=;
        b=IHazhEsKhR7zzzy6SkeR+sPRHpFjj12GtkxzMXyDeg+fwW2EuelPYcsPUOGUSMOfvM
         L8cHouwxBwzKG+X+i/IIzJOOEZZ2eDMke41kPKq7XBwZOicFtYlbpwSkT28eR3M+zbwu
         jIGWdiXtL0dLLF53Oe/gUlkGYXAKauvhIE6YxpqdkGdVnYdqYyYeChzxFCfvmKBNRW+5
         89/UOBnA4JpknIa4YXbMF+zmXKfekP9MbAVZiWB0gIjNLy/NnhDKp9qmhOfnjYa1QV3I
         11w8LHLNFubxJz9uTdVRhzlbhEC90b1n5ur3NUELJ5/oAacZz9XqBi1Spf7jgI7tRoCh
         CSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710329474; x=1710934274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bD45xEK7JUnfoqUmbxEu7GfiQ7GTxbNE69iuOGrjEw=;
        b=i4ex/yee0KEfnZt9OQnDN+EsixewnnD6AutpOgot0UY8HN8Q4JUJoWI8Xw4ZSxLsuV
         LissO+vIAXDOodIx/fsW5FDTihD7aYDYobemC4rQLKKD8sxYK1gg+MCoKIRI9QvG+8O7
         mC1G4WTpvlkV2+/my63T19w7TYixpsOyet0DpjhurDbIcpbc89IyM4Liam+GN10lsNWX
         gZaXdqEmioIJN+EREFSxfrnLyT2E/09XtmVj7w3xS47MV6JuL0FpqTN/Fb5rX7GVEXrz
         48W0BOJhCNJ2MqquijxVPTjhmuVDPBPS3tP3bWaLNpjt/nOZHQAxXvC+IRdHoow3dj03
         JjYg==
X-Forwarded-Encrypted: i=1; AJvYcCXaMxfPPUaswHK4a9TUTIQ1b8ml6yZLYCbkHsuLLDn+hl9M86+k/kkh9pATZVCM7DEj81LPEoPcVjAVYq9bZHaiVNeNMuNfIw==
X-Gm-Message-State: AOJu0YwOz3MmuV6aFtnfIg0mVvgr1r9XA6nhzdVOhezz/OyLwJ2NPoYq
	gCTZphVNbUte/hWoJm4gR7xht9bm6HlrqtYpvblxN24G2IPMpvM2OwIIAkHcv1UeSc19jd1MtLi
	wyTdLUcPkZgHpu0JYBNUBUwDcdK1TTnIMmzwK
X-Google-Smtp-Source: AGHT+IHmU6cCmKwwJehtAZUYrqP1Lw3O5+PG8HyUcGET4mng6mjG9YiDSvKg3MdHCdY9Rzs5EuDAF7cqxcD6b4/W/Z0=
X-Received: by 2002:ac8:740a:0:b0:42f:213a:dc9b with SMTP id
 p10-20020ac8740a000000b0042f213adc9bmr206428qtq.19.1710329473937; Wed, 13 Mar
 2024 04:31:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 13 Mar 2024 19:30:36 +0800
Message-ID: <CAKHBV2745wndqJ9r6XA58dNfS409ZrSW7EP6dP7BRc9ZWcjFyw@mail.gmail.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to the
 STE code
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
> Prepare to put the CD code into the same mechanism. Add an ops indirectio=
n
> around all the STE specific code and make the worker functions independen=
t
> of the entry content being processed.
>
> get_used and sync ops are provided to hook the correct code.
>
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
>  1 file changed, 104 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index c60b067c1f553e..b7f947e36f596f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
>         ARM_SMMU_MAX_MSIS,
>  };
>
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> -                                     ioasid_t sid);
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +       const struct arm_smmu_entry_writer_ops *ops;
> +       struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +       unsigned int num_entry_qwords;
> +       __le64 v_bit;
> +       void (*get_used)(const __le64 *entry, __le64 *used);
> +       void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
>
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] =3D {
>         [EVTQ_MSI_INDEX] =3D {
> @@ -982,43 +994,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *=
smmu, u16 asid)
>   * would be nice if this was complete according to the spec, but minimal=
ly it
>   * has to capture the bits this driver uses.
>   */
> -static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> -                                 struct arm_smmu_ste *used_bits)
> +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>  {
> -       unsigned int cfg =3D FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent-=
>data[0]));
> +       unsigned int cfg =3D FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[=
0]));
>
> -       used_bits->data[0] =3D cpu_to_le64(STRTAB_STE_0_V);
> -       if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +       used_bits[0] =3D cpu_to_le64(STRTAB_STE_0_V);
> +       if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
>                 return;
>
> -       used_bits->data[0] |=3D cpu_to_le64(STRTAB_STE_0_CFG);
> +       used_bits[0] |=3D cpu_to_le64(STRTAB_STE_0_CFG);
>
>         /* S1 translates */
>         if (cfg & BIT(0)) {
> -               used_bits->data[0] |=3D cpu_to_le64(STRTAB_STE_0_S1FMT |
> -                                                 STRTAB_STE_0_S1CTXPTR_M=
ASK |
> -                                                 STRTAB_STE_0_S1CDMAX);
> -               used_bits->data[1] |=3D
> +               used_bits[0] |=3D cpu_to_le64(STRTAB_STE_0_S1FMT |
> +                                           STRTAB_STE_0_S1CTXPTR_MASK |
> +                                           STRTAB_STE_0_S1CDMAX);
> +               used_bits[1] |=3D
>                         cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1C=
IR |
>                                     STRTAB_STE_1_S1COR | STRTAB_STE_1_S1C=
SH |
>                                     STRTAB_STE_1_S1STALLD | STRTAB_STE_1_=
STRW |
>                                     STRTAB_STE_1_EATS);
> -               used_bits->data[2] |=3D cpu_to_le64(STRTAB_STE_2_S2VMID);
> +               used_bits[2] |=3D cpu_to_le64(STRTAB_STE_2_S2VMID);
>         }
>
>         /* S2 translates */
>         if (cfg & BIT(1)) {
> -               used_bits->data[1] |=3D
> +               used_bits[1] |=3D
>                         cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCF=
G);
> -               used_bits->data[2] |=3D
> +               used_bits[2] |=3D
>                         cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VT=
CR |
>                                     STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2=
ENDI |
>                                     STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R=
);
> -               used_bits->data[3] |=3D cpu_to_le64(STRTAB_STE_3_S2TTB_MA=
SK);
> +               used_bits[3] |=3D cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
>         }
>
>         if (cfg =3D=3D STRTAB_STE_0_CFG_BYPASS)
> -               used_bits->data[1] |=3D cpu_to_le64(STRTAB_STE_1_SHCFG);
> +               used_bits[1] |=3D cpu_to_le64(STRTAB_STE_1_SHCFG);
>  }
>
>  /*
> @@ -1027,57 +1038,55 @@ static void arm_smmu_get_ste_used(const struct ar=
m_smmu_ste *ent,
>   * unused_update is an intermediate value of entry that has unused bits =
set to
>   * their new values.
>   */
> -static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
> -                                   const struct arm_smmu_ste *target,
> -                                   struct arm_smmu_ste *unused_update)
> +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer=
,
> +                                   const __le64 *entry, const __le64 *ta=
rget,
> +                                   __le64 *unused_update)
>  {
> -       struct arm_smmu_ste target_used =3D {};
> -       struct arm_smmu_ste cur_used =3D {};
> +       __le64 target_used[NUM_ENTRY_QWORDS] =3D {};
> +       __le64 cur_used[NUM_ENTRY_QWORDS] =3D {};
>         u8 used_qword_diff =3D 0;
>         unsigned int i;
>
> -       arm_smmu_get_ste_used(entry, &cur_used);
> -       arm_smmu_get_ste_used(target, &target_used);
> +       writer->ops->get_used(entry, cur_used);
> +       writer->ops->get_used(target, target_used);
>
> -       for (i =3D 0; i !=3D ARRAY_SIZE(target_used.data); i++) {
> +       for (i =3D 0; i !=3D writer->ops->num_entry_qwords; i++) {
>                 /*
>                  * Check that masks are up to date, the make functions ar=
e not
>                  * allowed to set a bit to 1 if the used function doesn't=
 say it
>                  * is used.
>                  */
> -               WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
> +               WARN_ON_ONCE(target[i] & ~target_used[i]);
>
>                 /* Bits can change because they are not currently being u=
sed */
> -               unused_update->data[i] =3D (entry->data[i] & cur_used.dat=
a[i]) |
> -                                        (target->data[i] & ~cur_used.dat=
a[i]);
> +               unused_update[i] =3D (entry[i] & cur_used[i]) |
> +                                  (target[i] & ~cur_used[i]);
>                 /*
>                  * Each bit indicates that a used bit in a qword needs to=
 be
>                  * changed after unused_update is applied.
>                  */
> -               if ((unused_update->data[i] & target_used.data[i]) !=3D
> -                   target->data[i])
> +               if ((unused_update[i] & target_used[i]) !=3D target[i])
>                         used_qword_diff |=3D 1 << i;
>         }
>         return used_qword_diff;
>  }
>
> -static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
> -                     struct arm_smmu_ste *entry,
> -                     const struct arm_smmu_ste *target, unsigned int sta=
rt,
> +static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entr=
y,
> +                     const __le64 *target, unsigned int start,
>                       unsigned int len)
>  {
>         bool changed =3D false;
>         unsigned int i;
>
>         for (i =3D start; len !=3D 0; len--, i++) {
> -               if (entry->data[i] !=3D target->data[i]) {
> -                       WRITE_ONCE(entry->data[i], target->data[i]);
> +               if (entry[i] !=3D target[i]) {
> +                       WRITE_ONCE(entry[i], target[i]);
>                         changed =3D true;
>                 }
>         }
>
>         if (changed)
> -               arm_smmu_sync_ste_for_sid(smmu, sid);
> +               writer->ops->sync(writer);
>         return changed;
>  }
>
> @@ -1107,17 +1116,15 @@ static bool entry_set(struct arm_smmu_device *smm=
u, ioasid_t sid,
>   * V=3D0 process. This relies on the IGNORED behavior described in the
>   * specification.
>   */
> -static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
> -                              struct arm_smmu_ste *entry,
> -                              const struct arm_smmu_ste *target)
> +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> +                                __le64 *entry, const __le64 *target)
>  {
> -       unsigned int num_entry_qwords =3D ARRAY_SIZE(target->data);
> -       struct arm_smmu_device *smmu =3D master->smmu;
> -       struct arm_smmu_ste unused_update;
> +       unsigned int num_entry_qwords =3D writer->ops->num_entry_qwords;
> +       __le64 unused_update[NUM_ENTRY_QWORDS];
>         u8 used_qword_diff;
>
>         used_qword_diff =3D
> -               arm_smmu_entry_qword_diff(entry, target, &unused_update);
> +               arm_smmu_entry_qword_diff(writer, entry, target, unused_u=
pdate);
>         if (hweight8(used_qword_diff) =3D=3D 1) {
>                 /*
>                  * Only one qword needs its used bits to be changed. This=
 is a
> @@ -1133,22 +1140,21 @@ static void arm_smmu_write_ste(struct arm_smmu_ma=
ster *master, u32 sid,
>                  * writing it in the next step anyways. This can save a s=
ync
>                  * when the only change is in that qword.
>                  */
> -               unused_update.data[critical_qword_index] =3D
> -                       entry->data[critical_qword_index];
> -               entry_set(smmu, sid, entry, &unused_update, 0, num_entry_=
qwords);
> -               entry_set(smmu, sid, entry, target, critical_qword_index,=
 1);
> -               entry_set(smmu, sid, entry, target, 0, num_entry_qwords);
> +               unused_update[critical_qword_index] =3D
> +                       entry[critical_qword_index];
> +               entry_set(writer, entry, unused_update, 0, num_entry_qwor=
ds);
> +               entry_set(writer, entry, target, critical_qword_index, 1)=
;
> +               entry_set(writer, entry, target, 0, num_entry_qwords);
>         } else if (used_qword_diff) {
>                 /*
>                  * At least two qwords need their inuse bits to be change=
d. This
>                  * requires a breaking update, zero the V bit, write all =
qwords
>                  * but 0, then set qword 0
>                  */
> -               unused_update.data[0] =3D entry->data[0] &
> -                                       cpu_to_le64(~STRTAB_STE_0_V);
> -               entry_set(smmu, sid, entry, &unused_update, 0, 1);
> -               entry_set(smmu, sid, entry, target, 1, num_entry_qwords -=
 1);
> -               entry_set(smmu, sid, entry, target, 0, 1);
> +               unused_update[0] =3D entry[0] & (~writer->ops->v_bit);
> +               entry_set(writer, entry, unused_update, 0, 1);
> +               entry_set(writer, entry, target, 1, num_entry_qwords - 1)=
;
> +               entry_set(writer, entry, target, 0, 1);
>         } else {
>                 /*
>                  * No inuse bit changed. Sanity check that all unused bit=
s are 0
> @@ -1156,18 +1162,7 @@ static void arm_smmu_write_ste(struct arm_smmu_mas=
ter *master, u32 sid,
>                  * compute_qword_diff().
>                  */
>                 WARN_ON_ONCE(
> -                       entry_set(smmu, sid, entry, target, 0, num_entry_=
qwords));
> -       }
> -
> -       /* It's likely that we'll want to use the new STE soon */
> -       if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
> -               struct arm_smmu_cmdq_ent
> -                       prefetch_cmd =3D { .opcode =3D CMDQ_OP_PREFETCH_C=
FG,
> -                                        .prefetch =3D {
> -                                                .sid =3D sid,
> -                                        } };
> -
> -               arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +                       entry_set(writer, entry, target, 0, num_entry_qwo=
rds));
>         }
>  }
>
> @@ -1440,17 +1435,58 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct=
 arm_smmu_strtab_l1_desc *desc)
>         WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 =
sid)
> +struct arm_smmu_ste_writer {
> +       struct arm_smmu_entry_writer writer;
> +       u32 sid;
> +};
> +
> +static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer =
*writer)
>  {
> +       struct arm_smmu_ste_writer *ste_writer =3D
> +               container_of(writer, struct arm_smmu_ste_writer, writer);
>         struct arm_smmu_cmdq_ent cmd =3D {
>                 .opcode =3D CMDQ_OP_CFGI_STE,
>                 .cfgi   =3D {
> -                       .sid    =3D sid,
> +                       .sid    =3D ste_writer->sid,
>                         .leaf   =3D true,
>                 },
>         };
>
> -       arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +       arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
> +}
> +
> +static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops =
=3D {
> +       .sync =3D arm_smmu_ste_writer_sync_entry,
> +       .get_used =3D arm_smmu_get_ste_used,
> +       .v_bit =3D cpu_to_le64(STRTAB_STE_0_V),
> +       .num_entry_qwords =3D sizeof(struct arm_smmu_ste) / sizeof(u64),
> +};
> +
> +static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
> +                              struct arm_smmu_ste *ste,
> +                              const struct arm_smmu_ste *target)
> +{
> +       struct arm_smmu_device *smmu =3D master->smmu;
> +       struct arm_smmu_ste_writer ste_writer =3D {
> +               .writer =3D {
> +                       .ops =3D &arm_smmu_ste_writer_ops,
> +                       .master =3D master,
> +               },
> +               .sid =3D sid,
> +       };
> +
> +       arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data)=
;
> +
> +       /* It's likely that we'll want to use the new STE soon */
> +       if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
> +               struct arm_smmu_cmdq_ent
> +                       prefetch_cmd =3D { .opcode =3D CMDQ_OP_PREFETCH_C=
FG,
> +                                        .prefetch =3D {
> +                                                .sid =3D sid,
> +                                        } };
> +
> +               arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +       }
>  }
>
>  static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> --
> 2.43.2
>

Reviewed-by: Michael Shavit <mshavit@google.com>

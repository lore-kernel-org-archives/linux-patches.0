Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E8DB647
	for <patches@lists.linux.dev>; Fri, 26 Jan 2024 04:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706241842; cv=none; b=uqNjMd2IjDPIxICDjIZseoSlgj9JAUPN0SJNJ9q3DY/aybzt/VEz3P8dXJXUBIVIMGSQuWKlC6214D7X7CMv8Y/gzYkrr/+ruQJDHw9uqyEKG08gXB+PiaBkeFe1k9j+ixkOZvB4MXisK3rZVDAW9YKEtasvQ8AsY9JNgD0vFfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706241842; c=relaxed/simple;
	bh=pNeSowuiOkOasW8SVA3I3l9bfQgAKxlivtyedMarNZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hP+91EgS9fVwl/QWHWeOylqc6z2kpJvUb3tDcjq7ux+wyDrCKE3NZhAMHzwJbnjjZq/jL0J8BI0bJJu1q7Sy9EBohhSkgoYjOC1sy/cAkOj3rHjyNKAtgU2RNYHqK/5YkrmwInZqU3F3mLBuW10c8utqqSTlRucJnMZOy2fwlwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OROL/oCI; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OROL/oCI"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-428405a0205so33371cf.1
        for <patches@lists.linux.dev>; Thu, 25 Jan 2024 20:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706241839; x=1706846639; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqC7DeUuP3n7aULFLNSMekUEXN60tWn8C8yc5cFFiPk=;
        b=OROL/oCIbrUasztQqLGbYgMdJTQW0r/n6zITW+HBN1+Vc+8OM9RYy6i66uBWpVvgLT
         Y7vQlFHyW6BVnSG9g6nGIf5Orr8Y3ipVXIaXlJjlquhJV3y5IYYS8AK7t3yHbr2Kpt/J
         urwDDpE6ufM3CMgnMGjijWhfL4Q65+KVtWVZF/SdCIvEJ+BI0jPv6dttLLXjdnHmQy62
         CkBjtZzPKj7IJQlVZwh1q5ahL7pPs5fn7irwdTG2xzSNlPXDBhd1oJb5wmFYnVhEDMS3
         15BxQkHGJOQSCKRnCZvcsjYFNiFYQYviinKR4dS7YjcYQ0yYnIZpjgeSC2o9s77ryRsi
         y4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706241839; x=1706846639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqC7DeUuP3n7aULFLNSMekUEXN60tWn8C8yc5cFFiPk=;
        b=OwTR1KtEx8RJL2c3zzHzw6eqfOVfq2vvNgW6KfGisO4h4F42ptzLdnCfDJiz5XAxn0
         +OTJac/NZEzzVGRVZbTqq4DW3ZEecgT0fhVYX7VkrAidAfxLLmrv0R8PGYXLrg78U/nY
         5cMATAzj1fPJYtyxcXrQYgLB4g9qlbeXxY6YLvjgeRw4GK6jw1J5xc+BHyTO+xEeNWN3
         Hien9nDMqUpQSVNTwW73Eyob3b+cl9Gm6Sju3XS//QwMERrVbGoOZtCHdWXdWMFcGRZN
         zuYOOeDM/qKAGleJKWNStlDcNH+iyjNE4232XO3LYDlwaE27a3aVIpHXNYX7Dis+XN4q
         fCRw==
X-Gm-Message-State: AOJu0Yyi/hooY22pgIY1CVR2L/TS6bptRZjF7k9DHHMxYsVCpI1UsSkX
	mGxZCNikS+TZQuVgj1kIvyrKTU1Do1MD16/89bKqnoYBnWOm3w93Vc+9DZd5KG/lVjTlSmbKzfY
	pgdd+6hO318bPVECWvHCsyGcyRM3c69qw1DAs
X-Google-Smtp-Source: AGHT+IEBm/+kP1vhrpZNIb81M0MQFe5TH4qpmvltcuLC16nw9qDVpsXqbRgJJjFn5RKxyqD4oR1gtR69T9F9xzjNnnM=
X-Received: by 2002:a05:622a:578f:b0:42a:1e75:b8d7 with SMTP id
 eh15-20020a05622a578f00b0042a1e75b8d7mr118712qtb.24.1706241838754; Thu, 25
 Jan 2024 20:03:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com> <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Fri, 26 Jan 2024 12:03:22 +0800
Message-ID: <CAKHBV25Y61kP5jPb0MNv-tXstBjj9pPACgQCztoWk_=R9TdjLQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2024 at 7:57=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.
>
> The iommu core APIs would ideally expect the driver to do a hitless chang=
e
> of iommu_domain in a number of cases:
>
>  - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
>    for the RESV ranges
>
>  - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
>    domain installed. The RID should not be impacted
>
>  - PASID downgrade has IDENTIY on the RID and all PASID's removed.
>    The RID should not be impacted
>
>  - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
>    impacted
>
>  - NESTING -> NESTING for carrying all the above hitless cases in a VM
>    into the hypervisor. To comprehensively emulate the HW in a VM we shou=
ld
>    assume the VM OS is running logic like this and expecting hitless upda=
tes
>    to be relayed to real HW.
>
> For CD updates arm_smmu_write_ctx_desc() has a similar comment explaining
> how limited it is, and the driver does have a need for hitless CD updates=
:
>
>  - SMMUv3 BTM S1 ASID re-label
>
>  - SVA mm release should change the CD to answert not-present to all
>    requests without allowing logging (EPD0)
>
> The next patches/series are going to start removing some of this logic
> from the callers, and add more complex state combinations than currently.
> At the end everything that can be hitless will be hitless, including all
> of the above.
>
> Introduce arm_smmu_write_entry() which will run through the multi-qword
> programming sequence to avoid creating an incoherent 'torn' STE in the HW
> caches. It automatically detects which of two algorithms to use:
>
> 1) The disruptive V=3D0 update described in the spec which disrupts the
>    entry and does three syncs to make the change:
>        - Write V=3D0 to QWORD 0
>        - Write the entire STE except QWORD 0
>        - Write QWORD 0
>
> 2) A hitless update algorithm that follows the same rational that the dri=
ver
>    already uses. It is safe to change IGNORED bits that HW doesn't use:
>        - Write the target value into all currently unused bits
>        - Write a single QWORD, this makes the new STE live atomically
>        - Ensure now unused bits are 0
>
> The detection of which path to use and the implementation of the hitless
> update rely on a "used bitmask" describing what bits the HW is actually
> using based on the V/CFG/etc bits. This flows from the spec language,
> typically indicated as IGNORED.
>
> Knowing which bits the HW is using we can update the bits it does not use
> and then compute how many QWORDS need to be changed. If only one qword
> needs to be updated the hitless algorithm is possible.
>
> Later patches will include CD updates in this mechanism so make the
> implementation generic using a struct arm_smmu_entry_writer and struct
> arm_smmu_entry_writer_ops to abstract the differences between STE and CD
> to be plugged in.
>
> At this point it generates the same sequence of updates as the current
> code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> extra sync (this seems to be an existing bug).
>
> Going forward this will use a V=3D0 transition instead of cycling through
> ABORT if a hitfull change is required. This seems more appropriate as ABO=
RT
> will fail DMAs without any logging, but dropping a DMA due to transient
> V=3D0 is probably signaling a bug, so the C_BAD_STE is valuable.
>
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 328 ++++++++++++++++----
>  1 file changed, 261 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b2e..690742e8f173eb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,6 +48,22 @@ enum arm_smmu_msi_index {
>         ARM_SMMU_MAX_MSIS,
>  };
>
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +       const struct arm_smmu_entry_writer_ops *ops;
> +       struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +       unsigned int num_entry_qwords;
> +       __le64 v_bit;
> +       void (*get_used)(struct arm_smmu_entry_writer *writer, const __le=
64 *entry,
> +                        __le64 *used);
> +       void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> +
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] =3D {
>         [EVTQ_MSI_INDEX] =3D {
>                 ARM_SMMU_EVTQ_IRQ_CFG0,
> @@ -971,6 +987,140 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *=
smmu, u16 asid)
>         arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  }
>
> +/*
> + * Figure out if we can do a hitless update of entry to become target. R=
eturns a
> + * bit mask where 1 indicates that qword needs to be set disruptively.
> + * unused_update is an intermediate value of entry that has unused bits =
set to
> + * their new values.
> + */
> +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer=
,
> +                                   const __le64 *entry, const __le64 *ta=
rget,
> +                                   __le64 *unused_update)
> +{
> +       __le64 target_used[NUM_ENTRY_QWORDS] =3D {};
> +       __le64 cur_used[NUM_ENTRY_QWORDS] =3D {};
> +       u8 used_qword_diff =3D 0;
> +       unsigned int i;
> +
> +       writer->ops->get_used(writer, entry, cur_used);
> +       writer->ops->get_used(writer, target, target_used);
> +
> +       for (i =3D 0; i !=3D writer->ops->num_entry_qwords; i++) {
> +               /*
> +                * Check that masks are up to date, the make functions ar=
e not
> +                * allowed to set a bit to 1 if the used function doesn't=
 say it
> +                * is used.
> +                */
> +               WARN_ON_ONCE(target[i] & ~target_used[i]);
> +
> +               /* Bits can change because they are not currently being u=
sed */
> +               unused_update[i] =3D (entry[i] & cur_used[i]) |
> +                                  (target[i] & ~cur_used[i]);
> +               /*
> +                * Each bit indicates that a used bit in a qword needs to=
 be
> +                * changed after unused_update is applied.
> +                */
> +               if ((unused_update[i] & target_used[i]) !=3D target[i])
> +                       used_qword_diff |=3D 1 << i;
> +       }
> +       return used_qword_diff;
> +}
> +
> +static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entr=
y,
> +                     const __le64 *target, unsigned int start,
> +                     unsigned int len)
> +{
> +       bool changed =3D false;
> +       unsigned int i;
> +
> +       for (i =3D start; len !=3D 0; len--, i++) {
> +               if (entry[i] !=3D target[i]) {
> +                       WRITE_ONCE(entry[i], target[i]);
> +                       changed =3D true;
> +               }
> +       }
> +
> +       if (changed)
> +               writer->ops->sync(writer);
> +       return changed;
> +}
> +
> +/*
> + * Update the STE/CD to the target configuration. The transition from th=
e
> + * current entry to the target entry takes place over multiple steps tha=
t
> + * attempts to make the transition hitless if possible. This function ta=
kes care
> + * not to create a situation where the HW can perceive a corrupted entry=
. HW is
> + * only required to have a 64 bit atomicity with stores from the CPU, wh=
ile
> + * entries are many 64 bit values big.
> + *
> + * The difference between the current value and the target value is anal=
yzed to
> + * determine which of three updates are required - disruptive, hitless o=
r no
> + * change.
> + *
> + * In the most general disruptive case we can make any update in three s=
teps:
> + *  - Disrupting the entry (V=3D0)
> + *  - Fill now unused qwords, execpt qword 0 which contains V
> + *  - Make qword 0 have the final value and valid (V=3D1) with a single =
64
> + *    bit store
> + *
> + * However this disrupts the HW while it is happening. There are several
> + * interesting cases where a STE/CD can be updated without disturbing th=
e HW
> + * because only a small number of bits are changing (S1DSS, CONFIG, etc)=
 or
> + * because the used bits don't intersect. We can detect this by calculat=
ing how
> + * many 64 bit values need update after adjusting the unused bits and sk=
ip the
> + * V=3D0 process. This relies on the IGNORED behavior described in the
> + * specification.
> + */
> +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> +                                __le64 *entry, const __le64 *target)
> +{
> +       unsigned int num_entry_qwords =3D writer->ops->num_entry_qwords;
> +       __le64 unused_update[NUM_ENTRY_QWORDS];
> +       u8 used_qword_diff;
> +
> +       used_qword_diff =3D
> +               arm_smmu_entry_qword_diff(writer, entry, target, unused_u=
pdate);
> +       if (hweight8(used_qword_diff) > 1) {
> +               /*
> +                * At least two qwords need their inuse bits to be change=
d. This
> +                * requires a breaking update, zero the V bit, write all =
qwords
> +                * but 0, then set qword 0
> +                */
> +               unused_update[0] =3D entry[0] & (~writer->ops->v_bit);
> +               entry_set(writer, entry, unused_update, 0, 1);
> +               entry_set(writer, entry, target, 1, num_entry_qwords - 1)=
;
> +               entry_set(writer, entry, target, 0, 1);
> +       } else if (hweight8(used_qword_diff) =3D=3D 1) {
> +               /*
> +                * Only one qword needs its used bits to be changed. This=
 is a
> +                * hitless update, update all bits the current STE is ign=
oring
> +                * to their new values, then update a single "critical qw=
ord" to
> +                * change the STE and finally 0 out any bits that are now=
 unused
> +                * in the target configuration.
> +                */
> +               unsigned int critical_qword_index =3D ffs(used_qword_diff=
) - 1;
> +
> +               /*
> +                * Skip writing unused bits in the critical qword since w=
e'll be
> +                * writing it in the next step anyways. This can save a s=
ync
> +                * when the only change is in that qword.
> +                */
> +               unused_update[critical_qword_index] =3D
> +                       entry[critical_qword_index];
> +               entry_set(writer, entry, unused_update, 0, num_entry_qwor=
ds);
> +               entry_set(writer, entry, target, critical_qword_index, 1)=
;
> +               entry_set(writer, entry, target, 0, num_entry_qwords);
> +       } else {
> +               /*
> +                * No inuse bit changed. Sanity check that all unused bit=
s are 0
> +                * in the entry. The target was already sanity checked by
> +                * compute_qword_diff().
> +                */
> +               WARN_ON_ONCE(
> +                       entry_set(writer, entry, target, 0, num_entry_qwo=
rds));
> +       }
> +}
> +
>  static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>                              int ssid, bool leaf)
>  {
> @@ -1238,50 +1388,123 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struc=
t arm_smmu_strtab_l1_desc *desc)
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
> +/*
> + * Based on the value of ent report which bits of the STE the HW will ac=
cess. It
> + * would be nice if this was complete according to the spec, but minimal=
ly it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(struct arm_smmu_entry_writer *writer,
> +                                 const __le64 *ent, __le64 *used_bits)
>  {
> +       used_bits[0] =3D cpu_to_le64(STRTAB_STE_0_V);
> +       if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +               return;
> +
> +       /*
> +        * If S1 is enabled S1DSS is valid, see 13.5 Summary of
> +        * attribute/permission configuration fields for the SHCFG behavi=
or.
> +        */
> +       if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0])) & 1 &&
> +           FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) =3D=3D
> +                   STRTAB_STE_1_S1DSS_BYPASS)
> +               used_bits[1] |=3D cpu_to_le64(STRTAB_STE_1_SHCFG);
> +
> +       used_bits[0] |=3D cpu_to_le64(STRTAB_STE_0_CFG);
> +       switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]))) {
> +       case STRTAB_STE_0_CFG_ABORT:
> +               break;
> +       case STRTAB_STE_0_CFG_BYPASS:
> +               used_bits[1] |=3D cpu_to_le64(STRTAB_STE_1_SHCFG);
> +               break;
> +       case STRTAB_STE_0_CFG_S1_TRANS:
> +               used_bits[0] |=3D cpu_to_le64(STRTAB_STE_0_S1FMT |
> +                                           STRTAB_STE_0_S1CTXPTR_MASK |
> +                                           STRTAB_STE_0_S1CDMAX);
> +               used_bits[1] |=3D
> +                       cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1C=
IR |
> +                                   STRTAB_STE_1_S1COR | STRTAB_STE_1_S1C=
SH |
> +                                   STRTAB_STE_1_S1STALLD | STRTAB_STE_1_=
STRW);
> +               used_bits[1] |=3D cpu_to_le64(STRTAB_STE_1_EATS);
> +               break;
> +       case STRTAB_STE_0_CFG_S2_TRANS:
> +               used_bits[1] |=3D
> +                       cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCF=
G);
> +               used_bits[2] |=3D
> +                       cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VT=
CR |
> +                                   STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2=
ENDI |
> +                                   STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R=
);
> +               used_bits[3] |=3D cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +               break;
> +
> +       default:
> +               memset(used_bits, 0xFF, sizeof(struct arm_smmu_ste));
> +               WARN_ON(true);
> +       }
> +}
> +
> +static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer =
*writer)
> +{
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
>  static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u3=
2 sid,
>                                       struct arm_smmu_ste *dst)
>  {
> -       /*
> -        * This is hideously complicated, but we only really care about
> -        * three cases at the moment:
> -        *
> -        * 1. Invalid (all zero) -> bypass/fault (init)
> -        * 2. Bypass/fault -> translation/bypass (attach)
> -        * 3. Translation/bypass -> bypass/fault (detach)
> -        *
> -        * Given that we can't update the STE atomically and the SMMU
> -        * doesn't read the thing in a defined order, that leaves us
> -        * with the following maintenance requirements:
> -        *
> -        * 1. Update Config, return (init time STEs aren't live)
> -        * 2. Write everything apart from dword 0, sync, write dword 0, s=
ync
> -        * 3. Update Config, sync
> -        */
> -       u64 val =3D le64_to_cpu(dst->data[0]);
> -       bool ste_live =3D false;
> +       u64 val;
>         struct arm_smmu_device *smmu =3D master->smmu;
>         struct arm_smmu_ctx_desc_cfg *cd_table =3D NULL;
>         struct arm_smmu_s2_cfg *s2_cfg =3D NULL;
>         struct arm_smmu_domain *smmu_domain =3D master->domain;
> -       struct arm_smmu_cmdq_ent prefetch_cmd =3D {
> -               .opcode         =3D CMDQ_OP_PREFETCH_CFG,
> -               .prefetch       =3D {
> -                       .sid    =3D sid,
> -               },
> -       };
> +       struct arm_smmu_ste target =3D {};
>
>         if (smmu_domain) {
>                 switch (smmu_domain->stage) {
> @@ -1296,22 +1519,6 @@ static void arm_smmu_write_strtab_ent(struct arm_s=
mmu_master *master, u32 sid,
>                 }
>         }
>
> -       if (val & STRTAB_STE_0_V) {
> -               switch (FIELD_GET(STRTAB_STE_0_CFG, val)) {
> -               case STRTAB_STE_0_CFG_BYPASS:
> -                       break;
> -               case STRTAB_STE_0_CFG_S1_TRANS:
> -               case STRTAB_STE_0_CFG_S2_TRANS:
> -                       ste_live =3D true;
> -                       break;
> -               case STRTAB_STE_0_CFG_ABORT:
> -                       BUG_ON(!disable_bypass);
> -                       break;
> -               default:
> -                       BUG(); /* STE corruption */
> -               }
> -       }
> -
>         /* Nuke the existing STE_0 value, as we're going to rewrite it */
>         val =3D STRTAB_STE_0_V;
>
> @@ -1322,16 +1529,11 @@ static void arm_smmu_write_strtab_ent(struct arm_=
smmu_master *master, u32 sid,
>                 else
>                         val |=3D FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_=
0_CFG_BYPASS);
>
> -               dst->data[0] =3D cpu_to_le64(val);
> -               dst->data[1] =3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCF=
G,
> +               target.data[0] =3D cpu_to_le64(val);
> +               target.data[1] =3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SH=
CFG,
>                                                 STRTAB_STE_1_SHCFG_INCOMI=
NG));
> -               dst->data[2] =3D 0; /* Nuke the VMID */
> -               /*
> -                * The SMMU can perform negative caching, so we must sync
> -                * the STE regardless of whether the old value was live.
> -                */
> -               if (smmu)
> -                       arm_smmu_sync_ste_for_sid(smmu, sid);
> +               target.data[2] =3D 0; /* Nuke the VMID */
> +               arm_smmu_write_ste(master, sid, dst, &target);
>                 return;
>         }
>
> @@ -1339,8 +1541,7 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
>                 u64 strw =3D smmu->features & ARM_SMMU_FEAT_E2H ?
>                         STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
>
> -               BUG_ON(ste_live);
> -               dst->data[1] =3D cpu_to_le64(
> +               target.data[1] =3D cpu_to_le64(
>                          FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DS=
S_SSID0) |
>                          FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_=
CACHE_WBRA) |
>                          FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_=
CACHE_WBRA) |
> @@ -1349,7 +1550,7 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
>
>                 if (smmu->features & ARM_SMMU_FEAT_STALLS &&
>                     !master->stall_enabled)
> -                       dst->data[1] |=3D cpu_to_le64(STRTAB_STE_1_S1STAL=
LD);
> +                       target.data[1] |=3D cpu_to_le64(STRTAB_STE_1_S1ST=
ALLD);
>
>                 val |=3D (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MAS=
K) |
>                         FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_=
TRANS) |
> @@ -1358,8 +1559,7 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
>         }
>
>         if (s2_cfg) {
> -               BUG_ON(ste_live);
> -               dst->data[2] =3D cpu_to_le64(
> +               target.data[2] =3D cpu_to_le64(
>                          FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>                          FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
>  #ifdef __BIG_ENDIAN
> @@ -1368,23 +1568,17 @@ static void arm_smmu_write_strtab_ent(struct arm_=
smmu_master *master, u32 sid,
>                          STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
>                          STRTAB_STE_2_S2R);
>
> -               dst->data[3] =3D cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3=
_S2TTB_MASK);
> +               target.data[3] =3D cpu_to_le64(s2_cfg->vttbr & STRTAB_STE=
_3_S2TTB_MASK);
>
>                 val |=3D FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2=
_TRANS);
>         }
>
>         if (master->ats_enabled)
> -               dst->data[1] |=3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EAT=
S,
> +               target.data[1] |=3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_E=
ATS,
>                                                  STRTAB_STE_1_EATS_TRANS)=
);
>
> -       arm_smmu_sync_ste_for_sid(smmu, sid);
> -       /* See comment in arm_smmu_write_ctx_desc() */
> -       WRITE_ONCE(dst->data[0], cpu_to_le64(val));
> -       arm_smmu_sync_ste_for_sid(smmu, sid);
> -
> -       /* It's likely that we'll want to use the new STE soon */
> -       if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
> -               arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +       target.data[0] =3D cpu_to_le64(val);
> +       arm_smmu_write_ste(master, sid, dst, &target);
>  }
>
>  static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> --
> 2.43.0
>
Reviewed-by: Michael Shavit <mshavit@google.com>

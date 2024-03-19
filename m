Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59C281216
	for <patches@lists.linux.dev>; Tue, 19 Mar 2024 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710856558; cv=none; b=DPwqONsSHa0ty2++FBPUUgPv72dRmWwCq0N0/xlXw+TOqdA4oK4gxk4a5WmE+1jAjsT9/WOXeX1NNe0Ej9cAxegv8eHLQU85zMEVawIgzgxhZYsQILIqRJPPX2yfsieRbvyyb/nisIbVTURwFKkj/2BsPVkFjkc3xPG45+0dyDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710856558; c=relaxed/simple;
	bh=W9ZNF2CrxO3NZW3pROeuR1/JTBnP+y1usL66jqLiegY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aUcziKof9l7pqDZIABdSRT63HxAXnTSCoPXsTPyfe+zQgabCc+s4IJl32u2q34Sw83FcGvlkaLNu29D60P2Fs2KZZ0K950DmVd1PAytcIJcaiy38dHNkYyBQ0WwFmohChb9XdBvR+nhInV0tc0rERNWcdx0rJc5tSbbvxWjp4dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTGEJLth; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTGEJLth"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-430e1e06e75so374701cf.0
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 06:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710856556; x=1711461356; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usSMlRfKZJ+vVCTW2RgwMTkgCYM15xnSxLC0R1MAmaM=;
        b=RTGEJLthPQ1ERCFdwR9AvF1pZkFqDTXv1ZOVCMnqu+eeo8wo5q+BtdLFt5OslY69/F
         FsYhTZX5hCK13JR9FhnTCEAjT3ME6nVfi/H9NcO7TOwJbWzKvJ0BI74WXWTCaoDzWAT0
         wrpc7+4qnxahi3CXYOsI0giE7DpgPbEJktcJRyqkQmM4cYVOKBQQz9PqeJwhb1kr8roI
         5MPm+fma7MU0q3dqdG0ajZx8Y8kLF8sDoPBHfAicSWtucAHBU56W6X8mWGDN2ZLq0pMr
         uvIlcwUACQMb4AhUS0DZtCi3cnsl9NEW4lLPwnyJxhhOJtZ+BAwk6XiD4HUeAJP2WHF8
         NarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710856556; x=1711461356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usSMlRfKZJ+vVCTW2RgwMTkgCYM15xnSxLC0R1MAmaM=;
        b=kg5qsxg5mMxcZK6lI5BLTVXSC9hlBwP5nq8dtBF1vbl/tNl2EKqOmlbe9vHkSoSPMf
         fmbrJGWgHo3Hgju4j67j9majkWqxj48ZeT4Ek8kbxuZeziUyxyyJIIGwkzLL+FJ8MWis
         Wcq8j1p1ueSek7kp3E63AAwRXoPHcNhupGWiywHWPqRTW4dLI3W0kVbc1+b5KFz2KqZ1
         nraz1Du3ZelxxRgsPQfV+J59pKcHVrq4C+ndu2glUvH2ZsE4URC29fgtmuxYnZpay9m6
         kH3FBHKzCUQulm1otL8NSYVqS0c1WWls+M0/0mpMlYATPV+bNZ2+vHn82jzNz5n6mxsV
         vXJA==
X-Forwarded-Encrypted: i=1; AJvYcCXrso+q504KnF1Q7vklah8xEyUljV8BUV0YroqSx2qI36P3ezrsCTCTHR61kxQxfR8PZ220uMNeQy59aPW0iikfBSptJbzA5A==
X-Gm-Message-State: AOJu0Yy+Y2Y3FC98bJUDxAsMpdH4vFtlDiciIxB6OBmX6IOSi3IDjdjQ
	eOydayWdP5rQKR1nwIEnupnV/XDByzl7crJ6vmmW8oQyXQcx81sGcjBX6smM5+1HFaQKw9RdiGu
	7+W5Lj49XFbYxWbT70vyjFzy5HhJhRgTVUOeB
X-Google-Smtp-Source: AGHT+IHOilf3aE1UVkcT0Evq7fQTS30oWR5RBpMkUmbPHjeSI5Db1aRzMOiQWAl1vTAI0EgFG0kIICxFwuSNhy1SV5U=
X-Received: by 2002:a05:622a:1827:b0:430:d77b:c53f with SMTP id
 t39-20020a05622a182700b00430d77bc53fmr249191qtc.27.1710856555628; Tue, 19 Mar
 2024 06:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <16-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <16-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Tue, 19 Mar 2024 21:55:17 +0800
Message-ID: <CAKHBV26uFZW_=fEyLTZpx_aVVBS-t8mRn30hx+JvyLRtpw0g4g@mail.gmail.com>
Subject: Re: [PATCH v5 16/27] iommu/arm-smmu-v3: Keep track of valid CD
 entries in the cd_table
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
> We no longer need a master->sva_enable to control what attaches are
> allowed.
>
> Instead keep track inside the cd_table how many valid CD entries exist,
> and if the RID has a valid entry.
>
> Replace all the attach focused master->sva_enabled tests with a check if
> the CD has valid entries (or not). If there are any valid entries then th=
e
> CD table must be currently programmed to the STE.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  5 +---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 +++++++
>  3 files changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index ab9de8e36c45f5..82b9c4d4061c3d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -433,9 +433,6 @@ static int __arm_smmu_sva_bind(struct device *dev, st=
ruct mm_struct *mm,
>         if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_S1)
>                 return -ENODEV;
>
I assume this doesn't matter because of subsequent patches, but the
check above could also be removed since used_sid precisely means that
the attached domain is an ARM_SMMU_DOMAIN_S1 domain.

> -       if (!master || !master->sva_enabled)
> -               return -ENODEV;
> -
>         bond =3D kzalloc(sizeof(*bond), GFP_KERNEL);
>         if (!bond)
>                 return -ENOMEM;
> @@ -638,7 +635,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_do=
main *domain,
>         struct mm_struct *mm =3D domain->mm;
>         struct arm_smmu_cd target;
>
> -       if (mm_get_enqcmd_pasid(mm) !=3D id)
> +       if (mm_get_enqcmd_pasid(mm) !=3D id || !master->cd_table.used_sid=
)
>                 return -EINVAL;
>
>         if (!arm_smmu_get_cd_ptr(master, id))
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 26c6b9f6f34fd3..fc19585bf192c6 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1285,6 +1285,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master=
 *master, int ssid,
>                              struct arm_smmu_cd *cdptr,
>                              const struct arm_smmu_cd *target)
>  {
> +       bool target_valid =3D target->data[0] & cpu_to_le64(CTXDESC_CD_0_=
V);
> +       bool cur_valid =3D cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
>         struct arm_smmu_cd_writer cd_writer =3D {
>                 .writer =3D {
>                         .ops =3D &arm_smmu_cd_writer_ops,
> @@ -1293,6 +1295,15 @@ void arm_smmu_write_cd_entry(struct arm_smmu_maste=
r *master, int ssid,
>                 .ssid =3D ssid,
>         };
>
> +       if (cur_valid !=3D target_valid) {
> +               if (cur_valid)
> +                       master->cd_table.used_ssids--;
> +               else
> +                       master->cd_table.used_ssids++;
> +       }
> +       if (ssid =3D=3D IOMMU_NO_PASID)
> +               master->cd_table.used_sid =3D target_valid;
> +
>         arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data=
);
>  }
>
> @@ -2725,16 +2736,6 @@ static int arm_smmu_attach_dev(struct iommu_domain=
 *domain, struct device *dev)
>         master =3D dev_iommu_priv_get(dev);
>         smmu =3D master->smmu;
>
> -       /*
> -        * Checking that SVA is disabled ensures that this device isn't b=
ound to
> -        * any mm, and can be safely detached from its old domain. Bonds =
cannot
> -        * be removed concurrently since we're holding the group mutex.
> -        */
> -       if (arm_smmu_master_sva_enabled(master)) {
> -               dev_err(dev, "cannot attach - SVA enabled\n");
> -               return -EBUSY;
> -       }
> -
>         mutex_lock(&smmu_domain->init_mutex);
>
>         if (!smmu_domain->smmu) {
> @@ -2750,7 +2751,8 @@ static int arm_smmu_attach_dev(struct iommu_domain =
*domain, struct device *dev)
>                 cdptr =3D arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
>                 if (!cdptr)
>                         return -ENOMEM;
> -       }
> +       } else if (arm_smmu_ssids_in_use(&master->cd_table))
> +               return -EBUSY;
>
>         /*
>          * Prevent arm_smmu_share_asid() from trying to change the ASID
> @@ -2825,7 +2827,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_dom=
ain *domain,
>         struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>         struct attach_state state =3D {};
>
> -       if (arm_smmu_master_sva_enabled(master))
> +       if (arm_smmu_ssids_in_use(&master->cd_table))
>                 return -EBUSY;
>
>         /*
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.h
> index 98dc5885c48655..7e1f6af4ce4e79 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -602,11 +602,21 @@ struct arm_smmu_ctx_desc_cfg {
>         dma_addr_t                      cdtab_dma;
>         struct arm_smmu_l1_ctx_desc     *l1_desc;
>         unsigned int                    num_l1_ents;
> +       unsigned int                    used_ssids;
> +       bool                            used_sid;

This probably deserves a comment. There's plenty of places where the
"rid" domain is handled as the CD with ssid 0; but we don't count it
as a used_ssid here.
I also don't find the meaning of used_sid obvious, especially if I
didn't have the context from the commit description.

>         u8                              s1fmt;
>         /* log2 of the maximum number of CDs supported by this table */
>         u8                              s1cdmax;
>  };
>
> +/* True if the cd table has SSIDS > 0 in use. */
> +static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *c=
d_table)
> +{
> +       if (cd_table->used_sid)
> +               return cd_table->used_ssids > 1;
> +       return cd_table->used_ssids;
> +}
> +
>  struct arm_smmu_s2_cfg {
>         u16                             vmid;
>  };
> --
> 2.43.2
>

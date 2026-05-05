Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E28F78C9C
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998918; cv=pass; b=DCJelxPF0cVchrF6LYr6EshD9ruXyw2M98HHmpY/W/FIaIB9OYd93LZFZ0yZx/s3TSUxheSX4lljzn0rlKVBJrfRynfv3kxYsZOIFI7n3qtcTjSPpCpqFwa56QPXVq4Gy6I6Y0M7kV5qdpwq9VKV4PmCHzxdtB/dF/8UsiHh1kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998918; c=relaxed/simple;
	bh=CTonTKixj9AKgBHFu3WR/xrozDujgnWc94kv9TkdB38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msue/HRZGfTUwIl7YacF88DqaEWajBEmkZcX2tPkm/Y4kP8ft41v5PrXIg5wtgnL7DGSD4G2a9pgM+jhjwWFrN/igFNa3EDVFXsZBmRo9J/FLOI8VCjwA4WMpQaCNh+sZrS3Q47nEoNs1RP9/F3vc3mI73k580gIirSveSwttBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=Oer2vdBt; arc=pass smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="Oer2vdBt"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7de7dc85b74so4930227a34.2
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:35:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777998916; cv=none;
        d=google.com; s=arc-20240605;
        b=ep/WYKbm0o5RhToREnKJ529f8uYq7g3nSIZVZ3IctdJW9my3+5AW+/Zw1KzgZ+CD++
         AkwhI4e1hAJ9QHyqDguiKfJfXtjs9ejGc91SzyMTBPJ7Cd1jp8zPu/g2opjPQw/GCrOW
         UbZF02T7io2niLWqZFz5Ht/tzET1GOKnEv219va3CtuHTXk10IGfJ02Adej9dFx1l505
         R2V3pT9UAUUUqo/nGG6F8p16PiUfcdoX1VBmJnOgPl1x3BTWyKottillB6XX8z6ZDaDM
         aPh7lBtzqNebnWd7/q1rnHFdfLsUnfEl99udySWmCHH1F+qZP1x2Dh45diyOwjQFIGr6
         IqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PZwRlD35/Ni4eJ8ZVe6U+Aw5CsKjsJO0tLj7syFGyqI=;
        fh=AlWZKdLkVVNV2mK4GKEW2TaXz8uNtUd9SuoqvpN1VYU=;
        b=MpMktBkLR0GLgO4FMip5JZVtnuqQRx87JBJxF5b8CJ7RPeghywrprkzse4dxFNhj6f
         8Zt0XB4mRVaCNTfEC+dbrpFd5xpx1bpF3qbdPgWmHs26188ZNqOQsVI9BAmO8O2lOeZx
         u8ehtMM7PKSVinlRnKjZFKekHnGvZUw5iYLkNOC58/dawdG3hnULI16VcHc+yLOmAp+/
         Gyb0rWu9fRIQ3ExT937ZJ8f3XZ3qD2k9uwFhHI8CqpB0gdfHAw+7wpmr4v/jUw857kNc
         AEIRCRVV8sNAn/tAt4MP2nUX8gyeDIMC4k2DikpSx88Kqtg4tQaxrSQ6Ypv0jL/9rrdv
         uRGw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1777998916; x=1778603716; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZwRlD35/Ni4eJ8ZVe6U+Aw5CsKjsJO0tLj7syFGyqI=;
        b=Oer2vdBt0EKRS8MSn4UP2PtdZFkDYKByVR4cRiCtmmbPr9sonp7deQgaFPzhwCIHdh
         VN3Fo/3jJ5COInEZGGnuYnkx9yQUNAO13jwb5x5vrdPgieg3C+RWuwBu9KkO/8qOaJwM
         fbQqNTmGQlK9ujZ6eOFGHP12QcGiP+UOV8fqhVk2GsBCcvRDD+UG5qJnpkbt5f9dHu9a
         cMNcal356DIEOZNJqR+14+my95mwDyOXRJH3imj0SwklkwZJqz5CtX/hbkmPmVdjWyxQ
         fridzYBKFPGaVpfu7gUS8ZouDCoUttxx1e5Z7FJEOLf0rX4uDo9d7vY2gqnftR4xOFds
         PAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998916; x=1778603716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PZwRlD35/Ni4eJ8ZVe6U+Aw5CsKjsJO0tLj7syFGyqI=;
        b=m4O6cWD+q6AgxzNyt15dNOrBmKJcN1EbbYVlDMSwLA05s6KJpXOq8B7fHnBPhECzXU
         n7vzkIfBkC/zyDDhJU4RvRA44sFZDvAM1ybs6u6W47vgXB+2uK8jPdoCG6g2v+XxMDJ4
         jUG1z95SOxxlj2ekk3OWTd4oJQ339ZkB8iyEH589aVgzNOq2ztfX5DeR7F2Qfs3I/TcM
         hu9x9lMg/G5sWoVOqrfLujAmDRjN1w5AWJoHTlRM2JCSFngKYqErfrg7HWhas7m4oiWF
         nRWNavUUSsRSJxa5+UQC5YUx3UwtOJQFRqoeQTKeVt7cmKIcEkBmBE9Q1nSso+w7Mqp3
         oQRw==
X-Forwarded-Encrypted: i=1; AFNElJ8IDodkVMzagztjNxLeMSFAXlDARra+OGYqCKg6KOxINk9ev+O79z9y47dzJRsMWN/SKo7yPND+@lists.linux.dev
X-Gm-Message-State: AOJu0YytGWXmkVxpiCAA6ys6BtTldTvXLqN2sgJrYTb8jj4lk3eVZBG9
	k4wPt4cb9XClzNrwlGIkBQmBl1FvKFn8jacxDIJ+qXmt9a1hF93GiZn/JDlx5IXqJvVxuwhr0qA
	71OehDXiBIoMqz9iveEdiOcPnhvlJeu3iT6f51hrEeQ==
X-Gm-Gg: AeBDieszr+49f/61sRWMRB0cx/L5PJ8oJIN+iclOXhk6FmtA7vcb9UQpn/cEMWG1GZK
	fmH5bRUCVTZgIHmdBy3FQHyoMbavNBI1AtDdbUXqLc7oH+Yz23VruzyH0eum8fJBY48idt+Dqof
	LDOox6YoBupKaG/EzVqhKnzBrzxkblBvvwS8gnp3HC0likg1qrJewh9+HFngoqsss86iy5vlGNQ
	AW8h0BfBIOL+NJKK4Pcx9m8lg8+cDGavA5HJM4fE114vxqwXNb8DGWU58QDZp/y2aKUDJyDf2Om
	T2Adr+9Nw6KRR4NQgw==
X-Received: by 2002:a05:6820:f001:b0:696:2cf3:3bc3 with SMTP id
 006d021491bc7-699981ea5efmr81275eaf.41.1777998915996; Tue, 05 May 2026
 09:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com> <6-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <6-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Tue, 5 May 2026 09:35:04 -0700
X-Gm-Features: AVHnY4LPfK7qs4OtHxHKG0TGC_8I0pYYVtUUsANuSQbTNv8bjJdgyf0feiYrb7A
Message-ID: <CAH2o1u4opjWDL8pFTstYVYDbML4_hAgQm1D4NH6rR8=RyG=Vig@mail.gmail.com>
Subject: Re: [PATCH 6/7] iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 8:57=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> Non-leaf invalidation allows the single invalidate command to also
> clear the walk cache. If NL is available, set the NL bit if the
> gather indicates tables have been changed. The stride is already
> calculated properly.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/riscv/iommu-bits.h |  7 +++++++
>  drivers/iommu/riscv/iommu.c      | 12 +++++++-----
>  2 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu=
-bits.h
> index 29a0040b1c32ea..f01b49ac815586 100644
> --- a/drivers/iommu/riscv/iommu-bits.h
> +++ b/drivers/iommu/riscv/iommu-bits.h
> @@ -63,6 +63,7 @@
>  #define RISCV_IOMMU_CAPABILITIES_PD8           BIT_ULL(38)
>  #define RISCV_IOMMU_CAPABILITIES_PD17          BIT_ULL(39)
>  #define RISCV_IOMMU_CAPABILITIES_PD20          BIT_ULL(40)
> +#define RISCV_IOMMU_CAPABILITIES_NL            BIT_ULL(42)
>
>  /**
>   * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
> @@ -473,6 +474,7 @@ struct riscv_iommu_command {
>  #define RISCV_IOMMU_CMD_IOTINVAL_PSCV          BIT_ULL(32)
>  #define RISCV_IOMMU_CMD_IOTINVAL_GV            BIT_ULL(33)
>  #define RISCV_IOMMU_CMD_IOTINVAL_GSCID         GENMASK_ULL(59, 44)
> +#define RISCV_IOMMU_CMD_IOTINVAL_NL            BIT_ULL(34)
>  /* dword1[61:10] is the 4K-aligned page address */
>  #define RISCV_IOMMU_CMD_IOTINVAL_ADDR          GENMASK_ULL(61, 10)
>
> @@ -724,6 +726,11 @@ static inline void riscv_iommu_cmd_inval_set_addr(st=
ruct riscv_iommu_command *cm
>         cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_AV;
>  }
>
> +static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_comma=
nd *cmd)
> +{
> +       cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_NL;
> +}
> +
>  static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_co=
mmand *cmd,
>                                                    int pscid)
>  {
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index fd9c5294dbc082..ea14630430451a 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -966,6 +966,8 @@ static void riscv_iommu_iotlb_inval_iommu(struct risc=
v_iommu_device *iommu,
>                                           int pscid,
>                                           struct riscv_iommu_tlbi *tlbi)
>  {
> +       bool use_nl =3D tlbi->non_leaf &&
> +                     (iommu->caps & RISCV_IOMMU_CAPABILITIES_NL);
>         struct riscv_iommu_command cmd;
>         unsigned long iova;
>         unsigned int i;
> @@ -974,17 +976,17 @@ static void riscv_iommu_iotlb_inval_iommu(struct ri=
scv_iommu_device *iommu,
>         riscv_iommu_cmd_inval_set_pscid(&cmd, pscid);
>
>         /*
> -        * When non-leaf page table entries were changed, the base spec
> -        * requires a full PSCID invalidation (AV=3D0) since there is no
> -        * way to do targeted non-leaf invalidation without the NL
> -        * extension. Force global invalidation to preserve correctness.
> +        * If non-leaf entries were changed and the IOMMU doesn't
> +        * support NL, we must fall back to global invalidation (AV=3D0).
>          */
> -       if (tlbi->single.use_global || tlbi->non_leaf)
> +       if (tlbi->single.use_global || (tlbi->non_leaf && !use_nl))
>                 goto global;
>
>         iova =3D tlbi->start;
>         for (i =3D 0; i < tlbi->single.num; i++) {
>                 riscv_iommu_cmd_inval_set_addr(&cmd, iova);
> +               if (use_nl)
> +                       riscv_iommu_cmd_inval_set_nl(&cmd);
>                 riscv_iommu_cmd_send(iommu, &cmd);
>                 iova +=3D 1ULL << tlbi->single.stride_lg2;
>         }
> --
> 2.43.0
>

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>

Thank you,
- Tomasz

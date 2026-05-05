Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C123B0AE2
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998975; cv=pass; b=Ax8I+InQdCexW0R+4NhSePh5tUv0eeOncYLK/6lCEq9rKu3eSOdOUj4gH6HvIow9LYH3V2uGUCdcvLzIuLFyPx47nGb2jc6mQam6ApemD7n6T2pLRsaNNsZP8tQ7nFVNl88QANecw5Li/8XXpptlfs360wmjtbE/JajFyE2yfX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998975; c=relaxed/simple;
	bh=UFuKXwH3uUk34lhZVYCtQJ9B2E0d9YVtv3RCiQ1zYbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1XyLgQh3bBUaTYx/CjcISNJxK/T96Reg7JJwzQC28Glwy9mKsKTgm6usdrO6P71TIqFHon2epO0ZUW7+jRpqyd/nYSb0NeLWrBQOtRb47DOYjSHPmDzOZcVFvHT/s3tZbWFMiQAjpY6UGAj7ms1MrntukD3AbTpC4og774wg+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=PGcs+7Ea; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="PGcs+7Ea"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dea1272943so3295496a34.0
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:36:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777998973; cv=none;
        d=google.com; s=arc-20240605;
        b=Z52dXXX/O6ps6vtA+N7nntT4QAgiexM6w6MVbBRAIlGr2h55sO2VtvPd1QZNWew88u
         M2PAmI9H1dd08bSRmFOI7DsBqkrE/M/BnKBJASRoJlduEppi9G3oeiGdDrWXXdhIRmMT
         gX38P0bMfW2om18tpR3cgfTSr08Kmpo0N6IR//Thv6WJmV7fbW0LWqZ0AUVlj3QS47yF
         WUGhoaV4nYkLVBfMKvt9WL8tdy/XIJr+YSFdJ1O3sxFZAQW2tTvaBXKwYlqMWmxCrABP
         NxlLxusAqcwZooJd7R78hHcWYOP5Y9ySy5GgkA+Dznwptp412DSJJzyU2IEMnPaMb9ms
         DBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XMwGqdsNVv3aob9cGd1eQz6UK34amfZUCSFO2bXmDok=;
        fh=85mAPZqteGMonrFuvDwenBEbQkpV2na9YMWGcxrARNE=;
        b=IvudVqHID72/Y3FEknmCzw3YdABn9kp5seDZPSHlIaQJ8IAw/Li7hNnha/z7fc7h0K
         JZPhI9PCx8Yd/p8thVvLBoaxqonYp1fqJ6Swr3Q7gSHqvyJgbIjKt1iM07jbReevPmH4
         pZs+Yck4+2s/xyhvdKtzMPkHxYSBNnNIGb+jknNVYuDVfDn5ffui9Khxp5Qv/GeJk7WZ
         aZ1KXgf94Mc8VYysOlYXh19uEQ/eQxiiTY3ipkfQRZq+Ge2WsgUnFmW5IQamJsF5PjSm
         q53E7a0j5Yn3UmQPQ5XORe6C52Qvwa/sa5XCxxwjXEX05S4zlPyq01REFVuHyETede9b
         enZQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1777998973; x=1778603773; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMwGqdsNVv3aob9cGd1eQz6UK34amfZUCSFO2bXmDok=;
        b=PGcs+7EaUhsChHIoOx3Y5DqpLJJmBX1wzZObZEVqtepDqXVIzatBNbuu7a7fj8e00y
         JpnjQU1G4rY9UCsWzmXHyoTn6yAda/BlIKoLkKPR5r19mi5gCtE5x6OZBlkKnFDIQjyD
         mxu8C+FUsUAwMikd6xK4dKvY1jK2HtVbJktDAK2ZgGYsu25qXI7E6isKJPPwUcdLAm0M
         JRq4gte6dI0vi4rdwD1aPSOqWvOMRxeEozchyuLul9M2cj8ECA8AcEd1/AidXJDSImB8
         8IkSk3mYAWGtE+qhkRcqGnpDX6NiiH3QHCX3tLzNXvLXTAvt6v4LZG8S/aoxaQBx1c0y
         qZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998973; x=1778603773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XMwGqdsNVv3aob9cGd1eQz6UK34amfZUCSFO2bXmDok=;
        b=SIbUuXeslmYpMZv3xkomFkQFQAeqdds5ejSv0qxpCYb0m1sW7Suryx64AHZVqmPXR1
         JlLCvYQ/npPoi9evwUOmHgAUVQHcip//dCQWv6yNU1d6TL3MTkMckQxrgF/nbNu8DFMS
         HKiwI8EiZBD4bW8fcyl+Dpu5ueBcT+77NXo9OLmiIZXzLl/onR6tTRApalP2H7TLP7gr
         o6OhijBrwf4zkbVwnFgP3dtmhlKvaJsZydmrnqndqwwosfH5J+w6kRVZxfMqLHlkCad/
         qf92/J89ej+aFeD66jACEAw6hl0OxTYQyNGAyC2GdtSEQQmBlLqqE7kW+N9v/7xwA59J
         A3eg==
X-Forwarded-Encrypted: i=1; AFNElJ9tD1pOpggoE9H0Q3AgBZLt1ttXFObdGnEACWJahB4d2/mmC2nA5HN1ddDXt5Tiu+iBbwS4YPtz@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt1G/MrXIMmtDzqgQinPTBujNiwmXZijpcxY+GYJcgXn6i5bJK
	XIN2L4gRRSW9y5lf/e4m36kwl8Jv4dFZ4h6ezNwTyA6OWjj2hAAeuI2FoSa3Lejgu4yAhOvLIAC
	7EkX6xzM7+1GuVyzpk7UP6M+mxJLS6B0sGBy2486tvQ==
X-Gm-Gg: AeBDiesLrShUJTa4voEZPMs14RwWssXg5ErFXm4o1v1DS/ZM8FWpKjGLdK2DXj3CVL0
	/eTPyrus950QpwxNjUhOS4FxvxkOgEAhlNGB5ovOqpMGlQ6s3NoVQvTT6HRgk1aSEyaSW2LiSEo
	OhMv3HdimUAK+N1DR4YwGpmwe2FrlkNDESWkbQBtwB95zJJ9Yx1hlEiy+X0RU3I7nHhlH+eMwuG
	fbiUdPO17Yia/JA3JsL9xID1DWjN4MBLsvmwHSm0B6sc6QGbQGQOfYP00ZTK71LNRaUUYYV/bMd
	Qf0zmMWUsmQUV5tSrA==
X-Received: by 2002:a05:6820:4df9:b0:692:a19b:af68 with SMTP id
 006d021491bc7-6998a59a01emr1986059eaf.5.1777998973075; Tue, 05 May 2026
 09:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com> <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Tue, 5 May 2026 09:36:02 -0700
X-Gm-Features: AVHnY4KvPh1rW_OXbHCyJsQ0b4w2L_79cfPR7de6IXz-sHUXJfM_liaWTT5PblY
Message-ID: <CAH2o1u4PJSf8epbjLcAD1rojYu2gLVUtgW4kd1J+Cnwzz08PeQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] iommu/riscv: Add NAPOT range invalidation support
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
> Use the RISC-V IOMMU Address Range Invalidation extension
> (capabilities.S, spec section 9.3) to invalidate an IOVA range with
> a single IOTINVAL.VMA command using NAPOT-encoded addressing.
>
> One iommu_iotlb_gather maps to one NAPOT invalidation command. The
> smallest power-of-two aligned range covering the gather is used since
> over-invalidation is always safe.
>
> S and NL seem to be orthogonal in the spec, so if NL is not
> supported then global invalidation is probably always going to happen
> as wiping a large range without a table change is not common.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/riscv/iommu-bits.h | 17 +++++++++++++
>  drivers/iommu/riscv/iommu.c      | 43 +++++++++++++++++++++++++++-----
>  2 files changed, 54 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu=
-bits.h
> index f01b49ac815586..32b3ad3ac9ae59 100644
> --- a/drivers/iommu/riscv/iommu-bits.h
> +++ b/drivers/iommu/riscv/iommu-bits.h
> @@ -64,6 +64,7 @@
>  #define RISCV_IOMMU_CAPABILITIES_PD17          BIT_ULL(39)
>  #define RISCV_IOMMU_CAPABILITIES_PD20          BIT_ULL(40)
>  #define RISCV_IOMMU_CAPABILITIES_NL            BIT_ULL(42)
> +#define RISCV_IOMMU_CAPABILITIES_S             BIT_ULL(43)
>
>  /**
>   * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
> @@ -475,6 +476,7 @@ struct riscv_iommu_command {
>  #define RISCV_IOMMU_CMD_IOTINVAL_GV            BIT_ULL(33)
>  #define RISCV_IOMMU_CMD_IOTINVAL_GSCID         GENMASK_ULL(59, 44)
>  #define RISCV_IOMMU_CMD_IOTINVAL_NL            BIT_ULL(34)
> +#define RISCV_IOMMU_CMD_IOTINVAL_S             BIT_ULL(9)
>  /* dword1[61:10] is the 4K-aligned page address */
>  #define RISCV_IOMMU_CMD_IOTINVAL_ADDR          GENMASK_ULL(61, 10)
>
> @@ -731,6 +733,21 @@ static inline void riscv_iommu_cmd_inval_set_nl(stru=
ct riscv_iommu_command *cmd)
>         cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_NL;
>  }
>
> +/*
> + * Set NAPOT-encoded address for range invalidation (S=3D1).
> + * sz_lg2: log2 of total range in bytes, must be >=3D 13 (8KiB, 2 pages)=
.
> + * addr must be naturally aligned to 2^sz_lg2.
> + */
> +static inline void riscv_iommu_cmd_inval_set_napot(
> +       struct riscv_iommu_command *cmd, u64 addr, unsigned int sz_lg2)
> +{
> +       u64 pfn =3D addr >> 12;
> +
> +       pfn |=3D BIT_U64(sz_lg2 - 13) - 1;
> +       cmd->dword1 =3D FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn);
> +       cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_AV | RISCV_IOMMU_CMD_IO=
TINVAL_S;
> +}
> +
>  static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_co=
mmand *cmd,
>                                                    int pscid)
>  {
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index ea14630430451a..41e26e267a7fd6 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -929,6 +929,10 @@ struct riscv_iommu_tlbi {
>                 u8 stride_lg2;
>                 unsigned int num;
>         } single;
> +       struct {
> +               u8 sz_lg2;
> +               u64 addr;
> +       } range;
>  };
>
>  static void riscv_iommu_tlbi_calc(struct riscv_iommu_tlbi *tlbi,
> @@ -945,9 +949,23 @@ static void riscv_iommu_tlbi_calc(struct riscv_iommu=
_tlbi *tlbi,
>         /* No level information available */
>         if (!combined) {
>                 tlbi->single.use_global =3D true;
> +               tlbi->range.sz_lg2 =3D 0;
>                 return;
>         }
>
> +       /*
> +        * Calculate the smallest NAPOT range containing [start, last].
> +        * NAPOT encoding requires a power-of-two sized, naturally aligne=
d
> +        * range. Over-invalidation is always safe.
> +        */
> +       tlbi->range.sz_lg2 =3D fls64(tlbi->start ^ tlbi->last);
> +       if (unlikely(tlbi->range.sz_lg2 >=3D 64)) {
> +               tlbi->single.use_global =3D true;
> +               tlbi->range.sz_lg2 =3D 0;
> +               return;
> +       }
> +       tlbi->range.addr =3D tlbi->start & ~(BIT_U64(tlbi->range.sz_lg2) =
- 1);
> +
>         /*
>          * Calculate stride from the lowest changed level. RISC-V uses 4K=
iB
>          * granule with 9 bits per level.
> @@ -969,7 +987,6 @@ static void riscv_iommu_iotlb_inval_iommu(struct risc=
v_iommu_device *iommu,
>         bool use_nl =3D tlbi->non_leaf &&
>                       (iommu->caps & RISCV_IOMMU_CAPABILITIES_NL);
>         struct riscv_iommu_command cmd;
> -       unsigned long iova;
>         unsigned int i;
>
>         riscv_iommu_cmd_inval_vma(&cmd);
> @@ -979,16 +996,30 @@ static void riscv_iommu_iotlb_inval_iommu(struct ri=
scv_iommu_device *iommu,
>          * If non-leaf entries were changed and the IOMMU doesn't
>          * support NL, we must fall back to global invalidation (AV=3D0).
>          */
> -       if (tlbi->single.use_global || (tlbi->non_leaf && !use_nl))
> +       if (tlbi->non_leaf && !use_nl)
>                 goto global;
>
> -       iova =3D tlbi->start;
> -       for (i =3D 0; i < tlbi->single.num; i++) {
> -               riscv_iommu_cmd_inval_set_addr(&cmd, iova);
> +       if (iommu->caps & RISCV_IOMMU_CAPABILITIES_S &&
> +           tlbi->range.sz_lg2 >=3D 13) {
> +               riscv_iommu_cmd_inval_set_napot(&cmd, tlbi->range.addr,
> +                                               tlbi->range.sz_lg2);
>                 if (use_nl)
>                         riscv_iommu_cmd_inval_set_nl(&cmd);
>                 riscv_iommu_cmd_send(iommu, &cmd);
> -               iova +=3D 1ULL << tlbi->single.stride_lg2;
> +       } else {
> +               unsigned long iova;
> +
> +               if (tlbi->single.use_global)
> +                       goto global;
> +
> +               iova =3D tlbi->start;
> +               for (i =3D 0; i < tlbi->single.num; i++) {
> +                       riscv_iommu_cmd_inval_set_addr(&cmd, iova);
> +                       if (use_nl)
> +                               riscv_iommu_cmd_inval_set_nl(&cmd);
> +                       riscv_iommu_cmd_send(iommu, &cmd);
> +                       iova +=3D 1ULL << tlbi->single.stride_lg2;
> +               }
>         }
>         return;
>  global:
> --
> 2.43.0
>

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>

Thank you,
- Tomasz

Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B7648C8BB
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998902; cv=pass; b=W2SnlnB4cy1ZPbBMz6QrgR0BAgHrI2cnveBDX0zHgtLdI/5UFEATQ3NGTvl+csSR6srCupkuSaLsXHsOJAolMcXDUpxcCMBUsPyASZ1olYtFgE7piBDMTBXGVSbS+Xdjl0f0Vfporp/P/8IvWMCrYYzTGIccbvhNHeUOBJySVtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998902; c=relaxed/simple;
	bh=CROFyCAkzv4ywS8BdMQC8KdzM2vCDU1JuULLkFtFPYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILS3l3PMesjljCUGbob4eMQn1OPyHllJ8Pjb9jGHBdNH5t+XHoSB8CfbT8fhtr0+gEI2LjgnROTPJtQzds4NpFqS3S4QXsLgcePqZo1rnJuUe5QJGdUoEUEPYzVdCOtqhOu/dRr75u9I0opBBCTeH/vTVjLiGD/CWexH0MohOKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=TyHgMv6e; arc=pass smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="TyHgMv6e"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-42fc6923f38so37124fac.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:34:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777998894; cv=none;
        d=google.com; s=arc-20240605;
        b=FLkZmnpDxmusf57ANroBY3z12jJQ0NAvGFcBXIJr0EQI2vaN6T5DD+HCQbU2/HPeET
         5yjUtsi/xm271xbdXjIZ0QnmwFOwDXpQRKQnC7FTR6EG9sL/tCDU4DrFZnsOOLNNcNrJ
         b6VcosEknCaWn+aTSmkSywKnCHnAE6jAodu603Ko5zJaEzLEjROmIzNgckXUHDItbO13
         1jVLqbKFzHGX+muv8I8EKzDR4nFiCJj6tLqPDTr8gx8TtfczEEGbDJVjdPXarg86gE+8
         WVoFn3hpK9zkv0ueekMvTai08q0aeTo/moe26OOfp+9J1m7GeeuN5mOkkkdmKQyimuoz
         JkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NDO3eiyh9Hz1u3onzFvnQb0LT/Ww16oACcFMq/SSUIc=;
        fh=70gh0AGaETmeRx53MwVO9dUKT3b/GdS/Pgbt7J37l6c=;
        b=QOA2qaLZtjhs0lH925nFou9lDVhEuCdiKJn+HdGn35oMkQHN4MB68sparlqc2JXrYX
         0/r4rkskqgrNX+s0rJD+NklOrWmUuLBJOW73ZeEPxK2w5ez6aESeI1MSwtzAMvrIme13
         WFyJhcukpHbVm8NH8EnL+LLEccnsKvB/6b8TwGXTSh1e1ourT2jA0VyKUoxVW/lTK62x
         r/2slGXN12SK1ANOxV48i5w+8DQe9eFyVjVB4lTPHyTc8WI4vczXrE76GW24UWrgIFkq
         VteI8GCTCIzRFrejdKbwAmzkp6byWUMt3BFcKFlxNj99NqwMt4mhm7spCo2lTFlUTGDN
         qdHw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1777998894; x=1778603694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDO3eiyh9Hz1u3onzFvnQb0LT/Ww16oACcFMq/SSUIc=;
        b=TyHgMv6ePwPvCrlNLNg1VjO8130XJEzNOjoVcNUxloeLYnAwp9YI1Kmd7Vl+RbROmx
         mwPwXU82jRqrQO5IUB41cvjAW5ccnccxx4ciAgMkwBADod6lu5bz8iD/A9D5NA0B/0iR
         dwtNP/BgCyBMnfwX6tYxye1+kzkPOs8Qj/nUHSa+MEenBjF7u8KXH9zB99Ygwv2fJi0D
         xfAxT3vPhP7dd1ecpyywtH6vIOLsH+u7/2remQzmQrcpFjz4DI8TX4innK9LbIq/5t0h
         lBWGORjpLOAW68rN2u4VCzRsdbc3ly0I87HdBrhrFXPf1o/o7rGTxlIvNyuBPW2hnXy4
         63iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998894; x=1778603694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NDO3eiyh9Hz1u3onzFvnQb0LT/Ww16oACcFMq/SSUIc=;
        b=SU0+NDWv6nbt3DEiQj+O07m4oO6hyM61pG4ug4FEvAgaC4Q4kZ+vHjCUutKrPQrHt6
         tqZhBstggW6NPOZUhpvZ72OU0oLH2Fb1hN4iJinZIBSuPrtwibA+ZtqzZUL/87Vspm6M
         EA0OY1aYn913HUcizdidqJAAL4oxPhAg0ey09V50p8jjdX79yy+8y0hn8MIDGhFlyWj9
         rwG5w4pjnfJJDFxLDLQkRYsmhmXmJ23P0Ci66qZVKivo6R8Xr1CYQnUuG1zSvbmW0veS
         wEuCllh4UnQLfVUjFbvcFHLP9XBBq3R+yQAk4t9OGH5vyG1XPVvIiMvkZcxAwR9pMYjT
         YG3w==
X-Forwarded-Encrypted: i=1; AFNElJ9EPNW8uKizp44oiiRhBh26jsrJzjfSQ/fXjs7QZQ8WfDxMlonU2EltOt2Kdzd4fNu3YiQJDt7z@lists.linux.dev
X-Gm-Message-State: AOJu0YwQm9wxoVg3QgJXYJ9SEn0nu3sjHDF9Tcn41AbbP83dcpZu7wrs
	9ioBmsPEDd6u7P2VB9RF7JtPFpM2xXNpzieL++oNF5t/9ssP8dVEKrKoK/kXwv1FFe3qRcFZQlK
	tgrZzaZqlG4BDgGupAm5wC0hDs9cJXSQfZzzOBD4hrQ==
X-Gm-Gg: AeBDiet6BR4bEmms8vMl8TNi6xPfsOuaz/W9h39G54DTWCZvaTByaPGFo1TcmAHVAYT
	0hMwc0AZp6Uay8AhF+n0h6Wqy+R932SyDNLukI9DL83ZdbbwwiGuoJrAKJwDNOWCPQojkPc8zML
	jcgTUBDcHKP5t8fKuSzpxcymsjMJ/9ZdUh1RD96hMkOAK3RKDTJK2QgpIsXQXWFTsKxIJSNhen1
	1RAav7SIkwZDA60Qr4j4F+KCLdVX4Pz4n7qdzJM/ggnQ8x6jy5lTwHxHHUbBnFz0j19QuO8NMKQ
	MpRm3XkzqA9QAxU07Q==
X-Received: by 2002:a05:6820:2b03:b0:693:7a6f:b311 with SMTP id
 006d021491bc7-6989150d84emr1409508eaf.22.1777998892571; Tue, 05 May 2026
 09:34:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com> <5-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <5-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Tue, 5 May 2026 09:34:41 -0700
X-Gm-Features: AVHnY4KmN3zuPOnphRUD3iSyHclk6jkkiTRo8gM7OfuZX2MGnqIi-uGqw8s8o2g
Message-ID: <CAH2o1u6RQBQARdL1VTYTJEb_6tskCizfbHPV=h+413H11RmV8A@mail.gmail.com>
Subject: Re: [PATCH 5/7] iommu/riscv: Compute best stride for single invalidation
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
> Replace the per-page IOTLB invalidation loop with stride-based
> invalidation that uses the level bitmaps from iommu_iotlb_gather.
>
> Pre-calculate the invalidation information before running over the
> bonds loop as it is the same for every entry.
>
> The lowest set bit in the PT_FEAT_DETAILED_GATHER bitmaps indicates
> the stride. This design ignores the SVNAPOT contiguous pages on the
> assumption that they still have to be individually invalidated like
> ARM requires, though it is not clear from the spec.
>
> Replace the 2M cutoff for global invalidation with a 512 command
> limit. This is the same for a 4k stride and now scales with the
> stride size.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/riscv/iommu.c | 103 +++++++++++++++++++++++++-----------
>  1 file changed, 71 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index 556d5dc9c58681..fd9c5294dbc082 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -920,22 +920,58 @@ static void riscv_iommu_bond_unlink(struct riscv_io=
mmu_domain *domain,
>         }
>  }
>
> -/*
> - * Send IOTLB.INVAL for whole address space for ranges larger than 2MB.
> - * This limit will be replaced with range invalidations, if supported by
> - * the hardware, when RISC-V IOMMU architecture specification update for
> - * range invalidations update will be available.
> - */
> -#define RISCV_IOMMU_IOTLB_INVAL_LIMIT  (2 << 20)
> +struct riscv_iommu_tlbi {
> +       u64 start;
> +       u64 last;
> +       bool non_leaf;
> +       struct {
> +               bool use_global;
> +               u8 stride_lg2;
> +               unsigned int num;
> +       } single;
> +};
>
> -static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
> -                                   struct iommu_iotlb_gather *gather)
> +static void riscv_iommu_tlbi_calc(struct riscv_iommu_tlbi *tlbi,
> +                                 struct iommu_iotlb_gather *gather)
> +{
> +       u8 combined =3D gather->pt.leaf_levels_bitmap |
> +                     gather->pt.table_levels_bitmap;
> +       u64 num;
> +
> +       tlbi->non_leaf =3D gather->pt.table_levels_bitmap !=3D 0;
> +       tlbi->start =3D gather->start;
> +       tlbi->last =3D gather->end;
> +
> +       /* No level information available */
> +       if (!combined) {
> +               tlbi->single.use_global =3D true;
> +               return;
> +       }
> +
> +       /*
> +        * Calculate stride from the lowest changed level. RISC-V uses 4K=
iB
> +        * granule with 9 bits per level.
> +        */
> +       tlbi->single.stride_lg2 =3D 9 * __ffs(combined) + 12;
> +       num =3D (tlbi->last - tlbi->start + 1) >> tlbi->single.stride_lg2=
;
> +       if (!num || num > 512) {
> +               tlbi->single.use_global =3D true;
> +       } else {
> +               tlbi->single.num =3D num;
> +               tlbi->single.use_global =3D false;
> +       }
> +}
> +
> +static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iom=
mu,
> +                                         int pscid,
> +                                         struct riscv_iommu_tlbi *tlbi)
>  {
> -       unsigned long start;
> -       unsigned long end;
> -       struct riscv_iommu_bond *bond;
> -       struct riscv_iommu_device *iommu, *prev;
>         struct riscv_iommu_command cmd;
> +       unsigned long iova;
> +       unsigned int i;
> +
> +       riscv_iommu_cmd_inval_vma(&cmd);
> +       riscv_iommu_cmd_inval_set_pscid(&cmd, pscid);
>
>         /*
>          * When non-leaf page table entries were changed, the base spec
> @@ -943,13 +979,28 @@ static void riscv_iommu_iotlb_inval(struct riscv_io=
mmu_domain *domain,
>          * way to do targeted non-leaf invalidation without the NL
>          * extension. Force global invalidation to preserve correctness.
>          */
> -       if (gather->pt.table_levels_bitmap) {
> -               start =3D 0;
> -               end =3D ULONG_MAX;
> -       } else {
> -               start =3D gather->start;
> -               end =3D gather->end;
> +       if (tlbi->single.use_global || tlbi->non_leaf)
> +               goto global;
> +
> +       iova =3D tlbi->start;
> +       for (i =3D 0; i < tlbi->single.num; i++) {
> +               riscv_iommu_cmd_inval_set_addr(&cmd, iova);
> +               riscv_iommu_cmd_send(iommu, &cmd);
> +               iova +=3D 1ULL << tlbi->single.stride_lg2;
>         }
> +       return;
> +global:
> +       riscv_iommu_cmd_send(iommu, &cmd);
> +}
> +
> +static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
> +                                   struct iommu_iotlb_gather *gather)
> +{
> +       struct riscv_iommu_device *iommu, *prev;
> +       struct riscv_iommu_bond *bond;
> +       struct riscv_iommu_tlbi tlbi;
> +
> +       riscv_iommu_tlbi_calc(&tlbi, gather);
>
>         /*
>          * For each IOMMU linked with this protection domain (via bonds->=
dev),
> @@ -990,19 +1041,7 @@ static void riscv_iommu_iotlb_inval(struct riscv_io=
mmu_domain *domain,
>                 if (iommu =3D=3D prev)
>                         continue;
>
> -               riscv_iommu_cmd_inval_vma(&cmd);
> -               riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
> -               if (end - start < RISCV_IOMMU_IOTLB_INVAL_LIMIT - 1) {
> -                       unsigned long iova =3D start;
> -
> -                       do {
> -                               riscv_iommu_cmd_inval_set_addr(&cmd, iova=
);
> -                               riscv_iommu_cmd_send(iommu, &cmd);
> -                       } while (!check_add_overflow(iova, PAGE_SIZE, &io=
va) &&
> -                                iova < end);
> -               } else {
> -                       riscv_iommu_cmd_send(iommu, &cmd);
> -               }
> +               riscv_iommu_iotlb_inval_iommu(iommu, domain->pscid, &tlbi=
);
>                 prev =3D iommu;
>         }
>
> --
> 2.43.0
>

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>

Thank you
- Tomasz

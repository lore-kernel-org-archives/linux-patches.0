Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E391B4224
	for <patches@lists.linux.dev>; Tue, 20 Jan 2026 01:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768872543; cv=pass; b=bbdiaGGl5WsEV3HgdYGO1L6gHN1eYQ2UGEpxGQBaFkE/jzkJ7pxEd6FRjH4Fwt+HRE6UeQcHtEC6bndpGZqucD+qjB6SfS4vb26fRHPxZidY8MoGVMHb9+diiNbAtvnQJVq8s8dCQLbZI0p7x8oeb3CupSmd/rKTBqsP9Kz1P2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768872543; c=relaxed/simple;
	bh=3dkGVxhlv3v+QiJyu/gHqTv/8KLmlaVDmw4fb1D3f2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ehtjnr4xAhrit9jKFMGMM2tNKz1iCmMMtjOnzKI0ACA+brONYHJy/rMfu1hVfuBBiwTXtAZ18kXs3lv9iCEJ3DxM0zU2cKrUUFTHtbfbTI0gHbh3S6cPYkEetsMfWXBnVpWRgDgnT6z+EYJYMaXioO/GeYYB+VCAmT45u74TPyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tv7agioz; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tv7agioz"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50299648ae9so1111601cf.1
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 17:29:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768872540; cv=none;
        d=google.com; s=arc-20240605;
        b=VFcBnBA0oqGdr5sfr5so8w1oTZDWCCeQ3wAy5gbmX34x6yNEE4a8FE1ustpsD+Bu6e
         H0yrncmgzYKwOfqlE1PYqsMEgyY450jf3STQZ5jnfpxomw+Y3TmhSx/JEEGJk9jXUSDa
         HcHO486RbO++6V26assWhLVK5RaijQBkBZkBkUF+EzBPCMLRpyjVCnVQifmchFQqgIux
         uPEjkIdiHzfmJrCwgsYWuJStnGaqBRkL79LchFPEZewxiwO89ZdqnvA1BLdgG9vdPRBb
         irMRHsnxuB9Fmh/pp2g3BRiRZ2JHqCZeR8C9Qv+naYWD+8n67RLCM0fXvR9izdoEiym+
         r0qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ojJn61U4L0laT2frCHxKlurP2cAcK8IkqiWzn71IsC0=;
        fh=dpaa6BJNW7ceVDvFxNGWla2zfppfb0Kaq0DtBhkzN8Y=;
        b=Qjhu0bfjG3wpRu40aEybxCMdc9elrYim5iM6WlR6QOpUN7kqjf/zIXD15AJp7Wt051
         Jr8D1Qy2n/Gm7vSs6eOhqfvSVR+Klqq7WWjdU6q4iMNn59ed9yiMPQYItRC8sOb9xfxh
         p0Y5NM06prhbWyFuRbL4scmAZU/veNKlyFKg0KC4YMQcUCBc8NiFw59LiKIS8F+KklzK
         xLma4p6jaTAWoaNXWly7a7KNRBnvEE/oY3gtuOU5emQvT8sp6ah/eBwoq7zLdXbE7y/U
         4PugR32bRZfVosiaKEN4HEBiCwgMmis4r9OCeLnd84VCB8+xUJd5B8/t80y59D/CoKmk
         62Dg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768872540; x=1769477340; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojJn61U4L0laT2frCHxKlurP2cAcK8IkqiWzn71IsC0=;
        b=Tv7agioze5oTgx+fcU12ygFUWEwfsGg8kzJhUlJAQj2CR1ipytCfMAx3HUxa0/vB4l
         Q8fAdgE4UUlDwlvhGe1Uq/BKZ+IkKK8pzg5/WGwMlcplCoOsBsE5rtRpp9yn3lDawuaC
         gbRM8Vp+Q/6jWdgYkn0ikYNE0gpblLxJg+oGpg7E2V2Tk9bq9ViH9CtXHDIABs2j237S
         JNKyC+6u+cir1AB/Pk4HjnbCIl4yF0tRAtGVsaabsBeqniMbUUk3djcyNe+rIZ8Jmzb8
         wSS71QNw69vveDOgxPSIly7KLy+GlKutrWojh1eYWelJU7xTDoeb6PMnvsGGX5KQUyhO
         29+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768872540; x=1769477340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ojJn61U4L0laT2frCHxKlurP2cAcK8IkqiWzn71IsC0=;
        b=Zh7M3AVcJcnmnEpOZ2/hEMUCZ+4GxuDsd7CyAi6iv/duMjZeoh7Y5I+TBHASHJcqk9
         2tlRKr/3XxtBe7EamKgJliKoD5plxqWswu9771k//zIiuVCh166TVxX0c3Mf5g5Yg1FX
         TyWVZUJpjOD1fmXdKgS0F0aPhOuCGf36pqucGWM12kVdQ0NEC0mjGoo4eAcpmFAxhCQV
         kzzw0zeUaufdehoakOcheJFClSNdpx5hZ3qM8NeNKpDLY+axdNmwqfDkQHsbZTY6WxNx
         umBZunDsyn+C4CVT5gtk2ycyTLWjiSSVeHfbz/gT83/DJ66nuJRJ9pQDlg4zdJ+V5Iov
         nL2g==
X-Forwarded-Encrypted: i=1; AJvYcCVSSa0FRTXnQOXHsuOQ8poYpfhitXjzYHDmmdraGUmdp9kJuW+QVfAMP5RYgOpsiQ+lVCEk9JpP@lists.linux.dev
X-Gm-Message-State: AOJu0YylxPO7Ssxgvpgzpj7OaGUt6A0CzB2BCXlVLAMr07S8V56Ms1Br
	pxvRee88ZytWe3ibavlfcj99qwI7QZXx6s5FhbMJWkQdw7DxBDlTW4WQ6/+DYBEGxFb7sgRmTMh
	uvdlgZAhNZjC0ZNeDEbDMpk8WvvYedVUE1tSkU7m4
X-Gm-Gg: AY/fxX5204b1ac6zHgBD2Ye0zP85jMWj4IFKlaxqkNjf/JYqM2bcHFTvUXPCkct/dq9
	ePxelZoHEbIarYiFfIPAQKcGk/PVL3rZvoXkitJsK2j675zuOsavaIKPmTgZGBq5lfSFG0IiS6m
	EWKieUshSIZgCQ3om83x4b+H396SzxYfA8y4mjOcKQuXgOPWdnnAS6CJYF5IPxdB69xetDYnIKr
	nX9GVYcugs2csg1B7Y0l/2teQN/ZkXg99SfrD4arwGOt6xMvtsNsGlJ1bPxNDgg2mrmlWQPWay7
	+vnYDLVRY9SBhnm5uB2JgoHVPNqFi7dheqyvQ3kQ
X-Received: by 2002:ac8:5f91:0:b0:501:197d:32af with SMTP id
 d75a77b69052e-502af851212mr27478041cf.0.1768872539710; Mon, 19 Jan 2026
 17:28:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com> <2-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <2-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Mon, 19 Jan 2026 17:28:47 -0800
X-Gm-Features: AZwV_Qjk5bUwKlZM6VOMMJgnPUK0p1MWm3PFCkDK0iD3ANnfvyVYxNuABviheuY
Message-ID: <CAAywjhT97fpZjXrMjqOxNbdrK2r=TcjT0syA9eMYv77B2Xi-FA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] iommupt: Avoid rewalking during map
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 4:13=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> Currently the core code provides a simplified interface to drivers where
> it fragments a requested multi-page map into single page size steps after
> doing all the calculations to figure out what page size is
> appropriate. Each step rewalks the page tables from the start.
>
> Since iommupt has a single implementation of the mapping algorithm it can
> internally compute each step as it goes while retaining its current
> position in the walk.
>
> Add a new function pt_pgsz_count() which computes the same page size
> fragement of a large mapping operations.
>
> Compute the next fragment when all the leaf entries of the current
> fragement have been written, then continue walking from the current
> point.
>
> The function pointer is run through pt_iommu_ops instead of
> iommu_domain_ops to discourage using it outside iommupt. All drivers with
> their own page tables should continue to use the simplified map_pages()
> style interfaces.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/iommu_pt.h         | 133 ++++++++++++--------
>  drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
>  drivers/iommu/generic_pt/pt_iter.h          |  22 ++++
>  drivers/iommu/iommu.c                       |  39 ++++--
>  include/linux/generic_pt/iommu.h            |  34 ++++-
>  5 files changed, 175 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_=
pt/iommu_pt.h
> index 5c898c01659798..22bae5bfeb0bac 100644
> --- a/drivers/iommu/generic_pt/iommu_pt.h
> +++ b/drivers/iommu/generic_pt/iommu_pt.h
> @@ -467,6 +467,7 @@ struct pt_iommu_map_args {
>         pt_oaddr_t oa;
>         unsigned int leaf_pgsize_lg2;
>         unsigned int leaf_level;
> +       pt_vaddr_t num_leaves;
>  };
>
>  /*
> @@ -519,11 +520,15 @@ static int clear_contig(const struct pt_state *star=
t_pts,
>  static int __map_range_leaf(struct pt_range *range, void *arg,
>                             unsigned int level, struct pt_table_p *table)
>  {
> +       struct pt_iommu *iommu_table =3D iommu_from_common(range->common)=
;
>         struct pt_state pts =3D pt_init(range, level, table);
>         struct pt_iommu_map_args *map =3D arg;
>         unsigned int leaf_pgsize_lg2 =3D map->leaf_pgsize_lg2;
>         unsigned int start_index;
>         pt_oaddr_t oa =3D map->oa;
> +       unsigned int num_leaves;
> +       unsigned int orig_end;
> +       pt_vaddr_t last_va;
>         unsigned int step;
>         bool need_contig;
>         int ret =3D 0;
> @@ -537,6 +542,15 @@ static int __map_range_leaf(struct pt_range *range, =
void *arg,
>
>         _pt_iter_first(&pts);
>         start_index =3D pts.index;
> +       orig_end =3D pts.end_index;
> +       if (pts.index + map->num_leaves < pts.end_index) {
> +               /* Need to stop in the middle of the table to change size=
s */
> +               pts.end_index =3D pts.index + map->num_leaves;
> +               num_leaves =3D 0;
> +       } else {
> +               num_leaves =3D map->num_leaves - (pts.end_index - pts.ind=
ex);
> +       }
> +
>         do {
>                 pts.type =3D pt_load_entry_raw(&pts);
>                 if (pts.type !=3D PT_ENTRY_EMPTY || need_contig) {
> @@ -562,7 +576,40 @@ static int __map_range_leaf(struct pt_range *range, =
void *arg,
>         flush_writes_range(&pts, start_index, pts.index);
>
>         map->oa =3D oa;
> -       return ret;
> +       map->num_leaves =3D num_leaves;
> +       if (ret || num_leaves)
> +               return ret;
> +
> +       /* range->va is not valid if we reached the end of the table */
> +       pts.index -=3D step;
> +       pt_index_to_va(&pts);
> +       pts.index +=3D step;
> +       last_va =3D range->va + log2_to_int(leaf_pgsize_lg2);
> +
> +       if (last_va - 1 =3D=3D range->last_va) {
> +               PT_WARN_ON(pts.index !=3D orig_end);
> +               return 0;
> +       }
> +
> +       /*
> +        * Reached a point where the page size changed, compute the new
> +        * parameters.
> +        */
> +       map->leaf_pgsize_lg2 =3D pt_compute_best_pgsize(
> +               iommu_table->domain.pgsize_bitmap, last_va, range->last_v=
a, oa);
> +       map->leaf_level =3D
> +               pt_pgsz_lg2_to_level(range->common, map->leaf_pgsize_lg2)=
;
> +       map->num_leaves =3D pt_pgsz_count(iommu_table->domain.pgsize_bitm=
ap,
> +                                       last_va, range->last_va, oa,
> +                                       map->leaf_pgsize_lg2);
> +
> +       /* Didn't finish this table level, caller will repeat it */
> +       if (pts.index !=3D orig_end) {
> +               if (pts.index !=3D start_index)
> +                       pt_index_to_va(&pts);
> +               return -EAGAIN;
> +       }
> +       return 0;
>  }
>
>  static int __map_range(struct pt_range *range, void *arg, unsigned int l=
evel,
> @@ -585,14 +632,9 @@ static int __map_range(struct pt_range *range, void =
*arg, unsigned int level,
>                         if (pts.type !=3D PT_ENTRY_EMPTY)
>                                 return -EADDRINUSE;
>                         ret =3D pt_iommu_new_table(&pts, &map->attrs);
> -                       if (ret) {
> -                               /*
> -                                * Racing with another thread installing =
a table
> -                                */
> -                               if (ret =3D=3D -EAGAIN)
> -                                       continue;
> +                       /* EAGAIN on a race will loop again */
> +                       if (ret)
>                                 return ret;
> -                       }
>                 } else {
>                         pts.table_lower =3D pt_table_ptr(&pts);
>                         /*
> @@ -616,10 +658,12 @@ static int __map_range(struct pt_range *range, void=
 *arg, unsigned int level,
>                  * The already present table can possibly be shared with =
another
>                  * concurrent map.
>                  */
> -               if (map->leaf_level =3D=3D level - 1)
> -                       ret =3D pt_descend(&pts, arg, __map_range_leaf);
> -               else
> -                       ret =3D pt_descend(&pts, arg, __map_range);
> +               do {
> +                       if (map->leaf_level =3D=3D level - 1)
> +                               ret =3D pt_descend(&pts, arg, __map_range=
_leaf);
> +                       else
> +                               ret =3D pt_descend(&pts, arg, __map_range=
);
> +               } while (ret =3D=3D -EAGAIN);
>                 if (ret)
>                         return ret;
>
> @@ -627,6 +671,14 @@ static int __map_range(struct pt_range *range, void =
*arg, unsigned int level,
>                 pt_index_to_va(&pts);
>                 if (pts.index >=3D pts.end_index)
>                         break;
> +
> +               /*
> +                * This level is currently running __map_range_leaf() whi=
ch is
> +                * not correct if the target level has been updated to th=
is
> +                * level. Have the caller invoke __map_range_leaf.
> +                */
> +               if (map->leaf_level =3D=3D level)
> +                       return -EAGAIN;
>         } while (true);
>         return 0;
>  }
> @@ -798,12 +850,13 @@ static int check_map_range(struct pt_iommu *iommu_t=
able, struct pt_range *range,
>  static int do_map(struct pt_range *range, struct pt_common *common,
>                   bool single_page, struct pt_iommu_map_args *map)
>  {
> +       int ret;
> +
>         /*
>          * The __map_single_page() fast path does not support DMA_INCOHER=
ENT
>          * flushing to keep its .text small.
>          */
>         if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
> -               int ret;
>
>                 ret =3D pt_walk_range(range, __map_single_page, map);
>                 if (ret !=3D -EAGAIN)
> @@ -811,50 +864,25 @@ static int do_map(struct pt_range *range, struct pt=
_common *common,
>                 /* EAGAIN falls through to the full path */
>         }
>
> -       if (map->leaf_level =3D=3D range->top_level)
> -               return pt_walk_range(range, __map_range_leaf, map);
> -       return pt_walk_range(range, __map_range, map);
> +       do {
> +               if (map->leaf_level =3D=3D range->top_level)
> +                       ret =3D pt_walk_range(range, __map_range_leaf, ma=
p);
> +               else
> +                       ret =3D pt_walk_range(range, __map_range, map);
> +       } while (ret =3D=3D -EAGAIN);
> +       return ret;
>  }
>
> -/**
> - * map_pages() - Install translation for an IOVA range
> - * @domain: Domain to manipulate
> - * @iova: IO virtual address to start
> - * @paddr: Physical/Output address to start
> - * @pgsize: Length of each page
> - * @pgcount: Length of the range in pgsize units starting from @iova
> - * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
> - * @gfp: GFP flags for any memory allocations
> - * @mapped: Total bytes successfully mapped
> - *
> - * The range starting at IOVA will have paddr installed into it. The cal=
ler
> - * must specify a valid pgsize and pgcount to segment the range into com=
patible
> - * blocks.
> - *
> - * On error the caller will probably want to invoke unmap on the range f=
rom iova
> - * up to the amount indicated by @mapped to return the table back to an
> - * unchanged state.
> - *
> - * Context: The caller must hold a write range lock that includes the wh=
ole
> - * range.
> - *
> - * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA t=
hat were
> - * mapped are added to @mapped, @mapped is not zerod first.
> - */
> -int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova=
,
> -                        phys_addr_t paddr, size_t pgsize, size_t pgcount=
,
> -                        int prot, gfp_t gfp, size_t *mapped)
> +static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
> +                        phys_addr_t paddr, dma_addr_t len, unsigned int =
prot,
> +                        gfp_t gfp, size_t *mapped)
>  {
> -       struct pt_iommu *iommu_table =3D
> -               container_of(domain, struct pt_iommu, domain);
>         pt_vaddr_t pgsize_bitmap =3D iommu_table->domain.pgsize_bitmap;
>         struct pt_common *common =3D common_from_iommu(iommu_table);
>         struct iommu_iotlb_gather iotlb_gather;
> -       pt_vaddr_t len =3D pgsize * pgcount;
>         struct pt_iommu_map_args map =3D {
>                 .iotlb_gather =3D &iotlb_gather,
>                 .oa =3D paddr,
> -               .leaf_pgsize_lg2 =3D vaffs(pgsize),
>         };
>         bool single_page =3D false;
>         struct pt_range range;
> @@ -882,13 +910,13 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domai=
n, unsigned long iova,
>                 return ret;
>
>         /* Calculate target page size and level for the leaves */
> -       if (pt_has_system_page_size(common) && pgsize =3D=3D PAGE_SIZE &&
> -           pgcount =3D=3D 1) {
> +       if (pt_has_system_page_size(common) && len =3D=3D PAGE_SIZE) {
>                 PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
>                 if (log2_mod(iova | paddr, PAGE_SHIFT))
>                         return -ENXIO;
>                 map.leaf_pgsize_lg2 =3D PAGE_SHIFT;
>                 map.leaf_level =3D 0;
> +               map.num_leaves =3D 1;
>                 single_page =3D true;
>         } else {
>                 map.leaf_pgsize_lg2 =3D pt_compute_best_pgsize(
> @@ -897,6 +925,9 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain,=
 unsigned long iova,
>                         return -ENXIO;
>                 map.leaf_level =3D
>                         pt_pgsz_lg2_to_level(common, map.leaf_pgsize_lg2)=
;
> +               map.num_leaves =3D pt_pgsz_count(pgsize_bitmap, range.va,
> +                                              range.last_va, paddr,
> +                                              map.leaf_pgsize_lg2);
>         }
>
>         ret =3D check_map_range(iommu_table, &range, &map);
> @@ -919,7 +950,6 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain,=
 unsigned long iova,
>         *mapped +=3D map.oa - paddr;
>         return ret;
>  }
> -EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
>
>  struct pt_unmap_args {
>         struct iommu_pages_list free_list;
> @@ -1079,6 +1109,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table=
)
>  }
>
>  static const struct pt_iommu_ops NS(ops) =3D {
> +       .map_range =3D NS(map_range),
>         .unmap_range =3D NS(unmap_range),
>  #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty=
) && \
>         IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_di=
rty)
> diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/=
generic_pt/kunit_generic_pt.h
> index 68278bf15cfe07..374e475f591e15 100644
> --- a/drivers/iommu/generic_pt/kunit_generic_pt.h
> +++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
> @@ -312,6 +312,17 @@ static void test_best_pgsize(struct kunit *test)
>         }
>  }
>
> +static void test_pgsz_count(struct kunit *test)
> +{
> +       KUNIT_EXPECT_EQ(test,
> +                       pt_pgsz_count(SZ_4K, 0, SZ_1G - 1, 0, ilog2(SZ_4K=
)),
> +                       SZ_1G / SZ_4K);
> +       KUNIT_EXPECT_EQ(test,
> +                       pt_pgsz_count(SZ_2M | SZ_4K, SZ_4K, SZ_1G - 1, SZ=
_4K,
> +                                     ilog2(SZ_4K)),
> +                       (SZ_2M - SZ_4K) / SZ_4K);
> +}
> +
>  /*
>   * Check that pt_install_table() and pt_table_pa() match
>   */
> @@ -770,6 +781,7 @@ static struct kunit_case generic_pt_test_cases[] =3D =
{
>         KUNIT_CASE_FMT(test_init),
>         KUNIT_CASE_FMT(test_bitops),
>         KUNIT_CASE_FMT(test_best_pgsize),
> +       KUNIT_CASE_FMT(test_pgsz_count),
>         KUNIT_CASE_FMT(test_table_ptr),
>         KUNIT_CASE_FMT(test_max_va),
>         KUNIT_CASE_FMT(test_table_radix),
> diff --git a/drivers/iommu/generic_pt/pt_iter.h b/drivers/iommu/generic_p=
t/pt_iter.h
> index c0d8617cce2928..3e45dbde6b8327 100644
> --- a/drivers/iommu/generic_pt/pt_iter.h
> +++ b/drivers/iommu/generic_pt/pt_iter.h
> @@ -569,6 +569,28 @@ static inline unsigned int pt_compute_best_pgsize(pt=
_vaddr_t pgsz_bitmap,
>         return pgsz_lg2;
>  }
>
> +/*
> + * Return the number of pgsize_lg2 leaf entries that can be mapped for
> + * va to oa. This accounts for any requirement to reduce or increase the=
 page
> + * size across the VA range.
> + */
> +static inline pt_vaddr_t pt_pgsz_count(pt_vaddr_t pgsz_bitmap, pt_vaddr_=
t va,
> +                                      pt_vaddr_t last_va, pt_oaddr_t oa,
> +                                      unsigned int pgsize_lg2)
> +{
> +       pt_vaddr_t len =3D last_va - va + 1;
> +       pt_vaddr_t next_pgsizes =3D log2_set_mod(pgsz_bitmap, 0, pgsize_l=
g2 + 1);
> +
> +       if (next_pgsizes) {
> +               unsigned int next_pgsize_lg2 =3D vaffs(next_pgsizes);
> +
> +               if (log2_mod(va ^ oa, next_pgsize_lg2) =3D=3D 0)
> +                       len =3D min(len, log2_set_mod_max(va, next_pgsize=
_lg2) -
> +                                              va + 1);
> +       }
> +       return log2_div(len, pgsize_lg2);
> +}
> +
>  #define _PT_MAKE_CALL_LEVEL(fn)                                         =
 \
>         static __always_inline int fn(struct pt_range *range, void *arg, =
\
>                                       unsigned int level,                =
\
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 916b68408463a8..ca9e90d80f7484 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2569,14 +2569,14 @@ static size_t iommu_pgsize(struct iommu_domain *d=
omain, unsigned long iova,
>         return pgsize;
>  }
>
> -int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> -               phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
> +                                   unsigned long iova, phys_addr_t paddr=
,
> +                                   size_t size, int prot, gfp_t gfp)
>  {
>         const struct iommu_domain_ops *ops =3D domain->ops;
>         unsigned long orig_iova =3D iova;
>         unsigned int min_pagesz;
>         size_t orig_size =3D size;
> -       phys_addr_t orig_paddr =3D paddr;
>         int ret =3D 0;
>
>         might_sleep_if(gfpflags_allow_blocking(gfp));
> @@ -2633,12 +2633,9 @@ int iommu_map_nosync(struct iommu_domain *domain, =
unsigned long iova,
>         /* unroll mapping in case something went wrong */
>         if (ret) {
>                 iommu_unmap(domain, orig_iova, orig_size - size);
> -       } else {
> -               trace_map(orig_iova, orig_paddr, orig_size);
> -               iommu_debug_map(domain, orig_paddr, orig_size);
> +               return ret;
>         }
> -
> -       return ret;
> +       return 0;
>  }
>
>  int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size=
_t size)
> @@ -2650,6 +2647,32 @@ int iommu_sync_map(struct iommu_domain *domain, un=
signed long iova, size_t size)
>         return ops->iotlb_sync_map(domain, iova, size);
>  }
>
> +int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> +               phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +{
> +       struct pt_iommu *pt =3D iommupt_from_domain(domain);
> +       int ret;
> +
> +       if (pt) {
> +               size_t mapped =3D 0;
> +
> +               ret =3D pt->ops->map_range(pt, iova, paddr, size, prot, g=
fp,
> +                                        &mapped);
> +               if (ret) {
> +                       iommu_unmap(domain, iova, mapped);
> +                       return ret;
> +               }
> +               return 0;
> +       }
> +       ret =3D __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,=
 gfp);
> +       if (!ret)
> +               return ret;
> +
> +       trace_map(iova, paddr, size);
> +       iommu_debug_map(domain, paddr, size);
> +       return 0;
> +}
> +
>  int iommu_map(struct iommu_domain *domain, unsigned long iova,
>               phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
>  {
> diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/=
iommu.h
> index f094f8f44e4e8a..43cc98c9c55f70 100644
> --- a/include/linux/generic_pt/iommu.h
> +++ b/include/linux/generic_pt/iommu.h
> @@ -87,6 +87,33 @@ struct pt_iommu_info {
>  };
>
>  struct pt_iommu_ops {
> +       /**
> +        * @map_range: Install translation for an IOVA range
> +        * @iommu_table: Table to manipulate
> +        * @iova: IO virtual address to start
> +        * @paddr: Physical/Output address to start
> +        * @len: Length of the range starting from @iova
> +        * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
> +        * @gfp: GFP flags for any memory allocations
> +        *
> +        * The range starting at IOVA will have paddr installed into it. =
The
> +        * rage is automatically segmented into optimally sized table ent=
ries,
> +        * and can have any valid alignment.
> +        *
> +        * On error the caller will probably want to invoke unmap on the =
range
> +        * from iova up to the amount indicated by @mapped to return the =
table
> +        * back to an unchanged state.
> +        *
> +        * Context: The caller must hold a write range lock that includes
> +        * the whole range.
> +        *
> +        * Returns: -ERRNO on failure, 0 on success. The number of bytes =
of VA
> +        * that were mapped are added to @mapped, @mapped is not zerod fi=
rst.
> +        */
> +       int (*map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
> +                        phys_addr_t paddr, dma_addr_t len, unsigned int =
prot,
> +                        gfp_t gfp, size_t *mapped);
> +
>         /**
>          * @unmap_range: Make a range of IOVA empty/not present
>          * @iommu_table: Table to manipulate
> @@ -224,10 +251,6 @@ struct pt_iommu_cfg {
>  #define IOMMU_PROTOTYPES(fmt)                                           =
       \
>         phys_addr_t pt_iommu_##fmt##_iova_to_phys(struct iommu_domain *do=
main, \
>                                                   dma_addr_t iova);      =
      \
> -       int pt_iommu_##fmt##_map_pages(struct iommu_domain *domain,      =
      \
> -                                      unsigned long iova, phys_addr_t pa=
ddr,  \
> -                                      size_t pgsize, size_t pgcount,    =
      \
> -                                      int prot, gfp_t gfp, size_t *mappe=
d);   \
>         int pt_iommu_##fmt##_read_and_clear_dirty(                       =
      \
>                 struct iommu_domain *domain, unsigned long iova, size_t s=
ize,  \
>                 unsigned long flags, struct iommu_dirty_bitmap *dirty);  =
      \
> @@ -248,8 +271,7 @@ struct pt_iommu_cfg {
>   * iommu_pt
>   */
>  #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
> -       .iova_to_phys =3D &pt_iommu_##fmt##_iova_to_phys, \
> -       .map_pages =3D &pt_iommu_##fmt##_map_pages
> +       .iova_to_phys =3D &pt_iommu_##fmt##_iova_to_phys
>  #define IOMMU_PT_DIRTY_OPS(fmt) \
>         .read_and_clear_dirty =3D &pt_iommu_##fmt##_read_and_clear_dirty
>
> --
> 2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ECF27E04C
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768450385; cv=pass; b=C/H8XyI5z3e3kcaqVEOCu/B9QItAvgPQBRPv8bpVv/3rA0W6UUqH68L48c3YTchkace+jVNpvid6F8HlFJs2KMJJLsEK/Md0HkNqQDaPRITTC2Y9S35ZGHjzK/3OaZ9+I16jK9UUkvrH5JUyoy8I7eTvr6pY0slfBlyzyZy1t7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768450385; c=relaxed/simple;
	bh=mXNjfijHygShzXEQilQn+4tWErbWK37VnOF1/8t52Tw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uhax3wd5CZGmTautkQ2+w8/4jZmUXK3u8tBeqOtkSXy/kn+Gyot2fCqUJiPL1/4r1Iv6XUtc4jgBDcwCHxSUDPMSV9/KmSAYMhAcpTp/VLEAmi7EDi50QzeJZysgE61gCrP456XXDWIFnnxYOIwuY73b5uXoRzUsOuL7wq0ZPC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=miiVLBv7; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="miiVLBv7"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50299648ae9so102081cf.1
        for <patches@lists.linux.dev>; Wed, 14 Jan 2026 20:13:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768450382; cv=none;
        d=google.com; s=arc-20240605;
        b=kaF4ut8ZcpAEnX2Wfsl3JNvTr4ICaA/KFwfFkZteFKDZGArrcT7zhPupa7S7NvFY6U
         zm42he179yOOSb66axesUki+mJ8t8k0z2pGixR8od4I0ZQgn1rbmTzNPq6oKk347T9On
         p7Nv+/ThtMtuTJHj+ey2/dfj+u5YQiPe4g768Iuf2TNHBmsJzAEjdXM7pgjNKxKUHLJP
         MxIvkieohZ5xD/XR6mUewQw6XfzzZMTf41hL5+5W/Xv76/h/rPl6alYfplrk591zpiv+
         q9htyu+0Njkl/xX12YFlF2gSME6AC9mWPWhJYVf4yLGM/tohe5ED2aNoVCj/ecrkUlxK
         0hBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1jI9sN+NE1q1c6SXnzvabf8IE+Avpei4VzzZZq8JMQw=;
        fh=970YpICQsEm+jKFL77/IKl9heSCAFf1m+Yu+XGHdRQE=;
        b=QoVPCqfdEZ3GFg5xxAV4aL/FdFyLB9A0NzPP+MF/5UCHfG5FuXo+HX6fT0UzKKYUEn
         X1xpSHCDnA5WrZaYHkfEsIEhJwDWgaogp2UT0+imb9aO3x4As4GlRQG3JKmRRNkVrpDf
         dHZrC2rabpxIsWVCvzml8nPQJGTfTu8hSllvOF6TSNb1cfe8DFuAgyhwy5ha+4GxXt5K
         s24eFlWfHj8uXQAMPEhNWm4GmtdozHSJAPdDyDi+133N0zJrj3oxnlZoFOzDYXj/SGfO
         W1wv538BvJrF1O7drJjrc70WIMaK4HONTAwXw/lsZ8pU9XMLEf4NTOW8fx0uYXqkRScm
         T9Qw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768450382; x=1769055182; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jI9sN+NE1q1c6SXnzvabf8IE+Avpei4VzzZZq8JMQw=;
        b=miiVLBv7eYM0289rUgrTdPxQGHxLAoNRseoFUrj0X5CMG8m+NikZ9tEcvitZg5ycd2
         2TKEkj31ACWK2QrhEzr24779rHLs6rRLaG4AhaKZUtmLEG7c5cWuJt5Bq5b2EQBFymk/
         rEikxySeBsTcZMnGS94q/iCvT8br9iFJrIGuXDxQ4p1W+iB44UDOfhbA65Z/zS5Vhae3
         lfmSl3dIhDZ0Kr7c4JpNPnsr0Ld7+abGiyBJxtXKnpiAybLH+9qisqUxh51EF8cEsq81
         WJQk86c+aBU8B8dFBbnlKrVEiYD8jIfueFtq/NuXVdFRhQ/VRZ8o/9tCWGz6MAWoJA1k
         nPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768450382; x=1769055182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1jI9sN+NE1q1c6SXnzvabf8IE+Avpei4VzzZZq8JMQw=;
        b=RErLI+jntDJa0fbzGByWlJ4fWDEUr8oA/1ckHcGBLLbrc9qkAxbUDaU7+4B2GMBlvJ
         jYS2aLW8ST/Z+pda+aE8MG98JNfa3iRp2kQFIybRV48DXJrmgUrz1stoX1D2WTd4JAY6
         hy2M+dWO9WX/zrJpcpivGu7AydceAwLq9TvYBVEKcNqgr6IJ+AbhVshUJn3cUKCzk6T/
         3LHDyPxw7vutqpyojR1aZnrjK7xO2GDV7tYUZjdm6FpXShT+j9XdH6NpSKxHmE3ESREk
         aOLs5wK2s5XRUhOd7nC4UW41hhcPWgSMfohKqdFPUgZ5XO0hFucPC9BxBBsEwJGpqwSj
         t2rg==
X-Forwarded-Encrypted: i=1; AJvYcCWrcB/l6Bz5mbBie+NlI/s0oyhlrgohsLmiAaEw3D+ipqDFueC+zkKYErDLhWpqhCC0mwDySjrT@lists.linux.dev
X-Gm-Message-State: AOJu0YyVJXYxsl7DOxVCd91zu+KVt1or1J4b+Mhr89q0KFRMdw733pzu
	VsWYjzRWjD0F820Ca4ovxIFmWmU9Su245Oih4Wud3qcVamTGqVnFTZ/mgaKQoWoGoRyUHtzhyg7
	m8VJg2ikaO8CItX0L3zvdxFbxz1MAoDf7/Ay1lyxx
X-Gm-Gg: AY/fxX7NQq6+ZGeio3C8z8peyu+pBB21MyzGjWv56XgqTvaceqNfFGkhA0/gOu/gBnU
	LLIxGXMUHit6v4J/ewOuwF478mH2iuDxQRHU2lgSMWtvdM8ZXLGepJ7dTSAPJFSuRSCGxmvw8Bq
	Pdz++ouoS354RJvYMAE2C19wgiqg5o4HbAc3VLJu1tCtoDHYMnoiFc7reg+hAXGVE48zq+WA0aS
	5mlS7zlrRbGYsof3i30jmx6uiiNAm0GrbTku9OoaqP5AqBe9AXtrUeegO+TNL5CEbif/Vkskzve
	HxSGBFTg3/Lea8B/j2nSrj56McHGA1jxh2ED/bYS
X-Received: by 2002:ac8:5854:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-501eab81fc6mr5453211cf.14.1768450382024; Wed, 14 Jan 2026
 20:13:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com> <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 14 Jan 2026 20:12:50 -0800
X-Gm-Features: AZwV_QgS3dgaueISLA7Wuq2dTRH4K_N_MwpHLHWrKApIslQgTJ5_x9gZ5oMZ00w
Message-ID: <CAAywjhR_Jh5K8VgLWFxvXwn66bV3vdmuxGN_OKh18Xoxb_NT6A@mail.gmail.com>
Subject: Re: [PATCH 3/3] iommupt: Avoid rewalking during map
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, kernel test robot <lkp@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 6:49=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
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
>  drivers/iommu/generic_pt/iommu_pt.h         | 127 ++++++++++++--------
>  drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
>  drivers/iommu/generic_pt/pt_iter.h          |  22 ++++
>  drivers/iommu/iommu.c                       |  25 +++-
>  include/linux/generic_pt/iommu.h            |  34 +++++-
>  5 files changed, 161 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_=
pt/iommu_pt.h
> index 5c898c01659798..14a73d3b291b42 100644
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

The overall page walk with pgsize and leaf_level switching is great.
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
> @@ -627,6 +671,8 @@ static int __map_range(struct pt_range *range, void *=
arg, unsigned int level,
>                 pt_index_to_va(&pts);
>                 if (pts.index >=3D pts.end_index)
>                         break;
> +               if (map->leaf_level =3D=3D level)
> +                       return -EAGAIN;

Could you please add a comment here. Maybe something that says that a
level switch happened and the caller needs to retry?
>         } while (true);
>         return 0;
>  }
> @@ -798,12 +844,13 @@ static int check_map_range(struct pt_iommu *iommu_t=
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
> @@ -811,50 +858,25 @@ static int do_map(struct pt_range *range, struct pt=
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
> @@ -882,13 +904,13 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domai=
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
> @@ -897,6 +919,9 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain,=
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
> @@ -919,7 +944,6 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain,=
 unsigned long iova,
>         *mapped +=3D map.oa - paddr;
>         return ret;
>  }
> -EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
>
>  struct pt_unmap_args {
>         struct iommu_pages_list free_list;
> @@ -1079,6 +1103,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table=
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
> index 000dd6c374877b..4c3b8184a2c28b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2501,8 +2501,9 @@ static size_t iommu_pgsize(struct iommu_domain *dom=
ain, unsigned long iova,
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
> @@ -2580,6 +2581,26 @@ int iommu_sync_map(struct iommu_domain *domain, un=
signed long iova, size_t size)
>         return ops->iotlb_sync_map(domain, iova, size);
>  }
>
> +int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> +               phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +{
> +       struct pt_iommu *pt =3D iommupt_from_domain(domain);
> +
> +       if (pt) {
> +               size_t mapped =3D 0;
> +               int ret;
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
> +       return __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, =
gfp);
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

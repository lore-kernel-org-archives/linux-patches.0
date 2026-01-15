Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D583C0092
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501632; cv=pass; b=s1GFLFLIaLD/SCr3dGofRsdWNTqIm7uSxj92vIwtaA3Af36PJShKVNVf05Yb8LKqEChToEe1Xo/Osb1KXVuLPkkzleouFJbFjKy6Rwc9/dQqVgb63HmEAvR0M9+vDpkco8DMoZlF9BM3Jb9/JAdsfypiUmR9Y9cjiDe1BKk7YOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501632; c=relaxed/simple;
	bh=9a2GaFXb+fA4y7W8/hgyJhmBHxnYTsdZC/+sIB8sV60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M8W3yh+lAiAvdkuquOvAo7vAuv8tjJNyzgQwZpDbYwv5rvWv2F7yIQnATu9Axuz7UigFLGEaOfJS08xxSgV3BwEo7PAbAtWkbfCPrapM5KYB95xpiVh7du9JUmdCaSlbG4eLof2p8FI7ZsWU8JZykzCuagJqa68xOznIcPe7Qn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYGizj9x; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYGizj9x"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5014acad6f2so24791cf.1
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 10:27:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501630; cv=none;
        d=google.com; s=arc-20240605;
        b=kxjnZi4iyhjdn7wFWmE0EmeReP5iq673ds7wXirUd6fm4Q+tfVqhON3tRl4AEg92xf
         NKSEBnAbLQNLSqNFDIgf1xhtzVRngmCGI+hNO0zzHA7OhOeyimjtZBiBlqKHdlsRqeuH
         W9qOdSHRX9+G9+6yLsASWp/CsxKw6WUDG9yrjFA9qIbV07wJXWlnoAbd/YMSBCgeFUux
         bsm1VhXPoLHRmzbDmOV5TZho7up9gHSPmbmR8kT/xHbuFLLI3KgB2JCpDr53cb0skNlW
         3SOtB7cLeFqzectioPr5Bk/IXztcziN7/oRyY4jGp8y1nmXfZDyqX794fkW8MIU2/ZcB
         YCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UUBnr0pT69XDgeuYcmjVaY3IHFc3NphytYYdMb5XuDc=;
        fh=DEoyIWEqp4lRPLjvEMmck7AiV0iU0ZJ5PIpc5RGFwFs=;
        b=BASvKMnb9/zAcQQZedzj3BWGfjYFnya8esd99F8HLM4NO7zPmDuhMvMQ/qS6hmtCoh
         aDdP9aJr3I63EULl2Vji8jBDjVTXQgPspHpQd6cYkQvAON7cDd4T4kRbx3/akngeih3/
         +sjnUiDWAfiUYYGCaI8K5U+jgod4+MiI6F3XSk0EXC4nkPNUXlORe/DtcaYw0AoH5k3S
         I77W7FDiq04xusy40FQUGN8hNnkEQUkvpiXxId7mYIwC5oGK/at0Nb8IYl/XtUmmXAlg
         FPC1wboG2DARJ49apfW4YaXYBgGlp2AB6+xT1vC7fNthZ4vUagWnkgUCa9bInM8KVfTO
         TGSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768501630; x=1769106430; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUBnr0pT69XDgeuYcmjVaY3IHFc3NphytYYdMb5XuDc=;
        b=cYGizj9xR4tduw7mFjX2AaS+65nRfIlByhH5mxF2t/BsuybvvuwpOp1/rJVtNxEwYY
         F73/JXIWqYADCAWPmzVgPO22fqaJH7Tgu8f2sB4U1Cq+edWsbM168cjgdAYmPd2noOiF
         vBcObevqQ+CJpm8San46r44IAYcAQB9Y4m9RZMRyHxjPqybJPVZKHipoTjx79DSAcTlU
         mbPhbvYI242vaGzvQ2mvnBH4jCaDoRDfngb/04rUx3TEFoIe0T+3zYJekJWtRUOg7wR6
         a2Iuyz1Ow0F2YWM5VLRAvOvlWy0DH3a21Frx0PXfKrEcwbn9SSM96UZZy8FIt3PlEknf
         TWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501630; x=1769106430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UUBnr0pT69XDgeuYcmjVaY3IHFc3NphytYYdMb5XuDc=;
        b=jZcDZ7mVNk0i5G5Rv10AAsm8cy6A7oHN/qIIhQ1SO8nnx12TgPLyDimvw9y8TMRVuS
         rkNIHOxOYVAXnJnUsrmNBRtQZHP26opCNctuFldryXgZUPGW94g2Dzp4alif5pKo1aG+
         9jJEZXZ4sMapPIxfCpDCiz5LxBTClxvRsej9PZ1MaCYJDDjRXe/pP31WleJc/OWPWG6X
         n0RQdtCFU8oIgy6GKwajo3DkEc3n9RC8UGL15u0XkH02oUQ8OnKbADLKZ5kQw3a4LKRQ
         2uMmW6+drFnMD9TzQv3H31ptoauGcjylxIEb5PHJLRWswHCn4qnDnwG/x2GcVUcW46e5
         8GLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQdHJ3zNa9kSmqro5ob00xbAFaZ/UlIhALV4yD3Jn5PdXZL3pIKhCoF8cASHb48GIHZmUnthra@lists.linux.dev
X-Gm-Message-State: AOJu0YwxTPJsuITdYhse7w8l3z5ErxLCmLoKL6iut8tuABMbr7HbeujY
	Y3QMxeHLaON0EMhS0UdpZaY47SugaGrvpKixPuZlhTsoITSUFn24mK0QJBWnGbjLU1Qd9o7BU7s
	ZhSKv6yaLtsO/mc9CNMVNVMkEprs0b9acUKOrRc9X
X-Gm-Gg: AY/fxX75tkCWDdVCifzoA6hwRof7o0toB3Rh3wqtz6Lm6gYho6W3sSUFIFOkq3dr/V5
	O+NvQW8SLbkVG00Glnf2CslRFUDR58Q/aeHly2Bt7tGUI02jIp6u3lfOUe5v04PL4mq459xtsv0
	+Ym//WUUpjcFQY94UsA95bNb3xXqvmw/2eJjUY4cCnPldm9to7J9kOnxma+A46EX3NWjU634WYt
	fLh2axoBPm1QK9tZ9EnXcGiZvzV3+cT7b67mT8nFTFJFri73PFx3G13DIJDWZY34kKsoOBrFQTA
	vtJA+Lh1RmukxfKqBriL2papIQ+nqS5Ye9T0tCtA
X-Received: by 2002:a05:622a:291:b0:501:4539:c81 with SMTP id
 d75a77b69052e-502a2308ca2mr347271cf.2.1768501629281; Thu, 15 Jan 2026
 10:27:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com> <2-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <2-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Thu, 15 Jan 2026 10:26:57 -0800
X-Gm-Features: AZwV_Qj4613PNkmN-MpgZ-OnhoPRlV1kS1AqbIQ7IWr66Cc22XInFcWPLAOoDfo
Message-ID: <CAAywjhSL5Qv=RFU83TfXa7kSYxC8FzWq4VVMREtHvk8=khLmNA@mail.gmail.com>
Subject: Re: [PATCH 2/3] iommupt: Directly call iommupt's unmap_range()
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
> The common algorithm in iommupt does not require the iommu_pgsize()
> calculations, it can directly unmap any arbitrary range. Add a new functi=
on
> pointer to directly call an iommupt unmap_range op and make
> __iommu_unmap() call it directly.
>
> Gives about a 5% gain on single page unmappings.
>
> The function pointer is run through pt_iommu_ops instead of
> iommu_domain_ops to discourage using it outside iommupt. All drivers with
> their own page tables should continue to use the simplified
> map/unmap_pages() style interfaces.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/iommu_pt.h | 29 ++++------------------
>  drivers/iommu/iommu.c               | 18 +++++++++++---
>  include/linux/generic_pt/iommu.h    | 37 ++++++++++++++++++++++++-----
>  include/linux/iommu.h               |  1 +
>  4 files changed, 51 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_=
pt/iommu_pt.h
> index 3327116a441cac..5c898c01659798 100644
> --- a/drivers/iommu/generic_pt/iommu_pt.h
> +++ b/drivers/iommu/generic_pt/iommu_pt.h
> @@ -1012,34 +1012,12 @@ static __maybe_unused int __unmap_range(struct pt=
_range *range, void *arg,
>         return ret;
>  }
>
> -/**
> - * unmap_pages() - Make a range of IOVA empty/not present
> - * @domain: Domain to manipulate
> - * @iova: IO virtual address to start
> - * @pgsize: Length of each page
> - * @pgcount: Length of the range in pgsize units starting from @iova
> - * @iotlb_gather: Gather struct that must be flushed on return
> - *
> - * unmap_pages() will remove a translation created by map_pages(). It ca=
nnot
> - * subdivide a mapping created by map_pages(), so it should be called wi=
th IOVA
> - * ranges that match those passed to map_pages(). The IOVA range can agg=
regate
> - * contiguous map_pages() calls so long as no individual range is split.
> - *
> - * Context: The caller must hold a write range lock that includes
> - * the whole range.
> - *
> - * Returns: Number of bytes of VA unmapped. iova + res will be the point
> - * unmapping stopped.
> - */
> -size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long=
 iova,
> -                             size_t pgsize, size_t pgcount,
> +static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t i=
ova,
> +                             dma_addr_t len,
>                               struct iommu_iotlb_gather *iotlb_gather)
>  {
> -       struct pt_iommu *iommu_table =3D
> -               container_of(domain, struct pt_iommu, domain);
>         struct pt_unmap_args unmap =3D { .free_list =3D IOMMU_PAGES_LIST_=
INIT(
>                                                unmap.free_list) };
> -       pt_vaddr_t len =3D pgsize * pgcount;
>         struct pt_range range;
>         int ret;
>
> @@ -1054,7 +1032,6 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *=
domain, unsigned long iova,
>
>         return unmap.unmapped;
>  }
> -EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(unmap_pages), "GENERIC_PT_IOMMU");
>
>  static void NS(get_info)(struct pt_iommu *iommu_table,
>                          struct pt_iommu_info *info)
> @@ -1102,6 +1079,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table=
)
>  }
>
>  static const struct pt_iommu_ops NS(ops) =3D {
> +       .unmap_range =3D NS(unmap_range),
>  #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty=
) && \
>         IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_di=
rty)
>         .set_dirty =3D NS(set_dirty),
> @@ -1164,6 +1142,7 @@ static int pt_iommu_init_domain(struct pt_iommu *io=
mmu_table,
>
>         domain->type =3D __IOMMU_DOMAIN_PAGING;
>         domain->pgsize_bitmap =3D info.pgsize_bitmap;
> +       domain->is_iommupt =3D true;
>
>         if (pt_feature(common, PT_FEAT_DYNAMIC_TOP))
>                 range =3D _pt_top_range(common,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb884f..000dd6c374877b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -34,6 +34,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/msi.h>
>  #include <uapi/linux/iommufd.h>
> +#include <linux/generic_pt/iommu.h>
>
>  #include "dma-iommu.h"
>  #include "iommu-priv.h"
> @@ -2596,9 +2597,9 @@ int iommu_map(struct iommu_domain *domain, unsigned=
 long iova,
>  }
>  EXPORT_SYMBOL_GPL(iommu_map);
>
> -static size_t __iommu_unmap(struct iommu_domain *domain,
> -                           unsigned long iova, size_t size,
> -                           struct iommu_iotlb_gather *iotlb_gather)
> +static size_t
> +__iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long io=
va,
> +                          size_t size, struct iommu_iotlb_gather *iotlb_=
gather)
>  {
>         const struct iommu_domain_ops *ops =3D domain->ops;
>         size_t unmapped_page, unmapped =3D 0;
> @@ -2650,6 +2651,17 @@ static size_t __iommu_unmap(struct iommu_domain *d=
omain,
>         return unmapped;
>  }
>
> +static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long i=
ova,
> +                           size_t size,
> +                           struct iommu_iotlb_gather *iotlb_gather)
> +{
> +       struct pt_iommu *pt =3D iommupt_from_domain(domain);
> +
> +       if (pt)
> +               return pt->ops->unmap_range(pt, iova, size, iotlb_gather)=
;
> +       return __iommu_unmap_domain_pgtbl(domain, iova, size, iotlb_gathe=
r);
> +}
> +
>  /**
>   * iommu_unmap() - Remove mappings from a range of IOVA
>   * @domain: Domain to manipulate
> diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/=
iommu.h
> index 9eefbb74efd087..f094f8f44e4e8a 100644
> --- a/include/linux/generic_pt/iommu.h
> +++ b/include/linux/generic_pt/iommu.h
> @@ -66,6 +66,13 @@ struct pt_iommu {
>         struct device *iommu_device;
>  };
>
> +static inline struct pt_iommu *iommupt_from_domain(struct iommu_domain *=
domain)
> +{
> +       if (!IS_ENABLED(CONFIG_IOMMU_PT) || !domain->is_iommupt)
> +               return NULL;
> +       return container_of(domain, struct pt_iommu, domain);
> +}
> +
>  /**
>   * struct pt_iommu_info - Details about the IOMMU page table
>   *
> @@ -80,6 +87,29 @@ struct pt_iommu_info {
>  };
>
>  struct pt_iommu_ops {
> +       /**
> +        * @unmap_range: Make a range of IOVA empty/not present
> +        * @iommu_table: Table to manipulate
> +        * @iova: IO virtual address to start
> +        * @len: Length of the range starting from @iova
> +        * @iotlb_gather: Gather struct that must be flushed on return
> +        *
> +        * unmap_range() will remove a translation created by map_range()=
. It
> +        * cannot subdivide a mapping created by map_range(), so it shoul=
d be
> +        * called with IOVA ranges that match those passed to map_pages. =
The
> +        * IOVA range can aggregate contiguous map_range() calls so long =
as no
> +        * individual range is split.
> +        *
> +        * Context: The caller must hold a write range lock that includes
> +        * the whole range.
> +        *
> +        * Returns: Number of bytes of VA unmapped. iova + res will be th=
e
> +        * point unmapping stopped.
> +        */
> +       size_t (*unmap_range)(struct pt_iommu *iommu_table, dma_addr_t io=
va,
> +                             dma_addr_t len,
> +                             struct iommu_iotlb_gather *iotlb_gather);
> +
>         /**
>          * @set_dirty: Make the iova write dirty
>          * @iommu_table: Table to manipulate
> @@ -198,10 +228,6 @@ struct pt_iommu_cfg {
>                                        unsigned long iova, phys_addr_t pa=
ddr,  \
>                                        size_t pgsize, size_t pgcount,    =
      \
>                                        int prot, gfp_t gfp, size_t *mappe=
d);   \
> -       size_t pt_iommu_##fmt##_unmap_pages(                             =
      \
> -               struct iommu_domain *domain, unsigned long iova,         =
      \
> -               size_t pgsize, size_t pgcount,                           =
      \
> -               struct iommu_iotlb_gather *iotlb_gather);                =
      \
>         int pt_iommu_##fmt##_read_and_clear_dirty(                       =
      \
>                 struct iommu_domain *domain, unsigned long iova, size_t s=
ize,  \
>                 unsigned long flags, struct iommu_dirty_bitmap *dirty);  =
      \
> @@ -223,8 +249,7 @@ struct pt_iommu_cfg {
>   */
>  #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
>         .iova_to_phys =3D &pt_iommu_##fmt##_iova_to_phys, \
> -       .map_pages =3D &pt_iommu_##fmt##_map_pages,       \
> -       .unmap_pages =3D &pt_iommu_##fmt##_unmap_pages
> +       .map_pages =3D &pt_iommu_##fmt##_map_pages
>  #define IOMMU_PT_DIRTY_OPS(fmt) \
>         .read_and_clear_dirty =3D &pt_iommu_##fmt##_read_and_clear_dirty
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 8c66284a91a8b0..0e8c9d31796bfd 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -223,6 +223,7 @@ enum iommu_domain_cookie_type {
>  struct iommu_domain {
>         unsigned type;
>         enum iommu_domain_cookie_type cookie_type;
> +       bool is_iommupt;
>         const struct iommu_domain_ops *ops;
>         const struct iommu_dirty_ops *dirty_ops;
>         const struct iommu_ops *owner; /* Whose domain_alloc we came from=
 */
> --
> 2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

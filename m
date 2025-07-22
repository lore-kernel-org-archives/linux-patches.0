Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B52628B7F8;
	Tue, 22 Jul 2025 03:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154019; cv=none; b=M/mKFCtYTm82f1v94UgJCdeHaOWxc1uqTuHR3V344rg67ClIsBunMTI/ZSI2n8OvH1eY20pBT4ggtAsVxF0KMrUswRSgFrKbPOe9kfs74twOPeVA/YCzBCoZBv5OstGS+cPTEpiqKQ++WcSrAcCnmqiI84roLVqxFeO62FnmbfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154019; c=relaxed/simple;
	bh=p8Fud6Aj1iuYXW/JHl6uZULCsOqNJKDdt7ef/XpR3cI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qq+RKxeaALfLFibshiC3EEyhp6dBTdKFmivoFDwTzqs1XWRB9HqF6E2bYCpTq+OwslZppn9TWRyVOXSbDffO9b59cWloZ/KOCtHXHnGY6pyz14vHXc/RaSDt3swB4/a21Y+YWWn48PMHhaeo8MJM1T68zs8p796VMHX5eMSbB5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUSD0NDF; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUSD0NDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753154017; x=1784690017;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p8Fud6Aj1iuYXW/JHl6uZULCsOqNJKDdt7ef/XpR3cI=;
  b=dUSD0NDFE87qu/XSjltKB8ttfYqlJtt8kYMd8FL89T/+W7z/kRN8fdfh
   64LLfdwRbaSdc6SdMFBHKZY897Vr+itToihGvnUUi6PdwtgTzJOMq5ROF
   OXu1Z8Ftmbkly1V8G5PHHKcOWJE0joBAFWZbQtPxRiMemrqZFG00jbJDs
   ClA8h6XP/3PQK9CuH05bC0Pw2U2MtGj1b8l8TDCS1sugDXdilKmGSJ4FY
   YuTQ4Pnk+C6T4w4ZbmrvhGKylX/Rm9VwoG9d4uZO70yLyB8ZvQ94SW2YI
   qVKLmDcwfiaavtotP2Kq084lsogto6aVlFaIJUF4hNHI6AgudKjRJF2Cn
   A==;
X-CSE-ConnectionGUID: HcRaj+8TTaKeIargJQRqvw==
X-CSE-MsgGUID: rk65nP1RTW6cT/Y0WnXTxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55499663"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55499663"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 20:13:07 -0700
X-CSE-ConnectionGUID: ql6y3W6dTaaISLzB02pm2A==
X-CSE-MsgGUID: +KVw6cOgS5qwYXJHyC+xYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="190001130"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 20:13:04 -0700
Message-ID: <529ca56f-5bdc-47ad-8d0d-6b3b5c800c7a@linux.intel.com>
Date: Tue, 22 Jul 2025 11:11:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 03:57, Jason Gunthorpe wrote:
> The VT-D second stage format is almost the same as the x86 PAE format,
> except the bit encodings in the PTE are different and a few new PTE
> features, like force coherency are present.
> 
> Among all the formats it is unique in not having a designated present bit.
> 
> Comparing the performance of several operations to the existing version:
> 
> iommu_map()
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,     53,66    ,      50,64      ,  21.21
>       2^21,     59,70    ,      56,67      ,  16.16
>       2^30,     54,66    ,      52,63      ,  17.17
>   256*2^12,    384,524   ,     337,516     ,  34.34
>   256*2^21,    387,632   ,     336,626     ,  46.46
>   256*2^30,    376,629   ,     323,623     ,  48.48
> 
> iommu_unmap()
>     pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>       2^12,     67,86    ,      63,84      ,  25.25
>       2^21,     64,84    ,      59,80      ,  26.26
>       2^30,     59,78    ,      56,74      ,  24.24
>   256*2^12,    216,335   ,     198,317     ,  37.37
>   256*2^21,    245,350   ,     232,344     ,  32.32
>   256*2^30,    248,345   ,     226,339     ,  33.33

Nice to see this. Thank you!

> 
> Cc: Tina Zhang <tina.zhang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/.kunitconfig      |   1 +
>   drivers/iommu/generic_pt/Kconfig           |  12 +
>   drivers/iommu/generic_pt/fmt/Makefile      |   2 +
>   drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
>   drivers/iommu/generic_pt/fmt/iommu_vtdss.c |  10 +
>   drivers/iommu/generic_pt/fmt/vtdss.h       | 289 +++++++++++++++++++++
>   include/linux/generic_pt/common.h          |  18 ++
>   include/linux/generic_pt/iommu.h           |  11 +
>   8 files changed, 364 insertions(+)
>   create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
>   create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
>   create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h
> 
> diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
> index 5265d884e79cea..2f9b6060e3b983 100644
> --- a/drivers/iommu/generic_pt/.kunitconfig
> +++ b/drivers/iommu/generic_pt/.kunitconfig
> @@ -4,6 +4,7 @@ CONFIG_DEBUG_GENERIC_PT=y
>   CONFIG_IOMMU_PT=y
>   CONFIG_IOMMU_PT_AMDV1=y
>   CONFIG_IOMMU_PT_RISCV64=y
> +CONFIG_IOMMU_PT_VTDSS=y
>   CONFIG_IOMMU_PT_X86_64=y
>   CONFIG_IOMMU_PT_KUNIT_TEST=y
>   
> diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
> index 953856e4b48369..b631cf00eba559 100644
> --- a/drivers/iommu/generic_pt/Kconfig
> +++ b/drivers/iommu/generic_pt/Kconfig
> @@ -56,6 +56,17 @@ config IOMMU_PT_RISCV64
>   
>   	  Selected automatically by an IOMMU driver that uses this format.
>   
> +config IOMMU_PT_VTDSS
> +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
> +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> +	default n

The default value is a "n". So what's the value of putting a "default n"
here?

> +	help
> +	  iommu_domain implementation for the Intel VT-D IOMMU's 64 bit 3/4/5
> +	  level Second Stage page table. It is similar to the X86_64 format with
> +	  4M/2M/1G page sizes.

typo

s/4M/4k/

> +
> +	  Selected automatically by an IOMMU driver that uses this format.
> +
>   config IOMMU_PT_X86_64
>          tristate "IOMMU page table for x86 64 bit, 4/5 levels"
>   	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> @@ -72,6 +83,7 @@ config IOMMU_PT_KUNIT_TEST
>   	depends on KUNIT
>   	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
>   	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
> +	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS

This line implies that the IOMMU_PT kunit test functions regardless of
whether IOMMU_PT_VTDSS is enabled. But if IOMMU_PT_VTDSS is enabled,
this kunit test will also cover it. Do I understand this correctly?

>   	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
>   	default KUNIT_ALL_TESTS
>   	help
> diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
> index 9c0edc4d5396b3..6fe95fc8466523 100644
> --- a/drivers/iommu/generic_pt/fmt/Makefile
> +++ b/drivers/iommu/generic_pt/fmt/Makefile
> @@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
>   
>   iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
>   
> +iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
> +
>   iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
>   
>   IOMMU_PT_KUNIT_TEST :=
> diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
> new file mode 100644
> index 00000000000000..4a239bcaae2a90
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + *
> + */
> +#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
> +#define __GENERIC_PT_FMT_DEFS_VTDSS_H
> +
> +#include <linux/generic_pt/common.h>
> +#include <linux/types.h>
> +
> +typedef u64 pt_vaddr_t;
> +typedef u64 pt_oaddr_t;
> +
> +struct vtdss_pt_write_attrs {
> +	u64 descriptor_bits;
> +	gfp_t gfp;
> +};
> +#define pt_write_attrs vtdss_pt_write_attrs
> +
> +#endif
> diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
> new file mode 100644
> index 00000000000000..f551711e2a336d
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + */
> +#define PT_FMT vtdss
> +#define PT_SUPPORTED_FEATURES                                            \
> +	(BIT(PT_FEAT_FLUSH_RANGE) | BIT(PT_FEAT_VTDSS_FORCE_COHERENCE) | \
> +	 BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) | BIT(PT_FEAT_DMA_INCOHERENT))
> +
> +#include "iommu_template.h"
> diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
> new file mode 100644
> index 00000000000000..262fe3538c4c4b
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/vtdss.h
> @@ -0,0 +1,289 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + *
> + * Intel VT-D Second Stange 5/4 level page table
> + *
> + * This is described in
> + *   Section "3.7 Second-Stage Translation"
> + *   Section "9.8 Second-Stage Paging Entries"
> + *
> + * Of the "Intel Virtualization Technology for Directed I/O Architecture
> + * Specification".
> + *
> + * The named levels in the spec map to the pts->level as:
> + *   Table/SS-PTE - 0
> + *   Directory/SS-PDE - 1
> + *   Directory Ptr/SS-PDPTE - 2
> + *   PML4/SS-PML4E - 3
> + *   PML5/SS-PML5E - 4
> + */
> +#ifndef __GENERIC_PT_FMT_VTDSS_H
> +#define __GENERIC_PT_FMT_VTDSS_H
> +
> +#include "defs_vtdss.h"
> +#include "../pt_defs.h"
> +
> +#include <linux/bitfield.h>
> +#include <linux/container_of.h>
> +#include <linux/log2.h>
> +
> +enum {
> +	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
> +	PT_MAX_VA_ADDRESS_LG2 = 57,
> +	PT_ITEM_WORD_SIZE = sizeof(u64),
> +	PT_MAX_TOP_LEVEL = 4,
> +	PT_GRANULE_LG2SZ = 12,
> +	PT_TABLEMEM_LG2SZ = 12,
> +
> +	/* SSPTPTR is 4k aligned and limited by HAW */
> +	PT_TOP_PHYS_MASK = GENMASK_ULL(63, 12),
> +};
> +
> +/* Shared descriptor bits */
> +enum {
> +	VTDSS_FMT_R = BIT(0),
> +	VTDSS_FMT_W = BIT(1),
> +	VTDSS_FMT_A = BIT(8),
> +	VTDSS_FMT_D = BIT(9),
> +	VTDSS_FMT_SNP = BIT(11),
> +	VTDSS_FMT_OA = GENMASK_ULL(51, 12),
> +};
> +
> +/* PDPTE/PDE */
> +enum {
> +	VTDSS_FMT_PS = BIT(7),
> +};
> +
> +#define common_to_vtdss_pt(common_ptr) \
> +	container_of_const(common_ptr, struct pt_vtdss, common)
> +#define to_vtdss_pt(pts) common_to_vtdss_pt((pts)->range->common)
> +
> +static inline pt_oaddr_t vtdss_pt_table_pa(const struct pt_state *pts)
> +{
> +	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
> +			  PT_TABLEMEM_LG2SZ);
> +}
> +#define pt_table_pa vtdss_pt_table_pa
> +
> +static inline pt_oaddr_t vtdss_pt_entry_oa(const struct pt_state *pts)
> +{
> +	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
> +			  PT_GRANULE_LG2SZ);
> +}
> +#define pt_entry_oa vtdss_pt_entry_oa
> +
> +static inline bool vtdss_pt_can_have_leaf(const struct pt_state *pts)
> +{
> +	return pts->level <= 2;
> +}
> +#define pt_can_have_leaf vtdss_pt_can_have_leaf
> +
> +static inline unsigned int vtdss_pt_num_items_lg2(const struct pt_state *pts)
> +{
> +	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
> +}
> +#define pt_num_items_lg2 vtdss_pt_num_items_lg2
> +
> +static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
> +{
> +	const u64 *tablep = pt_cur_table(pts, u64);
> +	u64 entry;
> +
> +	pts->entry = entry = READ_ONCE(tablep[pts->index]);
> +	if (!entry)
> +		return PT_ENTRY_EMPTY;

Would it be more reasonable to check the present bit of the entry here?
Otherwise, it implies that when a PTE is non-present, all fields must be
cleared. I'm concerned about any potential corner cases.

> +	if (pts->level == 0 ||
> +	    (vtdss_pt_can_have_leaf(pts) && (pts->entry & VTDSS_FMT_PS)))
> +		return PT_ENTRY_OA;
> +	return PT_ENTRY_TABLE;
> +}
> +#define pt_load_entry_raw vtdss_pt_load_entry_raw
> +
> +static inline void
> +vtdss_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
> +			    unsigned int oasz_lg2,
> +			    const struct pt_write_attrs *attrs)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64);
> +	u64 entry;
> +
> +	entry = FIELD_PREP(VTDSS_FMT_OA, log2_div(oa, PT_GRANULE_LG2SZ)) |
> +		attrs->descriptor_bits;
> +	if (pts->level != 0)
> +		entry |= VTDSS_FMT_PS;
> +
> +	WRITE_ONCE(tablep[pts->index], entry);
> +	pts->entry = entry;
> +}
> +#define pt_install_leaf_entry vtdss_pt_install_leaf_entry
> +
> +static inline bool vtdss_pt_install_table(struct pt_state *pts,
> +					  pt_oaddr_t table_pa,
> +					  const struct pt_write_attrs *attrs)
> +{
> +	u64 entry;
> +
> +	entry = VTDSS_FMT_R | VTDSS_FMT_W |
> +		FIELD_PREP(VTDSS_FMT_OA, log2_div(table_pa, PT_GRANULE_LG2SZ));
> +	return pt_table_install64(pts, entry);
> +}
> +#define pt_install_table vtdss_pt_install_table
> +
> +static inline void vtdss_pt_attr_from_entry(const struct pt_state *pts,
> +					    struct pt_write_attrs *attrs)
> +{
> +	attrs->descriptor_bits = pts->entry &
> +				 (VTDSS_FMT_R | VTDSS_FMT_W | VTDSS_FMT_SNP);
> +}
> +#define pt_attr_from_entry vtdss_pt_attr_from_entry
> +
> +static inline bool vtdss_pt_entry_write_is_dirty(const struct pt_state *pts)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +
> +	return READ_ONCE(*tablep) & VTDSS_FMT_D;
> +}
> +#define pt_entry_write_is_dirty vtdss_pt_entry_write_is_dirty
> +
> +static inline void vtdss_pt_entry_set_write_clean(struct pt_state *pts)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +
> +	WRITE_ONCE(*tablep, READ_ONCE(*tablep) & ~(u64)VTDSS_FMT_D);
> +}
> +#define pt_entry_set_write_clean vtdss_pt_entry_set_write_clean
> +
> +static inline bool vtdss_pt_entry_make_write_dirty(struct pt_state *pts)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +	u64 new = pts->entry | VTDSS_FMT_D;
> +
> +	return try_cmpxchg64(tablep, &pts->entry, new);
> +}
> +#define pt_entry_make_write_dirty vtdss_pt_entry_make_write_dirty
> +
> +static inline unsigned int vtdss_pt_max_sw_bit(struct pt_common *common)
> +{
> +	return 11;
> +}
> +#define pt_max_sw_bit vtdss_pt_max_sw_bit
> +
> +static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
> +{
> +	/* Bits marked Ignored in the specification */
> +	switch (bitnr) {
> +	case 0:
> +		return BIT(10);
> +	case 1 ... 10:
> +		return BIT_ULL((bitnr - 1) + 52);
> +	case 11:
> +		return BIT_ULL(63);
> +	/* Remaing bits 9-3  are only available in some entries */
> +	default:
> +		if (__builtin_constant_p(bitnr))
> +			BUILD_BUG();
> +		else
> +			PT_WARN_ON(true);
> +		return 0;
> +	}
> +}
> +#define pt_sw_bit vtdss_pt_sw_bit
> +
> +/* --- iommu */
> +#include <linux/generic_pt/iommu.h>
> +#include <linux/iommu.h>
> +
> +#define pt_iommu_table pt_iommu_vtdss
> +
> +/* The common struct is in the per-format common struct */
> +static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
> +{
> +	return &container_of(iommu_table, struct pt_iommu_table, iommu)
> +			->vtdss_pt.common;
> +}
> +
> +static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
> +{
> +	return &container_of(common, struct pt_iommu_table, vtdss_pt.common)
> +			->iommu;
> +}
> +
> +static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
> +					  struct pt_write_attrs *attrs,
> +					  unsigned int iommu_prot)
> +{
> +	u64 pte = 0;
> +
> +	/*
> +	 * VTDSS does not have a present bit, so we tell if any entry is present
> +	 * by checking for R or W.
> +	 */
> +	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
> +		return -EINVAL;
> +
> +	if (iommu_prot & IOMMU_READ)
> +		pte |= VTDSS_FMT_R;
> +	if (iommu_prot & IOMMU_WRITE)
> +		pte |= VTDSS_FMT_W;
> +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
> +		pte |= VTDSS_FMT_SNP;

The comment says:

  /*
   * The PTEs are set to prevent cache incoherent traffic, such as PCI no
   * snoop. This is set either at creation time or before the first map
   * operation.
   */
   PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,

It seems that you are okay with setting this feature after iommu_pt
creation and before the first map operation? Do we still need to reform
the enforce_cache_coherency callback mechanism?

> +
> +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_WRITEABLE) &&
> +	    !(iommu_prot & IOMMU_READ)) {
> +		pr_err_ratelimited(
> +			"Read-only mapping is disallowed on the domain which serves as the parent in a nested configuration, due to HW errata (ERRATA_772415_SPR17)\n");
> +		return -EINVAL;
> +	}
> +
> +	attrs->descriptor_bits = pte;
> +	return 0;
> +}
> +#define pt_iommu_set_prot vtdss_pt_iommu_set_prot
> +
> +static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
> +					  const struct pt_iommu_vtdss_cfg *cfg)
> +{
> +	struct pt_vtdss *table = &iommu_table->vtdss_pt;
> +	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
> +
> +	if (vasz_lg2 > PT_MAX_VA_ADDRESS_LG2)
> +		return -EOPNOTSUPP;
> +	else if (vasz_lg2 > 48)
> +		pt_top_set_level(&table->common, 4);
> +	else if (vasz_lg2 > 39)
> +		pt_top_set_level(&table->common, 3);
> +	else if (vasz_lg2 > 30)
> +		pt_top_set_level(&table->common, 2);
> +	else
> +		return -EOPNOTSUPP;
> +	return 0;
> +}
> +#define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
> +
> +static inline void
> +vtdss_pt_iommu_fmt_hw_info(struct pt_iommu_vtdss *table,
> +			   const struct pt_range *top_range,
> +			   struct pt_iommu_vtdss_hw_info *info)
> +{
> +	info->ssptptr = virt_to_phys(top_range->top_table);
> +	PT_WARN_ON(info->ssptptr & ~PT_TOP_PHYS_MASK);
> +	/*
> +	 * top_level = 2 = 3 level table aw=1
> +	 * top_level = 3 = 4 level table aw=2
> +	 * top_level = 4 = 5 level table aw=3
> +	 */
> +	info->aw = top_range->top_level - 1;
> +}
> +#define pt_iommu_fmt_hw_info vtdss_pt_iommu_fmt_hw_info
> +
> +#if defined(GENERIC_PT_KUNIT)
> +static const struct pt_iommu_vtdss_cfg vtdss_kunit_fmt_cfgs[] = {
> +	[0] = { .common.hw_max_vasz_lg2 = 39 },
> +	[1] = { .common.hw_max_vasz_lg2 = 48 },
> +	[2] = { .common.hw_max_vasz_lg2 = 57 },
> +};
> +#define kunit_fmt_cfgs vtdss_kunit_fmt_cfgs
> +enum { KUNIT_FMT_FEATURES = 0 };
> +#endif
> +#endif
> diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
> index 1b97bbfaa4f90a..fa6e36e0b9efa3 100644
> --- a/include/linux/generic_pt/common.h
> +++ b/include/linux/generic_pt/common.h
> @@ -171,6 +171,24 @@ enum {
>   	PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
>   };
>   
> +struct pt_vtdss {
> +	struct pt_common common;
> +};
> +
> +enum {
> +	/*
> +	 * The PTEs are set to prevent cache incoherent traffic, such as PCI no
> +	 * snoop. This is set either at creation time or before the first map
> +	 * operation.
> +	 */
> +	PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
> +	/*
> +	 * Prevent creating read-only PTEs. Used to work around HW errata
> +	 * ERRATA_772415_SPR17.
> +	 */
> +	PT_FEAT_VTDSS_FORCE_WRITEABLE,
> +};
> +
>   struct pt_x86_64 {
>   	struct pt_common common;
>   };
> diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
> index 7cec42a8efbb04..8f4a58d8c48899 100644
> --- a/include/linux/generic_pt/iommu.h
> +++ b/include/linux/generic_pt/iommu.h
> @@ -271,6 +271,17 @@ struct pt_iommu_riscv_64_hw_info {
>   
>   IOMMU_FORMAT(riscv_64, riscv_64pt);
>   
> +struct pt_iommu_vtdss_cfg {
> +	struct pt_iommu_cfg common;
> +};
> +
> +struct pt_iommu_vtdss_hw_info {
> +	u64 ssptptr;
> +	u8 aw;
> +};
> +
> +IOMMU_FORMAT(vtdss, vtdss_pt);
> +
>   struct pt_iommu_x86_64_cfg {
>   	struct pt_iommu_cfg common;
>   };

Thanks,
baolu

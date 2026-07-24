Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FC38A70A
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784921054; cv=none; b=HqwwZatuqX+nG5BKjqAZ/aHFuNRp1H8nkvrYJRE9tkpfFm66uhENgNFQO423Ku/rt8QX7FRRrmm9TV++K/h7QeOSUtW5Nb1KhuHV32kQgDLi1Y6I3vmk1BY/QvwIS9sVR7/qdbkagyBHQgq73g4Q+SetlIdR1H86MtAyYAX3Kvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784921054; c=relaxed/simple;
	bh=6n0PrMBWoS0sPQXahu2AXqIyzUhB0AuhgYBoeZAZIvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C17QEWrcUW3glqaW07ZUje1G7igw9SCjxYFQh1U39Gy8Uv+QQU+qOrHTfUl0sXVCXVYosT1h5Db6PYw3TS4302poiRxZpZ2K7Yn8LgoNoe6j58CPtl7KjmDpBTEy0aOzTxvOa7qtJlclFdXlhbjEvPW2lWVqUNkgFjTUcBe93HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sf5q2sm9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sf5q2sm9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954bb689dfso95e9.1
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784921049; x=1785525849; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fW3/tPOjJ9YD7ga7B9qWjKJD0av7wYJVzQ+5i41ieOQ=;
        b=sf5q2sm95EbeVhJXXOu6D4HwKo0V0TgRGHxLEZ4xSGjJ2gTW0jExRAHxqxktb2pkAN
         udV4PEdb3QgTH7gl2lZ1ns0WfVltcKvZVeIdEZtxXk2Bvt5sQhv637AH+asXu7NG8TKd
         seFxT/OidWIaIxXGy7Ki8wU0xovWLcuXfMEc9MIgWQA8cgUA2yTbi6JRH3XBFLRMOI6e
         vk8pnoBe68PENHoRimKZGOQklFDo1l6PV8jAkEsNeIBS3XHKyde8x/31/SXB3rG2n7kr
         3OMIrw3q3MuT/LYEM5jAD0z9+FeGvSEXgdd0/I+JWXR1DRSNRQdWSAaSkOZOhXnUY83K
         yEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784921049; x=1785525849;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fW3/tPOjJ9YD7ga7B9qWjKJD0av7wYJVzQ+5i41ieOQ=;
        b=AJ+1Mei31s2ayw89BkF6UhJB/KjtcuS+igdUg7tEJlXqtZssfas40sdiKlpj+3qh1x
         ZaDD1RIw60BhDKkdLqK8siwbucKOfms6X5DPoaxCgh1wfKiqfOdpHS6UXbFNHX4QBk4Q
         p+FkTv3V1jULPOxs/XJ0i2Q5YvWmhENXZKE/NAMcQDCv5VN4Y92gnF+bw03kz9q32g28
         U6tBtpHgS+zy6jsxANiaYxVNMHVQ1LH8/+/125yxrJ17gvfddrMJ921P8Vlt5XheoEVR
         FtLWHxVItEXmXqMUM15KssHXF7w7BVwax6KcftSUISk8zFUwNk4xZRETks7nSccbcDFf
         Y1vg==
X-Forwarded-Encrypted: i=1; AHgh+RpLTj8UEQ1UgnBF4xQ7mqiNAT9SizRAvgRs1T7xURK1TJdL8nfVj5VknmWKH8pIeItwN3tfysvc@lists.linux.dev
X-Gm-Message-State: AOJu0YwoR3RRWW6ygQE3jidR4wHYRJ/DCrb0fOG5SnHlrxLCejWZXzVI
	FRDCxpA2/U3WlS19cscTBgAtGDUrvYL+oqO1hw1Mkp+w6ikdXchWBP8Ldni4SiFwjg==
X-Gm-Gg: AR+sD13IsSo7n+uFPw+pBB5YQKVJz2XeDLlHcgKNkgiF0gngR3Pyf4iqYP6LT2XYr+7
	wKwd7Qpf3nsqH7Pl5d4WdUKK33GqvwlI4XQN1O5QMi8fQgZWr92Rrd/N4vXV0sUP/4XosneLQ1q
	qnUNoME0x0J+mEV0yPjj+FscSpGxVAKLvJWxNmmZUe2lnS5vVui9m8uvALXO1fVR3ZUUXlmu5ge
	n8v5nos5PGU9N/E9rkZdJlISBbJS+KP/zw5Ai0GJTRxLfWL09hSsXxhwRUnZUPp/Fs6yvEniNMd
	tjNXx9U/4CSNF+pJ1JxLNc6xxz+X3HqdUAsT7XBgo2+0n8+uNBKm4TZtNN2b0s+i6MOwnDLOWkf
	cSTISEglMOjlVkKzB89VIvbFUUjf64jG9xop4eL8q62fMWxpcG3oQRvQNHG+IAoNCpX9wlvmsAF
	fynGT9bxhgWkMfYaAiuePrlj3AYR9gjRf6VjSmig==
X-Received: by 2002:a05:600c:6a8d:b0:493:b47f:a24 with SMTP id 5b1f17b1804b1-496b4d2f236mr156575e9.6.1784921047918;
        Fri, 24 Jul 2026 12:24:07 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c66cebsm26168326f8f.30.2026.07.24.12.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:24:07 -0700 (PDT)
Date: Fri, 24 Jul 2026 19:24:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 3/7] iommupt: Add the 64 bit ARMv8 page table format
Message-ID: <amO70_Bx0hM10xUn@google.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <3-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:29:09PM -0300, Jason Gunthorpe wrote:
> The features, format and naming is taking from the ARMv8 VMSAv8-64
> chapter. By far ARMv8 is the most complex format supported by generic page
> table, with the largest number of options and configurations.
> 
> ARMv8 uses almost all the features of the common implementation:
> 
>  - Contiguous pages
>  - Leaf pages at many levels
>  - Variable starting top level
>  - Variable size top level supporting concatenated tables with a high
>  - order top table allocation
>  - Dirty tracking
>  - Low (TTB0) or high (TTB1) starting VA
>  - Software bits
> 
> Compared to the io-pgtable version this also implements the contiguous
> page hint, and supports dirty readback from the S2. It implements the
> original io-pgtable intention of always using S2 concatenated tables
> instead of only when mandatory.

I believe the intention of the original code was to use concatenation
at level 0 to reduce the table walk. Always using concatenation will
have a trade-off between high order allocations at runtime which can
happen late with VFIO vs walk length .

> 
> iommupt's incoherent flushing algorithm was modeled after the ARM
> io-pgtable version so there is no change here.
> 
> Additionaly it includes implementations for the LPA, LVA, and LPA2
> features however they will be compiled off for the iommu build until a
> driver actually needs thems. With these features it can support the "level
> -1" to produce a 5 level table similar to x86, as well as all the
> different placements of OA bits defined by the spec.
> 
> This is supported by a compare test that creates parallel iommupt and
> io-pgtable instances with matching parameters and validates that every
> tree level is the "same" across several meaningful tests. It covers the S2
> concatenated pages, the recent bugs found in the io-pgtable logic and a
> range of VA sizes.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/.kunitconfig      |    1 +
>  drivers/iommu/generic_pt/Kconfig           |   12 +
>  drivers/iommu/generic_pt/fmt/Makefile      |    2 +
>  drivers/iommu/generic_pt/fmt/armv8.h       | 1124 ++++++++++++++++++++
>  drivers/iommu/generic_pt/fmt/defs_armv8.h  |   23 +
>  drivers/iommu/generic_pt/fmt/iommu_armv8.c |   13 +
>  include/linux/generic_pt/common.h          |   42 +
>  include/linux/generic_pt/iommu.h           |   73 ++
>  8 files changed, 1290 insertions(+)
>  create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c
> 

[...]

> +}
> +#define pt_full_va_prefix armv8pt_full_va_prefix
> +
> +static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
> +{
> +	/* It is not allowed to call pt_num_items_lg2() at the top level */
> +	PT_WARN_ON(pts->level == pts->range->top_level);

This is a bit confusing, there is not a similar check at
armv8pt_table_item_lg2sz(), that's because the core code assumes this
does not deal with concatenation and uses max_vasz_lg2 to figure it
out. I think we should have consistent semantics for this.

> +	return armv8pt_granule_lg2sz(pts) - ilog2(sizeof(u64));
> +}
> +#define pt_num_items_lg2 armv8pt_num_items_lg2
> +
> +static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
> +{
> +	const u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +	u64 entry;
> +
> +	pts->entry = entry = READ_ONCE(*tablep);
> +	if (!(entry & ARMV8PT_FMT_VALID))
> +		return PT_ENTRY_EMPTY;
> +	/* R_RWMFF/Table D8-48: ARM level 3 has only Page descriptors */
> +	if (pts->level != ARML3 && (entry & ARMV8PT_FMT_TABLE))
> +		return PT_ENTRY_TABLE;
> +
> +	/*
> +	 * Suppress returning OA for levels that cannot have a page to remove
> +	 * code.
> +	 */
> +	if (!armv8pt_can_have_leaf(pts))
> +		return PT_ENTRY_EMPTY;

If this is not a valid PTE and not a table as checked above, what
does this check catch?

> +
> +	/* Must be a block or page, don't check the page bit on level 0 */
> +	return PT_ENTRY_OA;
> +}

[...]

> +static inline void armv8pt_clear_entries(struct pt_state *pts,
> +					 unsigned int num_contig_lg2)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +
> +	if (num_contig_lg2 == 0)
> +		WRITE_ONCE(*tablep, 0);
> +	else
> +		memset64(tablep, 0, log2_to_int(num_contig_lg2));

I am not sure about that, memset64 just uses raw pointers,
I believe we need WRITE_ONCE for PTEs.

> +}
> +#define pt_clear_entries armv8pt_clear_entries
> +
> +/*
> + * Call fn over all the items in an entry. If the entry is contiguous this
> + * iterates over the entire contiguous entry, including items preceding
> + * pts->va. always_inline avoids an indirect function call.
> + */
> +static __always_inline bool armv8pt_reduce_contig(const struct pt_state *pts,
> +						  bool (*fn)(u64 *tablep,
> +							     u64 entry))
> +{
> +	u64 *tablep = pt_cur_table(pts, u64);
> +
> +	if (pts->entry & ARMV8PT_FMT_CONTIG) {
> +		unsigned int num_contig_lg2 = armv8pt_contig_count_lg2(pts);
> +		u64 *end;
> +
> +		tablep += log2_set_mod(pts->index, 0, num_contig_lg2);
> +		end = tablep + log2_to_int(num_contig_lg2);
> +		for (; tablep != end; tablep++)
> +			if (fn(tablep, READ_ONCE(*tablep)))
> +				return true;
> +		return false;
> +	}
> +	return fn(tablep + pts->index, pts->entry);
> +}
> +
> +static inline bool armv8pt_check_is_dirty_s1(u64 *tablep, u64 entry)
> +{
> +	return (entry & (ARMV8PT_FMT_DBM |
> +			 FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY))) ==
> +	       ARMV8PT_FMT_DBM;
> +}
> +
> +static bool armv6pt_clear_dirty_s1(u64 *tablep, u64 entry)

Typo, we do not want to support so old hardware :)

> +{
> +	WRITE_ONCE(*tablep,
> +		   entry | FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY));
> +	return false;
> +}
> +
> +static inline bool armv8pt_check_is_dirty_s2(u64 *tablep, u64 entry)
> +{
> +	const u64 DIRTY = ARMV8PT_FMT_DBM |
> +			  FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
> +
> +	return (entry & DIRTY) == DIRTY;
> +}
> +
> +static bool armv6pt_clear_dirty_s2(u64 *tablep, u64 entry)

Another typo.

> +{
> +	WRITE_ONCE(*tablep, entry & ~(u64)FIELD_PREP(ARMV8PT_FMT_S2AP,
> +						     ARMV8PT_S2AP_WRITE));
> +	return false;
> +}
> +
> +static inline bool armv8pt_entry_is_write_dirty(const struct pt_state *pts)
> +{
> +	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
> +		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s1);
> +	else
> +		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s2);
> +}
> +#define pt_entry_is_write_dirty armv8pt_entry_is_write_dirty
> +
> +static inline void armv8pt_entry_make_write_clean(struct pt_state *pts)
> +{
> +	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
> +		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s1);
> +	else
> +		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s2);
> +}
> +#define pt_entry_make_write_clean armv8pt_entry_make_write_clean
> +
> +static inline bool armv8pt_entry_make_write_dirty(struct pt_state *pts)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> +	u64 new = pts->entry;
> +
> +	if (!(pts->entry & ARMV8PT_FMT_DBM))
> +		return false;
> +
> +	if (!pts_feature(pts, PT_FEAT_ARMV8_S2)) {
> +		new &= ~(u64)ARMV8PT_FMT_AP;

Wouldn't that clear the ARMV8PT_AP_UNPRIV?

> +		new |= FIELD_PREP(ARMV8PT_FMT_AP, 0);
> +	} else {
> +		new &= ~(u64)ARMV8PT_FMT_S2AP;
> +		new |= FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);

Same, wouldn't that make the page write-only?

> +	}
> +
> +	return try_cmpxchg64(tablep, &pts->entry, new);
> +}
> +#define pt_entry_make_write_dirty armv8pt_entry_make_write_dirty
> +
> +static inline bool armv8pt_dirty_supported(struct pt_common *common)
> +{

[...]

> +
> +/*
> + * Validate the S2 initial lookup level against D8.2.
> + *
> + *   Table D8-8: "Effective minimum value of T0SZ" (R_DTLMN)
> + *   Table D8-9: "Implications of the effective minimum T0SZ value
> + *                on the initial stage 2 lookup level" (R_TDJSG)
> + *
> + * ARM initial lookup level = 3 - top_level. Table D8-9 constrains the
> + * shallowest allowed initial lookup level per PA size and granule:
> + *
> + *   4K:  ARM level 0 (top_level 3) requires PA >= 44
> + *   16K: ARM level 1 (top_level 2) requires PA >= 42
> + *   64K: ARM level 1 (top_level 2) requires PA >= 44
> + *
> + * The valid level set grows monotonically with PA size, so checking
> + * against IAS (vasz_lg2 <= PA size) is conservative.
> + *
> + * R_SRKBC: 4K granule at ARM level 3 (single entry level) requires
> + * FEAT_TTST.
> + */
> +static inline void armv8pt_s2_validate_level(unsigned int top_level,
> +					     unsigned int granule_lg2sz,
> +					     unsigned int vasz_lg2, bool lpa2)

I do not understand this, the iommupt is the one choosing the level,
and it calculates the table topology, so it should not have bugs in
the configuration and should clearly reject certain bad inputs.
Running this at then is more of a debug check that I do not think it
should exist in the default config (maybe with kunit)

> +{
> +	unsigned int max_top_level;
> +
> +	switch (granule_lg2sz) {
> +	case SZLG2_4K:
> +		if (lpa2)
> +			max_top_level =
> +				vasz_lg2 >= 52 ?
> +					ARMLn1 :
> +					(vasz_lg2 >= 44 ? ARML0 : ARML1);
> +		else
> +			max_top_level = vasz_lg2 >= 44 ? ARML0 : ARML1;
> +		break;
> +	case SZLG2_16K: /* ARM level 1 requires PA >= 42 */
> +		max_top_level = vasz_lg2 >= 42 ? ARML1 : ARML2;
> +		break;
> +	case SZLG2_64K: /* ARM level 1 requires PA >= 44 */
> +		max_top_level = vasz_lg2 >= 44 ? ARML1 : ARML2;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	PT_WARN_ON(top_level > max_top_level);
> +}
> +
> +static inline int armv8pt_oasz_to_ps(unsigned int oasz_lg2)
> +{
> +	/* Stream Table Entry: S2PS section, Context Descriptor: IPS section */
> +	switch (oasz_lg2) {
> +	case 32:
> +		return 0;
> +	case 36:
> +		return 1;
> +	case 40:
> +		return 2;
> +	case 42:
> +		return 3;
> +	case 44:
> +		return 4;
> +	case 48:
> +		return 5;
> +	case 52:
> +		return 6;
> +	default:
> +		return -1;
> +	}
> +}
> +
> +static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
> +					 const struct pt_iommu_armv8_cfg *cfg)
> +{
> +	struct pt_armv8 *armv8pt = &iommu_table->armpt;
> +	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
> +	unsigned int oasz_lg2 = cfg->common.hw_max_oasz_lg2;
> +	unsigned int granule_lg2sz = cfg->granule_lg2sz;
> +	unsigned int max_top_level;
> +	unsigned int levels;
> +
> +	if (granule_lg2sz != SZLG2_4K && granule_lg2sz != SZLG2_16K &&
> +	    granule_lg2sz != SZLG2_64K)
> +		return -EOPNOTSUPP;
> +
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_AARCH32)) {

Was that added for smmu-v2? as the smmu-v3 driver does not use it.

> +		/*
> +		 * VMSAv8-32 Long-descriptor format (G5.5):
> +		 * Uses the same 64-bit LPAE descriptors as AArch64 but with
> +		 * tighter constraints on address ranges and granule size.
> +		 * FEAT_BTI (Guard Page) is not supported either.
> +		 */
> +
> +		if (granule_lg2sz != SZLG2_4K)
> +			return -EOPNOTSUPP;
> +
> +		if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2)) {
> +			if (vasz_lg2 > 40)
> +				return -EOPNOTSUPP;
> +		} else {
> +			if (vasz_lg2 > 32)
> +				return -EOPNOTSUPP;
> +		}
> +
> +		if (oasz_lg2 > 40)
> +			return -EOPNOTSUPP;
> +
> +		if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA) ||
> +		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
> +		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2FWB) ||
> +		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
> +		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_DBM))
> +			return -EOPNOTSUPP;
> +	}
> +
> +	armv8pt->granule_lg2sz = granule_lg2sz;
> +	max_top_level =
> +		armv8pt_max_top_level(granule_lg2sz, armv8pt->common.features);
> +
> +	/* The NS quirk doesn't apply at stage 2 */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_NS) &&
> +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
> +		return -EOPNOTSUPP;
> +

This seems a bit random, there are others incompatible features as
PT_FEAT_ARMV8_TTBR1 && PT_FEAT_ARMV8_S2 and PT_FEAT_ARMV8_S2FWB &&
!PT_FEAT_ARMV8_S2. Maybe there should be a validate() function to
make sure all features work together.

> +	/* LPA2 (DS=1) is only valid for 4K and 16K granules */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) &&
> +	    granule_lg2sz == SZLG2_64K)
> +		return -EOPNOTSUPP;
> +
> +	/* LPA is only valid for the 64K granule */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA) &&
> +	    granule_lg2sz != SZLG2_64K)
> +		return -EOPNOTSUPP;
> +
> +	/* LVA is only valid for 64K granule Stage 1 */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) &&
> +	    (granule_lg2sz != SZLG2_64K ||
> +	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2)))
> +		return -EOPNOTSUPP;
> +
> +	if (vasz_lg2 <= granule_lg2sz)
> +		return -EINVAL;

When can this happen?

> +
> +	/* R_QQQSJ: Limit the OA to what the format supports */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
> +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA))
> +		armv8pt->common.max_oasz_lg2 = min(52, oasz_lg2);
> +	else
> +		armv8pt->common.max_oasz_lg2 = min(48, oasz_lg2);
> +
> +	if (armv8pt_oasz_to_ps(armv8pt->common.max_oasz_lg2) < 0)
> +		return -EOPNOTSUPP;
> +
> +	if (WARN_ON(armv8pt->common.max_oasz_lg2 > PT_MAX_OUTPUT_ADDRESS_LG2))
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Limit the VA/IPA to what the format supports:
> +	 *  - LPA2: 52-bit VA for 4K/16K (S1 and S2)
> +	 *  - LVA:  52-bit VA for 64K S1
> +	 *  - LPA:  52-bit IPA for 64K S2
> +	 */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
> +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
> +	    (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
> +	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA)))
> +		armv8pt->common.max_vasz_lg2 = min(52, vasz_lg2);
> +	else
> +		armv8pt->common.max_vasz_lg2 = min(48, vasz_lg2);
> +	vasz_lg2 = armv8pt->common.max_vasz_lg2;
> +
> +	levels = DIV_ROUND_UP(vasz_lg2 - granule_lg2sz,
> +			      granule_lg2sz - ilog2(sizeof(u64)));
> +	if (levels > max_top_level + 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * R_SRKBC: For the 4KB granule, an initial lookup level of 3 is
> +	 * only supported if FEAT_TTST is implemented. See Table D8-9 and
> +	 * Table D8-24. FEAT_TTST is not supported.
> +	 */
> +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
> +	    granule_lg2sz == SZLG2_4K && levels == 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * D8.2.2: Always use the S2 concatenated tables feature (I_TDMHR)
> +	 * to fold a top level of up to 16 tables into the next lower
> +	 * level. Since FEAT_TTST is not supported single level cannot be
> +	 * selected here either. Notice that there are a number of cases
> +	 * in the spec that require concatenated tables (eg R_DXBSH),
> +	 * since this always uses them it is OK. See commit 4dcac8407fe1
> +	 * ("iommu/io-pgtable-arm: Fix stage-2 concatenation with 16K")
> +	 */
> +	if (!pt_feature(&armv8pt->common, PT_FEAT_DYNAMIC_TOP) &&

Should not PT_FEAT_DYNAMIC_TOP be always false for armv8?

> +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) && levels > 1) {
> +		unsigned int topsz_lg2 =
> +			vasz_lg2 -
> +			(granule_lg2sz +
> +			 (granule_lg2sz - ilog2(sizeof(u64))) * (levels - 1));
> +		if (topsz_lg2 <= ilog2(16))
> +			levels--;
> +	}

I am not sure that applies for AARCH32, spec says:
	This use of concatenated translation tables is:
	[...]
	Supported for a stage 2 translation with an input address range of
	31-34 bits


Thanks,
Mostafa


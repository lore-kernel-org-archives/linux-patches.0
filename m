Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F8D13C9AA
	for <patches@lists.linux.dev>; Thu,  9 May 2024 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715221070; cv=none; b=moOpLuhp/Z/KOjDvWFFAOfJtpkexhce06OzZAIyQdP3u6WUQg8EUmwZHWd/vkKNZ4fWFYdHISP1ZX/GWlGEQFqsZ2rj8Wf1cBIRV9WGHkBuVvMxjlz9dYUCTgAVrZvh1xL/b8h70/dR8xqcGIRvKNEODX6UU3IWATLWGAc8SVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715221070; c=relaxed/simple;
	bh=FwFrGQycwEsdaZqrgevNZtHDtzifx8foBIsTGmp9mb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=AV7VOZMJBmJJiEOfM/DqSWqyzo6CZrB3+u/ouAUPHL3jDswetI1nUhMYjWwnjnYk1m87mfnByNYbWJ7maF+JkpMj5nFiCHlxE7AhupB2DgqRW/+7wzF7q2SViBcHlqlF3GZmGSzuVezXpR5jNJRJiomySvguPKx1nA6Dldyd0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKD82k04; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKD82k04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715221066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kTMSGDGzUD2kxG1GS5r+o7cpzTBukSuL8ZSyifjKf+M=;
	b=cKD82k0407z77qwNl4oew8jAhmOfI39cL+4mfbZ6E+MFnJ6zJBlxYQbr92ZlCUoQjHmyqj
	rQ1sbZoW5ShpS+7OnI3D+aAV8W/GS2z6q0mYToG4WZLDYXjeCW4P5hVmf6DRel2eW1jTLH
	VHcfjy+t9pQ/QBeIHsIAV2ycFv7pdv4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-e-DGsHmHPOCWYgdNW2ICGQ-1; Wed, 08 May 2024 22:17:44 -0400
X-MC-Unique: e-DGsHmHPOCWYgdNW2ICGQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2b4330e5119so338045a91.3
        for <patches@lists.linux.dev>; Wed, 08 May 2024 19:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715221063; x=1715825863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTMSGDGzUD2kxG1GS5r+o7cpzTBukSuL8ZSyifjKf+M=;
        b=YIz7TWONTb90px4jnI/rWfXRGwmGHfWX8bbmi++AvWAnyGeURI0eVayrixX9s0xv57
         vj1UMWbuMO8MrLG8QvtbGDiWGLZwrRc0xjuj6w5AcE630xjeDQ5HM1SVhyMqLbhX3zB7
         yiBLGA5aj6vMeG7nRDryVoO0JvYhEWsgtMJgKQEmd4GfrbsErTRVX2m9oWZxkHib/wu1
         fQtfLXLJWONoWSuxOQ25v0NkhM/748kpvubX63AKXm0eQ+CijUmeBmtRFHLamJNs6aIJ
         UkAyYaip/GmCNFPcAFldh4w1XoFzqPxqxin2tnuuyfQ8/pm4qDsH0tv17vSXzgRqyMci
         77qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJBrv0ujQZS8TWrEcYeb7tRSuR7bPBLt2Z61No74WBRYIgZzLJqbFe0ovS5HyqjgqP3WAbEka9dTGeEBSBAAKTbRgnjW5lAg==
X-Gm-Message-State: AOJu0YyjRIXNi03JpmrhjhYFgtSIifbHpqk4fBF7AbwCZ8K7RD/6vDi/
	HpvpGw9m640A1/jZEYfvW0SqJwhsUspGw3if7p6K0c6QESrfArMbz8cfHhi/HVmezqavsgOr/IC
	KV68dSUMH+Lj7UVrl8ZG7epjQrNvN7pGw54swovkj9tMNFATP5UBWqjs=
X-Received: by 2002:a17:90a:db98:b0:2b2:7c42:bcd7 with SMTP id 98e67ed59e1d1-2b6165bfff9mr4337860a91.21.1715221062668;
        Wed, 08 May 2024 19:17:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0fT89t7nzI1dwDnuIH7qeqmcgk2FBBWf2Te/fzPDCsRflXsrqNb4ecIXYjl5ib0qkUDeYLA==
X-Received: by 2002:a17:90a:db98:b0:2b2:7c42:bcd7 with SMTP id 98e67ed59e1d1-2b6165bfff9mr4337837a91.21.1715221062139;
        Wed, 08 May 2024 19:17:42 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf319e2sm2373525ad.174.2024.05.08.19.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 19:17:41 -0700 (PDT)
Date: Wed, 8 May 2024 19:17:40 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <smzgwi3nbkt5ws2psvh6hzygaelalfviv425q6igherxp52tga@6x5u45gvorrj>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2024 at 02:21:41PM GMT, Jason Gunthorpe wrote:
> Add tests for some of the more common STE update operations that we expect
> to see, as well as some artificial STE updates to test the edges of
> arm_smmu_write_entry. These also serve as a record of which common
> operation is expected to be hitless, and how many syncs they require.
> 
> arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> to any other abritrary STE/CD configuration. The update requires a
> sequence of write+sync operations with some invariants that must be held
> true after each sync. arm_smmu_write_entry lends itself well to
> unit-testing since the function's interaction with the STE/CD is already
> abstracted by input callbacks that we can hook to introspect into the
> sequence of operations. We can use these hooks to guarantee that
> invariants are held throughout the entire update operation.
> 
> Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/Kconfig                         |  13 +-
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   8 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 465 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  43 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
>  6 files changed, 533 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 0af39bbbe3a30e..f872aeccd82041 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -397,9 +397,9 @@ config ARM_SMMU_V3
>  	  Say Y here if your system includes an IOMMU device implementing
>  	  the ARM SMMUv3 architecture.
>  
> +if ARM_SMMU_V3
>  config ARM_SMMU_V3_SVA
>  	bool "Shared Virtual Addressing support for the ARM SMMUv3"
> -	depends on ARM_SMMU_V3
>  	select IOMMU_SVA
>  	select IOMMU_IOPF
>  	select MMU_NOTIFIER
> @@ -410,6 +410,17 @@ config ARM_SMMU_V3_SVA
>  	  Say Y here if your system supports SVA extensions such as PCIe PASID
>  	  and PRI.
>  
> +config ARM_SMMU_V3_KUNIT_TEST
> +	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> +	depends on KUNIT

Should this be 'depends on KUNIT=y'

Seeing ld complain when building it on top of the rhel kernel. I'm grabbing a system
to verify that it happens with joerg's next branch as well.

Regards,
Jerry

> +	depends on ARM_SMMU_V3_SVA
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable this option to unit-test arm-smmu-v3 driver functions.
> +
> +	  If unsure, say N.
> +endif
> +
>  config S390_IOMMU
>  	def_bool y if S390 && PCI
>  	depends on S390 && PCI
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> index 54feb1ecccad89..0b97054b3929b7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -2,4 +2,5 @@
>  obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
>  arm_smmu_v3-objs-y += arm-smmu-v3.o
>  arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
> +arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
>  arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 8730a7043909e3..34a977a0767d46 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -8,6 +8,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/sched/mm.h>
>  #include <linux/slab.h>
> +#include <kunit/visibility.h>
>  
>  #include "arm-smmu-v3.h"
>  #include "../../io-pgtable-arm.h"
> @@ -120,9 +121,10 @@ static u64 page_size_to_cd(void)
>  	return ARM_LPAE_TCR_TG0_4K;
>  }
>  
> -static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> -				 struct arm_smmu_master *master,
> -				 struct mm_struct *mm, u16 asid)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> +			  struct arm_smmu_master *master, struct mm_struct *mm,
> +			  u16 asid)
>  {
>  	u64 par;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> new file mode 100644
> index 00000000000000..417804392ff089
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> @@ -0,0 +1,465 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2024 Google LLC.
> + */
> +#include <kunit/test.h>
> +#include <linux/io-pgtable.h>
> +
> +#include "arm-smmu-v3.h"
> +
> +struct arm_smmu_test_writer {
> +	struct arm_smmu_entry_writer writer;
> +	struct kunit *test;
> +	const __le64 *init_entry;
> +	const __le64 *target_entry;
> +	__le64 *entry;
> +
> +	bool invalid_entry_written;
> +	unsigned int num_syncs;
> +};
> +
> +#define NUM_ENTRY_QWORDS 8
> +#define NUM_EXPECTED_SYNCS(x) x
> +
> +static struct arm_smmu_ste bypass_ste;
> +static struct arm_smmu_ste abort_ste;
> +static struct arm_smmu_device smmu = {
> +	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
> +};
> +static struct mm_struct sva_mm = {
> +	.pgd = (void *)0xdaedbeefdeadbeefULL,
> +};
> +
> +static bool arm_smmu_entry_differs_in_used_bits(const __le64 *entry,
> +						const __le64 *used_bits,
> +						const __le64 *target,
> +						unsigned int length)
> +{
> +	bool differs = false;
> +	unsigned int i;
> +
> +	for (i = 0; i < length; i++) {
> +		if ((entry[i] & used_bits[i]) != target[i])
> +			differs = true;
> +	}
> +	return differs;
> +}
> +
> +static void
> +arm_smmu_test_writer_record_syncs(struct arm_smmu_entry_writer *writer)
> +{
> +	struct arm_smmu_test_writer *test_writer =
> +		container_of(writer, struct arm_smmu_test_writer, writer);
> +	__le64 *entry_used_bits;
> +
> +	entry_used_bits = kunit_kzalloc(
> +		test_writer->test, sizeof(*entry_used_bits) * NUM_ENTRY_QWORDS,
> +		GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test_writer->test, entry_used_bits);
> +
> +	pr_debug("STE value is now set to: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8,
> +			     test_writer->entry,
> +			     NUM_ENTRY_QWORDS * sizeof(*test_writer->entry),
> +			     false);
> +
> +	test_writer->num_syncs += 1;
> +	if (!test_writer->entry[0]) {
> +		test_writer->invalid_entry_written = true;
> +	} else {
> +		/*
> +		 * At any stage in a hitless transition, the entry must be
> +		 * equivalent to either the initial entry or the target entry
> +		 * when only considering the bits used by the current
> +		 * configuration.
> +		 */
> +		writer->ops->get_used(test_writer->entry, entry_used_bits);
> +		KUNIT_EXPECT_FALSE(
> +			test_writer->test,
> +			arm_smmu_entry_differs_in_used_bits(
> +				test_writer->entry, entry_used_bits,
> +				test_writer->init_entry, NUM_ENTRY_QWORDS) &&
> +				arm_smmu_entry_differs_in_used_bits(
> +					test_writer->entry, entry_used_bits,
> +					test_writer->target_entry,
> +					NUM_ENTRY_QWORDS));
> +	}
> +}
> +
> +static void
> +arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
> +				       const __le64 *ste)
> +{
> +	__le64 used_bits[NUM_ENTRY_QWORDS] = {};
> +
> +	arm_smmu_get_ste_used(ste, used_bits);
> +	pr_debug("STE used bits: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, used_bits,
> +			     sizeof(used_bits), false);
> +}
> +
> +static const struct arm_smmu_entry_writer_ops test_ste_ops = {
> +	.sync = arm_smmu_test_writer_record_syncs,
> +	.get_used = arm_smmu_get_ste_used,
> +};
> +
> +static const struct arm_smmu_entry_writer_ops test_cd_ops = {
> +	.sync = arm_smmu_test_writer_record_syncs,
> +	.get_used = arm_smmu_get_cd_used,
> +};
> +
> +static void arm_smmu_v3_test_ste_expect_transition(
> +	struct kunit *test, const struct arm_smmu_ste *cur,
> +	const struct arm_smmu_ste *target, unsigned int num_syncs_expected,
> +	bool hitless)
> +{
> +	struct arm_smmu_ste cur_copy = *cur;
> +	struct arm_smmu_test_writer test_writer = {
> +		.writer = {
> +			.ops = &test_ste_ops,
> +		},
> +		.test = test,
> +		.init_entry = cur->data,
> +		.target_entry = target->data,
> +		.entry = cur_copy.data,
> +		.num_syncs = 0,
> +		.invalid_entry_written = false,
> +
> +	};
> +
> +	pr_debug("STE initial value: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, cur_copy.data,
> +			     sizeof(cur_copy), false);
> +	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer, cur->data);
> +	pr_debug("STE target value: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, target->data,
> +			     sizeof(cur_copy), false);
> +	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer,
> +					       target->data);
> +
> +	arm_smmu_write_entry(&test_writer.writer, cur_copy.data, target->data);
> +
> +	KUNIT_EXPECT_EQ(test, test_writer.invalid_entry_written, !hitless);
> +	KUNIT_EXPECT_EQ(test, test_writer.num_syncs, num_syncs_expected);
> +	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
> +}
> +
> +static void arm_smmu_v3_test_ste_expect_hitless_transition(
> +	struct kunit *test, const struct arm_smmu_ste *cur,
> +	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
> +{
> +	arm_smmu_v3_test_ste_expect_transition(test, cur, target,
> +					       num_syncs_expected, true);
> +}
> +
> +static const dma_addr_t fake_cdtab_dma_addr = 0xF0F0F0F0F0F0;
> +
> +static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
> +					   const dma_addr_t dma_addr)
> +{
> +	struct arm_smmu_master master = {
> +		.cd_table.cdtab_dma = dma_addr,
> +		.cd_table.s1cdmax = 0xFF,
> +		.cd_table.s1fmt = STRTAB_STE_0_S1FMT_64K_L2,
> +		.smmu = &smmu,
> +	};
> +
> +	arm_smmu_make_cdtable_ste(ste, &master);
> +}
> +
> +static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
> +{
> +	/*
> +	 * Bypass STEs has used bits in the first two Qwords, while abort STEs
> +	 * only have used bits in the first QWord. Transitioning from bypass to
> +	 * abort requires two syncs: the first to set the first qword and make
> +	 * the STE into an abort, the second to clean up the second qword.
> +	 */
> +	arm_smmu_v3_test_ste_expect_hitless_transition(
> +		test, &bypass_ste, &abort_ste, NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_abort_to_bypass(struct kunit *test)
> +{
> +	/*
> +	 * Transitioning from abort to bypass also requires two syncs: the first
> +	 * to set the second qword data required by the bypass STE, and the
> +	 * second to set the first qword and switch to bypass.
> +	 */
> +	arm_smmu_v3_test_ste_expect_hitless_transition(
> +		test, &abort_ste, &bypass_ste, NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_cdtable_to_abort(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_abort_to_cdtable(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_cdtable_to_bypass(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
> +						       NUM_EXPECTED_SYNCS(3));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_bypass_to_cdtable(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
> +						       NUM_EXPECTED_SYNCS(3));
> +}
> +
> +static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
> +				      bool ats_enabled)
> +{
> +	struct arm_smmu_master master = {
> +		.smmu = &smmu,
> +		.ats_enabled = ats_enabled,
> +	};
> +	struct io_pgtable io_pgtable = {};
> +	struct arm_smmu_domain smmu_domain = {
> +		.pgtbl_ops = &io_pgtable.ops,
> +	};
> +
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tg = 2;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sh = 3;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.orgn = 1;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.irgn = 2;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
> +	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
> +
> +	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
> +}
> +
> +static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_s2_ste(&ste, true);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_abort_to_s2(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_s2_ste(&ste, true);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_s2_to_bypass(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_s2_ste(&ste, true);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_ste_test_bypass_to_s2(struct kunit *test)
> +{
> +	struct arm_smmu_ste ste;
> +
> +	arm_smmu_test_make_s2_ste(&ste, true);
> +	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
> +						       NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_test_cd_expect_transition(
> +	struct kunit *test, const struct arm_smmu_cd *cur,
> +	const struct arm_smmu_cd *target, unsigned int num_syncs_expected,
> +	bool hitless)
> +{
> +	struct arm_smmu_cd cur_copy = *cur;
> +	struct arm_smmu_test_writer test_writer = {
> +		.writer = {
> +			.ops = &test_cd_ops,
> +		},
> +		.test = test,
> +		.init_entry = cur->data,
> +		.target_entry = target->data,
> +		.entry = cur_copy.data,
> +		.num_syncs = 0,
> +		.invalid_entry_written = false,
> +
> +	};
> +
> +	pr_debug("CD initial value: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, cur_copy.data,
> +			     sizeof(cur_copy), false);
> +	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer, cur->data);
> +	pr_debug("CD target value: ");
> +	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, target->data,
> +			     sizeof(cur_copy), false);
> +	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer,
> +					       target->data);
> +
> +	arm_smmu_write_entry(&test_writer.writer, cur_copy.data, target->data);
> +
> +	KUNIT_EXPECT_EQ(test, test_writer.invalid_entry_written, !hitless);
> +	KUNIT_EXPECT_EQ(test, test_writer.num_syncs, num_syncs_expected);
> +	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
> +}
> +
> +static void arm_smmu_v3_test_cd_expect_non_hitless_transition(
> +	struct kunit *test, const struct arm_smmu_cd *cur,
> +	const struct arm_smmu_cd *target, unsigned int num_syncs_expected)
> +{
> +	arm_smmu_v3_test_cd_expect_transition(test, cur, target,
> +					      num_syncs_expected, false);
> +}
> +
> +static void arm_smmu_v3_test_cd_expect_hitless_transition(
> +	struct kunit *test, const struct arm_smmu_cd *cur,
> +	const struct arm_smmu_cd *target, unsigned int num_syncs_expected)
> +{
> +	arm_smmu_v3_test_cd_expect_transition(test, cur, target,
> +					      num_syncs_expected, true);
> +}
> +
> +static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
> +{
> +	struct arm_smmu_master master = {
> +		.smmu = &smmu,
> +	};
> +	struct io_pgtable io_pgtable = {};
> +	struct arm_smmu_domain smmu_domain = {
> +		.pgtbl_ops = &io_pgtable.ops,
> +		.cd = {
> +			.asid = asid,
> +		},
> +	};
> +
> +	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tg = 2;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.sh = 3;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.orgn = 1;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.irgn = 2;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
> +	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
> +
> +	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
> +}
> +
> +static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
> +{
> +	struct arm_smmu_cd cd = {};
> +	struct arm_smmu_cd cd_2;
> +
> +	arm_smmu_test_make_s1_cd(&cd_2, 1997);
> +	arm_smmu_v3_test_cd_expect_non_hitless_transition(
> +		test, &cd, &cd_2, NUM_EXPECTED_SYNCS(2));
> +	arm_smmu_v3_test_cd_expect_non_hitless_transition(
> +		test, &cd_2, &cd, NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_cd_test_s1_change_asid(struct kunit *test)
> +{
> +	struct arm_smmu_cd cd = {};
> +	struct arm_smmu_cd cd_2;
> +
> +	arm_smmu_test_make_s1_cd(&cd, 778);
> +	arm_smmu_test_make_s1_cd(&cd_2, 1997);
> +	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd, &cd_2,
> +						      NUM_EXPECTED_SYNCS(1));
> +	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd_2, &cd,
> +						      NUM_EXPECTED_SYNCS(1));
> +}
> +
> +static void arm_smmu_test_make_sva_cd(struct arm_smmu_cd *cd, unsigned int asid)
> +{
> +	struct arm_smmu_master master = {
> +		.smmu = &smmu,
> +	};
> +
> +	arm_smmu_make_sva_cd(cd, &master, &sva_mm, asid);
> +}
> +
> +static void arm_smmu_test_make_sva_release_cd(struct arm_smmu_cd *cd,
> +					      unsigned int asid)
> +{
> +	struct arm_smmu_master master = {
> +		.smmu = &smmu,
> +	};
> +
> +	arm_smmu_make_sva_cd(cd, &master, NULL, asid);
> +}
> +
> +static void arm_smmu_v3_write_cd_test_sva_clear(struct kunit *test)
> +{
> +	struct arm_smmu_cd cd = {};
> +	struct arm_smmu_cd cd_2;
> +
> +	arm_smmu_test_make_sva_cd(&cd_2, 1997);
> +	arm_smmu_v3_test_cd_expect_non_hitless_transition(
> +		test, &cd, &cd_2, NUM_EXPECTED_SYNCS(2));
> +	arm_smmu_v3_test_cd_expect_non_hitless_transition(
> +		test, &cd_2, &cd, NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static void arm_smmu_v3_write_cd_test_sva_release(struct kunit *test)
> +{
> +	struct arm_smmu_cd cd;
> +	struct arm_smmu_cd cd_2;
> +
> +	arm_smmu_test_make_sva_cd(&cd, 1997);
> +	arm_smmu_test_make_sva_release_cd(&cd_2, 1997);
> +	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd, &cd_2,
> +						      NUM_EXPECTED_SYNCS(2));
> +	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd_2, &cd,
> +						      NUM_EXPECTED_SYNCS(2));
> +}
> +
> +static struct kunit_case arm_smmu_v3_test_cases[] = {
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_abort),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_bypass),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_abort),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_cdtable),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_bypass),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_cdtable),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_abort),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_s2),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_bypass),
> +	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_s2),
> +	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_clear),
> +	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_change_asid),
> +	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
> +	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_release),
> +	{},
> +};
> +
> +static int arm_smmu_v3_test_suite_init(struct kunit_suite *test)
> +{
> +	arm_smmu_make_bypass_ste(&smmu, &bypass_ste);
> +	arm_smmu_make_abort_ste(&abort_ste);
> +	return 0;
> +}
> +
> +static struct kunit_suite arm_smmu_v3_test_module = {
> +	.name = "arm-smmu-v3-kunit-test",
> +	.suite_init = arm_smmu_v3_test_suite_init,
> +	.test_cases = arm_smmu_v3_test_cases,
> +};
> +kunit_test_suites(&arm_smmu_v3_test_module);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 3817bc99d7e319..15bad76cf84a61 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -26,6 +26,7 @@
>  #include <linux/pci.h>
>  #include <linux/pci-ats.h>
>  #include <linux/platform_device.h>
> +#include <kunit/visibility.h>
>  
>  #include "arm-smmu-v3.h"
>  #include "../../dma-iommu.h"
> @@ -42,17 +43,6 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> -struct arm_smmu_entry_writer_ops;
> -struct arm_smmu_entry_writer {
> -	const struct arm_smmu_entry_writer_ops *ops;
> -	struct arm_smmu_master *master;
> -};
> -
> -struct arm_smmu_entry_writer_ops {
> -	void (*get_used)(const __le64 *entry, __le64 *used);
> -	void (*sync)(struct arm_smmu_entry_writer *writer);
> -};
> -
>  #define NUM_ENTRY_QWORDS 8
>  static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
>  static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
> @@ -979,7 +969,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>   * would be nice if this was complete according to the spec, but minimally it
>   * has to capture the bits this driver uses.
>   */
> -static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>  {
>  	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
>  
> @@ -1101,8 +1092,9 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
>   * V=0 process. This relies on the IGNORED behavior described in the
>   * specification.
>   */
> -static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> -				 __le64 *entry, const __le64 *target)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
> +			  const __le64 *target)
>  {
>  	__le64 unused_update[NUM_ENTRY_QWORDS];
>  	u8 used_qword_diff;
> @@ -1256,7 +1248,8 @@ struct arm_smmu_cd_writer {
>  	unsigned int ssid;
>  };
>  
> -static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
>  {
>  	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
>  	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> @@ -1514,7 +1507,8 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  	}
>  }
>  
> -static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
>  {
>  	memset(target, 0, sizeof(*target));
>  	target->data[0] = cpu_to_le64(
> @@ -1522,8 +1516,9 @@ static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
>  		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
>  }
>  
> -static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
> -				     struct arm_smmu_ste *target)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
> +			      struct arm_smmu_ste *target)
>  {
>  	memset(target, 0, sizeof(*target));
>  	target->data[0] = cpu_to_le64(
> @@ -1535,8 +1530,9 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
>  							 STRTAB_STE_1_SHCFG_INCOMING));
>  }
>  
> -static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -				      struct arm_smmu_master *master)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> +			       struct arm_smmu_master *master)
>  {
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  	struct arm_smmu_device *smmu = master->smmu;
> @@ -1585,9 +1581,10 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
>  	}
>  }
>  
> -static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> -					struct arm_smmu_master *master,
> -					struct arm_smmu_domain *smmu_domain)
> +VISIBLE_IF_KUNIT
> +void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> +				 struct arm_smmu_master *master,
> +				 struct arm_smmu_domain *smmu_domain)
>  {
>  	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
>  	const struct io_pgtable_cfg *pgtbl_cfg =
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 392130b840d55b..1242a086c9f948 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -736,6 +736,36 @@ struct arm_smmu_domain {
>  	struct list_head		mmu_notifiers;
>  };
>  
> +/* The following are exposed for testing purposes. */
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#if IS_ENABLED(CONFIG_KUNIT)
> +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
> +void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
> +			  const __le64 *target);
> +void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
> +void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
> +void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
> +			      struct arm_smmu_ste *target);
> +void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> +			       struct arm_smmu_master *master);
> +void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> +				 struct arm_smmu_master *master,
> +				 struct arm_smmu_domain *smmu_domain);
> +void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> +			  struct arm_smmu_master *master, struct mm_struct *mm,
> +			  u16 asid);
> +#endif
> +
>  static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
>  {
>  	return container_of(dom, struct arm_smmu_domain, domain);
> -- 
> 2.43.2
> 


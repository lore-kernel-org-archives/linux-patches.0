Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9918562E
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713561901; cv=none; b=KydHm6P11r2I53Lg+T/E/WmtDmtVa9FRrGXa8XL3P9eU4wqsGmlLAP30XYrinxxSTrxd9V6i5iaaF6EpbQ16dmXOfozAdUre5PEPw1EBbpzWe7jgRu7dAaDi274XgXCoAtRUU8PafTfXEOsb1GMkRzyu4tsL9ur3LAAAckO+Yiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713561901; c=relaxed/simple;
	bh=7IYo8Vy83kVd9RemZZwQvLRi3gboV5vb9NvRdXc1qIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqBvm9HudWrdX9p5vVlUkAO1mhlzvTRxv1dZym+qwTpO/Fklz4FZF5jdq8yrPaDPD3QsV122XnLdyoCRwmWIFDSeXf2W5DYiV3WrlMQ0xVAOQvUcG9OMQ43GQzlPI7bh6pkhuGfWE+EUP5BWU+tww4Uj2DMgky+MBhceEU/5bzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=px8JBXJI; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="px8JBXJI"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41699bbfb91so20295e9.0
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713561897; x=1714166697; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kD9QVKEHKnLLqhMtbvxHnwDGMrrKVKP9o/5ogUb3vjw=;
        b=px8JBXJIioz26tM6l8QsHf5tq0rYhSUxVXG4EDlNJ44huwOvPopTAhbn/XDW4ohWwK
         4HTDScIl+on5zgIm7cngIx9e/fdpvfKgP4Arm4W9ILqCkK1ik5tYIifCDsGd4Ffea0j+
         GHuJ+Zu9B16LQOhSoKT493fZQU4zTANyBPiARXMmis44PYsp8ZuAtfoSIsW6rJwZdyEK
         BDXftV2YeNEEuRXZmJU3XLchUFiKf6Xfx7Z4eU/IW/+xJKXvRaIV+9JP/lxmIMdrIzG7
         lRajSwK6uw+1yF5PzOL+n7tt6ManozrD8V0nh2AA0MJhaql0Y1IuM3wCc24Qr5GDZGNb
         wJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713561897; x=1714166697;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kD9QVKEHKnLLqhMtbvxHnwDGMrrKVKP9o/5ogUb3vjw=;
        b=Az49cO0pj0B8MKI8x/KNbkZUmF1QNMViEgy0CN0IKc658Q9ySHnOgTIJJmdmcL0ArB
         KNp5HJ9BM5b/ZMrUPFGyXxqVUYA3I5AP0OFdblq33LtHUmelSy+bXeFkM3c93hlQWejV
         XzPTFIZQpDNeYh7UC1YuO44A9nNPO0Y7jJJ6v0BKz7VcHGW0i3EulGGK+fgWC/fLtU12
         KczU6Y10V2pjVgle/DWth/N75ViudvdMtospAoUtFT7o4i+FkGG3k1RcVdfso7RiTFww
         3j6R2WGDZW6uWpO8FM1yikLOMeDquK20p39nHST3nvbcXXJpolMnoAhiFN75A+htvazg
         It1A==
X-Forwarded-Encrypted: i=1; AJvYcCUp9a7xWkmRRzBleDIhJHgxwGsZzxM33wQUovsMOwPEFCAO6R0pYlyz+EO2czQVGMnd7ZXlNBlIWAUB2X1OoRagWya5+bVwtg==
X-Gm-Message-State: AOJu0YwDIBJHZ5FB0zcvdWiS7VvkG0pfeyjbBSPrjuuSxNjQYKTcre8W
	fWg4hQwcOx5c8+vn/9eOLX3HMARZ3gX40mTPBk0CQ+vqGf6935jEwjtbOYzEuA==
X-Google-Smtp-Source: AGHT+IE/5kQ6TKtHDfSEvB+/QOnnvKJZiM6Cecb/gMSAqDGL3mW6t6GaY2jHKW+LGT52AD+0+q2Vrw==
X-Received: by 2002:a05:600c:3d0d:b0:419:c4f:cfc0 with SMTP id bh13-20020a05600c3d0d00b004190c4fcfc0mr49974wmb.6.1713561896666;
        Fri, 19 Apr 2024 14:24:56 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d4591000000b0034658db39d7sm5345040wrq.8.2024.04.19.14.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 14:24:56 -0700 (PDT)
Date: Fri, 19 Apr 2024 21:24:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <ZiLhJKBLdr_YqL_y@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

I am still reviewing the patch, however 2 quick notes.

On Tue, Apr 16, 2024 at 04:28:20PM -0300, Jason Gunthorpe wrote:
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
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/Kconfig                         |  12 +-
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
>  6 files changed, 525 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 0af39bbbe3a30e..2e597102baf6e5 100644
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
> @@ -410,6 +410,16 @@ config ARM_SMMU_V3_SVA
>  	  Say Y here if your system supports SVA extensions such as PCIe PASID
>  	  and PRI.
>  
> +config ARM_SMMU_V3_KUNIT_TEST
> +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> +	depends on KUNIT
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
> index 54feb1ecccad89..014a997753a8a2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -3,3 +3,5 @@ obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
>  arm_smmu_v3-objs-y += arm-smmu-v3.o
>  arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
>  arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
> +
> +obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 80a7d559ef2d3f..f56a2d38012b5c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -120,9 +120,9 @@ static u64 page_size_to_cd(void)
>  	return ARM_LPAE_TCR_TG0_4K;
>  }
>  
> -static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> -				 struct arm_smmu_master *master,
> -				 struct mm_struct *mm, u16 asid)
> +void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> +			  struct arm_smmu_master *master, struct mm_struct *mm,
> +			  u16 asid)
>  {
>  	u64 par;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> new file mode 100644
> index 00000000000000..14c8e40712a70e
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
> @@ -0,0 +1,467 @@
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
> +	if (!(test_writer->entry[0] & writer->ops->v_bit)) {
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
> +	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
> +	.sync = arm_smmu_test_writer_record_syncs,
> +	.get_used = arm_smmu_get_ste_used,
> +};
> +
> +static const struct arm_smmu_entry_writer_ops test_cd_ops = {
> +	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
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
> +	struct mm_struct mm = {
> +		.pgd = (void *)0xdaedbeefdeadbeefULL,
> +	};
> +
> +	arm_smmu_make_sva_cd(cd, &master, &mm, asid);
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

The test doesn’t build with SVA disabled, it fails with:
aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_release_cd':
.../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:409:(.text+0x17c): undefined reference to `arm_smmu_make_sva_cd'
aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_cd':
.../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:399:(.text+0x230): undefined reference to `arm_smmu_make_sva_cd'

I belive this check should be guarded under SVA.

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
> index 72402f6a7ed4e0..3ffaa3b34b44bf 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -42,18 +42,6 @@ enum arm_smmu_msi_index {
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
> -	__le64 v_bit;
> -	void (*get_used)(const __le64 *entry, __le64 *used);
> -	void (*sync)(struct arm_smmu_entry_writer *writer);
> -};
> -
>  #define NUM_ENTRY_QWORDS 8
>  static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
>  static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
> @@ -980,7 +968,7 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>   * would be nice if this was complete according to the spec, but minimally it
>   * has to capture the bits this driver uses.
>   */
> -static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)

IMO we should not export all these low level functions unconditionally.
KUNIT already defines “VISIBLE_IF_KUNIT” which sets symbols to be static
if CONFIG_KUNIT is not enabled. Or maybe even guard it for this test
like what btrfs does with “EXPORT_FOR_TESTS”

Thanks,
Mostafa

>  {
>  	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
>  
> @@ -1102,8 +1090,8 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
>   * V=0 process. This relies on the IGNORED behavior described in the
>   * specification.
>   */
> -static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> -				 __le64 *entry, const __le64 *target)
> +void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
> +			  const __le64 *target)
>  {
>  	__le64 unused_update[NUM_ENTRY_QWORDS];
>  	u8 used_qword_diff;
> @@ -1257,7 +1245,7 @@ struct arm_smmu_cd_writer {
>  	unsigned int ssid;
>  };
>  
> -static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> +void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
>  {
>  	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
>  	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> @@ -1514,7 +1502,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  	}
>  }
>  
> -static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> +void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
>  {
>  	memset(target, 0, sizeof(*target));
>  	target->data[0] = cpu_to_le64(
> @@ -1522,8 +1510,8 @@ static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
>  		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
>  }
>  
> -static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
> -				     struct arm_smmu_ste *target)
> +void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
> +			      struct arm_smmu_ste *target)
>  {
>  	memset(target, 0, sizeof(*target));
>  	target->data[0] = cpu_to_le64(
> @@ -1535,8 +1523,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
>  							 STRTAB_STE_1_SHCFG_INCOMING));
>  }
>  
> -static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -				      struct arm_smmu_master *master)
> +void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> +			       struct arm_smmu_master *master)
>  {
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  	struct arm_smmu_device *smmu = master->smmu;
> @@ -1585,9 +1573,9 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
>  	}
>  }
>  
> -static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> -					struct arm_smmu_master *master,
> -					struct arm_smmu_domain *smmu_domain)
> +void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> +				 struct arm_smmu_master *master,
> +				 struct arm_smmu_domain *smmu_domain)
>  {
>  	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
>  	const struct io_pgtable_cfg *pgtbl_cfg =
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 8f791f67f9f7f4..0455498d24c730 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -737,6 +737,36 @@ struct arm_smmu_domain {
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
> +	__le64 v_bit;
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
> +void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
> +void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
> +			  const __le64 *target);
> +
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
> +
>  static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
>  {
>  	return container_of(dom, struct arm_smmu_domain, domain);
> -- 
> 2.43.2
> 

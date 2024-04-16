Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91A2138482;
	Tue, 16 Apr 2024 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295731; cv=fail; b=YNz/n2gonQU5aipwBPaSsxZRFmpAiZ3ZX4Cr7FtTsDvXwyV+s8fa8zKChn28IbuxbaiF41pboWES4n14FwMdnXyZzeOvfnCcgnUAhzL2VtYYLgHWiGPP8berpQpFjjLwFUMdplz5QhMuUkK1IppZVGS4iYHZr/LcFPSPrxwhAX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295731; c=relaxed/simple;
	bh=nw9bCOcnwZ/aXynNNiGMxG1KFeAU20LbD2OslekYzJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YJUcK0djmAkUT/V9mc4r5KaAxwo924PWhRN5OoFSJXRL8Vbk1LlZabqYgjqWP1G6yOMvUBgqZx6Wuofclme/PZuAuRxpM17b1ffNX1m69+6ZhmCx4jT/g53V7wef769Oo5DcpvCt6DnU/AQ9hRgRETncIyHEnrrbJmcZKUyhG3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JMsoZC29; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JMsoZC29"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfridyLOXN2d8AlEwG2N9j9WLtcpyycTbT2Gter9ffKkfFFrQnvqXZyTMP9bbc5VHHqEpDR4YIkYq5gzN9+cdBih9eH38+mexxi8Kfd3LQLJTmjPa+iaTpHmCU4Ll3U6i1evlmcYLIlWDR0I3W5H6ZWyZf4D5iK/RYZpPmkU+dGWqD/ty+4NXPHg4QxqJw69Lx12Mj5u8snc38CbZ44UPkRmkLOaxE2fwU1t6EGmQD6D7IijgUtW6gt/KnDhnw8XWFhB2OfaZW3r4rczcwcdISgY/9jbxGbw7xSh4gcOV6M3gDLJib06HUP3EFWZ4P65TWyr3MHfHNVFn9hx2iGpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJhBU41MFBfeiV7YP8dD26LoLghPUbNU05Y8lRvP1U0=;
 b=Ev4znqPAk9RB+QrPIpFEjcRq5TbeNxP5X6EDsr3exL+XE1WgjSvp18iSpADuT+nYIMvtj0xkhInHTeffdKLoiVGCeDbQB83mwr9djLmfaYSQHn10DW1BttvGKD86pU8YMijWlKSYT9GnScRppPXPBHWuKGa2Cy2RH3XCwb3QZU6AR79jtNFnglvQ7/xqaAobOvt2qJhChkrc19Skrdv9V97AayMZdv9JDZB7SGu8dsKJtlm5LGOvKyMqc+zBOLm7KxvtMKuxiWqrs0PNmkPavm3Z8dKZO//UyIsLUlFc/NcT9AkvcZVHFOf1uOmUa74l6II9zuoXVOh8duWzrnsE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJhBU41MFBfeiV7YP8dD26LoLghPUbNU05Y8lRvP1U0=;
 b=JMsoZC29eewUMy98ry1DdzFxV+fKyCdy1pkeeZ82rvPWiU+EI2RHiSWWLnkqs1LY0LfsvzOXNUtCeiT5mfeh6B3IiIsJ0QEuBbmIWiIq3GKtMqO49CLk7+KgyRDpmkbkHbqtG9yw5TGEfnpsIFWAKaTnFjExVi7i0Iopg+NpEoAAixXsrXYkhAVxarL6Hs+ilhX3RuaSEAK6RmO0rzjlDjwca42UK5Q+TlfoS0Z3tnRYiP5sVdpI8QlARsPfuz5io9psAuP70wG5O0TJZo7iXP/yEG23arzRnnDdy+zGtvjE4vcfFchWla8MZ7GcmMTJBXibPs1Qqqfwj1jqvlA51A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry
Date: Tue, 16 Apr 2024 16:28:20 -0300
Message-ID: <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:806:120::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: cea689d0-2a52-4852-4481-08dc5e4b6174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r6hyznX0mSUyySp6aajtLNdtzVHHB+OFvA5chxtlvpG9fSIcWzn851E6hJG4XFIcNtkfK/qjq7RftNijxGSPAJtVHqX4ChAbQ097COUb+l1JmP+hLli+yPKx3kUjBRWtkXXxT5a6uaH4cUWNlIeCL684I4crzY61EhTPNEC0EBR7HMoqIXPjg1PWUZ4quHp3tCU8dljrRtS+EsxDWquBkclTZQsaNVYsvHx7R2QdfFUANDB/bURAn9N6ldMlmpbOmAzZ6MdHfnmI2IEBvrqpvXq67vg+4Cy3V8GvOOPb6hlMCOSRAan6HBwOhhuIhKadUw8oKd7sdLNhy65ngiDl5Nf9pRl9AhmykPSj8jNexXFP6E5c+czw7t9hQt9175Y/SPmn47fRePlvVJWpOq/UD1Tr6VKBigEQeR+ORRHURf51qAio9HzXqFb5WXwWjdBcCOazYFsHjQGrEzzpNjNUCK4aagStDDPE74TZew9D3WgnkKHyza7884GJBvuNWmxdYu1wTJxHf6RATZzwnj6o6lWX84YGP+43gwIBGnj8wrs7ljxBapKm7uoxyIVD60kgJUZstrZHpD1aZqMrpUMJvNSMG+a9Bz3/NKIQm4inHekLE4/cbL/dg1cMS0fNb1Q2z+BBkXNqBRrixPnJFKKIT1RnSYOGyk6IlHxHhBFNCJ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xDP+4e/tn8upXpDSLS3JlmN1VO98mdC3wYnh8DxUMTmgHSUz39bnWU+fsf5W?=
 =?us-ascii?Q?sqjVLIRJ/6L9q83T3oOpVuaZUkBZ64b8CvrVZA+IBjSLJGb0vwS46M08LMvb?=
 =?us-ascii?Q?Dzo31gSnLK1bULOdWm6Awz5PldLkUvEpBWwLTwHIlGtzb4/wyOnFqxU/S1ue?=
 =?us-ascii?Q?FUIrCAvD23VMo6i/lvwZUZq4WgvFV3i12egG4G5YHIDm9zs638MKN3khWlcw?=
 =?us-ascii?Q?N9pVO38vDw4JMQigL9sEWxws/I6DBPz+w5xiJtefhXPlkuoSFt9Q5y/8xE0M?=
 =?us-ascii?Q?P2fTHVnZJNWwt59whTsBdceluDquBN7yOD8bt3cgUd7IZiwJRDO6uW1CX1ul?=
 =?us-ascii?Q?ttVse59z/bbt/YeROa+YVZR6Tkg0CBcMHKDmgWoEjeA01YhMbtbvntw3LcZl?=
 =?us-ascii?Q?fu1+1pRML5Nw+2BqEEmb8R2vInQu/WC3IspZW40vVyqEVfi/Q3W7uXiJ2q7a?=
 =?us-ascii?Q?L0IhMB06m0Y5VVK9qJ+X9Xk/y2qDJH9zgK3SrWOVERwXa7zyYbTEDtlZgC8E?=
 =?us-ascii?Q?Irw8Zmvl0E0sfLTu2Uc4zVWHnCQeCkRXaJOLEGi6JzYl12igtQPUBJkKDsaG?=
 =?us-ascii?Q?1zDjz8gvYmI4do2PTq+kOapRo//IYGECZQ9QMYcZ8K47OEQpyuq88Wq1Ikgh?=
 =?us-ascii?Q?ogNmh9bGunFXUkGPEnpzHjNICUiGpmnV2yJvoUIU00zmAUMnucxmUK/4Hzz7?=
 =?us-ascii?Q?jWEBUcp7irA2ul5bkjQOIn2eGpzj2ZJGdd3cRrMExTUPeBqCBHTSBKs4oAcy?=
 =?us-ascii?Q?UxqREQTsdeRxk0PnFNV2uGgget/KQQJB6X4Sc4RHc3ZiWCfj5a1HWArzmodb?=
 =?us-ascii?Q?qIgARuWUTuWayQduHqBT8lbb7Lb6Jh2ozeoSbmiBpE0qPllpr5e0J7ufcqui?=
 =?us-ascii?Q?hSsvyTXab7aV3vNE350TWpThRD4RMnqaygbYToYZUSkowGu/fMUu6DrTZIZ6?=
 =?us-ascii?Q?D91xSqV6gk+QHxDoQS6mWKDNi6KQSL9EM5mNkOHZuKxAt9NxYcn4es3clGlM?=
 =?us-ascii?Q?Oums/jbzSbN3TByXVNCY9FCyULBD4P2NuxBrNxobFeeAC/W94wnz7YLwe0Kf?=
 =?us-ascii?Q?IbKthmBimI/QLBRtjSsVmmBIMQ4O1fZor5nkKKxWdMd6oZLcxVJ6ewO9noGN?=
 =?us-ascii?Q?TpfWxdJ/QCGAf+QTbc3s7LpJTI2WuR6IMZBnzewR973ong/VcRWYZzo4xDO6?=
 =?us-ascii?Q?4MHRFZHG/3hyYjxnnun1FT/pe/1HfB/XmwHFj96HFznazcWyybs7bcr0yU77?=
 =?us-ascii?Q?0VpXyaQUkeL7/tTdLuQVzXtwl9LvpG63txTM79Kr1YsTI5RxkJm9PREM8uBX?=
 =?us-ascii?Q?pJbPc9PZrOjH70Jy30XHMaivRaif85iknmZNWxtZ0XEIJLjI6fQzp+KisjzQ?=
 =?us-ascii?Q?SW+Sayd5hHi7ONGvUUdW6yqodacdknaNsA9/hhRioCBpMSqHtWmlDc0vKC2m?=
 =?us-ascii?Q?+TLL9i+ruGsAZ1IOFtHOFc/3UVhOSV3zU9V6gTg3e+izUjtQeJGZyYRaPC15?=
 =?us-ascii?Q?8fyYnW/PcIe2UnOawzd82hIXImu0FDrZ/WwS2AKd5KZ3Bdkj4qo7eQ1EnuBL?=
 =?us-ascii?Q?b/+7ENrwx0mYaFWM4LUQRvtkWAD5KWn0qFr9xY3O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea689d0-2a52-4852-4481-08dc5e4b6174
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ixglLCHvuMPGGPyRqWGVFR/AnfN0SFzvm5Zo1P5xTe7sj1ES1xL4pE0dQlx+URI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Add tests for some of the more common STE update operations that we expect
to see, as well as some artificial STE updates to test the edges of
arm_smmu_write_entry. These also serve as a record of which common
operation is expected to be hitless, and how many syncs they require.

arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
to any other abritrary STE/CD configuration. The update requires a
sequence of write+sync operations with some invariants that must be held
true after each sync. arm_smmu_write_entry lends itself well to
unit-testing since the function's interaction with the STE/CD is already
abstracted by input callbacks that we can hook to introspect into the
sequence of operations. We can use these hooks to guarantee that
invariants are held throughout the entire update operation.

Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Kconfig                         |  12 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
 6 files changed, 525 insertions(+), 28 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 0af39bbbe3a30e..2e597102baf6e5 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -397,9 +397,9 @@ config ARM_SMMU_V3
 	  Say Y here if your system includes an IOMMU device implementing
 	  the ARM SMMUv3 architecture.
 
+if ARM_SMMU_V3
 config ARM_SMMU_V3_SVA
 	bool "Shared Virtual Addressing support for the ARM SMMUv3"
-	depends on ARM_SMMU_V3
 	select IOMMU_SVA
 	select IOMMU_IOPF
 	select MMU_NOTIFIER
@@ -410,6 +410,16 @@ config ARM_SMMU_V3_SVA
 	  Say Y here if your system supports SVA extensions such as PCIe PASID
 	  and PRI.
 
+config ARM_SMMU_V3_KUNIT_TEST
+	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to unit-test arm-smmu-v3 driver functions.
+
+	  If unsure, say N.
+endif
+
 config S390_IOMMU
 	def_bool y if S390 && PCI
 	depends on S390 && PCI
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 54feb1ecccad89..014a997753a8a2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -3,3 +3,5 @@ obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
+
+obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 80a7d559ef2d3f..f56a2d38012b5c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -120,9 +120,9 @@ static u64 page_size_to_cd(void)
 	return ARM_LPAE_TCR_TG0_4K;
 }
 
-static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
-				 struct arm_smmu_master *master,
-				 struct mm_struct *mm, u16 asid)
+void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+			  struct arm_smmu_master *master, struct mm_struct *mm,
+			  u16 asid)
 {
 	u64 par;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
new file mode 100644
index 00000000000000..14c8e40712a70e
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -0,0 +1,467 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2024 Google LLC.
+ */
+#include <kunit/test.h>
+#include <linux/io-pgtable.h>
+
+#include "arm-smmu-v3.h"
+
+struct arm_smmu_test_writer {
+	struct arm_smmu_entry_writer writer;
+	struct kunit *test;
+	const __le64 *init_entry;
+	const __le64 *target_entry;
+	__le64 *entry;
+
+	bool invalid_entry_written;
+	unsigned int num_syncs;
+};
+
+#define NUM_ENTRY_QWORDS 8
+#define NUM_EXPECTED_SYNCS(x) x
+
+static struct arm_smmu_ste bypass_ste;
+static struct arm_smmu_ste abort_ste;
+static struct arm_smmu_device smmu = {
+	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
+};
+
+static bool arm_smmu_entry_differs_in_used_bits(const __le64 *entry,
+						const __le64 *used_bits,
+						const __le64 *target,
+						unsigned int length)
+{
+	bool differs = false;
+	unsigned int i;
+
+	for (i = 0; i < length; i++) {
+		if ((entry[i] & used_bits[i]) != target[i])
+			differs = true;
+	}
+	return differs;
+}
+
+static void
+arm_smmu_test_writer_record_syncs(struct arm_smmu_entry_writer *writer)
+{
+	struct arm_smmu_test_writer *test_writer =
+		container_of(writer, struct arm_smmu_test_writer, writer);
+	__le64 *entry_used_bits;
+
+	entry_used_bits = kunit_kzalloc(
+		test_writer->test, sizeof(*entry_used_bits) * NUM_ENTRY_QWORDS,
+		GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test_writer->test, entry_used_bits);
+
+	pr_debug("STE value is now set to: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8,
+			     test_writer->entry,
+			     NUM_ENTRY_QWORDS * sizeof(*test_writer->entry),
+			     false);
+
+	test_writer->num_syncs += 1;
+	if (!(test_writer->entry[0] & writer->ops->v_bit)) {
+		test_writer->invalid_entry_written = true;
+	} else {
+		/*
+		 * At any stage in a hitless transition, the entry must be
+		 * equivalent to either the initial entry or the target entry
+		 * when only considering the bits used by the current
+		 * configuration.
+		 */
+		writer->ops->get_used(test_writer->entry, entry_used_bits);
+		KUNIT_EXPECT_FALSE(
+			test_writer->test,
+			arm_smmu_entry_differs_in_used_bits(
+				test_writer->entry, entry_used_bits,
+				test_writer->init_entry, NUM_ENTRY_QWORDS) &&
+				arm_smmu_entry_differs_in_used_bits(
+					test_writer->entry, entry_used_bits,
+					test_writer->target_entry,
+					NUM_ENTRY_QWORDS));
+	}
+}
+
+static void
+arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
+				       const __le64 *ste)
+{
+	__le64 used_bits[NUM_ENTRY_QWORDS] = {};
+
+	arm_smmu_get_ste_used(ste, used_bits);
+	pr_debug("STE used bits: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, used_bits,
+			     sizeof(used_bits), false);
+}
+
+static const struct arm_smmu_entry_writer_ops test_ste_ops = {
+	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
+	.sync = arm_smmu_test_writer_record_syncs,
+	.get_used = arm_smmu_get_ste_used,
+};
+
+static const struct arm_smmu_entry_writer_ops test_cd_ops = {
+	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
+	.sync = arm_smmu_test_writer_record_syncs,
+	.get_used = arm_smmu_get_cd_used,
+};
+
+static void arm_smmu_v3_test_ste_expect_transition(
+	struct kunit *test, const struct arm_smmu_ste *cur,
+	const struct arm_smmu_ste *target, unsigned int num_syncs_expected,
+	bool hitless)
+{
+	struct arm_smmu_ste cur_copy = *cur;
+	struct arm_smmu_test_writer test_writer = {
+		.writer = {
+			.ops = &test_ste_ops,
+		},
+		.test = test,
+		.init_entry = cur->data,
+		.target_entry = target->data,
+		.entry = cur_copy.data,
+		.num_syncs = 0,
+		.invalid_entry_written = false,
+
+	};
+
+	pr_debug("STE initial value: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, cur_copy.data,
+			     sizeof(cur_copy), false);
+	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer, cur->data);
+	pr_debug("STE target value: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, target->data,
+			     sizeof(cur_copy), false);
+	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer,
+					       target->data);
+
+	arm_smmu_write_entry(&test_writer.writer, cur_copy.data, target->data);
+
+	KUNIT_EXPECT_EQ(test, test_writer.invalid_entry_written, !hitless);
+	KUNIT_EXPECT_EQ(test, test_writer.num_syncs, num_syncs_expected);
+	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
+}
+
+static void arm_smmu_v3_test_ste_expect_hitless_transition(
+	struct kunit *test, const struct arm_smmu_ste *cur,
+	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
+{
+	arm_smmu_v3_test_ste_expect_transition(test, cur, target,
+					       num_syncs_expected, true);
+}
+
+static const dma_addr_t fake_cdtab_dma_addr = 0xF0F0F0F0F0F0;
+
+static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
+					   const dma_addr_t dma_addr)
+{
+	struct arm_smmu_master master = {
+		.cd_table.cdtab_dma = dma_addr,
+		.cd_table.s1cdmax = 0xFF,
+		.cd_table.s1fmt = STRTAB_STE_0_S1FMT_64K_L2,
+		.smmu = &smmu,
+	};
+
+	arm_smmu_make_cdtable_ste(ste, &master);
+}
+
+static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
+{
+	/*
+	 * Bypass STEs has used bits in the first two Qwords, while abort STEs
+	 * only have used bits in the first QWord. Transitioning from bypass to
+	 * abort requires two syncs: the first to set the first qword and make
+	 * the STE into an abort, the second to clean up the second qword.
+	 */
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &bypass_ste, &abort_ste, NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_abort_to_bypass(struct kunit *test)
+{
+	/*
+	 * Transitioning from abort to bypass also requires two syncs: the first
+	 * to set the second qword data required by the bypass STE, and the
+	 * second to set the first qword and switch to bypass.
+	 */
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &abort_ste, &bypass_ste, NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_cdtable_to_abort(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_abort_to_cdtable(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_cdtable_to_bypass(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_v3_write_ste_test_bypass_to_cdtable(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
+				      bool ats_enabled)
+{
+	struct arm_smmu_master master = {
+		.smmu = &smmu,
+		.ats_enabled = ats_enabled,
+	};
+	struct io_pgtable io_pgtable = {};
+	struct arm_smmu_domain smmu_domain = {
+		.pgtbl_ops = &io_pgtable.ops,
+	};
+
+	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tg = 2;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sh = 3;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.orgn = 1;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.irgn = 2;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
+	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
+
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
+}
+
+static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_s2_ste(&ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_abort_to_s2(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_s2_ste(&ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_s2_to_bypass(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_s2_ste(&ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_ste_test_bypass_to_s2(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_test_make_s2_ste(&ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
+						       NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_test_cd_expect_transition(
+	struct kunit *test, const struct arm_smmu_cd *cur,
+	const struct arm_smmu_cd *target, unsigned int num_syncs_expected,
+	bool hitless)
+{
+	struct arm_smmu_cd cur_copy = *cur;
+	struct arm_smmu_test_writer test_writer = {
+		.writer = {
+			.ops = &test_cd_ops,
+		},
+		.test = test,
+		.init_entry = cur->data,
+		.target_entry = target->data,
+		.entry = cur_copy.data,
+		.num_syncs = 0,
+		.invalid_entry_written = false,
+
+	};
+
+	pr_debug("CD initial value: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, cur_copy.data,
+			     sizeof(cur_copy), false);
+	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer, cur->data);
+	pr_debug("CD target value: ");
+	print_hex_dump_debug("    ", DUMP_PREFIX_NONE, 16, 8, target->data,
+			     sizeof(cur_copy), false);
+	arm_smmu_v3_test_debug_print_used_bits(&test_writer.writer,
+					       target->data);
+
+	arm_smmu_write_entry(&test_writer.writer, cur_copy.data, target->data);
+
+	KUNIT_EXPECT_EQ(test, test_writer.invalid_entry_written, !hitless);
+	KUNIT_EXPECT_EQ(test, test_writer.num_syncs, num_syncs_expected);
+	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
+}
+
+static void arm_smmu_v3_test_cd_expect_non_hitless_transition(
+	struct kunit *test, const struct arm_smmu_cd *cur,
+	const struct arm_smmu_cd *target, unsigned int num_syncs_expected)
+{
+	arm_smmu_v3_test_cd_expect_transition(test, cur, target,
+					      num_syncs_expected, false);
+}
+
+static void arm_smmu_v3_test_cd_expect_hitless_transition(
+	struct kunit *test, const struct arm_smmu_cd *cur,
+	const struct arm_smmu_cd *target, unsigned int num_syncs_expected)
+{
+	arm_smmu_v3_test_cd_expect_transition(test, cur, target,
+					      num_syncs_expected, true);
+}
+
+static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
+{
+	struct arm_smmu_master master = {
+		.smmu = &smmu,
+	};
+	struct io_pgtable io_pgtable = {};
+	struct arm_smmu_domain smmu_domain = {
+		.pgtbl_ops = &io_pgtable.ops,
+		.cd = {
+			.asid = asid,
+		},
+	};
+
+	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tg = 2;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.sh = 3;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.orgn = 1;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.irgn = 2;
+	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
+	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
+
+	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+}
+
+static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
+{
+	struct arm_smmu_cd cd = {};
+	struct arm_smmu_cd cd_2;
+
+	arm_smmu_test_make_s1_cd(&cd_2, 1997);
+	arm_smmu_v3_test_cd_expect_non_hitless_transition(
+		test, &cd, &cd_2, NUM_EXPECTED_SYNCS(2));
+	arm_smmu_v3_test_cd_expect_non_hitless_transition(
+		test, &cd_2, &cd, NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_cd_test_s1_change_asid(struct kunit *test)
+{
+	struct arm_smmu_cd cd = {};
+	struct arm_smmu_cd cd_2;
+
+	arm_smmu_test_make_s1_cd(&cd, 778);
+	arm_smmu_test_make_s1_cd(&cd_2, 1997);
+	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd, &cd_2,
+						      NUM_EXPECTED_SYNCS(1));
+	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd_2, &cd,
+						      NUM_EXPECTED_SYNCS(1));
+}
+
+static void arm_smmu_test_make_sva_cd(struct arm_smmu_cd *cd, unsigned int asid)
+{
+	struct arm_smmu_master master = {
+		.smmu = &smmu,
+	};
+	struct mm_struct mm = {
+		.pgd = (void *)0xdaedbeefdeadbeefULL,
+	};
+
+	arm_smmu_make_sva_cd(cd, &master, &mm, asid);
+}
+
+static void arm_smmu_test_make_sva_release_cd(struct arm_smmu_cd *cd,
+					      unsigned int asid)
+{
+	struct arm_smmu_master master = {
+		.smmu = &smmu,
+	};
+
+	arm_smmu_make_sva_cd(cd, &master, NULL, asid);
+}
+
+static void arm_smmu_v3_write_cd_test_sva_clear(struct kunit *test)
+{
+	struct arm_smmu_cd cd = {};
+	struct arm_smmu_cd cd_2;
+
+	arm_smmu_test_make_sva_cd(&cd_2, 1997);
+	arm_smmu_v3_test_cd_expect_non_hitless_transition(
+		test, &cd, &cd_2, NUM_EXPECTED_SYNCS(2));
+	arm_smmu_v3_test_cd_expect_non_hitless_transition(
+		test, &cd_2, &cd, NUM_EXPECTED_SYNCS(2));
+}
+
+static void arm_smmu_v3_write_cd_test_sva_release(struct kunit *test)
+{
+	struct arm_smmu_cd cd;
+	struct arm_smmu_cd cd_2;
+
+	arm_smmu_test_make_sva_cd(&cd, 1997);
+	arm_smmu_test_make_sva_release_cd(&cd_2, 1997);
+	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd, &cd_2,
+						      NUM_EXPECTED_SYNCS(2));
+	arm_smmu_v3_test_cd_expect_hitless_transition(test, &cd_2, &cd,
+						      NUM_EXPECTED_SYNCS(2));
+}
+
+static struct kunit_case arm_smmu_v3_test_cases[] = {
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_abort),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_bypass),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_abort),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_cdtable),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_bypass),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_cdtable),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_abort),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_bypass),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_clear),
+	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_change_asid),
+	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
+	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_release),
+	{},
+};
+
+static int arm_smmu_v3_test_suite_init(struct kunit_suite *test)
+{
+	arm_smmu_make_bypass_ste(&smmu, &bypass_ste);
+	arm_smmu_make_abort_ste(&abort_ste);
+	return 0;
+}
+
+static struct kunit_suite arm_smmu_v3_test_module = {
+	.name = "arm-smmu-v3-kunit-test",
+	.suite_init = arm_smmu_v3_test_suite_init,
+	.test_cases = arm_smmu_v3_test_cases,
+};
+kunit_test_suites(&arm_smmu_v3_test_module);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 72402f6a7ed4e0..3ffaa3b34b44bf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -42,18 +42,6 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-struct arm_smmu_entry_writer_ops;
-struct arm_smmu_entry_writer {
-	const struct arm_smmu_entry_writer_ops *ops;
-	struct arm_smmu_master *master;
-};
-
-struct arm_smmu_entry_writer_ops {
-	__le64 v_bit;
-	void (*get_used)(const __le64 *entry, __le64 *used);
-	void (*sync)(struct arm_smmu_entry_writer *writer);
-};
-
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
@@ -980,7 +968,7 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
 	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
 
@@ -1102,8 +1090,8 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
  * V=0 process. This relies on the IGNORED behavior described in the
  * specification.
  */
-static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
-				 __le64 *entry, const __le64 *target)
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
+			  const __le64 *target)
 {
 	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
@@ -1257,7 +1245,7 @@ struct arm_smmu_cd_writer {
 	unsigned int ssid;
 };
 
-static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
+void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
 {
 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
@@ -1514,7 +1502,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
-static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1522,8 +1510,8 @@ static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
 }
 
-static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
-				     struct arm_smmu_ste *target)
+void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
+			      struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1535,8 +1523,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 							 STRTAB_STE_1_SHCFG_INCOMING));
 }
 
-static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-				      struct arm_smmu_master *master)
+void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+			       struct arm_smmu_master *master)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1585,9 +1573,9 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 	}
 }
 
-static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
-					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+				 struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8f791f67f9f7f4..0455498d24c730 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -737,6 +737,36 @@ struct arm_smmu_domain {
 	struct list_head		mmu_notifiers;
 };
 
+/* The following are exposed for testing purposes. */
+struct arm_smmu_entry_writer_ops;
+struct arm_smmu_entry_writer {
+	const struct arm_smmu_entry_writer_ops *ops;
+	struct arm_smmu_master *master;
+};
+
+struct arm_smmu_entry_writer_ops {
+	__le64 v_bit;
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
+void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
+			  const __le64 *target);
+
+void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
+void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
+			      struct arm_smmu_ste *target);
+void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+			       struct arm_smmu_master *master);
+void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+				 struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+			  struct arm_smmu_master *master, struct mm_struct *mm,
+			  u16 asid);
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.2


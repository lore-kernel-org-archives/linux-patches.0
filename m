Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43A134CF7;
	Tue, 23 Apr 2024 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878075; cv=fail; b=RoyUILGjwh/pS2hzwrI4n0n8ObUrukQdh2j758Z4VBlqaccz9gwajgSXICLpukFEIDnI+IrYbjIO/p6+1/daj7uEVQut69nTf68joUeqPGHnjwUmJln/L+uEnqnvz0hEW2Hxb5hsutB2jkNW/eNHffyhYgsZxCe8MxTD6dVar2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878075; c=relaxed/simple;
	bh=r7+RPp7TxtJ1f+U4RP/LCAB5e9TJW3YVcRm1MCNZg1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uy7EwO83CubdHe7/bxMlwlpZKqvcv6n0Dj0WB5feqEaDoYfbNmMJAwt1UP0B9cyaar1W0/h0rKzrWsOrfowBkAbk54A0eOn6sm1Pl51J8XFKDJM37AyF7XWWgLuR3mTjWrsUQWU39IbEj/XnWEoSk+zD+bZlke7nGdAqSnusT6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VmBSqJtp; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VmBSqJtp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0b1UEzZxGJqHPi6dg5rYKX0+d8YVwBqzw+QeUc5KGu9nBIgx/W7Bawk98dM2Ror7BD4fQZUNBHsNRuKphKXdDOQ0OhNrslrnZPUanAG529FsvSDssho7pJ4VvkGyyivGq1rEdaLUFlMUTnX6z0pRdS0Vas9+u5zhlqQU19OuGQsCrksi5U+9Vkv/Mnei3oNvBKF3sIvIDHFUSxr93rKqvOgDdm9DzOMqNU2Iwz7KoIGdJQaF3e9GWt8R1bTSipRos7x2I9cEQvsG+sR8BotHbiqyXO+aRlTiJ5C82Dml4OqcOUNmW558rese/R0RteHKTlYiKGw2Di/3mR2Dl2ifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pTKawxbgzlCZqkYCwcBYfS0qJC+JBhkt0ODlLyj3Ys=;
 b=iojKvc0ReYg3ACUTb//x0b1WqXwE3F+SuqTKU0vUTU6xpLQ8YsbfFZQzGneTTykv3gHGkdjCzWjCjTK08B/r+ue/XGsaWn7NdVTnpcRucYd/4P481VIYlG9Oa/Az1FPszNAmYPatKMbXsusFtPlQRMLh5CFhV1tdZm0icYdMj2cEcxj8SlsMSLqsNKqE/v6PJRHSDEMr6KgbDkBrDq4fi5TVb7JAvCYzzoVF31DNWHouN+U0Dvv2B77dPFpJR8LeqI6C5H5cvn5kWsxADTGmw5Sfu+epjO4bDnLuNqPrhPkAu470881uiV7qd2pzYWG49JbcTuf+srE+tcuQvyegBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pTKawxbgzlCZqkYCwcBYfS0qJC+JBhkt0ODlLyj3Ys=;
 b=VmBSqJtp1LFC5V4Km5wmoSU7HKzYuWTuLfejihLvPxxy/1OGIadwsf9W6f9wRLCtEEnAc0zarwrGS9os8+s2VwT9RfDl7lPBfvbmArlbL26qJwUcY3EzIJDvWhmYCVI1ce4i0kvHOWH3qq/D79lVj5CJO6KNo2Bxt8bKgKYy7mBszlIGgAvloAmZ/SqGjoQG/P7KPLuZHWdpzXFNnI4YzYVXzzmItTn7XCPELcBPzT+bpJMNzFRzB0fjsGGDDibro8BlV8DtxNTwHIX0XDuvaTqBrMBwNp7X69gIwmK8meP04wSCViGSl0VSMbfil6EgB13evJAZ1V7wktCSrYYbJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:23 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry
Date: Tue, 23 Apr 2024 10:14:14 -0300
Message-ID: <9-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0326.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: c31ff9b4-de78-4a67-ff81-08dc63974737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VybzB/57gS0cryKFuZ6ZIykL3oyGLP7Yvy88h3QD8nd3qAm2YIzxzZYsNqFr?=
 =?us-ascii?Q?+xjvxaSj8NG3WD/s2c6lC+F56zbv8nSSZRS8D93Y8xF1/bDDlFiawgNW8eR1?=
 =?us-ascii?Q?adBr2Rgu3d1GWuzkZuDHtjRcvp+lEzkmuB4qbpsAuFnmbTxigHbb9oMjs2M0?=
 =?us-ascii?Q?T0nrMcMc0fIsLeT850uxYHqFmpi0fCqNWFdyPuh8+7hauif6HjlnVfOQQrI3?=
 =?us-ascii?Q?OlhZli7qcohZ31H6jnzbo2Iag7BpQAS+lwn4LXHY/UEpGZNEHvHoE2fY1Gy9?=
 =?us-ascii?Q?V3sGwUlDPfn2WJU4bDbBiVf5g+S/cn0OR569cHmpFy7mPZ0ZL43ktH0k0FvS?=
 =?us-ascii?Q?h9FRB2en9zAT1h6MAGnLqX/zyvEjD3U5Rxr7yJ6wbuWmZqjavvJMmPq1DrCR?=
 =?us-ascii?Q?MQmmwnWaIRth/EMeVKHHeCSJ1ZSX0GNFuQrolig3fmcWlUOTtgg08nUcooTC?=
 =?us-ascii?Q?3n2d7BxBb48QeVs5h5HWjoPlL0KE6sK4zVOqslBCd2SwcT7QclMoJhL8YcJZ?=
 =?us-ascii?Q?sq5SKimgq1QVFv6rtqCwyThfW1m/ZVn4NYwJLkWD3J42xzYY1N1c0V1u3qdf?=
 =?us-ascii?Q?s+uFMjOagPLNNL/RQtg2UPAYR5QxOkZKxfFtUOIN86fbCNcH9OAOD0RFESIu?=
 =?us-ascii?Q?UsC5GPvf2k7tvdWKvRNO0bDvlt4m107FkfAmo8v+PBLxNvMHx2r5Pe9T45OG?=
 =?us-ascii?Q?FnbkcJOlrGkl3lNTOkDDxslwxmCdgKia9hWX9Ds7VGizU1DtLvkQIIGI8wmU?=
 =?us-ascii?Q?E5b2iHwB4UnjQiMqkgcGwTf21gqQRDZcvl+1uTaJ9zR9KIORhWAHlSUozpqz?=
 =?us-ascii?Q?IegM2sQUE2inUjxJf+jrnb7aNtYanmMkq61w1xzkH1XFm9w6DGPvQVdCM/6Z?=
 =?us-ascii?Q?AJNQgHrypFR+adAk5NES8eMJR1NduBJIExS5qdxt4r86Bgt928WL+YXisqlW?=
 =?us-ascii?Q?ugltRRp21M93cyNa29A1ho15m1OrWDt8MnZJL95JK0A5MLmGzHooX0U2ALcq?=
 =?us-ascii?Q?Xg04Md5XNn397yKbZjyKgD75f4YKC11+F54ky8cMm219RVjndOL6YYPtjSB5?=
 =?us-ascii?Q?USeSozWCPiydhdKk369onRvIiKG6WNMpMqGcs6o1zqpbrYcHDdQhgzmPmdRq?=
 =?us-ascii?Q?sfBssGRD/Ttf3j9d89FaxrvqitLI+c53XUTfQSBJvMxK5XKQ4ObMF5iapueT?=
 =?us-ascii?Q?h7lhrXufnlcJ+rWTVex2X+swrJ84ekIi7Ezh50UJ5ZW4nqLbWxQ4oEHP1yul?=
 =?us-ascii?Q?UkAPjTqWcsl3nKg+asW0NzZyk9g9/05uGPhm0Oj08A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u/tNvIuuSwYwUiHr/WMNHAB5WY2yCrr0cHuPaeh+rHdnbE3XA7Sev9RGq3MY?=
 =?us-ascii?Q?fVHY7QCfGSQsqXqlp5DROt7HQWw2H+IM/lr5iSlo6lLJqEFnGRoRkyd8gUdd?=
 =?us-ascii?Q?OyujI9n8hePTn7JqALMY2xvUElBQNmHNE/rtNgeZ8BqoWO6WGgg2SuO8TzUL?=
 =?us-ascii?Q?+gFo1YX3FTuTGc3xsQHRHsqwQEO2B5Bn6SVrU8fWwwVPDiKcb8jzAR1nBGNQ?=
 =?us-ascii?Q?ubNpQqtKOyX/mbgB5Iyz0Wi2D7RMrEogCyQvdUKombhWn541dTHSCDMPNRpa?=
 =?us-ascii?Q?PaZ78IGi4QEE8TuB6GijDUcgVeBGNrRoTNNGN5Oxf/ryejfFueSBsbjAxYuK?=
 =?us-ascii?Q?MonokyQ/XJZlUxx7u+aytdF8vYm46JGkeDZR2n4gTwXoK+bFwzAdhEE+Geht?=
 =?us-ascii?Q?1EkkZmCrCYS6yHukdZcBqKRg+MVRS5G5amqeeXQA4aOGuUbL8Mrv7j0glbPB?=
 =?us-ascii?Q?S0Oa0ETYelYt5Buil2lS3xqJ4ZT9cTzgzRw2nNZkOurbP1N5S2qsZbRokBwJ?=
 =?us-ascii?Q?WlRFS5fbXmn0YJG1vkiyM3A4yxcTfHgZTrWx/YD34fYHJh2yrDkSY7aV/p08?=
 =?us-ascii?Q?xycD7IGkG1sKpp8uNj6wBt4mMj4cSUJTXL8K3A9WGC91Rbsq77+eKBlly/pn?=
 =?us-ascii?Q?mssEfwm4QMAnX5pya032MB4GUiO0DrXA0UqczUUnnDenG3LXj9xWaLZ9depv?=
 =?us-ascii?Q?Hvg5f/ty84gBCG/pOJCS5YCkXx771FHTzMt4ZO1Jz1zuBy6dQsGzp28WPbiq?=
 =?us-ascii?Q?QRTtZSMRkx3tlfR4E2Ry7Eakiu2aZKwwG3+a008eEapJ53f3IPfIHXSf8JTr?=
 =?us-ascii?Q?cafacEN3IQIgDSNY1SLj3I27SM2aWj7Xdd/LnGdBtlmO05k7Ulr452HjOKRZ?=
 =?us-ascii?Q?el4htaW6Ps7p8RQva9wJmpchtw7MC2El06vKxztbvhc38qQhAIcseQu6fbyd?=
 =?us-ascii?Q?qI6lBIPgvUqqw3X0Jpy9/uiZNdp88bu8/zsvwOCeX/Pb1A57t3b87ALhue/5?=
 =?us-ascii?Q?budXwA8Ltbuy4/3i3++EmYpC3H0cSVIjvb5VpYulBv841r+esJ4jI3W75nDp?=
 =?us-ascii?Q?UG9ymG0jFvmo4R1dhG1ILmBrbSn5lR3WgMThN5xfbrbDRiU6mPEHRpJ3TJ86?=
 =?us-ascii?Q?I34R7pQPjroBbOYeYN243DPJfGI2CUtI61iJ4pLC4KVPl4jxaLMhxZL8OKah?=
 =?us-ascii?Q?lrS24KdKOvlYupmueXriW+WFuGe2XM4A0JMZoknGrerHLkg6C8JeJhIC7XUr?=
 =?us-ascii?Q?f4YhRfbG1H8vEiv4uZ6avguXlUtCcsi1KUiwMWNUEjCQ/bsA3BjMUUYlDQbV?=
 =?us-ascii?Q?/laZuXbUa5DooWYcYcSinkbJ03ffK5dU+ojM2W3fxvc1wK19sBOV3t/JDpJK?=
 =?us-ascii?Q?t+LvayRD5BGH8vXli05sbNWwdYiY9QIegZOrfBkx1hFxbvDgt7CyQfvbXKGG?=
 =?us-ascii?Q?lmZfPTE6/stP6Y0ScIPd1s+k48lxoR/9yQ0IDmPEQBY37u4K4afcWNkxjyml?=
 =?us-ascii?Q?pk89zIjwIBKISEdp5khtbDwiTY6HHjeCQqQ49OU0LB5HuG/xzdtOFX2uxlIV?=
 =?us-ascii?Q?FocG2a00G/r3j+93pHZJL5MPg2T1W97M+2bPsUoc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31ff9b4-de78-4a67-ff81-08dc63974737
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:16.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JrCCY6BIzZnshmG1CbN5cY9r0X7bwYoxOu7LM4Zyut2QCclNJbutd9bxs4r8Lv+S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

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
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Kconfig                         |  13 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   8 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 465 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  43 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
 6 files changed, 533 insertions(+), 27 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 0af39bbbe3a30e..f872aeccd82041 100644
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
@@ -410,6 +410,17 @@ config ARM_SMMU_V3_SVA
 	  Say Y here if your system supports SVA extensions such as PCIe PASID
 	  and PRI.
 
+config ARM_SMMU_V3_KUNIT_TEST
+	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on ARM_SMMU_V3_SVA
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
index 54feb1ecccad89..0b97054b3929b7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -2,4 +2,5 @@
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
+arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 8730a7043909e3..34a977a0767d46 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -8,6 +8,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
+#include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
 #include "../../io-pgtable-arm.h"
@@ -120,9 +121,10 @@ static u64 page_size_to_cd(void)
 	return ARM_LPAE_TCR_TG0_4K;
 }
 
-static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
-				 struct arm_smmu_master *master,
-				 struct mm_struct *mm, u16 asid)
+VISIBLE_IF_KUNIT
+void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+			  struct arm_smmu_master *master, struct mm_struct *mm,
+			  u16 asid)
 {
 	u64 par;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
new file mode 100644
index 00000000000000..417804392ff089
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -0,0 +1,465 @@
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
+static struct mm_struct sva_mm = {
+	.pgd = (void *)0xdaedbeefdeadbeefULL,
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
+	if (!test_writer->entry[0]) {
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
+	.sync = arm_smmu_test_writer_record_syncs,
+	.get_used = arm_smmu_get_ste_used,
+};
+
+static const struct arm_smmu_entry_writer_ops test_cd_ops = {
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
+
+	arm_smmu_make_sva_cd(cd, &master, &sva_mm, asid);
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
index 3817bc99d7e319..15bad76cf84a61 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
+#include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
@@ -42,17 +43,6 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-struct arm_smmu_entry_writer_ops;
-struct arm_smmu_entry_writer {
-	const struct arm_smmu_entry_writer_ops *ops;
-	struct arm_smmu_master *master;
-};
-
-struct arm_smmu_entry_writer_ops {
-	void (*get_used)(const __le64 *entry, __le64 *used);
-	void (*sync)(struct arm_smmu_entry_writer *writer);
-};
-
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
@@ -979,7 +969,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
+VISIBLE_IF_KUNIT
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
 	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
 
@@ -1101,8 +1092,9 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
  * V=0 process. This relies on the IGNORED behavior described in the
  * specification.
  */
-static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
-				 __le64 *entry, const __le64 *target)
+VISIBLE_IF_KUNIT
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
+			  const __le64 *target)
 {
 	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
@@ -1256,7 +1248,8 @@ struct arm_smmu_cd_writer {
 	unsigned int ssid;
 };
 
-static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
+VISIBLE_IF_KUNIT
+void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
 {
 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
@@ -1514,7 +1507,8 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
-static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+VISIBLE_IF_KUNIT
+void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1522,8 +1516,9 @@ static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
 }
 
-static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
-				     struct arm_smmu_ste *target)
+VISIBLE_IF_KUNIT
+void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
+			      struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1535,8 +1530,9 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 							 STRTAB_STE_1_SHCFG_INCOMING));
 }
 
-static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-				      struct arm_smmu_master *master)
+VISIBLE_IF_KUNIT
+void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+			       struct arm_smmu_master *master)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1585,9 +1581,10 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 	}
 }
 
-static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
-					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+VISIBLE_IF_KUNIT
+void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+				 struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 392130b840d55b..1242a086c9f948 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -736,6 +736,36 @@ struct arm_smmu_domain {
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
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#if IS_ENABLED(CONFIG_KUNIT)
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
+			  const __le64 *target);
+void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
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
+#endif
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.2


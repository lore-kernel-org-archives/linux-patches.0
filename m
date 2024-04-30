Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035F17F38C;
	Tue, 30 Apr 2024 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497718; cv=fail; b=deCDhz3h2gyJVSP+b1AwinHoOfO/G+b8YEdUERD8Rku0F5naOF5dhO5nKs0/Dheq/8rOs0ZTi2vTmPmjaY2AILOJIJzhtbAP0gZaKHsDRjLTKKcrmK2sRkdjPbZkKA2itgvJGPNY5BU4AkPVyD1W6HC3y0fduP8Q5Gs7+bfg1mA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497718; c=relaxed/simple;
	bh=r7+RPp7TxtJ1f+U4RP/LCAB5e9TJW3YVcRm1MCNZg1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e/25VyGo1TLy+hU/PLp6+F+3AszFUxSZsqsbl+9qGDjMmmDG3tQj8eTjabT5dd4oKm8RSSakY49exw/ZPUAyNmXuqI4yeOGPsj/BIlqcwKlbNlKpSHmae9RcUlneWRilJ44WzEuydp47vyU2cY3Xh73ML5n6D1VsyeNYtU7sSHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ah1F5Jxp; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ah1F5Jxp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcWL0LgvM89Esn++mS7e5oG3/1cyr0nk6o1bKKuHVjNiUaIP8nwgSN0F/zqcBL4xgkUUDRVwhdSh9RpCQaMcbPuQmjUlMqf6JqD5KHLar77WslqC+Qi1MdfKu1KiVIieNIzCqG/wRDq8QgtTSeZxhJDDy0h3ObDwuyEauyFaW+v3FzfqjCp6Bt9iDyLM1TSPCGGWJ/0yFJvQgv0Iaj05HL9QEhlFNNr0K7IzBsOf2eJeFjl6c91Fgji7Tmk7/aa6bp/oxD821oxSAOLNAVGQJ4R72J5E/FGKUD2c2O9y6LGHJIaMVbD9zHBlW3K+Irk4Pfckw8rg0GnoqErD14VV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pTKawxbgzlCZqkYCwcBYfS0qJC+JBhkt0ODlLyj3Ys=;
 b=BayGO0Gum5UGdt9aJO2XUaPUgOyee970UKj6Xhay45lZ0tC55QoDj2p2DjJwKk6uFh6JB3n3VC+TvG4Aq8isrkkmiS3BJgORVIOjjiBAjN4dbblIGm6Dn0oALcan9hwcRsao/Fj7sjVKYRmGmUkT/xjZKfsP5EZNRvImgmfHLQftaWD2U0JWsUUI5xtjyQzvsv3hdjXw+cq5dD1AXrh46hN8+k2bsWml4EBqKvtvH2rWn87orDxp968+w6X6GftpKGGpHHhS73iKLmmVhlwP+m0OdmAtzkiHecRhqjnZgSwD0Gs8OVx7g4asFTZA5dUNkZm0YdgvI12pTQwNlN/xMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pTKawxbgzlCZqkYCwcBYfS0qJC+JBhkt0ODlLyj3Ys=;
 b=Ah1F5JxpYuIUGxqqrTqVnNDOsXhe09467XkeqtxscX7mfUZNOcRcm6QXd+kqQ//9A9MU9sBB1VHrDicwNM1sS26UDkqBkEz+loKSfTQI3px0OtIVqukwMhvBBnBNOO9k2Pz1CcymrlDym++TtGvNV1ZYk8Ik1hAt7a6HZ1Rt5onczjzq8BUYgeUus6ODZBPU0b/5Fv3e/ccCbZr3wJAtafc39cP7A+B8xlBhwPPRUFKv5Ml+ggK7mzxU7ZDf7UbrJtKGfJs3VWkM2dkhVsGB07wN48S+967mv4fR754fXY/+/bkljlhqETApUK3fNekfMzJVJypn6HcZMRZU5pWTeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:46 +0000
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
Subject: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry
Date: Tue, 30 Apr 2024 14:21:41 -0300
Message-ID: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0417.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f870336-7de9-406c-7c70-08dc693a0163
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XGVdXwNUoPtVoHpZ9Wg2UsOVGgLtD+IfkaJ37f1cF/MBsOlq1GakHhNTTf8O?=
 =?us-ascii?Q?M2hIm7Yh7WKKCUaQADftka8iBUDzfkZSHPv8TzGXhKp0TJS/73d77O8rcPBP?=
 =?us-ascii?Q?silL8wuxnU7elQQvQq2hic0lq3D117i5Jqpo92MLDCr01P8Ym3Y2oV/dWBav?=
 =?us-ascii?Q?IOfoD+3OUekG2AOvNU/5T2h8jG63Pfwfo2QImna/amo57+32xVJqyzot1ESi?=
 =?us-ascii?Q?FU0s/0vV+z6GhC2gciFATf0jSEqU0VS4HhCGxJcqd0AnPmUOc4Y7bMW6huRQ?=
 =?us-ascii?Q?vQ61e+DxfJum/32e8+1OwaTWcIvgjhCMnc8LRGHintlOj1Hvzyzui8Lf9UF+?=
 =?us-ascii?Q?bhNXlcII2r7Ho0dRR3ptaiO4KAN66kVasrBtfPQ8CluwMAAJ9cbPHfV7pclx?=
 =?us-ascii?Q?/M43ehg3+DDRkvGuP3vxP5B1w5p+DqxlV3mO5CWGDzrJwxNYD549QrvFErvi?=
 =?us-ascii?Q?m3jNXLTmSKPeYNWCevF3DTLOSSGKo3SScOXYLmOYD0R2sd1hccLa82/bffN5?=
 =?us-ascii?Q?cOPmu37P4rwuvEN/KEloP8B3fzbmqXfvyiq0tKNam0UTelPYUvjYXjnm4Xpi?=
 =?us-ascii?Q?7iG5sfKxfnY8FNMWnMaXmub/n102ETAThMtQuQzOSgy61iLXWjqeWQIRGbMZ?=
 =?us-ascii?Q?A2DM2H+bkCkJZ6khHDoIaELnLXiXDSsvrqYA4OCNHeRFweSzbkKzLIigWw+d?=
 =?us-ascii?Q?OuqtHleQcWhdTHQn8ne0MEL7SyhQdIEYqXJPbE6kP8fpGTz4tIQ/SxbmHDHb?=
 =?us-ascii?Q?ar0HGDSfkAegvRGANjSwqidiEbLkZ72sABuBwev8vtFu3Gj6Cmbg8DguWLyy?=
 =?us-ascii?Q?A2K9JaNzckTP3M6XBLHDf/TWlXam6T0E3hLpTaIEzfapJ+YWpVwIbAruKO4o?=
 =?us-ascii?Q?tmWFviG8yaGEEQw9cvdwKkKGECQmtF8eB4O/hQeRPiy7jVkHGXTfts3jg7fw?=
 =?us-ascii?Q?AUbMSxFWVMKitiX1CpOXyQTQd8RrO9Ohoq2gzAHXELt6OmKzFBHXvgIXTcqm?=
 =?us-ascii?Q?OM3bANeWVJCqzCW2tx5BUqC07gyzjsWcrEJlCsX2IcDxyhl+Q8hAkp3HsUrk?=
 =?us-ascii?Q?KkP8jqd36N1ajzFlMjHlKnjiVmV8cI5JLwyFtDKJVy+hrMaS4PRz1Or9o9Ln?=
 =?us-ascii?Q?HO/GNEaDMyx3SrjGSl4hskcrwZFfU5e64zt34CvQtswJ45riIR/SYOXxL7X3?=
 =?us-ascii?Q?RgxFoNhX6KbyMNJtTRpikXcQqEIVTlg6ADXvEBfDCAv6RNG8BYHPN10k0O5f?=
 =?us-ascii?Q?0YlDEDfw43RvTuSfDjPEN8jpNoj/u2AjtewqAJVvDw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p8ymBiNdRczuqyRJCRbCfPyY/8am+yaCm5XUIoMdxHYmQUjP5MokPovFW/qO?=
 =?us-ascii?Q?XUauJjH/pv+L5+WNGhlwF6HKbTjiTy75MwX0OY9d6nVfNXjn3Ti7Q1oTqadA?=
 =?us-ascii?Q?tJBcryaHVPB9sqNU96GCYbv+wlgTYWGdodH1Hc2NQfpWKDE8/9wgcSyFJUU+?=
 =?us-ascii?Q?37RrYVIKQoC/JZzX5KxhA7d850tGjM4VIlVhDFai6AYnROABK4alYPCM39D7?=
 =?us-ascii?Q?iurCF3FKJE4XC3Bv6cl6CzS7IqjacFtZwLeNBNLVv/+W4RR8izRA9jLUXhC4?=
 =?us-ascii?Q?jtkYvee5FcyWpHwtt7029KtCR5P0okkAQP7w9iiwMvYn6MBUFE48zvwanMU0?=
 =?us-ascii?Q?HIEln/x/FYC/Y5FT2cuLjkuxTNONW/JcvzwM4dPVpzTXac9B8qelhm18mJ9s?=
 =?us-ascii?Q?XlHyyvqQjqJIAvxdqIR4B7PebTezggvgMfmH6E3R+FV5VhHtIZD4BkA+PPsX?=
 =?us-ascii?Q?yxF5FSFdVcaJgMg/EHulEOcU9GWyZx9zDqcGoQG682IbqZO8VqI4rpHIjTyn?=
 =?us-ascii?Q?Yf3YPIqrYKkP2cKLgt/+aMq8ZJ5PbIlFaGoxs+3bD4CJN8SuF07cSm91E9P0?=
 =?us-ascii?Q?XsTKDAqgc1hs0ZiAAhH3sJObuuD0jBuU77xj5h4CT6jFtJh9gL4O/+NLAx6p?=
 =?us-ascii?Q?9UwDX/kl+HOOfRisUwwcHdbV6PFk4L5SpUN6WrSEZzWX8OKBHQhJYp5CUhwa?=
 =?us-ascii?Q?lO1tXlI8SSNKugga/O6GRMHKjM73yc2KnvGuTQAt9NUk4rE12XPGF0GbOUG4?=
 =?us-ascii?Q?hSOE1OeUNtoLw8Z2nabcHp2Wb7VKL/O97K2PFna9KysxjKn1BbqTgCXiB9Pq?=
 =?us-ascii?Q?m6sdm/0feUc0lQ/vMwmVdvqWDA072WVa6Ug2EINB+dvt87YPKTK3z4XVwneP?=
 =?us-ascii?Q?67AXzxq2Y8AoJvSl84JAhHvVm9UNw4TTPUgcWWARS3ucpnfhKrD680gRCIEG?=
 =?us-ascii?Q?XCa+3gRRsd4qPwuJFB0jOWlm2zkRai1Bw0pSua9js1emtS7rAd6J9Q/jdeFC?=
 =?us-ascii?Q?rR5h4YL0iZsiA5+pzKog49O42NntTgkde7EabARQEPiB9o0tvF5CcdLPJv1C?=
 =?us-ascii?Q?8tdl6XbyP18Dnhlr0sJEJSLtUZfbcQaMNkPjHS0MthHQK/UB8uogXaLqCMpg?=
 =?us-ascii?Q?BgDqpFc8RZfzDRedDW2E0Inr/5Bk6vvmY6mlmdTlYPVDehejn2HYt+Tx4stK?=
 =?us-ascii?Q?eqva5AfNOUlUhSM8H8ki2q71MFn3B2HZed8sQvX0G/7ka7JAzJYsMPVX2GVv?=
 =?us-ascii?Q?DZ2zP4zajXVEB1TU9Xvm5sSRIs9+wVCuF5m8EJFoapK1BTUvAPT35ZW0mZ9g?=
 =?us-ascii?Q?6mWMeMFSb88Yij4H+/wKvCLPhYc/iWIRcxNtS8qJi2EXyEz3ppU7kYdVjFvj?=
 =?us-ascii?Q?H10Njd6Tx9MZ1BMDxlcsCidw5rGw2GLE6VmvKoiT980D4i/7Qjcd1Wg/pM7W?=
 =?us-ascii?Q?V0jCLSoKlTyyENtBn+lRzc8TNW9H632H3dicxZaEpgK1JqQgn5kXxTlEOMU3?=
 =?us-ascii?Q?GHanDhpGBdE01TEOB2Vx0wWhLo9cEs56mi0u3E5FeAMbCcTOVtYhKDhJhPD+?=
 =?us-ascii?Q?650OMDdJWrgL1k31eY0nBgZFMTjCbNs+LmaBJWoc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f870336-7de9-406c-7c70-08dc693a0163
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3xEYTf2dNIyZYT7jeXlwUV5JPmeU+UrVN6iZlMC4kDtZNfuaUGnJ+Q+SOouVzE7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

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


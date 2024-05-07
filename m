Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A415E7F3;
	Tue,  7 May 2024 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088081; cv=fail; b=j744nwSwDf36q5moELZmr9xbzh5+4C3sBdLe2IbU1YdWIvMVuF2dTEcdiOYG6J3kHHWBni2iH4/Usdt3lIXGVmJTBDfSzqTcZVSjE/NsbtgQ7BdkPOtz4ZFYx7ss5nESdtQ/QE2exHMNQr3ZbHe2liHihZZGGwIAYoRVaG0wVak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088081; c=relaxed/simple;
	bh=Ty8katO+KsnJwNRhEil8IHeS/Mfi4v4JzMZmeo4JNBU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hPreLQejDiouZBvu27qQ23ATnbR7nryXCLbZ5z2UBVaDIsxy7hmVXw4dl0rX+dALvCHFQIF4An4czdX+n+inl10wvY7zO3NBdjvEnaSBX9En3ZcRiVwKHOUzSbX8S7eRnAhFDClshfyeVY4+GvM9FNEzJV+R9TvqsbJXw+PY2+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WeWw1Zon; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WeWw1Zon"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDWp6QrH7dcnjHPQEgaBNpmBj+yIdWvI9+PdCgKyi1/6aIUvxhm4Ol06aS1ex7eB6Mp2Bg7XFSdNbDfHvU2uKxJtc4dfqeC1aQ5DtHr9t0h/K27o1nLX4v9LzgMyOhvQa6A3u5+r5WSXaumoH3Jdpop6BGPd8Qx5qJzYdzJN9neA4rwt0FZCjd0NXLjNI0dVXffbCUhT/6Jcwsk9yEcl1Ajyl/zB3KB09M8aJtrc8lbn49nwgBI4d8CQ8eBVlgySn9O5ogQbHMUBgxOCEqyYsFtVuTvXFExGHgVq/HAZcCbwT2YiIp9cplRHwCJwD4MMuSzCqGo9ykn5lfbmRj9msg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL76QyXnglH30HCjWVVYhpRpxxhXXj31vn2o2IjfpGM=;
 b=oDilzGAnex674UHU2kIZWY6ZWeA7nLVMq1jMqPDtQw53rU8t5WbJi9/IKiJ5tNVPVUZPELqxikZjU4SCFXwIpfJ6etT5iEmvv2lyLK4Iu6zd674YbkcxoeIMEOrfegmObEJGuJOjdCYKbw6kz0dxKci/FRmyPkneaQwEqHBvjbJPsqM+L/S1wplXmCRE+zHfO2PzdErVqn2fghtiNUndtQp26JOcmD/Adez+MhdUvwLRB0X/XWXAQPn0W7KZfXbNSzWvLXe0eHGfQqXN0RaIK5M28NbMxcKFnoVpovaPL8KKtdd7hFaI37zTb6mkmcEVaFurp6FSY8EIVX9OXY4FFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL76QyXnglH30HCjWVVYhpRpxxhXXj31vn2o2IjfpGM=;
 b=WeWw1ZonLgHUhjQ7bkYEYX9VC919GVO0X9ahMUeGEZloX0KX4B63JhLhxso0Uu935WKB787fB3nO9pObO0ahkgWfiFnwVfNq5ki6k6DfI7+7pBrUWMUDXP9xouvmtxj6KOjEnWDje9/oVPrci+KywpiC2QQC1eA9mdwirHbvqek8C921DwFxq/QZpB/1FWleqkQu2F7/scSgTyEPSXLqisLHaK4NvijoTK99sxojed3l3BJt74+8G9qv9VwuAQnBWNWC4l2pfLVhYm0JaHSWhZOz/rbq0ec9Edqo0i5QP8/R1J6AgwQr2L5av/cAElzSTeYdrTqvjGuwLaVac2OOoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB7118.namprd12.prod.outlook.com (2603:10b6:303:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 13:21:12 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 13:21:12 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Date: Tue,  7 May 2024 10:21:10 -0300
Message-ID: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:805:f2::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB7118:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ed1bbe-5f30-420b-d09f-08dc6e98909c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iQ0QFUuHs98t6py+iN73+v1ABw1vXkrI5xIP0H3tGM2uqFFj4twNQuLXwrvm?=
 =?us-ascii?Q?u2Cn5TV2gfsGFw9xdX5+XR6z5MfpAknJq+mdFntsd6ePKpmsuog6BWgXdjDt?=
 =?us-ascii?Q?+0WweiA4J/k9EuwkUIFcHzBzIyyflpitnfhF4ADPUqfoce9CuiTixtE+dY19?=
 =?us-ascii?Q?mSZCnLpQGxt8hYljr+MwgXh5UMQgG0ZUryoE8mOhL1CfAky8/324gVpFJBp8?=
 =?us-ascii?Q?xuvacZaC9xFFNcBOfss/S2LmXeZ8r4pGQjA8MKSN5eLqxBYsBNa0qEYxLa3v?=
 =?us-ascii?Q?bAoyrDUkkvhj8mkk16HBLblSb5apyUlBxpIFj7v/0TyFVL4pmpbopupFXR8K?=
 =?us-ascii?Q?R99SjtA4t4NVo1Vb1itiscN49h4uL2TZIZXaunLJZnWAkpiOhppJEPZNByPd?=
 =?us-ascii?Q?uPYmra4yhJiJinJ95w3xPjJbG00kgBjQuNVIgmBOY7135oh7dUSrILVkbN3Z?=
 =?us-ascii?Q?nCVifZjpySpRUS3oAZneCknN7lANQLpIxnQXr72lQ76oKIlvZCIKRS2s0mAR?=
 =?us-ascii?Q?D17Gy+OAN6R8fNPV4cyiQ+BaCxn8iEazyJ8dAywp8Lolyp7LxEjzSM49lORi?=
 =?us-ascii?Q?zM3oeZFzCwj+2anmbTuGD0wSPfwUcdDYKu4NoObaulsMiw90fqJq4wrsdfop?=
 =?us-ascii?Q?UcPeP/b8W4KQcSMGMSy5orrsDRjPmhXvqvEFCptP14StmTjRzNlXKaxWjwpP?=
 =?us-ascii?Q?EDGg9zkmd/mBQigd68kzyzEFgk2k2YMrrcKHdGPQEbj/bhmz6gOKRoj7VxDW?=
 =?us-ascii?Q?E98+CSLvOz9+A0SJkCyU2RCBUkZ/Hh83ZjrStPmiuSXijupZVfwZUli1OrJi?=
 =?us-ascii?Q?+anS1WAjFeKLmn1F0tFygKByh3ihBhx/u1/NtTqZrXbrB3oIjV/gUTxSZX2y?=
 =?us-ascii?Q?mI7hn8laUpAuaonWmeP5ersnpU8VIMq/TC+zqiF33PwSLIJNrgIEve+S0Ag2?=
 =?us-ascii?Q?7HHZKad0jG/S8B9YxOW0Yp9F9DTvid/ORLqlGuN1zoUU3dIkh3aQ11ByzuVv?=
 =?us-ascii?Q?z4zZmBPSGlsX1Uj5L6j72BvaOQ+sntc7N1L9kd1fffxnQHP5nDwXuI74+n6K?=
 =?us-ascii?Q?Jmj8KAVxEjSI+itO0deESbzcboM9S1fCa5HY8wjbEa6jDpCsw4ciJOpYjB29?=
 =?us-ascii?Q?+uqTgJ/jtgUTUN2XsCJgb8zgMNsSgJvTOC6L1UootIri76IM9KLbb3qu9xBN?=
 =?us-ascii?Q?KiZn3tv8IBnV0zcER5ruD+XVINW+kVES64obMOF+nAoBU5dU3SaHL003RCxY?=
 =?us-ascii?Q?H0LclmFKvbq4TH565lhu8kb0+8dpI7AKprkSdvPd0Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zgd7lVE/jkjwv2JiPYtbM3bp5uXVCSkvu67RNKkKw/Ed3XirG21DaN5w8R8T?=
 =?us-ascii?Q?8kjvaPMjmWQc6VqvdwQF5Zn3G6rn2fLOmq+5EBPxiEEBdRIh2nAyE5Ac1UsM?=
 =?us-ascii?Q?qqFVzkJKwdPpaGxB2w2n/EFfSoOD9onJsZX4vL3WvynvFYA2AUrJgrl+yY6R?=
 =?us-ascii?Q?luUVzaY3rNefhjeqbn5pBKFFSYZxiSwkjlg7zgr90GZ5rCsU5IMMDxXDuRED?=
 =?us-ascii?Q?wC64RjuSoldwHTVpaYVkC+srGTYHyWLWBYocFfRBb2lpN43t1/0vNDpW8avL?=
 =?us-ascii?Q?gLnE5BQ8uH87vUvWEUx3xDa68DURvNV0po3q3z8SHW4p5hTfzwYZ3Jbk6e4t?=
 =?us-ascii?Q?qK0Zq7gAEOBFG4Pg/rp4wnjiwvhMq01L7bJ79GPjjdTZWSme3DZDS86KXDoc?=
 =?us-ascii?Q?Dq/LDFqmflCKBkTeW8b5DvQXVSu2RrtXr+7FHyMHl1R5+83ULLam2fg9Fc52?=
 =?us-ascii?Q?UwBKaJ4rhTMBS/wlDa+DJcNX5K+r2D1G1PK8bi0KyrTLm1m6VAEVk2zv5O1a?=
 =?us-ascii?Q?5XODcbhOAPP2t+mCWqtnJoVqgk5yoTuqrSUtkIXiql4ssGPi91UZvZg5LfD0?=
 =?us-ascii?Q?83Rg63DMrnMfMKoo/68iOZIS7I/d8MdLVofsTFheInAvvLOEtVXsS7U4aTBT?=
 =?us-ascii?Q?mSc/tVSsEiQsadDIxUpA5kli6dhVesMDYQhNNKExvhV3CZ5QMaSn5xAiYMNE?=
 =?us-ascii?Q?1UROtpq14XUV1OdMyAcqBRz5gRj7ar+9lJYJwxauFVe3NlgM4h5Vkwa+8Dbz?=
 =?us-ascii?Q?9ukoD8g1I16ZmjpCYPCpqAE80Az35gNEK2K5zZ+Nb+kII/aRXTJEyYPOVYGg?=
 =?us-ascii?Q?r0Ebu6DTk5nkvBa2L++cdMOhHGntuBmjNJKF3OgleiM+ASkJGw86dosHEa7C?=
 =?us-ascii?Q?KvcWkJGeU9UCkVSseqUhmlkcti/J14ufBhdKlrhMOr2oIVu7Upkpf9DJ2diJ?=
 =?us-ascii?Q?2GgLF2ssWB8YKrLo6ECK8MnoMgYwb0cf5MPPJRYx6jRE+yq8y/CODfej8WJA?=
 =?us-ascii?Q?tsDqoXFRsXJyxGvRwqIxNw7zhjUPZltJw6uaDYzaMdAWlImRqR1psGUieSnj?=
 =?us-ascii?Q?zD9jRTRjrl1DXltMRxdastTOtv1GLVQ3HwyGteY2CJaAqjXdAznHkrO+J84e?=
 =?us-ascii?Q?CCJ0sIv5VloJEwxGwKRvoSqy7c7xikluV9yDX9FzQKkAwAGvoaume+qh+7hi?=
 =?us-ascii?Q?qwDERjeakUPmH1Csr6+tqLn0OtshymTt/ouAgban9Va0XXMTnNgENDgIdksS?=
 =?us-ascii?Q?LyAsoID0IrVdpXUH3yKKugh6Egj1cjAUghP/zGZi7gnTjkpJsb4hvRUYbm7e?=
 =?us-ascii?Q?Wpc2fzJFAkee9XQvDCInNbOJXlOhKGhfIJKhU4Ta3ZnEpbWa1Yg9hRrmyg2c?=
 =?us-ascii?Q?1SwlsHnLDZwiY3pz8kuYoK4yvgM3BNlZ4FuXmKgU8K0CmZXLfO08F6jxwL8E?=
 =?us-ascii?Q?FyFTay67mTLHmZLJmi2cZwwZvy2OMYawTBPWVvpoqaBbQhlJ8eh+ReIJDUEk?=
 =?us-ascii?Q?VYZQOCZ0so0g8LK4AR3zJqjnX4BsFyhCOU4tOcH9rAQQ5HhuI43Woz7o7FZw?=
 =?us-ascii?Q?QH6mfG/H1vuXM9yq7NyddcICOj5ok0G9xK/ZJ5Hi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ed1bbe-5f30-420b-d09f-08dc6e98909c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 13:21:12.1174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fjaj+mLm0LSAOwc1ewHC10W2FafFow23JuelUN/6KNnr+8nlGhTM7pBtKMsAdFXS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7118

It turns out kconfig has problems ensuring the SMMU module and the KUNIT
module are consistently y/m to allow linking. It will permit KUNIT to be a
module while SMMU is built in.

Also, Fedora apparently enables kunit on production kernels.

So, put the entire kunit in its own module using the
VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
vmlinus on Fedora and makes the kconfig work in the normal way. There is
no cost if kunit is disabled.

Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Kconfig                            | 2 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
 5 files changed, 15 insertions(+), 2 deletions(-)

Joerg, can you pick this to solve the linux-next issue for Thorsten?

Thanks,
Jason

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 66325210c8c986..c04584be30893f 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
 	  and PRI.
 
 config ARM_SMMU_V3_KUNIT_TEST
-	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
+	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on ARM_SMMU_V3_SVA
 	default KUNIT_ALL_TESTS
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 0b97054b3929b7..014a997753a8a2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -2,5 +2,6 @@
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
-arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
+
+obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 34a977a0767d46..e490ffb3801545 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -185,6 +185,7 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 	 */
 	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_sva_cd);
 
 static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 417804392ff089..315e487fd990eb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -463,3 +463,6 @@ static struct kunit_suite arm_smmu_v3_test_module = {
 	.test_cases = arm_smmu_v3_test_cases,
 };
 kunit_test_suites(&arm_smmu_v3_test_module);
+
+MODULE_IMPORT_NS(EXPORTED_FOR_KUNIT_TESTING);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4820b8b5dd81b3..ab415e107054c1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1007,6 +1007,7 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 	if (cfg == STRTAB_STE_0_CFG_BYPASS)
 		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_ste_used);
 
 /*
  * Figure out if we can do a hitless update of entry to become target. Returns a
@@ -1141,6 +1142,7 @@ void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 			entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS));
 	}
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_write_entry);
 
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
@@ -1268,6 +1270,7 @@ void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
 		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
 	}
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_cd_used);
 
 static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
@@ -1332,6 +1335,7 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 				      CTXDESC_CD_1_TTB0_MASK);
 	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s1_cd);
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 {
@@ -1515,6 +1519,7 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 		STRTAB_STE_0_V |
 		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_abort_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
@@ -1529,6 +1534,7 @@ void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 		target->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							 STRTAB_STE_1_SHCFG_INCOMING));
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
@@ -1580,6 +1586,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			cpu_to_le64(FIELD_PREP(STRTAB_STE_2_S2VMID, 0));
 	}
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
@@ -1627,6 +1634,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
 				      STRTAB_STE_3_S2TTB_MASK);
 }
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
 /*
  * This can safely directly manipulate the STE memory without a sync sequence

base-commit: 36bb003ed6860aa478c0503a6c44725064679085
-- 
2.43.2


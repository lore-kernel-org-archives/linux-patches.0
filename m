Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140E48C8D2;
	Mon, 21 Sep 2026 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034948; cv=fail; b=bhM+njw7EeQ3dUc59k3jjXi6AUwXCkPr2Hd56tzHiRcqHio72ztL6RQSYS7727MQE+uIx1rNX/MrquW57hj05rphvuVR2WOdmru6A5ofHdFUhNHKSmmIsQv/dPTITm4XnpfGep5P8DwO9z/DY47Yg0SK+DFz8KYwdrZn01aBVS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034948; c=relaxed/simple;
	bh=PxqRQugsTtPOHfETb+sWmRBduVuWp7kLd9F7uewpDPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y3K/M/l9k/rAFm/NXlOjdbAQn149CNkRpEUnpLCn/zG28UBi+vt9Z/rm/EURZM6ChtG0svpnP9a/e8b2Lv7jzG5XSJnW8VvStXaoYhTcXQ1ZkZL4l5d5P9c4LOAM/LGIlT++ANZDiQPIV73/8NztkXUjlA+3/D0jajEd42ISepU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NDWbu1wj; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NDWbu1wj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLEqXnerWK7ioC47G+mOWJNErPajgNYJZ75NWLcJxSERy2KymKXbcvB6YbKUQ5YP3HjbjbJXRq5i3QuLeh8Q0pwmu8BIXvPxVVt1UvfNewcqkq2qaWebll/CQnSpVXaigVED/O+zRHDHyzsboMdA7W6vqDXn3yrkHDj0rwsP2UcGf4OU3VafKbhvQlBrCRdGSW3piMaoRDmAExIgciSOTgYI7mJBhWYpQ56AjZESoXQIk8bQnB58dytY9nPM+LbEyZOA689fltpshpTIDe4DYS92GweRbYFK+boXKUnCFQAQTbkf+QLOy4Xs+RW5LM8nUuyTP0G1umyzOq+gheLamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51UbhnTNQu4G+blw30KVXkWOBU3OphiMRdQFjecSFpw=;
 b=dAPj4iFQ4dMQad/czrdL7VqMVNz+Ft54sm3iTa+OzSYJ0rzDXocJkB1QC/EgOXULCAd0IlBUnau0BCaECzHjrq/RzJLdvSdsqTrArfXuUF21RYpPvHy46zvkg1f50lv4+PoygJD2QzBnawI7Vpjt6jnWotMfzy2h231dhg5no0DttxMX6bur/YlOANYOV6QlWCUr6Eta6XDnZTIy8F1C/0gUHuAmL1UNbdeXDOIGX2UrpPEmpvtu403gvxYEyEIyY7atOxODWnDuakklqg07RtT7ovmGsFTqURpFn6d38p5S9c7QGEpcjkaDbHfch4h3hJ514B3H8DWxgcTaGMQCzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51UbhnTNQu4G+blw30KVXkWOBU3OphiMRdQFjecSFpw=;
 b=NDWbu1wjef8neQLfA0pvCrpPxIDP4KywTdHwwFW6q96y/31z3ZAN6Mgq2rFxDl5tjLLetkrKZyk2sL21SvaGVyD/ha33Oopw7bPh3HuR5YZXN6R9NACueDey+k0cp3hj0bygqqwuvwZEiGM8Y6lj/gMR4PVziTbudJlM9ozSOJ/vWdR7bCZYqFaRX2HwOkREqE7/s95kit3XK86ANMUe2x2ZnLsClSq/4+QwSj27wvXmDoQ/Cb//8W7myY2otHeurgikaiTqUHfhb8JVVxXJXCQqjt+lkrhW9eGY+ymq+vWqrpVjWOpiPmPJ8kyRBJcBzka1R7kn+Q/RYQXC5dbeGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:23 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v7 8/9] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Mon, 21 Sep 2026 20:55:16 -0300
Message-ID: <8-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::20) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b996ef5-0494-4b6e-743a-08df183bca9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	os7ISolIEBxuU+KQ2U6HuuEwJOQDx6dxUVVyOwtFc5bjVyU993onOja0iEZX/UPqSFrH7Ns4/WWcL4RunFPuqoeulZnHMECwvQjSEiT97qJ6j7HaU73Lj+/K0kxHaZ8XMQMyJ2mjlR/CEA5Ae4C3xOblwor04pMMsmWvgmrRtPl75haWJOSPAOv1kwR6Axu/9NjU/xryxOeN61p39+4u+aAQo7p8HQ/lJ3mUQzgFT6scuQ5zeoqpkYwp8MeEepwz4OKhSw/9KH5jY2qAv1Sz/I/sryIBtyh0Ww6Tn1uxHiRAiu8+cshvCta5nisI0g/nFOcbT2yPjvq0Pnc5siCVdpYjIuSpIFUyTj0AP57NvMOL/vSOkvJtYGJwHoULGu0BYwvKOLZW9xiWTxuSA/vLCIdlPW36S703UlUnfJQE/Bub3WPj/dL0XyVGE0Gohso0agPjSmM88QBVRgtqTIPalDjt5SOpWL7Z4yucrpogPBIwMoWWlbrol2Fuk9ePn7/GvMooMDv5RIGbo7/Fg6FMlAIWEZyoLq5YHPCJm6YCDle3mH8BLBO6eSkqq0sg1pnKgRU/ZEG44da6+27uU7TXnou3S0vWEYINPeY0xWnmNor4fA3pLaXEprydTqkSGQEFRQy7up9CN9P/0KMYuxshWUrcxf4fxeWGEanNctZ7y5ehiHk0DQqSqKxUk3ySnsjQ1oemMVxWRL8A+fQEmrLbdg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eJXUxcBZMi8Vp5BhyiM4/qT7d3lMP2zOlwCtjhcRzT0+v12FB+lVBeTYNlnh?=
 =?us-ascii?Q?/tEGvSqqE6bIzlvYfBTTPBVENJ+7D2aHmEINYYSFZ56jDQIOUr78jJi7jtz/?=
 =?us-ascii?Q?CnVcCD8J6WR6j/GcJ9Dw4ATulEuPWJ6+rXVB4fPvueW9EHhhCnOVzF2yWvTP?=
 =?us-ascii?Q?FHsCbKaX73GSF0UbLWj2UNedK8xP7+fbn1yZIxsvXWWlgrFQWOI6RxjqVB1g?=
 =?us-ascii?Q?VIuv6zZB6BTIHH43PmsB9012jPswkSCqkqRm1BFHgyX+4MzgBdMTgP4AgQBD?=
 =?us-ascii?Q?d4QAbObH5PTIqzdi8wVkqLGOTb3Qgu9LjQd0K7dzzu+V4qGAmbh+dZplfbiN?=
 =?us-ascii?Q?CZm6JGRfIh/8CcZe65PMm3ZmhECALekOXk3a+DOD+wM/RoUS79wTrMvdXCVf?=
 =?us-ascii?Q?b2NhjEIvmCgOMBcejKNUHzepN3Oa0spr8IqBNKemr4/c2uE7iECdMCfVxs/v?=
 =?us-ascii?Q?WvdaSADQQX8m2iINlg8WYJRU8O59mnE/Jb5OWREk/HR9aV96zq/2fAlr9W/I?=
 =?us-ascii?Q?nTyPIYGUVOKeHyGuCqzK9qIaP2L2eR+FazXEKkX+NTHc3EF7O78jDOue4z5f?=
 =?us-ascii?Q?PspL3EHjaws3tT6v9qTKmhrtlzKXvoJWQR4tW91MYhdIm8RYtNkvrMa1BGlQ?=
 =?us-ascii?Q?Pin+BiUGNM286wRCtbC0I/C9IG30R53P0K2YV0YRvEyLtAC5TMb76q/XQRh/?=
 =?us-ascii?Q?SBcjGEtOPIA5rM1tDt0OQuvV7xskQUi6Th6zgYQvp64ED5I8R07oRPhKaZ92?=
 =?us-ascii?Q?u3JuKTGmg4KVjM9+Bm80Mq7iKXyExy9bRkG3GqNcEdnkfM53mUAjSOLCU62P?=
 =?us-ascii?Q?NWXFUDK/fdE5EOkqRiZziQKyVSyuUOIfkeMgSLVpVJo8gM2DQL13BnSxVYQ0?=
 =?us-ascii?Q?qrIQaDNZc16bx4bylhHDN1ozWk7YVTq3qoym2cp2adixD7Z5Kh6dLFS3dtpF?=
 =?us-ascii?Q?qzmz53X/PbXv3anYTtJ1kjg5hTlAKkwiIeyChjssgmX61+shdz5MVuGC8g8d?=
 =?us-ascii?Q?rwrDdzz7LdlyzVHaxZjkZ2WTa4Y4dAre8ElOMiHVnZnkEywN3tVjMKZY/wDJ?=
 =?us-ascii?Q?+IZ471BJism3cc7SbmO7JxM+CgefZvB9lFsZvSFDtKSgK1zxWedW2/hv3hFw?=
 =?us-ascii?Q?DxWhmIdiytS8fQTwVqO2Gdz7VFnwQfODwmfH0fvZKEfjYZZ2p/U2BHxe49W4?=
 =?us-ascii?Q?x+OvX9CT1NsnMdwPMYuHlfWvnRQnxoEYAktz8EysJ29VRk+/3eVBUM3K9b5c?=
 =?us-ascii?Q?0+Rt9PSS03qFF2rO/8VI4YHVJM2dsmb4Zah0Hjn/Ou+rBDyDdRzJuoQ55Y9n?=
 =?us-ascii?Q?bHpOIwslMqgI9gMLePrbCXjleM7T62oC1bzl8rCkh69dsjY5p03nLE3RKmjW?=
 =?us-ascii?Q?xL2IQFNuRzXuWnc18iLkW8Kb2kAwWPLlSD5XqNRIu9++SpZpQ39vmWDHKPv5?=
 =?us-ascii?Q?jBTMef3NVOBQDJI4tPKb1KViWj3z2n1akBZ7/HNTyXxX/7IKY5MCBVu29Kfu?=
 =?us-ascii?Q?gox4BGzeEXZYhWEeyVHN1MycagPKdKmYi2yg4BRnyzsYgNs90IAAlAHhM04a?=
 =?us-ascii?Q?nOBjQwEyIGo66dEkMUd+3umqNUPk2GZK9PODRkSFDyND2Y8j0C2DMdc5QnNH?=
 =?us-ascii?Q?2de0sGjjdORZX4bFxYfZmNjBeiiXN1Li4YhMNmPAPzqbz3NcRdJu2Z++hbeF?=
 =?us-ascii?Q?FFwjmxVlpUWZKESpUoJb4LamaGhlilV3efBU6+M5QUHsCAQ7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b996ef5-0494-4b6e-743a-08df183bca9a
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:19.5991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onzAsBq8Qsm+LlWiQ3sAdVz/zb7ohV+kWUpAB0wjz4BYxAe3H3gzKYhaSd4Wuks2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The range-invalidation logic has long had a FIXME that there is not enough
information to properly compute the range invalidation. There is also
subtly not enough information to properly compute the single stride
either.

Change tlbi to use the information format that iommupt is going to use for
ARM. This prepares the invalidation code to support iommupt and fixes two
small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single gather,
then the iommu driver should issue a small number of commands to execute
the gather to control invalidation latency. This is in contrast to
io-pgtable-arm.c which generates many gather flushes and direct walk cache
flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps, one
for leaf changes and one for table changes. This is enough information for
SMMUv3 to compute the proper stride for single invalidation and to
generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt conversion
will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation is expected to clear the table and all the leaves it
   could contain. Set a single table bit and all the leaf bits.

   There is a weakness in the existing io-pgtable where it double
   invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
   again through the gather. Since these are separate operations they are
   not capped by the invalidation count limits and a single unmap may end
   up doing thousands of tlbi commands. Eventually converting to iommupt's
   gather only approach will correct this.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the range-invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 188 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  25 ++-
 3 files changed, 185 insertions(+), 57 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index faeec656da9e7f..fdc6cb7a128037 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = start,
+		.start = start,
+		.last = end - 1,
 		/*
-		 * The mm_types defines vm_end as the first byte after the end
-		 * address, different from IOMMU subsystem using the last
-		 * address of an address range.
+		 * No information comes from the mm, assume the worst case that
+		 * it changed every table level. The way this is hooked into the
+		 * mm is tricky, the range won't be expanded to include an
+		 * entire table level if one was removed like the iommu gather
+		 * does. Thus even if this is a 4k invalidation it may be
+		 * including any table level too.
 		 */
-		.size = end - start,
-		.iopte_size = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	u8 pmd_lg2sz = arm_smmu_pt_level_to_lg2sz(tgsz_lg2, 1);
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows range invalidation to
+	 * use TTL=3 in cases of PTE only changes. The mm must not try to
+	 * partially invalidate pmd/etc.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4062ef2e13fe30..de9017eb93458d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2397,8 +2397,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2524,16 +2524,11 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 			    u8 tg_enc)
 {
 	struct arm_smmu_cmd *cmd = &tlbi->range.cmds[tlbi->range.num_cmds++];
-	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
-	u64 iova = range_inv->start_tg << tgsz_lg2;
+	u64 iova = range_inv->start_tg << tlbi->tgsz_lg2;
 	unsigned int num = range_inv->num - 1;
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
-	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
 		ttl = 0;
 
 	/*
@@ -2541,9 +2536,8 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
 	 * to target only the exact leaf entry.
 	 *
-	 * For a single tg invalidation a 0 TTL can come from places like the
-	 * SVA path that don't have enough information to get a TTL, or as a
-	 * side of effect of the splitting.
+	 * For a single tg invalidation a 0 TTL can come as a side of effect of
+	 * the splitting.
 	 *
 	 * A single-TG invalidation cannot reach this point if it is part of a
 	 * CONT group, so it is safe to transform it into a single invalidation.
@@ -2554,14 +2548,84 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
 	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
 		       FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	cmd->data[1] =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
+		FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+}
+
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
 }
 
 /*
- * Generate up to two range TLBI command payloads covering [iova, iova+size).
- * Sets use_full_inv if the range is too large to represent.
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					 u8 tgsz_lg2)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		/* If TTL is used then only leaves at the TTL are invalidated */
+		if (!is_power_of_2(leaf_bitmap))
+			return 0;
+
+		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl =
+				arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+			/*
+			 * A range invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				return 0;
+		}
+	} else if (table_bitmap) {
+		/*
+		 * Table-only invalidation. Spec says:
+		 *  For operations with Leaf=0, invalidation of cached Table
+		 *  descriptors for the address and scope additionally occurs at
+		 *  levels between the start of the walk and the level before
+		 *  the last level given by TTL.
+		 * Choose a TTL hint that covers the only target table
+		 * descriptor levels.
+		 */
+		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+		/*
+		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
+		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
+		 * since we don't know what instance this will be applied to
+		 * yet.
+		 */
+		if (tgsz_lg2 == 14 && ttl == 1)
+			return 0;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		WARN_ON(true);
+		return 0;
+	}
+
+	/*
+	 * Assumes the page table is formed properly and does not trigger the
+	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
+	 *
+	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
+	 * 0 cannot be hinted because ttl=0 means no-hint.
+	 */
+	if (WARN_ON(ttl < 0))
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate up to two range TLBI command payloads covering [start, last]. Sets
+ * use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2570,28 +2634,21 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
  * invalidation overlaps the first instead of exceeding the requested range.
  *
  * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
- * produce only a single range invalidation and overinvalidate so any potential CONT is
- * covered by one command.
+ * produce only a single range invalidation and overinvalidate so any potential
+ * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 				     bool single_range_inv)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
+	unsigned int ttl = arm_smmu_compute_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	struct arm_smmu_range_inv first = { .start_tg = tlbi->start >>
 							tgsz_lg2 };
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - first.start_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	struct arm_smmu_range_inv trail;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both io-pgtable
-	 * and SVA pass a nominal last-level granule because they don't know
-	 * what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
 
 	/*
 	 * The spec defines the invalidated range as:
@@ -2632,20 +2689,43 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for single-page invalidation without range invalidation.
+ * Returns the log2 stride of the lowest affected level. Single invalidation
+ * removes all IOPTEs that contain the IOVA invalidated, and we can reliably
+ * assume that the architected page size and table sizes (not contiguous!) are
+ * reflected in the IOTLB. Thus if there is a 2M leaf entry we only need to
+ * issue a single IOTLB invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+
+	if (WARN_ON(!combined))
+		return U8_MAX;
+	return arm_smmu_pt_level_to_lg2sz(tlbi->tgsz_lg2, __ffs(combined));
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
+	unsigned long num_ops;
 
+	if (stride_lg2 == U8_MAX) {
+		tlbi->single.use_full_inv = true;
+		return;
+	}
+	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
 	if (!num_ops || num_ops > 512) {
 		tlbi->single.use_full_inv = true;
 		return;
 	}
 	tlbi->single.num = num_ops;
+	tlbi->single.stride_lg2 = stride_lg2;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2665,7 +2745,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2690,9 +2770,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_size;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2889,12 +2970,17 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 table_levels =
+		BIT(arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size)));
+
+	tlbi.table_levels_bitmap = table_levels;
+	tlbi.leaf_levels_bitmap = table_levels - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4165,21 +4251,31 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * io-pgtable-arm.c calls this function either under
+ * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
+ * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
+ * with a single uniform pgsize leaf. If it has to change to a different leaf
+ * level then it flushes the gather and starts a fresh one. Thus this always
+ * targets only a single leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_size = gather->pgsize,
-		.leaf_only = true,
+		.start = gather->start,
+		.last = gather->end,
 	};
 
-	if (!gather->pgsize)
+	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
+	tlbi.leaf_levels_bitmap =
+		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 50fe7e99df898a..245db175386a9d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -823,17 +823,30 @@ static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
 }
 
 struct arm_smmu_tlbi {
-	unsigned long iova;
-	size_t size;
-	/* page or block size of the leaf iopte */
-	unsigned int iopte_size;
+	unsigned long start;
+	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool leaf_only;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * The pair selects the invalidation scope:
+	 *   table!=0, leaf==0 : walk cache only
+	 *   table==0, leaf!=0 : leaves only
+	 *   table!=0, leaf!=0 : walk cache + all leaves
+	 *   table==0, leaf==0 : illegal
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1205,6 +1218,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
 	/* Prefilled for invalidate all */
 	struct arm_smmu_tlbi tlbi = {
+		.start = 0,
+		.last = ULONG_MAX,
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.single.use_full_inv = true,
 		.range.use_full_inv = true,
-- 
2.43.0


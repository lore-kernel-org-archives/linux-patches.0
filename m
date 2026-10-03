Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAD340406;
	Sat,  3 Oct 2026 01:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990639; cv=fail; b=RuMoQqWqsSkFrhLgPRMxCBVEOmN/DLGXbtX4jYAvRrRyi9+GUb442D1gQSF96m93iyr8pJvrzQvX2CYE1jUa2DCb8+GEtkHfAmvAYVgtIhQhkSlhlNUqyE1wT969HKR/3Z9rNYwtdx+HWkRjRkjn5dOjaow2wbxFffLp5rgGmbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990639; c=relaxed/simple;
	bh=MoVdsFf08hPeHPm+si/ZfIuyLW5HdwHrL3fvXizDcJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t1YhNM0Jg0AZ56I/Cxanot3bjlLh9/g1On7yINAOTkz6RK8UYkd7oFGaWJ1VJCBch2sotSSCkqUVMsCdZrzFmsQsgF68Ng62f6B5GTU5mIZ3+PxzStJJrketSjLHPFScxpdG1CVQCqtuVjkgQ8iY9imBV0wgGQNMtSuwtOLptBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J5A8tmKw; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J5A8tmKw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDxzMJMNudC8e+VJ3b/yPmeviOr+569YFfDql66BfF3hD4FSPU6FK5OfmKdp2DffM7B8GZ+4J+4f5bwGdS+ud4Jly0/BwPRmHv8FFxOZ9MKMgNXtvHSxsNK+zi85PZqZ+6ST87VplPAciHIQrtibwp1uYrBgPV0OZMI4MMc0JMPG3tq9F6j8flafu3IZK3inEmE0f3I++kbuGDVxwqLhTtnAGGxwYZ3z19224S1OasuXNJ/8Z0DyyryyEv4nT8/8NCX4cTCTCI+3HhYeaKavZqWi9ZqJqA6ZFuu839SYu2K1ny4UIpup8W7KVf3d8zkWn4yCzppMlfjPSGa4z9k9aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpTad15HVoEJIvGp+PsrgnXDgezIARHu7SHu/M/oTGI=;
 b=ea1E+w4ie8A9fcaXyrBldUwKsEAlBh56mIoheYPYxWW26vOhioWaID99FFO7ENECXI3TxBv79BAUkE0Oc5dpWZssxmgNEoF/2dXpzO62frDsbcQtOBKzXRpxs7f8B9u3LlKn2uHDd+HH+xZIeo9lXHaHUaDqMT9Ge4bOEHD3wgo1L3KcjplCUiksKLEMS5Nr2EXnnko7ZDZLJfH2ZDauD6JSrFq+bg0y8Wf6tyq03ysJQMufQ6gCckqMU/dhRbRkJRs7AdOhJhaxKh76D7kjfCHSjZ2V1snjHQcDGFq7yJBVvDhCHs1ltW2Y9MbJZqvKcaCgeL7UGFmrTMJy72Vqwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpTad15HVoEJIvGp+PsrgnXDgezIARHu7SHu/M/oTGI=;
 b=J5A8tmKwTar3qE2GlDkaJEATVfJ6aBavrPdTrJevn4KzDQTYHjb8t8UTSAluMtoR80vbCDUEbZw2MWv+ykiv1jD+OXcnSjuATSF0IThnQnwd3xqtgR9y0JC5R+o9iG3AF5og7s0klSW4qTYQWLFdSg9Oh7Ydr7KVgPctrzVlPYStNvS4tiGs9BNLbIA7aOauvxlL5Ztaq1xtvnbX+j2rTjGrIgZhLQhDa4Z0toxQuQEcsDlJvh9MZrggz4BbZZT9oex0bbthRH4uAKkThzbUQuUqvwBzNKmn41qNWTPTigIZrZt8JfMYYXmIQKJbH9ITep501Cd/K6WuhCc1CblQLA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6615.namprd12.prod.outlook.com
 (2603:10b6:8:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Sat, 3 Oct
 2026 01:23:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:33 +0000
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
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v8 8/9] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Fri,  2 Oct 2026 22:23:27 -0300
Message-ID: <8-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: dcbc3384-649a-4433-3805-08df20ecefa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|6133799003|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	g+SANXGLHMhV2OrtM5GVKFXt8D7i/NH7sjc29Dl/HyJrFytg93iHPWrIjH4p/VaUyGb6B6kS5STBDrXXVrXWvHfYE6pq+hdxGj+dP42XMl9n7obyyMvZMoMQ+UXSN1F7PZ2geZvwSuRrNO9rOGgv0HyqBgIiT74NSFlo7json9yh4RIj+TPG3YxmmZAgYa+EYn+nsLpF2R7W+zjH/EDHZXgzU4CbdeXaoUhAnNvAGDDH2e8GufnH0vpx44BOu6dTXNrqf9xrMYpv8mqdZmVWwI1ztO0NWRkrCYjo4l7zVUSmyK11w19DmYP/1toHe37co7rDH6fDa9gdHMsaiNnZcsPLWWh70TZ9u43S0CEjJrjS5VEsgsSsaBmkUZjQinJ4AL/Lg0zvId6V/mFgmnJMtk0LqNw9NkMrmEMUfx8KT4NK0vug3bHSpS5IHjffhBg6DJAjOGf7zMM1VSfBGtry7PPIkczmFLGiDW3l6a2h1PAVloTQ1UyDV992ctAf38+aisZDJv7JF1R/T8MdHeLL+44MJkBE3D4+vyCHvaEWhzTcxNrBBl9CDUYojGAVuGOrOTydTcQPnKHhCJCkZseUzmfWXislOyM6PGddE+jtvYXtCXcwL18setpFZmkFebaTiAgPwCzM7h17F0agJnGZGj+4I/PQeqpC2fKd+Qk5J3BItjYo5/ZKj2XSiw3fBJ5lEapWNtKkrItni0tPnYLq3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/rj+LSLWgrhQIf8G6zoFLbhYe3ZrDzWyKAqlPU75XU9xAev71J9JyuVUBvIh?=
 =?us-ascii?Q?3POOxDn5mPKuPLRjqoJ/QpjlIw1JFQobUoEEx9yx3WxWhB5ZEAnUH3TtwbOb?=
 =?us-ascii?Q?AKib/P9VwjVuZg4l6z9HaDvbuOUQHwJUxGDP+jS82vdUO2Gvj0WtnP8IkYW9?=
 =?us-ascii?Q?Fl91JCwzVXDFX8S6LsHr4ZnYhaphlpcc14XEJjas+ou3B7SEAb7ayi13Sk4O?=
 =?us-ascii?Q?fboXXzmSlYIslORBYAUdEq3loByv0VzdHYUlgbkwudHFag+4m18a3CAQpUfu?=
 =?us-ascii?Q?/UVwBCie3ymMJDfUctCzFixbcPMfg/95C1ZvDWTJ5yC3i/Tv6X/uSxQoNQhv?=
 =?us-ascii?Q?H1PCRsiCm/sbmOxd6KV/c8D8Tw6QP/HxP28fEfOlvD+cYnJ+bBYe/5XWWjcf?=
 =?us-ascii?Q?ZSjcI7ipcBFFd3ry0IfhD8O29HAkyyxucM56IVYIv7rr6O2mX/N4q3abJV7u?=
 =?us-ascii?Q?/tJjzRJpLZ0l4khyloxRLNC5Exdu2vqDKwXfO0EJp2m4ab8ghQCUfO7gDs2n?=
 =?us-ascii?Q?HxdfD5w9LSo5shjEw0Th4XQWkQMQ8bMtcZA0bE+QzFYm9OU9yRzFzUjm2FJ2?=
 =?us-ascii?Q?8KQdL/PIj5/elnt7KIYloW2voJsI/J3aO+PCxeSsXWXk36HbWBQeTEg6dw1B?=
 =?us-ascii?Q?DCF6oLWEGoxy+iqXayOnMihyqHBgVFeWLXav9TQr1SetVe3MV1GlNzzajKRD?=
 =?us-ascii?Q?1TQIJII7tPNMVj9D5T5UeVfzy5K+Q9PQ2+vUPW+lamyX+DtwpiZK412eb2cd?=
 =?us-ascii?Q?IYAETsHnEU9zMso6tbeIL0DLg9RjKrlLN1l8QBw32FtSF90tL6pvBlnGPpdR?=
 =?us-ascii?Q?2SovrGoXw/gVc4g+MgzpMnzr7PPFdWaJwmiT2KofeJxJrmyi+vEELI9BRvEK?=
 =?us-ascii?Q?V1HkMpx8lqZ+BKvgCRj0ChPb1ngeEh/HEnjbZPdsofcS6ZtK2NLpUZT2iPj2?=
 =?us-ascii?Q?pegBmbKOzbw+Oi6Fkd27JuUOXmawpSl6ZLJQTVSOGZLvpwA3ikwkoACDKmFX?=
 =?us-ascii?Q?ZcxTF786PDoXbMeKztF098zgTsvuTmbfB2r++bomX4ivKOxJIOGdrv6iOMvI?=
 =?us-ascii?Q?ESzPkN7BDR3GNv+sadMcuiaHlyBzhKeL85l+Jib4rxoF7K3+sUXAOfacNuLB?=
 =?us-ascii?Q?xeS0Ax8FBdQsMnRlMuQDNU2rHDmCJ704ueoOBEAk+sV5JX7NvJzJgkJbv1np?=
 =?us-ascii?Q?TvkPOJb+GfyHGUZQsgrBl1nxGmqNfimfmI5RWK9P5OgU4bi0k9qQ/ZQqs1U8?=
 =?us-ascii?Q?vjubeIC/57tHl5s26oxk3ITY/16C8ZNpklzRDTWfI0L0T3zNSsIt6p7gS0Xx?=
 =?us-ascii?Q?ywgx6rIkxd1QgYzBsUvUxmfNcHhvdQpEU6fbFG3KdodQnFnw8pNNkH/4uMIc?=
 =?us-ascii?Q?JHIlxwvxHn74PXcdFvek2TZeNBcidZQzc0NbhwdyLYIOlEkCB2yQdg1eaM4U?=
 =?us-ascii?Q?r1ZHZ+Qt+ED5xEO3Tyft+3aWFOE9Ool/heswmZedk7Y3XhyXH3TVJFLcw27j?=
 =?us-ascii?Q?izQ59U+dPBVw8qPEiZU3ui8rsCIqX6N3UYc2N40C+HCHeBMQr7wHrQ9cvkka?=
 =?us-ascii?Q?EBgWUtskbaD/2MphlU5BK4CnPiBfT6zI4fUNvsCeZmWMyTpD3NJPoglEGYDQ?=
 =?us-ascii?Q?onBj5XINUkASYuk/a3iSGv+bJ93eOuC9RxUnTeNU3vxqsgOc/M2+AUtB9kra?=
 =?us-ascii?Q?+X0zXzwTVuvJjijIrJ1Pq3F2TXbOaSut3zBqS3dQgjOpCxZI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbc3384-649a-4433-3805-08df20ecefa5
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgLZX2D6S59ghw/O4B1zSbrOGqchBVzzrtjbis4a76RZxbIFyBrjfHTwWVm+Q2CC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615

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
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
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
index 9724c58d2194d0..7053f00dfb7d90 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2419,8 +2419,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2546,16 +2546,11 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
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
@@ -2563,9 +2558,8 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
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
@@ -2576,14 +2570,84 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
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
@@ -2592,28 +2656,21 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
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
@@ -2654,20 +2711,43 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
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
@@ -2687,7 +2767,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2712,9 +2792,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2917,12 +2998,17 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
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
@@ -4193,21 +4279,31 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
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
index 8e205ddd6bf67c..8950e23cb956ca 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -828,17 +828,30 @@ static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
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
@@ -1211,6 +1224,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
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


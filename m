Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237DB32AADB;
	Sat,  3 Oct 2026 01:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990677; cv=fail; b=gDY3PbJAk+HUiTkTVrGazRD4UfbBA0z1f2pi15G6BGqdcEMStm9GfZ+LCYdRO8cEip7AYe9b53lPH+DdmhpCb84epep1ph8yoKUz0o9CTNo3ibd+kJf6ZKybZGT+CMy7FQkVNOf1uQbyoOQeQ3tNLqo77/co2+dFTKkXqJtSJd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990677; c=relaxed/simple;
	bh=SM6I1NgR93SsM3y2+VjafxdEno2kLtcp/CyVcj9iB50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LYJuo2Sg3HrnImzt56CQEyva8C8H34tIzqVTr8FPrFR0RXQdJXhZB/jTdEjhUiTGkbovqDZMb1cbRMpWuvMkhpNZv62OC1b/ru5c0sgfnN7uY/PS00ueL6R+6r4pD1s+KzIqdYFuRMsoD3ax7PR69cB2p6t/bTCq0XX+2MUpnC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pGo/ko13; arc=fail smtp.client-ip=40.107.208.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pGo/ko13"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roRG8tPNc83RUfL2CxamTDo1M1EuPpNkZFQ3gwOR3r28VjJjq/16kyho+5Aiu7fdfVybXSFoX3eU4HzzfW337gSHHI8WDY9rBSRHrxzUIrx6Bv6YjiTq4z+qEfBhA36JGxhiqIBX6puzBY/Woalq5XWYlUkinVyIMZoHHQxnd5V1yxdFMAG4uIPNoXdzYToPokMIoXM2vWKK2hierTpfm9Dzrw6e24Yy3UcXgJY5y/bQ3FWTwDVqg3f9682A+19aVXi+2gBU9rzaFbWljs6MnUpDd6ARzarizB7f+XzuWaOlprYesOAMPiAuSZjK1W3WXk4GmDowL/KVqiOijA/7GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHy6L5w7EFoxRQmN8RmPhaWscYfspNIOH/slxFkoq5Y=;
 b=mAhDAMAjcHnesr4N6kDMSyJSjwr9PJ4j1iYReMFYV/wj4sD7CJmeC5iLXLjGqrecq9SqRKrCsYsNQKHbnw7wCcFbVe4HCb3Q793BaddHWzxdDUuw/VVOEqcpKn4mjYLGuSNKiW/eZRs+U2Ok/J3WeWm0Z8Vxd9und8mcU02yR0b5rzk05FXgIB5EMrSNjnwlYa5xaIMAYnZdGIeK32cvLOHIYgbmf5YXZyT+5wHEj2sK38W0aiTCPdytzd62qRAJUQM3U5NIgoMqI6M0XhlsHeHl4QPWC9bzVIrOIXDpkmxuyZloMr9ud5NgnAePP/9mCvLFZYtZB95Xtn+5Gq9wQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHy6L5w7EFoxRQmN8RmPhaWscYfspNIOH/slxFkoq5Y=;
 b=pGo/ko133P1WBf5Hw9hVgp0J36l6fi+1Dv5TxeF//AKVGwxn7NRNnRKtw1HY/0jpftkS8ki28kqoB7UsYqTCS7apabPM3ikJVM4WxAjdKrr2xYDv2JstXQMv/ZMweEFCSdeSUnt9kNINr/n2ItSNUYGgBgQrk1hd39ym7Ed+dcAyAqeeo9igCMLX+t8rgyX7SkAxNG/XWH1OcFu9cbLO/0IP9yWQhj5gDt9Yb22iXOGGQTWd6wSXD50KXpki+e6K6dHb7AyRVvwXuJVaUjcw2m51evFivOZQdDdqidPfwOhHQi0rC13St6DBUwIfU7NQje2nPQZVpNaIy40pYZNddA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB7641.namprd12.prod.outlook.com
 (2603:10b6:610:150::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Sat, 3 Oct
 2026 01:23:32 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:32 +0000
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
Subject: [PATCH v8 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Fri,  2 Oct 2026 22:23:22 -0300
Message-ID: <3-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 382d02cf-082b-4290-0c37-08df20ecef9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|10067099003|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	w0HgnLEHLu3kLmHMsoxakNpa5zgwFtZCPN2Fd4oE4WMnLACaIoHH+J/Ip9poHsAp0iDkOoXXrXlHKGlQUqTgo6R3v7L2gYSq/j8UTaqRUWq2msxSPOSSs1LvkFb3V4ZtRZGFYTVU7vXux09ZfDFb17ZLGtSWQfxbogZ9D/UOaaAZLAUi5qc9wOQnyNPHdveAT9qsXBMZxaO8j+ozTgUdMIBmjrXzsybWoHtIl/U9Ora7ggj0Dp+4PRTvKhOVHd4OOcFh8NtQ2Hnu4zKLp820lABBCqSJRcXRTx2Dw1NoeVM/nxe92zZhbpeUErLwsrrVUWm4ze9qqKIKa8yDtfZ+Hbf5jFH7pmtsVuFRTrzH5BhFZjrp7Ve++16gQJbPAsgtxsDzV/gd7GkK9j7AZ4JYvSCsTgKZmkH36XcE4eNMb50AniNkXZ7HJ8DqF7xhRgDP4oi58alLThwbzmO4h5lQXR6r3lIOzYL77HIUimCLR9snIgJgd2SX0IAuZNfYyWgFLjVd8pFFFzaZAVEoJXpdqTkhGtQwyEfr+jE97RvN8nV3PxMVjXE1XunYwblfQHj1FZ//KZjvEvEDnQ6p30cwE+kSqDxxKgkzAvq7ZnWXOeyEr4IN3hgKI9HgT+++uW2FJKZFvuthXN0ssfeqkkxMNmOpr2eHLFBbLvXKEeC8rtrNtjVxjJnhF43VljGiSJ0e9cpfILd/RtPFClQLITIFNg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FwE6zFqerlfcCH+3WPVcIdEG0Ekl0w0b9pB2Q3gPMrMZSdJ0pqcnKSzoP3PT?=
 =?us-ascii?Q?t0Igg5Nz/t9ADEh28tHh/XV7+v5En8LyycmYW+swn93oP7z6NCMxfkbefjHN?=
 =?us-ascii?Q?JGVqo6EAL9sR0bkY2E8LvVe+VvVrGbJlhwYv78Sn3urYxnB2WFz4HsBI11UY?=
 =?us-ascii?Q?m5yi2ayZtYcC44RX9efJ+z5w0BeHReyQDrSGB20dULn56W2XKXiojCSATTPl?=
 =?us-ascii?Q?Vxt/Gc8G9kFBgw9DMpztb8asJKdyeXPi5/8CI3Jk4u+3Jwtx4TBlWP0FDh2O?=
 =?us-ascii?Q?epUHlqVfrDvRiI2wR0pwLl3Z1NhKPOcjxMgUQGEtk32SlrIA4lmqdwoPARg2?=
 =?us-ascii?Q?y1T44Yg/F/n/XMhIM94kNkLA0arvHVD6mB1Od8D5hx9xR17zRrBmkK0/5rea?=
 =?us-ascii?Q?gKGZNaT270D1SXysa9JL+uXkcQBun1khW8uo+yiDzT+ixeXJem9tAQPFtvhK?=
 =?us-ascii?Q?TlRGH/z/a1AlkllqPuvLHOk7R4I7omIHJFfTPOQVb+jpSUDvqesA4y+N1AFJ?=
 =?us-ascii?Q?+PmlTC9k+8IGKVcPX9DmWzhX6N2c7QXcTVb+DRtBb+VDsnPOEC5ytPNHdfVp?=
 =?us-ascii?Q?fXg9Ac9SNx3DL1exkQQO5KuYYI7OZW9wdDUpBFW+LEHiL7XqjC6/iWkkdPAA?=
 =?us-ascii?Q?nJUuzx+7/h0qWtykg2OTl1+covCUQGnmmNQRnTsGuyg8o1dRPeqmdn/K2X5W?=
 =?us-ascii?Q?hPeMnV0z3uwZD3XbcZn7GRooodtM0HVvN+zSWXVcib8ozW7HYgIg8bOxZH+2?=
 =?us-ascii?Q?n6ZDmqRbF7XzTXuu+5mAkiKrK9F7+ysdkyNL53SFkg19AKGfVbUFZ4ew2reO?=
 =?us-ascii?Q?R9cJy4+cxE86kwJEACmPiFNq1RdSJZhvJH+2l4waWqJF3Wy0vjevCwIuF6kO?=
 =?us-ascii?Q?Fz0luUtQLyESwbc54w+jPIN+xTdm5qs28aRfaLiseUGOMyMhVx5mLhf0Ijow?=
 =?us-ascii?Q?Tn4+3dxp/KeRgK6pQQAp9nRGBzqtcFP96gc+VE3rdZ2LvNRfeSY5/FRmOB1m?=
 =?us-ascii?Q?XrATXE7XooD9mldWwJI/aDW8uTXFQkhVSv/d4qui1/cTGljxqpN6tuPeWfp1?=
 =?us-ascii?Q?9MJ7G93Y+7j1uwxQo9CZxwNpwkN9mNNegPofeFO4gmAtqWjFS3k5LksQJdAr?=
 =?us-ascii?Q?5FA517fhrBFvLPNb91+s2Ka/LOyeKma0zP5jbuRyhBBf6snX/ZhTi/1oe9IW?=
 =?us-ascii?Q?YZ08Qe/JNybFc9oe3JgD8biSbgK8UMIWZXqXtqwaOU/hROhR3ezCeE5vobyT?=
 =?us-ascii?Q?6GXFBC/IElFJtFZ3OjGPyT0Gm5Fc7Ql+EKoRrUNsLcO5dQ6toQL2qcdN0ppQ?=
 =?us-ascii?Q?cV7Q5fJQTGiTXxPtV9RSdYJ3DSOxJgVY5z2+dUd0pbPWl/TS+hGtwiFLYASs?=
 =?us-ascii?Q?+uEH7MXxt09tRjJ9borIFjAWbslycS9Q319JlkUYvHSNew5l/559rXOK9n+H?=
 =?us-ascii?Q?Z3MvcdxjqSgOBFGR7g2fWWT4qHZLvchXlBIzQTMWn2dmse/4gzAODKOXzt1p?=
 =?us-ascii?Q?yS+LePcZSWBrqeW/XXGuczGz81ivF4ZLLiflvOspzpEWtfLxalRhrUup/xmS?=
 =?us-ascii?Q?AfJbFskbdswLHDhIV89/Y/QQUSyYk6veAPC9bZgdw4kWOQG5vS60Q7eumoqf?=
 =?us-ascii?Q?GVYm23Fqs1P0jmkRD/sEcLTtrL3s/GmE3QodmehrIh5lCI87GyYWrZWup2Tp?=
 =?us-ascii?Q?yHNv1X8k1R/0A4qzY1xsgShWZ20yLZ2J8UdZNhbE+mT5UhN8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382d02cf-082b-4290-0c37-08df20ecef9e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7eqfPe9tKIazB7TSAb4mhOkXQfn5WjIAIbwa7NqfdMvyPIpSUQr2x1+/XYsJK6XP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was
created.

Pass it around in the tlbi.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 29 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 ++++---
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 3f50298a1c14ca..2f76f649dcf1a5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -345,6 +345,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bcdeb9a47df7bd..2df064cb0a5ed3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2485,14 +2485,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_size;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	u8 tg = tlbi->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2632,12 +2631,12 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
 		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
 						       tlbi->iova, tlbi->size,
-						       inv->pgsize))
+						       tlbi->tgsz_lg2))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 	return;
 
 full_inv:
@@ -2745,6 +2744,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
@@ -3001,6 +3001,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3240,15 +3241,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
-			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
-			  size_t pgsize)
+			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
 {
 	struct arm_smmu_invs *build_invs = master->build_invs;
 	struct arm_smmu_inv *cur, inv = {
 		.smmu = master->smmu,
 		.type = type,
 		.id = id,
-		.pgsize = pgsize,
 	};
 
 	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
@@ -3300,28 +3299,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
 {
 	const bool nesting = smmu_domain->nest_parent;
-	size_t pgsize = 0, i;
+	size_t i;
 
 	iommu_group_mutex_assert(master->dev);
 
 	master->build_invs->num_invs = 0;
 
-	/* Range-based invalidation requires the leaf pgsize for calculation */
-	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
-		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
 					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	default:
@@ -3333,7 +3328,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3344,7 +3339,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f0839cc767dd68..ae1fc9bae34098 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -741,10 +741,9 @@ struct arm_smmu_inv {
 	u8 size_opcode;
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
-	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
-		u32 ssid; /* INV_TYPE_ATS */
-	};
+
+	/* Only used by INV_TYPE_ATS */
+	u32 ssid;
 
 	int users; /* users=0 to mark as a trash to be purged */
 };
@@ -815,6 +814,8 @@ struct arm_smmu_tlbi {
 	size_t size;
 	/* page or block size of the leaf iopte */
 	unsigned int iopte_size;
+	/* Base Translation Granule of the page table */
+	u8 tgsz_lg2;
 	bool has_cont;
 	bool leaf_only;
 };
@@ -1069,6 +1070,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0


Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF517B506;
	Thu, 14 May 2026 00:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717496; cv=fail; b=q2ZfBMRk2NgwFf5SUdpXmTmM9TOIMX+QzH7HQrGttFGd1UORtEakEvnmWZwvhrvGXnEi2wJuyFb38s0p/a2LChVnFv4U1kgvvBp3Ihx1Juik5EvR1lgCjtiNJzlXX4dx/np/Xf16N3onoIYAGaMNo1Vf5HZQWwQ8znSe1dC6u6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717496; c=relaxed/simple;
	bh=g0TkPyEQO8hYW5/mYyECqE8YvuY7nI5R/MNaStA3rCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dGmc3oFJNTIJvaspxTJmtxx2kzQhkq+YHnGjINPB9QkVeVmouzELFiZUHNw/hBTTDgwZ2aYW16JNwPC4GsHlmLnxd+jB776glN9tPT+05RYi56LG/12K1nOIObsNH7st9Pky7WM3MWljH0AaHwmNSow3+7plnQMGBdr+ZHw0sjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L5LgM792; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L5LgM792"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5kx67m1giVK1i0+EbgM6I0GlAwZjWrlOHBKMnX0XwGgR97d5zIGmZ5tgMsIbrbaGoUcEqKBcvw5k3HMQBWmoLDvvyN6BQJxJrxkazJvPpg4HZSesKi9mjaKsAxh/iOTuFiMiQJQ7sWLKse/n7bfM4IQ9d/LjKVy/pI3QPYAh4utqx1MBENyxuuvVomC4TQe3kKRo2Cy060BP8dxiMZxZR+8YrbUz8sHypDqkhKSfhKTKt33RrYVnd7f0q8oks4kdyTytxkq1GBFIrEchGHw5MgHl//YunQDbd9E9VEdvdehtWFROz7mtyJ4JJororG4AaHjrtJan5ZoKJQ5T/7Otg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14i+4MoCIvUscZ9NJGN94fZcUl30SBfZc76GPBT1vQI=;
 b=GtmYsvkUaUT4Le9OWdr5h1AdpNrmFllurJM4tLHbwp7FJDn1953297F3+brN2Y66SMBsfPRXYMdVO9FWLFFoTzsOA2xYJcbW18wsJGG2CRyd80q1Pse1ZQcYlUAmSEmA1vdAxRnEtThWrA3jksL9wvbJfT3kqEaXBp0lJXAglzmycUio0i+3FxRYQVcJIzaEclHlaeTqy/YkB7ZA28BetEby669N0F6eeBEvnuv/cf6iu94X66ePcw+i5btYzceRNOMty+7r1/qowV5du6WkdY4jevp5T5sHgQf916HslQBGquEBEp5lnE7NvvmGIwZtVPvxLiWHBpYJY5LqdWBgrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14i+4MoCIvUscZ9NJGN94fZcUl30SBfZc76GPBT1vQI=;
 b=L5LgM792p6aBoRSwQlKRspfW9BsPmH/Re4iwjjZ1n0VVzAFd9R5PtNTy5D4c2DMus2qFD5R8D1HjZhDEWu+9Q3TRyTr67GjuDJHQsytEfqaI2a2b3kXxkCAuoo/dqCODj2UBCXwtDbQJuVGlV99apaY2Yx8FVBIhG7naGEVqBgzWN665jj9JDsMIWfcUqQ+hiWhTGetxDEU0KBlmV42ZttI8Yfyj4mGQPcwkcPCWAv272HpoxVktGpxKVco8m3mh5V4vCaspx4h4GRQKs54/Qo2oM9r1YaoO5DQYRZjbfPd9UMBVr8OKvO7mCUGlbXqXjUxaFErgBSFDhWBlIVrUSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 5/5] iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather
Date: Wed, 13 May 2026 21:11:20 -0300
Message-ID: <5-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0150.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: 5931cbf8-0594-4556-2f4d-08deb14d5510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x6Vg4SWCvKtrhr+34GPoboYpSpBkzL9xlijIZueot3RV1HyxTXFO2/EzrwfurS9KmPVQ2h/KILAGe+1A1w0CFrEkOPItS8gw3R/NNUHW6rcUhFzmBN4mVFhkEoj9eSfcS1GM+cmdM+dKqvQY+YFBO9CidM3eUsxTJThLXdY/7SyjZgxrSNF+SVdQGMDC108XBmyEhKAlFh3QoTsf1cVfIfM+jzdVSvSXlMoBdg/MwDeAXziB+qvPB9IJwh5npnx65IK8FpE8AP/PPi5eIz0gGb0B43ilNWy2fiqIEWz9d691icWHUdHrnmzBTNjDh8o1Mvr2ayvpdK5/c1Ckj7z64g5PpLdtNh0g+fLy25YdoXaX7enmHP72XZgkPbqck3c0uGp2NCMils/cpy0FLdBsqsLofycB6SZ3BXJ+EtJ9cYn++1di6+IzFYXJHWQcS52XPevpTjBlqeL8f5NjMnihVRQJmCJ2K9s5DN+1cn9kCbsj166d2QOhF3+VmstDF0KuD9RVrBtnVdPOIRogMr7pJO9PVlkzMAcx3Gw/8Gq/PbEfh4PE/zMlwTw1AU709GG0yafhABOtRVIDoHSnG7O6rXROzwQWNMaDf6ZMH9UcoxAnnvT1bciEWrsIXRnL3RosWHhCZAQhnrSG100dl//5AH9K8Cb/gMU4tW3e1g7alsuhSwmEwZiO+EP0tJF4Ilxu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tmD01DGpM3Cs8a7dTFyTdnZwaidPuO+/9z71IbvrN4wAkEks30+gFe9aKOYI?=
 =?us-ascii?Q?qFZqMcbzsUL5N0RbuoCuTTkCxriehwNvR4L/nPwTUw9HyWEKl7STgQhk7/Sj?=
 =?us-ascii?Q?vQEiFaBb2nylPhxeBMjk8+zzNCZq0OtzTkaxgQxdH12PBKWI8zwHOzM/e3Zs?=
 =?us-ascii?Q?Y6v1EwF32MiZSMPvPlMFf9WKDKxjBm5uVsEwRSp37ZKphSsiOHIo0RtX5uK7?=
 =?us-ascii?Q?iY9MK+dEUqmwe/Pn4BEso0F30jwZOONN+PH3iL/KyY8Oh6bqQluYWEPTSdBi?=
 =?us-ascii?Q?6bAiBxgqx+kqdVJWJlz1crGJDVJNyA4SLdFH9Gu43FTrV9E/8cqE+l9t/McV?=
 =?us-ascii?Q?v8U7A7WyhOl6lgwg3Nzzy4rbDJaPLEBRSPYvgPPhkn7Et7a516lIm+tWdj4c?=
 =?us-ascii?Q?aU6UjaIjhoQBuZ8G+NrZ87WDcLuy2WpT+V1vlL3mlB79EnJo9LkQPnWg2RUQ?=
 =?us-ascii?Q?mc8oCqiI4nVvetri99rX6I1SDTFQooyWCKOFVS5687reHS3bGCbCCY7U1Tv7?=
 =?us-ascii?Q?mGsHfzf9i9FyRfkofAxdh/wQenFxfz4oAer4xE5hvIBntfOLT9CK0TfuKMyd?=
 =?us-ascii?Q?M6cG4+csU2Cil3lHjHyjRraRZcpHJjy2bRGcNbd2SkeSw9TvgY6mvJFYIXaL?=
 =?us-ascii?Q?iklEZ8zugv3z33ebHWjOEOa6SlotY8gpLKdN3cYvV4gfYTOw7CTF3l6hjBbo?=
 =?us-ascii?Q?chDv+v6rsbpE484Z0qpu1LLusHu/fcG8a1odwJ24zIgkU7Pu6ugcAePqpJUD?=
 =?us-ascii?Q?6arNpwZCAeX6dfaMXWtkAWpuYWYYY3/zwbZCSys89RN7XjMEFpykggqCUfEf?=
 =?us-ascii?Q?Rto2KEFVFZeVRngIA/UcO5nwsntim1qfuvoEgiJI2CBsllH8at2+n2fIcO/k?=
 =?us-ascii?Q?l+Q2Na0qZ3H7/TSLR/vJ0SZl9GodWYtrmA1KgwkXxklMXiCS2mXJIxW9uRpr?=
 =?us-ascii?Q?uiRV2OSivt6D/G6KOGO5RG3vHYDre5sSBdD5MBfvVlAgBt0aa6cq3yKRbd+1?=
 =?us-ascii?Q?kiIhY0cYmsZjk4jm7zD+ZTgHtP6Y/7j6Fz7f231V0ntLmf40GY/lZaltmb5G?=
 =?us-ascii?Q?4upUT7nvO3/C68zqXSBTdVGCZin5svkenCVbHK0pqRRALwbCCVxnlVH98sUz?=
 =?us-ascii?Q?ucbuik0+DQVGJ/JkDkxflzKa9kmuGCvT6kN1p/mgGFmXZa+crycKY81P1IWu?=
 =?us-ascii?Q?5di9Q9r7jNq4zs7h8XWlfoiy2G2JZl4TXCHyNO9NwpBE1Z8Up9h7LYvDU9Rd?=
 =?us-ascii?Q?BfocXMo3xBJtwrQzZk/1ffHr29NpEz+StRH8FwOVstq9y481r4DtveH1zRSG?=
 =?us-ascii?Q?d4Rfcftw4MDpdBR9KoL3ylBalosLOnWq7vjo9AUyoNeHQnJl2gtHL75XrxP9?=
 =?us-ascii?Q?1M6Cf9PJsG1h7hFlpBg7lyOgfphzy0Y/ukVjpShVdHx00JesKzN4IWCAomhx?=
 =?us-ascii?Q?CPSJs4Y911mOHBzPrPlPPX8IYDZj0aZ0gerlzq9JnoZguhWP2s5YV3/SYEw7?=
 =?us-ascii?Q?Dxi13aPQK/dyehfcMV5Ih2V1B3lrVBWggmAjrup7Kk1lK0ioiQ3SfOPOupDM?=
 =?us-ascii?Q?sJzSru0zIaWACyP0UVfKx7epXF76brkdq17Y7aOKrkvmQDtTAt/wJo2smDxC?=
 =?us-ascii?Q?ZpLJ2FtAfc4XoHq1amIMTl4zsWTZzlJd5uM7dCapDZAn9XofJa0tMsYPnXc+?=
 =?us-ascii?Q?o8ceMqWJ5ejDgDXZ5OOuw8MQb9ym1r09YNIqViUoTJIrStTe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5931cbf8-0594-4556-2f4d-08deb14d5510
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:23.2986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQDLXbUJYu6eTUOD8sDAm7vTfA91VUDu7lnGamjSjngud2hLtarLeuo6s557Xkhz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

Now that AMD uses iommupt, it is easy to make use of the PDE bit. If
the gather has no free list then no page directory entries were
changed.

Pass GN/PDE through the invalidation call chain in a u32 flags field
that is OR'd into data[2] and set it properly from the gather.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 78 +++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 92410b9cf544a9..1a6d9cae7b23b9 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last);
+				  u64 address, u64 last, u32 flags);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 				     ioasid_t pasid, u64 start, u64 last);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 38cfeba8313b43..c546fb6dd42eda 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1300,8 +1300,9 @@ static inline u64 build_inv_address(u64 address, u64 last)
 	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
-static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
-				  u16 domid, ioasid_t pasid, bool gn)
+static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start,
+				  u64 last, u16 domid, ioasid_t pasid,
+				  u32 flags)
 {
 	u64 inv_address = build_inv_address(start, last);
 
@@ -1310,19 +1311,17 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
 	cmd->data[1] |= domid;
 	cmd->data[2]  = lower_32_bits(inv_address);
 	cmd->data[3]  = upper_32_bits(inv_address);
-	/* PDE bit - we want to flush everything, not only the PTEs */
-	cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
-	if (gn) {
+	cmd->data[2] |= flags;
+	if (flags & CMD_INV_IOMMU_PAGES_GN_MASK)
 		cmd->data[0] |= pasid;
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
-	}
 	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
 }
 
 static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
-				  u64 start, u64 last, ioasid_t pasid, bool gn)
+				  u64 address, u64 last,
+				  ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(start, last);
+	u64 inv_address = build_inv_address(address, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1521,7 +1520,8 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
 		build_inv_iommu_pages(&cmd, 0, U64_MAX,
-				      dom_id, IOMMU_NO_PASID, false);
+				      dom_id, IOMMU_NO_PASID,
+				      CMD_INV_IOMMU_PAGES_PDE_MASK);
 		iommu_queue_command(iommu, &cmd);
 	}
 
@@ -1533,14 +1533,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
 	struct iommu_cmd cmd;
 
 	build_inv_iommu_pages(&cmd, 0, U64_MAX,
-			      dom_id, IOMMU_NO_PASID, false);
+			      dom_id, IOMMU_NO_PASID,
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	iommu_completion_wait(iommu);
 }
 
 static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
-					 u64 start, u64 last)
+					 u64 start, u64 last, u32 flags)
 {
 	int ret = 0;
 	struct amd_iommu_viommu *aviommu;
@@ -1558,7 +1559,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
 			build_inv_iommu_pages(&cmd, start, last, gdom_info->hdom_id,
-					      IOMMU_NO_PASID, false);
+					      IOMMU_NO_PASID, flags);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
 		xa_unlock(&aviommu->gdomid_array);
@@ -1613,14 +1614,14 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
 /*
  * Command send function for flushing on-device TLB
  */
-static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 start,
+static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 address,
 			      u64 last, ioasid_t pasid, bool gn)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct iommu_cmd cmd;
 	int qdep = dev_data->ats_qdep;
 
-	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, start,
+	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address,
 			      last, pasid, gn);
 
 	return iommu_queue_command(iommu, &cmd);
@@ -1672,8 +1673,8 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 	return ret;
 }
 
-static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
-				 u64 last)
+static int domain_flush_pages_v2(struct protection_domain *pdom,
+				 u64 start, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
@@ -1684,8 +1685,9 @@ static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, start, last,
-				      domid, IOMMU_NO_PASID, true);
+		build_inv_iommu_pages(&cmd, start, last, domid,
+				      IOMMU_NO_PASID,
+				      flags | CMD_INV_IOMMU_PAGES_GN_MASK);
 
 		ret |= iommu_queue_command(iommu, &cmd);
 	}
@@ -1693,8 +1695,8 @@ static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
 	return ret;
 }
 
-static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
-				 u64 last)
+static int domain_flush_pages_v1(struct protection_domain *pdom,
+				 u64 start, u64 last, u32 flags)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1704,7 +1706,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
 	lockdep_assert_held(&pdom->lock);
 
 	build_inv_iommu_pages(&cmd, start, last,
-			      pdom->id, IOMMU_NO_PASID, false);
+			      pdom->id, IOMMU_NO_PASID, flags);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
 		/*
@@ -1723,7 +1725,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last, flags);
 
 	return ret;
 }
@@ -1732,8 +1734,8 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
  * TLB invalidation function which is called from the mapping functions.
  * It flushes range of PTEs of the domain.
  */
-static void __domain_flush_pages(struct protection_domain *domain, u64 start,
-				 u64 last)
+static void __domain_flush_pages(struct protection_domain *domain,
+				 u64 address, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	int ret = 0;
@@ -1744,9 +1746,9 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, start, last);
+		ret = domain_flush_pages_v2(domain, address, last, flags);
 	} else {
-		ret = domain_flush_pages_v1(domain, start, last);
+		ret = domain_flush_pages_v1(domain, address, last, flags);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1754,20 +1756,20 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
 		if (!dev_data->ats_enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data, start, last, pasid, gn);
+		ret |= device_flush_iotlb(dev_data, address, last, pasid, gn);
 	}
 
 	WARN_ON(ret);
 }
 
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last)
+				  u64 address, u64 last, u32 flags)
 {
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache) ||
 	    unlikely(address == 0 && last == U64_MAX)) {
-		__domain_flush_pages(domain, address, last);
+		__domain_flush_pages(domain, address, last, flags);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1793,7 +1795,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
 
 		flush_last = address + (1ULL << sz_lg2) - 1;
-		__domain_flush_pages(domain, address, flush_last);
+		__domain_flush_pages(domain, address, flush_last, flags);
 		if (check_add_overflow(flush_last, 1, &address))
 			break;
 	}
@@ -1805,7 +1807,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 {
-	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
+	amd_iommu_domain_flush_pages(domain, 0, U64_MAX,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
@@ -1815,7 +1818,9 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 
 	build_inv_iommu_pages(&cmd, start, last,
-			      dev_data->gcr3_info.domid, pasid, true);
+			      dev_data->gcr3_info.domid, pasid,
+			      CMD_INV_IOMMU_PAGES_GN_MASK |
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	if (dev_data->ats_enabled)
@@ -2605,7 +2610,8 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 		return 0;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
+	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&domain->lock, flags);
 	return 0;
 }
@@ -2627,7 +2633,9 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
 	unsigned long flags;
 
 	spin_lock_irqsave(&dom->lock, flags);
-	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
+	amd_iommu_domain_flush_pages(dom, gather->start, gather->end,
+				     iommu_pages_list_empty(&gather->freelist) ?
+				     0 : CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&dom->lock, flags);
 	iommu_put_pages_list(&gather->freelist);
 }
-- 
2.43.0


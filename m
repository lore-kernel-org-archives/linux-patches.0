Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18665489FA6;
	Mon, 21 Sep 2026 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034951; cv=fail; b=Nrq+29Lo750jBvuXoKJE/SaNRAnaDCmhQnl5Tvhe42B1th8n+we91Q8KG+qH3Nifjom9Eb7DG5BUguYhULKk80k1pi0dV5mfy8nBeh7152hPff/TGzKcmgmgkKzdzSzq8ViG60Qs24PQAnK7XZ8Xb6L+5LVv6loC9Z0pRD7rfm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034951; c=relaxed/simple;
	bh=n6yJ1S9RmZtzJPyiCWIRuEbyq3dyambyWqlhNK5yBKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IEFw1QQ4zsf7TrsrVulyWQYE3Z6FhOErBxdvFuaSYsGq3zSCPxfNAqZIqwhWxPZvLfi6PFSd3FJZ5hmc2iHeN00A4FmJvVgb09jEx0WZJO2rujEymUoJX9Hg6ivrUG7WNBKyRARZ2uMO2euUTVPN8D+axYy7sAtZf0UQuEyWdjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W8KH05j5; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W8KH05j5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQXmL6ttOAuH7SVC28C+cL/A/DifPu5PuuxD85ubhOJmlvmkkwBQLj5YGTeObLQCJXBiobDaqlClrG5j07+I6Jc2aT6vz56DPw4PNZ9jYaXUby1r6Ly4HU2t/vSleytfH6rVKtcN3BZ1oRKdEwL7i7g3mXEzINCtnC037Tgnpq2yDi9GQdJ/+Nef4D8arosQUByyHwQ74A3dgR2qKKc3Dv6cTnJbR2/hQHA8V3k2EKpb0eqUFgYw+Adg4Wp3WENNAlKIhfDrPuOPkiQgHQyyQxwgaTYeURABy+SgWflcJgeX/ujr7a4DoSr3tsmFRgx7DdC4Lvm2jTd4P3tTEm83og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6+J1Vq3h0bS2yoIlW0KKcG73s4SMqoAE9/Q1kovmSE=;
 b=G4pHhNHh60fCqb4Czv6m9Oq8sIp2+lQD25maeT1xsmUd2C0rsrX9TVDE9EmCV2bGktR9IJFS8cJRmW49gDz6tcdtKIukWpt5dmiwH2BPIU0IQGluapnGGFR/xd3Fh6YBrgANdEPHEq1YSPcK2I+5FYG3XNStfEEdhRCngPYJRTk4AMsRQ5Q1ANzSvMmizzRKUElG/RbCpEzSuuGOOMpd3Ax7ajK38aSAlNgcyKhusPVAtxP4auQpaF2M9wtwQwMAOBllGSDv7E6Ve9GCfpRaxizswgHGkiPO8ogs8nSQcybzRJfpcz43Rz7Cf0DaGKqFhr/Hb2zHLFBPuIREms/Gng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6+J1Vq3h0bS2yoIlW0KKcG73s4SMqoAE9/Q1kovmSE=;
 b=W8KH05j5a7kp8V4nV/dpvXCyYY2KfeHQ2GBoy1EwGl8hk9kb0eNRJCxeEsrXJPIO8s22bZ5rb/ZgsjbrxtKdYlnxQSvSbPJuF3JxIcp2xMcwtne0Pqa8HAxdNY3SZwzxKCJVkUOrYBxQIN7I54jfcMDQ+IHjJNvONPK7LRCABwYHpgXupjkFvov90NhMKb7IfeJA4xn3FoIquNP0rf1T4N2kua2d+YxCzmX4Tyy2cn5rSd8fszHm2zTqNAgwJzLL9oEGawEES37UU/Zp7uoF9xqoGe3ldIu/DIw7GmGq4KCaLeyUAVJ3kSh9acaJ8OwEJWdCCT0AP4YB6UWKJZKKSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:25 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:25 +0000
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
Subject: [PATCH v7 4/9] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Mon, 21 Sep 2026 20:55:12 -0300
Message-ID: <4-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:130::8) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 5abc0b12-7b36-4fe5-a7c9-08df183bcbac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	Y98xfNRcOPsxskin7Ah6tnd/DhrgLbd4+QvgDtBdBnWvN8LFXy0iv7xZQLeULsqxEKZQGg5XcLFntngSGt5yTUZb0EBmPtgFZuQFcAJocDHpQfBIebjmH8nTr2m6PpQp+wB/EgB/dlOhD3FmrcOxDmaz7gUzcdrU7ZhkZitP/emMrOp4Ld0gkcaKck97wbXAnQMFYJSf7uOTOJK8klCpMvQjHtlgB6AEzPA/VwHVJ37GgjWef3VXT6emM2KvPWSDZ98mhTGVgEwURBIjWDOLpHIGOydkWGnI0KYCPIXW5Sog7dvsUB21JthN+IVvGqzE6PGqv3K44+oHEtX7PmUM23rZRjYW3KdFfgatMxNXDGFoPgpGtryo1z0+ht6zHERDXoUIoCXxG5ZsacuVfSAIK50Q20VO13R7OZLs0hxr7Vmesd44hj0u9rMk/YQHGZftDCPFE6oOJTWmzue1++k21DeEopalRYvCrMtS2PnK0oxTMj6gESHr0+S4UOpQrsEmEMfpAC5E+/GcP2tXcnGuJr3m7FjIhzuRo0dndyrRWWJ27D/BSLNGYn0XSgkEM1mZLQcymerQbBO/5QO57GYTMBVWBsCn7UMHKUqua+eYYisd6t/nB8IvZ2WP0ZYEHMw1NQGK8pkcoQqA7ptjEEUAfV0xoq7Vr1URk9bhoVvmXAx08BBtDPTpqC7RVayrLgpPAJe7wH5r0IYtHsAsJZ5zOQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ANC9D6+lqRi8sKylf53wP2tjdPeVRWpxzhKj3Lcq2R3DkcAnsSQ6tzHhmCjr?=
 =?us-ascii?Q?MaWc8kIGV0LDhDcEpL0pUWEywEZ3clxXaHHpV1gVmD070YUHyH7SyPK6dWnZ?=
 =?us-ascii?Q?tDzW6xl7nLOc4ZDX+ILsWRaMV9s6Dz85hmp7CUcdmHxRIKNrv1gQ484ashou?=
 =?us-ascii?Q?hdhAsEKQsihxx4IitJk4RyEsJVOZvWljfIVLi0NK3C51FyHKmau0cqOrrxXI?=
 =?us-ascii?Q?eudWtQYJ+/WgAYrIu+OqZM41ZY8VT/dZupPvwE0Gtx4vwUfG7zhk6jppLzE6?=
 =?us-ascii?Q?DVLAHqPYA+Fx5racPK4Lz86HSdXYecUYbLvP0UHHsdiiioJ4INlEqwFyPEtH?=
 =?us-ascii?Q?PCKqfCKvDo8OtiUjC3DrAhpn+5r/JbABiEscXktlFcKywylmX3fjJJ0rQieo?=
 =?us-ascii?Q?FALpZjoAxZuTd04GFXEMmQDpr1xIS9h1QkWOt7Y7TEJC7/F+iihhRqBummW8?=
 =?us-ascii?Q?lF3gdQwDcivAxN5UvCm8JbfMI6ECICxpq+dZlhxfcqjxtiKSNenJSzS6cyOK?=
 =?us-ascii?Q?2eseR5m3Bi5WbDvl7+5zonGhSTTcWTv8QQtM2sVI9w711neZkty9auHDvtnI?=
 =?us-ascii?Q?PsZqAjDKvduv+YFNkMlIAhzJaGe+uwP1/n5agxmPhiMCKjYLTCCMvWimAMsu?=
 =?us-ascii?Q?W7N0PayGcHbYPCG2OI6WRDJOxTlIKWbYcaVRiupgDbUa6qLbBU1es29aiBtu?=
 =?us-ascii?Q?yIZLhM82VuWcpranhlABLYwil0Fvu8EurRHJxFhajQ+G5DoDiamzFXaHBD+u?=
 =?us-ascii?Q?9ukcP8Cx7kBl2pg39w/jzAhpyS5jjRFnaMhcJ4ItOw+ybS5xa8lX65hqtjDp?=
 =?us-ascii?Q?H7MzoaXJtuae1sFjOLyP8y3jxBoCfVXk2O5OUh56EqikdQXwduPTLCQUoWOy?=
 =?us-ascii?Q?qd/t1RNj7erkf1qpw3bX6abumYNhdtJkBT2AINfQdcnXUZuS+mARPjI64MEf?=
 =?us-ascii?Q?mvj+b36mTFySZ5/80AokXptUEVADPsfq1FLFSs6sM/MYfshTMGsS/dHyjOQC?=
 =?us-ascii?Q?ZOUHMF1qr/+sUTKfuR5c5az6jGoVFPV3SetVinrqrvDnk3NTl24HInV1JEsj?=
 =?us-ascii?Q?bEecqqkX95M2KmcBWr14TeGgjfYB4J+G5rxYozHLOeG6Jz0ha9Iov682u1cP?=
 =?us-ascii?Q?9ObYjctcB5Xyi+ren7HOEpbmd9noQfTWSidpS35xyW+OH7aTqbaYMyZf2D88?=
 =?us-ascii?Q?fHYxsdMVchpg0uRe3teoq20jjsZX1wZKzw2bawn0aw2mKBi4wKGyALk4JEkZ?=
 =?us-ascii?Q?iLmZVB+IMJh5r7ZH1HFtHsvmjfToDmL4gWXap97JDdn+/M091ut9Kjz0gnm+?=
 =?us-ascii?Q?4s4PnVsrG6q0ZQ8gZqWwJtEhWpfJNKcpBReQHLEHwVOYXHQPy4nmEiXhkPJo?=
 =?us-ascii?Q?n0j2DlGtMqjAqyI02Qxga5ivHtD03DkmgQMhwB1YDmRxLSX2dUg/a0PqpDnD?=
 =?us-ascii?Q?DLEkbxeFDm71qgyVqV2HcCmnyX7OQC96EpCXgeqQAmbMhE5tCqzC7OfoGQH6?=
 =?us-ascii?Q?kmnuDXem1jKkngs09R13w8fKxnpLe4BQY8/fLGVzOOdOOlgdyngT6UCj4j9I?=
 =?us-ascii?Q?sms940YN4433uiRVgRxTIU0lTtKiYm4xbnQhY7mEXR9euklnf59yC4cPdEKh?=
 =?us-ascii?Q?1eKYa3I/58Z86M4OaYrDqKfTGZHhybWn+ztJmEt/9ksTfapiaz6JSpwAzBW/?=
 =?us-ascii?Q?JHrbZWOKeLmt0j4fAeZYLuQY8FIpvyDHXV8zge9tzsbPUcGw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abc0b12-7b36-4fe5-a7c9-08df183bcbac
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:21.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhBRORJBs2c5hJgy+IIeq9kHSNvlhoy9XLuM7XpoJc4XlVacya077KZvKxI729lG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller range
invalidations.

SMMUv3 on the other hand will try to do up to 512 single invalidations,
otherwise falls back to full invalidation, or it will try to issue an
string of range invalidations for every 5 bits of IOVA range to perfectly
cover it.

While the range-invalidation optimization is pretty good we can still do
better and reduce it to only 2 invalidations at maximum using the idea
Robin came up with to overlap two range invalidations in the middle. This
preserves the exact coverage of the current range invalidation and still
caps the number of range invalidations at 2.

This works because the range invalidation can start at any IOVA, so we can
place a range invalidation forwards from the start and backwards from the
end, overlapping in the middle if the scale isn't precise enough.

In the cases where this produces 2 range invalidations it continues to
produce range invalidations that don't overlap, but the exact split point
is different than the original algorithm due to the new calculation
method. In cases where the original algorithm would produce 3 or more
range invalidations this will produce 2 range invalidations with an
overlap.

The SVA under invalidation errata work around is maintained by "rounding
up" to generate a single range invalidation that over-covers the entire
range.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One or two range invalidation operations
 - At most 512 single invalidation ops

arm_smmu_domain_inv() is modified to always pass in the tgsz because the
new logic relies on it being valid.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 372 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  16 +-
 2 files changed, 238 insertions(+), 150 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index afc0f68728609d..5daebe06556c44 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2460,167 +2460,232 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 H.a Section 4.4.1. Address
+ * bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = arm_smmu_pt_level_to_lg2sz(tg, 3 - ttl);
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+struct arm_smmu_range_inv {
+	u64 start_tg;
+	/* Normal integer, not encoded. 0 means 0.*/
+	u64 num;
+	unsigned int scale;
+};
+
+static unsigned int arm_smmu_range_inv_calc_scale(u64 num_tg)
+{
+	return fls64((num_tg - 1) / (CMDQ_TLBI_RANGE_NUM_MAX + 1));
+}
+
+static u64 arm_smmu_range_inv_calc_num(u64 num_tg, unsigned int scale)
+{
+	return DIV_ROUND_UP_ULL(num_tg, 1ULL << scale);
+}
+
+/*
+ * Initialize the smallest range invalidation covering num_tg and ending at
+ * last_tg.
+ */
+static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
+							     u64 num_tg)
+{
+	struct arm_smmu_range_inv range_inv = {};
+
+	if (!num_tg)
+		return range_inv;
+
+	range_inv.scale = arm_smmu_range_inv_calc_scale(num_tg);
+	range_inv.num = arm_smmu_range_inv_calc_num(num_tg, range_inv.scale);
+	range_inv.start_tg = last_tg - ((range_inv.num << range_inv.scale) - 1);
+	return range_inv;
+}
+
+static void arm_smmu_cmdq_batch_add_range_inv(
+	struct arm_smmu_device *smmu, struct arm_smmu_cmdq_batch *cmds,
+	struct arm_smmu_cmd *ref_cmd, bool leaf_only,
+	const struct arm_smmu_range_inv *range_inv, u8 ttl, u8 tg_enc)
+{
+	struct arm_smmu_cmd cmd;
+	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
+	u64 iova = range_inv->start_tg << tgsz_lg2;
+	unsigned int num = range_inv->num - 1;
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+		ttl = 0;
+
+	/*
+	 * SMMUv3 H.a Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is Reserved
+	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
+	 * to target only the exact leaf entry.
+	 *
+	 * For a single tg invalidation a 0 TTL can come from places like the
+	 * SVA path that don't have enough information to get a TTL, or as a
+	 * side of effect of the splitting.
+	 *
+	 * A single-TG invalidation cannot reach this point if it is part of a
+	 * CONT group, so it is safe to transform it into a single invalidation.
+	 * The ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata does not apply.
+	 */
+	if (!num && !range_inv->scale && !ttl)
+		tg_enc = 0;
+
+	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		      FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
+	cmd.data[1] = ref_cmd->data[1] |
+		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
+		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+}
+
+/*
+ * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
+ * if successful, false if the range is too large to fit into range invalidation
+ * commands.
+ *
+ * Normally the first range invalidation is the largest representable span which
+ * does not exceed the requested range. If necessary, the second range
+ * invalidation is the smallest representable range covering the remainder and
+ * is anchored at the end. Any excess coverage from the second range
+ * invalidation overlaps the first instead of exceeding the requested range.
+ *
+ * If a SVA is being invalidated and the SMMU has the
+ * ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata this produces only a single range
+ * invalidation and overinvalidates to ensure any potential CONT is covered with
+ * a single range invalidation.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	u8 tg = tlbi->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	u8 tgsz_lg2 = tlbi->tgsz_lg2;
+	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
+							tgsz_lg2 };
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 num_tg = last_tg - first.start_tg + 1;
+	u8 tg_enc = (tgsz_lg2 - 10) / 2;
+	struct arm_smmu_range_inv trail;
+	u8 ttl = 0;
 
-	if (WARN_ON_ONCE(!tlbi->size))
-		return;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = tlbi->size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (tlbi->leaf_only)
-			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			/* Keep the pre-DS 5-bit truncation when scale > 31 */
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
-}
-
-/*
- * Generate a range invalidation for ARM_SMMU_OPT_FULL_CONT_RANGE_INV by
- * ensuring the entire SVA requested range is covered with a single range
- * invalidation command. The scale is adjusted so that the range invalidation
- * may extend past the end of the requested range. This ensures that any CONT
- * the MM is invalidating is covered by a single range invalidation. TTL and
- * LEAF are always 0 because this is only used by SVA.
- */
-static bool arm_smmu_cmdq_batch_add_range_inv(struct arm_smmu_device *smmu,
-					      struct arm_smmu_cmdq_batch *cmds,
-					      struct arm_smmu_cmd *cmd,
-					      unsigned long iova, size_t size,
-					      u8 tgsz_lg2)
-{
-	u64 cur_tg = iova >> tgsz_lg2;
-	u64 num_tg = ((iova + size - 1) >> tgsz_lg2) - cur_tg + 1;
-	unsigned int scale = fls64((num_tg - 1) / 32);
-
-	if (scale > 31)
-		return false;
-
-	cmd->data[0] |=
-		FIELD_PREP(CMDQ_TLBI_0_NUM,
-			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
-		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_TG, (tgsz_lg2 - 10) / 2) |
-		       (cur_tg << tgsz_lg2);
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-	return true;
-}
-
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
-				      struct arm_smmu_tlbi *tlbi)
-{
-	size_t max_tlbi_ops;
-
-	/* 0 size means invalidate all */
-	if (!tlbi->size || tlbi->size == SIZE_MAX)
-		return true;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+	if (!tlbi->size)
 		return false;
 
 	/*
-	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
-	 * this is used as a threshold to replace "size_opcode" commands with a
-	 * single "nsize_opcode" command, when SMMU doesn't implement the range
-	 * invalidation feature, where there can be too many per-granule TLBIs,
-	 * resulting in a soft lockup.
+	 * Determine what level the granule is at. For non-leaf, both io-pgtable
+	 * and SVA pass a nominal last-level granule because they don't know
+	 * what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
+
+	/*
+	 * The spec defines the invalidated range as:
+	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
+	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules. Find the smallest
+	 * SCALE at which a single command could cover num_tg.
+	 *
+	 * Unlike other IOMMUs the spec has no alignment requirement on the
+	 * address beyond alignment to tg (so long as TTL=0).
+	 */
+	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
+	if (first.scale > 31) {
+		/* Range too large for a single command do full invalidation */
+		return false;
+	}
+
+	if (tlbi->has_cont &&
+	    (smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
+		/*
+		 * Produce a single invalidation by rounding up and disabling
+		 * the trailer.
+		 */
+		first.num = arm_smmu_range_inv_calc_num(num_tg, first.scale);
+		trail.num = 0;
+	} else {
+		/*
+		 * Produce two invalidations by rounding down and adding a
+		 * second trailing range invalidation anchored at the end.
+		 */
+		first.num = num_tg >> first.scale;
+		trail = arm_smmu_range_inv_init_end(
+			last_tg, num_tg - ((u64)first.num << first.scale));
+	}
+	arm_smmu_cmdq_batch_add_range_inv(smmu, cmds, cmd, tlbi->leaf_only,
+					  &first, ttl, tg_enc);
+
+	if (trail.num)
+		arm_smmu_cmdq_batch_add_range_inv(
+			smmu, cmds, cmd, tlbi->leaf_only, &trail, ttl, tg_enc);
+	return true;
 }
 
-/* Used by non INV_TYPE_ATS* invalidations */
-static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+/*
+ * One TLBI command per IOTLB entry, assuming the entries are all at least
+ * iopte_granule sized. Returns false if too many commands would be needed which
+ * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ */
+static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
+					   struct arm_smmu_cmdq_batch *cmds,
+					   struct arm_smmu_cmd *cmd,
+					   struct arm_smmu_tlbi *tlbi)
+{
+	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long i;
+
+	if (!num_ops || num_ops > 512)
+		return false;
+
+	for (i = 0; i < num_ops; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+		iova += tlbi->iopte_size;
+	}
+	return true;
+}
+
+static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
+				 struct arm_smmu_cmdq_batch *cmds,
+				 struct arm_smmu_cmd *cmd)
+{
+	u64p_replace_bits(&cmd->data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+}
+
+/*
+ * Used by non INV_TYPE_ATS* invalidations. Returns true if it fell back to
+ * full invalidation using nsize_opcode.
+ */
+static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	struct arm_smmu_cmd nsize_cmd;
-
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
-		goto full_inv;
-
-	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
-	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
-		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
-						       tlbi->iova, tlbi->size,
-						       tlbi->tgsz_lg2))
-			goto full_inv;
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
-	return;
-
-full_inv:
-	nsize_cmd = *cmd;
-	u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode, CMDQ_0_OP);
-	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2642,6 +2707,7 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
+	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
@@ -2673,13 +2739,21 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
-			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
-						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode, 0,
+						     cur->id);
+			if (arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi))
+				used_s12_vmall = cur + 1;
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list for the same SMMU. There may
+			 * be several pairings so check this is paired with the
+			 * one that did the full invalidation.
+			 */
+			if (used_s12_vmall == cur)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5c1c3ccb5fff0b..2717bf2f3f3607 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -804,6 +804,19 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+/* Generic page-table level 0 is the leaf-only level. */
+static inline unsigned int arm_smmu_pt_level_to_lg2sz(unsigned int tgsz_lg2,
+						      unsigned int level)
+{
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) * level;
+}
+
+static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
+						      unsigned int lg2sz)
+{
+	return (lg2sz - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+
 struct arm_smmu_tlbi {
 	unsigned long iova;
 	size_t size;
@@ -1176,7 +1189,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0


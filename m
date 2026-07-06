Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B7E433BAA;
	Mon,  6 Jul 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355236; cv=fail; b=rMoHJ8Kqj9BqlUYku2ax274shlQNpVc6omk1Slve02eovL520ysqcDD4WFB6kni9uOygVbCPLBpfW9nVK18PXzuEOMnamEbNN+JsDzKVTwwvpp75SjRAOO5BcQzHVQIBFuAzxn6z4w+OaTEikGy60ZmEFSocAtCXssTb3lRBOts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355236; c=relaxed/simple;
	bh=T6MohfcTVZykl9bROnRIR/xOOI8VzZhkGP1A33xeRak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QSanXse/9F862jXYIY4ozoEmsAk9i1aBFIwE8MIrsdBh3qtg6EArz6uKteT8NdPDLpXnB6VloMRWCznJKu4pqGlt9tS5REHMzztviJpl8L15nsBHdec9HN+GBosmR2VhMBAqeuPbpJz/GphX2AohcRsIsrHmWtjyck5hvVJQnbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o7R0usXX; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o7R0usXX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecvxBz7iOv3CKBmcmAbPwwcYRudP5a6Ip1sNJLfAg+NSJoHPfPhgJO5Ic47KZ0C9nyUdbB/kZHNpop006iwGuO8+jS2DyD+Xdg1E4UnUbXBvMr9NdjR5vDTkmOUbZpkmC94jdfNF6mUr+5prc2IB6ljdnoNwPahLLRwPJzk8pt7Uqc9bGwYrdAEnbzHAM4O5YVE6KR9i9qRUJO8i8KJVSDLUwjCWl+vCxkPE7Ul3mKbtwVyX7rdZtW0ILfBFDR7A47Y+5KSZoGF7edUOfm3LCtvvyg0trEDz7j+RWytt1RMVueuxTXJQ3gjrNBD5FvDMAcRIJONVH6MMeeM7TbHPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPP9g8yGgLEu4QkVw0cI15RCf1J1D4PP80tq9WVu6GI=;
 b=X3+S+S48xrcuewB0Kdoo9njfj8OHOc2NJ2U2H17fIXwOBLscwPa3qY85LBVb+v79aUFbo+MGnyZLgKZCQkyumZTRorZJFmI1v26l8gTQJV85DUtzG0uByYKIZKB0f+wB2JKYnWMUI4XhsPtjXKxyH1X25E+xPRwkRAy/X32kJn8cfdnCDqInILlqaQLNIfl+v8QgQwRVhXgfLSxLbC88JeyS+Tl/9pn2J2YRyQFj4GO4YcqKbCl8BuINK5rFwLseo0/VRFCI2RiUVWyqLizN+ml8v2L1p04bpMxW23PXA34VT6Cu6E7IBwnGqJ9DY8fLtlaQDaCA8x1rxPg70nQQ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPP9g8yGgLEu4QkVw0cI15RCf1J1D4PP80tq9WVu6GI=;
 b=o7R0usXXjkpflGPXatVjy+nAZwNDlX65nxo+Uqj5DiIeGyvWli0NX1I4j6aoIb5F92xFOCG81dMwReZcpY+J0HDBj8Atr3mvXBz24/NsVE2fvgxy60TzLTh/skaEh33qDCu9q3/yEa39XC3lCsTBejBUSWURDOW7bueFbIfQ9xX/XgcDnYAaAgwQFGKKs4PCRCCIKLqFR/Umy28153ZIVyT/WnBe4uWV2uN3MKoBu3em9NH2+UWc9aJQrzRGNIJjBtqfSq1/MKDZGIYKwvvfQvk5mcnbp9SXBcVhs/5EwgmC+8iq/zqIUxXrKVGzBSwjymJBVyyjEEodL2PgboQOkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:51 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Mon,  6 Jul 2026 13:26:40 -0300
Message-ID: <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:408:f5::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: ac4de869-5398-401e-3aa0-08dedb7b6184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	UaEln4wJjycM5j2X87oMXBDcs/Z0lpRidcOq9c7aO5ZISoHNP/g/F+iwySufGICK4EID8s8g1mZrsbzZKlthi5nIcBJVu8HaAY9ufdKx8sUJVxCHu+w94Us4Xj78EuGq946J6Lhe4ue2JP5OPk0SBNQAov/wlG56T/Z4kDcfIyAshmYtyvmQ3FI2c0tJpUIjFiiyeyz0BRjv20YPdVGXFSOhDGLVuaRtWrRPMAmska5SrwAdbXfdvztHfIisqSFKsasI6QmWmOq+JNdTjR/38PLvo54aKH5dTivfucVbJTybccQxal26/1V5NIXKP5r+6nLkQ4lwrtTIlDD+s+ddVeJOUJrDd5i8mYjX4397+LOH8ethczQ8LpYA3PTDbUgLTEq0m6rS/gj153PCzoanCjWFdG/SCYeMS+TrxbNOQolFS/jbJ6mmbm58r9ExG+XPc/cjqlX4GkAQFYjV23B62ybbh0/rnjuGd2UzqSM08UolOyBd5MuDTCoUnDck/p3ywJ6QKEhYPWirltUC8SlBBy/Kr6znNARtKgzzbo4RorFb/+8HJWl8VMZuo7NDRr89qsOlEwX/IMxg+OeuCiSFRElPy0Csxr7Ky+g27AMHpAt3hg9DH8i0VUTgWKeXqzayMd1AxZEW60wQigPU29gGhsDkiKpEkDVx3svKyRYGMK0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?szPm+iT2fjaO8jfPwFzXzSH4U0M8sPFOWszGzbj3ZB5QN5jsGG4EPmNeaLAn?=
 =?us-ascii?Q?njnulKJzJz+EpL1kyPRBBo5pDQQnrKrTopfq0/we/Wb/kBdTMGiHOZO+IOlJ?=
 =?us-ascii?Q?ZoT8zV1CCsZjaajU3EVPKk1955YejhZkuc0mjrhywZbDLCWkekLwV96a6+nF?=
 =?us-ascii?Q?Hblo2QWCE0qJmlEzr5TYb9IPH3SRcboDAyqEx8KiwpVH5ImW6j8Ikkpe43Jk?=
 =?us-ascii?Q?xjCaR6Q46mQ+gpnyLUHIJYapIpj11oVidGG+7hYpjX1ToSwVdXmLJK63qu/D?=
 =?us-ascii?Q?2q2w7dBMkkc9+F6PYqFeDAKPSnhg4V7puTfRzaBU5Ius1vfAN9pykMxLEj82?=
 =?us-ascii?Q?hM40897jItnoFg0p3MY5J6Y7dm858q5d0feRpoE+JAjOWgHCrVVbMNdbXk0i?=
 =?us-ascii?Q?7oeSL/rzzd8t3/V9ICCagdcLi9Kofrj9UsYLsrzcIylaC4rI9p1z/uwYi2Lg?=
 =?us-ascii?Q?BqEU7KNoUzmUpo3ehYHDHJoA51veB5u90tEjcmWvAd/kKsD7B46iyNpGAXPI?=
 =?us-ascii?Q?7KR3pLSG2h9DZwBgh6GwaOCGjDgSvVVBb05vSS9ERLcFiPXW8x3dHP96smaG?=
 =?us-ascii?Q?r1sLRUNVps+wifcV0NRUrAg6Ban6BVQxZauWK9yRzsB6j8GRktuwDq1GG1m6?=
 =?us-ascii?Q?6059BAO0x7GMKc2uuBAuudvbSupbbd8EtVwgRgN1Nc/WcUZijGkEoNRgbQ6R?=
 =?us-ascii?Q?yFx36RoP4pjtAL7nYAmTAwNo7hYCcGDh2+1Lr/uoHVL6LiH5DJp7c7GC4Tib?=
 =?us-ascii?Q?W1mfWN5GXAZg74++b0jM96hAy3CTTmeL+isOE6ncAtDTdbwCBDrOlhHCXFs+?=
 =?us-ascii?Q?FviukIDyJUWf8SLLtn+pK96w+j891OeASHMdC121RTbLMxu/rfkXJc3nxgZD?=
 =?us-ascii?Q?wTcbpCCdG6z14w96w7B/OfRy7KwbxG9jmZWjRjTVHw2x4OchivayQNOHfLo/?=
 =?us-ascii?Q?2ya/4aM8Dv0xspgD0Lp4GZkvjkw2ipejtUrCgofJbEabXL3ZoW2WAU7No5ts?=
 =?us-ascii?Q?d81e/YW2B4vWWGADROG0/c4nccYaa6RAg7L2s+5Men7ijTQj966fmHbJilnp?=
 =?us-ascii?Q?6mfBp+S8vh9WrPolX7KmR+0eoHubggHNh+wWz3OErf4K5pFpIeOyQH7LsTpJ?=
 =?us-ascii?Q?ULcSIYc/1vcAB1N0giDBGHWjo7hYmnUIyUX7A5kU1y1I1aZ5svogaifrMZJC?=
 =?us-ascii?Q?vpcEkSNXfQeT6dpKRaPxv7bjJu0iD6APZsAjnGFyI0rizM7WtoOtz90QDDVs?=
 =?us-ascii?Q?yWy2PCa3PcxQnaiOjkfl1PSxypt+urzmBVbonsYJ8swCZ9zLYXMj78G3hKZd?=
 =?us-ascii?Q?JHu7nzJ6sh8haJMLAhJvRcEGom8B3JIismxV7mJufxsgsNa75ASM7SDjf3k3?=
 =?us-ascii?Q?3YPYtCSwCM5ydnnYx3TDPazrwwtxQpnegOFmrRutzU/NajuoFiX+IXNCRS68?=
 =?us-ascii?Q?6c78snjz4boZMO0VmVAwv9hqg/B60a1a341qj38NVgLASz+oo5FtkwqYGI5A?=
 =?us-ascii?Q?uTuiGdCFmPpAMwMdHlEYnVrmPIjD1WMcCkTv1f3t1S/dyDLWNgi//0rGo6TY?=
 =?us-ascii?Q?ffQnuL8bWLaKumX3C01G9b0R3hEtjXVKUhCVX5Y5zYl/WazwLNugrz+AUhLU?=
 =?us-ascii?Q?qiX7JZq+2NScTqFA5RVORLCgiCx75+OviEuraKlBHLhgX9CkyNZxKOvWfOz+?=
 =?us-ascii?Q?djFk7xu+s6WzqoUiflh/6o0sypnKVuSiyiaJx+XCYN8FBdmx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4de869-5398-401e-3aa0-08dedb7b6184
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:50.1561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13c0dxQVhu2kvltsfL8w5J7saaf22uzeBJYzqFv78SVDGXrePVuegJmnCjyDAtjG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller
range invalidations.

Only if a para-virtualizating hypervisor is detected do they switch to
using more accurate invalidation. This also triggers using
iommu_iotlb_gather_is_disjoint() (ie PT_FEAT_FLUSH_RANGE_NO_GAPS) to
remove over invalidation from the gather. A pvIOMMU has a hypervisor that
will walk the IOPTEs and resync them. Over invalidation, especially
significant over invalidation, can incur a big latency cost reloading alot
of page table. x86 IOMMUs have aligned range restrictions so there are
some pretty nasty corner cases that can trigger huge over invalidation.

Currently SMMUv3 doesn't support detecting a hypervisor, and it
unconditionally runs in a NO_GAPS mode. This makes some sense for the
single invalidation flow where there is little reason to push single
commands across a gap.

When we get to RIL hardware, this doesn't look so good. On real HW the
best option is the same as x86: issue a single RIL per gather and optimize
for latency. SMMUv3 has a significant advantage as its RIL does not have
alignment limitations so it's single-command over-invalidation is capped
at < 1/32 of the gather's size, making it much more suitable for a
pvIOMMU.

However even with RIL SMMUv3 still uses NO_GAPS and it breaks down the
gather into several exactly sized RILs to avoid any over-invalidation,
costing latency on real HW.

When the HW has RIL support follow the x86 approach in SMMUv3 and
calculate a single RIL per gather that will cover the required
invalidation.

Calculate the smallest SCALE such that NUM can cover the range to minimize
over-invalidation. Always use a RIL command if RIL is possible working
around the spec limitations to form a valid one. If RIL is not possible
then do full invalidation.

At least one invalidation errata is avoided by 'always use RIL'.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One range invalidate op
 - At most 512 single invalidation ops

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 257 ++++++++++++--------
 1 file changed, 153 insertions(+), 104 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d22012466e3965..1ad642e09eb92d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2395,124 +2395,166 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 F.b Section 4.4.1.
+ * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = (tg - 3) * (3 - ttl) + tg;
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
+					struct arm_smmu_cmdq_batch *cmds,
+					struct arm_smmu_cmd *cmd, bool leaf,
+					u64 address, unsigned int num,
+					unsigned int scale, u8 ttl, u8 tg_enc)
+{
+	cmd->data[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+			FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | address;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+}
+
+/*
+ * Issue a single range TLBI command covering [iova, iova+size). Returns true if
+ * successful, false if the range is too large for a single command.
+ *
+ * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
+ * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
+ * the invalidation range.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_granule;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	unsigned int tg = tlbi->smmu_domain->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
+	u64 cur_tg = tlbi->iova >> tg_lg2;
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tg_lg2;
+	u64 num_tg = last_tg - cur_tg + 1;
+	u8 tg_enc = (tg_lg2 - 10) / 2;
+	unsigned int scale;
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
-			ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg - 3));
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
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
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
+	 * Determine what level the granule is at. For non-leaf, both
+	 * io-pgtable and SVA pass a nominal last-level granule because they
+	 * don't know what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_granule) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_granule;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg_lg2 - 3));
+
+	/*
+	 * SMMUv3 F.b Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
+	 * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
+	 * a TTL hint to target only the exact leaf entry.
+	 */
+	if (num_tg == 1) {
+		if (!ttl)
+			ttl = 3;
+		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+					    cur_tg << tg_lg2, 0, 0, ttl,
+					    tg_enc);
+		return true;
+	}
+
+	/*
+	 * There are at most 5 possible values for NUM based on SCALE. The
+	 * highest NUM is at the lowest SCALE where:
+	 *    ceil(num_tg / 2^SCALE) <= 32
+	 *    scale >= ceil(log2(num_tg / 32))
+	 * The lowest value is 1 where 2^SCALE covers the whole range. Pick the
+	 * highest since it trivially also gives the tightest range.
+	 *
+	 * Unlike other IOMMUs the spec doesn't have any alignment requirements
+	 * on the address beyond it must be aligned to tg (so long as TTL=0)
+	 */
+	scale = fls64((num_tg - 1) / 32);
+	if (scale > 31) {
+		/*
+		 * Range too large for a single command, use full invalidation.
+		 */
+		return false;
+	}
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (tg_lg2 == 14 && ttl == 1)
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
+		ttl = 0;
+
+	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+				    cur_tg << tg_lg2,
+				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
+				    scale, ttl, tg_enc);
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
+	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
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
+		iova += tlbi->iopte_granule;
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
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
-		struct arm_smmu_cmd nsize_cmd = *cmd;
-
-		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
-				  CMDQ_0_OP);
-		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2535,6 +2577,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
+	bool used_s12_vmall = false;
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
 
@@ -2567,11 +2610,17 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			used_s12_vmall = arm_smmu_inv_to_cmdq_batch(cur, &cmds,
+								    &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list.
+			 */
+			if (used_s12_vmall)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
-- 
2.43.0


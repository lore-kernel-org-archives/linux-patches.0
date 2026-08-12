Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010069.outbound.protection.outlook.com [52.101.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF389365A13;
	Wed, 12 Aug 2026 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565383; cv=fail; b=OcVJf0zdyOJSSqbZvvCQEs/Y1T5wv3ZH183HnQNYJ6Xa+HoaVgvn08VDrFr884SPORjxXi3VsXQM4AUepojtm2vzZCGVlMcB9sIGG61fgPeqXgH6gRM4HC04cFLiahbzPaQKrQk1bdJpEET5oQXvPkJZdcuOJmcD5cT1FTqHEo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565383; c=relaxed/simple;
	bh=MAMH97E4+u0tBS6pHwNobh/s+XM2m/sZOJzb/VjxstU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=up5XQpQ7henqRxFVZ9fUv808zZGC12zioIxZ1ZWsSQGJuRYcBi7U74F1hAOU/P0NCS5QnS0aYbrPC5wzol2j53o+R5W8tsSlSj/iqo1huUf4ZvBs2gDzyeQZiJdPNKekZ2OVz7tJ8Gbq9KhMHKr6vX+SUl//cyvwPULEnHRQ+W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SWcjJSdr; arc=fail smtp.client-ip=52.101.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SWcjJSdr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMT/MaV6q52As8+3RXZfPjG4OhqOddMTEkYNSTnfPblk28QRW/NWKwZwM7/Acea9oGDRcNDmC330t8QCDQxyUpY4XgQhiOtWqQnPUe8fJku/tvPRRM5HJZer4PA/f0E7T2hob1QrLXOEi7A4BcknCe1MxLBU2Rfxaf39USYhTtlwXZcrM6DF4ByGJ7VuMtuT29w59GmfCfuymjb6sm1SfAme0DYMyQ1zCG9SVRe97NddoFTGZ/TalhVK0CwuKLbwCT11lfpEnpr4E30Yzy1AjugzeL1HpwxA3ZmnwL9oNJzG32K1NurD0XpYsV6pzcqoi+msilRRLTo01RgD4AgTJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkfVBTIHNNJtZ/E+ruDz66rg6fKL5H8FlxoSqXWZnxg=;
 b=Vzne9UPpJMvI2CIGQ2GOWenUZNQUf/U1wWgJTahRAyceS9E14ZdETaEcOjU8J8+zFJaC9vvZdCuaAYx3YpIjiqvmAveRXjM9fuWAVZJ6sw+z8jSDRT3o2rRjNVsOCnLhgKz165kKYGOpBDGl2/FfcrmnaaMx8jYhpZUBfEc1VZYFjPCPmKepQLyIx8Ex58IRtHymIs6XmHvcoxOv2CodqdT5vz18VAfmPuaqNcDeYnzGDwAHyajwU5ipWw8yrUcU7WiPVXdT85chdfb0AFTvw+w9B3zQIcL5HozJ9vtVZQPSABuZ1vUGssN9wAnFCzvh9gQFTSq0eoJWyBHJKSK5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkfVBTIHNNJtZ/E+ruDz66rg6fKL5H8FlxoSqXWZnxg=;
 b=SWcjJSdrsG9wFUU8NnSGcEugljVBB06wtCcjT0nFkRlGM+gcoW/m9PiXSi1aAgBcWz52fbWOOPQCCxKcy2h4buBA8fOG6BOTwd81vy0q/KsTs9Rf2LbJJYJ3ZrMFPgh2j6F5WI1dGuxWIrCps4kYZg9/nGSylJfG3t1RoENbtvR9iyJwsnBTFnaxdSaBjJXxTpEOys6XMIGb6hJctDwwlC/eZA/TwHwhFlLB/P4AgZJ7MVZ6Zz068Wile4qCpEwwahaFalUo4VptRy1fNqP45UjTHhsdU392CSFBfwdKibjkCxTRt6S+P4E2YKk3yLCBWFxFWMEwB1BsbgqEb6YsLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 12 Aug
 2026 20:09:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:37 +0000
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
Subject: [PATCH v2 4/9] iommupt/armv8: Add DBM support
Date: Wed, 12 Aug 2026 17:09:20 -0300
Message-ID: <4-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0053.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 29e661e8-c28c-4135-df1f-08def8ad9db8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|11063799006|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Dax9C1rmMWvx56341Hm2Lqf3cv0Lbx0kB9RZGEtuIUyfyEsBAGyMGkeo143NhYsY+L3YITDA5rSKhOj950+cPaN9yiqe5jcpyhqhOTheaZm6a9nIHhn4fX3St1TJhLFVyUsBP0YQltf34V/euhnTaj8H8EK8MRwaB6S1l/F+wc8WnDHW4gDzKU0adW9RqoYI6kgnJg7MeiZdrp0wSp/p6xf5gqYSnTCZljykAEofuKwUzaU/zrSmXh6zScE2/l7CJuiQK73qBZOtlqq8xBjaGhSgFfZpO76/paByiND8GWSCYZrO3T1SvjS3YIp2o9RTH3JncTNTuXwFwea2o5UIcwB4kpK/oT5IMhGj+co2sKixRlMx29MdTHhFrIpiEdUI2aZGMZysHrMajNK/grdldJaM1hXWs0Ewa+pD8FK08X/M4DXwHd/6X2NI/sIMtemqNFNNMNnH/i/FRU2fLLxgwSRczDJoGRAg6eDWhom1lnFTv8T8+qk5aL5qgmC8zW5n5uTjf20zOdh3p+j2b8VsWcng02p0sadSr/ShLpORZUMNYLUKijm7oqS6M4v8YNwzgnX/I6gkVaBpyPhyZFCotGYgFzM8DZrIXE3NaI6ZOxtTNvrnDnzaEkaM9jy9NjpFNk4H9FOVyMosp2AG1M8u0Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VTKxXg1zd7fL4J9DdrBm+o4PxqBoRIszCuUwj6Nw++nlBnSzL7ntCvz0SNke?=
 =?us-ascii?Q?GQUSR609l/JdTtMhmgnq6FCqPncgXvtYNyw9T+Cd7o2532CsjKUsszP86Mdz?=
 =?us-ascii?Q?AE+nHhwnTfvIsdr39duhd4cLVtW1UsimgrNTUskyEHW+j1aQC+ZXQIU1f7VQ?=
 =?us-ascii?Q?E5/yFll0+wfzel/nI6ipbOSzRmTpCewCyIeTbBceP756V1qNrKGLnkSwW1lm?=
 =?us-ascii?Q?9jpSs9lMawER8O4A+NtieHGEj7pqzjZMCO/X8RlOJIVPXHbfVhVT8fyChtBt?=
 =?us-ascii?Q?qL3keuWz/n98TQJrIUkIaJ/HV3SFe2At/nQwdz+Arb0wz7reVQAtaWvbZgnv?=
 =?us-ascii?Q?I6yBUn7LPBv7m1hdzSc8zu/99ON4g3i2KyhPl1Bh/CQDcugBeqJqSgTxWHkQ?=
 =?us-ascii?Q?gZY6Q6rooSgANp5EjiZPtJSLoLSsLyph0oG0T7zr6d/jPWY4dxK29M1sKies?=
 =?us-ascii?Q?GOabpGz3d7w68tubzjUpY5nyS8nRWrjOQTWKEte4UGOnX8zP4FlB6WIWqnB7?=
 =?us-ascii?Q?V1rENFwq8n1ZyX5YoujCVH1F7CTCmCSvhRTTyi4xM9P3tgeNwlxtCPPeRzFl?=
 =?us-ascii?Q?PHvkFvjjGdEW0J/Uba1CXupA5zXQ+CCrZf/2KUlq2B3bPmEuJEdHWMWNc4NZ?=
 =?us-ascii?Q?ZjKJVQvn4fGWP6LvY0779u6fCUKeZsJRB2ACGyaa7jqtx3zwYoyCEuM8Xtny?=
 =?us-ascii?Q?JZJ0p1IrH9B5A8tQ2/zYxLM13U9sDF8aYCMSe3dLId2LmgNXwDwKBehPcgDb?=
 =?us-ascii?Q?4f2TZOaQn89XuxQDMGTtu77G3qFY3z/DhILxNb/33tACwuukfrYn9gaShRe/?=
 =?us-ascii?Q?xs9wpPUXm4X54Clr/YFwa8oVQ6TjdggNWwIwvDPkq6q9VnntTKwn4i+hv9K8?=
 =?us-ascii?Q?4jiX2qbubaSPD7zAebNqIiQg3A/NDB+mIXFtzC9UFowzV0+anqgQo9Yk8Eub?=
 =?us-ascii?Q?WS3wiTeCdCfCQG+WQ0/k3lwpvwtc06ir0+lQ55XrsP2tmVMYjB4ZucP/MC62?=
 =?us-ascii?Q?R+XAFYL7/09z/amsg2j1KdaEtpZhhwZx+kguR55GRLhuqIyxBRTXmL4R324e?=
 =?us-ascii?Q?MO0usBepQ5DPOzCe+dxZsEbLuZDp14BDK4Hp41JeHLYXC9b1D1fAF2olFzNy?=
 =?us-ascii?Q?yuf9e3zjdVdPILiNlNA2rbm7PyxjKONzE91gXvojvUuHwUaga+L6mbDWkPgp?=
 =?us-ascii?Q?K4tdX7xYwdUkuBmTzeA/d+khTdsTooJmhJvZx8mzhph3p/1Zg+rpvqkTqmM+?=
 =?us-ascii?Q?XhKmiLorHDjNlJBBrEmAovWyGR/ql+ymHmkt8gkFBcG/sEeqh+b7/XU8OFF0?=
 =?us-ascii?Q?rMk32QXbwmXIJ591PbrmewLdJ82xUGc5I1xtI5gTqTA1H/80JIKsQIoEVB+N?=
 =?us-ascii?Q?EPp+d4Cn4pVMj8wkjBlik4wOyyfvy3/605msiKAdjD12K1c41dvJs2SWGI4s?=
 =?us-ascii?Q?mh1fmaf0RsxvZx6wtaRkbUvH3yzZxnUa0TsNzF8cZaOH85DuA0JqOL2n4+CU?=
 =?us-ascii?Q?5S+VeB5524e9uLdHo2aoS90jiMf8YOvGVoeGOUJofqVKbqjUi2m2cSzmiXXK?=
 =?us-ascii?Q?JkolDW01y9Nu6doYIN1OBNkcTeOS++hQwneyOZQo4gdS6Zm3Tkpc4ZLpK98N?=
 =?us-ascii?Q?EQjo+9kkYTEPS00CnC245xzEtyKTCB94HvuCEtAMuyxdmFYKvZixxKWBa6GQ?=
 =?us-ascii?Q?1ZKZhCDRdafBRSTnsI7KgFI/PbkwN+ZMY+u0YOT0gqx3jOQQBXtdaSmejlIJ?=
 =?us-ascii?Q?+2b8DvX0Pw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e661e8-c28c-4135-df1f-08def8ad9db8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:29.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QcR4yqF9TbM5r9DBfXYfIEzFqjj8FPLULsVV6+1x+QF4TMeIkBgi+NlIkyB0w6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121

Provide the functions required to do dirty tracking with variations for S1
and S2 formats. This follows the same scheme as iopgtable where the table
starts off dirty to avoid any HW updates, and once dirty tracking is
started it will be cleaned.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/armv8.h | 102 ++++++++++++++++++++++++++-
 include/linux/generic_pt/common.h    |   2 +
 2 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
index 96be469d477fca..6bff34a0ebb59b 100644
--- a/drivers/iommu/generic_pt/fmt/armv8.h
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -97,6 +97,7 @@ enum {
 	/* 4K/16K FEAT_LPA2 (DS=1): OA[51:50] in bits[9:8], Figures D8-14/15 */
 	ARMV8PT_FMT_OA52_LPA2 = GENMASK_ULL(9, 8),
 
+	ARMV8PT_FMT_DBM = BIT_ULL(51),
 	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
 	ARMV8PT_FMT_UXN = BIT_ULL(53),
 	ARMV8PT_FMT_PXN = BIT_ULL(54),
@@ -420,9 +421,9 @@ static inline bool armv8pt_install_table(struct pt_state *pts,
 static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
 					   struct pt_write_attrs *attrs)
 {
-	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_UXN | ARMV8PT_FMT_PXN |
-		   ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP | ARMV8PT_FMT_nG |
-		   ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
+	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_DBM | ARMV8PT_FMT_UXN |
+		   ARMV8PT_FMT_PXN | ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP |
+		   ARMV8PT_FMT_nG | ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
 
 	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
 	if (!pts_feature(pts, PT_FEAT_ARMV8_LPA2))
@@ -442,6 +443,101 @@ static inline void armv8pt_clear_entries(struct pt_state *pts,
 }
 #define pt_clear_entries armv8pt_clear_entries
 
+/*
+ * Call fn over all the items in an entry. If the entry is contiguous this
+ * iterates over the entire contiguous entry, including items preceding
+ * pts->va. always_inline avoids an indirect function call.
+ */
+static __always_inline bool armv8pt_reduce_contig(const struct pt_state *pts,
+						  bool (*fn)(u64 *tablep,
+							     u64 entry))
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	if (pts->entry & ARMV8PT_FMT_CONTIG) {
+		unsigned int num_contig_lg2 = armv8pt_contig_count_lg2(pts);
+		u64 *end;
+
+		tablep += log2_set_mod(pts->index, 0, num_contig_lg2);
+		end = tablep + log2_to_int(num_contig_lg2);
+		for (; tablep != end; tablep++)
+			if (fn(tablep, READ_ONCE(*tablep)))
+				return true;
+		return false;
+	}
+	return fn(tablep + pts->index, pts->entry);
+}
+
+static inline bool armv8pt_check_is_dirty_s1(u64 *tablep, u64 entry)
+{
+	return (entry & (ARMV8PT_FMT_DBM |
+			 FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY))) ==
+	       ARMV8PT_FMT_DBM;
+}
+
+static bool armv8pt_clear_dirty_s1(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep,
+		   entry | FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY));
+	return false;
+}
+
+static inline bool armv8pt_check_is_dirty_s2(u64 *tablep, u64 entry)
+{
+	const u64 DIRTY = ARMV8PT_FMT_DBM |
+			  FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return (entry & DIRTY) == DIRTY;
+}
+
+static bool armv8pt_clear_dirty_s2(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep, entry & ~(u64)FIELD_PREP(ARMV8PT_FMT_S2AP,
+						     ARMV8PT_S2AP_WRITE));
+	return false;
+}
+
+static inline bool armv8pt_entry_is_write_dirty(const struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s1);
+	else
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s2);
+}
+#define pt_entry_is_write_dirty armv8pt_entry_is_write_dirty
+
+static inline void armv8pt_entry_make_write_clean(struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		armv8pt_reduce_contig(pts, armv8pt_clear_dirty_s1);
+	else
+		armv8pt_reduce_contig(pts, armv8pt_clear_dirty_s2);
+}
+#define pt_entry_make_write_clean armv8pt_entry_make_write_clean
+
+static inline bool armv8pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry;
+
+	if (!(pts->entry & ARMV8PT_FMT_DBM))
+		return false;
+
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		new &= ~FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY);
+	else
+		new |= FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty armv8pt_entry_make_write_dirty
+
+static inline bool armv8pt_dirty_supported(struct pt_common *common)
+{
+	return pt_feature(common, PT_FEAT_ARMV8_DBM);
+}
+#define pt_dirty_supported armv8pt_dirty_supported
+
 static inline unsigned int armv8pt_max_sw_bit(struct pt_common *common)
 {
 	/*
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index dd97304ffaccc5..b35cc67a674498 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -194,6 +194,8 @@ enum {
 	PT_FEAT_ARMV8_LVA,
 	/* Use the Stage 2 format instead of Stage 1 */
 	PT_FEAT_ARMV8_S2,
+	/* Use Dirty Bit Modifier, necessary for IOMMU dirty tracking */
+	PT_FEAT_ARMV8_DBM,
 	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
 	PT_FEAT_ARMV8_S2FWB,
 };
-- 
2.43.0


Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B330C2BCF43;
	Wed, 16 Jul 2025 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695883; cv=fail; b=J7tfjLbOZe3G1p6xDbovM+ftYh04YCGc3G0Mxl7gAt+xFuAu0kuydavCgAdScTtoXJCWgZc1qGo36dQxEYJur2olfeKkKYoPL/HMdwLj8SpkZzOwfLGcA+g1pYFkQP7WkVgVFdV3XRHcOPTslRdYTMTyEUU4RzBl4Cr4ARU2f5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695883; c=relaxed/simple;
	bh=rTMQjfv3WfPahpqRAFyFIZptEbDZ7Jl6j1vwTFglzXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ceLwEfs/e2KufoukWHGu2VGIj2aA4EN0vB+Xl0l3/FMzicgpJ+hWzN9L875hP9IaE4KQoEcrJBn2WLpDoC2i6OghhKOAlSdoAlI5QvCdLjwfwbmaTJpvmA5qkAOmAaZRisBT8dunYfyb/5nZKLVMZeJH4Mf6s0Vm0wPlRqjE4wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UMPx0MMY; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UMPx0MMY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDlaQhNJIsCDkoNWWUFCAmboL9qjZtb7LkbyI2qmQun1vs7+LmM2hM1qWbJ0u4x1eto+SzaUrr0GTdb0Nme1mN0Gi2nY7997JnaHK0P9o5Fvb+Z8WcmGrqDYYGXT4BEt3B47g9+dnHrIipq0bhjHTxi3qJHRW55s88lTFmXpGehIAUP4X9kDbHMQd7RsjywexPYMP3aO1yy7hh6MMvSdyE3ycaopwyaNIVLmpaE0yjULUZCYHpWhY/p6wei6m1Tc/AGbBs5tVTBWb5hkWoQSDtSkHgpOxcvFg3SYhV11rjTa/c0lOb3zIndWVxCc+9WK2ApED8ZoTGR5YmaLpk2fYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIu6v78fo4IGyQj2RLplL+h2iiUWq7A4+IaJHUwpahw=;
 b=Oi8mkXPgQ+f2ni/1++54RpN5yyoSAejOqlZoIJJlEKMwbDbDepFEZYriBXhmE3TKg78deRFzirjmT24oUZcYKc23P9889PrtEEDZ0x2W5XdmFmYbJ80qhUv2xWvlnbzsjHsLNAvX8iu3vmunKCABwmCCizAwNmIK6gXdC4vhuljwGDdRVuG6nH7amhwMOTXaly5GTWzlQCWPwCOBw572zr22LqXd+CChJbaheTrZFDG5mCn0wXyoA/0mUSJZroar0r6b1S/s/uGMZvl5TknACe47vaAs4V0OpCY0kysvbf+ZaFfdiPGylZPeh/TqXf8kv3tkIZ30lDUFyjZiGXxi8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIu6v78fo4IGyQj2RLplL+h2iiUWq7A4+IaJHUwpahw=;
 b=UMPx0MMY4cqT3X6LrjrmQLoKHkd+Yj8tISWs1bVbprclHRtindMAIpYcM1RNdgsywM5CqS65sslDtpJPvVcpkQV6vyIElIrSj/sMGmIHIE6MSLkp+7+z6gTbhDkhUGgoloWRitbenAeZcwo/WTXjA176XhTIbc3Ude/tzXF/CuCdEEzeBNT++9+PaR0fLU2Yx38VKWUumOu2uLFT5CaWAZMkv+KxfbI3+T+oD+snkiDloBhbeS4C5Y7W7iy3IFWJTjMrUE5x9mRVHqHs1qnG8/RZfzCjc8r/bikJ01RAAT5caWiFq3lfphafZOZ1a6Qgfp2MeQcU/iIoVHGJo1w9CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 2/9] iommupt: Add basic support for SW bits in the page table
Date: Wed, 16 Jul 2025 16:57:38 -0300
Message-ID: <2-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0276.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: e01cce41-e7a0-494a-2b04-08ddc4a30ad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4fMvh3ciwu2EovWPmjbYqkCO88AOGlM9pULLttb9Qw6NREzy9e2EuUwFnOk7?=
 =?us-ascii?Q?e25463oS4kg5NEQNBH94mthU5hSvt/4UKcY6yjvrndmvE9vLYboAGbRBdKeQ?=
 =?us-ascii?Q?OoF0dNN8pwb69Fmqji6NE5NA1rBfp8I7n6nnSEZF3onYO3rvZ/M2bO83Ij7v?=
 =?us-ascii?Q?Tn66O2rB65zPvUzvS/oB5NJMVOSEi93vWAPpVpRkVgKke7mwtbNGXzyUT54/?=
 =?us-ascii?Q?ij7jpxdmduTtHhjvn91vVvYv+moGrcC0j9y+Y1b6mkyuhuurqbc1j36x12HJ?=
 =?us-ascii?Q?y4Lu0W3jS2r3Q4vJswMcd/dfy08OJmwAd2p0gDR4UAKC5cXXBAkHGMXOTH5F?=
 =?us-ascii?Q?Eb2sugLE5+1UcrmQpWw++gfdvALHAi3I+HxddXiOon1F9mDTwBQJlwY/vlkM?=
 =?us-ascii?Q?tluYNzs5/aeZV/V5GurRz2PmEYCPJLQJkUyuuskoa/s5y0JJQV+r6q9ctGW+?=
 =?us-ascii?Q?TJbu4WuDke1P5/rjUU111LMwzXLpJNEgfVXRoqQLWr9b3GpRqHHl8zLwZi73?=
 =?us-ascii?Q?CFVqAQWyRcAN8O9ghHRhVdi38rvb/+tdJNg+SZF8ug/pz5EbfUxY1H/DTQcj?=
 =?us-ascii?Q?SHmDSlk2Hd/J1A1PAOA4b59PNKmvpjHo/WB7Wjt2uEQC+gpV/6lJ+4Wgv+Xn?=
 =?us-ascii?Q?lcQM06s4Nzsh8GbdpcfUe4VjhfBa0gY+ExS1Arh/BpMXaTyYTjmkqGxWVhPw?=
 =?us-ascii?Q?a4aSIKwk9QkUhEMKg9SOF1+R/1EMHvVdCzfUJ6C1HPK4qDE+By34QylTClUY?=
 =?us-ascii?Q?BBNbkgj50jv2EGashk51x/w58jB9xPyhv6NMUn/hLQC7gKRx6vrFEKZwoNsH?=
 =?us-ascii?Q?yGQi7UAnoL+CiE6wOCw9LWmqM7xCxv0EX0pVBuB+qTDW5PLAC6QAD2YnZynP?=
 =?us-ascii?Q?pwpIWDXhrcVDF5CdUJkspL0vsRaesBCw/U4k7BECym3FYzj8+40Ahoppu63r?=
 =?us-ascii?Q?eDUoEfwWH+AQMilfT2MNbHWR9zApiWSabJAc0LTj64P+DC96K9Sgua1ismls?=
 =?us-ascii?Q?vx8N2fiSjrQIuHC8CejqxAxfnCbACVV/gxH/K2O4oOw5u3djXHeLb+8b20ZE?=
 =?us-ascii?Q?S58cgP3kvukTxVVrK+fZXGSBMSIhjsIkajCuaeTqlEaEL7vC/KkiqFdiiRCL?=
 =?us-ascii?Q?qQ3V+nsn9AJQqOrLeFKkj7DgBcoPIM82EA0kJHUpaZpI7+B/ivu+wW3DQq9/?=
 =?us-ascii?Q?YXUBbRET/9HZoeDwvzBg5nj5OkPh3R2YZVGO6u6WOdSUIOaN0nH+gq70I4FD?=
 =?us-ascii?Q?nAJ6wfcsAkwrBxaP/T84uugtCgHgVVJArTHO65ow+P+IumwE3ayxeBOQsJUA?=
 =?us-ascii?Q?dO8fdHvjR/VNCSavL6+gVpOE3VgZVtWZ3YbsyUoBdBp6vVeT+9ICMD1VI9aL?=
 =?us-ascii?Q?i22yVkKcS2oajTKTGIU4/ts7JWf0dF4gd60ke2Q0mof6bNKEzLAkGxdEuuaj?=
 =?us-ascii?Q?izRACzhkodY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0JTy2d2CPK0DrRRj3a33V3twbG2upOeQuRVD6QsWp7ZQd+HQ8o7DUTNL/b6e?=
 =?us-ascii?Q?ITUPHvJLIIgOI6AWczuh3Hu7d2CA68EJCEDUhyFQHUS/OdYON90m1QDtOKrY?=
 =?us-ascii?Q?ssJRM3oH1hv/sHVTx/7YeAZETas2UelKT0KTZMR3WBTbn2sD8wjzmclzyNE9?=
 =?us-ascii?Q?Zf24uTzvIuAkb0XcAiSTSsgoVQp6plZZhJ61/bBl/tILX95TgoczBIZiH6T8?=
 =?us-ascii?Q?3l+LfTlay6Tr7Fhg9Klpaz+ErfpFc52nFlebbvAU+lBTdUXE36JqRQUTApQr?=
 =?us-ascii?Q?z5IajYy+tG4R2zSPZSGkveEyQADlAg3rvSE39Q/bpWRWSziU7KFxS+iv2LCG?=
 =?us-ascii?Q?7P6sAvkC05X6qNfUZ9BRTqtyNJzJAdvpDhx7tQDdb37E4MpVXrd8MXDLTVmO?=
 =?us-ascii?Q?LsrsENetBT4wEGAKPU17s4aesuwjAu5lHAhzU3vuVW8E3vkqrbQ7rHguJ+mM?=
 =?us-ascii?Q?Tk/QT7QgOngmrGdM8VHOlOEaYYeM3USl5/C8Bi9WlOrQxn4RMyCA/kBjbwrB?=
 =?us-ascii?Q?n3dGUyxilpxDFPA9vuAQ1jHqdWHj+Nebfe5rN5ecIO7rJuaQwK3FbbsDzrb6?=
 =?us-ascii?Q?lGX1busSzN1tNwT6kRK5xQeW45yAcyt9/A1t8nrIgSiHcAKPKPa9MWi9uc2L?=
 =?us-ascii?Q?R5t7sskdCyIcwzzWXywcHmnKEfSMEHBIr2Xgn9mAE8hf2dVxGIMOGfDtCNWD?=
 =?us-ascii?Q?rz9FcRMml+1McGdu1nKLwo4dlTbldlpHavae/j5yHnzgL4a3O7aU5IsYZcLo?=
 =?us-ascii?Q?x9/kuVtL1iYHFBuabF50GGyHg/dC+P7dfB4fswHCEDzeeQW20J3vQhTFtBFU?=
 =?us-ascii?Q?IcNrea2sfW+e8yDcvgO/kANAiXL8IS8oYjvlbt+pM2oxFVWbc2/htg1jtNHj?=
 =?us-ascii?Q?pIBCDdNs0DWCnwBKf1qhimKucK3D1B/GF7D/l6XMoo05UUh/hPtu3D9u8Toa?=
 =?us-ascii?Q?7dCOc543d8MOhvhN22v/pU0Yej+6ZVybv7BiyJqaYy8COIMpeSf28kLc2b9u?=
 =?us-ascii?Q?I5b1LYLxC1bBrgjRlX+UvX/eKkFGGko5vo8JGyuOKjSkESzmnYVqGPaF3OHR?=
 =?us-ascii?Q?69f6y4iLhMXH9qDIEcrh9ccMyHP6+GzUZ3AnNa7Yx0WN/khM0Wf5KCJ1Tz2w?=
 =?us-ascii?Q?4hXHfqzcPbc/kGzD4C85j+14/vTb2RbIg2ixqzgKrWVFlYcbkpGzQMFfb3if?=
 =?us-ascii?Q?Z6R0+U+/gp0m3kCK1LBNzZpwGvBARABOo21yq9NHhhBbjZ5Lqpa3VgTFjr4X?=
 =?us-ascii?Q?vSwRNXXyYSjm7rMJr7WESixmKWl7y12GIeB5adK/McTg+ji73bhYIUD/P7pG?=
 =?us-ascii?Q?nrMZ+EjZVHyjnte8VSlfbQKAJYC+MaGUVym1Cn90maqKBzZUOywKgfmAtlIy?=
 =?us-ascii?Q?Pde+Sl8as49uIbdv2a0EPjqgs81z07Zx5kJciFnSdo6tYJGoznFLRHIo/Ieg?=
 =?us-ascii?Q?Te+lM3QYT5p2XqL+47pXMDulOyMgM8LisbzYc4RR8Pq/Bl+UfNU0aO2m5Z7a?=
 =?us-ascii?Q?fw3NhF47VPN8cQ12ByHV0s7tRIZfkrBH9Gyt52uSlS11YqMaKI2J2nxF8aOY?=
 =?us-ascii?Q?fFNEmW6CurD6UFdA+0e+5h1W8hTLToWyxE9mZE1n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01cce41-e7a0-494a-2b04-08ddc4a30ad4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:49.8721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pC2I7J+3RbUNDsvwdkgqi0khaLSEQt3vUXrL7PCpIaRDqyjcvoy5YEGga5Ejxv3L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

SW bits can be placed on items, including table entries, single OA's and
individual items within a contiguous OA. They are guaranteed to be ignored
by the HW. The API is very basic since the only use case so far is a
single bit.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/pt_common.h       | 29 ++++++++++
 drivers/iommu/generic_pt/pt_fmt_defaults.h | 62 ++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/iommu/generic_pt/pt_common.h b/drivers/iommu/generic_pt/pt_common.h
index 5ed06104d38b45..ac139ae74e670a 100644
--- a/drivers/iommu/generic_pt/pt_common.h
+++ b/drivers/iommu/generic_pt/pt_common.h
@@ -338,6 +338,35 @@ static inline struct pt_table_p *pt_table_ptr(const struct pt_state *pts)
 	return __va(pt_table_pa(pts));
 }
 
+/**
+ * pt_max_sw_bit() - Return the maximum software bit usable for any level and
+ *                   entry
+ * @common: Page table
+ *
+ * The swbit can be passed as bitnr to the other sw_bit functions.
+ */
+static inline unsigned int pt_max_sw_bit(struct pt_common *common);
+
+/**
+ * pt_test_sw_bit_acquire() - Read a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a test bit and acquire operation.
+ */
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr);
+
+/**
+ * pt_set_sw_bit_release() - Set a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a set bit and release operation.
+ */
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr);
+
 /**
  * pt_load_entry() - Read from the location pts points at into the pts
  * @pts: Table index to load
diff --git a/drivers/iommu/generic_pt/pt_fmt_defaults.h b/drivers/iommu/generic_pt/pt_fmt_defaults.h
index 8738008d024b0b..a837ee9abdb7d4 100644
--- a/drivers/iommu/generic_pt/pt_fmt_defaults.h
+++ b/drivers/iommu/generic_pt/pt_fmt_defaults.h
@@ -190,4 +190,66 @@ static inline void pt_clear_entry(struct pt_state *pts,
 #define pt_clear_entry pt_clear_entry
 #endif
 
+/* If not supplied then SW bits are not supported */
+#ifdef pt_sw_bit
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	/* Acquire, pairs with pt_set_sw_bit_release() */
+	smp_mb();
+	/* For a contiguous entry the sw bit is only stored in the firstitem. */
+	return pts->entry & pt_sw_bit(bitnr);
+}
+#define pt_test_sw_bit_acquire pt_test_sw_bit_acquire
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+#if !IS_ENABLED(CONFIG_GENERIC_ATOMIC64)
+	if (PT_ITEM_WORD_SIZE == sizeof(u64)) {
+		u64 *entryp = pt_cur_table(pts, u64) + pts->index;
+		u64 old_entry = pts->entry;
+		u64 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg64_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+		return;
+	}
+#endif
+	if (PT_ITEM_WORD_SIZE == sizeof(u32)) {
+		u32 *entryp = pt_cur_table(pts, u32) + pts->index;
+		u32 old_entry = pts->entry;
+		u32 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+	} else
+		BUILD_BUG();
+}
+#define pt_set_sw_bit_release pt_set_sw_bit_release
+#else
+static inline unsigned int pt_max_sw_bit(struct pt_common *common)
+{
+	return 0;
+}
+
+extern void __pt_no_sw_bit(void);
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+	return false;
+}
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+}
+#endif
+
 #endif
-- 
2.43.0


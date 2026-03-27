Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CEE3016E0;
	Fri, 27 Mar 2026 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625047; cv=fail; b=j8Pda+on1ftAXVLIa2WcFSNZvSYBYCAGAht3dWiuorb3OywjrFMsXykX9nOLqhqHQvT2+8/11nHBq4TMFyzSo04z2xlLhdQyVkhqtwKXKiKQZotRGqlF8DhI7XWCVUtiSV+Rqu09fkELe6EGC3dpv24K9Ov/8gi14IShtzOg+4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625047; c=relaxed/simple;
	bh=o2m/4q/PrHi7aGQPwCflr1+fhsC24CAon1NbKbnmYH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gF13Elt1fzLfzXYE/bUQGHHCqdJ4yEId02DZUsEJvb34E+KxVOQdonIEllSZparR8XBD4Vpm3LhdrT7I/tE27tnYIW48Wnadna7RZ8r/zci8k+Jhb2gCmTonVXPH8eNJENF5xG91KwL2CCAhkLpLdZcDwUFh6jvf/dPylO8Owis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RNvQpvg5; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RNvQpvg5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tGb9CR02FG2hdi1/Sa8Kd2h0JqtJlKTJB6xGkV6UWrri+7dEU+nQUxqMLp9MqTFamAYcBlAPHgAV1PaePArzhCoy0Gz3FesyriKHaDRewEI+RRA/gKLjPdZtNKf4XnEBjtQWmGBejV7HduhbtnJzQHSzIbfcUwDYBRkb1FlrOgm5PBkzen1E12N16N+EJN4N96LzvC40+IA/QqWT3JltzEuV1a5Nu9gv2cuv4MkKNNMh6REVV8AQsy2kJ4KjxTn7QXpFWgmttA5AevhbcLOyCpDGMcGh8p93oEM+1GWr6xj2BfKlap+u2wJlfIFPpK0DOABeBlNrxlABE7r9AR4Few==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYV0Qw2kQTi6Ml97eE8c0ZJStKQx/bHLDro6BQmnvaQ=;
 b=pz9ksm9nMlqkXEoUUPnDHJCks+zfmNBjJr/j6OxeLOsmTcJmIKJEsVEJ77i60c54UPHsd9A1ZjKxYHpGVx7F9iXMNgdK5r466w5ze2iktItH3xGeto26JUcYdV1M4pfRod1mupBY6o0K3Ylmwz95jzhGKI1DLXubL5XCDjKBXVE6xKGYoNgICFtMIp5nM4nota1CfkHJCzZeb0CHvZA0+EBcN9cNErw2Xwb4jmFYT79yssHYGj57birQ7QGhUb/q4t5Evsa2sQjKZRN2b/gI1rO5VKDDl3PpObrc3TJyAh07Tjnx3SNGKfdAIB+IXldvTD3R/9yR5LZutsguJzSyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYV0Qw2kQTi6Ml97eE8c0ZJStKQx/bHLDro6BQmnvaQ=;
 b=RNvQpvg5OnqG4AZj2Ik14WfaKPw+0Uipazp4XmF6ri8RK8UsmbV2DTCS+kMSU9KH3BqqRvfQL6Zg+JbRo31+Iro0zrvW2K4Vojluix9pKo+KulJgRAdNCCxaI0pL978RCKZ06DzbSR+TzOI5TMsPYS8wP1c85fqF9Y5cE7d/It9vpWuR771Lj2QUXLcTKdDyjsQ0hh5u47mGLLeH3jUGjdTbw5ouW5nfJosNwo6xxyBbPIYsUFf8MjAd6LLWQxM2a4YaiTrhTi+cAIk47UVkiM9ASWI3WHhQOyjrslSaNZZCmEj4yyoym6e8CgG/NmEuY3BCWU1z2oM/5UhjhUe4Vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:24:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:24:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 1/5] iommu/amd: Simplify build_inv_address()
Date: Fri, 27 Mar 2026 12:23:55 -0300
Message-ID: <1-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb30bfc-50b4-44aa-76f9-08de8c14dedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	KvrBLe6Vqbasgy7h1VPMQLSe1U+lSnMgE+hwBX1r2r5zyzUkgiNuwmbn/j98nVSesAEMlR2YOu+AY21Egpthx+pBkJtq+QxRBvsDb1O3xXwuMokaA+wxRTrt1WLUC+PS7lad84aB6cIcZ9edcuf8NPbZ4i5xh+cu8vIEUnj+JZJa10NtSYFX507uuEQ3gTiGpvmGQve7MA1dGM5Dp3L2z/VwmN/u/3SO3+kCRbasO4DyRcmO4gW4gXjKEAvH1v4MCnnHAA3j7NBNI+v7Ci/XaVhtFUA0xLhKhQnPvVQb4TUs2hM0FXvVCwglFRytTaYG40zhdQCjl9vdTJqaeJ16IjvplimQCFggfgkKGkMXR0gA4aNsY7fZClhTcCajVLIBJx0LQxNDSngjusy10KrXsLmjL9S9PDVjDxjHghymLzwe9rRMMfSi4ni7pgMfZtHpYxbzA4YVW814queks1L2D1IKMcuq/HGUNrGYHn09zzjfymovAgQMEyG7x44F5zqyCNOEmzweHOXNlJYXXPOTAe9R7tzHMkO7YfdljiJkjtj/s1W3ipFt/+L6+n1LyLusd5hkgxJkcW+Lk91RHekMQu6zpgiQD67PiOdSXsWe2//+6J0NqH4xLbfJph7EU1qwUlJnGXhEd1A46OCLusz8xY2fTTuMJRatzN02R3nfJUk/Y46hnd0d5yDN4+IUBzk7jTB1D6ewJEa56RwgpMrOo8YqVbi/cqehuE64MBk6egJ/b14gnEoOwdANFDRibumhFfPpmJE+O2+tJW4hFyu5v/WnpO1w/hIcYh6H7ssusTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pHNJ4snvzHlIMCbbIT1P8eWXirvsgDHd0abIDMLcSmjPhavOBTxFDJADiOYj?=
 =?us-ascii?Q?rL3CV68TI1JjwQbqCjkyr7CuTKr20Uk9/rTiZaPunxpzZ80jMV0YQ5NadaUA?=
 =?us-ascii?Q?KuP16P/OmH/XYHYI28/hiwsmVWIFnepobFz+rglbUyDw2Zb2o3KcCbCZ3I1C?=
 =?us-ascii?Q?Hnkqfrr8PtfkUim/XRBHbH5CO4VD1GuiYmr2Ak5s7H/0ar2WX5FwKbOhUJmT?=
 =?us-ascii?Q?3kzVHyoAfpIZ3RWo9rmNP+dkROl0VI8SE/y4OBUExavQ9VUfZcrW0HZFu+Lv?=
 =?us-ascii?Q?druTHRcJ4t6bOnfwCeAnJEH0Tjxg6IxMtWNlKd1R/Cu0KkUARZzqzdyDg8e9?=
 =?us-ascii?Q?mWlMvBRZ2c2La10uhqVe0NIK/3sQGXiUTp9u16/4CHZfks2QRDBAm2UAwc7v?=
 =?us-ascii?Q?3aLFfbcv2ZJT0UwSZu4jDlM93uYoXDWz7OCkP1aZU+dUKuNJK5oRafRe7JuD?=
 =?us-ascii?Q?2gQd9VWHAaWHOIThwqDoLAKbnWgQKxHtVGlmvxtu1I8hJ8RSOmQ2eE9ffNGd?=
 =?us-ascii?Q?JFQYehs36gGG+MP9VbCIAM4IUlQe16ICnlyud7lNRINfybds7+4vBPpWVKX6?=
 =?us-ascii?Q?EWE325XEr+IeX2bBSojPJERTVEaXoXaZezfWM3tP7CCqcHNbyFyFsOYehJoU?=
 =?us-ascii?Q?4wmas8IaM3JZToEnvu3CdVqHI26UC2kawcKuzf7cnJaZ0o4S8OlHzr2sTNCE?=
 =?us-ascii?Q?QTpdBrRu7ohWd5sqaKiz244eGZlXScv5APE7wTGTZVf6l6zSOgF5JXThhzRy?=
 =?us-ascii?Q?XHzecVAPPWvhbSsY9NwSzPtsy99DaK2RwjuBII+91lhl6R7f++a7FaAY8yF+?=
 =?us-ascii?Q?140rMh1a/GazoBJnR7zyQct/uyzJzbad7nQ5/xR7onmsIDVT8TIlM2/zXB4q?=
 =?us-ascii?Q?TMWxxKwiEhoJc1MkUA4qqkIm+TdICwBcYRooS2RnOJtdiKnTaitYDVprIIHf?=
 =?us-ascii?Q?ulqf5Zk3xJrF1Ax22FjOeQrtXb0D6rsRc6TXJbMls4np60yDxoDObgiuA27R?=
 =?us-ascii?Q?tAxQyqwJ0FVr9b059AYtBbRjeareUh4aWWIDkRf8DpJnu+B0rqCQU0Tvmlk5?=
 =?us-ascii?Q?5PmduW7qb6LET8QH4heAwMKcSyPO9SG5Ji7gFMvJdBlvULr2sGhPYry79cK5?=
 =?us-ascii?Q?FhriCeJsMmYcT1rYnfpMi/fqFuALSuVOusydSHwdNoKmnOokwijqKl+/Z7Jm?=
 =?us-ascii?Q?+SJ9QGr1oHJh/IAbobeSDtkJg7G67TFRSIAPZH20e4EzRueJKAp8VWepGQcY?=
 =?us-ascii?Q?71JxrukbGggTjArZ2pd/1DlGSaMJmR5Dqdgl+aYaAqsua4Bs+SnPJhhjd3j5?=
 =?us-ascii?Q?bfxjxQJ0XYQCeNlyLEuwQleDXO8bcxai5dUSty7CiuCVB05NtAqh4sYXPI3J?=
 =?us-ascii?Q?5iEIpkuIs3NwHCZElQifV6EnWLwnnTsgH0k+45AsbqQ01NS81W0tduzzxIqa?=
 =?us-ascii?Q?VG+JI3zh0CrxL4XJ8TRLgJ7laVzE8vvP4a6pH3ikavw5FKzZnEMCADQA1788?=
 =?us-ascii?Q?fhVV/IU47zhWDUInN0PvJguAhxbvLyyfHmWAf9E2G88eqp4QdiltClBgzbe9?=
 =?us-ascii?Q?6np1YbNywYqLsosgERIdWUfCKHuwsttRaFTxtn8tqvxIUzgCXZG9iMlgJLa6?=
 =?us-ascii?Q?U4POc+Q9s0muGIQrE4Ekb31mkF0vWCO7GL+RSelYsOWH1dM0gcQWW/JdhYYW?=
 =?us-ascii?Q?hOk0W0HJ4cDzChJqiYsscymOQ7y3GenCwCJYgEGXL0gwWXd8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb30bfc-50b4-44aa-76f9-08de8c14dedf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:00.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xZoPRcCHOSxiMAK7gXrkKA8la0sSXtH0EHrVVC46bGYIiF7SRxWLlLJPyQ+NTkJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

This function is doing more work than it needs to:

 - iommu_num_pages() is pointless, the fls() is going to compute the
   required page size already.

 - It is easier to understand as sz_lg2, which is 12 if size is 4K,
   than msb_diff which is 11 if size is 4K.

 - Simplify the control flow to early exit on the out of range cases.

 - Use the usual last instead of end to signify an inclusive last
   address.

 - Use GENMASK to compute the 1's mask.

 - Use GENMASK to compute the address mask for the command layout,
   not PAGE_MASK.

 - Directly reference the spec language that defines the 52 bit
   limit.

No functional change intended.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 50 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 528ebdd26d71c9..28308759bb3e4d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1267,39 +1267,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
  */
 static inline u64 build_inv_address(u64 address, size_t size)
 {
-	u64 pages, end, msb_diff;
+	u64 last = address + size - 1;
+	unsigned int sz_lg2;
 
-	pages = iommu_num_pages(address, size, PAGE_SIZE);
-
-	if (pages == 1)
-		return address & PAGE_MASK;
-
-	end = address + size - 1;
+	address &= GENMASK_U64(63, 12);
+	sz_lg2 = fls64(address ^ last);
+	if (sz_lg2 <= 12)
+		return address;
 
 	/*
-	 * msb_diff would hold the index of the most significant bit that
-	 * flipped between the start and end.
+	 * Encode sz_lg2 according to Table 14: Example Page Size Encodings
+	 *
+	 * See "Note *":
+	 *   Address bits 51:32 can be used to encode page sizes greater
+	 *   that 4 Gbytes.
+	 * Which we take to mean that the highest page size has bit
+	 *  [51]=0, [50:12]=1
+	 * and that coding happens when sz_lg2 is 52. Fall back to full
+	 * invalidation if the size is too big.
+	 *
 	 */
-	msb_diff = fls64(end ^ address) - 1;
+	if (unlikely(sz_lg2 > 52))
+		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
+		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
 
 	/*
-	 * Bits 63:52 are sign extended. If for some reason bit 51 is different
-	 * between the start and the end, invalidate everything.
+	 * The sz_lg2 calculation with fls() ensures that:
+	 *   address & BIT(sz_lg2 - 1) == 0
+	 * Therefore only the 1's need to be added. 8KB requires no 1's
 	 */
-	if (unlikely(msb_diff > 51)) {
-		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-	} else {
-		/*
-		 * The msb-bit must be clear on the address. Just set all the
-		 * lower bits.
-		 */
-		address |= (1ull << msb_diff) - 1;
-	}
-
-	/* Clear bits 11:0 */
-	address &= PAGE_MASK;
-
-	/* Set the size bit - we flush more than one 4kb page */
+	if (sz_lg2 > 13)
+		address |= GENMASK_U64(sz_lg2 - 2, 12);
 	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
-- 
2.43.0


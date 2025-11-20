Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0382DC357;
	Thu, 20 Nov 2025 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763667231; cv=fail; b=U4AJk911zfEFuZ37Ghb/S6PNomuDhZdLkthf9SCEHixOiGvUgzctcaJ6DmWMirFOLNvzAh0sOLutnUjHXr7Lsg3w0efq/mncOIb1sTdITcZ+KQOUT5ySEmc156UO9JX//0x8BhMMhoyQs/njHyiQbj/xi4whGFBEk8aq0vR3P0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763667231; c=relaxed/simple;
	bh=VZTg4Q6WHvDjA8/BPUPlxATWYiD0xRB6xJIbS+G1cWE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=W1ZFplnsiD/LO/ZfuXLoVq8GBl8EGohX9tUrjuNxqqImv4ukpaLOm1AMegX3ztwMFlNGVNCh9EdKyLgFb0Zturw7OVmfQZchXiMYOnIJUk2dEWNn6uuSF5qdWKVYugaLYNXZGF1c55dT8EgquOohqlV7+MA82NL+ZMEgO1Famp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V8BN6pL9; arc=fail smtp.client-ip=52.101.61.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V8BN6pL9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0iRAyuum1oWdD15T5Ezt8shAp0BaH79l7BbOWC4Qu6l6wz2dfq0cfjcuwQjZLk/DGaACJlisUyxDj5frTrYNYTVSHPeiGhfzjJuWhExtRArLq1WpsDxpBtjpkBKQHLcsCCoRKURA+Yh2QgPq/ppm+YdXfA/qTnICwc6Wg/C4k2XVXfoy1RHlYTulphHbT3n3y09IrgQoAxz/FZ3y1lTH/ku3jIUFOqRxzhKVq0n29rhODxyaUjXM258FbeHfslokom9EgCFatB0uTfYJj5VbVb3xPhEImnQkWf/+rIs3vGPa4zQ97HTcuCwXbxsqPqyTdPnuS5FjD4++iEbl9fsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aC+8w8Qy1lQjsSwi8pO+ewK/9O8zEfl8CfKykhZw9y8=;
 b=JrVNMpiDyQwGzuZGKXOD9VrduZlh8Prd2eB5iOw426CDkzxW4BbRkqT63zCGDoe7Tt2DnFtYOcK2vzAR7qMdt8zVYL5o4iOCDqUaU0IUlgj7vFK62aOdC1fiaQWLWraOFvt3p9LODY9YtJIC031TO3Ff0o1U4CR/iUQLeeHHIxGK+w7vopThy2f/Jc6wZQjT+9atxjG/FamWKulFqBi7NmPSYcV+2oxe760ORhUoVFeLmsRV6M3a3gyj3S3uXSlxxmxs93Q7oVzdYtYAHeq/PmB6Im/yP5Opf8l+sRs7kPg3UxLUxOGGMzey4XxELV3G+8CUpZpMNTTNQEH3TM77eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC+8w8Qy1lQjsSwi8pO+ewK/9O8zEfl8CfKykhZw9y8=;
 b=V8BN6pL9XjZIlVBYfOeuTXR2ZH8Ws3vBKTg3/dW0WF1rNij7BBk8BsfnwDz7FUlEP2we/JEnb4KuiFVU9g6AYZbflqH5tXWH2YpUjkVDEdEUDR4FOQ5nchwaGBrzuDBczYLrMJTFTEQRYPANhJDC2IzPhZnwjTXhMd9cJPDnY1xPun2djI5Q7pSfRN8jL2Q1svkSkFnf32cMMTeQEuMJz75shTn+waIhlSqX20a7vA1xpUoTBLJL+DUHPrYYYyjnjuItStJh1Yf58UryqymMFA8EyAncxiOPzCwmtKCKkAAzRUbP8jb5wyRmR9JlxBKEpClNXnpz222h0xb+50VUgw==
Received: from IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15)
 by BY5PR12MB4147.namprd12.prod.outlook.com (2603:10b6:a03:205::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 20 Nov
 2025 19:33:44 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 19:33:39 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 19:33:39 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH] iommupt: Fix unlikely flows in increase_top()
Date: Thu, 20 Nov 2025 14:47:42 -0400
Message-ID: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	MN2PR12MB3613:EE_|IA1PR12MB7709:EE_|BY5PR12MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: 3801b30c-51ee-49e6-2ace-08de286bb4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KM8Ivp9KHRbP2615tKmvYoWkMSQRi988TFQ86OsjG9FNZtqBhIi/UessZTMC?=
 =?us-ascii?Q?G87XuNwgayvcIxIYYr4ah1gusS5UrY0AbF71IHpcutLVVyL+yQASqgk6SUqM?=
 =?us-ascii?Q?smXWF7hOwUi1urdbT3OP+JhSRAeIgn5lKqrxute7M2OC0EbMtSbGofpBtl9F?=
 =?us-ascii?Q?tG2FeZu2mJb7gwVp8WkkhDA4Oq4cdHw+jqrqPIVMcgKPDnSQFIGWW+YOUtrj?=
 =?us-ascii?Q?ESg6bii4RXxpN7645CcRkHv7e+mAckD9XAWZXrBniB2NZrVSWcDO/sGSxmnn?=
 =?us-ascii?Q?StiJfkAl1N4rQ+BO0hxKcu2H9SZbuc78leWDdFjY72hIz8RvoQUzfjnw/AVi?=
 =?us-ascii?Q?m5+GcFbwnTlJb8eXP4ujIU4OKNcrsCMNMli/FLFtGlz1JzfxHNPRzFjcT5jM?=
 =?us-ascii?Q?hiCxpwxL4GymDcA75wKewQU1Qn/MpQodxEuvQqMb+SloiHDeB9FZgoVY8lUF?=
 =?us-ascii?Q?vj4dAX8Ta8EF2Pt0EWp+7sWlpQh91EbIg7/rfkzhaPgD0v+7erDsZ4GlQITA?=
 =?us-ascii?Q?rdORNWWex88pbGpauY6Ofhiza5JthQOehpPvq+oEjd+GlReYD2q05Al6juLe?=
 =?us-ascii?Q?FlcXrNPMdFC0Nt2hlc2S4oLUHSZlbZ/mzva+Dg1oGEsUD2wzfrPjF5WferfV?=
 =?us-ascii?Q?rCJXgATVE2nAtG9KmOWf1IUaAznLPdvFxKaU0qcBCGJRxNGWdAYM+fEJVMsc?=
 =?us-ascii?Q?aLak+EALqo7I4NjvZ/whTrFMPrgSaagXH5LP9hUr745I15NCTMi4lUDtNBgo?=
 =?us-ascii?Q?3/FlABbeHUCZuf7GYzCihDgn0SlVxzavtScvDr6zCYt8vj/Uck9pzRxzr/0s?=
 =?us-ascii?Q?RoPn41HNGAY3HqKog4zbuIIJS4S15eePrwmqHCipVS4DSkiefpffj0UCSvbP?=
 =?us-ascii?Q?h2yNmRbAp69dmGoRcCt1sopQcH9Cdc227xYcka6bSG79rPLlZ5hnfQDFzJBN?=
 =?us-ascii?Q?BpJK8AK33ZExgTBtneLC8bnZoXPYpY7/Q7ZvsEr7uG9Gd3B7ZUkqhZySe2IS?=
 =?us-ascii?Q?9ANruoIwpNemQLIUDSIRhlwejSln/g+tpaD15WO3oVhnitZzY0m+MHoVAcV9?=
 =?us-ascii?Q?ybFyZ/BqbfdRZ+OETzW2wjx35r2DF3tFl2OA4zg2b5BwbpaplctXXB2uk3XY?=
 =?us-ascii?Q?sfT6xh9PJ9PrfmkbjwEouChSpxLdcYU70UeQPMMxGBuF9rRsS4rxb/yXETKk?=
 =?us-ascii?Q?Fc+P9aSsZ2BYYdDV2dpYxwEFL7vsILrHuBUC5NTvTPdqI35fMVfpZ+jenL/k?=
 =?us-ascii?Q?gSN0uHUvHh2qYmX3D7lww7a+wTkl9av0wBYcpXwrK7xYChr95q8/Ot5HRAjv?=
 =?us-ascii?Q?RaNSVr/Ht+hlcWiBRqaLrjzeLGjqBbmfUEOuZxUMS6yJsTE0Ev6jmEJF2hdz?=
 =?us-ascii?Q?w3kdkXzJKj0e6ZnGvxPitsirY3zQrxX84CTHQrGIZBcoMvmsawVMAQMsBQbz?=
 =?us-ascii?Q?wwDIFJUr2pxSS5NGTZlrTSTsC0rVNzXH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB7709.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9HXh35R3R4tll4O/m2asimh6L2DaPzuNQBJ85HCFV59qzM+IS6+SOWS+EqaS?=
 =?us-ascii?Q?rc1PCbSTl6FPbf4Vw1kCaJrPzQF5rMNZpamEdBltTou79pl3wj0wZzozDf6K?=
 =?us-ascii?Q?KBzEKDODPWykZGwYfFpuqEqEH6DDUiDCbZ5iWqX1OGO850I8MQJXDavLoTX9?=
 =?us-ascii?Q?pQdVRrJYtVLiz39w5ZCD2lCQ8Y3Deq/x03mBvJ3RCj0VhECxH71auRi1CJsh?=
 =?us-ascii?Q?hkzqhIxDXAJaZo8KARTBE0QXzwVnboNi8Td6BgyfILBuF4PtMCBvAVeAc3iS?=
 =?us-ascii?Q?hA/sZ8ZJeHeYpoy0RdDa7gUr3tFKGOO2QnQ3CpI7/lAFkwgcC+8vHTMkGP5p?=
 =?us-ascii?Q?xH9K1CKpQmZjTcv5fD2DvfOZuz9BLJLbwd8roXwRPvZ6QeBQcwwr7wnPEhXj?=
 =?us-ascii?Q?eeHYm5MoNd9ddqyoB1eN3TqD6xljntjdpIRCHZdtfVF8KVVJ8T5LXFRuiyrK?=
 =?us-ascii?Q?mCZjgEiGqqWskom1GVyAo2nH5bCs5AuLxvfjty4h0O6AWIpqi3r0+e8gxG94?=
 =?us-ascii?Q?nKmq9N9OV05Wx8g1whk/b9Wi+fXcFrUQumXDlsbBO92eQsWFoKpPeJOGGHFk?=
 =?us-ascii?Q?x23J9OtwqzW8c7oeMQklKe9gwfu0O0MyjouvX0lMyyrK8l+pRit9i7HLv6l3?=
 =?us-ascii?Q?AEv+O8Brv0as7qpLQGFhzQDmmDm109km/35Az1kDTl6CZnMNGPmF0a5oCKaE?=
 =?us-ascii?Q?5PqZY2BEBRdbeNUOF+k0lpfWzffyn+QJopCmWYsWiHDGnmthdgCbKSrR6HuT?=
 =?us-ascii?Q?SzIMp0yxI7db29mCKGZWhykvlcpSdvEdJgWYiFK9K6jrpSUYI/ss9N/SonLX?=
 =?us-ascii?Q?vNS1wOEeOtSHxnQS0OebcomaNlT8z5X+6EvV37xeiOlsJj205zHbKsrOo9wE?=
 =?us-ascii?Q?ZGJSkQofE3ki9+ZPWgdIpVfaV+T9mD9hIzLT26qf0gpldL7OkukyTk6Z7uDn?=
 =?us-ascii?Q?YXQ1+UvJrMUFronUeJ5McUYe0oEkr4rHlzdAHJumiubr8XJk3KVgWCUNfG5r?=
 =?us-ascii?Q?+XvY9ydvWViV5ARJLTWRv3xVlNhnQY/5PBeJHTFPY0FkWTXWkM/cqOhgFUBi?=
 =?us-ascii?Q?p2aq8vKTatDPc7KcWaBhw3Kap9/Emoivdgqn/fmCRhg141P/qIT5sjZZQItP?=
 =?us-ascii?Q?UvXR5qE2y/OKY/u2FslSz9cYfnpJRuj8rO7W2VcDmVfXI17VnYquJgbl5G7l?=
 =?us-ascii?Q?zK0gH9miX4cAm9evk32tWhhgmdzP3v2+hWez8WRbyogpqogNVmEmNYjrE+1B?=
 =?us-ascii?Q?rOYqwqIVjKPSdXJ4kHp2My8D3T7d8h3XFMKCr+a0E/9m2Pe4zd2NeJ8ZPYns?=
 =?us-ascii?Q?pal/1c5jer6ib0MjoQiEFuP/VpWaaYSGZm7RIlB12CbrcKpZ+nnxo79NMMrq?=
 =?us-ascii?Q?1O6yRB00/Q1AcfOzHzvWCC32H3kHXCio2NGMD0GSxr9YEQvsXV83hMot3cu2?=
 =?us-ascii?Q?+1uGBIkaPG/AleGdQ6g9odAoahp+Uk0nvopWiO3XQzqoGXGApHcTmmf5Kset?=
 =?us-ascii?Q?klWdPsyl+leoVcPs6T4R2rF/gorINUzLuXuIRYSy60roZhbysA0jTLeN03oV?=
 =?us-ascii?Q?F15LBMtHiWTFzQm1SCg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3801b30c-51ee-49e6-2ace-08de286bb4d4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 19:33:39.5315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olKYUSA14zy+iPTVTaJSX2ZyqzZtxkOe1l4PCjEzk15zTrrRQxZVTc8na3ERTkPF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4147

Since increase_top() does it's own READ_ONCE() on top_of_table, the
caller's prior READ_ONCE() could be inconsistent and the first time
through the loop we may actually already have the right level if two
threads are racing map.

In this case new_level will be left uninitialized.

Further all the exits from the loop have to either commit to the new top
or free any memory allocated so the early return must be a goto err_free.

Make it so the only break from the loop always sets new_level to the right
value and all other exits go to err_free. Use pts.level (the pts
represents the top we are stacking) within the loop instead of new_level.

Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/aRwgNW9PiW2j-Qwo@stanley.mountain
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 0e046fe0eea34c..032d04ec7b568d 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -683,8 +683,11 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 		top_range.va = range->va;
 		top_range.last_va = range->last_va;
 
-		if (!pt_check_range(&top_range) && map->leaf_level <= pts.level)
+		if (!pt_check_range(&top_range) &&
+		    map->leaf_level <= pts.level) {
+			new_level = pts.level;
 			break;
+		}
 
 		pts.level++;
 		if (pts.level > PT_MAX_TOP_LEVEL ||
@@ -693,17 +696,18 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 			goto err_free;
 		}
 
-		new_level = pts.level;
 		table_mem =
 			table_alloc_top(common, _pt_top_set(NULL, pts.level),
 					map->attrs.gfp, ALLOC_DEFER_COHERENT_FLUSH);
-		if (IS_ERR(table_mem))
-			return PTR_ERR(table_mem);
+		if (IS_ERR(table_mem)) {
+			ret = PTR_ERR(table_mem);
+			goto err_free;
+		}
 		iommu_pages_list_add(&free_list, table_mem);
 
 		/* The new table links to the lower table always at index 0 */
 		top_range.va = 0;
-		top_range.top_level = new_level;
+		top_range.top_level = pts.level;
 		pts.table_lower = pts.table;
 		pts.table = table_mem;
 		pt_load_single_entry(&pts);
@@ -735,7 +739,8 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 	 */
 	domain_lock = iommu_table->driver_ops->get_top_lock(iommu_table);
 	spin_lock_irqsave(domain_lock, flags);
-	if (common->top_of_table != top_of_table) {
+	if (common->top_of_table != top_of_table ||
+	    top_of_table == new_top_of_table) {
 		spin_unlock_irqrestore(domain_lock, flags);
 		ret = -EAGAIN;
 		goto err_free;

base-commit: 30dc4423a35507df9378a6eb1a7104f788f4bbb9
-- 
2.43.0


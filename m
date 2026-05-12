Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75DA3D25AD;
	Tue, 12 May 2026 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604397; cv=fail; b=azYE810ieyMjQWksHUoVfVI3214cnJCgoZAMGeUsfs+xontZngl2TQugBI3B2SAKKVmZIPbDk9kdbQvHU69ArWXodwdm+wto8RwQY/7+Zh1PdBiFZOMKiTACYBt+4dfmBAzgqoFgpLrPMkHY8VEjN/7RCb4cs/XKJZP0e9w+YfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604397; c=relaxed/simple;
	bh=DQ10hgjMzyF+xHAZ66CPr8WVr3BXKNLTE7PUfqSs3KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lMueu4om08Amch6cOOWx93WpQwcT47OGEAR7h2Gp932fSXMRSVWWZdOiILnzaoRa23UjNZIJYgj9NpEUpTofskWhIXO2XJCSxuzq3udx8m6gXK2/WlEHNWrW30nWjxXAklxLkFFHO5V9uW6DuvYY6UR+LZ9/RVMoG8HnoSD8A1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=raPRVGet; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="raPRVGet"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r9Zb5yxUxE2p5suQbUbcYXqcyw2Yr4wuY4j+4YOF5ylqe/hxF9d6rpz/gXbQfMrS3s1awSskvxSSvAFDMTJHjejWvzKlloqGE2MeVVt2mtgvngyGkg2BxucmZJOkhFgl5e0hOzSPpMbsuYtRhsUQgi2ZPI2nwd8VcojQBDvQxYueclUaLbgwhD64nXQ4jJVXOaMOUi7f13FDe7U1XMw0eWuBZ0gH82rw0Is7W4pBYte1sjO0YpKRlNXB2Y/6YwajnhlI8h6hUVgZ6lyPXrjkhCuJCB2uBw9g9WgGnYVUu9VBoXX7OY24o5chyjXsMi6OaZ5MFowedV+LR8qwrXITYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htaL62S8JHLHG5EaKdBEj0k9AskSwhFDa9dD67T3Y8U=;
 b=YAqmpi3knLY3dsDwpJwcqvPDxjd6ywBgjhl6hrAXC911b75tIXyvB3Pszt78QXCGm47OqKxFNYxwjg5TCn8NnsQUdYWUUQ1/iDGF5KayYsJnLW1RZGIU/+naY8/bNdOXkx5S/mcMbVfRBZvmR1hVz4cPmyJK0hD+mFBRLRrHnHjhJikvW0yW1WmWzPWGEeHFXT48nY5pycnpEzE6nojuO/DB8HeJX+EbXN54d6fJP9psDBxAWn3ujNp1aiFHkVBbSCosmGtR1ctRPcyYuuViUvLbJb0BbqKqPC6kOalXdLAOh7CPAMsvVUCkFa6r2bHXe2aVlVuBTPpuCwwv16eHgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htaL62S8JHLHG5EaKdBEj0k9AskSwhFDa9dD67T3Y8U=;
 b=raPRVGetTtmdgl27f1IKEWSi1ric690X/8/JwhqD+7foawqju1UhdnYGbZqVBthzbsu4ahcUWLNJW4Dxs63186Ak3mnGZtokPvmQM6mZz2BfVNzFLEJJAdsuGtvDEWeqHlyYzmnGnJu2TJEGpjttn7WmrjWZ9XvTCSCJA8mOLRyCUGW7MJQtOI15e4ENplz8Ic26jn3SNZ6DlqEJnALw9bcKLAEGJQ6D0Fd2g7bcua9Dt9RxcgfLWaIR2ji3rGtzHN2C9A2vDbUNTpkbwKGiVp9AlV5wHjrONTILnh4eJrTjM+5KY7E+zabeVcNMW2+W2MXYUor+RPHOUtvM3KGn6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH7PR12MB9173.namprd12.prod.outlook.com (2603:10b6:510:2ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 16:46:24 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 16:46:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 5/5] iommupt: Fix the end_index calculation in __map_range_leaf()
Date: Tue, 12 May 2026 13:46:17 -0300
Message-ID: <5-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::31) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH7PR12MB9173:EE_
X-MS-Office365-Filtering-Correlation-Id: f2af7fb7-0ced-412a-2627-08deb045fed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	MfCtEZwaHfyqTpvUBNZULPb2CjBdt3vLsSrHTO7pIAVw5dUchGvklYwq0jzNg97kaphNAVIRx735lp314DUpDDxMNXbhCMJ96o5BOob/XNWvz6cPgxS9QdlN9OFczW0dw4s9OY6NDxtrSH3cZugt7ntZscod5w/hOL5INc+6sl+EUKQfXPKvwV1yKBGBUIIq5hM6/vG6zNoHQUNi6mkxXAzw7rE7ey8B0OxpKGUFkmJ4yEi0TWXu9UHYyzD+K2JdiCI4W9+xn7OswXyXdbtGpDkP1Qel9IwEHtn3zEDaxVSYKxJ+TwvjEBocj+Anm6EJvBLZwsFf+yy2/88Vf5tdi+bB57H/30YctCk10tUFLYDPjm78hZNhYMBrP8xUBbLMEXhPCdq9bDDC8zYaw6G7iYEsVA1mHsuYhpxuxF9I9kYK5hJcPOaGwHoF0PCaFJj6Qr8ulR7gPehCXuPqqJt0wSgL4PZ25/xiM/Go/pFGvqTHabgmAT7EC++Mm2qtNk6REak4Gmm5DtHQmMOCCWbEMOh7jSZ0EICYsf918JnI2dL70o1Cl4Wx8OMDmSTC/Dtskt9AXLo27eX3I4TREU95JQyt6aWOnjXS2G+zY1yEeuXRcv+QJt66ciGmXS/TY202FZW9mvnZ0+QzA57lpW3b49oVpERgHtb2H/+v4dRraZvYQdU8U+Hqjq/12sVjt6hL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ypN0uk/kK7zgoJcGeaYrkutW0H9bC0EuDWXNZ6ZkUEb30Y9s09CbzwFFToyu?=
 =?us-ascii?Q?ExpNM9gR2Z7RzjALIO/JybEcFiPtljjjtKXPe3mvwTU9jyf5Ea7xqVrLehnH?=
 =?us-ascii?Q?40HtL2hiFaTSlKa9Vi6i//UWlNhKRpx/d3df2sjMxkZNS7Nux5bD3ZPsrfsR?=
 =?us-ascii?Q?AbAVoo5sbWq0PvVanssjnEP6fS/dm2mlw2raF/qN005cu46NKVZvPb3Un14h?=
 =?us-ascii?Q?kxrHRISb2qgk/8mOonSHrgjWuv0AuQb0Z2I08cBQs/WCVfAmAfT5PD7f/HOv?=
 =?us-ascii?Q?2jsEVId41DJjLgag+9DE57erRtVH5TL6st0mVdNtEaiA0l6skk2y0FXWaNY+?=
 =?us-ascii?Q?Q6c4qOPSmRxWnIiOl8N9Uq1weNzVq01QnZDU9UBEcZ8INTn5IhatyujZGcUC?=
 =?us-ascii?Q?WijO/ylV6bS8YUPzALjyeQ8vFq/wQjYU1aa9spno6/z2GPlrqZQM+bp4VDNC?=
 =?us-ascii?Q?lqF/oVI9TF9BHOAXT+PRSJd9oKxMt2EQs4cI7AmZqUuXtJ2kSzlkMAtS0eBK?=
 =?us-ascii?Q?rm6IouNjRAbyofMbyLIu3FsCRk32gJTB4FcogBdWqGt7TuRo6w3cSbfekats?=
 =?us-ascii?Q?1VioFMs8BeaMip/ZbOO17p6fWNaxbgvx41LF8wdKy3kk45ZnvSm1MYN+xi59?=
 =?us-ascii?Q?JAvwoApMj8mchJA2Kk5v2ycQu2sEMhH7TwuvFoAZ6wM65/RMDqMuHluIZ1cg?=
 =?us-ascii?Q?561kUlaRiSYg8+ctX9JTLc4GnYjKB7UjfMwoYPIiPjeol6JvzXpCYngLQjMO?=
 =?us-ascii?Q?t2PH+Xn11x9lkR1vTKcjXk2LOSee21Ni4t8QdU9q2mHqslwyCfEcv1YWS+hK?=
 =?us-ascii?Q?aSPomen9hst+lYHExgF1uY/qyDTVOcr2XFgLJ5iHwFNGLfP4TGxWZDrw7ByS?=
 =?us-ascii?Q?ypvc3DEQYguOKPedCtopmLt/5hi8nGZeLhy3y4jfBpaiBbPOiYiiUNFABbyg?=
 =?us-ascii?Q?E7TvHpXB7+UD1ZhB72pPY77pkYEjrKTlDrliQzLXmYMnFD4269MrltVDbg6g?=
 =?us-ascii?Q?NArHdZCjz8veMIxCZ49x8oUixZtVmHenwThHnxOhC1eXwsS7RczEJXBpnnLI?=
 =?us-ascii?Q?nhId8n6CPoohYDLtZcJjk4KrNc3opRTEQ4hdMBx6RiVEebrOi0eQrbT7n5s+?=
 =?us-ascii?Q?0Z8Ct4ZonW/OrcHkauM9NSMfcJLRrsmsyPx3hAlBi72ITbCFOtIv1olNjt29?=
 =?us-ascii?Q?IKNRGRUT+szZdK3cUtH62jrlrXuujF1e0d3MAtuCgTQ5fp+5ae4dbBWU92UN?=
 =?us-ascii?Q?qa59AmCGCd959G3JkkjIpufk+pawEwd2PYQjzDwNDkl4C5O9DxfgB4IzvZ9K?=
 =?us-ascii?Q?9qlkOj2dD8dXAKjeEqiT9hceGS8YBAAc8Ddv5Ez9smcCYwUAKCc5kt8wTd30?=
 =?us-ascii?Q?UIUTer5gBfrQxihOQLHHEypDvRg3/db/530+GERsk/O1Nhb1q1GLI/RyLoFd?=
 =?us-ascii?Q?g9vCHjXId526nEA/i9o5Vi2dOtGp3ZD5TMykvyxDLSpmCgUGmjSVqSit+oDG?=
 =?us-ascii?Q?Y6Xk6FFsaR2FnlgYsySIKWs3QT4KAFu0a2aPMy896os5Mt/K1NwAYSPNVcPO?=
 =?us-ascii?Q?vMFdeJhlvTD3VC31XPkHuMWKBFG8YZTENNnUDu2DVA0hi7bzx0+mIFBlcUZQ?=
 =?us-ascii?Q?jNqYtSFakbtgXhO7sdqsRnmZGlXtbEUY17nCx2bKcKdZizppd5RKBQKnUtKu?=
 =?us-ascii?Q?kRb9xVUbfa/m83CfII7A297n9OcD/JK0exKt/Rh1d6svVsps?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2af7fb7-0ced-412a-2627-08deb045fed3
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 16:46:20.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gab9djhl9FQjUAz99B9Wa+zRlMaUh/ZM0HC7+kNKJvXqhE01TrljZDbv6HBgzk6Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9173

Sashiko noticed a mismatch of units in this math: num_leaves is
actually the number of leaf *entries* (so a 16-item contiguous leaf
is one num_leaves), while index is in items. The mismatch in maths
causes __map_range_leaf() to exit early instead of efficiently
filling a larger range of contiguous PTEs.

The early exit is caught by the functions above and then
__map_range_leaf() is re-invoked, so there is no functional issue.

Correct the misuse of units by adjusting num_leaves with the leaf
size and avoid the performance cost of looping externally.

There are also some mismatched types for num_leaves; simplify
things to remove the duplicated calculations.

Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 4877b05291c9d4..dc91fb4e2f61cb 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -534,10 +534,12 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	struct pt_state pts = pt_init(range, level, table);
 	struct pt_iommu_map_args *map = arg;
 	unsigned int leaf_pgsize_lg2 = map->leaf_pgsize_lg2;
+	unsigned int leaves_avail;
 	unsigned int start_index;
 	pt_oaddr_t oa = map->oa;
-	unsigned int num_leaves;
+	pt_vaddr_t num_leaves;
 	unsigned int orig_end;
+	unsigned int step_lg2;
 	pt_vaddr_t last_va;
 	unsigned int step;
 	bool need_contig;
@@ -546,21 +548,25 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	PT_WARN_ON(map->leaf_level != level);
 	PT_WARN_ON(!pt_can_have_leaf(&pts));
 
-	step = log2_to_int_t(unsigned int,
-			     leaf_pgsize_lg2 - pt_table_item_lg2sz(&pts));
-	need_contig = leaf_pgsize_lg2 != pt_table_item_lg2sz(&pts);
+	step_lg2 = leaf_pgsize_lg2 - pt_table_item_lg2sz(&pts);
+	step = log2_to_int_t(unsigned int, step_lg2);
+	need_contig = step_lg2 != 0;
 
 	_pt_iter_first(&pts);
 	start_index = pts.index;
 	orig_end = pts.end_index;
-	if (pts.index + map->num_leaves < pts.end_index) {
+	leaves_avail =
+		log2_div_t(unsigned int, pts.end_index - pts.index, step_lg2);
+	if (map->num_leaves <= leaves_avail) {
 		/* Need to stop in the middle of the table to change sizes */
-		pts.end_index = pts.index + map->num_leaves;
+		pts.end_index = pts.index + log2_mul(map->num_leaves, step_lg2);
 		num_leaves = 0;
 	} else {
-		num_leaves = map->num_leaves - (pts.end_index - pts.index);
+		num_leaves = map->num_leaves - leaves_avail;
 	}
 
+	PT_WARN_ON(
+		log2_mod_t(unsigned int, pts.end_index - pts.index, step_lg2));
 	do {
 		pts.type = pt_load_entry_raw(&pts);
 		if (pts.type != PT_ENTRY_EMPTY || need_contig) {
-- 
2.43.0


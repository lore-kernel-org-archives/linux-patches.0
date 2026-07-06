Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8971340D57C;
	Mon,  6 Jul 2026 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355363; cv=fail; b=CWZLPmCx2A0RU/D4oVEC+iRdguzkutybKWAPgtlfkoZCTpcdkYc7ZaLveVsgjqB+76VRnnmkLfXOrJ4VuNr4xaY9m0nE5ei3DUnB7DyujzJAWj/G90QpRz4uQwbLTUQcV4Z/lHCxe6CMeIrirmuGz3UJYfRv+4COrzns3jyJmJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355363; c=relaxed/simple;
	bh=RaPk0Iegr3tkAqujoGVl8KUjDHlABp7lpygkgly58eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AMeBmKTP7R2MXp8DJh1Sgmu/X6+pkdaXnUor6bDJ6jLHUCVm5U8aX/C9Kzv15kQqGwscmUwxXH+C/XplWYEosvH0+712OKWWl6gxr/n4it8LBGex3xV/tOv/DHkX5Dxau3NvpnyLH62dkygVkBqiNX6ZseEWGE3udSMacFwjv8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k7qJqu5m; arc=fail smtp.client-ip=52.101.61.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k7qJqu5m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ33wIL64QKVnFDjKuK1pQOPpYUPYojoNwUpz5VOI6Kb4VRGcDZqB2F+s+Xxmvp9T472N32Zi2Yfql/wWz6/QcU202a5G2efJRA40HHsR54tuNWH9bmstSWVKPwE2Rrb4p6AYuqGDUozhQAxIuKglZnUwJD0Dq160VAWAyEP2IwCaV9YMpMlPZQZMu4UssGomuVK0vr2OgnkrhaV9AQopteBmDy2vgJuE5ASWoswVqulGi7Vyb5klbybI/CXEnABURRi9lUlCT/JwZINw+HfTc8s/lWqJliOYYMUA92VnZVuPHPKRH5FdVxRKynmb7XEE+dgzvG5XjeXuGKPNX3cBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZxKskWQxCEefIKwuO9mQa+pJnufIfSNJlqQGz28IbQ=;
 b=OcHdSw4tELm8/76+NG7VLILYQPPIPzt2/ztYBaXvRgk1aJ3PDuXZQqygUF9ZCejIgU+wj4ZDYHQhGqfooGKV48DVGjVoSVOfwF4HiYvWVlxcCslpVeyQjZZJVx5ZcxHzw90Jci5/XOY4W1OuAKoX+dViXFUuL13v4yzzlC3zKQmGpbgIPAmimVPsfP+H93RRmEfKMWUA+c+QueXmhqJ2a5tkiXfY/+aDVvnYlaLYdrGpWHTcs1eUAXU2hNR1+GqsSnHrbYrfej6LYvhTw/vgKtVQ4W2HMzMZcqawpzi684jd0fXSMUF2MwAUfZ9nAbCaYDgCFGI4SrLflv0IhhkHMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZxKskWQxCEefIKwuO9mQa+pJnufIfSNJlqQGz28IbQ=;
 b=k7qJqu5mKfPLSV/tHS905uF05VEs6Sybclt8b/joTyKHk2wgya+Hd1evzOgsKQRbRTQ6C+q2eRUOD+V0koiV4kHEKVS6m6uVrGLYmqVaeUZ4tY6quE4lQ7olIL/iaW6NaIAHPopgT+TUwJZiCoP+rOLG2MNLnuOoZI1vt4NZABGnpFanzLKED4Q3E3vRLq9whUNLbtZzWqb1w6tWcGVnMIwLzwhfgnR0YuEQMuidZaWyyjEaP4BydA/ivOMHGQDmX8Mn+srG2ZBtI+t6KObNBRA48KokD9/i+UzNSCcz0MqJfM+J1P06SJGOY6bvj0nvupwZZMAGgdVDrkRkh+bCAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:17 +0000
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
Subject: [PATCH 1/7] iommupt: Remove the sanity check for pt_num_items_lg2() at the top level
Date: Mon,  6 Jul 2026 13:29:07 -0300
Message-ID: <1-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:23a::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d84fe7d-b8f2-4989-4c84-08dedb7bb7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	T2pg+DmZjP2qQtV34qruBMjsVIHqX1xjYQo1k7Xtd+WKpnCIr28ykVawyAABwIaM8z7QgIbtKVqrIft5dNJPH3IEpbZINMpxOUXuvaPjyrHt1QSXO5sALIN3/b1P2BFvGPOpbdspJ6QFburqCpUR69B8Xx362FCoM1mJwzvQ9yEiO3zUxPla8CAijs/7yI7xRcikGo2T3LQsM+gSap5sW27gA10IHlrX99IvbgFc82GervReIPmLvCjpScfpgnHBqvLfOfZo4ynhZ6LUGAEoOoiXRmZ2UNL7NZafbRd16F+DV7jFmzasXjEyq0fTqMwovgry5j72gf0RlBHbCeMT2sgwNMQK1xiGh7JYFwNWA4N83NdoJ85c+/SpqelK7sPfw6/8T5YNTd6DRENf+S6aG3hmNy/7Uy9WsKvPBKmkpmmUhCLHkw7/kpvT08BG9+SZfRaGYwZ44w7mi2eCf2ku4G7Eo44m6Huwp8yM9Ne3VvrfDiEPgvKXUFzgwhTkLznrj8sW2c4Se+sKIRL/plANSY6kx70khoX1N1++Kkkt6K5tn4UbLiKrf065kSDuctzvxJyDrYf36xME9CPrUIpFnQZSncdPGujQyc+G9Wu2D+nQp+7hrFQfKuUetxccD9ezj0pdpgyIRqcORs10YnlssKSxISe0e00wdtdv2pbsZ+g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vBd8u1D702FAGW1faW3dMK0cMWstN9GIDFI2xutPbT7ZX7MN4tX1U1M1GYVB?=
 =?us-ascii?Q?uw9k2nFwUowuYnpF/Q/7c5jrBKK//krvdNyfZ+sh7WimA7LuDWakyFKzb0OM?=
 =?us-ascii?Q?NuPT5NzRh2wZA1ILFzd8/Z8WGYQgImrM3Ma82Qb3hpdmmCftoXkRZhea8bMd?=
 =?us-ascii?Q?7gS4W+VMzp2ErKb5WFtTD2ige98ED6wpHkUKeJNoalACPqaSvF9XDxIkQZp7?=
 =?us-ascii?Q?Vy+rN2wiuvyrRyA4K7YqtiXUIU/yS8Ko6yDS4kdR8gLj+0PQYaegi5HDg11A?=
 =?us-ascii?Q?icDbwHaUPmaA16MpovPPGBJEYqTrX331uzWIfqFRcqrI4+42m2XJU8lJPyiP?=
 =?us-ascii?Q?OkpP1KaJfvjDFJ5lyNuonE3lSEINVU0RHHSDd/jxJVZqBkOjIK28/x+PprCh?=
 =?us-ascii?Q?uYY7PuOe512/61enu2azc/o2O2wGhhHlGVBguZH1DfT9Z5xVJMMDieyjYZC7?=
 =?us-ascii?Q?smp+ogi0I4i1BNSB7asdnR4xEVCjFzKDf957WMBkZ3RxIWUX3k/7goXRixG6?=
 =?us-ascii?Q?k7jg6T1gxRH5h5JQWLDxV8FGNhYT1R/i2RdmG2kO4Ov6CKUBVVuUJJ/B7pBB?=
 =?us-ascii?Q?aSbo0rNRKFganfzY98IMqvMhDSoPCvOhNsL/atR4n/h3AfgtXDg3mofeIDni?=
 =?us-ascii?Q?65mhvg2SaSjnVUzZ3m63+4XnNuL+gW0oz2DeMF96Pg4xgvIlBPgZZy+svwRQ?=
 =?us-ascii?Q?isHkDNVEKWN5ubt9kGgpu9XZR24vc0ppfedM7yMlHd/VKze9XydyYIz3mm2f?=
 =?us-ascii?Q?5nH4EprlTDeDnj377U9d7/Ig11/LdxZsp27osOw3GvlThq2A0Qkusof4a/Bs?=
 =?us-ascii?Q?g4VW/M7Mc8zLUWHSouIX/La7sxUscu9SM0JOBq4QgkwLn5JglM0Qbe2oF32y?=
 =?us-ascii?Q?nfRAdSQBFKUu033hhEAgi7UN0lZL2rgZ7UT13G51whLFekDIISH1UwKDVGiZ?=
 =?us-ascii?Q?2V/05Zz2O/ai5W/xwPA3O9Bqgl6zvVYYftJ8zLe7tC6MH0+rTkRxc08wnOKk?=
 =?us-ascii?Q?At2v4JYl5HWRQ8uqRZK7zuT3adaxWG+WmKqqAlOdDvf0ZkupFHNgZsRCuKZI?=
 =?us-ascii?Q?l0mdAqzsIPds7Gm9QbCwde1dQ75GezNnHdwEEGHsO9FjTtKd+UpnJxJ55BJs?=
 =?us-ascii?Q?livK/qC46ESJWko++697xgmXZOu4bm5CeGfyGpaUoePh0hCkS+NhJD1sM2QJ?=
 =?us-ascii?Q?GjE6ljGX5rHSsP2AAyMUMjfIh/zSKgOueNM/Fy7AMi6bWV5BKvV2mYPwEiGA?=
 =?us-ascii?Q?NBTgnA3C36e2J7BVplneLZlCOphh1KwNbirwF1vghFiFgegGWZhjuk3nU4W0?=
 =?us-ascii?Q?zjXTG/U+/NMIgN6ZrwgKxrze2cq5lIbtZbIZy1XwC8F1zn6zncA5qLMNcFcH?=
 =?us-ascii?Q?Xjxvbxomqaf+Lr+UdlpnGRSIx7EBfn8D8mIAO+mIWrd0mYy6rcoNxKeRDHos?=
 =?us-ascii?Q?IxRJ4DaQRfcX9xS/jvNInvVrUQTAVcWUdwAFu6Czm+tMqKB1urI1BdoMt/aa?=
 =?us-ascii?Q?6EWEbLPqOYykm+tAD5VixFFlBBOEL4gP/O/gF66Ou3x3ciaaEjxHvWR79dmL?=
 =?us-ascii?Q?Ws5eMr+yo77Ui4LsOdyxoQ4+8wqjRXF04GGCGwH6YdP81aPpSzOfq0NyDH0j?=
 =?us-ascii?Q?JC9JGgVimQJtB3uXDOURg/hfEOKymH3xxVG00vdRpFqG2EueT8L6Sri0ansb?=
 =?us-ascii?Q?dWaNriV7aaRQkXj4XOrIYAH9aHySPZ86mL9iRvubqdgunXfx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d84fe7d-b8f2-4989-4c84-08dedb7bb7f7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:15.1362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gR9i+t8E9IFsvQlcNOysLcl/bWa0ZFuQMWQMvXwDj+kPahmXdjFNFV896yfAiU3S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

This was ill conceived, the existing formats work OK because they
happen to support pt_num_items_lg2() at the top level. However the
documentation is clear that is not permitted because ARMv8 has
concatenated top levels and we do not want to calculate an exact
pt_num_items_lg2() for the top level special case.

The logic to compute the number of items of the top level is shown in
pt_top_memsize_lg2() which is:

	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);

Which is pointless to try and sanity check.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index c2752151c80af1..f1320c7e88dbbb 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1207,20 +1207,6 @@ static int pt_init_common(struct pt_common *common)
 		     PT_FORCE_ENABLED_FEATURES))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Check if the top level of the page table is too small to hold the
-	 * specified maxvasz.
-	 */
-	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP) &&
-	    top_range.top_level != PT_MAX_TOP_LEVEL) {
-		struct pt_state pts = { .range = &top_range,
-					.level = top_range.top_level };
-
-		if (common->max_vasz_lg2 >
-		    pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts))
-			return -EOPNOTSUPP;
-	}
-
 	if (common->max_oasz_lg2 == 0)
 		common->max_oasz_lg2 = pt_max_oa_lg2(common);
 	else
-- 
2.43.0


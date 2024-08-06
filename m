Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5C17556C;
	Tue,  6 Aug 2024 23:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987104; cv=fail; b=MGCC5MFkkuPdwogffib7vgwZD3EGecfHf6RelJiQATOWhDVa8S7+ZtS/bDH9wvcbNLYhvUbu3YJNajIGo6p0SfrlWCKWz+U2cbm00arfr7fx27swFGsmHBSnZylGcdA+rV+tG1aG+VjtSzkiGatUBzSpBycGg/+1ijnhqvQTNmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987104; c=relaxed/simple;
	bh=RmQl8QtzWlwy1DJ2BVq313Ll25wxsU19FIlUJ8YTABI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I27E+q90OSiN9TDOed3xFEAnx/vzUq9MyRXzEiDy24TlfVe3pVTgYrWNWtW9W9Er+eCsuWQhC7Racs14kWGk/zUXBAGLmIPkhBSKQNoKKz2ZRddbqgfsB+qZSQ/ezURrUUMNnDaxomyeXgjnPHOgdrOaMHhYDn0y3ZkDgLUIDFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qIRoGeHv; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qIRoGeHv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ljaWTSEPYJLmsCfqyEPqp7MQMkVX39Pbmkyc5f1jD/dhId8WfrbAHZL6RyU+UDH8gSXN4+kZxUEUPNaTKjq1YMrIOf3lVmVfWHRIOWxW2x74nKFpi+qysTTd2Hy2jwA9AsFGrZv2ychbQa1yUCk/hVx1Gdrib9S+LqeYJZ4X3eoZK2m/EfRl3ZiZjsVqGFxWoEluGrWaJfbovRXabV8R99a7jbfeenkykYCcHr8W1ShcPArjZU3Y5WOk/oL38nNpNwWXoN5TW84X50bpsiMW4wXfHtWq1KGiM/hWzQPZjSv7EwowqHQjOc7Z8LLHgw8VZZwxwEGhyjx//4lqzI5dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6/FJ2tOwiz4XcawISnzVitqeIGHke3n2G5zNAU8e3I=;
 b=NtN4bJGaqFgz4/bV4n9FB8QaloJV4Ddv75q2HIEG3L37TZKW40Hmm9kwq5ZVm9cL06BYeKo1RAL4ZuPwhOuXWoOk5/XGEHBh+4GoBXjWzeyQ1210G+hs7Ois4muIE6Ism0X/mnoZSb6deZwe995UpbfgAOZenoC2vV3p3EkGnB++iO5LeKnWdNF5n7i6p+djeQhRh7r11ADzEVX3oWUG7edkvGA5N4wBLknzBwr4oqSUyMte5xBePaOa2I7q/XucBtH4UUEPLvo5aHUybQqwfC7JzngDlrzZ+5FuVeqmViVUx2kOBuJ9cwmpwVvyyr1mwVGCbeff8UHmc+ZAWiciyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6/FJ2tOwiz4XcawISnzVitqeIGHke3n2G5zNAU8e3I=;
 b=qIRoGeHvwLMlGYGPlrsu6Ig8XDneNd57I8H+ilOLJt05Em9Lq9vICnIDb9Efz+4qwmhDt9e20j4fkhRA7vfgbME95YyOOojst+BH0JH/mD6IlhTZvQx4gL7JQDWwsZjXyuhceNaIgHwIKQt+7PQ8IGrhZpiiAh5xjb+5zOuKzG5jZvKSBvw6ZMiynThTO+w3Qm5avUFtjOED5eojVYw9zTUskEz0LjKIeU9I4YaYG413VYgS2YlBorKYdp36mOl4zJXRsP4rZlLtOjbqvw/qKevahUNptyHWr0iO3iBbrNRNI4BixyEp6zzKOw7p7gtL1WCNF75iba2HeS2J+THzIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:32 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 7/9] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Date: Tue,  6 Aug 2024 20:31:21 -0300
Message-ID: <7-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:408:d4::30) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 1261e25d-fe55-4d26-3852-08dcb66fe497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hZQ1vOL6xLGriLhMRaF67dQkQZkubwPHu7kxtmg+fEkNL/fXZmyoEagYo1ui?=
 =?us-ascii?Q?l04vqy3csBk+N4hgnhSSgr+XT5Hb1wNopaOrbbB8IVPBwNhc/e7WD/eYcp29?=
 =?us-ascii?Q?L5TX0RZXjmDVhoEOVk4+91K39izoaRBd6RYZm/rBYtAQ2AA85OJ47tGqDYsl?=
 =?us-ascii?Q?FMFPZ9hXZCL7mMq1uBsEaMy9DPNsTxWDR6y7reBfqW6jIdutwJr/syT4/uEZ?=
 =?us-ascii?Q?FU+PCHCmnMveDoD9Zmu7Jeq2kpbHjpJx7ZkhqZDjQ8h5fIaY0okPe9H2m52t?=
 =?us-ascii?Q?5Z6xg7GPW9iJGON9ntbwFRwqW87qwj4qWVqW/iTUHxiL9uSbUz2BSP1SckOk?=
 =?us-ascii?Q?BpEy+AFBgXOU0BVwF/8u0IZKw/gpkY3Xd7kQ9l5SM9tI+S+pd1GAKgbWNo1v?=
 =?us-ascii?Q?StqSi3ZXyXxVkcMPgfBjuCLhjkGjeiAxNYOqrwozCdnCcoALeHN9QfVxB1bo?=
 =?us-ascii?Q?jcLBaxPYIIx9mxbPcGF40pQZZehxL34jTQozleExsSaOquQI+8iO4hKIhAp8?=
 =?us-ascii?Q?xDcW43Mnn8ESFYjOeMe86FRyH4noZ7cnA9KqIMeMPZVOrBJEH6yRLig6Dlzj?=
 =?us-ascii?Q?CGrniqPXYmsOYE+qBGqhvooiVmeLxK81UbHlYShSe8BOYnf14n2/Hm+BvYj1?=
 =?us-ascii?Q?E7XeD1G4Gl8+hrpy+tZ9MJLyvt8MEx65dDLLtnFfZ0wTCKN4IpFnHdPXYY6n?=
 =?us-ascii?Q?p7+IMD0VsDVs+OFCOYclA28sdXq6yIH4AQQf8sAd0YjNhUCP7d+SBZm25ZY5?=
 =?us-ascii?Q?hqivgMfylXEBOea6g6x6exniR0EMHzxFdRWNG4rfEbWK7ObTi7RGsLZX5EK0?=
 =?us-ascii?Q?OGPg+MDzNrzmpsj8rb1Zx8jYmRI9MTmOdi1Zs8Hs0rp5TvlnKgX8QQQpFNs/?=
 =?us-ascii?Q?vefdsytFOGsim38ZvY1fzVS3Ce3u6FIq/tlDnH69jMc3VtKXIfoTHD3pKe7E?=
 =?us-ascii?Q?57qhXET8aKlAW2SXeVP8abVVhEfHxJSU/oksWhwzImh//NuNvJpmgbgpdMbx?=
 =?us-ascii?Q?gLUGbV9agO9WqeGIbqvaryFjCZPAslx+2gr13RNppCd/HXlrNTMjNyKWjH0z?=
 =?us-ascii?Q?JpOJPHMZuDbeCnBWKQ99MKGhQBoj0cHJTVANBeiGnDkS601yeZoqFjfyggRo?=
 =?us-ascii?Q?k8ebg3IjAQk/YWmQwFlYVE1hrE8MV5eJSqJvOjhrxWWxFqSU3Gn9gLNmqVDJ?=
 =?us-ascii?Q?JajCtQl8zYPnnYriF3+HJnie8Ns4Gj1VIXwyl8WJeSNNRvHqRecuakCRcEyZ?=
 =?us-ascii?Q?U118bxOJpN0o8GUPa1EIdP9IaOHNay22N6fMPb1KwheMFThtz7An3IKruIhF?=
 =?us-ascii?Q?XErlBvyDqo+qw9gYO4CEAeHORnkYks8w+G/sdC9MSaVW6g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jAiEpWDa6jux+F81gdSt/+jtmYmn4oQOFwu9FXOPRjqangHe4qrO/3ukS0ZT?=
 =?us-ascii?Q?ZOQgN3S/AxiePF9BmMQTtA7VSnP1EEsmP+7n08NBpwGVnN7ENelgucrUt5J9?=
 =?us-ascii?Q?jfo3arcvrNk0Xm/BS242UeE0X3KaiYNCxlZFzrEhAwA6yxIbEH7KhBm95lV9?=
 =?us-ascii?Q?CYMQ2gwfDO4mXxP+MH+3kc/YH++FxzfOwc5+7Z9EkwfMVVOJ1K4XPDeWqSL/?=
 =?us-ascii?Q?JTJgL5lLFLKeGWKrtVuaTiWaNoIaXULcyRMsiqO4WlgZb22Tzwrtz2LMech0?=
 =?us-ascii?Q?uLJqY66EuiYe3HmK9g70yzy4XeMm9E9SS5KpvVDE39eS3wF267bZ3sWOW8dB?=
 =?us-ascii?Q?R/BJ+ja40vAYTSvAI96s8e+M5dqpBh9kO80CuXL/3+3WEdyqJNiWGMab8F4+?=
 =?us-ascii?Q?4I+z+F0Q7wVKDcrkZEzEoM1w0u7t9fRVlHvI/5sCDdiRpjRZR2J9FLu7eBUA?=
 =?us-ascii?Q?KFzFgOv1gq2cXPSYMKdsB4JpNcNjXyrkfellrUZu3L5631Pl9z8pLn8Ac5xc?=
 =?us-ascii?Q?5tuEDCfziVJ9ez0CijY5KJTTHe2zFQlVQ8+A+R3R5+nPq4nIV50fA3hDnoRu?=
 =?us-ascii?Q?u4PeUw0D7u7mEuGsnnnqsaGo+l/BzEJkAZt+wbvJLmoy4G/Sg2dPzS/Qo0yG?=
 =?us-ascii?Q?3AZPF4xgUBOVNN4AZpU48af8rknreFB3AF+dA7kYX7dVXEMsMsoXpnSqznMg?=
 =?us-ascii?Q?wPc2TpS24bkdoN8anEEK0/fmyItGV6D39XMEIouP+/nLlOZ3cD+HrP0IIWCC?=
 =?us-ascii?Q?Tor86FtSA2i/qVnYmXhGy6qJ5hrEXA9yh8SJpBcnCOgpglHJWlwXdgfDXHaI?=
 =?us-ascii?Q?nGCUFQaEtFmYDrQhrYrpdQgn57YCtSIM3U9Yjdk1sDKobyu6UaraescD7p3M?=
 =?us-ascii?Q?sA3hdHQNeYln4bxpJlnH+KLGEt3bjuVVM7DaEbi2gVP2hJR1WjTCGfCd4fkX?=
 =?us-ascii?Q?ihDakM2c2wLNQGjalOb+76Uh0BRz7sen8bKkY989A961S3hPSjUqATbisvrM?=
 =?us-ascii?Q?aKVA/jpw+DgheNxQXpeisAMWfFupqTl/QcrWTiNpOmhUZfLORKhcx1jcj0ys?=
 =?us-ascii?Q?2RncD5PKlOE0q03FHSkiGaSjE8QR/k3idqxB6v0uKgtPyNMHCw+/AhEtGzjp?=
 =?us-ascii?Q?FmTfxJgz6Hqln+BUApgNNa81Rw8lbU64/AOLID3M/yKiqw6skhuI9l4DRe1T?=
 =?us-ascii?Q?3GBIas/dqcYgZUJ23MywmzWdwirUcf75jRArcH40c3N5CoMevatZio9AJz5E?=
 =?us-ascii?Q?il9lfiW4+4aA3ucYNwvSpokxF1trv+cwVM9wQXwGs/j9nzsp3YWK/rOBwPi+?=
 =?us-ascii?Q?VE2tIQEIfHiUc8y7kfKrqMsKHmv1dNKJcaNkACgTwqbvGz0/ak8+PAr4UVZ/?=
 =?us-ascii?Q?TIAEZlY7nxcqxg0Du36wsoNoYSe3gsFGEsA8VXzFRQGSCRxqwlqMXeNgdGgu?=
 =?us-ascii?Q?vqIruyxcaAZi85xF1omuUZVQaDaGVC/60p2zHz3qpXIcabDlAf6g4d/AZUiM?=
 =?us-ascii?Q?ZCSR5/7vMwrWlgU5J5GeG2a1wRTTb43k01YOKP9PCzq+26EF+eiRXn7fHGzq?=
 =?us-ascii?Q?OQjxPaflFAjkXMNKrGM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1261e25d-fe55-4d26-3852-08dcb66fe497
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:27.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thLLt6fSwq5/22IhvbqiiivOZLi28L6FnVISR8eiyf+85TZFUMfn2BgXha1rYOpn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

The top of the 2 level CD table is (at most) 1024 entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
CPU pointer (16k).

There are two copies of the l2ptr_dma, one is stored in the struct
arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
use. Instead of storing two copies just decode the value from the __le64.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e6607d9d590c4d..d23a845ad82223 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1179,31 +1179,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
-					struct arm_smmu_l1_ctx_desc *l1_desc)
+static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 {
-	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
-	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
-					    &l1_desc->l2ptr_dma, GFP_KERNEL);
-	if (!l1_desc->l2ptr) {
-		dev_warn(smmu->dev,
-			 "failed to allocate context descriptor table\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void arm_smmu_write_cd_l1_desc(__le64 *dst,
-				      struct arm_smmu_l1_ctx_desc *l1_desc)
-{
-	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
-		  CTXDESC_L1_DESC_V;
+	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
+static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+{
+	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
+}
+
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
@@ -1243,13 +1231,17 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 
 		l1_desc = &cd_table->l1_desc[idx];
 		if (!l1_desc->l2ptr) {
-			__le64 *l1ptr;
+			dma_addr_t l2ptr_dma;
 
-			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+			l1_desc->l2ptr = dma_alloc_coherent(
+				smmu->dev,
+				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
+				&l2ptr_dma, GFP_KERNEL);
+			if (!l1_desc->l2ptr)
 				return NULL;
 
-			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
-			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
+						  l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1442,7 +1434,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 
 			dma_free_coherent(smmu->dev, size,
 					  cd_table->l1_desc[i].l2ptr,
-					  cd_table->l1_desc[i].l2ptr_dma);
+					  arm_smmu_cd_l1_get_desc(
+						  &cd_table->cdtab[i]));
 		}
 		kfree(cd_table->l1_desc);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index be931616d9a27e..68841ba3c2e789 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -606,7 +606,6 @@ struct arm_smmu_ctx_desc {
 
 struct arm_smmu_l1_ctx_desc {
 	struct arm_smmu_cd		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.46.0


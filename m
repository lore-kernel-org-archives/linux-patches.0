Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51584430;
	Tue, 11 Jun 2024 00:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065896; cv=fail; b=Ic6XBVK0FZ5ltudRN7aeKCE4ybwNuEi1YCCIV1VAo1JDaMXDzPQOMLu4i005O6UpwbmLN9FSwLL5JZ9NLoMVG41w5gaR5s23VazjK3u20w+JIceHeLOcnanKfvmEwJUqQq+njoo5vHthMEDgMAuo7gtRQqcWioXG7hehSztfRpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065896; c=relaxed/simple;
	bh=htmTRnf8doTQKEa1i4drY3cigTsLvaVa47u8y5ZXZ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p81CntPfTFrjhYnlM6VJ4+m4wU0UJLep1sBm2GEVe/hA/4oGgO7Dew1iU8EqwXOyAm1h90BUBAJlr6jMiPaMbRbRvPCyXuQwvmx/1zGrG6o77gfTmB1ePHAnl1RuuVkdZhtEyX3OPO32UMFe+KC8D+NJ+1WyUSfLQwrgYhYPnZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QumwHLae; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QumwHLae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImvHsKfHl9MmfCKu+3NW5VLHvFALP8f5xoynHQnKUqldEoIcJFLsc1J1tPIhXpm7Jq9LSrslPQ6qhhM+o+CKrYiZo0TDgL0w45wpf+96g/0lUZOvcxlzO5paxlfsRuYdqPLnSTWOZLe6nIkJTHhB1rabS17ElVEVeqxrtdX7RvxHKLNpJ5CSyc1C91lkEjYpLi4eZj6+aLIuDJBBwH0WwpeOp0C3hKl7rZ/0eeu8xa6iP6o+JRLZ+xTnSFbfB+314jaW4nztpGjgAqY/Du7+FiQJNmJzD6ZHGPu6Dya1FoOvk5aZ543yueDQo36JYpMeQ+keOlalTTm8rQ+e6svDQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLUGPmKneAgy+CXJnRO+PByM6IvyAVil2RAIAxUOr/g=;
 b=dQASkO6JNUSLicMFKOcipQ/hDHXJ3d8mmCezGZRou+3BKGGtYtnjzGRwhmzGoQap/yuGyLtq0nNAgc/KqWtKpD3QiKVbXS9idsIEA0tYI1cWemosJU0E5lV/eTY0LSPf4Th4hkMwv0dbdJo/zmpkwqNHWksA5w+Ab4sxjzXTE9YAd6QJBfBHM2dsQ0HqPYxONdiW66WuSr4ifKZmdchtCjR270bUey+vo2jSpxzQGlhqrXp3TQqLgKN+1Qo4tOQgQvIv4DMdv4peQroM549UXdp0mSa/IwmNC4jv4Fu+A71c19piWYaLJvdbI+7KoUjD69v4klqSx+/BtPOHquAF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLUGPmKneAgy+CXJnRO+PByM6IvyAVil2RAIAxUOr/g=;
 b=QumwHLaevR2KZYLbXiTCPnSfSP9QusUVEedSoq3S+nSoAjcYGBwL3hR08kaUB+SEXqmojCmHr0kI8PTvp1IqxKp7I3Jf8Xv9ydoMcnnvumZswk+rOTcHc4yaoUsynb4jMBxJZ8VfiD06Wh0ZkyoTRpZ9J7wJ0o7h2rDzG5RjwqaKI7zHQrcGtz7RC2JeLJ4Tv/S2cauc6OLdN7MEdCezNqupW2OBqoyXwl+AvZfjAD2iAdt4oAeZV4O94dQkyba8tpg+gKZGH4hjDMQ8KoAF+TAR3p2xuC1dtZW0Tof8kXyD7Xw8q8qq5wJvP/GZ921c1rHzxAnRDLXIfmNGNyjsAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:26 +0000
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
Subject: [PATCH v2 07/10] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
Date: Mon, 10 Jun 2024 21:31:16 -0300
Message-ID: <7-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:208:238::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a739b7b-0464-4aad-7446-08dc89add255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qve5khLNYZhwKp0RmfoIGxxLjnNDROHpk3YyIAfJLXxvXjWmWX8Q0J+9CYYV?=
 =?us-ascii?Q?5Md8AadXtDTRAUJnf7b376FUtQFTkQfDG7dGw79IpzKvRjURNbAXKTl/+71N?=
 =?us-ascii?Q?x4G8Mlv7LUsV6oP3s9erw2E+EXzOH7kY5Bmc11eUoYRzBE7qWJep6GysHyDP?=
 =?us-ascii?Q?SdOd4qhexekc0cZvK/zy3Wj63JwMymL8IK4qIHOyUI1nwDn+rDou7SKGoNcg?=
 =?us-ascii?Q?y5EIlyKvpKkQsXoGtpMgIbyKtAqOkjD9lnO+GMfodYCAWMozFKB2c5/JjRpR?=
 =?us-ascii?Q?BHLWLag8cpv6Qy2/19dXYQdPf/0sWiT/v4hsELL4d8t4Z9NOqGbIiLNcau8q?=
 =?us-ascii?Q?ZLMtnm6MecXd/jShIqtY8Ge5POc+MnNOMKUFAzQ0XtxqdKtOr/ry16Swig4L?=
 =?us-ascii?Q?ECY0ue+EKoxL0GnW4fnk+7ZI5aUV+KNLTJSS5Ns2Fg+wW1CagAj4K+Pgc0i+?=
 =?us-ascii?Q?l6tRRz1MtvPNXDLRT5I30bLK2IG+8RPCz9jN+lXDr9LgRh+P++eWyQwdMwYC?=
 =?us-ascii?Q?w+aBS+cx0nKexdzr7iWTH9dScEjdd8pREWP9eEQ0BF3RZq834EP3KN8WOdIt?=
 =?us-ascii?Q?IzVK8lfCQG9SJyGCM8hG8wyRL3aBjtKfDm49zSKDqRz7qY+Y66XEPFaUpBKn?=
 =?us-ascii?Q?k32b+XmQPbMiY1XAvtzQRQM78Aqj3qBgK6UvpoCY+zgBGGtC4HytF92rgaHW?=
 =?us-ascii?Q?NjShj9DaOQtzGQlpbrLEOBRei5DP1GAaK8WBZiCwU0DI8h7++npI4+DzdRKn?=
 =?us-ascii?Q?paz8p7HJ2Mjua56Z9RMUinBICriHIuAD35Owli21Yd3cR9kP8gbKZ/vMsIMQ?=
 =?us-ascii?Q?Lhmuiy/FPS5lcUr/XmDfHvD6C7Gxez+YqKe6NR/1oix1yOh31Qbpx+7dzJah?=
 =?us-ascii?Q?wvHvqqlni2rNdOBzue9XW9NgAIyxxKYLqMzGRTDs+vJdyszSB+K1ZQVKARqr?=
 =?us-ascii?Q?8iaxatQNlsrrPNvkQq/ikjQgBIwrJTPbjrnbB4pdEHe5fK0GOuLhRcwFERXR?=
 =?us-ascii?Q?cYvjXwEl4PBhjhMgQ4Yj+Kizo2WZPMts2wVDfRkub42gDRoq2y43mAEmEmza?=
 =?us-ascii?Q?+RNC1LNZiQHh3/VpGvUSECP/HjEL8nOdDWcp8yMeaJuAK6THWlovWnWJS2bM?=
 =?us-ascii?Q?0asDV+jbWcLrJHE8KHJG9fnJo1aTf8UWpQOc97q7xog9JAnnNXcCDwr4Q3OM?=
 =?us-ascii?Q?U5q0ILxUckPwnMa6iQr/e7WvysClMp7wDQukxoK/b01wVyV5wo7BSYifRN/r?=
 =?us-ascii?Q?FjGQfOqTQ8kHcXCmGN171dV8BW3S8eTs08cycaIO18hHtUZT9HnhKevMv4R5?=
 =?us-ascii?Q?JTZN+0fmpsRWNq94SBZBD6M5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z6gpkKjTNQgbkU+BR4e6D4XvHTm9VGD9BeD3vZPakuN6wbXtHS/yosov62Vr?=
 =?us-ascii?Q?GTL1HcFA9EjwNJdTNaubnC+zP3ujk88kTlp73m1czCwSVEJwPrRpNhnUsl/l?=
 =?us-ascii?Q?6FzMNu7vQkkfjCmQifk+IHYIi0nNIKQkS3ELX5VTQCF4tVYVLK+p6mLBtCyO?=
 =?us-ascii?Q?XqzHrrU2vI8ydtCl9Tv4dhtwCTK1oqC6uHDB7IIRIHTdMz0XUaCv31ZyqFCZ?=
 =?us-ascii?Q?LgqGA+lkGrjXk5DKXBnA/3/lqI0wMXF+iVlZ/ZhPM/bXgGm1KtfPiOHvgizn?=
 =?us-ascii?Q?AQEkkOhWoALl5GTz/+r6mTZa0v8ok+AVoNcZlxNonc1wJNXL8nMe7wpEHhHx?=
 =?us-ascii?Q?E6E8E4EoZ5flAqBy3cZMhAKTQt1zVvJr697cuJQfhrB1IHbsk+WY+ILMoQJB?=
 =?us-ascii?Q?DsUfd1aV3oP4omvB2fpi+8Ya9RUTnVdqgHnqARUzyN2GSR9mSnQLdA+zQJux?=
 =?us-ascii?Q?vnSSJsWELN8oX9c4YVY/7HCYY/M/fB2rzFaFNx7Vuij/QiYJ9WEQ1HyvLwAj?=
 =?us-ascii?Q?gnfKVaLpdVPvGvBJHrA3OvbXBbLJmn4+lB3o+Re9ulcNHR9U/sPXLPCNqs9h?=
 =?us-ascii?Q?UY+klgyVQQy2xb58llDpUjt9HzVDPKnmkQxzOrVVO7lfaVeWTvH0t+cHHU+m?=
 =?us-ascii?Q?ePMPnYWUIJxFF73FWwRDJecb8FFyP3CXCZalQA/FnvLwbKXWAqXcgPy+Rdi0?=
 =?us-ascii?Q?oUYGipcolh0yZQ/z5PnwUUIh/I9mRZprD1YWZyVnsvQ8+tlWj96d5eUg0wOV?=
 =?us-ascii?Q?5V5cROAmB+iqF4QFpq20r341mt+V6l9X5QntWmXhMlsHGJeCPDwOTzXDvuu6?=
 =?us-ascii?Q?kAoq5yXWCCvM3+/HdirmS2U9OKE8TFgHUqx4qd2qFQHnQtJzupN3FLlyAe24?=
 =?us-ascii?Q?urFdWaf4iI10h1/gZTu7GoLS8reVOyLNq+ihz18mcADOWMEyIWzuIMs1dMP6?=
 =?us-ascii?Q?k3HBoU/dGMCku3r5JNY2pb0rZYwmaLah+MldwRi3CZJrWi2LYtOmVY6NOtrb?=
 =?us-ascii?Q?4hxE9qpErnxOKHFbbU0Fic/DFyoX2PnNT6IX1Kd+W6uofXz7mMUBh3OXOeWp?=
 =?us-ascii?Q?sVYAiDAhdF1/gwnZ+g9jHOy1/RUP7Cqel2JKPOZSBvtvS5GjaKU0E6W2Wdmg?=
 =?us-ascii?Q?tTDYRHGItyF7HrWhWrNrqHy9c5uqvB3hEmzMIju6euSsnX8DDa7WSNRGMpx4?=
 =?us-ascii?Q?/INKCpIDcHCKyK9chomq5O99QAZV+H1Jj21jvQjAm/fHxTmfLqpnIN0X0l6u?=
 =?us-ascii?Q?nyxnidDcU+0R00GTE6BqSAomRglQliLE6SdXgIPGL7/fUzzPiIQxgQHw5Ah+?=
 =?us-ascii?Q?7k7C6PfiB0zSN6X8GpbSwX4ly57h2ysNeXhM6aCk6IPCh8SsdrM8pomOHgvh?=
 =?us-ascii?Q?QrHcw/T+kx7FiDarDdamAzquqjXM5NEbuq+7ndGHEjbcQWkDXjK7U+AqPYux?=
 =?us-ascii?Q?aW80sbasHGbG1X3WE20HYPTNuA7UjYk3MwewQ6E9kEzgb0C7XLWJm/KlOhVK?=
 =?us-ascii?Q?fC7LVLaPiiu/zRBnsa0EzlpyJmMkXFmK3QMyL3DypoGjjsULf42DvIGdGwI/?=
 =?us-ascii?Q?nY3FlcVX+F7OlDWqxNk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a739b7b-0464-4aad-7446-08dc89add255
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:23.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pcv8o+n7wtjJHJtDZOvcpetuGblgY1QElJ4e8eSBgGR0l4e1TvA3WMQYnmSn8C/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

The master->cd_table is entirely contained within the struct
arm_smmu_master which is guaranteed to be freed by the core code under
arm_smmu_release_device().

There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
called to free the CD related memory. Remove it and save some memory.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 30 ++++++++++-----------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b36bf6bed67d5f..6245e2558e6a6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1172,8 +1172,8 @@ static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 {
 	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
 
-	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
-					     &l1_desc->l2ptr_dma, GFP_KERNEL);
+	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+					    &l1_desc->l2ptr_dma, GFP_KERNEL);
 	if (!l1_desc->l2ptr) {
 		dev_warn(smmu->dev,
 			 "failed to allocate context descriptor table\n");
@@ -1372,17 +1372,17 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
 						  CTXDESC_L2_ENTRIES);
 
-		cd_table->l1_desc = devm_kcalloc(smmu->dev, cd_table->num_l1_ents,
-					      sizeof(*cd_table->l1_desc),
-					      GFP_KERNEL);
+		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
+					    sizeof(*cd_table->l1_desc),
+					    GFP_KERNEL);
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	}
 
-	cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
-					   GFP_KERNEL);
+	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
+					     &cd_table->cdtab_dma, GFP_KERNEL);
 	if (!cd_table->cdtab) {
 		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
 		ret = -ENOMEM;
@@ -1393,7 +1393,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 
 err_free_l1:
 	if (cd_table->l1_desc) {
-		devm_kfree(smmu->dev, cd_table->l1_desc);
+		kfree(cd_table->l1_desc);
 		cd_table->l1_desc = NULL;
 	}
 	return ret;
@@ -1413,21 +1413,19 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dmam_free_coherent(smmu->dev, size,
-					   cd_table->l1_desc[i].l2ptr,
-					   cd_table->l1_desc[i].l2ptr_dma);
+			dma_free_coherent(smmu->dev, size,
+					  cd_table->l1_desc[i].l2ptr,
+					  cd_table->l1_desc[i].l2ptr_dma);
 		}
-		devm_kfree(smmu->dev, cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
+		kfree(cd_table->l1_desc);
 
 		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
 	} else {
 		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
 	}
 
-	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
-	cd_table->cdtab_dma = 0;
-	cd_table->cdtab = NULL;
+	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab,
+			  cd_table->cdtab_dma);
 }
 
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
-- 
2.45.2


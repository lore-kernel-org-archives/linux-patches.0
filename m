Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C1FA2D;
	Fri, 30 Aug 2024 00:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976395; cv=fail; b=UaEE+rpneCI8xr+SgiKt7GVcTZKFAriViIasJOlklFRnyP9zb7qc46p/Hz2Qx+UZDTAG2YAGPqOmgQCONZFQTjxu7y9R+dHNWt5YwVDVXHelDCOcdr1lYRHQl8t5FfRFkBKNxz+RJfRrUaBdmkrY/lvJd6nKOkRrWKqozx1UhVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976395; c=relaxed/simple;
	bh=qsiMoUnnvahyGCHmFF4VVs536GNRZZp91YuZpUJW/8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LXqLA+GUoxngR9Og+sHsjitNGK1TBSpZ32JLHj8NDe3/HQruiP/0To2UfNgzAnGC64WiatUhFADSgyY/zhXQ2+49gZD7UTCUmfYnoOvJn3mNAMD1EnDCSpFL2Exej/DlbhMMY5SDD0ft2WAGFq1SGgDnZSKmA8mUu6dhBWicMgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O706acA4; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O706acA4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFLK9oOsWYclScgCaCID/ALngE6wqm5HHIhjT/Dyo7BjfVgTE5nPJCeMbGH5uxC9bZ/qIfFUwM0gKy6PNNBy/1tMbVrh8VrTwWPukVNP91gnPNFOIkZo4q++/Ho0DYvmF9MN2QGt+kW9jRpDNTdn1QUBnsVL/7aWM84ly5ZZyMAbkzJ4HsfE7k9sRRfJWx/DaKC8PBKG4zKf+WasLqOvi2HymUtwrK9Gyjj+FH8sEqTSH5y8oO1XLrpWeK6UgZDqZYg5XjisX66C5YQOXcsw53ff1MfLUPijh23WPmCKO9bp3ESnRaDDYmvlR9ELMxIHnjNcwlt0QPDUm3iSh4yaGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4kdorxxa2BrUmrXuVPJ4gusixKtgxR9Q14tV7WP4ng=;
 b=ldlSdA2AEleXR9W0GfMJEqKrhpE4e1pvfU8/QYQD+40FJtK7Vrun/RoPiBELcRCUmerLM91qghk9Uf8OnXaWdBWFDjX9VouEpkX2dcs0aXSCCgIvW7zJqRyQfbYZTFN6mIQVBpGDJO34oOO5FkdmJChZiBhVpfBphNS7d2jwDTw+W2HcUGtE4S7xunGaJzFMQY54zKhauwihQl4Ayow/H5fDJFAAbcfMHm1CnrYWPykfyW8DK34jSBOebJIgEjVWjTf/+V8F2WgwZxpKhLIygPAUghu8pbr+hWkSQ0fQrWWb/V0x+lS0PIaC4Yy5ypxjfxSWNzND4IEoQSJyLpaKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4kdorxxa2BrUmrXuVPJ4gusixKtgxR9Q14tV7WP4ng=;
 b=O706acA4iV6lFAyL8yXTOxD+AeqGtyCyTnq/NkiOLG9Hdii7rQjOGMEiWCsvY4abUB/CphFvw+c48ubw17XHPfIh3UCUE3+3Mg8UXfdeIKuehXGJJL7DTDFOnB1d+sQfd5mxaZhKK+gu/p6foOkfWejlcf66uV41SWhCnGTKlLX0hpz5MrYDuaMc2AyKinjWg/DVwVtq9Sb/mk3g6v//FQET+VulWqsmJm770f3Zl8Zgo/RdKLNLaWIqCr2N0ToiGvRCol9WQtm30AwaeUp+pq66OJcqsKN4oQeubI9PReCvdrhqREQpbOx/Fak1cdks3kMqp5OMyk6t0fJPSATWhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 00:06:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 02/14] iommu/amd: Allocate the page table root using GFP_KERNEL
Date: Thu, 29 Aug 2024 21:06:11 -0300
Message-ID: <2-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0929.namprd03.prod.outlook.com
 (2603:10b6:408:107::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d14657-7eda-4681-7ad2-08dcc887960c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VAiECsYfqZqrvbr3JYX6r7irVZlOMIj0USid8UQGc8CMV93Qrk0KDByOdax7?=
 =?us-ascii?Q?EStUFxUWhnQmrFY2ynUDin+6pO/06GJldMfAC7CNd67eNwsCxIjSshDUsQXk?=
 =?us-ascii?Q?lHDe1qihY3LrU4wQ7EJPvL73Yx1xbTIiWuU4hQhD+qW/Q+P8yixRORBXQ+7R?=
 =?us-ascii?Q?f0NRoFnCOXfMWF2e9F6VBlpU6FQdZwZIfEDtMU4gmhmGN6kqV8z90M22Lna4?=
 =?us-ascii?Q?qtPjK8TZRttbgHdF8nCRIgJXWOqKZeGO6VxZN1v0UZ9DpIPnASfuNhYh1MsB?=
 =?us-ascii?Q?YtFh7U/Ad7DWTtONSholBeHTqWxquzi55CEBgVAg5a0Dh7zpeXqVLhvp6zF7?=
 =?us-ascii?Q?Zn0YVJuSwrpFx55xrz0aczK4NNEVxm0oHIHfx2G+wyHdCXOgcSpu9/PiyTSk?=
 =?us-ascii?Q?MLfnVLMoYeNOORtKJ9ixExvuHJnVJ7jX0+lQeU95tuvcAR2FVyB/n6CVY+P6?=
 =?us-ascii?Q?kqcceLGEGJ9wDdOVpaEaH5EWMn1v7go91XgTAvlJ//sv/A1LQ7YF9JqjkHoX?=
 =?us-ascii?Q?CacDuGnbMcE2V18PrnC9aFkVxuR9un6MscbACXGEZQG6c7Q6OWz74MrJF/08?=
 =?us-ascii?Q?rTv2PhQrmdGoARh0/M9khdAfhasDWoxvmMbEhXm6h90vdxWXQFrHKOIN5Tdv?=
 =?us-ascii?Q?0+UNzE2dYQl5qykjgU+xqIs8oXHuNxNvS6BuSejGAj2BP8GGwtZTwIl6BhzZ?=
 =?us-ascii?Q?U5svDlTMxehaED8bLs7NBTHUOzQUh70NmucSR6j97staRL3LxaDRYBpL2aTh?=
 =?us-ascii?Q?TncXmwKy1lVUqI3NOo6x+/X4+qjJSzyxIe0BxgOh/e6Slp/lCp/JOqkoQmCM?=
 =?us-ascii?Q?1OElKdlg0vOCCofbtMrOuT3EVEz3KzHuoE++OpWrCr2dJwgxtPgmnnnUXQ1i?=
 =?us-ascii?Q?KSUGA5Tbp7zJommXMjR9DI5Yn8yVLb6dvG/ps3XiyQZKIX/h4y2ZD1eRiHVQ?=
 =?us-ascii?Q?Yhg5xJrkBQgQFxcKKlrI9dPjF6nMhCdO5sQUIAQPoWdtZ9DWZxgbRv8UY1xn?=
 =?us-ascii?Q?ul82MAR9PdAo3OQuWWSKMM9244LbmoOnK10goVhP8Tpy20ijKlRwctQRKdRG?=
 =?us-ascii?Q?b2ra1O1D70F3ZNgMoJAzMQNAyHbYeyPTdLJZfH5jRcHLxN5SgwHXiMkzkChM?=
 =?us-ascii?Q?WtijIib4M3pkanDif1iPidZTU74kV9Q7cV7/lrk5felridLULUj96k09HQ8G?=
 =?us-ascii?Q?KqxvtdbK//CYVdtcyQlfQhaqAk7p5yDjFfDHt/kwkx1Ss1pP+MAjw/YD5i1f?=
 =?us-ascii?Q?8RBt+eVR0SbL6HsS8VSy5nOlmfyWSdcet3/yOG3qTubBGGqjkbYNsXv5FQKB?=
 =?us-ascii?Q?qxfUrZJWyx/l57sKURtVMrUpjfVEjHcMVhWXrDF0CzudRA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ekcpYLJBV6dFnKGXu04EvgSERtyYRc9yxJiW6/7ibw3jRKzDiPBYHI0nnb3?=
 =?us-ascii?Q?hpUXJ+RER00gtPC0fiLRaHN9jNBPge8fkuQ92IDgwcz8bE9ZL4LNHC9qyl87?=
 =?us-ascii?Q?QsHKshaAMqhCcx3MrbNBgQZ59OHQBOBplRZ0m5R6ub+3E6SM/mt5uNH1J8cJ?=
 =?us-ascii?Q?67wX4nCKPk3jgBpwN2Br/dqZo0N8tYxuGw0Ew8S/L4JEBqo/GJHzilx3FrMo?=
 =?us-ascii?Q?jUr1As51oJTV+o2gaKS4uiGDmF2etC/ZbhcL/gV3ebpU6WPHCcr+HKJvJssz?=
 =?us-ascii?Q?XdO1KMfkVr4rfknIgYfM2e48rJrRoztKF82Xn6Hi6mh/IhPMz9QwfbL35AnC?=
 =?us-ascii?Q?tuc+iGIbZKPWqoW0beEeH8XsYh1NysOw5HzeBjfYpH7kTgPwpvRXVFy6MepY?=
 =?us-ascii?Q?PL8uHEbRI8HUEUxSmu7PjAxLqmhRAQfOIYzxhQJFSbalWBqMZWYxl8mviPfZ?=
 =?us-ascii?Q?MEg0nHDCQ7g9ZsyIhlT61gIl1isK2giT1jGBLKW9QJHnqZ5NJ0cXe7wGEjyz?=
 =?us-ascii?Q?e9y6U2vG1Y0QOEZhGPqhD/6Ul848nqhEmMfvwcK7M3SNEhuq6MuXNtn5Jp89?=
 =?us-ascii?Q?DKpwE/xlRvKBehmcxyL3GtT5n6h89GpPLuGf5rG62ZJP8k+fddWo2nC7J9Xk?=
 =?us-ascii?Q?fntnGz/dkZhU08OPZqGyLT3rUaahG0a7ihul8QvjpttIjXcDHqi6p9a5+K5Q?=
 =?us-ascii?Q?EPpGDWwltjFq5jkTvHVZeL2xxWiD8gATOyXrEHDdzV8N3SDBNOPCd9C9CbiM?=
 =?us-ascii?Q?E5Lei+UXucMGzUTcPvtjk+BQsN1LYDUHZs5PaMjlQzt/Rqun96u8LHwMEFPn?=
 =?us-ascii?Q?Zmr5XpTPfzJgEPzx3HtwURXLkINFXV+Bx5cMJwiTLCOKnWgJZmIAz3IijihH?=
 =?us-ascii?Q?NYxcaOAsXNsIMSKx8c57QDx5RHUGGlH92XFtXXfSN2odpTIQfS0YmsehYVsy?=
 =?us-ascii?Q?4f07CvOdb18KgE8Og0gzufTeDDor1vZTR6CRvxiRVDaEB36EFPBPGRBcC7an?=
 =?us-ascii?Q?gJKphxyuDCDdQJ9Ki3vXC6iRUPVTz/eea0Mgh9l81hj6XXEffDE3+TYHj+mR?=
 =?us-ascii?Q?JVOqqf4/vQ13lROzaggtTtchtNJBo3aoLNfFswwEcCqtc7VsfJJL2IAPsO97?=
 =?us-ascii?Q?qd7ce9vMbzIyBvNfDiHPuC8GJlh/5TR0uczpjQKP3+m9tERkYvqzuOBBTUAz?=
 =?us-ascii?Q?GSunOPOOevKvf1h6SAgE3pmLd7sdqbbivJHfQKYLhMzNm9zsPBx1JzeL//aB?=
 =?us-ascii?Q?2iEkLzYMe7h+5AaAlG1yqlLaQXKxFUOb0yhjxqSftxO6yzyAgR3mFlnSYstb?=
 =?us-ascii?Q?N9yYhzWj95aVG/P8VWR5ktVkpXglLmTcRJVJ4/ENbPHvrnzjX39spCupcMzS?=
 =?us-ascii?Q?Ox7kmXXEgq9Tn4nJUZ/iIlgDTTTe/jMkFgYPCN5tVYXWgpYbN2Pnv7exuzRc?=
 =?us-ascii?Q?He6WRR1TLyYA3nG7g3rln9twgZZj3B5qLFGSgGVpfA7JIsrEVuH+QleJVtF+?=
 =?us-ascii?Q?l5SzksLx4QrCOREcmcaIU2cIWLJ5iHQTVmtuQgkwK0cSQtFHEFAIJRg8ybae?=
 =?us-ascii?Q?DZ++cQPXihiljDzOXKOXx9iJSST+66PBbYeDK7VJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d14657-7eda-4681-7ad2-08dcc887960c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j40oyqCn9POQP1zafv4EnSuRyWMTEnHxfzR24AzmtLkVVSGXP904M5ebCYuPOGwm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

Domain allocation is always done under a sleepable context, the v1 path
and other drivers use GFP_KERNEL already. Fix the v2 path to also use
GFP_KERNEL.

Fixes: 0d571dcbe7c6 ("iommu/amd: Allocate page table using numa locality info")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 664e91c88748ea..6088822180e1e4 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -362,7 +362,7 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	struct protection_domain *pdom = (struct protection_domain *)cookie;
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_ATOMIC);
+	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_KERNEL);
 	if (!pgtable->pgd)
 		return NULL;
 
-- 
2.46.0


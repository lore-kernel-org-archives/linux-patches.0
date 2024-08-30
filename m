Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4991876;
	Fri, 30 Aug 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976397; cv=fail; b=P77BkHtVFcANr/4kvO6VtvXvhKUAWrnwPhQlc+o3QIhx2ydsRLEzYCLVlwbnTc74qW0TC7quMDuAWse3EI1SLKYxooCOX6lDwKlJGhkDBWG7qdwOIzgcDgkyv1lvYHdm52xwCiEDRvs12ZPut9eD/F8j+f45u2a94YKLDcDb6W8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976397; c=relaxed/simple;
	bh=Pk4JqJ7aWlDbH8gqJQbTwS6SstdRT2ufFByIjVFB1xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jXxJ6vhURwAewaSUe13CfXs6Nre5NTnLQwpro3gLW3XmPgxIeln0SNYWMq9hansnDjGYyI7y/Y+Y/Tb2lCX2PkdlTp4tmru7ARWN4xkcbwKTU5o4esj4jbA1r1qT2hdVCzXXd5L1oGElxVF8kcYmKXprN0zOhiE1V+v0dUB6Ebk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JDSESmwb; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JDSESmwb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XcJZ42FOtBlNjPgKifwSGDmRX7PQPOY0eudMovlD6ib+vDFxRdJNf0mC1WeVXqNVT7BT7KUyo2hI+SxK7DLrLdcTOHdcs2cvWI11fXvgHCWAggy9KObr13kh5E5O6/JjW/R/9FIoovajrmQDIoTjLIYAfgEav8wiChfvaqC2tDmNGBHfJRMsb1ztM0INCKAzOcfHJyTq5iDMbFqFXRD0sxv+uVH+y6EgyDaC6BQt7U4uY90qLk6RCuNdzsVH9gsOIvgKB7fXYmnL2I1n+Jk/vAlw5ReIOAzp+QcdL5YCa+q1gkFRzHzMvf6iaJ9ipCSRG8tUCuBlSN2DBee7a0+JuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNZDk8wHrpdvbAFNk78TL8aOuMmGOUMUAJzoyKTnr20=;
 b=jCc6GMefu2mDoZV80DL9KPtD6Rt5Eh6KkPoCZq+uLjuh4Cbi43h4nCnFJ2uxPw24XecG7uDe/nA0gRbQPsMiE2D7I/527CN50f2m+Q4lMuk2TSarLAqgQUlQupcY3SJdCWFon/prj43xXfF/9M4nNp+/+FC7MPwR/fUx/11V1gvlPXGtVt9lxcwmhB2Jgam6jppHzSPjXz4O+rkmPBC0l6MqtpKDg4ecXhyFsln/fTn2/swzPb4uNgLJ4+wXYkh1I7+gZdR1I0zCLyu3gNku2OMZuj7RDvJvq4kRnsKTHyD+aWkDb6Uy/qRjjNt++qvuS0WjwY1/GHPisugiIgF52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNZDk8wHrpdvbAFNk78TL8aOuMmGOUMUAJzoyKTnr20=;
 b=JDSESmwb7KMVLyaum9O9XB9JtAIQSOsV8/hq57sJspJJ8AoGTachhAuEsqxn8dZhy3mt999FhmKMN2ii0KuVSA6oEkKHKqUqfi4fZqOtQUnDBxXWeMi9P99Ijgu/GeIRGwHGYU8ctV5wZAyTdBdg/mYWPsxhLWIgAEI4NCZMnQPdeQ4KJQRRG/SziOFOsPqjqju22Iq+5s/sNOddVmC7JWgwwadNWNIwY/mnjk1odVk9mxQG82NWNwmMRvtqtNLqCJWpb8YfjOqMTZnrVU3ZgrCttoh0AthS3MnYJjNlwrCtZ9V4bCiS6WTpxGFucwqpFhPULVXDg4bXJhTVp2VPrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 00:06:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:27 +0000
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
Subject: [PATCH v2 04/14] iommu/amd: Remove amd_iommu_domain_update() from page table freeing
Date: Thu, 29 Aug 2024 21:06:13 -0300
Message-ID: <4-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0487.namprd03.prod.outlook.com
 (2603:10b6:408:130::12) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 6591db09-befc-49b4-e10d-08dcc8879622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xDHKPcUkY8Y/H1L0KZ/BxOws78ZZMaOh0pKPbh3O45fT+fDtykJoiFuaypmp?=
 =?us-ascii?Q?Rr3seZjxfV44gpt5HrMkwgX5DRnniNaDofIvrpZSFw2wwiGKFhaAoQhxcMaZ?=
 =?us-ascii?Q?gd6gx2eHY2uMYXdCVKo8uPnLGps07sI0sDBa+Ee3+22eTtUk8zdP+jgLTxEc?=
 =?us-ascii?Q?z/ts8sn5Vs5TWNoOVsxyenrBacXtRieFLYgujdZjU3cYbOcgZ0IQhqiq6/Em?=
 =?us-ascii?Q?wZ5ZaA6nhu+glvKMiUUQYo7A9HhOCsD3wRzDnCMq9Lk9xG3J1IK0M4lqRV/w?=
 =?us-ascii?Q?WduyK8RU7mvSLFMfceeeZHFResDoWHctxc8kefR5vkNeWB3wH4Pvdi5v2yWG?=
 =?us-ascii?Q?lxkqakJlty9C15n8KdrISN+8wB6hhLSUZ/z2l4/9rm4GUOe77lUDFbb4Kn8Z?=
 =?us-ascii?Q?cYNXv2ctzz80QGON8NpQwJqQZrL2YjdSv4ZRHQJjmdzE6EA0VOXQ6NaSi8jN?=
 =?us-ascii?Q?YFvrPY5raJnAZxJS8xCwjXID4CT2Nm0vXYRt0lp92IdHjZV7m+T2f5wdeiZW?=
 =?us-ascii?Q?83GiHGmNHZCRsbS7jgfY6DhvycywM7WZ9VKUWLO8Eamq5EuKwGABvsVxE8p+?=
 =?us-ascii?Q?BYNDyOKPjeQe4ynyhvjp8xMbb8ALiF6IEPmtRSXy2Rn3IjTGDo79C2US7JjZ?=
 =?us-ascii?Q?meyLNfzVWHHKy/wDsClXSIsvIv2H494+3HH1yD2uHdK5dRbnMIc3mAcjIkp3?=
 =?us-ascii?Q?UciQ8kn2k4fHeH8g4lF3/vEgLqEXWOAopyTTVZRrzd0YcSstbpvPUZCL6Ghb?=
 =?us-ascii?Q?VthRPUi1pM/6LwZ/lRaSewlD0SznSvaVBsh9brY6CDuyhftZR7aDuZr4oX1V?=
 =?us-ascii?Q?a/W0FEf8hWtCUtUZyFlGxIkYZEbWk8y5NmLzFYEOvrxoKG7zGFzEDD7u5hdS?=
 =?us-ascii?Q?jdaPESKcyI/FqT2q0zGAo1Qsu/pwcIKYFUZ0OyT30IcZZqM7V+Pq8SUcWmet?=
 =?us-ascii?Q?9L5zgdUheNLpd1RuJlvO5cDYhqfP5ddkppYIQaD9ygcyoA1uUxdxKkLUNDle?=
 =?us-ascii?Q?liX/AbpejcW6wHwEqMBQogYjKslN9s+K6E7ccbFNVpBt9pXBS2PvjQi++QMz?=
 =?us-ascii?Q?ynNmFr5KyCLH3lyqyKWHkDNvlj/bFKKG3MA1iL+lNEJ8Duf5+kGBv9en9ROh?=
 =?us-ascii?Q?8HQ5yIGbPtPAsAFYOzXCVu0cFuFc8+x2SGwQKCEM0fzsIMOqxMzpi+r0Yrab?=
 =?us-ascii?Q?UdbQMiXOTA6D7F5pcCCeS2BcCH7tJoJKp3oOXNvnJVNKLxnnLVb4xYeiHT4O?=
 =?us-ascii?Q?puPf3QxOZkp8E2zZXiqQw2lobTK2kQcTByQCkkcKe2C5Elw8sYOnmVtoovL4?=
 =?us-ascii?Q?rhHwl8lQV0AjGyhnZTpSywApm+IrPKl8nXqQ0+ejCuh8KA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gKdQOVfLiufFbqz0JN9GR+gSRld1GNmp1kZhO6b3RnjrXovuXOF3ynyBVPV9?=
 =?us-ascii?Q?zKMSkVuiFvkvFbKMjmiIhAMQXq3dzSHxLq1Lf7xJrD8IN8s9PXMFWRWc9r+D?=
 =?us-ascii?Q?Ndz5Ural8lGDosMTMvPmYb0rHutSrjSqlVeOQjquib+XJ41UW8EHwBqsdXES?=
 =?us-ascii?Q?ruU4SH//7rjS18InRov2UXzBEfk38BgvjCQnY/JrD2PHH5rSAljOWp2MMOZ5?=
 =?us-ascii?Q?wg/4G5086WRoIGzGh+Tt3/6id1ocrXZuL6ivSb9pM6WcaRVYOIHXccJWagVd?=
 =?us-ascii?Q?y7JSjGVD0ZeqvKjNNdWXW2nyG/Y8zkZ1s7IsatlH1hCbw9YkegVGm4S3kPEl?=
 =?us-ascii?Q?rDJRHeDaQ7KHI9TXoFPRchP7wb86hGW+V5NK5X0xGNmMV1VPAbA0WnCT29CD?=
 =?us-ascii?Q?ZVaJjkFebHFNBwUH421ie35mkKfO+Ro2IZWG2QV7NrfLnwWirafSQnwfkW4h?=
 =?us-ascii?Q?U8AS/YFo33bI0N3E/LWbCDMeopGLSvcFRDJ+uMCiRitlKOGJu9+mpsSpIB2S?=
 =?us-ascii?Q?Fb1C9t/jH3fEXfNNBmZfc6zrkEqpq8gnZLZ6iRHsgv19Uxtnz2vkLVnaed1j?=
 =?us-ascii?Q?gFHIheKsgG39htjVnnDUnRMwO+Ynze0861VvbtE9dbgw/YaLNha5Ks8nluWW?=
 =?us-ascii?Q?5LW79NmQsVTUFSEU6th+dEzTsldqciybEH5Yq+1uwNV5WCsWHHpaiJYwz2rb?=
 =?us-ascii?Q?796yaJmMr2njk9qPFJB0S3CqhZLsrS+Y34+oMujF/ZgWmphE4rgS9AAM7jef?=
 =?us-ascii?Q?jBYp7MkaaxkrPIkIzxjJrHDf2oZ1QcLxXbHD8Y4vLi1XD+pGK7lkefX51Cf6?=
 =?us-ascii?Q?He0RmoMhGNZD27pu0/g3DKMdaR6cSWf0UEnmrpezVFOu7mvl4SIfJIkIU8B/?=
 =?us-ascii?Q?NJ3WXcsdyGo3Z4M34/tTdsk/YLHIQ/DZ+vf12Usjf3VG0nVj3AZeuxxDa1Lq?=
 =?us-ascii?Q?FkYjMtS9VRXT8Ag0PGeWI52nwR4qAZUYfjM1Dt4W1/yUDLAZzhd4Y+zNHSz6?=
 =?us-ascii?Q?SyKFVDGQCESO++MbdG3UJNZwpmKSPZugtNdXRneJ8fOPF/7K7ZBS9YjQJNsg?=
 =?us-ascii?Q?8aV3yVgS+wWtBuSUTfBuRf6G9y1YXGiGEkMJdhEO78jtEB5hzbbWrydMHpOV?=
 =?us-ascii?Q?gydQqj99CmnA7hX45JaCTIGUtIdUCokZCEyt19qFqixzsEKR44HgkCluUtkZ?=
 =?us-ascii?Q?uUDRwlMs99fCasmAkDlbr9vfBW6gnY92mNXcvTDG8BWrThz7QUULMKr9V+MF?=
 =?us-ascii?Q?3esFkCBMpNO+fvimOT7M/bCkeh7DbvyukxwJwAzlrTVVVwFwtIrUBpPS6ifd?=
 =?us-ascii?Q?9T0mtknTmAGnOgbfO96Zu98gC4zf3hOH3riDoN7FGqE4d4p+32QKNQDgP6CS?=
 =?us-ascii?Q?a5k20816a6y4dI1Vke9CfY3TWc4pJL4DoFbL4EG283G2CvyryIqPf8zoY+Me?=
 =?us-ascii?Q?bmR3UHVH6yHGwP3HNX32i4NvJAmy7lwMGtU//3pHXpfpuzL9gbhJAaB2jtzp?=
 =?us-ascii?Q?jZPKAfs+RkkgpDynGvk/8rWwbtrtaNvX7TjeEgQwymCQ7AUyzgxuCT0OVnJy?=
 =?us-ascii?Q?00QMrUHG+D8G+jKyoonftUiCH6mrOLnaPqGYR0Ty?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6591db09-befc-49b4-e10d-08dcc8879622
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRAAN0tEJxIztVIE57FiJ6Xdl+D+5nF6VN1wQO8+YQO+5P947lnaiK1V5VAO32z0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

It is a serious bug if the domain is still mapped to any DTEs when it is
freed as we immediately start freeing page table memory, so any remaining
HW touch will UAF.

If it is not mapped then dev_list is empty and amd_iommu_domain_update()
does nothing.

Remove it and add a WARN_ON() to catch this class of bug.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 3 ---
 drivers/iommu/amd/iommu.c      | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 05aed3cb46f1bf..b3991ad1ae8ea3 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -578,9 +578,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
-
-	/* Make changes visible to IOMMUs */
-	amd_iommu_domain_update(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e53ffb86c3d09b..426aecacc63009 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2260,6 +2260,8 @@ void protection_domain_free(struct protection_domain *domain)
 	if (!domain)
 		return;
 
+	WARN_ON(!list_empty(&domain->dev_list));
+
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-- 
2.46.0


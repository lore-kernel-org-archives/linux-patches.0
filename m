Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22991B3B18;
	Wed, 21 Aug 2024 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261859; cv=fail; b=Vn/2/05Im+lLq3qA0X9LEjT/906VIOtQHJvaiFAA3fPKbGnUbZ4oxwevIn0Mqheb/KuJuuOMQcUSs+1qXr9YWgtu1gMLYGEZM2Gld78ffXLg7iSlKi1VW4sdl+H+evGt3nol1PGAKDJywwj4nUe9Chiqz70rZ1YS4f7K34irwC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261859; c=relaxed/simple;
	bh=9oBBsZAp+QHrDaFQHPRjnJWMgcVi4l1fZhvdx7z0L3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cx6qlS0M193yjZzdSa+KHuZHXbDLm5HynKVXe5HXNEypMxetNEligvD5Ytd2Yp5Z6euYmSkFzWyBw+H6LdD7NNC/yxxjq+HaZHMMptC20+aiEf2ro+5sqLyL2yx+33rk/ezadN937G1tCiCi+X+q1G8LW1w7En+E7ceeLgWTFsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kVJkTP0G; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kVJkTP0G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r/uNchuBntWDn61Tkq0NNK+REntCn9ChiJLBi1Pj77YPO4Px2/dfFjP3Gx6hBN9m5f6gIlDIaItOhGkblRpoVcmt+icr2FeHQsSYods3Wr2I8nVJfDNKan0OfbElszs/UFKeJ/nrXcAHaBigpSdrA8BxRGw7Z1QF9nBPKdufT/gBROYg/pxF+J3gZ0apjHJOyhDpnzfLuoP2cvnv1DTPR+m1HllxROpWFZ2n2xvNVvDIiBseWs6P/u6TSqJOujvlgFgUtM0uPDOfV1OzJ5o5wC12AS8mGUJgVCz3rggAQSuDR1da7TJ2WQgPAeR7iJfl9csqkdAaKpdQJKc1g1jUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOCtjPUC2OPvuUdYDKPQQE0HHFNh2fy7h91zQgvbWC0=;
 b=B0fiJO23or+ed11bM54z3Y8Byn9X6Y6GU/Dc3tRIyEX+M1qcxXrL430ggyACJZ4qvzDWKGFvYc4ygDhrcA+3lHorvBMQ1dethcPKaeahoW94zdwM3h/fN6bd+No8r/WICooAzFP/r+JqMjAX+Nb+yjlYL+kWit52JVZHgNR8HEZ4Vaverds69SkFC76GOMJlXhNWBOIuZAPExn0mIK9IszYEZQHuSXEdvsmcyZWGb5sO3lN+naqj4sJTr51wglgzm751UM2HLsCeW1KYiFChB52RtJodTHQfgW+B7mQYm1eeILN9KJPGFXuOiCqvd15NjOu7tMsJIzzoOzS76ORbZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOCtjPUC2OPvuUdYDKPQQE0HHFNh2fy7h91zQgvbWC0=;
 b=kVJkTP0GkZVm9f3mIS7IMfrEaYuzuOeGRG3vKWrxpuj3rxSNEvFXgbFsK8IJlfVMn8cHvYIAliN6txWQGEM8+urGDYeo+t2u+i7PjLmJp6nyZldIiQ2sOp8YKN5DCvqUfDBfewJJRRQJ5o/bPyGYWQPyomOVOAhd+Uae+zjENxqTuqW3KYngOKcZg3gyjiFhefo1F2DIDHaYOOmzECnDC3uBSFul3L4jf7zmeWPp7P21FyZou4BuW2yVbnULcE0QvAaOYgiIvbfZZ+TCwjQEMZU0gUE2x+MS14nyzsA3JhhaqayoB4sd8SphFB9hCCoM8Od21TWEysWwwW9crp7mRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:25 +0000
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
Subject: [PATCH 02/14] iommu/amd: Allocate the page table root using GFP_KERNEL
Date: Wed, 21 Aug 2024 14:37:08 -0300
Message-ID: <2-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641A.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f170e68-d91b-4f62-d5a7-08dcc207e9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5fTvwHRyPlJJIh7/cSALxppBA/dcXoKdgeF6tTnkb2shdOL36w2PefGcoVQS?=
 =?us-ascii?Q?V49Dn0lvPd5s+a7orKLz2iqIF1+zc7YlenFz+/w5jmOVD3/7GtZ4lXWuMCHW?=
 =?us-ascii?Q?AmCDaj125tAJarDaepd1dR/S5PcLLJICd4pI6rS5hrJECLrO7Ld827F9FPPM?=
 =?us-ascii?Q?LTQSBQEkjoYO23WGdGPTO63cxizmeVfHsjjYBsL5CCeSAUdm7DiZaZKU+SG5?=
 =?us-ascii?Q?XDIi8gbpOqmvG5K61PCThFfdq9pgwNePEvBAuFapCIZnJ21lP70RK9q2PWJ3?=
 =?us-ascii?Q?JqE74Nt6x2p5V5CDrAatKWyofdvsQmjVPdepmcnf3WqEQzzSrGD5XRlam2cF?=
 =?us-ascii?Q?sm/9TFL3fcjkeK7NGPbeESx4p1redtgoh6xAmK1vS9A5g8Un1Ntec+/wtClq?=
 =?us-ascii?Q?WTropeUOGWw9pWms60RdRGUuS4wCtzZ4fd6dzEYUO+F+HT07QrZIaWeacGHD?=
 =?us-ascii?Q?oBCZQ6SskdKMjuG2rPJ04qXXZ6pDTa7QDBMuzoHR/enX91AkteJo5D7rRqUi?=
 =?us-ascii?Q?WRVxtNITyIlyfa3/gIIGv3ABAJS9dWktg/WGRCPDJD9F0TYZDGyc9/fj/U8i?=
 =?us-ascii?Q?uc7THWNwGJLZ8qaLr8KDsQKQuMu1pF4eDGnESX+UlwABZSrSVyEKjANRd2Px?=
 =?us-ascii?Q?/iYkH4Z+w56Zd4otL/W8yHe8JsZOcLqN+UQA6Ai1dxC4NrP71b2YRiSOwmeg?=
 =?us-ascii?Q?riZgBdVx6KQ0+I6bcfXLMsMv7bZDHY5/8JT1nYldjNd7hQKxn784EpygvvoI?=
 =?us-ascii?Q?x8AJJKAgtQk7YRzVB9o0yZViE0Sw+fFqwJqpTNTrXgC4d/qasTdhdut8P9u4?=
 =?us-ascii?Q?C+NpxETdaUuVbP0UL2TTJqd4TkDZ9vv3YxcAqXCdWWTBzRM1/DhGGE1UoPZ0?=
 =?us-ascii?Q?2pqURM93zSBL3iatFD+J6ES22MkmSTY+xvZDBhebBUXmPFqtU539SwTywSME?=
 =?us-ascii?Q?KJl7tyXx15wj+NokemmueHFirGrgoveFT73Tpj8ZzVHKfM7fneND2DRjPJ5K?=
 =?us-ascii?Q?2jl15b9Nhv0OFFhDDPGinN2sgYslpm18rgy6qKdb3MWxdwdM/6Jf5GUkPwsX?=
 =?us-ascii?Q?x7MohvWzpSBXaC5UABOg0Ej7NZfaltv5RAvwYujd3z+xQ5mXc0tHR3zggFFB?=
 =?us-ascii?Q?FJe9pnSIcwvHHVAo4UZNLu2QKIPJdJb+hFfSjbMAJqQ2ktxzK+6vlwBho89v?=
 =?us-ascii?Q?9wV3ygJr1CGQxguNycVoJFXmDzVito+lb2xw5BbzyLJsJZndAFH1LsxzM9bc?=
 =?us-ascii?Q?p2eeFmzXf9FwtbDUmj92Ldbyu05/TfDBlQBxGev9txOAwNOxM4K0APSdDbMp?=
 =?us-ascii?Q?ROu3GxT0VeDQd2GBUYmlu/2JLi9nqVvYdHbik18iTyCfYw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3fHkr1w8KFt0fKmo5XV5+5FZgsxgNzymDnBHd2ReNehn/dPYswgAkMkK7hRp?=
 =?us-ascii?Q?KOoOrrpcW0PEuqDk3GgITkBseek/lfedavg5oOwYIcA3R+p1XwUQnX2QuwtU?=
 =?us-ascii?Q?Fu5kWB1q3S/1F7GZMDYTS0SBymP76XrEcjMH2V1+JdQTnwo5iXyzgA3+6mlN?=
 =?us-ascii?Q?qKAtqdA7tMlnIDeQnbMjYPFl47U4RLdzMf3b15qlugA2hJwt+aFESo6/Qdyv?=
 =?us-ascii?Q?dihZezEIhWyo4OuqAtfrlV4n58Mi/6frxVP66+h/FRWUvMGVwz4yMgaNdjAs?=
 =?us-ascii?Q?HmbOpMKUWYAWLvwnY2WDjgGQOzNbcOiKBA4GTVezrHzNHsVJIGwT/aOFkQMd?=
 =?us-ascii?Q?OY/UtyBB6PEn7tzJUoImbl2N58O7lIMfhLnRYrZv1ii2lcW7iPY0CzUOZGcu?=
 =?us-ascii?Q?MEbajzUI6ec3HuTqwdj4weIV6KNSH1+WyZ74vjPFGvitdNT5QqSlC97Na57T?=
 =?us-ascii?Q?LYuvgqEaihNULR9Q2Q5b44GcwEkpC/BbetitID2/lF2+0x0FUo2mYu9J6qZ9?=
 =?us-ascii?Q?7Wb1hHmZorgzsydG+8DvGen/hKf6TM9iSa9VPjh1Byuo5eVz4dDhfoIlIEJI?=
 =?us-ascii?Q?M5lAjHe7r/VTNJ9Qx+PShGvbpR8tBMAddxczu8ssB7SX5xEST5j+nyewu/0B?=
 =?us-ascii?Q?mTdeb+5A4As36vdl7ebn6FuVLUKJQuGqxen5ebtDvJfrOQOb8EC6xWVhTrwI?=
 =?us-ascii?Q?aaYkIjG/M2ExjtezvWU7FIMB54vqGz7ljZhhbmvmP4b5pWav8ZN4E8xr27n1?=
 =?us-ascii?Q?6qEO7LGmYgl9FVeH/9iXMJPb1UAtqV3e0L2ZSQ5A0MLF5nbKDcTb/2JMRdu0?=
 =?us-ascii?Q?0S2fRlJrNVK98EXya3DOvmuQ3IRjs3G48jvZXxqIoLAS51aWmb0sUgDJI6Gk?=
 =?us-ascii?Q?DIjZfxObUGPrcMnGfvdX3+X7GMg9BiOdUSO7tLXcGi1RNoNgh3UgNlHtA2kc?=
 =?us-ascii?Q?8QwFikrkN2eRpNb+gh8eFpBv7MU1ABJzRSAnsgYO+s1z+tuT10Vmz/DS/aYn?=
 =?us-ascii?Q?CZ1PkIgU6FmsnEAn4YM1DAbOUAdyCzoXd5Yv98DTOXKHUEGvQ6j6tN2P3XZY?=
 =?us-ascii?Q?v+7LC+dOCq/bROZrOS5ZopmYmov6bn41HhP0w2BVrORH/l9ShKRb5ScQtBsX?=
 =?us-ascii?Q?RqhXZSOJ6XbdxiACRe/BOs0U2ye04Nk2xhmP+j/c61G2UoLQjhyjW+EMZYnp?=
 =?us-ascii?Q?lWTm+16uNTxBlXfWG6NOAAbhXRhAtW3zw3DjAmksoQb1Jf7HQxSNpw3zMDrZ?=
 =?us-ascii?Q?I4AE6wVEzkby/rcWUAncOSvKCwFpnbyc8u+YpEMcb0AVlbtInXulDkKy+6Mn?=
 =?us-ascii?Q?0il7x4Wl0m8fS5SM+L7PpYQ/rCfeRDjwkOVuq41V7/BVEjAwnES/CAXa+JTj?=
 =?us-ascii?Q?dO+K8g43G7Bnt0fs3EDXq1Dtgdcg4k0pC+ZxBKmmcxOUfIhD2XySaHn37/zB?=
 =?us-ascii?Q?H73yfXI+O1zbJQPzcXxzdOFqUX/SrRK8sXSg6+Fp2FYxnI1NT3MPJY6gCWHN?=
 =?us-ascii?Q?4Y7ZTxqE4QZ4yVAfsfceHMUAV9TrajgmpDzZF+12peVgCe/rKKsC8O2sXioP?=
 =?us-ascii?Q?jU7vEFIkycYlYznhaTUeiGI2pFlTsbDMP69rxxfK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f170e68-d91b-4f62-d5a7-08dcc207e9c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.3276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQ0XEnLuZ4QEygiPp/Tv1cPYyg3pNbR02cN1aflG88Yl7XmY5YQStKU1UCdn5CCB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

Domain allocation is always done under a sleepable context, the v1 path
and other drivers use GFP_KERNEL already. Fix the v2 path to also use
GFP_KERNEL.

Fixes: 0d571dcbe7c6 ("iommu/amd: Allocate page table using numa locality info")
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


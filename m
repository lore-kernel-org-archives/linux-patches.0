Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AD982897;
	Mon,  3 Jun 2024 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453904; cv=fail; b=KjtRRQytCbNFb63NHSfpMwER2P00+A8lqgONGW1dlE1zN6HrzvEe0/F/OxhmZzOf/aLTzEO6iew9rW0ZsE8vRRKygueVpu7WZUFArWvScKOvsz8rjp8V+RRRfmYBOkhDb0B5f5/u2x3bh78EtCwrK9OjAAVZuR1AJa7K44Glti0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453904; c=relaxed/simple;
	bh=HxU8FpUAJYO7WlF8BqZrBTWw9ldoibXsys8ADXSFFKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a5Cj/6XaGidX6X1sZAs/qvrUdyqhDjNrKAP1Aj1yW9L/7PifJM6W7kDQFV93LqvyB4X2KXf7EjNUz6GAatGRVqEQK4gE67FylZbZZI0WbMLB79D7LDUpFXwx7H+N07RlSatsVdhuS9ztrKkSPxYrjg21t1jMDdksuppSTqyZ2M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VVoSKVQO; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VVoSKVQO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hfv+d0bC3SPVVcgH+71XCOF5DFzffxJKNTznWIcqUqX6abmYic6imbyi6kYWK257p+6/0/7OeKJOVg2hh87wVLqat0YuNvOncsJIEEkTYauq4FXABsy/6SSTD8UmlQt3H4PBIrrxI7SarWbZBdFAnrVUH2W8umIN9kyqpZt/Oar92JWlaJ5mligBKnBSE9Rp/02nJYFYD2bQkuMSYmIJLZ77uuIA+BzXMYCxaUht9qGHNqF8RPuTuF/jMq6aQrZKmAkGhUUPNIgvRpu0YszO9NGIiTOfaJUODX7NGHyc7Hyw5gOcQKyLT/HXu79rE1zxIqh8Q4xvQ74cFT4OQR9CKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXzG4GbzcN3hQJDnSoUtJkUFnOerBqj6wHti26PymiY=;
 b=MiYtOg6sglAsm5k2Kfy+4kRGMkBSdlWg17bHsImrbc2lnxNGV3dxI4hY8vlL03x2iMNG7uNDdVWTpjgUrTLbrAolGr1Rx8CFAJzOeubR6+6v5GqJc+knYyCJ8zYoNnz2kuRhDux+Km2+yQUDjNHkYPMFAyFvhT01m6CEuc5CIhzMhlRiesP7kkEu8Sjs8DtzIyr3iLOiObxRLcI/Ze8jDst5o4U0iSHarfs38bVXj2AyGlfSrSE2CSqVLw0GOJMU/CBqqG1ChQrTrA0Fqt26kLz1whpFBq6JXRdZYg6/M+3pg51efEuQDINLs/6mGvoPqahp+XwBGyKRUrqb/ZbA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXzG4GbzcN3hQJDnSoUtJkUFnOerBqj6wHti26PymiY=;
 b=VVoSKVQOqXlO710kWS4nXWnJyG70pGsqE78hFTcq69rdpRqbPug20Fvw6PGo8V3fNelMXJxWj8BpUv/7QaYU1w3g4qD+Tqbyu5UgQ6GLyvK92YIf7YIZiY84gNo4EjZVTns01ZiS6edKgiUf1hzocxWz+NdxZoPYztRAalm9wFsK7z5m+p0R+3ONlZkL3y06uwQBWWO1dAzcE7VYiAuhfxk8fji/7pdYNQBZKtonf3ztG5YAlD0cwAmSkAOkisylnV5qnNibdjdEFRcC2VNHiIXoA2rQxM7gzhOK/39BfVNs0ev521EKgkYbIEmyHElWIuyJmS2V6YvS51OOupWI+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:37 +0000
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
Subject: [PATCH 5/7] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
Date: Mon,  3 Jun 2024 19:31:31 -0300
Message-ID: <5-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e94d408-43ac-45ec-6c42-08dc841ced14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vC1wVQeIm0jkNte/iL4QZwO0YoKrXZWvhU3QTHlf+r9W0dTdl8jCxNTrAtDH?=
 =?us-ascii?Q?GQM6L96Dj9IISmMhMDxgYq52B8JOtJL9zllZYRxbGBxPRVHOxzJ6cAGYuMN4?=
 =?us-ascii?Q?9yaExImMsldX50USFKyJWjdhMEFTtd5IL342GiqcegIINmjXVMSvE623btPd?=
 =?us-ascii?Q?MWEOQtlmCv69oI/Ch6pwaf8MoQ/zUFNlNDrV95fB5N/L/VwpnVLz5xA22DVa?=
 =?us-ascii?Q?F3g+bG4a/MyISRLWiY6hyjBPCTgy+ltL7gIEDN8yAD2kmPSir03Qsfzbyym+?=
 =?us-ascii?Q?WrGM6TiFLx0m9CGu0sW6sqFc4KnVvQRmC/cDP/hH8PThd3LpjtnIxQaAz/qs?=
 =?us-ascii?Q?eprDGPt0cGTHXICIvDlXzqBF2qffGjlOBd3yB7BZIslvQ7JDAXlmq2Z5zb7M?=
 =?us-ascii?Q?AjDTxO5nGgU4NXth2EqO4bEhzSA87LaHPIQPkvUjOHHPAh+NLxan4p8rQwXF?=
 =?us-ascii?Q?EB7ZGrK6udPwu2UmeGgk1su8+6GKxkEvx4iRdDDsOUk4Rl2mRgjLrrjATKm0?=
 =?us-ascii?Q?C0vCt6nF9OAXOQDKHvkIcLGbRrIlahh0wC7bnlIGkg413VVlvyhpjqeCoT/O?=
 =?us-ascii?Q?WydW195XJp1HjU3GZ9OAWFJCz7vGruvWPajcV9ViUP2zPsgCryEHWK4VKnAD?=
 =?us-ascii?Q?xfIl4gSdaNrFFd5rgTVAKQ9u2ddKwqMEumWkkNzYqFkfThmSx9rHxb5SKMD/?=
 =?us-ascii?Q?gBsKcYuwf8aFD8nuXS5cOReiTzKgus92k6CHmUL+pngOEsULFNbfMYzWO0wV?=
 =?us-ascii?Q?2sE72A9zOD+2TGF2arAxfi1i1QnTPkw3ffnH+lY1TEJEZkCpeJ8SBaTZ7RaG?=
 =?us-ascii?Q?4oubry012zH4FiveZs92aLOVfb2jTnv1Q3eVaFUEfU8Smm11DCOExdZU8ifz?=
 =?us-ascii?Q?K/y5fnHFF+VRb/7ylY6AP0Lm0KRrdAWN7jnqOcqwphOazTsK9DhVGqys8T/q?=
 =?us-ascii?Q?GePd8Y7oMyMD1Pikv2JucyOSvBhOlPCh5bgLF+YrHjO6WS9CyefbFhIDir7s?=
 =?us-ascii?Q?UcZ0OUembXYqbQ6LpdQmRm1hIP6iFzFAAqHHuPSp3anfnh4dplPxkjXbtHMt?=
 =?us-ascii?Q?98aKcu4rUD6wcuZvK+iblPrHs5ckcfEO0svwRGNHn1UBHqZIrY5BCcLXF6nW?=
 =?us-ascii?Q?eDyCXr2fjd177eKmg5DPGwu6lEFTffGE+LAFCc+2WwpHRrPaQmx/wZuTtWct?=
 =?us-ascii?Q?fXRJPrHOINrAWbisIIattQMVHlbrmYjwQLF29AX//swUrYO+JRE/2Y3oXjPO?=
 =?us-ascii?Q?R5F6lX9y2lxiu1nD5br3N+UiQt6W48lOnZGnYKAI4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V8XWFM5xVe60TpkkUQdMfRqdKXHizymiB/guzzzkLDfisYQ8aF7hlBT8Uh26?=
 =?us-ascii?Q?+ORhgJT++2SGWMU5IVCdrJwLfhsILZL/pLBDzWVlcqpEIzcK61Yn0KISURxx?=
 =?us-ascii?Q?Cm+iIxCksLdXF2HOz6z9oLQMqSqqG6SvhJ3kPIXqA7zwAxcBN77V4Pt50H9Y?=
 =?us-ascii?Q?y8URvcZL6g+//z6DDC7IQZdN3jXTTi2fYT0Am3l3N3JBRSRU0pcsPzD9UGX2?=
 =?us-ascii?Q?6MblVne/i+9fvvG/A1peJxtI5JlBWe3eDIlUmB/9y2IsCEB3iqJFmfxDOe43?=
 =?us-ascii?Q?rbMl34t1ff2dZo4hUVUtsjXrLLMHCMz0lA2IE7fDvU0moBH906pGXNmjPFiu?=
 =?us-ascii?Q?Jcgrjw7Lp86tRBxSjMv11XgA41kO03Lvne+F5EUqzSHL/jeWfqG9l4gujNVM?=
 =?us-ascii?Q?JgdlpErUngNBkK4SHhZhtVSpFjlD/+18UOeuRXJXrQ2pEjwkrn9/Bdm5TIxB?=
 =?us-ascii?Q?8f6oB2GKHeE5S2pkNj2GJbVUbjuIOOnjyDZ/tmChLj6K+KF39FGsd80txblw?=
 =?us-ascii?Q?VCFQZwE1T4IFr0b8Npw7+C8aHQFA0kHdv11mwXnV4FdAZJgSUaoiSUz6yp47?=
 =?us-ascii?Q?Ido0gHvNrbpe2w0V4qS2lSSUbLePoSPCreyuwseaadEu8Aj8SMVmToKpyTzB?=
 =?us-ascii?Q?tV/1elK5Oe8htMo++Oa9PydH2pqbgrusRnbYBp4Uz9AU28+8xSYr9KdP32s4?=
 =?us-ascii?Q?Ki+aOvig8yA+5YOOqAK+48nhdwPjfprzax+NthmwiLGQhXX2qghcaiumvZyp?=
 =?us-ascii?Q?cjDcvG3kBqHWXmgjWmlpT/MGLchsNko7wCc4cnuZQw+tAyK2slEuMNdlQ62o?=
 =?us-ascii?Q?AHhENVn0WwTp05ntuEJGaw40ThtPnJSuL5Y5IVHPj5NeGPYgzQG2/V8yx/t1?=
 =?us-ascii?Q?FubQ/XuVa+VNMkBtTDsYCTQwsEk8RrxBpbNV6tdjsJFwd0k95XcRqOXY/hNP?=
 =?us-ascii?Q?OoS49bzIQUo3EFLD+/tfV+m4iSWdYoSm+pPV4bIcxd/ndcO1K4pT88IHJMwA?=
 =?us-ascii?Q?1JmPZycJQSUwim+sKkydzrfvHbBTtBzG71Jtv+X7P35nIE88oF3PrIS+4Win?=
 =?us-ascii?Q?XGkr3J6Tc4urj4x0EGWb0jloy2gpqewdKwVqb+aIfPfIOjUgFHko58rvVLbg?=
 =?us-ascii?Q?e8eQ9vxWPyYO+UWNsHSH5D12Dou9EGFca6/ZpDZldHX8oUtZodGq5n1x034A?=
 =?us-ascii?Q?A/1oybdKIvFfHpucev7SBxVT/KjPtSjeOxlcSo3WhzWNpTNVlJuoZFD40DSo?=
 =?us-ascii?Q?2hInMPzHqnZIrW7OZacaunS2yDTD2kdS+yZIPr+imTswTeFrdQdLwfxB0LeV?=
 =?us-ascii?Q?huwI1z3YQYIR7E5NQnH0Qf8o2Pc4KAoC+/P7N4o6ZMT0Am/ur9v/hFmtFLi/?=
 =?us-ascii?Q?HNEHE6NJP2WHkVB4Iz+h2AC80gJ4+LTGzIJc905tV5/5vOtc4A3wDTUwU4n+?=
 =?us-ascii?Q?9Sjnh1iA55E6adwoqUjl3qL5sFgFMlmFs3bREnrxiIhniVBEPA2G011Izzh5?=
 =?us-ascii?Q?0Qo9CrObImPmH/EHYvnvbucfgvSNVVjZINyVtc3XEdlH5FtVMT4Fv1FuYqxb?=
 =?us-ascii?Q?5yXbwwrpvX7KoVmrpbA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e94d408-43ac-45ec-6c42-08dc841ced14
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:35.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adZ7OomD5St+9LnnZSH3KZaTsRN3SagV/TPoWSqz2ySpJvKQ3N0Xzvz/8KUTI+7i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

The master->cd_table is entirely contained within the struct
arm_smmu_master which is guaranteed to be freed by the core code under
arm_smmu_release_device().

There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
called to free the CD related memory. Remove it and save some memory.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 24c286a0834445..3f2e0462433d2d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1172,13 +1172,10 @@ static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
 {
 	size_t size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
 
-	l1_desc->l2ptr = dmam_alloc_coherent(smmu->dev, size,
-					     &l1_desc->l2ptr_dma, GFP_KERNEL);
-	if (!l1_desc->l2ptr) {
-		dev_warn(smmu->dev,
-			 "failed to allocate context descriptor table\n");
+	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+					    &l1_desc->l2ptr_dma, GFP_KERNEL);
+	if (!l1_desc->l2ptr)
 		return -ENOMEM;
-	}
 	return 0;
 }
 
@@ -1363,7 +1360,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->num_l1_ents = max_contexts;
 
-		cd_table->cdtab.linear = dmam_alloc_coherent(
+		cd_table->cdtab.linear = dma_alloc_coherent(
 			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
 			&cd_table->cdtab_dma, GFP_KERNEL);
 		if (!cd_table->cdtab.linear)
@@ -1375,17 +1372,17 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
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
-		cd_table->cdtab.l1_desc = dmam_alloc_coherent(
+		cd_table->cdtab.l1_desc = dma_alloc_coherent(
 			smmu->dev, l1size, &cd_table->cdtab_dma, GFP_KERNEL);
 		if (!cd_table->cdtab.l1_desc) {
-			devm_kfree(smmu->dev, cd_table->l1_desc);
+			kfree(cd_table->l1_desc);
 			cd_table->l1_desc = NULL;
 			return -ENOMEM;
 		}
@@ -1407,25 +1404,21 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
-		dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab.l1_desc,
-				   cd_table->cdtab_dma);
+		dma_free_coherent(smmu->dev, l1size, cd_table->cdtab.l1_desc,
+				  cd_table->cdtab_dma);
 	} else {
-		dmam_free_coherent(smmu->dev,
-				   cd_table->num_l1_ents *
-					   sizeof(struct arm_smmu_cd),
-				   cd_table->cdtab.linear, cd_table->cdtab_dma);
+		dma_free_coherent(smmu->dev,
+				  cd_table->num_l1_ents *
+					  sizeof(struct arm_smmu_cd),
+				  cd_table->cdtab.linear, cd_table->cdtab_dma);
 	}
-
-	cd_table->cdtab_dma = 0;
-	cd_table->cdtab.linear = NULL;
 }
 
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
-- 
2.45.2


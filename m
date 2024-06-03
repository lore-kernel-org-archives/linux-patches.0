Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A11F9EF;
	Mon,  3 Jun 2024 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453903; cv=fail; b=YcDmnIxkamMOgNkJvK4H4Smns3AbgIxl7POCDjiTGceNiwCMLZkebXdhb14CZGrvs4uIJyK00LaaFVVkLRjppGtiWklaoQBAhwoS7zotZgD8UPOppAdLPdkm02Kr0phsKtg2QM649ePPPph0cqq/MIKRB6rCQLSvBoONscqSAcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453903; c=relaxed/simple;
	bh=4hk+fo6eUpMYNcVrBGSyuFyw4OOHvvU5J33WFREVAB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QFoEsemrarMjpP1SZ7/In3AE3iXWT6ygZZeZWra8sipcnTSYux09t2b+fqavs16+HKN+k7qVmSNJ4LnfEf8EJNROJ1PtnZS1ueg2JTWBGU4aw23gkj5PC7DjzDDKRBGjMtHaV7HU8qOmEL49XagYK4R2T6Axmmb6jZCGY08D678=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IimGIcz2; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IimGIcz2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EugQ1CqemH9InTPEPIo3n3DR7ZlHxp2FfoKEqhSeJiCSm0FQ8I00IMWQ1baxo0T1DV8Y6cqzvfuL+dmjCaWRnnxmYpmIqw/jthLUwJAL1Qu+BuPyJ4rseWoKNqzye0UGvrKjlCgnOqnyLLOPiaPTteawUirT/aehZOhgKIgOMfAJvnl3nJMDnZ94BAxBcd8ubp7GPv7vx1d7WZpOa66xnXD7DUkU2aXY/OttJgUAMIQdE9sXR7DOUmxTzZ8V1fOYqwDBoz1zsidDfHucNP/LPxM5Zy4jIjnvuE8BUA3CPZJMMp8zxieYvoI0yD2dvaxmYV5XUM+LSma8JZftpNg87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8S5BLU9hmD0jyUqeJWwDK5uZDH5e8UMpl+jedlZE6w4=;
 b=huHF0crF2CcatLpxKwduAkAVyhTzKvP/mEi3wSOG9QX7dTScyIMV84Y0HTj2kqW1PFZwBINHlnZ2CH8lCI/ZjGBmFuyJQAF73DLMaDK7IOfd8BMOW2hpW6uy5kHAGzc0piaIoJDSEu7nSzJ5faN9Q0a5hLatPrnYFDR9Fa6idLiI0HTopz87bZcNg6snkJgXws4uwLVIKDVxyUzzFkvsX4FUfISgv7s0dGDRLtKD4r9npn3j707Lg9HwJQodn+/8QEgE9HEhjbGiq/vuT2VP7jiFe9H9gtzDq1noGmDdqr07XGhuP/sQVfINoQcD3ydzNtCGyaMstD1qpT4+tYszDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8S5BLU9hmD0jyUqeJWwDK5uZDH5e8UMpl+jedlZE6w4=;
 b=IimGIcz23R3XH1VVPa1dE2DgfNPf8gK7A5PaSQ3cXbVoiWYCEfINK81H+9dIC5TUDk8um5CL2s5qcwYjRtn0XKzcmJPAaPEQzCVWh/E6wNPBCsIHNYE1EAsm2ZPC1iv+4zoek4Fj/Fr96pLvLpStOzw4hSda5J2/QGQaLtRH1hyz4sK+mon3rTV6FTYiFPUNL5zzjUfq9aYAITdZQBzNBufUHkJN5Wxb1w4Hk72o/EF8zbtmCWarf+3YM+C9D4jJsvbwWLndnnVvouh79XbVEbBRmT8X0j409YpFS8QorWIm9EDxh4BX82ZPh/F4ZksjiNKyfYnHQuJFggkQcokXsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:36 +0000
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
Subject: [PATCH 3/7] iommu/arm-smmu-v3: Shrink the strtab l1_desc array
Date: Mon,  3 Jun 2024 19:31:29 -0300
Message-ID: <3-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e33f04-5d7a-4d87-bb0a-08dc841cece7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2dQEZp0x2V4vcVVNifuibPxqOnu2yrSSIIemPhqQiT47fwUHFzxhC2tzUFPf?=
 =?us-ascii?Q?Yuztyxu7r9660J3tegTu6mV/do2PRSRFRY0ABGN32dkEA470UX4y7621einx?=
 =?us-ascii?Q?qNaRNxFpm4IsuoFHCmSDz7+A15yFmfzy93mKtySOIc9ruAY/YoCM4mY6d7pY?=
 =?us-ascii?Q?DTengS7PdvuAwOI+1P4ycZNX4wVtNSrXBVTATS1hfhTpiLqzGQ2Ymqo0f8q1?=
 =?us-ascii?Q?YQ8DtwEX7BBiXMABA/4bwv8J9EyX+OlirmhozVKHtAnvIT7uEAB+ICYHrDoY?=
 =?us-ascii?Q?7j32AsRBkh9uB3U7r+tNNqy+Rck3kvZAlGV3u7jWHvMxzWKcdqzV9tkwJFke?=
 =?us-ascii?Q?cV8LsTqt7Mr8JZC2fDYQRFVI9v2lPtCzO+UpFCubq+er+hvgc4e4M4RoZ84D?=
 =?us-ascii?Q?kXxPM7RZ/tSSn0foQ0Ie1GW34QacSChQsuIRJ0gVO4fE+/U3PliRDgpSTp6c?=
 =?us-ascii?Q?SXbntdVqP2mus001Ur1+5pQjNx62/fvu3bX53o+SngjhSEnks4zlhOFDe+Ce?=
 =?us-ascii?Q?a2tR5KwqWGrI830a0p1DU1DusdrWGaNBNWPx8C40w7AUL76b+k6+FWF2qAYT?=
 =?us-ascii?Q?etEVgf6flHnsFZ6KnYi8WoPywe9j2futZAE119H8Q4dVa/Uh/6R2p0aYNmb4?=
 =?us-ascii?Q?P2eCKiEjYC/X0MEXj870agKNdxpif6VXIYFCSTyMcGf8X3FHH0kTjPmTiIRE?=
 =?us-ascii?Q?+TYNwIjR4wqvEouixfVVtI93oZGiuYPVg3gbjU8lGT3YBqycu4nH1ytRKVAI?=
 =?us-ascii?Q?lARw9bW7J3qOTxhnwu+5OWv6it+jz+sFhjY7Iq43cydOjBRfrLKvLOcbSRDG?=
 =?us-ascii?Q?sGChJVHiVn3kRWNE3jp7nnzXMWis7OQ6X0Hw6RM4p2zCoHPi7/DgLdE+q0/j?=
 =?us-ascii?Q?9t0UGNyN2/Cc6QRfBwQ4SDjSfYSu3wFBxUdNJ+m/aVe4Wr8dhU//JBiRabP+?=
 =?us-ascii?Q?AGwFBUbXFITSyXNQvAsir9EhduwjXAKaSg5ZLA2fpkALZ70BjPSTDgEbxmt5?=
 =?us-ascii?Q?E9eJVISUm+qf6jqeII78e2bN14PGKkWqrlIw9YwTOO7+SJWBge1GAh7YUBh0?=
 =?us-ascii?Q?0Ouq4oBamkpbdjI3TdUdwOxtcwIxzQh3VfGxTw8VWTj9Fh3vBx78a49lGAQU?=
 =?us-ascii?Q?0b27IJqEeNJztojxTA+7WVCHAULu5K2vJYmV61qvb4C9zeRHw7Q6GVTUpt65?=
 =?us-ascii?Q?6jWaRVQ+ipxW8NJw83mUp8F+mvC2rAhbzB8kqPPBfc/oae1q4AJnm2RXML8o?=
 =?us-ascii?Q?tLQ5/tEX3ETU/E2Q++00EFy1/m6NzoFH0o8doDL/7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c0STayKahAXx3E9yGSUdKEkQ0YWFo6LAdESLFjgsMcqCTHPD69CCWnNV81JL?=
 =?us-ascii?Q?GlgJKfdQ7f/PFhEkvX122avXDOJHG964rSPf1/Kvug5p4egxppt2L+LXoVEx?=
 =?us-ascii?Q?VU4DnUVb4IYyfoX/r072UZmHk6bMoWOWFr/qG4ihwxW1wJ2TyyA50dLlOWwH?=
 =?us-ascii?Q?TVwRQdgUasIVut3HwF38kWrBC5GUaIXn7Ir4740ndQa9+9l0okgH5J1KISKE?=
 =?us-ascii?Q?rzf5SYZsR21UyfPxfajRRELg4K+Kc15CyCMst6RlvlI6YhRC2/OZ+Y9B+4Na?=
 =?us-ascii?Q?f1RLhUlJBKUQDOHExlda/k6dpnt0+pd3kqCetSDIO8eKVJX0OepMI3PDWPtb?=
 =?us-ascii?Q?FsXTeK9pNdcGZzoJ/tIT8cKfb0KwkinQ4zxpTFhMDprE2UFFRLAfibB7MOZz?=
 =?us-ascii?Q?K0m98ffN04QJ2A3sOPhERzlWaeALVCJojhU/RGD+2/N+JKTYDjbuuncLliZR?=
 =?us-ascii?Q?VuAya1WeJNgr6sAopggFmn2sv1umCcZ5ySNo2a8VKD4iQZkztbPyZUrQcYH3?=
 =?us-ascii?Q?D1xe/IMHj1tb9CR21opWOj2lM7cRw+r2akjJc2uK7f/WlBrB663EyJT9rX5v?=
 =?us-ascii?Q?YvhhfZ2VJm+hdmKIKT+FVUrQO1iLvWs90GNKVKSaJ59tnevSmKSnWFjRsE3o?=
 =?us-ascii?Q?PZHZxhV97uSkdJhw6cwGNxFkJ7eJpKXnHMA/NIWHatpBYG7tfdbv5HZmW499?=
 =?us-ascii?Q?1wYZRem5Gr7iqsZyvEoSeNuomzU2SX0m3jGZabTVXkt+ehmiVKpDfKxAC3PP?=
 =?us-ascii?Q?dkIhvansJ7AFChs+aL61qR+zpKWbUQ6bPRQhyI6nZYjqa345BITmUy2uz5Bz?=
 =?us-ascii?Q?y098OlPgZuJGZREsK24WQke2coKz23grH9w+j8KyLfTi9YI8lHYCeCvFS6iF?=
 =?us-ascii?Q?onm+zIuOIDsf6YhjsdhkOuLeKob2ec51xm+Y+CoiVzaUFEA3+eEqu1WWeg7x?=
 =?us-ascii?Q?HOj5YRULIe6JSR4vnl+GlwKzuY/hxwaRhFrYcErhMP0sdRnHvgz5dWBhz1zB?=
 =?us-ascii?Q?2IDtis4BeFrnnJ8ah3FlqVVTdmIO/GcUydnx1iT2RVLk4gMxT3R2tY/5x6Fe?=
 =?us-ascii?Q?/q9JuyMAB3XwCBvEwotBTb41sneSD9/5K3455xA0VmlJTdRj6vJpECPezXAe?=
 =?us-ascii?Q?WfisShvRSuwY66SXbNaVmp6sJUqgPRdAORlAmiNcL+HPO+2OlPJMWyPSZUF2?=
 =?us-ascii?Q?T613JK1T571WY5XcWbJmZNjiKrKFOl6Hw5n3pfk6a5rHP5jKX1WvsyZPaDyO?=
 =?us-ascii?Q?ixB1JHeQxJVGYIBr6jD7fb/JelDTnWh93oAiOPkRSNIJZ3DtIgqk2i5bys+z?=
 =?us-ascii?Q?ftToc7hJid4bPKZmUCIBocZdjuxQED7L54H7bGBi9azRshgnKlZWBO9jzMOt?=
 =?us-ascii?Q?h1+vkL2BTd4pSFBHPXvS6XkrbHCApMs+JWbqlfErh4uPEQKu4FEHpwIFexqy?=
 =?us-ascii?Q?LmQoJrPjOlhNZDxBA7TjvxjjVxabNyaCqDfbidNwkOCZNeuasbQsuUEzmd1m?=
 =?us-ascii?Q?nnSHJj4kB6TrsPK5UBz97bGzGD6p0wC9KOr1Xg6yi1QDpW3vLVwLF1bpfF6W?=
 =?us-ascii?Q?MzBVrEJG/60p4XyEmvg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e33f04-5d7a-4d87-bb0a-08dc841cece7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:35.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvniJDKCxnY8uCnl95IXym2PvZf6gX7GS5hCGxwfBdoj6dbuekyjtlX7t8ArMh8l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

The top of the 2 level stream table is (at most) 128k entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (1M), and one of struct arm_smmu_strtab_l1_desc which holds
the CPU pointer (3M).

There is no reason to store the l2ptr_dma as nothing reads it. devm stores
a copy of it and the DMA memory will be freed via devm mechanisms. span is
a constant of 8+1. Remove both.

This removes 16 bytes from each arm_smmu_l1_ctx_desc and saves up to 2M of
memory per iommu instance.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 14 +++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 ---
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d27dd0600bf1df..735dd9ff61890e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1448,12 +1448,12 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
 
 /* Stream table manipulation functions */
 static void
-arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
+arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma, u8 span)
 {
 	u64 val = 0;
 
-	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
-	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
+	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, span);
+	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
@@ -1655,6 +1655,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	size_t size;
 	void *strtab;
+	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
 
@@ -1664,9 +1665,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	size = (1 << STRTAB_SPLIT) * sizeof(struct arm_smmu_ste);
 	strtab = &cfg->strtab.l1_desc[sid >> STRTAB_SPLIT];
 
-	desc->span = STRTAB_SPLIT + 1;
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
-					  GFP_KERNEL);
+	desc->l2ptr =
+		dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1675,7 +1675,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	}
 
 	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
-	arm_smmu_write_strtab_l1_desc(strtab, desc);
+	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma, STRTAB_SPLIT + 1);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4769780259affc..280a04bfb7230c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -577,10 +577,7 @@ struct arm_smmu_priq {
 
 /* High-level stream table and context descriptor structures */
 struct arm_smmu_strtab_l1_desc {
-	u8				span;
-
 	struct arm_smmu_ste		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc {
-- 
2.45.2


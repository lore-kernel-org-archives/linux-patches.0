Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D251B2EEB;
	Wed, 21 Aug 2024 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261857; cv=fail; b=eCZUvlZsINpSUyYuifekIhnVyuz/3Uthg7y96qye0BJaWL/BBL0flrzM44VsXIsrE5rz2evPcfAmp4QEhEH7mU2nyEaA7cSXc13pM5woFwlFX0DOEgii+fAsLRR0aGVNbWy0DC/dAmT6y2SxrenTHZco7xk5KrfS6/oul6cUFqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261857; c=relaxed/simple;
	bh=iP9vOGna3CRnahFqgSLbZb9J8XvB+7c8U3wRPboBh/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NSsFhMiy6lrOn+RXDkSzqxHMcKJAvPbEydV0DX1ZDVG9gAM24AT4BTF21yRWn5x4MZd+xai75dOt/UU+Itp68BieyPKCVg2fiUSZ1RcdrRhaNYd5xjQsWICx6fI36BgQsoK+lgqM647rMblxORuBkJGpuDwiyrCAEezj0MBp8WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PJSvNaAF; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PJSvNaAF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BUO9Kh7UxVrJqDpyqZmcSXMZ5M2O1Si0QAkLWw6UVhGX4f11qPqX7T9a1LvaaISbuJskOCr6IvVf5FvupbbLR6I26A7o4vD5SoeGVb9uTqn357ac/YLEsHzzcDjXOntDSPT2rlpnXLESFe3coksnCLFXVzQ67t1aLzom5aqUS6l1ytnOINosWHZ6TMJ/odymTk36KR5/TbBx4rYxJpHx0EvrR9HPd9mxLzs4DIBGBVMuqf6MsYIzk9Izo1yoehBwKPxfZ75yL7vyoqwdHOql+Bt3ct+Sy5DxPDZ3d+B7Vef+BwvF+p30H8HDdpgsIBTfl//nzJoZtqmAUr+iUzXZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nU0x/BQVdy3XDLNGNb0FMhrzOW6taysNI+hLfvjQUS0=;
 b=tfeTAa044zYI1+14FotMT5hoWoCjJSEwF9ORlalVRezjyWQtt7cEU7F8DdlUF4nFSTgPrycecxK7M6qelArsb9AUOKTY24vbVuJeZjgnNWUGTe9Oxbl41fzGlXOLVu6Ip5wq9TTsSCGq5IG+3bAeBrPyiHQT6UnC3GElIsRHdF/SgxTcyhu0Y6gL8rIorwm32EKqLmVwSyN7wM9jlaFpgNjWy9rUQw8dot8M/lyn3Fj9GXTtyXDQAdnD69pc7YCNEJfSZMQTcCSYQT+tiVHlGRS1k/KvAAltIg4do3N2GWw3Jo+mLeHK9cW0FgWSuSXhsgIhyn152gTmbURwOsQmTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nU0x/BQVdy3XDLNGNb0FMhrzOW6taysNI+hLfvjQUS0=;
 b=PJSvNaAFIrGHEIbRL1nE7rTlP/Lhw8jN6hytVxoXG00XBZsV1w2jQWnbLyR+7aPgw6lLZDwzDoCU2UsrsgkJmV7JZ39/KzUPWM/UeTMUkO6apOshmxJ3DwrJLm6yw9eF2aYi1hPUWgyeeS/63SggWxUsBuZccjUt0avyKqu+RVGuwhUfF/nL00s7cUCPPMzNLZGl+Wjf/xTBOs0koQ8zwbTWx9snrMp3SQRM7t//8PVHOPcRvuvviPSPoxZ7BKUScF4QhL8ErEjN2a9LMm8SgQ1+ZcKc8z9ytOZ/6LMW6ar9qMFT0gW3LXBPglC6JR0taBPlnU4AwcKSlS3x5L5QgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:23 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:23 +0000
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
Subject: [PATCH 11/14] iommu/amd: Fix typo of , instead of ;
Date: Wed, 21 Aug 2024 14:37:17 -0300
Message-ID: <11-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641C.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 1180e2f0-d502-4f46-42fd-08dcc207e990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dw6boJNHfSaX8pVSzkXlxBN34d6lYVfIbLOHrpXOqPxBPI07w8jDNMqL1Vlu?=
 =?us-ascii?Q?617oFT0itDiBrj0GmPEpozEaExwxSi49IN0q1gFf39gppGYa5vnHMmEhhCKz?=
 =?us-ascii?Q?Tcy80L1XdPfP75E9UvISWWc7cFo85Hs5Jjiqc7pvRf2ZWqvKbqRqIq6SqeUb?=
 =?us-ascii?Q?eruDlPa7aje6Q/YZpbp7YY6OJHGQ9Mq3C2fK5nfRCoYDZ7x9myIHwoy+Tw+1?=
 =?us-ascii?Q?Mp4oV/Vm6JHvX+DqhuwpFXWTBOVXw8oTMZs2kSlHBy+dGXkmofyWxvFWyBKW?=
 =?us-ascii?Q?79+qV/O0jIeK1spTLWJuHKVTSmJiaDng7C+DTGgr1xFGL9pbJQ4mpZQC/xlS?=
 =?us-ascii?Q?xm2UQcTUL8Y35AFxzmDfu8NFKCvB6qNDFLo1AOp+VYkNO6hom8VDXjoYb+bB?=
 =?us-ascii?Q?APfIlfmAfzKxiF21tKY36P3zSqA3lVfnNCzftrTFayxdiOHt4D8K9JgObZQi?=
 =?us-ascii?Q?B5CeHJ+6hU50awFuPz7Enh+hh2wswDZD6TWjY7RVUSQ24CnD/eOYyQwV5bTW?=
 =?us-ascii?Q?JSsdlvw7SVrlI6P5BGwuZg8XkFU8JLLh92Bn2Jbp8Sw3Y3507MVzDoCu9Z8k?=
 =?us-ascii?Q?ihgwki7l/qqFf1oniainccQODkUHhoW9IlpllAn/TrELiF5GlLnKIbPL/61m?=
 =?us-ascii?Q?ScZKWFNea2pWfxYFcvKV5noTORnSnYfVK6AAaQjD22bnrNgb0gD2bOcgZJS6?=
 =?us-ascii?Q?TyW87IC8zEPWyTGlyD1xqEZi8tVV5QSHAIJrQGSHvWRPNDHEtpxcOsGK9S9G?=
 =?us-ascii?Q?+wkGKjnm23LB2QbtQ4rZdSuiuszheN7HW3ku/ku+OM0y0oOSCILsD0njq4cu?=
 =?us-ascii?Q?pB4yUxlRbXtuwegcx1Nd/60bYUtcY68YimkwJwg9z/aOsmk0k6fvTsLBbcV1?=
 =?us-ascii?Q?tGXIOssnTwIv41GSaP9JZ3M+PBZC7dMTd6t0mC+NZ0wjJUIjmDlFtjY5IctG?=
 =?us-ascii?Q?Lmv4+oFAcMgsRBdaIipjOFNAEiubKZPNyoOTQ36dLlnl/m8fkOdQLYKUn/BB?=
 =?us-ascii?Q?dm2azDlj++scifdVP1m6Kp7HFGD9a7z50+ETeh+MhFRrvWfSuQJw+0oNbwn8?=
 =?us-ascii?Q?qHd9Uy9Xw8s97lExGB44CFVe96AVlopsb2OUkbDvIMfgUnsYeZGWFtBPZJbG?=
 =?us-ascii?Q?qYk66JxZNTqklQsGfYP6vajq9iIaHDOrsDIvQCFtLMk+E2n5y+slUWc1mzQZ?=
 =?us-ascii?Q?6RTrRXlV4/DfI0NRWCFIIvl2kf4Zsg3Bwh8s3Rz0Seb3DJcX/wx9R6xZUHrZ?=
 =?us-ascii?Q?CqydcVjHVT4lEHBeQGdConisu+1DCEF0GcyOeyBzKPbAF7Wtbs+dA1I02aq2?=
 =?us-ascii?Q?e+KacGtAYQ0jBSY+eg7z3l4Yo6wdKPb1FGF7CWJOEZ8buw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TAenq6ka9ZjPtWrI3Mq8XfN+V14/3qBpH868zQsrdF7GitfSkkxrAzvX4/Pd?=
 =?us-ascii?Q?mTtnF8VAcFcr9qapfRbk9dTWo2/WAx3H4azzybDTkhqdAt3YkV/55MnqWkgS?=
 =?us-ascii?Q?VnmpQ6G7nV9P2jQRLk5holDPhDtoguT7J+5BS7tSENzjMJ8gCoP8x6ooEs0u?=
 =?us-ascii?Q?0qcV9loUB9dPCmGDR/n1P85nqrnAovtPyADPSp+a2ZfekKbY7p+USjYmuoDb?=
 =?us-ascii?Q?1DKLaPO9Em5r/DjIe7I1RP0DNdTvw1io8DFbLvcwbwS9+9Yew0PoVlL699aQ?=
 =?us-ascii?Q?18R9q4XBxgrNr7TZPtmH1Et4IsUjOQaDL54vMMOTw8jQQXYeZd/5JmheR0di?=
 =?us-ascii?Q?74SzAg28KGUwCz9zdbWrQtlh+62hhR6+/EvXPnLAKcNYdmn1FGwEyAL/P8wL?=
 =?us-ascii?Q?+2nR66PTSAUEK+w3gXhz+PobXSvPIo0bIieZw/+kvgzVfV0KHzDUhQnH/rWf?=
 =?us-ascii?Q?ZzyJ7trD1olC/0ytm6Mme+NTfFZDzEg/BadI0Jil9lgVMv6hbhlenMhB+lnC?=
 =?us-ascii?Q?X4DmNAkqODLZ13y5PqA0vbiAUDnHC61LU1xRRqe/XfOgH/bLVjS1GpnOHQuq?=
 =?us-ascii?Q?pswiaTOiY9K3ZYWhdRHRKd6+p7LB6qobxM+v5Pn8Xw52kgrL915thPhfqXVh?=
 =?us-ascii?Q?3dnwjLmsPSxN9Zjv0d3xKJdE4vGWvF3FjXsZJL+Vu3HWovjQki2KUmwlTZQT?=
 =?us-ascii?Q?npS1f7aVSpZ5z6fkN7Rh7x2IaNLhENPh8nfNllMQYVqP3paKjL2EJfxXMamz?=
 =?us-ascii?Q?dPi/nsGKnHtheDwT0Zn9pdpSKpg/JcltFBghtp+n2j3g9LXIi+h2L/61mrki?=
 =?us-ascii?Q?SC68Ej2Qt/SIGVVos54tEdlsapjoCX6s5owouO5vBRexbUesXlMxb2X9AzW6?=
 =?us-ascii?Q?sbv4phduc7REJLkvYk8gDXsIJgaU3noIrdgBAiOeupBNcDPPsbnmxIcnhQyL?=
 =?us-ascii?Q?c2dD4U6iqldIWL8mvtgszGGBnbJX9euvstr1pCp4piQKtRia8CbyD8xT6SOa?=
 =?us-ascii?Q?HeGvgTMQ7OA7Sq03eqMVvZbjjtP9o/lNgemCaXJ9TYkmyidaTv1e7O7m/Xvf?=
 =?us-ascii?Q?Y1EtnvluammOYpD6B1V8jCZUijucsPrvM6x+rSx47dFSpbZZeDBbT5Glw6cP?=
 =?us-ascii?Q?VafN+48NwTy6ff/nUQqPPIjbqJgsmB0E9eZ1qNpx3QN2JTfK0iG4U4LlVEEg?=
 =?us-ascii?Q?uAQq322HKa0+VVhV7er8r9IEZfoUfwowCh1Nt4SErT5JqZwZpmSjrcHv88Ui?=
 =?us-ascii?Q?CsJ6jOr/toRTe8Ba5QWQIKaBOTfiFN8yDACxGStdhvp08/iDXC2btidTQXpB?=
 =?us-ascii?Q?lOnmBmk3n32cEKbODTjwhWR5agaMJye2j7M4WR/kd09YVFnusIPc6sz7X9ME?=
 =?us-ascii?Q?DnBVqJYYQq1F59YTpDK6u/WKT0JgJYvfhMgpPYTEpF0kvRcvUyMVI++nIGUU?=
 =?us-ascii?Q?FbbMVPFm4qU1V8cKLSmy9ogoyi+dGH2VPMdn1+jkPXW+lSzwR+mYeKCps0ya?=
 =?us-ascii?Q?sT+G3XMSJr5OOT4lKDvsX1Nxv9L/FhToUZ6YJwFxfLEf/QEcPNYA7BEVtGHI?=
 =?us-ascii?Q?n70VsHmyYJ2k8G7w4zriE3sNR/nc3BdIbTBrhB1R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1180e2f0-d502-4f46-42fd-08dcc207e990
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.9755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cY6O8wSLrEye/lUcjCLM6jT+tQu11DFa6cqnyozTrAPQQk8koe/0XfFR6YvjINWy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

Generates the same code, but is not the expected C style.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index ed2c1faae6d580..910fe1879f3e41 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -375,9 +375,9 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->pgtbl.ops.unmap_pages  = iommu_v2_unmap_pages;
 	pgtable->pgtbl.ops.iova_to_phys = iommu_v2_iova_to_phys;
 
-	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2,
-	cfg->ias           = ias,
-	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE,
+	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
+	cfg->ias           = ias;
+	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE;
 	cfg->tlb           = &v2_flush_ops;
 
 	return &pgtable->pgtbl;
-- 
2.46.0


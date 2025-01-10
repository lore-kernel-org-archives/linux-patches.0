Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B6207E1A;
	Fri, 10 Jan 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526913; cv=fail; b=MKsHaDvvKcUwkpR2WBamq/8EpcX7RDkJt+aYipMYDLyA7iKUiFEG7IaTXyKrZNi+67WWqiU/FPbZ2rLa/FAGDHyNDWgO76zl+BmtlTYBPKa/KStp0+mXHaTZwjZhez5CjdV+EXv+Itbuq4IwyaHOyaEUPlj+7Je1WA8QYeKKMus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526913; c=relaxed/simple;
	bh=qIY6RfDYxlsQAXXaQozsEsmHhEhPB9M3MYI3/L5wu1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R+lhKSsnipZmHIRhqw7q5FqN3xC+BHGthm10M4/OpHYcNAVhS4H5MSuFJG5/iXIOPJsF2+/vkjZUCrIQcsia1YORRz0ViAIHuF0QzrjZywVlGtOnquCO6LGEZ+WMqWphVCZRWE52/Qt7002CTlz8Oh7XyOhlr+39016xN7TcNuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oBhi1IzB; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oBhi1IzB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuhkJxH968jdCUePF8qq6atez2TRrAEmZNmgkX7Du0Pxjb5zC1kT6g1XLNF5LUg+IVsr+c7ZLRherPqUwE8OM+UtBqxtmqEqLf6VWpqfG0HgFhjMBrhtrfOH3b21vUinw2aeqYJKz8AmgYvk6GaTuRokIhLJsqeJCH5q+a8SERLpiX43j6r9Ll1UMcJxyPeBfZr9sGaGCu/bgcjDZrJGrpwgiaUKhuOxsLGj9eUrGVvh1dKmNcGLXx6euCS/RHmsIwWXLCHNUl45i4mVZTp7OXZk5CvPEinyCYleKcF3bAEKeYXMDe5d1l4KphcEQ7EeMJMVxvPkbCKE+Cn94Q8nWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwvuEt3kQxzTfZdKUwZmfB/WRGxtKsHen/o5W+LSMkg=;
 b=Y0uPKPZaV7GDMLeIAhMDY0gF8eO7n+YMcHpxGQwnxNr1ROOrbeOr2W5XZl0tK9qsZpayNp6b3DGHSov02ZgGJdiQjyBhLiskWEyxdMqpHrMtTWuTPqCD/gGn2yyZ6HuvdaITy8YnqdVuypgmcJ+Yx9AozRpLxzrW308j+5PPBZKatxSTVeCVgAwjF8uT1rA0W8LZFis8M3Y6r0FTsILrjCNAz7UHYrRl4r7NdcTcIZdBCNpmY7FQzarD8yek4x7SeumKzzs1cDx44v4TFmsUmG8Ld9p1j7+A9Qs5QfJm6zS5nyWItJOsZikD9gbHM/wYUQp3U+iNrooiWVQYDn6PNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwvuEt3kQxzTfZdKUwZmfB/WRGxtKsHen/o5W+LSMkg=;
 b=oBhi1IzB3h5FqXK6Te7Nq7Y0+N1YwaywJEwJLLpD8M55jBfZz0nobTVLiQfJRwFAJuJrjCzpYrcdgRUakAreoRwJxikfHFlKVpl8dLuzWgC5eOkkUrLWjg3j57cc7hZOIwoqLKdEHqAYWD3sEDelLtOvRbXx7lSzCDJlyi6UxSNVqaiOfciIEofmvwlNVjaZ6fEN5CaXNPwOBZJTf0zbnusXxEWQEIzbeor23bQn+9eUAuxaQZJd3nOSkS/xn4Zta7L6FjqzvVNur/mKRVSoRwAFwIfa5nsxidhuwngPbQ0BJ1dPwgbTHDyrcqXaPLAoWCrdsnulJeL16Vv+dLbh1A==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 CY5PR12MB6036.namprd12.prod.outlook.com (2603:10b6:930:2c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.12; Fri, 10 Jan 2025 16:35:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 2/7] iommu/amd: Remove domain_alloc()
Date: Fri, 10 Jan 2025 12:35:00 -0400
Message-ID: <2-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:408:e3::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|CY5PR12MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: 07472ca1-a20e-40f7-b385-08dd3194bdaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KIefNDToYo5JGS3aG4vmMOreNa24jDcZ3S9rl80F5Z/fw2EvKRF65XAuOulP?=
 =?us-ascii?Q?YSxiDEOhYuv0YJ2tzTzw94v//cnB6RaxvhDq5iK53UlTxMXVgvEBF5sm0Jjt?=
 =?us-ascii?Q?V/lhi+gqQss+neFHpiUmPioC0ovR7+kbQ63XWyeC1MpVgWz1+7cDHt5m5ut5?=
 =?us-ascii?Q?jegBWDZesisRAOFOANT1oMd3wJc5lbX/j0iCpUXoghCBqmh68AXMnTy5uWJP?=
 =?us-ascii?Q?xmNIR19fZusJkhwnR54TcZgZcbrVZUPmtiW4goZVYmQuQOaaqomMFq+qljXf?=
 =?us-ascii?Q?ytZ5kLVaUcxy7GNgFItrnN6DJFqBfJx6vCBHdWc/BzTj4hbXJ+1suINEHBQh?=
 =?us-ascii?Q?m+L9vRIh0Qm30RANkma7MyKAZeQFHKNlPsys7P51j0Kt9ooW7afiCGcV1U9I?=
 =?us-ascii?Q?GupzWo4luiidEOok8fYcuhPoBP5X2sdiIRAa35NZegoKOHO8Z0FKaO1e8d2H?=
 =?us-ascii?Q?3c+ZJON1ZBhpU7wjfpOlcv7qDOFNlLlH1vmo7zMnV0WoqsaZfFL+4SFr+IDN?=
 =?us-ascii?Q?+fgenDEOH8VPXe3nYRPDpzAHe+JUx+qGNUNo4FiLKdGjkB/AvCkdCx6PhuTl?=
 =?us-ascii?Q?eoeUne6m5YavYTeNlbU8OPKA+ffkRlR60ZEHQ3TQMCzQr8/aB4za48gIi5jR?=
 =?us-ascii?Q?6YScVO7uiu6gosBLSTXq3xoATj3lGPq9qWLfJyopkzl5igjufj+f1kL10aPo?=
 =?us-ascii?Q?hlLQItG6p1ilvMvP8xM+ol2/TnjQI1fgwqg0CX+iYq+QLMFNFe3rNI45Mu3i?=
 =?us-ascii?Q?IRBgcPOaJrv44ZX4hS0KJsgEvIPHoLibp2pxAUDaCgobODiuFu39VGZmg3Jp?=
 =?us-ascii?Q?IyBa1awy2q+h/3K3m0kVr5znJ8g4NklgPdh9VxH8PPnspJ55dycJnqYjL9g0?=
 =?us-ascii?Q?Qo21MtLFdTNY0a7pNEET6NIOiFhIxIiBwbOWwjP36l5azxnsqBClERmbG1K7?=
 =?us-ascii?Q?TBbsq8tE0l1fpfEu3kpu1hMg51X/mFHCKRwv4PMny9w7Wfx+ofgaHdEG7wTf?=
 =?us-ascii?Q?WGnI8ngFRf/p11fa9Bi16I5KSV7mjHA95t3lqkTYNxx2tD51XKAJXjBY6Y32?=
 =?us-ascii?Q?nIe5mXsQnwXuv6FUzBKzg2bzkF1IBPPTINOl/bCDudG9w8y8KGjJasqBgWwp?=
 =?us-ascii?Q?qs08qdyv83DGsLGyekiIhB/d1gokd8Mwd+GvImjCYDfNKIdiHbHlX/X+kLjy?=
 =?us-ascii?Q?LepPuGAJjgX/0JMp3WyMpGos4V3yyy9YVlake/1YeM8fxeeDspkWngTOjbzu?=
 =?us-ascii?Q?TuytmK6WFzb0j0a1Jmzy0pcWqLZclvDETNBIgPhSiIHj1cC+6t2XA7sH5X4l?=
 =?us-ascii?Q?+3x9MeUxZwpW7CwwnxrOmyutDIMB2up3jf/ioXotLRcJqRPjx649TtNdNc5l?=
 =?us-ascii?Q?ZW/PtRdOHeUcn7Q25PEiBR5y/LS0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a4zC5YWtOKJbFlkq9ZqHC8mNmK8DaU6haghMajg7WnspifV/7fA5N6HdHEF6?=
 =?us-ascii?Q?Pxj9qnEKTGoBsW6aUD4Kim6/SInCz1jk7a4a9PbPagt6UmAkIUJSa09gXnKK?=
 =?us-ascii?Q?LQ4lZhvL0hSJSDKddvfwAwhFtgehDTfVxFn86VRIdwwDkiBPFbtjJFXKIJe1?=
 =?us-ascii?Q?yphCi8S+4Uottvq/qEr4qKs4c6Emx+Y8am3aK3POIFtOfamY4hPkajpniX68?=
 =?us-ascii?Q?Ml+4hO2w3m8Y1+tWNVaNzO9G4ZitHRKam06TNVaa92rZ0K9oXBIYidKlCU/e?=
 =?us-ascii?Q?FLgMBMVWaUx9aRoIzajFPWufoqTHBUnnNtgdhWvPt5NwqxikVMUDPkGefS0s?=
 =?us-ascii?Q?IiqhWQTkWCb0v3Wh8rksyCYuOpp2/Bvwec2he3SgFmKgOqMqSMmdza2Dap5/?=
 =?us-ascii?Q?r5P5CAZhwHHyzHxshKJmUVpCmC61FOSI/SwdQDAlxOuG3PdNYFTU6ea84uk0?=
 =?us-ascii?Q?n52qklB9ILbuvEPD0pMhMTr5Xyplu4u3pP14o/fm9uAs+h0VAmIpusQSbZhX?=
 =?us-ascii?Q?pxiJjjhvAhWcjc+vrPGfR/MJveqr6vO3IlGHurqR/Po8QuWTEQcWYiSgnZWC?=
 =?us-ascii?Q?irXkMTeI3mqkRLtUIJcgxQuAHXl7TDSHbVxngmsrLyzX1M0yrnamuFH3vJX0?=
 =?us-ascii?Q?XyO7wr/U37S/qiBuy6ZXbU8RAhGsgmZp9TnKlCElS+SGrgw9l+JXY508R7Oh?=
 =?us-ascii?Q?fo3xLr8BrKTyVIf741UWe8gtu5zjpWgrY8FPPWwWvs6hzUQ4rd+1t7RiTbKv?=
 =?us-ascii?Q?irAfAercSy78ozQ0TRbyyFyxZmp6AKuiMolOsBPwj/b4zICzF2N4bvjfO3US?=
 =?us-ascii?Q?G3ml7VPGLLWHlmPvHWRdNjwuT1sGc47s7UaKZyqGvuNHxiKvFhllW+u7JK+u?=
 =?us-ascii?Q?OfNS9WcbCtNr3W3+8NJdM7qJ2hE2g/uDreCv/0r/7zVa2Z9QkauByZsicYz6?=
 =?us-ascii?Q?Py00whCrKjnpq3SlR5H6a1wlqSM78aOrtSEU8/jpJPp2I/bTin4BRhEMcJ21?=
 =?us-ascii?Q?x5C8uvaMxhuNIswpEyobY7eadubKbrbJUHkaV9/3Mrov2wRTGx1+SyiCWq7c?=
 =?us-ascii?Q?QF7zBVOoBsxBzIOpQaUHS5RYOuKDlWsJXVrkg37gmEKnq8xqleUJE98V7VtC?=
 =?us-ascii?Q?kCULM/g4UBX2rX82xw/RQj6OwbF0qAiUQFMDisKMUN2St8mPQDmUvA0RsrIf?=
 =?us-ascii?Q?XUBuf0CkSgsrgLuSRlDmQw35aoA3Aqv+SA96Ue7eESU2cECR0x7CPTl583j6?=
 =?us-ascii?Q?pRjgrzqxesLnXJdwd8t2k2Oz8E4mhpQ1OEYWsDnFxBMdUpPewfccvFRkxklL?=
 =?us-ascii?Q?ShwMkSWz1SsPaPCCFDx6XfEC9r6ncnA/hNo7l2eQkmzAexXPRQVyxAjSBIbu?=
 =?us-ascii?Q?J7F+ZsqqKBuHATbAYNqzGmPhIBkcd5h8Fw+EVp7DsttfmAGUh3Y2HZRDhJXQ?=
 =?us-ascii?Q?FZdfR0Rvj5yzJNTqk0R5DvQEx33GPHh9TMC9/kZ4omw0rFZj4DQm2quZRkGw?=
 =?us-ascii?Q?LddRqGHCMu+LGMc3m/jEJIMls18agv1eDkBEiGlLDf+A2RQGYAZy1PgL5nAL?=
 =?us-ascii?Q?nhmil2JDL/A0g31jsolIW5HYmbRYpmIWCYkSwkhc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07472ca1-a20e-40f7-b385-08dd3194bdaa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:06.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcgpxaVOmsCUsNMjkxgP6Niu6n86RNNbPrXjrSV0TE/VffyQSdazDNfSocOh10pN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6036

IOMMU drivers should not be sensitive to the domain type, a paging domain
should be created based only on the flags passed in, the same for all
callers.

AMD was using the domain_alloc() path to force VFIO into a v1 domain type,
because v1 gives higher performance. However now that
IOMMU_HWPT_ALLOC_PASID is present, and a NULL device is not possible,
domain_alloc_paging_flags() will do the right thing for VFIO.

When invoked from VFIO flags will be 0 and the amd_iommu_pgtable type of
domain will be selected. This is v1 by default unless the kernel command
line has overridden it to v2.

If the admin is forcing v2 assume they know what they are doing so force
it everywhere, including for VFIO.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 93093f1c5c287e..fd94667ed85357 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2565,25 +2565,6 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	return &domain->domain;
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
-{
-	struct iommu_domain *domain;
-	int pgtable = amd_iommu_pgtable;
-
-	/*
-	 * Force IOMMU v1 page table when allocating
-	 * domain for pass-through devices.
-	 */
-	if (type == IOMMU_DOMAIN_UNMANAGED)
-		pgtable = AMD_IOMMU_V1;
-
-	domain = do_iommu_domain_alloc(type, NULL, 0, pgtable);
-	if (IS_ERR(domain))
-		return NULL;
-
-	return domain;
-}
-
 static struct iommu_domain *
 amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
@@ -3068,7 +3049,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.blocked_domain = &blocked_domain,
 	.release_domain = &release_domain,
 	.identity_domain = &identity_domain.domain,
-	.domain_alloc = amd_iommu_domain_alloc,
 	.domain_alloc_paging_flags = amd_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva = amd_iommu_domain_alloc_sva,
 	.probe_device = amd_iommu_probe_device,
-- 
2.43.0


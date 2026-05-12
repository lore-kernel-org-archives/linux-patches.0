Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E903D45E5;
	Tue, 12 May 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604398; cv=fail; b=PwGot/zAzvv0ols1ImGlC3JA7ymTSD2KryytoMhWInp4ZoPxFzVxykk40xiubSMZviaJtjw3Gz/ggfeDc0p0y/aluspM9Kij+XRiVMzBDH30CPm7nBbO2eRfQwRYeobexDFV/AOdxB0pmta8POHNNPSp8Du//r8z7b52ESNz/4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604398; c=relaxed/simple;
	bh=CJQ90Yzcvdlxsqir7GzFisx9CNHuHA/tzHnkRm9L55o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f8cvjxdSUuZn11dFcqm0+bOWLrnhW0YoOpyS3IMMrc7Ru4zjlSDMYhbIHbtTVGc52DibmQSzGW2GK+R1mEasp6K0YgucMBA6GYsR7G1Ux7P3Y1nkg0pjr6gJAf8G5cbHj9QvGRVoJ6ATBvpkmpnifb2q64hf2j2fkFz4mWQKiTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qy3AWenU; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qy3AWenU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8IRojjK2AsPd/NmAY1wJ4pdqk2buhoAdM2fPL5GFQCEoyNV4qnuRITf/S4dLZMqikc0wOifsHscKViF8+GlKnvnrYGo4wGoGr2mZU5lVow9ZpqeAaeRzAFJoI1NzZ9Ao9cz+xLLf8y7zR1ILJ7C1wDWEwUTW2jtFpJLVco1p0BfktGlgRQhfcUil0kyeekIFbNXLcFZajsqFJIcRISKqlY5seZys2LfcPUij8irNWv65qhEuTWZFGB4TQ90xM2IPB+lz8NY1eOoPAeGbzfJpLstr3AL0g63CWcli+2fPZOys+XdS+wURS3AG24VdvwRPkXv0+uMeuzOK76aW3IN1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6cX0PJ7miQiXf8xC7qaI3UQPRIwS2yAX0op8eWj9U4=;
 b=JsmhkgaVtsgxGSJbj4C3jFY8rGQxbZgJSTooIwJGKjmMZTIbra81XXqMOsYCA4C6/gPcedGjQHwA5M30I5ZH6hL9/G371aXLHP+8pm8w50PmA7HumHBywOSY9VpeVjTDNQQqzYPsZPCEthZkb/WJabl2SdzgB7kTjiGMKVZ9iehEeGGtTcqlMVuF2r9ej4Xd8uDgwfOOqPx/W9NkBFQJLG6YK0djTwfsJ+iI9McwkvuQMvww4qODbUaE1Ub6fTTJdMoQWPspDcH7XA+qtnZxxOZr5eNdkpnKM2ObzEWlCOj0D2l/GDw+fgJOe7TLMQdSp82nrcWucSZWk0KT/SME4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6cX0PJ7miQiXf8xC7qaI3UQPRIwS2yAX0op8eWj9U4=;
 b=Qy3AWenUj1I4YyNVYqK7lt2Ae1n04Q7mdLZ8PRGXp9YS0fOG4cOhq0jwqnCJFZvgrarIZuElqHx/ogW+Bt++Pb7dk5yxNEqhj4h7YSozTkJykv3meMVHclviDhBoAtT0GuziVcfZNtsrkshD6JbwYtf3/RxQIrn2gUhl0kESn7jS1PYPvgo7yc6/t/0dAZlZL2ocBN5S1qHeWiorxkcRSOTM3PqF0ZyVjzZ2hcfn91ZM1M8FGnl4T6wRomQ5np/HKP2nCpLxdIMNk8UAlQkD0DQGM/XDMZzBrHnykOEdLx6e0/kcD6at6/q6b4W3omGTtR7/Lo3dmSC/YnD4pkKLQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH7PR12MB9173.namprd12.prod.outlook.com (2603:10b6:510:2ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 16:46:24 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 16:46:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 4/5] iommupt: Check for missing PAGE_SIZE in the pgsize_bitmap
Date: Tue, 12 May 2026 13:46:16 -0300
Message-ID: <4-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0007.namprd22.prod.outlook.com
 (2603:10b6:208:238::12) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH7PR12MB9173:EE_
X-MS-Office365-Filtering-Correlation-Id: cca35bd3-9548-43c9-c7af-08deb045fed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	QPWiKo9cAvKan3CetEa1Ox+ZhR6PZ/UnuVRcIWgXF2165o9iY8PKOGewDyiHRpToEWEO+2swI1CArMuXlQ5Gs/UZeQM2RR/yZl5kkdLoC4tq9Siy05niJ/g0nuMjXJtU8Oa2unkZpog1NSO2iooYtP6pv3jgDXZDmMZNMWbgu96nku38GvF0dfa/QhomQ1dYfneVOYpCf0D2QKnk6YQXTBtU3Drjk7CgdLb68HndyVOJ9K8z+LxnwU6yMbuZNTH6LekWK1L8y/XKw7wygv11ditUyyMhTxY9ceNiYCWIvZbHJaiZym514fHvI1cgXQyckNyN7Vmlup4QT++FoZssPJwbqslF5C+dBnZPec4b1/WXinOh/FB/SV7FpiFSwXJkBURf1qPmit+ZYrDMPiHAhU+FGBNU6dlVOcx/1vbP3hZQtkLq3Bz12GUGCsNeipPwJ2NBs/ZwpWfE9aTUsVbJI3pOZ+1wlFnoPyRi4c8ZcKRjISFwoLyYC4l6YX/NEZb0veZqs7ZMo3yxSnnfHr84M2gQ8OI9MU6ewENcIM3eD3g+42Et2yml1AdJNykxfJInskPSKIqWfDknSiXBaMe5XyGPbgSKUO2vtKqMnhlCLvgnskGH7JED4RpnR/XOuunzQxR2JRmGnwj3qdwitNez0J4FvELnAcVzBYBH1yUGS7ErfVSQtF5Lqe3jTETkoSgD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZGazAaFGfpZCFqCuxO1O9SSENutUSVLhhqU7axHYd3uRZzrZHED2nolA7Jkj?=
 =?us-ascii?Q?2ybhy82L3wQm9MaWzypttZDf0aeL9irkTSEf1s2TzWUMxrEQGCgGelxi6Voq?=
 =?us-ascii?Q?UJRvXyBHvHWwwtU5MigWPhXANl/196SjuQVC8JWJK+2cu2T7BqspXv/C9diF?=
 =?us-ascii?Q?aHNAryg4SG3djiup3X7Uz3xiv+SBZpbu8TVlGbseq/+5U9eNKInBDEaiVoe6?=
 =?us-ascii?Q?hxKefri/HZEozUtgvivkaWZO2Fy9QgSCmWJjOQJQOW18rmh3/NP/GqCPWLtE?=
 =?us-ascii?Q?2SpH1KOtnZMkGAKO6VzVPYBg0D4uPsarH97CqWXyZJBsaJynnOVgRV2YnKT0?=
 =?us-ascii?Q?6wnOVKAIOUeAyKn++OCRgyJe+cuOemfkb8iYHznpoa2BxqXfBdEF8tPXPt6w?=
 =?us-ascii?Q?T+hneyGH+rlKDP4DUhZOA54MkS6UOotYNf/cCKZ9cev3w01+e0EhfTKxPVxf?=
 =?us-ascii?Q?7VSJToKrgKVtnd3yYYhfW+VG3bv98ELxsv+Ux0OAVtlqnFXiZLwZVvwiFXK1?=
 =?us-ascii?Q?OkfgyN3DAQkAXnnEGXhJKZEihHGG3UtetcMcxFPmZEaCdE9xhi067//MALtr?=
 =?us-ascii?Q?mPQSwYO+g8MaWqlZN7wnkWzcAdZvmglZANAnDedcCg6kiVDxJmQ4Z9WTka59?=
 =?us-ascii?Q?2Kc9GcSq/Abx8IMB+LCPMdHO3VNYfu7LLwts78bYjbmMXN7Nw3ZV+NkcOtr7?=
 =?us-ascii?Q?v/J6VCMuvAQfEU/W5LTNo9KwxxKPH5jH39JLrw7nvV+6Hn/7Rt8aXyYAbSKB?=
 =?us-ascii?Q?YxR20FW5Jyn0Zh3R7K4lQ2d87ak5yjGs8wLCZKRuR/JoQYoCnyfzn4qnKLT7?=
 =?us-ascii?Q?Yx9Ei9ZrweBH5RHF9OsQXePf/JUFnt4Gb+aJAjL52cwBrn47ZlmsJ+kWVflI?=
 =?us-ascii?Q?dp8rzcGVxoFnwZd7AJvkx7nH2Ke2WBPAZmL7Iw+AeDBpJb1gCI6xBVTqwcNq?=
 =?us-ascii?Q?ZWPwMz1o0uDuQ5vaEUV2idakYrup0JmReOkk38p4NAM1ZPKLNGq12CJ6EKCD?=
 =?us-ascii?Q?m+RueZOiyTKDPjEasRiZgHvTfTsRW/WvedSPRftQvOEohogCGfT5ZM/KDCjw?=
 =?us-ascii?Q?oSQKWJ2SdGPHs95R5mwjXVNHeQB2kBWuA7ERNrSYSja7vJK6cxlt1scqHU1x?=
 =?us-ascii?Q?fwQP1l2i4S0LrMTzNVpph2qFaxtEwqFCKRvSqrgjUY8ssEy+qyx0dsbThLvB?=
 =?us-ascii?Q?6CYjAT92/AuqFYRMzYqnSaXplfxinaUfLDRBWFbbIX57NTqsQAVElUqtQCvD?=
 =?us-ascii?Q?JCEvzuXqzykN2ryk+FZnPNN4SHeMyaLzl7+lrdsDww/nTrC1tOauYcXKDtRx?=
 =?us-ascii?Q?ncemKfe3Kfd4+w4SXMULMPvnmZG5sJTmbIfwAi3CUGbTaWzzZjnnfSUp2zSB?=
 =?us-ascii?Q?eo0a1wxH3ftFnncOP4R1CH5A6HV13KZFY0a6ZUjJIlNxuBbKHFQm3TUzx7dA?=
 =?us-ascii?Q?JGrzHhblgf8Wf2h2Wpr6SheiV4Ncbfgzfv84lDsZyPEtJloY/4aRaIRhb8uy?=
 =?us-ascii?Q?7aoL+84ksAoHtd4lqb6uoMUKBGW715EcF0k72pTbjlC8ztqaM2a2O1ixVNOi?=
 =?us-ascii?Q?0a/FkXx3ec06/bcvdLntz0bfrH/zNN6imL8saiq1WnUJc5lBpgQ6M8xmLNHa?=
 =?us-ascii?Q?8nE59gVnBsrUKCGtZLMVmvCioVGwW46WBrn7NHECZgAIlEZLTPNfyq4XNJob?=
 =?us-ascii?Q?QwM69R83x7K4BodXLw3dUW7W7uLWVgql26Y13u0/pfIsJE1N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca35bd3-9548-43c9-c7af-08deb045fed1
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 16:46:21.0342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4+382H5Wp5CrDPsIt7U+mb+YKHQXPyNXjDaA13OGbjCiccqbfmctHqwcUZE5l/U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9173

Sashiko pointed out that the driver could drop PAGE_SIZE from the
pgsize_bitmap. That is technically allowed but nothing does it, and
such an iommu_domain would not be used with the DMA API today.

Still, it is against the design and it is trivial to fix up. Lift
the PT_WARN_ON to the if branch and just skip the fast path.

Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 19b6daf88f2ab1..4877b05291c9d4 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -920,8 +920,8 @@ static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 		return ret;
 
 	/* Calculate target page size and level for the leaves */
-	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
-		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
+	if (pt_has_system_page_size(common) && len == PAGE_SIZE &&
+		likely(pgsize_bitmap & PAGE_SIZE)) {
 		if (log2_mod(iova | paddr, PAGE_SHIFT))
 			return -ENXIO;
 		map.leaf_pgsize_lg2 = PAGE_SHIFT;
-- 
2.43.0


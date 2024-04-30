Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAE817BB1B;
	Tue, 30 Apr 2024 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497715; cv=fail; b=MnjFR0j5zxsKn7RR82XcRid8jTdj4hd4kjb2+pcFSnjT74OuCZvAdawVZOKZmonYpdJNhA28TzyibsEwW6WZqEWM8LRg0H+30pO8Ew3rHdHbR3Z2A57bJkcbHST2Iuvs33Juhjqj6UQNogUOhvy3EoD77D2F6AQ9IYKrfQYst6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497715; c=relaxed/simple;
	bh=xM6jD2iToPzVrsvKhylPSbmUmem0hOaf9AQVr88a0Og=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZVEItP1nkcPSPppLXJuT3DUkK/7XNbsIlq+dEfDjWtuy/wEWdCL+HkOuIlwpyahW4pcxShq4jEz18T3PTnJHhtzZUvfWb9eSDh7ZFBLnJl4RPoJ1clPa9xlrIIdptF3J5XnSRMG5uhfmp8XD7dws1j0Bco8aYBt87iLsQ6CBU5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lDp3KrQA; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lDp3KrQA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jg2GNFAVV8PfYVW/Y+GEpzcdBBOIbD5w3RFr3c0A0htsWiBXR10t2Aclag89PAcZck7xRPPFDmGWkYiy2SXvcq5eGx2MGGkATdGtHtkTTmPAT6l6T17bsojIJduh7dy5BztcPavRaFaknRekuzoficsj6Sja6IgMM+0DRorTxwcOcPwHE44+vaZOXqWhHXnBzGhowVze3D8oUsju4Z1iTZzOxUGbjVeY/tJygNh26mICyrGCmPUkORw79IjUNuMuoRpLlJh+2fZz1v9MxZYPYSFGGVga370x7i5EOPVm3L7MB5VMyj/1DATL6xukCBQB3HiokgR2i0a/9HVQ6S/PfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iPtGTT05UbcD/zPgD3HjFeiQfpFkOFel/L2sCOlTIc=;
 b=IPMzMUDyvX8OSHMCenqrNInZLL4j7HkbNpcB0kRBS/h/1iR7T01UL0LMnQ1JFgDy7TW44xm5JUX39WR8+etFRnp82wJbAGCG1gLk6NtC0Q0aOrGPYNOVpF2TTO8o30eugt8f6dV+QMKw9jxDaZf8ZLpmd3I+18yKqRRayL8ktz/XT7tMt2NKv7H/AClr5myWupTXB5qoZ3lECm0IVDyYAkgJ+KyN43w5TvbEFCKzzopLJMzpLP499ElisGHB2Sg7PRlk6BWuPO06n+plkbI4etk5OW0ULWjxfl3Gz/4mM/lsRZ9wj8QVy6zSRgfMAwcUGy5/MPf/Hcqo19gOJ+XEKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iPtGTT05UbcD/zPgD3HjFeiQfpFkOFel/L2sCOlTIc=;
 b=lDp3KrQA8AitHGIg/VvpxgMu/9HbkIRnWLGhRRAaxj7wc5MW0/R3VgZBILAEoc1YRKxpkJaLSC9bUP/cqvHA/aHZu6AIVKCZgKfoVmuWQ2NTTmVXi3vqbY7MwgpdNrLIAJCPR7zmQ+1MyLU7nFRUBMjR0TTx8SBzdiYTAISe8ydSTNw96KaftO0v2zwmj6W5BVr3QbcFX3I3y7siJnqeHy/AQLP5SWpciOQVMd15soDzLAnI1Nff0hjROVbfm6AA22v5rsgt4Fu1G/rqzUOyIYbj9k7rUE31Bo+pqft3ArfX559eQp2eor/X2W/CWDLgGpaYLbUyFczRGF97cOiDWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 0/9] Make the SMMUv3 CD logic match the new STE design (part 2a/3)
Date: Tue, 30 Apr 2024 14:21:32 -0300
Message-ID: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:208:32e::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 50524f7a-1898-4b28-6ede-08dc693a01b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7W4PBdhey+XlYwXewuOz0T3iBvPFlOYBephlbNS2mV/XGXenxah43ZySSJQw?=
 =?us-ascii?Q?k7jGIAA1+2xmbgO7IqUWPW8nWfIez2JgkUJLSLm/cE09rtlazozbKvIIJUCf?=
 =?us-ascii?Q?sGgE6+AqD0VhZ9AFcCA3GHBl0F1SEwcuVXrZf+7Mq83YQr33JSKt0ANI2efz?=
 =?us-ascii?Q?WvQHOkLJ1f5R6LyxXdp5DgB07CkZTUxBBZxbln2tpLhX3Oc2qXf+lpsViQCq?=
 =?us-ascii?Q?EtdK0FbleEv5vj39fW+a3KAkznx1JOceA17LIGK4UfmQ510T4bu9wqTBD9uy?=
 =?us-ascii?Q?nW4ojjUR+BmfQ9IyCc7uXifAI/3IEXmDdzF3DynLzXx9jSnJRFxgHihNzMRv?=
 =?us-ascii?Q?NaMzIu7ubIuiW5Ba47ryrAPxIlLC0cvKmmkGNAPRqxlhMrPB/0lXkvJria7T?=
 =?us-ascii?Q?u/2MffW/vQ1xJcOvT/g6HIPN12czHMZogPjnHSLxt62eg4CM+82NhaJHf7aO?=
 =?us-ascii?Q?0CPTLiqRCrUK8AVR2Bunhcs8nxAqrl6NjJec3JsXlYRc7FR2/r7uh1N+PfmP?=
 =?us-ascii?Q?WEp5BTLOrFygV+nGUIO/KbCmnTpeq/o5wePOMbyuZhyXXbbtx5yYozB1JJVq?=
 =?us-ascii?Q?y5yT9GUBn3T/HqhncVnCSdxtRGBzplwE1tNnOIDPPn+pcDQuDgHbSIf+BIRa?=
 =?us-ascii?Q?dz+TMslJzT812/wUTtoR0kKk8+F7BIIvnI/Nfzub9XbuKlfKTtg2D3r7eLLh?=
 =?us-ascii?Q?M0qvwiNdt47L6B3hcMhgDOGkxLhlt5t/Hw36XJeVtYXVj23xjXhEYjdH7Foe?=
 =?us-ascii?Q?DBgFpY+ET8O3kPArA240VjHrKlavO57bKwVJQz8zE5ZL+Y/Gc08WjxV0Dmt1?=
 =?us-ascii?Q?snMmyCRU/cqaZ7MKN6dRC2XMPtOLUDcVDcsNL8UCge1nVfNr+xqxTJLe0JTf?=
 =?us-ascii?Q?6ahM/3TDzl4yacnH1JA62ceHPxc7fnDAmlqZdXhfZ37xJ6lhQ6wew6Lje9hs?=
 =?us-ascii?Q?uEfIP1/2ZxQTWMJw97gETpTPL0WSKZcDCWCfJn6zrfoE0gigYTq5pCDrCFtq?=
 =?us-ascii?Q?AWTcwt4aSVAr9hsjx0TzAiTRfjEDFqz2WBoIaLrreKllKO26PJQTwIKg3X8E?=
 =?us-ascii?Q?GaCh1oF6gbCQE3YgHbpmaNB+BnmOGD3DBe8B4uYn1MV7u0Zho/+9U8z21mzH?=
 =?us-ascii?Q?lnaqgyOF2LskZwt8Dn+u4sFi38oKU1F10VK4vVuJshFg7QJC4sziC7VTbW40?=
 =?us-ascii?Q?mLLYBRNlFuW66u2lgCY7JFqqdR0D9KgV2tqPpescaOwJ8ZOoHfWoMXEUy/NR?=
 =?us-ascii?Q?6oMBH9qjk0BitGmTr85mfWIulJW7aE2CHjzznZ9DXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2sJOOjMLzTp7N5l07qNyPdMoz3gdKKvsfvspgcggMInALRnSyKF7crO1NRdl?=
 =?us-ascii?Q?rWtdp4oP3fkgYxufogmNPOxx4x96UOxT360u/u/35hNmxHFjsy6vYeEkaEIQ?=
 =?us-ascii?Q?ARdbr5hg+1ZOdnSJULhwanXQ6IKWVJP7e+I32eW5/rEbvh5qLGy71uyqKDBG?=
 =?us-ascii?Q?NtG1mqDSFDLIOaap0SE6Vdvek/Gm8IdLvoYVrKpWw4nGXAS4SU1OpdjUl5XS?=
 =?us-ascii?Q?BYSQRMFIS0VZtCPOFWW5gondszsoQTi6yduh2gsjDhu7lKnWns8Gx/W2Z4I7?=
 =?us-ascii?Q?+A0YuyIK7q20YPwawFPTVGszGfDvOCFqMI0m92vyx0jO+rBeEpOQux6mwxdn?=
 =?us-ascii?Q?8jf4mPxmowpnatcjlCr5zNt4LBG6Ye/Yv63j5QbnbE2ZOq6yUSDUCTOX8NYh?=
 =?us-ascii?Q?/+Nh1DOWp1+iIgEoUZ5RpE2q7VHB7KlkC2vJkNNcGrpS0jqQ7Ba4MUkFjFFn?=
 =?us-ascii?Q?kQxxsKomiE9ihNP/BDswkKj3Ng8br8ROq+d4loBX5T/zN6Wpxdhtmf1fhhf9?=
 =?us-ascii?Q?LechPDm498q/CzZnj0S4gspvZ2MrvB5XVp7QyL4vz0HEau3MSylY+6C74O0J?=
 =?us-ascii?Q?XvEdp2pKFT74+CTCkmseUpbTxUASIShsMiH5MJoXHkKVh0gp6lBhZKspp4nS?=
 =?us-ascii?Q?vY0pHzDivk3pC/XmVDuVibkzWQmLvx2nYspIo3RXHP9XtsfLFQJdb/1FAOB0?=
 =?us-ascii?Q?ZtPQL0k75h2cmLKChlFf5USOXm820ncrKpd+kdmK2UUnMY0QyZIs9N99GcWq?=
 =?us-ascii?Q?yB5/TDGbfn3OH7jJM5EoYwwVDMj4eoNR1FRT91jgvAdE8ERq56p4veaHC/YX?=
 =?us-ascii?Q?39IpPW5PZJnOAA7lbBvYIqVXX+774fXWgfH2MlAmouAPg2RnscXmos4JdHfs?=
 =?us-ascii?Q?rFg5CSSnx39lSkicMzco9/LzIlKXTs2AxsrKC3lMtXKuR7xteUeHM+UTGS0d?=
 =?us-ascii?Q?oGdXUGyZtV6oIv7IAcSn5LfwaFZwn9nYz0Rcg89fZMUd83G8TNU+yJPJsI6u?=
 =?us-ascii?Q?tTLnu81Zr8yMSJO0EMPzQgoyYjeLV9vBqDcqL2emuaz5S396bhSKcHruQGJI?=
 =?us-ascii?Q?RjMZXpsMo6684BRTrbWRiY44LBJeLqTn/tB+WRh1W3xlHwlO/ZHNFXKUQB0M?=
 =?us-ascii?Q?HvOFJoNwxKxdDtbf18aACQ5Mgf1g5ktl6HlyqE5FDHGVgKZyHClO9lYty/wV?=
 =?us-ascii?Q?n72zYVye22wBVzh2U3OW7MdyeMtjn5K1puNVGZbtLJGTUAH0xHRXdwjjuUnB?=
 =?us-ascii?Q?e5fV5DJPs4xXMNCYGCAuXJlVtAwg1XUlefpYVNs5e5yI+oSCXiCHWs0YB+R5?=
 =?us-ascii?Q?uTARsB0ypCdYRKiVJ0i7nCZXW/EdanuVAbTwSah0x2qhZun6S08Bx5vphD8S?=
 =?us-ascii?Q?XkVCCpYPNR52z4ooQA8YalS050Xh16oreKKnD0puuYQ85N8RCsT0iCcO9d6f?=
 =?us-ascii?Q?Jl2YFUz4hT2m12v6mI+s9GEesMGY+m5CqKF/tGDKxaGzRCnxtioacMEt8Msv?=
 =?us-ascii?Q?L/0uD07sMd2U155R6MAxK7Ct7pFamxh9vutFLnnwYCdOtu4mzMAJamk5s1VG?=
 =?us-ascii?Q?tDBz6o1PWI8IftmWjWBRNuB7eWf16Ng0uBt0JXmC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50524f7a-1898-4b28-6ede-08dc693a01b1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrQdV77BA6/gc9uXnZvtjb9IKFGW2Pduld/F7uowoxSREVezP36m32TOMU31krBv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

This is split out from the larger part two which aimes to rework the PASID
related code.

No new functionality is introduced in theses commits, it just reorganizes
the CD logic to follow the same design of the new STE logic using make
functions and a single programming flow without leaking details to
callers.

CD does not have as strong a need for this as STE, but all the code exists
and continuing with the same pattern makes for fewer things to understand
inside the driver.

The following PASID code makes use of this to rethread how the CD
programming works to take a caller created struct arm_smmu_cd and then
stick whatever that is into the live CD entry. This allows the actual
PASID and CD logic to be general and then the PAGING and SVA domain types
can sit on top of it.

There are four kinds of CDs:
 - Blocking (ie cleared)
 - S1 PAGING
 - SVA
 - SVA with a released MM (all fault)

The last two have to transition hitlessly.

v9:
 - Remove arm_smmu_clean_cd_entry() and instead zero the required CD bits
   inside arm_smmu_write_ctx_desc()
v8: https://lore.kernel.org/r/0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com
 - Remove ops->v_bit and just use entry[0] = 0
 - Revise commit messages
 - Revise comment in arm_smmu_get_cd_used()
 - Move hunks removing code from arm_smmu_write_ctx_desc() earlier for
   clarity
 - Consistently avoid CTXDESC_SPLIT and remove the macro
 - Don't check master->stall_enabled for the STALL_FORCE mm release
 - Fixup rand config failures on the kunit
 - Use VISIBLE_IF_KUNIT
 - Move more mock structs to .data to avoid stack frame size warnings
v7: https://lore.kernel.org/r/0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com
 - Rebase on Will's for-next & v6.9-rc2
 - Split series in half
 - Include the kunit test
 - Update comments to refer to the STE & CD in the writer logic
v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Add an ops indirection to the STE code
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry

 drivers/iommu/Kconfig                         |  13 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 164 ++++--
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 465 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 504 ++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  53 +-
 6 files changed, 903 insertions(+), 297 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c


base-commit: e8e4398d53f98be7ac48e0bda9ea6e26df24136d
-- 
2.43.2


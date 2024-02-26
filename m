Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0829912F5A7;
	Mon, 26 Feb 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967260; cv=fail; b=EbSpxwB17rzOoga5B2J8b30IRTmv7eKX3ClzsnDgd8x+4nkDXS8aXykL3DIrWkypqsZlYxbjQ2R/qWK6/fq+vmfuoL5i287s/W9vajoCPQvQUVXJd5GHGIyOwoHEvZyo/DscjWmZ5Yd6ii1lvcaYJkYM0HaICAyrQSkIjhF08LA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967260; c=relaxed/simple;
	bh=e9o3vbBB1JVw22be3cpRAYhm5JRt7Xp/wv0Wb0iiaD4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HFhSxpas/AQ6Qvu8BkHIAJDOCpro6N01wpht+TEPOSdcorvxDTheC6TcbHtMxO8GwFySp2EL2yY3inoUb9TRO8V8uBaaisAu9oPQGnZtIf/CfQuX8sTgAiKQuJT/5/zbTjGIsb96hbXQJ44p7gmjHCws0AKpKyeedQ3h9bsF/QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XGNedgQ1; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XGNedgQ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikVttwL0WQNLokO0deQsRAsMJT62EWyIjgVVrEV7cmxJ3kEDUCvIWmpvLDgOgDiBO8oQ95wSi5/wLxdBYAE7Tfp/Jv9/j4OMsMBprshYcvcWhovRGmxzYz2ahs+kIDCy7EoA/R7jlfo7BqSx0ZqzX+5yA7n0qGnD0TndMtI20xFLka8vNuF0QNGOpayvw+FbJ1Jkdd657DQF3CPciNUv++Tra0VT/Y2LcLZz70ZQVvFBd/eQaecQu7A1oPHCnkY/uUhvxp3zzm4/vHjgc6yW8vTkRXP9zbFfALMgtOD/LTpu2u9U8kHfmCz0Kp8/+uaRWOYfkChtifaRsSQW5DA4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjGLSXpV2Y3nbYpHB7KB5LMBi63KEL6HejxuU/zfAF8=;
 b=YBfDMI++UuyFtOj4Y6qibWpzH7ARGPa3HDqGX3ljvfHnY7ySBG15hhLLBxbAz99ey+nqc3+ceiCAuraMUam3XpH6wSccw05UXasigDhDpwjX88hUfKQ3u8r5An43L7/rswUVNLny7TMIR6yrUCXRf75rsmjwYRmnx7ORNw62Y1HB13a+rL/puOPr8NU8AMRa/Wjcj5LzsleQwGEN49IS9vIby4sk6n78g/4a6n2PaecgHuw04jNooy9bdRZqmfmb4CAKdgovjQlEijuHhXcKHYqm5eCUBY/i4McA3uOhv7TGvQ6jfXhzrjRgr4LtTZ75d0dw8+NeliYVeNy8knwevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjGLSXpV2Y3nbYpHB7KB5LMBi63KEL6HejxuU/zfAF8=;
 b=XGNedgQ1y7qgByWACHKQZSzsijETFyGlXouiLohGDwSQHZBK+zxEjGcHqQdUgDsUNgRAoJ6RErUWE6Seyt+HSr0Z8vQi8zFrh4ChTSn+D3kWNidXxTqmy37w1WhM3nwLmqnbOtjYefVNf6w02JzmAZSQAVyZzwZUAiPjrIZ7ClZiVfY/0UIP8MZ/pPOJXiUSagRgqvS4/UKCjXbf+j8Z+az0solwIRfIk/ssl/BfgeFSVsDODb3YcuI63XP+b08SwaKHcaBQme+jvUSQ51SNMBuxkgWraY4MSAz12oIAGxTQXu2uS0YkclAEn/2+cF5/qpI2FzKxKA2kMXWpTu+mAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:31 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 00/16] Update SMMUv3 to the modern iommu API (part 1/3)
Date: Mon, 26 Feb 2024 13:07:11 -0400
Message-ID: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: c177ff3e-b082-40f9-a596-08dc36ed6a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4PNNnA/SNThLmPIoPlO3zVFphQulzgev/DXt0VmG/7/rpABInxJshzAbiKftnDmsgSjxe/k4N802bVQw54VmERwAy+mYbnICjsXooonFxdNY8DcwREqKsg+Xtc3uyRaTM1mNYrRAgwHTeAmYlYluQANeh6eah+MKVyGHl1Gx8O3++e0Uq31uc8QSs8INNW9hN2O7+AbS35pe1PlGcNXz14BDiz6M0OX/OlZ7nMqPV0iSWxoqpMnlJt1eOCfzDyAUKfD7+kjgzDj4oz1k2t7XU4KPlCx0y1i/LclrA+H8TM+oQ+zmgIG/GCc8FBz+sGwEn5Zzx7/V903TZ/+moyyQTZ3ZOUyhldLL2CbRMQE51Tn+Ya/llVHtvy4Yw8XnasHS4OF07dM5jUIJF6Sp4LFNqYku+8HO5kKwr69tFS/Z9vGZoFRaHKwM7nIvQKGffjGpmxkyVMBJd7czvhyIWcGUZMvpb2MPK2umfI6eTmqjjQBq+QjOD1TbhmwPzA+NoctlhZJXANlg1PrysRIwP58rnmYh6SCOPkm1ytoOvbAWVR+LZXFc9gmDW/YpaU8kJq8Xk26rASl/4mRRhhayAgY8kzlAYnHzIZMPX+VdCHe+bUV85O7NXhmOZKEYS7aOWdND8cBaIeNbl34UVRyK8ofLDROdRzVPqCPtZKdYzxQVa3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8fsTukAN+fsyjuZ86qVVWCV7nN0iAGhn/D2oGp6brDRpUhRso8NJfg61rtk2?=
 =?us-ascii?Q?OXqE3kxMnqYvGh2L8saIVyzQYH9YbtHZZNiX3aDfxKyOCVeMFmhK3luiWV6p?=
 =?us-ascii?Q?dCHVDa1RtxxnB43pfbTaggVnSkzlRwipSbpp70XDmNOvqJ39dlbhovzHBFxi?=
 =?us-ascii?Q?RWp5yzP8JefVYTthvU3iI1bYJFJJc/bc5S6DQSz0gcG9fEjnURqsluLtXTWr?=
 =?us-ascii?Q?t9usUThIl35MaeeNzwLiJVX4SZQ+kpR7mpCKR3FTh1oKzi+JSIZAJGrmot6e?=
 =?us-ascii?Q?E2amPSCjqT2ANNaKSF8n++m+9F1RDk7XuOwQg9LQfyAspX0RMU8Hxa3B2Fcv?=
 =?us-ascii?Q?8/6uAnvowBlq6rlZvpTD4T7VKHnCXQl3SPQQ2IB0hoTBH4WrskY85gmNoaEW?=
 =?us-ascii?Q?ve8BYy12WCwPgngbtJ53tNSZOXvF3nfU76oqD8z6gigUdHhH1kQWCkK0AQkC?=
 =?us-ascii?Q?hwsr20+lla4/Rq2gumO+cy4exRVC5KhkMtj2tmqEnCmrhAyBKGPadt5sByOo?=
 =?us-ascii?Q?BHakHm5L52N3POpr9wxH1qrzQbPL63Z0FzOg18pkN6IGslhaYWX4heLh+/vo?=
 =?us-ascii?Q?vwk5SVm8zw7YqXhwBNzrCx4pHO4Zkb9+9lV4ninrwrxtMgR5BiIq0xGcfG9F?=
 =?us-ascii?Q?M3k244V1VqrtXkMXbM6nUsKGw7kIt7t8bKOSlPAoBGWG5v92tVBONffIgo24?=
 =?us-ascii?Q?lfG+qjpAb//TeuaIACnjRE06zBabkF0LpH39S3HexDoJoMCz15Yyb9IVxgP1?=
 =?us-ascii?Q?0vuKHNwhKhawvzc10mQCfyOixV+U2v1lTjpObq3OCztHltx8s6ByOV0o7Wmf?=
 =?us-ascii?Q?oaOSf65xxaXDMgJHIizl2+kcntIQ+s9xvsxbboqoLaX8LquFPd1ec7bYzglW?=
 =?us-ascii?Q?DVMnvoh1Qm6XbNpudTx8WPd1eiicMxq7Kv/bBiK5KoYIWxiGlmCtwaYjr5LG?=
 =?us-ascii?Q?r5FdGHsj93wI1zpbnMkEqJvwHE16fk6O0OPYS1z6nFzZgJxo/3feHlvP8rg6?=
 =?us-ascii?Q?2KW/F49ptF0H1N3dCh6h2XTZDn8EcfckG4lMPxibisq18qu2Stq38Hk1whBU?=
 =?us-ascii?Q?mOV6Es2KkhVPpq8IyUCUQrYHPG5vpHwqOWkRpNYmbCKDvLGDtXOKdSLkf2dz?=
 =?us-ascii?Q?UEupxh5GN5/H96wsYRmEO4y88Ng8ZL3lDiZCu7MNVEu5Gb1O51TTHLI8IucR?=
 =?us-ascii?Q?gLfDYVQp2z8GqCOoyCoeOOvezCw7l40r/kBdCtTqKEFB/VA0GGKN/fOdzsMX?=
 =?us-ascii?Q?pF2WCkiF5UtLNt98MJJ99IGRYf8LJb7lfolfOOAp6aclPXUF19Yw7BleE2L4?=
 =?us-ascii?Q?qP+WrPAhZp2bEqysRtK/7y4GRr62YsXQFUlcmA+JtMte9OIetDrvPbkLHmYf?=
 =?us-ascii?Q?h3kNutOFRbMsC6YWP52Ukr1SvYhTY+IirC2/6DaRnSIvlf7XMyfktVswtEeD?=
 =?us-ascii?Q?Bkqc3VsXTJoHh7PNdeYDCPs4kWo+Y5Qtsr0xUyxIt0cmWMUc9ijg6a1NAqpm?=
 =?us-ascii?Q?78MfWoIc1nUvoXLE6MKkDg81vR+zninXrPUkwapjSeeHRSZpu4I1r4trWaCu?=
 =?us-ascii?Q?mxtJFrrMiWchzEVObx/2oA1XhH0fCV/XJu1m/HEy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c177ff3e-b082-40f9-a596-08dc36ed6a04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.5394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAljUTWDYYvoS2iX/7K6qnO7jDfiby+vuSUe5JZgB+qWqCWaPkPFlyQbEpFUlpnd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

The SMMUv3 driver was originally written in 2015 when the iommu driver
facing API looked quite different. The API has evolved, especially lately,
and the driver has fallen behind.

This work aims to bring make the SMMUv3 driver the best IOMMU driver with
the most comprehensive implementation of the API. After all parts it
addresses:

 - Global static BLOCKED and IDENTITY domains with 'never fail' attach
   semantics. BLOCKED is desired for efficient VFIO.

 - Support map before attach for PAGING iommu_domains.

 - attach_dev failure does not change the HW configuration.

 - Fully hitless transitions between IDENTITY -> DMA -> IDENTITY.
   The API has IOMMU_RESV_DIRECT which is expected to be
   continuously translating.

 - Safe transitions between PAGING -> BLOCKED, do not ever temporarily
   do IDENTITY. This is required for iommufd security.

 - Full PASID API support including:
    - S1/SVA domains attached to PASIDs
    - IDENTITY/BLOCKED/S1 attached to RID
    - Change of the RID domain while PASIDs are attached

 - Streamlined SVA support using the core infrastructure

 - Hitless, whenever possible, change between two domains

 - iommufd IOMMU_GET_HW_INFO, IOMMU_HWPT_ALLOC_NEST_PARENT, and
   IOMMU_DOMAIN_NESTED support

Over all these things are going to become more accessible to iommufd, and
exposed to VMs, so it is important for the driver to have a robust
implementation of the API.

The work is split into three parts, with this part largely focusing on the
STE and building up to the BLOCKED & IDENTITY global static domains.

The second part largely focuses on the CD and builds up to having a common
PASID infrastructure that SVA and S1 domains equally use.

The third part has some random cleanups and the iommufd related parts.

Overall this takes the approach of turning the STE/CD programming upside
down where the CD/STE value is computed right at a driver callback
function and then pushed down into programming logic. The programming
logic hides the details of the required CD/STE tear-less update. This
makes the CD/STE functions independent of the arm_smmu_domain which makes
it fairly straightforward to untangle all the different call chains, and
add news ones.

Further, this frees the arm_smmu_domain related logic from keeping track
of what state the STE/CD is currently in so it can carefully sequence the
correct update. There are many new update pairs that are subtly introduced
as the work progresses.

The locking to support BTM via arm_smmu_asid_lock is a bit subtle right
now and patches throughout this work adjust and tighten this so that it is
clearer and doesn't get broken.

Once the lower STE layers no longer need to touch arm_smmu_domain we can
isolate struct arm_smmu_domain to be only used for PAGING domains, audit
all the to_smmu_domain() calls to be only in PAGING domain ops, and
introduce the normal global static BLOCKED/IDENTITY domains using the new
STE infrastructure. Part 2 will ultimately migrate SVA over to use
arm_smmu_domain as well.

All parts are on github:

 https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v6:
 - Rebase to v6.8-rc6
 - Commit message updates
 - Move arm_smmu_entry_writer_ops and related to part 2
 - Use "if (cfg & BIT(0))" style for arm_smmu_get_ste_used()
 - arm_smmu_init_bypass_stes() -> arm_smmu_init_initial_stes()
 - Fix to use STRTAB_STE_1_SHCFG_INCOMING for the S2
 - Update kunit in part 3 to test the S1/S2
v5: https://lore.kernel.org/r/0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com
 - Rebase on v6.8-rc3
 - Remove the writer argument to arm_smmu_entry_writer_ops get_used()
 - Swap order of hweight tests so one call to hweight8() can be removed
 - Add STRTAB_STE_2_S2VMID used for STRTAB_STE_0_CFG_S1_TRANS, for
   S2 bypass the VMID is used but 0
 - Be more exact when generating STEs and store 0's to document the HW
   is using that value and 0 is actually a deliberate choice for VMID and
   SHCFG.
 - Remove cd_table argument to arm_smmu_make_cdtable_ste()
 - Put arm_smmu_rmr_install_bypass_ste() after setting up a 2 level table
 - Pull patch "Check that the RID domain is S1 in SVA" from part 2 to
   guard against memory corruption on failure paths
 - Tighten the used logic for SHCFG to accommodate nesting patches in
   part 3
 - Additional comments and commit message adjustments
v4: https://lore.kernel.org/r/0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com
 - Rebase on v6.8-rc1. Patches 1-3 merged
 - Replace patch "Make STE programming independent of the callers" with
   Michael's version
    * Describe the core API desire for hitless updates
    * Replace the iterator with STE/CD specific function pointers.
      This lets the logic be written top down instead of rolled into an
      iterator
    * Optimize away a sync when the critical qword is the only qword
      to update
 - Pass master not smmu to arm_smmu_write_ste() throughout
 - arm_smmu_make_s2_domain_ste() should use data[1] = not |= since
   it is known to be zero
 - Return errno's from domain_alloc() paths
v3: https://lore.kernel.org/r/0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com
 - Use some local variables in arm_smmu_get_step_for_sid() for clarity
 - White space and spelling changes
 - Commit message updates
 - Keep master->domain_head initialized to avoid a list_del corruption
v2: https://lore.kernel.org/r/0-v2-de8b10590bf5+400-smmuv3_newapi_p1_jgg@nvidia.com
 - Rebased on v6.7-rc1
 - Improve the comment for arm_smmu_write_entry_step()
 - Fix the botched memcmp
 - Document the spec justification for the SHCFG exclusion in used
 - Include STRTAB_STE_1_SHCFG for STRTAB_STE_0_CFG_S2_TRANS in used
 - WARN_ON for unknown STEs in used
 - Fix error unwind in arm_smmu_attach_dev()
 - Whitespace, spelling, and checkpatch related items
v1: https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com

Jason Gunthorpe (16):
  iommu/arm-smmu-v3: Make STE programming independent of the callers
  iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
  iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into
    functions
  iommu/arm-smmu-v3: Build the whole STE in
    arm_smmu_make_s2_domain_ste()
  iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
  iommu/arm-smmu-v3: Compute the STE only once for each master
  iommu/arm-smmu-v3: Do not change the STE twice during
    arm_smmu_attach_dev()
  iommu/arm-smmu-v3: Put writing the context descriptor in the right
    order
  iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
  iommu/arm-smmu-v3: Remove arm_smmu_master->domain
  iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
  iommu/arm-smmu-v3: Add a global static IDENTITY domain
  iommu/arm-smmu-v3: Add a global static BLOCKED domain
  iommu/arm-smmu-v3: Use the identity/blocked domain during release
  iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to
    finalize
  iommu/arm-smmu-v3: Convert to domain_alloc_paging()

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   8 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 730 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   4 -
 3 files changed, 498 insertions(+), 244 deletions(-)


base-commit: d206a76d7d2726f3b096037f2079ce0bd3ba329b
-- 
2.43.2


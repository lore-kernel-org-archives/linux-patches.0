Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA23A13AA4B;
	Thu, 25 Jan 2024 23:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227069; cv=fail; b=uJxeVb/cMJGNb+dCzPCp6TjSfDrVcPfQxIKYSMhNzAlB20zgTejPY3cDEEDYJwW+VweJRWgE26Doh+yaJ/XVYekwKUKMJj4yLcUQ9Pqrlc0c97fWDLayTb0xQWzlmQCet5DhJILX2kh7od0n4blr4GASb1RFh0LtJJfeYBer4uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227069; c=relaxed/simple;
	bh=ex2FrRUTf824dni+5zROBbocxmjwRsTpo5tr9IWUkx0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iWidgPt67RlX6dsZ30Vsr54qTTHy2EqrvnAZBxTv5QJMc1fNR8pyPOngi7LbHoq5x/LUEG1b4PYK0QJs9uY3havR3yW2ihBSG5JW6sWwNcWfdO9h5PF98C2rFkqFfhaqMDXewFzrB7JJcVHxqOTepQQBSBVeJMzZJPfsVbpAW0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TKgTR24S; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TKgTR24S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyXNyrtecXahBS+gfh04DnTpllBwTrI7y3BTAw708gRZKinfhzr7mwXLR9tcDJ946zsE56GcP62i4V9CS1A3JmU0J1eGimkPQzIJgVL+Zr1lEYz81Epp3fO5WF+m9vhubQwnawRQx8bu2qfDsNmUJ9IsTsgytOrY7RUdw4ZQiPqmUNOc3zOrVOX7d8nOKfWY11k74OA0G1uS1VqS7cbxrXunZhe4ZgOXxwBTBCqJeqnig5XkgHCdlcVT8DaWS9L8GhWJzmxwQ2ggX5Ztk3NwlT4l0NiLA+PHjvohVHnSF1hpGm+yRsFVKSMbexdgW0iI1Tf8tNcDwpOZ1V+gGbBf6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwdzHEhP61u6VBAoaO3qEga8/tsSrHq5UvcXT0CK5VQ=;
 b=k9vvSIPzBO8H2T/s/q4efY1g5gDattaLiD2vXfy4VMtfEzCDKvYwMZkPjC0Oq73cA/6LNfKSY3UWIGhm7iX7urFkUH289BMnMQb4jUDeWY3oj/mnqZaYP9M5oPYqjn3peh7lfXu+jTEgHhA5NfrPBT1Ks9Xqfbwb9YO70sZJJhEqFmV8qgnPYvnMjvdS1jVHIv7670AT2EOpbEh1yNfkXL+wCZFBkyCqT5zmXTrRiAkhyquSGKMuR6PiLlPwuUM1Co8bjwlTip9dk8SRXFouyWuljKBg18+tuleuCtlUN+sBBYBnIttEUYb3CkbU9nE5s+EqRzVV+8teL1ARZNi0CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwdzHEhP61u6VBAoaO3qEga8/tsSrHq5UvcXT0CK5VQ=;
 b=TKgTR24Sm7o9sUAnAV4oL6L72ZNn1Bf10Sq9uFgXLEU22LEPI3Yz9LM0fsm92+0ZUi+vdlMoX5842TVhvJ2fy8jrAfJ+o+cInnliKKL7iC8yiG3pmqiJreC3lAWApFoPHFR5DxoDom2rvXFicl5YfSy7weoLS4BlN6grdDzFS9w53NT0Gf+YWmYW1GwccV3B3gNBeKnpFHNQgJ1m5T3vRNelLQVs0vulF9/XlGaciQS3Suevb88cDrFtAE7PhoOs6ZhoitB9MDVVTHzlbnbblcAdAi54Emzs7qmUE211DpVq10yywz1lco7wvBPFq+iHhyWJCvPli03LQfyDYmnaiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 00/16] Update SMMUv3 to the modern iommu API (part 1/3)
Date: Thu, 25 Jan 2024 19:57:10 -0400
Message-ID: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0035.namprd11.prod.outlook.com
 (2603:10b6:806:d0::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6ed51d-e8f5-4bd1-3a1a-08dc1e01641c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2O1u0e/EONyGcFuTuOTmxB+/XOHDYIBg++bkaMyRJdLwyBUXGXGFM02+Sk+Cox2O66vkuNNFIxfLyVcUut2yXCCm1q1bRwXwAzJyRG5iWSv8IHLYGl3guADxRlrH791iArNKKDgJteNBLH+dXos3+3uJ9icV59wdScb7DlF+04+FVIE7XPpUnxISBKhSsYsRrrFOVLzU9CqviySOWgLXLikdaFJYn2LcN8iN6KtGabVxMboZXdWDQ6h/ThjfmqKcygDmKMDHvn4ImRSR4eZcWHRBzyvwYneCU1HKLCYNl/3qz1Q435rd7/3eYBoz23RLlPirtubl2HVWq+Mbl90mK5XU+Pd8oZwPcj0/aJ9CQ4Khji/tyK60y4o+cRP43QFNLlSzVtH1txOpGPiGz5dtbkF4iIUK9GuW1GyeWO6NSCk6AtwQMHIiTrWdntRXKPRaCd5lgNRURIvloDpYBqlGlE9bd6EF0eWoURBzaHb19XWtCEJ0Vb61sbmFGzaeLjW6GZtckPIKxeh7uRiN5B0kGbixIbxSzU1gLQ+ekXb3Bj/CD2F/OxoEgMpJEYlRAueZYXTBj+sjNWUlamN4gPbvLPPWJX/Xq9PO+07V8/mYpU+jt1JasxWaO4qJItJsCpJEoG8FSARwLY4kbGYb5BfDBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(15650500001)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(966005)(5660300002)(316002)(8676002)(4326008)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OC4WDh9WUPeTdoCjgrDGPoJU3wizJZjdD2LjEJlQNcd3/V2uJ2i+/wZAEfW0?=
 =?us-ascii?Q?qvlaWFd8QqVGXuV4g7KGwq8lgjweK/v/I93I/TRxjctSBVe26x9CL3C/pIug?=
 =?us-ascii?Q?/m+uvkk7yXSxH98DzCbUkVMO/IPxON7VPCfavsZ9A1zaVJ/sRn03L7yfpoWn?=
 =?us-ascii?Q?/5wAwkPqCHeZauq5TrzwdyhsX9KmgApYagn8rxmftG9y0vaOBB+5Mrb/IQrd?=
 =?us-ascii?Q?tKWX6u7TexZOxo0pS/Edt+lHqU9/Cv77pFmPfdWN59b709xH7tQSbO4qQU5x?=
 =?us-ascii?Q?QvbFqIA8bFdqptOeFf4TlqYooMTYgPECZP5ThYvB96i7VNvOldHrs/YWXOm/?=
 =?us-ascii?Q?Wd7R8AptUAU1NJ+rcw9uUA5YSLV4zfitqEVbDuTu2sM6P2OMaxE2BwfMP6wS?=
 =?us-ascii?Q?QXve8EwrGMEFpigU6vNkh5B9pgZci+Zr1DBlUP9JQEGlx3vEMC8oKKDWO2uC?=
 =?us-ascii?Q?yamjzvZotg2IgOA/j5Ug9rcAE7EeiPSrZ66uqGw6qA9pi59EfENp9bTtObwq?=
 =?us-ascii?Q?D1vHLqR2X4CKLNpzGlQRMuol1eeNvNZecV8+heR7cvWQ8QupK42y8mBygzrV?=
 =?us-ascii?Q?rjp7FR84IuRH/sRDIancsjLAYOidZWL8HSvMGUEQf0LTL4aP8x7KQUQDI8VF?=
 =?us-ascii?Q?oxEChRaV/0B4JnRyNTnXrKqFQWqC6Fj/w/9BnRTrlTKBph3pN64c76jG3fwE?=
 =?us-ascii?Q?nCXpl0l1L9KcF7Ecy1nKm9FJyI1pkOGfQ0Q9jbnmL3rBA2SM2gL5LAgZVFwm?=
 =?us-ascii?Q?zsMcVzHHmhePHWBB+V1JroY075WKaU5VAo9LK39YeKkaJZhW4lKaYU+bAgQX?=
 =?us-ascii?Q?O49qfu2H+KlIPlGEa1e0eiJJN78Ep1Kf7xn8zbLdX6crVy/AC1XkvA8JcFFQ?=
 =?us-ascii?Q?ih/hcfJf/XTU1LtVhhTq0mrb2p0Brk5b5PesOCy31W5cFKybNDGXHQKjk0gy?=
 =?us-ascii?Q?GbH7up2+n8Qib2b7hal3eELRWsseizY+CrcsKtpGyyQToSYSIkQCYnYUu0Hp?=
 =?us-ascii?Q?OecxHvh5hH925mi1yPsl1NwU/cq2msduYhjJL9Nc+OjaqzqMMeRN28MjKxW/?=
 =?us-ascii?Q?icc+5hjsmYXJly1mrSMRBhALu/b2n7dF2kdAL6vksYza0CeuastgztL/uefE?=
 =?us-ascii?Q?b3sOd/IEpDG2Du8XXHG4neuxeZgK+FQpyiJZXGA+Ar9b+p6PzY6fMaOEowz5?=
 =?us-ascii?Q?FHsu+K4XPvtbzsufXw/+LIY/MWTr/bVcF5JgnD3xmUpfFqjIrNbU+QuDH/I9?=
 =?us-ascii?Q?Ecz0EHnsD1pMxkMkMexL27kU8OjrK7jrBWviYHHI7sJOxhaTPNpcJFnVTJRx?=
 =?us-ascii?Q?WXspP9dmAzqg1mPLNVHo2Uq6h3W68QMRkuXpjI2YCKbhJIPUvEB4Z9sv1UtL?=
 =?us-ascii?Q?9JmSFnMWTWceGvSZ5Vn3Os1bACOTeCQoMEEVPsV1B4Ffe9vCjh9bmQualwSg?=
 =?us-ascii?Q?jmlE78mmTQ7q3x+R03kBhEo3u0AgkX+R0tKhXTLDC05SnZOnFIbhBImSVh8o?=
 =?us-ascii?Q?1/CB1N2V01QtgJiVIb/EAmnzM08lSTVnfZA6p0qRM3/3knxafLW/7vQIZyBO?=
 =?us-ascii?Q?qgDJfxv6oy7z0EHPKwk5VeS6cS9YU+StFH5yKcdr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6ed51d-e8f5-4bd1-3a1a-08dc1e01641c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VZKainy35nX5eXGsL9EV3OGI7aZ3qN7HnXgS9WlNkQ0Sos2TG5IxHNz+SYZAcX/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

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

v4:
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
  iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
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
  iommu/arm-smmu-v3: Add a global static IDENTITY domain
  iommu/arm-smmu-v3: Add a global static BLOCKED domain
  iommu/arm-smmu-v3: Use the identity/blocked domain during release
  iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to
    finalize
  iommu/arm-smmu-v3: Convert to domain_alloc_paging()

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 747 +++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   4 -
 2 files changed, 510 insertions(+), 241 deletions(-)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.43.0


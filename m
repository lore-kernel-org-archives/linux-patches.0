Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2656D1AE;
	Tue,  5 Dec 2023 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sZtOg5r2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9AZR6h1Ua2b80VFKowaReSV52uuD1DEDk/vJk5ar2RI6OffD+2tNAdA/lyQKm8UidGcmOf59vhefVKZjYSDAnl1ePuBb87CoGjE3RsBZ/7+V0OkLpne2GF64b8s93J+PCEUd+dpsshPOHkLl5cZf/uwmZ3fRSIKPnoigEL3u8QXc/DbLJ0mkgmGUIX3gexZpTragP9UqD06bX8JdBTk3uU6ZzyBHEe5nAte8HBVrIQShevuVsOp87Pz2v+nvuqhI6YzOqlBq/GyLLA3DNPwCB6yzLRgjuY2xWHb9rjk2wAowzcs07hsFmfGFkDm0mBi/nKc4synMK3CVp2zrIVX0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba+MuD9rqbS94k+sTwmpckhwVfyqiQRP4HK9U3ytOjU=;
 b=UpcR9FouDBm7gKH6iCfPwTZE8d1jKW6tT06wg/NYLpKR5SOYdi+egMxztwBMljuBqnV0r4V5tVqn2twp/isSUVFnCf1YKNx2CxFtT2QEhGG8eoj+NvP+aSpoUZqRdUVFnhay9prUwLfNE1+63Fo/h+ww9kZgB097rYqyoamlT7NQkOKUhlguLdzMCp2Y0KmW51ftSHjlIWg9bms4zhpnD2LMgLCpPiuETVNLtO8OOKgqBN331tvhKOBEf/JrYtn32Ycsb613v/40i8+kEM8I0hTxLHg9RLaE9dDQLtuSvnhNH75I0Yskh0lGEw/mq2TYYx3v/W7si2ONTiMSUxAwcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba+MuD9rqbS94k+sTwmpckhwVfyqiQRP4HK9U3ytOjU=;
 b=sZtOg5r2NKsZKG6Jt194oYWeK9CQZkKdhbiRpLtIm8/CtxU53HtQQLgRLNpmjAGRnUxQVj88/6FoWZK0PE8RZSeq4kqVtFKVpLnz8JreM0cqAfl5OAkQab3JWiDOjr3LHdSoCw8XG2OjFUwlTh7Re7iT/EoYWUGHoisuFgSHBraUZrC3S67Oz6revYV5zqtBpjM297GtRJVZ62+6IVB0eQ+tfwlkDU2XZD+OjUCq53VjgRT/eEpepbaDvKjDNfe9ZXiQjX3NmEe1mLcbJlGrWvIPmpnZMvmxXmB/Yn+nBnG/H5R3vcn4A+ujzkqZpQDpwiTwMhvBOmD1D+UQIn6jNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 19:14:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:51 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Date: Tue,  5 Dec 2023 15:14:32 -0400
Message-ID: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 3486b4cc-aea9-450b-c987-08dbf5c674d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r3ey8jBj8Tz9PkAtX9m2CrqkP54HQQqi9xtPe1aIViSK+d9po+plX8BvbKdiBgycdZYTn6j3qtvFPYDaUNnMkGTOBIFwgF0EmQrdlrAkWJ9FG/JcZfc2uxo/KlyNNFDjFa4M4BWgZnC6TMRGU5TGWINI/RaGIfqcIhwZaJ0TGSnCz9DX/u+CisVeUvZ34I87FJlMdes/vMOOIgTeM2vY5hVD976OzZLA/OTLmtS/oepW8O4+6nIgNsrwwx803g0+zTGeGQl0i9/dUlnz9kKhpJxMoQwhUn5fWGcSl6EOIbSdEK1W/FAv6PJQ29OBGE9aowtTMRc7CqHjErf567NKHrDI/ohDofrqYXROK85OSJQ5z8YvQIAp/OXCSr8hrF+TBi9Nee/HUpOaIjqTYDCf3GX+Lq/hC9OYDSTKBRJh2hreiKi9m6FBx0j2r959bKXlJ3O0cfr5cpmOqWKLP5NV5BDE3IcroeFfu8d030MqHS477BJbPI1ehYajBkrB6apjiK/bS7bnyjwCkJ/0Wxj7KL+G4ogoYmG0mL7HFCQtx06fqyCbowCmiJ9IrJxI8SJEHssS81ESBFQhQYkiz3MeKQYpRHytjIecK2iVAnt4I91uOapCTr77Kj0aHacLxKXhUwChjyIeKFm/u3GaGXJyDlvXGIWqe70Q74Dka/I230rePJX00HwQEZxX6re2vCYY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(346002)(366004)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(83380400001)(41300700001)(38100700002)(36756003)(2906002)(15650500001)(6512007)(26005)(2616005)(7416002)(6666004)(478600001)(966005)(6486002)(5660300002)(86362001)(110136005)(54906003)(66476007)(66946007)(66556008)(316002)(6506007)(8936002)(8676002)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YvudocI5ZABeT7xlTrESZBjgpi8XcmdIcFfkDQ2Fw4SVFih8TEmUJxkLwJuP?=
 =?us-ascii?Q?bpON2doCkkjopTcN7UdfB2qvgYTsx2DZVVM1idWpdLp6N65I8y9E6+IiRyNz?=
 =?us-ascii?Q?fMAVOq73q3xp40p3YIP6m4tryAnFsWgxDLAGDFlctgD9sVzk07MlVhxF25V0?=
 =?us-ascii?Q?8raqu6AA+mr474TOtfLakhSqqrg0x764pKNXteQsBYYz02AshSxabInU9e/I?=
 =?us-ascii?Q?/9/tLVGqrEZ/f/yZl1bcVnH1IS47jrnydfAcxjPfxKsol7jIg7nlC+Rz/rbf?=
 =?us-ascii?Q?b1vFDIut7Xq7JEAyojBWt1lmD483fcsSeor7wi66jEgCDIFkxtFsKDd2q0LD?=
 =?us-ascii?Q?tCanjB+Hqt/DzOkvcceRYgFo2gQHliOjEvRj97GFKzbZHYUCYsK2TugsxwyB?=
 =?us-ascii?Q?2toRjV7hZckNg7GTiaHS+4+/g2DFAQtVKISWlO35ozhUI5XxB8RYs1Rd9Uvq?=
 =?us-ascii?Q?u5ayTlYJRNixhC98/wDOAjHBhebE+0E38fhx044CMF4v6YnhrTjVuzg6WNbn?=
 =?us-ascii?Q?K+4bwOMwnoZrwhwdQdXQ+YDcOa1hpR8QFPqMkhuXW6/K2ki6OecmKqxQfF3j?=
 =?us-ascii?Q?hlvj03m4sH5hdDBcCSULRGkKfw6iKnSmxp4xUiqtqTQyfXWcVjLQOx8PBRo1?=
 =?us-ascii?Q?f9ZcvpuOQ7c2Fwwz9nynf7Cecvq0vbR7wznVvThPRV29ym4yT8AiOnChyGEl?=
 =?us-ascii?Q?CBo2Nsz3xKCpwrQjNvcl4R0l7AzG4ZvecE8xYiqcnH/aXQOH5gdWZC6UCM2y?=
 =?us-ascii?Q?20QcuqbtYfTzpVSdDHXE/9CPLJhquO6KqSM6GWddMh3o2jsl7dt1WEbGryE2?=
 =?us-ascii?Q?wQYv6ZHs6tT2fa60eP9txQTwLHTQwLVhjVSlSo8WBz9dkYF8Hm0t/1AoVtc4?=
 =?us-ascii?Q?3XNuh3HCJaRC2ze8B2dhiYr7oNLeKVgPC3gwH4okUi3E3DzR1MA33HMykFxK?=
 =?us-ascii?Q?ubm6DlzzWzRc7f68rVakD6k3+DaR4HMdt0VUlCkm0pa67C3kHdfWXM/2vZbG?=
 =?us-ascii?Q?r105TE97pVuN9Lqw54J6isx/DevzvTq1GCwss2QnPlLYOK+wk7nrllYvhfXe?=
 =?us-ascii?Q?WKMpDDfITompFju6d0pskZLVfvjBwhdQUzrXKYpc8BG4KKOdvkIP3InoFHEN?=
 =?us-ascii?Q?xwzEMS+/qam1yCxn+BGJnc4wxREjeRQow6NorUo6ZMI9hZG17lRt5++OlFlf?=
 =?us-ascii?Q?sFfV/1m81SzyjTNZ//4YhtbR136yhazSLRJVNpbkXPlF/tjClrhvaWXXXK4k?=
 =?us-ascii?Q?Hfrr+swzGSjcIQ6pOd7wCtI/Ei/KFPypt+f/Ms6KVFackDekKTUOfiTOwmlp?=
 =?us-ascii?Q?SerBQlAJHGk1S8qzM5Ysdbnk3hpdE3Zzg/5umnVPMRpqzkacRflk9ehmuEgb?=
 =?us-ascii?Q?mD1/62I5CI65ThrRkKvGK2BERgW0CeB24ssP6Z5+5eQDNfPd9tS+aw6PBLka?=
 =?us-ascii?Q?A0OMCOuvnL1r+EoW4RgGckbsFxCGon0uhn6WQ1E3tpEPCWititrJp/fwnfiV?=
 =?us-ascii?Q?uZcjJXhoxq5i+X3/02z1m6CyuJ6HcXjS44gdqSbOrVhM0IjtNHFUk/rGsEPO?=
 =?us-ascii?Q?l3uq/y3FEEKzoSVFunU9cEOwfffTzMTw+tcSwr4L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3486b4cc-aea9-450b-c987-08dbf5c674d9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:51.6940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DuUV5C49CAmhglNAiptmgrB1Gqiuty0gy71ud33tZ7ng9nOFOW0VSKsetve70xi/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6051

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

v3:
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

Jason Gunthorpe (19):
  iommu/arm-smmu-v3: Add a type for the STE
  iommu/arm-smmu-v3: Master cannot be NULL in
    arm_smmu_write_strtab_ent()
  iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
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

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 729 +++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
 2 files changed, 477 insertions(+), 264 deletions(-)


base-commit: ca7fcaff577c92d85f0e05cc7be79759155fe328
-- 
2.43.0


Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489020B12;
	Fri, 26 Jan 2024 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292950; cv=fail; b=tML7cS3kWPB6HIMOxJsOU3huKjxNFUnDywQPxnsCDhkUpewQrZfWVtg1wjozcTIlP3NuTu/2AXVNkrRCBQXz8yjRpYQgii/NbuwFbaw8S76DjEs1KLia4Q6mhrs4cD73VH9IcuINvrm7/kiUApXQJGPRap4EHUKshBbx6JWDC28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292950; c=relaxed/simple;
	bh=4bIHDf7ptuMJva/wdg0zOcL8vdGoMv+WKskWLyuC9Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lHNQuTtSTjgyVAI/Pjk2ZhTZzyrU0HHtlewb79oaB0Md4oA3fvsD+AeTqss+q1sEZHD5Rb7h7poHBONgz51NSANKIqzZFS089l7gzv9kUOZLVncYyfznV0nN+VJQGKdyjIIVOlb4DnATOaizd/UuS8WkvfL46zpEzjadfMhukwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K85EZKjJ; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K85EZKjJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHNpTUdHZc1m4+QukObbzTohucttyb2H+kVF9cr5ctawLLdwqBkLSvdDUHsQcILJEJtp3fttRSVSRkkyODXVB2GP9GyWN1sXDMdQmlJO7gNkYnNaH8iAjP2K4O1epgyvNc7mlCG9E8Vps7dTJdTr4o4NgMnNT2YtfVBHh0azixCEjRe4uum/xvL1EeJ0Vwa0gcUTCnaOfDNtio0NbwZcfgKmsUFehExLISGtFhZb/W+TnIs+g9Sogv7YleQ5NL4DVoxkkwzn8cB5i6CuY04L8geQRswyMqLO5hEZPaV+G5kmxKngNER/4cBISSRmcqhfoQZ/taW+VutwQYL3ZuJ0XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFT0djtcs6Rpx+yIj8JRRJU2gyTk6c8NPYCtJcEpKdI=;
 b=Nu0zBSMroLTWZp+g19jvnygtP66vTLbvCZ085ZFiyzvhcp4KR52cjwA7y9Kn1IXJ+2pPwssUVAFm4rCbHE/RvEATYmSvXxdNNFN+Q9ZkQkoGMLFdpeCw1kNEe9BdTLLuCtAFTFJZ7owt4T9q2yeB2Su2MuW+2lwIbJBcVDcHGxFjym+iY4QdAhCAk1ibwfPMmtr870qsWuk8DqLFtitboziwMEomWd9Xa1BWSccYqph79uMKJ1B5l/R72xk6XKxHMzA/GWFSBsMd2ShhiX92g0AclRy9/5Gu1j9HcBhWq8nXiuYzyDWSvEYWiaqJM2i9CJXNAkNcoigce6Pbs0mtBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFT0djtcs6Rpx+yIj8JRRJU2gyTk6c8NPYCtJcEpKdI=;
 b=K85EZKjJtlU22J9igh4wIXEyyLl89I9YgerNOhiopCP9Vz89vWg+m/IlYd4hMsmigHuzQTgd8HegZT+1cAjo1CpjMK0Xb1DbU9m8XbERwlC6jAE8W2/YH+F/TIwZcYAilzPiVprowtJtpVdmWRg0UO4k+okq+KVSOra/5n5NAVoZJ88kUG1+9oPpYEe8l/pxJhoWPvndI369YHCufXeFGEhK9xNczIRibbIOG/okydaBl+cHzujV/FZOFiXjjrqotR+Ns9goZGNmE+7Gb21dGpbMBAMU4F0BfGnZ0jSUiD2MlrFP99WEUFJ65kz2GHkxea0V3WThAbabb/K67a4mug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Date: Fri, 26 Jan 2024 14:15:02 -0400
Message-ID: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d7e887-5e68-42d9-6e0e-08dc1e9ac821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	40UP3OkpgRwUcGAMdvO50XfvPJRlDhMVhc5uevdEE9XgZA5YUi/oRJdnRdjVrZpoWP9q/8p1AojUygmAyI2huBdidg4gg6ogJIFcbvyZs1Ry0HTl+uIrryV3e6KqbZVdnSKs/DsY+wnJa/hPR39W7taxQJ/pp0dYGCXXtP9w+qlF/4fIj+1ygFG6R57Oh6A42G6w3WsyiKUKfgGd129lZNepkpdT2votqKcnt2UUBt3S3RtgmYfZUYxykFRvhn99AI1UJvhkDkV6NkCZJq5nRblMtlP4Qkvy5qawE+Tm5Qc3o6x3P+WDXCJ77zsfGhqQRWDTOiL9PuggNqz2SPEbmrEWHqroVaZo7ObnH8CosGtlZpp+dZZzwggGCGVBLyi/16zBKRwo5f3wq8fJVhoySJaVNjS2u7xItRMXrsD/d5jskpHvgSwCOb4q1h4kaSFaRear2fzTeuRuZTAV4JhjWfB/I0nRNsvQAsc0D7Hpp8+VpC3E1EKMJA/Iax5F8R5IOZMMMUWgNICFQnEHIgrsLatj5aSmI9EEMDyRCAHCTb/5UkNwhamvHlllbb2PtNQdGXo4iOPBDh/tQv6RZtJASxuWcaQz/DhB1M0Za9YJ54eYzFNhZucdyiNskTEgjWkoKjGPi2dPivygQhZHgLHN1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(15650500001)(8936002)(478600001)(966005)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(66899024)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z7HVNPakebvDuGm6tgv572KgyEnC2KVkRp6Tu8npPpVYEdtKvzfiqXZCmsbS?=
 =?us-ascii?Q?GYr68NpjkFv7BnS1tKAyZLCM7hXLVx4VJtG594BoXLfX91lJ/nkB7CJwIIiL?=
 =?us-ascii?Q?gnwDs05XEXAh6JnvK5tnGa8ly/UsYPSiLdR+41PyKoQT35pUkFNVYeIwM/+n?=
 =?us-ascii?Q?vA3vj8AiPqutZOmZr7VYsOXmcC2WtfbAVweE9Y3TrZtsyxElHDT0Vnpo7lII?=
 =?us-ascii?Q?ctVSZLAepCgVjFurWvhXokaKv9PTX0Xx20iGnRCfVyr2Jiv2WQF/2ayCXtwA?=
 =?us-ascii?Q?ATw/LGtr273Q9EMvU05vCqyurs5UVBbj5BOYBamZYKfXqBYuGxdrbXQDY+Ri?=
 =?us-ascii?Q?mgu6HlUMEvOMK+c1wCPRwEQosVX3Ottpz+lg6wgOY+CqdSUyABN8KQ/vZhOH?=
 =?us-ascii?Q?BnkBIhVA77D9O3VRLpQfcT7kTefzL6aOxmmgjjgPaVn/uKhnm2um3m5Uqmjh?=
 =?us-ascii?Q?6qM29tlyL0aKGaR0JbD7lgMVU8WcRabU86XxXwu6SQ39C1O2QGaG5N7LA8kI?=
 =?us-ascii?Q?G+N9bL060wxrZoIxdW2jkZOKPZQRImOtoQCi4DGrvaPy4wbjQ/ITIGMamLmS?=
 =?us-ascii?Q?9OFWadRKqPkA8+Jhdwn5253mhfV1CRgC4Lud7AaqVU9HFRx98wylPQzoWtaW?=
 =?us-ascii?Q?l22keL1zwIHuAt0RLUSfKDKSCIpB+ILiaD4ZVtO00xggUwpp7RH33pR0Lxoe?=
 =?us-ascii?Q?AlZ1Y+mqEKciVvz0AHy3f4JOr5+mt+33Wr/YSe0WXig1qUVAVnOtwsyePXcy?=
 =?us-ascii?Q?HUoMWqlhh83FPgnwLAWuL5RDFnLA2+WVdaz8/lnWikcZUBqwym8abkaRaXng?=
 =?us-ascii?Q?CPoZQ3B7mu3w4BWuoEfPyQZUj0EAr4MrVUVwQs/aYv4yn0oXnIR3kfckV5fv?=
 =?us-ascii?Q?YHf3Tx1McyjgnZXdT0p8k1IJDM1Ns8XXhCxXO84KU00PhQ7+tquhwKyPW5pd?=
 =?us-ascii?Q?2bANPvCvVxt0BjEC1fxD2o71jSFnjuCNaHrc15+MiNK3ZiyOEi41wejblEkE?=
 =?us-ascii?Q?5GyOJy2GxpZacCZLDqLkfY2VVShmLrKbV1krHB1Bxnv3IHuGnHkB9W40mOZi?=
 =?us-ascii?Q?Mhxf04UyfHcyTMt8ojqf4ELBKxkuWogpw6zFfsoHCWJR+kA18sFIKYQpxKtY?=
 =?us-ascii?Q?WiWeCVGXSEb1GA3RMSdwcJyrjsclt/JMu8W5cGc9NbImyHJdFvkVtHx9baCX?=
 =?us-ascii?Q?GE0wgHGGRLY7WVei8sWlGT/D1P/StqV8vvrV14+kyhGzHE15JSsU5+SsSeJk?=
 =?us-ascii?Q?2nqiUEuSrIpCfuIW5tIxVn6EzR2o9f78a+rFh6+RwUtVLGRPp1zZ0rBqicse?=
 =?us-ascii?Q?3QJJLX88kEeHLLqVIzSFOVnYqY+DHkKsGu3tOQ+OfUB4fGcLZO5ldGT4uwPp?=
 =?us-ascii?Q?3wN79gsP0lH2h+6h2963mLFwsS2QSY8R4YhWJQegvY3XJDJHtXGen2o2SHUy?=
 =?us-ascii?Q?GVLwfSayoGt3rbW7v64wLFHJfhor4USTyi9zifE6Ma+dnoWC9/MJ+YFv5jaW?=
 =?us-ascii?Q?MRWrSoavqtTDWY0LHPoErxihgHu6mzSqe1QOo2R+CST7Jn8j3rsH/Gxgchi8?=
 =?us-ascii?Q?FZvQXzIhdurRNOWptoT9QNd0WNEvq4TPqPlQFODU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d7e887-5e68-42d9-6e0e-08dc1e9ac821
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.2272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPnfROa9D2D+wSfrWE3Eiryn7OBgAmc+QvHHox4PKOU6wthutB5yMpXF3CRbE0cc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

Continuing the work of part 1 this focuses on the CD, PASID and SVA
components:

 - attach_dev failure does not change the HW configuration.

 - Full PASID API support including:
    - S1/SVA domains attached to PASIDs
    - IDENTITY/BLOCKED/S1 attached to RID
    - Change of the RID domain while PASIDs are attached

 - Streamlined SVA support using the core infrastructure

 - Hitless, whenever possible, change between two domains

Making the CD programming work like the new STE programming allows
untangling some of the confusing SVA flows. From there the focus is on
building out the core infrastructure for dealing with PASID and CD
entries, then keeping track of unique SSID's for ATS invalidation.

The ATS ordering is generalized so that the PASID flow can use it and put
into a form where it is fully hitless, whenever possible. Care is taken to
ensure that ATC flushes are present after any change in translation.

Finally we simply kill the entire outdated SVA mmu_notifier implementation
in one shot and switch it over to the newly created generic PASID & CD
code. This avoids the messy and confusing approach of trying to
incrementally untangle this in place. The new code is small and simple
enough this is much better than trying to figure out smaller steps.

Once SVA is resting on the right CD code it is straightforward to make the
PASID interface functionally complete.

This depends on part 1

It achieves the same goals as the several series from Michael and the S1DSS
series from Nicolin that were trying to improve portions of the API.

This is on github:
https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v4:
 - Rebase on v6.8-rc1, adjust to use mm_get_enqcmd_pasid() and eventually
   remove all references from ARM. Move the new ARM_SMMU_FEAT_STALL_FORCE
   stuff to arm_smmu_make_sva_cd()
 - Adjust to use the new shared STE/CD writer logic. Disable some of the
   sanity checks for the interior of the series
 - Return ERR_PTR from domain_alloc functions
 - Move the ATS disablement flow into arm_smmu_attach_prepare()/commit()
   which lets all the STE update flows use the same sequence. This is
   needed for nesting in part 3
 - Put ssid in attach_state
 - Replace to_smmu_domain_safe() with to_smmu_domain_devices()
v3: https://lore.kernel.org/r/0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com
 - Rebase on the latest part 1
 - update comments and commit messages
 - Fix error exit in arm_smmu_set_pasid()
 - Fix inverted logic for btm_invalidation
 - Add missing ATC invalidation on mm release
 - Add a big comment explaining that BTM is not enabled and what is
   missing to enable it.
v2: https://lore.kernel.org/r/0-v2-16665a652079+5947-smmuv3_newapi_p2_jgg@nvidia.com
 - Rebased on iommmufd + Joerg's tree
 - Use sid_smmu_domain consistently to refer to the domain attached to the
   device (eg the PCIe RID)
 - Rework how arm_smmu_attach_*() and callers flow to be more careful
   about ordering around ATC invalidation. The ATC must be invalidated
   after it is impossible to establish stale entires.
 - ATS disable is now entirely part of arm_smmu_attach_dev_ste(), which is
   the only STE type that ever disables ATS.
 - Remove the 'existing_master_domain' optimization, the code is
   functionally fine without it.
 - Whitespace, spelling, and checkpatch related items
 - Fixed wrong value stored in the xa for the BTM flows
 - Use pasid more consistently instead of id
v1: https://lore.kernel.org/r/0-v1-afbb86647bbd+5-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (27):
  iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
  iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong
    PASID
  iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
  iommu/arm-smmu-v3: Add a type for the CD entry
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Move allocation of the cdtable into
    arm_smmu_get_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Lift CD programming out of the SVA notifier code
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
  iommu/arm-smmu-v3: Make changing domains be hitless for ATS
  iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
  iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
  iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
    interface
  iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
  iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
  iommu: Add ops->domain_alloc_sva()
  iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
  iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
  iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
  iommu/arm-smmu-v3: Bring back SVA BTM support
  iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
    used
  iommu/arm-smmu-v3: Allow a PASID to be set when RID is
    IDENTITY/BLOCKED
  iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 647 ++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 864 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  79 +-
 drivers/iommu/iommu-sva.c                     |   4 +-
 drivers/iommu/iommu.c                         |  12 +-
 include/linux/iommu.h                         |   3 +
 6 files changed, 918 insertions(+), 691 deletions(-)


base-commit: 00fd06da33094bc0176fdb22832b49250847b3fe
-- 
2.43.0


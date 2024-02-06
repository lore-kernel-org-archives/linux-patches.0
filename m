Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF35C135A75;
	Tue,  6 Feb 2024 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232398; cv=fail; b=BLhL7E/xXdOzv68QGSDSOXQjAAKHuMVjERsYHE1D3glKws+gTPvev0LtlKJrFlM54hLbC81iiY6Z2GzR24GkbdhmzPZDU6NDdMZnnATHUdiS0OtiF59ysPr0VHkumX69IEsuNzS4kXtWesVIAHqaeM4ZwBT/ZB3Sh0RrnWsYNkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232398; c=relaxed/simple;
	bh=IG5xW8KE//B6wlsjBES1SBHocDYKwdV03m0ZkSCRUkk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Is8KyGxCgP2qHibaABY2Ac19qWp18qVYxBfijPnpSh8VmGsKJ6m+h20jME99dFudCZKmlOvJTkY0c+iwhx22vzHKS5a1pfZqdL0J1VhjqJ3rLFPyHhXQfY2xY3DDOmxRHCfdnzj1G9IduVwlPiq0xbHCyLBA8vX+mlXL8WYSVow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XttBipUR; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XttBipUR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhCln57Ef7kzU9K7byHC9cOx2CwvJNmhDSNpok8Ad5PdJURya1gG54mgCRQMmDkrssmDO5YFXExLIAuleayJozd2i+0jM9wuv2DYAnPR5+HxwqL6mAzeggK+5uecaoD//+AotEFEgd3PJpMM+BwvBthYUwJ8NsGHyCOb8ROWDC8nP5yzw8xxFcuIq+nAPWRQLUrTDazJEVoTODWzOn2FCNc3Rs6Lbo6P55tC53jGFDMkE0v38CwkZeKyoN2w+kavQBUNUZ5TmukzCqWObZ1M6blaCIWSvka/Mc4WqOju367P+bmlYZABRPncZCFPQ13itDL7sarp5Hf6HDVVfnd+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCJNbh4fsneNbUd/Lqlm7ORKzJKwipo/k+nOBL3L8dY=;
 b=JvECxzdkA3EqgoOpBlDP9c0P5FhmLsukDzsSyusnMr9IJRNo7Ipflckzf2kwm3LQJdvX/XE7S1bbcPwyyqRq1zPIoYB4mtp54cFNxj/QHQXP5uC+IEnkk8bO3vQXg3b7VH3CV94l1iFTtVweuGQXHysIZD2YrgtjJgt0of7fS9qMx6TvMGEoC2DsSv0IaQfV0pqnkPEQ3Gblc13inOi48lIfKbzHnwkzboxU/fn0EMZO5/I0BvRrDwF2qXRzMQQ59PrI4ZtciiCKhgWk7fMryZ+tIw92E8IYPS3QDKx+rsTZsePrWKc0knVmC6u4SmrevZii6z2TGD3xc1RVQDslHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCJNbh4fsneNbUd/Lqlm7ORKzJKwipo/k+nOBL3L8dY=;
 b=XttBipURpfUmqTv9e1GRt/9zI96H6vXCwyzrTMxxLByjCBrMlrnxMcPJb83XaVJbrULRa0NVlzT/ROUeXW9t2Si6nMApUmnENi9naomqYjcIusaL71fz6EbKQ3t6T2hkVvBhY4CTiWKO1SBW13Z1Jnf1BuHbc+SCJLUdRPajeCv6Eu5/bzSpTGEIl7A3uN8LcrHe/er5SdDxvNYGiEeX+gbtjjrDdYUbyatE5+DD5tPOJo9pZXKsFVejQ6EeHCgdWDLQgVsf4YBh7I0WAsO7rzrHZ1kvT79WsbIc5Ub2y7C6Y5SS+BChtf7j6o0kE/5wvkDJCfnIVRr0vm9dvG/RuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:04 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 00/17] Update SMMUv3 to the modern iommu API (part 1/3)
Date: Tue,  6 Feb 2024 11:12:37 -0400
Message-ID: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d778014-8f63-4d47-bd19-08dc272618e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L3Vhytljs61gGI8MpNfLQO+/f5PxePK0hCAep5Fftvwo3drdcOi4RMjYOUEBZ5ZZWwhKSgGZFOrl438cxxjDa6wS0N7WHwS6n/tD7HIdQCRKQQQpio5oJ+xChxv+GS+L3Equ3Lrzs5oOTX4Is6DcBb9mQA9X7qZ3L6CQvja8FQ4YJQqXmYsUvUXidjiyozTODR4Ju5eLmbKzH90YHlwWPnhvWHZDLL6eAtO0THT0S2prRwJ89c8U5PrWpj/uwyvOzY/ZuubA44WiT7eiLNQ6NJmNB00iAxDMzcwpfyzFIvTqHGKhDTAcLJbbzyXuIAILb5q+rqH4eZ7nWmbcbZ7uSHiug+SGzwSPOEkRDeX/2e0KhenQr77b0aCwxsSs2HSp/zY0aRnmzbyrlgO+FIOZAQeAzNiy/HZE3Qd3tQH/LCqo7ZoIBGbmwuZrj0+WGCzahe0zkVElSV08znH0lwxSwneAD73mbwqIze7Ajratdi+Dq1e0aJGX+LyWh+wARpaZsYkrKgap1CUnkg7IqeKUfT0rkqricJFYzOWyc2OTnYhQc4dNb631NucPKZqg0WFqYLVqBC7jYp9hQ8EzS7Zm3hBQbirkmssAhjyJFhSFd+Sru/qKdkK3/27bQ6cZ03sIfzH9YHElbddsgR8VIivC6QPf7752Bxb9C3RZTqnhkDluM5qP9oofu/N4ZINZ0s70
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(15650500001)(86362001)(5660300002)(966005)(478600001)(8676002)(30864003)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZrXjTzv7fcptVPR22VeruYUhh3ZSo9Pq9+NHfO+RVq1d06mthEtVxt0vgIeq?=
 =?us-ascii?Q?7wHk18ZKmrafQ/ols8uQbOkNoPPvqqJBWI16YgcBl823mj2DXqDZD1Tb6EYy?=
 =?us-ascii?Q?Z0RbDZ3OpPQia2xylWiYYIcC/2P+sxed4Z2elBEWuC6YqFBXXA/DaUDBI1jg?=
 =?us-ascii?Q?rUId5AU1u0gRbSQrtBEpyMLuBJzrMsx4s26JqFUsMhqQpLeR8iDlvtrvJRxZ?=
 =?us-ascii?Q?44wI4nd7J2Qi1GsQMOpy+d49rowFF+ZemKDw+IAYxSYnq9UOefiQ9683+iMm?=
 =?us-ascii?Q?mMSNx3AtbJWcuSQ/SCjVI0Lku3Y9GJPvwRbMixX2L4w/aG/VThMPwnxCmpml?=
 =?us-ascii?Q?+oyGMG9I0QJTtRHxY1mUBZlF3i+vWOMOxXK1Ih+z8BL7xGl5eXpH1jw16VtI?=
 =?us-ascii?Q?0zWWqS9n3UrEfM5wMQffDCVKegXHfrnhCoVgZMR5sVwLrQZVZqkcu3grAuET?=
 =?us-ascii?Q?VsQY2blUj/Xz/nCSUohDYI3vGgOSJUZxNP+waVV6TZqI4bhkw5U+CGUhkZGS?=
 =?us-ascii?Q?AQaLIafkdAe1nJ2vyhuin4KcLfEzhHObhVnNnzssCPqsyV8g0VrsAuRZQxuy?=
 =?us-ascii?Q?bkuXceSpHFzSZFHCE1TPNeXwwnHVA/I6N1KWY6sGAnYXhiiMo1zxhhi8C/OG?=
 =?us-ascii?Q?FLfRCNqKQAeRkfO8y6waJAWd07QS+TE966r7/IjPtRemXcfaz4jeA7DA2Wdv?=
 =?us-ascii?Q?2T4T7zgZmzeXtIFPtWaGNuQ7ZugEhhn5+BQd6H19MV+dvAKp4mdwerm8GntW?=
 =?us-ascii?Q?PjXWSK6GH93iGFnpNO0ZXVqONG2V3bNrozHpj50s+exZ7WLrKNZs3rADdGsk?=
 =?us-ascii?Q?xinZeuS9GSV/Vjvla23zeoKAk8Ot0h561J8psrXw3HWxN3RstaeXDaNreGPu?=
 =?us-ascii?Q?KAcUBW6Tegpmy4FxaQkoo2+JB5GHrTprsZOxXGepa4Cb85Uop6iKsFntS0kf?=
 =?us-ascii?Q?M5zHiB/3fmMj9aFXYXQMZ9AUBKbd4aiaXPFmsJ/9gamqXYUR7fRILdAyDfZQ?=
 =?us-ascii?Q?ILGLHpYilG2TurNNM4KKToXH1c1gDsYrd2XUnPP9BWMc0onk0m1PK/aJHPZA?=
 =?us-ascii?Q?yyDU6aw7wd+K1UTktQrdsq79FzNviBOyCFzJNoiCYNLIX2j8hFpsd7TVSRQo?=
 =?us-ascii?Q?HoddH0dFw2Ggwqz1Zqtrg8QdQ7uF5cuZ/26Z2Ydkdmu8GArmnqNJxmqbUqbj?=
 =?us-ascii?Q?zzF/pEPWq6yRBg5OoloLsSB5N2AEnCjHSnSP8duIgiMsVS9F3gGMZxfNDRXT?=
 =?us-ascii?Q?QjXUiVnubV+mamnLzucyD/PS7xAah35tj6DmbGC7mYvjtd4blEKtBm8MZDVT?=
 =?us-ascii?Q?BBKcgfTbL8emcHG0tyWy4mfPo/D/nfM1v33JxTtoed1VH/vaOzmNyLQnteZu?=
 =?us-ascii?Q?eVgJYJ0CPHw9pMVbHYUZecZ7oTgGmryOZRxaufQoFOAuCJoeIdk1/ABBN+83?=
 =?us-ascii?Q?UEJsLS/3M8hAfFI/HoyUjhMUxl152AOQZWHnkcMBmXP8hMPZekdeCCzUDyWZ?=
 =?us-ascii?Q?vYb4mCmXKHUTn7sCzX0AXsaF7VKAwdPSzUREmAhVobOGOYH1/ZWVR+dadT33?=
 =?us-ascii?Q?rKPp9ZkEpo/j3+6X18F09VOu2xqxSa9Wo0Qlvicy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d778014-8f63-4d47-bd19-08dc272618e1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:56.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkjXr57Z6MSPWi3rm2xkDs33YPTPTNtM9IKPyEH2NaJOlHy0dpnwiZRaRuuuKygM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

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

v5:
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

Jason Gunthorpe (17):
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
  iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
  iommu/arm-smmu-v3: Add a global static IDENTITY domain
  iommu/arm-smmu-v3: Add a global static BLOCKED domain
  iommu/arm-smmu-v3: Use the identity/blocked domain during release
  iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to
    finalize
  iommu/arm-smmu-v3: Convert to domain_alloc_paging()

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   8 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 778 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 +-
 3 files changed, 549 insertions(+), 242 deletions(-)

The diff against v4 is small:

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -57,8 +57,7 @@ struct arm_smmu_entry_writer {
 struct arm_smmu_entry_writer_ops {
 	unsigned int num_entry_qwords;
 	__le64 v_bit;
-	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
-			 __le64 *used);
+	void (*get_used)(const __le64 *entry, __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
@@ -1006,8 +1005,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 	u8 used_qword_diff = 0;
 	unsigned int i;
 
-	writer->ops->get_used(writer, entry, cur_used);
-	writer->ops->get_used(writer, target, target_used);
+	writer->ops->get_used(entry, cur_used);
+	writer->ops->get_used(target, target_used);
 
 	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
 		/*
@@ -1084,17 +1083,7 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 
 	used_qword_diff =
 		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
-	if (hweight8(used_qword_diff) > 1) {
-		/*
-		 * At least two qwords need their inuse bits to be changed. This
-		 * requires a breaking update, zero the V bit, write all qwords
-		 * but 0, then set qword 0
-		 */
-		unused_update[0] = entry[0] & (~writer->ops->v_bit);
-		entry_set(writer, entry, unused_update, 0, 1);
-		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
-		entry_set(writer, entry, target, 0, 1);
-	} else if (hweight8(used_qword_diff) == 1) {
+	if (hweight8(used_qword_diff) == 1) {
 		/*
 		 * Only one qword needs its used bits to be changed. This is a
 		 * hitless update, update all bits the current STE is ignoring
@@ -1114,6 +1103,16 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
 		entry_set(writer, entry, target, critical_qword_index, 1);
 		entry_set(writer, entry, target, 0, num_entry_qwords);
+	} else if (used_qword_diff) {
+		/*
+		 * At least two qwords need their inuse bits to be changed. This
+		 * requires a breaking update, zero the V bit, write all qwords
+		 * but 0, then set qword 0
+		 */
+		unused_update[0] = entry[0] & (~writer->ops->v_bit);
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
+		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
 		 * No inuse bit changed. Sanity check that all unused bits are 0
@@ -1402,28 +1401,30 @@ struct arm_smmu_ste_writer {
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-static void arm_smmu_get_ste_used(struct arm_smmu_entry_writer *writer,
-				  const __le64 *ent, __le64 *used_bits)
+static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
+
 	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
 	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
 		return;
 
 	/*
-	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
-	 * attribute/permission configuration fields for the SHCFG behavior.
+	 * See 13.5 Summary of attribute/permission configuration fields for the
+	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
+	 * and S2 only.
 	 */
-	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0])) & 1 &&
-	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
-		    STRTAB_STE_1_S1DSS_BYPASS)
+	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
+	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
+	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
+	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		     STRTAB_STE_1_S1DSS_BYPASS))
 		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 
 	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
-	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]))) {
+	switch (cfg) {
 	case STRTAB_STE_0_CFG_ABORT:
-		break;
 	case STRTAB_STE_0_CFG_BYPASS:
-		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 		break;
 	case STRTAB_STE_0_CFG_S1_TRANS:
 		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
@@ -1434,10 +1435,11 @@ static void arm_smmu_get_ste_used(struct arm_smmu_entry_writer *writer,
 				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
 		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
+		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
 		break;
 	case STRTAB_STE_0_CFG_S2_TRANS:
 		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+			cpu_to_le64(STRTAB_STE_1_EATS);
 		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
@@ -1519,9 +1521,9 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 }
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-				      struct arm_smmu_master *master,
-				      struct arm_smmu_ctx_desc_cfg *cd_table)
+				      struct arm_smmu_master *master)
 {
+	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
 	memset(target, 0, sizeof(*target));
@@ -1542,11 +1544,30 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
-		FIELD_PREP(STRTAB_STE_1_STRW,
-			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
-				   STRTAB_STE_1_STRW_EL2 :
-				   STRTAB_STE_1_STRW_NSEL1));
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+
+	if (smmu->features & ARM_SMMU_FEAT_E2H) {
+		/*
+		 * To support BTM the streamworld needs to match the
+		 * configuration of the CPU so that the ASID broadcasts are
+		 * properly matched. This means either S/NS-EL2-E2H (hypervisor)
+		 * or NS-EL1 (guest). Since an SVA domain can be installed in a
+		 * PASID this should always use a BTM compatible configuration
+		 * if the HW supports it.
+		 */
+		target->data[1] |= cpu_to_le64(
+			FIELD_PREP(STRTAB_STE_1_STRW, STRTAB_STE_1_STRW_EL2));
+	} else {
+		target->data[1] |= cpu_to_le64(
+			FIELD_PREP(STRTAB_STE_1_STRW, STRTAB_STE_1_STRW_NSEL1));
+
+		/*
+		 * VMID 0 is reserved for stage-2 bypass EL1 STEs, see
+		 * arm_smmu_domain_alloc_id()
+		 */
+		target->data[2] =
+			cpu_to_le64(FIELD_PREP(STRTAB_STE_2_S2VMID, 0));
+	}
 }
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
@@ -1567,7 +1588,9 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+		FIELD_PREP(STRTAB_STE_1_SHCFG,
+			   STRTAB_STE_1_SHCFG_NON_SHARABLE));
 
 	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
@@ -1590,6 +1613,10 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				      STRTAB_STE_3_S2TTB_MASK);
 }
 
+/*
+ * This can safely directly manipulate the STE memory without a sync sequence
+ * because the STE table has not been installed in the SMMU yet.
+ */
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
 				      unsigned int nent)
 {
@@ -2632,7 +2659,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		if (ret)
 			goto out_list_del;
 
-		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
+		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
@@ -3325,8 +3352,6 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 
 	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
 
-	/* Check for RMRs and install bypass STEs if any */
-	arm_smmu_rmr_install_bypass_ste(smmu);
 	return 0;
 }
 
@@ -3350,6 +3375,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 
 	ida_init(&smmu->vmid_map);
 
+	/* Check for RMRs and install bypass STEs if any */
+	arm_smmu_rmr_install_bypass_ste(smmu);
 	return 0;
 }
 
@@ -4049,6 +4076,10 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 				continue;
 			}
 
+			/*
+			 * STE table is not programmed to HW, see
+			 * arm_smmu_init_bypass_stes()
+			 */
 			arm_smmu_make_bypass_ste(
 				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
 		}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 23baf117e7e4b5..23d8ab9a937aa6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -249,6 +249,7 @@ struct arm_smmu_ste {
 #define STRTAB_STE_1_STRW_EL2		2UL
 
 #define STRTAB_STE_1_SHCFG		GENMASK_ULL(45, 44)
+#define STRTAB_STE_1_SHCFG_NON_SHARABLE	0UL
 #define STRTAB_STE_1_SHCFG_INCOMING	1UL
 
 #define STRTAB_STE_2_S2VMID		GENMASK_ULL(15, 0)


base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
-- 
2.43.0


Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E227D3E2;
	Mon,  4 Mar 2024 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595873; cv=fail; b=jgXmKymr4c0tynMN3WNm4x7N5WEZEZiwetpZ079rsdcjRMh3asBabuTC/FjgNy/Hh1gF8kB18I82txgNaBHVU8LOCQN+jRF4ruv1FHKjvnHkQNwMRgLqLdNVSDZ9XPi8rCppKagYVz+oWKbrnLO59EkEZAsaz8ucfV2pnr10Xe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595873; c=relaxed/simple;
	bh=6Wz8icCEe+zF5JQI8nsbcPosOkpnXQt2D6eGyt2d4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pSjj46qy1gQBxL5CgYiFtAmDAjMMVhGf7A+dT1W7+y7+PvPXDJMM+2C5lq2cSA3p44Kr4C3QPHbe/GmaJu3mRpk3+GaEmipcZNAvwGlOxc7oZHMVhh23lo3F+L7uIdVkC9TvCvgL3ZtZaF4CbVFMQwARmjLC06YxLspLfS8yFfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bwoZFSoR; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bwoZFSoR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkrNT7sTuMHKDJXjMYcnO6Rr+QsvgTUW4Aoy0/p8oQotiV8md3X5M+WuBmlgFnrHn8Vh6DAvdxv7Zzf8Ncfu5WJFOW/hTU1bFLVdMfvY7yLH/pPlkNqhrt0TpXqRjHlUa+0RQCjzxy/RowLY7v8zz/v53Gq9nbvcQtB/Yn9rsuR0BMo+JIJ2B7b0QYPOiBA/MnZoxqGk94NMPfTYvu2B5/j+LaVvx7DIVUBbyDl7eMMiLKLW4o5HDbBeca/xqwaMeZ3GW9pfdEQhUf5HOzTNKgGEcsvGw2Xr2Uo6mizXj2SRcUmXyowf8zeXdjSNLEd37CKKHR9xaW6tp9R3EFLTBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIsZEPSzyq/+umhSgR0ZHhQ8nwujIyjoJvp+gXOPHc4=;
 b=HDdyFJw7KlQ/l/3hL51BajCR7PyJ9pNmkDrx6fsh3LWMQej+v8YHWpWT1iIBu6ASYWBgpAo/ahl8NL8iEVdcfoYwaBC2vq+MiRmCCLDFwUP7Cb11fTkzrSbv19rcqcAgIh4rHXV5pxzn0/IDaHFux4L96Pfynb/hisx1Urw5KlOlfNT3jTLFCgJ61TUkBMnT66tREP+BVwLVnY0Iyp1XLoXb9mx6ss/E7f3EwAkTOtKpSsGe9zhZhaZ552VUfOezQJae4UQNwEioEEw2OsiMyOgmQGWr6Hf2D2hWtBbvc5fNAW88Y33ZGFNKV+/y7rsnxBhrcqTSoNutmij8lCtFNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIsZEPSzyq/+umhSgR0ZHhQ8nwujIyjoJvp+gXOPHc4=;
 b=bwoZFSoRfucBGebua7khxecTJL0qH+dy9N7/zRFJAvr/I0h69Yqw6rRsrLmiYSV/Lx7HJigWjsNY6QBvZjhs7biBX5qK539zOwoDucAW1N2RtdHEAp+jSOPVmYIfd7ZZRNNhcOQ7KcyjwGbuosH/HGe5xBEO6vyc8W6Nv5oF4hW4HMPGmRq/MOf1O3vwOUjNey+1kXiieHhNYJRHXw9DthDv0FUxKtUtR25luAqCO82E4gtGUWo+2TuBOU4J7IjXxcBQSf/Bb7TK7VAFa8o+7uzyTuYGOVLx2IOHNYnnElsZDNt2MJ8xddbiqdB1QjBZT3h0A26c/lrSio4xXjorlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:23 +0000
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
Subject: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Date: Mon,  4 Mar 2024 19:43:48 -0400
Message-ID: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: ae868630-5518-48f0-233f-08dc3ca50189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Q9G/+a+j05n1nYzY40ro48os15/E7JevC6jVFdJspkils6VmJKqJmLcMRiv4FOTKJryemn4xFoUfBwc3qWXzKd2Hq8f1cOWKDFpcysaTifvM+/2VjeCSs9PFkyD56u/0F1rj658Qsp0Tq4557WfHQXWW4yXa9kC4LhaqSn2DqPK9tR7gwJok5s+UZGf3J/XRkvNVB7YNgFQsf8YFdFfdLxYaSz61ehDOIfWvEjvh2kUdx1PUF0kMnVNA6z/fT8oWD1oPkb+dGoFl/Hu7Zf7DyGzeABC8wx6aduFhR3l35/HxJjo/oS3avbg6xOWbRsJv0APeCCkhDRvhMsrjbHiLtQiIzAjKOwsbz1tqZkEDH0AS7LAUyn+F3nLesa+e+SYbcY83g2T40P2KZOQqUOHnxR7nHL9onrxAGfQhFxtuRaLsH6aBbQ+5ja2D+O/u6hU+Qve9Ci3nyh8JZj6JARbUBiV5N7OMauFh89bpeserVyGgd1shpBALcX6eyJIkWWiypftWhBuYgcgxUuQnwG7k8aQVtKWZGo25Uk0LP76zXXh+6Z46UJaWxa7aqqYY0yqX1Wdj65wz0rpAj5TGHQ4FH5crARf4eeFcI32+Vwj05wGOJ0knXtpifwc3GRWhy/B5kLEaHo1odeVoUPEqrkWQ5ANQJVB00Z9IxrCWRfByhBg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YKgpt5GuFEjFZileCERURLOOSNAVTHPP/i1OypTdISITYu8JuEwlJqMdoVsh?=
 =?us-ascii?Q?uRvEWb+B2V1TsxEKBy905jnKFXSQOGlZFu9O1MMP5YI3BVpObG6aw7hYwYMR?=
 =?us-ascii?Q?KEqlmMO/YayZbsCJvFCCj7qlZH84yWGoiVVvUD80jx26xSI8SZqukvRmZdD6?=
 =?us-ascii?Q?84T/P7oHD2baotMrBM92i9boFyqudqWIFeHx9DmXgaIZ47p0LJxegwguAefF?=
 =?us-ascii?Q?n7gYBHDiJ5Uvv0RTNOORvNPlgYI5Kh6HSkC1trqZx4SdM9fPRhF4vReGQ9qZ?=
 =?us-ascii?Q?pRhltWQCQ385BxlPjHnPgRBjKBRY2yvrY0hZ4FCZZumZTEUYOlOmJ1dChMXI?=
 =?us-ascii?Q?9Rrv6xBA/LIbwIDeLuX2JGCmy1rvb6VXOJz8i/ntH13IBfEVRtYLzOQnxKyE?=
 =?us-ascii?Q?vIHn/DcS90tJKkaycJiLcopORe8Z9zvxi2HvEKnhEEeVytyqCJEyN48F2j6d?=
 =?us-ascii?Q?zJB+Cqw+fbU4Qdct5RVSbyXvter1nLLosuhSzrYPqB9m9XVu3sy/EsuAnfBx?=
 =?us-ascii?Q?oGWVLSGjI1fE28WinZjPqHu+tx44GBqWRVuy3nTMonBPqFDxdYWqs2cav21W?=
 =?us-ascii?Q?/Dff4mEVycDN0xdGWmraQ5QnnyGKeN36KxwyerYTg8ooYAUB320oQ7N+RxAW?=
 =?us-ascii?Q?1DvT7tJ9jRSldQI/ihmKHRgmJ34/rZaTq3CeQH8ry2HFGgRprKnC9P25gkUp?=
 =?us-ascii?Q?f5/5PJ4NsEfAmntcbMSjtDpmBvKIkCWtlPrUb0MefCVw6HFxyKwpzURUpU1y?=
 =?us-ascii?Q?3JvYGhF4+WrknJ/GcUWI+lRctYBHeN//1uxeYiZoL7xbaALaZ5CWTE2+mgGY?=
 =?us-ascii?Q?69bptMjmtztb5Gljyc25m8ddAJyr/GadGNpx5PL3qM2rqfwOFHaNYQ1/sqCp?=
 =?us-ascii?Q?GlIdc5IS94NM8YNysEtUQCy2VxbH7PSQ+UCi4ciAMkDbGmomnIPCMAlc8QYL?=
 =?us-ascii?Q?Oa1ic7in9Y/kvZ+C6Y5znIyWZFv3Hi+P1RPHeUGbQUZPA57fyAqzgEOEGQYk?=
 =?us-ascii?Q?f8RC0YyxpbGI/McKp2pEh0dQ0w1El6VgasqkDGHK/ohff/Hre5k7sP68fBHl?=
 =?us-ascii?Q?trr+YKpGHvL7OI1lFbCT2RuByryTSoILlv8hzPVyH/7ozeGQr/1GRWS+W15D?=
 =?us-ascii?Q?d2VMxgMXPrruN1YpaRQNCFIAqHIlvAzEQWrf7yFLf+J24AFjdjdPcOyFBipF?=
 =?us-ascii?Q?3PG0b9Jk67ltHATTTyuxDbNx79SDlFjI+vPzT3UkVo8CICTkeVxTCzp8/5sp?=
 =?us-ascii?Q?de2gYSqDiW8A5jAyqrhVz1k5qwPfWGX6sdWYS4avvO1llMeXzohQdy1A/zn0?=
 =?us-ascii?Q?Wo5hbBxYuq0vst0eB5bW9VChTH4piDZHX0z53t1QS3L+JR/TAcRjezfKXCV1?=
 =?us-ascii?Q?knTPeCjz6ClLQvGqbcwtJbyzeDhog7+dqGUKo1WxwxLnBGETuJjX1+Oxec+1?=
 =?us-ascii?Q?pTcs4Fub3AHk50nWFTLs4wij+6QRPVtp3e3RqP5shGoiZPRpBYzQlOea5U/O?=
 =?us-ascii?Q?z+HdpvbicLCp7NrcNU060Occw4bZdv2erwqn6Ar2W7tfivAyykC4dcVgsDiP?=
 =?us-ascii?Q?o+mUNN9n2o/4RoAugEqFEpOhs+hW4xI+7/0OhEAx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae868630-5518-48f0-233f-08dc3ca50189
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSM7JZ8NC8FzFmrtOfslSZ/3L/1JwFJEy6vwAesfIBpIQXcItQMnOZpVz8VyGEru
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

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

It achieves the same goals as the several series from Michael and the S1DSS
series from Nicolin that were trying to improve portions of the API.

This is on github:
https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v5:
 - Rebase on v6.8-rc7 & Will's tree
 - Accomdate the SVA rc patch removing the master list iteration
 - Move the kfree(to_smmu_domain(domain)) hunk to the right patch
 - Move S1DSS get_used hunk to "Allow IDENTITY/BLOCKED to be set while
   PASID is used"
v4: https://lore.kernel.org/r/0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com
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
  iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong
    PASID
  iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
  iommu/arm-smmu-v3: Add a type for the CD entry
  iommu/arm-smmu-v3: Add an ops indirection to the STE code
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Move allocation of the cdtable into
    arm_smmu_get_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Start building a generic PASID layer
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

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  639 +++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 1036 +++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   79 +-
 drivers/iommu/iommu-sva.c                     |    4 +-
 drivers/iommu/iommu.c                         |   12 +-
 include/linux/iommu.h                         |    3 +
 6 files changed, 1024 insertions(+), 749 deletions(-)


base-commit: 98b23ebb0c84657a135957d727eedebd1280cbbf
-- 
2.43.2


Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ADD14E2F0;
	Wed, 27 Mar 2024 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562919; cv=fail; b=EgTOXqK8i1C3djdNx89myF7I76c4q2MgqFNWLaB/WqIw45IyxN02dBdEnR/SVLHK+VbiUo/XZ0YgsDhuFeOB4wl2h30ld0oV2rzvvRnbi6dNyEq2L6f6eqBpdnroyusvPJYwNmJWw2lUo18rByflZFXH6Z2zOl/0yoHEs+zwbUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562919; c=relaxed/simple;
	bh=EZatpWA0dVy0ldDB1Uz9q/OUxb11dzYNhCS/e2OrTDA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=telfPmM9HJD1O7E1OfeIFtgrTfnI1Cm3LhW6HGqF74krkv/EyerDF9sukgyRAWU+MXJoEJc9hCZ9xi+Gqvc/6nwKmCmI9nzATYxO3ISlLngynbQfG4E7GY864m/eC/JaoQKUigCfhv4NCHceZrk8SZeWMSAYrVYwEJNbM11jXs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uRmeQ+W9; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uRmeQ+W9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9BJbzDMjrIdxscKhWDhPkaR+IhOVfmQx1X9IYwByzdxerEXsD6U8KylQfW1QT1rkGaK/GUrN/KW9X6H9mCD8VmFI9hKTPIS+wQLsAVOgREmMZfMBd5gppE5qb9QjhWR6Wwy4uSCE8Nupj1xWjYdJ6vOYKgD0piDNxS+4kBR09LZd3NSiFf3ZQRXY5tfrXD0wi6VY0GEMRE7i0alPNNatzIpoMMNyStT5sOAK7sa4uv+9W9XrWhJ8tuw6UUW4MEeozTkvx/rfVkov4bktdLDnpiQKojCcQbCaveFv5atnMMhbBTk0uYiKDpwlgZidquv4QUCoi7IK1Y5m7cl3N8kVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFncPi1JzPxFzAsURzoOwYDSykQGOVvkVBqVvekN+4Y=;
 b=f3Uo1CS0OoGa4yf6fOwi2teZl7BrkPXFijNGvnpPeDxN3kE+SGJKHjPiNWKmRlX1c8RFhDXQ0m1xD454GtE8tA3JT2uZicG0iTVq15KtgZQTsCG0eFdTLV3T+61rlA36wyns7bL9+AoU4b6rBLeKnOoggDZsJry9Sez5HcKFXU+Pkua8Dzl3RY6t1eUpaYgQ+spq3SlMBeoqmHDk0QcObSvMe/k8XsGPi9mRvCE8WoXbIhLP0Ys0tUrjWwDRpiIdcRCM0ONy4QdPZAqeH0K8faNsQXRJ8PblJsYwGnx3QrusqzlHZFzLCChYD9oTmgj9DKqT/76b/Yw+T6kdCqCD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFncPi1JzPxFzAsURzoOwYDSykQGOVvkVBqVvekN+4Y=;
 b=uRmeQ+W9xMgPZPcZyXosWm1uGWNO3XA4kaAvdY1E/r+sZPZaWDDw66dEZsviEUsQbllisbxZN4uMEUUJ0xDvQ2bueoaxsst9a7zZ61664CDlpLnLiUEs7/IHni1s5tZrB/Qhkgyx7+EyENdrHqTeY7QGRBy4ze91EnSWghdkQk268Wn/PetCE1xKI/mrGtQ5h1mDt56Ss3p9AXaKqN0OBFWJ8XD3TmwQIDfoeXKEj0QRY7mmDprk43O4frkbG28TTDS+Mf7/fkkznIKVbaMxgtsngJsNQwS9KNeX6AwVvPaACLwJxLt+KpE15SpKKhJnGaGnVog/TKr6VuSlDKk0oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:31 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 00/29] Update SMMUv3 to the modern iommu API (part 2/3)
Date: Wed, 27 Mar 2024 15:07:46 -0300
Message-ID: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:91::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 763cbb61-2748-4a60-1361-08dc4e88e1f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ouckjt1xWCAqhatpVUhB1ObAmEDPcUulgxZGSV+NwI1RpXwjJIy1h6iZnAj2OrIw+fj8aWKoEpLCIMdJDbn4ZG84OVlki5Rn44LCSl0Ow25cviSAwceBWA5/dnkfr/GGQyGz+K95IOS4A1Kiok4YD2Q2C4r0omiIq4MV0Fw3RXtF3bjRvWsOhbdtJ2hDz36qLsFQrDkbMt/4IHtCgQIAW8PPvOq2JZ9v/2HbHh0qHoqUmqwkjmZzAauLSzfk019iUIwjFwyqn+Q40k1rOvnx8VKhQ4fuSucowlIfFPnPJcUDxF0dwSd1kKavr38JrpK91/XeNbTLaqXNcO0KV9zhKIjXFZL+I00ApQuU9gRdVx7ByPYGD3mPToFS7rz1c/T1FzVfJH15hla4QycmLs/iWShFV8z7myMdO8N2ytTG7g03xKbuysQ/c9i9arVpeLgYUVel6Yv5aknMusb5tb0BMqljfYKBylt7yLOrohWpwbbHtXzhT8/zCYYb+JJIZjrq+0cXR39eWDYiuaVDhsO+kqfdnFqt1FwTXs4fSgpNxOLHdmXl7FC0lZM3zOWNTxwpz5khtOjQ04XvglueO7/rBwB0o4+rQqKAPWC4i/c4EdG9jHLjmNnE2UzZ0FFanBR27d7Zgp4qMB5b1uwJG8n6UZIABDTajwZ/1jFQMlCZA8o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WSURVTJh1oRwgiwqpD2DaF6PlUw5/LAQqltJqmHso8p0gUPGksc9hz1UPKqi?=
 =?us-ascii?Q?7+yuycb5zgHmStBX0UwisVAHdageiXlUmL8NIj1k0qRoWLqBqFxGN47/QsVT?=
 =?us-ascii?Q?OKWYY2o8o0uoX0xiZDM/2J9+Yv76yjNtgFV0dU0wocrjJsM69Pbm6K1U58Hd?=
 =?us-ascii?Q?ikjgmp5ZQs8ISANUMJI5yDaqBEdRUlD6tQXM7yN603HEL7x3ZXpGg0U+ghGr?=
 =?us-ascii?Q?ToCzuB4t+Ha/v7iUTECxC1SoGhOQLL6orULRdY6Kt3gYeO85cMhBh/2ANceY?=
 =?us-ascii?Q?MNLvSmldhGwRMXbvmOHlmEVyK4bEGba0SCvd0uwZeBKLmlletGvYhgPojEiY?=
 =?us-ascii?Q?7rYnx86QT3r5cSTLwpDWN9GF5+WpCW+xTjabNiJnLU9yGl1dAlhqPpWrlhrh?=
 =?us-ascii?Q?OWOXkg6NFpuouePD7ANn53RGbndbOu6gOU3NNIiyuCsN3LH9PvJuYhUVhVBK?=
 =?us-ascii?Q?ecjUOrbv5heSnlAuo7/peuY6K3C0pOBlwx7wnbRT8tAwKU3vethZRJFRjdHN?=
 =?us-ascii?Q?BhomMXbYsqDzcxt+MgO3uZXp5w8qTxTk6jHRlLuXFkWimuqlMwkIdj8cDTCj?=
 =?us-ascii?Q?PyOfzkhuvVnYk5EJOJc4bZVPz867Zm99KJZn3YlLUMUSVJBJgFxe8fmYal4N?=
 =?us-ascii?Q?DagzlB2iRLRmgqyRC0slTqkRHAE8djO1IzFQzOZSIGMFI17NwTC/tpSYXMVO?=
 =?us-ascii?Q?Hx9/11csQ1TRD3PCg4vuvwPb0iB0eZ6FlcsUV2npuND9xR06lIck7RlUPviC?=
 =?us-ascii?Q?zm4dwLElzee7IKmfuqVVDK6ER/4PbVGSmUDHlpNhKUlYjH55dLsx6/0SWADv?=
 =?us-ascii?Q?0gRyv6S9MMMnkOynYJPoDB7xXgcv5FSyL4cDhuPIvjEFxw4fNeOQ9jQYINzH?=
 =?us-ascii?Q?ZUlsR9Qr2M0mgEZEH5LdIObjYVx7yVNQbsBGnCO6qqIUWRz4kDzEhW17lRhY?=
 =?us-ascii?Q?1ofCRBmFrT9nHsre+23MNiKaTyBiJTbtJN4OG/CMVT+outsRyrnzyJx9CJHV?=
 =?us-ascii?Q?b2eGRTHnt3AUTAdrC9tO151OY3SsjFfeu5umUfo5dPEokx1swhJOenitsTRV?=
 =?us-ascii?Q?Q5OrTHs9QPCqzYifa1twJftJgIuCIbVEXDnbPoeaNSDCYcoK47CkTtl+MDnb?=
 =?us-ascii?Q?DP+DVX/kOlmLBrM6A17k1QUSE++OKGzkA/5Yt1jeJCRjNgsmjuPmfDdEBrSb?=
 =?us-ascii?Q?ZROehYY78scXrKTWxv3bLixgFkNgxM+BOntnvyOq6wF/jHy7D7F7OyAY+lSz?=
 =?us-ascii?Q?oLgM/30uXRwHUfcjgjkWKgOospvmafFQO6r59BshblAyfhtQf3DbyplmftGy?=
 =?us-ascii?Q?ZX7N1meWmpn4GSKVD+opy442eI9gsJbuPbl37CGPwsEkwI7SNjUCv2P0NJ0e?=
 =?us-ascii?Q?rnuejuFts66S/xneNQtIBOPSO5nLS6OhF5UYfHYBI8RbKP6DRdoJV9mJU4lD?=
 =?us-ascii?Q?Fin/q4lUKcNpwkU0D/heRAe8zLucProqxX8zLKpTMUxSMV0Fk4Xf6jOp7RoR?=
 =?us-ascii?Q?Ldo4LES3QmHYch7fmV2eEIpaPPn6eaWcuyda4REmfH1isaP68l648xValBgP?=
 =?us-ascii?Q?0Na2Tnr0zJyDE/m7IICkQJwxi4yFbvJD6VKLLISA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 763cbb61-2748-4a60-1361-08dc4e88e1f3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBN6ejIHK77X+UQf5AAylQ3PX0+/Go/olW2rpgsxk1lsfQFjuAmp6itkE2IpsnMr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

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

v6:
 - Rebase on v6.9-rc1
 - Remove arm_smmu_entry_writer_ops->num_entry_qwords and just use
   NUM_ENTRY_QWORDS for CD & STE in all places
 - Split arm_smmu_get_cd_ptr() into arm_smmu_alloc_cd_ptr() and call the
   allocation one only from attach paths
 - Remove cd_table.used_sid
 - Fix order of EPD1 in arm_smmu_write_cd_entry
 - Do not double invalidate during domain free by removing
   iommu_flush_ops->tlb_flush_all. Consolidate all the ID invalidation
   code to arm_smmu_tlb_inv_context()
 - Use the right old domain in arm_smmu_attach_commit() for PASID cases
 - Rename arm_smmu_domain_free() to arm_smmu_domain_free_paging()
 - ssid should be an ioasid_t not a u16
 - Scrub the CD target instead of the no_used_check temporary
 - Reorder the patches around arm_smmu_alloc/get_cd_ptr()
 - Add the temporary arm_smmu_write_cd_entry() calls to
   arm_smmu_sva_set_dev_pasid() with error handling
 - Move some of the hunks for the in_set/etc tracking around so that
   use_sid can go away. Use in_ste instead of arm_smmu_is_s1_domain()
v5: https://lore.kernel.org/r/0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com
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

Jason Gunthorpe (29):
  iommu: Validate the PASID in iommu_attach_device_pasid()
  iommu/arm-smmu-v3: Add cpu_to_le64() around STRTAB_STE_0_V
  iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong
    PASID
  iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
  iommu/arm-smmu-v3: Add a type for the CD entry
  iommu/arm-smmu-v3: Add an ops indirection to the STE code
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Start building a generic PASID layer
  iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
  iommu/arm-smmu-v3: Make changing domains be hitless for ATS
  iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
  iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
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

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  637 +++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 1118 +++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   76 +-
 drivers/iommu/iommu-sva.c                     |   16 +-
 drivers/iommu/iommu.c                         |   11 +-
 include/linux/iommu.h                         |    3 +
 6 files changed, 1086 insertions(+), 775 deletions(-)


base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
2.43.2


Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221CF69286;
	Wed,  6 Dec 2023 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kycMcRF0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9pCq45qxc5mbPqjCpdeFRbRfQQpECS556Xj5fKrRP9PLtFQQtZncjoHQuMBi8QJUJNjbp6iexTbtZHjcuPuYB9NF+4Hm4ikjLc0CAkGqvpUFqhsgR+iJHkYNyMYHLYrUr8121Aa8XDAJFH0LeJQVVME97wyEbPFj5QvutDj1hcfKcIZ95Pl4yYv6OIpC2aiJvJs6GZRGdrDxJvpBVR5hca+WhrUNd7QTTUTozGYc1mTV7I0SIxZBewo25rCDjaKD1n8TvOZNFW3mUX1068amxtbcupGhDH5T/M5chHrFX7/nYAQfxwsSpzdAASKIhc7DexLtqhwo083e6HTvG5eOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNRBYYUJGxpqMCwvEkvJ+/8BxO+WJ0udCNmh71mzYhU=;
 b=emWNhHvOLrkPmLRHWUW0FVcNeSGkf84nZONxxqAvDWuvRXVNWJBp5NbovhCSiA+lEI+XipiHc3RfaEvzSZhQDfgOddA2wOlDAN4M2lHaFL6iUphD5F6aPxllEK2hvvZuYXQiCxCCA43g/9pClwerI676/yJrwTJg9Ou1JKqxoU6MKBR5Cyudg+mPip6Rv0q77eXs2/htC/GZ6uxYvtYint8qILhOqlRKuDTSPxcxSC3GL4eI9+QiLFeyVbUMEAPLnw7O+xk9iGcVGWqkwSbepeZ6tlDJatxagm08v80PAAp7o9EODvROUXnGGbXjPAkaub9b9dYryDxmtHQKRve5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNRBYYUJGxpqMCwvEkvJ+/8BxO+WJ0udCNmh71mzYhU=;
 b=kycMcRF0uXREQyfRHNpxTUSWwUPxce9Z9sSDdngioiytR4Zu/bmajXeexPxRijnG+BGJ9LuV2GcGCTDw3fhTl/brFBXM46UzKIelriparalsb1JfQUSPkO4ug55WivMGvmTzezp9IweYZDmK9USMLf+hG5215x/ymQM1YWncvp+APo0uqd7Cfz4kL4UOMop2iLQ7Sb2SrwsUq7Pt9KnqPFMMoD0oVbg+I/YnxlWq7zjNFL401EqjvFc5MHhevG4Tr0P2hyQmNg08HKsRlAkanBeMXvCfpf+YnobcXWMu/pcqKnHR6pK/IrGN6pb1k4mBR9P8S3CJ5cxql9yc0G/1Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:43 +0000
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
Subject: [PATCH v3 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Date: Wed,  6 Dec 2023 13:28:06 -0400
Message-ID: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0011.namprd15.prod.outlook.com
 (2603:10b6:207:17::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 9edb915d-5525-4904-dc08-08dbf680c702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nn8uuuXKxTf+f0JrfUqDyKsorpWD4eCIgKxL3amOwJ5N95iwrLszNvukF8dP8DXoHHyGqOJ4YfjelSLNI85ZuFCDd3WiKUPvzIVNK5uSe/NuqvsplQAZ57vFMGfZit2HMrO2VeHXaPejJEeeqKosm0TD259WRp5SHIcHR7YB87ifqoTVkj6Ran5wReWCNm+rZE+vsZp88MraEtGAuK8Sm3mBbbX8/M1RuF2TWsc8ctQ/dKIyhcXpgpX7c2JETkesHniY9kQ5Ze5b6kwVSiN1/JKA7UX9X0+uXOFXX0HvToFPuImLMZz55Enf74n2bTXbBPXTTAg2PdfTLV4392lhlDBGDYpl8k09Ox6zP3CPob0DD+AiZkX22DRxqYlXzmLqEi5HuuhJgv6JWR8s5sGXSY4wQUf+TNaY3mxhWa9i1dv1IIcIezZ8lAu1RY378nHN6XnWBBO3skkq/7La3ceXtyUchuim2rQEbq1fGEfZGIh7HTzpQChjzc79tmMjVWtjynHaYSRnqEJ/2/zYVEBxYMQcXO+hHJo/y+DEwdzjmMOdUL7dfYUiBaIGBYV5tIPZhFK0oqYfzSgivxBja6bOCDxrCvhdGBnBjJenYsEkoa3D8Fd4gEf4lmdW/X7TwYp+oE66KidRkv1CVJMEhfvJsqJxpOeQJv7TZ2AHM1xhezpBhvz3zPj50kNY/NOK0xEV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(966005)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(15650500001)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(66899024)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HO/EQ8XTmmNfKQp2ubHP8vMzKzyE47SlTvrnW3BYNwMAGdpNw9ylgCzKD7Nb?=
 =?us-ascii?Q?YMPjaJ5GZX+q0Ymbn9CyvLfVBqBQ/fkFltvyobFm+vkKVmS7fZz2LkJJNwbZ?=
 =?us-ascii?Q?inHVaBhLLYcEmXH31jCAihAzvbcWzbFjYIsnL3Yc99uKmAhn8veXHJQ98kWD?=
 =?us-ascii?Q?xe0ZRkk0yJQQe7WMwYXmpXvI+evc2EUd0w7IMlpO9IbgNPs0zxAYU9DtvGho?=
 =?us-ascii?Q?k1fQHHJDCKELHW1wA2ZW1SN4mDYbHfxPWQt/TunthPdY+yO9W4Fa+v3ovx4Z?=
 =?us-ascii?Q?X3ispnuOklB7WS6QHKI+ilz0Do+t5RbwO9QXvmp/0hNZiMbocNxRsjSBQJik?=
 =?us-ascii?Q?kFCuPwWPDAW+nSr8pDrswCgeW0/a4w8dtHQhWDzrmyBvaW0BzG3fUv8PfWyY?=
 =?us-ascii?Q?08AX1ZKPW8PURE99lxxw0cES5BWZUTizgnyYxsoAx8GNhGAWtr+09WOro8vj?=
 =?us-ascii?Q?oMGVs/jNyacjcgByAixEYJ2dE9p0AWdAzfWSsLp+5RUPSzqMx2UC0ezkQtyX?=
 =?us-ascii?Q?boej5jD5KWAz8fBtwem8v6EuvuMqMw/rdBUdOfOvvLi97FZ2QXkvstn18msL?=
 =?us-ascii?Q?mLFzAWC0ZoqNKTsuE5O1wBqfysypub0aTlMU5RmOMMTLnaIErB50sI5ZaRmO?=
 =?us-ascii?Q?bH5BAHC9het0z3lZNu/mhG79TSPMdgiM0hMrvMZVIR90wWlI4JxMS+XCmwRu?=
 =?us-ascii?Q?uMRHih1N757tx6U1ZTD9m2Zv0QKv1OVYgGaRmG/Gxn7Yd0CMuflzsu0+/9Us?=
 =?us-ascii?Q?oayv2oG2b9KTUpjs+uJhQ0AUaTcB+4gY2ReU+kw8jnxbHIKfn5W81LN6Fpyc?=
 =?us-ascii?Q?gkAUENOp+enBi8Hx6bEBL/4XtkvVGZgjsm9YWAoovHjB722COk9PrGJa9vpM?=
 =?us-ascii?Q?JJLKXK3hjlEW+loK2eaB4CxBP3zQ9JFXLYp3ZsA7Bi/vh4nP/OyYhRi8QqkG?=
 =?us-ascii?Q?4y13UTgGoHooF+1EMcs1Z5+DR4mDsKcpOM7NoxZ6S9HOCwfZkxsuxTaKPAmg?=
 =?us-ascii?Q?n6S5IUEc/yMchIqWxtTZ0GwrTPg5dgs29f5Smly6szbSvITivamvAVtjhjLB?=
 =?us-ascii?Q?jynKaPHYkjwuihjFNBzgMZHmCqXPo+W1g+JYdSIgSypZAnDGBrGXu90X63LX?=
 =?us-ascii?Q?hwmaG3jghY0Ob7z5uxWyTCXuV8Fykt4AQgCT+d8gJI/GybmASKoIxgiAuE01?=
 =?us-ascii?Q?R4Zdb+zCkOmcikjUztgVvaL7BL2uRowNQ1YykASBEiCHW25XhxsgLXqvMgBX?=
 =?us-ascii?Q?yNzSai3mGF4ySMtQuUOdzFxS0+Z94oRQFlNp9iMZYLjef0LS2OPHa4RKmm0I?=
 =?us-ascii?Q?N+nBtMRwQNk3x4liEu7Ou5jV9OXEoKKR/vUm+syhPbiebc7YQLza3Q5f77xv?=
 =?us-ascii?Q?W7p6BHcs/Feb6WYwEMWWL/4j4qrgINJcoKHDb4DY4/dA9s1r58P29UE9uVeD?=
 =?us-ascii?Q?2cNO6tplmDtJD9amNR4YAq5P/w+0TsvF2gZKE9zrpVUQHJlC7C3v5+zzP2HG?=
 =?us-ascii?Q?m9Z2mP+mmh3a79bJyT80yScXzgEYD8jRH5CE3x+wqrKqOjHLwH57jWK6xCXJ?=
 =?us-ascii?Q?b+/4EfjQtyLpglboF/IJk9w+jVcB3lFImBfbJ6p8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9edb915d-5525-4904-dc08-08dbf680c702
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5z2vkjjMAEDZBjZgjPnajvPNeezM0k6thxzZDOaOK+sV3CMVUfkElMa939E3pa8P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

[Sorry to resend this, I typo'd something and didn't CC the mailing lists]

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
enough this is much better than trying to figure out  fixes.

Once SVA is resting on the right CD code it is straightforward to make the
PASID interface functionally complete.

This depends on part 1

The SVA change requires Tina's series:

https://lore.kernel.org/linux-iommu/20231027000525.1278806-1-tina.zhang@intel.com/

(Although if you have only a single SVA device it is not necessary to
test)

It achieves the same goals as the several series from Michael and the S1DSS
series from Nicolin that were trying to improve portions of the API.

This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v3:
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
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry_step()
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

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 630 ++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 834 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  94 +-
 drivers/iommu/iommu-sva.c                     |   4 +-
 drivers/iommu/iommu.c                         |  12 +-
 include/linux/iommu.h                         |   3 +
 6 files changed, 899 insertions(+), 678 deletions(-)


base-commit: df3abd7ce2d2ca37e0afc6c421517ae79d3ddb94
-- 
2.43.0


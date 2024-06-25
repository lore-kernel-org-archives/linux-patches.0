Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8C14BFBF;
	Tue, 25 Jun 2024 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319083; cv=fail; b=aS32el0+PE8kgjLkxq55/DGuCpiuHbXj0i7KczypGHDftQBAGOgB8ZaF+OX39fWqRwamKATOLuzEj6z4c5c5mXoQn2+Xuk+b9m1WRS+rRFfbTni2SKhtpOVUzHSTOlDLnURBOu+2ix3nQZPKa9qmGnfRAVcHPMuYFd57MFOXv8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319083; c=relaxed/simple;
	bh=I+KFkTHG5R5bqEmB/vTk/zExJFm9wgeDcqUl0nMMEgI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XhTlAVYfkCTlYYCz8lj5WD5Q1K4JCRizWlnHGHy7nq6MEoZsavvgZYksoP8AJv+2+1jvjCNfi6K0eN8ldATAIn1G0cWTRHoRDOPEwjYQA+7l4HQL+a3z3M1M8HIdMd+XyS07VP87uUBmNktF0voksyLi+0T9Xwfce8GjUeNtlsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jQJ6S0ig; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jQJ6S0ig"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWf1bkmBLTx7a6D3NyB9pc1sq2M8M5oNSl7DWPb+J/sLW846FEYlKbR7l/SrhFMppBp4H2GGGgJ6WErje0WpRfkD33h76N1PWgxJ0OVVxzuK3Gv8P4CXAOUelKxVwRaWNTjRfUHlASwgONFW4ClaHcMcKRZmA2bcj0g8gNlbMYxKKmHrYDHucgbDuXpxno4DjE/264sXpC4kAANhH/5kzDKeKLlFtrrcyRX7QLuKU/eRxUbZ+UThV2d6HcLhDR5O8SMZknt7jpUkwApfMKVjTQsbsDYhwj41L/XK/Lmbr4AkpVX9dFX8Dwsn0goQG13mUYgh7da2HyFDRjewjNS8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bouOs60Jl69t3/439FCz2ahMs+XXPToi7k9nS9TTxxY=;
 b=gdTQXhDqTUyrk4r18GwYJEgMeYgSb2X/wEZgvzfTh+R4whBkE6psgE4iSvUyMW6APNUV6r1Dkxl7OGykWR+8nb1rqrsQ+2AP8wDUmmeNfZpWQBHOAV5HgkuppiUn8Hv+zi6RyBKONuk7SMbUgv+X3Fa+JL5dFKOSXeTJTmheVLYJfhk2dkzqqYLYBfXqsW0a+4LZedQjWahfDQ+DNGc0xpPWXbBZeTy7IinJ+BJRPhI2AWNaexJVBkJIExOkFjQicZO1lF9LqcyWqdf5ngWJ2F7AD/rEz60ETR5x8/f+vtSkQWw02ypQIdhDgULtB33oNjqoOBZmc5a/oS80I11ISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bouOs60Jl69t3/439FCz2ahMs+XXPToi7k9nS9TTxxY=;
 b=jQJ6S0ig7MB9QPNylC3qF8pMa+cdKi6hbUKEz8h6ZMDkXlXpXwcx8uqg+JfhuMY2UASvw+GqAzpZEioSkIihogu4Txs2UmpPQhSVKurnHgSmk3Zji6u0JsF2eiJmmTy/0FS5BNz4l6aTRQJXE7fKCvWt6cxiYSdEmHrLCchFz0sJ9GUevAMhu0baq7+DaigRL4IN9VsVAdTaHBUbtrs8GlJQn3MrflzdFC7qWtS5l6NwHFdbComfOjGd5ddonGj6mWnVhJo9sPk5dWYQtm9gU+I4MOxuqiQn/F5qR+5e1EyqTxb/+LMSOejcXAKejwPeb33rM6AKy4u5Km/EVn67Vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:50 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 00/14] Update SMMUv3 to the modern iommu API (part 2b/3)
Date: Tue, 25 Jun 2024 09:37:31 -0300
Message-ID: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:335::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cfee1ff-187e-4ab0-fe3a-08dc95139e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YQv5yevFiSRaxHmQ1CyT7SOUjWDBF4PRsBeadt2dJhQZ9JCmnPy31Sk61nY4?=
 =?us-ascii?Q?V2yfq1KGZuCmw7PrSyf8rOGDajnrSa7KtNnzlvpHbz9kvAjkCGe2WNvFlhqF?=
 =?us-ascii?Q?xwToTeognIT2oZarBkJDcZ1Uhcylmvdhwpbtz4oJRDAIqN7/0Qx9y84QddTz?=
 =?us-ascii?Q?5fUN+t9NkrJMbrih0bO1RxEGf8KDdfZMcpSuBCAUALSvMxDS43/N1+fgjg58?=
 =?us-ascii?Q?r/tFtODA3oe3279Mvv2C66XTwSjNMGLHnEPH7SkJ1YMajjhAPp0erfXZ8P14?=
 =?us-ascii?Q?OJ3dLim7Tc0dQxgS7uyzYxhjEY4sSR26tDvCPQzm0/YaiQa+GtQLiho/jwVg?=
 =?us-ascii?Q?X/lHyYX1UEDPJ8+kNidNoRG14H14xITtNw/CFm1K+zuXIPgryd3IiycsimyC?=
 =?us-ascii?Q?l1TypNlT0BF6n6qPaJFQz538ocxqEGDHMw1EgsDSUvhoSznzpTXoZaHN46xr?=
 =?us-ascii?Q?m9h1zRDtjr1ExvKa/b2dWbn4UJoaHJZ+4erWCFEtilDoRpNeYgwnqXp28QqM?=
 =?us-ascii?Q?VnwYC4DMu2QEvNPRriPssAp8wwV3fMAg8giX774dMoP0Xq7wVok4t3kAVvif?=
 =?us-ascii?Q?PIVZBVlLaUeXGLPnCQ0gxBdBjh+AjU1eYixBOgzl6NCuEHLe+jLhuoGOcjD3?=
 =?us-ascii?Q?AaO/Er37yYl3HpNwg7STLBcrqbFVlBJa8AU7pIYcukgB5geU81XUjawbjK82?=
 =?us-ascii?Q?sxb5NvDD1nfaMTB6Utnlh1lz/gznup8goaKawLL8Rq3ascv65/j5Q6TG+rhh?=
 =?us-ascii?Q?oDR5brpxvFqUM8YpSxWQWqTLe4FmPewNoZSI/sHeVSwNwYxr97Adq3poJVvN?=
 =?us-ascii?Q?O8jDr3dFSn/flYNFKTlA2a3gL3PdXW2kj1yA4PPX2InhMPniyTwQOnoGkZDk?=
 =?us-ascii?Q?S+wykkv4WVahrJjggQI1HZqP/+8kKqZJc2KJNazh28a+XyF7mxaiooUYth0+?=
 =?us-ascii?Q?YPhlM/PaO9gg27iAURvrQoTusPlhPJnlbvFJlbxVJDRypVUCGMOQaynVUi46?=
 =?us-ascii?Q?EPYwZKQQec+DRuY4Rc1kbcZ5cnabhVHTsoMaVHnh/MWQ1734dK7XBEg1CbvL?=
 =?us-ascii?Q?fdIwkNseoDNy/gWTKXX75yziFjcUN+K5nafuZ0hE/FfVGz9xrG9vChMDnZF7?=
 =?us-ascii?Q?NpZnczxf5d4mqsk2m+i8NLsBIPexpQ6r6cvejU4OO3PzUcDGagYDnPJaeZir?=
 =?us-ascii?Q?QnXHTX+JkCfFsDvDZrjxvfV/d9+tL5ZoSRDW5+uB1/YKqVBqta6d8XOEM27Z?=
 =?us-ascii?Q?k8y5iJZ8PwrHNrcklbVzE5g1N3LfZKad+QLu4IjbJMRvAIkKLDXWpXaIMZhq?=
 =?us-ascii?Q?OjneYJz7bsNqPzQ4oBnWYgao?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QeNRR/hy7gXCyKHH0xNhKmVg9ui4t2qdazTUCjoNdg/sJ/7PSdBWJulv7ZzM?=
 =?us-ascii?Q?OhQYBTgnzd0Au4mXcth4GMNovldbpODe8Q6spkIRGO9MiM8V0AL4aXVrjk3g?=
 =?us-ascii?Q?kVGDOKqvVqZfySffmEMEt18792sD3g1e0NaRTZbBd9HqutnYcXA+zt8mXhzd?=
 =?us-ascii?Q?7wWbjsEfhM3CKuY9Q+8xvGQ7c4K1HyuRnFKBALo8tcOC5+lKOtcJH45Ekdt+?=
 =?us-ascii?Q?Co/UZ1i+iq0rZ7naKYoe+NvNT1efv+12UKqeAKlYKJMXbUfOMJJr5J7djc8W?=
 =?us-ascii?Q?/S042JsGqD+w/4Pdx3LYV+lr1v9MvBge9J7lBxjKJZsBGztrx0PLLbyXqXv/?=
 =?us-ascii?Q?12yDiw+FGoM/toee1b8M1Iw2C6hs5v4ODlYjO9zXd5z37ghQV0gjoEpiRYsl?=
 =?us-ascii?Q?Uzitm0vcpaa65kaiYmcrnQUoXIQw1Eo8/LliHclQo1onzCUKZ0O2GQu0DM7h?=
 =?us-ascii?Q?N7Z1hMZ85SstrQC2LgVHRQSlHh8S0DkWl/ttldHjELj798UZmwNwCVpl2t4F?=
 =?us-ascii?Q?En9c7V9qpHqYRIBfgb7Rz2ybq+cx5SDR1j562rpZSwelBDLMTgdoq163Qs+d?=
 =?us-ascii?Q?deojwWfSYf0D+Nsfv7dcX1IVO6ZsWql55n26ZBOJRvCH6x09HzLY4o7TUDk/?=
 =?us-ascii?Q?Ttc/o93SHkd8/gfpQmu8GRdZBKmAB4PiSmiQF4h3283Ez6Fl8kqw1GNGxIFg?=
 =?us-ascii?Q?0tp2BPkgBFck2I4Qngh8fL61qEE0GPeLAIvbFUldIXfi+KQqla42cigYGC8P?=
 =?us-ascii?Q?XKj98CiSwBfwArf1ComJfxEs0OFVSFRYQ4lS3wI0bFkVv2NQGECPn+8txKNn?=
 =?us-ascii?Q?OjbCe+voXZn+4rDOss4+Dm1AwB8vMW6FG+GEg39DKYD782tZjH0nXSOIOkmr?=
 =?us-ascii?Q?qFW+l+uzL4CVoOyMuXdZ6IHsjxLHaOzspqYVCaI20lbsjP2DPOS/mKoA5e2o?=
 =?us-ascii?Q?LMi8jWGSVWnKFlqSh+vofi52w4PNdPwUSAb5gJDsd5sxaj7cSB4oz1U3Xt7k?=
 =?us-ascii?Q?rTIPagS71qEeR6xrghMoENsTxwafFLJ1EXIzhiIq0lLD3noahN7QSmpPu5J/?=
 =?us-ascii?Q?6RpLj/lijlyRFf3N48LxbmqXW1K86NhXkBamIuUC0VUp5w/SSa0w1xaKaymY?=
 =?us-ascii?Q?Lt8OG8JbvQwOIlPA2WnOqxbE0WQT5WZnmlAYKTE+uXBbid4j9DtuYNCW6aq6?=
 =?us-ascii?Q?uTql+UfBn3HTt3fm0TkccBPyhWYA43NBANMllZ3G44e0TY+BLTv5pobekx2b?=
 =?us-ascii?Q?SYY/Rz9cksnoV8CR4WGxGz/vwvdakprX+bmET84bhuK3UJ0JReuxH4KtEUti?=
 =?us-ascii?Q?SzwZw+Gw9tPLk4RbQAyxVs120J1qcLJgTGCfsDyG/yX+ufeebUKtzL1AzeCW?=
 =?us-ascii?Q?Eq+gqqmRU12uE4t7HxP4EEAvsUjzTNCeqGdMjFH6LV5He8HXEpWgGHLic1BU?=
 =?us-ascii?Q?g3XJV2Fiygc5sYWjwfanJ75zP2aZzAT/S3mXIVLAFeHcc24RKPTJp4xum8q+?=
 =?us-ascii?Q?HisS3mrJMN2rfX2aGd4CpmhNIsEa6ltEtAmN+gHQ/fZ+sahmiqpjuz4qniGi?=
 =?us-ascii?Q?G/dZGcsk8Cgi0mHvkLPUnM5OtywxQfkMtdTHHAIf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfee1ff-187e-4ab0-fe3a-08dc95139e5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:47.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHo3XrngjUJqr3RFwhCjb+Xb18BaUXdQbvBt/q0YYFdWgrZwJKcAwzPl5zFWSBAb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Continuing the work of part 1 and 2a this part focuses on the PASID and
SVA code bringing these functional improvements:

 - attach_dev failure does not change the HW configuration.

 - Full PASID API support including:
    - S1/SVA domains attached to PASIDs
    - IDENTITY/BLOCKED/S1 attached to RID
    - Change of the RID domain while PASIDs are attached

 - Streamlined SVA support using the core infrastructure

 - Hitless, whenever possible, change between two domains

This requires some reorganizing how the invalidation is tracked, a
flexible linked list containing the SSIDs as well as the ATC information
is used instead of a single master.

The revised invalidation infrastructure is used to build generic support
for attaching any sort of domain to any SSID, including the necessary
maintenance of the invalidation list and the global ATS state. This
mechansim is used again in part 3 as part of the nesting series.

The ATS ordering is generalized and consolidated so that the PASID flow
can use it and put into a form where it is fully hitless, whenever
possible. This is necessary as changes to single PASIDs or RIDs can not
change global state like ATS without impacting other, still attached,
PASIDs or RIDs.

Next simply replace the entire outdated SVA mmu_notifier implementation in
one shot and switch it over to the newly created generic PASID layer and
generic invalidation logic. This avoids the messy and confusing approach
of trying to incrementally untangle this in place. The new code is small
and simple enough this is much better than trying to figure out smaller
steps.

Once SVA is resting on the consolidate PASID layer it is straightforward
to make the PASID interface functionally complete by supporting S1DSS to
allow concurrent change of the RID while a PASID is attached and allow
supporting PASID over an IDENTIY RID.

This continues to support lazy allocation and installation of the CD table
by continuing to use the CFG mode for IDENTITY/BLOCKED when when the PASID
table is empty.

Finally enable attaching any S1 domain to a PASID, not just SVA.

It achieves the same goals as the several series from Michael and the
S1DSS series from Nicolin that were trying to improve portions of the API.

This is on github:
https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v9:
 - Clarify comments
 - Collect tags
v8: https://lore.kernel.org/r/0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com
 - Rebase on v6.10-rc2
 - Make arm_smmu_sva_domain_alloc NULL when SVA is disabled so the core
   code sees a NULL function pointer
 - Update comments around arm_smmu_attach_prepare()
 - Rename struct attach_state -> arm_smmu_attach_state and document
   better, include more common function paramters in state
 - Consistently use ats_enabled everywhere, replacing disable_ats in state
 - Move the note about ATS bypass/abort to arm_smmu_attach_prepare()
 - Remove temporary cd_table.in_ste check in arm_smmu_sva_set_dev_pasid()
 - Improve comments and clarity of logic in arm_smmu_attach_commit()
 - Shorten arm_smmu_mmu_notifier_free()
 - Fix domain -> sid_domain typo in arm_smmu_remove_dev_pasid()
v7: https://lore.kernel.org/r/0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com
 - Second half of the split series
 - Rebase on Joerg's latest
 - Accommodate ARM_SMMU_FEAT_ATTR_TYPES_OVR for the S1DSS code
 - Include the S1DSS kunit tests
 - Include hunks to adjust the unit tests to API changes from this series
 - Move 3 BTM related patches out of this series, they can go in the BTM
   enablement series.
 - Move the domain_alloc_sva() conversion to the first patch, and rebase
   on the accepted core code change
 - Use the new core APIs for the PASID ops
 - Revise commit messages
v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (14):
  iommu/arm-smmu-v3: Convert to domain_alloc_sva()
  iommu/arm-smmu-v3: Start building a generic PASID layer
  iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
  iommu/arm-smmu-v3: Make changing domains be hitless for ATS
  iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
  iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
  iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
    interface
  iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
  iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
  iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
  iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
    used
  iommu/arm-smmu-v3: Test the STE S1DSS functionality
  iommu/arm-smmu-v3: Allow a PASID to be set when RID is
    IDENTITY/BLOCKED
  iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 431 +++-----------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 116 +++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 560 ++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  52 +-
 4 files changed, 663 insertions(+), 496 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.2


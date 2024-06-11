Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4704C81;
	Tue, 11 Jun 2024 00:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065899; cv=fail; b=dU3isSxu4pLIh/2xlIGwr6VpPb/mtmy6JmuEImAMlOzDLAmwVHxOZfFTD4K3c0rA3gAJ6Mk2ct39Mj5m3NCgtzlMcftxgue7rFh8T67WSx5N2/R+ur4M8qmhObxfVbGoJspkzjxiold/pRPb2plDFPMEViuK8/xUiZOCvnvuP0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065899; c=relaxed/simple;
	bh=8Q2oW8fqSrGgbyEaAAw9LW70UxnOWUob+EzDoin8o18=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ny66Wkgb/6gnbXowPecfPkOqlsJwcpKI8zZePDMbLTfS6sxo6zAMc1UY0UIWzKgZtdpHAao8hprrCCIEQ9nAaLHCL87aU0b0fv70Oz1lCDFSKKQVGVz9Tl3kAyDo57ygFjPpmG88zv5NbFmqEHwJ4kqsd5UpDnq9rhKvlKVAUt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jvOIzGjw; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jvOIzGjw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4QQI0VhHV+N6Qe4QbEtcbEfWZewlfts7G4A7iVJNFt4ROLFTlBWMzT1Id8T1Hi4lTNZsgifpRFZ3K4SUe9W533lkKAhLbHCesRo6n/eeosj5jidCk7X5iOMCHB4rvejbUllCQCpf/JiujQmzkBUXOVO/yr8oiruZYTDay14IbcG9eBrn56jDqPiqpcHp2n9i3c/TfWw1dgoFBAXYnEQRFTYq1KireFIcgquSrd1ff4zeo9gYInkBrRaATenpjjBwEbPQdBCeRVJGRn2yUOtbRCIGVia0sFSRzQff8D5zyfIp/SRuYPH4xzb6nOotRbW2UfGsMRKnMZg8cYRy4HmIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QR5CUsKdnpOiQOoBhgT+z2GrpcAGiyJ4eHDEivZHiA=;
 b=G1aS7P57RWloKC4h6qcvSIKATP0jHxlm71HzGsEvLmahPKB4SEvhEIiqPTYhP+WrefncVSCfo4s7ic45+D7ObPm+KReYIa533vz9ySeDiLggLxI9TsC7mLfdCD318J/O+Fn2ZWg1Mt+90htmxCWvjl6Omjq/0s2pY1nfIpJ+kX8SQUoNAGKao4DOyKg/y38L1wvDZCMP1wmblQY9qmiYQA8YL5eBOL0cazJs+ZDpxqw9N0olR+xLAKit2htX0ciwiCLdhCybY/wL0V0hDzR+drTKLzJ/w42Q4uZtC72KPNgKnfr5/8QnLFq1aR3B1J8QdJ29UXQOTurPKv3rillz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QR5CUsKdnpOiQOoBhgT+z2GrpcAGiyJ4eHDEivZHiA=;
 b=jvOIzGjwSBmDxyJQTWDLuo8M+78Eyz33Oj+3Aqpw1ZEC9POJsQFSc9iz69LMxVrFRwZUC1z11XRxrtbfbJbWGWsbKqkIxEE/7Fcs6H4KzS+33/5elAkmikj3eJpbr0Ou1FQQVyYabDWO2RifDLY7AahPYW1/gMsgDeCiAVu53l07AMHdNwm3XQSMImKzTkoXjETEgnOoy9yUOw58Aci0OtjOYH4pufxJ9U44oDvkfWKcpb/v/dtxtb0Hmbh9ltgiAc2+GNEar0FTJbkSQWGVDkB/ft/5w/HTR/LzTReUDlE9CzYdv/tnhVr2zejuUWlbYsjKwQh51+Jl5jWSuC1tUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 00/10] Tidy some minor things in the stream table/cd table area
Date: Mon, 10 Jun 2024 21:31:09 -0300
Message-ID: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:208:234::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f88929-6466-4974-c87a-08dc89add284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RzTuJixEkUFaD5mzE07Mys9xMduZcrtijSgs5oiQa5qWYr88thqm3G07HdoQ?=
 =?us-ascii?Q?CNu/1g61o27H3+51ldYW4iQ2rFNq0+Ezteu8e7nS0/evJi5F3JOTBWwo5qK4?=
 =?us-ascii?Q?LtueSpT5lcHseT81Qa7G/tIM6bJM16gQn1UKZSHEhml2PIcXnwpnz99n4+kI?=
 =?us-ascii?Q?vIzU0q0Ek1iSRTt/H1Ql0d4H2ErV0RJUysowCEHGw3YWEopq5+o1J3eFgvpi?=
 =?us-ascii?Q?VPK7l6n6z7jtFCwiYe/663HCPbRECW3+ggrmOhbFN6QxAI2zV/9iRlaoGhs+?=
 =?us-ascii?Q?VqYGD3BCY1NZ9hZ8KXBYPjTer+h9luLiPT9D9rqMBXsazdOoNICKPAfaSOLe?=
 =?us-ascii?Q?quN2NOXafe2pFF9tlVqyt6jNrJ9r+PhxH/8sFVvvxrxFdC+wGKgOPTVlP2gW?=
 =?us-ascii?Q?vttZm0o7/mp8FGL5VwNGb043xD1Zu3xpQB50IDhRc54LGBIfE1fPR8n/oF0w?=
 =?us-ascii?Q?MjwGxuBGgoSLmbtW4oySSpgOcIXaP4ZDHzwJYlTV+P4KI3NxYpfe9G6sdGtp?=
 =?us-ascii?Q?MuZD2pDg1MhYlljuyDC3/pT+QA4NN0QvXOEz9hGx2tKXX7k+lPDJk5MAPUTT?=
 =?us-ascii?Q?Emq2xK9dKRmm61G6gqSHq7TtnuKXqSOIMlIZBtkKHpdBsl93HX5tFqNZY5ir?=
 =?us-ascii?Q?6WL8MAqVdFerHSf+wFeBOMD+ywz+vVtBjErzkWnmACj91b0x5n0Vs20bRNbu?=
 =?us-ascii?Q?5z18NOe5ntoa+J5PsTqrIoCUbphTkIHobPO2QzWNhxw6mCb72xb6a63TBMuV?=
 =?us-ascii?Q?voboZn5pQt5VZn4bLB6bvhhT2zX3GamSOuijpaSspE2u4IYGJQTN+pmVNqlu?=
 =?us-ascii?Q?hF7/rjy4GvkWyx9m307JikHhCVTQQeLPuDbope1VGYJInPYsxpc0spBXRaCg?=
 =?us-ascii?Q?+6LkwbvjhbfmjdGGsibzdOhVOBIqB2dqj0HKHOMeOmiF9ovzfpj5QHGh2ck4?=
 =?us-ascii?Q?gucYCopCW1IdgtkV/pfesbWgUrISLZP/S335aj40bkgXuW0sFlp33Lv2e2B8?=
 =?us-ascii?Q?GS0O0TgrwH5puoJxbr9eLE5fkhxINb+z7zxYbLzL76wWW3WE4/lvL0Sv8/DM?=
 =?us-ascii?Q?UrsBhysocZgSOcvZJlO2iF6BnwbV1oltNpwtMKIX0UlWj7ZBcuwtF4TMFs0z?=
 =?us-ascii?Q?hZsgXTHIN/oka+JupqRMY50b/0fKJ6s8c5vkUPeG7G9sgzWIxg20b+oVYnvx?=
 =?us-ascii?Q?i2U97te1JPcxVab5A1BGJNMW8e9v1TImW9BT56eTYpn4KK/h92+BenrSt7Fz?=
 =?us-ascii?Q?YPnMlOwnyBBAMaaLkgeIsv9AOu5KGMBHE93vxICdpG03bbnT5Rvqg5K7yKmz?=
 =?us-ascii?Q?FsfqG1swZ5nU7UKYCp3kP0UN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JZIjBoDxZXknhnx3yFj/PmONkdGrnNXkBfHgbsn7xIgUu183yd0caemoUsYH?=
 =?us-ascii?Q?0kF5ti1+G+wkl0U34xzcnsQcU98O1zFQV9CDKJFswMpIY0/YSywxFnabE2ad?=
 =?us-ascii?Q?2J/63lFluufn5nxb7Jf182UCjqXqAkkV4HdF/resfCGj6cHkv2Fk0bEc64rb?=
 =?us-ascii?Q?1RloG02sDUHfKBxrSeVyu+EJoQkv97otdLdkoW4xNA45BwgXsqW/OXsinFrK?=
 =?us-ascii?Q?uG/JvoGEWdHh10bAnRRgFt7UeD12AgwQq+WeDIyQ0z4f8HFdLKaZjwyK69H3?=
 =?us-ascii?Q?bn8PWGv7TH6TiAbICHEjzam6Y3kejSBeQjaO7dOZCdRcgjxZpru6om/M4JNv?=
 =?us-ascii?Q?7HhSTyLN2asxWuzsXbJ06jvwrw0nQU5BAsPWsPnKeLa0CttrkxU4yY6ligTx?=
 =?us-ascii?Q?19u/x8m9PE4DuoJuyU3xYClEc6AR7bA9pXT9OLVHl5+Z4bVzqWW4MUH4odNs?=
 =?us-ascii?Q?p6T54OyCFKNrTAKpGePdyh+4DY30OqrIWLdhjW3HGFeT1LmYvjL/SvDixq33?=
 =?us-ascii?Q?H5ZauwKYHNRnXnxskpC+cjeijHyMIKH1PJEme3GnokB5XtV0Witf/k4d1rQQ?=
 =?us-ascii?Q?yR61yXhz1lcPxIMge8R/VXjdRZtwqpSEbfb4rB0wOFY9L0vYAw6OBzqCwD1q?=
 =?us-ascii?Q?VKDyFvXDIba2jfkdWaDvTzlI0FbOCxOYh8BdjexnCGkBqbW68IrDJjTrotAD?=
 =?us-ascii?Q?Qs1wdhz7TU8767+Xnh/RQOnFEQquAlFv1P0u6glrXOb/KmXx8wDdqQw5LpY/?=
 =?us-ascii?Q?nwWdX+aZ/CEuljH1Kpam2gNNI/DYFanvc28X6ay0BymR9Q7k38qfka+UJijs?=
 =?us-ascii?Q?zRappUCi1bTRKBl7/mCaxHDy8Ju8L70XelRE0Yw6kSoSP1yH07WzEnqSGwCB?=
 =?us-ascii?Q?wTvvQRAZWbp7O1oS26EAhB1FXiidRyED2llPyGdvg0cWmG6j9T86kKt3e2AD?=
 =?us-ascii?Q?WIr2pG4CzCqEwetTnOVPiiHFmYr2zos25krNqZ/CNUzaYcJWZbWHTcgmk9Xn?=
 =?us-ascii?Q?SmsjKaVoQzeYWReR6gbUZMwSFsiPyW2VFYAwffM+l5GkwqRY8zQQ8JhMqcvs?=
 =?us-ascii?Q?Y2kf9gkki7B/vtTgQwmTgEFIXlYBENrWdNdCktVy74k3soEpzFg/QZ5FqHjz?=
 =?us-ascii?Q?VKbkrN3w/B1IUvdKdiNw+rMM1AQWsgjtuU0IqVIVy3HvJu1QS1iDzvG+LnSJ?=
 =?us-ascii?Q?d1y/HrN5JxXr5tWVtCdnFH1nmr4RUTaBNEgUKZ+CzY8hOqUjBtVXbvh6QsmA?=
 =?us-ascii?Q?hUsIW+TPH1RcJAt9OulICF8Di0xNSf3GpvC0QT0HQs+ii9+SGH8ZsOul4zDB?=
 =?us-ascii?Q?oKq+WzItAw2eke7vTKooRo7aeO8swyQBSN1LNJ2VRf5xzAsFTDtSQbz80+hb?=
 =?us-ascii?Q?A4CWGG3xthxEHHF4jVQdNe/x7J8rAp3SfBYXNCVz2ELnVEquswW+VXRalrMK?=
 =?us-ascii?Q?/Bu4YcYzRfG2tHS4obLCsL2VboDP+NuecDf4V7gkoahDmVgulTvSX9Al7Tm4?=
 =?us-ascii?Q?Bv56ZxJTMmTUhwhaPV/fPK2yujzDBDWzD1K/LgjDNsj9IIHrEJgdZ00GzBC3?=
 =?us-ascii?Q?j12keJVuFa9fRrO2dd4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f88929-6466-4974-c87a-08dc89add284
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:24.0043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXgQDeq1DAPPCZF4tRzGRByZVOPZPEdGgQdsrx0t4d71I5MA7k9tFT2TX99UASQ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

Will pointed out that two places referring to the CD/STE struct did not
get the new types. While auditing this code a few more oddities were
noticed. Based on a feedback from Mostafa and Nicolin a few more things
were fixed up too

- Use types for all the HW structures everywhere even for the L1
  descriptors that are just a single 8 bytes. This helps with clarity of
  what everthing is pointing at
- Use indexing helpers for the STE/CD two level calculations
- Use sizeof(struct X) instead of open coded math on constants. The sizeof
  naturally follows the type of the related variable in almost all cases
- Remove redundant dma_addr_t's and save some memory
- Remove redundant devm usage
- Use the modern rbtree API

Parts of this have been sitting in my tree for a while now, it grew a bit
since v1, but nothing is particularly profound here. Enough is merged now
that they can be cleanly based and are seperate from my other series.

v2:
 - Add a patch to add structs for the L1/L2 HW layouts and use their
   sizeof and type instead of constants and generic __le64 *.
 - Add a patch for L1/L2 indexing helpers for clarity
 - Reorder patches
 - Redo the union layout in the cfg for both cases
 - Fully remove some more defines
v1: https://lore.kernel.org/r/0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com

Jason Gunthorpe (10):
  iommu/arm-smmu-v3: Do not zero the strtab twice
  iommu/arm-smmu-v3: Shrink the strtab l1_desc array
  iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
  iommu/arm-smmu-v3: Add types for each level of the 2 level stream
    table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
  iommu/arm-smmu-v3: Remove strtab_base/cfg
  iommu/arm-smmu-v3: Do not use devm for the cd table allocations
  iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
  iommu/arm-smmu-v3: Add types for each level of the CD table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 319 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 103 +++++--
 2 files changed, 211 insertions(+), 211 deletions(-)


base-commit: b9f4172f83796c9f0b84e92c912732251bd79b57
-- 
2.45.2


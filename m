Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA93D72;
	Tue,  4 Jun 2024 00:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460178; cv=fail; b=LWET/3W9c8sa2IK7H/CWhUJzavxasLwBgBMsWDQwRqUsefKm/muHSaXOM2kmHS+zibDr7X1whUMf/bw8gDeQciZ4mTHDAVHZDlDs2D0vwL3F1Vodd/3fsaFYi8beTtLSOv2wWo8i0UFGtIC/2zdPFc0LPdNtOI0veZXNMI80IYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460178; c=relaxed/simple;
	bh=dIBvB6aa5Vsat9TsyNQjp+BI4BtqhR61RuOcJMiVqEA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=T8xDOabFnQO1C6SLLbM90pn5IWjxpxkrDXssoGk/xxblncHsZEpmiaVJ/Ng1uZAHXT26a70SXQ8eoODvcsuHyiO2vUZhPusnfccCVuRDtwyQn0VdYZ5Vgx6kFypnq2MSRRpBGt/DSMf3l9OwuhwSbTVxnm2rYqQGzZZ92Mnu35Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VWLp8bmC; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VWLp8bmC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAe74V5v/OB1paLnT9sXc1Imhxx49DE/rJSwH4e9Wa0fnDGockId91E+x98KdZ1dIdWCxUbntahgtVtPRKCJosr9090mjOwrCctXL4pjK514HnwFD4+h2URduNRRC42uxvbJCWJ5zgax6hkNIFNUYfFw+ykzBg6F9PNhd1Dsl1f0v3WIurIEboJGcfE68feiZS7xHylne36z7K6sykPAyZ1foEWKeK/tDPM73T/Fg06JOG3R0SbqVadD1eETQ8YAftGAJ6iz36gxkmFhmHk8vDLGN+Ncmvr5IDoeQbnKoI/RUwRMYwM8o+OK+sALWYRCOG4T3YSzYIlDDQINt4VpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVdvYkTWH3vwNPpMCZ0vHRSV19ocaeu7mqLuLBWuIXs=;
 b=lr2cr+RrMUa11n6BDZHMKI/4GtQwLc35uzO30kHYUDSmPuSDPsB1k0uvVjk5rkRdUl0Q+zr74ZJKYGx/flynEj7mcnR0oLd809l3eqScS+56Rjt04CUI9ijYnFtK6jlb0tSuclEe0QDzo52rTw+RtHOoiVHVfwcTOkh7Bl7trm3B3c6g0Qmt5sDRrKoG2qQnluzro/jWsMc1N9xs29WgB0c8s+2KmbmVYPqmOi7p+8skWjzmkXc8JMay0UXkrbagVmYvTfiffz6TeXs45OhuLum4jw3stcDDuvDXeWyYe5T6oe3cKUeibrIDgvl7daW/v97rcaNMIPWCJDUbelsfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVdvYkTWH3vwNPpMCZ0vHRSV19ocaeu7mqLuLBWuIXs=;
 b=VWLp8bmCEtqvearxwEd+zzH6duR9FmOovmLdf8JgFMegwsR/BReR0UStInOc2/JZ4H/XCo/zu/r+Cxs2FcxsR6rIGX1FyQv2NrdDGk5BIlgw6spDegYRYPli0dl/c2ywov2S5HzDTmRm32up4LFTYVRcNHhelnU7OFYVKr2tkQJh+F6miujFra76uiROBEztkRfH+BB3N25HXmOyMMhubG93QJgL0WcBPsf9oqDB/jiIVyLa9/Ugg9b47sXnRT0Ft4WGI3A7faUGMiZSczieshuf2dkWo2H2jRr7wdsXR3AigIs06ZkeZjY6VMypAJg9Kx5O55gr++xgg4kAe2kiTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:05 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 00/14] Update SMMUv3 to the modern iommu API (part 2b/3)
Date: Mon,  3 Jun 2024 21:15:45 -0300
Message-ID: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 9adad40c-6fe8-4eff-eb51-08dc842b84d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z4VmL4tMfOKUGrYD2y3OG6QRHz7YEmyUN8kCtL8LSKB9ssL8rfpgggqTqrSG?=
 =?us-ascii?Q?7xHdimU8qQZVX/YsFDZkGZX72ycZyy1myXMIqxs96KijZ+51oyItlNalCU3d?=
 =?us-ascii?Q?ebVmdN5W955gsVHaZH+lTLOfBviNhBo6MMML4+5az7H164rt0C+bNIv3Q3H4?=
 =?us-ascii?Q?O9s3VqW0mlW55y3XvSNUdKib+iQjeG9hZ3gJzsCAaKETI6xDPgQFGC68py2z?=
 =?us-ascii?Q?6dKTSnVKzhttHvOF1SDaED18XUb0Y+DAcBi3NrmOEaaZOuFLGBXcVdIaWtVz?=
 =?us-ascii?Q?0gSou8XNK8ORv1PW9E4xjfxnk6KzwBQfB238sypub6NNhUL33+yrOAeBmkYm?=
 =?us-ascii?Q?fMw2/qkJ9bqtO3viBrwRgQwvi4AnNCoGglBCNmyB4hBiC94HLRyA8HMIhoyt?=
 =?us-ascii?Q?v/MlJvOwLrO/3RfVTo/bO9XsQ9zjrqQRqJl914PorUcerpb4KBGB72XflwUX?=
 =?us-ascii?Q?MAulAYJVyifV3DqU2ckWZBDyn2+K5Xsx/HY2qmvR2wXpfZUx2vV0fNxBix4z?=
 =?us-ascii?Q?xlaeYXGfMwh/UX45ytRG/d5GLR3SzWeVhLcwTzs00d+fguRZQ/DfMSfBcCVd?=
 =?us-ascii?Q?DhAi7WGyLrJTDE17rRjsdaVnCnyedaGB+oBgFBv4iHqGAowxTgvmgVboE9kq?=
 =?us-ascii?Q?vZL5lU2ToXkH1pr1guZEsdIU/S8tTD+uVambe7RO8ExSTDwm4tLPNdo6zFNc?=
 =?us-ascii?Q?2dfmDHSCMPhuoxE55peyLADtXFWW7dareIAMB5WuNH6fi7xbrNQrrP1qwUZL?=
 =?us-ascii?Q?VGRGK+bDyhfccgAetdaQEo1v4tbQ9kQr7MxEdVuINCrx2lGB6dQX9n1CF3Y4?=
 =?us-ascii?Q?fkkfr0/yDhZ6UPIAjaFPMXkfqWzpz3h8xK24HG5quoT87NpcKXWeYvfvKS8l?=
 =?us-ascii?Q?QGg7WkNfGLvmz5KLEUP19mHVS6Mh0Q8dybFzeyMXLsSuCTpt4jYv6JKuEc0W?=
 =?us-ascii?Q?DEa/xyqoEbIyUo8FizjqrbIZzI6GwMGIko2SRcY2N01U5xJEE5DyA/UuuOtC?=
 =?us-ascii?Q?9QS4Ov4wjrp9KgfO5HipszM/gLMPu4gAuLY0j1LR2Zzbuvl7uA1AJcebu9x4?=
 =?us-ascii?Q?vMMXDlLGAGr+qldIrNI+Jsz/NY9tYF2UqksJM4RPYPH6gnW5Q5pXSk9LC9jL?=
 =?us-ascii?Q?waDi9ZXSPWjghtFEY19ydaVuw1u1wduf5w9zML3wtXAJzVeu0nSBQlTK5rHi?=
 =?us-ascii?Q?3GCQ5FHE5zXT0S8T0NNcikbEkf1PcvxyjaplSAK8nEK76Fu8E5JiP6AInO6V?=
 =?us-ascii?Q?ZWHNiaVqV/2FCo3t1IoBUV4UG2fxw4hXDi5Ocx8OLA7dDHYATjfQMm42hdzi?=
 =?us-ascii?Q?M8c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HZHdcvxF7PIcGAXYAhj9iSaRMma4ejfOG2mpIsn4K8y2juf+d/K+HRyNJYh5?=
 =?us-ascii?Q?d7+2xRzyoe6qgZsVVF5EF4bSCDV+VCkAvyFXX7OO9d8AFhDk2mORHDzs2nxj?=
 =?us-ascii?Q?y8E9OBzSKYqWrcA0ECfOq8Tz8Y1rBIeBffDviM5ECM5MK5RXwpXKPsvDOUB2?=
 =?us-ascii?Q?bnzWiE0oCHtOU2J+7bLpfqdbTBiHPDr/2AWvj0FTzdQPnHdGJgm7J22Lop1q?=
 =?us-ascii?Q?YAN2mCrfAyIkLt37+xM54CdUgiXpIMhhoLqxLrY3UVLVxfrhIDEaEABaK9gs?=
 =?us-ascii?Q?/Pgao/z4BWlKG3CJPHPQdFPZyqodbr+GhbZyOCk/kLg7tXxYmQKCK6tEQyra?=
 =?us-ascii?Q?hU3Gt/DV1sk/emLSJdsHw6uvpXScKKMJJTkUgr9V7lMEY9koxetBulKZeLsD?=
 =?us-ascii?Q?a0qfMNb17JYJBy+1uHE4daWofCoFkYiq0R5p3+gCEy4e1Oz20oRbGctF/qJa?=
 =?us-ascii?Q?WKsRRGxFIjXkQQK4VLD7p2PIX7OQtPyKgqWfpOqb2pl7bfgqclpgrO6UfKPM?=
 =?us-ascii?Q?aRPGTo4M1iJV1qGwpKY6iIrSb1CMC3jZ2p4m9YRnJMwLbTx1/X7vAgswpk0v?=
 =?us-ascii?Q?O02Zqag98+fC9Wk9mXmpAZB3vL4gyWlx0xbxTph12Pv4axFdQbOEwA9i4T4n?=
 =?us-ascii?Q?Kvd0WjiI3Km1TzgJruajsuLR/DTiEwkXH52D+ovvE6CHzADE1Gox1OvUeQd+?=
 =?us-ascii?Q?eRDNm4s3RRkOAOWdvt8mSy6mLYYd74R+U0/fSnggVmMJ61+rdlKq8QbDTV0s?=
 =?us-ascii?Q?pbtPrQDEGhakmMu3XprkEFjkH5ZjaE7Acy13eslXI6oVeClxxKkszbv2ON1T?=
 =?us-ascii?Q?zIXHD/0jSXRXo1FSVaz6IdywMcWaiP7NuzFTGzurS+p39uDTPMBHvv2ehfsM?=
 =?us-ascii?Q?WZ0Se1jO7wU+bWTLrQzF2ENhHFnzfjH8fDMOG5k5dfg3A6tvAuInz1w87vVQ?=
 =?us-ascii?Q?qwSJX+82RqQjDyInr0A7aWzEa2uKHo2pLp632W5UZGeISI57wC2xLfZW9LjV?=
 =?us-ascii?Q?3bH7TDrO/Vkrl0LfOKrmUCGJQEHdCy2KUo+5gMbN1Zkd2rttpRJ44jEeXj3j?=
 =?us-ascii?Q?kaGaRka7RbJPeukJy7f8UnHgrcPN9HWF2l3xz5hdrgImpAjnvC29LXtG9d0E?=
 =?us-ascii?Q?MMnt405puxXnQE7QByIfthrxt456DO86L+67+XA+1S9WdMu4CBniEpJMkgxI?=
 =?us-ascii?Q?XGfxVJ3XB66yiZfMJvfIWQiESrKjodItx624M5gBnhXvFb7BjC902z6unaf8?=
 =?us-ascii?Q?SF2AfVh9GzzX8Ckw+X3AniWU5lBiqb1R/k+BnX+szLddVCND1XKqs7KEMpzX?=
 =?us-ascii?Q?yb3bHMft5c4O8dhN29gRWa7V+JLwsZ8hGlRly/r1MlFSxSXDm01QRZRDX/Qg?=
 =?us-ascii?Q?KkynIj8RF+AqGVZsDcjrhgyKo3yTcmP1+EcSYqjUYcBBPJ2GsgN0KewwOscS?=
 =?us-ascii?Q?Lyqyk40esBaL2mkXvCju7NfQD4FJ6D75OzxC2aApni5iPUZpTXxZ0nsq8w4e?=
 =?us-ascii?Q?EQyO1PFBuaM0oB0mmW4fUl976eiNi4BQpZ2zKfS4dHbZYGPwgTx77XxL3Tgj?=
 =?us-ascii?Q?MhYFz6ivteJ2V46bkOM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9adad40c-6fe8-4eff-eb51-08dc842b84d8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9H5ZoOO2l8ncUePf8BUU76TAvQnHNd5BuZZzY7UtuzaqMz+BeO0DTu+4EmJYXQs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

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

v8:
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

Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Michael Shavit <mshavit@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 561 ++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  52 +-
 4 files changed, 664 insertions(+), 496 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.2


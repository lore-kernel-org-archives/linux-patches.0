Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B46A1B2ED6;
	Wed, 21 Aug 2024 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261856; cv=fail; b=iBJpNS2VQiH8RPxe3PdxeVXAjflj7og9FUjYPremgTVhgZ+Xc4lMAh0TbaO3F4mQEfLlTSjeBZbXP/n65hO6sym3QotBflFQvDWo90UMIKBG6+r1UDOZyeZRcAT9534hGWaKfMlBbDsaWRFma3S3cETxEDbccdnbKsP0mF+9PE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261856; c=relaxed/simple;
	bh=R2+F5woEsBAkYoMp/hQTYRBuHpQaAGr4FUxDzpsCljg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PqoMotTG4pAlQhNoQ0kHaUQzSEdrqL06QEJ5EOieQu9loynKvQS5SkkqVXgGtLZQZF0+C0TXcbHzQZ0VcxA9gjBvP/GGqyYLH7DzclTKWcuzlccVn5lN29KKamOdB78uM/L3gNaE31sD5SaQb/jctTjgZP0TnOyfhvb2P87TK2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=po/JpEJh; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="po/JpEJh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjlw30I5rADRcPVGGmZdqjNKLHb6p/wCjhd4Pq7wHKmhSZE+O81ds8WTrCvi6VxIwhfPyS3DT5NOOOzmOnbZ9SwykLSdmg02GzNkLDHgxnvvPuZX+pJcUHVG/uLio+ebn5xqtCBKEHDgOMv0pdcqJdYfNnH2hZeLrrW2UENbGpSG/P0zk9fXbLsyWrFdapxDIUrwZWUPAT1eYIyWLZlT4U7kEqglVJ5kW/m1EAHX1C7v2d6Sbe4howQjZRqrLc1P+Z5cGt7j1P4JwwiMug3HYXuwZeSKmP7kXEnDzgyS5FT7nPXiVS4tH/WMDMHoocNr0CN7ozKhPupkDLPP2W5nFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKVKecEWFghhHAELw8OL1gEnZ6EPdpbELdzW0sOQ2/A=;
 b=lJ/gEgmainvXhtZrsd9AHJv1v2+ZtOOpCT16T0mk8Q6gm7Uz8x1xq87a5odGlX/PANWLCIq7Odtc3ZByQbZ/3VWaCOHITgo/rFPqT61BigQpOwNyt7YSoJTtZ1vcFtLoeJ0Csx54CZae9oauMTxDfkcl3HJQI21qBlFHBtF9OD82NFvehPHKhDJ/CT6mXydrc0dxj9tI527IlAL3zQwSkpOsysRlBesosFyCs3cT4lVXHQ+gbeQdjluzqbtD1mb8JIVD3TtYidDgN3gAmJkRv2LeRxSfYADALyrdjQUDH6uHIOIaxka0zXlW/urrGVlF/1u+frfdMCyPlmyKK6E0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKVKecEWFghhHAELw8OL1gEnZ6EPdpbELdzW0sOQ2/A=;
 b=po/JpEJha//7OUNYGRyVZpiVIKyjU30bfSzsRsDOBC+ROfm1xvh9M6GC9ISiNoJXPwDvj4IPLHtNAUbI4DmDLMjaZY4QEdpcXVPIucSdHYatcPuB6yfxWu+76fMNzbzWSQ9JNJERgOiszFqxCyUe2vhjw6/lOq6SkDAxxrB4szzBH4xXGddQnN429mhGuMSMWcDSRxjgJfoo1DF8oIZuRzg2ESs3GwIz+kBji8aYsthAniGIu+C0KUxJ0kNp3DayuG4Ruqioa9BVu9UZz03QdYQJTHjHU4xObnQR+QJJuveh14vaeRb2Nn7HDDvStEqHj6FPiqILs2zJtLZXxkTkGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 04/14] iommu/amd: Remove amd_iommu_domain_update() from page table freeing
Date: Wed, 21 Aug 2024 14:37:10 -0300
Message-ID: <4-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641A.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: c38450d8-12dc-4d4c-adef-08dcc207e97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iRHohDmHT1PLYqYURBDfk6x4PCpk1mlRJpsARwhcZjKXFOPs/A3rvO3rSC75?=
 =?us-ascii?Q?FxkNPqBpD10WrLDuMBOOO3ILKvF4ISec9y78MzNJYwdaUMhzGMtAsZYS6aT7?=
 =?us-ascii?Q?XeJFQTywDavToK3FxY2MOz5CpC871wNgg3c2kyeFywCZWn4qXhQc17ZBbB8g?=
 =?us-ascii?Q?UARhW69V2Y0gq66jEJRIuEt8jcCG9PM4Q2eePysW/8qS31dE7aYFpW+TZ7kj?=
 =?us-ascii?Q?Q3Rpqu/rYWRlPrkLv+pj8sz5GqSMcLIPFby7vlNusblvWewaXf6DUIoDYXcR?=
 =?us-ascii?Q?x0gBSm/4anI7PEHjjZUvpeoXrF5Ru2u4CGw+CBa59CRFD8L5sq6tASoO0s9k?=
 =?us-ascii?Q?fY4A98AtdDj3Vxa/Zffsmw8JgdirJd8Fs3yiq6k50b+sxDRRjhTQMlUxa7Qk?=
 =?us-ascii?Q?oCupoWPbEKGlnER5trIU/EAx43KTKgQeXbPssIQkeOXOikXt6cVWXfZyhFnX?=
 =?us-ascii?Q?6rtXsy5mZjRIL+JN/Srr1Ug/wgQ9+q9h7nfEvpIx3Sao72ZicAHHh+WgwHlD?=
 =?us-ascii?Q?a/7ALe9okGHx30EPZix0dNCfRnXK2fu2jPbPS/b7NmdJZQ7ESWRjiDPRL40w?=
 =?us-ascii?Q?Ofqz9VHhBUiHFqqpYcvkghvg+ujV0uJg14uDvt3zEepi2ONAQ2cjbWq+KgH0?=
 =?us-ascii?Q?S4oGLtYpRq8MnE6i/ZZnqHUKb9ka+yeSJlZtPSBV3j+vO4ymu/lX+c1rjU/G?=
 =?us-ascii?Q?T4pIF2ubSjAA9gMjYQccK3m0JqgP07dUsl0JWqGYnVgiX5AXS+1hvpPlOXYu?=
 =?us-ascii?Q?HjWrwMwJ28RvCkBnBL1KxQf3WGhAOttxHgkeWfeEwwBhJDpwJfJImh0B3M6C?=
 =?us-ascii?Q?e6N34u7mLJ8EimkREh87WKH4nLMTVL3GrlF9pW5ClQqqwDsLy+gL7Ijk34kq?=
 =?us-ascii?Q?zbEXcUp0NacyGgnjD+k0DqmBCfOXKMisV+n53Jvq2Glhu7J9+yS00iqRc+TG?=
 =?us-ascii?Q?vsVd22IHgHYBeI8IkLJdZR7u9YfQLhhoBE4SDeOlP9QVe7Wzr+OUKTneKpGy?=
 =?us-ascii?Q?yW57bcsvyi+v1Lmyg/vEcHz7Gs3dnMXiJKzPdw0rgF9ElIlhJznMsnamR0Fv?=
 =?us-ascii?Q?6dDEwdia7is4Mdv+Fen39D02/zaIBWPgubm8ZSamIh/MomEwRTK0b+X+sFko?=
 =?us-ascii?Q?vu5dgMS+rSLKFxCesgXwu84Rr2vExkboTPEYGdJf30BmYxizqksbWRwKSHOu?=
 =?us-ascii?Q?3gAI3qG0eY/Vz39EIgPyR8PBpCNqDwuDbgXkcRfEkdPc7AGwfi2KLXc6KwF4?=
 =?us-ascii?Q?QNHy+rc3gE35qW3ny2kYEfdQGo7f0ZIBs/wD2Mxd/pLpyRWpbEzUYrl4tm7h?=
 =?us-ascii?Q?4CAV/pjpnMLpIuq8f+dPncywCOuAlwnNLrJCLmYrXrdZHg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wHdtD6s0JvMrVCJroSMMjoKP/1KiT3mKyItoUyyDLOFwkdcYBIxJByOmMeG1?=
 =?us-ascii?Q?auZ6+AxQBS6qD8jwqe2URIytUmX4452nUeoJqwzp6O9WcfLt+xmts8pq1pLI?=
 =?us-ascii?Q?9Wkob1Iiik05LdRCMonY4sFD1ValHbZxxTGqYnYIDBTE8yWNNtyqLhtlMvPN?=
 =?us-ascii?Q?PovZLhv9bv3bBI5a5unkBy0VZEqbTxsefF+D12oUyWGqbzLjrl0KFL8t1L9j?=
 =?us-ascii?Q?d8bSyyf0irRPAPYgF0DoTmdLPun5lPryPfPnxDk/kOrN9taF7OVoQHR5YQic?=
 =?us-ascii?Q?BzC5ZAvmOeV24ApsXNmXt9/ll+p4XJihLqCp/L0Ky+N2r3Eg3hZqrfFKtJ8S?=
 =?us-ascii?Q?rR7xr3s5wAjdZ6enhRKLDZ/aBfmQH8f5G4igYhNysF0g4OX0KZV+zOJAfltS?=
 =?us-ascii?Q?/axkrDTFV3ZG3ys+gGbXHVXaVP0+oGoSniH9OT7wLKUXOL2bpxP+/eWka6CT?=
 =?us-ascii?Q?SOu4qF053sv8TIOsl3u6JGsoeuci+xs3W+oYlhz+373W7pNbkN/xVMZV1Dps?=
 =?us-ascii?Q?7XfbPjNJ29CA3Sj2xbEqANSm2mOQ74xigDLZPAeumAhMVhmufd1vC54aaRzF?=
 =?us-ascii?Q?BwmSoMfx+PnYz4nMY+FttcxQkN5gKjvubDSPp2XkDALUfgLA0kqPVtYoGSU+?=
 =?us-ascii?Q?HNYzp2U0nCCXhaaZaxkiHwYaeW5mFQ03xv13mkrGlVTc0rXY0PoMd0g0y2kD?=
 =?us-ascii?Q?zhPa9brTCWXQnxLQtj6RqyBiWV/8HjR8qa+iEBV/hyEk8Fkxu/1puE1066bd?=
 =?us-ascii?Q?BUk6BFwYl0pPuVcIDFTamFVcCkilPvh9xWPZ+LR1Oxu2M8iUsK9QYsfU9EJ5?=
 =?us-ascii?Q?egGy1J3CWcE9E55EXMllA2s4amXEgpPK0UNHQ6Cko0gzKUbe1llGc0G3uMxv?=
 =?us-ascii?Q?HHHx5p7+rRlh7f3XzN4C1ow4M2z73oOVJwk+y907aLqDos/u+P/PPsHA5F8c?=
 =?us-ascii?Q?ymF4WJp05iNlfHSsnqqoJWTSFt2tFu20RSimw02+Oh25pfKBXRlpeJIGe+xJ?=
 =?us-ascii?Q?g4aZz/xkGxlLgC8APuIz4YfslZxi4WKbS1JAlLmkq0XyYKWHul2xdL24WkWU?=
 =?us-ascii?Q?FmSvFxJYwGD28ALp+eReCXVZk5xFJjtVlJz33Xbzxc3wJttO2/jTIvAvBr+a?=
 =?us-ascii?Q?E/CWDGmhRFIenOpaK5iYahkIsUiDE3uZypt0uInpTkijBFZ3SRdrwyP3wmgq?=
 =?us-ascii?Q?Zotym/0l4FaysOLF1gD/RDzXPxP7Su8/fTitgmPJeNuP35AdZ3DvDC0H2J/Y?=
 =?us-ascii?Q?VI8B/CnIQC0nPSdJVaLHS2hl6SBYavHMlvAl85n2B4xc1PofYyIE0PXw5hMQ?=
 =?us-ascii?Q?gTKIO7dxmAX/qAhjyMMtSdGav2Z+HuD2d9AHE5nSfUHrMzNOvBILWOcklXCG?=
 =?us-ascii?Q?WVNWbxT9qHUDXyfStXtzNkjUgspIVUO8dSwehAJ9Vbg2TurNrQl8xi2Lk4i1?=
 =?us-ascii?Q?s0EJjabnlisr/xLQ1xZhx/WFtpIGfwrQgpfwv9YdP07gY7uVIBDEIniEsyJ0?=
 =?us-ascii?Q?5bekWG3We4A3jPcMAW3XjIFf+/EEZqK37KRaefcmJ3FioY95iektscsGmYQd?=
 =?us-ascii?Q?vOho92pJmwk9G+0cWwF/DLvUQnG39Rj3InwvnhPG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38450d8-12dc-4d4c-adef-08dcc207e97b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzb5jEQvWpENHA5bM6hXK1iTj04UmIZilKphQ93ru7rNijpDL4kyfVBj5GDBY1CE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

It is a serious bug if the domain is still mapped to any DTEs when it is
freed as we immediately start freeing page table memory, so any remaining
HW touch will UAF.

If it is not mapped then dev_list is empty and amd_iommu_domain_update()
does nothing.

Remove it and add a WARN_ON() to catch this class of bug.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 3 ---
 drivers/iommu/amd/iommu.c      | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 05aed3cb46f1bf..b3991ad1ae8ea3 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -578,9 +578,6 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
-
-	/* Make changes visible to IOMMUs */
-	amd_iommu_domain_update(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e53ffb86c3d09b..426aecacc63009 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2260,6 +2260,8 @@ void protection_domain_free(struct protection_domain *domain)
 	if (!domain)
 		return;
 
+	WARN_ON(!list_empty(&domain->dev_list));
+
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-- 
2.46.0


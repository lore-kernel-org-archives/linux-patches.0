Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5139F1E200A
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491014; cv=fail; b=rfqvQchVaXapUwaE6LMCDNWLR+qkVRbY9zU5F8/8A3RqnS7/8aAB/fSHUzTObO0XUH6sOKV+cIdbEtGWPwexPz/weN3WaPSz5kJGOGyQ2MgfcfULjBljT9ib3F/gxwSHGtLSo6/ZTh2xVGXPIlq8naXCnKsg5FawX1wYiIxpUL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491014; c=relaxed/simple;
	bh=/dNsMUgLCXStd/1eTrKLB0hnuAZyLKP2B18hk7Hldog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sTFVU5VEQGawttewuwn3FE8v+mHO4/3yBUKdex9E4fD6jTyZQWqF2XDbLI65ugS7pOoPxpSvn0gV+HrK+ApqJCx5XsXOrjXByTlLLweVOkZpqUW5D8we97WDazS67NlH5Ui2cWBVZPHFIoW+LtKzfXaPPGVlLbGMCdS8XG1WydY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U/wQ7FC4; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U/wQ7FC4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lTwOeZasdUb47p+CroVoqaEjaWt00taS/1JzWlHIl72OTHu3Q/Ww3BRJHdKC7oTxiIt7y43z8IxwesekID8+ReycqNABRC2pQM82T12BD/NWuR7Mhe3W6LKhNfysYB4Tr1BuOUUTB/Vpm7+Ap8HMC1INBjUIpz5qF1j0tAbLzhrfgtrwfCQb12zzTzZ0Wg3/fz6RuZG0Hg+3hdNRuExxsp2C9+y+tpnHydezTqVeYC2WLPCNrYaCnvw2mixL4eyjdhpJbEG9NbZvc+jVMjrcEfmRrdtNLNhpWq1ysTe2jm8VsIjOQiP3Ogre+hSzpDx6Gz4cOx6B6jYX1DZiGUJMdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98Ksrj+miS0+Ca6vrt/OMLd71nk6UKW0sXWR7yptuXw=;
 b=d7ZEK4vckRVo3esC7oouOmCDHWFr8clzHPyg7LKz+wP3zF3IMlVryTKGcDfWGw0nHFtcAbk6L2WHuzD+e2JEMmoemNUGu5+2y28Z4rPp6eGdrcS9equZYz2iSsv0bZYCBrEp0q2Uy94tTGWrx+msB421r/KvZeSR27mAxt2ApQ5oOOPnXokwV4MqCdlo9hlspmXf5DX5YgZ7xt0X7PK7uoqCUathI6q/gCF+oZS2cZzoE0jcjMt3T/b2unqSVEYdWPzpUEBeZ2m7P+gbcp1vZTQnZoOMbFAcMOz5abuPltV59SjIMATnZ/UZxSSyfTwV7+QGQ/ROLrrQFTcbzC41eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98Ksrj+miS0+Ca6vrt/OMLd71nk6UKW0sXWR7yptuXw=;
 b=U/wQ7FC4cXPvEdRQhijiyS6FPoU0E7MC/kiIyIR18+iVZlaD5AjJriIvgoRf/wn282AF97MTYc9I+xF0nkBnFpJJqqkhPzknfZEbb+oW8KuLwyimKeWKdKtfdfgvPhL8uZcU4aC5vTViRr06GgOAUGirMjtgI52K+xkkMR7fBIyifpQofoF9U4SseUYgmQMXsG/8wRtbifxl1aVUfQ6Ui+oBcGIpdF1evllouUFSAKVK3WbYD1YjG576+I1B2nKN/IBr4+uDHfBiaJxhIlUiAYde0Tz8uSBxfll/HDUrDaY2Vm4uv3+6FcSCgoNtU6KQa82aSGMKNAavMXY5UYvtvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Date: Wed,  9 Oct 2024 13:23:15 -0300
Message-ID: <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:36e::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: f4400d56-89a4-4b9c-d8a8-08dce87eae91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GjH1ArCoG+WKLovRdMEmWqkOSpqgosgaC1jrXqpGLoimnD3CmafEOEQfL/8l?=
 =?us-ascii?Q?2RAcRwbEAVzpde50XjVDruJLnecrTBpJqsc8MsPT9WVWilnIEwChVJFiaRly?=
 =?us-ascii?Q?d2dC2RmdN3Ax+9goKR9oarqfadh+W62dxXk5LsN6ve1ff1OhbKhE1EOBJy4u?=
 =?us-ascii?Q?vHKGVVEiZgw0ejUEnutE0H6jhgACAb7U+06ttMyLTQmrQh3XoLO+e1K9Kund?=
 =?us-ascii?Q?cUkSExtIz88Q2gkomqDnEV3iFk1ykp1vSHhY4v1Q/nbdft6ASPmsCHxzAW4S?=
 =?us-ascii?Q?M7jR89/Md5PPonlMY1mTp6VTWtevhrgmqRAVjpEn3whwK2fuCHNAp90qjjqa?=
 =?us-ascii?Q?DC6mT4n5XFehZ0RTf7SkPkKQqfG82fAlCEElb1yvtWjd11NbyUMOuZZanQkH?=
 =?us-ascii?Q?X1T9obzJ2CEPuVXxZI1SoG0JK5yJ9hpA5BdTsCDwq01wdnGKGeVwFmJbXPpt?=
 =?us-ascii?Q?An0+zINv5cNeH7Kqug+rZKN/T8cjTtWjnr45RWsZNjfOcSpsb0SOHVXatf6N?=
 =?us-ascii?Q?kRB+5oX7hwxgqTqZ+w/wgatuTAdNrinhdRTSFEHBkdbbNaBfhB1cBISg1hfJ?=
 =?us-ascii?Q?av5r7G5LeO1D7c0tLA8U8tnFXXiMLYdMhLJfnt/u5H5R5/cdx3yKqgq9AX3u?=
 =?us-ascii?Q?ssUtr7yAHOfQlOJD48ML5VjZhntxHCiwcged5o8Zvogj3VKleorLC92+StGD?=
 =?us-ascii?Q?wzFsNPRV6BK4DJKfwwCBEtrEQWzgmTUjV4h6T1dUBbFFsAIrge75zc+jerdE?=
 =?us-ascii?Q?px/RDirb+RHz+OKuGnktfVolo7ZeOgIfAEKI/DdAUcOT3Loc9G8/u1TBBP00?=
 =?us-ascii?Q?0N9KhopASN2rfY6km42fM/+Q5tz51GhER2I8DsOBTI8nsk8Rd0Bpcmn8zVgO?=
 =?us-ascii?Q?v6hIPZLGAgBq6Ep3jAnUzkh3fszqB2Wg5LjJomzKeiGZEuNDF1iGR9XkzkaG?=
 =?us-ascii?Q?ehj6i9D3HXyfMb1rT3gaTXNH201YQPJMxp2XdmkZiMPIW22nrftfIl3+U4lg?=
 =?us-ascii?Q?upwIcehINMKE3g5tk38QBJw763NKrDR5vb/61XA17uPEonHNX36//LPInGzT?=
 =?us-ascii?Q?uH3D1nFVn8jMhx2JMW4RXsTub4cSuCLTBZQ0A6qKeMsp6NvG4sllPcDwEtE8?=
 =?us-ascii?Q?GoEL6MCssk6pYVd675h6Ml/rmi3y+mFof/of55FhxQ5hwZ7GeoL3DCnEENn7?=
 =?us-ascii?Q?qVLpxjdzcBtd/HcwSs3wyEIDKhaIaN9t+ucRiAqha8DncKcgGHO9OSpZnnqy?=
 =?us-ascii?Q?Ezpv8US+wLUCTEUhjihkfEbqX/svF34J7V6AutMWsJaeo9AdpB9Mvb566b3d?=
 =?us-ascii?Q?J/XhX4qR2GeMr6WwB07g0oAS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SzsuDejJOrNI1QiOSQijb5cr+n0feTc4wI6uxupAgzYqdZCrB6tcOJSZxT63?=
 =?us-ascii?Q?J198r5v0BkTsUqmdeUPYuF2HQix6C+FCrFDKfsmUbDuTd/GJAbkND/QEZFUE?=
 =?us-ascii?Q?SRc2KWA3y60MpraHIiybv70qffImJgWtJ1DMKcSXm+SRfgLrdMKh9teJ0S+u?=
 =?us-ascii?Q?IuPtuCfUe3qGusXH+NpxUAOo3zqM2euHMuvmexxozqbNNDwFC7HLQj5KLzwq?=
 =?us-ascii?Q?112/HmbkMq9yXXEbRv/XNGd4aiaICcrxhpm/hy8o48eweBodFo7xSIMOfZwb?=
 =?us-ascii?Q?g2p5olGKlJFwCCKA/6xaLDPYMOiaE0phA3J/MdxQDmLIZwm5K/yyGv6w+sBY?=
 =?us-ascii?Q?DBYLmwFZzP2+20yt8ql6nALnl0lk9nhiHTm4M2v6jD6nsGHMA6irBHMIlnDi?=
 =?us-ascii?Q?xbQSg8IskDOBJt5P0u9VGdAoKC1Ca5VVuCDdtElDLPbMk1u+LydL1hRr5Pxc?=
 =?us-ascii?Q?uVWSZbZOlFSQsyBoD/99JlnJUwQl+GHITLdkwOQVK6zIhhcPA6JW6jgCgDb7?=
 =?us-ascii?Q?4Rpd6kMygcnK8Q4R9y82LwKcvqiRoc2hEQsBGNtuK1kGxVX3SVVUq/4zpEii?=
 =?us-ascii?Q?5T593krHhi12SflPg1mHKNwxz58TJQEj07NZKOLTKpAK/SCH0csrCqZo8n6j?=
 =?us-ascii?Q?DGV0v6x67eJomCBz0T1s45FxRwxNwiM2NnOuhCLkjVFk+5k64jS50arp20ww?=
 =?us-ascii?Q?vRrsDEQfmQy9C2WnZuLjdA02aVB8uCaCfZoMvGBQM6GafIuMTNz1d3qcvjB+?=
 =?us-ascii?Q?nfsMq8KApK57eIebyPEzbkiXg3FXf53unIo/gKeclo8Z7EUtAdeXDcaGR5sL?=
 =?us-ascii?Q?rvVwuHe8Nxrflg7NuE8oQPG4WaGXQCThkFtgCMlbIU5oyWTcVpNkIDy7azrP?=
 =?us-ascii?Q?wJUFYLN4lgrlzO8Y2DjKRmS6gioQzoT3VjaS1hNOwXThpXoA3XuuoK+dqsvK?=
 =?us-ascii?Q?QCys9hmq1EoqyDLswwtABcMgVRFD/k0FT7xoa7DAgnH8pK8hfYodBw2OXVDK?=
 =?us-ascii?Q?GbPs8oW7gHQT7xClR956fq7TkrErK7PE82N+QZ7p9wcbRr02nhpnYA0D0EgO?=
 =?us-ascii?Q?LvdLroY13DbJYu7B43TFyK70oBNtjVD7pJP/t52yUeAfM9RIqlQq3fDSLJAL?=
 =?us-ascii?Q?p5TuwBYZWu9Jy21FrBoYFuawRcZXePQmc0uc6kUoyZjHscqfDBewJhAx5lz/?=
 =?us-ascii?Q?4pJ6a+OGXEgxL9Q78I2sPPnnX8u+Zz22zu16JxdrXkG7fIoyw0XoTz7XuC1i?=
 =?us-ascii?Q?H23t3WF/6WnkGJXDH/ywtRO7XT/U9FmggLl1iHHqRYZrHDfeTqnVUYF1CkTh?=
 =?us-ascii?Q?z4u0fylvv3L/cSIx64TfklcmEOy6v9ub47afZEuy3/SLmfTr1fe/x1WRIYwD?=
 =?us-ascii?Q?LpwjbwpDEuMWK552+ma66hwtOxlGdsw3Uawd0e2AjtFRMrptHY1yXoNLZp5F?=
 =?us-ascii?Q?lewkJTBGGa6CLyvfb8sSQ0HLyzUz/ho7+tZuLmQ/JKNAzb83L/wooWi/cXug?=
 =?us-ascii?Q?coJoWfbogXzfR9B+f85IN1w7odkOFiZa2ImOLrYFeM9fmCfcFk7cByxMnOaA?=
 =?us-ascii?Q?nlVu7nROr4FCVXjrIvw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4400d56-89a4-4b9c-d8a8-08dce87eae91
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:17.3903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7Qf5mSXwA3VQGcPU0jHb8/kP43JbiekEkDTM+NAqVcEKIVrIwXPjPSx6MqLt+qj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
works. When S2FWB is supported and enabled the IOPTE will force cachable
access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
access otherwise.

When using a single stage of translation, a simple S2 domain, it doesn't
change things for PCI devices as it is just a different encoding for the
existing mapping of the IOMMU protection flags to cachability attributes.
For non-PCI it also changes the combining rules when incoming transactions
have inconsistent attributes.

However, when used with a nested S1, FWB has the effect of preventing the
guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
bypass the cache. Consistent with KVM we wish to deny the guest the
ability to become incoherent with cached memory the hypervisor believes is
cachable so we don't have to flush it.

Allow NESTED domains to be created if the SMMU has S2FWB support and use
S2FWB for NESTING_PARENTS. This is an additional option to CANWBS.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  8 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +++
 drivers/iommu/io-pgtable-arm.c                | 27 ++++++++++++++-----
 include/linux/io-pgtable.h                    |  2 ++
 5 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index a9aa7514e65ce4..44e1b9bef850d9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -169,7 +169,8 @@ arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
 	 * Must support some way to prevent the VM from bypassing the cache
 	 * because VFIO currently does not do any cache maintenance.
 	 */
-	if (!arm_smmu_master_canwbs(master))
+	if (!arm_smmu_master_canwbs(master) &&
+	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index eb401a4adfedc8..4e559e02514983 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1046,7 +1046,8 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 	/* S2 translates */
 	if (cfg & BIT(1)) {
 		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+			cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
+				    STRTAB_STE_1_SHCFG);
 		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
@@ -1654,6 +1655,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
@@ -2472,6 +2475,9 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
 		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
+		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
+			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b5dbf5acbfc4db..e394943c0b4bfe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -57,6 +57,7 @@ struct arm_smmu_device;
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_FWB			(1 << 8)
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -265,6 +266,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
 
 #define STRTAB_STE_1_S1STALLD		(1UL << 27)
+#define STRTAB_STE_1_S2FWB		(1UL << 25)
 
 #define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
 #define STRTAB_STE_1_EATS_ABT		0UL
@@ -739,6 +741,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
 #define ARM_SMMU_FEAT_HA		(1 << 21)
 #define ARM_SMMU_FEAT_HD		(1 << 22)
+#define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0e67f1721a3d98..74f58c6ac30cbd 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -106,6 +106,18 @@
 #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
 #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
 #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
+/*
+ * For !FWB these code to:
+ *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+ *         Permit S1 to override
+ *  0101 = Normal Non-cachable / Inner Non-cachable
+ *  0001 = Device / Device-nGnRE
+ * For S2FWB these code:
+ *  0110 Force Normal Write Back
+ *  0101 Normal* is forced Normal-NC, Device unchanged
+ *  0001 Force Device-nGnRE
+ */
+#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
 #define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
 #define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
 #define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
@@ -458,12 +470,16 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 	 */
 	if (data->iop.fmt == ARM_64_LPAE_S2 ||
 	    data->iop.fmt == ARM_32_LPAE_S2) {
-		if (prot & IOMMU_MMIO)
+		if (prot & IOMMU_MMIO) {
 			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
-		else if (prot & IOMMU_CACHE)
-			pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
-		else
+		} else if (prot & IOMMU_CACHE) {
+			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
+			else
+				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
+		} else {
 			pte |= ARM_LPAE_PTE_MEMATTR_NC;
+		}
 	} else {
 		if (prot & IOMMU_MMIO)
 			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
@@ -1035,8 +1051,7 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	struct arm_lpae_io_pgtable *data;
 	typeof(&cfg->arm_lpae_s2_cfg.vtcr) vtcr = &cfg->arm_lpae_s2_cfg.vtcr;
 
-	/* The NS quirk doesn't apply at stage 2 */
-	if (cfg->quirks)
+	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_S2FWB))
 		return NULL;
 
 	data = arm_lpae_alloc_pgtable(cfg);
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index b1ecfc3cd5bcc0..ce86b09ae80f18 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -87,6 +87,7 @@ struct io_pgtable_cfg {
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking in stage 1 pagetable.
+	 * IO_PGTABLE_QUIRK_ARM_S2FWB: Use the FWB format for the MemAttrs bits
 	 */
 	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
 	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
@@ -95,6 +96,7 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
+	#define IO_PGTABLE_QUIRK_ARM_S2FWB		BIT(8)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.46.2


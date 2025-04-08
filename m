Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B26239089;
	Tue,  8 Apr 2025 16:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131267; cv=fail; b=EXPCEThGaZiIR8Otq3h70RR5MCSfX9vzqVTyLVf8zpKqt3mtvaVLwrLyf6RKy+dvsev7GLl70Mvqf+dMmY7rRzCIrnslVwS2bixwInSCnVGzIs/8GZV+looDpo8Z17/gw1zozTEwAmgFWu89gP4zuuNX78oKUiR5WU0wOVDt66g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131267; c=relaxed/simple;
	bh=ucj4ztDFuwAl3ikaPg8IyY2TN68QZezzX+3nQY7xGeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=juuW3SVn4MGiBoGsiMbh7LaqqSXXI2CxubhrC2ytSfk/PjQP3cTD8SOAqgIxDopiWVu+yUKogJUn0zc6BU3I1C7G5krvbpWriZe0AoRKfT6f+CUfsHC08dVw5O7qbJAM42WlhDDXlNMBAEk3FSbmPT1C+qHqlum6cjjGmv3zkWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JQQtsShC; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JQQtsShC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1xAsrAFlp8QvXh3f7FDECujNnYm8Ceyytaj8tmG4L2EmpuW85KjM7c8chhKw0HFZvSw3il6cjtkLnE0VJw3pNjpEvMkghwxoxgFR15gwB/btk90Bt0jvxXC0K1/VELErlIhX1UvzzM1j9q18oK2c0IDIulsKxCEOgpX9z+V91+iOG2+Y4TLNFawxFtKo80Uy1KNQ7MHMdq7qg/v/9JAJx0WE0QxzwiPyq8mu+CmkGhN6wrwYFAQjEMQTygmNWS9wyHj944rnNR35Hah20Vp63xE7+GU4JixPUQ3DBQCxGl+fgGCdMplWpSpCO+jllCUgt56GhX3Q/Hg6IOBKvFyug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4sZRYMUl4o4qdaBcEF9O7suZPS2wa7CRY7hmjO9By0=;
 b=tGNRiDG4CInU4dOlmyC7DiT5eC5o6U7CqWDacqtJLImyqqKecsVCeiW5w8fBsoOnGVhPBMFzUtyZCeVS4lUtfDNaD/za1u0sxGicxyG4V9gE6Fm/06SK6QR3PrAN4Lb7/vJK3lmKVNFs8cDlWCc+1fG21w+Z7qX6VoGXyykKlGIIYHaeGL75j3BiqRLuzi3urfh90E9fDZZANTVvhVdwCXaPWiS86Ib0NItaq9W6nf0R4FJNIMOG9WINgcbIg5cJBsOlxFPAgFyrpOgBzUVJIsyLlnk91h3DLtWfCgFsbFDHYo1r+sLtKU/Aytn+dM97QFLfyPUk1JKtE/okNeJ8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4sZRYMUl4o4qdaBcEF9O7suZPS2wa7CRY7hmjO9By0=;
 b=JQQtsShC4ciafugRuRuFfJg9jwjD0S/h2SD5ky+1tv7TWiR73/PK6vg8JH4yrEi1db8kURqDk5NJke4BIc5mQrMrb3Jd0W2jrnwwFsaV3lfPtqUY7iZ1ACxYhGkiw79903Kn9H6JXSpJ01rIxKLmT+XZEl7ejY0WIVYrtAxHaHygpWZU7LF1XWSaiPRKXStspVWZPbDZGhsv6QjYiljboAEbe7npnB8Sz7jw7JEeWZJ1VaM2tCn8ubgThc0mLQxIMmigtoi/qev/S85SHOZSl0/ZlmhC9cQq72CjS00IbJeN1ZmXGycGvIG3/Td/IL0HD1C6ZN7esSOLLdHL/SmPsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 23/23] iommu/vtd: Remove iommu_alloc_pages_node()
Date: Tue,  8 Apr 2025 13:54:11 -0300
Message-ID: <23-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:408:fb::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: caa8db0f-3782-438f-82d2-08dd76bdfe4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rtBsS5Vo4B8SZ4xqqGjxwRxZ4Gdw1QcLU7vTAy8Txddh9ewSTbDw6UOyZsIG?=
 =?us-ascii?Q?UGwGPvEvdrtSFe7PiXUmLh0AH6alHRG4Wmpwp1V78TIka3bp5CoHAiy2ldDw?=
 =?us-ascii?Q?fo/JE7u4XPWuHF1Zhdx4vDwCfs9BGLVj2cXCwzBhnHorMSAOShZel7F1BJ9z?=
 =?us-ascii?Q?mwjtNd9mloncKO+LEAdYIPMcxWbwAkNhORMmBxnm0uYoId5HLn1ZAHC4o8ib?=
 =?us-ascii?Q?SwGNEDIETJq502qzPphOUJXc93/lqdPFULEaey6gPzPmz10VMrRxw50UV+uC?=
 =?us-ascii?Q?wwLc7wuvpL2oVj4pfEX7F1rkudwRA6ioRQxFYKslCUMiPXtlhWyOF3nHPH2O?=
 =?us-ascii?Q?7wpBvR5gTfAirp13J0NnUR0LH1T2aa9lpGnx+5P53t68GAiHxZpHPlh5lLt0?=
 =?us-ascii?Q?a98PPtt0QF8XGLdMDAygOzXN7AiQ8IKyZ8mDwkoR3j5Kc3lE8mqvPWSSHJZi?=
 =?us-ascii?Q?vralzemc6SPxtrqy9wvXUM0IZ5BtoiRhjzHNFO1/EEPmfa11Fo1SJTcBqyof?=
 =?us-ascii?Q?0AGl6NLd8OCr0CZ231EVqaI6/UlbsJrJzzFgjXOkFrtx4AWo3zq0Rc3oFBnQ?=
 =?us-ascii?Q?rXX7DoTB0IVMnNb4MgTxgSFHGxArJN+3KhYEjE5MrZ/R8zSJvARbC7pzTUWY?=
 =?us-ascii?Q?iOOwTHNvn3HImXQkeuLCYweQZIdcMEQbKL6tiuIaeGQQrPz1jS4IhCs0GAjw?=
 =?us-ascii?Q?I5Us6tOHA8OR9AlbmbNJOeJMsnxi5ZfBI5sY5VjZkOB6CEHzt+qGjV0Au5Je?=
 =?us-ascii?Q?ihF782riTqzgfnMKGBQmH+bmYLQb6USVCb4eRdq9C6b0O2ruN7RyZ+1cU5Xx?=
 =?us-ascii?Q?zu/PTha+VHkwwVNvFE6ksuMjdAq/PVC3yOBIRyAVsQP6xdigNE0WeKL7pogK?=
 =?us-ascii?Q?7pfs1L56bbMgYveqy48DJaayjAyutGu+N4m6om0b9//irBxMJeu7Dof3i7U8?=
 =?us-ascii?Q?NHulVTZ2YwPvBPoZ8vR/bjiIEfIcsP6pcMhQWIOP8oq+GminmfKgoGGf0rmJ?=
 =?us-ascii?Q?ez/Nhze/iVXZr0J5RLGflcygS9TFiprME2lGVl1gwS+ALNmOpKkDmC4xxJnJ?=
 =?us-ascii?Q?CBFkaVbd7nRueLwMSuW9R7/wKvjYCNgwH2YjYuajFbMfGNJwwcKOKVN+RLuT?=
 =?us-ascii?Q?tylf9rfPOMGWvdMb9HGTdy9gPqXXfz5Q64Y12KuooXmekKMyfeqs0Xwkyq0k?=
 =?us-ascii?Q?58KfCCID8ukbiGNNQsbwFGFUk2RZnKceyP+ElPAyt+7bx6p+udMj6JW3uVIv?=
 =?us-ascii?Q?E6ayZvU/ov4oCDwstkUwNJb0a6U0nXyQjJ9nD/qT9ZG7WYsxoNLso6ruEpAc?=
 =?us-ascii?Q?3k0YBlluNJb36Y+v0/wkW0ZDvrAWE1df25iA8WEhsSRvVVub7iuoOc9s6H9o?=
 =?us-ascii?Q?kPYytCTO/8J+OlzF9b+1acZTaFrQ9JYWo2PYgy63dghfKBU1sTCy8lN097Ig?=
 =?us-ascii?Q?eG8SfOfRVNdBm4mPDyTiqLg0fF4XP08P0wHSjU/gr/Gu72gmqHY1XA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PZD+kHf3TQ+qiAzeKG5FJG6/F6Fi6tQ98tFfmub2iaSbU6AuHdudoCVqNY2D?=
 =?us-ascii?Q?YrCxd3zla+p3bvrpXj7nxDFOuUSyRqXPrDyBy8c3knAosMGU8RD8lKKKgDAf?=
 =?us-ascii?Q?s5eXEDRd6/5UwrDkoJFJbznHy/QjHEIUXYeYKbDsh4gwWqxp7YWJYd9Z6LhI?=
 =?us-ascii?Q?joqUPV60IWIrRpjjfvNxsP+YBZ5VGGH9rFN4qzWFLv16Nqn7ZYRrrWMwAb8h?=
 =?us-ascii?Q?9KQKMH25eu54Igmga+bcUmZYokR/d4Szlhc01VIatYUwLPtIYNCO0YGS9bsz?=
 =?us-ascii?Q?Ha3qVmPu/N/ZEwnFHz7Cf53VPzZDkCKG9Sbm1AZOafAoo2GgLzMSX+2x1h7S?=
 =?us-ascii?Q?zUTxC2JMhWtJcbOfbgVR6GrE/raL8iFPzU47I49JP+rtE4bCqEdRMxIpOLRl?=
 =?us-ascii?Q?2LfYw2MUrUGC7MF+iuk2DDTDbmd4tTMufJd02Yi4PyTYMBC2bnr/CYK4FGZ3?=
 =?us-ascii?Q?im1KMazkEaQ8sFgqNRA5Z6zs1ZizlpXPlz7F4M9AJrB7eP/EjLxCd+dDXpMC?=
 =?us-ascii?Q?B4n09bVuOlFOomeypqc+nkx9H5IraKXTMsmJqp47Q6JuR0RE6AoYI9T3/4PV?=
 =?us-ascii?Q?tkvzUf1GGouQdBDGx1mlNESv+0Ptfu5obQ+eflEycIRjsB2XHXm38hUtneg6?=
 =?us-ascii?Q?TOWJxihcw5GOideMxPR6b5fhorva0WuRzysyShmEFs9BSqMIiab7KxJoY45L?=
 =?us-ascii?Q?q0AHspgaxJtdBpj8cTQHM0BZJhPJJlcKrO39LLFIh3Z3WVQ+MS6MCCP9gMvC?=
 =?us-ascii?Q?sFFVaiJz3OXzrOooyTy7QaaTZOMpP4Bs2J+zei7F9llqnDA60egEMlqBrU9W?=
 =?us-ascii?Q?Vr1rzTLrqv8lYtWgrx27Fc/S5DnYsZyYpaTkq76rBEJtkXRdbb+Wr2nMhENd?=
 =?us-ascii?Q?mLFGdVMl7PXrsGHhW8Z5Oc0LZPMC7gFC8oPcf0uxt2gdBTaF12HAraR4EBew?=
 =?us-ascii?Q?x0zwSeAzi/AY5xFnZMqAOtuNZ375iFlJdymBMyAz98djYz111BoBXShUNK2/?=
 =?us-ascii?Q?3kS17NlyySIqN2IipCO7gJZjOAQlsirCD76hHAJrem5NNr5cnVp448DaF4zK?=
 =?us-ascii?Q?mYeh5UhBOD4u6zXsrJS3qY5GY6Qq2wcgw1pCgd5mZOX4/f5DiATSIhrU+QcC?=
 =?us-ascii?Q?upFqYiOWlK3Pk7o8BULZX8PtWrBf7O6TMk33Gukn7VXxIQReJljBQEt72cna?=
 =?us-ascii?Q?caFGRJ5+uY33YN38NEid4l1pS4fbUsvWdIgC31IBGvugn4apJ2Ji5o/aNkfo?=
 =?us-ascii?Q?IxclJeWwGe3XZrY2QeFvlQe/uzkHFoMiOIqCmMT1r0cHdLaecDM9Di6DaJ80?=
 =?us-ascii?Q?Oj6936APcipZ94CkQhOrGGMZ8lhQm1SZAhoRVe0hFyd7D2+/fCaMkiexZ0JA?=
 =?us-ascii?Q?mhZ79RPTcKQxAq7P8iFkR7lER5nObiaN8tWCoIODo2ORj+Kq0DTy0fKq95wa?=
 =?us-ascii?Q?ukbs8PhT7gb3o5NerOtsD0tMlrgvX8bFac8eiEY5h4WdeG3JCPUoAwBIZS5m?=
 =?us-ascii?Q?nBOP5n1TzFPmpYE82gjhIa2KGKh2nCHbjaAMUBeb/YZYws0U9dML+dd6at5R?=
 =?us-ascii?Q?AkMtCw/Vx2OTckb03vLKfkAEPivCBX4EfFP2P1Eg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa8db0f-3782-438f-82d2-08dd76bdfe4d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:14.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhlBuWK95MGm/IC9lpJfjpPofFqfgO3a16HeVXC5KjHLDqUl/ipK33EfWJVrk+9L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Intel is the only thing that uses this now, convert to the size versions,
trying to avoid PAGE_SHIFT.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.h         |  7 +++----
 drivers/iommu/intel/irq_remapping.c |  8 ++++----
 drivers/iommu/intel/pasid.c         |  3 ++-
 drivers/iommu/intel/prq.c           |  3 ++-
 drivers/iommu/iommu-pages.h         | 16 ----------------
 5 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index c4916886da5a08..8d5d85bf00802f 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -493,14 +493,13 @@ struct q_inval {
 
 /* Page Request Queue depth */
 #define PRQ_ORDER	4
-#define PRQ_RING_MASK	((0x1000 << PRQ_ORDER) - 0x20)
-#define PRQ_DEPTH	((0x1000 << PRQ_ORDER) >> 5)
+#define PRQ_SIZE	(SZ_4K << PRQ_ORDER)
+#define PRQ_RING_MASK	(PRQ_SIZE - 0x20)
+#define PRQ_DEPTH	(PRQ_SIZE >> 5)
 
 struct dmar_pci_notify_info;
 
 #ifdef CONFIG_IRQ_REMAP
-/* 1MB - maximum possible interrupt remapping table size */
-#define INTR_REMAP_PAGE_ORDER	8
 #define INTR_REMAP_TABLE_REG_SIZE	0xf
 #define INTR_REMAP_TABLE_REG_SIZE_MASK  0xf
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 6866b4e6284842..9119170f95d94c 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -530,11 +530,11 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	if (!ir_table)
 		return -ENOMEM;
 
-	ir_table_base = iommu_alloc_pages_node(iommu->node, GFP_KERNEL,
-					       INTR_REMAP_PAGE_ORDER);
+	/* 1MB - maximum possible interrupt remapping table size */
+	ir_table_base =
+		iommu_alloc_pages_node_sz(iommu->node, GFP_KERNEL, SZ_1M);
 	if (!ir_table_base) {
-		pr_err("IR%d: failed to allocate pages of order %d\n",
-		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
+		pr_err("IR%d: failed to allocate 1M of pages\n", iommu->seq_id);
 		goto out_free_table;
 	}
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 728da85a910068..ac67a056b6c868 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -60,7 +60,8 @@ int intel_pasid_alloc_table(struct device *dev)
 
 	size = max_pasid >> (PASID_PDE_SHIFT - 3);
 	order = size ? get_order(size) : 0;
-	dir = iommu_alloc_pages_node(info->iommu->node, GFP_KERNEL, order);
+	dir = iommu_alloc_pages_node_sz(info->iommu->node, GFP_KERNEL,
+					1 << (order + PAGE_SHIFT));
 	if (!dir) {
 		kfree(pasid_table);
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index 9859bcbd425e16..52570e42a14c05 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -290,7 +290,8 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	struct iopf_queue *iopfq;
 	int irq, ret;
 
-	iommu->prq = iommu_alloc_pages_node(iommu->node, GFP_KERNEL, PRQ_ORDER);
+	iommu->prq =
+		iommu_alloc_pages_node_sz(iommu->node, GFP_KERNEL, PRQ_SIZE);
 	if (!iommu->prq) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 7ece83bb0f54bb..b3af2813ed0ced 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -84,22 +84,6 @@ static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
 	return list_empty(&list->pages);
 }
 
-/**
- * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
- *                          specific NUMA node
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * Returns the virtual address of the allocated page.
- * Prefer to use iommu_alloc_pages_node_lg2()
- */
-static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
-					   unsigned int order)
-{
-	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
-}
-
 /**
  * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
  *                          specific NUMA node
-- 
2.43.0


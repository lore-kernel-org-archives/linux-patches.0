Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10BD273D6B;
	Thu, 23 Oct 2025 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243773; cv=fail; b=rxd0k2hXbtf41UemEwvyMgpiYBN6/QCaI36rbG6eiuP3Mc5gJCr/cIyD4CKRzf2cDsmXZuKvyRoyO1Ggc4LDZFrlk/WujiaVcURdiBkXK+2hzCbEkAsgOMbevFAJvdMRg18GJnQhS2Oy73LV7A+8gwcd36+GgoxWi8kHxIbK5eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243773; c=relaxed/simple;
	bh=bLoSVpbOpgPrKRpjmc9i/tzVPghKL48WltmEiQYr90U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KV3DhVHhK6S0HHOTHsZ+UbkdJYrzhQ/zsMG9rn+mgQr5Hb7QF3zTWPlrZfVKhMFT4bytJ82WQJrk23vtPoeQ/jhcxbReVw+NFz6e8ipskBSrXHUSf7tAKFPRFwNfPF/c0eriXftWAANwHNO3/I2a+H/GxHZCXE5tyNuyJzJdv9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gvc7g8mS; arc=fail smtp.client-ip=52.101.46.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gvc7g8mS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFf3quUc4JZeGANaIE+SDVk06jeXVu1i12zC0mqsE8dSe6Q0y7ebuFzwGHB3ir8AwIPwPfVO+r7WDyqQczlKXFJ6dxjTUODutVCYr8SDMkzjl9G8gbOLMcUHKcPMACwBKyAnuJtddoWeo299PToNaqPIbfDYzGsEStie6TV9radm1n+uS1bG+YzJDG5B8CIzJAipjzyz1kJXqq9PxEYjHwLxrCYa3Vh/08m4H6gSG1yWYeN0e7odPKS5essWsGwfKyl04dOi5tT15GUH3x2VabTbIFd2/0h8CypZpKORM0j8RDVjL+BNSOFuJASWOhyeetmIvyhaezz7y3jVvs1Pnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHT+Dv8l20Lx1IxwhTiO5hh3RFCBmzAeT0LfcjJkNpk=;
 b=PfJITgF6698Fv/SvRSge7wCPUY3BiBD0n05pJpLJezynWdgUXqQkge7fgKmXqXUhTt7PHR3OHhJAx8YQbYh8VqfG/rFz5dGLrNYMfDKe/CO374z8rBgd4Fui2/7CW11mYMhOlQ32WG4Eo9jAqMQCS+maRKubC5L8lTIE7rGgIhsQwSFpjLcRtbv6y0UcOI/i4ZJBQi+2e8ITTpKHx71mXIuu9H4lAGLidUsAnMQkbHt+vZuWolEx1jzB+A69WlLiJHKnSEVVKu9uETawr6V2aKWjrfssOsm0oIF+4pjG+dzKhCvEO7w8xjZObmU4kK5/32vI+w/BNiC60PZviSt5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHT+Dv8l20Lx1IxwhTiO5hh3RFCBmzAeT0LfcjJkNpk=;
 b=Gvc7g8mSYQmY+dDfblNUKhpY6sKvLXJh9zbqjZrLTvPeZekLDRcTUgUJNPvCY6/E/XjiOKbdp3kjma+M7b6TpqEUTzgotcx2KONbixp1v632DlD42HOhW0KV9h4UnwsFL8En9rCJCjM/DkabB10DqMkLPL9AxzdHoTjBghTZVr/SnJNDCXT7T5UA/5HDNq0OCYFjZeMoP8MiiK0wFNUuOSwQSLlk6zY3lvk8chWZvMGDDCBcfclyvsYbd0w8PUILRpnr5zAzLctB+4YAjxkoErne49JdiwBzMZXIXB8gAt7w0JhpBx7cToFesx6qiSrOukfatKHoCTS4XPlxY7wQxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:44 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into the PASID entry
Date: Thu, 23 Oct 2025 15:22:37 -0300
Message-ID: <9-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::23) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf168d2-d98e-4847-4767-08de126128a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oyNbJdbiKoJGFDzzfgc0EJoAZFOU6uEueYWFG//8utfJomtjIjSl1LUkVT5o?=
 =?us-ascii?Q?6luyN4ZRyuYUxJVsUneQw6J/ynhaOGBxlyDSBhr2Jixt8ZdL/BIMNtZaik9E?=
 =?us-ascii?Q?gOiVh69IlHjvWdY4AVVYKMtJtI4/Qf0bPbqm0/9/CUNKOGjySOWMjDVEvnMV?=
 =?us-ascii?Q?4F2eQJdSLiQz0n2JVgoENA3XYS0XP4ZNBeRUxFKRNww4Ei7TUUxwe+V04kVx?=
 =?us-ascii?Q?5Nk0nYrRQLB7RJ2o1WrYbNUJcnmV/umVc36Z2HTA9Woy7vWJCSxN//9z6hCH?=
 =?us-ascii?Q?WY6xBsE3fY6P6PfJMqb0wPZ9PoPrm1f/pRfW6ySVg7g6Lfg7zOGVGQLH+kcw?=
 =?us-ascii?Q?3Dkss1RTeFrlVAqE2gWgeBw0UAWNDIHoannwNIWGZ0y2gl5M0ZVzpbkdYFEt?=
 =?us-ascii?Q?MKb2GOA9N2rDrDhYLCUlVXnFAnY/HPSh1FzscwgDfEaFACKGytFboBvWbusq?=
 =?us-ascii?Q?RaWeRHwNonSwXxqJE516y2/7UScgtggj+/6qx0vMIpYgs1uqwk41FOG1HkwY?=
 =?us-ascii?Q?tRGp/GGB5Eo/ePIpStijNwqLwir0ZbZAcyqM/+SI3ZDtw+WoXcq2HIS3udlt?=
 =?us-ascii?Q?LN2ynC/UoBB+kaq8eCNhJvqugMrNlHnVTf5dY0q6ADQEW2t336H2NwSwV54S?=
 =?us-ascii?Q?aQCjj+S+Ammi0/DaVhUlcCfXUCtGd836mfxBiqNrfeu6oIArd70Ky1Qv0Q2J?=
 =?us-ascii?Q?phY/pl4uC9taC3ijx3dOhZpNR0kX7wQu4reUJboFWzN8Slr6sGMXJ9stE55a?=
 =?us-ascii?Q?aDwT1FoUmaIyl+8U6/R3ATh/XSnFJC0jDEHshUq79Kk9pOAQAadAdYTt53xG?=
 =?us-ascii?Q?H23KqJu8Zf5KStnynorbjX3ALuPIPDpFRKGGmxZQ5WxnMEHTjQHMEnEEf2v8?=
 =?us-ascii?Q?ojglY3roN2lO58c+1tuoHXV0xI82WLBRGmly1oug0LnEAmvDI5fT1o/tICUQ?=
 =?us-ascii?Q?CqOSwcUStu2w96N8PUDo/tfzXF/O0O82wq6V75a7h9NAXrq+fviPmdkZ5Wa4?=
 =?us-ascii?Q?eL+sr5KaYXVBeaJdyP1uXGvzDaYlHRtKwOwfTXYPWR/8DCbgJg94TexH+Gqw?=
 =?us-ascii?Q?WDPsINbRdTlQI6ClfD+hDKOetatNomBQtkSs4j1yj2nxC7kDgqtmljSbVqBq?=
 =?us-ascii?Q?6kd1mOPUk7kCqBqVdl/JF4AECxjY8Y4dImklIZ4DeHaGiY688RNvb4q2rkmr?=
 =?us-ascii?Q?kfflAISHkwOPWh7i8DTUwq0xINSjAPS6H10pb4Ad1/japM72wgYwTFaJcEdX?=
 =?us-ascii?Q?pMRnQxI/GXnQH2uZRPchKcNtuxt7clsQ0m8Br++AIUOwaLgUug9JT/pH+J2h?=
 =?us-ascii?Q?WZaWwGhwEYBFaAprOTYfJiWZLO7CdnMhXbl/4N+QtPIrdylsXGzXuwGxhXQ+?=
 =?us-ascii?Q?ET46Gd4RljJMUeAEj1O8++q5PU9IRR9ilKbzpblSCVqsfmgSrdxDc3skpPgb?=
 =?us-ascii?Q?73JnvtI1tnMkWt48oCYKiwd++55WDf8n?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZUwRq2EricJ7zD43FI1cwpIvvTf+jYJcryuDQPVLDQGFUjusFznAHiVHDZfM?=
 =?us-ascii?Q?lLGXu1ZJZcF7ttBXMOVx/0dv3UIpIVzT8XuSv0BfELNMBCkR/J21vJ6JGSaP?=
 =?us-ascii?Q?v7uJwcPRWc7TfRVU5Xhuvshe8lV2WJ4eS8ChiDukFKTPGXV91JEkuUbIXXS7?=
 =?us-ascii?Q?SrtwAcomlORkUel5cJnZ7Rd+dRg21Tl2J5gZjEygn9lrKcH8FLBfs+uKJMH7?=
 =?us-ascii?Q?WBD4NR/KJ1lYBSXmjU8x4+ZXf4RK6qGiDyY8Y7GnmphAZk6cx0wCVdgjCIpK?=
 =?us-ascii?Q?wiJWxHM6M7Zvb31D1mJPjIWiIWrLVxgb6WckxWQQ/MBKHBO3D10JQHGsqumd?=
 =?us-ascii?Q?utEwCgWHE4ds7b516vWwgO/4j7nsF/afceHrOgbn6IFgtTJ66VIhcb+LaUIL?=
 =?us-ascii?Q?UI+/uvmcjRt1JQe+6n5RkJQ+YgKM1/Nx3LndTWNBpwipaDLL9hBReXtkJwou?=
 =?us-ascii?Q?AM9ggkgxXvKFAguSlPmTXlg/+0KAU0jWl7lA5Ekzn1Bq7BdgHHQ3EU4jfDkd?=
 =?us-ascii?Q?l17q568Wsz82DLdqqjDj05W2yDJ9dJZrgfJGBLlE9OMioTR9aBTrqG9No9a0?=
 =?us-ascii?Q?e5LwkSXD2s8Er9EbgNiQg9tU2BoobuYKIFYRMZCnvQNWG0c0dvLg5GsyZTGa?=
 =?us-ascii?Q?GnPxCbBSXmQoV4391z5Rmd06eNwkspTIjrYm6zxvOOT9oiX3ZXWHq+NUIN/u?=
 =?us-ascii?Q?sgIGIvcgP/wOQpr0eq0X5HNoI+F8QbgkcM3tK2flgZqLAxmFMayS82kcU/OC?=
 =?us-ascii?Q?ELVfN08FqND4DMCx0ipBihNMI47lqfkK74YTzG77Ltqlmwoldc7FwUSMVOi0?=
 =?us-ascii?Q?IZvOiJQ5ySc9JNdYYpzOhV/96clcsgEpul/+JVF6arHuGe+X8KwR8GkWZx3o?=
 =?us-ascii?Q?mr/4eFzgexxxSL0FzZyPXUWFFYsYISEAtukGvDGt6/V9lEBQeSheTOW0rKQj?=
 =?us-ascii?Q?VnGaCsVKZusfXCluhFeYKSLynUk3ifpR3ryuQjMLu11SUG4dhUnkzANWaI2t?=
 =?us-ascii?Q?zD8+Xo+HETLY84e+s4j48GGOfZ8xP1ewjxrowZUhYFHyGEBmhMkHx5j3SE4k?=
 =?us-ascii?Q?G9d3G+sok+swQHa3B1AhyIDA/dispAegpvM1MMUTnjkgjQattIoVGzVlZTU8?=
 =?us-ascii?Q?jJ6P+89FTrtQ6OXPJpLKXieygKqMHFhgYT19Ozyk1RKIuz85jGghoWn3OKxQ?=
 =?us-ascii?Q?0LD/wE9nv0dDYTC12eQkcXQvEPP0WvBPAgfseJCUL2DkKzl8W4WlOYd+YUuk?=
 =?us-ascii?Q?jzHDoyAEZ0zkFBCQtTb4kzVBUJKKQZ+u4ov8uN8G2c/DiiG4OAgDqrN8Y6G/?=
 =?us-ascii?Q?pr4p+QZulGGkvCUpsp3YtdLQuVORIYrVnj3M1P2XidXTcjLKegwe6Rr9mm0v?=
 =?us-ascii?Q?pbuCMlq8snBciLg4hu6ROVS85mKkvJwObI75aGaeW+5HB5FNbIna1OCcUEV5?=
 =?us-ascii?Q?PRtcX9VRms603K+GBbXL3L3KZaGlmcKgzsI/egI1GqyiQLS2Tvw4mAr2jjLw?=
 =?us-ascii?Q?SNvHEY1L5nq3rr4XXhUQpVA+t+A8IxHh6+s6pBWJqTO86WcNsiciWqsjb/A4?=
 =?us-ascii?Q?7TA3HNAf37CfTtU9lnkdLmthbqjGyMnrfuHBZauq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf168d2-d98e-4847-4767-08de126128a5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:43.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIXwRO8aW+V+zKmK8Ti2b4GUQh22CVtf/TsUzVJ/glXQnPJGQ5SfAoUhhEuTAXnp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Currently a incoherent walk domain cannot be attached to a coherent
capable iommu. Kevin says HW probably doesn't exist with such a mixture,
but making the driver support it makes logical sense anyhow.

When building the PASID entry the PWSNP (Page Walk Snoop) bit tells the HW
if it should issue snoops. If the page table is cache flushed because of
PT_FEAT_DMA_INCOHERENT then it is fine to set this bit to 0 even if the HW
supports 1.

Weaken the compatible check to permit a coherent instance to accept an
incoherent table and fix the PASID table construction to set PWSNP from
PT_FEAT_DMA_INCOHERENT.

SVA always sets PWSNP.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c |  8 ++++++--
 drivers/iommu/intel/pasid.c | 31 ++++++++++++++-----------------
 drivers/iommu/intel/pasid.h |  1 +
 drivers/iommu/intel/svm.c   |  1 +
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 1b6f67aba00286..95cbb186d0bec0 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1300,6 +1300,10 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 	if (domain->force_snooping)
 		flags |= PASID_FLAG_PAGE_SNOOP;
 
+	if (!(domain->fspt.x86_64_pt.common.features &
+	      BIT(PT_FEAT_DMA_INCOHERENT)))
+		flags |= PASID_FLAG_PWSNP;
+
 	return __domain_setup_first_level(iommu, dev, pasid,
 					  domain_id_iommu(domain, iommu),
 					  pt_info.gcr3_pt, flags, old);
@@ -2989,7 +2993,7 @@ static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
 	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
 		return -EINVAL;
 
-	if (!!ecap_smpwc(iommu->ecap) !=
+	if (!ecap_smpwc(iommu->ecap) &&
 	    !(dmar_domain->fspt.x86_64_pt.common.features &
 	      BIT(PT_FEAT_DMA_INCOHERENT)))
 		return -EINVAL;
@@ -3030,7 +3034,7 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
 		return -EINVAL;
 
-	if (iommu_paging_structure_coherency(iommu) !=
+	if (!iommu_paging_structure_coherency(iommu) &&
 	    !(dmar_domain->sspt.vtdss_pt.common.features &
 	      BIT(PT_FEAT_DMA_INCOHERENT)))
 		return -EINVAL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b03da83583ac3a..3e2255057079c5 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -366,7 +366,7 @@ static void pasid_pte_config_first_level(struct intel_iommu *iommu,
 
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_page_snoop(pte, flags & PASID_FLAG_PWSNP);
 
 	/* Setup Present and PASID Granular Transfer Type: */
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
@@ -461,19 +461,22 @@ int intel_pasid_replace_first_level(struct intel_iommu *iommu,
  */
 static void pasid_pte_config_second_level(struct intel_iommu *iommu,
 					  struct pasid_entry *pte,
-					  u64 pgd_val, int agaw, u16 did,
-					  bool dirty_tracking)
+					  struct dmar_domain *domain, u16 did)
 {
+	struct pt_iommu_vtdss_hw_info pt_info;
+
 	lockdep_assert_held(&iommu->lock);
 
+	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
-	pasid_set_slptr(pte, pgd_val);
-	pasid_set_address_width(pte, agaw);
+	pasid_set_slptr(pte, pt_info.ssptptr);
+	pasid_set_address_width(pte, pt_info.aw);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
 	pasid_set_fault_enable(pte);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	if (dirty_tracking)
+	pasid_set_page_snoop(pte, !(domain->sspt.vtdss_pt.common.features &
+				    BIT(PT_FEAT_DMA_INCOHERENT)));
+	if (domain->dirty_tracking)
 		pasid_set_ssade(pte);
 
 	pasid_set_present(pte);
@@ -483,11 +486,9 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid)
 {
-	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte;
 	u16 did;
 
-	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
 
 	/*
 	 * If hardware advertises no support for second level
@@ -513,8 +514,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_pte_config_second_level(iommu, pte, pt_info.ssptptr, pt_info.aw,
-				      did, domain->dirty_tracking);
+	pasid_pte_config_second_level(iommu, pte, domain, did);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -527,12 +527,9 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 				     struct device *dev, u16 old_did,
 				     u32 pasid)
 {
-	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte, new_pte;
 	u16 did;
 
-	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
-
 	/*
 	 * If hardware advertises no support for second level
 	 * translation, return directly.
@@ -545,8 +542,7 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 
 	did = domain_id_iommu(domain, iommu);
 
-	pasid_pte_config_second_level(iommu, &new_pte, pt_info.ssptptr,
-				      pt_info.aw, did, domain->dirty_tracking);
+	pasid_pte_config_second_level(iommu, &new_pte, domain, did);
 
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
@@ -773,7 +769,8 @@ static void pasid_pte_config_nestd(struct intel_iommu *iommu,
 	pasid_set_fault_enable(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, pt_info.aw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_page_snoop(pte, !(s2_domain->sspt.vtdss_pt.common.features &
+				    BIT(PT_FEAT_DMA_INCOHERENT)));
 	if (s2_domain->dirty_tracking)
 		pasid_set_ssade(pte);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_NESTED);
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index a771a77d4239c4..b4c85242dc7962 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -24,6 +24,7 @@
 
 #define PASID_FLAG_NESTED		BIT(1)
 #define PASID_FLAG_PAGE_SNOOP		BIT(2)
+#define PASID_FLAG_PWSNP		BIT(2)
 
 /*
  * The PASID_FLAG_FL5LP flag Indicates using 5-level paging for first-
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index e147f71f91b722..71de7947971f82 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -170,6 +170,7 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
+	sflags |= PASID_FLAG_PWSNP;
 	ret = __domain_setup_first_level(iommu, dev, pasid,
 					 FLPT_DEFAULT_DID, __pa(mm->pgd),
 					 sflags, old);
-- 
2.43.0


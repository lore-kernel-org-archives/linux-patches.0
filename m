Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003AB3DAC0F;
	Fri,  7 Feb 2025 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939579; cv=fail; b=ZjyYjwRG/8vX0UW8Y/3RRo96OZ3F2esvGvRz5+pEoCz2DzBNej370eEHMrMkX/zMGZUlGGNRthPoMKKgCLZZUDnLzZgjQHNpoFP/stIZG8W1Es8wwpJ2Xg5FiU8u7zjDzZeTYcGaxLAFQFjRCDu1r1fHiq/I9zbHHxDktO14Sg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939579; c=relaxed/simple;
	bh=P3nxhsh9UZ2029Z/+D7Hs5/XH/mYA2+gPakPTo2Ro/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lOO4+NJ8SIzfn+VwwV+HmLFGDYpuQoNCBhgrcXVN0YOOpwJx/spxDNm+jyHy1zTJrNn9CkFy7h1fRbSXSdjds0qpn+woWBnsiNyQsvcLJ1S8DUDxaYe/b/+f1Vcp2POtb4Q1YuKAOOKKu0V+UNYORiMrDVaji6jnF5zpS45Grno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dpl3fz+y; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dpl3fz+y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=du61cVBlbLlaglDSrBxvJ/+oCSnhA6dpaYVPqarMcRRHSWyeTMej5ouBM5EWNJCHU/DTxIDUmzZoPIo/iCkdtYdIpMiX4+xzFYoh/Bp6JZ/wWjuV7UT9lpgE8ktrviTP5rBRzNZJ0HxsWFXpGO6ACywxLv9pHkTxV9S1u8bZU4C9EhEH2Ihx8aErOXNVSzHNMWI35+nYryP5zEeI9rJmc8TTXv5eI3MKdJGc3T9U4AevAKq8bCRSUuQZvZxbauvz+AB9PZvZ+w2+nXF4dsKysxAlRjMmt/HH5VxmaEqcHOq/X4jb6GVDb3SKMc5zPKR2r1EcOLL9glT4uSTzUX7L7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3enVzVfea/GcMgcMICGS5TOHTfF+x7hNbg17rcVPTzU=;
 b=KVo2SzTUg4TCRoIFsIomrAze7JqKXdLyd+3sj+W7EkZ2FxS3VqD3F43uqlSnXYT78uRWEXntHJPi6qtRKHStu9WPkeQ+I5ZHbfygJ4qaC9D+LIFmgEJ/ghBjCzXBYDKyl7QyHXNgSmDuCH4Pw6sVGd+9UeGy42TL8LeohzVrd03KR9/3WDcreHWGkmt39I0yJuaTFe8r0LzzO6RwyVGjA1SxKKEcF44m6bBq9xd25ShEihViZSGCnyMVNoba1AwLKG9hpNdM9tWrHmux6t6HwwWmUFP7+wOtPpf4u7zsh3NCCAtBxkG0W6MXkgE4Hww6zZR4lCmXlYIuGGDiXGe7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3enVzVfea/GcMgcMICGS5TOHTfF+x7hNbg17rcVPTzU=;
 b=Dpl3fz+yovIFc/tQIcYhhb41q1A/FIs+PO/wqX619S2pHX0FOfouyxgnnCOrDmg0PTpM7ZSeUNhIwwZGZmsHjuT4dbICnhGnOCvGZRDpng/uVNr9Avz5jnuTFQAdWEbpUrVknDw2zgdTnmMiCFzI4WtazhXsSECcqq8ZW3mpO4kswiVydzG+IEEw+ZXMVycukK3FhCLL4k+eucMpHvmNa8D1u48hrkQbQoJGISfrShOAHIyxiw8QDCOHpeR6R9EnU/2OQ7Gy9gDkf7Rrfzr3ILRw2JKSu/jrZOsOhfpYQQNOrVKroUEOEv3nzb06qGdMdBCz4ZMz9gSK14E+nfvdhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 5/5] iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU
Date: Fri,  7 Feb 2025 10:46:05 -0400
Message-ID: <5-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:52f::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab6fa99-5fb3-45bc-57b2-08dd478627c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HQgnbf1gQorxuczkD5FbXcFyS9kro35Ip7TO46x8pA++RYeeWKohPhbMIGMz?=
 =?us-ascii?Q?WoepdpwDl7O/Kp5rU+v6bpdIDoc9SusAA+7gT9/CIvRRStgx1Va3IpOl1iJu?=
 =?us-ascii?Q?GTjLrutEHRxoL0P1ZrgcGEJ3DrwmevkTbla1GyMBzPTSJXZWy1XdGc4o+i0v?=
 =?us-ascii?Q?Kdlqla1WtResEwR0jHgJxcSkFfPcmeV6NDo1sbT77bIyDWxJ4P+ee5TzRvnB?=
 =?us-ascii?Q?PeKUlYty1/Od1LXLnV0LX0EdCDwpi7FwtcN1WPuGM/VCiZYAZ06EV5Fmd8RL?=
 =?us-ascii?Q?4Ki0H72ahFVdcUxLh2Al12L8IPusu+gGdzQyMlNDJPlAE7K3HPna3thiMyfO?=
 =?us-ascii?Q?XsMUY1DDlOXuFI/+jGaoGGJOeDvOLDxfKvcf6+VnhvaqUnrywTyFKYAJCjac?=
 =?us-ascii?Q?xG6PkAY7L/MocY1Rmd3J6NQHEp5BA1gc3qBr1WPk1LP2spWQi4729L0w3RkL?=
 =?us-ascii?Q?iBHv0+1a2fGty5r0lhk2QL9jOpTcDcjBpliaISLspxpxteJhc0fdhUA2djRD?=
 =?us-ascii?Q?8CUCi7uy0fcYl7u55mjl8GUHryotr38xO8yznyMSS6GRwkGMwTxj7eelbpcg?=
 =?us-ascii?Q?8+JpJMnHmI6QwRQy/NN+0WNP9ULbjlSGYyje7w1tjRI1KLmJwAbAVAxdOcT0?=
 =?us-ascii?Q?bBd0Hux3gt4x5GiM/UVJ/nPFbUq7TmDTo7DywBmR0BHQ+NHTlZS6VI3bNrwh?=
 =?us-ascii?Q?62Uoko37H/JTkC8/li0PkUTxDR4YA7JfoQKcR6jlSdJdGvZYPn514OdHkN6/?=
 =?us-ascii?Q?dc2QkFBRebRgAN6yVKNisQOtoz/ikCWfSkD7mxC2fGhDrGAPPFx0QF1oYlDz?=
 =?us-ascii?Q?ibBjsPIMwT1wmms60TxeJPi6DOPcgr29yXTaIi4875K7F3d5pUjXBc7GoO1I?=
 =?us-ascii?Q?UZrI5J8V/XprTLlek7hXlnVQHm5VCDNFE8aMrXBdq6BFY86fW9if9TE5VMdc?=
 =?us-ascii?Q?R6oCYIR6mql6E/BfEsLU+vijjFaXFX4TKqEg2FoiRg0TkGfpRGGs/TFbR/7O?=
 =?us-ascii?Q?XYkXo8aleq2TIbjE4pJ37AqxejEG5cxrEamY2BoovWPKsPRa5kMF4Y/5snhv?=
 =?us-ascii?Q?jUOpSERvo7bs4HCa6vO8765udmviqeL0h0rq48yt1eiQxer5pqm+Mdlo3Rj9?=
 =?us-ascii?Q?nQjMLw3+HRZJ9Zv7pGIGVdQHHn7x7IhKM8l1zVwRehlhIy8a4aHVyKXaHhWY?=
 =?us-ascii?Q?jG7C6aw9thVdnafG1gxoRQhnwUbAqq0fU/MeLYaEbutfPd5vIE60atIUiI1K?=
 =?us-ascii?Q?cor/rrfXGFQma71fwdO8AvOgjtPiIjT2icaDz3kGfeJfHkOwCqGA7yrF56sO?=
 =?us-ascii?Q?5s1YUX3T0d24mEudDos9hvqieeqLIg3znLySXkb2JEvVVBbeWuGoCPY5o34G?=
 =?us-ascii?Q?5qLxkJFP87kwhEgfXV7kL1s8jdOI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hy9VMjC3uO5nfFW2Vs1nw3Iq1JsEj8GqRwnn4Y/Da1RrgiFAWFNly3vz/Po2?=
 =?us-ascii?Q?4af4xJabNR8iOu1Inp1dw01nGQd6vf2N90i4ILdDI1okRmgvS7+OT4uPy0jk?=
 =?us-ascii?Q?oqxvrSNzm8Mh5hySoEJrQzbndg2b6VZY20P7FDVaYDV1h4RvkoA1z0BRiqAb?=
 =?us-ascii?Q?cCD6j053eQdS8YIE1ZpoSuwIUuxS/VC4C4Z7L7XJ6jfG/1MLMKCZnFZl4Czv?=
 =?us-ascii?Q?AkmFtde7AGXhN5jHge6Y5RHb0gYZVpv2W8nXoEW6mRLzzLRYKg5zxuQzegjt?=
 =?us-ascii?Q?WQLGt2BZsCV2uBk1EWYeB4+9ZTG81Un7c0gDGLprpl8LuBqdCnmpoHgyrdwV?=
 =?us-ascii?Q?BsIuiE4FxVDJav7PdAxzuInQjjEcVMVzSXXmEc3VZvozkVUi3s1ihTTpDMwk?=
 =?us-ascii?Q?aXeZYb1z/X4602stPNCy9QpzNcgQt63W4HnkA8vVEZ/y6a+DcLUKpixneIDZ?=
 =?us-ascii?Q?FgRcoLtD2BQ4+xPXYEC9MHtvsmRCctxerXSEx+RlZompSk4vc2tfO6R26jYI?=
 =?us-ascii?Q?FbRLBIk/6E0tXFk1fI2vqR8jrN5eW/kf6UIuKvIN420xkGWxCOQD7gUpIvzp?=
 =?us-ascii?Q?X1gy3odkkcEFvvvd8JE4I7YwPdgruBiny5bzg69lwZFww80o2sbuKt++QngS?=
 =?us-ascii?Q?tTuasyD4fjNtezMp3YGFfxnUTMBGu5VIMLAh2pfuSzGn4l1odVyj8wZrvl1u?=
 =?us-ascii?Q?mqYBfXQNHxmky0jK6/rReGZfWyRzGZKGVVrJnnMOmB4e9yNorUoM18AQWKfe?=
 =?us-ascii?Q?gekELsYjwEU021V0JNWJ9Vhf31f3ChjSrlTYwcCyLBxlXonPUynG7icC8twP?=
 =?us-ascii?Q?wOty3X6Gy+dipG0K6O4vyKa280hp1as+wjVQs/jiUDWeVCMgo0OJEwt9F1gG?=
 =?us-ascii?Q?8jFXfZiURab+j7NVvZJ2DX1Hul83Un/FbGyMnSePqnoyPDgViyIHDi2p5oM9?=
 =?us-ascii?Q?WWFYKG6worGJOxeN+hopVqbVctF+hA596j76dYd7p8xa2+1XWhYiZBDX3DQc?=
 =?us-ascii?Q?x5eNeggvY+mG0b1X3FwzRqQ88rJqeReQrfrL5RHJ6TmkzCXUPk3qOs/5WZ4j?=
 =?us-ascii?Q?sKa8VFwB/smBHJUefhuYJ2H57qSFitllWDg+tP0o4UYwQppGj90yVYTXQjDt?=
 =?us-ascii?Q?t/zvsCb0ICiUDkeVYEwL7+rQjjxqEqD1oGmWrHyDn+RPDghzC5/avJEIStrp?=
 =?us-ascii?Q?eRfP0KaND6DADnpfCrmApr6wUa3ENBxFkhJP0gTUZOSTPPMfULT3LvRD1Tfl?=
 =?us-ascii?Q?Z6wJa1FPkeJBflwwLmSC2cvAKYsXXST/VPbvSydLtKtKXOiUC20upCMzo03L?=
 =?us-ascii?Q?lqSOBMTP9iwb8ctNWEKMvn8ICpCrVXxmv/m0ivEPzGYcQlktF2bsoa2UPXzK?=
 =?us-ascii?Q?kzyBS1tQmK2EJFAyht6Zoa+b2S7xeQnA/1F7/UD50YrDcE1alv7P4wypdBBl?=
 =?us-ascii?Q?enXbjkN899U/SuRZlTekIhydYyLNxtqihF8DrdjkeEdTyKGoW0r58+w6JFBQ?=
 =?us-ascii?Q?FuABYloA0DjlSRlYGQS3E3GzFx3QqMNLGuWzaOLy4/bAtvdKX5HbahagQLVo?=
 =?us-ascii?Q?3s3RJ2fDZ9VgGHDhaaDCpCt35nS75AEJuKDu3BG1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab6fa99-5fb3-45bc-57b2-08dd478627c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:07.6140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7C48vTu+kDKvkk9xOIET7yJJ/wm6/NpSrmBynlAUMBr4LCA7HBcbu6MRSwqmp65
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

fsl_pamu is the last user of domain_alloc(), and it is using it to create
something weird that doesn't really fit into the iommu subsystem
architecture. It is a not a paging domain since it doesn't have any
map/unmap ops. It may be some special kind of identity domain.

For now just leave it as is. Wrap it's definition in CONFIG_FSL_PAMU to
discourage any new drivers from attempting to use it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 73a05b34de4768..b81a82df9fed25 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1987,8 +1987,10 @@ __iommu_paging_domain_alloc_flags(struct device *dev, unsigned int type,
 		domain = ops->domain_alloc_paging(dev);
 	else if (ops->domain_alloc_paging_flags)
 		domain = ops->domain_alloc_paging_flags(dev, flags, NULL);
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	else if (ops->domain_alloc && !flags)
 		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+#endif
 	else
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6389d59178ba3f..55cc87bc62f5d0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -554,9 +554,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *           op is allocated in the iommu driver and freed by the caller after
  *           use. The information type is one of enum iommu_hw_info_type defined
  *           in include/uapi/linux/iommufd.h.
- * @domain_alloc: allocate and return an iommu domain if success. Otherwise
- *                NULL is returned. The domain is not fully initialized until
- *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc: Do not use in new drivers
  * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
  *                         use identity_domain instead. This should only be used
  *                         if dynamic logic is necessary.
@@ -617,7 +615,9 @@ struct iommu_ops {
 	void *(*hw_info)(struct device *dev, u32 *length, u32 *type);
 
 	/* Domain allocation and freeing by the iommu driver */
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+#endif
 	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
-- 
2.43.0


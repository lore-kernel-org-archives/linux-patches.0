Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E355719CCF9;
	Thu, 14 Nov 2024 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614139; cv=fail; b=geC/Vhdijm3BVY7TmUbg0w/3nK1drW/YLInEvM1LUG3qgNRB5oSQiPRRCkF55ZW4r7ZO+PblvoZ3knKbNC+0iJHYJwrHlO2YhbosVtn/hoA/8xOw40SOVXjaHKgSZHBhkoWrCvRLkZPGsqwzeOjy434hbThk8GWGysXWexOHnYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614139; c=relaxed/simple;
	bh=vvgjUho+vP5TaF6YAjKwp9YR+USFKfIyrcUUHLdHS18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FZ0OyBrameRTlKzN1f2I60WssPmlBLy/XjJs0dDTt/u6HxUEQKSBVFwzlLMPaFM7+nMGgrPfVrM3widyT0KhKAx7FQDzMoHtPpAyUJxCgMhg5cxp3BDYnnEcsnEXnDtMutPWB2zgaSPl3dFsJ37V+5D05gjPxCbSYZ947iNxk+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V+Uiy8Bs; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V+Uiy8Bs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ci2Hni/+BXOhBRooipAMsG1+wxiQC29KK9YT9NBcT/F6bVsJCouak2Q+4gN47hiMuZ0QszkqH65Nl12RA5iJwJ/TyoxrSEHVV1b019rUU3isCd0QS/MW7D0v5mYmgcmKQoLpAi5yMM1iF8Gk/3KSR6Mw7zLgTXTqM6rczGhVWzsSNMni7NOMah9SVJFYZxus1Wam0UF9RgmLbrvGeA6fiiBoSiVG3ql8qaw/EYJcPFd8tYnZ2H8eVY66I8BNtft91EpSCFdN+WNTsebcyDAOlxhQXZ4A/HRvs4fc2lnohK++9U86sBa9vj2QY1gKgu3UpJbTAmzf4oaMX73S9RExvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53/vONpAvsslSbP0976wx0/6dZsZC3vKS7PP3chj9pw=;
 b=alihav8oql77yifaqgWrLUTpQu6x84J9N5pTw4ic4QOjTfT43p9N9U5ZJV+RzxZa2VIzgFxWXX/wgoFD5ZxfRxUqjIawGls7aAkibrGFxvrxb1cuj2kyKV4cLqJHbrUANUwiYUSEa9wEp2q7ljbN3gKJJnKIk8bqOLupI3A6dGAiI/x9rkDeziFxe0dFsVkzxGICEf8u8ex8tvuI7Koyec98vuZ0MDIl8d3J0FrlB4DFBgGQPVKw3dvztEZFaYgIqyrD/fHJUcaJ65GoYH2aN8NXvx3b9mCCu2lHus8+hlTn5RO4P9fh51vFgGkq0yiLC1fp4sT/P45rxmkRs63xRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53/vONpAvsslSbP0976wx0/6dZsZC3vKS7PP3chj9pw=;
 b=V+Uiy8BsvX7cACn137Rz8zzT/N1yHpVFzqhHywIQ2zbJHfpJ7HrhGEpUO3J+cIlA39ahe2nsLQrHz4yU4FsV5Ilk0vYnvKzsZkxVDZZj0wLb3KCsup/18hFZV65pslE2JD8e9pfBhkP3QI3+iw5rvY0/+bFhjTQjW0Ijmuu/JheEm/Qyg+FDYOxe9e+FkXdoSIf+B6oTfjEDb5ujTFCSFPm7pnI267FzGRIv4HMitaiHYhYDkYKrp50df9esjgQK2ZYHJaFAXPZvVFcykfa0VaIq6ho185Da5tK3nsq8SQDyBdc6qWvKoAgkTJu7cYe71zKj8LgnOks/Io+vgszycQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Thu, 14 Nov
 2024 19:55:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 19:55:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 2/2] iommu: Rename ops->domain_alloc_user() to domain_alloc_paging_flags()
Date: Thu, 14 Nov 2024 15:55:31 -0400
Message-ID: <2-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0074.namprd04.prod.outlook.com
 (2603:10b6:408:ea::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ad5ef5-c70b-4e28-1918-08dd04e64c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1EDGz6lL27iRnmBANO7TbdQmObBU/bnTG+6+/SKnCyr3HqAZ52qNp6tnlrov?=
 =?us-ascii?Q?W0LlPC/fVr7usAxbnTDZy55Xn1gJ73iZWGaNY5Q9RDYwu8PsZ4hr9ZHdlRrm?=
 =?us-ascii?Q?7D8+yhPNilvgtgdyweWDJk9Vo4GFpTx19bZa0zcqbYFU2TiiaspoODKjasb1?=
 =?us-ascii?Q?SSBNu8WAL1kPCgy9rLZbluhIum67jvvBORTGVrJGl+JCJ9ebNWyo1SAlkUAB?=
 =?us-ascii?Q?1O0j1pAVBQecIdKx1bp3EMuTVRhWNfPVro+CPvLWH2FssidlnF1uHeGr7lpx?=
 =?us-ascii?Q?2c94cutlTKUFBLIkGVE67flfxxHhf1/lhqkP2ic7/BBN6QVPJ+pnbQgBh9yA?=
 =?us-ascii?Q?cV2sLD21oUM3suM8lB7ef9gMpiWLVWolFy6TsCBOorbYInqo9kQDvp38peN1?=
 =?us-ascii?Q?nN31X/dOz2sV5ISU5awSQIQko+jHRBOFyZkCz3zG9r/HmR+8r409zET2J9Fu?=
 =?us-ascii?Q?XmHsPnE3AawzHt/UGTq9xcuv/MLRpRkXDBjN344EMiVuMJNmD3pts3LDAl/H?=
 =?us-ascii?Q?bembpvXj7CFIUQhNcF6tg5I3hRaFSB0q65OpQItGJFTmoxVi6Jueg7IrdVjT?=
 =?us-ascii?Q?IEN042I6d1m8l22nIGuFZp8Sim2uuax9WjnwW9hBAddliLvAgC8NXAGumGQj?=
 =?us-ascii?Q?h9di3wnpLGXIXJL1jjP86cvRWdUrTJDk44U0ZFaJRdzW0ODpA2/O1dpZdaia?=
 =?us-ascii?Q?lWCTKde97Rut5dUCMQUJAOGBCjuyslIaESy5j0gK7M7RvDJB3kyOtSkVblQ2?=
 =?us-ascii?Q?4hGHWvejTBrXy2/vA1IPb7qZ8KxAQI16l6Sld1GqTItkKzERa0YNkg90MpvU?=
 =?us-ascii?Q?Rw5QA7PVowQHl9F5TtsxeEFSqJkp/OGps88eo/GF2cNNZyKZD49kMUDMQJnV?=
 =?us-ascii?Q?cm3gqIZGS8N10yBPqvx66lQF9IHKFnw/oAMp+uReN9wp8h4k053jD53tZ4Kf?=
 =?us-ascii?Q?6TO3JZu8+23/buygXZs/lvzdXs21ZuSqLwHVATDSznqSTQKAcBHFkr4mrTuS?=
 =?us-ascii?Q?jwKtu3PGvkxYPCA/MaPeMKTqUdvmHMohxvoafQN6e2Zqm47jsgOm5n6Vx4rq?=
 =?us-ascii?Q?zTdfhDawKsemi1Y5/9uwq/4Yz0t1u9GfEdOiLfSwbwcpH7Nn9ksofQw9ExOF?=
 =?us-ascii?Q?8W8SOufIM5l75gOjHfFN2nCjz9NK0f/MBjb4BKJQyPkWE00G73L15MrPCGqc?=
 =?us-ascii?Q?J/LR5FCPoy9QWQqFiaBkKGtOb+TmUjuXL3DqqJf/2fuf0KjbgfP2fHpK2arj?=
 =?us-ascii?Q?FfhnDOP3vAygTXe/AN6TQX6MXn+zMhBM6nVeN5D47PFm2U/A9WACYzAs/28s?=
 =?us-ascii?Q?iG49OAv7ajSVNJS+I+1EEtgF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jx/Gk5wMPtk2raYOJgrIB+nVNu1ebl05j8x0JgOUgWwcarrqEI+3bCvX7jl7?=
 =?us-ascii?Q?udCBwtV71FUKvM6ddio9VU7rwAK6eCXkw5OJUQ26ONo3MK7AKaT8T74YPiEW?=
 =?us-ascii?Q?DzEKhgei0m498rRHKJj5kh+f6ejHA8OHZkA1WXPVYsGjuOLxusDKjE6+q49K?=
 =?us-ascii?Q?SLvy93LqeSSC9AmhhYsxJfK8PCmjfm+6as0e1+Fg7fYr2eOBcbEd9GO5fpdT?=
 =?us-ascii?Q?ON59QuQd8Rzg0JLxZgQYtWVWK8zwyopdQVO3EdoQdJC71EXoeM9BWQzw4cE/?=
 =?us-ascii?Q?eLTePH39HhxB804BpbYgoGVOldgHSjQEEck3ORD+7ys6dRD9TJSbKUyngyUc?=
 =?us-ascii?Q?84dNFPCCcrYpWW38KMOfQgSuvbzP8eZfyAEWNVyKsaoeJjPufYM+Byc01X/u?=
 =?us-ascii?Q?sfgtAbWKRXjCjoy5C8TmVsMOOQWtOMRfxddsT2HRlyjr78pFdTpQ0QRF5CpP?=
 =?us-ascii?Q?I2qBDg0H0lJ9qGJ5x1tc0OYcZtOs179wPDArc/QxM5sBEF2NLBQnnDM1Gv3S?=
 =?us-ascii?Q?IL/rtfHeJ6doAkpV6t8XmmrwdcAqMM/WOEOnfqKlM89Fi2l5fWVduTse01yx?=
 =?us-ascii?Q?mnksnZ6vvLQ/4qkNS/cgmFAqAYTUob2dIvDLWOVlmUMP15EH2dKJ89QCsL5k?=
 =?us-ascii?Q?vBDnUJT0bh32cDMIxhAfawdaMd18Clb6nyIKDXI22WowS8aOzT2bkZHXcJhh?=
 =?us-ascii?Q?6L33k132YifNdoyI/5iK+okV7J7nrSrthR/+HNO6U91uZvG4XO6nFqCqq4dP?=
 =?us-ascii?Q?5B/KJeupleKRtX6c7zwp4wOeCoHOssqXl2yhW8lXcGQrOCJPA/joOiCifTui?=
 =?us-ascii?Q?SwD17wuBW+alT04lUcJYpJYUjuegF7xpWd/aVsF2iyuR8GBjl7KWMnIs+yrL?=
 =?us-ascii?Q?DM1EAM2hlzZPvTvRI7ZcsDOBvuoZN3mYA0hrJ7fo+jwzRihgJP6VA5bYvU+J?=
 =?us-ascii?Q?Esj0zocWw9XpWi9Xvsvbg8JDk9iN+HUaeIZH/fJ7i7gTbLMf/yffsvAoBgMt?=
 =?us-ascii?Q?Fn3UHvZBL1MCAz1+HMdTXyRva8/mOqe1aACX3MSK8/Z7Ynkp0z8XknxHzMz1?=
 =?us-ascii?Q?9h5YrDk1vfC465KXGM7i3aVtxJg5RvDGxqxjBCP4k3DMBS68pRL6GOaWysrh?=
 =?us-ascii?Q?R/P5d1JBOgAnsdpRrCUpIMFgGrJ8w5cvKEwjsiyk/P6SFVOPWVaz9ew5YNlQ?=
 =?us-ascii?Q?jR972HRhpa4i6NjhayrQ21menY216dE0z/V7ZmOpIpfw5/Pl5xBwXgtjGbt2?=
 =?us-ascii?Q?l2J6nXb+H2ruyQe+4anVdO07uaVdc5UVuEoC7NjjMeeQh7nnvJLPrlRdRbsA?=
 =?us-ascii?Q?2N60oQmEtmLnjt3K9YI32kg7Ri9/6EtZs2SmuF0CGrdJlE1+MP8CtHYplMzq?=
 =?us-ascii?Q?CayXKC2GCxKUHdMivdV+39pdOkVq/QqdLmiTK8rKqhHP3Vsyjmue6Sqfq15+?=
 =?us-ascii?Q?Ebw4vtKII1kQb19Oh9PFNveDByO463xTmUYzmS/jDS6QbFf18G03OHB/hiH4?=
 =?us-ascii?Q?9nPPkl5v2FArgl6m3wmW8ZLY8YqamDgvzs9J9P8SW/2PKFXqKhHi30fM/ZMd?=
 =?us-ascii?Q?YpPZphpgqHc0Y96lyO8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ad5ef5-c70b-4e28-1918-08dd04e64c0d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 19:55:32.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sk5kMA5fzJtV/OecIdLRyddR1Hw3JaurzxFuTmEtZwG1BqxyxAFLu52FAUJIcqVb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563

Now that the main domain allocating path is calling this function it
doesn't make sense to leave it named _user. Change the name to
alloc_paging_flags() to mirror the new iommu_paging_domain_alloc_flags()
function.

A driver should implement only one of ops->domain_alloc_paging() or
ops->domain_alloc_paging_user(). The former is a simpler interface with
less boiler plate that the majority of drivers use. The latter is for
drivers with a greater feature set (PASID, multiple page table support,
advanced iommufd support, nesting, etc). Additional patches will be needed
to achieve this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  9 ++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  9 ++++-----
 drivers/iommu/intel/iommu.c                 | 10 +++-------
 drivers/iommu/iommu.c                       |  4 ++--
 drivers/iommu/iommufd/hw_pagetable.c        |  8 ++++----
 drivers/iommu/iommufd/selftest.c            | 10 +++-------
 include/linux/iommu.h                       | 20 ++++++++++++--------
 7 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5ce8e6504ba7ee..3f691e1fd22ce4 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2407,9 +2407,8 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
 }
 
 static struct iommu_domain *
-amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
-			    struct iommu_domain *parent,
-			    const struct iommu_user_data *user_data)
+amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
+				    const struct iommu_user_data *user_data)
 
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
@@ -2420,7 +2419,7 @@ amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	if (dev)
 		iommu = get_amd_iommu_from_dev(dev);
 
-	if ((flags & ~supported_flags) || parent || user_data)
+	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/* Allocate domain with v2 page table if IOMMU supports PASID. */
@@ -2884,7 +2883,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.release_domain = &release_domain,
 	.identity_domain = &identity_domain.domain,
 	.domain_alloc = amd_iommu_domain_alloc,
-	.domain_alloc_user = amd_iommu_domain_alloc_user,
+	.domain_alloc_paging_flags = amd_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva = amd_iommu_domain_alloc_sva,
 	.probe_device = amd_iommu_probe_device,
 	.release_device = amd_iommu_release_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 04630dbfedd92a..e4ebd9e12ad468 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3132,9 +3132,8 @@ static struct iommu_domain arm_smmu_blocked_domain = {
 };
 
 static struct iommu_domain *
-arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
-			   struct iommu_domain *parent,
-			   const struct iommu_user_data *user_data)
+arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
+				   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
@@ -3145,7 +3144,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (flags & IOMMU_HWPT_ALLOC_PASID)
@@ -3546,7 +3545,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
-	.domain_alloc_user	= arm_smmu_domain_alloc_user,
+	.domain_alloc_paging_flags = arm_smmu_domain_alloc_paging_flags,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6f11a075114f7a..7d0acb74d5a543 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3328,9 +3328,8 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 }
 
 static struct iommu_domain *
-intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
-			      struct iommu_domain *parent,
-			      const struct iommu_user_data *user_data)
+intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
+				      const struct iommu_user_data *user_data)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
@@ -3340,9 +3339,6 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	struct iommu_domain *domain;
 	bool first_stage;
 
-	if (parent)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (flags &
 	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING
 	       | IOMMU_HWPT_FAULT_ID_VALID)))
@@ -4468,7 +4464,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.identity_domain	= &identity_domain,
 	.capable		= intel_iommu_capable,
 	.hw_info		= intel_iommu_hw_info,
-	.domain_alloc_user	= intel_iommu_domain_alloc_user,
+	.domain_alloc_paging_flags = intel_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva	= intel_svm_domain_alloc,
 	.domain_alloc_paging	= intel_iommu_domain_alloc_paging,
 	.domain_alloc_nested	= intel_iommu_domain_alloc_nested,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7618e9c65d3fa8..9bc0c74cca3c7e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1987,8 +1987,8 @@ __iommu_paging_domain_alloc_flags(struct device *dev, unsigned int type,
 
 	if (ops->domain_alloc_paging && !flags)
 		domain = ops->domain_alloc_paging(dev);
-	else if (ops->domain_alloc_user)
-		domain = ops->domain_alloc_user(dev, flags, NULL, NULL);
+	else if (ops->domain_alloc_paging_flags)
+		domain = ops->domain_alloc_paging_flags(dev, flags, NULL);
 	else if (ops->domain_alloc && !flags)
 		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
 	else
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index ec3c64a8c79633..ce03c380465154 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -119,7 +119,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 
 	lockdep_assert_held(&ioas->mutex);
 
-	if ((flags || user_data) && !ops->domain_alloc_user)
+	if ((flags || user_data) && !ops->domain_alloc_paging_flags)
 		return ERR_PTR(-EOPNOTSUPP);
 	if (flags & ~valid_flags)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -139,9 +139,9 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	hwpt_paging->ioas = ioas;
 	hwpt_paging->nest_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
-	if (ops->domain_alloc_user) {
-		hwpt->domain = ops->domain_alloc_user(idev->dev, flags, NULL,
-						      user_data);
+	if (ops->domain_alloc_paging_flags) {
+		hwpt->domain = ops->domain_alloc_paging_flags(idev->dev, flags,
+							      user_data);
 		if (IS_ERR(hwpt->domain)) {
 			rc = PTR_ERR(hwpt->domain);
 			hwpt->domain = NULL;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index c58083c3660aee..a0de6d6d4e689c 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -379,9 +379,8 @@ mock_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
 }
 
 static struct iommu_domain *
-mock_domain_alloc_user(struct device *dev, u32 flags,
-		       struct iommu_domain *parent,
-		       const struct iommu_user_data *user_data)
+mock_domain_alloc_paging_flags(struct device *dev, u32 flags,
+			       const struct iommu_user_data *user_data)
 {
 	bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
@@ -390,9 +389,6 @@ mock_domain_alloc_user(struct device *dev, u32 flags,
 			    MOCK_FLAGS_DEVICE_NO_DIRTY;
 	struct iommu_domain *domain;
 
-	if (parent)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 	if ((flags & ~PAGING_FLAGS) || (has_dirty_flag && no_dirty_ops))
@@ -718,7 +714,7 @@ static const struct iommu_ops mock_ops = {
 	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
 	.hw_info = mock_domain_hw_info,
 	.domain_alloc_paging = mock_domain_alloc_paging,
-	.domain_alloc_user = mock_domain_alloc_user,
+	.domain_alloc_paging_flags = mock_domain_alloc_paging_flags,
 	.domain_alloc_nested = mock_domain_alloc_nested,
 	.capable = mock_domain_capable,
 	.device_group = generic_device_group,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0472cc1245192d..1e3308e899969d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -557,13 +557,17 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  * @domain_alloc: allocate and return an iommu domain if success. Otherwise
  *                NULL is returned. The domain is not fully initialized until
  *                the caller iommu_domain_alloc() returns.
- * @domain_alloc_user: Allocate an iommu domain corresponding to the input
- *                     parameters as defined in include/uapi/linux/iommufd.h.
- *                     The @user_data can be optionally provided, the
- *                     new domain must support __IOMMU_DOMAIN_PAGING.
- *                     Upon failure, ERR_PTR must be returned.
+ * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
+ *                     input parameters as defined in
+ *                     include/uapi/linux/iommufd.h. The @user_data can be
+ *                     optionally provided, the new domain must support
+ *                     __IOMMU_DOMAIN_PAGING. Upon failure, ERR_PTR must be
+ *                     returned.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
- *                       UNMANAGED, DMA, and DMA_FQ domain types.
+ *                       UNMANAGED, DMA, and DMA_FQ domain types. This is the
+ *                       same as invoking domain_alloc_paging_flags() with
+ *                       @flags=0, @user_data=NULL. A driver should implement
+ *                       only one of the two ops.
  * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
  * @domain_alloc_nested: Allocate an iommu_domain for nested translation.
  * @probe_device: Add device to iommu driver handling
@@ -614,8 +618,8 @@ struct iommu_ops {
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
-	struct iommu_domain *(*domain_alloc_user)(
-		struct device *dev, u32 flags, struct iommu_domain *parent,
+	struct iommu_domain *(*domain_alloc_paging_flags)(
+		struct device *dev, u32 flags,
 		const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
-- 
2.43.0


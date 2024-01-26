Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37AF20327;
	Fri, 26 Jan 2024 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292940; cv=fail; b=rU7uRijUCkwCgQJdZRgnr5xhiUQUVehGSYaCGDPJBLJgHbwbH52nen7aY4hqP5Ep4iM06xziAT5PBY+nRPx4Bx/vjB+jrycLYfkhQKAF9c7cXxWolvf84XeQf+J9Uru3Ae7+Q4rhd8JElrlWbHKTykV+WRx6OcjgaZoeLhUWW/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292940; c=relaxed/simple;
	bh=sKoBseIxxbVbef23AgLc68oj5KgSP4fHNpzdJOEYM0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q+nUZ15Gp6Chl+MjVc6qytINEmvz3X3OK30OA4DakV4WiYjHUNwUITgd4m9LooRYP/C/eVRNobnyMOpgA7rOGOZz7ZkmHccWlyknXoitMagGbPI6pQXyziA2N1Ln76DAuXDyygwLAhsHznoymaco0JyMcpmzeFjaGoEczie3UbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l/41OOUQ; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l/41OOUQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koScWp7Si3684QH01G7oao7DYiQ1QQaExhWiCZBbT/+MY6FJh/mO8JvrKlxgA966smaDC83oXSbAWuzJmicsoi+Uk5UNZeOfBGgR9H7kHQEYb/8gPnVd+KRxJZtBgMkRYhzo9H21WwsO3SQtnsE/54Vyom4nEJU/hBHyI1MzjobddH6frSMn6pzihcSEATxfygFxEEvF6XAL6H6W2XJwR8bd+mv6DhAhqu2WBERmH+aVgQgg/5tYCxjligC4rn2ZocNyoDJhr8YUZs2Aj+g2soArLTye1UWK8QqaUDa0RdfXJIP7JDzf78eaxc+TBaSUVP/XvEh3lZ2ITCvuGokCXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QmwQZ4cuOWhCzdZDns8VH3h4yjbgfnMJjHw/Bn9WvI=;
 b=BhS7aZuht4C0olQvArCghXRqNKv3eD9T2rMwPG0VFWsyluLQu7MVEGPj7UMivkGBeOdLVowK2y5q2FyJ5LEwYbu3iXC2tGbFWa1YdCrG7NkLxfYe+hCeuclku1C8TGarwMEFjMMmPMq4LjThsFdoLOeBkT5q8kNyvtcq9QOhBiS8crjxyHY+rC6218oX82pmsCVpaXrW96MAXCJ8qetNRefviK3H+0rij3t+bwxSGs+VUsZX1xvuMGgZvw1y/LR3dxXT4lE2EBqz55jLoG6o3jDQHj8Iw3TWwzsiklOD26rEpzdEwcvAqm/sf0E7tDfwfb3kiYdJ+zb4Uto3hN/Dtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QmwQZ4cuOWhCzdZDns8VH3h4yjbgfnMJjHw/Bn9WvI=;
 b=l/41OOUQDsFZOFL1wA6cT/7Icbcn3yQovov5yEt0qiHOg1+eehMhVrtdoXC9jmcRVk7iljYvDis2pBkEwNo6YoQrp2M6ueF3LmTRQJHbnPkfRD1NDI8tTVTkHyBR5bfGwZvhKec77li1MaZ8CV6qK2NlQSifFQMV3xekyOBKFBkGd+vLgCbYnUD6m0aWPsDccOP59/Xqcc5lKqy2JxMKk3os5TiBIHw3GBsSuEHhiPZPzcARyQeaqFfWj587J+kK85PcJAT/EzfmdWMw+9mbkW/3qjFZuICt5yNtW0ydjSZyfNSf/WnAvbnxE5RTma3TMbIVnwABNx0X/9HlxLDfDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:32 +0000
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
Subject: [PATCH v4 03/27] iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
Date: Fri, 26 Jan 2024 14:15:05 -0400
Message-ID: <3-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0101.namprd05.prod.outlook.com
 (2603:10b6:803:42::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 491eda78-db73-4e93-61df-08dc1e9ac832
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	htPiFTztq4V3xaPEw8dym4GleqdYKF2svE2/s2NG9X63cJCQ6Akgpe11/QMyEsryDNZDxIBK0yTWXmkpKxg0Aeqz8DbBv0Hhpzd+oNlveGeWpdC7whWWUIqQXjflZNQ+AsPfuk38QXMbJ52xd3yt5oYOFIXrG879DashC8Dc9mzTZioPKZ8kmgdAhPuno67PztopDRrnIaSRNC+oDzk6PGBwgXXTML0L2019vO16rKQBvCtJyVTuk5gXzwTFiIa/wt0edV5erpcKFH2kt0JzQmT6zkf+qD61n2DbByEVeh4PLdE1dlwQTMU3n1OjvG3aDr2ZNQJYTuPU+eED65GAjKJ5ocTrr5LSHfmOdiAg53DLi62+M5UmNiXhUzgH8kTvQ79RP3Cy4+4YaNFZzLzBERWmi/9fvEu9IBJzXEqfksrmLUVz3tQqOsQygLkAeLmzjmdm07huLIFmmOZOzmCJ6wToAyMAXOb0sEcMPSfDnKeZldNew4b59QiTZ9AZjAjwUwPzpYYuFULEEyc0HbCgAc2pvMNCexT19hNpQ+SzdrOyv7sAaN9NuV/gJx/+kLkaO+dw/6DjKhhVtbkztUFD3HKPpZf9uYbDMzKW52NGjxA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VUU0NodfsEYZy2+i+A7vInt9aE82Ki5p5KjbgND/ftpFOLEqxtgXllNrSsCU?=
 =?us-ascii?Q?+IJkdO+DCBr7R9ieToGnd57+IEHp8klsf6TmdJkielmaq1czJ76jwkWKzoYS?=
 =?us-ascii?Q?TU45OaZXSIJ35D8sKfyaB7XilF+DNeuIUMqd3aHOmiZsLxsz/ZVNJVNVSS7s?=
 =?us-ascii?Q?+0iJl/Gf4AqUldC/L5hJu5vuYVkcgVkG8uvlBVidndgCox/j31LW8LyUQr8I?=
 =?us-ascii?Q?a77W3oyqN9v9EyoU0tvTTZvzppKB3jXCijxoGoMSTNQSdQQT+IOG6UsSLyBj?=
 =?us-ascii?Q?XsErCphL63ajefi15Jb2ZuAREFy6hSDv7etM1KbKQMZErHXlHpsQOW/Dyskx?=
 =?us-ascii?Q?iVNt/VZ1P/eAixKCrhqA1Q7Mub8lROEKU8mOq1MLxBd85SrMwMLe9KbKjupO?=
 =?us-ascii?Q?CWqYGQ6N8pIutl0daq37W7qx5KThi3datax9Gw+oVB6QiY3vTkPextgXmCKC?=
 =?us-ascii?Q?og++OkHWC7bMzqLeK3jGpDIZWBdC1gjyie8wga92fPALGa755dO0mNB5kTl4?=
 =?us-ascii?Q?PWxorC3DqHvUCKX/cTiKyZyh8F4NX4nEOvj0p5A1Lx4qGwBOAFAmymQ/oPAb?=
 =?us-ascii?Q?pb2ZWOf36SSAD3pul/QLgn8X4+gJGPz8i4fh3lQiI7TVOQQYJf+ElmoqZyGN?=
 =?us-ascii?Q?3hIkXNgXxISIYHGs4hBi37WGkDRPKiBWAuTLZVgaZt4tRpuhhnAFsfCPWg+h?=
 =?us-ascii?Q?U1xYCPy6QW3Z0atgutI+rCKxhnuk1fRjuJ8zIUpULOA8D4FD/lyzTYP0d/Pp?=
 =?us-ascii?Q?h+qZfnd72YKe3ICzld8QD42HO5ZUOeJKRODffrVZ3Lp8RnjvRHfUciIOvV/q?=
 =?us-ascii?Q?zMoXSAnFeLp6d1tzXA+P6FeFOhfTrXXyNysZlec2UKzBk36UeVeQ1k7d6HWn?=
 =?us-ascii?Q?YDJR5rSs9DrH8mqUuWq7OEK1+gj4ss9lfZjWp4GiXaaCV6V8V7ZoKVWGmUkS?=
 =?us-ascii?Q?Klt+Sh8jZpswz1Dpr4zaieS/QxGwRHKaBrN20zPsqzoz4XRH+Ux3R+S3xmLJ?=
 =?us-ascii?Q?A+XJkAxbyo4TjGGks6wA9e7VJ4ezq486sCg6zoVEfIAxxdwbFZiJGsyuwA3p?=
 =?us-ascii?Q?eT210vRclHkErA5ca5Jpiee0RW0SHE+tHxQQ5pIMN0N4AgDqLqcCcvOjmwf9?=
 =?us-ascii?Q?Z6NCQqt7Ovc500HGwTqmFilIZIzgRZJze4Tx/lkddVey8C4/9njSIK/Ei3jd?=
 =?us-ascii?Q?3iXOcXfJh/Tc8YibO8ibAZvHQe58QcyBdEGPPECIKV3ar0jbha4qQppZoau8?=
 =?us-ascii?Q?LpaEl+A613FSUOAK7G9rmz3Y4rR9lwuDIPXeNBCIALWy4mhrpLsR+yPOc09J?=
 =?us-ascii?Q?8aZRUd/Af29yZH/q2Euqy3ECGs+wD0Lh2jswJ+5ZAaoy10p9uhWLgyLmp9wt?=
 =?us-ascii?Q?Gz62wV9G9pAi0TFF8N0LwgZVY22iHx4LsLvjdqbVJFwsfwZb2F9nXBAkJUL5?=
 =?us-ascii?Q?pkfyx5V/N+lV3Xbx0tm4ryqyMnGsenwkLhzGAqUMiXltRcy9Zo/OPHrITaDC?=
 =?us-ascii?Q?4+AxMCAB35VHF86c0IM2rI5T+Wiki1dCjL6fSa3p0Vg1sTIakbFneJz7Ykw7?=
 =?us-ascii?Q?OU4EcsRMJBN7h487QdAtEdIT/tG1lu3WXJKdZIYO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491eda78-db73-4e93-61df-08dc1e9ac832
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3y2PLV2VL2dhWGo6X3jpi5Q8As0j6yBpjm31IHIhG87IrZmuRrxUweFIhTPK9N3k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

At this point we know which master we are going to change the PCI config
on, this is the only device we need to invalidate. Switch
arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f890abe95e57f7..710016ec41af13 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2471,7 +2471,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 	pdev = to_pci_dev(master->dev);
 
 	atomic_inc(&smmu_domain->nr_ats_masters);
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	/*
+	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
+	 */
+	arm_smmu_atc_inv_master(master);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
-- 
2.43.0


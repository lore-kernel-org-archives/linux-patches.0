Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DF020327;
	Fri, 26 Jan 2024 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292942; cv=fail; b=JmtYCe30+edwcqedvcDDatDOD3q2492vLHoRRac0ye14fNJdAMC/+y5jd4LqG4/G0n8yIV605yLx9c7muchr/yp97ULhZkMxOqcjyrHlwSUHxjr17bstF2SWLIanV2n6nqj9HcHy2VxFtbe1a8PwSqLFHgtpTKoEo+bOsyDIu+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292942; c=relaxed/simple;
	bh=khpS7neHlutTRG4B0u6wCGEs98dg9QC5sWUttvAn4wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ToXn5tOOvi+ZfclqnxBCLnBK2IpR/38mIPs2g87kFLzgVuZeb4RJptNvDEgT9opiPaH3fTrpdW6nkLw14I0KrhJ2xcwcPiYJ6pBOar6BN3N5wHkZ7bekJ/F4o+UH9q1XsJJf4QCnXeEif2JHTrPjUkoNZk/aQkgZmG/vnJFvDVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bO3m1Zt3; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bO3m1Zt3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR3gHSj1U0I12n3XB2bOCEfGvLuLE42AlVRxe4jOr5+ABRh6aMlox8SkQKPWKsEZpcTPN9BCv6JU7ZZTVtiKDzPw/SPK3QPimrE5gnIrRR/IOlBJk4c7l/hIUdEG0pWPMNzpIsaKzPKApbRov9X7XnVrpAxYYwv9Wo4bSKuS35mK4iSVwLg6Iu5SmeCd/Vo+m7vHyMFZVZOpiOBXAEpHzEIN0Xn6MnxdxVJGgB+Kps4WAQSB7Qu/G/nRMc4Z21Y4Y53YDMwmiYfSNpFrAHJaWXaenfKatmylwWv6NSbE7DOoE0VK5ROWOOlmgjLe0UMZKFTbrcVldHjUI3qOQvsqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N971Jefw225IV23nvD2d5FRzMDc+zPfI8NVYuP8XODg=;
 b=BMmz+HqSpwzSePrMuSZbEsOUiW7OVRkS32GMJ542tQ9o6zo3U50NNgE9L5AKrQdYQ/ZtQklCux4yn9MuNpTMzGGjRqP0K3rxbJTTc0Ik7U+rMvUXVZCXVP0NLVMHZSgYbIX1BVAzkCZnXO6PK7P41S6nrzDexGLmHdeOoQckSLxntbk3GOj8F7RSRmhpbPwmEV0KGlLrZcBynYBty1vM7MAvX2Hgq7zjBrxTY+Ng7qvUN2K+fuMlBEzC8bXUwsMA10SG/psBvmS5FT51TVyqgO5e7pgRW2GxIjB/JvchVdZiNsqmgAecN94wqPh5KoBN0pZHvrBBlykkHtUMPLfAhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N971Jefw225IV23nvD2d5FRzMDc+zPfI8NVYuP8XODg=;
 b=bO3m1Zt3LnfCpir7dH6ssb2lKUaMPmc6PN6BRd05tvx4h9V/rjQcA6XsmOCU07uG9GjVgT/2LdDPuxkWpXaSbPZEGyzKCBxlBlu6IUjRg4Hq9b5ORMa1nW6QDqbw9HIHUgHuaOhqbhP3KbneLylzfiUy7/hHFgCvbj0h40UVAuR53WMK6qN19JP1/ASKZ+b0/wh+MRM9o3dYBHcfhgTudncClwXodv35B+vrKzJrP5w+GIfu31K3daWLY1zClfoKiA/jX00x3+nvKeTTVnsq9pPsptqxmEbhstCM7KcN8j9w90u+pTR7AKYmt1QMVlZwuN+e9e6Xam7Q6dHSSqkuBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:33 +0000
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
Subject: [PATCH v4 02/27] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
Date: Fri, 26 Jan 2024 14:15:04 -0400
Message-ID: <2-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:805:ca::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 086d4662-fbe9-4907-ae03-08dc1e9ac83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cfj9qhPQGDwx4vO/AkIe6mnoXBQYIm+lFx7I7cZfvYnVYB0Hat2odtOUwwjtUbXWUCpCGjzE05ZyeVZjS7w2zE7iO6YQHzLKthgsTyEcK27XSM3uckCaNKnJ5bcMgxCPTqPZuoXMQu55PvanNPWr7zwZERlWR159gGZKHttJlT+7syJigRYdF8dxScQmU1G6sU0GapZPd8Z8kQZAwMgDGDnpL1R0rZLfuz3BL75koq0WRRUwWfum5pjO0D0E+jgmfaK4Qsd1kmpvLDLd0UDHLuFrOVEpIkZ3fP6DC/LmY7DFHW/oZGj4zsl/mGnUL4tHrHP+Bvg5gqg7aNhihFTOYsBtlk9xgzSUEWw+VnHX35A6TwTEjqHMkWTVm3PqI0ha+RtM5WNeqhi74LA/R4iNKRRDD24EEll7Y9JcV22z+axluuYmKDc9/JPz1V+6zivPvwvVGfQazvduE1kDyD8x943RxwZyNMsqVUa47nda5DHEO/0ZgX7hmyAj2h0WRVSgwtnrMM2HJ41UZW5E8Qmf9ouJytCiEx2eJCtHFop0UUFx/pfWi1rTXUCJkGoeDMDxzmQXhtuTgt3Tw7Os0I+589DZwksbHjbxxOYIpiUN51E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(4744005)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FY6rVjUZd/50hBd0ndvgFQOGvHQtWw5TaK16B9SBJevcMb53p2JjJlaLlF+T?=
 =?us-ascii?Q?TyJMZB/Y6GsHSXPbq7fK1O2VMP/Cfybj8Gbd7xkLLCNq+AArD0Zo2HpW5+Xd?=
 =?us-ascii?Q?JZh8oqsi6F76l+ljUrVwra95HsafvqFCJilq9SScLv/LqDyLfewhlNUUkf7H?=
 =?us-ascii?Q?d5DSS7FwGe4zrVOKVeL1OzaHay3hO9qGvWvCK6SH8SaKchcRUw6X6LDYkBbV?=
 =?us-ascii?Q?9atjw6bKK4sidY86gqrbMonhsTI7UE2okfPHUkxHz/QEWfF6CnQLoNNDJMKw?=
 =?us-ascii?Q?dKJcYdnJZnkWdp67CnPpvPt584Sm83yQVoSb00V/craxR1uEuLcPVRiEZLEf?=
 =?us-ascii?Q?FjLL3BB3FZ8v4980lYyV7mG4Yzso33RMzII1rDBzzLcLUGErBUaGbmQEccBW?=
 =?us-ascii?Q?rLLbAZtahH9SBGucVBWd6rs082+E/y2Zwi4J8uB2fAo8u8bj1fAHDnUcoBYf?=
 =?us-ascii?Q?mbk97oAvy2Uyl2mf7M5B7lfMAiX4mefNPOzyT6LbaPlsxGDiCJaYD8K0hEJ1?=
 =?us-ascii?Q?9CW+PHw3Y3DpOqxxv85dlfQxZpo2INANJt/6iJBNs655NR7cX73ZQPjrPUl0?=
 =?us-ascii?Q?Bzp5iN6meGgrlt1WBOjtngIyGqCJ5KqozvRVXWxMLCx/mKoKCixolcqedpDG?=
 =?us-ascii?Q?sgs8BMGr3ucnXeg+aHz7jCVNvP8qVFB3n6tZgGPxGGtvX6+5/GNdUgs6UUov?=
 =?us-ascii?Q?SFdnU+OkUs/778lrgIaebUy6gVucxITfClUoX5z+pvQeb1vNOw3eN7fkWUlh?=
 =?us-ascii?Q?lX/b4X48zoJFSQTl8t3LYUMCAH65qX3LUbFwSL5aBi7+DOB32Y8ArquNe/q+?=
 =?us-ascii?Q?MrSNTZOcCCF0EWZj/NsSuHFB7V9RU+i0IXg5TNLGfahz0jstcpRICFDN1nu3?=
 =?us-ascii?Q?0z/ksleyTH07HDdaLUnYw6vd7JWIs7DAUXXM+QF6JmpzmTRpm/PjWaLAYCNm?=
 =?us-ascii?Q?94E4lTaqGQkoTJ6iVKsYHhj1oyUwDKP4mdezuU7AlOOk30ES+pxU6Av7Yq1f?=
 =?us-ascii?Q?zY5G1dbkmaR4FZ+jhoHUEL6kuub0gOPImOnnlQ3LUj89GdHKGWXGqIGjqS+J?=
 =?us-ascii?Q?fLgYj1GGULprJD+GovWhdlVaCJXleBAhcA8Mumlvuffu6Ak8SYgpeSzSWOWb?=
 =?us-ascii?Q?Mlxp4VnkShYW7QS9o0kYoZt5SQ9iGCATYOTyMedH34xe5jNKBQKkUAlqmZoj?=
 =?us-ascii?Q?8aHCJO+A7vym6QU4ZP2MevPjXC9laaaWl3XJGC8A4Iy66FmZ9Ac6C+I6qULq?=
 =?us-ascii?Q?zvQX0CFaGdZKB0Ur5+KPQkt/YuKQ+f4NWqCNzjPSbebGsQ0khXmL6qqtRbaf?=
 =?us-ascii?Q?wWC+omo9uYv5NnYdoX9ueEQvCj8aoaKizrZrtl2nJrSy97ntBiXi6+amvkru?=
 =?us-ascii?Q?AbVs6uHhKoedaIiuKW/OJJSwKr3ZlGUEuK+9VWatGe3e/rqx4ZCytH/IJcGM?=
 =?us-ascii?Q?0vzdG27wy+e6H+l3I7VLwFPXQdl/z+zg9U6Hwc52UnZYunQV+MkDbowvp0mj?=
 =?us-ascii?Q?tdDCyY5zUPDpokI5kHZZhRlioxOskIe93paHMex9yTI+0cBXAfKZEvb0C+tg?=
 =?us-ascii?Q?VTvK9LGnDm238pTnYR7EIvJhkang1qiTJML0TFbj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086d4662-fbe9-4907-ae03-08dc1e9ac83c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.3830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtF88tV7crRBV5WFHclrNbuDphNpQeMrebIBgueJIFA2yAoonUbfN2zjH88Tkh+7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

The SVA code is wired to assume that the SVA is programmed onto the
mm->pasid. The current core code always does this, so it is fine.

Add a check for clarity.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index b4549d698f3569..556aa832c63f15 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -595,6 +595,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (mm_get_enqcmd_pasid(mm) != id)
+		return -EINVAL;
+
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, mm);
 	mutex_unlock(&sva_lock);
-- 
2.43.0


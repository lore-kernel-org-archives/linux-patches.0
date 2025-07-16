Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F9D2BCF41;
	Wed, 16 Jul 2025 19:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695879; cv=fail; b=q+oxFQzi+qTZIYC3141JKXlMlLMAfvGBUn2xikiOV+AB/QwflPJz9SM5/R4neHA+3lw4KYYFnUa4vV91EZy7KG4H7HMS0H1DyxZoejp5qasP5hWUf6sMly6mlSNueNFR6hgsKrow+7Fd3MCVkPght/sl3fbkryS3cuZvjzWZQH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695879; c=relaxed/simple;
	bh=7JMmaYDgqoidBac/HfFAoE+G/s2K+EDfs/lbnYwh81Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fXneb/eboTZsXdphLfBAezVjsJS/Rim+2jlRO7fwWA9yow+iBdoPjtjokOuHWFTrSOGG5iEsdeb+837mFL5iLYHOC6OvWO8vQlGyxqCnQv68UTBm5C2bQ92rk1yH9+FE54jjgfhdsbXeAJvOdsiQaN1tij1jmqNdVBVa9sEqSOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lsKPklHR; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lsKPklHR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5n2Qh0m4mjKzEgNDCQJrxcgeB4EB7ILqUkLWDjLV/6e/wS5BF7LbAl6Cxg7hpg57JUz5YUyDngrY7y3bUL7bcr3v0dTyrioa1w/XYJ/dMDeG1mRDmhO3TCyCaCtSHe059xKiLq7kUIqZPj6b1FruTJ8hcphc7ji3W9u65k+4ZG9kSVedbMynikApE+HYGMRBQ6E1eBSrPluvZXGc6Xs4Pcbp5AA4x/RjREAYmXUtGFOsv0TmCnfVxKOBuTPzZ6PCm9EEsh0RgDerCrD4Ar1mSW5VVj6b80hmm6zUIVZsHWoqPEWpPTdElauAh6Etbou2dSpJiEd71lUydOpLPOPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdD+j0XeE+7jywKeruBXNwUDHg8wN+ifxOlNGcBo+hk=;
 b=iiTqJwgxdigFXFrnkaYp+16+2uI9r3khNg82RIaqcHt+wDtElfdkjEnSrFIdsy2lh50q9lmBp0NxvvYwYSE5Okfb2fEUneB3CAjN3RQL+sfyqw14cKCCbhtbndMDpb/BT2xL7Otnc12nKiY2NevzCjEi4yzJEm+gFiIH84cYj/XdfL7IaUAeWYPf0x17Pby/9qLtXqfwcRel2tgw08QKz1jamYY4D+V1QT+5T+9FbDlFU/HIdVZ1ezxjWlpnW8/BUslRBSBY/A7W5yG1pAzzspI18agXDFKnL0SYH/fJYt90utMUC4JDT8qvBxe7Fcng0AtLYl5eUJz45nJP5IROAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdD+j0XeE+7jywKeruBXNwUDHg8wN+ifxOlNGcBo+hk=;
 b=lsKPklHR/Fc7sBJQrW/wGqyRKVUEHVAbmCRFwOxZeQ+8P4kF008T7P+tH3HdBOTCd9GtSih6CUHkf2VWROXjEsGlf+BSAhY19DyXfbc7G6EkS8WBWaE6KB1chQfGXXMqdp8rChlF2SPSxzMRlt4DM8IJb69o/aRu7yksVvxacW+FZtDtNt2yWUu/yCepqRBlOylrqPIAvvBOKLHDq472LWh7C99esUfM/Kqwi6QGZqbZmBZon4ujBSX1wBBbpLNCFjlYSiI4oS2ijCePbygmwoCpm4lMkesfFHHx67RsKhJjCkImrF5ehNrAe/sfQz8XMtZbLptKujZtqkF+EXEgAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 6/9] iommupt/x86: Set the dirty bit only for writable PTEs
Date: Wed, 16 Jul 2025 16:57:42 -0300
Message-ID: <6-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0008.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 23ff3817-13a6-4896-6933-08ddc4a30a2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jb2SSNIO423bFqymvAWl9EB+FpPyQucULk2osX/HMbJHIIl200CGp8r/hrN6?=
 =?us-ascii?Q?lQOUbMR8aPeg46AopHXmflyWo3YXG/K5PT75QwYKDcKfwsMkU+1tqkGYIbcq?=
 =?us-ascii?Q?vS/tjqogKtsptfPmR7+0udGMvIbCPPCtzTGZLbfGBatqJW4XOPhIegioaiZ2?=
 =?us-ascii?Q?lVza4/sFTs8zkKqFFIE6NhfpeGV7Xq5yM8bmuQWnsc0UMGGgLFzOVxnFZoEQ?=
 =?us-ascii?Q?Xm2mZ+J975WsAg9aM/k3ctUyK2KriUxCyeGyQUwwIwZ89OEtcSeUaHs0995e?=
 =?us-ascii?Q?r6am6ZnPLsnBe7FVXwBULCPdqzeJqTYInd2RalrzJO56JtfWDd6dekHfE1Z7?=
 =?us-ascii?Q?7uGWgsKxRRVZeqtaTmUqMscY0xX9z+sr0rYeDfF0Vq2kHQ3GLf7afjnI09hx?=
 =?us-ascii?Q?YU/OwOQ4x0jUGLsCJdxpWGrDiFQTQQC6NCCppQG4VuzWTEFzATAl6SFCMEzV?=
 =?us-ascii?Q?fiWW5B5jnZICKxofMfC99/IefO4kbBPhO9H0dKakLx8WEbmpOlEqmn//5kYx?=
 =?us-ascii?Q?1cKJasjy7ZdkKeHfopIxOcVA+LtotY3vShcYLzyIILFmw53AVXCH4jEUsWVu?=
 =?us-ascii?Q?IhdiF7r3yECzpECQdbr/Zh6yF8xVVGKeY+WCavnalpx2tDrlQ07UktnuekuS?=
 =?us-ascii?Q?eql8A3qnzYm3JZL+r1CI4WsUVAPy1C1zGYPANRpbF9xwWlf1TdcJW1aT+qei?=
 =?us-ascii?Q?Rb0wulT497tEVi5rS7h60TbVS/DvsjFvqPFYtDC6xO6fWr7KeRL/NDXmfbOp?=
 =?us-ascii?Q?4T4nkoFR5/aTrMOVqFRe7NnnKzpW8jOeacNxRMrqiswgwsM6xpcmmpVUO1Hc?=
 =?us-ascii?Q?Max6sX+JcyPhQF085G4Emp56DwFk678rCw11ZHHImpBKxYB27yrhEspVyiQ2?=
 =?us-ascii?Q?aEU9Zh5jfNdCL1mQg3w1F6jYsoNh1wluiPtqTabKN4ZkULyw92rlmkV6SRtZ?=
 =?us-ascii?Q?DRXL8xJgXXEcw72AERw+Gi3A/NQO4TVtIcAn4qgg4J54S6otoauR3jdOXEqs?=
 =?us-ascii?Q?0wz7c4S7xACSuqwlGnNA63z1wd2rrbWI+MWKVLE4ANIxfBhgEUULAHv3wvZX?=
 =?us-ascii?Q?a/uZj2djlcIz2AAFbcVs6hAz/7epqanek/ySDZg0by6AmGMtp/eXU70KCQBf?=
 =?us-ascii?Q?QcF15LUwGPdbw1En5Zcm46WSZbA7aEW1PSO4xUvptZJ9Zv/czwX2lY7tpkNQ?=
 =?us-ascii?Q?1tGFxsa4HHCvneVzx1vtouY7800gOLaF+fjoCDxyTp7cRcKuB3Azb66JNpZM?=
 =?us-ascii?Q?XMn1NPTQ90sgVtPDRvyWU9dlV12sukHNHV/oGVDTNyoDUAtk7+imA7EkZ3Zz?=
 =?us-ascii?Q?DUsj5z9jXivwA9qDY8vfcbIjyWJHfczqJWTs5LxdeaX3t6TKEYetKPkGWBQ6?=
 =?us-ascii?Q?LjSIKZMvyx9GJ33BnlgsGfMZw4vMcdAWiEIZQOxt1cRute8YxX4MXwLgD6G4?=
 =?us-ascii?Q?yuBXlejJ+p8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Qbtd5o6J8zqP5VeZ5qEKt74uusEdWpUD4c30hbWRsRgVYnykTwQtz8DPWqU?=
 =?us-ascii?Q?qtyeP3VNKJW30hO2yjiesK1ZhTXr9VJp5g6p4HY4AkkYaGh7RlVSkHKvu1Ez?=
 =?us-ascii?Q?YltCT1NGebxCyocDA5c555Nu4E4MwnLuT5HHQJp7j77JxJTlM1IwubHR6LUn?=
 =?us-ascii?Q?G2KfSgow4yb2/QyLC7B8U8evFuspy2H8co7YFxq/eFfED9f20kyOPuDPZxLM?=
 =?us-ascii?Q?SeJauaHRrV7ZA9b7uq0lkJModop8GNQdmJ4Hog0ezyhwIGy4KdLO0jRSRS1Y?=
 =?us-ascii?Q?6cETzY1TAjydb4MT3RhwpC9v3glFpvLUzejht4I2nN2gkmjOGtFxJL80PB7H?=
 =?us-ascii?Q?QqOCFMjdfuSIZwlDt+jS0k6pSc0QT/jv4ZsYvAeFYvyl0N9I6rsRZnTP3UDe?=
 =?us-ascii?Q?i1dsOMOg2Y6C8+aannqM4n4dzD2ZD55TlglTB7aXx2VfkClqkxxLofjZt57O?=
 =?us-ascii?Q?BL1XubUjDzugCMOgJmHr/6rhRU3Nh3+0PQfYg/8XDYUJn/3QgHBoEtPCuuJA?=
 =?us-ascii?Q?F/cBmXPYiAecE/Ay/6xvwQ3oexCbC0957aiwxVfNIZc4r0smLatPfikNUsiT?=
 =?us-ascii?Q?MSJmUGvajoejaKjtGAwc0eNgiVhxnpWI78brHfWYBqR0li29jVzFxg3ikkmy?=
 =?us-ascii?Q?UKOKjM9y75DlG20jt5oItxa7Aggkp9IN36sT8m3TFv/3VoTwCYrXMNFMVvrL?=
 =?us-ascii?Q?dxt6qkOrxYs44OF19DOhdNUso+eiTInMweBGqvWO//pTvj6jWJqfLa7H7hqj?=
 =?us-ascii?Q?Zo0tTOURdf98Tyl7b0cGAnrM8vQx3olYv4k6r+f2niHl7Uhzhe9zAZSVh89T?=
 =?us-ascii?Q?9uzSAbcIDcksXY51Va4jFMKmf1Ne2iDGV4HhI7cjpSkeS5xIrQq2a6nanttI?=
 =?us-ascii?Q?Qa2/ReRJDWmDl2C5LOg2BnBTGZovYsckTiR+tCeTGP5Kntr9PIe1Hjq5YdvQ?=
 =?us-ascii?Q?Mxrw8YprwtGBwGITu3BrAxCtjzjYbOtfEyBM1nq/NbTK1NyozoIoeav/Hjx8?=
 =?us-ascii?Q?WlR/xpbpX47zft7f9TMv08BP6PvC9bNaDlCKVz+9E1n9eU/gkY/zlMIJdl7E?=
 =?us-ascii?Q?Y8BiRzKqStvdq+N+dDxi9hUe2D8bbk/SneQV1OZE2sAg25MpIWRCWSK6iF77?=
 =?us-ascii?Q?JBRm6GQ1Ejz7GIt8AJnew6SyCtt4NnR9JjwZj/GPZ/Bp/obSS2/UmhJIu4IP?=
 =?us-ascii?Q?tZ4chg7VIxo22YrDoEwW0tjvgCoi8SbHLVc4Kk5HY6T75GBZjkuhaPYdwIzv?=
 =?us-ascii?Q?G7pWhkW3YO8SikY7xT9TmcaDSZIxt7ioIEtuGgFRViUz2Ia8gIF3KE1yEM9U?=
 =?us-ascii?Q?BOVtTXJyljC/bARfC70u5pFWg6ZSNLUKer8n9d4U/BQTgr+32n8KiECqhJZ8?=
 =?us-ascii?Q?R6WSA0OfrhXNOTsnPUQ2L/45/3h9wJh8esK6ulhjNHko2FDHI6VN3F/Rlgkf?=
 =?us-ascii?Q?amvttkunFl0aA05o80Xo3OT0CHiFkRYBVdafVB5UjA6uU3ivC2LjUjGdh79u?=
 =?us-ascii?Q?OCslzVcgCCNEmZ3GX3JWHx3W840i6sBZYQARdMAhI9kMsUomo8B/4z3ia7n5?=
 =?us-ascii?Q?CEGWKJkYa0+YdfneZAsIIQdIK4xMwZ0/2gPzoEMy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ff3817-13a6-4896-6933-08ddc4a30a2c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:48.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHrWonZ9AUicBzZ6W9ValWxXerluz0MmvNOS+1JfonreHr8vfj7FywmDaq5i0uRt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

AMD and VTD are historically different here, adopt the VTD version of
setting the D bit only on writable PTEs as it makes more sense.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/x86_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index c01815b6229cce..60f8bd6b164b54 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -185,9 +185,9 @@ static inline int x86_64_pt_iommu_set_prot(struct pt_common *common,
 {
 	u64 pte;
 
-	pte = X86_64_FMT_U | X86_64_FMT_A | X86_64_FMT_D;
+	pte = X86_64_FMT_U | X86_64_FMT_A;
 	if (iommu_prot & IOMMU_WRITE)
-		pte |= X86_64_FMT_RW;
+		pte |= X86_64_FMT_RW | X86_64_FMT_D;
 
 	/*
 	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
-- 
2.43.0


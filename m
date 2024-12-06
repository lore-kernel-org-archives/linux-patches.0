Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145FA2F5E;
	Fri,  6 Dec 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444635; cv=fail; b=RwATEVaM0LjeeKj+9vIyjudni0JPMVQeq+VwEWrB9ABuEVFFFlH2JSw6PuTcYF2WaEjxD/XOmg7a1zZo0OvECfquhB3DJtzFfA6dojh1HosM8TkqhgQAtfttwmYAc5tR/DNorcO7MNCfkBY1e9Bh3Bt8V7YpeSYRe/nvLWfxXOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444635; c=relaxed/simple;
	bh=SUMByHunZNoCt/f2H+l2pPk/HX2/X3MevSouDMdD+vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QWlmU4SyYw7pHSjrg85qxe/DXAr+b2l33quiugIaT8NVhEbxv0dcg8eKMaGT0IcDdHEUfy+CDJHUQxPjJL0Dp53mA2kPwgl2+whq8+1DKd0+Pa9ssAvlvFXzSiJhYTphv+02OZqz3ZkXNTOUewZaA67S+ITnQdsL5YItqH3rmx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VjL1glBz; arc=fail smtp.client-ip=40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VjL1glBz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5vj6TklMwXF0nLWvxvWxWktYHqwQ1ss3tzKLDySBTT0Qoa+7lfpi7W9xN8jj1DNoNOP7C+5KfRR9owap6YDQKJNPDEUozj2Focr7ESUtDAEMHz9RLyRVzECPfU1ckbS2aWHRbaFGR66Cgvgk6Ez8jhBb62WOfWy2XaMRHy/6H5zt0Tmvhhqvtuc8NJ3gGZp11k/+g5m6xsCQFac4X5DG67u/iOnS4oxaaE9PAnuLbu1bmtqTV1VXjIkYZ9hGuLDfVdYQbZRtcF06bfcdeJ0fJXzHhGyVfOgDnOBlsRTR3pZCwOBbgn4Hv825ASlT3XJSOwDHa6kWiKcWcMmG7ogmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lDBwgRPRmUbYVZ6wNVbyJ4M9q5SanDfWgEPm/6lAtc=;
 b=CCSBAzkOcoGQGYr0LVLHppAKP0w7nK9HYs6pl7xKnQD0My7glIdBdb/aJj5DkqlaBaznteFnRNTH3zrnWvt4oleNAlmBcFIE0YC4HTJ0RmlEjFoEYuPy3IEncAtgWUVesOSbh4472bwJirW6FSfs9DEODmDA2EMmu2Rd3SEbS2aZRh2GZ6naUutWPiZ33tVCsZBxHil8Ti3wNANwrBut2VXl2f5ljEf1mm6lfXCMikPPmVgBK4PmBfTr3e27E2egtYDnc4nu4G2PT0N0+lkytkKXBD9ng8vFlTCldLfZmUhTgM4iFqaV1CMcYrMpmAphaoDO4ClWtd9HctI45gEp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lDBwgRPRmUbYVZ6wNVbyJ4M9q5SanDfWgEPm/6lAtc=;
 b=VjL1glBz6yZw1R9mimFau9KnlQL3ZSYvXXpFkIHG3jsfbe8Io0Vj+Hh3LT4AVHGgw4aJ8LhMAXJWvWkCtqj8cV/4M9nHoiDcjK0SlUT6I98R50qCqSQID86NCkK+grd+FKvgf+dgPE5DVp56nUDr4KAq7RY4OHhRe1TBhsjf53176F1MZ9FW8TJCC7GhFV1KXvaxHi7YUd12MH8Sqie581I/KLb9VS2OHtG/vF9VmAcXE6tMp2PEOCcZnXcO470UgcZFoPo6BZeqcTBMa4+ubWcyyONeOEEgvboDfo+e6Df+u/mQcRSTBwc9IOPAiwx9KcBFS2tgXZFeEDlFmjK+sA==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by DS7PR12MB9525.namprd12.prod.outlook.com (2603:10b6:8:251::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 00:23:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 2/7] iommu/amd: Remove domain_alloc()
Date: Thu,  5 Dec 2024 20:23:37 -0400
Message-ID: <2-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0109.namprd04.prod.outlook.com
 (2603:10b6:408:ec::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|DS7PR12MB9525:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c7b64fd-f6b9-4f3f-ed1e-08dd158c3e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HBVY0nYeUIHhF5JeL4lVoVy0DWgdSIcL7CEF4mKdmXzqUOfFBJoCrdlsyVyz?=
 =?us-ascii?Q?HJtid4w0wuwVjEp/LVuLwYzIHOUY2iTqrxZwsJMDPPp+d1tV6D9AUwSmQw5a?=
 =?us-ascii?Q?IsaxdZyhOybm+S1rmNp3jqFrrLt7MHdXNrVoG2tBWCKkfoZ+Y8QA6MwOnnGM?=
 =?us-ascii?Q?xyYgg1HrS+vp8lMzYFFjbJwH319swqpyayNAb38a521jIh1qXwwy9HaGaKL8?=
 =?us-ascii?Q?MnPWUn/JsiN14v3HYTbAcRFJZqXHrvhig+8LzB6i/CtHXxc8ONPsH+vOt1CV?=
 =?us-ascii?Q?gP8pcLs3UDGwf3D2c0DXlE/m3o81C9CoSfeUgNN/Uea5HrAaSwvmHqdXADFZ?=
 =?us-ascii?Q?RcMUIFRZpPlZJnN+/M420m7g5rNE4/Ki6qG2urXwRPR+4UqUhMjjnnPkvKtO?=
 =?us-ascii?Q?HkLNefUq57Z1Ep+NyRxVqdYRj9mAiU+1lem4VOKq2Ul/ZzHxtgXILD8YUmZo?=
 =?us-ascii?Q?OhrYrJ+t2ieyS6B8FRLVMu7Z2l72Rd8B5XhrHR49ObcPXpZbwwg61U5ju8bI?=
 =?us-ascii?Q?5WVOrtWX9tVI4lZQWYTZ6YDbapuo9Tq4APj0/tKv7M+n0FYWqEtdFffA446r?=
 =?us-ascii?Q?vo1Z0Hm35Z3pz10UtSVJP6wytOY/koOllNOHk6AJPzH0+s3PEI34hpmbuhL8?=
 =?us-ascii?Q?Y5WplIrFXfKI4rK6+Fhp174aF+cCh/bBxxKjK6ZnfC9xfvGYaP1QPpS9ounq?=
 =?us-ascii?Q?jSjnjpxQEASvl4dFTyp9Wz51zg9d09jNqsMXj/uGI9+FakdvOr34hMUE7gJJ?=
 =?us-ascii?Q?eK7l3EIwxQcrS22KT/eEVBLMaAawfX5hIbvdGyk7mv/aFMetZdLFul8SxDtr?=
 =?us-ascii?Q?g2geQUE+gwjMuRZwOR3Auq2z7i+38M01SgcdnNaR2jEHrbIrcT6fYcJTvJ89?=
 =?us-ascii?Q?4T7E8wp/OHqnTH/BS8GEbMZmDp5pgFRVsfW1G5Uerq+l9TiHnTglSYPqz6Bz?=
 =?us-ascii?Q?T+cR9ia/HrZtlt1E2N0Qc1x5q/0YEKuLoeaw0LtR2RCWteKhxdg/BzAB3Qum?=
 =?us-ascii?Q?jOAvlapEjymjQ3lsRUyXjGC9jd4wZ8dtnm7FHoWGJvgZmgRUU9wzKmwwOSWy?=
 =?us-ascii?Q?rDJ2nZKQKnqD1NfmaaWqIet+qas9X9G/d7nCp76PHs9E7qJWIRKnNZ6hIx86?=
 =?us-ascii?Q?B+BASRujzYRjEJuX50tqXf8T8a34SAnifzI+VDrDORgT/U0Oo0FxQXCK2MSn?=
 =?us-ascii?Q?pDxd8PmvmMR8ULP26TBBBX+rzfDKwiPBn3GTu2DRTExy86qM6QAxWhxMPXuJ?=
 =?us-ascii?Q?VNPCxgPgbRAPZzT97591Ahi05ZO9nUabIwrlvh9Syk9RFPXFSrnEsSnOKPCc?=
 =?us-ascii?Q?xOfGJu3QTTSbs0gY0PLLw4jALdq2afHM/6zG/zwtluIQ1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BDv3+bFZZrFE2zXNaffYR51A8+q5QpcUDJStQLx2X7ctKJwhklKEH/uXuU/n?=
 =?us-ascii?Q?ad/sKd90dxbjszXOgIVvL8pg0xeoxX0QXkXNS4EfLZqUoZr4y3tkoTQE+f2t?=
 =?us-ascii?Q?1BinY+Gdlr3ziKqKYF4gJjcv6qoXG00dR1q3v6vrVYiYDoYmMJTKzwnmOedO?=
 =?us-ascii?Q?GmTzhNmRuhxokz0+HRGLfXBcxQQZBgK69H3DfSOQJR5AYI14BQmSBj5gLl88?=
 =?us-ascii?Q?RHAnTh5DB4CP1hiySnhQAUp9LysVuiiYnN/y08Ah/dsOQcoKEHHGgcLSeC/u?=
 =?us-ascii?Q?XIBMs8ONiPyebxvoWT7djWw7dbqUbcYrsrWbm7juGqrA+6qcVWDxqA33CowY?=
 =?us-ascii?Q?NGmacbVm5C4/XIi0wYU5b2RzTqdxDH5AM318D3PG2sKwPH419jdvLUX2Ba1i?=
 =?us-ascii?Q?qZoKMA+DBOT4L19V/yr0H8S10TFvBG+Lae11FB2xkrXphzf2irhJyChbwPvY?=
 =?us-ascii?Q?TQUbjmpWlf/PKMBY2ZMFnPicg4NhNNDnRWw7lHdoD/2mF8ZdUq24qaeY8fN0?=
 =?us-ascii?Q?gkPkL9RTlPKXldfyar25Zec+3T8x/RGOTHld0N72yMTJCnMZe2Vfi3/mkPJI?=
 =?us-ascii?Q?hIwaW4cXsfcTMsaXnva+T9NuN3PYPB+oweHRyvmgV4jdGzqTm8nD7Lx4drK3?=
 =?us-ascii?Q?vDtRpuLS1ZCOG57R/ZXGlJwgfuZbAG5ky1V/LQQ+n9iisM1OfA0ge+aowK1S?=
 =?us-ascii?Q?1VqqJcc17lACkbee78LKS3KtV2/wKFrkC3iDh4+Ot95fxfQrgrlLu5RIWu5p?=
 =?us-ascii?Q?lrGDgbKjo3N+TFvUYG80DZy+GDjMI0HU5kZSafhoLkmBeOIrFPxvCeWGu613?=
 =?us-ascii?Q?tTwJWyl7zHohC/sP4p8TFEcIv8BJNv8YzUllr6SaZu/X4UICVzpNMCL0z92x?=
 =?us-ascii?Q?EVXCkkGeAg5Km3YZ7bkjuNWMB7mmtXy+RaLpL1Minajwvbkf2mTUYJNBIGBD?=
 =?us-ascii?Q?iYhrAob1+/Vn+BDrDlsRtDOgMncWJyZxW34qhUl1v4o/UlPaFvwm8VqcN4gS?=
 =?us-ascii?Q?DVm6hGzhTI6cIL7gcooEp1qt7O8/bBAWc8hNIc/ccEAv2Yb5A/0eiJhoOv8G?=
 =?us-ascii?Q?xrhpEA/f2jsfsZMmOA8OZ2xRSoSRZXXO5uhnjT0uLx1zfVl3+7j4HIz9E/SS?=
 =?us-ascii?Q?iqOJ9BZg62JB4104RriSTKighdYwpqkbAOI5GX0B0nBulmq+Hv/pvVN/7U19?=
 =?us-ascii?Q?rDEGYke+4XoA6o9fkoyX/XUjlc2Lx2lpm28gs59AKikgOvwnBOAwACq7pRoC?=
 =?us-ascii?Q?/+hufHlTQykSQ2t8xylRpYRvdjlt/lKxX+gsoLUUyhnEGHjsklGBIcEYRiCu?=
 =?us-ascii?Q?ynOeWgKCPAROIpjPIWSKpyvPXkBWb3r1i9tNf/ptPVXhG2wm3bEOJBVcqedM?=
 =?us-ascii?Q?ZXrDumQBog+cfGD8AZs5OXFCij2wpi43ulC/t+g7RokqL9O1oCxF3S/gBOP0?=
 =?us-ascii?Q?Ya1fDSKkXKA34sNmUZpiWlVE/SSJvfTGsx3mqv440DJhmsoTZGjozq8v/0ix?=
 =?us-ascii?Q?VjzCt8sqh2ZKjaw0Fb+xdwQVzGw4kFiccFc+ifaDa7Xg74nt7w8EP3LuPO59?=
 =?us-ascii?Q?BIAltdZ8zeY+GR5IR3biqo0Z0TlqXe2sKI/y32we?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7b64fd-f6b9-4f3f-ed1e-08dd158c3e20
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTOymJwW5X841utZLPDsbg9uKr4q3vD39XglkaFkw8wSjBo37rwHWyLLavpnMoPU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9525

IOMMU drivers should not be sensitive to the domain type, a paging domain
should be created based only on the flags passed in, the same for all
callers.

AMD was using the domain_alloc() path to force VFIO into a v1 domain type,
because v1 gives higher performance. However now that
IOMMU_HWPT_ALLOC_PASID is present, and a NULL device is not possible,
domain_alloc_paging_flags() will do the right thing for VFIO.

When invoked from VFIO flags will be 0 and the amd_iommu_pgtable type of
domain will be selected. This is v1 by default unless the kernel command
line has overridden it to v2.

If the admin is forcing v2 assume they know what they are doing so force
it everywhere, including for VFIO.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7e7246c49006ad..96d87406f89467 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2386,25 +2386,6 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	return &domain->domain;
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
-{
-	struct iommu_domain *domain;
-	int pgtable = amd_iommu_pgtable;
-
-	/*
-	 * Force IOMMU v1 page table when allocating
-	 * domain for pass-through devices.
-	 */
-	if (type == IOMMU_DOMAIN_UNMANAGED)
-		pgtable = AMD_IOMMU_V1;
-
-	domain = do_iommu_domain_alloc(type, NULL, 0, pgtable);
-	if (IS_ERR(domain))
-		return NULL;
-
-	return domain;
-}
-
 static struct iommu_domain *
 amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
@@ -2881,7 +2862,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.blocked_domain = &blocked_domain,
 	.release_domain = &release_domain,
 	.identity_domain = &identity_domain.domain,
-	.domain_alloc = amd_iommu_domain_alloc,
 	.domain_alloc_paging_flags = amd_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva = amd_iommu_domain_alloc_sva,
 	.probe_device = amd_iommu_probe_device,
-- 
2.43.0


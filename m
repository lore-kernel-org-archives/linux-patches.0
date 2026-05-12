Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C7A3D25C5;
	Tue, 12 May 2026 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604393; cv=fail; b=R8ubnDn968/nIuV3FPUKEAGR8KSSdijkf7/HhcnTvqVik/FO9z/4bD9jPiqB3iFyDo00TL8ynBd9ExHiuEpsX4yrzY79aZl+K6bABjgpzOmdqfHFwVkmAjx5siTFgPwZJJ9Da9awoG1Gr5GAhQf5qFSM06izstV6EW0tLJGCgSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604393; c=relaxed/simple;
	bh=5CrcDIxUss1bXzfH6HfUFIwDHrHPiwsMihd5M3WQ5r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RlWnoN9YfzbSfEQj6f+njuJ/kOCbh7GUWhH7qFolEhI1U71Ii0sMmDIqFKc8RlFev4DIibglweu4KfXHoQ+xlzHzCl4Pr8yKy/FBQD8RSk9fMl83dNyOrOPcshokV/RillekD2SAjlN+/j67Otxd69udNMAAGuB9nZe4lK7mvoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XdLXLdrV; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XdLXLdrV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=utPL6D738JQFZ7mmm/+eQVUCjkIYrnwmr01/vAxzxyLKtv95Yn29o+pLKXCTNawyfho0QZ+OY0AHbUomI/UMhqUinYE7Ds39YX8pdJI3+YOn8L93xc6rTx4QTbljDpOJGNUO8AqbNjeBOiAN4H9+LIVgYuwH2heE23J8+Itg87rXwlcGCAeNNuBf/+KuaNg8NPUwWCOTvfpYlZ/ulN8s3UgBgHK/xtUHlsm/lrmRwV7wxwYaAiR4tX1EIC83AlvgqNxl9TahLXE1Eqo0AnVkkXBtYHk0PJEBgCgzwebcoHRj0/uksS9iGddfAWl4qjvVWM39dHC46wDDRNbtW4ojvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2wqBqjq9Ch8aaQmr+BvddCraK8BaRRZKYK6KNS4MZE=;
 b=nkccRjhXPTAvaH4qSYg/XZ30iSEpXvsK59mqHeaiXTZ8but+WGpSxJzoiTjUzCCvuNbM/0y0JLPWzz3GlDjBju/U5cKPOGuef+AVCgUpyi7uhd70KMPrK7m6tgA1VZqjtsWvRuqWWTD2EUyZlXBXOPQS22EQX0HpevTWfUt//0Rzaayr58v+2MTPKGvfgY0R7i5hfMbG+NatoXiG2YMag5XHRIXe9AgANIKcmY0I2UO6vH5bbPUCW7njLgjc7Sa4yiGdX3XPtFpQ4zUFvUYfEzv5jt764a9EETH6gK1yYrNTzwuQCPs2CxQmRjz/wHNLXTjwM6bW+4iaPjMlS9DhHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2wqBqjq9Ch8aaQmr+BvddCraK8BaRRZKYK6KNS4MZE=;
 b=XdLXLdrVbWhv+9tcejFYKW7V2OvTK+QNNLykstmIEEthl/TcYNm+Vf9uzRQ7Z33nayv7DA7mAZGKb/hnJdRT0I8VvkAT22YeBCrV/h2P/JgnIRAcq0SweTWGS/vOu5w+LUn1ac7apf14LZHLP/8lzAkaQP5Bg3BYxQJiWgEvlue/QiK+NcFyC9T5ecPswYh2rE12WdbdjP8E6md3weRE4CIfSpmrXCtupp+nV0B5wyOB0eV6IW19KwxyJIBwcvHfS3S5WjAp0ZiK0RbCetLfzFVUZHHZz2YklHIjzsHh6I/KtlrhmxOvYWUUSuqjimrK7XrLWcqSBuORTFILd1g1GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH7PR12MB9173.namprd12.prod.outlook.com (2603:10b6:510:2ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 16:46:23 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 16:46:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 2/5] iommu: Fix up map/unmap debugging for iommupt domains
Date: Tue, 12 May 2026 13:46:14 -0300
Message-ID: <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:208:52d::6) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH7PR12MB9173:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b4f18f-9367-44be-a33c-08deb045fdb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	z/7WWIX2qNHvA24h5+XQ4/4dGHobaQ4RdjxLwpVURuo+PvkvAvz6Kh4n0YkCEktXc4EhPp7ej3nu+VWVikoe0DQ22/Kp3liTOwXaKW+OvABSI8ojGRZrfmmUe0QSNG3RPW1PSW/w3aAgzCw/JT5mDIr+555zJpLhVchCLracv1+ZRTYo6HmmPNfCaNULMZ3ACUhwrODXJCmQ1gFZID23J18dOtQpNgPPbSM4nX6SqU3fWTZhoZd1LJq6MjmqgxJyuwt0mr3GvsDw0Ac59o20bZbUXKUtVVNJcEHWj+8zouq2wcgf8qHe/zrJRaUcRKjdoKj0uk8SDJ+svQyIVcUgnlAAGalT7nVM6n6a68Th6BpnZECO09lfIPL8lgHk9ehja9nbbYhASUEA1qkeIFPwDn9Cy0FOzFu9K8eaKjVrKAa9SQe8wYqTDy5+loBX/iMOe3sppGWXmB/oA7traRNFmMuB6tESDTZhtc1V/Gr4h0dKWjDTk6VPhp2fSKtjAxS4J2h5glghBdjGklGqDdPCvtGhiQvdCinYxsNeusHXH3PB8/MvtpN48lMdmg7BS/StUOoAPAAiCKzGsQT8zjWoEp6FIEwc+bBo61RpvCEC6GLzm2V1gUcGCzPgBMjmBbAUviLG3oemdG8gI4/vAxFC5FTQKatbs53rWqo3AgTADB3kPChpfPe/OASPSUE3rfeu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hGs8fuITW0oGmGdFB+7g3aKX3yHJEOlFscZclW1KAr7gPdqr8SgqU3BQEtj7?=
 =?us-ascii?Q?KAUmgO45UKZpOAwbBF5TKKIX39nMIyi+l/aLQPv1JEK4a6sp1tD4lc6c1MqB?=
 =?us-ascii?Q?uPikmYjYbEVf1y3+63UdIKPRdi+bFw/u9lZu/n0j44qZdpn0gpYNqvKeJKFq?=
 =?us-ascii?Q?BxNawNAPY2b605dkc9d9B68X3Kx3eI96TEUSY7IB6BeOAtCJFy0VftizP0Qg?=
 =?us-ascii?Q?XOcncnPVJAvudf54vb4LHgPS9S9uqKUCyWxzOJDEUR5EjHJg2kWS/VnkYMUU?=
 =?us-ascii?Q?Ik71NiYmTwHXM7MMI/xug3BTBY//AchjLyWrUSkZ9beX+8sSPthxAgVyUMxq?=
 =?us-ascii?Q?/TZvTtxTfScDHefJq4oa323rB5PwU8p99mzxCZKtvQOnn+45ym+mDykZzMlY?=
 =?us-ascii?Q?LKKUQRjV0CUjsp8P+2gCEboqb1pNTKoC6AM5/X1v06zZEN61cGJZlGLBm+TO?=
 =?us-ascii?Q?WKxaaEGLr9+KlmBcYzk1Wh64j9tvSY1AoPyspB76LO24+Xx2/qYdrjXHocgT?=
 =?us-ascii?Q?aiaVzjbsW1CtWh3R/0UMbMVtvCxppKlg+mCo737MYzE5I6B2aaltpqjCSHGi?=
 =?us-ascii?Q?0GVx8E/6a5lQPrGUHHjuqAHr+QbhGwJs3C6tNOCCnir+Em/pIRQPh/KBaXuo?=
 =?us-ascii?Q?F0pMjrSC1y82dr9+TGK+prLzYqyhI/OKORvg29ZGlfWNrZvYEnmYBuhE00lN?=
 =?us-ascii?Q?2NNOABWSImMvAg4MTianZBcgyNR1YWrMxQk7R3ipHCjHzduw5y3IjqcWPlSe?=
 =?us-ascii?Q?APKkrHfGuyulfXpJabqzWJjA1DVw/PzES2XW4d/tfMD0xA2q4yJoXd6ZZ1dd?=
 =?us-ascii?Q?f+C7gx+rPmwgE3G73kxq/2V3hK2oZ9eN+7gPCUKaUnoxNAvmZRWSw+BdNbZx?=
 =?us-ascii?Q?XTBUPaNSKcz9UKJj27FqPPeMCAj/08fHo3cmhyzVMjG4KHzBNRCTLi3/3TFN?=
 =?us-ascii?Q?ETMx8zNm07K+julYoogH03UJV83Ux7rCg9n3meYE/Bx7h9z6aenLQOeckytA?=
 =?us-ascii?Q?Khp9RF/KekZhbUDcj98jsXzKiQn55m/bY5UTdfsGTREkTiE0ESOI0OPMFUdd?=
 =?us-ascii?Q?1r0phYpRZvzFhSmn+Z56x9J+ykjxcfwoduDCa9NKsgr7kpnbH9eV2tfVf4TH?=
 =?us-ascii?Q?IvRUijAY+b4JVN7i7e2ZgyLmA9Fs9CdTddXGNX2SZT85i3n8yNm5hVl+XFFb?=
 =?us-ascii?Q?Xh0cSF6Gg7rqSPdw0Ku/HWoDYXpp5K0IVZYcUbaNyWgY1DGUqemkCbGip5FR?=
 =?us-ascii?Q?WBBy509RcZ/pgGpr93qSGszdVl19Rqwj6VexxRvq+TyMahmc4f0lfY+ls7mC?=
 =?us-ascii?Q?V1rldzvc1qOlkG9BHLBxJzwUm/lSB49RNXZUY5nloHx57+Cs8uiJ5PNdPWT4?=
 =?us-ascii?Q?44AGsOO0bL/k6YoLD4zfL4TvnbQdbMBa/imXiDdaSg2+9NbSh9BfiN8O6L70?=
 =?us-ascii?Q?6uYWT738ImVkTkVarv2L6G+II9J6oxyQwgYO0CpJwTgjKlXTM5HUJgUtKAEv?=
 =?us-ascii?Q?QF2rGiIw3byQ8sNQ3SX8u6oxEjDT2b2yKuLxkjWqWYvDDo7t9L1k3fdUwj0p?=
 =?us-ascii?Q?NycksRFnNWRwW9QDsF236dNAeB3oCg1Z7Flzozf+auBK87UBDHWseXo2wKH8?=
 =?us-ascii?Q?66PX0vPKepWlTQfGUWakiGNAiFhS0EvaIUGpbGHriT8Q02zX30ei/XBFpwdG?=
 =?us-ascii?Q?kcqCTQTsMrCJPl3x4GnXIAS6pgVULVEqrCcZn4KbyJOdJ9Pl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b4f18f-9367-44be-a33c-08deb045fdb5
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 16:46:19.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5g+TYnEdyE/IMNiS+d262h3Tw+H0DiRpTwTGtiNWGAMSAKjTMdKol9VAjG6j2eqm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9173

Sashiko noticed a few issues in this path, and a few more were
found on review. Tidy them up further. These are intertwined
because the debug code depends on some of the WARN_ONs to function
right:

Lift into iommu_map_nosync():
- The might_sleep_if()
- 0 pgsize_bitmap WARN_ON
- Promote the illegal domain->type to a WARN_ON
- WARN_ON for illegal gfp flags

Then remove the return 0 since it is now safe to call
iommu_debug_map().

Lift into __iommu_unmap():
- 0 pgsize_bitmap WARN_ON
- Promote the illegal domain->type to a WARN_ON
- iommu_debug_unmap_begin()

This now pairs with the unconditional iommu_debug_map() on the
mapping side. Thus iommu debugging now works for iommupt along
with some of the other debugging features.

Fixes: 99fb8afa16ad ("iommupt: Directly call iommupt's unmap_range()")
Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6e53cfad5dc001..e334588a2476b4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2583,19 +2583,9 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
 	size_t orig_size = size;
 	int ret = 0;
 
-	might_sleep_if(gfpflags_allow_blocking(gfp));
-
-	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EINVAL;
-
-	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
+	if (WARN_ON(!ops->map_pages))
 		return -ENODEV;
 
-	/* Discourage passing strange GFP flags */
-	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
-				__GFP_HIGHMEM)))
-		return -EINVAL;
-
 	/* find out the minimum page size supported */
 	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
 
@@ -2657,6 +2647,15 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	struct pt_iommu *pt = iommupt_from_domain(domain);
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags or illegal domains */
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
+			 !domain->pgsize_bitmap ||
+			 (gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				 __GFP_HIGHMEM))))
+		return -EINVAL;
+
 	if (pt) {
 		size_t mapped = 0;
 
@@ -2666,11 +2665,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 			iommu_unmap(domain, iova, mapped);
 			return ret;
 		}
-		return 0;
+	} else {
+		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
+					       gfp);
+		if (ret)
+			return ret;
 	}
-	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
-	if (ret)
-		return ret;
 
 	trace_map(iova, paddr, size);
 	iommu_debug_map(domain, paddr, size);
@@ -2702,10 +2702,7 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
 
-	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return 0;
-
-	if (WARN_ON(!ops->unmap_pages || domain->pgsize_bitmap == 0UL))
+	if (WARN_ON(!ops->unmap_pages))
 		return 0;
 
 	/* find out the minimum page size supported */
@@ -2724,8 +2721,6 @@ __iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
 
 	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
-	iommu_debug_unmap_begin(domain, iova, size);
-
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2761,6 +2756,12 @@ static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	struct pt_iommu *pt = iommupt_from_domain(domain);
 	size_t unmapped;
 
+	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING) ||
+			 !domain->pgsize_bitmap))
+		return 0;
+
+	iommu_debug_unmap_begin(domain, iova, size);
+
 	if (pt)
 		unmapped = pt->ops->unmap_range(pt, iova, size, iotlb_gather);
 	else
-- 
2.43.0


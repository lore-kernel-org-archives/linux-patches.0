Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F104E14E2F5;
	Wed, 27 Mar 2024 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562923; cv=fail; b=oAOcLw9uXz8TruDVnupAFCoj0f+fUqwQILOlBk/dhzzvAhajA9ct3DzJCuwOyNryTEesYkMh+YAhztPPy0BXqVqOwSTyG55736OlA8yB3W7yCzMTfd6XMo0OAF9BY53ewD9Jq3kxySaydl/JkrWLKkbwDNRPQX1K9eGj/XC627A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562923; c=relaxed/simple;
	bh=iyQ5pNGfhu9A+6KEHcW9BFVlyfpdsGc4Yt2z3MCiwd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LdhHlfFbO6/RScbSuGW+m5T4+h7+HMWf3B5ETB47AZ/Hx2s/E45o2NblR0+TDg6WoQuS5sc0GJFjSdURx35wnffyEsFAmuRuuH68k3zWQCrI/ATWISo3wXcbEpMp7ClQBd84yW2czULv0iKQZdi4p6VgLPgcH9NouJi+9yrAbC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J7pxMqNC; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J7pxMqNC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc5vBK2ZEdNOWa65gUnUI/PzUf5NGwE5N/4dCD8WUhryZ81+fjhCeJCjz9qidNNymBEhq1bqQBBffxIGJJn/BqLRjOnAxp6gWwUEd/TIPqhy5KBJOutWWHrBVlzbuXWgWUR0smXHF6CJzIGC3i2bUZ4NHJPUDCLlDPG7au5dkz3/NFDjUHeJyfBF1/sJ8TaFjYMxfGkpvB2DIk6qtyYj4bEFM5bBYJW3G6YQDthm5qo+Tspnm1q85sQ8pNNIuPE2a6WhaprW1Q8WUCsXcwSUC6BZd4y4O7vJ8KmnHk1moUNj55CPNddf8GTQrc5WXlHOEuHYnYWzB+xfkoUA9g3vtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNsVxxAr5oOUMzPY6oB1kMo+IdzMqLmUtep2e7LaAM4=;
 b=KTxl+AX+tGzuOWCpbEHgxnD64a8eoaQHU5AS2K+53uBZFY9NRoI26FDttRN96L+Nj/OhRz4fPUwo4Vbphn8yVV+SmdAqGuWsdebZWU+D3vA0nxTJ8BYqr51GeugSgiKMeusiURiAEGAah6mbxPfFzd5CEaXLu9nHfK+vqSQSnGSGFM0UBZpP+Uc1FmjQyi9T5fU2IkYtYvquvg+OntZW8pa/WBnsNIMvg5r17dR2KONKHwt7stK2YkMD96knvBNu2rsvqZdcYPNc7VzZqMOMsOzkP+OxhbxrkNnmrxLBPbhBM31Ptd87aExN/pq4TfQC0A6DZfwG9UaoJWeM9MuLXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNsVxxAr5oOUMzPY6oB1kMo+IdzMqLmUtep2e7LaAM4=;
 b=J7pxMqNCmaXJNYaMZIG8exLchX3VY3+Xfd1C4tKJaEuMdHw0YCSOGU9MPkWT6z4hHrT/gQzFgD9YfqQcu6GqcGy5Zt83i/lbbxSZCvYvq7h92FoXr41ZwG8ULoYnKw2iWCdK2WrtB9PB3+/BmEcULS+2T5PFdNV0ad0ANciw3MQ9Jg3jgna9fErdbbOJjCL5vXBYbvn/S3MknsjvdwzoWV/NSXqIovk96kdDfxegWqFaa5jyEKgQRtOXx+g0T3N5Zh1iG/cESEQ4lmF9aFpWmiUtcapo9hVcLPJDr27SdjB2A6/TdA5m9YgkoUpBCNop2guK91xN3jnNx8XNFYuIbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 01/29] iommu: Validate the PASID in iommu_attach_device_pasid()
Date: Wed, 27 Mar 2024 15:07:47 -0300
Message-ID: <1-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:208:e8::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: a050baea-c1ec-441c-3f90-08dc4e88e22c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vfyaMpaGsUzbA788ubvGJcwVQVjW9zAU4idRKpqoiGnpS85nU2pYInuxEuQBrTQk8o8LqsahxIHnVDQY+Q+MirIRbILhGBFJYtcXRNDGajNHH5F+n11vhzp5cCfwGoRpBerhPwjY8oFD+tYaDlo5VblYz+35t3fDwz/ssAF534BM3fkK0Ia5do9dH7ZfvMGCeUiHNv1XlvRzes2utB6/V2Aw8GBPsxXYgO0z9+hW+epOmNNLUMMGOykKKRU9v6JcbDVP6A6no4RHyJpHk7Y+6zGDT0plMA3O7aLJDU+0epasnVVcj+g1/dktMmu0O885nS8sUH5FwEqgfykoiaGXuVuDXXyllroz+xpULAVBEjnr3GhUJpnb5RWWn85vOO2WEkHmtZE3tRwdi4bBBHifzZR2XLrrmLTyBr0cj2MqoPT8iTeLgjiuz8kOvNsIO97Df/P3yDfxHk4tMjqz6ub94pdlmIcvJyWzI0ntTZNlu0R/Z/BWWgzDhuPKQ+C19Ui8oCXv//92hWQJhalRwoqQyN5PJ7emebZ3YtPzhubr9rcZjgszuYGUYwdc5owG1y7F2YAMdQVhY7EHB6srq8d6lk0aRL3l2V8aZ7XXDkWD0PIp2l4nyXA2xpRNjlwBVCyV7vFuTtdgGMJy00I+EYsBlrhDbIP+WjJWrLgzPbTE2RU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qDYX4rQFxMoT/quDN7WBKNAL0NZGr6y8E3ygZnP8LZc/q0cGaOYOFMqwZLwD?=
 =?us-ascii?Q?zuR2bxRBpqEexSbTFmuQe3j5H7uGoAxJ5FU9SCefp0D77wb+DBl/p6790aPz?=
 =?us-ascii?Q?sIUnFHMHRxHAu0IIrODNKYk0Kd4tzKVRUCOgU1U8VDrgQ9BTTP11WV2rFPtH?=
 =?us-ascii?Q?+3idp89FMzCMo2Yi0kUoItMXcpQgAf0k+vNC2IuRbyxf2KHWgYjZ35qEm0mv?=
 =?us-ascii?Q?XNfPoIExzNlw2xtfJfNO3grL8+jcGTUiWXGxD2SzkanzUpVbM/mZ+i8YkcJa?=
 =?us-ascii?Q?VsX3PIDqBmKRXhW/od8TJ2DervKhvTsgSjWrVZHze43sfEVB5CU0zkHTEd5t?=
 =?us-ascii?Q?M7Bu+1pwxKnl/FPwu7As0DEZqGFuLM5jVM0bT3a936xI31xTV5z18JIbTFOw?=
 =?us-ascii?Q?+CCNw5EWvXmuJzqY1U5csJNyGfA5xPBbh7OADJ5NhSk2VfUQyKD7vc6vxFxj?=
 =?us-ascii?Q?YXIhnmx/w6TaYNyEyzISMWMpmCbOVQjcvSMqhjJuIDiYOun261vxStY4WYfu?=
 =?us-ascii?Q?gHM32qSpfLkDHx+kFIIaB4Ed4+lIUbofDG1KVtwWuYO5H2YtEVPECGcOBigi?=
 =?us-ascii?Q?kweDNX3KAHMjGvdiDxPPJPBGFuSCBbJZokVNV0AH6XN/TkAyoK/Y47630Bd2?=
 =?us-ascii?Q?BhiBJYmD7P7WPuoHMwP6qQuM0hafT2iQKgbnOfgC7XMuv6Vhkw9DaTJVFFqC?=
 =?us-ascii?Q?gQaC66sDZl1DZTnpyI0rp2KBp0Ft9gBWENzdcpEtUNanA/5gNWOR0dxHbZ6k?=
 =?us-ascii?Q?JOlDCeiyTiXXfNxVRVnkobnDtfhG82r6hz1ay5szozF50HPldLA1gSawddQh?=
 =?us-ascii?Q?l5Pqf0fXL9FlN8c9rYsjJ1w03yOxOVuDef3ETn5aQ/O4wGjHRvyzy5lnugol?=
 =?us-ascii?Q?ZGx4LhoUZpF2SztjcSn54Fmj3d28XpYmbkYt7NV76rOV44cFOYB3UOPTzLQx?=
 =?us-ascii?Q?JrW5Gm2KUwgzd3O2UkLc6JnMVR886nrnrq8r+pXgSJI6BQWEQc3P2prv5puf?=
 =?us-ascii?Q?s0dPrGri7y5nPiJMTrpJstNsMBnHUcENTZ0iTE5BlityRkZkpDodNzSGnfer?=
 =?us-ascii?Q?dr7WU8DhW29InBZzAPfEKbJKy2k6Lt6X4/fgS8UcavqQey3F6efGuqx8vowq?=
 =?us-ascii?Q?aVxN250AOqW6oC2kY2yeNLstP458U8g7krx8XrL0W9fzAJgNsErm+UwYvIkH?=
 =?us-ascii?Q?j0eknOga2KqGXrCaRJXJe4+BPzqGnzGd8lR54mtfNb7FmWukahbiwC5QSXe+?=
 =?us-ascii?Q?T96kk5LBr7JoM2CnwXHN5JyTdTWdFLsdiGn1cIcfWwtvYss80DYlgA/KWm7+?=
 =?us-ascii?Q?3wDKelLpHJ8gIGfio+/7FN/py/lSAWnVYVWbk2xUmKXgFsKU+6agaCTNAFh2?=
 =?us-ascii?Q?PuVwtn3sssJsFnnNaRVU19eJ0qZqjLTe3pKejbpppjHpv32jenyJl8k6rPhK?=
 =?us-ascii?Q?1UBm6N5/w85B+CFlqBDXFzICZCXX8oihHlSdz4nNq2GEhgtIyVjdMLiPEE+w?=
 =?us-ascii?Q?RGPa6oi7Y8ckMENfWRJs9WkxFN7AuzRkKpQ3/TUOD1N3dgt1vyoQHR/AZqh2?=
 =?us-ascii?Q?brHgezqEMQVoowzTlVb+QauR6Mdn5Rss0kHdVvNL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a050baea-c1ec-441c-3f90-08dc4e88e22c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWXi3VqY+pLmszmSYMt9jtILmsAP6+n4DBt6ozZVOI5WzaUnW00bpisOgiZeQGWp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

The SVA code checks that the PASID is valid for the device when assigning
the PASID to the MM, but the normal PAGING related path does not check it.

Devices that don't support PASID or PASID values too large for the device
should not invoke the driver callback. The drivers should rely on the
core code for this enforcement.

Fixes: 16603704559c ("iommu: Add attach/detach_dev_pasid iommu interfaces")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 098869007c69e5..a95a483def2d2a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3354,6 +3354,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 {
 	/* Caller must be a probed driver on dev */
 	struct iommu_group *group = dev->iommu_group;
+	struct group_device *device;
 	void *curr;
 	int ret;
 
@@ -3363,10 +3364,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
+	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
+	    pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+	for_each_group_device(group, device) {
+		if (pasid >= device->dev->iommu->max_pasids) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
 	if (curr) {
 		ret = xa_err(curr) ? : -EBUSY;
-- 
2.43.2


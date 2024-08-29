Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A837619FA93;
	Thu, 29 Aug 2024 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937610; cv=fail; b=YXCxs+iaJViYVcIEdUmiV+3sAJatrqy58I9n9ep1S28z/LrnWehUhiwxSS6PdXS4mVc5tPzmsQYyBBZ6+kpcWfF1AdngvOfuWWT5tSFbXGk9gZ6HT0wcNO2QYIwepfGFffeM6JQqHxvp79qK4QlqfFsv9y33DpiZN97n4YjaGHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937610; c=relaxed/simple;
	bh=xWqM8lzQ3bs/DJ8qYHpn6vt2WyfT6R6cdTAGDOolOgA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ul80GWfNidLiQAyCTXfFz9hHZ6uHpqKD/X0j/9Bk629xhlyXQBKae/I0j57AWuhcPHqYxxBjkpWB3w4OmQQJ6No63HMEowHoY/A3MS0yLelNI+rlpHrKPYQ5w146V29D6YeJK9xov1K09A+2W9woaUcUsme+ChKsna14hCcd9hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dpRYlynr; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dpRYlynr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7/hJ4tCV0HMo+rDJhZdwS/i0wzQ4bUAkoqjmL256uL55mML2d5qKOsiRO6iMsemxeMB5ol3MocYiwjjuF7cWrYrJbDLCxTUeACqY9P/PokaUAUdsjDbhz5SfDepqqV/EtVUnB2JMjpdrJYU0N1XvS6lvkEk/uNMJDaQeNT2Asdavxbi1nVwBhAOZr+hIhcn3jZ3rnOQRfPBIeomzkT4Dc2C4McqvW1aphS1TmeiXwbIqVkWJWOSC1cX1+/xKfIGsVd0UY8KN9NO5Y9ySG1hBDXzHXRDdblo8ckat8h89rbZqFAbyyyAoNRZVKku3wpGi0Khr8QyJOctMSeD/ZOdiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aG7zfSlS0Km1IyMVw4CfuEN8YAJe51S1HsVnLiCuH4=;
 b=eQ+Jln45ZEbqDCUViWNtrtlbB5CDcsDJKmvGIRF2kpnBsh3wbdPH4bmOTxRKuNzROqK/7dQFn/rQjaKVHt9/Eh0YctD7a0X4T4fgxOqv8tJwXOkGcRWZXM/bkVau1obviNMRErkzEaPy7/VswW63ynOdZBhrnl4Mnb7GLeoJ6Y8GZ+d/ZNM5ah2iM0RCTUCRQna4kpc47Bms1rKBSU0Wox2TdC4dpV7D04d/UlsCZoXlbTsWwJBiTIDwpPIgVMiboEktPVl4xaqhZY/yonQ6e8qpRTA52ehS1a4QdSUiRSpVxDR77xYeWU5GclH6KwslEBwBkKcdEm8BA72xIiUM1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aG7zfSlS0Km1IyMVw4CfuEN8YAJe51S1HsVnLiCuH4=;
 b=dpRYlynrLmaLpreWZnGEQ+ctHfe64fFYckNdvoQECEQ7uvEk8ainq2TF8Ad+vN5GD3AsEw4WVC5sRCZDa7kzkLGO0YEiibBxu/im3A6PCY7OwNLy2YqYc/ohkIFCbiD4WJ5I4BeYLNP4OzqzS6VQwdqxkeHJlaF2e5niEcMKZC8OVPnn5FlkIHkJJo8b/6117DxkulJmbzTaplOkggwr07HtZEG3nNGqLukXB4SF169nJJZ9hBCZqsETFX2Ozz9zit6o2ZF6G/OIksJRavHBrvryTzi8uPa17WYxMaelbtCiJT7GhA7HUjY4eaOWgnSvq4eF+NhpaVfZDuHEVcAFaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CYYPR12MB8921.namprd12.prod.outlook.com (2603:10b6:930:c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 13:20:03 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 13:20:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] iommufd: Check the domain owner of the parent before creating a nesting domain
Date: Thu, 29 Aug 2024 10:19:59 -0300
Message-ID: <0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::28) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CYYPR12MB8921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc921d2-8e37-4c16-9a85-08dcc82d4925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V1szBfLLMjO9jE4gBpTFjiUTTIGkbO01MK0cUeguvHSgmamP4QoEopvlpO/e?=
 =?us-ascii?Q?WyvEpaLw3l98DMtyOvt4xacRd/WjLe1YN2o61sZYsYNsvAWNgEDK6MITgkjK?=
 =?us-ascii?Q?Y1HL8iYYhvLDMx4GfUI1dABK4MM6i8LoAslhaCpvAjDeK8QPFl8PiCdG0ucc?=
 =?us-ascii?Q?YWoHHL1JsBWvvcB7iRgz4LhEXjqmZmM5gThfzAyTxmRwOl1tSPgVAvwrghkm?=
 =?us-ascii?Q?KotOx1A8j5HN9Yt7CEqfrumLc9yKR+FkiRWwpxvKanadJ+mxxSyWscV2R/RR?=
 =?us-ascii?Q?8u5+BbC37Itz3hxlMpjIt1wQi7Luj3CtX/Kjf0A4sriVl3u/jqvoRNZ3BpwB?=
 =?us-ascii?Q?RD58NwPFDP187JEGG7Yz6GWjpJ4KGKPeWNZyg1wVNp1fEJlm3wicmi2lRUj1?=
 =?us-ascii?Q?9cl3iM747zyPTe+r3uXuT2x8VBrji1ZustRb//gZgEr+BE4G1dFasdLFAmfe?=
 =?us-ascii?Q?W2LPz+goQtksgQcIrEQUvWwKDHum/BZh5HdiOOYp08vd1EcxzvVGSyPeNavH?=
 =?us-ascii?Q?mT7tfiN29l4as8ZVADFjfSpkUvwEhKPdbVm6TrDUsQgVdrttnU9S8NI/IOie?=
 =?us-ascii?Q?HOKLs9gEPvTQuXBGUAuouje63p9TvJCQ1dzmgA110wjvbnuGZMlyGdI1gdo7?=
 =?us-ascii?Q?sPSAD3fnEao2TmjGCIwrtvI/L1t2qGifI87qS0ZtWL2zoPscx+Ft/zxiQrcg?=
 =?us-ascii?Q?faOp3TG+65jge9b1Po3980L/QpMauqa28VxmkSl8NphZXwljmiNS1m9A+M8H?=
 =?us-ascii?Q?NH65oYSViKF1tZGoqwzbe00yklIBkA3Y8P3LYT6zbZ8yco0VhwtcQFRIG0uf?=
 =?us-ascii?Q?UXdMnplUJfY32/OJxHe7J4wz6k5w9D3YZtT/iiSCfXP2qs+mqu/C2HGEM0jf?=
 =?us-ascii?Q?y7++cq4qifSATfLzcINCqb1Zdeyvl3t2XgbUCj5oLwsHrxdehR9Cee39/BDO?=
 =?us-ascii?Q?LkZrufjStYOyYX4YN0RpSlCVA2hGHOLJAvuXMlKzWge4QjBioPwi4ptUFAqH?=
 =?us-ascii?Q?FKcTLhLzkMfcA8a+xuZjYKdW3sC9flbaPejUwXOASx/zv7ADkY2H3vR6Z/kT?=
 =?us-ascii?Q?yN9onjqpU/0dcG/Ke5ISXxtR5Tk4/M1MGob8bFS/iH8DulNNr4RWLdYpgddE?=
 =?us-ascii?Q?xti9drz/tUwKCwTuKXA9M2mjDf1Wf7dh9PWP8cMeLSPRl3XIlLA1hOBen/6s?=
 =?us-ascii?Q?Zkb++6sCIX3zCZSEEScQI1Gh/bHuCkzWZVVYAuFtHKOBZpcTwMGcXrvOW8U5?=
 =?us-ascii?Q?Rk4L8xtADuV0tAgVlTKc6Gr/yM+Imf5dOVaBx+C3BDbgkJs/DvpJRFLHVuS1?=
 =?us-ascii?Q?PTdQvW2Xxn/WVXrnzondXr33nvBHMvfFyJ5XszcIXaRcXg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zEekORMOZwUGAYQ7BDx9xklq5nY0cMk9T0w618xoF9rx7/ge5LBkoI033Hg1?=
 =?us-ascii?Q?Jd8K7Qw+V6iHMu1aTDXCCRrR2hgpnS29C5BiI76gPFVDicD8FM6d2OTOG2C8?=
 =?us-ascii?Q?FaJfvnF512BDo2E75+s3CWsQ8XxDmmEDDNyKrr2Ctz82BlhEXM/ncwPS9dKE?=
 =?us-ascii?Q?r0YLkWvf4kRQHogyjchedeTXXTyFlInDjTzIyjGsaH89dawQHBInsuPb5ve9?=
 =?us-ascii?Q?+p22QqAvWKuJ/UfYBI/Ew20BuVv9X6kavxn7BzC6Ig5izNkMuo/dwWk0tx2+?=
 =?us-ascii?Q?qoBTSu2ZM/s+XEH1PJkd24u51nfZgwk9c3Q5alGqZajj/fhqntDeuv48RpNY?=
 =?us-ascii?Q?B434QltrUK5jNC3Hf+ko2mwaxYah/YiN9+8DuAlMyypyhfE9Q0r6WZEpSy6d?=
 =?us-ascii?Q?vXF4Z3OI5ASWs46EL15NjSQrFGiKnAkuLMtotTleE7paKgyMF7ggX1ER8nDy?=
 =?us-ascii?Q?SdeJYD9RbdgrU38jUoim+xg3gH1eT0yBxm89wa7RznL/vtqDZ9KJxozagAP0?=
 =?us-ascii?Q?vqTnwY3+dpxzIO+PpKrw7GzPphs5Xueqs8HXFIimDar2Pv+ocAx4pHB+sSlk?=
 =?us-ascii?Q?j7VUrapELHXX3c354/iJBlvBHG3vs1eE6q0RhSaakrTYMnUDwvcVoq+Vi26r?=
 =?us-ascii?Q?rWAWNJXDQhbdylwJ4bQ/fFw4S731zx4vnPmtvkiCwlyzQ8awR8TPv0PsNZ3L?=
 =?us-ascii?Q?pEi4HWxfAGker/ZAWC6UAuN/5L/1G6L9qv/d1qxiIgwa8Ay3qQ2sy1QE8Ynb?=
 =?us-ascii?Q?/PpkM7rNvLX0wVND4vECpx/c8JOi6tebQYs8CPdkW2SMWn7wb8sBMSNO1Ydg?=
 =?us-ascii?Q?6KEUGvWF4N+F6rPQoLFvCaJxESntJiqV+8+BjJDvWZgs3qhmPAFNni5Nt8we?=
 =?us-ascii?Q?e/EsOPXNJLuhP8rN7/jORKB+T66p9+S9rJCnj+m1yxaUxbiXWkdD4T3E6n43?=
 =?us-ascii?Q?Hw0rNbSvnJD+TNglDTSYtT9tb1VMcoqUvHdWfKjGbg0wNEdMGG955gGB7Pue?=
 =?us-ascii?Q?meqxC7iOYdYNJkcVA6LraPyhA4jz4C+bMXsHv5g1khy1m9WADyZD8GGeW0gX?=
 =?us-ascii?Q?nTlg9sooSXPI8LQiFiNKvYMHkvOKIit5e1MxkZku+ExIEh2gRc/Y0KKrCewr?=
 =?us-ascii?Q?E4kbI7MFgqMs642tEx8/RKD8VTB4OjDitjx8odeleW82+3GRWsG8/bNZekWO?=
 =?us-ascii?Q?yl0kv6SVpNjzJajUSvqbu5crWGuOaNc5rJ/dzpSzdZEAmtM9/3PFKdugUI3y?=
 =?us-ascii?Q?jLAr9nkgUvhVKsDpe9R6JQ1KLfCTkwG0Xlmi6nmp1G07wPFv26rPj68dRmmR?=
 =?us-ascii?Q?CVcU5HEOOhy2G0THEVHsuik3MXb7vDX30iPh2FpxEEndp6LoH42yky0n4Tjh?=
 =?us-ascii?Q?423HcCvN3KSDc8JyAeL5HQXhMOtkAqyk6miX+Mv92aLPrzpS5nxsj25Y5mcZ?=
 =?us-ascii?Q?JXtAAKgLpQRUbi2WCf0vPiQJmjIqZJZTSlqRcfp8ehKP58I3QoprmTRLRnnO?=
 =?us-ascii?Q?XKz85im/UhlUeS/TpcqcTm2XIF9Ipp0sGLXsW3oNeqh68bcp1I2mrfFdrVUV?=
 =?us-ascii?Q?MpeCzu7zB1OhoJTiFvemmOXdTMherGFZ3GLfl5yT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc921d2-8e37-4c16-9a85-08dcc82d4925
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 13:20:00.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAItdkMD9dqixVc9odQrtxOtH9du3323zNzkyPvcQy76flBC0TWKEDOtEMWVNmHK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8921

This check was missed, before we can pass a struct iommu_domain to a
driver callback we need to validate that the domain was created by that
driver.

Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index aefde4443671ed..d06bf6e6c19fd2 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -225,7 +225,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
 	    !user_data->len || !ops->domain_alloc_user)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent->auto_domain || !parent->nest_parent)
+	if (parent->auto_domain || !parent->nest_parent ||
+	    parent->common.domain->owner != ops)
 		return ERR_PTR(-EINVAL);
 
 	hwpt_nested = __iommufd_object_alloc(

base-commit: d2138b9e6ff3f3261b68066313b69adc05af1929
-- 
2.46.0


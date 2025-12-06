Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B8313527;
	Sat,  6 Dec 2025 00:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981648; cv=fail; b=TyBULjT8ASCXC0vEUIr5Dw19Qu4xvzmZtoCVEtxfx6NykNlxcKGDtH5jcSzhKiY20SZkfq/YLGu3m7qn7vJnk/VoSWzmuvPexkDk3WyRhOJddehuLTQWC1ti6IWqpfw2u/gwjcjVEHKxtSAbdTKtqRkkyznelo8QYdHChm/oh4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981648; c=relaxed/simple;
	bh=5wtMC3h4AzNMavUM7blsMIpP3aj2JwgITG+wSPMIKDk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IqroziNIRiQVl2WTkl8hUrP65t+EmNqAIN649D8m3sMqWdH4ZY15tAi+X/E0PASiaVYqwWkoTqR4dHeUh/gzJZSjO7mjj8ZcnbbC4MEMVO8ZrpJA/IKvy6j8QGeYN91aJFJ/JT1G8FnGZDzCjDLkshuCIyAZhiuH0EiElGc5bjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KybmMdEB; arc=fail smtp.client-ip=52.101.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KybmMdEB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mECTQGyjlKje5tmo/9UuUUtCv2ZbABbaePIs7IwETK51xabU7TBnkZnj5VRhqvnhyPSP56VXRnu8GorAa6mdxazTN4exmGSz5+vLaEiPBkGFjzguTrPx2UVSWn8is8j44UTL9DCtOcei6aL0OlqdDQq39urjF71k/u8h7UCaKiKSCQXjXN8PD9hnnIRr5QjE8PIcJWHkxaoeYs2K9cAIi5JKl1n3RIcF+HD6F+j7I+QbDHkH6j1tqNsl6LxMx+dDnLGWGAcIxmaWu8Y5mFPEfCBA7zqyjyP2Ty74xPWIFYYpvHAOPmcRu3bW2y/9eOQoqiyjMc6s+HgyEvD1oIGPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrMaBUhwQKKH7rio4UJ1jJDMCap2iPNsalKj9qJ1gEs=;
 b=CTqCaakvwgPglstZw2sI05KuTk+bkaRHx000JhmimTYVqcL7q/RIDNf1jLshhslTVMDw3cyW7Igl0t0v2QnfY8ylweXrKbptZcLfReaPHAqfcSzUBHxRlqae/60SbudddmHXUd4bfKDSPfIbsQQc8eZhO1PP8M8vBTev/8N7uiWF9fMD7PN4FdUF00x1I+tZzcjA7UEdcOlWE2l6p6HVktsUtN8Oe3rS7Iqh1H1DPWblfNhFwMpC2oUaYaEkUS1jQKjYl9g8q41I6Mm8+naFAQRgT4Rz8C71Djym6sNNTJSzTbdDNd8ps2E8ctOTCqY2cY4/TkopviRlrUp9xxmumA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrMaBUhwQKKH7rio4UJ1jJDMCap2iPNsalKj9qJ1gEs=;
 b=KybmMdEBGJyfs6kg3+QCJ7pfgBkL0HxQG1xu2Uu/yBxm/+pIbxqZboOL6WzNVcMAV2txNKT2EDg0ScBZBWO8415iBVxnGPKBI/KqFkNKxuZmPgAGP8zp5JiFEhKGWctvuTRfnQdyeAACU5CpiDEnQrdl+NK4CUtmHLHlCe7QMTosHjSVe7wpp5u7JM1H7AidvQovz4IduDS+0pkLKb/+6VC6qjgBwD9QbKsykhwafJJOAYVBXYIkzbFvZg9H2LUhis2LishA1+D04qV2jxXna4O9RetXzyzOs0SjOhLuWYZ0jQaGaQ5UX3ghhZlWbPWViTNygAZeizDzkl/KWWr/2w==
Received: from MW4PR12MB7119.namprd12.prod.outlook.com (2603:10b6:303:220::21)
 by CYYPR12MB9014.namprd12.prod.outlook.com (2603:10b6:930:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Sat, 6 Dec
 2025 00:40:43 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW4PR12MB7119.namprd12.prod.outlook.com (2603:10b6:303:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 00:40:41 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 00:40:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	"Lai, Yi" <yi1.lai@linux.intel.com>
Subject: [PATCH] iommufd/selftest: Do not leak the hwpt if IOMMU_TEST_OP_MD_CHECK_MAP fails
Date: Fri,  5 Dec 2025 20:40:40 -0400
Message-ID: <0-v1-c8ed57e24380+44ae-iommufd_selftest_hwpt_leak_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0696.namprd03.prod.outlook.com
 (2603:10b6:408:ef::11) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	MN2PR12MB3613:EE_|MW4PR12MB7119:EE_|CYYPR12MB9014:EE_
X-MS-Office365-Filtering-Correlation-Id: 7781ccf8-b55b-4e06-392b-08de34601583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Py6o4TKW9F/fU1F0tHqeXV2+MHp90esjJ7KOzKpGIRpYg7QeeyfZKHirFdr?=
 =?us-ascii?Q?9umwSJiOsu5I6VdHm5eVBE78pqFiuGwe00zG/hsJrxV5YCq+3RMXOEdj4Pnw?=
 =?us-ascii?Q?6YIzCOvv/Ky7dj5AF5Srpd/1Ol0BfRklzR8Z6RNSUTVNsIwX1QP5K373TMV+?=
 =?us-ascii?Q?5N8KV6wfO0Zb5HtIB1EH4EVkJksDxDlWWPJA/jSM8SzQioCAc2o3O5zPY2+R?=
 =?us-ascii?Q?JRHbf/ffm5NfRXQphEKcRq8q5mvHIXjQxm908Swxp/vlG+cK0lnxmqWhCMXb?=
 =?us-ascii?Q?hqaiIFIyZv1fdTCxQoE8Mu9iyzBSTIU0NIn6NNUsPWgwYverK/bB2iv/3Uk3?=
 =?us-ascii?Q?BoE6+xIJkvQgK3A5NPAs2WD/K9XYrJjH0qIBb66J2bmWJyr6IYGNVZr6FHhm?=
 =?us-ascii?Q?6mWDP/b8uZVRmAqnU3P/GqMgVgzqR9kbnt4Mv40dyPe2gc/Z5hhH7MhS3Ubw?=
 =?us-ascii?Q?aQD4HNO/5UwY0I00V56tAs0kzmRdxOPGcfzs5+XKX0DZu+6SlR9KIKUOQD6z?=
 =?us-ascii?Q?l0nrketLsHjr4avaGSrJOgr4hji4dCr4opCcNDAomdp35r+CRrDxrWVxDfXH?=
 =?us-ascii?Q?QXKaP/tWTTDffsqKAzVQx+M0dFdPgNGyDHWyc4VVWBFZv2gIUt7yET0SaFUb?=
 =?us-ascii?Q?3jDXgkZuJaiuICrpz4YyjuFST4w2BCSqkV3Y99s0ydkO5cHPsDNxXye9sbFL?=
 =?us-ascii?Q?TtNHEcxAEs59FRds2RgeOVVpJuHfAUuZ3XkHtYr5QZJ47izDceqcxTgj5Rti?=
 =?us-ascii?Q?vBr3em2y2BLK/Sy7BhN/Vz6tLqpYLIca/vg/tDZGskV5t0BABqsfOLkSGS2c?=
 =?us-ascii?Q?wtAVeB7wgRQPbAirxCfK4p6vRfiJ00VSiBjHAWcMOychJncnQx3xr1NEtzs6?=
 =?us-ascii?Q?KRZVGjpB8goC1qUZ9r0fenkdyzTCVQmqyM+AZNu7WgbcOQZ5YqWif/Y8zwCY?=
 =?us-ascii?Q?GpIBHtUpkGaJS/f9xMtqoACG/jyLDBCA45oT6tO/Hj0TelFLYpgOESgLB5MI?=
 =?us-ascii?Q?h1tqtPWraDE9aLi+gazJ/P0360G3SmjlMA90uPNIDwCAa2di2CgZ4Ua0857G?=
 =?us-ascii?Q?tFjCGaHAu46cOT2Th7dsf7hsrVES30HcuLvUwN0dH8v1Wub78Xi2Q3TAFjFB?=
 =?us-ascii?Q?X/D93z8u+M19nACMZwiCBH42W3JQHF2oUwU3jZZZGtvTucji8e+7VPGtYPJl?=
 =?us-ascii?Q?bQIuCyMn/Iz2eUu+meTb5cux3m53QWoDlsPEdpLHWpRhn3k3j2CFr/+kzmo8?=
 =?us-ascii?Q?1FHbSgKVZAnBIbmEJni2TFQUY+B8uQNHfpgaI5S591Gbdjbvq/NFcNZXnIsN?=
 =?us-ascii?Q?uY5x3eUxiwPmz1Kpuy49ZdVqswzI5yCNMepqee2cn7S474shgLuRhIeY5RPu?=
 =?us-ascii?Q?CkIYDHNdN2WL54LZQEhzH6zFTkIA0R9RYZuJp89Ap4YvC0f798wVa3gtn24O?=
 =?us-ascii?Q?lOgzZclAES5t+5fw1n/igUxbfpg9LcKb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7119.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aFSIGpbeIO/+Rn5jNawdyjqnEl4klVnzV2Enn7J80dkFyFOpiGCrPNpxKIN/?=
 =?us-ascii?Q?3L5GbRr1kLHl1KbhQTYb1OsqulpylKpYFTvT7vaZjqbx/m7s4b+hstPseai3?=
 =?us-ascii?Q?UYB9c15R/lrVEiswXwCkDVIkaiW1KowKtqHcL05drtkRQyiLwRLGYDTJtyx+?=
 =?us-ascii?Q?f4ubZyFR5Bl6feXXOfbSfu4LyGmugDeQRtky2ioYnEmMIzxRy9HWwjdBCTwW?=
 =?us-ascii?Q?q18uant7ccyRQRl4t60v6m64FA87LOF61QPPzJi+sCSC40Hdc7gtAP7xVlGD?=
 =?us-ascii?Q?o5YXJ+jMEgX5nZaiYqAAbyHzIRLQ4D8RI8RexpAGiARekTx1osQScCrTBQAL?=
 =?us-ascii?Q?I7FGdrI1k6+2uOtYxkS/G0r+k6maJxKcS+VqhGMo08DAe4cVDrOl92aL7UJ7?=
 =?us-ascii?Q?ywkkUifDEyYxTf/yAv2mMST4by0Pxe6K+B004H1W7oS2bNajvPtjWV8xpUzx?=
 =?us-ascii?Q?yvROr2s3MGnIjy9h+CecUcbHpU7dboRpH5DEprr5fUM7jLSBMkiC5iLh9aTA?=
 =?us-ascii?Q?KvSIfkbIGduUJ5QuKbx6W9pNw1qKssul3CaTL6DjX4x9mxdROt96mXy1GW6x?=
 =?us-ascii?Q?0POKK1YaxD61biOjz2Lg7r7JFtZQq2Iom3Ia2ajsldEr93n0xotuupnWgWZg?=
 =?us-ascii?Q?NdQe4lVQt/+L6isOUbh3jjwYjOGPNzwyoDuEx8T0SaVz5Dspsn10zgm9KfhX?=
 =?us-ascii?Q?aEp/hhFl0Suyf7HZIyJSvM7IYacF9T9tTJDlg9P63uizjYWB/ImwtE0Lxy/R?=
 =?us-ascii?Q?8joNtaWgPTqqQCd9YWWKVxgI7KY1nCy2Z2aF1vKRgb1ShPX4bzO5y+EhJVY2?=
 =?us-ascii?Q?O/2nfkVRztyLbE6WKomOfRsDa38dZzhthhvrYsvhoU4iNGV9XEbse8meXvqc?=
 =?us-ascii?Q?Cc5siLDrADHQPBmDU08h67vifjbMzVzNhn/+8Zkh2G2ev8zs5na9JtpdxNMb?=
 =?us-ascii?Q?KVLZxuzU1JTJNEV5x+YX33rA+nk1njhCLpRY69cVcIl+cqVkfnpzFBLQDEKR?=
 =?us-ascii?Q?qiVwC7SjOaWxT0rKiftj+RiNkQtJXKPPQK3x3UMYi4yQKyK6yfZ2V5PR5LPR?=
 =?us-ascii?Q?O6qXbZ7uQbaNoBuFnOv9hOjU+ugUxFrdVYYe2OpCiR1wF5LyWKHaWydNFh8N?=
 =?us-ascii?Q?Y8IJn6WvVMVnRfeRnaXT7jeiXyrLPULEgmc9Gg189UU3CRP2Igqr3dXPnAb9?=
 =?us-ascii?Q?t+6IewzSBksS8+uzKzKgPwd8Nnblr4ZimJKYdHKGyi5q6wRFD6/3YTjV2EWj?=
 =?us-ascii?Q?x68H7nOVFYvHmMsLgJhMf2huCWucgBgewI23xw3v+SX+Vk3xpBXlLQunhrUW?=
 =?us-ascii?Q?JOoVCkj7pYFJ7TbfD3oR24EyQo34qJFKRqGSDYXacjbAAVbl+bWvQaA2QEG7?=
 =?us-ascii?Q?7exnLwmzRPNhfaYVqYw3VlBMrOzSgCnx7uysjaNaZpk3PI6OTJHyzqeqCSjD?=
 =?us-ascii?Q?0ZAt6Dq319rxF5KAvMbgopCRjSOc4XulorrnW9KRQjjyptmGgxa+vLfNIRLr?=
 =?us-ascii?Q?RN9no0eQ9EXZAJHzfimHCt5VCKVoyXekOZ0M1bBK17nN3MgF4B7GPWB2M/eR?=
 =?us-ascii?Q?iCZ2tXkk7muXSzEraJs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7781ccf8-b55b-4e06-392b-08de34601583
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 00:40:41.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RzvPE2dCMLGXRImSOPNdPQPmpqU6t4vTMVSHaKe6NtepsOwySbs32Pl07SkfOOGb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9014

If the input validation fails it returned without freeing the hwpt
refcount causing a leak. This triggers a WARN_ON when closing the fd:

  WARNING: drivers/iommu/iommufd/main.c:369 at iommufd_fops_release+0x385/0x430, CPU#1: repro/724

Found by szykaller.

Fixes: e93d5945ed5b ("iommufd: Change the selftest to use iommupt instead of xarray")
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/r/aTJGMaqwQK0ASj0G@ly-workstation
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index c4322fd26f93e5..86446e1537949a 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1215,8 +1215,10 @@ static int iommufd_test_md_check_pa(struct iommufd_ucmd *ucmd,
 	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
 	if (iova % page_size || length % page_size ||
 	    (uintptr_t)uptr % page_size ||
-	    check_add_overflow((uintptr_t)uptr, (uintptr_t)length, &end))
-		return -EINVAL;
+	    check_add_overflow((uintptr_t)uptr, (uintptr_t)length, &end)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
 
 	for (; length; length -= page_size) {
 		struct page *pages[1];

base-commit: 63a2cffb09da7ec83868042eb9cd2285fa17cafe
-- 
2.43.0


Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74548326D65;
	Thu, 27 Nov 2025 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764287659; cv=fail; b=ckj79s51TAlckfE4MxzPxDgqD4LyFvcwvn2WIv8xvl/5ZT051gIJEjoNlisNpLuiwjifwJ0dPjDoJEF9pEs1LSaOAZLm0UBFteqcJ1p2YfNQGQNHQWZRJGMYszsgrOzFI0ZxIrEqPbQeJsFPKZ020PyGHy6Nr4ok6WL7zQIkFEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764287659; c=relaxed/simple;
	bh=QcJnjXes4ILfoYKPRLsaNZ4q1qved+kBl5odBQYR9ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hxSZ/bdPgMOFfkScpYJTvziHt+AK3hjDtw7kYfKyx4YDXHf/nPPXgRS138Fxjz1XZt4CW/+d/jmObMXmGFc0v7DlqUEO5pyUx4hzxqrL/rxaj2MrdF8aJSGngX7LIym79hOLDdcUP0OIHej4KU3vuLMSoV55PslKWKvN+Tb5Qs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EuKjuG4j; arc=fail smtp.client-ip=40.93.196.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EuKjuG4j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWAiwdT4YrRyF5OfVkxdCu/XT00cjRmOukEbGLeWpT6mryx03WxOrvcT3AmZYlDzQu5Brfe71eVI5P0DgJUtJHn8CYVGWo9ZF6oW1P/Z9PZfIA0J6mrVHKzMNj6ssQtsDQKxJJ4g8JK30E9+tj3G4kZMpYDo9paRSeyLJNx/fhIJ1VQXvbZX5sxbEZ8Y9hXViCyoTzaZV87RQYwC5YsS1DK1guKfkWjC9jc9E55DNLScRAbOKamkXRd2Rs5NZPzV6+6T4+hQV8qHSCxyDv2aY6PFYR/wKP5AyjhK45SHtENnraIVvLpfUQKxYDveeiNM7A49d1Fzoz3DurhnBBHdKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f95ZjCQl3CZmXAXnk2StlBE0F9sgg+7R1vY//ZfAzF8=;
 b=UQzPehKpfDSsr8qSwr6Ch9egZiJwzak90SnCZKmrLaXC1Ls1ES4hTZyaJCSggPNG+fBfSJuEGOlx5Vjcote6VW2rmoBIwvNikO6jtRlGIZg7y5p8dllUKv1u8HUoCkrJ40egHhAaeviZ2Wgz0f8Vo0PadyjHtSMv8TcIK89lsDGJ1o/Tm+qFY7vw/7bMISm99RbF8kZz3OYaJYGW/Cm7rqj4oMZ5DkZg1kUSs0uXMAxa2Q13NBaad2Gbu7jiNupOe0wwDhZ8jU8qNIe7Cz9955c1CAShPi8A1C0UO56q1Gp4NAZRVwW7ysOeGBduRsOxgfgcALRL+Sm8nlMV1KslGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f95ZjCQl3CZmXAXnk2StlBE0F9sgg+7R1vY//ZfAzF8=;
 b=EuKjuG4jVx7AdbI/dxyLckk//jAx8WzPx0pu9YzK8+2QKqNRRolSIUIesBiI4gMYT+wO9GYHozD21SPKrlu2mprwp1GMVbT/mqikYIbJ5AmKOHpqiwhI8XpBbxZy4D7L6SAKalf6THbltGl1sncBUseHtomWAcVaaZWftCTaFWL9+Qdok/ehLPWOddEYEZcC8q2tCUzTIIkTR22aGFLI89DQPyvxoOQQ7F+KKhiQeula+R71bVBLeiKIVoQ9OiThmdWFucxKgMOKISBSt/W9zDMAOLRzZCGi/Ii1czHYJGt/WM2xbTGvavFmOLn+5ReMdUIHaffnmW3QNtye7SKWDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Thu, 27 Nov
 2025 23:54:10 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 23:54:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 2/2] iommupt/vtd: Support mgaw's less than a 4 level walk for first stage
Date: Thu, 27 Nov 2025 19:54:08 -0400
Message-ID: <2-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
In-Reply-To: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0064.namprd16.prod.outlook.com
 (2603:10b6:208:234::33) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 387f4959-b95f-47d2-bee8-08de2e10421e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f+mykR1tnc8jHsBWb1yDmuME3iGYGPVXZZO5gUZI7QfI19u8RuXTY7WTWcJQ?=
 =?us-ascii?Q?E8pK6YQy5QtILhOw0XJAJocBjRk0HLc6ofoGP6EAmodHJfBNf0FZ3mWXFx1z?=
 =?us-ascii?Q?UibZMLAmvNqJkXIfogooT2UdrwNXW6rKGDMI1ohB4IZXysaGs8xam/O98SRr?=
 =?us-ascii?Q?wjFaHouzalF3gTgUXlHYK8QU+eaddlMA5j05VAQkY+AHXURfKWljT/XDk2zI?=
 =?us-ascii?Q?40j5zSHvvaAWOYlSHmHr3Y/AtOoHqoQunkHKdRFPV5I+PrKZRmMV2JjOBX1T?=
 =?us-ascii?Q?D83lZCzCEhtXs/tHTt+eoqrpoqSwymdWpw795/FISMJ3chO6bxqyHFxm/B5+?=
 =?us-ascii?Q?VB/x0vTlULE3xadsnH2q+X4YKjW9ZuiU+rzpRJJ/OjvafnrfP+woB0V2v6ZV?=
 =?us-ascii?Q?46o0etCtqa3OL94HN+dxnHyOZ74/j8ZQDfG8u/IRPCHfPHjbeWY+sFwpboX4?=
 =?us-ascii?Q?hQI5R2SSNEA7EAuwFoDIOuwhSNB8rGP/IDzx01CNGwHPT6zK3tN8wX4Y3mS5?=
 =?us-ascii?Q?VmZMVkwnw+4ml1ei/y6EcBoqZwaunVhA44WaLsVEjbIbmdaW2v3Kc3YiRcn4?=
 =?us-ascii?Q?PkCYTbssfaNF2nenzMNsPzTjr2nhvUnFNgz7bMRTR+uZhpDfLFD5C273Si1M?=
 =?us-ascii?Q?nRwV3jZPSNhQ/wMJcm29u3/jZIGwyuG5osBKi4w8BPDWYXKrBGWDov+SFe/j?=
 =?us-ascii?Q?qYPAOTtosNUWRvJ+z94+1bGU/DI0N9VcW4NRFkJiqVLdZTjLrRTnlFRReY+c?=
 =?us-ascii?Q?2umCgqeyGMvJm/Ga3JJt0gnJvDypzVF1n9pCjhydgnCPDqFKj8m1ntpuxsbs?=
 =?us-ascii?Q?dn7+lcXgQPMTl8oKMLfN9sqVbdNeaBk9GzY4t9sVDxgBErOAXXcbSOujDi+6?=
 =?us-ascii?Q?q631uuR+voIBpwC4I/zom4PRcldsJnlFobvoe9P/Lpu2okeSKO9JZkfdESYm?=
 =?us-ascii?Q?p/YXY4sJ7Jk2cLJ8IDjWtDlbRMCnD/n40RInwil4y+lcMzqEV3P5fA3nhooL?=
 =?us-ascii?Q?+IaULfH+UTifPijszQlKEbzCYq2ApfUehOUBBDcU80eNrroONUQP4adSVO+j?=
 =?us-ascii?Q?VszfhJ6N2ELxJmGdfLgSvUF3tWT16N+7C/eSfsMTrmXVMscPWPjBQEt6OEya?=
 =?us-ascii?Q?7q9hWJsrFxrDsWSJiRrSSCFdLQap8intyx891JE4eJnxWeKiDwMlfZ5N/7mQ?=
 =?us-ascii?Q?leSB3Ui3IWd8RFldaGmxQ2yw47ts/agTfrkRQJs1amnhTBY9suGMlPgnwMif?=
 =?us-ascii?Q?ZckpP5q78D+WqfzrvZXXPVR2s5mEzByWtJTfZ+rvScI1kgAPi2cjNGWKkYjy?=
 =?us-ascii?Q?oDuXdD56u+rL65Ji+brvJm6ClJemhsCBfz8Xl2JfhP4BRA63RQ19QQZQzpEN?=
 =?us-ascii?Q?JLudoyewArXWrCsWlBVgizNDOiQ0y95yHJcT5VZucK2M26w/Kxf6+SAqmJEX?=
 =?us-ascii?Q?smwa+MhxqHLzDQLAU0rYkxRvvby2KwhN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HmLtPTNIjsyckjDv/E1IJMM9u0zD+YDFWa+4s+LGp9NDFUqTTUWP/MEm8lAv?=
 =?us-ascii?Q?dI/gFvAsZjdZy+HOlXZLLAvkUYFabB3QEo/h4KA3FshG/3g/nhPr0nD6R3FP?=
 =?us-ascii?Q?Wtb7i/H3NLFe/km2RHFabQKUpXK61ik+FZF+NLfhboklJMT1U7ENtaJBGtrN?=
 =?us-ascii?Q?LRCy1UCwIpPmVzTvhwrRJ5rpWc7CL76cOTsyEqxjYUAWmOw16lhvE7w3syuz?=
 =?us-ascii?Q?pETa2jQcCRVVow9XRt4NDZtxSlzeQvKZ3SUcJznB2q+KVC9ZIDUu5ynRTlSL?=
 =?us-ascii?Q?0/wKtrpXGu0zzUgt/mm2ccs9cv82qh032WuoHKA1j7MAARqK1rGIalSlNjIK?=
 =?us-ascii?Q?T5zkk/BTR8q8Kzq7jwNR/abAONAWDqTDgeq/ObJkLFymBfm3TIeb7QOQmTT4?=
 =?us-ascii?Q?wZbPSCxXwzQKc08BgTjzEtCYrXFGnvjoupczyr2JoxqfwS/kdIdtDBaZCAvM?=
 =?us-ascii?Q?HKNHAHJF1Jss8oBKmudT7p54MAyyYzuPfYwA4TZpdHwOLy/1qrIkoE2fKKRs?=
 =?us-ascii?Q?Fk556hI4UI1B2QzbmkieX/vwsRpeNS3p/o7QSFo6FhBQyoBQJngu9u0BHcIs?=
 =?us-ascii?Q?Ohqa7OZIYoUQ0KKsXxffHqrWDpFjERydRynKb5buMNKmQ81Ie596tuILObm8?=
 =?us-ascii?Q?YUEVewiCKw1fyfmfeRqfnE/KK43j9AQhfQwQCcrxs4zhX0owthT/3tummX+Q?=
 =?us-ascii?Q?WPSbVH/UOdjotEV49cC1xQyJjsHuuKeUpIQlG89iQWXqDiZv/D8R/IEsbqG+?=
 =?us-ascii?Q?EFr2aSlReSGUFTWmkR072TU5p5s0UeeKqT4TnU2wi1VvWatAp95gSYhujdvR?=
 =?us-ascii?Q?7Y/rnOmPB9zvQoJHdr0xZRT7fsX122gjOQ8U9YWhMZeFc5AnyxchOYpMoOST?=
 =?us-ascii?Q?k+NiMWi2RrMPxvpGScpYph2ZAGXDmSWIOe3VI1t/YLkrrgjbSEDFb5U1tegk?=
 =?us-ascii?Q?3fiFUSA0fT5HDsxqYVDm6vI2pcqsIpA4bKQ9Wy7V/kv0x60YVBk6gzM40T4Q?=
 =?us-ascii?Q?x9EKP7ewbMBGFel6oLYUzQY74gZKSwxQZ4nppF6/mMZYrATIs5KuYXO4QQad?=
 =?us-ascii?Q?H1O73P1Gw/JpRBEhWL9xZLkQSutDezXCuDmhWc898CzpsPAmjhQCq6a4Qd4Q?=
 =?us-ascii?Q?yyDwelsh1gz+JDBlpPwAh5QyAGgJ0SYTQCIyOsLQfMTBRl3NhIev15paB7T1?=
 =?us-ascii?Q?YzUVUlhEdxH5bHfmXklcjoMBErEHLlqF68sp5ldwapIV1mH+65jv5E9ufJiI?=
 =?us-ascii?Q?sdMRkAyuEJQ1LZhzcojyFWottWaRC0mVBXV9FsM3M/mTU9cfWVVs5b7zeP8G?=
 =?us-ascii?Q?hePqoquD0kI0U2eXbzazk6koHI2aiaeua+gFJtbfDJnXMMymrftVK5wtPrNg?=
 =?us-ascii?Q?ecLNw6PcoEpoJ2Ufc629njgpxw/js6Z2v8ZdT954SMcbmhtPI7iEg4u4BcWf?=
 =?us-ascii?Q?ab3TAbCSvVTRxPjOjmXefn7YgstdaNESBYD0BKDZfmk1SdXgP3BWRV9U6Re3?=
 =?us-ascii?Q?wfoLTNwD32nBKk2DjxJ0IPZ6KYKUDlq3J5XJUhFp+qEVs9MKVwGNbAWvAlAc?=
 =?us-ascii?Q?Cef4oUih/ckN1Hv7ODM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387f4959-b95f-47d2-bee8-08de2e10421e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 23:54:09.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOGg7z4mngk3sY8FopKCHQhEGOsLR/6baBBsO80NQqlW4QuXbh+QP1yhjS1lv9S7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

If the IOVA is limited to less than 48 the page table will be constructed
with a 3 level configuration which is unsupported by hardware.

Like the second stage the caller needs to pass in both the top_level an
the vasz to specify a table that has more levels than required to hold the
IOVA range.

Fixes: 6cbc09b7719e ("iommu/vt-d: Restore previous domain::aperture_end calculation")
Reported-by: Calvin Owens <calvin@wbinvd.org>
Closes: https://lore.kernel.org/r/8f257d2651eb8a4358fcbd47b0145002e5f1d638.1764237717.git.calvin@wbinvd.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c             |  7 +++--
 drivers/iommu/generic_pt/fmt/x86_64.h | 17 +++++-------
 drivers/iommu/intel/iommu.c           | 38 +++++++++++++++++----------
 include/linux/generic_pt/iommu.h      |  2 ++
 4 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 48bca4dc8eb61f..273951b4501cd5 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2708,10 +2708,13 @@ static struct iommu_domain *amd_iommu_domain_alloc_paging_v2(struct device *dev,
 	 * in both modes the top bit is removed and PT_FEAT_SIGN_EXTEND is not
 	 * set which creates a table that is compatible in both modes.
 	 */
-	if (amd_iommu_gpt_level == PAGE_MODE_5_LEVEL)
+	if (amd_iommu_gpt_level == PAGE_MODE_5_LEVEL) {
 		cfg.common.hw_max_vasz_lg2 = 56;
-	else
+		cfg.top_level = 4;
+	} else {
 		cfg.common.hw_max_vasz_lg2 = 47;
+		cfg.top_level = 3;
+	}
 	cfg.common.hw_max_oasz_lg2 = 52;
 	domain->domain.ops = &amdv2_ops;
 
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index 507abf2c934ccb..210748d9d6e8aa 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -241,13 +241,10 @@ x86_64_pt_iommu_fmt_init(struct pt_iommu_x86_64 *iommu_table,
 {
 	struct pt_x86_64 *table = &iommu_table->x86_64_pt;
 
-	if (cfg->common.hw_max_vasz_lg2 < 31 ||
-	    cfg->common.hw_max_vasz_lg2 > 57)
-		return -EINVAL;
+	if (cfg->top_level < 3 || cfg->top_level > 4)
+		return -EOPNOTSUPP;
 
-	/* Top of 2, 3, 4 */
-	pt_top_set_level(&table->common,
-			 (cfg->common.hw_max_vasz_lg2 - 31) / 9 + 2);
+	pt_top_set_level(&table->common, cfg->top_level);
 
 	table->common.max_oasz_lg2 =
 		min(PT_MAX_OUTPUT_ADDRESS_LG2, cfg->common.hw_max_oasz_lg2);
@@ -269,12 +266,12 @@ x86_64_pt_iommu_fmt_hw_info(struct pt_iommu_x86_64 *table,
 #if defined(GENERIC_PT_KUNIT)
 static const struct pt_iommu_x86_64_cfg x86_64_kunit_fmt_cfgs[] = {
 	[0] = { .common.features = BIT(PT_FEAT_SIGN_EXTEND),
-		.common.hw_max_vasz_lg2 = 48 },
+		.common.hw_max_vasz_lg2 = 48, .top_level = 3 },
 	[1] = { .common.features = BIT(PT_FEAT_SIGN_EXTEND),
-		.common.hw_max_vasz_lg2 = 57 },
+		.common.hw_max_vasz_lg2 = 57, .top_level = 4 },
 	/* AMD IOMMU PASID 0 formats with no SIGN_EXTEND */
-	[2] = { .common.hw_max_vasz_lg2 = 47 },
-	[3] = { .common.hw_max_vasz_lg2 = 56 },
+	[2] = { .common.hw_max_vasz_lg2 = 47, .top_level = 3 },
+	[3] = { .common.hw_max_vasz_lg2 = 56, .top_level = 4},
 };
 #define kunit_fmt_cfgs x86_64_kunit_fmt_cfgs
 enum { KUNIT_FMT_FEATURES =  BIT(PT_FEAT_SIGN_EXTEND)};
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f117349d67dbf8..4e888867e85c03 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2794,6 +2794,28 @@ static struct dmar_domain *paging_domain_alloc(void)
 	return domain;
 }
 
+static unsigned int compute_vasz_lg2_fs(struct intel_iommu *iommu,
+					unsigned int *top_level)
+{
+	unsigned int mgaw = cap_mgaw(iommu->cap);
+
+	/*
+	 * Spec 3.6 First-Stage Translation:
+	 *
+	 * Software must limit addresses to less than the minimum of MGAW
+	 * and the lower canonical address width implied by FSPM (i.e.,
+	 * 47-bit when FSPM is 4-level and 56-bit when FSPM is 5-level).
+	 */
+	if (mgaw > 48 && cap_fl5lp_support(iommu->cap)) {
+		*top_level = 4;
+		return min(57, mgaw);
+	}
+
+	/* Four level is always supported */
+	*top_level = 3;
+	return min(48, mgaw);
+}
+
 static struct iommu_domain *
 intel_iommu_domain_alloc_first_stage(struct device *dev,
 				     struct intel_iommu *iommu, u32 flags)
@@ -2813,20 +2835,8 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
 
-	if (cap_fl5lp_support(iommu->cap))
-		cfg.common.hw_max_vasz_lg2 = 57;
-	else
-		cfg.common.hw_max_vasz_lg2 = 48;
-
-	/*
-	 * Spec 3.6 First-Stage Translation:
-	 *
-	 * Software must limit addresses to less than the minimum of MGAW
-	 * and the lower canonical address width implied by FSPM (i.e.,
-	 * 47-bit when FSPM is 4-level and 56-bit when FSPM is 5-level).
-	 */
-	cfg.common.hw_max_vasz_lg2 = min(cap_mgaw(iommu->cap),
-					 cfg.common.hw_max_vasz_lg2);
+	cfg.common.hw_max_vasz_lg2 =
+		compute_vasz_lg2_fs(iommu, &cfg.top_level);
 	cfg.common.hw_max_oasz_lg2 = 52;
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
 			      BIT(PT_FEAT_FLUSH_RANGE);
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index c134132ed10f89..9eefbb74efd087 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -277,6 +277,8 @@ IOMMU_FORMAT(vtdss, vtdss_pt);
 
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
+	/* 4 is a 57 bit 5 level table */
+	unsigned int top_level;
 };
 
 struct pt_iommu_x86_64_hw_info {
-- 
2.43.0


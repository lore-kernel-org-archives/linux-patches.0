Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145A92472B6;
	Thu, 12 Jun 2025 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738715; cv=fail; b=Tj5/Ca3fPEQ7fB3gA6CaEETzE3VQ0yCm97ZQbd+GZ058i54eLZE9/aRqIe+a9THUkIpaGXEss9Ek5G97L88Wb9FeBah3S0NK05vYiVk7yR0Rhu6yZ2Pw9atPIeGbFraFqlDO17Fv9JLkigs39sjoq/L0Fe8rRmWEZzWSj89h/Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738715; c=relaxed/simple;
	bh=mb3+b85ZhCf1tqe6JL39yLWPEogUFz9/C2CE64YPwGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W9nmE6uaeTIOYY6CfyZAIqvYx7YUY7u2TbXHlmZcf35pMzSpwJoF9RWsIBy8jckbFo3L50KEmVmo03v8u4b+D+MrUMZYB4yP7cm9tNgIhCLad8L+Tlacqbu9ZqOaBe19gDUwTZUMfphMCnEVUMKA2ZX48aO/Qs/x8X7fln4xYe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rAd63zvB; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rAd63zvB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOO1hqwqt6Mr1BZWIiDgkeMTvUDx6sp4zE+32F29lnFfDjqKQASQ6nHflHsK0CVGvJeafCSUIbm3dixdnrT9RrduPAxi091PTWPO3WNuhriqEWWtfukChfen61SL5AaGhVyN76S9+kzRVkGMiBf/nU41gl7LSw5fWo9jFfKqIvzZcKy7uCFlF5XgDnSezMoInveRpt0kd1tl6cAqBAdx3k8Oj/hl6jUWMwf9BNanGaDmDsZA6NDPAlOsumhtqp8WnBf0ToFoWRgpeVHzNULIkWnh4+4xxokYr2MtJUrgn6e0cYuq3S+XEjmiOrLsOqsUBlGmMCAVDqD7Nu0I87bIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tybGq1DmcV0ODoKpJY/UxoIOHaA6jqFZTVs5fOqJFxg=;
 b=jEK3M3u9rCOB3xcwzy6241XTij26qeeH8XI8jOSCREMObtqczH5+ruDsfW+BC1vWT3cVBxNUazN7pW5IQyw27KhFhIvxBg8ZJKQS/8kgwdy8PpFsFqQEwQkdAdEFwcLAKK+lSm1IBUFQdgbZ7DHZUbOnLy4dF8NmAvFR9FTJUZkGJy/ytAcOZOgLXxmSjo1Fc++vZbq+8wQURVGNFGNtvy5RhkB0iHYi3LGc+HBVHFsONY7waCVG9uNelywiRObyzYOs7osJXywFjxB1yOOvbvInCqEIscVRngpJv2KoI1LPMj1zFVp58WypP5VqIyGElFFT6pOKfqWIlLlB9AOqKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tybGq1DmcV0ODoKpJY/UxoIOHaA6jqFZTVs5fOqJFxg=;
 b=rAd63zvBZg0ic85U7EW3b7j//U8RoD2sHer9D9BqJjNMPF7LFRZ6+Lf0oMSrm7V0k+Fx9TK3R7Z6JVX2CxQ37KyeuVAeo1sUhiv+xUH2ISXPLoRomenTrY+N0UjU0jtib6vpWwYcdWr2BPmehRr4uPamOkq/XzoZ5rGNWI/uX18LOFiXMJoW5rrlFAOiR44oPima0BVjuY3M2EFXo3U90gfnDgr+2q2OWR5uVEF5JQzuEwv8Bd8FORyWkqfKnWkfqtvns24pVmpqnkaPuSyAf3h72nyzFuRGsHfmBZ75BAHuJEzLSyvxGUAzwVE+VzzhWX5a4uhk/0dt1151GqSuvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 6/7] iommu/vt-d: Split intel_iommu_enforce_cache_coherency()
Date: Thu, 12 Jun 2025 11:31:38 -0300
Message-ID: <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0328.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 6042a8b3-c00d-47b6-87ba-08dda9bdd973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+UbBc7EB8AyAxWAF5g66cbQWH+9ldDWX4oqxKi2k8it35BosoSv92j9eZGH+?=
 =?us-ascii?Q?rcPrPAzY3Wj3NnF4rSx6AEh5tetaZww3oDQRstFLoVfD8gPgmWYa48KKesJr?=
 =?us-ascii?Q?seIcXvOTL1OGhOReCxCpQ67SS9gylI3zcf5wNVWUUo6f1WeorZD8P9GjUFaV?=
 =?us-ascii?Q?v2zRbeaANdN+Hjb4Tx7lPCvWTb/X/GL7HSqM8EPVgWQpDQ2DbWnDAo8m/Ymk?=
 =?us-ascii?Q?KEb/BbPaTe+mAPZlZa1S/OupWeLBTP9T9L4ZNQ7vg6NRLoY7jLHi0EV857JV?=
 =?us-ascii?Q?ZidN7Ul1eVs4SzXAWCoo7BWUiZW2+CMzuqlfHhTOAvrf0Xz2HtKNB/YV6Bel?=
 =?us-ascii?Q?4yrxxrQY+LE5L36J1dV9c/erVRDNTXUAhw9m/9GmmuPXnvzP+ZGO53TehbeO?=
 =?us-ascii?Q?ii47XWz+7rQsH0FIz3K0UqJc5txc1fCeRjtORPOtSqkEobb7kGg5koRcFe5K?=
 =?us-ascii?Q?cqL6WyxiAAvq9t2FeC1TCjKkCqxoYseIS3/h9/Rd5oEL2xpyOOsVZFT59MGH?=
 =?us-ascii?Q?XzFxHnFZXqw4bXr2V7gW6P86NBX+cC0vEkAHgqjMnrjbTrXzlIibqipqkCUb?=
 =?us-ascii?Q?Apm+Wt087ZuPqqpOmLK4OYWcSyRF3plag0axWV32pURsA6zGjupb8BHqCqWS?=
 =?us-ascii?Q?BIyVqgnjUUjshFx7XW8zM0cIBJTH6r5fwYaFBBv2ijj8Td03xVl4ipQgD7an?=
 =?us-ascii?Q?ZwMWmHA7fGswQXjlLgu1C+ircpJjLfhlbeeIYebGsrMST+fn6QAFFiRbdiVs?=
 =?us-ascii?Q?uhBJr9mFwVqobSovxbkEB6V1mhVTgMW8eO75IeMb1kp9l84eu6DAyU+55+XV?=
 =?us-ascii?Q?xPj4OksgXSnk5V7DZV5EGA7skVM8CirnfJdxhQLdHEGAfIuxy5uAitmi0I/E?=
 =?us-ascii?Q?dhJNhYI9+rnS3Gmp0JUvVQi/RVzDCHekkqD9AyGnoT3huZeBl2pdqPlT7XcR?=
 =?us-ascii?Q?ttoI/OLtHljsFl6bn810SOagW5e9LJNulIpaf066+/Aozmqn1FLpWqwyL/n0?=
 =?us-ascii?Q?Z5J+mb7waMpJY4LHKbZ0VPBQTsaCsj4VcRm7u28FZkxAz9hsUinKDHWEwWrb?=
 =?us-ascii?Q?R7acl4P+TSyVkrKnA+stlLGiFjRsO5sXfIZIR6/zZnEmwzQmYY88IcJRPZoZ?=
 =?us-ascii?Q?uIQE4Y8mjMHJKAuRqHVBXKQs+/gES06hyLEiG9PzNQCKHbtjIJMim3jBff1B?=
 =?us-ascii?Q?RxJWU2TkGqv1arLb8gW2n9w3qxfVi/diR9XANENCNtREAXf5I8MRtBA35L3s?=
 =?us-ascii?Q?ErDcRj412d9jWDiAjb8aUT2os7WeKvxOT2U0ra9JEGGNmEeW8ldTZZU0GnW2?=
 =?us-ascii?Q?o6BLEZnaO/2MovHAGTEZv9h3M0xY+V04NcO9jilyAklzBgojVE+Y9L3rXRdp?=
 =?us-ascii?Q?e/PLrz5d5hrgJfFJsug1r/41XresPwcJS5UoHrfHFOLwFHNSfA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JqpMMBzvGZqW72WUbYqbEPjRaNIiLdgTKaZUQMhYytgDT1aC0Oi/fOED03jQ?=
 =?us-ascii?Q?l6EyR4hzef5We+sVy34U+UeGB2gX6gR5V3sX4MpkHcBig7K45QLDrvph8QU/?=
 =?us-ascii?Q?Z81uA4yQ0A5Kpvkhb9vAd7LeGsNRSrYC4KRoq+EPn1DHuGyGUWlsRE6g3D3C?=
 =?us-ascii?Q?/4oQRVDk9JTkr7S1xnk/Ilquc+TMWvvgYR/RCnEKFStbJcVWirCV79NMiVuY?=
 =?us-ascii?Q?V1QM6sNI6ic3ytCT/asSwD7QuIwY7a85uxcpQrN99tm6wSBoJN/foOmYE/VU?=
 =?us-ascii?Q?+nNTjdqe2vDajuM6oNwlD0Affs2eXxJ97V0nUuJ32Gp2Nu9U8zJ/CqRISR70?=
 =?us-ascii?Q?0X2tKZk2MH9NMDJdGhiMjfEX/4t/nrgF24kyf+fxCv8hk3G20h6YGZYLsnrF?=
 =?us-ascii?Q?AVRl7LFE2aALfbsNdgZ1/RnendHxFal8C1NUFV+j4avVcddX0U6YdvkDPQqz?=
 =?us-ascii?Q?xcTBj1hxbW6Mlj1mV2ixo+NuPoW6oU7xr4r/IUrXG981mAcv7dp3mUTpgQ/G?=
 =?us-ascii?Q?AR0KOiWGJleWR71OOQZq/Ztzz1pFmqWNEnNipLdSQrcDceUzWpHjNCxPinOs?=
 =?us-ascii?Q?olqiia2Fh7P4R/zBzmXoag7bGbah4U7C9bRbSZ+SqaQ2LRjnXXVXinTvd5q9?=
 =?us-ascii?Q?YnLbiXr+QPx/bjzPbqt89mc3AkFgNrJV0S/PZG0+FzUXpw3C5ZFyhLyMIwtz?=
 =?us-ascii?Q?gTeNycwbt+WfM+purDWbuaTmlMHvOfiZjrTF9kTZlGlz6Ptubwqpu+GqTWip?=
 =?us-ascii?Q?O/kiLaueYoTXMwYMEwhFs1yHchzzK+O8hWTuXplyp/SRS0gw2zrJ6ve1aash?=
 =?us-ascii?Q?JdV4Qujwhe1WmwmVTFeO4xT1RP3jpgKXiNcZqGlvWRFEGWTQ72uT5IkUGoyH?=
 =?us-ascii?Q?fpmMY3IOoKRwDnKed5KzjMjAZYgBJG3SS/UraUKVW+D7PuWlRYX8tdecYb1k?=
 =?us-ascii?Q?0V8pTa8wSVF1kBxGhL4pOQvvXRXWs5wvcudTEgQ01AojGTzgV0H6j1eSKvTs?=
 =?us-ascii?Q?Qks1/BWW139lrudgZ+G2T0h3zJ9SxpUk4MHeMPUCShRQcupLFZDyY0gDv8Bh?=
 =?us-ascii?Q?+sgqIflrEsF6SPmL989fcCwKG74CTV6oJaTJNBOwjCKAZEa8kuc0GpVhfP5L?=
 =?us-ascii?Q?uKv4WZUBscHWxl7Eebm2Zm7jr7NRfLsFudAZCnr0R2pYnPR/asBNQOksSt/S?=
 =?us-ascii?Q?kK+E6vQcAM63lkMqCuMwB4szF/40oaC22YCBbO73KPgfxZnASTteLSpQd7oK?=
 =?us-ascii?Q?TVcZNpmdgXDx7euPiCFFaXvOUDLbyo7D3kt/o7tET1N2tQoCAOvuXWbD/s+x?=
 =?us-ascii?Q?SCKX/E+3zDSLl36sdLXjVBhULFEoTjfnD4N2DqUg3SKAqDblkliKpvygHXZy?=
 =?us-ascii?Q?rY3asEFUvVGV9Da/PzaSP1gfhe6iFCcOIctSpJ21B++28Z7+ukC9NKn0wxnG?=
 =?us-ascii?Q?5xn2/o5xNOqNwRAiMRp8YKew71d4aKVKBj+iRV81kUgNvMDHx7Rm8EYUs30E?=
 =?us-ascii?Q?0lCCdlgq6zXNWJm3GEpi/FzYSudQi5ZjwwX0vuMnL1GiWpulLOrr/4BgxMCj?=
 =?us-ascii?Q?A2lqSHdQ/0crpjQh8xZpX/UTCS0MN33uRdWz+0Hv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6042a8b3-c00d-47b6-87ba-08dda9bdd973
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:42.1239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZr1jvjsS9FqQ2JVUnO4eVsmGc7praHEGa+gIjDfHheZZzMsGUC7DpBZU5wBA5TW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

First Stage and Second Stage have very different ways to deny
no-snoop. The first stage uses the PGSNP bit which is global per-PASID so
enabling requires loading new PASID entries for all the attached devices.

Second stage uses a bit per PTE, so enabling just requires telling future
maps to set the bit.

Since we now have two domain ops we can have two functions that can
directly code their required actions instead of a bunch of logic dancing
around use_first_level.

Combine domain_set_force_snooping() into the new functions since they are
the only caller.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 56 +++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7a5c794e488614..5fd4b82576ca44 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3629,44 +3629,40 @@ static bool domain_support_force_snooping(struct dmar_domain *domain)
 	return support;
 }
 
-static void domain_set_force_snooping(struct dmar_domain *domain)
-{
-	struct device_domain_info *info;
-
-	assert_spin_locked(&domain->lock);
-	/*
-	 * Second level page table supports per-PTE snoop control. The
-	 * iommu_map() interface will handle this by setting SNP bit.
-	 */
-	if (!domain->use_first_level) {
-		domain->set_pte_snp = true;
-		return;
-	}
-
-	list_for_each_entry(info, &domain->devices, link)
-		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
-						     IOMMU_NO_PASID);
-}
-
-static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+static bool intel_iommu_enforce_cache_coherency_fs(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long flags;
+	struct device_domain_info *info;
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
 
 	if (dmar_domain->force_snooping)
 		return true;
 
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	if (!domain_support_force_snooping(dmar_domain) ||
-	    (!dmar_domain->use_first_level && dmar_domain->has_mappings)) {
-		spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	if (!domain_support_force_snooping(dmar_domain))
 		return false;
-	}
 
-	domain_set_force_snooping(dmar_domain);
 	dmar_domain->force_snooping = true;
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	list_for_each_entry(info, &dmar_domain->devices, link)
+		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
+						     IOMMU_NO_PASID);
+	return true;
+}
 
+static bool intel_iommu_enforce_cache_coherency_ss(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
+	if (!domain_support_force_snooping(dmar_domain) ||
+	    dmar_domain->has_mappings)
+		return false;
+
+	/*
+	 * Second level page table supports per-PTE snoop control. The
+	 * iommu_map() interface will handle this by setting SNP bit.
+	 */
+	dmar_domain->set_pte_snp = true;
 	return true;
 }
 
@@ -4381,7 +4377,7 @@ const struct iommu_domain_ops intel_fs_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_fs,
 };
 
 const struct iommu_domain_ops intel_ss_paging_domain_ops = {
@@ -4394,7 +4390,7 @@ const struct iommu_domain_ops intel_ss_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_ss,
 };
 
 const struct iommu_ops intel_iommu_ops = {
-- 
2.43.0


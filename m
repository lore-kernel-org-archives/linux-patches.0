Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C063E024D;
	Wed,  5 Aug 2026 19:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957347; cv=fail; b=IXQO2sMQjWgOQbeZo5xy5z2NnFpYioQyQ0HS92c4v1Uf1m3zxJFTna0E45rJDkhfXfkQju4LeN38UqrDohubNiY3JddLSFRNYUmum5QpGepjO7qaLR+GNfX0BqOv0FRXA4V3WCoqIf7mJZRR1VIwVLhm6tsEbW6qEP88IGGifmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957347; c=relaxed/simple;
	bh=cJ4eNAC1yHqilXnMrDSJZhpyASI/8F0gKHQkehjr9dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KaaVWm25MxWzJtqDiN0fBeObT9G5xc60lDL1hA1fBJEuczhmZ7LBXz/iyj8KhQrC8fjXBkowHS1OV+v0B80G2OrrpgwBEIqZTDXKtIbsHKcPENfHF752/JZHYxnOMXzIeHCYHNNSFszoOsaUGKgd0AfpHosD7ScsRIC+2LVdS24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ozShPAqN; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ozShPAqN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9UQgHcMjCdA812jRdzaWHJLFRRwr2O5gq+K5hI/CM0Q5DVHjgBL+1VdJBZCxzNsT2jKaHipYBrUbWbOWDhfqEXw1hlxryanXE0XZp1QKw/XRe5wUhbV8raFLsgLklKa4N3TCHkjr/q3yk6BccanbfS4ca4+x4MQpIOgiXu1C4Zw9vBm227Lsd3yjQN0L1j0/FWyc28BkxLhsnWUiHeSqhLrsTk1ANuvktxC7lIFiZCRPo4EX+Rlgj89nLi0GoTo3bM8t8dRRLlMXXefjpHh22ue9aFLWMqyrv8XH+tZn0cIcZ9s6DzU/YBz9I4ZVJofyTBBbovUBtpnFDcQ+6K9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRfklZ2rR61dNpT7vJT/BpaAqPH1fXLIT4I0lc7R3/M=;
 b=bHVAqOl7UO3pqbC9zBQHk2zEX4kiQ0mUp2dWxzt//CnXBd0W0o+bQs0Xlo7DWCfUQY4K0mn0hyNRZkafAbergFVlrszokxseTisgACFORwBOtwkSgcNuQjgyafttFQsRJcigYNlD5k3mw1NWQAzrtQR6MUtY/IQYNLysOFhRb08umH9TQp6JnJK0keEZArLTKSB/B7L7is1fhuQFuR5CG74V7xAEGsXc0Bye9pyuCkkWVjdFzDbmoG4yG1QRirvnLCVJXj8bsVsfTdQ4EKpT0eUvPE6HokW+u1K8hJxkxdqFrtPHpgRTcvpgxWPmg8sxIOy4H9bEwbqEG3mODhqq1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRfklZ2rR61dNpT7vJT/BpaAqPH1fXLIT4I0lc7R3/M=;
 b=ozShPAqNbknEuLluPTdUSGp8+wdEeictlsVanY2ZE3WB5RCrp1alwJxnw38uMFveo0NvpqgkYrMaJ2hSxRqejT3LVu1sge5kH1NCTHqIC1r3ZW33kQVXAEjQW4uvydKovddqCUJQAytR9LXEvQX2AYHmDjJ1CZiJdQpxHEwNVi8ZsinV+vbYPqKz2umhT4jRFEGQrmcpEXpckyDyAOFCmb1I4nj/sOzR/X2shVI1+5NgZdRXyA4mljpkqkippMVLjZUrWvrsf/mv1ZfL6KdUvLPn/ImJHFt5LovqCjj2HuDZ/cNN3MaoEpmRl5JLlVBxM00vRCcMTu7Ou9iNITuUVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:28 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Wed,  5 Aug 2026 16:15:24 -0300
Message-ID: <6-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::21) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 6882038c-65e5-454d-4fe8-08def325e88c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qWqpi7l8CMNhWOpG6IHppyIn/81cvKvyFNhGDSoQX+zF8wEsrwuQ0ysM/UPMc+C42u44Fe3eMnJ1jI4vQqk9P+TZ+AmAfbMi+vnQH1DwimKcGcZBsBIt8ToB45X5pm8vcucjUctL5PjknM7O9n0BxEjv1v0DB04tQni5LSNwYUBrCJkRsngRdfaq1NS7O4jADFEisiMYwjSQEbi+dK2VtAER1mA5tfWT7oXHpmIo/ptNhMl6GPFvOIUkP3W/ygFQcawmz/qOig61rExfcM49tdNU8vioHMSKiWvSx7RAJG40VX2gNJfgeBBLzqzZtfNBvokvK3UOFkEJWnz0P3LR8GcjH5NH7llCcn4C++C7GVWCgoDQQxDZKCHABZjU/aOVSJFwpVBKgIirYYrFgIK1bUFPozl9ERKA9RHOUsGlCtaC2bezzqUIEvXsIKLYb3zOWmE0KOkLsQZNJf5I+RMBVpVBoa+8ncR52ldX6R1jXSkf4nAOQe9igRI4NHicg1B8/aiifmFC6DiCntueybmg3YFrK+Iac+VPk3Ya4nHBqHlk1XsQc14aphMjXDgBBFUdZdwSvIva2QXYVSV4Xe+xCk1oQ+J2PtHhNbsYWpm4caQsHP/UlYN729ycRhuIpAOAHVFToUYp4zq2EtmxkT1JLUFshv4xbD6j+zcDBxcUI2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L8uw0tzJapj+OzUM4h6xNcdMvBP6pJ973Lh74FlPpacA3nZbZF2q88Cdo9nX?=
 =?us-ascii?Q?+maWQFV8d3W4nGJAjm1+WbKoFhaBbls6uXg4gO+njlDesNb/NAWSEpiJa1PC?=
 =?us-ascii?Q?W8XA9ALbPT9LnC4BgNgO/BzX8/hRfldJdkgpJ6+3krzt53G19WQCJGEvNsCH?=
 =?us-ascii?Q?CQIUqxS8G982RWet3nr2+lk/Yt0tiAV2fxHbAfgg1vuWjOyQimgGaLB/ORpT?=
 =?us-ascii?Q?zSAQdtTIT+d0P6ZSN44zr4lKrplLBgJdMvqdxGbBAFIt+ViM+zvEYDXNdYcg?=
 =?us-ascii?Q?MIWTSLEc0EDjqg5lXuqq1lGvWB7+e4rr613jefyT/UtNSDdJcwijqwhIvK+/?=
 =?us-ascii?Q?Kb3mo6PW/tbLtRSnnmdXpcyD2yobTYF3J6yY9SuRg8hNcnIEiTqoerpdURyP?=
 =?us-ascii?Q?livp3O60eEPyai2AIZIN26pjMe4zocuMU+mnCIx27B4pPsmLdBlfkbTm4uHx?=
 =?us-ascii?Q?KF3rnjSw/f0XTyDyWcCtsLSgow+5twBKNZH30VSfqRLeL03uqYzvCOrd3iSc?=
 =?us-ascii?Q?riHs+znrtP27p6k5UxedBYRnmL7I92roAAVIvgqlzoPXIRaC5JHTW0EkGfCO?=
 =?us-ascii?Q?ZktYkSgmBg4TRXXkRGY4YHyJBjIMd1PNESzwCGidCvYt16ImKpKuWXPiydq8?=
 =?us-ascii?Q?auBhbD336pOsk1i8oHxPaHGwjo7VbDefvuAqFTnP7TsfYF09NBLAijirq7Af?=
 =?us-ascii?Q?zX6eYOj3+oHGPJc2BFUlufXqpgFaP9/f3a3HIDLQ53jDQ3nZHGelt4gjVOj7?=
 =?us-ascii?Q?YOdpDH7vRg2YXW06Zq8Qj/2b9O3m5152djeKAwBjidfPNAcL1nIl9erHs1Kl?=
 =?us-ascii?Q?QWs9N74XL3yIWXNYFyx9eJzR0WJIQw0OI+3EAoEgQ0wAwJ6WDQBtXxqjULCs?=
 =?us-ascii?Q?W3dUf10bRQTfNEvL3+G6Kct1n7twJG5hlJbv7tfTI41fIFsHHHXDvCwNkWLS?=
 =?us-ascii?Q?ZwLdWM5GPEDHRjifdlv7rdgDyYEu7qIEBYfjLQjUN0QGgHpHlSFBpF+SQeoq?=
 =?us-ascii?Q?HuXd0vk9yU3C+sIEn5qGzQoXcXm/Ir1zk/AlVM8IvvKB/PXgDUPllH7+xcvE?=
 =?us-ascii?Q?x8Qo7gzE3npEh8tBOrp4tpGVW6YDsCAingCpC8RuTkLXwR5QX0hlA1S9pyUV?=
 =?us-ascii?Q?pz3rIudSsAlp69zsjj1auL7k8zWpCYGvO3ofKWiWTjjo4xRMrpj+Opp5UrGH?=
 =?us-ascii?Q?dM+A/YCszeL44/R52gbgFyuRvdF3n7XYWZBzptlioLnqcm2SM2ZfBkYE2veT?=
 =?us-ascii?Q?f7cZmQXc06JbmQBY5s+jgaPVScn+Pc/rhIgICrlcoCa8Ykh+JUA8xdMEw5nc?=
 =?us-ascii?Q?CxC/Hl3RoJsHm5uS12FtQfJD4GCkFKdgkxq0q458ZBOZalw2bB6je4yjytLa?=
 =?us-ascii?Q?9hoXCFaPjI00pIRg+6mQFjmh/FGqh9/M49OZ9zpCeOIciOZDXIMnk2BUqjy+?=
 =?us-ascii?Q?AoNrukd4i4ATIxYIysteLZVgVD/nr53FEMUekaiVxgfvczI0S4byBzEJz4kT?=
 =?us-ascii?Q?1c9EjDQynRUk6LPLlfLl68qxiAoPqjUcZWir1rOy9obAd5+hzHv6WPdN5F9/?=
 =?us-ascii?Q?ib/ddmhHqvkwZD5/JJ2ifpGf/2g6Uwn4u+H2BfSRXj23Ke3Y6mLfteVDf3mN?=
 =?us-ascii?Q?p3WTKvzSoZOZB6hL/SyPqiM8Ca5/fkEaz0pFddBGAiIbh6bTMCIrc/9BW/kB?=
 =?us-ascii?Q?ZUJlncVLB1p2m70z0ADb3t1yOeU9sGQXlGU/2A7WppEXFb3ldgXaqxxhTf8y?=
 =?us-ascii?Q?nPXDaC2F6w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6882038c-65e5-454d-4fe8-08def325e88c
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:27.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ey1xGvctenlsDll9by407kxEkxwgJgggO7y08y5IKP6d3XDdpnBBq6/R8WHvqkR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

Each of these has their own unique situation, populate the tlbi right
at the top and pass it into arm_smmu_domain_inv_range(). They will
diverge further when the iommupt invalidation scheme is introduced.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 54 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 ++++--
 3 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 002e50d222ca47..20f3ca7f5472c6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,16 +140,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
-	size_t size;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = start,
+		/*
+		 * The mm_types defines vm_end as the first byte after the end
+		 * address, different from IOMMU subsystem using the last
+		 * address of an address range.
+		 */
+		.size = end - start,
+		.iopte_size = PAGE_SIZE,
+	};
 
-	/*
-	 * The mm_types defines vm_end as the first byte after the end address,
-	 * different from IOMMU subsystem using the last address of an address
-	 * range. So do a simple translation here by calculating size correctly.
-	 */
-	size = end - start;
-
-	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 55a47a5bdc184f..3c812df9d01473 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2729,25 +2729,13 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
 	}
 }
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf)
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_tlbi tlbi = {
-		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = granule,
-		.leaf_only = leaf,
-	};
 	struct arm_smmu_invs *invs;
 
-	if (!size || size == SIZE_MAX) {
-		tlbi.single.use_full_inv = true;
-		tlbi.range.use_full_inv = true;
-	} else {
-		arm_smmu_tlbi_calc_single(&tlbi);
-	}
+	if (!tlbi->single.use_full_inv)
+		arm_smmu_tlbi_calc_single(tlbi);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2766,7 +2754,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 *
 	 *  [CPU0]                        | [CPU1]
 	 *  change IOPTE on new domain:   |
-	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs()
+	 *  arm_smmu_domain_tlbi() {      | arm_smmu_install_new_domain_invs()
 	 *    smp_mb(); // ensures IOPTE  | arm_smmu_install_ste_for_dev {
 	 *              // seen by SMMU   |   dma_wmb(); // ensures invs update
 	 *    // load the updated invs    |              // before updating STE
@@ -2784,8 +2772,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 * this matches the instances used for invalidation.
 	 */
 	if (invs->has_range_inv) {
-		if (!tlbi.range.use_full_inv)
-			arm_smmu_tlbi_calc_range(&tlbi);
+		if (!tlbi->range.use_full_inv)
+			arm_smmu_tlbi_calc_range(tlbi);
 	}
 
 	/*
@@ -2796,10 +2784,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 	}
 
 	rcu_read_unlock();
@@ -2815,12 +2803,23 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each single table level it wants to remove.
+ * size is the size of the table level and granule is the tg in bytes. This must
+ * clear the walk cache and any leaves within the range.
+ */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = iova,
+		.size = size,
+		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+	};
 
-	arm_smmu_domain_inv_range(smmu_domain, iova, size, granule, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
@@ -4088,13 +4087,18 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = gather->start,
+		.size = gather->end - gather->start + 1,
+		.iopte_size = gather->pgsize,
+		.leaf_only = true,
+	};
 
 	if (!gather->pgsize)
 		return;
 
-	arm_smmu_domain_inv_range(smmu_domain, gather->start,
-				  gather->end - gather->start + 1,
-				  gather->pgsize, true);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static phys_addr_t
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4f57cd58197b0a..187669b8e7e34a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1177,14 +1177,19 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf);
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain);
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, smmu_domain->tgsz_lg2,
-				  false);
+	/* Prefilled for invalidate all */
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.single.use_full_inv = true,
+		.range.use_full_inv = true,
+	};
+
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0


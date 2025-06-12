Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D9246BC1;
	Thu, 12 Jun 2025 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738713; cv=fail; b=oAHEX8HEoOj/TeJDgV5HRalNhVJHxeqCnFG/J7ck/pSd0AY4kLFPFUJLHoR2iakcxylXkSWWsxj51Pou++kRgLpbpUAiOiET3YDIkeIzM0LveFjjjuweDydT6ltFpX2z6D36Mz18adxsES8njWRaDahBXmbPZChxMlHRVJxNab8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738713; c=relaxed/simple;
	bh=Yu9Xo1f4KL2QOv5siFWGlnp0f/yd19mcEmJpoJEyCwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dTmd3tWFEe7+tqzCdMpWT8Hv1a3qeqhO98KCE/gpdw0dUKcvoSzq6lHe4UePVjUV7aYSC0kJEoWP2OyoWiylLFG7B3nkHuP1V53sH/x9x0TqItHaAVpDIk4oKG7iomQVYtj2TQV1h03ndS7VHipKPk4QgxUjwQZnmzy5ZrzDfXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RYnuX9SD; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RYnuX9SD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEqyUYF2wejqwZt3eylEJaPE9vK0MQ1wMPL4UElsG6fLp/Kvm8GGQUVTPDIsHh6bTU2ikp05Fl/hIvEnQFBextFL4rhQcWm2sorRuUo+++kUuMzELqMDnO06blVODFfqKGNxcqJmiFAhTwiqpKzZg8tExbWJZqrMqg9YlyFerz7XAMYLThUbc3kCWVN9m+hYqWLFheeL0QnJnGLuugy9AO2F91mY66bRjaWldNzP4SXRnMDfD3w5LA28KfhWm0zeqWsMS0awtlqpe4927DH4Le00fKbn8g0Z69098Y4sFQY5CP1w+SSvrLXSDTSXBqV4oaffz623VCXqZ80q0t5qeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7Mvzkv9Gc0+FFitzWKwmIEHGxqL0gK9y9UgarV+IpE=;
 b=ENCf5t+g2+I/GbdFDgfDmiXPGlI2yHPAEhZVi4PB5QgeYumZGbfN9stIz2yqgmEmda+Jgwhp9+YzPlpsihHUVj9Z5LevyCk0iFOH0ILfaa7hHn9/S4WubGHG+JGG57uViwTBzM4JdCEtvV5vWGGkjU3tGyKHGb875Orp4ppClh9vk2gblwqzr8ZLAEZ+WFF2wIxFf5SeGaxBs6ukh784LYhshccgY2Rv5c/Y14V26wSb0AN0GQNRr0MfLugWXsGmYxIeE5vvSp8cUZnRb0H5noaeklPaEPU6NvsD0f52ZpG+ukUCTcBRx8n4noGfw7Sj6+xLVxs/22wjF4Fhe4Qnug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7Mvzkv9Gc0+FFitzWKwmIEHGxqL0gK9y9UgarV+IpE=;
 b=RYnuX9SDk65z2HcC7eFKm57Wxs8Wxegc5qlGHkv2tbaqA6l0iDggPKzNRHJaYv4g0/AKdtThK9z2w71yKZFEYJz0XIbs2Uit9ay8K1c6F8hmQDNxUwh2Yt04Gy6n72kEcBX0z2cSiZLxjNLxul5CTYuEc2jJEuA+SMmXfbGYbB0lFfXi0ftJeUS5c3nybdShX9hkscIfJ4CP9ORe5IxWDki4LAnL5TTfV5Lsr/0sCr6MVSJE32l039wx6gtPqRi8IVU1KCYtCXCijVIr1xvXvEMPBw0erVWI+pcxpJvpJ4Ij84DLTtHPr4lIm6Yz2acue90yjF/F9T+w6aXpNXxYrg==
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
Subject: [PATCH v2 2/7] iommu/vt-d: Fold domain_exit() into intel_iommu_domain_free()
Date: Thu, 12 Jun 2025 11:31:34 -0300
Message-ID: <2-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0144.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b59cf6e-eb52-455c-d980-08dda9bdd94e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Io/pVLV/UO15N/83FYjco0faeigWgWm+l3ny795FTfyavqKDVKhR/qiEuS1y?=
 =?us-ascii?Q?H9s6Ehj1x02lCiMjcpL+yekRvldjs4ctI05pu6cNUWNqpbV3DkrobbMtF7lb?=
 =?us-ascii?Q?Tdm4RbnWI1dlCpTEIHBr0U5e39B37hoCMJLsUT3MSXNl38JxX8ljVWAJ1Ctt?=
 =?us-ascii?Q?n0+UR87PNEHDs2pu0BuLgp/RmSRcFxAfoxUqfXwugJ9c23CMCpfu/LQaVYgM?=
 =?us-ascii?Q?XlI1z8K/u5ZrppLh6wryeIAz51+X4dRec7kr0tFQeOwbmhrOoz6eFXb/REju?=
 =?us-ascii?Q?Oymx0/rJ0ckNTKJISihrXcU7nOT6MLDdiImqBpdAbjrOtAXs3Rh9cCfKNqwn?=
 =?us-ascii?Q?ZKT6ayQrxHm9uGYCseqvXEHLWXdy5v7s1aMAyOU7k3zmO/zzDaNz45P2pstK?=
 =?us-ascii?Q?BCjnjCAmBDghaZXh3zxbpdTVJ0sQ5sMsJmMzBiXC0o3k39LGbKj2oqsXR1OG?=
 =?us-ascii?Q?A54DXzTW/edUD/npo7m3J9GQuNgFuQXDm7fHe/lUZ1gbYYxDXoAt3VRfkASm?=
 =?us-ascii?Q?IT7PydCjW4r5gBwOo1BNgZheUs+vIjcx+gZ5cYklBuZx+pXbruaSNA9rSbf8?=
 =?us-ascii?Q?fMYu7fKiEozPSl0fASzb37bSvXjBotIM8M4jH24WoMwDgVwrYgISz1x3h90z?=
 =?us-ascii?Q?k8t2FGaYCmMnSITi03i81wg/bawYLSLhhc4ZVKaK7DXbL8XIPlKy+DfN0ze3?=
 =?us-ascii?Q?Pzsn+kmLYuOb7m4Evhwk+qflcoUFKCt2wifXJLg/7ZaQjFZ3XRmVPCOtL6jv?=
 =?us-ascii?Q?qApXcKdnQvUop6nthQZJP+2+xyM5bpjfEvbR9BRh23FVG8YS7xEKpBMXcBNK?=
 =?us-ascii?Q?OEZNiKucjrNB2LeE9394+K3bRCifpUlHDKnQn1UNgckdHDhMOT4s783haInI?=
 =?us-ascii?Q?ahS6f3PaWII7uRI9vQvoRQcxgauAf9vHRXynfSYDTPfEbtq/hmM27QpZfuof?=
 =?us-ascii?Q?Uo/+PT2CWYTInyxOUyNqeYMA8YxzscEsBNZwYFusDLcoMZLiiek8WaJLNoGc?=
 =?us-ascii?Q?ql2VrhO94NoyUXFcxMy3zet1hvEZQYEl2rCAbi/5gySqAJnS461oR4rYftc0?=
 =?us-ascii?Q?x/F7q7RFRTH+A4wV7bX2omV3Lo3rnJT0JbAJ7v0mr1zcmR2L48pnBs0WW7yb?=
 =?us-ascii?Q?UtqLFR+Hfh1+AuekYbM16DDblpRIPZdn7TzmOEMr9cMZhqH1AfvQTixn5iaC?=
 =?us-ascii?Q?AxTFcxiSrjAnikV/TxWIorK3NZpJ0B426nVVIVCkAVHZQnfEKRxeG3vgcha4?=
 =?us-ascii?Q?W9OaUwPnV8cMlRk09OzpJdclIvMTPUZWjle1oxSLpaYo8SfvhOzHzDvEeJ52?=
 =?us-ascii?Q?DooWTgl1w5EKvWe5mWTnHQxz2HGWqxX4Fn9b2KG8H0yNDgtGwemUVbxCQVbH?=
 =?us-ascii?Q?B/bqe2XpuduFff30mE9qQTwYaTdDS/Wu01P9bhHUaG3QGn1z16Huap0ASfsq?=
 =?us-ascii?Q?W9uYafL+LEA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P9a4JJzOG7akc6TMRMbjvMRlHLC2Li6xeA3S2oAFk0GCL9e1e33UcGvusWIY?=
 =?us-ascii?Q?OdL02WOfPFRnroQp88F0sSx6BSgLginE5+PS0JpRbZEtleogQhU3QHJaWyFc?=
 =?us-ascii?Q?D3td/5yMj3o6cHNK8j486Btu0vcnsVC5DnfZUEYzfDNlwQxtTxbheL7nRb7+?=
 =?us-ascii?Q?SBdcA2ro54WXea/zKv/Ld4N4PYPOL12ghDQ0Qy+DqdDU/wqoNcDpL/D3q+OQ?=
 =?us-ascii?Q?5u9gp4BW9v8tflIdABbcqoICdna/K/wfTAh2SaFNd9Y/Y/3RfLwGxInNEG07?=
 =?us-ascii?Q?fmvqM91HeYue1RkP2M+nDJAcR6o0ae8t8+RANJoXuQTQt5R3lQlWFy8DoZrC?=
 =?us-ascii?Q?xaH8ryaxhZ8JfDJw+tycJnhxpidRihWJopZ4mYNTUgg58UaWmCv0YORa+aEv?=
 =?us-ascii?Q?2KoyfxvrNfDJxtAJFn6/aVVhzZkyQqLGdjGajSOwVCo97GLT5tlosL1oqsRe?=
 =?us-ascii?Q?hllqkSHXe9/NKEwRqc2Ib3Ohw5Jl4i6oZ9gJ4B9h9Zxi5qSRVrr9PSlfkYUm?=
 =?us-ascii?Q?LqBs4lPmDH3gTGWvsQpFURjil+UDL51B5FlJ7HhH/8LdlErlFcDgCqG5Zjyl?=
 =?us-ascii?Q?b1nXX77yG79gKBxvI6waUamB6OsUawTkQr9sflmaz1N7t14HxBDRQIT7kaOH?=
 =?us-ascii?Q?MgaesCDZzlmR8Bge5UkjB6YmD/zLYBuvsyQpu1ZajjU0CHY46KyH7Hd3XMsp?=
 =?us-ascii?Q?liweHpHkeMhJ3rA4FoQY3MbtzKUFJlfFQjK0b6JlHhDJlZC1Lvz4nmI1BjY2?=
 =?us-ascii?Q?0/GY7cVLHa3OGsOioZtEw4Vp/ygg8EjU4iU7+wY8F17OsHPzFGetU3K+/vtz?=
 =?us-ascii?Q?bl+nKfzOJGsHm3jD2+2kJQmpFdJlHMXZ5Ui9EkmMnWuhmaOHIJYnUWYY78lq?=
 =?us-ascii?Q?2z2OwErJnrVKSID9XGO51RMV4a3WfpABBFpIrP3SQYjWN6anQcQLLF7uHSPN?=
 =?us-ascii?Q?Dz+qv0cKVlKTz/1eHn5J7ACUbzxWCZvaivNLLQp5TgtlzQ2Wkm3mI51MbRG7?=
 =?us-ascii?Q?vXabmm9zQBFIuftiHSw0g2KyplvPz58sZIE3jLwGYhJXaSjJ4gjNM7NDZSvd?=
 =?us-ascii?Q?qIx5zeWjhvB8FYyYs1zh1042rsa2xrSXjP+W/XyGg6zpD00Ll8qLj+uy23d8?=
 =?us-ascii?Q?XLmrFVzKNu5Xo4wvZbcqriNANfako/Ul/xUSwr1xMyyTzeKSpe+NbzH6f/6u?=
 =?us-ascii?Q?TCfPyr9+Ff0SIZqUwkeg844RA1CuF3gW+yrBARsA7yXxVTcAIFtQN3fo1Wek?=
 =?us-ascii?Q?bFj+/KSohjvm6yG5aI933d8LoKrOC61rx9sxUi0+CdTmsR1KLIuK+HLKmOmF?=
 =?us-ascii?Q?n72BTK5cadbGE5L19zRvUrazWdD0Vvu8KccsDTEP29PUFHHkovWG6Ou30CWx?=
 =?us-ascii?Q?hatkqrjnEfSaVGUFOcqifNicQnUy9Uu9pG/kLT0daCWlSPuPyNa8lakqUYQ5?=
 =?us-ascii?Q?s/QasA/mDdMCvkVUGMhI1ZAU6phsFyQyC2o7Oftb1UBPsEWGSeUZ0NDMSLYr?=
 =?us-ascii?Q?CInBqkpOR3KqcV2MIGvXtvu0h4ZIel0Z5VSzmyrSyIm/jK8XzJ76JrgN49YA?=
 =?us-ascii?Q?Hev8KCesIw2Wday6e/rcVVj9D9d+8zTA4hutL2cx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b59cf6e-eb52-455c-d980-08dda9bdd94e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:42.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z9mgEHXOZT576/WGIU9ZDFjawpYFuZpLuUd9h9X7yg7sIm11lcMlm0qzNCGNnz0q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

It has only one caller, no need for two functions.

Correct the WARN_ON() error handling to leak the entire page table if the
HW is still referencing it so we don't UAF during WARN_ON recovery.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 38 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b42bb091088ff5..7119f4be1b1393 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1396,23 +1396,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	}
 }
 
-static void domain_exit(struct dmar_domain *domain)
-{
-	if (domain->pgd) {
-		struct iommu_pages_list freelist =
-			IOMMU_PAGES_LIST_INIT(freelist);
-
-		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
-		iommu_put_pages_list(&freelist);
-	}
-
-	if (WARN_ON(!list_empty(&domain->devices)))
-		return;
-
-	kfree(domain->qi_batch);
-	kfree(domain);
-}
-
 /*
  * For kdump cases, old valid entries may be cached due to the
  * in-flight DMA and copied pgtable, but there is no unmapping
@@ -3392,9 +3375,24 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
-	WARN_ON(dmar_domain->nested_parent &&
-		!list_empty(&dmar_domain->s1_domains));
-	domain_exit(dmar_domain);
+	if (WARN_ON(dmar_domain->nested_parent &&
+		!list_empty(&dmar_domain->s1_domains)))
+		return;
+
+	if (WARN_ON(!list_empty(&dmar_domain->devices)))
+		return;
+
+	if (dmar_domain->pgd) {
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
+
+		domain_unmap(dmar_domain, 0, DOMAIN_MAX_PFN(dmar_domain->gaw),
+			     &freelist);
+		iommu_put_pages_list(&freelist);
+	}
+
+	kfree(dmar_domain->qi_batch);
+	kfree(dmar_domain);
 }
 
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
-- 
2.43.0


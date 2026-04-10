Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7C3D9DAA;
	Fri, 10 Apr 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836641; cv=fail; b=cnhvEAO1rosn0FbPVxHqoHBZNdRWZTGndLcpbw76N7TQAbOiJZsMHHrf/AfU8qlRxAeCQ+yCWw5lj1oKFjfSXAAtr3YGbo4w5xB2h6QAzm0jCBAHGOZaPkiVNFkmdnAUgisP/dRPNWTsnZ0yIKDRe97QkXhJEVj/DNjbJw6VqNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836641; c=relaxed/simple;
	bh=oKy7fxDt4xjzM2B2qAJ/rpBaXqEor/dNxw1CdW6TLlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ihThSqrzNEoEzjEqSvBmpxrRZRusWZdOsjhPcTSW6DfFpzovhZ4q1C6bS49My5s+27zbw02TveivUlXxMz4Xv8lJsw+3GivvJ1ySErjcwQA9JFqpBz+cVNt1QkJBtwjISk3+f8XzKx5WQgCqje979ndmTT4JwFsBaXX1Mv1+PAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eAfT6hnR; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eAfT6hnR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bm1WuAcc7e5LybgKFxXZzdnzNG8radIe5pqWF/PxjfKxjAhsfv+IRViKFp9jR28uckrLgty7snHvQkdtUAlED/LokKJTYuivil1t7B49HhvhwvAVd8b4cDlJiRgt8bf+JR6ZZ2S6MIWdiHQTcMLQRobNfo0S+uZ+zjzDXuNcLX14FiEHeJavX40EDKscWE1tjFw+9iCIV9XsAAp1TufQ6+S3cWw8ULc4xNz3dP0YqBwxP6fpTMeq/0WLYQsx9jYqVRNSprv6slat16Dv9ruz65QvOcmAX9nKWGWC4qlEk7bUcZOiOoMTo/R+KGogc/M31FSkYyPs1Le6q9tK8U6w2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msJ+TtpCkD1tEDtHtP5ey+TEyYwQCr9ZN7RCvMpnTIs=;
 b=oTqnyIIGKDGlB8Wu+4h8L9kxyJAUFjIEYBfhHNPuzEh8wtfqWTDHHPoYlaUe9kW2aVPGpXGC+/W37zkYBuyyT3eR1lr4iUx6e7bQ5vtG0YuOhlY0jkhuiN35CsLf8NyY18PdIetPJoHavY3QWAFApEXCo9EDNQi6g9vquSlZjItwzVC8rqnNCvkZMBNHzQBoHZiDGy+TeoKZK5woxHR4sm/tuGk89o60TWtSeLE3uUZPRSFFGJBNWhsNlBzj58A27x6n8v4nUsuvQHztQ1tpxpIIXBDd3g7T1HPxCH83zdnCHGmlUPix9JbAo4/iX3HZdmHlYOv4oElRmk8UOHGw1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msJ+TtpCkD1tEDtHtP5ey+TEyYwQCr9ZN7RCvMpnTIs=;
 b=eAfT6hnRDBPHw3iArutrA4ocL58dPVYeidLBj80G0+gI/Y9LVW2Eo9w+qM+Jg73Rww6/AhuQzPMIWStPH+K5kMuCBVQtECUGjixKXYH+i0dve4xAtZKWjeZyxW6DXgG4lI6tRhtV9C/w1B236x/yPDBGzNrzwzA551MZKrNVvgaKXhtKXj78nBszG41RWw7S3c+5l3TjFTdBdEO/T69XF7Byd/y/Qim8QSGL/O6XgF0+iJer6O8suPEyQS4iYAlENqPYU5eU3Y+ThedItakjvT4WBZ7UcUYT+7fXEMNpsLCNEyZC6DHHOuQIvIUOtLM2BGxfgryuihO7JFHjjcCpIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Fri, 10 Apr
 2026 15:57:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:15 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH 6/7] iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
Date: Fri, 10 Apr 2026 12:57:07 -0300
Message-ID: <6-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0079.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 225f46f3-2cbb-45d7-d924-08de9719d36c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lsUBX3vXziHpgNpyvBbsTb9Cvnk53P4/qMX+AsYwgafxldiBU0NaH82EP3zk0xzwfBFre0R05SjJHlq/Zjx3pIpH4aS+16F4yzCWZXaDsF36G351A1CeyQ/Cmod70yaayg+DmJQJQlt9qR0lJvz8K+8HeyfCqfi7bEpl/yS4X0TevyS1BBzTB9zLOtb1UIuQVXSecCNlVCLuuBPVmAy+2wU9SOkQwpZ5J2s62w7YE2w1/GKH4rfnGAmy7hTIS73ODwvtEUtH40qMdDTEU4eaLIcYFMktCT2vBqGj3Xtc4smNM34zIW2YfHNFPjgkX5kqKp7mxWc8YDcJ04dRVGpCPES0DKPKB2JQYAMwTER+NG4TLU95Hd2KW6XlGvdAtcbZnFVJ6QI2Imv8iPBUYV6VyGFZaZBA+gtu9KLY8tomJ7h1kDswS3tR+kbNrIWIAWJeWo85BJXXmDjc5ZRp5czr3WGNleLBh1OoiT8peidDNNq/3PWPxQQqhmiJu9fEOGI/9PX5njRbmeqUZOuSqeTC2OMJNVAx60pX3O10y14suhr/ngB9hsGJLMQA9npMM3wTHxrQj/HZEHrgUrRnUXPHQl+xYCm08520hgflUdarFo61OqlfJ9olhJ+OgiXGL4GDGN6RajbijVE854rXkxvBN/zSou1yU8TZM646heH0361C3R5MRHDK2uOQOvh+BJ2Z5+bOdvpWhmBANCwXnoO8FaSaMIpNvvzPHRUTxZgRmBl61u3aC64Q1NxbNQu/llR7s0dDy2IxIva0zzbp/jfwSg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7DPdIj940yBkJxSiMsZQpkQuKui7zTCTMS9Q7U9aZOvZWgXORBOFe1nOixtd?=
 =?us-ascii?Q?r4NYsEa9DoNSetoJdB7Yriuvlkym5WFN8FtywKGrZCEHY4pI41VDp6XBKNNK?=
 =?us-ascii?Q?N3/hcnyrytqkZ6SJlZITmW0D403TCnc6AdhgT482MjdIEma/SxNWqB7HHGZ7?=
 =?us-ascii?Q?PfVrUZFFyYtHz85/sfQuDTvyshRnJS4GFEvpfbXQG2p9E7tTvj4A+glxzqeN?=
 =?us-ascii?Q?GN2A5a7/klADFlvQy4M84cImYSFt8fmOZAEuKRb0onyLfTMj/c6XmIsq+Lt5?=
 =?us-ascii?Q?ZtGfNbWzqDWWzEdNLtwMH+r/iR+uAMs/vYhhUbR65GOBl5sp1vWiBdFTeGZW?=
 =?us-ascii?Q?9A2Ypsr6Qjq8Kb1AjVpzgIP/osVatWZNX5v+MQXJYNIT6pFR2QdQHC7EIbrr?=
 =?us-ascii?Q?Tyfu9YrXe3JlkXEPzfqOiKsZELD27gR6IZlB2ngiG0B/XFHfY9pAtM2mGLDG?=
 =?us-ascii?Q?exYXhyppB5fTRuvfU6RPSw+IaJ9oN85omGL+rSTIUs1njlCwCIgTPsvyITUA?=
 =?us-ascii?Q?h2xRwIc5CbWQAA6eWKuVqs1SaN9lFHZH5ujtUYeuR3rA903P0KF/g8zqbOVo?=
 =?us-ascii?Q?fR0oIYuZs4VbcQ9tOuO7kWgjCRIp03Mp1igwV1wAY3OuBWAV5TYukrvHYsMJ?=
 =?us-ascii?Q?sLUzZDVOFaH9bFi4QvJzTnYQ6Z7cJFovJiw47ewezRbfbKYu82proU7mkQb2?=
 =?us-ascii?Q?NVUyjo2VfCD/Yz+FAunDfE/2YcOYiYkxA3gVi7LhFLQMpFvtajqHNm7NHhrn?=
 =?us-ascii?Q?gwD+Bzhs/1IfTMnbBTc3peTDILbD+CAp0z0DqNL/3RKCxebtIPL8mpPRGJ07?=
 =?us-ascii?Q?BwcNuCq9GKptFXwuwqtIJMjLIbg2CagaVtjB6fUjRYtP7uGp2TzdGQNIE9OE?=
 =?us-ascii?Q?UIfMhp8eLRCl1rxcxpeQiq/CfDIB/sA4WstpHsRRLFf+nsv0ySkLJnJe4tc0?=
 =?us-ascii?Q?JU43O749G9sCxc4EpjbtkO2/qzT/j9D1RnGqz+wamCLhX7kdNG5VFvXUY8Eu?=
 =?us-ascii?Q?mpPfDvA4gu/KC8xExcR4VxBgfPYg+840A2fCXJ7pbHWIaBo4mfLhpsVr5Y+G?=
 =?us-ascii?Q?s178LL/pOd5nCkaWUBRZABZnq1FkycKYmrZ9zAX/W8Yw0+Huz5PHXBIOPTF7?=
 =?us-ascii?Q?/oAKOBcydmdsKi6eW08eO7sJpbTJnF18nk4uYoVf8axOp9FxWzLY8Kfrqave?=
 =?us-ascii?Q?VEA/E8q7ApFd6oIhHSFmiAVH3PGwQt8PJAZxubuXRiBow/b3fSUno7UbTFBx?=
 =?us-ascii?Q?UesibwBqbhRsuoQb/6sHlXoliuKcCxHMrycQDvhAAewAfhBslrMXqqmJ8uqT?=
 =?us-ascii?Q?LxKtiXRzrJQ+HWpKwkTivbj3/t/G4+0wWFrJ9+JmSkmBJiSJ86oDlcwxWchW?=
 =?us-ascii?Q?1AX/Efb4+Yj+gVOH1YISAuO1O18ZDAUCU+WfhD/VFQjEIln++LPrW4XxnMyY?=
 =?us-ascii?Q?9XRCU+tOdH19eGpFsN+141L7tUG/h3csI03q+83UGQMoCaq/MLKR/xF07eeI?=
 =?us-ascii?Q?lzSqjEyE9kac9ttHmW24s/v64fLdKn3ref1IfDSlgViX71TkQ5PoClW15efe?=
 =?us-ascii?Q?qroAXSCddPPzSJw97Rz8vV6nc4gBmETIk7u/7cva01S6Q/hyybrAQLpHJq1F?=
 =?us-ascii?Q?St/0kad2MWslMt5RfT2F/kbnuP54vpqM7hM3NAMwazUzhbpn5nNZSmn9KU74?=
 =?us-ascii?Q?aBatuolkugpYHo2wFj66lhAfehUF9jyfw0wpLlORQuAXyjl1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225f46f3-2cbb-45d7-d924-08de9719d36c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:11.4116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMq8BPKZ+mENfBf5So8zcZKKMSSrS+xeOwWW3Ks/CoNK/jURTg50ARltM5mQMOST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

Non-leaf invalidation allows the single invalidate command to also
clear the walk cache. If NL is available, set the NL bit if the
gather indicates tables have been changed. The stride is already
calculated properly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu-bits.h |  7 +++++++
 drivers/iommu/riscv/iommu.c      | 12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index 29a0040b1c32ea..f01b49ac815586 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -63,6 +63,7 @@
 #define RISCV_IOMMU_CAPABILITIES_PD8		BIT_ULL(38)
 #define RISCV_IOMMU_CAPABILITIES_PD17		BIT_ULL(39)
 #define RISCV_IOMMU_CAPABILITIES_PD20		BIT_ULL(40)
+#define RISCV_IOMMU_CAPABILITIES_NL		BIT_ULL(42)
 
 /**
  * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
@@ -473,6 +474,7 @@ struct riscv_iommu_command {
 #define RISCV_IOMMU_CMD_IOTINVAL_PSCV		BIT_ULL(32)
 #define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
 #define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
+#define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
 /* dword1[61:10] is the 4K-aligned page address */
 #define RISCV_IOMMU_CMD_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
 
@@ -724,6 +726,11 @@ static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cm
 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;
 }
 
+static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_command *cmd)
+{
+	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_NL;
+}
+
 static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_command *cmd,
 						   int pscid)
 {
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index fd9c5294dbc082..ea14630430451a 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -966,6 +966,8 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 					  int pscid,
 					  struct riscv_iommu_tlbi *tlbi)
 {
+	bool use_nl = tlbi->non_leaf &&
+		      (iommu->caps & RISCV_IOMMU_CAPABILITIES_NL);
 	struct riscv_iommu_command cmd;
 	unsigned long iova;
 	unsigned int i;
@@ -974,17 +976,17 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 	riscv_iommu_cmd_inval_set_pscid(&cmd, pscid);
 
 	/*
-	 * When non-leaf page table entries were changed, the base spec
-	 * requires a full PSCID invalidation (AV=0) since there is no
-	 * way to do targeted non-leaf invalidation without the NL
-	 * extension. Force global invalidation to preserve correctness.
+	 * If non-leaf entries were changed and the IOMMU doesn't
+	 * support NL, we must fall back to global invalidation (AV=0).
 	 */
-	if (tlbi->single.use_global || tlbi->non_leaf)
+	if (tlbi->single.use_global || (tlbi->non_leaf && !use_nl))
 		goto global;
 
 	iova = tlbi->start;
 	for (i = 0; i < tlbi->single.num; i++) {
 		riscv_iommu_cmd_inval_set_addr(&cmd, iova);
+		if (use_nl)
+			riscv_iommu_cmd_inval_set_nl(&cmd);
 		riscv_iommu_cmd_send(iommu, &cmd);
 		iova += 1ULL << tlbi->single.stride_lg2;
 	}
-- 
2.43.0


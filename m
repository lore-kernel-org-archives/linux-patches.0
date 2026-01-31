Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2155F72622;
	Sat, 31 Jan 2026 00:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817659; cv=fail; b=s/1cgwPPz75997vxhqiqXWod4HFcFHR6/MGJTvKtphJlWYwiTCCqw9lF8pptngsE7Gl9zmTMvCcT6yGKsT1+MuxA5yAFhvUeHfjeYmYWD4mZzhQwULrS8qUvsGyKtzkoJ4w1/3L5nnijtxZdJvOjBq/cCInyLERKBFt4p/qzWcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817659; c=relaxed/simple;
	bh=BH75SFL019N+LDr/WSVsdODDtBJ6oOtrlGjCDZfzM4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rKmq6csPAMJMgeHsHc2VobmWSqK/p/j+K5/SPNmWDHmsgXaGEVCo9eQc0F1MZCCtK3J+1ObCHWK1KSB9xnC+xdo/6bouK7XNNUz+l5/+0eB/WrU2d07j+PeQQ+/3mUKwf24dKXs/RFW2rD6GTipo9im3LZcrDy5ZUD+UP2I6iu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jaZiPHP1; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jaZiPHP1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZudfTUgtabTMz0b9aMDyw11i7IC0xNqpKXBjB53qX7CwWzVe0NtJZ1IBFQ0Gelab2RY92PI3iGtn/Hw/k2NY+GxRywioqB+O0s7hCa8opU/A/KnBoFhNGcdF+n2kYkzQBbnmeD3qV5rxjssfrGpLlKNjz5FgzXeIqWRhXdAe5YH6fWP5TULvmFKNEI2IyV744A/XsjKMIzRBNZKzv/XYdWyfRqFpPT5Bab3l6u2oZZVmTJ4WGIPoXxwvh9ibvmYk7Q4g8UoDC/9Cqppquq8Kejco1MbM7dgytVLTOj1Nqqy6M5hMyvuRmRpuTXFyM/AAcLQeB5ngXqkCBtMNmwMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+XoQyH7QP68qNsNuvWkUhF7o75j5Jq4PC79lVzUvI4=;
 b=lMd+g1Mk6wUoGxEKduAfTUXAZ8IU3bAZi9OQtDAOZSU94Efl/tnWwpPyH2bQAqD/l6Yr4AYgL85XXLSh51L+ooSWGb/NMz6RBkZ3sDZTg0rKgmv3K29lEHSnskSb6CZ+mBjG80IwdDopBgczkd4yiGis4MtAt5XlZJdwxh7Q8KKKudCEwTddS2UyjjXZboDKsfuUEx7XJ+cEJ7uDcihIC/Qe0P/9RGUlWaBIcajUStRLLy+gcQeey1a+TgGs+CGYI+BEPQN2KDhMK5HiDUwr2bLsfjRIBv5n+UmVyClDa/QgXQpfmeCEOqfv2ev21DHnyoNKKctBW/tvY4Pe8n3erg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+XoQyH7QP68qNsNuvWkUhF7o75j5Jq4PC79lVzUvI4=;
 b=jaZiPHP14toHynv5AduoCOl54F3aE7lOaJ7YgNewUaA/gJI15VMbfy8+piCoCvnhmOFvVST5KhPlSBtYtUTIkLXWUQmNJMG8WjMKp86Yd+v3adVpUB/oYu6kBmygbkNX2IUdi8ADxL1xvubkc910U3/fYiWjzAmV30BCKFi/It9cACzcDPMhtJEj7NxM3IATh6+qRAGJnK68sW6qBZRh4GTB5oQFC9Hl5Z9ttmiY4IpygpneXkQUx6XZzdM7wb57ljo+/204sj0pZk+YHT7kI5y31USg5WgmSyil8FmZNgYxHZZmlMnr1nOrMoOOxOgETIOHw/otFthvLjmIGq2SqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 4/5] iommu/riscv: Enable SVNAPOT support for contiguous ptes
Date: Fri, 30 Jan 2026 20:00:44 -0400
Message-ID: <4-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: ff88d8b5-aff7-445b-fa7b-08de605bc9a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VELueSmf+XZC8J9bII5gtRWQEf4XdF9AfuxxxM81KcqxDGeOrSZlS5bDOZuu?=
 =?us-ascii?Q?Jpx3X6Fy6kkzqg2+JYKhQyHzdOk3Zyys9JzOkS9aTqsRIZMV40o/zGHKEi11?=
 =?us-ascii?Q?KGYJLgDix32uUf3NVZjiEpbh/o+7rVCLHXfuD6HA/+Ots5sipoHfkyKw/YSa?=
 =?us-ascii?Q?V4LrpGl+PsmTJBSK2Y4XssfiAMstb2ChrOBs9spC8Sx65t8Zk22zuHzunniD?=
 =?us-ascii?Q?GpZb+DMhcmP3yEt9eiqay1fC+Od/hpygVjm0itGB7f7EvudkrCW41pM3HpWz?=
 =?us-ascii?Q?3pgFBR6o/fppMgVvgMOOTrhTuXWUfJM1ICP1N2IGBmc7YVbxBxJwYONhpyhi?=
 =?us-ascii?Q?bJkcQIh5epkapC9klS/u2IOpZU01sLvm9HKumAXeYtRw3gABUxX+oyX1KZPC?=
 =?us-ascii?Q?0aw58ne8EjGtPLQJMabl+e4dWfj4tLlBeHUkgxtvqCPdEPN4ehdrhm1+LT7a?=
 =?us-ascii?Q?qOA33PNQ5pOWUq2MdCEpjBCYW7l04APvFfaur2eOWMvfG6QQFOFNqrvhbvVF?=
 =?us-ascii?Q?/IUTH1849Kdtr6vK3w/xdMzb5aBcXt1jNxhY56sbFh/wT+j8eKsbGCVmUUW2?=
 =?us-ascii?Q?g79qUbJGYGtScHkhya/QgWGhxh7ZI7v6VWcF0ZvdsSaMoya827eXK3Ig2Njr?=
 =?us-ascii?Q?m/kmWUHV2SD1NTdD5hwTzmYpA9RZYEeukZNmVME+qVyrI+EXLmvCe77odaFe?=
 =?us-ascii?Q?jVozAXe4sidk7pmgCsTSh5OLpAXPiZvXcKwn0dUH+fi7QSGA17oJJN1cUxr/?=
 =?us-ascii?Q?N1fBMfOriZcPXE72GkIaCor+5lrsMH6rwH5L+rqd5YE0iyc6bG/m9WLtViua?=
 =?us-ascii?Q?Q5FLJa4/iUg1fnclEmotl8MG9MQQLVdJo21oAa0lktiN3e+7CmVVCAYgxxB6?=
 =?us-ascii?Q?uh8LfRQyvgxWOh0fOuoCUnqlr1ZmH3h5x0nEWgSVNoh9PWWjzHc+lVx8SjfL?=
 =?us-ascii?Q?uTBxOvMoejbB3bgIZ+sb2NEAAOdi8Oz9XncthZ2ZNhXEhtz8/QH176plEu/h?=
 =?us-ascii?Q?g2C1r+g/9uz0J0mrHN6jCkRSLe12d6Lme9Y74Bg2yUm7vBVUgFbmvU4WyZPY?=
 =?us-ascii?Q?CTh2XVkHRAAd3R0G3jlgLKsjJ/4NOGw8VcAxA7YWQG4fT6Xq3aNxUqxcGVc8?=
 =?us-ascii?Q?buHGAy9CF6WIaMsNH96DfUl+xVVHm2tiej5OY6T0iN7O4myrkX5N9Cj+zHjD?=
 =?us-ascii?Q?C0emfyRLpY4ysmS2LI4OZR4gvVjlKNusZMdUG+4HQ8YhKj0mxOXpxO522F54?=
 =?us-ascii?Q?IxQ/D3fmKdQqrGtTgo0TOeSKs8kEcSwJM9hayx3LUDuA1lxuxJ86B4jfPcGQ?=
 =?us-ascii?Q?7NqOHOawRjNn0QTRtd+uiPU4N8ibT8XFVoXKq9zEduoEn2fugFeR0Zfi3boy?=
 =?us-ascii?Q?/2AzzkY+db1PXHigE5F/KXmi55+JxTotkat2Xo0IHnB6tsEyQUhglXBxUK9h?=
 =?us-ascii?Q?5sgybEE8sxqFa1WZOXpGCLzlWMpTaz4mH3yyqDejH9ZnfzdLUpB3skuB0e5a?=
 =?us-ascii?Q?KgYI2OO+gwDkWAeEwA9kTyLsQhD+APXi4S4pwNtGpMDMpNVQhfNcNOqHZLsm?=
 =?us-ascii?Q?1ef0yaI2T17IbcxwmmU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b1CgU8VvFrUKgVoiFzej9IuNpaiCnoMlR37CygStOdxYV+8tMhnMcA8vikAd?=
 =?us-ascii?Q?4djnaz2GsbEqcYRpjD6F1PJlFLe3gWHwMTFTP39XROiEkIwiLw3EPmFuOpUG?=
 =?us-ascii?Q?/oTL7vqxqay5zDRApw4sXd0+behjmrzVY91rebDJVdAuNUsg2zEvcxDmhDHj?=
 =?us-ascii?Q?XHkGXet5ZDlTo3HDhRcuQ5yglejchTRg8lHCWF2wWTuGC8kTMsEGyuVIMXJN?=
 =?us-ascii?Q?WTlTw5BctRz5p32KqmTPtIUP0FdM2CE2qPzxUit2MPHy6zTxQzsZXhaD1skQ?=
 =?us-ascii?Q?tUuCLKSjuBzScEDM9cQLeJRhLpv7Y/6KLJbiojBd3JT3RATn1pPstemASw4e?=
 =?us-ascii?Q?/j5zoeJZqtwZVzD7XkXXsNei2NgDOeWAZ9MumoaQJ0K6sxEyZscg9aSJgt5V?=
 =?us-ascii?Q?TnpL6Rr6EeoCzyzdflh4O3zyYib9jhU7ToZFspUVroi82T1dMeawSGNWMxNA?=
 =?us-ascii?Q?VGreKc0+QFWv+p8E9ZpFrqx18E1zQiJtoX0KuWydD5cTFODM3NlGqNyeJck0?=
 =?us-ascii?Q?mkMRbbrYyeapC9HFQAJi2LKPQ2IzQi4V/AwL0cN+vk5sIaZD6E2BClNvhl6b?=
 =?us-ascii?Q?m2cTK57/3cG1WzLcUpZviiCEz1D6wz6PQJ0H0NN+hheEm9j7EOrYQ5KDOpoz?=
 =?us-ascii?Q?dULJSaRw2HV6CdHuv7T+nh42I9JUzdtsSdM54hCoump2g1STz/T/cum7pb5l?=
 =?us-ascii?Q?JOJotepFAHDQq3IbDkINCpo8BMz3Q0GEKX7ZgPmtV9pc5GBmWTed5SmJHNQW?=
 =?us-ascii?Q?VQwr05V8lP5wKJe6N3H0OfzzxXyDZjw39/HYNqPoIl5gQoX1H1CoiGct0Slm?=
 =?us-ascii?Q?s2TUsMNY3N0720HHBQ6b1h922vHRebZyW/VUjKuhwNdNUtmQ/A8aLIYthTvN?=
 =?us-ascii?Q?9xyQsvHKaM79hjveXf9Oo/rz4myz1mYyNqZmyWytKJT4xqOHrbvlyjdEMKAJ?=
 =?us-ascii?Q?abY5EaeGWqJyFIt6pu9VpnT7eTStm047+QzXgUAAu/NflVhWoNdyhGWMV+xu?=
 =?us-ascii?Q?WGwaUeqOmptLu1kSNJ0TOeRrPbd3GfRZMFEfNo1FSj/CmdkiTJKfczgFdZss?=
 =?us-ascii?Q?4DwkbcuyqS6IR3dZd8KDYhHj2GSRgufRD5YQiAi4ovPwWuTYznPiyRME1Wxu?=
 =?us-ascii?Q?0hzb/MyGeuQXTKFJt4rLAmfb0u+/3dK1haMf226M32BiES0VWYayO+O/3C3L?=
 =?us-ascii?Q?q5VwceaYOhM0OYZuKlq1hDeDDor0CmLTkgtgfnouhngiRSI+xjPIl+3knUSY?=
 =?us-ascii?Q?cpNIW38dN6DPmDDWuRBK46IlgPYQmed81A4RB+FY+JQ5MP7buZ4SaDh0qffA?=
 =?us-ascii?Q?Gocir1Ptpsh2o5shUxHrBLsA7C6RIZTi/J1b4TDIFtpiHGVibDN1o+bmT6hj?=
 =?us-ascii?Q?mpx7wzneRDoS8LOYAIXhfbv1D1E61OI/jqcLCM+enWYL3ljA0wF6aSroj11e?=
 =?us-ascii?Q?chkR1WUcx1zktcYInDmWa2dfHpykzcQkL34oH38KfF7JdXc2qhSkNQSV43kY?=
 =?us-ascii?Q?WLv3VtsPgQCx8DyEVs9iEk+PVpIkDBFjVdQ6l6OGQSQTAvAmOvbqXf/rYcte?=
 =?us-ascii?Q?jIeUJJyTJxBjdJsGqcyci02eyLDp1lSnNF47+xXfTQ6S1U7lgV66mmp8Yjfa?=
 =?us-ascii?Q?V49MkXI8k3kPNytFp53P1nk3b3x4xq/plakn91ApW1F1q5ZJ8OlSL/SB7vnm?=
 =?us-ascii?Q?cGJd3Gh/5HN0JBGJLrCDGaKtjSJfp8AV/bmY433emntnpSgaHg/npxm/iGS1?=
 =?us-ascii?Q?HZRE+jgxvw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff88d8b5-aff7-445b-fa7b-08de605bc9a3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:47.6130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+9AIkkDLopSTEEAaJGLIimCrtYYAvJQhJInJIBu51CridPz7QQyhENtem9umGNN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

This turns on a 64k page size. The "RISC-V IOMMU Architecture
Specification" states:

  6.4 IOMMU capabilities
  [..]
  IOMMU implementations must support the Svnapot standard extension for
  NAPOT Translation Contiguity.

So just switch it on unconditionally.

Cc: Xu Lu <luxu.kernel@bytedance.com>
Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index c02878f00294b5..4e2e08114bbf15 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1185,8 +1185,13 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
+	/*
+	 * 6.4 IOMMU capabilities [..] IOMMU implementations must support the
+	 * Svnapot standard extension for NAPOT Translation Contiguity.
+	 */
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
-			      BIT(PT_FEAT_FLUSH_RANGE);
+			      BIT(PT_FEAT_FLUSH_RANGE) |
+			      BIT(PT_FEAT_RISCV_SVNAPOT_64K);
 	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
 	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
-- 
2.43.0


Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809314C58E;
	Wed, 27 Mar 2024 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562906; cv=fail; b=qe95jcSAog6yAJhD1d060HP6WS3DbXAPijHi965FGdDrMFMQ27F/xtTC9OWdezSp6Ww6IsXJu3uwQWs2RaxmYIzlb1hSMIPrL/ZM2Xy5Y3RMye68pAQtodIKS91WVOuym5R3nLXQf40jSDmnryw76XqEJP4WOXMI6bxnPtljmq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562906; c=relaxed/simple;
	bh=PNES9DSiAR0M9MQnAkwcYXSwu4Fky81Lg+GHY0n8bGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NmtU7zCDJPJMYYYxLEv7jYZYqIiu4tzpSc1wtypveOcSZQnc5A2rc0lqnYRDYdiyrsqLDnqPsLJwIneiOkFVLCdwoffTDnV9CioPfE4brhYhQV2e4jslEfMcT1Ovx7Rm+zzl5MZV4kqbSIfIjcMDDvwzqbjqcb0qXyaraD/6ZzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M/OwlqHp; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M/OwlqHp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNv3lPqx801rlxjKGeym4/WsB0BhwzVyfHXFdmr9fkz7CtQSk6GPu3yHSLnwPlNKHo2ESXI0wcMFPFW37JeZ0vgYdhReKHH9TMwtsDyPJiOqs9ePdWjTzm2HUYRp15glaF3DvPDt7NlTIitD8fSxyI9hXWcqd1DAaTHvFyBppnj4x17C/IDPZF1yMnX8/JcKlEoSHgqSzzN7ZeSrKaXhNa20rM1sgPh6TXGC0IhjDokx1AFPB+uwkZISlk0HJILeC7A3/xcbtz/0l6awVhFKcQWohBOK0z8c0mgkIslDCPgSy15nGPz998cEXk74vf7/9aXD3EO01jJn9OOI8xIlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+q+NyN7EmQpLSiCvfUmAP8PFcDmU7QJ/E6ybS8LRe0Y=;
 b=cBEB1kUkN9PV3ytrRnjaTeLQaMzkNuam5ci89VvfiTU0Oxmihc1gQNEinai0bKbpk+RR/NV/BLnPPFfxxXH25dV6urNawmKRyLARQwO9ODvw+I5ahQ7zE8RXdNs/Z00Xw7Om0doQyN3mF84QCiuCVbEByldd6SvXwyCqPSdSGaZfnrwfs6BGuVNyUqXedCiYazp4dGiU1y3iC7grIPJsxUXWG3gMyELWsgaizy2qsORB1/p9SMs9QFcdP3kgoFkJdE0mQNz6VOauaPDrg+VuAFhFJgRB2KBPWtdzchJl5C2Bg0yh2UpmKUnvsVUQkMM+oB5rtx8z8T9z0P8XkS/fSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+q+NyN7EmQpLSiCvfUmAP8PFcDmU7QJ/E6ybS8LRe0Y=;
 b=M/OwlqHpkLPW2P0wz12nvrltXy17GVo5Eb1onmJ8vaF6Ds1JiAjv0SxByET0zvDuuoVKYrvLj8HWQn//227qzQhRgWcAaoAMlS2QPRIouqgj7Mz0m2C7T4cS/XHyoPI1BQ6K0W7WurN6xHw3dRW2h+CbsYoWC15NCqtUIUDZ8XRcsNjO/rP+8ELzTj6tQd6PziBe7Puo0smm/waaFSU90kHRnOuo9jvim7bqZKV/8FOZJPEBZ4UHWEXht08Ghs4MmHSME80A3ZBHpgZdJc9Pnsyw2CUbmGZ5rQNmqHE0UA50aBTT4W+c9rLoNrcHnICbsOS+dIoZjpFRRWRZHGP6sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:19 +0000
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
Subject: [PATCH v6 02/29] iommu/arm-smmu-v3: Add cpu_to_le64() around STRTAB_STE_0_V
Date: Wed, 27 Mar 2024 15:07:48 -0300
Message-ID: <2-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0310.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d84f27a-1e5d-4ebc-b2a0-08dc4e88e0da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ldJs1LAGHsSeN/dvAUkTEVWTxZD/e2trYP9Fa3lATVbVhf9jEpye3rBHSsgMCBm0npf6tZ9x9OlA+tCDhB1jh7VzIOVx18AtzUVTlq7EkgyrE+vbZ0mKlJBgxGE/dQj50WQDTRzAcxzzKshetP5SkkueBdEKKF5MVr37iN7AsDnIoVcuThilzo2HLk/CBk1EDrekh/txaQtne6VTgQ0QCEC/x3BPl8EynFXB03OW7uqJ20EFzwUZAUlBPL9rfDERIv6UpyP+2YlXfPNOlBp5HwT4PHeeBaWYrGN8NhocXGLlWut92ySxRAYUcr1W5xX8ctfkI6bRGI9CqGMJfs+H5vOlcIKi8ooq/UxBY4CELoNqN+yRU6KbxhljhipIRQzrC9nGbqO5YnocMQTgr7Aunge1BXT2MnzWgN5VezI3F/90IV9bZ6QpsTThlpPFQyUsL7gNZQquHHvma9ZdZBuK3PhVqSEuV4bwA9pPttFF7Jy30Tmjh3gJJGBvNFgHuGMHRsJf1VwRhoVidrWD9PdvZTapEorVaHWh+7U/lWJeo885CQZ9IfoXTGDH0Fteh83veQRq8P2rLdj8N3DEy1ZUKbHSJctk4fWTgiNbuSfVCzzS5ksG8SbKIoS/VcfYxE8uJA8Wzt8PHhEb7izbi/I82+dSwmFZqv9Dg3nHjCN/7Mg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zLUWM2e3hImP+aEQHZYo2t8EjOiE4g7T+GJcCRkDg8SzeRU60dNw4DRlIRvU?=
 =?us-ascii?Q?AtSn0yR3PzMvGbBZ9Fu9YUkHgTSh/8E2TUjD5B6AfKzcjjpJXJMRqRC29qqW?=
 =?us-ascii?Q?jOAWeVOXYgd0xCeawvBghKdrY3oJHTBsApWGJTq5ZaQG2PlIxCA7kut2vQOf?=
 =?us-ascii?Q?DD58mDTdchCzCwhTHWmm5UjvfwmH2W36PR/6hjrrPUQtBEjQidgND6HfdHyD?=
 =?us-ascii?Q?lV5LKfvNtezIS7kHixNrZpNQ82u7Hs7rCDh+28jZodEl0KoRXSLXp+MvWfv+?=
 =?us-ascii?Q?CWvXwsxuE1OpqQPWOpEAzLeOoOwEkKgZrLzCUktZHaKYTehVB6Z2HVCliXGq?=
 =?us-ascii?Q?tCj4HLamaRxb/Je37ZhKt+4tgeY+A1BgTyEuur50+Vo7FlJhswgIOCPfGHs6?=
 =?us-ascii?Q?PS0rM0MF81FKzUSgBbIUs/qF9A10yd24IV4syJT3dugt78tbZ3v1eDctunJW?=
 =?us-ascii?Q?89c/BvxaMOhDQ8S6sjRNPv1ZaeMXMAZo7ybLHvM/4HxLPkdfYr4vyDD7LFP5?=
 =?us-ascii?Q?1+TasbF6ijopS/uoQyFnPxmIdrBIr4ZCYstequ9zcvJ3gCGDMfj7jJBpGQXT?=
 =?us-ascii?Q?FvUa1C+GLB34pwa1DDtYF4v5tkVb4gSZhTGVLB9e7hr5jjxOVDGflBWnCiNx?=
 =?us-ascii?Q?ayoeEbk8m1dE3unkWM5RtGsMTtthMU5d3OuCZpO7xA7+bAMVCdr2pogdUPUh?=
 =?us-ascii?Q?dWGbGp+xm16eA2AWJrX0sVHJY9kHKXnajUO1piKprcvzS2zza3SjC15XOp2h?=
 =?us-ascii?Q?eKITxBSdNCbPO3dvQfunB6SYBjTpVTk2puVjSJ95MpWnCQS9hrhMkduYkva2?=
 =?us-ascii?Q?HKAxKoWtoVGwplVYKWOhHqCeRDV8MxNh3Hj/KDV5e5fvUjFDQN62813zYuwi?=
 =?us-ascii?Q?BGxveUZ6+2DbqIZMt1hkoFenEnVQ0dIwxTcILV4haczqDhDMH3QRKIAXFxUX?=
 =?us-ascii?Q?A+WFhGyt0ndzYm0Li9fCaKoDFvhOFuICOrdHP7QwfonyqVl/sH9pDV03B9Ju?=
 =?us-ascii?Q?1yGxPDrIL93dANP6T6xN6D8O3v7mPS+ADYQoWC3I4niGIb4cIQK1Vc4In+m8?=
 =?us-ascii?Q?u2o/Hq9x5h80gRWE9pqUvTa+Bv489xSMQG57unpGEzGhvDSNtdhRVnUU/Ped?=
 =?us-ascii?Q?1wSoKQDca6rNiYgbUzkp/BDDWyK/xp/vaQJvUtslgPH06n8/Ttiafaf3hpjc?=
 =?us-ascii?Q?++YWaqW8fJJM8S8/5MBugHjRtVlU9QKhtJTyIs/9/50jhY3zZ1l+rUYTbm6j?=
 =?us-ascii?Q?KMNxouNBfLibbLRP3saQkA9/5NaMusgATTGOACRTWbbWZW/X2IGLHpQ3ORv2?=
 =?us-ascii?Q?Q+QFJZmazniWYvL1SUh6QqyImHjlaSKLGa503ldGz6ynPId8oQLwQKM1q4Dx?=
 =?us-ascii?Q?bk5LV1Ri0Zxj/bKhyffUR2++0eK7R5/cifY13/qjDbC2WwuNf+Y5/ze/eXcq?=
 =?us-ascii?Q?35isfI2aGAiNa43PfAiTGFvgNH1S00A1O1Rd4OLgKVYfZl+IPstjuOoNY8O0?=
 =?us-ascii?Q?5RSNV40/6r3TO4vnVu486D/VAejXgMGnb7kyCRR48M/oJY7JA67RONDRMWT9?=
 =?us-ascii?Q?HUEtagaXLM+FS6JZv7t/mSD6WdPRSI+8GZJguax/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d84f27a-1e5d-4ebc-b2a0-08dc4e88e0da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cG8P9oMYKn7mnF4I6nuFVY02/qOpQxaZyta7v0U34JQqaAHbD0GB5bercgU8hAF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

STRTAB_STE_0_V is a CPU value, it needs conversion for sparse to be clean.

The missing annotation was a mistake introduced by splitting the ops out
from the STE writer.

Fixes: 7da51af9125c ("iommu/arm-smmu-v3: Make STE programming independent of the callers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403011441.5WqGrYjp-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5ed036225e69bb..fa3f3e7d9b0cba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1139,7 +1139,8 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * requires a breaking update, zero the V bit, write all qwords
 		 * but 0, then set qword 0
 		 */
-		unused_update.data[0] = entry->data[0] & (~STRTAB_STE_0_V);
+		unused_update.data[0] = entry->data[0] &
+					cpu_to_le64(~STRTAB_STE_0_V);
 		entry_set(smmu, sid, entry, &unused_update, 0, 1);
 		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
 		entry_set(smmu, sid, entry, target, 0, 1);
-- 
2.43.2


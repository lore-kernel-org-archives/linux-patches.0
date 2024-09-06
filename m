Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC441D278A;
	Fri,  6 Sep 2024 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637696; cv=fail; b=BmBpW58LDlG3zQBlpjtB8lr5qLAiJtJMiHTm+hoNIm1BXdZy2FebaTrCTKYOPGjHNSCnjbNXIIUZ/aLsNA+Ql5Jf5kLuavKCMPeXPUWQFCNa+G9ezb/CSTNyQpC4+DUhCgsms7tYxKC7h1KE+a9kb8SahTwDxtcXHSMPox3KfNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637696; c=relaxed/simple;
	bh=wOUsZ4uon0zSF+06G/epTrpt07ZzB4G4cqIYRZcJBTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mv67yxO+qFVevRXxhmmkBm2chGEyI9EA/CVYObfdR6K3ko6L3bYadUAp8z2RC8xBrsFHkr50BPMx5tYPu3uqIVqaSFP4EDCxzQUQyUrdCi7Vde0f3jCMSfceERq0pvnHFWkfj2DNxrY9AOTWmgVqqnlQr8qt3iewZ6/Ofe366B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=px+gL8N8; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="px+gL8N8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDF+PIxMPPekA8jjjZrVvmHbKEe0sIBi/sD/8Vcu2Kyk8jRm1UP+VOlgYBB+A2ay42gJOleC6BnbXvwhIQoSHX+hf9Jr2yU2w3cmDw9yiwtvYTJbNZqYOaBbVADXHCCA09dfZD9NwV+EBLrV0wH1TFpvn+i+4ftm1DZQiYirD74nOxPI7noZLlb7OVhtXzXPUVhs2jfYvXdwNErpooJmu6/lH/LjMJq+iQISjV4AswH34K+tQGw9fDo9yv91SqwO36YIH3Duqq0IU9wb1KZk9J+fowkGixIETt/KwAqzbkKRCEKdFHsiayBPMFlcGKUEWxmYXWEYTW1NsZg3lUqZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pL8yOKo2//ZVxyx5e8QXdjU3hywYbyecYr5naa3v8Aw=;
 b=m7XtnSQiCZIIaVfF8Ly5cW3xoDm6sX4aPnqQrqPV79XYLGYxSvDbdp8pklRcMdFKXqfbq5SRAgnd08NqcC3AVRzbwRUEkDJAbAUemoMjT/8ndhNU4cckVXhSEF3V8+hryMS3LcSSRwRQN22h9yrdS4R7uzhmZyakG+su0YVijXueBbYeEAy6erq83psSJ6xbcI4mvSONq3OER2hkwk5wc+IMAslHqJoZcx6Aga5cuaYju8617gld0KPs/oOk5TAZfGVLLjVe7NZ20cO60n7P6MlVv0vNDe9hl/ZR944L3GeWab7wYN/vexyG8GSzabCgJxKQKchAMiezaljBy1x6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pL8yOKo2//ZVxyx5e8QXdjU3hywYbyecYr5naa3v8Aw=;
 b=px+gL8N8PVBRTyqIvSoHEdBALz9uGNNwCyeA7R33wxYlJXVp7md1jHOD0lS+OOvPcN9RPGYYKU7bsKpXsJ7Bvb12/TY93teXz+/jezxsSS3Poqbwptqkih0HIDZ7L+7XPizux4EqC3QBHXyCZ4yVPgYBmwC4MKgffpt1GF0aT7M+7CJ6GVcYu3o+3ZRjO4U21UepSgy5GECtlok80R3XgjyIQ8tKJ5XOBErXhnwnR6TKrVZ8C97XutatlCAOz7gFxqV+OWiXE8KK+EW0qNLKubHd6rjd9H9cOC1e4F+htiZ4kUDRwweCtWoPeQUqmgWsu5ukrL+4VeopUkqTcumzNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:04 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:04 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 3/8] iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
Date: Fri,  6 Sep 2024 12:47:50 -0300
Message-ID: <3-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0371.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: ea54cbec-5176-4a6f-b6c7-08dcce8b4765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MLVgHg3yrmToCjhmlqOZxhTwf2b2zbMLdVJadh5bs/RbCO/zgrdQkgygFSxa?=
 =?us-ascii?Q?EZfV9gOq12H3kTlyRous/UZA+6kE26NnnekZ7wgYNbNk5Ohnxhurv+2VS4t6?=
 =?us-ascii?Q?+m452/zjLYn9C3arLxuMkbpFvlRsUFdmcCi030lkZF6HJWnUSbwu9525NB1h?=
 =?us-ascii?Q?sO56e1SPIC1vpsaKcp4FlJl+hQq/WnqhMaeqMsMBVI1vOaf96ZVrCH9AlSAv?=
 =?us-ascii?Q?Iw/+H8r4Y7XiN9A5u/88fUJufPdhzGNK0+Y2rTKUwAxBYjlelKG4aQ2RpAOI?=
 =?us-ascii?Q?yQ/eYqpkCKi6Mn9W9+vunXdMlgbdjTRYBZTaYzM6oD7Xg51Od1YXc6wLmWPF?=
 =?us-ascii?Q?uSUYbfCqPpM1Hj1P/bx8j827NV+98EKbyzRWXnj7e0vOL2w2wr8Iy6H22Svl?=
 =?us-ascii?Q?BRhxAT0HuoIvST13OvFDRZ8UupHjDUJxdIEZ9Z5irNGzQwBsLWMjFL63rp8H?=
 =?us-ascii?Q?2jwteT5aPAlUKzPp2e3UeTNcxG4QEe2tY6FeyXQD+KprPKH72hS8q/KsFG2n?=
 =?us-ascii?Q?YII3DIvcq3CO1QHsW+i6fmKikXnVgWuk5p1qKMycPQb4KHm6eOzC/8sYsimg?=
 =?us-ascii?Q?suC2HjxtnDJwI8Cc763mp3oK6DbZvWXVGrrYqD2GhDRpIqGXIYIiqEJmbfVX?=
 =?us-ascii?Q?NwY0Ip0+MZTDGBIVYvST2JzQaex30XQ1t9p2WYc+aonsd6zJC3WJVDP5VUHm?=
 =?us-ascii?Q?gZRT/kexEUmx2JpfGV1JiCgcXNuMDB49+4q8d48pTWi0gMCNs5Ex3dSrN3gL?=
 =?us-ascii?Q?nVreM1cmhTH//YkEUrNeOJ38BpQUUJ8CH+5cETRy2GITGXIHjFGjH7wonu6p?=
 =?us-ascii?Q?EdhyWh4Uhx3TtEtewmqDM+SXq3DTxMPEUpsUOeGMn0FdOGBvZ98iTarVISSN?=
 =?us-ascii?Q?kwhN32T7MiYX836sd2SHbniU5ye5sSPX1D+zQFSz+C8GzY0IQaQVXlQAa8re?=
 =?us-ascii?Q?ZuRytSzgvN7AIabcNy0M53xOI5Q/eiuDeInURZpg+k+XPhQ1zVuWizuyahxb?=
 =?us-ascii?Q?86NIaLQaxuzq832VEJyN3YMhq3hS9srcjIYNmFh4zlaYG/P7mkk0Fv01/nk/?=
 =?us-ascii?Q?HTOiE/Mo8k7mqNb4G5FlgB8uj1NBaYo4pnL+jpR2eaZzko2dpyVzrY52muDc?=
 =?us-ascii?Q?Kpsl5bPeyoxJiH//cS9tl5kYhGD5meOMIcT4yp6wQuN++VJhBJCzB/9iJ1VM?=
 =?us-ascii?Q?ekdlLXqEXmnucYhnxt18NaVC+0flAZBD+VCcA7nEFwvkcyapfDShHrOJy7Oe?=
 =?us-ascii?Q?9/nnc5fNLH47bzzbwapgqNylkwfa3LHPPwpJr7Xa7Lsx5aWCYG64f7Nlqz+2?=
 =?us-ascii?Q?M3ebjhldeZ3Y83nDDD07OmgGmjW4opKgdONxUsYWOXJ1Lw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PFweR1uZjkUbiElTZRnEyB4ABJwTmRpvTM8lCGVQbb7EOvx5EE5PL7fmRQ+j?=
 =?us-ascii?Q?vzCZowwGlgZdr9lOOHJjaxZqr9x0S6wwHB8paN5+qkaWLyxYkl/yZdgJcT1P?=
 =?us-ascii?Q?B6EiDt0n5Obats9QkRuDbi+eQsbx8Pf2ly0tC3XPSG1AlyEpLUs2Fdzn26IQ?=
 =?us-ascii?Q?I/QIk4lwFCfHICrfmoqzVxfNvPYEjw1ocsFdxVKOGnh8cLENtJ54qSna3J1S?=
 =?us-ascii?Q?Eyoz2olVPgqaHDPPCc0QpxfBw67QV4HrR/HqoOaX8IjeIW+Bt2bkVpGAL2wk?=
 =?us-ascii?Q?KNSX246eY+4s7bYL2Bw/O+hTseSSQ5RBziMHGj975W3gpEqHIi0+V46TY1sf?=
 =?us-ascii?Q?M2HzYdBRt/9poLHiD3/KV8Ax5h6xuB4ScBjOagLmmifaNhoI0mXmrluoYUJt?=
 =?us-ascii?Q?8CF/DzWEIr0ICb/OUgwXEKscv46KBGDdKvrwvmXwwRd+aktUUh6mQIA+tsW3?=
 =?us-ascii?Q?ewlPagoWGt5RbA0bynuCnutl2rn9XGAnWxpbqWWR6R1711odjQN0HpAr9u55?=
 =?us-ascii?Q?CQ961oelR3TNsItpjP1T3rBtsHbl7BG+WnOOuog1EOkFBs2TYVlOMzPD7E90?=
 =?us-ascii?Q?EHiUNcmyllb6G/g21+alqTNqMa3XKPPa6HpPMf7NfgplNrXOJjqZNCNIufYT?=
 =?us-ascii?Q?LBSIYgJEUMWDz6NFwebWK7s73CDQhv512SPD2FMX5pU2S/itkadRGhB5nl2w?=
 =?us-ascii?Q?rIKPvbk9P2Rynv+ty+NGxA6Iox/ias+Db5iTPmI4DaF3fgP/WMjq8Q9uHdY2?=
 =?us-ascii?Q?qBHDJWJThDmkiwnNHM9p9f9VWp1M8BpCPzIwv0MIfI7bHa8kawyvTR3+AT7t?=
 =?us-ascii?Q?WVpdROlLvzZ1Pq77pncpK/e3Wnn/ruzcPBSG0ipzS8rpoEy8jN9PB9hfQOKe?=
 =?us-ascii?Q?H2GObiA4uW0giLRfjl5M+UqXN+lghlMYXSDg+0gUh4Nc0osfVsCTw/2mvxGs?=
 =?us-ascii?Q?GmxvZcuU5nhC8BDWr1QL0/acl4Wp+zGXibeI98F8mYQEpL8RRCditeSdmliR?=
 =?us-ascii?Q?BmqbStuZ0Q63pLesfROJ3Hvyivxyc2viLixpFaOzbaJ16Yw475rSXPmO/aFg?=
 =?us-ascii?Q?/fWr1Qab3BcL9MEa/vnu9hJtC+DZYkOQCgQQS4A9wGVKTjqhwyiqdoJ8ghZB?=
 =?us-ascii?Q?fwNggKCXASorZ9LAzpXj1X68MB3+3OykKaMNmsFl0HDO4ExgbRMnWAz/BSB3?=
 =?us-ascii?Q?MTWnDhQYBezVABazNHOi/39S15RjqnPvklKr6y9ri0cFaAh1KK0QPuYZ/vN+?=
 =?us-ascii?Q?V0WpOLSdp0aLGDq5vUsQr6Zc1hTe+k3a6eYB1UKQaaoLdu/T2mqtdRegnBKk?=
 =?us-ascii?Q?KpQ8+LYoJI1LxyPtHA0LugM27yF5x6ypmPuyQYdFEs1axvvka335lGJk4sri?=
 =?us-ascii?Q?3HWE0N8/DhEL6N/VSuRp9M9vz9LJB95e3W5upvQFjKyLtVZYPHSnpiNt5EOx?=
 =?us-ascii?Q?1z3SWJ5txZGqzEgKxRqQteLEoYe4Nfx7pqor18c3oME/LY6UwAxutHe59t3Q?=
 =?us-ascii?Q?u4jBXcWW/soduaNTvHcIcnsTQgAca/FTjtlUphCVblo35SWzN4OIgw4AWg+o?=
 =?us-ascii?Q?/Tj2CfLNb8vrmtRGb8dncBfS2ur6Az71QWOd6Tfu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea54cbec-5176-4a6f-b6c7-08dcce8b4765
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:57.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjTBnvXES9IW1BQnWnVgJo6zhoiYcaen937xq867htKgsJtet8cZI6WhKElW7RvR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove STRTAB_STE_DWORDS by changing the last places to use
sizeof(struct arm_smmu_ste).

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 78 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 22 +++---
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f9faaec946c294..336803fb1f895e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1712,25 +1712,24 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc;
-	__le64 *dst;
+	struct arm_smmu_strtab_l2 **l2table;
 
-	desc = &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
-	if (desc->l2ptr)
+	l2table = &cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)];
+	if (*l2table)
 		return 0;
 
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, sizeof(*desc->l2ptr),
-					  &l2ptr_dma, GFP_KERNEL);
-	if (!desc->l2ptr) {
+	*l2table = dmam_alloc_coherent(smmu->dev, sizeof(**l2table),
+				       &l2ptr_dma, GFP_KERNEL);
+	if (!*l2table) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
 			sid);
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr->stes, STRTAB_NUM_L2_STES);
-	dst = &cfg->strtab[arm_smmu_strtab_l1_idx(sid)];
-	arm_smmu_write_strtab_l1_desc((struct arm_smmu_strtab_l1 *)dst,
+	arm_smmu_init_initial_stes((*l2table)->stes,
+				   ARRAY_SIZE((*l2table)->stes));
+	arm_smmu_write_strtab_l1_desc(&cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)],
 				      l2ptr_dma);
 	return 0;
 }
@@ -2487,12 +2486,11 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		/* Two-level walk */
-		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
-				.l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+		return &cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)]
+				->stes[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
-		return (struct arm_smmu_ste *)&cfg
-			       ->strtab[sid * STRTAB_STE_DWORDS];
+		return &cfg->linear.table[sid];
 	}
 }
 
@@ -3193,8 +3191,8 @@ struct arm_smmu_device *arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
 static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		return arm_smmu_strtab_l1_idx(sid) < smmu->strtab_cfg.num_l1_ents;
-	return sid < smmu->strtab_cfg.num_l1_ents;
+		return arm_smmu_strtab_l1_idx(sid) < smmu->strtab_cfg.l2.num_l1_ents;
+	return sid < smmu->strtab_cfg.linear.num_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3629,7 +3627,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	void *strtab;
 	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -3637,34 +3634,33 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
-	cfg->num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
-	if (cfg->num_l1_ents <= last_sid_idx)
+	cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->l2.num_l1_ents <= last_sid_idx)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u bits of SID\n",
-			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
+			 ilog2(cfg->l2.num_l1_ents * STRTAB_NUM_L2_STES),
 			 smmu->sid_bits);
 
-	l1size = cfg->num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
-	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
-				     GFP_KERNEL);
-	if (!strtab) {
+	l1size = cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
+	cfg->l2.l1tab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->l2.l1_dma,
+					    GFP_KERNEL);
+	if (!cfg->l2.l1tab) {
 		dev_err(smmu->dev,
 			"failed to allocate l1 stream table (%u bytes)\n",
 			l1size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
-			  ilog2(cfg->num_l1_ents) + STRTAB_SPLIT);
+			  ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
-	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
-				    sizeof(*cfg->l1_desc), GFP_KERNEL);
-	if (!cfg->l1_desc)
+	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
+				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
+	if (!cfg->l2.l2ptrs)
 		return -ENOMEM;
 
 	return 0;
@@ -3672,29 +3668,28 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 {
-	void *strtab;
 	u64 reg;
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
-	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
-	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
-				     GFP_KERNEL);
-	if (!strtab) {
+	size = (1 << smmu->sid_bits) * sizeof(struct arm_smmu_ste);
+	cfg->linear.table = dmam_alloc_coherent(smmu->dev, size,
+						&cfg->linear.ste_dma,
+						GFP_KERNEL);
+	if (!cfg->linear.table) {
 		dev_err(smmu->dev,
 			"failed to allocate linear stream table (%u bytes)\n",
 			size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
-	cfg->num_l1_ents = 1 << smmu->sid_bits;
+	cfg->linear.num_ents = 1 << smmu->sid_bits;
 
 	/* Configure strtab_base_cfg for a linear table covering all SIDs */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_initial_stes(strtab, cfg->num_l1_ents);
+	arm_smmu_init_initial_stes(cfg->linear.table, cfg->linear.num_ents);
 	return 0;
 }
 
@@ -3703,16 +3698,17 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	u64 reg;
 	int ret;
 
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		ret = arm_smmu_init_strtab_2lvl(smmu);
-	else
+		reg = smmu->strtab_cfg.l2.l1_dma & STRTAB_BASE_ADDR_MASK;
+	} else {
 		ret = arm_smmu_init_strtab_linear(smmu);
-
+		reg = smmu->strtab_cfg.linear.ste_dma & STRTAB_BASE_ADDR_MASK;
+	}
 	if (ret)
 		return ret;
 
 	/* Set the strtab base address */
-	reg  = smmu->strtab_cfg.strtab_dma & STRTAB_BASE_ADDR_MASK;
 	reg |= STRTAB_BASE_RA;
 	smmu->strtab_cfg.strtab_base = reg;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b25dd72179415b..23918a547cbbce 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -613,10 +613,6 @@ struct arm_smmu_priq {
 };
 
 /* High-level stream table and context descriptor structures */
-struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_strtab_l2	*l2ptr;
-};
-
 struct arm_smmu_ctx_desc {
 	u16				asid;
 };
@@ -649,11 +645,19 @@ struct arm_smmu_s2_cfg {
 };
 
 struct arm_smmu_strtab_cfg {
-	__le64				*strtab;
-	dma_addr_t			strtab_dma;
-	struct arm_smmu_strtab_l1_desc	*l1_desc;
-	unsigned int			num_l1_ents;
-
+	union {
+		struct {
+			struct arm_smmu_ste *table;
+			dma_addr_t ste_dma;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_strtab_l1 *l1tab;
+			struct arm_smmu_strtab_l2 **l2ptrs;
+			dma_addr_t l1_dma;
+			unsigned int num_l1_ents;
+		} l2;
+	};
 	u64				strtab_base;
 	u32				strtab_base_cfg;
 };
-- 
2.46.0


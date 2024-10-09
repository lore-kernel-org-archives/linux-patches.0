Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045DF1E1C2F
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491012; cv=fail; b=kyLIHoO7LTUO2UrhqrqXUs8pBzMXUFeGs7GcvGQR0KKdA5Ed3LbrXBtKF3Cq9mjL1yCOq2Y5ll7PKRMu4IKwPbIrnsJRuZiUoEIJO931ullnywA/XPdvTBPYbX29d9RTLm3BS3baqSevs206YodLh2aLEFPatS/5iKb17ZVdVMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491012; c=relaxed/simple;
	bh=d4scfK/awn6fiN+nl4ph6GbOw9++bWGOjgYGwfK9yFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B3WfDxFdFTLPXeSzu34KtUIJzZGnFhWtZM3U+N2MATy1GhX4+NZSoVH5po+0/Q5yZOdbk0o8tM0dY28juEytbNKsN8lLYHqWCiaLawZVUIZUH60vy3N1NWfGFJyf0K/75XUpdHBmBrea3qIOLzeB2T1ZV1b7IqRQXPkJXAeHqhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L0abM61l; arc=fail smtp.client-ip=40.107.220.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L0abM61l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbZZw0Zj7zjk81IqgjbIao8IKVH1ZST7HFWfQxqox5qsAg25iYz/EzZWHfbjtEVpx24NZtfspR/duwhwEldvT0te9krCAPzISv5Qxr2e0v6hvTbO+7Suum/5sl8L8Zr1sVSUW6mxfc5W2yVaPDFsHU65CCfLTFl47ESTFZopeQhJeUmNy+R6AQsEpAbAwtFssZRT6kIH/pSjmAqq7duqUowwEH9Flb9ww9dCgRNpTK+06hbntCOTDS53p2VW8NUSwBl4u5zu4lARXqme42RGaWxQoEKV2lhZDF12TemmMVuJD8OoxhvN11WgxqQoIHWngmeWVE4g3o2DRh99/cROOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlLcOotZn7KIOaZEjh+wsvcl99WKrYuATj4rVYT/KFo=;
 b=usDCfxQhW6Ik/1sv5+OVNxaMeo0b2LLY39egGA9bn7i6noldF0FKFG6YbkzmVAZ8Cp7Gv6Jkd26M1bnOMRCxwP0BBt5Tq/mKGEo5sGr8B2XKXiFhhSn8Vtw7huyAK26zCLGXyfqCzIHWk/Vypi13QYzz847eBT6X7zqxhsGLGttKeP6cMozkmyOwFAJZZjTTUgwgE5z9LGshpWkrco5HhmgKZ9FIj6VH09kKQbnRsqS68Gjn+8QLQPCz1y8mce7ToBzxuVOMsJvIzY6NXzrahBeg0o3aeGiA0lTR5j+k+Mpc8leJooULZvoptBgt2eDkEycjaDjsvn18jjN7RLR+GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlLcOotZn7KIOaZEjh+wsvcl99WKrYuATj4rVYT/KFo=;
 b=L0abM61li+IwBHOnjEj57Ld2YA3fd2R/WjAgNnMoyrGNwhVzHhCZe+2V2HPWZ4kHmDdPG6eid/0sH5Dy28+OY675bi2WH7ljsSPxpSrKBgEd6PwQiZ5HlBLUvuRPD37EdTHP6mo+jzRmLrC8huGX2pwYDp3Xhg2qTNXfo+wpomUrrE54lQ9OpVVg1laAumNkpDCW3a/QnN3SvHrkdzCbn2QWUAwCjregTeLglcm0OD80gNJnJNYQmbmB6r1AcSCpfwYVDh1nPRuDCGePRhxrGh0pWQzjbhZT2QPd7ZkFP+6T8/r56U1C+TfgkO1Dvzq7UyP+u4imRDEJLktQFJzcIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:19 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 6/9] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
Date: Wed,  9 Oct 2024 13:23:12 -0300
Message-ID: <6-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:36e::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: b39aafab-6574-436e-3fe6-08dce87eae88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?unjRbVLyITB+NB8WtgCaUGIo45/6GzWrGEAPKVAvBD3VkgG6ZiM/lUJaNZ9o?=
 =?us-ascii?Q?3ahxPjJLz392A1G7/05CnlhsbScCKEBIEaqY9r5pCuCyK8Iz5aYZRp3XZp2R?=
 =?us-ascii?Q?tBiZtLUZJGm5nA1pY0+96EAff9gNDcr7Oqzt2kfQVYtwH9Ty6BfxbyMZ+tmV?=
 =?us-ascii?Q?6jYkmORNsatW7dHPyFHCEGbjhilVT2Bh1/zNqSdrNE/cC4zbW2O/LtZkLsyp?=
 =?us-ascii?Q?/6rSEfg0wjYFkq4tI42kSBq5pOLcUo3SOoiYdEF3zLvHtU39QlnxU15xeatL?=
 =?us-ascii?Q?3MKyYvcgsMPNFWSfmbKLnKgCSWyTTiLQ+SNUGiq4l+ayOH3YZ3uwM88al+Uo?=
 =?us-ascii?Q?rLe8BzsVvUV8GNZ8WkhubdMHEzEjAgjXY4HnfRFErzdrL9U57pZsD4TRLpZX?=
 =?us-ascii?Q?szjt5hmzVFOoSAsfy671MegfVpY5q4IY50Q1iVvcjqXBEXvq72UySG/4F4Cq?=
 =?us-ascii?Q?CdBHhm70HAzyqnJ5Uu6tNiSc19qd2qB3d3DOD/N6sVhvLhrRNwN2AsI2jpc9?=
 =?us-ascii?Q?+CdYqr9+H0sD9VeYQZDcIlCmseh0l12m3PkmPRS8NLApTN+GUdetkEt3OI5e?=
 =?us-ascii?Q?sy0YOL3jesujW+yrI6VG78X+pf8m8pxwsTCVswtDkO8pIB1PXVZKHo2JgPjx?=
 =?us-ascii?Q?AYSHhWNqU+0XjT+AI2AK21jgt3ZWqBgEirvmfwdU1xEOwASKQcW5hL4H1Mfw?=
 =?us-ascii?Q?HniA6fN/xf3xeB2u6clwPLTsAL+2Cev111eJlM2mZiRfpt2zRltSbNxcVGdP?=
 =?us-ascii?Q?oKGGRMrIgdrcFIPdll10nJKM46Qqyi7dTKU+mnaEBOYRGOaFAHl+21fq48sn?=
 =?us-ascii?Q?HnDTB26wuIJrGRHr1x+pJuv87OakF6f3QlxY+b/vZiTkEoxq0aaIcVp8LUcv?=
 =?us-ascii?Q?OTvKCB3h1q0QiTHJLw0LH7cu3M8pU2l/Rq/2f1FDf8BwFjsL/vVWs/C4fmo7?=
 =?us-ascii?Q?E7EH5sf32g5tMKmPWs5NwaHY7Es+pKXhfHVOYYr3JULaIqySVoUBSQi1SZKw?=
 =?us-ascii?Q?Db/3vZC859tdrWZPQaWN8EspCXqkfLNIyomin75NFe4NzhKFmUTDKcMLRHNz?=
 =?us-ascii?Q?dzni3wmOm55xkBrYyHIJmxa8laYgBr6dKP44R0hsGC9uuhPWO8m5HhOwlpE/?=
 =?us-ascii?Q?5+TbyIdE3BOuE9ry1G4FbL+BL7ALTOwhEHFL9/lIl2QQ8m9gVl+KDQ54rpwD?=
 =?us-ascii?Q?ZXU2+ydPt7KSEBzfQlIWhkT4QGNMqaoDEjT8Fz0Q+TI9gYcZAoydW9f+2/kQ?=
 =?us-ascii?Q?T54L92Zdysy5uPgroRB4dIVLxBsb2/B2EG6ZbWGo14IS1zjwIF4KinI22SFc?=
 =?us-ascii?Q?6CWvOu3m1uLFSE0MkjPqbmYc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cQTqjYBRrVwWQwB7DHcdmy7F3h8GZGwjYc2pWOiRKdd/G5q6mKjBoXdR4Iv2?=
 =?us-ascii?Q?PjrS+kcYiAn+zV5esyYS1c1hWH2NCAB3ke24J79WlzkwENX+Y/evVFruX7Rz?=
 =?us-ascii?Q?Mx7xq0OVmbCkCBGEjNFOpEn/t6bPEBWbt5Gdvq5gEQznsv2Aq+vLjLFmuBrQ?=
 =?us-ascii?Q?Uwu1eiDtENA41dhfkR1oJ6TD1f3GISBq8Vihrpus3gAOx7WS5l2iD2GwZBWH?=
 =?us-ascii?Q?smBw/xzJsh/kVCW9OFtcPJJ6RGiOOHxAnaFPZCK3JwauW6McNMaf+H6JmodV?=
 =?us-ascii?Q?lmvtzlScypZ/KnvRzUzma49kGVIZnhpamChw+r4iucwjgAst+TEqI0W/PSCc?=
 =?us-ascii?Q?pVTgdBeeOhr4RIwgtqks8fBXIn1DoCmhXQafw0LVS6mo4+SWYMnhSXokXuqy?=
 =?us-ascii?Q?Q6F9HuY9XPoJzDr1H+BAqFjqo7mJWGCEksvPtluB4h5/B9F9S8/cKYKF977n?=
 =?us-ascii?Q?xxqchogDDWdg/tL0h5DFKzEp4sfZ9ZX2QsJ6cGBS6Kw0NWsupJdAmy0q7hzZ?=
 =?us-ascii?Q?6xaoIZ288W/hTK/0flHzRwX51a2NByPiBXDqkM49JthNYojWaSipA1y328Tb?=
 =?us-ascii?Q?zEBe4WTJGEIeJgwpBAd475O4cfKmTpkf7saUo3RkjbpazEiqgmTWlO4yEeTV?=
 =?us-ascii?Q?BFQ+jJzY45KY7+RCqmwA2c8zIyVMIPsUr1Y5+A4yC3Vw4QPquS2Lvg6CaX6x?=
 =?us-ascii?Q?9Z14zGS0SYgAn6TL5ByG0f4WTUM1ZTYI2poLBffEv26h9O59BvdKEX5sCHQF?=
 =?us-ascii?Q?3b8kWNruoa2yJUaeqR/mcGBOZb6zSHcCAVf3L7HmFU60AmMYIU9KIQgFh+qN?=
 =?us-ascii?Q?RmuiBZAkQ+XMkpOTfBaGsC16gaDFoaCng+NRXRRjfEg+6PCvr10OOlSV6Um9?=
 =?us-ascii?Q?f1uMoMl7poeys+Q1Dls9sSCrUMUjBJ9kK1QKkYtMrwMrjAprdOU5gpY168Fv?=
 =?us-ascii?Q?fRcxuCGFo+WZf00jG+uXF+KCmM/Ugk46Ji/h0qyox5y6K5YYr7JbbsO+TzTH?=
 =?us-ascii?Q?RWfP3+cJRUBSIoN5JXIMfkZqiC3xqx2mNtLKEVfHZj2d6MW27LRk1MoWC6d8?=
 =?us-ascii?Q?chAuPhHXw4H9mMdlwyOj8lX9dw0pBbxrZq2/pjBoqVNQL+n8WvfGZhT4O2Gv?=
 =?us-ascii?Q?sm1LqeKbFTrVCrpBa1SFA5Ul/Vx41SbilMO8HE+QutSEIaDDcr8UUgOpZPef?=
 =?us-ascii?Q?uHxROMD6RSAS7IE5T+B80nQAc4CLlKD5uVpJ0/px9jw+ykSbBArrMq2YC38Y?=
 =?us-ascii?Q?xTAQW0zUDZH+v9bCvGeuF8Aex/y0mEeE5rgBdZvnOuQ25AI22DasmSrdSYii?=
 =?us-ascii?Q?NcDd08e6I/1KIFx3ZFCSj6/6h+KDg2JxhIVIvdjEyUP1mQBl6B6CFPs/6+iz?=
 =?us-ascii?Q?JmlgxE17ebLvmCCwFpDjOsfDDpnEZowC53+9LDVlRdKQE0up4U/nYh+IhIFc?=
 =?us-ascii?Q?SDflEPBUkmCsRW2RX4b+zEbQDaY1wzLbe/QV8tWlgXNpy6KyE7BqREbahb8J?=
 =?us-ascii?Q?Zrqwi1dOH2Cj9JegQQoDpMkXwIXKbeoU+piuycaaE/tBKp/zGwTRrit8f1Nw?=
 =?us-ascii?Q?BzmNneKFvxyXzfbA4aw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39aafab-6574-436e-3fe6-08dce87eae88
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:17.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tap4LDjJ4Iv6ScIK7FEPcUN47k97mk81uY4y+7opmaVsJLJpKL0SnX6e0F9+Wnb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

For SMMUv3 the parent must be a S2 domain, which can be composed
into a IOMMU_DOMAIN_NESTED.

In future the S2 parent will also need a VMID linked to the VIOMMU and
even to KVM.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 996774d461aea2..80847fa386fcd2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3114,7 +3114,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				 IOMMU_HWPT_ALLOC_NEST_PARENT;
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
@@ -3127,6 +3128,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
 
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
+		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
+			ret = -EOPNOTSUPP;
+			goto err_free;
+		}
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+	}
+
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
-- 
2.46.2


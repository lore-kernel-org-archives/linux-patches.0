Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1E14E2D0;
	Wed, 27 Mar 2024 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562917; cv=fail; b=NF12wmQb/BJ7GVAuKqIH3Wkw3kQDRqbyyIixi2hJEv4SQEjX0Kin7lJmCV1Iv4Sx7ADwHRLNEv+HMtkLrWNPSO0olmHTbTcmKY0d4c+Pgn6fGZsMrrlRetoXsu7EUy8/1zpGbMGqyNYmJT+2Sxt3qonocfVPXtc5cIXGe+Aki3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562917; c=relaxed/simple;
	bh=LeXMEZZzDCHBVxYER6wkqC7l3riC4gIeoDuTYO+a+zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iVXOWkvZGQflc9uMfjzmnEqwtLmdq2VQu9mtQ8AKH69JuuoTKrcxO89RQJB9lZ5Z9UWCIIWbITEFAtGpWG7RRBdT7a2gzld/bLOrXvGaxBMNTcSjiGDcSe0pAq+xgoMIUBZPw/Z7oJ47nrcB45EX5BRTAXF2lezCOpEVriHmexM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fLN2ebqp; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fLN2ebqp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxWwwAWwv+bjaIYHJubNv/E0zb8RTwlNeYmfdZ04zXieIKaGTV+96obnPcM1Yjwm5Ot0d+ri+mWdwS+IY4UuXn5aEyetx4DBK1z60U26KFd/sw2TSmsMZkvwP68qcW5+f7xR7ndCkkQkdrfdwlqFY1Mzwwpvv05BgDr4mkQEBQubAm3DpxNdE/IJ7f8d6pKnDzmxJ+3/eeA346w+037R3xA9GAV7TloMIv6D12w5zRW/EiH8f/cap7ofvtpUwMtgwyrkvV8XcA6u64lbKE4tfb2XzcMmZeSqxcKs/lTfwbK3AitCG24JZ8bJNobU3+Mc3yWqkQIsTR92pbDqko91Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl1E50wiFJDauM5NmT6LROZcbPJ7yB/GkFKe6n06lg0=;
 b=lQ+4l13GSROk0JYkol1zkpXsfOoPr7U+9o62CnsAZ0m141IIWkKbLBu1dVkveeXMXOPWRevsbjP4kbplLqJXd1m19L6ngskZCP1eScCjVVnj9L19ol3IVxDPI7VfXG9wtwcRHK0GEftpSOR97j9W2HWmOlCYkAmyPeur4QVclRjguKDaXy9IDeGIoc2LgALJLWF8Nb88a+7rIep8WRdkY4t8WsUY1xeC7UO0npyv9Pm1ctu5AzBGhz5UHFDQ/81XJM+pHBlPdgN6Xa3c/rFXIvc6On4olttjWKdMF5/gz8FnnDiPII0i0onBQDMTE2wSK4SdoYd/IemSEuQTXB34tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl1E50wiFJDauM5NmT6LROZcbPJ7yB/GkFKe6n06lg0=;
 b=fLN2ebqprovFJN5FjRKP2UoPtTPIQPokS6QWZ1AR5Y3KrkYij94+wanMTyEJjncs+dq2uIxLFTadd2SW0heXsCgvW+xhgQAdmiPKg+oWQmamvfFKGozdkqFjqtDUIf8atrV6Z2yoLmBrZSDQc1OfHHCDPkD+2E41pebqLoHiyhZ6WdlNYqAHFjXcnYzhNR84vM6Gt+ORHImDWMV9TSbhBkVlv8czisYIhS5UuoKn+rarw+SM80yUDlyhpe+qefBvJj4mjwm2Cy+gghD7QzXe1myfKO3J6SqgzUUIzacUYt3MQT47V9+ptg5oPQSqKxPGMEuyd9121alo5pLA2m39aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:32 +0000
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
Subject: [PATCH v6 08/29] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Wed, 27 Mar 2024 15:07:54 -0300
Message-ID: <8-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:236::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4b9850-e6ad-48b0-6f85-08dc4e88e1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OeK19my1H9mEDC8MC2Ti5N0qju+JIZ+1ggP0BWEYQ6/HGb6dUnTOkWuSmOg6cWHejMfx1JnrTBgauF2dKPT9yeICgkzR+YQZ+N8r1p8rYBqWCXDUYBYL8WWi3bMPxLHRwoP33sqjIEyKNzrcwUQ4cKwQ8JKmJ5zizrQ7T3QxY0VLyxSzyuy1DZlyi8w01f5svjqJAHTHdhq8de4NjcYjta699u0GSTniMgrndCW9wPj91SQcLfPYBazrihRDoI5FVbCdw7rBrQ/QnJCQqPuMas/YTip/PkXYPu3fL5Jj5mOZRmjvAkaeQzd+xQSMUzMIWA69iYvT5FUioC5ihvpgXZM3EtpXfp0AQ958i8S75Q8LOT8xjYsiMWEvkAteXR1oAfmOdd+MqPodJvde6KLhQoNV3HNBUPE+HpN3lX1rDTd1R/BgwtAPdhwYpvbNANYWDHDXFJanOdYljPddtRrqS3jn2DXpeE4Ofd5cjPtDQsejxRG+shbyVxhBMo5cwO9wtC0FdmeANuZLX3aSdov+y9ho/gpt/bDJEj0J7fgq4AfEjlTC54TUg5FGMrbow3wlkeZq0YSc143XhLBV/mgC0eWvT25MJ2uq1aOh/5ZBlikaMkjFcPPD5wMjS5hMSKgVJ5d9tL/c6aRurQOqyihGlbxxL2KQPLSs4vnrE/MqQl8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vFkxJWa6xWoddUnYgx3lBf109W38V7t0hKho/kRyKjXqLr912K75Phsjd138?=
 =?us-ascii?Q?0SEcnQ95k+Rk47mU1Oowa+u7o41/2FGU4d6y0fExCx5Az6VPVaAlnXkT99As?=
 =?us-ascii?Q?zrgSJGaOIcN/ugxmFW8Vyui+UCJ3k/WMiWRtgG7e7QaiOC+9PZmV/OB6Bw/p?=
 =?us-ascii?Q?R5OsFKa33bzi1dQJO/Mi8ts7ckcIN9sXf+fyCjkr08Z2yInVSz7Eg72kSfbg?=
 =?us-ascii?Q?w3ASGh7rIZjVCEoVJgi7D3Pv1s9Oba2LbGw9z1NSoC+9pKRLc5ngqVA6DpYH?=
 =?us-ascii?Q?Ohy3UsJLyPra9+E1gUZtFpbe0Zhl8Enc12NpxpadnAADWvgZ5/Ix/vJxw8pb?=
 =?us-ascii?Q?hEcwLlL/lwIcXm6C9ycQd7xF115+t/W4bS78L0bOmFyQ5C6aJ6rdSKNQ8cwG?=
 =?us-ascii?Q?jz2o1o+BOMrvpT95i9l2K2XKUY3shusvhA7GHFBPLgXbXPjocSzP2uaoOPmz?=
 =?us-ascii?Q?QC/MJYu7rD55yFTufb43I1LKTnD4xz6U0VWpqaCABQ4Ot3Uf/9ienkrfR3zC?=
 =?us-ascii?Q?jg+b5yJ6J8Gjqlq1HJ4TT+MpA/WUykMm0kHq9T6lyOLDnf11fxHGTOgC5D9v?=
 =?us-ascii?Q?5UrVx5goDgu3rCQZB20xfhPYyFFookaQCynPiJEb5wqEfFE5Ch/9L9urKx2a?=
 =?us-ascii?Q?qIp/vp+nE4lwVNOrOtmJKpsx4wR14mTDo+BaFWpHQGh51mx2PZYvaa/N9gPF?=
 =?us-ascii?Q?tyeaz54Eu9d3e68aVbdUE6e51KRv3zaY+FfAWLhRR7+8OEcg0e0aqX2gQpt0?=
 =?us-ascii?Q?jWeXfHB2X2LYJFcp0zyD+Zk0wjooiDkPdt9G87GjkAncepcW1khHOjjDRZd2?=
 =?us-ascii?Q?PfDKLU4Av2eLLtZR1Gbq6Bl8uOp85evm/UVEvFrrAuXIIywcFOBzvQqaFj82?=
 =?us-ascii?Q?rAQFK3u81K0RTuOFUr6/kb010YjaLx9gj/RhSsDIpEM2y86JYD9GWh7iuQJt?=
 =?us-ascii?Q?IEF1XYx5sHkCd9PJyaAi3ur3w94yJEeA12DWWu7WuUf6Mp6h3pRoX7wJx1ba?=
 =?us-ascii?Q?tSzOfAAODZ8BGWcGB8Bia3L6x40h05zftQ7C5cXkGPHKJ9I35vF0InXif21w?=
 =?us-ascii?Q?E7U3SULzYL82s0XniEsvMBiWIjySaS1VoodTZxBXJgYbnG5N6s/R6JfVPZiq?=
 =?us-ascii?Q?xOzRuJJGObI5aS0qbC6RAtf7Bjqt3rliNrhAI/rnfNtxFxGASQlwOPLZuXlb?=
 =?us-ascii?Q?uX1Qp0NdwIePczq25SDolWVvRVVN9Vc8ydmQ1t+ljynSJL5YjU0mpQswNUHr?=
 =?us-ascii?Q?u+e+FI7liQtWGHh13sb3AIBrj8eQkglS894oAnPztEYRSoi+AcoIKX12d638?=
 =?us-ascii?Q?gqXSZTx5Fu4GxESBD9LtYgRepZsmp66jX+Lk3elc9FiYYwKHadcGoVQ/6TrI?=
 =?us-ascii?Q?utVyNQGvX3E2+hCPXbLPrDkzMUZBCVlRW0npdI8DMbXF2riS6YXOax2CjaYO?=
 =?us-ascii?Q?zXTNVzKhPEQt5VugUuFN1MWzO5m4a+fR9PkuGCaqXqj5qRufAR4pOzw8hRrL?=
 =?us-ascii?Q?8QEqZXQ48MeMyGJTV8fwNQHcjYEUb97CqGDMUhiVM7grPfSOxep42V/L1yMU?=
 =?us-ascii?Q?iQ0J5G69lK46thtO2yjIO8xzuWhjLvtMSK35AWSf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4b9850-e6ad-48b0-6f85-08dc4e88e1fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.5127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ypgSyV4TCJcpJ5FJ1+gqsCvYIHzh1WPr4t1nPfxTTLdykrdMc0ZQO5/DDB5TQCKg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
attached to RIDs and refreshes all their CDs.

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
 3 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 41b44baef15e80..d159f60480935e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -96,7 +119,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 453437ca4bfc2b..fd1d4d774a7cf2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1209,8 +1209,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1273,9 +1273,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1288,6 +1288,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -2646,29 +2672,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7078ed569fd4d3..919f9f717bd3b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -749,6 +749,15 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.2


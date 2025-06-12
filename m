Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1002288C6;
	Thu, 12 Jun 2025 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738710; cv=fail; b=M6B8mb4Ay6/XkLSWDRdOqMeCWG/F9ubpzyAsnBM+9cJgB8PudyR9tfr9cUSOE0Cshmhe1bi6pfKsz+7P19kkDb4fKG54N0yqL1fxsnIcZn1bTvUvH6D0hxbCMU3TpoDv8DatUCSogRI6slhKw0aQygixV2AWw07v9e+EbOq2Q0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738710; c=relaxed/simple;
	bh=xJpBQYwntySeCcmcdoN02QTIrp3Hkr8zoAEKAD9yUH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oWcMPOF+04KptbdmB76h5+MKtc93Vzrmy8cU1tgY1LBAfNdju9IewiD7Z/vwJ3xcE22Ez5nI0NDMgdXMrJvDnSBLHfVH+OlUdM28uQkdP5SilYrm/Y3ElPXMkT/vhrcymRwuPQtYxB3l9e8OxmI7vUEEk4sUo67+hvKyhqmn7yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PtCFTFRN; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PtCFTFRN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXy9Unzw5uoUNZDfBfT55HP04UfBMZRFkLMo7sHkJts6hnGo5Tm+sJZd2Tk3YDZRPmoAC0ukqsy30vk1bvhLWychq3iuAOdPgtB5pxQUUHbMYhbsF3GsrqxBG0ux91o4jNvWhMvOp/Qt7nKNNvV1pCvhfdem1j4Qry5l8/xlnOxgTlpi42E75W3pb83FzGEFnZs6yxN8uFJI+UT4CKTMQMG3ajwPEabX3wBb+6My9yeS0wW7QNCffzMU61xpkGh4jXQL3jsaxeGRu+eTv4VWjJRmgMnvxx00y82KHLW6u9Gxs9FORG4cg3S+jYf5heE2DzuDsUXISgrsYYyAJZltlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csSilbrYed7Av5mIq4IocA2tPLgbNe/MPBTsdfeMPZ0=;
 b=opfDj+GzibPj22oaUjoh+s7/nVXm7dPyD9Tki1+NTMQA2DZaSheljLkBK+Ke1SxRn1iIIRsBTxSFL9Llhtl3uaRIG8e8ruVH30BV5nXLfmLIUNr0kdSqZ2ZfWxbcx98AR5y3phgpH6HGGizOD9k99ZqLl7aqSh/N7iyQrC1s69CQarGVTLpq/Ucm3ltUXjNxwSGKyAswxAUUK1q9lhJyhgu2LmLLVqOf1XlB8qObmj3CrnqFrmDt3FmfqwfruKJ0FyF3hWj4vNpYR8Zf/zuHo42H4OZYzTuMlAJ+egtWNJfGRWRwaJHUfJetLdKRTH3yoUZYmFC04hl7UBYgvMb0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csSilbrYed7Av5mIq4IocA2tPLgbNe/MPBTsdfeMPZ0=;
 b=PtCFTFRNtuVGzILleH+XTgXGFygtj9xtqvu3WlWDLhJEkenLSTJqAPQLF0toBta89fkmvBQ2O3miiVadvvI53kcxNhR8KlEeZlntOZsLYCLWHvd9Ba7gIb97DpUZeNBRJB13nvlLCW4El9r2q1eIxLQnJKzw3+oB80CKQQyyoUlz3ag17uNjkYptWbWX+mqvtT6JZgJ28ScmqxfLLmAaajsM5kmaeKPKcpfXcZxcl6H4c249RxO2IHTeiIqBT+iWpznIU1dCSIHtxGNUtuEwMF3cQc1c978dv7tp7h5AjmYWRFzdieeAMU/Jpe/hBA+EDSeim/d2rLfaLEdCZr9FSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 7/7] iommu/vt-d: Split paging_domain_compatible()
Date: Thu, 12 Jun 2025 11:31:39 -0300
Message-ID: <7-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0121.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc424eb-5e19-4e0b-ad05-08dda9bdd8b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aAdaEzapzkv/MgBQXZgSHOoQG+KRfANZGjkJdkesbFDLX04jX5YHA2Ncyf+h?=
 =?us-ascii?Q?AlphE029Veac+GydnEGVhElTC1TKtaO34AzLm03vq5kaRrWCdyG+SdnczO0U?=
 =?us-ascii?Q?bnz9Ch+7ouCafa7LXguihu6WsqSeNe/03ZCBOTCAnwwnXZ79DhFWe7WdOkEV?=
 =?us-ascii?Q?JXOZt3mlLfOwpqJGQx43niz9I2do2VIs4/yYY8UMfKfyTkekhOKMxvEh4vH4?=
 =?us-ascii?Q?shOvRv/dFFD7BTg+LHOSV+DgjoK9OJ8/VI2WcYa4nzQOTzi9D3XUq77cMz9M?=
 =?us-ascii?Q?HzX7FD33YShC+qBYMVJqDFO2P1laLyFsAQjL1ereq9XwyOsCPH6hJVJaJdeJ?=
 =?us-ascii?Q?dzvKIIS8Yh/x5h0m9fj8qWAPjwyTRgv4Q0e5DGuqVL8uCRmkbrFYYNny1wBx?=
 =?us-ascii?Q?c0msDOTLUD86kVY3Gk7uEbhKdRBQ9FIIBgrCVtZOxPi7Z9hyaRfn6LvY5en/?=
 =?us-ascii?Q?tDuZoPyAjWhT1DtRyoTx21jzNOBrI2jY9GEz7RjMycE9b5c83iR5lLoSAYZs?=
 =?us-ascii?Q?jfDGbbWd7ZimW/DzyGNubYizQ1IaPJqJsAqbNUbvVnap3UqkKWxan0RrokJl?=
 =?us-ascii?Q?IJ+ku9IYEku1OOPbOJbnWeFjWptsPkXDSyimVf0t8e4YqgLIRt7xQfMJ78J7?=
 =?us-ascii?Q?oVeIKps8oWwR9NU/xom+Pyfyfd+dklCThi/fXfZ5moB/ARGWCpEGN70LuGf9?=
 =?us-ascii?Q?qJU19oJP9VoRHM56EjC5Zwy+W+lhpNuy+Rl1gYhDUBLo0mgH/kC1HmvsSKjb?=
 =?us-ascii?Q?y+z4okTccE+IosprsnsYNXkY1pTaVdYSQ8j4cGIu8zItaVxdJ2PCAz8MV/q2?=
 =?us-ascii?Q?WETPLy75/38mR8B9gRLmT/mANNOK6S6mExLGJfqnKx832PgHpCfX6dC6/oIU?=
 =?us-ascii?Q?EYgjNnHiLx7f1SKtgAkefkTo0IavY7CNFYpdDgoTl7TuGqRIF5688b4lM0LW?=
 =?us-ascii?Q?ETbl2/HYEg5ANay3TiqwoJ+K6/WxoGRuLGIruYCKWR30KdWbYGzf4nB8Ym9Y?=
 =?us-ascii?Q?1rrtY43CSVau3/2PJmz3A69rGm1uQhPRzOtnQdmTDXIEszp31DKMPsBBJUIj?=
 =?us-ascii?Q?avzlu+/ufdnMe9WaZ1sPRGS93kra0ZmmBKTEHVKr0tBqlzgMLKIXmOvi4Gl2?=
 =?us-ascii?Q?Dr38w+EkmMFYpaMKAhryxR0Lu7e1UExuq2FyrU9F9zAKcjHllUWwZy6Vjs3p?=
 =?us-ascii?Q?oDakjGXF2vD0r8V7EykXvrcl12Z3TuwKqVFS8k2J0CGxVrQR7XMYigboqWDU?=
 =?us-ascii?Q?GS7dLJ8Y7apDuCostcr61Z8znxfO0f51pcJzUl4s55gfcbFdgxu05+VGCwqc?=
 =?us-ascii?Q?DjHxa5txBwij0Lm9EnFVbUzpxyxO1/Ab1Sip4yL8FKSVFko5IYsFKFm50/o3?=
 =?us-ascii?Q?b9EWAx+XHLII015czKGsuFjSMaDBIl8omT8BEp3ShiouiMBUNuzx83dlPs2F?=
 =?us-ascii?Q?ZOvrKRA+bHM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWppbDBJYqKsyD+PbJY8Dh8Ck1u8yKWXwK34oA9eRdpWem7JQcjhtEOE6xyu?=
 =?us-ascii?Q?QPi7a8hiMZr1sKuuB8bAgQPgpvu4mtOXhai7/baVpm1NKuU0QVQfWSXaRgum?=
 =?us-ascii?Q?igwn8s2z4vGYfikt9peStDTsvEkEXsTF+pXJwAIqpTN+BiZpTc2resg+ITQ+?=
 =?us-ascii?Q?AURG67+/j+nbGLKPxiEIz6z9Df3aKWn9IOpvwKGB0o4AtHc/PfoG8fvVDYUp?=
 =?us-ascii?Q?J/+ZQDTFhV/121lywIaeY8mu1SxMdMly8D/hWFHT1lXa5OOh8TJzmxhG2ezn?=
 =?us-ascii?Q?pyoLgPqrScau6lJ/gO3VIIBrcKfVUhBPunRXGWUoxSg4GiKCyieD5XepcRCV?=
 =?us-ascii?Q?ybLNCd/7eRfNRC0V2YVV7KjPSoxShdpBw43cpuml6PmJJmnWHvVWjEOQ4Cyv?=
 =?us-ascii?Q?NeVTIDRqr80lv9y3aLXsgi+BGFRxa6tMufBhl4eoPtO5B+uvbEbbaw0S0Rfo?=
 =?us-ascii?Q?r/onl6vvCIR+odkxUfRmRY0WlhmBity9Qq4F2sPtYGVZIpQ03cR8Y57FmAOz?=
 =?us-ascii?Q?rCiLm7eY8RlB5EkUatZjNV1Ko+KfobseH3WCStBUPU4VpawL2vsO3xEtf0aB?=
 =?us-ascii?Q?1aFDHCOd5opUc/fr6Gionoo4/tSRg/gO9lFqlHfWA3GhoBm/hW2cZSPeb+0c?=
 =?us-ascii?Q?xdDl7S5gyfmAbfKtpNGcpvZq/hHieSGLjDLM8blLDYeRNSPfBckYvVOP/Dkq?=
 =?us-ascii?Q?mmrm0lXR6gw34UOL/mq2usV6YmV89cqEtUtPhamsPTyR/BH+B+iub9u6Cvp5?=
 =?us-ascii?Q?FUoJ7IVDDrot+H/8mbIi2H7Jl1OOYtVx3+i9F+nO+GMeDfuwbTMECTs2cX4d?=
 =?us-ascii?Q?5Hf7NOXWhY8dHjtJD4ehna8yTEIEcKlwrqnBXKx82cLDJsp5m8fBZYohCTWe?=
 =?us-ascii?Q?zNnnQ8jn/G6d4s/SVCH0uNNTRRfWJdmC1i7RUoJal1yCXvyqtPxegHFR24ue?=
 =?us-ascii?Q?4IYT55aF5CK8Uq+FRn2pTXmiP5+AQOlM2qB/kw120ojwGZUNFwjt3MVoIGX9?=
 =?us-ascii?Q?i4GVc8gK8lx4GAcBDIutDoFHF5XED0trIm6BL4+5lD41Bw2u4jSqmoeWvuFm?=
 =?us-ascii?Q?ERtNcnpEP+oXggfkqTF2sjbiHEYPOgP26dQCZDYlYxq/oa/Vn1wJ16Mjo572?=
 =?us-ascii?Q?KA6Ha+tgji9zsn6itUxR36bWnxYwk4vB2/CVpVzWCz/MvCDPWhvnCAqO9Dw5?=
 =?us-ascii?Q?hnxYPWh0u+BzBSs+d1bQ+YkKtKemWX+hkTzKO/CdM4TS9KBB/iocu9VKi92N?=
 =?us-ascii?Q?VjFKsM0YxTQoh1Y6fhVdXxYNUZYT3eMy5yzih2mMVOpLHFaI85I/vOQvZmTO?=
 =?us-ascii?Q?RsX2/m8hc4xQpjSN736zU2rJdTriXPN0xS8g3leg/nmWB3zlrHMTk/yKCBUc?=
 =?us-ascii?Q?KwqWb5h70V/jnz4d36RlpVqfsq3m3pVgurHXVBr4Pgnq0EWqSNSkQI1c6pc7?=
 =?us-ascii?Q?lpp7ydRF9Rv6vyegX+QNPb3fy/gFxipViP29dWMQ48moyvOi3BQ3+JvZ9BN0?=
 =?us-ascii?Q?qXoG+TdcrQ81PxzXR8b/FMiuybYTlN2yk8jIKY0ASd8WkZdMs6RJqcLpZhad?=
 =?us-ascii?Q?mKP9be4vDZN3gWucxJkiag+v/3k41GKT+CE6e3Jc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc424eb-5e19-4e0b-ad05-08dda9bdd8b9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:40.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2krRKQ6GCcaLp2QQBrBBenKuGpiJyEzXkJMe/TGqIkxgJs7U7n41kNNuoH3lo0e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

Make First/Second stage specific functions that follow the same pattern in
intel_iommu_domain_alloc_first/second_stage() for computing
EOPNOTSUPP. This makes the code easier to understand as if we couldn't
create a domain with the parameters for this IOMMU instance then we
certainly are not compatible with it.

Check superpage support directly against the per-stage cap bits and the
pgsize_bitmap.

Add a note that the force_snooping is read without locking. The locking
needs to cover the compatible check and the add of the device to the list.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 66 ++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5fd4b82576ca44..ce8ae89404f313 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3417,33 +3417,75 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	kfree(dmar_domain);
 }
 
+static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
+						struct intel_iommu *iommu)
+{
+	if (WARN_ON(dmar_domain->domain.dirty_ops ||
+		    dmar_domain->nested_parent))
+		return -EINVAL;
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!cap_fl1gp_support(iommu->cap) &&
+	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
+static int
+paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
+				      struct intel_iommu *iommu)
+{
+	unsigned int sslps = cap_super_page_val(iommu->cap);
+
+	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
+		return -EINVAL;
+	if (dmar_domain->nested_parent && !nested_supported(iommu))
+		return -EINVAL;
+
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
+		return -EINVAL;
+	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
+	int ret = -EINVAL;
 	int addr_width;
 
-	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EPERM;
+	if (domain->ops == &intel_fs_paging_domain_ops)
+		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
+	else if (domain->ops == &intel_ss_paging_domain_ops)
+		ret = paging_domain_compatible_second_stage(dmar_domain, iommu);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+	if (ret)
+		return ret;
 
+	/*
+	 * FIXME this is locked wrong, it needs to be under the
+	 * dmar_domain->lock
+	 */
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
-	if (domain->dirty_ops && !ssads_supported(iommu))
-		return -EINVAL;
-
 	if (dmar_domain->iommu_coherency !=
 			iommu_paging_structure_coherency(iommu))
 		return -EINVAL;
 
-	if (dmar_domain->iommu_superpage !=
-			iommu_superpage_capability(iommu, dmar_domain->use_first_level))
-		return -EINVAL;
-
-	if (dmar_domain->use_first_level &&
-	    (!sm_supported(iommu) || !ecap_flts(iommu->ecap)))
-		return -EINVAL;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-- 
2.43.0


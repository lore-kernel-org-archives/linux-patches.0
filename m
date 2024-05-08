Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD7112BF04;
	Wed,  8 May 2024 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194663; cv=fail; b=aQTPxekvtmWDJ5pCAmlSHzEBRP26yib56fvYTUXzItACAr+TvKMCxaIQ7WNMVMPDWObb5V2ZH0aZNqgUrTaL5fXmZSNEZ/74/biU+nLU54ZS2ESGuB/SouXRFj8/9N6rvZJNnapJzUI+L/ZHuA+/UR6RAS2bf+GrzeEc+qCHfmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194663; c=relaxed/simple;
	bh=Wfm6ZkuQnD5G4OM/VE+hn28pCvcNCUc0Nsill55YQfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ooZmYo3e1ZeneUISqUPCbQlEuBhYfDHcvP/ellEQhbraxJt52oi+twHzUt0ZQslwIMUiMMSEaQNovvKdw1xycuPJ80keCIEHHxXPGoT+lz+OT8T5HmvTbc08mK5xkRq1sUdLmPz6q0E5isDO+Jreujh6uZJfC4KlJ5jljimMdGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nr7G/M6m; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nr7G/M6m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CREU+s1XUG5jcIvwCpKV882FIUoL47xrb7AK/fFpf+/1KhrW+gfpP7CIVYcf1Iv6UYDFiJ2HULUv3fxN0DZaMWO5YDHVrBlyMfMVQonJa54fSRs5xDMtlYrMvLo2IJapnn86Qvrjl8RRIc1BSkfbgol55zV7rbPDPQNzQ201x6xnUG4ewibm2jXL9JjICJgiyKNz19RsaOG7oaZen6ijWPA/6m9l1QCK/ybqvrIYCS1gj5dajTsp1YUo+7t6UrojHhV/Oyrm1CG4VaXQOqzyTmei58wjGlR/80/5zzilgsHOcpxkbizoREKpmWqIqpmIvFZo5d7MF10DW5Fyein1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfKEWo7ACqbvcuUbrtoSc5CScqzXZmbs/gxNzZH9glg=;
 b=QtDi1aDREOGOCM0ATeF/RjHJ469j8+JrVqCLjLKDz+jmnirMzKIA4AV2bl9mGvai0HglVRraR8ZsvWjqTwj2IqgJXxXS5frhdi5a9jF1dJzZqILx5Mmt+0RjOGsPLnwSgJd43tZ4/YUO2e1FkX6HtlCt3z2llMPvvHcHODQIbJHhqd2ts8t9h4TjGa2f2nNPwjHc/njlgUxu7kH48GZXr+utZidm16VO8YwLZ+TrvIwKK9J+OvzibUkH+DPC8tM0c2/G/lsn0JpjXwaKKmMtvBWYAimCwFMFSQKx0nMyxSirjFQD3pJajNEdO+wBicaxfwJ9zzQqUZ2065VNbYDqiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfKEWo7ACqbvcuUbrtoSc5CScqzXZmbs/gxNzZH9glg=;
 b=Nr7G/M6mF8PpGlqDpHDsJzE8YwZb4OCJXyf+e+NrMtOM1JWb2CDA13MycsYB1p9f9ir0X4RQIeAUihzT324TggTGz7VyZ2m4KBJT4iV4PnsDpsQ9ay1NpYQUTQBQGfTyrP6Ip8WzEaT1bt/ZjXH1BenVOK/KbisTwtZz7ILw0nn25OdjnD17cIQtXKxMCJEV7OWIYGs6L2V6sUQ+0V/ZjBTvAe9GcrmDwlq5JblE8ME15plW9uQAV+w+f4XvvkDhS7QpV5jHvy6OxaZoZE7R6g11suHKzzQwB3EG54rS/G3m++Jl42J7S3WEt5s45s5g59cP3klsoJrrYZjLxH67MQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 07/14] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Wed,  8 May 2024 15:57:15 -0300
Message-ID: <7-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: d4550059-1b2c-4859-1e11-08dc6f90b3b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OyMPOY5kpFpYP961iX1EKH1RyYGVQ3P6X1MJW9QWU7XvYMOArgOgP4/Q5erS?=
 =?us-ascii?Q?CgYd2/HODFJRgn176RpXffLB1rVhvfFh6n72XtRooG4T3LpmpTmW19WF3khb?=
 =?us-ascii?Q?FqN1BBlKwfDvESFiA0VL5Xoax1mlzcco7NkXswijWKIRcgesXm/RV5OfF428?=
 =?us-ascii?Q?1MaEuA7wevH7Ydd5b3FSvbD88f9GtTlJAHn8nwC0eq8KLt+PjvkrDJ2vSOFu?=
 =?us-ascii?Q?bGxqqapKiHPKouFw1MzIRXJDGbC6jaobmhYlfWbr0qa2KW+rAeZqo2ea4weu?=
 =?us-ascii?Q?DPasMPo0j+9rkqcMCujaWzzOjNwsOWHgE+c8kjNiuYoW3KLfVGW58whtNfi8?=
 =?us-ascii?Q?dHOkXiEMi6oesx6fEzPwhCTKLUDy9T1d2tTd5TnRxhIBfdwR8vGXAijpxVK2?=
 =?us-ascii?Q?G16545evhMt8BvRi5xcYdW19j9yLF+khXkPfgF2C5rBlx/03k98oxvzAxCmj?=
 =?us-ascii?Q?IJ3K+czhMaR/jsz5qQpbhMsLHo5uhPoL1oDI3zEjLkWieb5BvuvY3c4ScB10?=
 =?us-ascii?Q?6HTdNAqDb+FjBGZ/PUSCFpK3nq2NQojQGgDyXb9wEHltNxvz1T3+8iEO2/uA?=
 =?us-ascii?Q?EKWT0bm6mS/I0N+Sy+Kt92i0kDZzKTr1F8M+QkdCjNPTXzf4FQrd8THIexLo?=
 =?us-ascii?Q?EQAHS2WTE37f+LPXC705DCf/r35tUqCC+IE4anN5wyRDjFDW5E3+Oycbnooh?=
 =?us-ascii?Q?qcIiUykANBuZ8o+feq9q8oVLYilbVSbxFA1C7iXL75doKZLFEGAZImPyDsPz?=
 =?us-ascii?Q?AeV8ms/gInbAN+kw5r4uJLMe1B6XwpHmfkUOIed7XYJG5tSsRXjsxVBvozTN?=
 =?us-ascii?Q?JIVG7O8KitS3YhT7blx6HqJKqRoQ/SfBvBr4Uqf33OR/O5ZL5uS7+nlXHEhP?=
 =?us-ascii?Q?wU3gv+F8VFyVhnQfA8prND+TsC0bSjWNYASbeULk5w1Gk7X7umNvWwcnPck5?=
 =?us-ascii?Q?Ahl1+Inqq6s+Kfojw+5+yyHj7vCAOb09ROzokluHNBQRqImLFIynKtjH0aba?=
 =?us-ascii?Q?qjJ6TU+FEQrANOMqYeUoWO/Zq1HNfdVAXYIB535yfl/nXsTRrflmYcc3Qc1H?=
 =?us-ascii?Q?HPVWdAp2Ky9dn9dRcTjJL0/7hgRD+wOPshTurlsMwRmkKFaG56QgZVYLrGJo?=
 =?us-ascii?Q?fq5ahOdfCdrTp9bVbJrBi22h8JYu4v51eTUYzmx/zzd3/+i0huZmHY8nNOMz?=
 =?us-ascii?Q?aNgUsJLZwL2T1SGC5mgYk6OjimFklmCMVwGqCM0I/scgYMdU4n0Z7HQtpLnA?=
 =?us-ascii?Q?iLfpaCwO5X2rAQq7rGqY2TZe9umgRreFPu0XxJhcWg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ozsoz0RqBoZYZxZolD2iGStkIzQTSp7w1W9dHRzz3dHgZhs41qrmkAbNQsA0?=
 =?us-ascii?Q?rdaWdK4rVkbYzK2NbIad8ALLRXvhy57sqG5vPTdAq8j2Mdy9gccoWCUCxriV?=
 =?us-ascii?Q?BIv90dXKAA6VsZnP+1o/R7yxNWuXq7s8LZhgkwo7/v0d38W3U0uVrGf/gv4g?=
 =?us-ascii?Q?Rjo9GoiAQC9c4Zu0hHWjBreozDuuuypr8DByfErJb6OsKLfHdVD9gsczkHtU?=
 =?us-ascii?Q?HB3cLJiGBjTUKWujGSoyN9Fd57W+86Br/7oRGSD+uSArbilQuZjv5L/wMov2?=
 =?us-ascii?Q?MafNBb7fdeUXuziR+sYRPaQlVA0ZNkhYoq7Chu2zVzBtuo+te/LA37r6//SM?=
 =?us-ascii?Q?O5h76iWHG1Dkzd1rcWM3vlWmNgX3KLTVJcBtztv+Pwi5UZaJcEe6AUnsClXS?=
 =?us-ascii?Q?XMFWZYTaW/uJVOkGixnPJQ6+MtCzCr9fwZ//Qsyg5T3NqxKf6xuN2JHX0w7v?=
 =?us-ascii?Q?FSns1lu/zD5hTkJU0VdEbjN05qq0M8duNzihGwQvg8RKmE7H7R6K589bc9oy?=
 =?us-ascii?Q?GfoPuoDWbmZI7JuyECaHtEXJYLS+tEB01NCkEb9hzFgna4GS6ckrQYPaKd4Y?=
 =?us-ascii?Q?FEUBp09M34X1B90U9noqLHVPWVIOefYBB+rzmvdblBK8apuAWtXWVWxnpIUh?=
 =?us-ascii?Q?Bv3uVqXHK73jOtkAQwHLRcvD6d8KK1Xc9f8fCsWuLPY9OFlg3CbFqqrVVAYA?=
 =?us-ascii?Q?YqXsj3MI5H28ClJoQZ6ORPv8jvu33dlQggDpy9NX4F0cbMuegM704E8T0BP7?=
 =?us-ascii?Q?pTFvEtz7mnog50Wmocy5te5XnFF67uciWqyXBIUNQ2u/nZBfxpLGCYP+NbFl?=
 =?us-ascii?Q?ORWzPk0IfMh+8jtZlYioUlHYYYImDA0WFS5kZxx9C0wWDhrDuZe+wKG4bEdh?=
 =?us-ascii?Q?qsQ+lSqTXRv/SE/PD3NyI4czOskOumN1kdSH0GGDnMBkSqgv+/GvPBI5VWc/?=
 =?us-ascii?Q?8+qYb2CaAeSYoGf5O+DdvkKXTdpukpWuLAXeIPlU0v4zdLxFUQGY5O1Xe/ch?=
 =?us-ascii?Q?B+3oJkRXSxflLSAY/Odvio1nbCvCVc0IJ/CnflCstCpwJQd6jjEE6m2DlOCE?=
 =?us-ascii?Q?JBCItA83H6GH/87j9WbZHchBFEYIjUpc22ffs/0RROPGvipbml7suUHEgON3?=
 =?us-ascii?Q?DHQQ9+R4kujkV0z8jkpGzfrfPFLQ81ZTj3B4iGdXMQz7sIQtHRIMBfVzEJN9?=
 =?us-ascii?Q?xgKJMGLBErYSIRd0grxqdNz6OK9JMVUv/LPkna1wft0CBMBEdCsBibGP0D8G?=
 =?us-ascii?Q?k8THLHbpr7eyO7UoOX0WF7EZuv3vJQsIEtHhVki14P6xfFwqjY5agZrVrnIc?=
 =?us-ascii?Q?/IaqSM6ybWyov7Vb7bM9bdDP2URGoa3k4cTRT+yWoZkLVNllmezw6au8n7ub?=
 =?us-ascii?Q?X/XML5qK3sk3qcWeEN9iMt3OTGfdKcf/+widV57TrW3ign1YFkfxUMEczsbk?=
 =?us-ascii?Q?P32q+rUrV4B7fgOPFtoDPLcBwL7xTB+ovpjjLbXISx/SKq/ECXJIXTpjgGye?=
 =?us-ascii?Q?4QcqNSd5cZ/g/T2vGn/h/wzGkFbDET4ruZO3+D2BsKYbieOBA8SDuiTMO6vC?=
 =?us-ascii?Q?9S21nnCE5D6iqZSlHtWUX2vkqNoVil4FqO7UghdO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4550059-1b2c-4859-1e11-08dc6f90b3b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:26.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAT8MzD0KkMzG0uituD3Ju02xKZM7YEkYfnYIwjqgaSerhluQbJd5M3ffQt+FsW9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5f418b96679c88..b2d8b7a1df343a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2005,13 +2005,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2494,7 +2495,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2581,7 +2582,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2591,8 +2593,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2606,6 +2607,7 @@ struct attach_state {
 	bool want_ats;
 	bool disable_ats;
 	struct iommu_domain *old_domain;
+	ioasid_t ssid;
 };
 
 /*
@@ -2637,6 +2639,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2689,11 +2692,14 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		if (state->want_ats)
+			arm_smmu_atc_inv_master(master, state->ssid);
+		else
+			arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->want_ats;
 
-	arm_smmu_remove_master_domain(master, state->old_domain);
+	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2705,6 +2711,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
@@ -2801,6 +2808,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
-- 
2.43.2


Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2B7366;
	Sat, 11 May 2024 02:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715394759; cv=fail; b=dfdGwXtq9NOwi30GEtRQBXubAOEXkdgMqpE5th5M4Zbb19pVBY3nXZAIADRY5yBtfmiqZOoPNmW0Mx3fmjf97ek4cVIlcxjmaBHFvW72DxcS3lu+OnP4hnUMNaFNrDvJPqzugIvbia0QPdLqp5QiZiQWESBOXjd33qrF6RPdYA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715394759; c=relaxed/simple;
	bh=qq9sMmsqtOK1GXG21YN6SxWgY3/me+vJCuuvjsa5jAg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpwi6fUdOZx5l7Ti+iHWy+xCdzZeOqegpy3QiYDQDCHAFMrjO5ylaO/3CxHALeqxI443yKMcwVCmv3jMW1JULnZnGrDgJ2XgGtxKftRM6LY1BXIirKw6sIVDk6ZfK2O6xT9xN9OVVIFIhqwQ7wsgmvhe7Gwql+X4svPm30gTyuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NgKi473X; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NgKi473X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdmX600mbTXPlfVH+WUEghl51PeNPbDqv3pnr44nWClXU1kjfy/ukE4KSK/STtt0viQmgDxt26AwD1YGf3REehqfBZPzhnwzTlPPomT3zSMA1f3QA+b3kspkGuAshLNcBUTx0ARQjGoASPAtyMCg7f8db21TDNdh7llvyVA8yY3Lyj7ft7EmA6qxlUAXhxTyOK5kYfVERqqgg/O4S2NHGPppbq+j+6VvdZRsbLM1t0J/QnVsKgISkMbYtUX9l+XafAQEBPn5KQloH843VxL9nDn91Tz0ytNGFW4lwoOm64JSZjH38/HJ3aQrwft8nvcYOiePXRMjrbsq+RhsVpb5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlArHNAXJaAQXqEeXrd6tCmnjVtWiXJb+PEirbo5epI=;
 b=lXyBpiexVcI2xzVu933tpfyTX5PQguH8UbJt4JUxeZUuQ+mN9mFVIK351kG7x6ZgayakM5XnLvp99M8ZLUS/uRQAx2kJyrcsjsstQxbnH5eAfPvSqX2lBpDAHsYumHB2PVNmnt/BoHUnQ5MDSqoseh1TDB59hCuROnd8U2LS0zYiIbu4do8VBN/z2d165bXLhpEjsleuOpkHlXfRvXrQvqkjDs6EE/ffwH/V7AmxryXrg/Fni7LOQFmlCfMRWiTXzO455/hcdzpjy1c7u1TMifeNv6MLhpwBZdRiEXgi7fy3JAkbCZ6RDwfK6sIOTaI6AkUKOZb6C59f9/7TNa+EkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlArHNAXJaAQXqEeXrd6tCmnjVtWiXJb+PEirbo5epI=;
 b=NgKi473XVrY47XGFSgjQo9JhF6PC3fuf4/PuoqDOQVpgbKWpomEWjs/gFIxdZxtN6QKJ6DEPpkt5BV7cEcQwRvkwUmiAYXJXNIPsONtQj28iPtWXDUrTYWH8XJNR3CJ3c2BK29O3fms/1+u7kAzZPrf73ORRTdAomK/oMusTJdlg0BSmJU4RPw5FdrCI2XeNnmajr4JzEloKSIDMLQacc6Vtl3aqjsLYUrXqwgPyqczcOl3RzZYNr2Qm52H3Fwru5L9OUU/ItXq+N+M2bZbw7Vcxz3TrPtfDmS8937QdDDo4E+8LVm2Y41Dn8uo5wvqCng+fB+hCkXvTo3pCUV3bnQ==
Received: from MN2PR02CA0031.namprd02.prod.outlook.com (2603:10b6:208:fc::44)
 by DM6PR12MB4105.namprd12.prod.outlook.com (2603:10b6:5:217::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.54; Sat, 11 May
 2024 02:32:35 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::96) by MN2PR02CA0031.outlook.office365.com
 (2603:10b6:208:fc::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Sat, 11 May 2024 02:32:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Sat, 11 May 2024 02:32:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 10 May
 2024 19:32:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 10 May
 2024 19:32:22 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 10 May 2024 19:32:19 -0700
Date: Fri, 10 May 2024 19:32:16 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <Zj7YsKWSqGqOgOoV@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|DM6PR12MB4105:EE_
X-MS-Office365-Filtering-Correlation-Id: 8672b4bb-465d-4ac9-4682-08dc71629dbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400017|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TJrD6D6ZzXj/GljtaQWKtesXqjkkkNlC0ZzF19B7ERzEg4Ug/dILISTzvxl2?=
 =?us-ascii?Q?YjmD0AhbMx/H8uq+92F+cr2F9s1QJvkLkdPYsUKCrdYJwCsDQaBZejpUKJuT?=
 =?us-ascii?Q?8xqhb5fpSiaRrKbwDStWhO48CxdqhFi3CKmoxXgxaW2fLL8dxCtlKIyrKxp9?=
 =?us-ascii?Q?GXGgs4VOTxvmNsVuQls4SIylGJ3BrxNpeRcZr5T4AZ4Z/5mi5TitrGnZpfzY?=
 =?us-ascii?Q?e7+H7uzhbll2xVqm+l4aap/qS6J4fXZqHsSz4i8tGxp9+75eOGvE8/vvjxbJ?=
 =?us-ascii?Q?TVpmSEYM/Y6O/Uhyj8L16uzBOjLRlWLv3rJXSBpeeQp0+0mdj1gjjyUf1vv9?=
 =?us-ascii?Q?3lA4uhD/vd7BXtxP6DfWyrzrt9c0lE/6nVMbhGnDuMRYI2+5vFGVzZRuID9y?=
 =?us-ascii?Q?SuPA/tVg0+44wowvHoGICT/m0162OydkTsldanybzUc6Mm0VmpUr07+ugVFJ?=
 =?us-ascii?Q?ygpACLJYdhtviMsDr4VP4sSQhqqNeM+vP/EE11aENqGfTbl6cZ8N+IXWmXdX?=
 =?us-ascii?Q?Xni9aPbRPmK+U5ziKqXd1UsW2NI4K5IjDNUNgdjCIBSjzgk3WFnCeQ000lmu?=
 =?us-ascii?Q?yNd0USKSuxL/3OiLOJX1S/iJ9tYgO4/wx064OK35eKPHHO5zaFDvZGGI3YyJ?=
 =?us-ascii?Q?mSc2H+NhP3TSgJzkRlTiHoj/3z5h46s+BXOQr/Bo5lGNXLjk/obzFY0ZOrz+?=
 =?us-ascii?Q?wxCZ9ON+Wmlw0SAhk+F5GEtDffo78vsTgGny5hYctJs8BTXadF8uIg434mNk?=
 =?us-ascii?Q?eMg4977JYMiYAnZRGRwWvdTWmJcETZwvF2bKup8cAvzU+oNrpQdJ987sYvIz?=
 =?us-ascii?Q?HTk+dI3YztnrHTUIGMqomc9kPzbd9fKTpWwCOWZpWkzHitQRtJO4bQI7BWdv?=
 =?us-ascii?Q?AqWxNnj/StP48kc5BbdyfRW5B4DEOm2ztEun97F4AjRRQloaPA+JBifS+PBc?=
 =?us-ascii?Q?Fr8iYNzbbu6C2UHxibesJCSzGxSU+MIko8V+KXdiK93afC3/2g2Vy6jnqsil?=
 =?us-ascii?Q?TY5dw84qXXxdM7DkH5q9m2bmBCRZjDjPugkcU/dEdqtZ3uQQ3ZToH+lkHifu?=
 =?us-ascii?Q?Nu3gYBJGqyGqbenYxvEOd8/CdjDqFdo9Hv+YimVV5HXX4McuBb1GGrB00tCJ?=
 =?us-ascii?Q?nY3DSlImIWTL6m+TTtS/7YDoX3O70tiRfvpSH1QkjMie5dNVmcyDtv16fBPI?=
 =?us-ascii?Q?EtoMwCiuH4XpZbe71loHrsAW5Z/d7DzaqPIDwB0t9YKye8TCX+R8MRPUf04w?=
 =?us-ascii?Q?d25f0cMtZjgDixZgzsr9doLgQRpEHCUcxAtArAFzGR6WIw02SILBe7QWFUa+?=
 =?us-ascii?Q?q/T1ol+aYFeH8CPd5pCDQDpkhmuv1x2G6WxIMTsPOftVdBIH/QbobwrX8GVU?=
 =?us-ascii?Q?a0QTq+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400017)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 02:32:34.4675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8672b4bb-465d-4ac9-4682-08dc71629dbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4105

On Wed, May 08, 2024 at 03:57:10PM -0300, Jason Gunthorpe wrote:
> @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>  	struct arm_smmu_bond *bond = NULL, *t;
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>  
> +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> +
>  	mutex_lock(&sva_lock);
> -
> -	arm_smmu_clear_cd(master, id);
> -

Should the new arm_smmu_remove_pasid() be inside the sva_lock as
the arm_smmu_clear_cd() previously? This would also seem to match
with the arm_smmu_set_pasid() that's inside the sva_lock too.

With that, arm_smmu_remove_pasid() seems to be removed entirely
by a following change, though its function declare still exists
in arm-smmu-v3.h (I probably should find what following patch and
comment there..)

> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2412,6 +2412,10 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
>  	int i, j;
>  	struct arm_smmu_device *smmu = master->smmu;
>  
> +	master->cd_table.in_ste =
> +		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
> +		STRTAB_STE_0_CFG_S1_TRANS;
> +

> +int arm_smmu_set_pasid(struct arm_smmu_master *master,
> +		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> +		       const struct arm_smmu_cd *cd)
> +{
> +	struct arm_smmu_cd *cdptr;
> +
> +	/* The core code validates pasid */
> +
> +	if (!master->cd_table.in_ste)
> +		return -ENODEV;
> +
> +	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
> +	if (!cdptr)
> +		return -ENOMEM;

Though I might be missing some piece, the in_ste is set in the
arm_smmu_install_ste_for_dev() when STE.Config=S1_TRANS, in which
case cdptr is already allocated? If so, do we still need to call
arm_smmu_alloc_cd_ptr()? Or just arm_smmu_get_cd_ptr() instead?

Thanks
Nicolin

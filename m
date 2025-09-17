Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011005.outbound.protection.outlook.com [52.101.57.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCC32FF164;
	Wed, 17 Sep 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758134088; cv=fail; b=hivPK/AYp6pbmJ9mAJpRIuDiS0Osg5RLXGOCyKGja7U8WFoV09kN67x9mwBDOoTCkuciIeFZ5445jIZfJ5GiAdQUD/UXVWZ4AKNJ/CTeETrCUQQuqKncxWQLPJusiF+lkddRmi/Ao0weazrq3cG9U6w2bpqE4o+pWYQ94vfl4RY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758134088; c=relaxed/simple;
	bh=Vt5UZAdjfobB5AsBPSqmI+pGv6i2Jaxy43EhiK9VY/4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lp05JGYSl96LE1NAVHoxS0KqfIq66FfkWiKKRQPC8nENSMOR6r4xOoITvyeZzSh+t5khz7504GVqz8kzcb+Y1+NyEIFxeImvuhaCiLFH0ZMeRHFEgisGA1fLIbmDTOkwy1pfwbgmlFqqO+VNFlR5D4iJicGBXmyXmxIbpXVBPHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mU1Jq8WW; arc=fail smtp.client-ip=52.101.57.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mU1Jq8WW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlUbSdxzlRGNziyRZTRCvkVxJrieWFfbNdrztrMLc2jj6ALmJHvQf5kc84dix9oZFCyc4qcU9BynkYiPVBWI57ijgrmo93Ntcex/jy6JeuEIVQtmmQeqwpHGtZaKuQYdG8Ku+FF5DRBhLxcV+CtbdbsH8a5UHN/Wy+i8dvVeOiJv4gLNaPRHzSPbcWAGwWBmYtNZp7/95nknLwv9gGLFqolKbXf84si2IClP4Gsrb6nhXdHf/MbTrRGjOYsFdHULT/35olcGcXmM+R69xjrqo4J9jXVQ3mpJMhvSQ65VrrqEO0O0hC7SJt15q5aBMzk5itxHu5flMsPDeChGelWlMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeZuF3UWMlhGf0RjfQcydHsSYAGgWN1CI/AjDsZ5HP0=;
 b=qjUy/1WRA2ARJ6S/GlqJxPBa1T+9D+pcQ9RA/UsNMNDiwsZmClfMGvCIRGwV9mS4U4NdNK4sdzX3q71V8YTluV22DjEhjx7/Qr6S78Vux36yDVu8bJyd3MxEuB8hnvpAZWhX10FXJBolBSsD805eBAgK0fMTz1nZ4uZ5HS8qCa2DLsA6bKXY+6ty82oBt3Z3mHp70s3HVhaPqIFos3Z0WaH0Ye8+nItsZiWnqaK4OBELWaeuipuipPyaP8wqMLh7F81ei4PHIvfYUyss0kG52sk2wL7Mro94/ne+Fr6BVNe5nKfQ0++SZMrLKk/9gb7TcyMLTMS9xIHRQV+ImL8NRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeZuF3UWMlhGf0RjfQcydHsSYAGgWN1CI/AjDsZ5HP0=;
 b=mU1Jq8WWwC+ygFN+IQ9pJtkRnEnMDv9uobEscokVK0g091CR539BF6acDoxJpTXyuzIahIeOwx09tfMagC7xIr6HMBbQlxNJ/TMx55vRGWawrsklAJH+8PEaWiIU90VOvHMfUAF39mYe952zVAHZHE2yKUyKgxvy7Q0jAY+7Qwy0YkIx6w4QcdYNQqA+b7uXOm/zD+CrFlu/X1PGWi2ta2WkBC9KbC3xBX6viI7HMQiqi90x9MbwowTqoGPdnLir2J75M7F90U/sxPfITaiMhcnxAX0S6Kf8kzWJJM1Bc2mPvGEfBof7Ky3qkQxQfXCe+BFKJRZRFZtlKqVlRlwXiA==
Received: from MN2PR16CA0054.namprd16.prod.outlook.com (2603:10b6:208:234::23)
 by DS7PR12MB6167.namprd12.prod.outlook.com (2603:10b6:8:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 18:34:40 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:234:cafe::ba) by MN2PR16CA0054.outlook.office365.com
 (2603:10b6:208:234::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Wed,
 17 Sep 2025 18:34:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.0 via Frontend Transport; Wed, 17 Sep 2025 18:34:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 11:34:17 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 11:34:17 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 17 Sep 2025 11:34:16 -0700
Date: Wed, 17 Sep 2025 11:34:15 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Lu
 Baolu" <baolu.lu@linux.intel.com>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>
Subject: Re: [PATCH] iommufd: Fix refcounting race during mmap
Message-ID: <aMr/JyYjV97r+vqx@Asurada-Nvidia>
References: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|DS7PR12MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 57276ce8-5746-41bb-25c8-08ddf618dc95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oswgb6BK8WGUTrn/FDFj9KJ+QAY3JCXU4U1ghSUXXUi9jRD3itGRPvGmNBgx?=
 =?us-ascii?Q?R6qp4+TaGSJQMEun+/cO3sTvyRdI6SNK8dONE/4i+Rjzobtqpj1XJ0LPuRuJ?=
 =?us-ascii?Q?mPl4k66xMpK40l7rkYUIpcfVDXJw7+7+rPdOVOMzymjjFXrwKaWBbXz6AiqQ?=
 =?us-ascii?Q?QttZu4xxyzWdO69yA5C8FJi6FMLcZZhMuphqfZLCYTAQZdlh0JDVpVIhzCl2?=
 =?us-ascii?Q?UEjIM/gbNXHs3XNm5S+9FqisLfN1iDc7iAB2v5VeT9GwW31vdw+OHnQfqOSF?=
 =?us-ascii?Q?55P6HrmlWBcnwgADyrM/1TjsXe6LijLUNtLsp2sdtzx2ibpDF7rdtoA0qChw?=
 =?us-ascii?Q?lZnj5/1Use+bIuBhEV7ntu72PTMVW6UINr3xmtSpGuATwEFq47thuKlyIw2D?=
 =?us-ascii?Q?QbxJ/SL1Orc6ZAhe6n8oahdCaI6WXC7RHbZNoqDBLp1U5AWNzSVdb7yzYLgC?=
 =?us-ascii?Q?csLypBuzKCQAZ40eS7ayCEEh5y0zF7uzt6Iwrw5OKkBrC4t5nOpBo+ap2Ikr?=
 =?us-ascii?Q?qEYnlWVeaPElJcgRxTrML/jz+TnaAbObA69gv9B1hdtpeP2I/c955QNz894H?=
 =?us-ascii?Q?FW4NAaNTgIjKtYDz6T5ulBLTLz5HtDb5XtQsTVNSgajzQ1PQcy2qO7KLh8n3?=
 =?us-ascii?Q?6nICwITbBgaEaFh0cotguF5DmzFqmBSIkw7j6gmsuIcdGhjWjQHJpOo8QnHB?=
 =?us-ascii?Q?IUAxEcZcjMNoIwl2YJPh9kQ/WU/zhwatpkimtfxHjjDL0uxI2bB9Mle0Pzir?=
 =?us-ascii?Q?dGcP98TvCRyWCAwxdti1NZB3oN2drZm6JCAsSppJIKhw0MbbZSdD+KOAKEyh?=
 =?us-ascii?Q?Xnja5HA4wMe2OjlJ1unryqtQSegkkwXFA5oVGpW6enm+ubSXhnTbGdp/gJK+?=
 =?us-ascii?Q?D/YqiP9hhc7w01KRTdefLr7JhljmPEllxozN53zWNvpCvc6tEohTYZt+jU8z?=
 =?us-ascii?Q?I5N9en/DIIZC5sMCYn8Vpt+Ir6ZW1uMz8q0s60EqrssfvZHPV4tUo2HlqLlO?=
 =?us-ascii?Q?KYfKEHKrNTO+ITRjnrHkZpTV1yx3R6GUKSew7rBEVFAam/iMBw+QcVOVS4xa?=
 =?us-ascii?Q?NxspBgyeU6Bv7FncCISHTEThahLmanKZjr9Gz+YKXO0CZ41a+PV4UHN1EZkO?=
 =?us-ascii?Q?JhBK7XE3k62EkqKBk+zr4UrxteBrP7ilSWgR6MbxQBRtKO2SDFnoCSuy7gjD?=
 =?us-ascii?Q?nqEE7U/9QykbcCnRcV5mTATKj7/xfWSENVdex8boEg402qD7Cu26Lz7kxbla?=
 =?us-ascii?Q?4ipmg1BfrnD0o+zpNz6mgMG7XA2WfObytIu5WOScmv3wTd8n+uJatsARwtxU?=
 =?us-ascii?Q?SOmV+O2GrgipBWmvSFITD/kaXK1IEml2heKl69h0FMbETiXgNHKkVE/0v6QE?=
 =?us-ascii?Q?n4zb6UaWhfmo9yS5aQVO5n+TSYvdqSpAJm53x1C6beNJ6y30hH0Wz5cYwDSQ?=
 =?us-ascii?Q?WfM3pnYFqKTZbc6MVzgWsf1r6tMCo1Z+59PG+AToVMCm1ZRfTiMwARltdcyf?=
 =?us-ascii?Q?yFFgtm89Brti4EXpDoX2r/ObGpulix2VihSS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 18:34:39.5052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57276ce8-5746-41bb-25c8-08ddf618dc95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6167

On Tue, Sep 16, 2025 at 01:10:07PM -0300, Jason Gunthorpe wrote:
> The owner object of the imap can be destroyed while the imap remains in
> the mtree. So access to the imap pointer without holding locks is racy
> with destruction.
> 
> The imap is safe to access outside the lock once a users refcount is
> obtained, the owner object cannot start destruction until users is 0.
> 
> Thus the users refcount should not be obtained at the end of
> iommufd_fops_mmap() but instead inside the mtree lock held around the
> mtree_load(). Move the refcount there and use refcount_inc_not_zero() as
> we can have a 0 refcount inside the mtree during destruction races.
> 
> Cc: stable@vger.kernel.org
> Fixes: 56e9a0d8e53f ("iommufd: Add mmap interface")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> ---
>  drivers/iommu/iommufd/main.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index 15af7ced0501d6..109de747e8b3ed 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -551,15 +551,22 @@ static int iommufd_fops_mmap(struct file *filp, struct vm_area_struct *vma)
>  		return -EPERM;
>  
>  	/* vma->vm_pgoff carries a page-shifted start position to an immap */
> +	mtree_lock(&ictx->mt_mmap);
>  	immap = mtree_load(&ictx->mt_mmap, vma->vm_pgoff << PAGE_SHIFT);

Nit: should we put the comment line closer to mtree_load()?

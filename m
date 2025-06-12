Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8D819B3CB;
	Thu, 12 Jun 2025 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749749121; cv=fail; b=K1SAXs4HcKezuYKYWSq2gb4MCXH7kOSwqnu6oAFLWFHQfzQbAfe2tSfejrB1k6flNEx6HOq+pdl7pDnotxEcKqKOPaQ5i/0AJUIiK/xxq5M13zJgMWm3x7xfeE967nE390KjQe4+pV/+QfUAicVgfb7StCSpOwxBfKOYlBGozuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749749121; c=relaxed/simple;
	bh=bNIdlqCOsG1zxESvv2ktScwdvipAfI3sITIOgU7AjW4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnWpUpR1foCYb6rwc3MTx0vtRQ57fYu34+kFO2pKQvW2iR0LBedRORvqN+PzZm+PcBTbRgh2dFL9NhJ48qsnpNXthA6RUv/7lntNNmuM43ko2rRTov+Yid8XNlyf6QIqYZFkuU4Mn6yoHvbTDOQdkXjfL+EzejyAmC/sXydmXls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eWmDu6Cl; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eWmDu6Cl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WT4cO3e88TaDnpn72a4yvI9L9vjJOGmyn1MDFWzV4mflHNAvJwiCIkl1Vj2uU4ok/qisYYeKAs6mmJHOXdu5ElEnDqlgq1/Q2aij7imrIvL4EeDsuxO8su7N2uO3JxPImgSHkJhh4rlT5dEvSUAo9i4UO5tDZAupKK6losmYYRx3l6E3bdadeHI8Hv+zJwz7F1O2UhLANyFP+X84y4voHcj34le+5hu+ms1Lgm1KrxD/Fg28yMID/yZH2yIdzbRo2peBQhqlLFGuL1Rib/sdNCEoQgq8hFmgqqX9r6eXfQqt8mK48LSMmBZdQeKa+eTFiP2C5WzQfO+Y6Vah4RlTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv11xYbUwzhG0Lj+vKpmiNasvXHQyxKygGaR8jkBcsc=;
 b=R5aQCvb6zdYzM31gUOQM5iVirPsuNVsypuWHKGtk+Ian0oolMTU95p9oSceoSuDqZ8rETFiC0oKsyY+9LIXRl9KTFkz8Q4RuXzHfFF4ouZeVe/9nKEcccoQ+3vKT7xP4hynNvKfnOMdCjaYtJmXLlhD5QLzckOz9FPws7k17J1/FNGxEmAG9f30nNyO8cen6gGeo1LHDFP2TENVRR3q8dfDv4ejeQvY4vTIyDF8qQMzGy3Ad8sQMKB+vc6ExLpdrxR1fJaOR9ltGUE92oPRmUb4/lk0SlJFlkgy+zJTd0lMpkHZToFevD+41ams047yYKX9oaLVI5aiGbJvgD40WWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv11xYbUwzhG0Lj+vKpmiNasvXHQyxKygGaR8jkBcsc=;
 b=eWmDu6ClnVPahe/V02ZBaGGpY0TXvjG8PwbBqDnM1WHoz1NzgNxOYEtYfXnT89CXoB/pn7gLlJenQLWwH1OtyAZL1sZcPJM5K42AyUktPZlMHiwpWXSXDYIS/SzZW2kDdovxUoGbrzHrecB704/fxr5wl4nvP3+oxL7TftN4tnaXy6FcRpwV7Yclm/K0PlqdoQDfccGw4PeX9wmC92CbKo12qOdoNHcAc/hBxvomjs0HfiqWmrGYumN3YbcETJJAL8kk11UKP2LizeGHN8ygqstoD2GPJSuOmEzaWBYtUHKmEbctzijWH6ndGSWw/ZxbqB7Bp3IETjIxjRDEfRrtww==
Received: from MN2PR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:23a::26)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 12 Jun
 2025 17:25:15 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::82) by MN2PR03CA0021.outlook.office365.com
 (2603:10b6:208:23a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Thu,
 12 Jun 2025 17:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 17:25:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Jun
 2025 10:24:58 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 12 Jun
 2025 10:24:57 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 12 Jun 2025 10:24:54 -0700
Date: Thu, 12 Jun 2025 10:24:51 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 08/12] iommufd/viommu: Replace ops->viommu_alloc with
 ops->viommu_init
Message-ID: <aEsNY4X4AaxDVINo@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5586990446e4c97827b5a195622ec0f8cf9d2d67.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB52762103614C7B8F1322F7CE8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762103614C7B8F1322F7CE8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0744c9-ba7a-42b1-a1c3-08dda9d61853
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vLtA2DLXkP5wCijGgu6DM30l85fWMEwObZlO5MgrTocZVvotFXk+qF/+vS+j?=
 =?us-ascii?Q?q5JpDP1pJgYKNQoa6waBlzleGFftUiqlJG/LK2J9MDA09CbCmC8LnXqS08eO?=
 =?us-ascii?Q?cZnM0eu5Tj5Kak9J3SbynAuvNV+Yy+aDJr5OpmelmpweDR/uB/gK19B+paSA?=
 =?us-ascii?Q?xJuCte3lAJZB+dEcwOagpy9TwK8O1Y0AfjBf80vLhtMlmBIgN0rf0PAqTmWo?=
 =?us-ascii?Q?yp+TY7H6sjQqoUz43wXzaS0rWMHOFhY8UCVmGouNOV9d7u1ZZmci7putzUla?=
 =?us-ascii?Q?ZMizSb4s6dE9oKwKjx5JUKnNok9CvU1ge79VoSvPnkpUy1SURayA+JSCpaih?=
 =?us-ascii?Q?gAC/KiDYZekThKIjK0AQN3ZmX+5/y1P3sLAOsJ+J/gI/hd7H+jfrnB+1iaht?=
 =?us-ascii?Q?KaPrkfkFci+kBuSBYAqMpI3DYqdIlkPcI7xtdd3I0ffNlwKnRbkSHNLXyDqt?=
 =?us-ascii?Q?ly070FgWxy1x7a3rFiDxQRpfSirSiuhz1waT+J8T/1PlI+xAlcnrqAZHg9NA?=
 =?us-ascii?Q?HIbMEf/9TZUC/a+8bBGAeB7YfUM0CoaKuDrESI0HqLrwXigsxfehtIRPNUt4?=
 =?us-ascii?Q?sQ8N1YDAucHRcSYMroZCrxpnrioYiMaXarQtBh4xIk5EK7Lj19hALTYA7K6c?=
 =?us-ascii?Q?l35NEJgMyMOMc2LP3em2umphwW2LEb6R4GDdXww9ncyShkT/CDofPsTs1Ly5?=
 =?us-ascii?Q?loAWVcOgG91spP+4UkFYb+hyJ3btohGZ3Kn/AEXzWqVfskcokFgI0OJexOVM?=
 =?us-ascii?Q?RBl31NrlmfHgik8gzU9MD2jOlhZwMqQejwDYYCjjNuZoi39eBwTYEQ8fusqK?=
 =?us-ascii?Q?2Y3a/KyQ4T1R3EymMTlMNn1vcx2m7XsWdpxDvdsfGtuFOKSBprd0LWH/zJCF?=
 =?us-ascii?Q?5+1srGBA7PBaB2h+jV/tV3y1Fg66G9ziiFU2cJIszIJbXiZdsOX707oIPk3x?=
 =?us-ascii?Q?St1V5F3hwx5cxaMA8TlxVXzyVsdHK1riyGH9Te/NQjTqdHlwkrke4NlbBB8m?=
 =?us-ascii?Q?bzgi7wD8bCXGMMFz81ZLn90xjSd3i3XLVaZY6R4FI3qjyV5E0EV18Ruzt2+X?=
 =?us-ascii?Q?t4GMV69wkqExfiLIgus9M8hYXKxBOXTpKfYzNc8pxxcIvDeQ4DeSA/lZDLBK?=
 =?us-ascii?Q?BPnzf7m0/b9bi3Z7VE8QY6cXqOq+qlQkDe7Ou5tSefpUTt6O4iMIPACInBXM?=
 =?us-ascii?Q?Tc8l5bwpgKBMKQsIXl8fEgosT3iOJzDgrWAhBQbpVBLfAC9IcPlP2J6GG/XV?=
 =?us-ascii?Q?062VycH0d31ul3N0ZUeoJlZq1mc8FMiUmgbn/OwQDNLLyxuWubnb7CZD1KQX?=
 =?us-ascii?Q?QgufwXOag2qRVo+JjVR1Cq+/TcKej5UwXrKyH4HSkqv3e+s8jcelzU3Rt6ze?=
 =?us-ascii?Q?YjGAjE6eEwcQ+1w+FKJYEn9HwLZV025qx23L3OUcgyY/Grbst7qAS0rumRRG?=
 =?us-ascii?Q?KNGlCrgphH+MWQbuuzaIOhdhk7IWpV44G/0aVTyZDwgl6pQmjvtLtHH24xsY?=
 =?us-ascii?Q?o/qtCAk9raRAhqdqJB7IrvNkApSVZ+CGndNI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 17:25:15.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0744c9-ba7a-42b1-a1c3-08dda9d61853
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486

On Thu, Jun 12, 2025 at 08:27:12AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, June 10, 2025 1:14 AM
> > 
> > +	rc = ops->get_viommu_size(cmd->type, idev->dev, &viommu_size);
> > +	if (rc)
> > +		goto out_put_idev;
> > +
> > +	/*
> > +	 * It is a driver bug for providing a viommu_size smaller than the core
> > +	 * vIOMMU structure size
> > +	 */
> > +	if (WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
> > +		rc = -EINVAL;
> > +		goto out_put_idev;
> > +	}
> > +
> 
> It's not about user providing an invalid argument. Sounds cleaner
> to return NOSUPPORT in such case.

Yea, I think that's legit. The driver is broken to support vIOMMU
allocations.

Maybe we should change this one too?
226 static struct iommufd_hwpt_nested *
227 iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
228                           struct iommufd_hwpt_paging *parent,
229                           struct iommufd_device *idev, u32 flags,
230                           const struct iommu_user_data *user_data)
231 {
...
266         if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
267                 rc = -EINVAL;
268                 goto out_abort;
269         }

Similarly, the driver is broken to support nested HWPT allocations.

Thanks
Nicolin

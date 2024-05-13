Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F21146A6E;
	Mon, 13 May 2024 08:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715589271; cv=fail; b=o7sRRoWjottVRALn0OS/u4N2FblfrFvDdr6xaqO3tIIwYDLK4ckg3CxqfBefbv+oFlVOaOPe3NUlJUKh43t13dmO6NnA3Q1vGGIVqWLrxvHXjY8ZjRmoulIzsTmyuTwzy5UW44Z91Y8FF0td8TRck60EdLRA9Fh6Oehsc2foD9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715589271; c=relaxed/simple;
	bh=rPHDWOznTimOblrfFQDNjWEX+IEKU+6XNCf1SeO6HAw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYpanL6XVQWpRzSpRMe1tBGS2KA9oRFLKdhXfUeajhgSuLbV7qxQgFwSvq0ajuPf/bFz+dE9ommQUjiusG5p38Rb/cII2nzxQTMCMjRHfmD+3KiObcLp17UDoJke0iSOMrjQeJDoaGtXd/qatHhAg4WjHlw+UcrQOh66P7+6s2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jN9C7wHY; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jN9C7wHY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfiszgW6ulg7VdH16pYl6g72OQ0UuYksvSYHBFiKsCvYC3QQwIMPFkKFjlYF/0uzzJFe8YXxkTQXiISjbEzAvnTkXKJAq145OKI2TDJM6QJLZTEvSnAkb/SU7rBqyqDTVhmltJpcrnoWSNA8Cz566nvlRj5Qq7NiPFr4qCZAYBmk39wCYD4xTvQM+ESQaqvz8Av1FKOhbUZHCPEYfFHRnW0C2W6sX0WVKj9AAtbjGPZTmIdvkRgzTRUzEBes+RX1tH4FS9v5sS5Kr8d1auGqhcbBeh8w/kNL5Hn/7ZoBXqzDIEMZS8ThaNFRQV4PZkGAkvn9aqwM4n1rj3eFI7Uu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1lssMXrJdj7zyABwFkfl0xQA0z8jcCUdYXyN2y/Yv0=;
 b=fCwfrU1xNvyUpYI5I0q2seMLUQGc7B4kWq0m2yfKmAqF1mYedjhy4iXlENkvZolgZsE49S4RnaQg3D3Thke0FNHJM3OnUPaMzxlc06Buxye8Yh0wS8OcQfqSktUjA5ZM31P14Y4xSKAHNLRC/S0uv0NlfuEDDPBD+WHP/xm9tiv295YxRgXyqGzIEuK3Vb73TvbiC1GS2C/Jzpv3PkHSw/E0poI1kaWi7CWdOEdu8CHuZCbe9ysYKN3FKWzd/kcrl90AvzFf9iS4/hfrwp9Hw7/DqLaYkWs/s0aImOfRKKnpXAmNonHB887gq3W9aqNzYtM3OJMzk+v3Fonc3R7pmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1lssMXrJdj7zyABwFkfl0xQA0z8jcCUdYXyN2y/Yv0=;
 b=jN9C7wHYbownYkm4icP36TUrLfV5/FuSy4fOh+nUfi2FilBN4+zL1kBl2SQGGirZ/RXqmwPfeb18/k24xb1lydiJJSYWakLO9PxgWjLqpSXqjUPQpmZ5UVFCVXTvFce/OsBLRBTRhG3ntFpolcAqQB3amj0WJUtzYbMwNytchmDsWz3PbpCr4MYwdppRAP5dLMO2/8ZigWYZLtNspg3HQAToKiqB/KxCrHqIl38aViECPr5gHrYg7I+8kvB43iRDKpdkcooyUhj9JdLWOIi6r43oHs82BUTCFEYV3YzBYwrCDj0LGQzLlkdV17Tg+TSNCtVz8t+Bn6YOsLWW+QvBOA==
Received: from BN9PR03CA0101.namprd03.prod.outlook.com (2603:10b6:408:fd::16)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 08:34:27 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::e5) by BN9PR03CA0101.outlook.office365.com
 (2603:10b6:408:fd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 08:34:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 08:34:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 01:34:15 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 13 May 2024 01:34:14 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 01:34:12 -0700
Date: Mon, 13 May 2024 01:34:09 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 14/14] iommu/arm-smmu-v3: Allow setting a S1 domain to
 a PASID
Message-ID: <ZkHQgUa66uAo11Ml@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <14-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <14-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|SA0PR12MB4384:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9a61ee-3a26-4600-540c-08dc73277fee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?at6uCDjnOGWeVAxU6quRF/xrWUXc/J9euh/kfbQL59xPY+yOitiBJFHauzUI?=
 =?us-ascii?Q?XkU1esbCtWQRslQHYzAwFp5dCM8mTcWuWLMBCzBo0rp8xFX/qxiciWVWlUh8?=
 =?us-ascii?Q?RKdvFS2KYcF4wsZAh8Vo+FsivCjS5s8BhYJeiLuxGcMGCpYcbBgojhTpooBF?=
 =?us-ascii?Q?x+ItbXHs+c0StPIesdmZKfTL93QIp5eZGehhF3g0FDAI6e9V32OqOb9+FFiJ?=
 =?us-ascii?Q?Ef4/q/gnRLl6lOxQAfolmmH/qxd5e4KDTLDhGc7YZ+D9bhKoHeU0roy16sbz?=
 =?us-ascii?Q?uwri7MkvG6kav2bdBPvLfdErl9E+RzTmr8k5MFlqijn2iYpmsoWfIRr2Rq75?=
 =?us-ascii?Q?sezK5oBLhO9WVxZArYMA3U1j/HB10E8K8X6OrQXP2Bwj09zq858a/f2wvAn0?=
 =?us-ascii?Q?veo3xHAfJ1S1k4WXIFjeOnNIY6YhRqXuZVaKGrJFZTvcgwCiL5QEjv7WjWT4?=
 =?us-ascii?Q?xzVv7N5DEw8JmplZS1FOrN5IVL1UbSbNZPsa/qt0DyRC4gZb/eBgHuv2kG5D?=
 =?us-ascii?Q?bUBVk70KE1NLcvFzGZqX8Yg3lE9uaIFMl2f3f4wQ7ym0PwKM4ZLWVC8qp2fV?=
 =?us-ascii?Q?xxfR0fLH6NtsMe02tBFQGclLjv1ttgN3JFx1yRur3xIquvER8GAWoYbZArc8?=
 =?us-ascii?Q?h5kZIOWhSxJR0vf3Wo4gVqRCLPO/FO69VI3i/u9t0xnvubpVEVvH3/3cMHvp?=
 =?us-ascii?Q?RVad+NGg+/z6dtdjpcK4EUTA0FdZiN0P57b7sTiyGleVRouXN8sEN2Ea9Us1?=
 =?us-ascii?Q?cUZEAmquaJkJsveMdK/zGzPbwzEmoIY8UcDVbQl7lFTSAzNiLeTYzNDUqs02?=
 =?us-ascii?Q?wXVpTVWJHpcjGOwzigl3lGdMliVPVzhFH3FdaC8Y8vluggO8l0PIy0grbUsp?=
 =?us-ascii?Q?4tcruK9bIn4KJ5rWZ0Ig+d2+C86u2YyUHi4pHf7EmoMVhkEN0rkLUGp+lYRk?=
 =?us-ascii?Q?5kBaVbcNm4XEiTFptxKcFwtbJ4igwuB1l3Hl2i8m2hbaXUkQerAUpVbyB2m5?=
 =?us-ascii?Q?jqnOD58N11qGfwdpW4wf8N9ZLZAvFa2CdyxiRo21sACuneU0xutFOKexBE1N?=
 =?us-ascii?Q?xrz8pnZKEGT7yvELLHJx3+bbr3dsLofX8pBDFWmIiDrVc4u1z9orVDJ23sD4?=
 =?us-ascii?Q?HoaCG0Iw505JyIOELKeNFE97aOOc8OdBpwSO+wyEdZ3lS0kpSIFIUoPQ0uHf?=
 =?us-ascii?Q?qkmIvvkYaaNepj1/N1SbMxirrVjiV3d5uOaWO5Ng8v0sZb2OOwlIyiTvI/Oz?=
 =?us-ascii?Q?mN+js8U45o2+LhYwjQUOYPBxap1stleSt1hUHMI+t94pdCqQ0uj0iiZQ36tq?=
 =?us-ascii?Q?h1fpY3+uNcI7wwe5+eWxDqHny2d+BmgcfqM+3SaLGV40olAVdiEPMO5lnq3Y?=
 =?us-ascii?Q?LtoddVfWij+N5iBpy7T0B5hXAEVf?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 08:34:26.4668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9a61ee-3a26-4600-540c-08dc73277fee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384

On Wed, May 08, 2024 at 03:57:22PM -0300, Jason Gunthorpe wrote:
> The SVA cleanup made the SSID logic entirely general so all we need to do
> is call it with the correct cd table entry for a S1 domain.
> 
> This is slightly tricky because of the ASID and how the locking works, the
> simple fix is to just update the ASID once we get the right locks.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

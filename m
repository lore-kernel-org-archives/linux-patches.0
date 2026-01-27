Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010020.outbound.protection.outlook.com [52.101.85.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A77821255A;
	Tue, 27 Jan 2026 03:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769484880; cv=fail; b=TTv99pJpqIiINWQcBCcdkva8/VYMLZpLSgG0E2sOPInHbTplfkBZ1TkBV/FVSwwp7jHT5z0aL35y3UlY6Fy7qGa42NNvzSRUcmbh3xf3Ts/P3Dmw5XpEvIp8F2Kl7a/g0X5bzPgbx2XO6BhIHv9/eP+bH8K9LtWNXDTNZP2Fs6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769484880; c=relaxed/simple;
	bh=0PIF2T9yAgh0foBodiSbCFtP9oCSPeErLyejVbrRHE8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2EKhD8U9V0fAty9PU5UKSiLIWQEkjCV0IBwaL+N1kJ4s/s56YPPVVtNJnEslWCtJc0J0tEACPKcT+An1eeLbDfu3qNzPD0qK2wSvtt1TTBDFm9PidwJv65KmtXBHXivwSVFMJALRibEKlkTl3yroQdS4p2tlwI4O3EOUtMRbKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rr0qDTS7; arc=fail smtp.client-ip=52.101.85.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rr0qDTS7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKHZQ5VNjid4ukuYGL/hG5ZIj5iiGdKTTt+dXcocj5wTzeesxcAvhkU+VovZkMYnKqRSodfL/e4Irl7HsppUWJOT8bViHYM/wuBVgxTI1sDF6pmQtv6HtePqpIxX/laKND4tsJSac2hBptJDBnHgay/nXfNnbWafBTpR6oaYcEQmIy3gUcEuV+f+qUnS7GHs6Sm5pBtcCfS5dq5DAcap9exrLPtw7ofqL63cmoM3kQUBd/2M4gdSjtNKoWP0Fh08Y2Eo1Lhd1v0mCfebsjVUUhfNiktvreCMlv5QGVM5afj6tNzbZXSdMjEwj2x4plH0yqdeh6ooW4m+CG6y0/IcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vh4WJ+xpoQyB1AqP5moTYmYAs1a1wLRcIiGSKzW2Zo=;
 b=UvmFtVg6lWMs/YS02KgWNQEBL516PyAsxFxbWgHVgRAaXFx1ZIzJmwuixvLBrHGp37nz7VMOQIBQXkUoTfsJXQp2rwYUmioxmnaA5DzFL/E2w71UQfUf27KlTdk626rKYGtSa3bGC+jfCKISu8wwKRdv0yCGzpY/yAlDAbpl/yOBz5zeh1tJqMiDtmvRVRQW8BYD0A4Dy5ZoRe7mtaEA6bKhJ1kpa5qlrIbkeq+3y+XZ727iDCBxqDsCQF15ZEb6/0FyBud7RyoXZIHm0+v567n7xOSZWncMEaol6rhTLGwktj56llEaPCTc9PQp+1QdQVZ8ylN0QnyTjgjkaOpAaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vh4WJ+xpoQyB1AqP5moTYmYAs1a1wLRcIiGSKzW2Zo=;
 b=rr0qDTS7uQ+eBjC2khIrIz/q4YTKsLhDuAIE5G9cCc8lWNFsR1zk8wc89Sv0IQlkdUf2mK0NnWO10sEb3nFMU3tbwuAzqGOQbUnfwGbMnsV5KqQj8ropT1CS9+uWb9zvN65JFa4q93+7XRR73/TY07BHsP/5XNWUftp8t8QQer9Hef8uNkmqBWgxQXvzAowgeZn8boObnan+06rLOUuJWfW1hW7BlNPudDKIm7n0GCB4pPW0lfaZx+2Aha7IDQGx+8n7T8cy5fsU9aJCLOnuXrwWDgisdxE4FWfTVbHRnVbyGv2Qf0Z9217s56wYjPyhMjOCa8MvO4X4LO1Q0fhyuA==
Received: from BL0PR1501CA0007.namprd15.prod.outlook.com
 (2603:10b6:207:17::20) by MW3PR12MB4490.namprd12.prod.outlook.com
 (2603:10b6:303:2f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 03:34:35 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:207:17:cafe::75) by BL0PR1501CA0007.outlook.office365.com
 (2603:10b6:207:17::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 03:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 03:34:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:34:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:34:19 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 19:34:19 -0800
Date: Mon, 26 Jan 2026 19:34:17 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 07/10] iommu/arm-smmu-v3: Pass in vsmmu to
 arm_smmu_domain_get_iotlb_tag()
Message-ID: <aXgyOYkBz4pxzsX0@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <813abd4f054c21f1bdb4c26999ecb46eb54f266e.1769044718.git.nicolinc@nvidia.com>
 <20260126212000.GC1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126212000.GC1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|MW3PR12MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: e121735d-56d2-4895-e349-08de5d54fddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NhhcfBzgzbjGdCcnrM0zgbHDtvUVumoor0xzlUCu7tRVr9MxUuAm5p5HxqaP?=
 =?us-ascii?Q?9u0OHdxfnQdk+G5/er+bwNjdLqFjofs2GwDQf+gJV71HWtiuVu/SaTmifswm?=
 =?us-ascii?Q?u8aaE/aaxlNSknMuBQbOa/CEbP2X1RRTa2McXJQAkdbZ2EOULEWGem19qcRB?=
 =?us-ascii?Q?slfB4A/6DTgU5DlGKxVxZiF5BsPRhGfVExHH3Ismv6pBig2XwWSXOroz8bAO?=
 =?us-ascii?Q?IhEguG0/lD98cQB2T3WF7EQsh8Yzf68pxamTmgMvzd2Qkvm33XEBiwtQ1L8F?=
 =?us-ascii?Q?SxuqlwRdyB7KZhyr2yJ03EAe8wQdkflP3RnQb9WuFzW0g3RpnWU/h2iGqcFZ?=
 =?us-ascii?Q?2wpwINvbphknMaGQtVKqX6AFjFAwuOHTYwJys6x6Zjoo5XXPfvMH5uhVDTXR?=
 =?us-ascii?Q?60qxhYjENy9HnzpOA/A74iCLddoplvBy0FrkX8HXRlWXSU7S4w8wm/yWJ4W2?=
 =?us-ascii?Q?hjfPg4uligeZzfHETbFjawcK/sBKhRn0JRSqxTkgZfpY3qcEx1POT1woxVuq?=
 =?us-ascii?Q?8fdgzQwlWfG2av3wfM3BZglNOXAcdpEPVuXiD+xopSJd4/xcjaRTfzYE4iH2?=
 =?us-ascii?Q?tfrdHR3+tBAxHptVoiHJOAqjUCP+xC7UWJjYCAzUudSz+dV/m0auHhaDn59f?=
 =?us-ascii?Q?u2Pp1fiKTdArkTf6j8kF09PD/G7PEtV+6jZwAHhMg9yyInKOBlQbBq09BhJt?=
 =?us-ascii?Q?gyp9nr5dD+b4liaBemjw+4M/zD5nlffjJb8nqwHeVFmdPEaVGQ06ceI55Ymy?=
 =?us-ascii?Q?/6sH51UZ/Lc1StGopbU2HymlNsLEboXPG4FabmXDrhy3HoDODq6bYRWX8FSY?=
 =?us-ascii?Q?eD6QdjkgmY6xBGYOppsT5GGYmc+0rJt0XFwmCErRcyHaSsSQ0JtTbPmDsC9U?=
 =?us-ascii?Q?QiyONJrPHMaNQFzc959CMrD2KDG/c6qy8DSERpC6nRvXa4wUbGUbmIEGJ8Q5?=
 =?us-ascii?Q?Fxytxb1UK/os9pOqx890SpuJD2qJZKPeU8pd/wVfHjGPfqc87m0+sIRGOHE4?=
 =?us-ascii?Q?rrWwbkRxHnSuEKYcj+1LQKEna6keAkljvuiy87TKOg7CWHdEeA8xS962w2/i?=
 =?us-ascii?Q?Iq9s27mX/0MjlbRUdwdtk3T3aItp+RsWhDiOh55CRLG4/+MEHn5LkcLnEewG?=
 =?us-ascii?Q?/XLpxre0TZTMNX63gGycpp8ZXnsY+3by9QrbzJf1pFHz1vQ+TYnqlPTTSblG?=
 =?us-ascii?Q?CWBiVgM2wk1BlOR5y+qsldSwqUFjm23f6ZdJKjoFi0ycywhYr+qNncjtAP/H?=
 =?us-ascii?Q?44AmqxTuLXaoGYUkDgaS4Rhc3pI9jIqfPbaOy1zHbBIoaihkp5iFUXWVOTgd?=
 =?us-ascii?Q?E72NWtCT78q9UDtloIc3FpLqGGcmHlxLOSGQ55SxSFDZPjPcQ3RrKMM3pATS?=
 =?us-ascii?Q?A+0V1mFOiQXPnreUaf73v+MV8tMb9xNfBchVPZ43buGtj8BueyHRgZWabeez?=
 =?us-ascii?Q?0YApZwdou1X2UyFiFsanO83Z3nENK1lhogSDT1mqXaHyZzfEnfdgyw7Bz8G9?=
 =?us-ascii?Q?+BBjcCGk+f/5cOEsP4HjeoX6CPmOtQRLKrI574Ee87xQ+dzRDbjqGGkm/9TY?=
 =?us-ascii?Q?WthOl8dr1RnZIr/0pjVV2xTbx0Sm7T4XQ9NJDg/3gVw8jktIQ8XBdlFsgksH?=
 =?us-ascii?Q?RWHHm6C4TEjliZRblvpbMrkqx9W9GsdNnpC96Cttdl3hqK7jFw9dH/czhij5?=
 =?us-ascii?Q?1oP2ig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 03:34:34.9146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e121735d-56d2-4895-e349-08de5d54fddd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4490

On Mon, Jan 26, 2026 at 05:20:00PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:25PM -0800, Nicolin Chen wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 5a7032081553..8323f74c8923 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3137,6 +3137,7 @@ static int __arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> >  
> >  int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> >  				  struct arm_smmu_device *smmu,
> > +				  struct arm_vsmmu *vsmmu,
> >  				  struct arm_smmu_inv *tag, bool alloc)
> >  {
> >  	int ret;
> 
> This all seems too complicated, the domain passed in should have been
> a iommu_domain, not a smmu_domain, then you can just do
> 
> if (domain->Type == IOMMU_DOMAIN_NESTED) {
>   struct arm_smmu_nested_domain *nested = to_smmu_nested_domain(domain);
>    tag->type = INV_TYPE_S2_VMID_VSMMU;
>    tag->id = nested->vsmmu->vmid;
>    tag->smmu = nested->vsmmu->smmu;
>    return 0;
> }
> 
> Here and everything is simple.

Hmm, should have squashed this in the base series v10 that I just
sent. Anyway, I can change this in v3.

Thanks
Nicolin

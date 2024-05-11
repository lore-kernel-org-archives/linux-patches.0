Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52A2E85A;
	Sat, 11 May 2024 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715464615; cv=fail; b=Fr/Ru25GrmoYqXVNDYCxhhH6Fl+dLwATkiYiX/hNMvC3QvJgj6fFwqNnu3NOdicey8Vyj14bpMR12BIZFJCiycEKetXdvPRRldiQYb587upwv0W3WlmnoR7w42xR9ky5dpwvcPAK6vc66wmlecHala0PswtMIfAUWERdk1cBotM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715464615; c=relaxed/simple;
	bh=i6kFcdIsnW3Cxll9XaojGPnstMpOcWp4cG3CM5LtDJs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUE3P/zXZDE1ciNG42T1DjIjF3SebNaQxfZDRQNV6Gtx9MDIaVbMu40YPxM3g9xISRX7a8GoARw4DiUfKutnUWeKgdnt419FFf8llwLXW/KSW7SLH29yE9cLJvq/LG+M/QXmLy8ggkZwXXG0ZOQGofwkiSOD21W91SaNhii86E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R3sYA3oi; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R3sYA3oi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdIUJYfXwiKN0Y61i30eQ7SWVskIMAdxgQXWtx7/Ma6aBjc5vmzZR4vV8lDqBONIgEu42y0O2DxYeeNQSeVFE8p9wAd39kTL2QWCN/L9lf+rPD+nVx9JmYk2FVLIZ8Za60tEFhE2VJ5ShvOcoMCrFXHO54OInl9WLPEw7IMnu52j6dNMm7X/MNYDwO+KzJpzELt0wZp0Vs9IHPStYrQFKJRlfJ78avvTfc9gMPLaW/SGoyRxERJWTw/i8Y8/WcknwybPGt/H+ex8eUTWY9U8RRnFuBCqzFKSt41W6PZ+XEtAF3qSqbR7xfYZxgwz5wzuInME9+njnUOYiWha4h3dSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZOLKZADUXVeASayD8sXp8Z6y1/yg2pwXiUVAn9LMkk=;
 b=S/xNmYSbwJNSWItKMD/q7R76vmQUFo5xdkpsOgOn2JCugCTEf3ZlmuEY/KmhHPK1LJJhc1xCmqBIq5wKN5jI4JP9N6tl4epXmwzSzgmULX9CX8EcNnDXPv/srK98feTH1v4By1EHOy75k+SDlzlPnn/05ccq9cy8tSpOYydh8lgK52NvoTaOMOTQY2uLhy7gv1urNL7t+7WsevdlkZ1OHGMUmmYJhLln024YmER1qWOKISeJwEFXyz/NKcReOTzj7YGNvkdov7NTh+kDPLZOajzCeB10OlI63VghrZKoKpIyqvReSYNVNhklixb1YFL4q0a9fcazSmwgR0zaYiyAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZOLKZADUXVeASayD8sXp8Z6y1/yg2pwXiUVAn9LMkk=;
 b=R3sYA3oimPLcUsXQ9tLoWCvb+55dVDV0/LtGB9A14C5XwV31bnfX4vYp/tpxUUmPzYeg/JpWQdizjNBaNd282BUMhgdHEWj4gMMENyMa0VaVURzquGaDzGD4UHoJBd1CsxopLCTsnAcSokf5SL5Rkzygaq+9Ka2dLBNTLxVnPxd12/FZAH+PpHoBvN6VgQKQe4GqBZd/UiA69H5M5usf7NGb2fDFoHfs+ksLNdKXUQCVwXRVrO52MLJS7MfozAU3lACXUGRXBk3S65jeZ0M11nZ+UyE+GDgoWTOmvJ5VQJH7vKJuYikyHRNp//JO13knbMFdNzX8n1cWiVdZtVmW4w==
Received: from BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42) by
 SA3PR12MB7808.namprd12.prod.outlook.com (2603:10b6:806:31b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sat, 11 May
 2024 21:56:48 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::96) by BYAPR01CA0029.outlook.office365.com
 (2603:10b6:a02:80::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Sat, 11 May 2024 21:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Sat, 11 May 2024 21:56:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 11 May
 2024 14:56:47 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 11 May
 2024 14:56:47 -0700
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sat, 11 May 2024 14:56:44 -0700
Date: Sat, 11 May 2024 14:56:41 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 04/14] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <Zj/pmRvkKYrT/h3L@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <4-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|SA3PR12MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c156908-edcc-4e26-a2b1-08dc720541a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|7416005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9wW3Jh4IJF6W/hy4T78nnVbSI7Er4mQHu6cWHjA5KLjV7AhFdpTMLMbeR6g1?=
 =?us-ascii?Q?xojwTf4nopcbCyQD8v5A3pEDnig52N/UjqgDdNsUDIWP7VBROQFx1TW3iZPD?=
 =?us-ascii?Q?MzB6evsAyMC3BfEtrgmqY1BZFZ2DvKayubI1W6Ol8zHaDnsfnpDoP5Dk0TpG?=
 =?us-ascii?Q?70VPxPMQsS7Zar5voi7KALFPM6pjnqgA+IX9kQjEF110Djzmk3Ph9l1FwRn5?=
 =?us-ascii?Q?g8AuaMna0LHhrglGK6HngI5LLwdJ3mlNDwJHByhTem1UrgnGAmSYafKTpW5Y?=
 =?us-ascii?Q?8h10Yc1m56TPds95YfECbtzJzkj+9G0bqTeQ6acMLpO5TWElpMoaXvy0BSWU?=
 =?us-ascii?Q?qsCaQhyd+NJCq09tyGzhRf0x9Lzb6AnPZ8ueYJ+gYOyPdgYFsvIID3R42cJ8?=
 =?us-ascii?Q?Ai7sFZ3ICGF2Dt9kFo4vmvrThr8zMAO+286MVgQOShkCh8Tom2Otdo5qzNGF?=
 =?us-ascii?Q?cqfHyaNKic1oNgHvxU825V2NtkNrmjMcR0EJixi9+hPfXoNFwDyZ0OIFN4Dt?=
 =?us-ascii?Q?KcmbfBvTeSyiXe5qYjewgIo+aJ+WNVVV1abdH6i1jEDecGswf7YpxIFLGnsi?=
 =?us-ascii?Q?49jqdLJbb1d3cETRUrEXiiu1jp/f8D2b5okdepuqWFHGsO79G6aKBbDG7GHH?=
 =?us-ascii?Q?SKFBhryCAcXmJ5E6pWRfzX3g6XmcSQ49Oxorih237XCtRWTj3DXIvrwPX4Ja?=
 =?us-ascii?Q?4dZkOb2RjyLryD8mZSdWnjpvAlxKWJAlsBiShkvjPrgXG1bX+NWsw+Mzl2/D?=
 =?us-ascii?Q?onv8FQNwjSabcx+dDuHO6RCtz7FkwArWZ6JLfw33UJHPVpNTxzqHRgOfKdV0?=
 =?us-ascii?Q?F1m2K9G2v2S8xFC9RzQPrRn1VfZK52zzOZANi4FDcwfsdFTk5vcWvRONfYB6?=
 =?us-ascii?Q?tCUofAFsFKct9HlrseO2PVDnkO0gAbyasZtX9eFmRZZ27yEJgq5kiY9I62Kc?=
 =?us-ascii?Q?5osILnq7ibK/wOpLCOJ2bANmdD9/OSzR4og7bqg5INALYdwt+msJ7TkHIOfA?=
 =?us-ascii?Q?guxI2OH/t7ZJz+j3+UhaK+fUcMpqf2f5f72pEFQLnEkLsEUQRUOivQ0gkNUU?=
 =?us-ascii?Q?PI2nZ/uuYcShLfONHdMgdjN6Q0XUxzb+deCLJzvZRIooEsbHq9HgsBwbSTTj?=
 =?us-ascii?Q?65BxCfSKnz3QHhNuJX953v+TCZfIsAZ/0PaVU0AcAc5q408nCmR47RDVPAZK?=
 =?us-ascii?Q?vJPzbxlFLLI9bw8UDPgQhvKJQCXH0yenctkZ72/AsPCYgiDHnHOU5z1n33rs?=
 =?us-ascii?Q?+HUKqMHOl+pAssuqnKUsMtlQICS1RmRE8Hx95Xvg6ikpCXKAJRgsl83ocEjt?=
 =?us-ascii?Q?qohWzDKbsjGJ0FzEwzldlZa0IZoYhQzydXhwEvSa4Q0pdXH+jSwtJjzIgfM5?=
 =?us-ascii?Q?kV2qvtC4ibqLqaCDrvCbN2IfEIHG?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(7416005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 21:56:48.1165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c156908-edcc-4e26-a2b1-08dc720541a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7808

Hi Jason,

Overall this patch makes the driver look much cleaner. Just a
few small comments/nitpickings below.

On Wed, May 08, 2024 at 03:57:12PM -0300, Jason Gunthorpe wrote:


>  static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 532fe17f28bfe5..01e970f6ee4363 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c

> -static void arm_smmu_disable_ats(struct arm_smmu_master *master,
> -				 struct arm_smmu_domain *smmu_domain)
> -{
> -	if (!master->ats_enabled)
> -		return;
> -
> -	pci_disable_ats(to_pci_dev(master->dev));
> -	/*
> -	 * Ensure ATS is disabled at the endpoint before we issue the
> -	 * ATC invalidation via the SMMU.
> -	 */
> -	wmb();
> -	arm_smmu_atc_inv_master(master);
> -	atomic_dec(&smmu_domain->nr_ats_masters);
> -}
> -

Maybe we could keep the function for symmetry, since prepare()
still calls pci_disable_ats() + wmb()?

> +/*
> + * Prepare to attach a domain to a master. If disable_ats is not set this will
> + * turn on ATS if supported. smmu_domain can be NULL if the domain being

This function doesn't turn on ATS actually, but commit() does.

Should it be more accurate "If disable_ats is set this will turn
off ATS if enabled"?

> + * attached does not have a page table and does not require invalidation
> + * tracking.
> + */
> +static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
> +				   struct iommu_domain *domain,
> +				   struct attach_state *state)
> +{
> +	struct arm_smmu_domain *smmu_domain =
> +		to_smmu_domain_devices(domain);

This could fit into a single line.

> -static int arm_smmu_attach_dev_ste(struct device *dev,
> -				   struct arm_smmu_ste *ste)
> +static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
> +				   struct device *dev, struct arm_smmu_ste *ste)

How about arm_smmu_domain_attach_dev_ste?

>  void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> -			       struct arm_smmu_master *master);
> +			       struct arm_smmu_master *master,
> +			       bool ats_enabled);
>  void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  				 struct arm_smmu_master *master,
> -				 struct arm_smmu_domain *smmu_domain);
> +				 struct arm_smmu_domain *smmu_domain,
> +				 bool ats_enabled);

We seem to pass state.want_ats all the time. So maybe just name
it "bool want_ats", given that "ats_enabled" is only true after
commit() that always comes after these two functions?

Thanks
Nicolin

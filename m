Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F33333B6CD;
	Tue, 27 Jan 2026 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769533907; cv=fail; b=ffJU4P9ABPMhos5IR03ktjjbmd4CMIOmovJoF9k0/kKM5uWBZLXbdfk01zIL7nPv8EmSqIYjIoL6s/xd+I+Ft6qmuQR6nosN7XpWanKr256wBbtRpFphnZmq3DE+qXW0MpR6tBQg4v8nfZeGNc1oebiwinoMGGfOZLr2yxbDBpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769533907; c=relaxed/simple;
	bh=7OHNbO9VweRagJRD9u0/G/jqe+Uvf3ffV2pJJZ3oVAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUUrAr2X4uUxcgGLk4EXlibHOSlu0zjvHlO+VbDAdUmR56iSGAfXUj/l+bzeuDNlPBgRd2aWE29jlrdka0+m9xUM+JsKxJSrOghXo/HPV2PV8bpNdDCnfL2cl7sQvqeStzLQuESeWK2AnJCqSWc2rpaKftiDmMSyszSx9hEzyD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MKY9ba/4; arc=fail smtp.client-ip=40.93.196.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MKY9ba/4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tqofpBApN+uaSkuFdQb/i2S+kYRBZhWz7tqbPh+gb6foL7x1CDFKT6AM0h0Zvgo5pscqnviI+3klIJ9Lnfqi2shE5T3YCCoYBzGSAHisNfuV+A9bLT5HE0LLWK3IfZnr/IUtD+pLFvWEx2LF99ENp8BlaJmy6gM2jXM1ZXk7qakqI1+OB6p4MGf9tirO/bgbKLjEOQckLkW/rkuKK5w1pS0p/QNuuRgJsjIIXOBLUzenPLpx7tmkdNljKj8bbSsp5+7cPDHNjyPeFUJ5PQI2igcZRBYBHmhgK3/w9tWPIDnku5fRG7JVpX1upG04HgrxxADDxbsHD3rQIcLz0Oj3ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a5VxSQlT38xFdIzorIXYuKdlRyEckZmABcSXjFdCHU=;
 b=N4naBBqv8860G6MjNnN9Qsv226eSQ1qvTmoUjnRYLRB4AVkC/5GNI9a+tPR1shYAQVpuh49YnYFyDRELTZQzuEExizrjVesSoQ6Ae761ZYw40fZkzc8Zd0nwrWEnxQ5s49mszbUwP3VJJFeIqs90hyBhici0LhjrLDDmhQ0dpg+H3p2CwGOxGZJIHwSrYyaytfFMZFOtPxp2nFfkasSf9t23rRjyn9qTvSf9nxU7eajByJppm5M3TJO0IMgnD7C556iKQruJrPtN6ECSuXK4wS8nqAPEBNS+h9Jq8uSQswcCK2id0ate1OeWrgEWdEhspshdyi1zLXfQfnaInDUB8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a5VxSQlT38xFdIzorIXYuKdlRyEckZmABcSXjFdCHU=;
 b=MKY9ba/4mlmLq0mdI/LX5WivNfwkdN2lRNMBs39Qedjj327ze6lb5jl2+VmpzYy+0/Y6VnE14KCOsmnM0jCjR82uP6seTHR6482jSaCdxk0Fh2QKluaxvBsU5iAvqSJJbJHOO9pIkHk9AS1HA0KDC4eyjfxqRWtJtP2uO0M5jzZO6X9gM0tzs9A2SQ1eCHVRxRj3/ii+9KpezuSofZWZN1hW/ZVrQe9xmB22bhyKuEiyphqPBcpFGqWoEP49Lp4JyHi+hF1Y6Hxgvq6X+MxYSXVgGJpvst9JjlV+JRJaJtHhxtAJQHvmj1tljvfmRvOCJwOJN8BngfbwYs3ckeGV7A==
Received: from SJ0PR13CA0039.namprd13.prod.outlook.com (2603:10b6:a03:2c2::14)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 17:11:36 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::84) by SJ0PR13CA0039.outlook.office365.com
 (2603:10b6:a03:2c2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 17:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 17:11:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 09:11:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 27 Jan 2026 09:11:16 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 27 Jan 2026 09:11:16 -0800
Date: Tue, 27 Jan 2026 09:11:14 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 06/10] iommu/arm-smmu-v3: Allocate vmid in
 arm_vsmmu_init
Message-ID: <aXjxss9H3NQ/qe+m@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
 <20260126211636.GB1134360@nvidia.com>
 <aXgrsJeXB3bpFQqK@Asurada-Nvidia>
 <20260127151138.GI1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260127151138.GI1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b677a56-28b6-4a5c-bac8-08de5dc720de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZdG+QFzFHXJuereYuTwwDfx5lDfTnUMXFL4yp6W/rvmHF+/4e5ATDyflot1O?=
 =?us-ascii?Q?gcc+XXxk07QwgJvYB/wrgfsEYbUZ2nuSkAr235aPo5EUebKU+ot6DgbGM7o9?=
 =?us-ascii?Q?GT7KpblII0m4G8NYvOufKkpiOFG1cAELVsnNsseTWyhcYFlcDzjMMpMHL0s7?=
 =?us-ascii?Q?zErmwOKrBQJ8jiemHCVm1UsnxONBxhFD0MAtkz3qQQC6/9UdyuopoVqYSkUp?=
 =?us-ascii?Q?QisW6FrXZzfa2GI9hrD1TXBf4rRRZm+MN/tcBRDzq0pIcNLriP0rU8aiA4XH?=
 =?us-ascii?Q?mYPnzmtfBCuTB4Ce+SANXenuDrRmw45Y7Fr96XaepAStibNuzGFT+SOlt+BH?=
 =?us-ascii?Q?KZKx2BshEunI74yOtfi3FRjCLm9WufKP8Rb/6hD67TmKwxaNZGgs9lo8vmzO?=
 =?us-ascii?Q?Yd4eaJBIPOU0pCfvLn2AbxgLviWnat1co8d4SSXOOWz986N04Ljs4JCm0eD7?=
 =?us-ascii?Q?ADbu0UsuhswYZnby8DNc6mY98qV11OBwIfjrlSIioW9Zb+NvEzNfVm7pzdy6?=
 =?us-ascii?Q?vi1an//Dkop3Wk/oJeQRZ2RzOvEUsZg+5cCuNQqCEbHi2WVKhAruLlV12jbN?=
 =?us-ascii?Q?iII5n3hLiBNN4MV/20vN4J1fP37LOmQSNEm9mOlv1DnXzzfmDuCZ+FUkv/VI?=
 =?us-ascii?Q?giowJfyPjxBZ30lNN3q8xxbIwxff9F+nJxaUJkohp0aMlEytzg4Ren5YO+Wp?=
 =?us-ascii?Q?nKvnpi10uo+SU8WFilgLsNZo6wzEaEPCC2X9p/IrHFknTx0kR3Rwao4R8Vm+?=
 =?us-ascii?Q?T4EUxuZ1ssuIu11wMq6dZMs8dvv/KyD+zeE7IRA57Wr0VloqGG/0cQfeO6nS?=
 =?us-ascii?Q?bIojFdEo5kWD/TuAfzutkDgIMA39QLTizmaqRmn2pBTqcLbiSWRF9W4zutHE?=
 =?us-ascii?Q?8WZ1hZC9bcXAmfopZtT5mYuSbFEgVC47Rx5/ZrLlcPjfbOv0QW1ALILnlefc?=
 =?us-ascii?Q?OZLm3GuFEpz0Lyo/uBg4399qYYUcbEIxcJ+9R6JtxU9VTZeMlqLhnteyFrPl?=
 =?us-ascii?Q?or3YD7VTPZe09mlSGrLCeB+JZCV18IdORoWcGa7FnzOHPX0fOgKhhpJIlHrg?=
 =?us-ascii?Q?U9pa3wJT+yxt8vYzMmB+wr7gV11jNs1FSMlOXURUx093DvPq9Wc9khzbNYNs?=
 =?us-ascii?Q?zR3J0xN34rraT26Q1ZiYynRGC9rtzcJidf9ggGBHEucDDOnNak+V/XNfc/tR?=
 =?us-ascii?Q?p08hi5v+u8UyjJqjv49AfDFTwb9AEoOmh7iYxEzFku+u2JyqI9dmW0xfgDaG?=
 =?us-ascii?Q?XHKhHd1Wej6GZgar8q0lbdzw5OwfxGiInQ5wFOL//+P62tNC59HscAp7XQdc?=
 =?us-ascii?Q?GTR9pztSfXAqQdTa9tp4nUeCqnDNmNQd8D8f2Q0Sco0mlu50sV5koFp7B6qH?=
 =?us-ascii?Q?u7AlS4gBpQadqQAMK/P/i9W0HgK7DvxZrTsbAu4fgG77nuvu2YcBoMEHBq8J?=
 =?us-ascii?Q?Dr2Wwf3GrrvCudMph9DZQV5GGRtNvsgoa4gfn7UzttPELNPJwrDB6vUDE+2X?=
 =?us-ascii?Q?EP8lIJTMQgdSC+vzYOh/Lm0chkr65d8nS4lBZ4zoe/yASNUVqsxCBsQ1nh4s?=
 =?us-ascii?Q?EHgWZRiJq1MZ2guSlvQW4l8SVwgIZE000JnOnLQcsUPuXIFPxX9/Z1i4oXhy?=
 =?us-ascii?Q?MrWO4KEOB41sLvn2WFVzVwDQ+74oLwCLybjKIXA6xXqPlS0b0P1KhCasYHiD?=
 =?us-ascii?Q?oQDXRA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 17:11:36.4319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b677a56-28b6-4a5c-bac8-08de5dc720de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259

On Tue, Jan 27, 2026 at 11:11:38AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 26, 2026 at 07:06:24PM -0800, Nicolin Chen wrote:
> > On Mon, Jan 26, 2026 at 05:16:36PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 21, 2026 at 05:24:24PM -0800, Nicolin Chen wrote:
> > > > VMID owned by a vSMMU should be allocated in the viommu_init callback, as
> > > > HW like tegra241-cmdqv needs to setup VINTF with the VMID.
> > > 
> > > Even the architected SMMU needs this, the VMS (not implemented in
> > > Linux) should all share the same VMID for the same VM.
> > 
> > But for standard SMMU, the allocation/sharing could happen at the
> > device attachment to a nested (maybe bypass proxy) domain, right?
> > 
> > vmid is only needed for STE (attach) and invalidation.
> > 
> > Or do you see some other case where vmid must be allocated during
> > viommu_init?
> 
> It has to be tied to the VSMMU, it doesn't matter if a single VMID is
> allocated on-demand for the VSMMU or for the lifetime, it has to be a
> single ID and shared across all STEs.

Attachment threads are mutexed. Any device that attaches firstly
will allocate a shareable tag and add it to the array. Any other
device will get the tag from the array and reuse it. And nothing
will change this.

> It is easy to understand that lifecycle by just allocating it for the
> lifetime of the VSMMU..

Yea, it makes sense for that matter.

So, perhaps:

VMID owned by a vSMMU should be allocated in the viommu_init callback for
 - a straightforward lifecycle for a VMID used by a vSMMU
 - HW like tegra241-cmdqv needs to setup VINTF with the VMID

Thanks
Nicolin

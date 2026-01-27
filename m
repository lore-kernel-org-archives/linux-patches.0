Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B07C267AF2;
	Tue, 27 Jan 2026 02:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482243; cv=fail; b=O4LgZI7DoSN97g30KPXotzVYgjw5Y24lABmMt2a2wUlVagZvvlM4n3g12vFPDZbCMjYARk1kLGyayBeEX1qHAGbs3tMdKieCSDxOHY5KJ9KSOQYVXmYxzexZ8qOFOrohm6NyfMppPA8OemISrQqskaFI7RTwngV0ZAdwiCUnlk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482243; c=relaxed/simple;
	bh=rg+VS9ndjEl9ymMI0Nj5NxOScxBvoh3nQUS0z8bBhXw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVtNcEIZw8w8C8+3lsiLbU7IrPGizhczD/hR91YqwQgsejKUwJKuJCPkzH7uC9Gh8tbYplGwano/iwWYXiqeQrjhG+erWGihqHma+lSYDLKgkComUH00HR7GOemWsYP5gCE1vzfshPYHO4AtHubkMrgQRKNxOaP05bR7BXSOKb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mGirRedH; arc=fail smtp.client-ip=52.101.61.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mGirRedH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LkIhVk80c+mb+HtOT3+t3gyWQxwmDnO9vzzdmt8Ts61O9c27GUgqUgJArvK5SUGfk127eRtXlQy1lcd8ClFXEt6NFHDggmZDlk+b3BlWa3rQF0HnEEtvl2Z/klHQ1sL9arm0u+wK0NyY0m6oZjxqVWI68zHjFBK5hBcewrAprahiu7uRr+sbyXYcfCTSk7qAuIIbcVpwloAev6rZpalr+quZ72W8Y715i2zGtB6nRXaZ+Fi7hG3RYGCLq6rcndxvGsfYeYhG5XhOvOmsQSWbbgdiLsPIkS11OWqAzrgBCjS+GHLVJWh0BcddfQqJHhmu3KJDFqSq077puhZGRD/DOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dO+c2mw9b7Oyw3+mzbrTMwqKEkmL5bdvLUYW+7ZW0a8=;
 b=pnZ7hlPo3aO7lMAUc57GVpbpQ9IF8u6c9XVu6MBePxY/drDEVzOyi+DCrH2ih14ixBSU1J6q32vuysXS++LU2mWlafT1ZNJphw66RhnDWfoHBo9j4GrgbJu5/rbh2V4OEMAnayIY8OuI0BJ/K4drdp1H+poc01DpOzTPl2uUyMzRnUkoY5Z8aNwY7NgnjMi2aDdAktedZ7lZ8hrYlz/aWJV8LTRFmWJI58pkA0fH2XZCrBOtnIkCLZESNiVn/t6KCJbsF2H4wIkY4nPFgH45II6O7jti3x7v2afwh2ghUj7NuctsdwNoaZd49zNXoFFhYqrbFd+d9OTpv0IXpL1qMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dO+c2mw9b7Oyw3+mzbrTMwqKEkmL5bdvLUYW+7ZW0a8=;
 b=mGirRedHa5IVcTTC9LO06qhnn3VNJyjiZKK8TKxAkmM372gf3dJApYlQ7NmN6y06Dep0X42KYnIPGdalLfVRLGf20dU5bcunOnG4QydQ8npgef7ahcrrw16Pk2+yMooMdsUX58KnuESmWMDw7yr3C6McDj/iIUI3+ik2US2Pd4QY43C+Epqk7BcGtpZfIQjoKEyNqtwgzZhjwABfEXu2sn4kjf3xJv7EW8C4N/Qh3SfQpIFXDAfBtJnepVoLykZHI7d8oa6a9m3ypPVng7OK/4nFY+r6ItOHBK0GZd6kGIGcOYQx5DUofruQMl6OhV8arRAainRf0810I49PbM7slw==
Received: from BYAPR08CA0020.namprd08.prod.outlook.com (2603:10b6:a03:100::33)
 by SN7PR12MB6838.namprd12.prod.outlook.com (2603:10b6:806:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 02:50:36 +0000
Received: from SJ1PEPF00002311.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::3c) by BYAPR08CA0020.outlook.office365.com
 (2603:10b6:a03:100::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 02:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002311.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 02:50:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 18:50:22 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 18:50:21 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 18:50:21 -0800
Date: Mon, 26 Jan 2026 18:50:19 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 03/10] iommu/arm-smmu-v3: Look for existing iotlb tag
 in smmu_domain->invs
Message-ID: <aXgn6xOqtE8935A/@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <86118601583b0c98fef39d38ad08be232bf1d04f.1769044718.git.nicolinc@nvidia.com>
 <20260126210301.GY1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126210301.GY1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002311:EE_|SN7PR12MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b70140-cf4c-4363-8dbe-08de5d4ed92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8LxE7ylKZqX+/PfG0n44xVPCymgIqbqgvssRjNjIUWEYa/a7uzH3h2F0OzIW?=
 =?us-ascii?Q?QegqjIqgIGW5bapOlGFDvtebykcpXTrAp+nFUdtgKrjNFRokkUvbOHi4vzT/?=
 =?us-ascii?Q?XvK3MRlwGNtj8ShU8jojSWY5RnfuWq5vPq/loN9nNe1liuBMbxn6A6wqUoWM?=
 =?us-ascii?Q?8iijMKtLu23yAxbqLLYb52AJJquNCtAiLd/eilfD0wID+KTPdpW4wbMzuMIF?=
 =?us-ascii?Q?qKr6GM6JPdvTgLustifVjtfjHEZSF0D2DjFSKsqelSW+G0h4z0D1PbffZAyM?=
 =?us-ascii?Q?0bEHIfoGJCA6M33fIDbqa1I6AfWJI0UOPBCK7FK7iw5cCIRcspn9bFU/jMYC?=
 =?us-ascii?Q?PQA4ftvbbXgrY0QK6CScsB8w2qqcaKlQ6m50HlVMWLx6pgyc0aVUHdpATTCx?=
 =?us-ascii?Q?rdB1IwqAMHVV2njEEiya0T6nKa4qzzt3ryiEiaPsF7ylvr5YaBQfGBTn0mb2?=
 =?us-ascii?Q?xVrcFxA9db47Fdr1mHb8Tf2QmzX41rGZ4uoT9SRm9I26WgT3kn1R/IOppMaH?=
 =?us-ascii?Q?UnBYWNObo2o43eDtnJHC097OVCaMWrXfKOImHBBd8Joqy58gknAELhu3NkdY?=
 =?us-ascii?Q?Du6ehYHTNq9f/hE6p5GHYogrfNyOdMS/GauY0p44NhJRRJQcL5+rNwNIXIo5?=
 =?us-ascii?Q?yTDAcQVrSXzxe0OQvlixHPoDzD12xbbzflEfSzhhbmLCsY0Y4t46gQguWrZC?=
 =?us-ascii?Q?XW5mrUAW7EUmWCn1FQ497ff35mPN11KIsq76IfX/PuTp2UNBrxU57j1z8Yf3?=
 =?us-ascii?Q?/DPPbWZGVqRERRoQzCiizRtvDwV61GFm067gLZkn+PCv4W7pvi3kwhSqWXC8?=
 =?us-ascii?Q?n+Oz/ezrN5U3VDhOS+KjItsQ249PFvk2w1MGuEpXICNNLOn+CGS5TVOZU5cF?=
 =?us-ascii?Q?BdDMgGsCst1UwUfHD+A68MIS8UGRao6unuMFxkdFrbSg48JJHBeSwmaBJ/tA?=
 =?us-ascii?Q?gJKZa+pStDb9YEkm/zMKe4P1SsXycjPisjOYmL6d1EEMz2WB2eYEZdMWK1xy?=
 =?us-ascii?Q?f9u9Iyoy0tzUEIGZkliRQECgPKHziOMRr0oIhn0qe2ohNCBd3VqXHWv6UlI9?=
 =?us-ascii?Q?rbnQtq0vBpSha3RxXOvMkhTfW2H3ovjSAhafJp9MIV4VSg+haGXGlQ6H3odc?=
 =?us-ascii?Q?RQr97yWC7SypGKOLcCdlUZSQTcTRAbV75Zo8hxvqsOtDIwBjfrZ/iuCh6ogd?=
 =?us-ascii?Q?8Zquhs0bWfVUXH8kKc+aguWhnFVrXfA8268KeV9xiP/jj2V1IBcW29QiV0s1?=
 =?us-ascii?Q?FGy6qwNjVvUIG/NscrwQh7kbMlItUHLXuhirn3XWo2lLmOFhWvLFMSxRPMBO?=
 =?us-ascii?Q?JHAqfBPlPCXo5aYwzW4HNjZKh3RyYvkLprFi9BaMHrBane1Y31G3RPOZSnh7?=
 =?us-ascii?Q?+IfIg49DvYT69cr+WYgRFttIyH4GMku1vW/FRzadXikSx/s8AP6/zR99qAaN?=
 =?us-ascii?Q?/vHyjXiFsxqr/ASMn+Vf9qwMHYOhu/V1Jlp9cGcjwPPOqPelrivXp4M9yHuG?=
 =?us-ascii?Q?of/J7cdcEXnSIC8SsqfqoDxDDWGoL3eN5MD0mnZ23bMsEv/nV0oy7pMNP2Y6?=
 =?us-ascii?Q?vDtLjQ8LX6HZWEzcuGURXLERuj80qwMuciD7KskLq6BjCV/gfZ1ffLG4S3H0?=
 =?us-ascii?Q?83YpPS3sVde9YlJNKhnxT8sFF4hwV/woIvth5T1cd/h6JtcQncneolICKAZj?=
 =?us-ascii?Q?ijI7iw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 02:50:36.4839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b70140-cf4c-4363-8dbe-08de5d4ed92d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002311.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6838

On Mon, Jan 26, 2026 at 05:03:01PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:21PM -0800, Nicolin Chen wrote:
> > Once arm_smmu_attach_prepare() installs an iotlb tag to smmu_domain->invs,
> > arm_smmu_domain_get_iotlb_tag() callers should get the tag from the array.
> > 
> > Only the arm_smmu_domain_get_iotlb_tag() caller for new_smmu_domain in the
> > arm_smmu_attach_prepare_invs() will be allowed to allocate a new tag.
> 
> It would be nicer to have two functions 'alloc' and 'find' instead of
> the bool. Alloc would call find.

Yea, that just came to me as well after seeing Will's comments
in another thread.

Nicolin

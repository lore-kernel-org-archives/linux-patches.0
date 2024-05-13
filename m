Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1D29D02;
	Mon, 13 May 2024 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715636118; cv=fail; b=ELDhWnpks9SDtCbh965qp29F+PXZ0aHrGWZUcAOEkqAJ8u0IyzqCc/7B2Ly+544+l1/dYRBjCReAywlxWdj7Ab6meftF568UX6L/kZfN3puorqj9691ujHvNshOjdSO6m9QI+EVsbqtPdGEWZOlvO4JPJjEvfhHfEM3jEmonExo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715636118; c=relaxed/simple;
	bh=bC0HKRdfq5W9+yyxk2NTFGUDBHTubMe/1PiervDiYgs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHJ3pgGPhWh7wJTCpALE1FW1VkGoiFgQTRPxxMVTgFk8pQfdWafgOdIHOr9kpNQHtXTrYV/XwBwQ2eYfrwaw8p9T8p3gwxiq+zpb6pUl/lKaUbvrS+6tTqRu0Xz01q77WEuZV+xtirganju6Wnq5biNeNQnQe3a9cxUTzcA8bnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fPiucNt4; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fPiucNt4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axFTRBlHD68RoEizNU1UenHTNr5RIFEUp6ZlUGUPIeqBeY7rGf3gCGPjgpgvdIgCYqLg3zo7Fma9MESKYxwWR3pnTGxzSHHVJckzI5dmlN3WGItxnorkrsa445mCYxajeJsXu0WlmauCHyooMjMkz56L35LtsGH/v22VjuA29hBXJcGAdSScXpJPasMZ4xdtQNwNDGuEihSSAPcqsLd1N5oA3b/amULVWjbmKqmg9KyIAiIkKgtnlWTMIY8e9xgMBSYXIgLxM50HNm/h4+WY/wm++Yv0eMaKA0OnLU7oPCu2W2hS0rIneKaC/EgW7UZbW1eaA25iVxJwE4aBxq0gKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0eZ3kW2deyGA6VHWB5iPTPnTJIoMd3dc5a1b38f4ck=;
 b=FSgyMZzBRg7yLjvcdKszYsPoiefFx3bvS++/NHJHMFWKPNvOQcRm2fG686SoK5hn7zlvsyOctWj6Eoubs+FeCxFzcwNJA2iXQvIN5Yy9WT5uoqK/zfjMTo8kBaZ6uQKiyD11oQOl2r/2Bce6hkSZYGULpflHG4fLnwCg4b9P26c3BB/3GfdSNnX9edBRR1yApdBK6EeKBonLw5qchfGyLT+w6BsgShMHjwAYQ4e+JfxBA2x17YSNO8XyDatMBRcHGodCK4fmSk52dQ8Z+hdxCQQhwlAoweOzR3zjcFbhD8bNAbC+ELp6M2MVX3liRiEGVwF4kntuBitZMaF6Tbzuzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0eZ3kW2deyGA6VHWB5iPTPnTJIoMd3dc5a1b38f4ck=;
 b=fPiucNt4dRBigIBBkhiw5z27ApxKsaVPOQOn3eBeerZNRW/k5A7j9M37ugn3RV4eyUUS76Z6LfIODbB/fz76zNxBK1ZTm9J4BZjFib8ibnpaFKNwWLR4DAs/zb7y3KmV8fo+JOYIOws2i0hC1lsY2HabDmWs7AQYgZVRMh90KYw9xHyONEX7bqxbPZB80WiZ2BmzK3BiLY1sFOfdyt6fwQGmQRE+Cz5jT5gXCGr3wZbK2lTJXQAw0cYQ+t0PrhJ8yjRQ7W4rZgWZbT979unuISfV3uihJ1nUqK7Y1EFfYWnvCRAfhJ7ruJskrvJP9QzZrl2zJ9aPDvWyN4xQeSYSpw==
Received: from CH0PR07CA0002.namprd07.prod.outlook.com (2603:10b6:610:32::7)
 by SA3PR12MB8045.namprd12.prod.outlook.com (2603:10b6:806:31d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51; Mon, 13 May
 2024 21:35:13 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:32:cafe::30) by CH0PR07CA0002.outlook.office365.com
 (2603:10b6:610:32::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 21:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.0 via Frontend Transport; Mon, 13 May 2024 21:35:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 14:35:00 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 14:34:59 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 14:34:56 -0700
Date: Mon, 13 May 2024 14:34:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 12/14] iommu/arm-smmu-v3: Test the STE S1DSS
 functionality
Message-ID: <ZkKHfpKMWwC7LCan@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <12-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <12-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|SA3PR12MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: e793cd40-47b2-47cd-d1d8-08dc7394918e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hHloXJUx1io/Fi7XUSGP734gJnhZZOpRnPCk5HuUSKYtFZwvdbQmLYa2pROA?=
 =?us-ascii?Q?r4iZAWV9vcouOhZYjOtOySnb0GKntvFhXyM741/sJhjLhun0tHOn16qIaVxZ?=
 =?us-ascii?Q?I7UBT67Qdni2fBe+gdBZsuSuERHxvmQadVdj268Q6DOrkrwxHbuQJ602P1aL?=
 =?us-ascii?Q?OqwGy5WtJKda/2Scg/LpDvJMw9cYeiQi/acCshmBOp5P/xg6SydB4dc5G4Vb?=
 =?us-ascii?Q?LXfYCSbRFxeLCVUnTuhPYy8OUM7I5c3+ir0D/PPweloh/lXxE3u+wJ2ywo3s?=
 =?us-ascii?Q?6Bgu+ZltxcZ/0kQPgHIW/PwUK93AG0fdM4IQiG11lhlg7E5ZNfIfO1001UF8?=
 =?us-ascii?Q?zIQEbJYszpIIz+srlaoq203uE6SUsrKiumw7vSOiSiNuMdyZM0r1D2iGA8SB?=
 =?us-ascii?Q?L2Om5Dbhe0ctmpRB9aGIbwKRZtzLTC8avcw39W8e99YwzYsKCOksDdKdSRtp?=
 =?us-ascii?Q?pwKlVRKMA/9jzIbIKSJm9JPBfnDi6fHr6HrN5z+igNz3a7LlrWAok3m8Gaz6?=
 =?us-ascii?Q?VXVfDZHfjaa+LRjix6G07upg/8P49r6X9BlZ1ugSFQXkguk1SM+lptWMZYPE?=
 =?us-ascii?Q?uMqt+AHZEN6J/guXl+34prSwB+hSfeQejhhL2yfJVXXIixY9fDLlu6EJlj2C?=
 =?us-ascii?Q?D4l1eR1rY1PoJQRzKXgDonx1emRIsF778s7S5b3DJJY01z8755Gi34fnVLVW?=
 =?us-ascii?Q?oagZRK4I/bqxfvGNO11aRvP1zjR2zplY12u+NpAU28daG2tbwNuP0Pf1BGpf?=
 =?us-ascii?Q?CinLS3Qz8OTdcXnAwg0np7ztdcIfcmDXogo3bimhg3H3JoK2RPY+EHB4Tn/r?=
 =?us-ascii?Q?FB4pFiNY5he7/Wy1Wx/HnN29B/h8cLAFkZC4xL+8kH+mBL8ALS7VRpNiHMnD?=
 =?us-ascii?Q?nr+7D2Be+UjL3Bl5CoPOWdfmeEYqgOlNUg5P1NprUGtXzV2zXxsnJsok/xvR?=
 =?us-ascii?Q?tmEkY9n0oR70ThgeVtcMmZgF3J/g3R4BM+8BRhcWmdF2NzRha80se964NoC5?=
 =?us-ascii?Q?w7t7OlFzrL3RZ3bUNcE7yU0et6r4bJlIWIhQKHesZO9g7LrwTh3HVwt/dzSl?=
 =?us-ascii?Q?T+A4GxXQeEtXDjYYIMTw0pyhgQRGaXzT1T2VK0ZtM7naj2B4uxMu7cmFb3w5?=
 =?us-ascii?Q?1UwQOz1B4Yy/pr5404IgnBeRaS//709crgosDCZ3AqmrrJNPvrl/seGpe7yj?=
 =?us-ascii?Q?5TPxmHaB0T95fSKs0n9ID/7GqE9kMvCuqUySYRN8QFv20QhXOr5sXCG1SPTQ?=
 =?us-ascii?Q?LVE+kV/GqE0XBAG+arErDCws0WkJmj5B2A4YpMF8UCeFnP5L+FXMreXtqYij?=
 =?us-ascii?Q?PsA7Rahki96HvGGugG8K+zMVhtiKoACWWQC86lo4zwF+zsECLzqXiiRKJ70e?=
 =?us-ascii?Q?9JuoGpc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 21:35:11.2615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e793cd40-47b2-47cd-d1d8-08dc7394918e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8045

On Wed, May 08, 2024 at 03:57:20PM -0300, Jason Gunthorpe wrote:
> S1DSS brings in quite a few new transition pairs that are
> interesting. Test to/from S1DSS_BYPASS <-> S1DSS_SSID0, and
> BYPASS <-> S1DSS_SSID0.
> 
> Test a contrived non-hitless flow to make sure that the logic works.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

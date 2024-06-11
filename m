Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4A441A84;
	Tue, 11 Jun 2024 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718074971; cv=fail; b=JjbDZNOv5WixTEDn22QIHj/14z3miY6uNQSw9VoW2MPOW/TpSDTsB0mJEdCpU+GiyAdLsKVtbpqEW4ZZdaDY5LQ32uFxj6wYSZQH9cIFta81GMFj/8PK3wkHXcwJLkDEtsgBUr5xP26LobSOaH9PAtioEUzcuiSieZJawsh3i/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718074971; c=relaxed/simple;
	bh=OgfEbe55Xy4Q4ZY0aX8k7gj/cEp3m2MK5WR2DUaiGLk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0hWKSXX0+j2alVc84uGTvF5qgwmACS0vNU1ySiR+XWNWVZYk951d0GdhTRDFCzBamZdWhWmAr8eJMEq7xD3xldDiZ+PL+4TvzaenFDTIWOuB/y1cdLDyqYpSopB/dp9PkbfLc/CntoTmE6cFAdV13H2q1UT/OxjKRmAbPWrhOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lfexq45o; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lfexq45o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrN0Phni7wRM+WtrYXjfJNdBvCIvptwDRKvAD9SUPih2ogF98Ex1+54ggGXzRge0q/aT5Y1HJEQZYZN6xL7r52n+O6EVNBJX3qz8IlqTFrjk3qlxwhxIM0xe+N6vK50dANst0GlJEVz/6gbL+Tp+4ip1rFHFgcspiuAROKMu5S887oqQbzbWfOdHacvq9/bMP9UOjq7RYsX5izAK56oNb4sC6N4M7FcKigcEOM6d6aFVG1QB5BJZCugxtNokFI8e7MfjpdqUGmlSBuOd8R8mMnxNyFVy8LwhlqOzTagc0x06+xj86Bx7jUFhm8q2wgD36kMwQPWxVcd/ZjlItBsZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwvR9169Y3fCagaUMY3Fb3tXfFPbFXP5TeWFwT7xKSc=;
 b=b8+TC0ibdhCHaHDZi+6VRoie1VMplercqX1Q/s/LOK8aW68Rx2sRAXrAKDD/1E8sqBcOodIzWOG0g03NOuuC8GHT9Y/6H+3DDp6Fml5QPq8kyb81m1qqdKLRp+2RNgf5KTiUySdv3zwzxT8h87pivAxSTs9XoPBYRQrqbM/KYA3NQxkbQP5vVjGQvQenhWKbuj2yylw5oknNtwRo1Ni24Os4CILnpk0Ne7HLIFoO36tRsNE6fZ81nOg9YXyITsqsIf5w6l904m4rv0o+WbR7E/amZ4JJA8WgusbANoVpCe8cid+GWjJjH5y1o9pWOcHZgAB8xjJXHeKX+YKB6zY65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwvR9169Y3fCagaUMY3Fb3tXfFPbFXP5TeWFwT7xKSc=;
 b=lfexq45osS/28uWqfEXPooeZPOYi/dT+t2+4Sg8MWCHL04hVRfdEKaUF1OOrYZI0aAFyxD9oyQ5izq8b3X+EnCQKQ3R+nTv8rNVbwNOMp67dwgL1QHyGKwNaTCiXaxYxgzIYvuqFstsxoSwGwSXLnsIVDAGru5utE0mNS2orOftiXpbqXwO3GFsdqWZyrwT/b5WJa5L35EN//f8qa09WWz4lhsmgf98PR7UIaLxuBidcVpIoXnfdRzRKRHdqcDFSdPIiYF2+hnfXMAdFVOG/Lk+X8wPTnf/9s1Wfi6TgKmS3+W3omf+37I9mnCYaHvjxaUo4O1XGQNFhsDcpAr58lQ==
Received: from CH5P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::18)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 03:02:46 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::c2) by CH5P222CA0022.outlook.office365.com
 (2603:10b6:610:1ee::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 03:02:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 03:02:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:02:40 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:02:40 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 20:02:39 -0700
Date: Mon, 10 Jun 2024 20:02:38 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 08/10] iommu/arm-smmu-v3: Shrink the cdtab l1_desc
 array
Message-ID: <Zme+TrcsIMtMmdUf@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 5865a0e0-c289-410d-a2ca-08dc89c2f899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qyFPQ5GYFqXL4KyW/YDJ7c7K3QureLjD7yyRx7H2CGD/kTFknU9v9RsgiQ2H?=
 =?us-ascii?Q?D0ylIF6uP0l2xCwRLqCoLHA6jpFpca9fs35bbRcImdnylpagpixHyPxoPK+9?=
 =?us-ascii?Q?hu7Czpxe5vshdOUMoIenaoRfCQwmVJVWpASqAoF81+KH1rhixao7nsoqMJF8?=
 =?us-ascii?Q?83jbiaKFU56nvpFp01SNjFLR0unXf+wGnvv74zNLI7voiMDdi42LF5pLK6k2?=
 =?us-ascii?Q?pCKDhCk4UU6HwOxjKmpdMTwWxeeWiAPxRLVKBbbNnMRmt8JBtu32sz+qXnYN?=
 =?us-ascii?Q?BUasfbHOO7OzSjmASco2daBqrJl/Z4YZ+b3zyO0lg7uZfD7QgVlrFmeooaXd?=
 =?us-ascii?Q?4CV26zVy8/xW8CKfwUY5ZhY4D3UnGqGZriuWMNyRnL+bI1PAvXrobyCNSki+?=
 =?us-ascii?Q?1LjbehvGVg+kEIqVbioEvYzlWuxWX/6P71TyGwXJE8RZco62KTSZJaMwYewg?=
 =?us-ascii?Q?qsP8m0p+U44GgyJCRPE95gGozaK5CzojOsTFDq0rhv0WXlEjLjrBQnnmrBtZ?=
 =?us-ascii?Q?hJM+iNdRpDejQKi4nk/gKyWUStGRjaBW1Y9BteTpOCku5Yu4UO8Uzk6btIMU?=
 =?us-ascii?Q?uVLkbZgvupZDVOvKv9ZvKodPfNCyENUDDCcccO/DG3Bybl5i2EUJTVMrrnGC?=
 =?us-ascii?Q?nRtkM0VipiddRBqz/aMRKLytsT0c65mz2iO08YU0ECMukspyyy65yI1USARF?=
 =?us-ascii?Q?vFbsH6RzGlcPjpk+M4VOIeOxVG4ls1eX+8JAqjIl/UN59sqdvK68VaAFbwWA?=
 =?us-ascii?Q?ym8Kvf1cx1ge5+GV3EARvWpXQqB2TZBD8Q5ugyJq0HCRyf/YOqpOud3mQuRp?=
 =?us-ascii?Q?xUEoEYr3E9Ktg2XsXSuq+ZFgTZRcvWfds6yMtI5WTgbkdQrtupMQ5AKQe2U/?=
 =?us-ascii?Q?HS0UcbbwkcQkPpuS+5YWj+fPceKOpecCClFEG75zUt1vmwFWcqviERXnIRHa?=
 =?us-ascii?Q?GsCjnBLiIIomfuZ4nRrOWHMlxoyaEcFms+R4XLG3WS4GNwQ5+fLkztWZQ5eZ?=
 =?us-ascii?Q?KTxI9Y0ZKeGz1Yg8VJDOOFWAjTtqMsR+oJLpQ/kAaeBdp5S8AEPB1J/JPkC/?=
 =?us-ascii?Q?QK+2Q8mZwgP+EbF124dI7A7TvqZtfLExeMFTbu0WxfeB4xZWcUTYzLQWkotD?=
 =?us-ascii?Q?Vti9NMAVyrL2uhVw1PAt0WIuQ4LlKI3EsSRC4Gn10YPnybMjgx/q95hCCJaZ?=
 =?us-ascii?Q?9CwfBohI88020ElrBV3HyGNZ0qBMXJxk62gsBAB/1kAjGpmSG8lKMbLwUw5F?=
 =?us-ascii?Q?DiibZeXL7sP75m75f5ApjeQnAneFyumRNBIcu500VnKa6zl6Ka0obj26JsBO?=
 =?us-ascii?Q?cXTqCiFKRdLOScRvLd6rNlXf/kkZrIaBEnFqSnfq8zwp6/LiAxLGlCTzKACV?=
 =?us-ascii?Q?kqzVI1VcLzsW1z5M8ntbmPHO9YvZoPukjSBMWSDj11DJKctsHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 03:02:46.5528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5865a0e0-c289-410d-a2ca-08dc89c2f899
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527

On Mon, Jun 10, 2024 at 09:31:17PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level CD table is (at most) 1024 entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
> CPU pointer (16k).
> 
> There are two copies of the l2ptr_dma, one is stored in the struct
> arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
> use. Instead of storing two copies just decode the value from the __le64.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

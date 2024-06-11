Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F257516F91A;
	Tue, 11 Jun 2024 03:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718076467; cv=fail; b=T6eXT27ENszmNYj0W+U+z/PKe+GjOKSqwbtHEqYdDOTH2iKSzfDU77m1qXnc2rph452c4AOpmoKmWhAl6lYQ+mgL/LfbgklTRX9gp33ollvgEqKJt5OGWN3LX1Ueh4h+R0uJuLTuU3MtO40zIu8/MfKcUJmhascgTbSD/QEf1Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718076467; c=relaxed/simple;
	bh=iFnNd0Gjgo1lDgJXyuj0YLYi/aKl0OpaqcNqhffYFAY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jx4LqKmq9cXzxDGxrvC/O2s2YXEujrg1w8itP1Z4oQmVRuNUr/b/6hwdj1MDQO61uiPE9LEhuYU4rK7x3mird2lKumtBreAceCZ/rPL1YfEomZXW8ovrUZl+ptfWODw1c8B0bhPxliOIstbMqSAl3+KM8Xzac9OvfXCCoXd5kJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I8BOYAoe; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I8BOYAoe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfAw1yiNecCarCV8pKGrvFVPW1pTQYZzQZXllPvrV6GgcWwaT00P2HUFlIUJl6+1uYfTSEbdKnvuPuiwLinr33xQ4zBTGNRNmu2br0lKV4rGtTBP/voCRwBaE1tEIIOdbboxah++WOGiY7TE3QWtj5R+fHjc8BrcI0mfxwGAK3Nazdv9FVHWP/wv/Oqzwx4q7/crwNbrNSmJD0q7CyWOpBmGFCVjKNk5VMBQD2z2X3k63UdNtJ+cEskTq91K2sKIu110eDEzeowSI43ocyxHwW5lRnF6FcFlnnW+lCGBQlMLoLtXy5pNU3ecZ5ieK38BNk9/nogSvd1t857idB5z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAo0ZJg6muU3ZBMZ856TmgshdCu+j+dkk4BOlrxUYk8=;
 b=ji1Jl1dKXd8mSGx2YmgCL0hAWO3nue1GIud4E6DdXvdyVjBeM1GpMKlqEHTO4wmu8xz/e73Do3zLpkQRTd+DPDzEtkuoBPq3gvIxrtOlw95pIBRuY2MPUfLyG3wOAGBdOCjijwSX1KXTjhx6zy9R6iiolN6iElLk1XTUhvedZ1huwjWN3bTNm9aPZR9lnwTARkRJuoPSNJdKV8GCFHIQOdjjlMDPbwsvXo17v1jftXKelefqt3ZtPVQTQrj/qQnT2DQ422A/rsPTZcJXolo6YoHTHj+lIkSM0XrcfGp3orlYUrzVPuaO2hL9KDLPEunsuV3u/xMdnn0TJdd0elbWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAo0ZJg6muU3ZBMZ856TmgshdCu+j+dkk4BOlrxUYk8=;
 b=I8BOYAoeBjuIxvIwH2WpdJY/XOeZbZn9hZubgVA64V1d/O4ciO0D3EaimVWiUbYVOSjgjT99l+wm6WbAtvEMQ4BGYa/cK7uMTwzFUv4dZsXMtg+QVMqisNgSRp/OwhbLGSRPrFjpp7TMyBYuelLYB26KE9C7N9SJEi5yKyf71QpPH7VCce5hy4GBPKeTqXtYjZeR+GGkzPWlzD6MVs+4TEcs1QneW/Ic6EwIjeJWGjzmNko9k6smx4RJMJ9NsTRYzC2xp4iVO38OpQLkwGRAAc9SflEfPrByChIzlhddKryL2DGw5HoaiFUwJgrSFkpTJI1BvOL4eo1VMbZZDC3gTw==
Received: from SJ0P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::34)
 by SN7PR12MB7979.namprd12.prod.outlook.com (2603:10b6:806:32a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 11 Jun
 2024 03:27:43 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:a03:41b:cafe::e1) by SJ0P220CA0003.outlook.office365.com
 (2603:10b6:a03:41b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 03:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 03:27:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:27:31 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:27:31 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 20:27:30 -0700
Date: Mon, 10 Jun 2024 20:27:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 00/10] Tidy some minor things in the stream table/cd
 table area
Message-ID: <ZmfEIXUBohGqiAKf@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|SN7PR12MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: db7395b7-cc81-4b8a-5486-08dc89c67427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lmFJLe6Z59WDtllxeNXNTXkbKMOlETYsl3bYsCAwxetTpwWvuQHtjHeymWKR?=
 =?us-ascii?Q?Ww6goP+Q9oANBHn/XVqQwCsK304XIjjA2eqG8SCg24BUOr8Cdw1qWlb+zYNl?=
 =?us-ascii?Q?iCseRiAOWYTaE2Blqv/DTVB7//tJLReFXHbV9W/tqQ+mCkbNWrQGtOOrtQk/?=
 =?us-ascii?Q?EQXZzwGk2V1jZczl2wBwEyBTxj566w9a6asc3naP8ze9YnWn80Bvk9p2S9QC?=
 =?us-ascii?Q?/PYJUx0hqCHNd0cgSVOo/XpvAUAqm0zruYPvl+JoD1eBLyBI5FwKC54Xehg2?=
 =?us-ascii?Q?EsYiyhkqe1yhK+cLqSm08/tPGDaRNkfNIfOMGLoQ8/NLxTQOlK8bvp27U//j?=
 =?us-ascii?Q?48s9KDMcmUHanZaFQR96ROreryktHYGWqETi1lkxIiOCmSS7N64sbX7L+eFI?=
 =?us-ascii?Q?v/Od8wJpIwm0yc30WEFJF4NI6NDPCOvVknv9S/H8W1y2bbBadLl9TD05WnK1?=
 =?us-ascii?Q?HUAPEic/vs8qs3fyKa6Etl3Ma6jJaYweXyY9fk1Pi3Jm8hOPZrbZz3mnJhHV?=
 =?us-ascii?Q?gxoqIo4E7E5yt1QZg42aLnZcyupJbRR1EeZiHcMcAefrMfPsITqWYTr2uMN1?=
 =?us-ascii?Q?8TRX4LYYvi4mUoAH9VW9rTmjFZ/NKyRZlWcxNlTg1dynXBTUSit1zjKEspu2?=
 =?us-ascii?Q?AQFg2lbwAdRZaVMYX9YSyzySCQOE5Osr8SCPFVRyX60+rf1fxNPPNGqkyGbQ?=
 =?us-ascii?Q?FXiKGaP2TjMk/j+FDMb4mF2l2rgKr8mrltXjuEwEUtcA7t85S7PlBaIIe9lD?=
 =?us-ascii?Q?qlYRA2vVEC1zNQqRze+JN8fmxQ6cT4DYOrr3kKyvfOUPyB3nuBKGT+CZrylp?=
 =?us-ascii?Q?TsWitoUXN12Rw6waFMX6xCyp2T3E2tF0fPnBiu59OCyttrJVHBefJ2Jqki62?=
 =?us-ascii?Q?VWaIz/LCCP3Uj9KJFE7JLIp5hZEba+Snu46z7onAivWpaTqpVmdKNVSD3Inc?=
 =?us-ascii?Q?nZpwUfxTdM0T8xXgku+Rk6RURyPxVR7I6lHp2/LuOhGh2W23g9JEQ7gmJDWr?=
 =?us-ascii?Q?c4AWp68SxQHasiR1JUGxtexiaxr3jzW1H9SKH7OPSo3ZrgpIs393ShBCwvd+?=
 =?us-ascii?Q?vJVHFgzgMtCvbHv9fW3dBnH67pbJA9MSGqRwWGm2pmaKVP73QTqd4DVPfur5?=
 =?us-ascii?Q?M46IGTXoDQaCOqDfmQh4UUA/SupJUz8j1P/kv/dj2BLXM0pA6CKLMcluHgi0?=
 =?us-ascii?Q?/NHD/oerJc9Y0PtOeAiKP0hgaJ8+QKx/fPDwXkI3mZ/4H/3wUalmM8bY0+vo?=
 =?us-ascii?Q?Ejl1HWJmrH10wL7UOe+py1qFKRwZwz0n1RFaH2jr0mLmoO63XiMXQ9uFJXt4?=
 =?us-ascii?Q?0JOGYktmR6JPylY65aTihZUgrCf5Qrc8oHB3DTcmKQGpz5O2Dp5sUsV9+07e?=
 =?us-ascii?Q?eNMeYaHzyqcNdKbIi4hK9TgplNLCGZCxTlDREvlGDc0QlXxziQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 03:27:42.3782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db7395b7-cc81-4b8a-5486-08dc89c67427
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7979

On Mon, Jun 10, 2024 at 09:31:09PM -0300, Jason Gunthorpe wrote:
> Will pointed out that two places referring to the CD/STE struct did not
> get the new types. While auditing this code a few more oddities were
> noticed. Based on a feedback from Mostafa and Nicolin a few more things
> were fixed up too
> 
> - Use types for all the HW structures everywhere even for the L1
>   descriptors that are just a single 8 bytes. This helps with clarity of
>   what everthing is pointing at
> - Use indexing helpers for the STE/CD two level calculations
> - Use sizeof(struct X) instead of open coded math on constants. The sizeof
>   naturally follows the type of the related variable in almost all cases
> - Remove redundant dma_addr_t's and save some memory
> - Remove redundant devm usage
> - Use the modern rbtree API
> 
> Parts of this have been sitting in my tree for a while now, it grew a bit
> since v1, but nothing is particularly profound here. Enough is merged now
> that they can be cleanly based and are seperate from my other series.
> 
> v2:
>  - Add a patch to add structs for the L1/L2 HW layouts and use their
>    sizeof and type instead of constants and generic __le64 *.
>  - Add a patch for L1/L2 indexing helpers for clarity
>  - Reorder patches
>  - Redo the union layout in the cfg for both cases
>  - Fully remove some more defines

For the entire series,

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

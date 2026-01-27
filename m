Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E421ADB7;
	Tue, 27 Jan 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769536286; cv=fail; b=cz/uLpwJkHhO/dnXFY9WHZgrPlkTTjSFvRkUgppjWX7MP7raJnit1dMkRSQg/MOYN2X4xE1sCnkR+Hw6WhqA7cv9+vtwU0RccctyKWKmU3CHOd5GzBLNm97j0QDkThD1vnexyK8qimkg7BSuZOCJiwZuFJf5E9y2y52Hzivv3Gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769536286; c=relaxed/simple;
	bh=CTxVT+cD3h8oQ2S9vRpGT2r5MEpqrJZK0UB+5yejnio=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6gFEMpVwOqHCZPHP6nTjUlMsarnigNuQXA6jrmA3+BlzBEEtOYPYOLj99eF/sQckWnFMKiR686W/z93VqY9TNBbdCggLVdKoiYTcCjJRLioT0BcqPD8aVAReGkVq7Yzvq4fSbVcgD4XNh1d1u2muLvXtgbNOYs/2SYm3UA6Ie8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uB3+vvLf; arc=fail smtp.client-ip=52.101.85.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uB3+vvLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXmJAtAr2XGR5POYWSTMvWKy0jKOJ0xZvlcBV7LYnq2fIBZNS2kbx+oHGKEgOCgf8lmFAsEces8Vi5C7RSGdPvh565/ebIR1UgPHgVcYbu7kRX9ilDR552QTa8O3O2Z/Dox0JbClFX/vAcsrrD8VzY2V3tpR3Q85WU+LmWKJHPqsnYmljqTJbsBtNO74LdAf7+tqnXBaEOZXPjZniufAz8FGaeGmWCC9VCNw211gVU5XZbFXtHybpQIP6m+7Hy8kc6N4N0lC19KuVu+Lfqvzl6JCduT8KNQb2FrnIOJxRMXxESIPaLjJ8x+8nXmK9WzAty3HmneDftM4llTpbvUfeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loP3z5G593SBJMbOigdLWtpGpmlyccRB1f+6XAa+5aA=;
 b=PumyF0iLgFUC3RK7kCXBfDbXwo3ilJ0lG0rLOqOTQ0o2ElRIJho9QjVIIucwy8IYzdUu0CX7XQH8w7RawnMCKjeh2BSJGzSHWFwXgpHn7cBGV+TtXx/OAl6Kc8JD8O68KSXxThOIKDj3rwNKuv01eTkUCs5Xc276SMA7UdWsxHk6SCCIBaLe0UZ44/mBRbsweTNFIOJe92NvuzIYOpWPuL2o9Ycd4NTd6rCS2i1cDglsKRRSpwL11v+XISeR6OQIcFrBOq587x6G5x1jT32mwjDWG6jyjCakLVXJcUQPYEdrkVFG1Db5GzRxNkR2V0amU81zzxrYrR27l5Hs2T60SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loP3z5G593SBJMbOigdLWtpGpmlyccRB1f+6XAa+5aA=;
 b=uB3+vvLfRmZ0i1MGd+vdzcCvx8BxfO0WSmhVX3/EwaPygFIsLARbiuV+TUTyP5gt+k91EmSECYb8BCgHpnXKZQzNsnnKfzwdDdb+mFFeA5XKJL4UBc5r4u7vzIhZP4IDCoZiaOJld9RVDl3F1D7TlOxeugiYOyXj25vDAd7uTnvIzNLI5O4i9ouLnWgF1qBF8L556k13cMbgbYaCn/vErt+1y5wW/xHtnb1n109jzkp9a4EYXgWvtg0eyoq35k++JpU3ppsLayOJW51lvGfugq06Zw4tcQvp2iXgEdMFPsEd+50WvfKrfMR+EhNffajKwO7GfUaJrZOy0X0AuR5ihQ==
Received: from BN9PR03CA0952.namprd03.prod.outlook.com (2603:10b6:408:108::27)
 by PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 17:51:20 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:108:cafe::79) by BN9PR03CA0952.outlook.office365.com
 (2603:10b6:408:108::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 17:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 17:51:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 09:50:58 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 09:50:57 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 27 Jan 2026 09:50:56 -0800
Date: Tue, 27 Jan 2026 09:50:55 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 10/10] iommu/arm-smmu-v3: Allow sharing domain across
 SMMUs
Message-ID: <aXj6/yhMoveAHv2w@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <2882c7b6dcec7cf8bdc08bd4fd9f4c4373db5469.1769044718.git.nicolinc@nvidia.com>
 <20260127154111.GK1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260127154111.GK1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: 42fc9683-021f-4b07-c4bc-08de5dccadbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VRB85TKfJQ+MVhojbq1f/45pI+mupzQyXH747AnPdFy3o3RfZUDJAj9bm0W1?=
 =?us-ascii?Q?v0x2hCbl2JRQXVm2boMvzx4N0T/rMEFrmgyW+io8WObXGfbpbwncV7NO3sNw?=
 =?us-ascii?Q?zLjtFEwbroUCDGpTsqopLcQVoTK9eNmNNJsGnq8WF8gklrR2TlxrO58vPAzP?=
 =?us-ascii?Q?c7l0cdmU550OwGFb2qvc/SRHCdpiz1H5XzNbzPTMLJdoQ8pBHc1C9Frb1KkZ?=
 =?us-ascii?Q?CJKF9QXP7DsAbX9POU+7/Pu6sfKwQwBxQOLH15ubImVlqbChfDn8VC82aUs7?=
 =?us-ascii?Q?mTCRR2DasSjo5hZ7frXbV5GaGn/gHOq277Ye4TKd40HMQ0VnDZF/r2Y28Ivv?=
 =?us-ascii?Q?hQgLkbiG31QqCULd6N1mijZ2clqUS9qlR8SBUkU8vXceTIbr/63qptHbKaG8?=
 =?us-ascii?Q?iWNpHuxIAKgBlTXg3PCnbmdTKYATD3g5sps3vApgNKa7mPuyydTfWGYbGmy8?=
 =?us-ascii?Q?Fkop71drX52vv/0fJ83p96CmFSGKPm42r3Var7D61dBPPdDhGuZjHiYhpUsm?=
 =?us-ascii?Q?3PTpxXWGAd+stYAuv0X6cVGbIBqK/jgW11uv3oPzk/C+gLfEX/mHqmv0u8hX?=
 =?us-ascii?Q?q8YT88Oh0cvq/EhyUeMOji+dRGn3naBS01TwGo0ZCfNL5lGRhBwy5F8k/aFZ?=
 =?us-ascii?Q?NKYA65H+4YFiVqX/CBENPsTd06O/JMHRYHg5RX/R5Uyv5NGnTO/Kpqb72yzs?=
 =?us-ascii?Q?POZJKm1G5F7ZWwL3wYIoPBlQ/PVpNUuRkca0pBpqC+z6gZrZvQrKxKSJlmNO?=
 =?us-ascii?Q?sCeNNpwnE+EfBWXkMvywFDROAL3UpLYxrjKT/27xN6qyGU/OEkHjUrF/Tq/s?=
 =?us-ascii?Q?aN+z1TJTLThzw/VrC8RDD8roNqlWzFy/X0cB78qDkK4ljbFUi/rtJzVB+UcU?=
 =?us-ascii?Q?36HxLqG/8EXAjA++5vp2kHYXLVuCzaPCVx09lEDOiavIUnxh+WfEt+d4L/aJ?=
 =?us-ascii?Q?AhOzxAEhsFB4oJEMqtkBz56OjiPXE5SAMAvLqQNVK1h0/jegcyy5Pj3lAFTI?=
 =?us-ascii?Q?SeKyV11GaCqn3DrbjzHLCXS0QGdceK9ALN3Fzj0tMI3Ka2pjWZrAu8Y2ICNu?=
 =?us-ascii?Q?it/8mcXlHq5aHc6ZMlgtq6cDAZlRDFyWFIQGR715HhVFp8i104CmlISHWh/n?=
 =?us-ascii?Q?NdVITBxU20kEeZ+GJhx8oQfqzhAnCwQa9C3fbatWYg0A8m9vFmLOGBkjbr+V?=
 =?us-ascii?Q?7j8dWiV+JmkMQQq3qEy6d48txeuaH5TSp6iD8jtvsK2dFvNzUYmkLiAAFKZY?=
 =?us-ascii?Q?49dpAeDT+l+UgC8V6vKC2v78asIbwTRRhadUDKHVAjaOf8FbrtkvbF1fjsZB?=
 =?us-ascii?Q?P9R6gd+k0g3qUyjGkx0ztCHhKiv2tRfeF+zcuXGKRG1T508XPQCkhc4tVha4?=
 =?us-ascii?Q?SciINO3gveoT9n4dlw1KfEflnkX6DdXqKNEvwRGSXCeONx4LvNWVWEQmRPeH?=
 =?us-ascii?Q?9Zs0inPk3i8OAkYeKyz1M4etBs/8Y+HOERdPHW9heVR51EFfBQd1dKkY908x?=
 =?us-ascii?Q?k8WBEKaE1H1xSpDs3J2VJVtTskxqs8CkZx+oEBaz6t5CB2YGV/h6oSG0rzjY?=
 =?us-ascii?Q?v+m1zxjDLLzPo4I8s+XItZIsh8mbclUvNB9j/977yyiQTGGS12ZjQ1jtlSum?=
 =?us-ascii?Q?4SVhQpeaD0Nr4NEAjijEj0QN7sv5G+/Y1zwveupz6o10XiBvMXiXyG8BMUZr?=
 =?us-ascii?Q?Ww0L0Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 17:51:20.1021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42fc9683-021f-4b07-c4bc-08de5dccadbe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448

On Tue, Jan 27, 2026 at 11:41:11AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:28PM -0800, Nicolin Chen wrote:
> > VMM needs a domain holding the mappings between gPA to hPA. It can be an S1
> > domain or an S2 nesting parent domain, depending on whether the VM is built
> > with a vSMMU or not.
> > 
> > Given that the IOAS for this gPA mapping is the same across SMMU instances,
> > this domain can be shared across devices even if they sit behind different
> > SMMUs, so long as the underlying page table is compatible between the SMMU
> > instances.
> > 
> > There is no direct information about the page table from the master device,
> > but a comparison can be done between the physical SMMU that the domain was
> > allocated for and the physical SMMU that the device is behind.
> 
> I would very much prefer this works by inspecting the cfg from the
> iopgtable..
> 
> You can get it by doing 
> 
> 	struct io_pgtable_cfg *pgtbl_cfg =
> 		&io_pgtable_ops_to_pgtable(domain->pgtbl_ops)->cfg;

OK. I will make it a detailed scan

> I think it is important that the domain->smmu pointer be removed as
> well

I will try that too.

There are smmu_domain->smmu validations in two SVA functions,
which presumably might be replaced with this can_share() too.

Thanks
Nicolin

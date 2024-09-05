Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E519307F;
	Thu,  5 Sep 2024 20:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725567045; cv=fail; b=aWrMHWGsZxCy9Vqkg9wYMAEERty3Mx8zhntt4Op1G/IjZBSd89h79/jvti+FuCAxCleHsPouu1KU7WHMhtBBblIGzFWgaJKbD9UQqoeSIBWGEMwFHLYGZoXHstVS/VNCttxgusQ844fbPaeGlZoTx03Gb9nCCWRVcF16LduQFnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725567045; c=relaxed/simple;
	bh=fJxg2J2oc+8XUAaEyFOV+exA5A2Pqq7aEltntVhEMdA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sx1kUS+OisIGXd493/EN3G4/7aWLwDy9eIyh1TeHZv1yiz8lH5kANDLZPXAFAfck8WyUsoqiat762+gryNqTLUxSHiXCtQr8V4NguqwflQ2DRgT/mR3OgMaWysyCXZBMZR+Xju/Td1hCT8Z+5uuyAWJCHQwOnSvlRt+y2+N1gqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mIfu1tJE; arc=fail smtp.client-ip=40.107.95.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mIfu1tJE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cy3dwN+tSx2RuhJiF5J9jjPXlVIefZ5xFAKSz1spGhz7tVmD7E4xGAbfYdmwtTi2kAe0NR8eY384nYI4/pq9/B9ZUTyhY553cpHWZ30HEwOgXkrqXg37p3uftLRc1Dh2Z/DccYsh1kqm6pTuzA/4gNRdWc3kxGg1vzjZvJq9YnMnZxwmwq6+zUsiGRbTSb52vWy+QUBWj1c812SgMW23djWudZsQ6niDkxJxPzVNhCM0GmnjRcKRhQ28gHb6mWABB48uO4X7gGwAOljnloc+3YGVpozGPv4R+6C9sgk8iB2RVjG7lU4qYrE6HKRuY+yXfcZMJRvqd42LPkUW6VyOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZlVu/EvifEpIlmCkWtN+q4tap89eVhTBWwczwb+4lk=;
 b=nN5xIYh5OkQR+PdE+2PzQkhuDFK/Ios/Qhy9pWaniuSoHxviF5vBMfLZ7ynEPUIZ9/Sbg1VvFIksY1UUMKkwa4HKuFEpRx7/+XPljmpB2Uuu5uhxX7bJw/G6wr1yca+rcO5yamtp3VRFSko9ArrzjeYUljRQ24aZ6qv695gvFkTin9QEzY15fgyrysb3vti1q9UQiVWBuvLuPQigF1wYzZu1/fH3ZZBfbc8KDUxh83CN0mIQFqkCfigAsC3hK0hqEDPaA+AkoH2Kk62KWJJ7x6CUwi36ZL6xs2NFD7rEpPYx0rwBiJvLDAdNAuStu716WrZKxISSNPNdgJhuCk6eUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZlVu/EvifEpIlmCkWtN+q4tap89eVhTBWwczwb+4lk=;
 b=mIfu1tJEkw2Ryk58ZkeYN13es7fnx85HJNL8MrvRU4ty1BJ4xq7CFnd3/ZEDxZRGPera2ME57/nXSdpr53Xj9eipgi6Bd6OZPIGihpYQfnTfBxtY8jjCMAEjVpG8ARdctiN8gVTdXYZCqq8GXPBQmbHox7W0z74MfsOCJJt6qp8zsWD4z41Zcm9Ryc2fhF5kBa+bTQ6ym2zUscOFMjLjuKVTzGrVNnXCZFTCZulvDuaX5BsJLS6uOslE2wdamKUVFeDgnDsxvZFTeU6hDITv/Uvhz9VivY1BWJ8rOzVxH3jXo5YVfD5MlRY2PeLCPrr4NSaH1V3rhMuXKzsBmAoD9Q==
Received: from SN7PR04CA0194.namprd04.prod.outlook.com (2603:10b6:806:126::19)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 20:10:40 +0000
Received: from SA2PEPF00003AEB.namprd02.prod.outlook.com
 (2603:10b6:806:126:cafe::9a) by SN7PR04CA0194.outlook.office365.com
 (2603:10b6:806:126::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14 via Frontend
 Transport; Thu, 5 Sep 2024 20:10:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF00003AEB.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 5 Sep 2024 20:10:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Sep 2024
 13:10:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 5 Sep 2024 13:10:31 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 5 Sep 2024 13:10:19 -0700
Date: Thu, 5 Sep 2024 13:10:12 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v3 0/9] Tidy some minor things in the stream table/cd
 table area
Message-ID: <ZtoQJAV3+j6oCmyf@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEB:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: bde80922-03c5-49ec-4c4c-08dccde6d075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/w3oVEITJ6vSY3z2ClbVMiHnuv8pXq2a7VeCFseoxDGVe2GWo8XWIH1XQdsZ?=
 =?us-ascii?Q?ZzndPC9QhtgguHvJl7Or4J1mLSJo+qOPyB6Pu3KPvpsZUBKi+tzhmtop+Cv4?=
 =?us-ascii?Q?/z6On16CQgRy2H0KT/qoM2I/OuIUZzBjSVjaXKojHAbQ7HNcZOIyhdKqz+Ju?=
 =?us-ascii?Q?oWiRL646b3P56xbdxFLJ5ouvjuqGv2aamQRl2iVUGN0Amv7Rv8g6KI7NumFo?=
 =?us-ascii?Q?fbYaXVjokJZMeJ9SIUIAP+IxQqMU4+uQxgl739wBEDEMLBbNoGIkK4/PLan5?=
 =?us-ascii?Q?BO55vXkMyAljzxMS3dHB9+5MQ00cIF3ZektXxY6fw5l7hw38l2tlArtOub+u?=
 =?us-ascii?Q?nn/ruPNhtJo3Hvwols7TctRFfDLU7C7RVK5jME5Np8fRvBW0VysRXDEmrBbV?=
 =?us-ascii?Q?KBaq5y0ejolytG0o7vIZnZf77jTVzWH+MNKFkL5gkHz6prx/Y8WlVSFpV27U?=
 =?us-ascii?Q?+Wam/7d1AmjHmzIb/TrhLLqgwylO0nEkDrd4yHGEFZcYYzWyDPaZxuuDQoW6?=
 =?us-ascii?Q?7Fghn0cp5mYA+N10D9R3RNJ3u10J3rtpfBY4MWNNWeUyg+EH724jt6vaH2k5?=
 =?us-ascii?Q?mxwnjzfmY21fjBk1Nsm/I8GU59tdP+zS7Wabp0EcflBLwjI54DGeQHf/6PAT?=
 =?us-ascii?Q?yAeCkHSlq3l6z/fZF9nwgqrmYbPDkhTtqVDvV6EgLnzFyToZ6BCReRvpKa3C?=
 =?us-ascii?Q?TxipjTn+ecSPTBzafpJ2vjTRJSTjnoC5DbRSNmHj5jdwPdHfybD1h+JJt2Hd?=
 =?us-ascii?Q?1Xee0sOJacAmVFNgSwkOG+FH6r/Z/1IFtpieXhEKWiKVTuSpwRoApLaOHNVZ?=
 =?us-ascii?Q?WCdf7BavdG9T1X7vczoU0a7TZmZOdDCv5f94vSoVbibuNXJG1gcnu6pkqIxw?=
 =?us-ascii?Q?9stJmh5GkHHbMNhVqB9em78GhXC5UxYGSdUKn0+U5vKa5BkT2SJfgI0zWI98?=
 =?us-ascii?Q?LYnlkBc0CHm39Ag7Hg6TqvV8sYYhjpNFGW09SbAvPMy3pwbtxT3vaCo2do1B?=
 =?us-ascii?Q?tLJj93ppCDLSiGKAFmiqaSGvlsM06tBaclz0EphPkib2pfQuwYSiSZZ5pD5v?=
 =?us-ascii?Q?sqZ+Utt2wRA58fWb1srKjNHurDuFIyaNJMwyC7yKdw3sWhEZdYIgjr5rm8rU?=
 =?us-ascii?Q?cqkadsuYAKQFn6qOGVhJHydPcUWlQtEOi21yxNlX+3rMLFPWQ2yt+LsfuKYD?=
 =?us-ascii?Q?3FdlyYLyxplmY9vEq0xusKqEeSp9MsAVKibdg3H5ALI/ysLOHuIIX9b1N4nm?=
 =?us-ascii?Q?2UU8SFzi1WVpYqsINdCHzwHad+FMojmC37dtwQs/R868K22ci+C2OF0OJ+eV?=
 =?us-ascii?Q?eejbnYTkJ13IGQctcwqTh+TiMI9HPJyK5MxkwXbTPXw1D++EAIS+6z7DQCch?=
 =?us-ascii?Q?E7H+UXClWPGadTcMoaf0lU+4IK8JXI0s2zAUJkzYGkpwDfjM0EDMs66nSuvV?=
 =?us-ascii?Q?XirwvQkEUxIJRWGxYnpPS0I/TBhA6NnO?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 20:10:40.2194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bde80922-03c5-49ec-4c4c-08dccde6d075
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209

On Tue, Aug 06, 2024 at 08:31:14PM -0300, Jason Gunthorpe wrote:
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
> v3:
>  - Rebase to v6.11-rc2
>  - Preserve the "2-level strtab only covers %u/%u bits of SID" without
>    change
>  - Vertically align some of the constants
>  - Use u32 for the type of the index and sid
>  - Fix missing * in le64_to_cpu() in interior patch
>  - Bring back accidently lost "Use the new rb tree helpers" patch

I didn't exclusively test this series but it has been included in
my nesting branch for a while. Considering 2-stage configurations
and vSVA cases are involved during my testings, all my Tested-bys
still stand.

Thanks
Nicolin

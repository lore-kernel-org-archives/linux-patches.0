Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451678488;
	Tue, 11 Jun 2024 02:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718072024; cv=fail; b=hRkmhw+y6GYTUTTMrQaLVy0vFzlQqDT0VvvXA5ULhSjrtEbUoEvX0Kxu9K0yPD27aSe7lr8mBcCaUOOUAuj05gCidozYTwdkt3013hzr/aQ9nh5D3dm6TSj/2/AeiyMjWiklek8ZWdwQN0BEe/LePCtgl80bmYw+L7wr4lVht68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718072024; c=relaxed/simple;
	bh=Etn2NlpvW6TjWYlTtiigONRYRbyTKmMStCuhg3aLty0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ+mLgqO7W4lhNRofKQiIp6LBBzgayM8WfTqZLV6L0AQZd1l8FyD6mVZcDNVGV3RqEuBq7DeYZWnkbMMRPKssQhIHpL9+IRJ+YCodw8p5ys2Q8OhljVs+jNHX3fzfHkZj8MvNbtlWn8yH3Mr6teU2tuQcucfRKiI2m4HD886Xic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hcXcqSxx; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hcXcqSxx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvuElhWoLyl24IVRRKgM86/LiZZoSfzVeYahq1lmjsV+3g1l9SLbun85wWfpODQUNYBpFZRY+JI4GCIeUjl4lCU1oit1Q4JJBqk8BmWrMWXlkjNgeT2P9IMJKt1ZgoEsW83R81tpEZ6wUdjHBeBcCNqnuXMRGP632cTKn2uLSxQLTVKRmR5xK7O3KLhbG2zadX3sIohs5T5NJVVuGcgETcST7F3Zhpvao9S4O4zCin4Cc5iRv8RB8W9sz2JTK8os21QOxX1aqMqbs1QG5/jIUQssQ6oTBf/TLKYysDoICMSmxTgiPQ3hQf0TNH6hpZVPG6zZQUpSC3jZMrwi6GBHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGNyEn3Wppv+curZjXljsTJGE/oVoVZSS/kLszeQ+hA=;
 b=BHR8G184dMzRflOsqmYIl8dHI2mu0EAKmGafxBi6ebrTJglb1EexCbJMbLVv3xOhqBGRYI83fh8twDrVv7luAVh9C2NfVmwWQdhTNQyQe7cUE6TaqT0+uaqZZrTgjMAE86zswPmi5MYM7tg0y/QOZBKZ9Lvw2YwQV1LyYsBWL6SUlaYgDupn/3dWge8UciCqnpXj1ycO/5UuuaPC19dCjnTu0QZ5/uu74tRUItiIX0rlGohZimunct7960lmrJvuI1nr2CqUy7MTRYuZjkDmNzcbGUdN17G1ZhxJ67WrxhPgpg9ZaJeRxSlg4PH5P+aHT5vHTpX5lbtPJeAQ0FmlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGNyEn3Wppv+curZjXljsTJGE/oVoVZSS/kLszeQ+hA=;
 b=hcXcqSxxIBsdp1Rn58PjW5upnwOvaV3GW9rziR/58qDQhwa7kyVPkQ3Jo+dY9KONoCanu3I5Db4P1wSRq8DwbUATZDE6c2UNqxU0XKy6Ye6j2NLY1QxpW2AiEkNonNp+bJYfm+3Sb0itcarSWI/0JTGnNqPBmKVQOi+IW5n74gHLDs0mTAnVq7L26ergpiAd40WHUCo2UNP1w83HF6UGez4cxliAmrHZe1t4c6sFWMuEoitf2B7lF9xfPPSvHk92mtQ624MYmmf2eGvgNbudv4d9WECJTql8CnTP1k3SPn9ubafqA1pbTpdfYHSfC8hdMToFxSNGHGcNsl2ICGfkmg==
Received: from DS7PR03CA0299.namprd03.prod.outlook.com (2603:10b6:5:3ad::34)
 by DS7PR12MB8419.namprd12.prod.outlook.com (2603:10b6:8:e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:13:40 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::28) by DS7PR03CA0299.outlook.office365.com
 (2603:10b6:5:3ad::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 02:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 02:13:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:13:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:13:31 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 19:13:30 -0700
Date: Mon, 10 Jun 2024 19:13:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 04/10] iommu/arm-smmu-v3: Add types for each level of
 the 2 level stream table
Message-ID: <ZmeyyXanWprverAe@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <4-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|DS7PR12MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf7b8e3-973a-49e8-7e4d-08dc89bc1c7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jaTYyaolBkm9hrPaKfnHbyMqjdaM5DCLiq+wUImyZpe+Tc9oEYSVLuneLun9?=
 =?us-ascii?Q?Gf++lA/41ypKvKsKMiAvkdmCRpnrEXffpdEjAwBp9El7T52bIjqhRIlDbQ12?=
 =?us-ascii?Q?INa+QQpIuI3fUzM1juB3K8lFAFZCSoqcjStqSz+WFc0weU8gkhXPwVMXZlc0?=
 =?us-ascii?Q?Nr7g+7PeX10otQMgsXP5blQN8IjbRmGeUiUcUHMR/cyKHak5yz08QpCzUHfF?=
 =?us-ascii?Q?TCishiaL3vjBGp6z5Klq2Zb0qOQD25YH9J48VVwqM5qyRJqgzthl/jcmO2o0?=
 =?us-ascii?Q?rqXFFo//nqFRnLYyIwH9xqAzUbiapfsZ/MlQ9J+uueBXV/u6CcmAeEl14NlP?=
 =?us-ascii?Q?516uaHzHaNHznqmXoTwnz/MAtsmxdlZdmRnX7pwRaH4I2brFSnHx7wW0MiSK?=
 =?us-ascii?Q?KmXalVhVGuKvoUF7zLFXKtmBBrHIzq1sIMdx+oREZj9jaG1KKTtp2B5PidS0?=
 =?us-ascii?Q?CX88UrTbfJb8uWJsaui+aw23MPi+ghSZoLNhZARpsb3JyTbsE2FjgkNmSlyB?=
 =?us-ascii?Q?ykgnSv++lhFA26UHPeFc3O9GGWFPbEvBmzj72EiubxfSMuiOSXS1/4jgbhII?=
 =?us-ascii?Q?n850W8rPZ+8a3Tpa6bOO6B0P8L8fe5VHC85mM11dUrCu299+qxv2Fr4lFFK2?=
 =?us-ascii?Q?yZ6bFDyFor2husJlUWTvRkS6jix3clCvs+UhFpHEtv4uNA3jKVwssXjcNN5P?=
 =?us-ascii?Q?jhElI9WwBOZYMADJd85MT3+PdBjQBvpJ7GxfWH4JqJ6MJ74iCEkgzZtX+PPv?=
 =?us-ascii?Q?mg3dxNCVWdPEWawK+BInoLkZARifqFfcBWEY87sWEGlm6U6xcTTW/2gHofRa?=
 =?us-ascii?Q?xrM+uK1Ew5uY9byaqntSuKgN42+5dgfBnu5XN2sLxlB1t4I3SppMondSCdlt?=
 =?us-ascii?Q?YxdMS6sL5Neeg8dLhbOkQehRNt/Teb5t0IMJDMtxG6TrVtjSVPrDPOpPVfa8?=
 =?us-ascii?Q?TKdFis5yKYERjIt6ebQ4y5wIScOeNHNzl4Hb/XTHqG4AvyOB0e/9bs+kgQlb?=
 =?us-ascii?Q?KrNCXYUV+uleXdqfg8GNtGnkX7WJUZXT0BC5HT3duu4Ew1Em4fRbTDemMSW9?=
 =?us-ascii?Q?QOYnRlVegtNHFk8cr2xKh3gTYlO8G5stAT6JtxxSLWTQXlshwex0NguQtlKY?=
 =?us-ascii?Q?XHFJMlq8pmZfzEqlgb5Wp0ucK2OF7OGISbDkcvlf1PpqbBXfj7NhHC3KjeVH?=
 =?us-ascii?Q?R2FNDijxgsuKBaFrAnZ0xSS7rkIQdRSVbFS03cYjUSTP2NQIDVG10jNz1WFn?=
 =?us-ascii?Q?LBjaGVMb8sV/SftPbaPeNxB4SnQNdVeZD7TSflWiZtwus78qtBtEQ7otxQ+r?=
 =?us-ascii?Q?KOBf81uiLB1b+bpkPG+46YO+fDehU/s7O7sqF2Wfj9a6q3TSDd77mOifJwxl?=
 =?us-ascii?Q?7A9m+mpEYqUdKSWf33JnzntgtJ7L1qUqWWgfU4AbwkQvawYbCw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:13:40.3204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf7b8e3-973a-49e8-7e4d-08dc89bc1c7d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8419

On Mon, Jun 10, 2024 at 09:31:13PM -0300, Jason Gunthorpe wrote:
> Add types struct arm_smmu_strtab_l1 and l2 to represent the HW layout of
> the descriptors, and use them in most places, following patches will get
> the remaing places. The size of the l1 and l2 HW allocations are
> sizeof(struct arm_smmu_strtab_l1/2).
> 
> This provides some more clarity than having raw __le64 *'s and sizes
> computed via macros.
> 
> Remove STRTAB_L1_DESC_DWORDS.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

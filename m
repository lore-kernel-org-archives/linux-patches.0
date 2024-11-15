Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1897016BE2A;
	Fri, 15 Nov 2024 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731679327; cv=fail; b=tops4cW6PO8BkzGp8veur4J1d4ukUTKbMD8YQDIsaLTHd+3Swbpl3K9gGlEbr4DvK6ELRSxMtiu+7dfWeLquvq0/ah4LAuXD2YE19rwZgBYFZpBNcliRWPSlP1eAHAQxmAG78fObYanXlI/F9pzo4Pawa1HFCNuWL9SDlpBt9dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731679327; c=relaxed/simple;
	bh=alLaQnmBGwlgWKyNxthqnkdGzN04HDHh1cUn/pyC6B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eiHWsY6ZY6jHz3aaLWHXEYQIUzcsL4hpJMg6s/A17aSihAjHFf01HxsQVqcKoGRYYlHX6dVVebm/NwQWmzCwQpqduFHEiaknbmXz0ZwK5BkPntLwSmGDSj7fr3r+W9Ra7tLNL3r4M3FyZin6UVx7oCMpbm0j2NqCxnCYOYLhD+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gK8DXge4; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gK8DXge4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aqFewbVSQ5EVdenaLdQ/un4kVKQZ6lndSU8pLbfYtM5Tvd18Lq4Hss66DUFU8yhJXRKt9SM+rH6AUh27spQJSWT5T3csHMohAx3aH2wXVyEisKIr/imv5RPopl5E1h710xdrK8cKXI87MyQlko/G9I0HfrjVb3x1pBQ7ITuDmsewhqe560n38GAUy6vqMKclHzfB0tAlT2eAetqg5ENnDGSIqLFTlg3RC39+t8t2RuXXCQWxFTYrVlrRYNutEe9sUCrKRz9v6EnvBNbr1mOIp27ZFeUtPbioTszfrEgGzrMlSo9vL/aMV9NmNQho06RZc+vUViJw2tAdm4kX2JAbdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pl7U/tzpXwjOgMfEmhjb4J8CMaJEcojsgMv5810LpGs=;
 b=A+HtgZzKCgGqScVbDBpXEt41VQRnQRyV02DbJ/7PQSXGZs6umHiEdQdCJYHbXTwrMSmkk3eicpZf+5Bh4v/wZZSCEdCSIR3wggPq0LGcpnnZnaUJ2EPOFVd5h8IhXMSj5p20ksGXbXwirYnN+QgbMdLLeLgvPSwEYfg1z820d3ZiHYe3NIazugdhMSNuscdd0RDjOraBlBYsRq7e5P72Eo7wiVEGxOJ6W3QU6NusbCJ1fW3O8Yh4/kHYCzsBxMF6qrLZMlx6KsjdIems4pzeZiIWrg0QCAOP5iwQ//tTQoxhHtuIn5UofD1ZADZnYfBZbTMhcet+Vch0il40Uu+ekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pl7U/tzpXwjOgMfEmhjb4J8CMaJEcojsgMv5810LpGs=;
 b=gK8DXge4PmE2lnuxJumQ+lJnu/YSGjM5w/iKAo3pjs5R7UUdYLUmRL3GFMstmiy8xg97ACx50wXX2/rolyJEZkFpQ2k8S4r3d/rSI+mgVB9niUKOrQI2qdUK0lmFEWUakL2kwnEKc9hZR1WV3VnmCDOXIE2jMEsrWoQiUwSGk/uDcZEdy0tsJJNfaKCt+LG3IYQ/lz6xR4FxgeieXtWP4IcmWpCJV686k+TNnLxC7PT+a2F1TGpMM1ELoQAWHRNBQHQe/3DK4wdll7zmL57lZGkjd//NcaQ0Aw3UIPj57g4TwxDJD7V/qLH3v5ZfRTIVl9KQBBe1Ow5T9wApyekMig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by MW6PR12MB8707.namprd12.prod.outlook.com (2603:10b6:303:241::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 14:02:01 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 14:02:01 +0000
Date: Fri, 15 Nov 2024 10:01:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] iommu: Rename ops->domain_alloc_user() to
 domain_alloc_paging_flags()
Message-ID: <20241115140159.GW35230@nvidia.com>
References: <2-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
 <e9981960-a7f0-4e0f-991a-0b96e1d57cd5@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9981960-a7f0-4e0f-991a-0b96e1d57cd5@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::9) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|MW6PR12MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: fddf0c0c-4d20-420d-57dc-08dd057e13cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hd8T9YHLT+Z7+fqmvDUCYauIOnKTDsfjdOWMvkKLNmFer9ZcnTsyHAWZiekK?=
 =?us-ascii?Q?4w3c6i/ECDMcmLK1xCRlWzSSb2c6VLhR7WgYb9mw+Fw6P3WrCp+GFtod1NTU?=
 =?us-ascii?Q?UboUDxwTUX1W9HBpOpIC2pPEzk60w+7ab9aRNtBeAWFuk4ccwlTn7kuwoQ47?=
 =?us-ascii?Q?tTiGZKHwqI5IbrZQ0pTwZFykyVVGFHPVGe2194PWPhmDIF9DFsTCdn5dt1wI?=
 =?us-ascii?Q?S1JY/2nNYKdLOxDm0rtP2qJfeq1Ku8wT6CshlbLHx5uFISoYIDPItDc831PY?=
 =?us-ascii?Q?oEbKmOlODvf5qUBFjqRQD3fQ/ELppOjZ/EtcCgwLE8ECQ0TP/GiUZgFxl4KL?=
 =?us-ascii?Q?bckxGvz322yWmembY4OO6Oihjf1R5MwaosR0T9uAaQuRkeYF33ATwWF07fRf?=
 =?us-ascii?Q?SyldA9uYKdw4rmlWsRUYaAxSXA3l9gEbL823eGkAg3Irr5eh4qwid2v2EM6t?=
 =?us-ascii?Q?Pi8wFj1j26JQ+FyAibQkvSsoMhys9YtcHSqCxGLL0V8njmmZ4zmEMYFtF15P?=
 =?us-ascii?Q?9DeLvWaBUWt+RleSeT9p7fGHp8dlaUJvR8VDrpjGtuG6/bf47BSOmUKzkJNv?=
 =?us-ascii?Q?tBhuYyrCrqXe4v/UWAdAsixzF2lxW8D5kSpdDCeGA26tvJps8p/aFPD9epxu?=
 =?us-ascii?Q?L0UxbPrnIoQp2eUCNMM+uryiFbGcaVkv+J1o+d8F44WA5C/sbVltEqjhAh+3?=
 =?us-ascii?Q?9OOmWCN0kTYn3DAlyWy9V0brcjiRoFt1uvlY4EI0bd5mQI4oYhSMFr1+lqlu?=
 =?us-ascii?Q?3GKcA5+DHzk77VR1nL+GBT/vqwZCV2qZdVOaVhSs8zNxdOCMIfB8fQcMPohk?=
 =?us-ascii?Q?nRPTiRrekPPyhDjSA18NsnKx6KrQHHBvJQalFQjRWAzRxeq08pUWLC3aUuxM?=
 =?us-ascii?Q?Pzfe2dYbSOwWx0N6EJS05zp+xVYnyFtLDc8pgG8Z0NEAHpCi16hr0C/6s11b?=
 =?us-ascii?Q?eYC1BTZ/Lgg6945Oh2MAntJcGkwpL6Qmbm1HmDZs33BnBmk/QBlvcPACKIc3?=
 =?us-ascii?Q?3ukMtmG/hv2owO5PdnoH0K05nEVTCdnAGgjzOVsFLT5eOlipXvNYneR4eoeE?=
 =?us-ascii?Q?NywaJhmwJ/cIGBuM/oE3i613EpiLiRSTcFzNzsu8urgdw/UN9YlkggyKMg+v?=
 =?us-ascii?Q?3d+SRTv9TyfTujOEDVVCkFrCFZn9RYP8oxJt8qbQWbT+DYlXT7K3rni5Oo17?=
 =?us-ascii?Q?k2iwPWoHZlmfAZyF7SPVcMFgZNOKLMWVMWGlQ5YU0k/pELGTRo/EaIujnjjb?=
 =?us-ascii?Q?YU33iIX8U6D+60xUr7C4u3I044/Dx3/P+DGILPsKcdQxWXyWJq1zXrj+zLCO?=
 =?us-ascii?Q?Ovwd9SV7OhE5rWpenEOz4mqg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2aDeC9UllZNi1LPy3Qiuqz7as/6IoU0OqKcvaOa/fBDtaqCjWtCOxt1gyFKM?=
 =?us-ascii?Q?a9Q1ezt4dQvDARzT3ZPpgdRXVyJ7Wfh93JehtB8m3OI8e8EcXqixoZ2f1PLJ?=
 =?us-ascii?Q?DwfPEjGQCkbK0OxrKh/oWg6uTCkx569zxYWItPY+EbB2pzcrN7KE7DJPFUck?=
 =?us-ascii?Q?KfO7kN7nFrQ5VfoKfDIw31XDU00YSk7tDr8lGTV4xz7GvTHwypA4NIeGJZig?=
 =?us-ascii?Q?ZNLAHh4cZQ/opMhT0Htbmdz2KMckNWHzw0XW7uwWXTT6YPusBb9gg5v0jdqk?=
 =?us-ascii?Q?6vXESPZhnATYYIUPTU30jp+YQSa/L2PTehquKaAD/7c3SBghq2MxqlcjAkYS?=
 =?us-ascii?Q?alUgPGC8MKqdSKYFAlhHWXbsprR1o5DU1UVtjWwic2UMFq5lxNeBX5srp0zj?=
 =?us-ascii?Q?E6Fd9xLmdVuVMW3Ohyhfx/COLhVyHbZ1v8JxqHbpBmSByFY6wd3vvxMrys/P?=
 =?us-ascii?Q?MCDf4i0jP7n/x77SmBH8gmMDmEqeuLsEbVa/TcD//lpy8FtL1m0HpBMqLTm0?=
 =?us-ascii?Q?MkbcYhTan/lJlKys1vV5IBgrReIZRWuEMbGi+QOgYZwBLFRsFqI0ZqKwGSMz?=
 =?us-ascii?Q?B9E4XMJGoEt6Je56eq6+Kt/Ps6GDqNTcUaptxiapJokHWnqJzS6HHlIMB7E6?=
 =?us-ascii?Q?HSX+AFIVypmrn0bwBamEqG3HwQkTC5pEFbMrbvb0lpboeDsaopN4J6SkYCLi?=
 =?us-ascii?Q?w8MbLNsdZVCpWEy3J+xMqWW/a04DI8n20tZtoRdiR0zXhLWlDqzpcuyefAjo?=
 =?us-ascii?Q?mJHrxJwGjwpeXmiy2Q6ylTQYCTHZw6JoEMdbSyGywcL/MhavAAYKEenqw1T0?=
 =?us-ascii?Q?ghkclUesNX6Ec2MPqiJlwIcwk5ZuN4wbRxWKBHNpciAayDx81UHvmZNOXHKJ?=
 =?us-ascii?Q?FzbTB+W+qBMeoZhMBNLZhcMYhwSLu5nYXIzr20TLUmX9NF5+gKY3ISnR003t?=
 =?us-ascii?Q?z4jF2AFgSnlh4TgJRrcS2HLtlnHxiLMe0voMNzARrudsyu1/xE15v69EDE12?=
 =?us-ascii?Q?XXYDXYEnRugTSCehisEqWO/9DkcGQo9FUHqgxZhsKrywFxyBnNeJzqB1XClh?=
 =?us-ascii?Q?ueKvNzk8jXvaVWv7FY8CAuE/zUWlK21y88SIQpLRzqrg+8GjMuuDWn2QuSMC?=
 =?us-ascii?Q?w7Lwu65r69S5EDboDJRnjmKxwCzWbE6RDxMQAbQFqF0kyBJz4z9J21D8edtd?=
 =?us-ascii?Q?/Dr+St2/SfXnKwcM5ZxZ82F4pst/XEZHlQ+pULFJ8D0fMT0FjWDHsd52xS/J?=
 =?us-ascii?Q?38ZodD1Mr2Gxv1Rsz9MtF2HCBMoEYJGgTUNe4ht+yDl0JLOKsxsBJmHUlXMG?=
 =?us-ascii?Q?B51Lxd8vK0GGdiEoqLQvgiscPEL5Crxxcb/qGs9Zg4skwMu31y5FqjyspZa1?=
 =?us-ascii?Q?w5eAXyC9wSwcfHMcM5I7us5JoVgtGSFgOTQG7fSGc9W1DTNK6GtMdgPfPHIB?=
 =?us-ascii?Q?mdrV4eqNkHNU2n75l/nAEGoFZIgXp5ICumLFwZHDXFkofShV/N7aWfKP3E3P?=
 =?us-ascii?Q?r6HeMmN97GZVJWqw9W1CNZBlaiJZsmZxyZjZ90j2HeCmGZJDQCoyOlIppFj5?=
 =?us-ascii?Q?wVQ6Jw8tu9PT8P856Qo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddf0c0c-4d20-420d-57dc-08dd057e13cd
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 14:02:01.3876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vi4LIvuNMWjb/310Tg3hQVjvJf8Wa7Wv+pGHFBY0f9pj+isxtYWDhHayBfPe5uOk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8707

On Fri, Nov 15, 2024 at 11:22:50AM +0800, Baolu Lu wrote:
> On 11/15/24 03:55, Jason Gunthorpe wrote:
> > Now that the main domain allocating path is calling this function it
> > doesn't make sense to leave it named _user. Change the name to
> > alloc_paging_flags() to mirror the new iommu_paging_domain_alloc_flags()
> > function.
> > 
> > A driver should implement only one of ops->domain_alloc_paging() or
> > ops->domain_alloc_paging_user(). The former is a simpler interface with
> 
> s/user/flags/
> 
> I think domain_alloc_paging and domain_alloc_paging_flags will
> eventually be merged into a single domain_alloc_paging with flag
> support.

I have patches to do that to arm, amd and intel. Alot of drivers will
just stay with domain_alloc_paging() because they don't need anything
more complex and there is no reason to spread around boilerplate

Jason

Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF062DC787;
	Mon, 26 Jan 2026 21:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769461607; cv=fail; b=blNcFE/Nw0xhiaiG8NZrmxKlFFs3xXwuq/jMuIEcS284u7X6HumUU3bdvkg1cdSQPJ3/lJKUbG4/zEYzEOZN2gqScHbzhg5xk83LGqM1qw39IKGhuIYulpNxZiq/C8XZTWyas7GXZI8tX8kbmaKwWcIWFQKv7Y9lzTYS9ZrHdpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769461607; c=relaxed/simple;
	bh=EBWbTaQkb09bkMPZhF94y+4WVvN39viXlJ3d+DtW4Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oe9jrYnlHAoTl7y4SRnZbaK0i0OIDCCYQMa/DSYVPIKi/UpoLZm0zPcPd55yuOXDGqvD8L2pTn8favmPtR5REP9DhFPNiyy1HMMUIT7Yvz2Pgi4DELRQig5Qip9uVKlQlTpUnobwG4orLcRbvZJ+o9oPAc60QQpZYJq7x/LFu2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MT2wn5sk; arc=fail smtp.client-ip=52.101.85.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MT2wn5sk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENyRfp0yoef/oOcATzSZkKXMRHMagWhVVDIZ1K3dYFFOLiwstAskgxokbghyY0A71AOCaRTiiDkef8Glaf+nX/o3yd4Zb39k6tMuIUilM80z4w3uytbWs5ovMvsCYdl4RGsrZXwz5ey26u/QPK8B/1F4H31IhwVB5/TPUw9cvq2JgsFimWae7WG+fCaLQKe3NRezlkaGraDPLgUKtPGGomsFgebPd++8BOEL7vMfVAUGU2OmDxuuzYWEw0eegz0Wk4nWtmlfuxrM0FYC2qda5omO4rXGZOMPCJVvhsZlB4B55bDm2Gg9ybM7Hk4e5DKjHRAih7hKvH7Dug6NPlkWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVffTeZLGVZVEGl4L7c72ckkhomtAIYqAmUPGf8LTyM=;
 b=PztBNjNPWJPIO0i215/uWDbljohdVvdu7EUHX3t2pCzQJrFFezdDHSfhUQFLkr4bWfAAqQylskvcWQifhUlQ0vsHD2Zwpr/F6qpw3dLDQ2cEwGv+2FQGUSEhOx00vxB53cUJHu3UG2ZR4wUNmVMuMROMJnWQcaUGZvSHyv+4Noj4AhS7GCFrthJEGfIJA9G/ycjAdpkKoPOhttP+M/V3AZqEOjXgLL8RRF5blkTJYlZGE90nasU1Ba9+g2BhMntXSDEGUJBacrC0AONtx3Cf4WKLVBn+g8KW/W/JQvKpLO7fF0efOPs0YytzZCDxFBeTBOtaFcRl5NlhutyZOZddUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVffTeZLGVZVEGl4L7c72ckkhomtAIYqAmUPGf8LTyM=;
 b=MT2wn5skeXvIbmhLvir/REj7z2swQl47ganZAspxQFSMVbswbbiVmrpWBePRm/AiQGNWealbowp5JPe9++OBcXUVmm69/8vOwF68dPbQmR/AwxDNl2f6/Rjso6V8Kl+dm8xV/4V1fp8OUrben73NdwawqmIJD3bYg9ECTeXVe2LHS0hVGAQpPpEjz9TRZCmkXcXIVTGpoOyOp15cnFQQpPdtz5ooMYEv0m629NqnjupXMaPUzXo1DJHIC1pb07wfjrAf5B4Ncon/q0DWLnuYDRIRXSAHzY7FylEKPctPsIrIkKNYrh56+MyDKVN5dPcWICgl1+dB9leSPv9cT2XppA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB9564.namprd12.prod.outlook.com (2603:10b6:8:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 21:06:41 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 21:06:41 +0000
Date: Mon, 26 Jan 2026 17:06:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 04/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if
 no id to reuse
Message-ID: <20260126210640.GZ1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: IA4P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 633f93fc-7a4c-4407-1365-08de5d1ecd56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hKRHnywG8W7nWjXe1r1+0r1uPSZmzIP5ScMsqeo4vy675MIZshxuc/LEdgSw?=
 =?us-ascii?Q?3DRuaWRAVr0ZB/2bU2SceMrvNx72Z37mNMSRYtdYNIK6n6Ko6WWcR0vHnTOf?=
 =?us-ascii?Q?ziFe54/uIRxKS+P4MFfidTJN+ZjlRNlivkJ7sVY/IUAc0fY/1ca3YUCvRcmZ?=
 =?us-ascii?Q?IfDjjqXxsoUWMOhyzFWNGQF/GDE0Crj34tqL0/AbRu7WnCXU1fhl8a5T68+X?=
 =?us-ascii?Q?vHoYN/exwFvX9nqbypnJIvJyrTxK1bUsFkhxYMuPGWgXtPuN8t6xAilq+dxP?=
 =?us-ascii?Q?uxlzLKsGtFLh1SXliYgR+bl0Y/sSzofKQLSM1kfhedPOr20UyzY+AQhndTYB?=
 =?us-ascii?Q?6Om8xFxEL/pTVBOOW7xeqiJp40PwjtIZINky9Tw8fE4QjQ5jAPEpmhNAXrtU?=
 =?us-ascii?Q?2EvJ1M/UIvSfgBEjkgi4T5IyzPplLbbQ3gkHXOAfh2x9TRFgL9da1vV5bMjY?=
 =?us-ascii?Q?QUcNPSNlF/r0XRnLFRViKLC+BVb7yRNWw3YQ+DXw47H3IUWZgHlxBX12L0S5?=
 =?us-ascii?Q?disVmbzdEeJZz2VyEv28mViW1v0OiMrkVJwgY/vCPPCI81GuIKApXSNCE5WD?=
 =?us-ascii?Q?W7H9GdbYIOicNJOGLT4NQcBc+k9xTurfTUChBCGgJRgegASHR2TYhgHoWDlN?=
 =?us-ascii?Q?BxpaxpffcpZqW75qOGTENDZnBM9RoaBIvprPgT5L+Ws5EZoOToi1ETpwVf4o?=
 =?us-ascii?Q?w7qAMP+HlCiubZTfp/hf4hozgyub1Tag2LpONG73e5xKVmD3ETKbeOiMU6bc?=
 =?us-ascii?Q?4hUw27ixVQBaieAd2TojrqDBjgiJVmzUSGRBKvxk01uGRsVTdrNsA4hQLOKZ?=
 =?us-ascii?Q?VgLDGf8zQkzUHhWPYKf0PKwMaj1JU701yhGvaLW7Y0EMisL45hdXD51y0YWW?=
 =?us-ascii?Q?R+uF6gtoTqmGRK5QC2F8yaaJvdo2B79DI033Kdwv5Ae3QUbLHUSLAWMke7E+?=
 =?us-ascii?Q?e2xwogYTdldrwyBwm7aCO936m9Xn2zlxCQBv4CIF9h4HqRnR0ZhExl8O3DpK?=
 =?us-ascii?Q?YY20b59uGwoNKDh6nuBgDnKqMPFQKJPfSLM198hjuOLL6DGe7qdHGouoIZXS?=
 =?us-ascii?Q?V1BMk3UE3ZNboS1Bf83R1s1e8796gp7Wr5OsrRgk/EfR008MYt+TmojBZ45E?=
 =?us-ascii?Q?jwd3taWhyNreoNFRSAsXT5qeSQDkDbuy+PAGuQ+7exU/paXVAF11MF2zgj2W?=
 =?us-ascii?Q?yZ5tctiWdPV6oqLkhy5G8t8qWVMJiRriEdjhmZ5XhBsCpKR4+iVWoyFyuCOF?=
 =?us-ascii?Q?RqGa3P0GJ1g4dvHnFVt6Nc3LMxLwriPj5Rum/2ckqJ8yfU1IilUxfu7eC6C8?=
 =?us-ascii?Q?cgyd6uKFGsi/WsGCtjIdrqow70GthcPLyQB2Iatj/oPzzKWy6mOGnsgBHtyc?=
 =?us-ascii?Q?JZe3SQ7s4mkiHJJ22yR1Bkukp9UkNfhI6MbKY3iBcv4mJT2hdfZ3B9xh/vyu?=
 =?us-ascii?Q?A+eUcrWOTm8LoS09FjjNkzDAvjWOLY5ctarttFebPOISWTnbf5m479Th9YwK?=
 =?us-ascii?Q?Ip1PZNx0ISTEhmrwtkju7+ekt/A2i2eg7H12bSpaNpNjMIOBy1R0XhqWDyHR?=
 =?us-ascii?Q?351qKLHx695VpBCoJYs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pS8j+hzkkrLai7kmV5eCjIEX13V+Oa/u41oZVdInDQRlOqtLclzM7BzLFsL7?=
 =?us-ascii?Q?/FhBOGoe0m/RBdcdnYiGdiIzeVjtPzQZnkSd2+rPJOb+GZZWVlXYBJDmUE3q?=
 =?us-ascii?Q?TV154QPmtqlZkkQ4WIjcxzG21nzaovOFIgCTRYdgZkxI/jvGZ4Fc0ZaseHen?=
 =?us-ascii?Q?TdfSemr2wOp5T+SxPplGGxACLGet4EwaIRn9q+mN5gPiK1VJSNmAd3i5rezo?=
 =?us-ascii?Q?7AJY66Ttpyy3sybScYnVvqiqI0T6SEFR2+aGahc3+atZbv6n8dSvERkHtl38?=
 =?us-ascii?Q?/BGZwQ6gKbTD+uOeWtfWyEgx4HtrIaRF2GzL6icOr1UUFWbNMzvvubxnKB6T?=
 =?us-ascii?Q?i8QfcbSVQvPAZPT7ifg+4GNRzDNjP98+WrkP9ditFyLRwaA/7ohKH8orrEVa?=
 =?us-ascii?Q?5xUtalrkIPv6vabjTQlyAq+PeHoGa9sArUus4HvpcwoZoYV9v5GxOjWpb0Zq?=
 =?us-ascii?Q?150IE38YH1jOHIC70+tRNUa7/Ui/xIe5b7TlryD5SCX5TR5nKBtUUD6TnaC2?=
 =?us-ascii?Q?IP6ioRkFNDKKoZXYug6uUMDSOwwVluOIF4gjINuQUXYutbygjKfuDY0XlPRH?=
 =?us-ascii?Q?wBO4sbXRAnoccGf5QT7+21KPnUASNbT9FBBZYh3vhJTs3LZ2morGFmgkJTcJ?=
 =?us-ascii?Q?gdfSj55nf1YfhBruZluYQeUi9gIzgg4F/VEetkFtpcT8VAMiaepYt6qyOxQ+?=
 =?us-ascii?Q?8cBHvvskHDx2OTyW90Mu9Pc1lJKd5SHvDJPko5OrPiQ845wMfY2r53DBnIrM?=
 =?us-ascii?Q?o3aEkGAiiuoxjheulxTMiNVtSdYyMqRIwAv2o0SbNZQEwCcz0PvJEcdLA7GE?=
 =?us-ascii?Q?ITgvrB/iBgm+H1FmrLC/Kh5RWq7vmWQ2kT65aSXdSb8eYBCv20EU+qYHzpZG?=
 =?us-ascii?Q?cVdipZNSG0uDSN08JnrXMEZH7N+LynnjxFkP+2Bi82wPG5aRjhT0liHYB7iX?=
 =?us-ascii?Q?YP+BwUKgA4ZKZHlUkBhVLWkevstwfUDHKGgj1t7Ml2iZr1CTsb2Sz/pu94hz?=
 =?us-ascii?Q?o5b6z7w73n+KFaclo4lbhQMtJydiSFE1TAP83d8XI7L0mSCe/8JlqXwiW5pR?=
 =?us-ascii?Q?kL9REGI7rJrtmg32lTXhPsownhaE7Cnxp18UU9EDJod8b3F/cx3viHALvB3j?=
 =?us-ascii?Q?lwbQAU4lzk/aCjtNmmp5zOZ1dcS4hjO34szLN7jMdp4ar3XpSB9wMx7xH3sP?=
 =?us-ascii?Q?O3nZ0En18bymFF0T0kQlBhYb6T566m9pSvTbkc7flM4TDky0CWCnRQqPzdwz?=
 =?us-ascii?Q?GG7ryX7sXsmUx63Qx02bfyP7Ix6dgRMyLfdPsCWJFVR2ruWg/t8oMq4VhXn6?=
 =?us-ascii?Q?FwEccDLPfihNySaH90j6ADpoXWb9zmAHnkAv1KL0WwGxglMkQIAqFKaUdnso?=
 =?us-ascii?Q?TMY8GnEG/tsvFEJJx3iCJjLxQKS8b8k34XosFprskU1W8R9SqZ36J74buHDN?=
 =?us-ascii?Q?OHElf8q4lqBKQgwdnNHRjVi+v+qV0o9necY3yUg6M6SNNu5sCvACKsrbIzS3?=
 =?us-ascii?Q?r815K5KrQmEbcF2MaHY/fanGsmrZweeVnuK1n69GCMAlDL9zx9Ts7bOPluaQ?=
 =?us-ascii?Q?FnbACX9r88XUIJDcsLcNieFPmInOykig7ygvy5jWBS6v+sjefgbnMt26/EmX?=
 =?us-ascii?Q?PWr5Kisxz7pytNf/J9CW0oQEPvpzqFzXyiORxizUJzFcMyqBC37zLbiYxgN7?=
 =?us-ascii?Q?/a5hhYzo/GQdKbS53ilGMeH2z8qiJJAqRdvcZAjVa33Tv+dt/uDuhhJUE8ju?=
 =?us-ascii?Q?G3JFdD3nnQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633f93fc-7a4c-4407-1365-08de5d1ecd56
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 21:06:41.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yR2QWdRzFz82ICZbjB+mF8N0YRkVqAnTT9JjBBxwC2pjm8ZL7UrNrM6UkUcEX1HB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564

On Wed, Jan 21, 2026 at 05:24:22PM -0800, Nicolin Chen wrote:
> @@ -3220,6 +3241,9 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
>  		break;
>  	}
>  
> +	/* Set a default users counter */
> +	refcount_set(&cur->users, 1);

I think abusing users here is a little too hard to read..

Can we just keep track in the state somehow with a flag?

Or maybe union in a "bool needs_free" that is for the on-stack version
of this structure?

Jason

Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E754670;
	Fri, 13 Jun 2025 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749819540; cv=fail; b=XRfW+FgJDn5ca0BEBkQi559sHaLqdKh3BqBUoTAYXRXCMmGM7WUKQZSYFQ8lS0j7Cuq0siZEFY6KbCHvqjqSx4cS6qrDQ95K2IAp6tCW4IgT0O2b83GGhCuh5+TSYQ3lp/Ly7mpplzyjUCzHzEwyK7vS+DN1s/y8zD2Pq0HJ3lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749819540; c=relaxed/simple;
	bh=anr+i89l/pAZK1VK/CB+dq5u/U4/XndWaYysPIK/6nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DcgvVVxDLXYvkr4gbo3tCp2eptnpDLYQPIIXoOW78VLsxsmWQiLWdfWvsxM72fjb4+CdDwNtTNBxRzoo5H2nJ7ndg5mQ70CXmiMNlOnF3P+THKqxh9L3QekoDDaC0/1PLqg6B8rM4a+qzWOW2gSfdePhDQY/lOsg1UPdtYilxFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TmXX2lFH; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TmXX2lFH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+C//tCrsx/Udv6QP8Nc7RotiuuPlc2LsW9PVeKgh6GZfaBGuqG5ztAzcls1nG5oa/N0qyJx3OgLwLHeo1ap54D36fQmIojcQMbOPbM0+onouT4bOzR6NUF+iMJEeSQcg8qpI27aGTE0jx/fXiJGilAvEpvVVVGFm9prwNVLfR9rHf4T6PTYcCag3gMGTeLvDp9fUr0VfRZrFFk9tazGAFCgeIxZ2nhO5p4BdGS83itGW3x+p6YQjtsMR2PIc4SswACBPkXn1i6E5Zrc0EseI8EIlh2Kv5gVcjOBfD1US98nLrgGPomauAtPnllUvlDOIGZaZxHydYVJGZOCtVBYeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHAXVZoZKnOKSVx3HAqKyr0q+ebxCy7MmQjvWHHjyMI=;
 b=wYyE9SEJwSpO5iIivstXZqbxKheXtcsy2Dd37Q8SUd1pXf3IYvg4SeOpZR4gxtx5e4xSjzHhMfHqoJoIBMCf3VH/B/D6ujLT+uQ99dsgwR9vTNJmmSWuCyGwRT6Tzi6I6ggTlyiwQ8Dx1rHv9gxZ9oVAL/OieaxIngTKiveg6eNMMwH7k0vhqJdWDT7D9zRUisg+XO5FYC2JdNN4BKeSuLsBTOpa8Y5BvmOmgnvIYBwZTKR352L9h6LHUImp2R/3TMgL8r1GtUkqrsUZGrPFAzb/lZo+cG0UJb4lac5URndaIDpoIvX7PXdWT15vro7+iuqquIV6DGsGPmDJbnewsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHAXVZoZKnOKSVx3HAqKyr0q+ebxCy7MmQjvWHHjyMI=;
 b=TmXX2lFHsp3B6GxZrMPVZrGaF/0j1eSos8p+uCBpgNOBYYy4bBssCezSNTLgcNAYUBz1WZLvRUVwUbH351afIXabAIeVFBb8i21fF/47nog8/wya2V082r1SSeLG3UhwgVOYgplEzpn7RQR/UcYve4NWbRifr4Jg9WCXasJrPT24iS/anYYmsYZiGk+GzzHRciEpuu/CHUR3Xd7pDmvVAlPvbfWl0C/nJ8il3eU2HcW0zK3xsjv9M3K4+l4c+DReLznDkPW7mBatOrfVpPdPeZbem7jy1edIjqK8WZAnPiV9twBh8eb8oYMJRyBeGLcN/EntfYR4A8IcRsg1cE+9QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 12:58:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 12:58:53 +0000
Date: Fri, 13 Jun 2025 09:58:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 5/7] iommu/vt-d: Create unique domain ops for each
 stage
Message-ID: <20250613125851.GZ543171@nvidia.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <5-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <BN9PR11MB5276631EC5395DC7E4A2B14F8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276631EC5395DC7E4A2B14F8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:208:32e::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: a05cd508-f317-46ad-04c8-08ddaa7a0c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gfbDWA05zc8MAz8+yAZHYYHQGTUb3Uh7F5SjwBHPHdOE24Jz4e8v12jX/7n6?=
 =?us-ascii?Q?Li6EiV4WLkSZFjKEpjlE4sR/sJ4G9mwwdZsJLGqijmRzWfqHpu4rZMfLsCY9?=
 =?us-ascii?Q?0HFSG7STfOpT2MUUo+gY7ws7OnBcCJitZDaUSig9QylnRvkzsQl+u3gcpUkY?=
 =?us-ascii?Q?X4Aqd21rczAs1DBGZU4nyPOZWeTxkgr1sF+OUsYVWKtQP8aXyDmhxU3v31oR?=
 =?us-ascii?Q?om58b2YvYTx5L1PbmZbrW/nfgPuJQM75eESn5nc/i2RXnAruavH8rrhwMlZa?=
 =?us-ascii?Q?j7Ee/zSzvVEOSuX+b7Uve/M4Id3FPtJdCfaO4n9W92Ydmowwt5s+iWk+imYm?=
 =?us-ascii?Q?NaoyfqzWp9rPkLRHCRYtgE4zX6983zqYMDAoj3I+OCw4kxF7v3ZD2rxeVBAX?=
 =?us-ascii?Q?7RLetqBZqNkpLo5aBmID8zpBvw18ejAKoeqi4A6+n1wMc6Nsd3d+hrv+epHW?=
 =?us-ascii?Q?CFd56QM3j2/GtAuzG8bNuQ7I+05yl5Vw+bGOmy9Q7VE5ch9EyEXnRracaAmK?=
 =?us-ascii?Q?w2Zxxj51yLRb6N0Eby4rTyRTZOUvugD/bKkif3JPaLOSYhqgKH9SI+aN7WIm?=
 =?us-ascii?Q?vszjzQAdfmZRyFfHLMVUeMrhu3AAAJqHpqhEq2r3/NjVuZFwtFN9LV3qoK0O?=
 =?us-ascii?Q?mFm3jQWV/Te413ipZsOjia61deXbz2q/Kvb8K3np8vaOF92ixhzdhfA5bn/7?=
 =?us-ascii?Q?3U+rjHxFd1W+M1UZzWoBSQgKFif1Nh0/JsiLI47q7g3KWGcB0NspX6lW+Rsm?=
 =?us-ascii?Q?ny4cO93sV8QkkFzqRjWaCnC0R5MrEw/4dmdndnGC72BuGWJfA/0DiOVUcUta?=
 =?us-ascii?Q?PuB2J/iMXpm8/eioxthhfGL/OsOj97VDHUlJ8vFM+KwjlbbFxbg4EBeggfgM?=
 =?us-ascii?Q?QBVXBP5FGhB9iHwG2dtqzxHu4PljTxowcLk1lBrcp7fApudLqfOM0GLOMSAg?=
 =?us-ascii?Q?Yozc1u0r56hgPN94DFnhvRfuzCA0BSUy4Nw0C2YzvEWvX5EoJl1FS84fAJAE?=
 =?us-ascii?Q?u/AFaWAgivOU4Sy9SeMqC9S0J6M2olBtBcCEh/snzhyhZGqlO3SpAPsObubc?=
 =?us-ascii?Q?kGBEOlxLqciUxBwQAmzjtHTPH4/2yjv6vPzzUFbOwA8cF3x1mA9mEwMDOPNz?=
 =?us-ascii?Q?THb2WgNg3ar2FQU5SZ5IzwMEWD40bHMSgqM3viOysH+y5dQqxrJj2y7aZ/A8?=
 =?us-ascii?Q?TD8R3FfeAREKfvzUOGjZLRK3KhefcdjVlN+vgERWYdBSfzBemIxZcSvAJcE+?=
 =?us-ascii?Q?OwSS1tnHubNt2F7vLY90Cb+v8paV81wSG7rJkdFCIBANle9CBK2R0XF5BnQT?=
 =?us-ascii?Q?fNcMQApvmwlZnc/r3gj0CgpbIIU9/3SavZLBAOcBMBisZdJuw9FLH0clrtUM?=
 =?us-ascii?Q?MNzd04NYCxzHA6//gpWETSKGcUxffWvlKbiWaxZhIK/a/URXn74EywHkl+V/?=
 =?us-ascii?Q?p7Fp8ZtCXmk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YoKvkJcSN8Qn0gQ/GY/KOW2OE5eQCJehW063qs+meYwh5crJjIAblslRWFIa?=
 =?us-ascii?Q?TFW6FEOTsreMXDlU1On6283DqY5kR3OLWIynxzIl8oa8FXFbxbCOVbXILNyP?=
 =?us-ascii?Q?62OyisBh4oTSsCbuWnxYcQ8/Ic2ebJUF/4Ykmrj/HYo1kKf/l6ymMSP6JSSB?=
 =?us-ascii?Q?rsvf5BxARbNh2GZ3OzTVLQ4jp7MVmdXWvvCsAT2OsTeN6MI+rGp8LZSfeORN?=
 =?us-ascii?Q?91YGHH+hzEoglpMtFFZ/JIN99MawAQdbGvr612kchUq3gOf/ixe0QXvhAAKj?=
 =?us-ascii?Q?fcIvYf3JHc0iUx5SOBTvevF0K3WkNzqdp5Ei67umNri/VufwDAyT97/H3qY4?=
 =?us-ascii?Q?cM6pvCF557Us+24VxZ2c0CkdbgYgbLEwMCN/G71XJqP4T3VSgUWpM2GEnsde?=
 =?us-ascii?Q?Of+vpKk098xVy8gMoeNl59WVbaAKLwNostDGWkWr9sGwY7P2YLowUlFGoGQE?=
 =?us-ascii?Q?h6KlVUTI2iFP09qZDp4PWR+G2RC0eiMO0l/u+WpBlMxWBDXRFJnxUERGalG3?=
 =?us-ascii?Q?GnR8zr645iM5iPoPTmc71m4buO6u/SLQPUlGolgddUyWWfZj+I/n+AlieOl1?=
 =?us-ascii?Q?mcjCp5uGGwZgyKtssSz/RRMILbNubMbMWbk3PZB4PiY6FywhUGXKKWr9sJlS?=
 =?us-ascii?Q?GuxEXw9Udnbxob51QTj+nzCQtaaZ6Tw3romz/aL2koshvppqq86dYKlac8Bp?=
 =?us-ascii?Q?koM14ejIRL1raI7PB5i7WRVtjUiypymJ7Mt7IdfvL3Yvzm7UdOh5ssk2BJnU?=
 =?us-ascii?Q?QxpB7dH5kSkZxIAXSiEd0D3S5I6AX9JdPVe8GF825kZY9oCINKKSv/NhoV7X?=
 =?us-ascii?Q?B5eVplaoe/V0aKtSDlaSBBRB8cpZowvM5XlvKumizenpvwMM9AwnyP2sQzXB?=
 =?us-ascii?Q?i4HZ+SM2R9DPdGwBg01kJDMtgnxgcIuGWKQ3bIWqdbgUrs8L19QWEzPuBbGR?=
 =?us-ascii?Q?M62owEn+V4u2pjPMAPbViOTjVK+ZAfNHG8OXV+3hszkonUkZIy5Eo1wug0l9?=
 =?us-ascii?Q?HawuZBXlbW96761KA7X3ao+pWocwPiPoymwIj1yaXY3ks94ddqyBe4qlOTKH?=
 =?us-ascii?Q?EGxCh4r5x3rGh+4589DpexXRcmUnA8+14P20ucIbWCegLNipVVihU+eDr+NG?=
 =?us-ascii?Q?MYCUudeKjVKKSaSzo36bpjpQJ4fs/M3Z6T7JcRsnlyordI9IcaZTf8ADnHzX?=
 =?us-ascii?Q?Gv/vZzQl5ez0Ccq4pVdiksSDrNkA7IAC82bvdt6Ju7v9TCnemUzxiQ1z1s5m?=
 =?us-ascii?Q?NOhPzMVyye5/VgEnmfsJurVsH5+jvy9euAi+JyIUum1uIgaeidZI0QUorFzu?=
 =?us-ascii?Q?+Us+hAzCBKrpwGEYeOT1Hhg9dYTJ70r7u7YLD7WdrrjdPAQg3bsH8wT4MF+A?=
 =?us-ascii?Q?FllIPQZrnu8UJ9YkmDEq8QtfoPxfEPFmZzh2MECiFkGB6cUj/2rmAjutTQOc?=
 =?us-ascii?Q?90peGRI34K6H9v3djp5zgjtPOO+yzyoqEFkkSa2kC5VzPbH5UKeoCAbcMyB+?=
 =?us-ascii?Q?5UVPxmJ/rklryl+Gg0H3fjhfhzz/uxFYx/bQg7mUJibpe7AIeIYEXrP4VVIA?=
 =?us-ascii?Q?tyJGDHyR92sooFQif0GhpGPKg3qxZbdFYPSM8t3j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05cd508-f317-46ad-04c8-08ddaa7a0c92
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 12:58:53.5685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gexpjyx+k7z7+BEM5U3SQFVMfOZLg9YEWBMe02Tf+g81I10t4r+RmagHT72fAoR2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740

On Fri, Jun 13, 2025 at 09:38:30AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, June 12, 2025 10:32 PM
> > 
> > -	if (domain->use_first_level) {
> > +	if (domain->domain.ops == &intel_fs_paging_domain_ops) {
> 
> It is more readable to have macros:
> 
> 	domain_is_fs_paging(domain)
> 	domain_is_ss_paging(domain)

Done

Thanks
Jason

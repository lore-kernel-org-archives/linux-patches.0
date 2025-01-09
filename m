Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4275218B467;
	Thu,  9 Jan 2025 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443123; cv=fail; b=HFS1U324vmmZl5a0FiOHhJTFS1a3reTkDWRt9ynPSd8bKJ4S5ao5DleDUjUozYM0nwcR47YHKDbjSYPBRLhlwTTejMdX/f4LIpg3j5ZTtUK52YxIbICnPL0R3KCzxxP+T1/RQsWPoL+xmRU6ikP9L6duF9/OteG3YY5zT3FKRfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443123; c=relaxed/simple;
	bh=w/3t9CnRAJ62vuYgAuoIxshS3SCg3fK1RB045TXEBc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cBWjFUeY9ycMShTT69vBMtm5nic4AzVLYVxbnUHGbttU36nffrUWYOoNJbecloS9E8+7QsMd9IyyBJU1GnlJvANY1NGbJbNvLkMvD0uJLQ+WJp/XCSQWUfk7/7f2JqoPCyP7UpiKtRMFEQFD4etUsGmR2FX5kiPvxMjVhwFy2hI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rJELZ3XM; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rJELZ3XM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xjh6RDaW4Y+JAcPbmtK/KUMrSbMY/U1ohN+TNXXdD0dbyW4bD8YMKbdM+l3VlVzgfpBv8XUfZN+2lZX4xuFwDlPzHIqmoOLfhPnZA/5hp8Q1PlCYfKQz3asemi+RivZCw2Jiea3ZWYqcXEeeRYfD6wHt8EH7VWCHgNdlV1f585ZIHQHGChmNXFddufWyt7KjA0iPu2i1iRgYwYUTjjbqKbqJIqlzWy3lUlI2xwkUHwdyqkPMTzWt2Kvk7LyTt82kdDOdMZeGTWCyBv4rzO8vPS5KLLzzYVT1/iW+7OUq2VxdSSAFyPisZqCMwvWmaq6UG4F7ifObUsMrnP68TQV6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koakAqn2afS/7tGYQtAWlJmRuPXvtL4q/wQoyHSZcmM=;
 b=g4bmorRc42qabakeV1tSGT0rmRNMPS2cj9t54yTI+YVfbL8f1t9xgh9q3I1k2OvVxJdCgcqtW61Cc/jMXs1Iy2+qr+Pv/v5hJ4GyXjwT8x5J5rg44UJbeRTSkKFS6OL4QLMxe6fblU3bPKluLrULoc4nQyM9yi1g8ThtCrYeMoVpWy53wdOc9HpGc5k+tpK1wQzseBChcRUPNKCgFWgiSCUe8tdLWEkj285AFOcQWwlGLG64Ft0YvivPCiqHS4yAO3NFD8r8izWVaQOqnRiib3YGm2jcSiC8XQjABQF5vAXmArkQAlORvzUMiUxnYT5mRG4gMnltuFOTN6/l6q0L1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koakAqn2afS/7tGYQtAWlJmRuPXvtL4q/wQoyHSZcmM=;
 b=rJELZ3XMAf82p+su4KZ9HDQ8ofXy/SW8buTBMhgoqFgUhx5H0to1X1i5WiUwienKkzB79Jeq8W7cMFktI1ATZuicWgztT/QlBr8uC4iSw1SPvUf4yAY0qiAed5VLz8aXqzZcdOIQ93MhOwErUHDPz+YO8p/M3S6d/hXEMPMwh2kQNekQA2mDuOTAcDw+rqRNO+ijk2rjpwrEPlnCKploBHI1F4c2Y4A0TdsmD0EiqSlYPOucGkt/RSIBkKapqIQXzNdm/oSu1yvWMf45qIYF1oUqcAUJ0bQmJ27Ad66TkuBSMl4ywkKdVAtC9R2JHXtEpqxlRIS3TN7Q111/ObvzrA==
Received: from DM4PR12MB6640.namprd12.prod.outlook.com (2603:10b6:8:8f::15) by
 IA1PR12MB9061.namprd12.prod.outlook.com (2603:10b6:208:3ab::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Thu, 9 Jan 2025 17:18:38 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6640.namprd12.prod.outlook.com (2603:10b6:8:8f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Thu, 9 Jan
 2025 17:18:36 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Thu, 9 Jan 2025
 17:18:36 +0000
Date: Thu, 9 Jan 2025 13:18:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/7] iommu/amd: Cleanup some of the domain_alloc_paging
 path
Message-ID: <20250109171835.GB396083@nvidia.com>
References: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
 <405afb37-8e8c-4abe-87b0-df2ed83d8ef3@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <405afb37-8e8c-4abe-87b0-df2ed83d8ef3@amd.com>
X-ClientProxiedBy: BN9P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DM4PR12MB6640:EE_|IA1PR12MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: a4e4ee40-6608-46cd-871f-08dd30d1a6dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?leJN9pQ9Kk6/Ta0XyK9TGy4/13vjC7wpLgABI0IZfDuns923eOd7biKxHZMs?=
 =?us-ascii?Q?Qs8yspJzon0Q0uikb75emly2DoRm+OtCXeJU7WyEozKe+a06v/i5wRxi7DOG?=
 =?us-ascii?Q?/eueSAJHgWvrcR+q5or7Tb7QCpwSvM+u7x5CO6Gtnx94ikaD7NHvp5WDTQCZ?=
 =?us-ascii?Q?H0t/59Ru8XnPhlDjYVgvYcq8dnpIrfe+eG8WZbOYkxr5sDuH1lWKy6Dp/FFe?=
 =?us-ascii?Q?coSIoFv1iFGI5aXcVJTeIvGuDPS6+wSZ/9wAFvMMnoe1UHiyUcQT0QT9uUlp?=
 =?us-ascii?Q?pn0puIdVf3VYsDflPy2h/psLoaXEZ9g6P082Sb/0KSqT7/PrXxS8YEOcUwoI?=
 =?us-ascii?Q?Tpp5jmggY/tPYb+OheMKX9LFIklvIWj4vn5hosWofdIyYBlRmfpVWVVqCnJo?=
 =?us-ascii?Q?L2DKo1DCCsUGc45GuOFD8wQZJDd/c0IhUgSdwl+k3LRvajz4RuFK4jKaY7EZ?=
 =?us-ascii?Q?RDaijkwcA4ZTjH+ceBdWZhtEZlzzYiM8Y6XWW/a5EJguPr+c0uFW5XPQ400l?=
 =?us-ascii?Q?9+BHZ3//mOdCYmLe1rU3+slRZ3h9a4LB7dqNqr8hDhQMdvrO8zxqISfzywfi?=
 =?us-ascii?Q?B4TbU0JItgqeH1pDG7T8f7hSr1C041tHeBCNrtEzldKSHPwFAQGPiS7lKVko?=
 =?us-ascii?Q?y1qSHcjHKzPtJDJDp1kObkrpEx4KhnSi3MSwCwSK3LcyDeGwiZaa+5wcxUtX?=
 =?us-ascii?Q?gZGrm1nbkvK5ZZQy7JSPtc2LDSVSBy57/7QgfF46V/AmbW5VTaOoM5iVrdRr?=
 =?us-ascii?Q?lZWIuLhkBTAPnu9S0zeaeRm37z/6bcjlsUFYkL9j70ipingd99q/r2h85bvL?=
 =?us-ascii?Q?gjHhvKHYW1EdGr5mJc0mq1fZQtssHwjpxROVBASM18a73aA7NsJG7OdciW76?=
 =?us-ascii?Q?uFQA25bqPsXiJ5ITggYtERa2GTIQGLFPEEDDQ8uvm3eZj/NgVloI2c4BuZ8W?=
 =?us-ascii?Q?uG5STVh1XBqtFnhScyS0bxjIzhh+w/j+QRfJtZw3SF0V+/Zzx60tr4olLZ5V?=
 =?us-ascii?Q?jb7VcCzcTE7yzxBcdY/xtyil6RWPYvjhXHzzA8+V3fWc8ahGdP/s5Kg7bOLY?=
 =?us-ascii?Q?Ym+JjgyzAnuPEfgL7saygktozGMGLXkCFw+ewcw4iLMVNU0CzO6s9Oxh3rpR?=
 =?us-ascii?Q?KKgQoc2X1qwLknHv6jDZzt7+YX2zUT2VN4xzFvhItCtFZWoWSi8L/nXtFyRX?=
 =?us-ascii?Q?SuVP2LBcs0x6H71wxDhsNuh369ULFPijzWt29RhFSJRQQ0nMoGkb11WGyuGP?=
 =?us-ascii?Q?lQy7GxxEU2TZamx2pd0bmI5tb+Ev/3WSvj775/WuTOxT7bzMgXRgLJwURUsQ?=
 =?us-ascii?Q?NSaEol+YHvMGuyjIV20xonfas1xBWgKCxdgdFhIxED9z0Lu1E799UxNSlHvG?=
 =?us-ascii?Q?AW6+KvZwghmqBhKezeBFykiyTXyp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6640.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qv7me80924xJXZIMhzbl/Zn//s6jdDrhJnRPd5FQ/dTVQNi0a90aQ9kIXzIB?=
 =?us-ascii?Q?cYOlimfmg3oqPz5j9kphJ98iaWapyRF+BdOx/nU9fhggof2xX/Qh6BOLs3Ei?=
 =?us-ascii?Q?eLcygfkjhLueKg5XX+vS2j1pB3OfYQ4o/MepZAfp7B7mR6gTKORqAxjHII2W?=
 =?us-ascii?Q?pUgybIJqMNUNjvbWDJyIMbOc6GL+V7oDHDpt6SW+/gWEKj7uZU4hMRDfvdYp?=
 =?us-ascii?Q?TqgjtFB8Osm1R5KxP+6GbBEsF60hE3SokZ5XprHeMFtEfm//4I2GJ7qsl8bP?=
 =?us-ascii?Q?0YV+Qk4LPn3ISuDQ+R2fuYi8QLXAaoLqyF8XZgmxl9t7/QOZeTgAvPWJEurC?=
 =?us-ascii?Q?yGLEecDO/Lm96YRQDP+LiCO4O/q5CUO7BFIWoQcMOnUMkQAUibtDkfDMwMGN?=
 =?us-ascii?Q?JYeoe8XUnXRZPQonVrwAyg3AjfGHTSOs0IxfpiQb/4sajXThyvxFC0j0M1Yn?=
 =?us-ascii?Q?WSfsEFwpygLskeSdxJwq/VsBD31VGyX1jkSH+xWXFj9Q9rcPkJpLIbOnWwb0?=
 =?us-ascii?Q?TKIO5dmaerhhtB83JkSO1UpEHZrapwrVdCftBRa08ZPMQZxN9rJzNwhopUVK?=
 =?us-ascii?Q?/QiGj13j9QLBtt/xntcAQTL0mZEes+Ti3v0a8qcmoLZ5Bw7vdO3YDWUiiRSQ?=
 =?us-ascii?Q?9avi3uraLDRhPVdFTstgh5OX9vE2r2a47vSGm+5AnpipQcDBD2Gj96rN4GSm?=
 =?us-ascii?Q?P8x3VA/85ZB4Dkc4SxjvvD77huRNcFwBoDYVgQyvWY4ttIDT9HSk3pVEfA6b?=
 =?us-ascii?Q?ZNY6wQlnNK7Ln46iopmjx5H5knPElWaVAZ93TQ5MI73zubsembhK1zQ9sGJY?=
 =?us-ascii?Q?rCC95LOz6pnOlw18f6QSd2/zyRlOR03grtT4ic2EW5a522yUtvz+ILQllvvH?=
 =?us-ascii?Q?Ai67yVMsEw3oIWilSgsOsG2ijAhW+ZdrQG0OG1IHb2cV5jqNmXigBNFSRHjK?=
 =?us-ascii?Q?Bdq+x8Y1Yf3ex6bgVDnGqz436pc9usNxD/X5fm8d0fViFz8/UyZL0qe3s/qg?=
 =?us-ascii?Q?uKdBdALR9zUBtyDjl7Gefqu8CroNsrN8vnAYZOMcpw/HWHP9QYUThCD42TSp?=
 =?us-ascii?Q?EqU1eKfIGH/2K+E/Giabw5Q5ipswMjvgeKSGl450QYAcn/3iXDHOkjYfzVgn?=
 =?us-ascii?Q?3VmczLgBuiSjQEbgEDluNeqh+v8/SLqTS3ezS3jqZazut4zeGbBBdVmx9Qdc?=
 =?us-ascii?Q?UNlX1ZDvDXO6+5rFDFnJhwawgVN6hkt0+WVDMbXme2YvjPWs/s1ySWkDyzv/?=
 =?us-ascii?Q?mAPpH+H2F/aGhKBlId/lQihfXyeQZ4dFPgDfo02hvnYZn83fKWnoxihxzrUv?=
 =?us-ascii?Q?eM/QL+h2JN3Cv5QJbcMLD1PKddm+ZZ/cvMCJorTvCDdgZLrYLDP8z8Kd3V8D?=
 =?us-ascii?Q?WqheZv9aA5jZh5J018NYaor8jXuK/kMh2vvWu2DTH4z80NUYTr5Sb68APL9h?=
 =?us-ascii?Q?gSREW6qsvmm1OYGHWf+O6f97iTaqOL8KneoO/iyNX9N4VSuuWdfGsEnq36xL?=
 =?us-ascii?Q?opHT8OpcQaVxYG4bu6Kw5hjHBsMp44TIZPSH/xgLVwfalqIF1E7lWCNwODeg?=
 =?us-ascii?Q?tWW6dC2a24vMTE1Qas+NfHnR1qs1Xx4ut0zQKuiv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e4ee40-6608-46cd-871f-08dd30d1a6dc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 17:18:36.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78xq3tKAtBdZNbt5i+sHGb1p2/x2AVKvdNK3eouy6goGNmKp7VmuBn2vVU6GB7r5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9061

On Tue, Jan 07, 2025 at 04:21:42PM +0530, Vasant Hegde wrote:
> On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> > This is a small collection of cleanups
> >  - Remove amd_iommu_domain_update() (dead code)
> >  - Remove domain_alloc()
> >  - Remove now obsolete NULL checks
> >  - Remove obsolete domain types in the domain_alloc_paging_flags() flow
> >  - Use PD_MODE consistently instead of mixing with io_pgtable stuff
> 
> Thanks for the series. With this we are close to finish the domain allocation
> path rework. I have a patch to fix def_domain_type() path. Will rebase and post
> it soon.

Great, thanks

Jason

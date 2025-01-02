Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA69137C35;
	Thu,  2 Jan 2025 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735836449; cv=fail; b=Ft2VLiY1cDptHLqy0QA9IcTFBjeE+dX6VBxu7xPGj3v9/xrk6K8Kf5iht66lKhHIxvl/vYi3Barbgp2tosAjoXiqvIY38nEYBT5WR1PNOGFZxuPVJKmCS6fxp6BljZcSJwJYGwHT3w2imCrW+WlOOU8Slu5Wc7wG6AIgJ7ksf0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735836449; c=relaxed/simple;
	bh=E1s8/9fDqGIlTWwQKsldBrO/9NayzKSuJ3yzcXOoemk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hb2pywFc3h5IEumJwx2tkPMroHQ02mEaqFXFXCyyzM7wB+orZQfGVdQ8uC9D7eA4sSzQtDWiCRSLYnCA8XNoK4t3iI/GCRZFbT58jaMIx8axllgCN+OBSrJhEyOtZPwzsCyUP+OFaYJ4xNeBgZZu7aWfE3Nf5FKy5KWKGy3eEKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UeHHYQs+; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UeHHYQs+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C1Ml6y+T1U7ChRqjO9NcZHP9p0//iYH0HmGzK4H7JS+OnPZNRFWOn8lxyrMI30rFr3H95uEFs1Q6EygkHrb+0tOMeLLRjI9RUx3m1z2CgTx8FhP5UVdSz2QlN2g3HCncD5afKvemmyp1LOmY20bS6qxaXA/CuwdfGBOcYRAXBDhEc02QdQlFiREFPuQgc/uR3Dfg2GhQ+WY6aRHqdE73SKI7lJN9BN5cnKWuk7R6Ef8MpOx5t5MYQg5LgvgfNr3M2+rZG+ARJ7x59Qmc0xdJvueY1S8/VVqBUdtNCskGVpC6q5KVIunNhr/kMBO55i/C4VY0ivhH9Inw45BscL987g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iPg9D3rFDEaKI0a9Kprc1Vecdn0NJXY492opN8Vrc8=;
 b=CPJMeWaabHXsHfToUfi9YB1Q9H3TSvQCk6ZKT/eqBxW5J2duveefvlRTG5c1UzEVhciXL2C6y4ZkGGj/nH4QkiwiYsKrkxOipBjBFuD4ZZGeHcpIqU2Qo9t2zzM6Mw4xLpatZxgeJhAXOekPcDfwpM03GO43Y0tBqDMZ+usxHiU00zR9YEnr3ONgPvjwY3ArSunk4kYOYC1yccAIQyY9QZTkDhcT71LTQxgiwC+SE2XPXX7HTUa4YanFbjjjdm9IUJdRsfA0JTOfF+NSOlKdPYe3GqXQXdbsE5Voz+5Tq0K9iG8FI61tKxw7BiMCkUbrRBWFh9X1wIYM6qYRLXF62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iPg9D3rFDEaKI0a9Kprc1Vecdn0NJXY492opN8Vrc8=;
 b=UeHHYQs+kAK56h056a0TY5HriauGJl7WOVTfz+pxaGtRO8VE+n5YRaw7kb3x9s1bBJWlRG4hUqxTnA15zooXzvqSyKJOi42iTQNZocl1n1LYp1vo43vSIcIVxLWUj6uuset/UR35ZjINoBvtQa2sBJAbDwlwLCftyNExpRWpD3LEPaxX9wcrhgnCe+KJ3trU6z5cBqt34/Prhxj3fo1VSH0Ee+nXBXI7A4/+UcvT7SotJkOvsMPovsMDc/sXlMJP6Wc3g4nNTvm+E/cFzqMpY2jcwDfYE3OXjuwJ7Pbtb6UDMjLignHJx407l5nP8sOWAM6zHgRvASOenjkGEFVqHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYXPR12MB9385.namprd12.prod.outlook.com (2603:10b6:930:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Thu, 2 Jan
 2025 16:47:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 16:47:13 +0000
Date: Thu, 2 Jan 2025 12:47:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	patches@lists.linux.dev, stable@vger.kernel.org,
	ikalinowski@nvidia.com
Subject: Re: [PATCH] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of
 hardcoding
Message-ID: <20250102164711.GC5556@nvidia.com>
References: <20241219051421.1850267-1-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219051421.1850267-1-nicolinc@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0111.namprd02.prod.outlook.com
 (2603:10b6:208:35::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYXPR12MB9385:EE_
X-MS-Office365-Filtering-Correlation-Id: cccd6ecb-fdda-46a5-8440-08dd2b4d1b64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sM2r83BKP2nOqo5ieuQIixkekGxX1zPmWDdUjELVtFc7z2Ds2UjiTMhP43v3?=
 =?us-ascii?Q?tzO6rTbMoGs14oysZN4RfUXC6oJS0NglkHvC8i3QMEYjTjugtus+V0yPYbA9?=
 =?us-ascii?Q?SY6Qx1G7T+k1DOe2I6zsQM/jUeyGciX7cAZyLd/YVdGrhAd7DZmnUEc76x2d?=
 =?us-ascii?Q?s/YF9udb1WEI4oz1SxEFtFZUOhswGLCeAfJ4kolGVONBAXPCGDsxJ7sNsbtW?=
 =?us-ascii?Q?WUVHcMFTv3q84aAhQeQCnkuepjy2OiNYw8BKkYB2nRTsFJluOwbJzbty9J/i?=
 =?us-ascii?Q?JmD0L41SdVE7GDm3CDdIwobaIkhMuXTbBApNESJfJMiGXn6HhkJJGid1/7cW?=
 =?us-ascii?Q?7XY/XlsgpDNHsYmkTbZNHvFxWiPNgOTR5Um/7xIpGefaouBQvhE1D4bztAWb?=
 =?us-ascii?Q?VeXQOA8bhLWWbPOJlDCDazRY/IP8pP+6RSKsJpIOjRBtpZMkPWN4+8PMus2/?=
 =?us-ascii?Q?2LtZx2LJT4aj0iFg2ia9ONQOmjUE3pQoNzDdyh9120CGbfY9YtETyvzNmSq3?=
 =?us-ascii?Q?uy4N3J74DtQ+26BFGQxVBpebxU9c/doa9HY6P8ztvYcFIz/Jj2eJfbJ8MdBM?=
 =?us-ascii?Q?e2gx+HPweurwAvONdT6AV8cmybO9R4W8QmorWsoGUjEindAxJo5xLsBQexs2?=
 =?us-ascii?Q?Fd/VzbgvDwvqipSOB8CjyIb53HodaKc90CnwUYiouOflXm3pFwMRSGJ1Z92I?=
 =?us-ascii?Q?8w8VRIFKvZORG4rGN0vbS6bi274HOWQHpxUsECeaMJgYbgOqwfJzVpfgVP63?=
 =?us-ascii?Q?zWsH2DxI4ijWRXeSqt7GBb76ynbIcBStWiQhrY0vRNpDx9yOdR4lXvVl2D8M?=
 =?us-ascii?Q?bO2hGkG4uqXXOIqJ49Ma26lMK8xEWRFAjCyMSBz8gp38JiaTyd7uI4GmBWwo?=
 =?us-ascii?Q?dUEA8POUkOlXo8pTc2mrEDQe94CtOv3AxaiqyH7KHk8pY4Xup0DQrO6z9Nzz?=
 =?us-ascii?Q?9+mjqaWop30v0SKrtgYZwd8dpJl7w+XZNK5MidHQmS3YX+hdlhHV6OKy6IF9?=
 =?us-ascii?Q?55bLm/TS5NCMNzzQH/rE84byDK1eHLZzBBuhl7Uk5Ke7gLGm/a+xwmo7SXas?=
 =?us-ascii?Q?oJormXeBlVWrKJ8A3rbhJ9u92HPrXk6CXAtv75EZkHDvfyeoxc+1U3PZda8B?=
 =?us-ascii?Q?vannMcmgFViQ27PWjEWsQe8KIcFqbx4PNHPH/hu8oaVywENCrgfCbojjJfUR?=
 =?us-ascii?Q?Jrzq98v8/jPjwpLUnfOofM7K5BGaxAONjN9fO42T59/Np7/KIhMZYGtQFsRa?=
 =?us-ascii?Q?mI4+X8Eccd3jbfAPe9gwPfaN2ES6aCbsnQacH400aQEnWGzk2a2SY82H3GfX?=
 =?us-ascii?Q?Kki4A7sa81TbwsVsJJH0g9zOlei23npsfvMU9jwjYWfmbMd8WwbkpAt5ONJ7?=
 =?us-ascii?Q?hTmczsBqLBK92vgTpZG/FKTFPEPV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w5m90j/o2limgCWWJiroX8zAfE3xfyeFn2vIPtqkaEWmawvpJHMuqs22TK9O?=
 =?us-ascii?Q?Dsc39bB5o7tzkYP74BH4Wh4/PJVetGfPmv/soY6iv2FF5XCTNZqUYxf5BNuZ?=
 =?us-ascii?Q?Fx7WLKHsAdYzWci8IixeusMI445YmG13Vdn0Tm/U91z9XqQgC9gZX+n+hi7k?=
 =?us-ascii?Q?sMaE1HNfhXe3GfIYKwGkQb7IycQRbmCfEsDZr8CfhvV6CX1ThI3nvlaXU+T+?=
 =?us-ascii?Q?LkFU6GCEgdVHOla8AsO53zekPG6SzhVzECfGsb3ZhkDsd24XhOU4iaI+Mo2r?=
 =?us-ascii?Q?evApayLI0eQa7Fc7Upwc/Xwi3OQsnEXzv3UofnxsUgygtstUX7BRiC9QqbOf?=
 =?us-ascii?Q?c/r0t2bCAuZVoJzbifRpTD0rEsPHMn+zRq+OYO0B4GJWZGFuZvzJrEYg0Jab?=
 =?us-ascii?Q?5bmFCaOKtOAYGoMQkPCjPEUj+55YgZe+MeriAZKAzuIX0EMWWtoluglRtWv4?=
 =?us-ascii?Q?yno5HaKbfObYEzS+4Lw22Y4kxB87w9MXycWtPuRFf4fO1nTAciUI3dNYtc1W?=
 =?us-ascii?Q?bSeqAUy4f6hrwDeIBXZmje4rMQq5zruSDsR1L94OH32UH5T1ALxatpVrmKcg?=
 =?us-ascii?Q?Kr6u8eX8UAtW3s+kh1RlI+2ER1WMRaX1HPfueUkGoBnLRiCv8R1D1xtn8xMh?=
 =?us-ascii?Q?MOAHU42Wsx6GX87aJqqK024T+0pzKPGDcuB7DWZGP77PuLn09tJqZxUs74CJ?=
 =?us-ascii?Q?h8KPGnRqyTxum6tNUYCB49HLJdUC3FKOJea6sL0Tc5FUP2zSFlijGIcA6ryT?=
 =?us-ascii?Q?U2dF3Q7x2Kj7vcxOZ9w6i4p43b+afrYJcXI6AuZ/V2HKx1HQBc3xmxDfpwdy?=
 =?us-ascii?Q?G/b/bDxzN9nh5ffVI+WEHq26/zHMI4fgUUSYyU0l0PsH4j8d3FS6RE4nU3vB?=
 =?us-ascii?Q?V7p5XjFXdzf9NY1BWN6fyKWHeBbEe+z6Uo7dR3nu2OzlCpW81HHeaeMRsYs4?=
 =?us-ascii?Q?odfuKKpWZEy4aQpLe9mVC0yB9HVl++0ADH1GJ0nzs4NhSJBG6S4ToFTxYq74?=
 =?us-ascii?Q?QOo+jQe/xeE2pCRjzTbUE6FCb8XwVSo/3enGLSvRZQR7r1Z1yzlrBzbGQ1P5?=
 =?us-ascii?Q?hnEJxPU7T+ea2hLoKsAqWHz0XxldhI/VzJiaXo/SSQm2ocSkyoafNmjHqlRF?=
 =?us-ascii?Q?M1gOrrm+Evio8bVu6NUeRmpwU1KKlIxGL+SbPn4XfZKOW4OSQT2UA8cMIRM2?=
 =?us-ascii?Q?2lCn5dPS0brGKHIyt1fVMm8+O1GTrMSHYRkihZLjRpa/18BcoFDAFEpC3ij7?=
 =?us-ascii?Q?If6r0Ejiu+zTWVOuyFvWEaZcBBJXEJzCkc7jXE8P+mJmqORzo5TbifbQQ8lc?=
 =?us-ascii?Q?ek70jD/bjVy/KB/07I7TZcEZxPQw5w+BAsKXzgV7GcfaD9d+XS1sSZVq4xax?=
 =?us-ascii?Q?38mymNqy5Z+DVxge6DDGSYFZHDuoDSWM2A8F716hBUJFgxz92rUe97n/1Kif?=
 =?us-ascii?Q?f8JQz4rMjYSM33C9vm4CI1cfxzJnDP1WaxNngkgGVoSZwMw5SCrhMY/R8/37?=
 =?us-ascii?Q?ML+D2tkzvquW6IifOVkTpZmPmXqCtH3T5ISag/Ud+z8ij9FwUBC9g4oScFJ9?=
 =?us-ascii?Q?vuKaxNC5uCD98lGkwb9drtv9x85g/g6quGTOxaHu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccd6ecb-fdda-46a5-8440-08dd2b4d1b64
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 16:47:13.0358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Hi3zbv8+9eKy8DWM6qQg6RONeu5t8e/W3ZGQKz+eafKgu5ax3w3wLhZu1nQBI+7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9385

On Wed, Dec 18, 2024 at 09:14:21PM -0800, Nicolin Chen wrote:
> The hardware limitation "max=19" actually comes from SMMU Command Queue.
> So, it'd be more natural for tegra241-cmdqv driver to read it out rather
> than hardcoding it itself.
> 
> This is not an issue yet for a kernel on a baremetal system, but a guest
> kernel setting the queue base/size in form of IPA/gPA might result in a
> noncontiguous queue in the physical address space, if underlying physical
> pages backing up the guest RAM aren't contiguous entirely: e.g. 2MB-page
> backed guest RAM cannot guarantee a contiguous queue if it is 8MB (capped
> to VCMDQ_LOG2SIZE_MAX=19). This might lead to command errors when HW does
> linear-read from a noncontiguous queue memory.
> 
> Adding this extra IDR1.CMDQS cap (in the guest kernel) allows VMM to set
> SMMU's IDR1.CMDQS=17 for the case mentioned above, so a guest-level queue
> will be capped to maximum 2MB, ensuring a contiguous queue memory.
> 
> Fixes: a3799717b881 ("iommu/tegra241-cmdqv: Fix alignment failure at max_n_shift")
> Reported-by: Ian Kalinowski <ikalinowski@nvidia.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

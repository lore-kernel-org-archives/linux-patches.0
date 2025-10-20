Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010049.outbound.protection.outlook.com [40.93.198.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC16334C20;
	Mon, 20 Oct 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761001193; cv=fail; b=I55UcsE8H72dL4HhsXcargCB8VnUk35XBUMn1nBSHnKUQ5iAdl7sp4Pz5YvpC1x5ezxW9YDrj0mZ69dh7kNc31P3HWYbf6DVItQTY71DevBc4Yi6RHynt0sfLYfJRdw91xFa3pE/JxQlQbsIFFg1lEAea5u7vMOSi5DrIaWlHek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761001193; c=relaxed/simple;
	bh=p46Q+CXY4oKFsygDQURbPB0C1NTxUPAOadYT+oDjRrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KpDqTpMnEoylyI9z9QUbMip261d3Hz/TztBuU/kCqWsSpsbEfBz4ppTLmwkYFP2UA2PqF1oGeA8E2xWxoVcdnYzhB8lgXOIRT5NuJFtKZ/qvQ275MKfx3inhirEam6uqcutbwXurpink1RFKq67qboxVwyv6OwlGzPFpjS8eDhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cw/S+zHP; arc=fail smtp.client-ip=40.93.198.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cw/S+zHP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJ7g1CCboR+5xR426CCglye4ipK0OcZfqdMXbVW9QC/ZLmp+2rv1BL1JSHdVTS0nhqa94CgLMOFe2vzF5dIPuyDjovEciF/9X7EsjKJlmPhjod382rdUM9gIFTyAOksv24EZNmih4gm4O+e4AHAWEGGo7LDtaNC7j18vh3df+lXY5GiPZ8CHDbBpEIOyIrEAsJtpB3tKZ2tdU91I4gqwIoR4fFv5x1W3l+YBIYVDqQ3B8Nh1NkczjR+ExeeGGHzMkwkUh0RLwqGO48eyZra97piI7RgAHV811EUeqo069r7bRStxAZtLhN5LqGW9xgWEyvLIgYxoBxOJ/PZ/LEZ+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Me13+JgrqoWkKgJ2HE2OHADlOrB5wjQFqa6jogBevCw=;
 b=BILw//VmMesjw6XGuyLOr2goQ9JmUcM3dKuB+zOdxCZgvsL7kikS3BBE+UpuqXvIOpwlSawfMxOgwNU0z9vRyjaNjlIkhm3/iLiK8MRL4wnAWjO9fUlEXVg/HPVwdM4NjGLpWVnSjIpMd/FS+3vzdk+HLh+czUVc+Pw1s5HGk3wCYeJDzJYNTBF+7o6L3pzDA28/sd1Nca3wFStUKQuGDLq4QuP33BDMu3Yp7pU5LpVwT18Lj8ITSPJkSyC3OLHDrhAZxeMb444GQr9+lWqgoDhPuI4Ywp8jLri3HwfxeptgsktzEDu78zwnAXNYitNx61wb5mUt/UjtCM4kzNztqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me13+JgrqoWkKgJ2HE2OHADlOrB5wjQFqa6jogBevCw=;
 b=Cw/S+zHPwg9TySeUPMuB4oCgFPG1JKjwW/byST9yH5u8uH82J0z1ePGIYi1TqI7r0S1/1Cqp/Zdld0bGL46g5c5WCYfEYn6abwftI1O5/baoTTamb7qu6mvKqH79b0X50EUEVAGBhIEFsKcX+VgKWU3tv/vaBL7bm7MfM+qsTVUlKQHqhKdGLEjZDoIZdxJEHulzmi09Z2TZ+MGXoqGMPsfuyOTgSzFmEQCFsoTQfSxEb+T8egmJlGeiXoyCyUAZfGmt0Y8DHKtLMoiq3f01ZEnRG+7MB+mZHTpQeJgM/2uro/YVeKWXpRdD7nwlcjOeipsyNURbb420J6QuR3gACg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA3PR12MB9180.namprd12.prod.outlook.com (2603:10b6:806:39b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 22:59:50 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 22:59:50 +0000
Date: Mon, 20 Oct 2025 19:59:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>, patches@lists.linux.dev,
	stable@vger.kernel.org,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rc] iommufd: Don't overflow during division for dirty
 tracking
Message-ID: <20251020225947.GA644827@nvidia.com>
References: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
X-ClientProxiedBy: DM5PR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:4:ad::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA3PR12MB9180:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a4b8bc-8451-43c4-88a8-08de102c5f09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dhnPpX1IcpQxr41JTq6vAx2WtHyGbqcwuOGdhZUWdsoVY+FMaY+L7S1EuT9d?=
 =?us-ascii?Q?0o78tH/H20WUGn3dNUjllSXj9SLrMyxHpPnE0FjvSk7N9fmwyWqueSxMBHSj?=
 =?us-ascii?Q?511zra1PF3hWaKjVbE53/6ZmqZVSJARy99sb951e6/6Z9+UjD/JO759NUGUc?=
 =?us-ascii?Q?BWWSdk2t98sEbm1G2KrCjvAMokM37vmGU7wEQea6OUjeaL0iRrZsRiVIxI2C?=
 =?us-ascii?Q?YoVaDDcADuBwESUhgTQaCKhe/JeMb/J8NyGgmT+oQYOit2VksljOrC3up3Dg?=
 =?us-ascii?Q?gzZb/11DfDuTQEqwDL9Wm9EKz8LeJqfNxjWghg6Zg2J3PH1km1cIhQ0I4Bjd?=
 =?us-ascii?Q?oK8TnFNw/PCABYG6iJMJy9jKRAttpyaRzfNA4i4USrSUDFU64QTdJpQiw8V8?=
 =?us-ascii?Q?vZfNq9P15wsZi2SHEEFvLUIxxXiQPfrb5BkQA0b/eSAdmKrIht2/TZwBUVgX?=
 =?us-ascii?Q?R9iclSHcv/A4Z1LRzGG10DGs3+TbuBRW3V63YlpdZbzd1q+HBAgjXE0m3wu6?=
 =?us-ascii?Q?UV8O7fgnUr3MpvmGVCISB4DQR64YdcyYj0Vt5c3U9v3eIIZ6RrIz1mqX3ijB?=
 =?us-ascii?Q?YSlzRl4Ph7Pw7gf0mx+ftY5/yPB9DsFOJHcGYyQoAimtLjjICg2VhDJs/cBL?=
 =?us-ascii?Q?ag8Il28390XjKFVSBvcJXC5Vty6bb/JsEmJe8hq2ZUXILFupYE5ULIBZZ8XB?=
 =?us-ascii?Q?9aJFuJAkaUe2JqD8G4ieMWFM/KV3IEKEFmJN0jhXhV5UTWS+4MxScFApV+mF?=
 =?us-ascii?Q?7Mlnv6qm13RPaP7SWNcSzy/5s7OBYzuXz/hqHvoKLVXM7VnQP47iwDC+TwgJ?=
 =?us-ascii?Q?uEVEQTmrbcduOzeq7JbfUu8qymKDS1kUds9eb4yQwJkIIXN/G5tidyEC3jYI?=
 =?us-ascii?Q?MUsErpGWxyL+u6ldLsRsN5u96Xey2WVIQSt50BhbuvLY52w8azzAG5UrTSgF?=
 =?us-ascii?Q?NW7LHrQgiRRant2C9rdVrDLBgWlv2vipkL/B+BDhEY2Rg3ylSmr2A/lv6iOw?=
 =?us-ascii?Q?d/5IoFCKmlax4KrxfvdA9gYkYL3h/w5Sx5/8oQuNLG1diu3T1yvSq9lG4mMU?=
 =?us-ascii?Q?1nT7/pes7MlL829j0oGEHf6xTyqielSV/f0gDno2gBF+rT7xA7OyMReZHxZ8?=
 =?us-ascii?Q?Jg9mlDW4Ne5WkNvlKhygwk9PgSGpzt3HhgJuG9iVAzzNB9hItG8yDmkpPxZJ?=
 =?us-ascii?Q?wJBS2e2gHxjQnFu29uTQ/y+txvYFPxb1PZVOQ+PD23U5FcJB2TTgGuOfPuSP?=
 =?us-ascii?Q?7M2POEBb+0I6mUfMZSJfLfaiGfTuuqiXMDgMrixxROjItknvidrUdcoILS1P?=
 =?us-ascii?Q?H0bESagimQWEyZKyygf4mmibodKkKEiG+rdKBvpvDQYWkAVHIlPs24Xq1/jv?=
 =?us-ascii?Q?6K73+3E8MdORzGGg0V/ix6YKrrGJwEc8jElFVbrwgeLhI9sbSTE0ZKKarfY9?=
 =?us-ascii?Q?DgKcg2ssuut0a51ZgZLIoSGOx8sNX1p3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AjvgJkzD6rejGTckQZYIUslkzELbqrlgU0FZw7f01afPxxd5tuSvOdjWH6nn?=
 =?us-ascii?Q?iuiBCdoP9mSKP6TdUFSP6SbxPvYwTnTn8RGeL5LKJrZVF5r6/fQ6vHdnLop8?=
 =?us-ascii?Q?WmBdzl4/Cu1zGo0JP5zer+NyDpSMJm8UWliGgJXLILj2zYqzQsvp810ZAzxW?=
 =?us-ascii?Q?qkaMqv+bjfVtfSxOioEfkZ0uyRuYyn054dvxgFABJR+3zN9HBkf7ulBkrjM1?=
 =?us-ascii?Q?IpU60D8t6uObFBPkiGCm+NySSqEIWk0umjenBAXPtKGzGQRodruO71SulvRb?=
 =?us-ascii?Q?mEdXfix/5Ve+OsEjHcYUYoTFL0YlL0qb6pE2XyqNKdmX83TzjLRM3AdfnBI8?=
 =?us-ascii?Q?UqZVi+2aMnnT2Tc1kgiEXZk9PdN81WW8/HDTU8Zr++BnVjGPVoKLjDTm3T9g?=
 =?us-ascii?Q?yRCMHyyUj28mwBgW87VUUweuprvsoJhB02kITYex3JacMCxrj2mjEfrJMuwj?=
 =?us-ascii?Q?4bUtASke4uWW7gG/PMZgCNj353aWzDlMHHK/CeOmi6MycyV7OKsSCdSCZKUP?=
 =?us-ascii?Q?YVDrqtRZu5YTX79VPl6vUw7E92jAhK1kxB6GdVAvErfTyQLVUPzBBmt59H8X?=
 =?us-ascii?Q?wcY8zP6pmfNXRLJe0pfF464/37qxBkFLljqAdyIz5lazyjINdxzXlQZmWM04?=
 =?us-ascii?Q?+daa2MlLY0HJ+yaULNkdc6p1bVUWCF9v3j9kr7e0fgRRy4qdGnDIXPbeSfXw?=
 =?us-ascii?Q?AYrQoBSJnNC5XjT0mMVcGz9Rz0DVfQRycACZWAKRkZ6sfWf8gro7cH3V1i69?=
 =?us-ascii?Q?v7/Glemi2yNuFuKMGDC1Sqzd3IB4Zd28NCIO/txvQM5iVAkGEt38C9YAZ6Ff?=
 =?us-ascii?Q?F9oyhcWYeIpjf5J4begEaJJN6KB4FfDffooqM+Ypwf4qCIFBHeap+i5g/oCM?=
 =?us-ascii?Q?VlRfXz4CcWrntYEknK7KQkcFyJMhAPYug9dY1eJVLyTLwSVYzRUnoNnVQC4R?=
 =?us-ascii?Q?TjMSTyZfsQizWq419AQ+T3tKJta++Cx09n1xovF2SNLPTa17OvUSYl0keE0+?=
 =?us-ascii?Q?yZ2QyJY0syWcWL0JgsAzWUTgu2tRHIwHqoxE5BzufvgJUZ7aMm/1Five+KNr?=
 =?us-ascii?Q?T3qv7Lgnt5BQdS0+aN7N13IQUScoMCX5adLfzMZyFS2r2+p9BcLoFxOzCgBl?=
 =?us-ascii?Q?jrm7DVySSsy9uIvjSWIbM4K+jSsOhjcY0foXag+pUoqDA+dPYEN+Mlum6BTA?=
 =?us-ascii?Q?wcC33qUmuo53r65l2mnCPDM29Ub8trzEZIuXHkVhWa57YDu1VMlBPfa+zc9a?=
 =?us-ascii?Q?tDsm+nyfCIeY+6MkoOWZmTyw1Al2emFB0rWbDcrOEZfOPI7EPuAnIEb3FZ0K?=
 =?us-ascii?Q?ISBC5UvEk8HzuNalJZlgznD43vOggrmbEwb4TwNR4FlwzRbZIiPRKA+VbTc6?=
 =?us-ascii?Q?fMAe0Q1ySKRwttISLItljV4U76tyuvLfMVjhsHm7AOO9G0Gk5wdd+g6L8e8d?=
 =?us-ascii?Q?nHOkN8tuDb3vbnyLeuMYRvMpyH7S/1IkLxqA7I/f8//S+HOg4LdZVQO1888Q?=
 =?us-ascii?Q?w0rIwho5bTzTVczGU5SUqo0tITiulYPvqRK0cI1WwKeiUm+Br+dLU4NSb4/z?=
 =?us-ascii?Q?030cFY1+/33sHPonyKcYe23H2MSPDsll76cRt+QX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a4b8bc-8451-43c4-88a8-08de102c5f09
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 22:59:49.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoGTOU1syhuolgwkWO1eYCb2SaMohwo909mxDyqV6YieU9NfH1mHDFFqFN+GyYPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9180

On Wed, Oct 08, 2025 at 03:17:18PM -0300, Jason Gunthorpe wrote:
> If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overflow
> to 0 and this triggers divide by 0.
> 
> In this case the index should just be 0, so reorganize things to divide
> by shift and avoid hitting any overflows.
> 
> Cc: stable@vger.kernel.org
> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
> Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=093a8a8b859472e6c257
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/iova_bitmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied to for-rc

Thanks,
Jason

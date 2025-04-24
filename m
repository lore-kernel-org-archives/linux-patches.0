Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922332F30;
	Thu, 24 Apr 2025 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745503580; cv=fail; b=lNFEMd7S3EJR0xEzxT6fEFK85zGbjJJHzixIUUQ7I1U+Nh+8zJfSBCnrpgXiYaXsSzNm1jpLIZk2+2xB8Nk6FayV80aFXrC44qTZLVO2+vBnNgQeTcr8xTgrzQqa/3sWHHMTRZU8hj0RqFvVpGOsSDibxWJd9lv64PxUmGMJatc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745503580; c=relaxed/simple;
	bh=6bv9gzwb8IBttYGWaUCu7wPHsg62F5ZvnHji5BlkWlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ncL638rODpDXviT+QrS1IkGkMCpjiz6IYzyIxdPo2LBh3Pq44lwQSfbwzDB/PmhvoQE+XVpJROt2SbvS1/LiogR4IC2qFnjDGEFtDOR0rT8QJy/uvkk1kLXz3MyJswbFkD4ZEp57zJuQxggvwXgwd5tK3eQjnHAyDapejrtsTbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fPvYgd0r; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fPvYgd0r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEn+HD+iO+xJKpYUMBEU6MH+NnD5W9K6Hn6dBl3n8RnaO8fyoEkd6amgPj4MC0RoKb/CoMt3y2n7M9GGExBIWlfCBD7MRySVtwJR6kcOPTrvxWbV2j8ZNG8gz3F8Gu2+MIgs/Gn4k+Kyi/XT6mg9g0btLk1GvHvPym4kw2Xmm8uBIs1w5b5t5Pbd6JHVIybc9dfIQ59LyGR3HfBltFGdkDYDxiYCUM4w5dFVaAbAXvj9jZeQHZFi2wfYU6Q7231y51PcCELRZrk6gNT63Qmq5Dt1wioda8aOAs8LDO285kHq/PI07OsmRCagIpA9uutzXAAhUON7iQuIqP2cP0hX4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eux9qTh7dsnH/ZxjWJl6HK/SffC2XdQMKguL46G6FKA=;
 b=Y9BHZaf5oyfQxS5pLdoZ5+nGE0s3ghuln7HvooCSp+VFfR+xgFxKbM01boTLIq6o4Fe6ESeOsx+neVrrZJnIALr0xSeulLk3S2W62bheZ/+J5Tf2Yq/uRe26tYjJ04vUVoBtZXF3PoeeRaDXNO4Abwq9LFK4pK/6VCUKpoStr14Ia5Pxi6W98+8HgG0KyqOub8tZa5dlsm9LAP2iVlS1tAT0+2yu0sLdDVtECOL2QRjgCObREPddhGk6v6xIEgqjfCRvafwVzYhmgVIyOkMr1YcD+rsImf3w2sWUYFi1qjL8qSD0YoAYm4O0eVNxxK1nLlvFDjh+HXjYzW3dGbxsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eux9qTh7dsnH/ZxjWJl6HK/SffC2XdQMKguL46G6FKA=;
 b=fPvYgd0rfQGUvSU2f7qO7x194pKXAQ3MI/Od1w5A5NsFzyeQzfBV/jTszt4jFYLgyCIwyOy9uN/jhlP0/F53BTHAil5LPNjavXULJOfzk7HTUMCbehAABO7z44RO4CfpA2EidEoVGIBQpLwVRmx65Eftm5kxQ5buAJtMsHP5tx8lgbUV2TjxNdPHLQ1UQ+OZ6Bjuut0wQKYx1bISEpMejXsAkq6W52hx0qv9emEhO6Nzv6K4ATF4jH45KA+Lnk0QmjRqNtaGj/XKOFpuNQntqbWVCC3eiDm59buaqdFHC7NiKGEzl4wSKX2e/PmETEs3cEcIAtgpYoMX/4aB/Gn3lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS4PR12MB9681.namprd12.prod.outlook.com (2603:10b6:8:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.24; Thu, 24 Apr
 2025 14:06:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Thu, 24 Apr 2025
 14:06:15 +0000
Date: Thu, 24 Apr 2025 11:06:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <20250424140613.GR1648741@nvidia.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
 <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
X-ClientProxiedBy: BL1PR13CA0143.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e84dbe5-6413-425d-d51a-08dd83392d31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jiv0RRKjFr1daPxYcqMTwWpmF044QFNLmNZevuXBwiHxsdtBg7/6JA8O4h1r?=
 =?us-ascii?Q?8gDzH7wdmFmJ3zXUyPuJZezTmsGiGxjXTPnQMUp5UKxa93eIAcVfdwK/6HoA?=
 =?us-ascii?Q?j9lMBbZpHMjDFKy5vTS3HWMJElbunghiWN7+5pncZj146P5drjLb60XtxX78?=
 =?us-ascii?Q?zZPoWow2yq3boMsh4SQjXSkZGEfUqlcIaf2KyVcvkR5gedbvR3zamGxbJyec?=
 =?us-ascii?Q?H7jtelG2cxtGro25nXBtvGNXG0tOhQR+q/RgTYDYpb/Zg0FMp6dINoknaZdA?=
 =?us-ascii?Q?7yaWt/VDrRcdYq6wFPCAo2AyZszc3MXWhmC0O+8+4FMmbb6sBMrppen0tOUf?=
 =?us-ascii?Q?gY2lZ4ADq8rz3p2hot4QNTw4zZ+dVrRDu2XfECJ2NDvqi8KRjgyiZuZcvnUK?=
 =?us-ascii?Q?yZ1+I/0EHdHeOR1CaRBG59OSUtTX4lH6c8hCCnPWyUOvOt//bCOtU17jgSVQ?=
 =?us-ascii?Q?CmA8Jf3WPv6z4UVSJGGdrkYjyczj0yCNlIcmJeXTn1s1Tcj2nCnWI8YfJv5I?=
 =?us-ascii?Q?orOsGYrJQIUzdMk2FpZplhaLjdHb71VKKhhKHvDQrG8Ux1bmCiqnA42QoISd?=
 =?us-ascii?Q?OfwnqqpOtgywCjewT8kSy4cSFnPZCmPn1BOckxK2vzIbJQkaDlzSAUeYeiKS?=
 =?us-ascii?Q?utJD2W9GkplepxRxX81GSa8diptt41yGk96DlULRN38iFmuZm5dmlQ+XMH9F?=
 =?us-ascii?Q?U7YBCGZItc2kAsTesVnuT0plDaskqdnmLRQcYzB/UC6psOewEObzVBez+MqJ?=
 =?us-ascii?Q?z5NYiSp6Xl9XuvFvsqGTGIt6irskU7EQUtYESOuLBLFXKleLjI11CvxbM/ZD?=
 =?us-ascii?Q?QoMjrTnLjVZAbF/WRIyGRcCQSaBz/BqQvN4yPfbR3/7jrPPjZUQmiqEv4zqm?=
 =?us-ascii?Q?hx1Aa7gZ6i1sJ15wNg4QFz0tcPb+1W8pKT0+2Kg5Tz4EWeugMHDodJ8XV9hn?=
 =?us-ascii?Q?pmkTDOWxrjRyl5DhtXmUyzTjvZHcfj3C/rNzmL5ubnBXAAcShw9JLKIIJsRX?=
 =?us-ascii?Q?MKtNmyUEiaCCruciYzRtbcghW2jLjxhZoO1LVc6Ko+p0PDJduMzBabLMI5BF?=
 =?us-ascii?Q?qfm/ntAsklV3PQcjLQVQ8+jcFa2Gb6s1Gg5FVv/O8GtUpcs1NfBEOZxV37OA?=
 =?us-ascii?Q?o01LsS3YcKJa+3diUeVleO+b2e6k5lpBSLS6vu9vj0cL1z6/9PByk7UBl4Q1?=
 =?us-ascii?Q?gymFcUl4UBvgxLCdjAfBmbWtEQZvQRA2kvuUhHNhVaPyrIgMzpBn3IdxG7YS?=
 =?us-ascii?Q?kwdqUd28pWHnYLJKsy4212MSSDx0Yq8W23QeftcHhn+8o1LGhuqpZKPcfEEL?=
 =?us-ascii?Q?V9tujFFCfzYbhTgu2RHhwZEtV5CfZICq8xoNSJbQNUyJZTaF+HI22El7GiSi?=
 =?us-ascii?Q?kuOBzcstAiyVFzM+r2oeXygdF1kIPH/KJRKd6DdRdycmSCW+7AUyYrJytwXY?=
 =?us-ascii?Q?8T35Iji6irU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Z/MvmSU/QnQZo6vPSEgBtSfnqfPDwd6HhHgxboMg7h/KFk2pIEvwBBs8wXC?=
 =?us-ascii?Q?zG94n8pudGHev/xDrf90enp2AV+aUjS2StoiItyXWXez3cq7gTiMMI/hZKs5?=
 =?us-ascii?Q?AjBiT2Ho1JtZdgPR3qnuJm3TyHKtsE54lT7T9OehyiSpnT/iiMZvqxSobBUo?=
 =?us-ascii?Q?zDXgKGHrZhE/BGoggySpkmYYLltN+MoxWKATKWGKlQVOrU3+QtCWyty0LcLZ?=
 =?us-ascii?Q?Gcx3b2blZrZ4GgXpWeIbosqa4H+QVNM7uR7ebtYmXlyohrH3Tov66lAmUaEO?=
 =?us-ascii?Q?IV+PdMgUWto8dJUEyE63G622yXcHfDK/aYuJyl/NQfrsQS+L8VBmYGZDXktO?=
 =?us-ascii?Q?oA0uBW0toJIdpYzs54fK18FS4SADZGqhirPWN7Ys9D/v0Dgh86vbfjpJv3Nx?=
 =?us-ascii?Q?eqUEyJrr3T8Khq9f2snhnNQGLbki/mFzAGcnjClyotv9oXshZ6zpR94raiJI?=
 =?us-ascii?Q?dnfXWZrV0dRUAPH4/bIPH5sXFdrr8B9xLpPw1KYFYNemtOLF9VmMjjav619S?=
 =?us-ascii?Q?ZHCLNTqWE8f9LyNOQqP4teODSdE0B+djMRVg7vmHPe0Qd6KdNUkPDvpUR7pS?=
 =?us-ascii?Q?BcEd2axJUsJR55wzQ1Q9pJ0CdxLazjb5Gbx9xZ8gUcKdI2D+NaEm6qt8vCkN?=
 =?us-ascii?Q?vNcLMyp1v1+tVYsnlQY9tMYkGhF4NvMIxC/HtFt6nflTAsrVfrskwebEQPbr?=
 =?us-ascii?Q?C2w59m6+kXDFTvHyKe43AMaFO4oRFxAeO2rma0DD0ZQk1FUc+1pZILhdb9Yr?=
 =?us-ascii?Q?Xq+jDzUAXEY4Cj9265ExmU8Zd7oA7dJKMVfRlXP+8f8QYxtefmEh7PGOdt9T?=
 =?us-ascii?Q?Ddkc4HHwmtsOhDqyEiPs6DrcjMIhx2U9eWAMoUxiFMVZeWIkFxJUebAhYldK?=
 =?us-ascii?Q?XOppf9MZ4/4BL/nV1J3tIYbkL07eiBPvkqNBVMoiC2StH81/lXu1HUU6p6AS?=
 =?us-ascii?Q?gTEbqxQeT6Z1PMV+vEiWnJCl7RjNgvDZwuhWVQ+fFJ9XSCwnB7UqlbwBuZ1H?=
 =?us-ascii?Q?rtO05pkNdFTnWb3GsIHF2M9PCpJLD7j1MX9jsJYMR0kCyRvviWOle+yENRZ1?=
 =?us-ascii?Q?ZJzoHaJBWObvttx5aHaBsc+QoG01aJgyPTVmeN7ooeFxetDwlQ+LZKOUxf3P?=
 =?us-ascii?Q?ewWn/oTCBu66JdZG+ZqRWoqhu60xIKchhXESXBchicUN6OidTRMu4XnPDzbZ?=
 =?us-ascii?Q?EUo0wKaEOvU2SvJ5aMzeUd0xbijBX06XUDUvq2w2wQU+m0XpgrdfgT8NQB94?=
 =?us-ascii?Q?7Jz5hOhTRX8qxDMvldMYdfMIaxnDwuvZ95VdeI8xatFdr8SMi1NnWbrzZf+7?=
 =?us-ascii?Q?0kx0YHPpcEjeZs6sceoiy8ni/k9LOe2OxVwLV9hw2H4GuRUYD+yP81LpTZKo?=
 =?us-ascii?Q?oz08X5zJcGtuu4KNI2G+Wc1lLlt09qzFa/lY0E0jsiPQprNgJpzXNl9a5VsQ?=
 =?us-ascii?Q?VWQfC4rcQeFfOT/NJbvYKzbyxBpvgrerFWSkjX1UAHZ5d8bOghIcNM/8Jq9D?=
 =?us-ascii?Q?UbNUZAXJIEllUIwSWpq8EPVy+Ky+OQ1Y+Ier/UbqFUUzfiqXDX6Sk9yKz/W4?=
 =?us-ascii?Q?KBwATh+W4WKIfVHv3bP7h8UPkKn8TsnWhvhJBUOa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e84dbe5-6413-425d-d51a-08dd83392d31
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 14:06:15.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcY0b1Xy91DmOfZ3iJMnNmClV49Mj6wm7C33J1hgaW1BaW4H9i2SS0eFjUl6dRIC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681

On Thu, Apr 24, 2025 at 01:26:21PM +0530, Vasant Hegde wrote:
> Hi Jason,
> 
> On 4/17/2025 9:51 PM, Jason Gunthorpe wrote:
> > The AMD IOMMU documentation seems pretty clear that the V2 table follows
> > the normal CPU expectation of sign extension. This is shown in
> > 
> >   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
> > 
> > Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
> > would have three regions in the page table: lower, non-canonical, upper.
> > 
> > The manual describes that the V1 table does not sign extend in section
> > 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
> > 
> > The iommu domain geometry does not directly support sign extended page
> > tables. The driver should report only one of the lower/upper spaces. Solve
> > this by removing the top VA bit from the geometry to use only the lower
> > space.
> > 
> > Adjust dma_max_address() to do this. It now returns:
> > 
> > 5 Level:
> >   Before 0x1ffffffffffffff
> >   After  0x0ffffffffffffff
> > 4 Level:
> >   Before 0xffffffffffff
> >   After  0x7fffffffffff
> > 
> > Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/amd/iommu.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > AMD folks: I'm just reading the documentation, it would be good to confirm
> > this understanding. I'm a bit surprised nobody hit this, but given the domain
> > aperture was wildly wrong up till 2023 maybe it never gets exercised
> > carefully.
> 
> We have tested this with 4 and 5 level w/ some bench marks as well as w/
> forcedac=1. It works fine. My understanding is IOMMU uses bit 56/47 as well for
> address translation.

Yes, it should use bit 56 for address translation, that is part of the
page table architecture.

The question is what happen if a device uses IOVA 0x0100000000000000
with the iommu. This is a non-canonical address, so I think
architecturally on x86 it should be rejected. I would not be surprised
if some HW treats it the same as 0xFF00000000000000 - though that
would be dangerous.

There is a significant correctness issue here with ATS, the IOMMU
*must not* allow address aliases to exist, so if it responds to ATS
queries at both 0x0100000000000000 and 0xFF00000000000000 with the
same PTE then it is security broken. The device ATC is only flushed
based on the canonical IOVA, so any aliases can remain in the ATC and
trigger UAF issues. This can possibly be triggered by userspace when
using VFIO :\

So the question is not about if bit 56/47 is used, but if the IOMMU hw
is validating the sign extension. Assuming it is validating then we
must not tell the iommu core code to use
 0x0100000000000000 -> 0x01FFFFFFFFFFFFFF
as IOVA since it is not legal IOVA. This is why the bit width is
reduced by one when computing the aperture.

Given the security sensistivity with ATS the sign validation behavior
should be understood because I do plan to come with a patch to enable
the high address space for iommufd and if some AMD implementations
need to block that we should know :)

Thanks,
Jason

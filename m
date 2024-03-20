Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA933FB3F;
	Wed, 20 Mar 2024 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938780; cv=fail; b=TeCPkk4xSRDw13wdhQShNi/v08uAL/twleOlP0eCAhY9g8ypJToo766HX1jBukpR0I7r4XT00MrdMCA1aevCAno5I/wZkhF+wvsYL/ELB7/C5fmZ8klOzbhQwDqxwpRBFUWWWdqC/uQDVjjIDf2HSe02QA61cBtbVMeJQ5N7Be0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938780; c=relaxed/simple;
	bh=lfoiicfOkYLgVJgXp3TT7zCYOVL8W/HhKO3TCH2spV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VtVyeQM374R04/hVUqS4QeDOt0tlwBMDqpBdR1h7lda+dXHDvnPbox5nE6mHQw+kXqjT/0PBNuusFMxJZnaOFdbkdQAXHXxFK10TkcR1e5jPTYZfNbBTOCQpdlWOfifcJySfS7UGp5vzP03EArEWhmvmyBTWS+thfU4jGC/evRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CPiGktnl; arc=fail smtp.client-ip=40.107.100.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CPiGktnl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/E67cWuRuEs96qkFISscmCaCcczYbAs3ju/nv34X+oSAfFytIn6fc1vqvKubwLGnPGKc1tTtSktPxxIDz2/7j+2DDp6RoWy010Y5xFAWdq0i1T6GsCk0cBHEzN8gVMhEwNViTMxuUvE311378Od4vbpXvZ8V9MyNPQTp39812qFLi/0cZ4ZTnavoTcCNB3KoOsTsER4CP2awObQoMGXIq3dVdYMGH8jTEcmZyolksBtM+ufRTmQy94KuZxRzOPQ1bEWEq/0ahy51U9A+xq4Ns+swLlZKh29Qdgj88BiwK+Ggx5K95Fs65W1qQ2k9C5vC8Q3zQ41CieiolylQPgXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eh5dyNhw4y4eGs1DNnmEPdfltCBgLCt4bWD3QtmIahY=;
 b=UyuwW2hjmEYuzGFr07xXdkF+p+zNxTKhBul1SdOeWPjwz3WArrJYpVUXvPmtB/6ES1jhLUcUfpqlhD6tLdmcoVRAiUOIN0TJ4CtUVo5qdaGSQPOibk3/ts+ZfWbyoCK0sNin8z9MfJjq25mF4p5CewCvxR8Qxz49J6U6ctBkt5vqtbyOcgFS3ssiAG2MOYWPZUFTQvw3jP2A7P4q+1pA5emT3/R25o/57YqdFuZSwYkk+wj4KMKIgWkAdGpXOr/ywb/Pq2rKhzH2RJp6ClvwAu3XJSZWMk441bv87VUGHe70Iq7AmuZJu3t6VHcBkDrXfw5s9hZHU53cBhSRRsU20A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh5dyNhw4y4eGs1DNnmEPdfltCBgLCt4bWD3QtmIahY=;
 b=CPiGktnlUfHXPnuq3LF3okPQxsNOoZSQylblGHmeDPKNJaWjP3yFxqaAx6YoEX6J5bOjzqH4p/BfNNSlInvMJV32XThrFfdkDBL/PJeudv11sDFQsjwqwC63KLZ7Fa1FY6jw0aRfTXBhdyPbv9Jg/OVx5ebRj9mNv2x0SVA0AaPlF+SrQ+8HUDtfZ4C4j2rddYWucOMopxyElTe5Gml9pMhFIbcVjbiRd3D3ThEkA0gfs1grag7oVCvTVD2TC48iH/hiEvvFV5gLPInaFyVhXPEOc0dDnasv/8wzI2x51c1JKvgO4uPu31GTW5/nE3RuuJO9xn6Z4/EotHH4Vc7vUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 12:46:15 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 12:46:15 +0000
Date: Wed, 20 Mar 2024 09:46:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240320124613.GA1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfP+S4CfTt2qvD6X@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfP+S4CfTt2qvD6X@nvidia.com>
X-ClientProxiedBy: DM6PR01CA0010.prod.exchangelabs.com (2603:10b6:5:296::15)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BY5PR12MB4083:EE_
X-MS-Office365-Filtering-Correlation-Id: 02bb6b77-5098-4ee4-5efe-08dc48dbbabf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mvYjCmL7UMhttrnF4sEYIZ9wTtFNeOcmoO8ffNuUIVqSK7u56ZsdohBudfLIyiYYxrPN0vdE7zLc2Za4tKnoKDfzEUrVRFfj25Zvk0gNWtVm7slhcKWkFSRrZgHYdyKEpVnz9jDvh1495MFYrQ0ZO6RKjWbjmud+1iuyq0GhDIAJMOCJ27MLyA+5QavnJODAVxkSU4hKk2bcDcQGk2Nw721StXPrYl5bMOhXK1f5GS3xPCKtLHv09SbHJttp710ne3xrMHoiWJH1g0vyssV30JxIcNmzrkiNP/SPDLEyRPQW8UeBCUFcjqM/v7sBgXUJiXENNYbI2u+8GjkPx6VWZnVKfxLzAmGpnZ/vK4otltup0FGfx6nfL5buLyqkya5JjUVV3BKopMytQqDoVZB1ZOp/UiSj1ze0BHoDLGnZuSXMEMFE9jjlMPz6+78KFja0WChLPymq9po6LGVBc/oI80seZcmSAvvD2I0OZeeyddblygWHTEZCC2e11sQfG7sGLdiPB+kTQCDkGpAuvuGrmv1gSUa6aH0G8pyxdMdVGmVRrN7/VeK/qlkE8Ytdxo/srlN1EOlgJqqvzdq3bY4G0DfXz1350vGBHGDlbTP4DOD+eRUySto/QjDT9CcWr6idVKjXiHuZLV8+JhY1HHxorHgdnqAben0dSz2Pj6hvLbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TVEXBNna1h0/nXbaXMh6x8XlsF4rl4ayMbuvuO0mPjK/na8sVUnXGkmLenst?=
 =?us-ascii?Q?PtahGWl0FCh5y/okVhYoIuemuguqS44l23D7XgXX45pTs7qaf60F0RwhsjFV?=
 =?us-ascii?Q?fY1JlF5nL2uKR5RZNgU6NYHv18U/o27pW1pVscflV9D2e+P4mvq2qmgD9mOq?=
 =?us-ascii?Q?fMaFMrJYCIWcxxvn/tLLJ9BmTwxCSKG6njQochSNYyaUfvpmZb10tihFxYAl?=
 =?us-ascii?Q?q+o4ojAHuRZwU3eQnOeuRbfuFXZT5LwCqtZ5YktKMCMbm9+nrQESSYRRNfvJ?=
 =?us-ascii?Q?JX8iQyv4R2c+fbC4GcE3FpC8IfscLvRMJXxxdBMs1AmRJZ24kRKUGMYXxz3U?=
 =?us-ascii?Q?hiSO5rLUkG8TdteZZAs8DaLwuOLTY3I+U5wrExaYsVZm0LtpEG9b26sBgeu8?=
 =?us-ascii?Q?N5XezP4u1xKcdLjrab19Y8hzYieWCAki3h1jFPaYAmijaxbpDV0V1d4t20l9?=
 =?us-ascii?Q?gENiDD5SR3JfcCkFn4/dmjAXUYN2tBmhI5TAYrqUIpwc9Eg9Q4UOAIVishlc?=
 =?us-ascii?Q?IwR0rm4iXd+JN1WyYZwjzvzuO4a0TTwrX0xNbX80jjlE7nkq2fAWoP66/FjW?=
 =?us-ascii?Q?kiFNetcNLWACJzF3prk/PqfFq06wLtAep4g5qaey6PXp8AuL9lsdvUE5pHz4?=
 =?us-ascii?Q?K0dhDVtyd4s6wHTlakEN6QhzA6P4N53dRX54+th6QQwt5n816KKglK62wGZV?=
 =?us-ascii?Q?jzlDsxGVYOAIizgI8KPDw3YgjmL3morV6RdnRR6Lryvik27V1YsjkkLBGhRP?=
 =?us-ascii?Q?uXWOEn6/NzcAR/8b1DxipOdM0g+WB11VV7iW8cPimZ8s7KZ7WmvICSwOY99Q?=
 =?us-ascii?Q?+OUTDLGJyT6XoydMwRtq32nxfQFnUgc4wNbhcoxofFrzS6YUZFkVBFl2+JdR?=
 =?us-ascii?Q?YYliXt6c1do6iDabrNNOilQu/uvIh6Y0rX7fomuN4xreOPXwoiebkpZEapgz?=
 =?us-ascii?Q?2IXMmcS0OxDP4wHPuYcv2BJa1Cwb7/AFBlSV7LKuGurjbZGpJUPJgBbAj1yW?=
 =?us-ascii?Q?3Bo44ycj70jzxjy+YZGAMnR+rBbyE16OvOwwq2o4y7Z65chcy4PtyICdt1+l?=
 =?us-ascii?Q?9TiXQGnIor3SMpcO/GqZIQLk2dxWyVRUcyKFWg3EtgANsNIkhWB2X/eaqrgj?=
 =?us-ascii?Q?SlB4R9+hO7e8Sy1qL9Gpqy82WrzbERdR15Ufxp9q8fFmOjx5LlOxCUNVy+T0?=
 =?us-ascii?Q?bWBuRxJ843rJpt0miyDo6U9T9YwjzUq7DHiiRc7sniHPqNUJ2bZkeMNuPBFl?=
 =?us-ascii?Q?Sp3YxSIWYyghUflpTMrSlTf3OIylt/1hd14yQKsKB5ryGmSzXnfZD46GjG5i?=
 =?us-ascii?Q?fRoiYEGfnMQUneJXULG7/1uekIE0Njjm7LtwfRVwri++jNq+BK2EwkE18TLH?=
 =?us-ascii?Q?KahPz3q6uWWHZ56NUa5NToqcFGG62peh+BBFl8Zt6tPxMtInOSVxxYow4MDo?=
 =?us-ascii?Q?ewZ1YbKiJNQf2ZktZC2VHRGnmaAjJOpC3YnqUCLHQz/ESZtE7GK90JOBYWnB?=
 =?us-ascii?Q?MLmmpGpNj6exgaRCSujko7pydDO/gvW9SI28Woox1JDozaGoQOMO08u7xyn2?=
 =?us-ascii?Q?f3i93XAjtqnO2rrWtjmt2zgGiovcNQ3Odtba36vS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bb6b77-5098-4ee4-5efe-08dc48dbbabf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 12:46:14.9789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ma8sf9RVIFUltu39ZRZ3xqhrV4swFoR/5ngK99EQZ2hRnbZWJBcUj0zFF+HBCWGN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083

On Fri, Mar 15, 2024 at 12:52:43AM -0700, Nicolin Chen wrote:
> On Mon, Mar 04, 2024 at 07:43:53PM -0400, Jason Gunthorpe wrote:
> > CD table entries and STE's have the same essential programming sequence,
> > just with different types and sizes.
> 
> Hmm.. I somehow remember that one of them was 4 qwords while
> the other was 8? Yet now, in the final driver source code on
> the smmuv3_newapi branch, they are both 8 qwords?

Yeah they are both 8, it is a mistake in the commit message. I fixed
it.

Thanks,
Jason

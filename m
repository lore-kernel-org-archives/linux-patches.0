Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C609A2D;
	Tue, 21 May 2024 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716313921; cv=fail; b=OJT1J191UZBBnMWErOYVG1n4BZ1ozU/+HXabzRb4FMoyCRyNF8ljPcMKgpwqfiFU8KDfriF4czwGgRLQNnwfGAvO5cL92qxZIbg/hq9rhLN093VqMbo3+08KtfJaDbbfZ0DwHYggv+cO4ydYgY9cgHRXqD2x+KCypPg4H97lTKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716313921; c=relaxed/simple;
	bh=ituFn4eLdwFyigdgGfp+r/EgHFmIL59SzCfjbj1PeZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UpKKRDqV9Qi30v0gih80SVU9Ssh6/xvvqiw44YZ1FZcKGJwmnS0QxonX0EpmHQT1KZW54Olt559di6m5OsqmrkhquN0ezKnif26kyUuTdg5wCX4bLIf08n54fnU+qMHgbwFKlNf5kLGSk9WHI8jQbjlCgVRDKOaFGBa9OrKpgX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gKxWf0wU; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gKxWf0wU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3XArztUhbrsPfO9palUVWVpdjBfI8fI6bXVBDLyE2zCd+DkBcBKPqbDySZIE6CjU07zUYEHgx3csF4PLjj/vxlY/ulBpcL7X6uSI4arkt1SQasGr1QHcWdNCf5QdVYm9TXyG1vAV8jDfk672kRuKEROwTi7hXFiuM66ph7cQ0XIR3uPfKW3M6OoHYaihK4bqBa5fWbeqjvmNJa47xHJy1jprS9sB1SZkzppGGoThaeJw9C82NfB3KsFbGww0DnQ7fJKPOeSk0skxILCyS2XNbWHoeVRcsfY4rp3Et5ThMhHK8eWRZJTDNPXQels1LoBTSBzdT0VsJx0j8eoRruMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1PMyjf85UcidlbQjjMqmxdpLEcYyAqlRK/+6rKLUMo=;
 b=PaHqF0DISdMwIq1zPPJpSU5OjDfszJe0O5TOPaC5UGL83/dPRLP5Onm4652ZY4cTAykBNJiyv3XZPlZkhikMOB4o5gVCgZbeuLv7nX+EveH6YPHkt+ZT8J4SU+OxvmJHXlfrEwVrwzI2UVc1yu0wDqszM/pi1KM+crVYAyBIjNZXhXg+ylAsRQuwNUEjmDJIkLFcaUtrC9gdIax2SSKZ4AnAZNk2f/LVAe1+DQS+9Hnh+zUxB3c598G5Yt1MkEbTUPvBxZiwhYMiN6rJnk0GHHghRWkU5/+Hg0MY/NyHni70QdQC6cLt6d/Uiy5mfI3cci7HW2P74K9M81XEM3DxBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1PMyjf85UcidlbQjjMqmxdpLEcYyAqlRK/+6rKLUMo=;
 b=gKxWf0wUyv1biPG4gSiBqCqUn1PAJpW235fcAL8KJQyvIoVK18s6crNOB1GYWWANy/7D6gayysHZ8CWncyB6+oPwsr2B1FkDZ7SDnt1ZzwCBJkp/m2Wd9CJ02J2lQzHCdngbBw8XY+hv4dzjvXGqg0XwQLBgkhq3pCj1ZQT7piBl9ltaUKBKrKxvrSEH5jpKPxZcvny+kM/S9SDbDuUYFe1pCo4Hr1VF5nap3n8VbplG64yF6wOT/LwV2Xk9/iAsI+kCPtcyhZZwEHF3afYikGC8E4pRwfB2KMSLSJ9bGzTHZ+C4SjipmfIjyW4XwS8WH+Wg+PkJgFSXtzqnbdaRgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17)
 by MN2PR12MB4158.namprd12.prod.outlook.com (2603:10b6:208:15f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.18; Tue, 21 May
 2024 17:51:54 +0000
Received: from BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe]) by BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 17:51:54 +0000
Date: Tue, 21 May 2024 14:51:51 -0300
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
Subject: Re: [PATCH v7 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when
 RID is IDENTITY/BLOCKED
Message-ID: <20240521175151.GC133219@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <13-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkHP40H2xeE3cyPB@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkHP40H2xeE3cyPB@nvidia.com>
X-ClientProxiedBy: MN2PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:208:d4::44) To BY5PR12MB3843.namprd12.prod.outlook.com
 (2603:10b6:a03:1a4::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3843:EE_|MN2PR12MB4158:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb48c16-89ad-4fc7-1065-08dc79beb37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x4p0gDMI/FHUSmRCUr8VgOgjdGeEzh7zoI0jQ7gYeWM/+DWSTPEp/iWB4O3j?=
 =?us-ascii?Q?WJlhPkkFC2Kva1bgIAKzjr9MInmi4sk5GJN6Apuo+R2KSzXBbJk78QrT/zh6?=
 =?us-ascii?Q?izaRTCS2vwCrMj36947q+Q0WF1LuvX/RbOqBvdlFDCH8L2z2E4rgqoe+SGf5?=
 =?us-ascii?Q?rv4Slb1bu3Za/RwX32Fmkv8BmQpDfNnm9a31fNZ8xncMNEeuFg4z59uzqawc?=
 =?us-ascii?Q?LiLrJdyxT5h759i+/5xgJlYirpCMj4BCJ49lU4S606eygONlRKiMpMlzYLlr?=
 =?us-ascii?Q?wtnEi1qbT9LsZEmaqEN7ZDkC4CiVWAm3bpelvb2IvUxiseU+PGnWBcjmiFYa?=
 =?us-ascii?Q?gwu7ktQoIRDmtvgN74gl/oJCni/OCNDEecgHUAE4dXyRWRnBRpxq5O9s1EK7?=
 =?us-ascii?Q?VbbPXWeECNqp3KMAblm1jnwt507gFOzRChiSaj7l89fh8sv599YZDctJbLho?=
 =?us-ascii?Q?yyx9Ez+SBUlIyLwYnpMXrV3VSBezPE/A//eiwPIxTS3l6OJ1+9HagLGKo4kL?=
 =?us-ascii?Q?vmlPpi/Yt94lW72Uce52gbLS4HSI034IiQ9WToZzdihVlvMF2732LdNW87l2?=
 =?us-ascii?Q?6fZ0hszxwIjxahkRJQ3odrrFfC54+EU24lmnDciYWITQwwrvGqFudmpkOT7E?=
 =?us-ascii?Q?PDtGZl4n5V/LJITUgQKu2Cxa8Q5whE4hFUjdYCThUmy/FJH2+d45rIKGl4ll?=
 =?us-ascii?Q?b+0D+XKXE1n8c1HsXyDPKZn1hqmU4Kz04HyTp1Xf2mYipZFRy3f037vPCc7x?=
 =?us-ascii?Q?TayBHeFu3OzOco9lm7f/bUTNkCn4FDw/nwLubaIk3frT6Lo7p5Wjfb8WOedh?=
 =?us-ascii?Q?ibz5RhRxMsEmItKJkV8zBNmm3vZnAUudE3jTJY4x5R8Dt6L9axvjKg95dl5/?=
 =?us-ascii?Q?E0jDKZJeL37EOv9PEKlK4NTWMLGbNAauJ3nYcnEmQkPua4s2lLl5wQ/fwhWb?=
 =?us-ascii?Q?JUz1GE5awPmLwzfSMhF5Vzxm8y8no5R2nY+bzvryHKPqshDatblCyDFWdgdr?=
 =?us-ascii?Q?BYxcMqD4DNVCDSliGXcQsrnjr9n4j1oUCINlnz8PSQHNqonRLSFP3JXwN8bV?=
 =?us-ascii?Q?YTBgkUvxrpGccjyu2dcI6zDX9CsuZsrD27Ws9+QGn0n5T1c2kQKXr5VahU8M?=
 =?us-ascii?Q?p3OipoKTTU2HJrclUE/crCEOb+qLqPgK+EQ0dtgfxIRa7HIimqQPiguGfeMA?=
 =?us-ascii?Q?aWtHt6nJVGUDPHyC4lgmauZSyLjNdbXkHxcsZpIgvbzUCygP6jicxZRBMFnx?=
 =?us-ascii?Q?KsAM4yf1pIo5CvC02h1L2m2SmADopG66DsVsovJxng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q+5/TA1MQOjAQa3Sf5BAmdCT6dfwdl8kDprLOHwxpm1bYCBf+dlC66NXHBYp?=
 =?us-ascii?Q?XgQ9Me16dVVQd8I1dYMWuYbsF8xmemj3BZsPD9vpfeNS4NWE3LjVOYmQFP0u?=
 =?us-ascii?Q?9K/zme+yQnoMo4uqx+AVk0frvd84ul0MpPl86V+7dIpsY4E1aXbvbmAQmC5F?=
 =?us-ascii?Q?CP4H6DItfU2rqX3WEcLF8ToifiBr+JJzSy5Aal9pmsOO/2KcjVpgUWN25eBp?=
 =?us-ascii?Q?fm0OVfll7gw2DQereyyeRy+PUD37lO7YKOibxA9ft93KTkroyyPHHHsqRTy2?=
 =?us-ascii?Q?H0eZu/9G23G8Iql1tpdwh1YpEUB4BweCQPymxQQKIvQ6168XUPfqcpgw9HCi?=
 =?us-ascii?Q?y+4Fy9sM2Jm/Iowgo3bYF8gY2FWYmlg8o1WxH6uwXhJkQLmgnw+lvKQeKTn8?=
 =?us-ascii?Q?qi0GaB3OJmLZdFGP9zys0mgJrhfMwGYj8yNtRklGtq76oh4fnsOMl8ynTbIX?=
 =?us-ascii?Q?rNPeGjrfDXkSiKg1/9xjODAIOFNSWafPTeQuAekzuq4IL9fCk44okpelEbuP?=
 =?us-ascii?Q?joKyLFygrfkveZwgvzcYDZ++AGk7xLPiddIc2g/c2/u02mUF+Y/Dj1FH8Jjy?=
 =?us-ascii?Q?wg6OvHVH9F4arXO5wMKu3+PsaC2gBwVOTJ6jbroKMrmTAPT48cDIECYwhlcP?=
 =?us-ascii?Q?a74yj59LIh0b/pGmVWM+ZDGDeIeg/o0aslI6eLlA7no/NunHhgn+OYCMNXc0?=
 =?us-ascii?Q?HnkI3Fcm3r8d02WuTnDBLSKzFxxJREGI8keQsG3a0En51CprZQrmQ9Ej3PIH?=
 =?us-ascii?Q?zDWeKejlT+6cYhbh2bejKCYIBAJgpdKhyCOQkU/RAS4j21s8J/e899tkX4Wt?=
 =?us-ascii?Q?Zj+RQKLMGyuXvBDqGx4gq625x76ATH+F3QHhEYBriXZ8Pi0EKwTuR1veYiqh?=
 =?us-ascii?Q?gaBLnYsJv3a8yn91HalUtASHwAfNmx60ex4NwVYTGtY832jz0abq1L/oqsqx?=
 =?us-ascii?Q?aiT2k37lhyi3RGYg/c7RGG98UNVKWzytJndo6ZpV8MnzUMdqGekO9hxdJeEJ?=
 =?us-ascii?Q?vZFjmjtVegH47hoTfGE2xCol/uQqzWnS804GSDAUZYAQFlry7G6vxlryg1Ku?=
 =?us-ascii?Q?XKDg2wiO079cDnPEaa5kk0QxQ2NFDCCGnAQZObo+nS+1QBElPikTdS2sC/rR?=
 =?us-ascii?Q?W+AYhXRnMTiD0B4/2AHdwct94TLxdIMqfNMkL/+Q5Na8ChwVDIDff/CHkTZC?=
 =?us-ascii?Q?ih3ycUU8o7IlIg8rL/6/qdOPHkzOnlrcqlSZuyHhumwo8hCCxOFJts/I0n9a?=
 =?us-ascii?Q?uSB5lgsXa5GEF1IGVWQvQFy9mSuyxN5r+ZPiPKUx4xgP4wWs7D4n6HnKgvGr?=
 =?us-ascii?Q?7CT3V68WuK+XhTnAx/l8OQmhr0zBCXQWYH7Osz1HYrlt1BTmIVrG9/kho1Au?=
 =?us-ascii?Q?exAgRb06QLfW+mVob/KMPyrmgGiBQRYSiPdBtoQXL+jvdK37Casmi5bd7DJv?=
 =?us-ascii?Q?0oIQaMnS59heSQXNLWnUo0MBgGWYg/hlF2Jf2A4hQzTa7XIGg3wNzg5ugKjj?=
 =?us-ascii?Q?BDaZ95SeXw/ygtwpUU2Urq0y1oB4CIDmuKltcYnSbi3LGX3yaVX+3PO++3c2?=
 =?us-ascii?Q?bA8QenKvHgCuXjOL6+Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb48c16-89ad-4fc7-1065-08dc79beb37f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 17:51:54.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hitdqgGSP4RXGdDxgdiFlNXMN/gCY9w84j9gOx2un4oACxdUwXOn0l8nwwoSNwr8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4158

On Mon, May 13, 2024 at 01:31:31AM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:21PM -0300, Jason Gunthorpe wrote:
> > If the STE doesn't point to the CD table we can upgrade it by
> > reprogramming the STE with the appropriate S1DSS. We may also need to turn
> > on ATS at the same time.
> > 
> > Keep track if the installed STE is pointing at the cd_table and the ATS
> > state to trigger this path.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
> >  2 files changed, 49 insertions(+), 3 deletions(-)
>   
> > @@ -2819,6 +2851,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> >  		arm_smmu_atc_inv_master(master, pasid);
> >  	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
> >  	mutex_unlock(&arm_smmu_asid_lock);
> > +
> > +	/*
> > +	 * When the last user of the CD table goes away downgrade the STE back
> > +	 * to a non-cd_table one.
> > +	 */
> > +	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
> > +		struct iommu_domain *sid_domain =
> > +			iommu_get_domain_for_dev(master->dev);
> > +
> > +		if (domain->type == IOMMU_DOMAIN_IDENTITY ||
> > +		    domain->type == IOMMU_DOMAIN_BLOCKED)
> > +			sid_domain->ops->attach_dev(sid_domain, dev);
> 
> Should we check against sid_domain->type instead?

Yes, I typo'd that after some edit

Thanks,
Jason

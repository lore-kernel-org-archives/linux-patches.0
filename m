Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62AA2AF09;
	Mon, 13 May 2024 22:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715639328; cv=fail; b=eG2IpiE3eYkFq7e3+jgrAvtfwEQyM5XBd5k4D7oc2UxxuUOCqwbUx4U0ujBofKjSetkLI8/UhqecDCobkt7Z++xldwh2gKY9rJkkf5zqVblfng1aMSTfwJbHhHd0+pgExYBori00PyCt6EpNvH71JRbxWYoR8d+khc8Ko4R/SXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715639328; c=relaxed/simple;
	bh=sisT6Ax+qLZcuddVe5hL8CWRd0wLKo4OaVNhSFt+DYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XY7ONQrLm6Fj7qGC8i2I8slcZbR+GlUi9pNLJaSysH8OvrTDpfPqB4jc5pr/GLS1Tx1uboKxKSv4WMnRc/2KXJHY/jGC9SRnwI4RTIoAcQzPReWu58QonaQdk1fHizBrxmn/76Klp6p0UocGVTBvakrBiOxUjKpP+G8C54ps96A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gg7/8Cfg; arc=fail smtp.client-ip=40.107.102.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gg7/8Cfg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnvfjb/YjGOxXn4MvK4b9RyYJrs7bXjC/y5BzpCM8NwVFEvM5rvU1/aN/9fEtVq+48AW+kAMLkxTL5n5CDYS3gvdik/eb5xgQjgZgpm84YXWobPm8wx7ToVxLbTnH0RlFnR7z68tPgu1mdba9qR8TXB9b7rrx6bJz32F/LhIc9wSb3NymIS8yqhktZmS2N7CGP5sXSP5+mnrEAqtTj6dfdd7t/w/snGREmwQeUsIhHxWn8V90BTcV/oWzZ4ne3K3EdiEN2BSpHsWxeUTvFsPFHMuFUF/y7tb1PYAbuOidh5DN8VKNXJQs16bepfWnfsS2Lymf+b+gu3F0tbr9sJwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FCAXjtfLhaf64m5jSLsOl4kh22DpHjJ3PY10HLy6Rs=;
 b=Yzg17yvn8oaMTFSkqWKdc/rzwzZr/D8bjAmyPB1Lzn6TC9/C3wv6pPLajLKV0tLe+fLSP5TC9t7CMnW5mkfMC2dUrWmeuc5wIdvh4XEEXJ6McKyG3WREsaNuO15du/Xq/5OyOH2QpiNdmFNPGtwb+ujw+sjEY6ll2n59h6hptvALUlNCqBmM35jX5SvXIAT3oFQyXPw28+6cri0T1HEmR/Dd9LzRvjYrbBFU9TAflEFy4oHpmhpK9i8+qurdOqMzMkQoF2u+D9+YT/K/cZVneDl0O4Ldz5RTO9iIeB0oVPKJXAXtIuc9cRRlRS/h8sO5z1KE3Gk9M15qNDGLSRQoAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FCAXjtfLhaf64m5jSLsOl4kh22DpHjJ3PY10HLy6Rs=;
 b=Gg7/8CfgcLE6WaEf0nQQg/HQorZWu+fjCq33P5W9fhBp8y93qJ/3qaoX4rHzYZtHG8V8FxHXeXGkUBD0xmEXJLNAscvDKAiHf/cHSlB6Duh4YAOfz0p0oSDRgPA6ds7CIghr8vOY1YJJeiulimHVfiQ5ZNVhTQ7PDpu1drnpKVWF3rfuV9nlW4r5OIiETEzDnBXiXBlVYd+qr6b9YIKTmsISAnwhPjLoPXnfbI3J1EZPndNgsY9YCPDckxz+l/NIeRME3qVJu33c8elp8kA+jxLoHl6ZlcMngvHdVn/Uj2pCWABJvj6i7g2H7W+kvRyYmv0RViyMFwK1gnTln4eogg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB5709.namprd12.prod.outlook.com (2603:10b6:510:1e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 22:28:43 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 22:28:42 +0000
Date: Mon, 13 May 2024 19:28:40 -0300
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
Subject: Re: [PATCH v7 07/14] iommu/arm-smmu-v3: Thread SSID through the
 arm_smmu_attach_*() interface
Message-ID: <ZkKUGMhZ8fAmtnis@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <7-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkG0FYhhqSW7Zmt6@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkG0FYhhqSW7Zmt6@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB5709:EE_
X-MS-Office365-Filtering-Correlation-Id: 19355e42-9c66-4e07-2735-08dc739c0b6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zoq7vXu16VDEhuUgdpJJI8V4GjOXZt9l4dzHTEnJNari/RzW87FEOK2oq6UI?=
 =?us-ascii?Q?XWao++AWYzERRodBX4xvPTLDprjjoXE7Uydh3rTPCSd6flrV7kb4KjHzp+X1?=
 =?us-ascii?Q?0htMo0lh6c2HnLL46tPKzbScsiys69Jmw4gDirMeifdGp2wrafEDLaw3B386?=
 =?us-ascii?Q?H3J1dbjTDeGKbepwqY1xFUbu3bYv9a9iDeqTp1QxLyAXtXQoAWfdbZBgf0Wg?=
 =?us-ascii?Q?3jrqv4qZoT9ph3I+QwEmHEH/3Bid3HjhX0j58KpDokPggxa79h/h36jjIhBV?=
 =?us-ascii?Q?Pk0J8pgN/pCw+LjgjkAEk+NJwC533t20APjo15wOcZbUR9L+JSmge/dVEgoN?=
 =?us-ascii?Q?OQxSZM5BBPSzzz6pj+gbPPGKebi2OECB8n2X40HLTbd0osn1k6aEliao5eL2?=
 =?us-ascii?Q?JpklPM66oydG0vhNaNvtv7iuLjnzC+IH31TqkcJ1sF9o0g4bA1fuvrLeDRMr?=
 =?us-ascii?Q?SfMJz8lZ7CuMk3GrxU/LTXnOtDYXwCv3U4mmZ7UUswjQSTtdrTOFnfyRVS7s?=
 =?us-ascii?Q?41MyRsjx2MEBVfEEmgGGSa/h78KzyNnH1LFgSezF45l2ig+N7zDxT/PUJSwH?=
 =?us-ascii?Q?utLk9yG8Qk8/ik+J+YQQBAGt2msG8MT/Ie5Pbbv4aWJHiHvLDTd6DR5IOmgQ?=
 =?us-ascii?Q?PMsGpyoT8VEHoTtBsnEVdtgTtMUEll8OH6kPaIBdL+GJGxERDMVFeTZZzd0M?=
 =?us-ascii?Q?QkcXafxLOa5f4gi9C4wCbMfuG2ewOfSq0six47BXZfGb+9ORi4OdVnghJHVq?=
 =?us-ascii?Q?sI/yESFo4PXaFPVDu1U/T27RmJRUCtOmK5bC5vK1zENuT4JuVIfjFgUChvQU?=
 =?us-ascii?Q?63MHkaFu0rQrHWXa6Lk4e+1Lyx/w+a1QWFlpnxSEO6oBQpajjtzffzYGV+9f?=
 =?us-ascii?Q?40nVW8VZ3ilXNeFeJ85dLRQzp1KQ4pXwSkxkMVxruK3M6bPtKFhInY1TR4r/?=
 =?us-ascii?Q?ufq+TOZe2u1hD7Q57VitK5UVU0gH19AF5uyFSauEwTmhgC0CuZNogmGfMG3v?=
 =?us-ascii?Q?WiwrnQ5FWu+ZYggZnOMD8z4KQ2ftuAswas9VLvtGWNHUtKWZuiiqJfINZE4a?=
 =?us-ascii?Q?GCVHVEANVgnGxmS+Vi2wbWkTpyeyFa4WCas10U4OnLkwAypjGW8o8GH35KAN?=
 =?us-ascii?Q?ehX/RynVgnpFPEQuMeq0KoUOxJYyoANxmvYvsYIhdSCjXzP44uOPrY3p2dVd?=
 =?us-ascii?Q?3zLcEuCxT407CXTr1LnkipHSMVZyrfkqfIViz2gLI9/aN749sMAYi+6cSrOR?=
 =?us-ascii?Q?fTIEwlABDUMJYJO24p0/Q0B1oUJNqDVEE2vNkazvpg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nECZ0Ha9p0r3UBC5JaAtc9wnOYZRRdvSI5TU719/wgZsGNxt6rq5Ivbuggbx?=
 =?us-ascii?Q?dy0qecVY+7LthJpkrrg36qEmkXX+c7nxNSgUUFtOQW8meKxw66fYg+TxBfwv?=
 =?us-ascii?Q?D4PeFnIpYVtbXUqcryppFnpOX4JnL0or0lChvPBIFuxMQAwQhbPyK84impg3?=
 =?us-ascii?Q?yXTC/so4dQmMdrqIRLuZOaFK2UrsKNPhcLSR30/iwLo/Jk/vaVB49Xbr73kT?=
 =?us-ascii?Q?4oDtU/5Tv4fCKOjAZiAKa10Y3TGq2y72x38da6mnym7idmOsLH5Nlh0tVRXP?=
 =?us-ascii?Q?BKyc001+4lr8SEaN1o+L3/yF/XkgGauP1HaIkB2f7y6G7sYnQQL90GO+z7zv?=
 =?us-ascii?Q?eRhxjpI1Pjliwt7E/ognzpcTCgKuqw1OeCzmNJjPnV4hVdi0BOfhQMbPhGx/?=
 =?us-ascii?Q?JRR9yCbRfV6JStgJcerFE8FysEYnJEscgmfuvklioAfdcw8L6GawE5NKiQV3?=
 =?us-ascii?Q?DSmPD3IJnTfSko/YamPLyfsfYnKrfzDjEJuWKSXx9EXh6y/C1ZF6a3Qf3DDq?=
 =?us-ascii?Q?FDxvvtxqjtSB44QXDEQjX89rle22h7U+ReEZKMoDVwm3JdPIOhh06B+x4atA?=
 =?us-ascii?Q?uN8Oiif8gEs6+FBqKbp50nCHxKF0oejS3w2bR2pmd92MPvoiV9toLj75ptIS?=
 =?us-ascii?Q?+g2BQU+b+MMG7D+vJSyZO2wStYw5e1mis+8w29JisPvdzk8Co8Oz8/7Ni9JM?=
 =?us-ascii?Q?c06nSuk8zqpUZI9yQDN/eUAf9eFq2hIy6wLu4VsOD4ree/FpyTQ9ViRnb3Vx?=
 =?us-ascii?Q?ulR/SGB7DKO/2ZqrKCnDaa9wnmnBquo99hA6RVc2ct5EANy1uQuYsiZqlwyl?=
 =?us-ascii?Q?xuC1KmmD4T7FHCy+jnlmRrRjfyljSIuiNQS8kd2ua7ehfoT1+Ogxhvqi65Oj?=
 =?us-ascii?Q?gV8yndxxHQ44MQPhIVRT0zn9tR4wU7PQYcS5NfSyodyYOfiSAZMRKlS+7DOz?=
 =?us-ascii?Q?lHsy7pMv9zSwGAlICaWkRHagia/aePkt5pe/p3+rJcZ55z+QF2NViyKovsh6?=
 =?us-ascii?Q?lGpLTFWQNjLd7zDRvqwy8ZI+AM+Dn5LNYXQUYTssnSDwO4ebgfpUNvqLBmD/?=
 =?us-ascii?Q?D19iE2rfd0lpjRoYj/7MIFKT7h2DFNx3pJIwxBE/8392NrwjF+4uJAnrDV/l?=
 =?us-ascii?Q?mXZokZhLkYlY5ufbiBt7kOdL28+lJcrmRTiWcd3Y8TFa5Un+ZoFOC3kCvsWF?=
 =?us-ascii?Q?CYP7laksn449biv2tlZ94zThNatjtDdEm9BZsV10VHbgijzMoRM1M2COLoPu?=
 =?us-ascii?Q?iwGk01YuEntaoGvSognn84GK7nOs6AX80kYF1Irapk6l6alOcQxX0SP8ddnK?=
 =?us-ascii?Q?6P6lnKR3+LtXxc5qeRoC/kqaiNF1r+pQStbUAALUa3Yt4NXmDZPddu+w6Fi+?=
 =?us-ascii?Q?bFEi6hR7Amk/apswRKO7Cq6SlU6AHfj7KCwJ2lX837qyEUMy2KMi+55XuP1/?=
 =?us-ascii?Q?S8/vJVLRSvtEPa8PsT/3u3KEgnZAn7rF08Kr3TuuAJb2PDFI/Jg0R3onYXmF?=
 =?us-ascii?Q?Y3MykJtWuk+9WsqqeD49JeM+o+SMZKLi6mb5YRKryMCcBBuIRYwCGFy+wuj4?=
 =?us-ascii?Q?yTYJK7X8tSI9kmE8/g4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19355e42-9c66-4e07-2735-08dc739c0b6d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 22:28:42.4770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2EMwUfqQYQN8XfT+Ooqn+7x18SaCAuQy1MEDyu0jcNO7cCklb21uKxzHwQLQtTw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5709

On Sun, May 12, 2024 at 11:32:53PM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:15PM -0300, Jason Gunthorpe wrote:
> > Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
> > through the arm_smmu_attach_*() family of functions. This triggers ATC
> > invalidation for the correct SSID in PASID cases and tracks the
> > per-attachment SSID in the struct arm_smmu_master_domain.
> > 
> > Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
> > ensuring the ATC for the PASID is flushed properly.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> > @@ -2689,11 +2692,14 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
> >  		 * SMMU is translating for the new domain and both the old&new
> >  		 * domain will issue invalidations.
> >  		 */
> > -		arm_smmu_atc_inv_master(master);
> > +		if (state->want_ats)
> > +			arm_smmu_atc_inv_master(master, state->ssid);
> 
> Just trying to confirm my understanding here:
> 
> In the arm_smmu_set_pasid pathway, ssid is a valid pasid. So,
> here we invalidate both new and old master_domains using the
> same ssid/pasid, if either of them occupies the same cd entry.

Yes.

> And...
> 
> > -	arm_smmu_remove_master_domain(master, state->old_domain);
> > +	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
> 
> then we remove the old one here.
> 
> Though the flow makes sense to me, yet I wonder if there can be
> such a use case like this where an old master_domain is holding
> the same cd entry as the one wanted by the new master_domain?

It could happen, the API allows it, and the short lived double
invalidation is a trade off to allow loose locking on the invalidation
side. For this kind of thing we want to make the common case of
invalidation to run fast.

Jason

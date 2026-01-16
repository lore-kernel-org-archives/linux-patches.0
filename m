Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E32281341;
	Fri, 16 Jan 2026 05:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768540399; cv=fail; b=pBizlVvkSkCQjzK4f/Oks6id/OmAeLcImWr0avWlM3xS7xDr13u2+gdTKx/iIL/d14vvMGcWxgeyMa7wJWnytgURzOBhVv2Ri9PJvO7eV0bdR7XzxP8Bjl+PTohgTXh40p0osN+mBxkUlnSTpB/tfvRbwNSMdOCl3Y+077nf76M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768540399; c=relaxed/simple;
	bh=UwE9DQT1C+2uhCEToFIuw3lVoWhlAq4413BxWPXGWO8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJ1gVrRGtXsniXO76cvpxX8Ab7MBnNNJ7Q2B3WS8bFunNc60jZmq4ow8V9hnOpRWSSzTkY4+jpmK5csehRXhvctQ+Rz/ROHheXlJ7MlCPqxJvmzKNjQcIScliATdfPtVQ8UrxpbtEqXO8h2RdQamzc2qOUqa/G+2IvcDNYv6IeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tkPRojQs; arc=fail smtp.client-ip=40.107.200.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tkPRojQs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlPllsnAqrn5kYuvsO0F+XGMg3IFSJd+PL5EpY24/0Dn4+neGmu6J1SdTKI9k9bWf8x2QHnV1oGRbrs1mSzsr7ijW4y7A0xpH5d9UzFFg88QUz+L26TzJiIMZlJVjpbF/lM17xTcWW90F/q9R3d2YsFlJRyDRC870so+CeoSZe8DF933jQ9VLmBQIfSE5iOeCzRHGFzj/4kB8cAvSwXo0HjDeRsaVXFNKq6UIckkdXCll/wEfWEvsSoNmqud6XwAgFjzC/ziZtqLFrKNlfVm63ieK09TDCOtOuIuYcRyGljUm/ESCYDUvHlt4LduIoem3MSxRGU7qPzf7h/dcgMSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2+WGO/HFetSSYTrEJqM2bd7N2y6y+tuzAH4k9irIoc=;
 b=IJOoet1TbwzRE3xYvDQ4+sIMKb7hvdYmfJ1G3+j05RWRNgvXLvbfRpYRg5lRzlaeToiWMH/0E7zqQEpivBQpT52IdUqCCmpuBUSUx3yOrS6kVK46By49Bayh1gJujl7Oqbz3Y2zxT9wR+l2rBnb+4TCrOarAg82nNpO45wrhS/NSy1KRqLGTXIs9RCnfMzMbube9FKWmI0OVVdhkNzl2eFGjNkm3eCsa1QcExVkF02kcIG9sbXfokoo442JyZUEp6oTQuX0iBtJxeq3ZB1sdorTXNxoXEFy/eBq5coUnpHeL4g63IXvdeF0uUCJs9cX0L3DzjfgXMDeOlnk5UdS6Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2+WGO/HFetSSYTrEJqM2bd7N2y6y+tuzAH4k9irIoc=;
 b=tkPRojQsXCR4OZnNNlpJyr7cXl0gqO3/SOmwB0/SmqS+4TIjX7ZY33yMG0xwPHLRFPi+fVIxNrStW/nzzzTF35v820yXQKYXNOxHN4+VRC7O5s52VSf/hE3Qkvwv6w+vnv/15iGdHZomJ+e1T/y4jiverimJ/u6EKeypVIywJCplr923alkUWvJ572twzTNFnCwtTt2CA2KXaKk8RXTGlCq6HFKZfkIBh+0COKTldh2nDomfmoD2SxL1lFu8bjSAV7SbpeWxP6dINphj2oOxMecP6Gl7JY+lt8ZwmQrg4SGVJyTxQYg0EhOfWpYnaGHu8GUbOJpGoKqE7qGfpg5uog==
Received: from BY3PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:39b::26)
 by DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 05:13:13 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::9b) by BY3PR05CA0051.outlook.office365.com
 (2603:10b6:a03:39b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.2 via Frontend Transport; Fri,
 16 Jan 2026 05:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 05:13:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 21:13:02 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 15 Jan 2026 21:13:01 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 15 Jan 2026 21:13:01 -0800
Date: Thu, 15 Jan 2026 21:13:00 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
 <20260102155715.GC125162@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260102155715.GC125162@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|DS0PR12MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e701bf-eba6-4e2d-78b3-08de54bdf2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bLa9w4LE510I33lp+V1sQC19tui/ENB3Pn9GhzoiqJqYFXxwbt10tZRkUVeY?=
 =?us-ascii?Q?+fhZBwAKuFbTLCxf/ujphneS6mAtGHddOCwyB9qGKeOY1hNZfk4bowockRmT?=
 =?us-ascii?Q?viRs2PqaOTseDO16TkgN4IGN12ZwwRezX7xquGsrp+T5EsuMJMHV2WDUvJO6?=
 =?us-ascii?Q?MII4LANMWJg5AuZgZz2/9nn0T3+NeYLcXma4b9dpJV9hglbHeao50aHhRI9k?=
 =?us-ascii?Q?3gIow5UBj1+u7Gf4uoRjidsT8gjqM1I0bZn4q67YhC/Eva/vIdCKsikhAZ2d?=
 =?us-ascii?Q?zQvjxTBkmbO1Kx8k65R3z0D1OBExaefsSpaNZurDP8xh8Mz5PPKrxF8p1I08?=
 =?us-ascii?Q?38FrieLzmGRTOEPA170cNp5WojiiwEVqs7l7AQ4kMSmJwQ6CwtAoniS45K7y?=
 =?us-ascii?Q?RiIlOMj01HXJvFZexmCfP9ZPvgipzTV6G3cVnj9aK4l971yPoAreTrWvO3SD?=
 =?us-ascii?Q?+fYAOWOuyzmxDQ6iI3cFEh78eSS84OUl1VsKWQTBbpRxfRpHmqUvdv+9CdQu?=
 =?us-ascii?Q?/HfC23sJs97i1B0NzUeVWC0wdqoX2wF9gYLugB8JqhZaQtyMdh2pFh8LAlqG?=
 =?us-ascii?Q?B91pNeFFIC+KC62mfq7som3n6m5NJi/ED4XSXGia0MHIp0f+Mawm8sxHPBdM?=
 =?us-ascii?Q?6gGxPjpn1DOz4mUKb/vvbZCeqniqTxMPVZ63M9kCsxfwRkuFtpuCJQzLZG0P?=
 =?us-ascii?Q?6CZ0DDMlqWD9BOPvDW6XBGm2hLSGegG3Q2TmCZkKdjLIP/akJ1a7RoQM2ky8?=
 =?us-ascii?Q?VvgYQKPI+JV9AQLhrm18cOHRsXuGdouxUfHLfKew39EUuYfQWVoJSrt27Q/i?=
 =?us-ascii?Q?DwwDiGLuNIb6HxM/nS/ENi2b3EkwemLUjetyeMY9vCLBe+AY9Ats7baJhwd6?=
 =?us-ascii?Q?f6cWJJ278lYsaD4LpOwaF5FPxKBbQX1/carktcYJvyOJEpPwisyD5Ie8ehAA?=
 =?us-ascii?Q?GU15r1WoyssBd8PEdfMPOMtjxbJlvi7HdzYJ/cyBYZRDG7wlXxjULa/x4G7W?=
 =?us-ascii?Q?ItdOI2h0xCoHgZbHgibEJxfUlnQC3+IkFO2MmDlt1Li7TfbhJgRpsCnBF7NC?=
 =?us-ascii?Q?0Ukia3MW7tE02ncLuIIbpJQah/NlADOI1+iuisgN25+o70Lnjn746RnLRlyv?=
 =?us-ascii?Q?HBnbDIzMBARsaMOHasDkTjyk4tRVPUUItVtF2vZmgGCDvrZph9zB/EjceXVd?=
 =?us-ascii?Q?/Yt99OSMkkf3eE1/yPcnW071zWOhRinpFHOWZlpvvKDYUTT/nvkGkwJJwBrb?=
 =?us-ascii?Q?BWptPIIIIao58J0eudBhBLZnPdPJrH3gbSLiMDoPXmJ/eRT9N/M7egz+A6Hn?=
 =?us-ascii?Q?9fXVJXlzRuf1qWcispMZGgiScv31/MvcF650d1G5Yt/AipepVvnKj40ve8rt?=
 =?us-ascii?Q?55MqifrkN2lc2Vv4RmxCBbcTrVf1EnwFxBdTyfyAxLFE1gHXx0IjVQhRakAz?=
 =?us-ascii?Q?kRrd8a3ll4mTVzVetUIvqunowbhNsTc7NLfRKekS8v9wud5p9uI+NeYDy6SO?=
 =?us-ascii?Q?fuGAW5z5mFWqKxm6k4J6Rd/nPTMhaAIw9GQZU9jaX+Gnb7T4xIOCCykAmXnS?=
 =?us-ascii?Q?hHa223osFG7kgrSPvhPHD/6o4VHP6tvDNxKKZ/q3AnS1UboUT0Ti2T8Obv8Z?=
 =?us-ascii?Q?/eVHzcHkQ/TcfiybUMoK1ETS9RPUskcnl85s+STBxIDczncweVuEqXxKaJi6?=
 =?us-ascii?Q?p2MulQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 05:13:13.1673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e701bf-eba6-4e2d-78b3-08de54bdf2d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7558

On Fri, Jan 02, 2026 at 11:57:15AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> > Hi Jason,
> > 
> > On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > > +			    struct arm_smmu_master *master,
> > > +			    struct arm_vsmmu *vsmmu,
> > > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> > [...]
> > > +	case ARM_SMMU_DOMAIN_S2:
> > > +		if (smmu_domain->nest_parent) {
> > > +			/* FIXME we can support attaching a nest_parent without
> > > +			 * a vsmmu, but to do that we need to fix
> > > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > > +			 * of a vsmmu. Probably by making a
> > > +			 * INV_TYPE_S2_VMID_VSMMU */
> > > +			id = vsmmu->vmid;
> > > +			return 0;
> > > +		}
> > 
> > Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> > return vsmmu->vmid to share with a naked S2 STE?
> 
> A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
> impossible to get vsmmu->vmid.

An S2 parent domain should be per VM. And a vSMMU on top of an S2
should be per SMMU. So, it could have stored a list of vSMMUs and
device attaching to a naked S2 could match its master->smmu with
vSMMU->smmu in the list?

But, it's probably not very efficient, so I took your advise and
added an INV_TYPE_S2_VMID_VSMMU. Overall, this looks clean to me.

> The only domains which have it are nested domains using a bypass vSTE.
> 
> So, if userspace attaches a bypass vSTE then it should use vsmmu->vmid
> 
> However if they attach a raw S2 HWPT without a vSTE then there is no
> vsmmu and it should work like any other S2 attach and allocate a VMID
> for this domain, ignoring any vSMMU that may exist.
> 
> In sort, the only case where we use the vsmmu->vmid is for vSTEs.

Yea, I think I got these right. I have all the code reworked and
will run some tests and post v2.

Thanks
Nicolin

Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B813D68;
	Sun, 12 May 2024 20:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715547266; cv=fail; b=Jp9MxUH+fzYS4FyfCu4gyHBzmvtoNH6HIPc4VY8u41ELvN1ZQksswGr2tCR6woQ47SC1enMbPy8zaZKlRrWi68KxEq9+hKw0ve/bR9IdMYwiyIdxnj46U+So1KLRBIkknRaeFpfuonsuRr4qRc2FQ/6UUTqFS+S1Aev7T0szaFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715547266; c=relaxed/simple;
	bh=n7p+Ldis3oNVYK0tSbe6pLlNuvmnFE17RABXvm+J3pE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPvRuCkE71flKgv8utht3dJyOoUMIC38GWE7X7BSUcTbaiDFb0KKr4v2bB36Y2LndgJ4GnUrmLEMk8cCecbxesP2lqsBAl/RydPtYHinT2QoO8DgBTZikvsyTxEWJNtrHdp2lWvw/0RC3gTv8cRQy+PC5W6Drzw5j+vNSCIwkjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F2FrqpVJ; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F2FrqpVJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atntFMydu3VlKaWSp3rPmWqifbMEDyKKUrSPXZqn2MT/CNUtKPbFrRxmu7GNMHe+ABvj1HlqB706BaHHVxmWyIXwBWPp8gt3m2u/QngEcYuEXauL0ROS2ZeNc1C1H3Y2cHr+YzqyKP+UptvUMmBOe0fWCYPQIJSCt3KHWFKwTDLNAsna2ljIW5kfakpjfOjhk8LxdRDUwmG5W93unvLGOw/LuyscFlguFFOlqCCOKCOMB6HVrTKsWzn6B6e86RJKuYU4IsKuywiu31gf5UevVm8BhYp+uqigfEUuI9vbSUUfeoJHo2WFWQzjNQfo5oMJz3L9Zy1f3EWriSL24+MkLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsAro/j4cIKswKJXCpD2q0pHJXx9xgumrhGMs+7LwFw=;
 b=GzsNWWahl+Di06U1gAqiVS4gt7Y5sTeK4y7VLZSPG3hSBDWuBfJKvcYBfgFI7dvLzIzHxty7QeZS3WpLpQFHBlsSZ0dX039agd7YSker1RASpaduREjjlXx1F2NkHN8eqh7N3/xQCXwpgHCvTBTJI3gCzXlJIAeiHtIYeIcEchoGgeIoIpY55TVLvXaNPMFtZl8GKlTX4s0BS2GqAjxwFzRujMzCDyt2L11ofejQ+nSjkUMgM0/uGlLmj3XQfAIRW36qzzVco157/If4/jYxnGmYljXPNkDb0BvWi6gpnJvNy4wo0pOKAl+yF+mVNdw6txNpqBQ7Y2WBnP7wNtR1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsAro/j4cIKswKJXCpD2q0pHJXx9xgumrhGMs+7LwFw=;
 b=F2FrqpVJAthH1KvXbOcHeXWodc1LpriwH98QT679+LTQkQqvQNs4NTcoDH69hdUwdVN4G2/Yz6/7V6sTs+Pgk/mqCv91ttG1911w2IxVaairBE1f55aHSo1FnQwqj6XAF77lkqMz1xHAyPbgH8v18w7T02mb9a5DognElQ/HGl76/inGz3kZfNTkeReKKbPIOebW26/XgKiDM+4UkMN38Gb1+apqdJf/VSjSCleF5/WddoMuxWDqE6ocQzcp+4fMQtDPAzAT4X0u5zVjhMCX+Ei+avXfeSHJhm3AGuCu3E4hkhGrXrU+E63jCbYuA5GjSt0bDg/NOksZJN76fXuv/g==
Received: from BYAPR05CA0106.namprd05.prod.outlook.com (2603:10b6:a03:e0::47)
 by CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sun, 12 May
 2024 20:54:21 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:e0:cafe::c4) by BYAPR05CA0106.outlook.office365.com
 (2603:10b6:a03:e0::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22 via Frontend
 Transport; Sun, 12 May 2024 20:54:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Sun, 12 May 2024 20:54:21 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 13:54:16 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 13:54:16 -0700
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 13:54:13 -0700
Date: Sun, 12 May 2024 13:54:10 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <ZkEscmhh4I6PeP/S@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <Zj7YsKWSqGqOgOoV@nvidia.com>
 <ZkDAL+TX93QfTFMc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkDAL+TX93QfTFMc@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a95186-ef64-4776-2d92-08dc72c5b2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PHjzFQV8ZLSD5HtEy0mRUYSj63u2m+pD95Ny4ikI+l1VAZsyQrfLMMdT3s8q?=
 =?us-ascii?Q?LIJDrLMNwqpVSJh3xDgCsS7ISeLwKzKOYal49miWkLhqmRmYMa1aINzt2ZsS?=
 =?us-ascii?Q?VB5GlhaHRIlxL52muDR2JlFcVyA9CwbDJWlVjzWz6j6uBGXaBE82lwetX3Lt?=
 =?us-ascii?Q?cDsei3WgHHSPbQ73GuhoFRApxc1X8KpyaA47TU40C4RLDoRPExqrvfa57Pr3?=
 =?us-ascii?Q?S2pXv//89856UaelEksos5RG5cGzsnPKfYlVRGB5/8GIpvVK1qTBDhueh4yY?=
 =?us-ascii?Q?s2oGVsdZ5Q2FU5c2jcnfzHtPDVnnBaLGlg2zH6eGkiOB0fMTErsEgp8/wx9D?=
 =?us-ascii?Q?sLDFUuWT1rjxHxeDxY5sveSOIt6RJj8uKIY6kp9JFGC3HB/8AaWVaOY2nXMW?=
 =?us-ascii?Q?Uhi5sTFlXLp2i7Vzdui6mOQZO0CwTKPOG8k3Gx6iQhEHs1h1dhbOUrRXQ+5s?=
 =?us-ascii?Q?vNH/EfLFsULLM8Rs5JoIP+3jthoFXQHuMaCnNK0dyv4jL0LozHY/9nROyP7U?=
 =?us-ascii?Q?XvSSI4ij1FiWS/IT3HK4s9J23wFTf7LPQg+nIt2oVFpsRJ91twbxU5DVOSKx?=
 =?us-ascii?Q?KlsUoMEbtwZvxJdrRhdlxHbvcl1XrhtqjZw6nglI9SKRe/vMJYpa6S6Dpcj4?=
 =?us-ascii?Q?VcHtXC403v/qCYOuJ2zSB/rJFp7EvQ8B2ax3FTwrilB7Y5/J9pU7ON9cmAe0?=
 =?us-ascii?Q?fjg0ejWZVzW1lU1lfSgXahZbNfXG/zagW0Plygy6qJA3xbKojYSPgt6pkGiT?=
 =?us-ascii?Q?+3fIWvt3xyvKLYlNFhz+bpVEPSxwjyTV2+Pox0nVEDgMCT3UlAanVD6r/SCN?=
 =?us-ascii?Q?AwQKIM2ohZu3W2WZblfBATqaRAMeZzYSBxAF5K4dYph/P09R7/uC+3DuomI2?=
 =?us-ascii?Q?rcDf38FwAF9eBJUVNTPDpbuv0sbWU90P+HBbIAy43tkPybRjj5FE/wNf9j9F?=
 =?us-ascii?Q?jXfi58EyMjVTB/sQrNuueHIAzq5S0XEBmPiTMZnh6bP3O7F/LtFrebPlfbJ+?=
 =?us-ascii?Q?zU8I+Z0P94dGFv4VifhyF1jB+1JOgmhA4B1608h2wg0UnKgl3Od40iHjvtHs?=
 =?us-ascii?Q?Lf1DFjf49P5+JS1q7lXIvVSwHS1MAnadAU+KxLvvqxLtuRe10WEGdqQUW8k7?=
 =?us-ascii?Q?XczmSLgisokMOeGvpPHNH1lSWbjiy96HEMlx+cyHx/YTt///SKh8CK+fPlqr?=
 =?us-ascii?Q?RzpCG4fLsG1P+POikux1AMlYAyttQyvrtAt5LrULediTr0WUzwMqxYWotiUQ?=
 =?us-ascii?Q?BS0RAus/RLYEjcbCdTdUYtgWzaeSZdJ8rOQiXUSaNYUkkath4mTI5SexsDbn?=
 =?us-ascii?Q?j40tko+D66GSYcfKg3pTt+U4z9B7XA6Fj2/9065Nh3NZ2un+4dErBgwxx7Xt?=
 =?us-ascii?Q?GRX+6GA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2024 20:54:21.4504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a95186-ef64-4776-2d92-08dc72c5b2ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015

On Sun, May 12, 2024 at 10:12:15AM -0300, Jason Gunthorpe wrote:
> On Fri, May 10, 2024 at 07:32:16PM -0700, Nicolin Chen wrote:
> > On Wed, May 08, 2024 at 03:57:10PM -0300, Jason Gunthorpe wrote:
> > > @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> > >  	struct arm_smmu_bond *bond = NULL, *t;
> > >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > >  
> > > +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> > > +
> > >  	mutex_lock(&sva_lock);
> > > -
> > > -	arm_smmu_clear_cd(master, id);
> > > -
> > 
> > Should the new arm_smmu_remove_pasid() be inside the sva_lock as
> > the arm_smmu_clear_cd() previously? This would also seem to match
> > with the arm_smmu_set_pasid() that's inside the sva_lock too.
> 
> Not needed, the sva_lock primarily protects the bond/etc stuff. The CD
> is locked by the group mutex. By the end of the series the sva_lock is
> just protecting the set_feature stuff, none of the attach flow.

I see. That lock in the end product does look cleaner.

> > > +int arm_smmu_set_pasid(struct arm_smmu_master *master,
> > > +		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> > > +		       const struct arm_smmu_cd *cd)
> > > +{
> > > +	struct arm_smmu_cd *cdptr;
> > > +
> > > +	/* The core code validates pasid */
> > > +
> > > +	if (!master->cd_table.in_ste)
> > > +		return -ENODEV;
> > > +
> > > +	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
> > > +	if (!cdptr)
> > > +		return -ENOMEM;
> > 
> > Though I might be missing some piece, the in_ste is set in the
> > arm_smmu_install_ste_for_dev() when STE.Config=S1_TRANS, in which
> > case cdptr is already allocated? 
> 
> This only means that at least the first level of a two level (or
> entire linear) table is allocated.
> 
> alloc_cd_ptr() is sill needed to allocate any second level. For
> instance if the PASID is > 1024 then we will need a new second level
> page as only SSID=0 will have been allocated.

Oh, I had misread that v.s. arm_smmu_alloc_cd_tables, while a
cdptr here is a CD entry.

Thanks
Nicolin

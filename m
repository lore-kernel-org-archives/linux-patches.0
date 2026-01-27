Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381E435EDDC;
	Tue, 27 Jan 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769533162; cv=fail; b=ETLlZqWXIsa/+VXwvRs11J5BgnaprJNkAaqaldsakBLcLHxGiPNh/2Qwea4vIrAeGfg1yrR8GAYY19qnCPS7u9KViOGhSp6I3J20cMIYEX+qjApsPDITc54aPKeqyRMtG/zzESgWXlPHKn9vQkDD86SUHgDbTlLX9SBuLAmL2sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769533162; c=relaxed/simple;
	bh=M7vfSun8xAc+W9Lu2+0oYbaa9zhu9fBggvWJPATpapw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKj8aPyehoEmIouXnWz+OyXaOIliMl4akihcl8Af9saljtFktlU1htvEb1PaaCBFA7e6nbHucaDqASZopVQs2U0Zq5jqnrxp1FCOm/Tpm6NPqxhaCRLsfLQcGzp7BgCDV82a1CiJSwYnv5o9W6FpIgQnP6tgzsDNC4+Gj/9flLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A0NQGCzY; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0NQGCzY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kocbYKr7rIL4nguviuburLO1a7SjIGjAjoppsACkleHnfaHO4FlEuuu9A8uCuzz2WDEpJn9+UiC0cwwgJRv2s2f4VxJtDS3fbDvsY0yz4XPNHds+Ys5NPXj/vMepL4vFOo03tZmDFGdK0lVHEk4HBbiowwRhSdIfPEHW5d6tsJ5MjSIXJWoMUnispszyrChMB6WBEZMACBthWg3IoSdnmNImUtYmWbo5cE6t1R+nSnVzYZogMOUwxLaBXN9GUusqiBct8EsR4cN3Emq8gqABj0KUeuaDfCVmZY28o/NJTy7hPHy0iBLyTxEcJzPIxd3e4IToRhqYeEttuULO1iw08g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DU1IUbGWeXsFRP9PQR2TBB8BMLrrsREum9bj4NwDbc=;
 b=N9B8jqV3dGYLDKfSb7EXwuKukMXuYioOmChXquexJ+Un6//B8JssQXTcRR2VjROYb/AKbWFUe6wWEMJDh/c5YC5SBdGIITq62OcB2svwAVoALiyNaWCT0CNObLP4dD/ijKkDOGW4FWH/oQoNeAkPkap0JV+92OGB7BJD3EmWs/1aT8C56kTTUCj32NYqX3tKrAAy87i5rUGdev19sKJCUnjxukH/8tzBLE95WqgtNKUHKOfbBWiBipZMzWRM06f9e7teCdwJOmNyNFpBDjyRN7ejzoFWeCWfA1MQn4Oh+t5rZ7+tReBGaxT+vMa6tj/QTMKJHUsM4qPtu/Sdyf9+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DU1IUbGWeXsFRP9PQR2TBB8BMLrrsREum9bj4NwDbc=;
 b=A0NQGCzYi+EDIuJkf+RYdmK2jCoiISnIJ4i107jx8VN4vt4ITNAL4KJgm+aavzkroE0OTij0by0UWW6B/0xs9fccwVnxZ16Dhf/KG8h8HEn8miNCW0SEnhDHtSVWFGfTzowOohTQb869AZRDvfgu17eKMpiRxD3yTDNT3pkrOBjqHNikS+NGwHr99LS3BCfMJNQP1pckAJvSbxM1OsK6b/OJWeEIwOXSH7JP9rZBPqE6XNgDLO7sP+HITo2KlH3dVvGig2TyS/Thkwgz2Y6nG2UUbO7qeOIyhxqencQU4Oq+nnyl5A1FeVzJMYcOxJ+IwotA5eWFOfuw0yhVDlUZgQ==
Received: from CH5P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::19)
 by DS0PR12MB8415.namprd12.prod.outlook.com (2603:10b6:8:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 16:59:14 +0000
Received: from CH3PEPF00000009.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::b9) by CH5P221CA0006.outlook.office365.com
 (2603:10b6:610:1f2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 16:59:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000009.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 16:59:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 27 Jan
 2026 08:58:58 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 27 Jan 2026 08:58:57 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 27 Jan 2026 08:58:57 -0800
Date: Tue, 27 Jan 2026 08:58:56 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Store IOTLB cache tags in
 struct arm_smmu_attach_state
Message-ID: <aXju0DkpGxjsiJK2@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
 <20260126204443.GX1134360@nvidia.com>
 <aXgvzoPJDej7HEAm@Asurada-Nvidia>
 <20260127150848.GG1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260127150848.GG1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000009:EE_|DS0PR12MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: c7e03527-3d4f-4f38-f8d3-08de5dc566bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eYNONR6lJqdeMv7pvuqBdLs7oK/y0mcRzEyhAPtnCNYqYr/DCRzbt02DnaZz?=
 =?us-ascii?Q?gZywGPkIHUlfFaxkmMB5d+RuKh6BRROSEQTTL4UU9CT+C+T48Ie1AMFNhRUo?=
 =?us-ascii?Q?gsuV8WW5AGPZ+QOSOybIXAo1ZjN5nc52kTm2wIAkDLxJsFKZfPWQKlTs0N/6?=
 =?us-ascii?Q?st/JN792PSZVQABe9B1qKkLH9pi+ReJfWbz2xJOzXLJMT+HDNS/ToGDspL+Z?=
 =?us-ascii?Q?BmtxpfBrDgGI6EKdn6tXzSwt4vsq5otHmfSR5kWb2UHOBxAdv1QXWOEuyAJ0?=
 =?us-ascii?Q?1D32Pu9mtUV+EULoAjmuuEjjN6/B4ANfz7h0ThhSUPMXJN7xEHyYdh3ME+EF?=
 =?us-ascii?Q?w2A24HLXHr8+IM+g4ogI3NT1V+yQvtqb/uh+fVlkwHt/2KL0WJLLBaNMzlvf?=
 =?us-ascii?Q?I066RCN70DhS726hc2CD/Pd512VjSElRsaRjeKYco1P8K5rFFPuTAZQESWHB?=
 =?us-ascii?Q?Jl1jhYA7aZCz43/RWBdkga9T4E7hEHkzrP8WQ2P7b2K9OUaKjtUBjA4i2bXs?=
 =?us-ascii?Q?Aps2Y15PB7vp9Xc8NN2pKCXzaPwZ/YSWxUlYFjXBVCCR8HuBtIHnozKRn65E?=
 =?us-ascii?Q?Hei4p4pTBkXSd62mbmwUfyGWaCk/hvjtf9fnIRklEPXvpHiXrgICNHnlxm9z?=
 =?us-ascii?Q?VaiiPklT+QWxaS1wCWkFP1Lj0NLCFmrTBx43wASfWGnYzVevcZ2a+WrBctcU?=
 =?us-ascii?Q?4dmiQzncVpD1tPwgVV3O+6sdTQY/MVAmyZb1wYCaq+FJybHG7TmRF5HTt3b/?=
 =?us-ascii?Q?OcO7ECtH+4T+OmHFApZ/kb2NEg2TrhUkq3ks+qzqLWCcoxsyOE5bc8HHRoEB?=
 =?us-ascii?Q?DWEyT8mcOWVBL+Bfw3JrfzW3rvyW9v/3qctSeVVLUijoh90L75m4ne7eTTrK?=
 =?us-ascii?Q?IqgT412u7drxXke5TDLR7LNrY6TLOnn1YytRdhVYsARhuf7AzxKiPW1vP9y3?=
 =?us-ascii?Q?jcybscvQvhS0uAdTK7VT4szfw227LLHP2cf6tHrpAP8suoq0xJ4tagU7hbDV?=
 =?us-ascii?Q?ZRqioV+imdojzFVyImUL4mdrX3O1Mecb/SxpXLJjPWmg4ZeJBbsE+oCBOlom?=
 =?us-ascii?Q?Ogizi6oifTp6mB8wE4Ldcu2ouCXWs+HcCtNc8BAvhff4aMiAF1EHrs8K84R5?=
 =?us-ascii?Q?+G+EDknWw0iVKzUGJBubKgX4e70JGUBzXt7tiEKU9Oi5iLPI+yheLxKv3Sgv?=
 =?us-ascii?Q?nx9Tt0A0QXXH7Enu6ZCPxyIBRvczfhwjtKAT1ZYhWa5y5I3nUrvj1Jh5ByH+?=
 =?us-ascii?Q?Tg60RXWL1Yw0P37eQMPpLxpGQeRVeYKGhULzSvJfUEXJ0EJDGq8pney8UymG?=
 =?us-ascii?Q?6boiZaS7ADjoJcbigmT+BGjVzUlX0HKKVJBueuf4LrbxaMRbLuyBZqp7OAth?=
 =?us-ascii?Q?aSYVwM3EGwkl0Bt8MFDa4E2MxsoaozoCJEYy40bC9qzK0hVB+BVttOwqw1Ya?=
 =?us-ascii?Q?e5e7GzYZDAsJuDg7JY+vhsvAvQI3Gok6tME1oRon+F1t62OMrbk+RP9rmwhp?=
 =?us-ascii?Q?4KHzEVmMGJJPOOeWPuPxh1n1Vp3iyzbEAtAd+ZCInYcyEpFgAVpxahpgH+EW?=
 =?us-ascii?Q?MFd0EbVdmLz0y/mO2SE1+QCdNPqFfjHCP1c97PBdYB5L0K+5D8X/dykwh4R1?=
 =?us-ascii?Q?E/fJ90BYtNyLqhzuGZFYXhvVPmFw2EGbNgjubIXtinV8BB8GdRQ2stO20nGF?=
 =?us-ascii?Q?kC+Jcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:59:14.5584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e03527-3d4f-4f38-f8d3-08de5dc566bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000009.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8415

On Tue, Jan 27, 2026 at 11:08:48AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 26, 2026 at 07:23:58PM -0800, Nicolin Chen wrote:
> > On Mon, Jan 26, 2026 at 04:44:43PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 21, 2026 at 05:24:19PM -0800, Nicolin Chen wrote:
> > > > +int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> > > > +				  struct arm_smmu_device *smmu,
> > > > +				  struct arm_smmu_inv *tag)
> > > > +{
> > > > +	/* Decide the type of the iotlb cache tag */
> > > > +	switch (smmu_domain->stage) {
> > > > +	case ARM_SMMU_DOMAIN_SVA:
> > > > +	case ARM_SMMU_DOMAIN_S1:
> > > > +		tag->type = INV_TYPE_S1_ASID;
> > > > +		break;
> > > > +	case ARM_SMMU_DOMAIN_S2:
> > > > +		tag->type = INV_TYPE_S2_VMID;
> > > > +		break;
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	tag->smmu = smmu;
> > > > +
> > > > +	if (tag->type == INV_TYPE_S1_ASID)
> > > > +		tag->id = smmu_domain->cd.asid;
> > > > +	else
> > > > +		tag->id = smmu_domain->s2_cfg.vmid;
> > > 
> > > Would be tidier to move these up into the case
> > 
> > This will act as a fake allocation path in PATCh-3 and eventually
> > get replaced with a real allocation piece in PATCH-4. So, I wrote
> > like this in a transitory manner.
> 
> I'd still write it in the nice way, you can remove the lines later
> when you add the allocation logic.

OK. I will keep them in the first switch statement.

This would instead make the get() in PATCH-3 a fake logic until
PATCH-4 replacing them with a real allocation logic. Should work
in the same way.

Thanks
Nicolin

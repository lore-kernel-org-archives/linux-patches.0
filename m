Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAD51411E5;
	Wed, 17 Apr 2024 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713371156; cv=fail; b=oUTMfw8nLnX+ojSZeT1WWlJ24WuF9uQLeCdFFtUksD1ivDWh9/ra2X/QVm9k2TUGYkjaWonut4Zg+pgpg2eP+WmDaBLaogGiceWgkBrA6cNDOZgCylcQWJ+jmxihBak2fPwPl68JRTUC+ckG/a81TokVZSgulnVLvGBD9FYie3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713371156; c=relaxed/simple;
	bh=jC8zjVeqga9Pj2AliKIlePm1cFEL11HBEBNp80JQzug=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGNwKYrCx/eerxD3viZmZqcwr9GcBuW+akw/h/JPkGi+HAayTrsHp62ph3LcfIveZ2Z4P0QxW9Y1yYqmfo6yEVh2tE+So1VxZvZmw4bQ4BV0mV/lfuqwXyocA1agqVnit/ZadMxeh0Imami0oFIy/CuBfDJSLDOI/1XIpR+T35Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hRN3G/xH; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hRN3G/xH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPG72EbFcMWv86TMBH3+gdrCdSWz9vyur9l3nrsFH6gLmvG7aDvPkUfNNPauNrp2d3XyD/DvpPt3zAGnE7NIsNWlc8LYAEYd0NqRDqLQgv9VlxIn7XWOVhXac40bK97VLhXo55xLY22ikZ6iXOIQj0yJo5siUwHMadcRw2n5EK/w3dSNcBre3wXnGFeL8yh2loza5UR7ieDb8AZj0nPjoYfQxYLfU4INU6R/y5YRtPFy/NBRpBpSv/3vH0qGqzBMIxeEMRAlDMkFBDZtR+jABXPoOQdwPenUqlaYyV+UDSPFx6nD6R2bVXj85H2Ctv5nIFcOkt8otMP5fAm86Hz4Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdjMgwewBe8CCj7B2aPni44Myi42+tP8cIUgXDgs2BA=;
 b=BY2Etp5Onk/WNrO+a4hGzzkyR204vu9cqI1ouSel0nfbNCPW2+WNlaGineJXIHUgbAkayZyNy5nkfz/OWgFTvQBlp1xAkzSvtUSrVaZbv26I7sDVYQznCRLx9nvtBaoQOg8NLCtkvLMmEtY4GwObpZGkxxrgmOjdxrKGEk9yn5WjsIlbpnbZI9gEbMrzOYZ9czdjanmb4pzj3NN5urdlhBDqD0cfDgIRm6oz+ohiPM7cpCLRaeTwwT8GwstMUs3FZhtNxjSsz5rwg3Ae683LoIpAw2wD6OBbV7TTwzvzN+O9rmOTPzoykUD51AhNLNaIpxHZ+0WyszH2am3YDMWFFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdjMgwewBe8CCj7B2aPni44Myi42+tP8cIUgXDgs2BA=;
 b=hRN3G/xHp2zhYsbpE30eDBVTIp9CxC3I1F5fVK3Hz727/b8uyarmsui21AWi7Z5bBmbM8hMtxJm8wgP41QWgZ6hALIhi5ZGBSLuM0vY0M522gZMcaI7wco3BE1Gyx+G8VC4IZ0tl8SH97r5VtYAm9U+cQsKMUalLUmxzQE+8t+CXq3FoBRlLTL2JpJXw0uVu6wm9OztRjdhpWf/APhKEd0CtDF9WI1IQyCdoS554vIxlczoOgE6S2F/gSZhtnibI01KXAdhtyD6FJr7tn0qKCwjREV1puvMulx84Kqd3PXhAwjuxEwA7HK1r/twWibZMSGLWPtkoNsjYjBW3hUO5eg==
Received: from CH2PR18CA0032.namprd18.prod.outlook.com (2603:10b6:610:55::12)
 by MW4PR12MB7287.namprd12.prod.outlook.com (2603:10b6:303:22c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Wed, 17 Apr
 2024 16:25:51 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:55:cafe::34) by CH2PR18CA0032.outlook.office365.com
 (2603:10b6:610:55::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.20 via Frontend
 Transport; Wed, 17 Apr 2024 16:25:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 16:25:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 09:25:29 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 17 Apr 2024 09:25:29 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 17 Apr 2024 09:25:28 -0700
Date: Wed, 17 Apr 2024 09:25:27 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
Message-ID: <Zh/3992Xf7Nd2P9/@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zh98L/vNPugu6JbV@Asurada-Nvidia>
 <20240417131727.GR3637727@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240417131727.GR3637727@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|MW4PR12MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab9ec42-8cbd-41da-6cfe-08dc5efb0c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EylF8VBXv8z/6eE1cUzxq+uEx6wxcibPOoTc6EEGsf8+QkMvsF0iNt+UQut+c+iNce53kW2/F0RNAmiwHPVafiJKUExUuddY9VrBuYS272bwTgxuF6xr1Wa4GaOgMO4s3AXwj5bpjJ0DN77J+1CjQIJqgxNGwbEGbaCtqv3cHV2s9Jx2QQLlncPgrZssoGz2oPCHwPz4sa4zYEpQvpftwcmTRjsRjHgtAmFbVZ1JbPqzqgdnENCuYe7XFVdobOsbyHCYRQDL1Oj4GdZtXCoYdViiQMTCW0X4uHB1o71Wbbg/EiKM26rOlHBw0m1JltZvsicrFYX16CdNpu41Cq3wctYkNiH9uxJfwYE74c+rjfo6OwKndpI72A11WYI4sTu2PqNx1voZ5FUJYgpmFOoYmTDYcBvgRZyq26+2Vm8nIkh2D1Z7yvJtFhTEgTYR2KZSUq21InrtOXPq84n2rk6bde533jckz5OtOZkvdpKcAQxKKP6uYCJM7zhae3dZmIKVS0YlXvxQ/w6KZabH74SSBT7pQjrbQNrwNiBUVKB9RQAWgruNVp1E9h5Z/qfX9Jjwafw9/OISz1UugG6T3I6XT6OiGqARz1HItPByKcP1XLCI+RtRYlUpjrxyZUgB8P2yAfWF76OaKkTclQFITKmca/D0aKzaFi2ESAo0r17lMDEDz6TTSnX4wO77P9+KkMWh/JRiMyy9K/RzwlktqrC5lHCyM+q5jMpv/gtscJD5HCrND/zSNqh7p3bm/wUh+KOB
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 16:25:51.1998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab9ec42-8cbd-41da-6cfe-08dc5efb0c2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7287

On Wed, Apr 17, 2024 at 10:17:27AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 17, 2024 at 12:37:19AM -0700, Nicolin Chen wrote:
> > On Tue, Apr 16, 2024 at 04:28:18PM -0300, Jason Gunthorpe wrote:
> > > Pull all the calculations for building the CD table entry for a mmu_struct
> > > into arm_smmu_make_sva_cd().
> > > 
> > > Call it in the two places installing the SVA CD table entry.
> > > 
> > > Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
> > > the function.
> > > 
> > > Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
> > > locking assertions to arm_smmu_alloc_cd_ptr() since
> > > arm_smmu_update_ctx_desc_devices() was the last problematic caller.
> > > 
> > > Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
> > > the same value.
> > > 
> > > The behavior of quiet_cd changes slightly, the old implementation edited
> > > the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
> > > entry. This version generates a full CD entry with a 0 TTB0 and relies on
> > > arm_smmu_write_cd_entry() to install it hitlessly.
> > > 
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > > +static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> > > +				 struct arm_smmu_master *master,
> > > +				 struct mm_struct *mm, u16 asid)
> > > +{
> > > +	u64 par;
> > > +
> > > +	memset(target, 0, sizeof(*target));
> > > +
> > > +	par = cpuid_feature_extract_unsigned_field(
> > > +		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> > > +		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> > > +
> > > +	target->data[0] = cpu_to_le64(
> > > +		CTXDESC_CD_0_TCR_EPD1 |
> > > +#ifdef __BIG_ENDIAN
> > > +		CTXDESC_CD_0_ENDI |
> > > +#endif
> > > +		CTXDESC_CD_0_V |
> > > +		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
> > > +		CTXDESC_CD_0_AA64 |
> > > +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> > > +		CTXDESC_CD_0_R |
> > > +		CTXDESC_CD_0_A |
> > > +		CTXDESC_CD_0_ASET |
> > > +		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
> > 
> > This is set for the new "quiet_cd" case too. IIUIC, it is used to
> > ease the switching back to a normal CD, i.e. mm != NULL case?
> 
> If ASID is used by HW (eg for negative caching) then this is correct.
> 
> If ASID is not used by HW then this could be 0'd and we could adjust
> the used calculation. It is still functionally correct as-is, just
> slightly confusing.
> 
> I didn't notice anything in the spec about ASID interaction with
> EPD0. The spec was otherwise pretty clear about which fields become
> IGNORED by EPD0/1.
> 
> So I'm assuming ASID can be used by HW and must be set.
> 
> AFAICT this is what the current code does, when it programs "quiet_cd"
> it doesn't actually write the whole CD it just flips EPD0 to 1
> in-place. Since this is only done from a CD already programmed to a
> SVA the ASID remains set.

Oh right. I misunderstood the last part of the commit message
about the quiet_cd. It's clear now. Thanks!

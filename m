Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C37FB;
	Wed, 15 May 2024 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715733172; cv=fail; b=TgOCiFa+CgmKO2OaDlCoq4QBjjV0aU5pdNwR5u6JGwFKw5aEJVLn1dZ/IO7NxNZbIzjj0YgL8PDfyzlRcXvXH4nebdJoxStLOYcCGaLhNh32GkhGZ5GHsHbAp5duanaPVzTI08BMpQzeGyWjfcQ0QihuA9G02b7+R3mZT6aRMlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715733172; c=relaxed/simple;
	bh=G6BfMP7gdswVte7JigmyDaDge1uvgQcEV5nqVsQQw5U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUuVn0Kium4kNKg3VzpRfjcDyMv0yxlmC4m30EE30SGzIyPjXRTNv8s0jq3gV6gc55se0bZ9jEZW0GQBIqPlW7NKDwqM5Prsc9eS0dMRfpiahrjoaSngG3jtbKQU0ip0HY3D7R3blkaQE3mUOeSP/vGEzfx7BFH2FknZao8pXuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I6OJ6h7k; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I6OJ6h7k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBbzOOB4S8LkWA2raXygdeRQ0bT0uSU55dcFF/33jXe3/jFVsj1RwBzlNlnKHvOvkEHJFb52J4seVYhyT200V4LCy9qFxBgsKnfS+6O5JCDRz9HQYdxuilI0rru+mLYFhZbz5hEAOL1IfS/RCONmWBn0xVdXYYLMTjPxqd274pcteaxSSVawAVeYA2xI9qMa0MmbzlajxvQCXzvTZMNSN8GOp/Co+C4jmNciFM1tyYjSJZ7l+zfeUqN3/konczAfJ/mLYs7CncqBbj27nm8rI/EFc9qgwXpQfCgPrp6ft1C2vSsxs6iqDQFeLDTw7YDwVH57Ais3a7anV6woiCSVDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsZsZIYYWxnJImdzzI/IPFu4xtv4MN3rGUMNHmhaqDw=;
 b=ILAqur7q1JwDOvQ3AAlTQEgCz4b5+pRQSdaOoemLB9PDOniWq1RvdNyrIDni7K6R8txEAccFt33CxH+YlcXcQtz9XgBoO7bup9BAL9ir1o4TMl0ltP8QoAO5SyWjOne3dElmShNoUeUhWVr4GWJhBazQL4vaMq5bab4SF63pKock7MpPuouE82MGBrBXO2QyvdaW/Lgr5X9ggbPc264aT2IblH5NaCtQMLoMvvLasIIVHaJmtGh5BvI5NGeVeoNVNQvD44aMa8fRzGizn7wzxAIH+JBobRexksgZVt3yAsztkDUIIXilW4i8aFUEcL/F0cLGkZr5SdZ3oGl+Nz7ohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsZsZIYYWxnJImdzzI/IPFu4xtv4MN3rGUMNHmhaqDw=;
 b=I6OJ6h7koyEEuPHdR7YX+3Lb1W/2NXhM6tTwjPbQF8O8iG5mLzV3uqOOeX9oLYbxneGOzVCtsrVsbnOisZKliid9htvXrsCwBaO7jr24Bqtmco5y1eLy1Kq7q49OCtSvSQLoUFYM9efsA7k38cJ+Hl6APjAi08x71bdmdUxh5KdKxEP6Dss2KPtbscttxLwBiGCtoBf5c9TWl88dV2XSv/SqoNTa5aFGD81nwQb0MWD448JdOlHEB7KiTreYucN6Hvq/NOVLn9eQLCF41peyDO9HAr4+uwW3i5cpxv19c1Pw9/rpkMXkzXfJ74gwqMyyY2ReQJAe7JqZag6SozMu+Q==
Received: from CH2PR20CA0003.namprd20.prod.outlook.com (2603:10b6:610:58::13)
 by CY8PR12MB7265.namprd12.prod.outlook.com (2603:10b6:930:57::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 00:32:43 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::47) by CH2PR20CA0003.outlook.office365.com
 (2603:10b6:610:58::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27 via Frontend
 Transport; Wed, 15 May 2024 00:32:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Wed, 15 May 2024 00:32:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 14 May
 2024 17:32:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 14 May
 2024 17:32:30 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 14 May 2024 17:32:26 -0700
Date: Tue, 14 May 2024 17:32:25 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be
 set while PASID is used
Message-ID: <ZkQCmSc+/8haHj2P@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <11-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkG9INGfwNcnubyI@nvidia.com>
 <ZkPtnTfup2snod+/@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkPtnTfup2snod+/@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|CY8PR12MB7265:EE_
X-MS-Office365-Filtering-Correlation-Id: bebb8ece-9ade-4e5e-3ff4-08dc7476894a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bMJUg8FVNwH1zOEqUwgzWw/ghnliaqHNOvwHuSE4u2T0b7AgBSurbc5aZtG+?=
 =?us-ascii?Q?NUxWnuSQO2tpx/a82aiQ/Jpf6wAILol22DmivafKAQ9MBey1exSlcIJ1qM31?=
 =?us-ascii?Q?6KJhVVIoPoSu9neEScJl46y2x6QLK3qzCAxcZiehmb7G9IUs72MHIdyDiFsg?=
 =?us-ascii?Q?POVUoZriiYyBujN35b+X3anzJpA/xxCKssuLwGlaTvqGYhvr3zz+etZZX95m?=
 =?us-ascii?Q?AT3dBWkTqAdnlGB8aa/xgQot2+EtZ404+/W4yGUoyuRsbH+qsDi37AfN+yoY?=
 =?us-ascii?Q?vAvNkJykwidFmqw4pEK65OjNuG44dbDoWcNbcfkv+lDqwb1Ws6gQOziuIyrS?=
 =?us-ascii?Q?mB3+f8n744LZU6Zmz41IJ/Crr6xHI30myw58qBuH1LcX23tU70HYq71w4lMr?=
 =?us-ascii?Q?P9eyJKMoIwnnHHD+Nk8qDlGltequ9leXj/ObjYhhhgSjEmwbamYGFvBRhvD4?=
 =?us-ascii?Q?PgOXPMkUN9oEA/92gpquv/WGRXmoYDMZBjaBCURkXgN1j+cBjEiRfcUUddoF?=
 =?us-ascii?Q?JlTFlB0XPWVWEEzgrZFAxf/msTIyMqt6JZf07k47oCGw1bJTU34RRw6Dkpob?=
 =?us-ascii?Q?P4ducWPLNSx3WQ12awNbzZfFCb2ORRFNWnHZs4z787fPmjIYS+fZTLiUSo6+?=
 =?us-ascii?Q?gGtTTMLo9dHr3aR60Z70zKa4VmDFJQIokwbc335Dkii8tYkZY2U6hpAXX8Wq?=
 =?us-ascii?Q?Vy0u5BODqUGHbljmbQG2gTI8l5ZpZI0iVbaPCRPBQBk8rXLTMjtdFVUGHaVn?=
 =?us-ascii?Q?wjXqKbELZDFXfPgOZ8H4MJQqeQcxcNDnk9x/UrCPvPWdsH+SN8Ens/aG3AN4?=
 =?us-ascii?Q?1hSDjSzWsO9tGhmvfV5HkqgMBvy/ZkOFY/KzjPnNoEsGSRRJ1xZDJ/6R+ERF?=
 =?us-ascii?Q?LbDLTLg0j9lrlIcKAzATxohXVu9s+3kkf9t4ARQ0Hifn4INp4GzeunWdzKEN?=
 =?us-ascii?Q?QGuSVcsh4RiOckCWfiEefvwZOorayWMPrsc1D8AwuPkaKCeWNa5awrY/XqCo?=
 =?us-ascii?Q?vb36UyGHGN1CmMmAhZW3UAMkn7wi85XQ4udRSY7kLr4PcugPQ6Mg58QGQFqU?=
 =?us-ascii?Q?z115q59qpZ2Oa8PdtVZ+p3h62uYaAGQPgjHo6vfA4nhzlgE1hk68OG50VzAY?=
 =?us-ascii?Q?fIxaRrTzjNzYSpqP1e+J/m0B16mJbKosvHyRDsyWMd0nhHEx+lMqXU73giP4?=
 =?us-ascii?Q?ztYXadYmLvsj56mwzZFrdYS9c92zBTyGLMDTTvTcAtu091C1Ob4GRnbFvV1X?=
 =?us-ascii?Q?RaTx4kdmJwOB9r5aaDmAQ+BEafj1GGLY6YUOGL3Zycouz4Ha3nwEClypRQjE?=
 =?us-ascii?Q?M/tDm7mMkMo0AbrSqZZtI1vM3yIFCEhyRiIDEQj5YmizC9eb9v+Gz7Wp2aBV?=
 =?us-ascii?Q?n2UimLvnZva+17MmNJv/NKe57JTA?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 00:32:43.6356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bebb8ece-9ade-4e5e-3ff4-08dc7476894a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7265

On Tue, May 14, 2024 at 08:02:53PM -0300, Jason Gunthorpe wrote:
> On Mon, May 13, 2024 at 12:11:28AM -0700, Nicolin Chen wrote:
> > On Wed, May 08, 2024 at 03:57:19PM -0300, Jason Gunthorpe wrote:
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index 15378c131a5bc7..41d7a0664a445d 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -991,6 +991,14 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> > >  				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
> > >  				    STRTAB_STE_1_EATS);
> > >  		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> > > +
> > > +		/*
> > > +		 * See 13.5 Summary of attribute/permission configuration fields
> > > +		 * for the SHCFG behavior.
> > > +		 */
> > > +		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> > > +		    STRTAB_STE_1_S1DSS_BYPASS)
> > > +			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > 
> > Should we check ARM_SMMU_FEAT_ATTR_TYPES_OVR here as well? 
> 
> It isn't needed, this is just checking relationships, it is up to the
> make functions to set the correct bits based on things like FEAT data.
> 
> > The SHCFG is RES0 when !ARM_SMMU_FEAT_ATTR_TYPES_OVR. So, the
> > used_bits[1] doesn't need to include it in this case?
> 
> In the not-supported case then the bit will always be zero from all
> make functions and so this will all do nothing.

I see. Thanks for the clarification.

Nicolin

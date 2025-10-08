Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010018.outbound.protection.outlook.com [52.101.61.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A22C0F8F;
	Wed,  8 Oct 2025 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949901; cv=fail; b=TOE4m0wO/GGmBENATEwsaPkTh+1U5D4Mr9+qrIWpO6S5qb02HwjZA5we0+eZYSE0BTqcu93VE/bQx06oO94FMJi/QOczN9cFqToBIQRbmHKKAHSpJOcfB6McPlmO2IL9/2XVTJ/gis2nxSE269748PYD8OX9LUGkQGju3oLlUxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949901; c=relaxed/simple;
	bh=gNQp+dOMLQ27XasYjO5CWj7LYPsMCeNA0Ix2Bn0OKbc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0xAQQi4p2vwfAqNkkfy2DIPSXc74b+LfRX6BSyS82jFRda+GEdt0tH/7Bt1HO7RYveyvKnVfgPffFeT63cbfReN3FpIWeCwp1/3YF/zA+0SWtXvHCQf/jGGq4NhL9f+H4+ILivJJ61dHBYDknsIpxR5gUApfypy+uUij/SwjLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BrbTHxU5; arc=fail smtp.client-ip=52.101.61.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BrbTHxU5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RKqOTcnNeCg3Fp8s8QHMyDuVom089IF0DO5gdk2pbwKxSg6GPGf/AFFZzvpdLXua9+HB91k7PALK3yuSPBpHMha5LoAhHLnsAXCnfBJmSiSv3p/PCs2XUyQIVWfNZU6uurp7a37kD19m/fgJQsixpiel709naqvmuPejrZcVJxESZANCBq3uAV1fX3bUumtnI/sNKjvmo85WnzK9A7AqG+L+Qb/qXzqP46dOAy6zAty3Ib5/hyLnqc175NuuFlhoeYx5JNNAMPLy7rb3lQXLQ2cpt44Cs89Tm3ddKoxCePoFkfmsakOFsn/YPbxb6mHIrAb5pjpIIkG9juohtrixLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN4tE7W4JdH6Biw3013A5vjuel8CFBhIRJwqp/KYicU=;
 b=b9rtByuwLASJwHga8FK9Dup/+Btu7Nsh0Iy5+8tgcHyuv8C6SNwcaTgR7h51zlgGrpqZcH0XaKWSmiEMMiYEhYghYsEyXGKB2RtvhsiDPoZi41LjxC4NdaUsBFKUupi1prFC1hRmueDdrF+ji0dJCGf/9hux+ATwRrvYz2fqaCSA1wGL4II+fmBokB8B/c3YS7WM6cxQysPrCfT6HdFdZAop9BVps1bYzB6Cwus49h2cBNcYYcq7baJkVkaK3CmRqLdYr/Ejt1MqO0iDhYuf6+V0zqR8QgGkIFLllk0KIZvDwQleZODkWxZ5pNLT8l/kWT9x8cYiD86/5XlfusYmdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN4tE7W4JdH6Biw3013A5vjuel8CFBhIRJwqp/KYicU=;
 b=BrbTHxU5t6BulxR0v6CpP5VQOnBeos/k4HlmU8moFW1Czk99JxxQzi+InK8Vozc6dKjGrqOF/UszCWPtbd7Z3FUHdelNyy1CqdZ/fxDUh5v2uJOZkxWLK65kWOQg1VwiBf+jZyY53iqRhflsyX1PutVQI4MO3R7h7HCE7PCTl0OoIX3VFOcLs7YV7f1h5+iIJ8TTsgG2PBwqFsSbUjHC0jORiq0nOdoGSjtQ1I8R/lJPgPu3oMyIFT27GnVkG7fpafzXQKk5KInvxcjde1sW7buRRIQ9xdPDq0CLf5hA+4paRa+3QmOV3BZMZFnjK3fT+FWA+rxdb8Jjkk/BDYPMgQ==
Received: from DM6PR02CA0122.namprd02.prod.outlook.com (2603:10b6:5:1b4::24)
 by CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 18:58:15 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::e5) by DM6PR02CA0122.outlook.office365.com
 (2603:10b6:5:1b4::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Wed,
 8 Oct 2025 18:58:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Wed, 8 Oct 2025 18:58:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 8 Oct
 2025 11:58:00 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Oct
 2025 11:58:00 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 8 Oct 2025 11:57:59 -0700
Date: Wed, 8 Oct 2025 11:57:57 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Joao Martins
	<joao.m.martins@oracle.com>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>,
	<syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com>, Yishai Hadas
	<yishaih@nvidia.com>
Subject: Re: [PATCH rc] iommufd: Don't overflow during division for dirty
 tracking
Message-ID: <aOa0NWKpNMDSECz7@Asurada-Nvidia>
References: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: dfde37c2-4704-4574-cbb9-08de069ca336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QbLZtNT1bFoKXZuWIAAC8U0BFaUsH1ZOnB6i0iIKjlGAdVrVAPxVxE7IWBlW?=
 =?us-ascii?Q?cD2KTASPfkQjeN9dPOLTPiq8IdynMqKIvgltqt/4dfc6Cuub244yGBUiCVUD?=
 =?us-ascii?Q?ZXoVz1O4qlasHHOMZXPa//8XBXp7QCraK6wVbs+/e57DvdmGZM1MIJ1SIfc5?=
 =?us-ascii?Q?nl9Xxj+pVjk8j2yvv/bwksSBRhEHv2U/IX/9QXdOY/EbCG/IUjC7WzgOCQPV?=
 =?us-ascii?Q?DgdclmVgmd9W8Vk5nFBWO2PKEOO3I0LmQvnPjgkpbuMkjLPz3Z/QTnOWA98f?=
 =?us-ascii?Q?HniJVHaPF1ESVYfcddtu8kuCoSlAH4UJSX2AQeatC/Cma9lT3qr9zqQUzTzp?=
 =?us-ascii?Q?rBN2XVPmSrYfUSoxppiRW5l/2izcgKbx6lA+wf2ho6yFEDH+6Z0/CW+m8c4y?=
 =?us-ascii?Q?58g1Jt6ZegXKWy1Kp5rCa0sd6q1/CaizjOC+ip3eJjiOm69UT2TC1amfVi48?=
 =?us-ascii?Q?Vo3GX32bDsdErTN1gtdU1stsOFlqqlrqCOiSK3pDtWZtjr1xe3wQy2/qAV/4?=
 =?us-ascii?Q?mwSomd6IrJuslTjHTNhJhuHFXV1yt57ImKqfXOLM4VRKc46bNl2nvawAnM6+?=
 =?us-ascii?Q?qGFM35ivwv6Ga644I+DEU3e4V2i8cBw5/0FPc4r6sqaLUvh0jBbRim9+6TOx?=
 =?us-ascii?Q?PMszkZBFyUMuVE/bbnyMwBWlxdhlszlCyQHVxN82tZoEhSSFD6gRV3LKWqID?=
 =?us-ascii?Q?VYbc+vHsoanGvk79nSy1lATRUqZEv9Z/ExGcXFNSBT0a0Q4hoX0fTcli1SGb?=
 =?us-ascii?Q?Gu8U8/YDxpSmy2SudGY7monv12CrRiuVkdpMMe08kqTjVXkTBqaKzGieOS9Q?=
 =?us-ascii?Q?a1oMr6aunEUuTHwngP+zo8NeN46eodaofWlVBvAA9P7fOCiytNrbTKxGAUd6?=
 =?us-ascii?Q?GzxmoeOIz+TnlMuhIt6zboFPFtRdJ6F6AzkwWzvul30I6VubBtnddSYtm9UU?=
 =?us-ascii?Q?bnbmaUdXy7gpI7gPfm+aLVDLwmR9zSD8a+LMudRajvE8dXBCg+B/XXt21qLb?=
 =?us-ascii?Q?VIi+RvdyVTpM8xrQlJb+78Or5od8gfLxs2re5d/sjquykP0uNPlQ7f2b99Dt?=
 =?us-ascii?Q?jTsqCtwTlb+0fqjzeghlp1OOCcGvm/1FuhIbkh9nICct61GHj9ookDafXSaa?=
 =?us-ascii?Q?5OfFruI127zP0rZtmpjjxo8Kkrp/JdvB/ld4nfmLwJKRFVqduH6F0Ewv6kcJ?=
 =?us-ascii?Q?3PAITAdJ3SjVlvGm+xP/a5Quxm9U9M1GL/9Cmux86Cf0BHSIsbuKK+lewOQd?=
 =?us-ascii?Q?iTEJ30DFwgi/1txNXx0WU7+G1j77QT5BoO+fqOt59ZpW5E6Y/uW1xcq3jtC8?=
 =?us-ascii?Q?S2eNtsC8JoUA3D2zJohKDO6adPVKZdDsWwYOgOAyBosNVhlNM1uJp8OxYEcf?=
 =?us-ascii?Q?ot+P/NXiFQlYarNHz99TzbpNlLvoxd6gEyzKAgDpCyWYnqVoax8z3X1RZha3?=
 =?us-ascii?Q?KqyX4upo31asqcDmSUYAU92iI7HPK5gAhegfRyvHi6Bs7z+i2tTWColBrIDG?=
 =?us-ascii?Q?4Je6QHJv6KFuQh8B7wuSwP10roeBm95GwAZFodq+L/mopIc2qXa8nr/C2lnn?=
 =?us-ascii?Q?lYmF5nBdaXx2ZDPMAig=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 18:58:15.4476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfde37c2-4704-4574-cbb9-08de069ca336
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594

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

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

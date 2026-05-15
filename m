Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79311ADC97;
	Fri, 15 May 2026 23:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778889135; cv=fail; b=Y1Zb5GgssQBIWFTRGNcZ8E/q8PU2JS9MrUTuqYegXe4FL6spHDtRh0rTobasMAvY8uM6qltrLa2aYAjE2IKmiglvwuENEGgRGQzs7+bOvTnz3rNoydBGcq92AeRW2xtqF7okmxveLFuDmaLzlneJxAx1j3/xVbpYAL5yhISyfsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778889135; c=relaxed/simple;
	bh=djb0m0OMXu/IjpdeK1Js9HTAhB7CWPY7kkJ7j+ct0no=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmvIDT8DTfre1W/VdMR+T/tvesIHlfMFM2iHhU2ffR8WW3+bKGcU+AFTDaCJUPkQ0bX7/NyDnhar5P0+wjQmw9IXBGBK6JIQKPzhYSng9+k3+ZyPotvs+BnMO+kQzG8LWzdozhEFLROtz5sNnMeK1rnbrNobYDycOqEJ0pExQl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H9ZN/s81; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9ZN/s81"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m58kvaSFUqI9DYZaPYDoXTGGRJABBrCbFh/157cmnkh0UnW8rTLwmgJY8D8uzER5Gb+aL0wBIk483b2JseaPjmvKqlsXmZedOSbtGyL/nDLQju0kkhPKSYNTPCN+UPY8BJ8PQq3EICQLvXoyECVq8T1zLhpdJagAIPMkldVwb5jEoRkbHZjFknafu4Jo8LoUgzSIU5Dk4u+bZhQn2p6PDdpEF+EIH4+6EkAUUS3sXTJinXGoqi3m3XkqsPzVQ3xAu5byj24eUw6D+OilTBXkpTWSCGVMR0own2z8DKaGPXEXuaPz7Q6EA5CZXFD3XELegMAosQVF9kLXzpDkB/a6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31+Xt66QQhks2cpNCdxp1IH9jZEITcnZ+yE+VFusd2I=;
 b=Xhh/B027lugZpsnFeX4OT0e28tWF9ArwW5tXaisHlLCOqlTzAXCHW5DjCP5pCtarRccmcElT4zDOiWsXWgpA8ZaLgq7KEPlt/xF18TQrazbgXXNhTvaGH3mn//TNyevF15EB0QXqmKUwj0C/R5gtpwUVoJAwYNLYhiQEqMt1n15PMC3Jc7bF0MZDpvDYAl0tSxjlQNUz0NF4VepADuXeJNOP5GsHmwpqFufx+LYlmsIY8ViEu5d53tBVPfZrQUTJgu/HDf++mef14R7tuIOOmX64zy3vFaCqrrYud9enm8mN+GY1wHs1Sq5mNPoS6cEJbeI2tc5uUHqOEAWc+UR7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31+Xt66QQhks2cpNCdxp1IH9jZEITcnZ+yE+VFusd2I=;
 b=H9ZN/s81sdEPNzMY4sDE7yxJGM2T9qC2pZDDb3HOV4qJsKUlOylOGo6J/wvADiQjxCkyIgYsZ/2m9Gib4gGvTaUh02wA9+j6PjfkwHfuiPWynA1eV8C6FEQ23Wb8FXcgsHjq657Z9bC187dRkPCmLP5X6d62Q8aYKv8St6UqmUVh4tTZhue2daG/o1/hADN0MFULUv3x1ePvwG8Z7e12ELpiaj/GMjLykRYRAQo9Jbz4+tGxyV24WpGh0zzv+Rmfb4oKoVygEmfVUrXaNwB4uq4TZaD5WT+qeDqevTuUgp3hv44EsnOWPi6rsoRAqzjPgG/042cEW+2TQCx19PNh8A==
Received: from CY5PR19CA0100.namprd19.prod.outlook.com (2603:10b6:930:83::12)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Fri, 15 May
 2026 23:52:10 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:930:83:cafe::2b) by CY5PR19CA0100.outlook.office365.com
 (2603:10b6:930:83::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.12 via Frontend Transport; Fri,
 15 May 2026 23:52:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 23:52:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 16:51:57 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 15 May 2026 16:51:56 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 15 May 2026 16:51:56 -0700
Date: Fri, 15 May 2026 16:51:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Jonathan Hunter <jonathanh@nvidia.com>, "Joerg
 Roedel" <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-tegra@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Thierry
 Reding" <thierry.reding@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, "Will
 Deacon" <will@kernel.org>, David Matlack <dmatlack@google.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, Pranjal
 Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL
 from arm_smmu_cmdq_build_cmd()
Message-ID: <agexmqdWMTBgJON8@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <5-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|MW3PR12MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: f9078f9f-5469-4992-3a51-08deb2dcfa63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700016|82310400026|18002099003|56012099003|22082099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	RGF+xyvUaRy4P8MHJx0xx//r9xPjqb2bwc3O1b40FQT5Ns18q+14LHWw7itmKGvV52qc1zoYZTvYJDBiJittgf8NBmT4Hjlwkqvp9OVN1M51YNhWj9CaEQ7srrHU2juEWVmyIvSSnn7BL31oUjggdEjvcd4q0CXl+AUQSqgzKfxMSBshTilN985+MoWBME7IRihzr8/GjOEK80gTBmfVW3qm4nbTtB0XytTnofIOjy/gOWy+wiFlUcFuZuJKFxzCZAGEAckdYFVS0PY+Jvw8SfI1zrl/AhTH/sRZnEKKpp5G/Mm6NAoIwgCFt2lf4jMDY203UjvZaiNizwHh44n7KtYXdJe/L+3ew9/MiyemhoZ6mKzY8fIrBO1DQ+ZXKP1dY3UY5c609wPAZLpIqnSVbE55ZGoWXHvNvzMhfqzehNNJpHMXFXkQPeMjJjRVLyGOBBtlDSkVIvQeYH2ZwjWr/hiNofMPiKQevsR5Yr0i20UOiglcIZY8lZOJjvnUls5DlL7saU3f+DftoedbOJhDIaSd5BzNQFU+iYfvLPxhkrSlAOeDfeR1GwWjSfBT2K94iJA6GCDR9wKb4mTeT01VdC48uXz10HJKEkrxvB5ZXOCHcjiuJmfapc7KFeZC2Bd8pL+zNyJFUJyH39RRYwvoYTvhzBS9sESw5oOhyLL8SKrMK5/W5XkQ8dQRL6qc7r9b/b/tgvtGP2uyu8Ts+56/NS2GGOXT3FI8ZXBSKQcuLBo=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700016)(82310400026)(18002099003)(56012099003)(22082099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UwfnvFyxlHbrYU0qXkySBGF6jsd9yQG1IMUGmUfv+sg3oFET0zJy4LM47IbnbUYhTYHyQhlZPR5WdhVEzN/FXD1sPgJixpx2UHShR8GTPzcdq1feq/p7HJYgyf4OiyqAykRDhlOHQOCip0TrPjFuih5CFoAbsDrxuxSSndI65PF3HKWHPypJvpVA0rOCRiSJWBQMtsdZTivV37dZW7GtpmQAcTgkMV27DBtV/8lHvOF2UdIVRHtlm0pPadk5YosiGzHjdyWpszVauXRmV9/75ZRZ8FBvFcF4RJZHyvmhdkhWde2WvxBAWbYmm6ZSmctXxJyiARUdHvIPzfg4U8L7rfil4uHi3vxotm7Fv+fzb6PJgIE1s6uZxbRQjENRNRZW+1hZutiS9hbw8/cEuD7RPVD34cUfZLgAhcMQazhcOUic7VuCOv6gYQct1La+AX33
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 23:52:09.4956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9078f9f-5469-4992-3a51-08deb2dcfa63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426

On Wed, May 13, 2026 at 08:57:44PM -0300, Jason Gunthorpe wrote:
> Nothing uses this, just dead code.
> 
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

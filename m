Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B44101E3;
	Thu,  9 May 2024 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715247601; cv=fail; b=GRFdDlYYfJ85VN9E7hK2CK5DQp2ovG9FMKAjyXGcpTLTwda+VO+zHkvGM2ZagpiUSW4OmiwXXNP1QhXDy9kF/+5v221IiFA3sfy4NjkmFNsUTPF2QAORu3kB2VNFOpgf9LoVpqtXvdP6K2XM7oXLv/lwhQvMcjfYJZCv6it/Lkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715247601; c=relaxed/simple;
	bh=lc7XI66Vxw2nEqGFGyeItQtzjYbpvXf+/fCYK4PC/Vk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4dx7Eg+FBDmWmSijpaoRtj6DDt2RWW3QLUZTxPplzefrn39nTdUkoYO/xBXrSxW6YN4Q52Qoob3uGNYnWZqgeOpZiAy0offeAik4hDdp2khZu9ZaH47sSNFuSsCiEhSdnl35SZYaAPooLTc/zQcDWXJ7HzyIiFyq9dpMgHuvsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bCg7+YF2; arc=fail smtp.client-ip=40.107.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bCg7+YF2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aa+z8PlMN2OrrvCtKpPIgeg1RqTp/BFtRbgtfeonXu3n481aqiLd+qS1KAes6hMm9CvKpP6rAez2+8Q9uMTK3MVM7lKcKkz745szH/76m+ycBirOneV5VtM92RERbMj68IOZqMb9kQZLHMmDV16va1aNiuHof7eESnBx4Zm/s0XWvrm007vjaeo96ggfNt3A6d3LxOO/JJ4kPF5HuDZ9AovU8Lh4s/xsM+SH99cB95/Z82JEtFFHpmmhIxpc8NN00+nyVLwLJczBB3p6RtYE97k2DUVQMULL1rbKk6omrZZgER5iuwJs39EP7RcwTllXSoINO35+7PJXJQfgWiGUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYxuD/5KGnnYEJKE6mrvGmDmN8NyRbI5c866LD2BC/o=;
 b=dLVv2YhAeof4sZxVp9MGWQJaBCb2HGevRSnCF0yKgUCbM76tSsf6CE45FnC/D7kNzafahz6PUoe5uh09NRqgyieAoEXnLeiXEPRH6Vk/Ve2Xt6+LBC1bGS6Bv85WiQW4oEAToUkHsmMVpLnehk/foCklBhAujjyDfm29C/WrZ33WJZyZfO22s46oDumzTd/r0qyQOUcw2QcMlAYRvm9ZGg6Z8WTYJc1K0CM0DKl2nDGCJpIQReKDc9WE4/T5f5zFMy5/8NbaPv6JDIbeL5qY6RvtdC1iTDM1MEw5LehrHe/x/Znhd84JOZ/JO1XUZkL5Kp0M2uwlzGTDNC8Sj0lFqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYxuD/5KGnnYEJKE6mrvGmDmN8NyRbI5c866LD2BC/o=;
 b=bCg7+YF2tz/D3D+AsO9pISYtB8HKKm/dEirAgQK+XrqDfu/GJKZRE/J2CgKeSluBeV0s6VtwLCrP9dIU0M9PpgpmoZRQhQY3k+LGL3MLx0SvOoS2TpwnbT4otQoOptd+HVNluVUrJuYgiMuFOOVGxg4iwT2ExsYfYFCw3xtKr61s2jZRA8RXYNaQfxxWQzy2QoTv2l2VBvdC96459Eh8eSu52nrOVIQ2owH1h89YUFhA33kQ/ieFXVstJTBay1gH8GS1vTh7pX6V8axMhARUTyEVrtWFjE4zJXnKnNdVH6mGPl4wk3Dbi22qDjmCnRrZ1WERKbtYSdJlzVw6ARsbxg==
Received: from BLAPR03CA0132.namprd03.prod.outlook.com (2603:10b6:208:32e::17)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Thu, 9 May
 2024 09:39:55 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:208:32e:cafe::8b) by BLAPR03CA0132.outlook.office365.com
 (2603:10b6:208:32e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42 via Frontend
 Transport; Thu, 9 May 2024 09:39:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Thu, 9 May 2024 09:39:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 9 May 2024
 02:39:35 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 9 May 2024
 02:39:35 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 9 May 2024 02:39:23 -0700
Date: Thu, 9 May 2024 02:39:16 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 00/14] Update SMMUv3 to the modern iommu API (part
 2b/3)
Message-ID: <ZjyZxJ5zbrP3DYn9@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: e32485c8-4fb4-4b16-65e3-08dc700bfbad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|376005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nh/8JmssJetJ0UK1l8E82eB/dZqQ12lgPnT0qsv3dQA769PqFaI2sYuYevLF?=
 =?us-ascii?Q?SEPEgnzCR8D4NLlR+41BlKgEF0r3RYEl6NaGp8Qwyy9oXiLeQitUUpVGwXN3?=
 =?us-ascii?Q?iK1LcnWo3TthIOnTwnIpaT548kO6yU+n4t6f9kIWcDeTHtpz7tlPFGN2LEVk?=
 =?us-ascii?Q?cDkpknPj03+RUjTNeK5fVd7nh+sI+XGfGATQHuMXnVIi1PmbpE8coAyJQ5dG?=
 =?us-ascii?Q?pSFiCcCFRp26sIB1DMlN5vpIl2nVCRlS1UumEySm9jGEzkCPW/fV6eCKfCWt?=
 =?us-ascii?Q?jvU96VcW65mF4m/jgyKYokUIRJaL67fXUM1lw4MtbT1wEXcwjetOuuv8AKvU?=
 =?us-ascii?Q?+e6baC8lwIoG1qWXDxl9OYqsyCXsmvmts0tYBXsk6xSeH5VhKJHXiJtC7zhd?=
 =?us-ascii?Q?LiHZ/W/dYh7MjxUaQyE0mchEOAOe1rKWscUXOSmiFFsAppbSOg8rO4btWX0O?=
 =?us-ascii?Q?/VeRIp4hCIWlYRwUW30HBSBDDxXIxouuusKBYMg5N0UtFh1S7pJD8Zh0+vuM?=
 =?us-ascii?Q?XTC3VUgk4svtMnOFHbGv4rhBqtBPo4NDnLl3XH1pHI0HFgIlWwj0lMEJ0EdU?=
 =?us-ascii?Q?DqyL5GDiWyzz6BgrXH/k4QAOhMrNurSh6MD8BbvayzGolQejuvdtjmr0tu7H?=
 =?us-ascii?Q?7rZyHfzB1LfAZ8ery2viZlrU3eZXvjFjV3VEsBsH3sr+QMyGohmPyVbCr5B7?=
 =?us-ascii?Q?2Wz9wsGUattxH/RggyftRrrXXU84ixIsPSH32MuDVMSEVSgaO6tar2b1Cgm+?=
 =?us-ascii?Q?WBO8xEOV3SEsYrs+QIjfXv0Q2YjC0TJgYRgaR22XqqgKvwlCL5ADSYdXsw/p?=
 =?us-ascii?Q?LXnYssi3wyHaSC0G6fQ8DBiT0hjvkIZJlL9OXIIJs/v3ZKcW4+l7ttzYB49Q?=
 =?us-ascii?Q?xSG7w3AgQuvwjeOaE0ZIBZS0CVQYBpPcLmkRyGEDcNsMoTdcCQ+2lCApT6sE?=
 =?us-ascii?Q?EIKyelcpanRaZtR3QXEcmQngrVGQtN2fInQDsxlEO+Wej09NjzimXxl7H9qV?=
 =?us-ascii?Q?wuyzCmOxryM19aaKIDvw/x6jI1soN2CThNTF1PkMScfH4AjgI3ZJncYs5jFO?=
 =?us-ascii?Q?INrLzRG0AA8A2ja6ExpOWXy4dI6bbA16a+mMTUbYR7awwLzrBR6yToOKqg8S?=
 =?us-ascii?Q?kjPezJ81wb7j2+OEB61RRYeNjMFYutNsSyi2WqA26zFlDmfjfFq7RqEm/1uK?=
 =?us-ascii?Q?sN1SjBSorfnvMA3x6qNNG4ne8/qCOuDcnv7i+39ioSD2N9ZfHdjVFnVKk8su?=
 =?us-ascii?Q?Y7l2Z8s0zdsBvsEb4bWXAN1QaAXn78Wkw2uNTsSl/0a5xtIBhCOCnA8MXpsO?=
 =?us-ascii?Q?XpDWrIVxvSfnabBXh787dz5TsE/c2pG2OgoUGVoG2aFBT47NyL0iv6J3npLh?=
 =?us-ascii?Q?gkPfi37FBZswOllNscMheUIg2xqV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 09:39:54.7132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e32485c8-4fb4-4b16-65e3-08dc700bfbad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

On Wed, May 08, 2024 at 03:57:08PM -0300, Jason Gunthorpe wrote:
 
> v7:
>  - Second half of the split series
>  - Rebase on Joerg's latest
>  - Accommodate ARM_SMMU_FEAT_ATTR_TYPES_OVR for the S1DSS code
>  - Include the S1DSS kunit tests
>  - Include hunks to adjust the unit tests to API changes from this series
>  - Move 3 BTM related patches out of this series, they can go in the BTM
>    enablement series.
>  - Move the domain_alloc_sva() conversion to the first patch, and rebase
>    on the accepted core code change
>  - Use the new core APIs for the PASID ops
>  - Revise commit messages

SVA sanity works fine with both S1DSS_SSID0 and S1DSS_BYPASS
two modes. And all 20 boot-time kunit tests passed too:

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

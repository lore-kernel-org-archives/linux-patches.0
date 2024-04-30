Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251E71836C7;
	Tue, 30 Apr 2024 21:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714511527; cv=fail; b=NglD5c1Vqp/QqUvD6fHlXMZ4bTbiZcPXTILIBXIIRSNqdffDRvNtKZlWToY3VV4SFbdxkN1JI3DBSMIbQhsjX1yBF571IK4H20PSnidbBSGLhHJBycnf1QVu5mhIiQMioDroX5i3MZsriesVHfx6QpTSGLtBoH2uVW8LTHXw7oA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714511527; c=relaxed/simple;
	bh=Qd2Vid/Gic91VlVgxMQw7xIwFH5p8SidzBfP8yGWd9c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eplrq7GHQL+5Efyu+sUTVuKNYL/Ka36ZzOMx+TXgTxnSWvEiZuMQmSsE5I6iugnxwfZ5dBPMYnM1kqjAnIiOBzX2U1H1urP7B43KfwooBlZpBevAVo8CxbOLJMgsCTMBzutjb9Zc55rruBHKHrsG3HowTPXp2geIy3eEwdMZhVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YrOFtGph; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YrOFtGph"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkMaajDW4ryoy44HsRtE6t7xoE//B/s5XbS57GqxZDJTIupFGnrLSjTh7RogG9z1RTbC1e+onEf7KXpCnxFPSMBbfOVGA6zJz5qof2OQj684jA7wTkr8kEjdE77ub7A+nmfmLKrWVe3S8mDlXVsPO5BjmnYtoWNxNyKfLzQmcC0v9s4Zkn6QzIIjo4/LpmWr+9W9d9bS1x/XsThW+46oG2FUEoqVjK/z5MZNHN4oq9VqWrqGXZCR2+BeY1ibyYW08xDUkK/+zUC4kMJluSB0xzpUPp6NR8co3S3/Y8QHepse6bmQSNj5WoBDbVhV1+7Z5JmVHAANmDvg6r4T5rDVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iac7xZf8Fo0jV/wy+VUwJk577E69qAwBfaHEsZmCDI=;
 b=YaRLLHtODJJgacB1CKwKr/sI5JHSNmprD4OB/68/fyxUeXI9GifGacqfgjpbnKO0jiUNmqrnbuYMASKMvZm2NZKT0K3JeAf7299Ti322AWMyze1ivbKzajjfesCpBofi8h9YGsXfh6R7Cx8zPjTQo8kIJA6fC+FLCvOF3hPif5u2/5J2+Z5WmySxekS2m7hc47+2maDSD0KQOBFx/95lloejTII0nYJZpCPF8yQ2D8qL+DGMGkTD0tQT2oRmkUT1qGBA53S+glCbozwynUAKGZ7HfMKfO+Bg4ZiEONOxuID/s87NSlknHEGZ4QMl/Rmni/DGkQcvAj1NOXCjPu2wKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iac7xZf8Fo0jV/wy+VUwJk577E69qAwBfaHEsZmCDI=;
 b=YrOFtGphkujVYFzLNO0f9DVS1HUVgU+v0foEAbLBs8g5r4aARceJ1yy7I9tUBY7RZV8c9HIge+5VoCjtWKeQL2ULVfjA+Hf+AZp3rTmzrg+HpmOln9daezTIfQdj12cZsDy3l8aqGcGVlQsrqwPrHD8YzS1N2FtqxdchYRx4VWB8Zr7veH24D/M0IxTMiftENWwjq2A6Wej9UMzqYyp0twDBQyUSS1vyMQmMKGZVYljKxCQ1BfmUTNdAXeDOvxSR0SOjWETjPxTJqLH3voSYGhW491ZQP4iuKSIw16mUf2wORFFdA6HwIqx6s0SKDrCrlvFPe/5THorddqYDytd7uw==
Received: from CH5PR04CA0017.namprd04.prod.outlook.com (2603:10b6:610:1f4::17)
 by MW4PR12MB7438.namprd12.prod.outlook.com (2603:10b6:303:219::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 21:12:02 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:610:1f4:cafe::bc) by CH5PR04CA0017.outlook.office365.com
 (2603:10b6:610:1f4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36 via Frontend
 Transport; Tue, 30 Apr 2024 21:12:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Tue, 30 Apr 2024 21:12:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 30 Apr
 2024 14:11:37 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 30 Apr
 2024 14:11:37 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 30 Apr 2024 14:11:36 -0700
Date: Tue, 30 Apr 2024 14:11:35 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>, "Moritz
 Fischer" <moritzf@google.com>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 0/9] Make the SMMUv3 CD logic match the new STE design
 (part 2a/3)
Message-ID: <ZjFeh68ozFHcQmk2@Asurada-Nvidia>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|MW4PR12MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bd2e2d1-59c6-478e-c0b1-08dc695a2db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400014|36860700004|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ryUiFxUL16fkseVzZhj3gSTUcmeuvp8CjN5NYNCe1xT3No0MaSRE6GviPk1O?=
 =?us-ascii?Q?I+abmTdm2vO8reLtcfiCQl1G47OfCwk4MmbtPbP4jxA4LyJzqk3/ch0NPAXV?=
 =?us-ascii?Q?nv99FCGj9BFeK19T39x8FzAIGcfSk8X0KQc5e8AUKPvSq1OgTRy9joueo88E?=
 =?us-ascii?Q?ohxgRl2oauxptULc4vScVFJFfzDm+oZfWl20SnuzzBVZBESqBAH0W7hslvo3?=
 =?us-ascii?Q?kPKncM0WwLc422juDqcf1oNLfmZz1KgGVSlVny/bi5Mh/ymrgx+YO37rOokV?=
 =?us-ascii?Q?DmfrijXspocnUK1dCaeZPUFk4dl5lFuACI+xonBBr2RdjfAv8YfuznmGeR07?=
 =?us-ascii?Q?lXyMnW2kG9uojDDvdSQj8f31KcaVXRXp9Xe1cdEKCnwbXZuj8RsZsIT6dngZ?=
 =?us-ascii?Q?wZbwOC+n/YT6G9GWvLO9J5IraEEs82hvtNAcS7nQu/2R8BsrHIbkSmi7YZQs?=
 =?us-ascii?Q?DCTpMsTh7VWqgvnmfkA68S83+4AXxajbFdmKm/sNyTOWfUDf1XPaLNTHYVbk?=
 =?us-ascii?Q?aidnolCDWbTa+xd7Zq7Xgez29+bEQYSbA1euhfuwAIx54qOlDhgW3dIIKwG1?=
 =?us-ascii?Q?rf5/FjB1lmNeRF0Xe9HjoGcD1QjZhttkz4slK3MqJDQP5gxJRpKqJQeOfcep?=
 =?us-ascii?Q?mhMsu5PczWTp0dplWoivhuZ55YFvkSHiwm1H8d8AWVaitskndUP8QenaIRuJ?=
 =?us-ascii?Q?mleG0pnrR5KOuRwRC119pPWaIH5GZbPNKusAK7/kvIWjA/WssaZMebfeUeJI?=
 =?us-ascii?Q?Y2/VOG9IAau8NohkR+F4HjINueCVG1GAjdvy4Q6tIpoogdYg8AYfNtRPU5ja?=
 =?us-ascii?Q?0CcM+0i0uns1TKOeF41PiBtHudMjpNrT6NobVUG7h2PC/xmi91iW02C6LxNg?=
 =?us-ascii?Q?n/DQZdRFnHLTnjHssIXFnTZI+IZ6YF57IZV5VJSwEay3uowQ1y2GpKGjcG8T?=
 =?us-ascii?Q?STME5srup/BNb07Vkq4hd8YlOGUljDb25ccQQ+JN4t28JO4Km9SgBBDmgQS7?=
 =?us-ascii?Q?O77aiStXhO2pGYFHQT13IE1KOZKipzq+jbiOeuRm4dv1N11NDacy7D0bUt/3?=
 =?us-ascii?Q?QnRBGgZAcUvA5MIUG5o6b381hSlRS/BbTVfuPbqNq9vgx7FTRU4tiGzlRJI4?=
 =?us-ascii?Q?VKhtCF0aHrDSgiPy7ADLIDcieEz0UH4PFd5UDGHFk7QsmXx+uVLlmfs9Iw5n?=
 =?us-ascii?Q?lqxVKxKe5tF62v6NUAFGnm5wCo3CnsvHn3mb0xNcTXs97J7xtY0ljKb14958?=
 =?us-ascii?Q?uOQjLrTQIG1ZYXpquFJSvnkzgwSeYgMCi8WFhXZBEh1bT1LrxLnCB9GtMWud?=
 =?us-ascii?Q?9vXUW2WPDs2n6ZWk72/7QN+CSI/f276QBEw5G92iQpkQ/FhaIBc5qOTf/dao?=
 =?us-ascii?Q?+yhVd4k=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 21:12:01.2958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd2e2d1-59c6-478e-c0b1-08dc695a2db1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438

On Tue, Apr 30, 2024 at 02:21:32PM -0300, Jason Gunthorpe wrote:
> v9:
>  - Remove arm_smmu_clean_cd_entry() and instead zero the required CD bits
>    inside arm_smmu_write_ctx_desc()

SVA sanity works well with v9 as my previous test on v7.

Thanks
Nicolin

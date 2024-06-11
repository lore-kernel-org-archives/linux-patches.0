Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693B16C868;
	Tue, 11 Jun 2024 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073100; cv=fail; b=A4N77moKVwfRK7+OGBB77YgpRgViLHx+1UUAcQEwKxu8PmhnXEc39DIYlGIQbsC4bgQ1TtShhSlUYoeIAhwF3UJsZTND/7Kg+wvGdEkwtcz4IrMOQyHFC7lzXRYhfirFhd3WtlKR0zk9MAPsrAKEdq9q3rYzK4OoPDe0qAnaJgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073100; c=relaxed/simple;
	bh=0fi4XiCsAzqqB0m2hSCxgRBnEwlN1e2HhzYOsuvEdDc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVov/L4JPpi34xluNGcvp8nS8pdpbe+cebpeoNr7mksKDRCKiQGN+MaUIYtAGhPuYx0ED1XS5dzwgZkG3fBx94L+YrDY9tyHFwNIjKI6zI7DSR6IjDc4fJs9XiIdQF3uQnYZOsXR10jfIGfcjWp+QkEJqWq+BBTPXLCXX5Ineh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XeyPKHCM; arc=fail smtp.client-ip=40.107.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XeyPKHCM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/ceonyPolYaAJ+fUtsXeMZYgbU2KMSK9Z7RAm9ZhEM0wtk70ouqEjYwNCP2xmJFV85TlxFKvVvk4NyWgotpsYHgfS7l2NnZBdctuBerrR+K63Z4NjNVye9Syivmri/fXeO+0K4RPky098v7n2rdWRKMIXw/7Ms1wnnPGbatVWxRJ0fpzf2a4wdrwUbRbM5FJQq7JCIoFxTuIn3J4Y/47Qf636T+LY4WOHJh82P+Fbr1yF+C9pNyjVGrretpNW5onEGe/UXCA5OZ9JN8mt9WF+TmeocQ/sOWQKZ528kNBQOUCAI1N4KPA3M+3YXsFL9THs1ghtUFEg4kKhQzdXVk0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZwd7aWRnWCvRGnYEt79CEclQBaw7acskQQQOHJ5hyk=;
 b=iDaM1oR11ekUq3ybmyLKstEgGn78X1FeqWKDqzHuqZlHeAeM50WBbSjNOflQ4py0YqphkHQEp/dLj6/Q28L/2Dlp7mPxWnHw4iNrHEnwlyrqlx9yXlYryv+rAKTVQR4QemuPqUqzfvyzrJuGxNVix3alDf5EVNPwD/uwrLQH1oPYAeKSpbsqIdu1cPy3ytBM42oATsCmq5DbqtcsesX1bmBgB7YaNdgiOHg+NefQN38Q7zUK34utLqBQX5VJoaydw/b9J978nC/fEZFeOufmgjb9G8jhOP/bIxjzCs/rMK0s9sSSVXNQZICYPbLz0Q9Yuzmn42rxqKZW3PCIcF/Y0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZwd7aWRnWCvRGnYEt79CEclQBaw7acskQQQOHJ5hyk=;
 b=XeyPKHCMVW57BqyrGpCLWUTDgousxwCkgTQMY7a53dPhEDxHJIeJBpLWGMl/oNtK+DDcDaqDZdhOX1KLpwtnbsSUNvCkLIUaEeJJwOvUZXH/ZKJAcLUzt611YPxNAMaJSX5hv8AisKGfWn5/QzSoP6n+3egvTxCbk6LUok3J2StuoVvAuCJJJT+7d/gS3iTisbFEMfd1YqMXbU61a26OSQyuD6NrV/YIuNVDgAMf6LVzsk+/+TWmYpDuoS95y/xsNy/JPGn/sE+ST4zQMBLetWcfYkRgwyQvgimXAT7YSKZPnHHJeKf3xzNr+jzrIpGMcye1ijRvHsLMPjxNxmO1lg==
Received: from PH7P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::32)
 by DM4PR12MB6471.namprd12.prod.outlook.com (2603:10b6:8:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:31:35 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:510:33a:cafe::48) by PH7P222CA0007.outlook.office365.com
 (2603:10b6:510:33a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 02:31:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 02:31:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:31:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:31:17 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 19:31:16 -0700
Date: Mon, 10 Jun 2024 19:31:15 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_strtab_cfg
Message-ID: <Zme280au9vSYyIBN@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|DM4PR12MB6471:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b13112-78bf-4ac3-04ad-08dc89be9cfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wS726xgnoadypKdNF9K8f+FSH4XffYJAj4RoQcxo3Yx4V6QZ/gXLW35eHroB?=
 =?us-ascii?Q?7TY+RDB2YyvSrS+9g9VVVx5JGTqVcRqS8hgz8IhJY0bXRMUxyAk2DNL4QRwV?=
 =?us-ascii?Q?jcFLC6FD4jck2wC7I3h2Xgj8HLtuiIc8iaiPtvi+fV9ke2pHplUy+NJTDwno?=
 =?us-ascii?Q?MRbSCSqKb61ulDh3L4nicTu6LvEm7LdGBxFCTZ0+oMBGtShOCQn/StWigS20?=
 =?us-ascii?Q?koL49u3twRM/ehOWa7NPwONZ6p26Lo28sh1eu2/dQmE3gCzNBMQY/9ex+PVa?=
 =?us-ascii?Q?s3C7l2QiQ1zHObsJbSgXR48B0T1IDYk74mo2rVMjo1PagyvYJpUd+0aRALZO?=
 =?us-ascii?Q?pgC7PGG3xvktlMwHdIoVnLhUIaF/w6plyN1jesMk56c/B8MQCujceVsixekA?=
 =?us-ascii?Q?3S1W8Y/23Z4uT7S3mbLSoYkgtqHj0VshnrwQPbYGcbJhVp9W69yK7tqh/P1k?=
 =?us-ascii?Q?EbKhFZSs757Zl4WAlAuvyhsCnz7c8rPR+M8yRKktFYmF9G8EMOXhyqPfwnAJ?=
 =?us-ascii?Q?sGR63Dt+r8rlsZVuLcmUoGfsxHBrymOlEYgRQwWeD+YM6INXyNq1E96AlTeG?=
 =?us-ascii?Q?s7JWeN0oOKgwt/CoRxGZHL+Y2jGDXMRDKnnQvCbcn9DN6tiexUCn4ca2wPdm?=
 =?us-ascii?Q?NoC0tjOVYHymwWqzB6J4XuEeYpBZRNMyM4mkdpP60eLggF9i1IV2pgrTR8MQ?=
 =?us-ascii?Q?lyYtrxq4rvmr7bRaDJXXElOg/A1uU6PsDUwcsRRHtXhZuxoA5U6rfq7IVOTe?=
 =?us-ascii?Q?DZHcdPxQ2/evnFPKjcbH/Tl5wnQCjKRAR89hUVJZAujWmQH/rTU9XiSbZ3tJ?=
 =?us-ascii?Q?uZS46cH7ON4Z60Oq/oZSotcDhu9/aO8FWby4uPak7xJgb423UhhxPL9IW0oB?=
 =?us-ascii?Q?c65n9StzZTvWQXytLIn0ocXLCYHUm7w5GW9o3JNLD4VHEFvx7+uMCSuBYXnM?=
 =?us-ascii?Q?549ONqpqdcKTpRFA6Fn6v5cQOMM/xsV9duup63cQYEB7z+benYzERD7M6W+K?=
 =?us-ascii?Q?xoMRdPihB89z+5nhn1XO23LUKae0yyTIyvtGFQiYpOx5i/97Wp7QwhOe2rQ6?=
 =?us-ascii?Q?uOs4DcCOpKnEBy4S/7ZE7GpgdU5w7Q7ZWHCE2oPxKtlvtZ0/DC6NKHN3JkEx?=
 =?us-ascii?Q?iPh0z6TODDw0uVglwLyHrpq/qGT4CyH7LrcweL3sF9zCY8ZQosJ1lK0l8X3G?=
 =?us-ascii?Q?ohwb5dr6WR7oEu7++DoHqUGhwZnt5rjMa1/GwqBFsS1tzntI0kH98ODHLghf?=
 =?us-ascii?Q?89k2AlGwxvsJ3CNNm/vOCjSsN9LFq9Onisx6yg/Mej/KwomJ/bdHZIvClmSZ?=
 =?us-ascii?Q?hI8Qdvhmhx09gw0CPA2n6r4RuO9FLwMptVFVbHXxcu+yN8FwxdHLDKX5AQfD?=
 =?us-ascii?Q?quq9qBfgdXVY8BdHWkwEJFmPkQLF027dAPbUUH6BWF1XmW9G+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:31:34.8849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b13112-78bf-4ac3-04ad-08dc89be9cfb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6471

On Mon, Jun 10, 2024 at 09:31:14PM -0300, Jason Gunthorpe wrote:
> The members here are being used for both the linear and the 2 level case,
> with the meaning of each item slightly different in the two cases.
> 
> Split it into a clean union where both cases have their own struct with
> their own logical names and correct types.
> 
> Adjust all the users to detect linear/2lvl and use the right sub structure
> and types consistently.
> 
> Remove STRTAB_STE_DWORDS by changing the last places to use
> sizeof(struct arm_smmu_ste).
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

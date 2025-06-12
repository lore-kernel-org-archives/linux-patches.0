Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4D63596B;
	Thu, 12 Jun 2025 17:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748045; cv=fail; b=Zgb0OSHxlvYk6FRQ+aDMSSPHfz3NUC++sy6dlK33pv7xWkvt6OKPVU631UoCmwVaP80JYkvYhlUaLmBrhTAIkTfVmx1cL6h6Yh5DedYh53rUK2ZPZc0+1rQnyzkp/9vZBLgJMvNfUCuA4K8CfJj/tze9jNVgE8e+8iQToXd/zbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748045; c=relaxed/simple;
	bh=jv5Vyr/g07ojqzDZEcRYu8CJFdpSGbcSp9Pvgc8RKTY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4TBGPw72wAUv/+tC6nVPjqiH+0OYRP/9F6kIHWKZgsfIFSyKD6eQNo5NMV0oGRLov6uMmudfOObmrlRBbDYORtYF4LACgVy1T8TU9WHNQW1d0d6l73wAuGQcDx5ZZRJZp0qdFxCGAc/HAcc44Tmz3zGykzzZSdb6Ab7q9rRPqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PrVLNaGP; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PrVLNaGP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMbCwoErNgP/y4QK/9xC5cTuQPAfDU/L6vm7B7q1InVUOTTr3ML+qn4RtfMmMFHUYqRVqnrG3B0CY5TJpgSyj/SAlzm5HtYN30OifHJHGJhxz01hQN/VjRTSs/Trh6w7NiEOEJ987G1YJ7hB57j0/amRPeHksWe2pzXKy4JerP7hIwgT0UAbFbgIvipsw7Sc2/FtOWb5IM7Kxd4zbM8pGRw8coIIZ4lCFZmuD0A2QdVXgWIyfB4xzKIheZT6maQTY31AtVdYT1vCALhP7dpn5Ya18mKGDCXI3b3FHy1tvo2fCKNJs37rEJS6E+1izUKFA10ZyM2V++wDFd0e2pI1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOS4QBWMfZa0ntDYdWKw36vasyXju+x4Srhb59aFSe4=;
 b=UndIsrGOKbm/alGeH9XM75n37BZKdse4MJkpIVErOHYYRbGk6C8zw3OCl4tkn9/epOUw7sdwW4dmVqlwRdKdozbvVE1Lfrro/ecVz9u2n8f/FK0nDwgSAP5gnWWzzjFUvxa77fl1kxp79v/UA2hVNgV6M1KtcMV0A5P4PLKu5K2+NCSZT2UUX4jKlmcOtyL6V3XyOeGslqN/cIPC3LxPkN7WgkRvYjKQVdCCdWb6HxymbYWYmHs7Smkz8F/4g0OW5mi69fSczqP0zut2Q/gKQGT1iVWxvGfM79goSE5Ou266msPsx7SGiJ/jUb9TRfZAdxLDJE/wXuRsdBYUSQNWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOS4QBWMfZa0ntDYdWKw36vasyXju+x4Srhb59aFSe4=;
 b=PrVLNaGPvP3orqCriZppaS/1y8PZCh9487w1MpZhrV0lWTnJkSnaVcmWRhDC2vOKS20WOlrQF383uLxKxBztWqSyC4yF9MN8zsP3VgkHg/U4VZ6Rs9sVxCBWykYszcVjX6Y+4mF/f7NYPI0Xq/snxohujarKIoGWsYWJhACrATS7wYaOmyxxNrWSR7kd4WyqOzN5iXapVOU8kY9GWW6ll975eopvxTcfHOpMDErZ5WSVRdI8oPjd0Qx9687vQu5FbYbLOC299WYaY2qzQM3KW3/Dkvi3A4EPRqLEYa8ptuKZmlY2d2tpIrHaYYODMd/7Obld417HFyx5e1ZAaLHFxA==
Received: from BL0PR02CA0133.namprd02.prod.outlook.com (2603:10b6:208:35::38)
 by DM4PR12MB7693.namprd12.prod.outlook.com (2603:10b6:8:103::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 17:07:15 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::1) by BL0PR02CA0133.outlook.office365.com
 (2603:10b6:208:35::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.24 via Frontend Transport; Thu,
 12 Jun 2025 17:07:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 17:07:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Jun
 2025 10:06:55 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 12 Jun
 2025 10:06:55 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 12 Jun 2025 10:06:52 -0700
Date: Thu, 12 Jun 2025 10:06:49 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 05/12] iommu: Introduce get_viommu_size and
 viommu_init ops
Message-ID: <aEsJKZLRTf36Dh3Q@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB5276F17940D4B219D5B4F4BC8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F17940D4B219D5B4F4BC8C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|DM4PR12MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: e6f04d18-1cb6-4ff6-6dcd-08dda9d39484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UTD8HR328U7fIMGXgo+ybW/0jNXjfQokZV+mwmVA/fQXkBouSNXuTqe60PKa?=
 =?us-ascii?Q?FP2Iogxi1qsXKs094arjfR7rz0DImxVlMo9Fc7AdYbJ2KprtzLH3cWJ98Pm8?=
 =?us-ascii?Q?Z5rUAumWKbN6RDZ1NL2oKqeIKCysiNiyuY+mr9RUz0hb+yJpoEreRSxTxIwn?=
 =?us-ascii?Q?EKMkcabbcVeAaX4//bC23DvooyxoXdcfIRyB4fUF5S/ghPYdsYkzmhZfB+ot?=
 =?us-ascii?Q?tjSthBp1M53v+DEaPVxoTLSLrKAMVPzrURVDeJ8FeF+WLgwLwAy1n9XTS/0x?=
 =?us-ascii?Q?1kzbTdVFIsxaNcuIVUoWvOIVD+xpVcDax9fm89xWqTKQ5dQDXdkv2rYFeQ3v?=
 =?us-ascii?Q?6HmyUHFPsFaSmSI9vWCTuIwDl9BCOvX2YGx3fYcn/InW16zdXo5tfHg3XG7L?=
 =?us-ascii?Q?xAjdqsDgCZI72K0QES8WwHvzqytKOxBoOOyzeZI6+3qrCwzhGqa5ZdAhV7qm?=
 =?us-ascii?Q?dlp75I1StftEXOGYnrq2UwbZN5udoZ+Z5FI569/nM+DP11i2CCEgd9Ap1F7w?=
 =?us-ascii?Q?5fDxO3gw8S/w17J9ETtJhRTe5Ta2DqK8KTxpjYsn2P6aWtZSsba80NMCE5yS?=
 =?us-ascii?Q?0fLt6wCkoaQYENz9YW20F/7zjPkTX4o4SMpcMAuUlPwRi56QvLELcYs31DbK?=
 =?us-ascii?Q?/XntLKGWLBNpM8kCxaaVXjNlyXGm0QgZOaZ8OQVG2ztL1+4cOEmJWj913ZTa?=
 =?us-ascii?Q?Mj1zj4/3bNnevI/65X1wZ6HcKmLOXudYAzPKwsgbbmmqI1QhRMghdFSVY8ot?=
 =?us-ascii?Q?/e9o4adAvaeurd+2YUCFApS6FDCeqq3eqmylKuhv6Etd+WDhyxjvyj8tUel1?=
 =?us-ascii?Q?WbMhivAWU+ZdeLlS5VNMzHgAz80nQF/3vvUEIK9IO+N4sdqZkyOuMt3qAnJB?=
 =?us-ascii?Q?524i9IKbwCw7w9rOj2UfD9q6wvBZb9lpip3SAGHYN1s+n7iZZEzvL7SuI3zK?=
 =?us-ascii?Q?Bl4f8oSpXdKDEWHMlmgyuIgj+pS9iwC7FFUgoOVEtUfaIExyn5KtQqv8A/Gw?=
 =?us-ascii?Q?JP8uJuFfCJbsUqaHgpK0rIprE5AMtJFt8cRiupqnUgFR7OqQelF597XAHeP7?=
 =?us-ascii?Q?X5E3eukNicckrzhmLsaXoqrYrmBsav6AhcBP3BLiPGdYyXOXGlZN/ZNj32UQ?=
 =?us-ascii?Q?WotrjI0YExwTSmfXdBh+ZOSF0ZQUxP/FIpLyNvNrywm412fFMHjh6vCMHq37?=
 =?us-ascii?Q?ex8z0nYMGsuH2Csz0vc9Kfe2Wj4imhiSUBPtrWGGN+96gKbiXgbzgIHLwmPy?=
 =?us-ascii?Q?ZV/spteI54q+ilSezGcZMfPemgALOq6eIxE1PXRNVfhij0fSUqC0+HulBobM?=
 =?us-ascii?Q?PUmJFZFH/TcS3Jt6c1GpzxsVwDwmgOs0dLWIHRRI99AznIjzYel41YGqBANU?=
 =?us-ascii?Q?Rnto8x38NVxpREnVOehPUWEgcqljxZ9oCySedrmaPK6MLGzYKPRqP/Qb8GNM?=
 =?us-ascii?Q?SaY9/+oxjxcT7hevR0zaGP+EJOc2pEXDQYo1hSfYN8X+St5a48Ehr2Oj9XEP?=
 =?us-ascii?Q?xXVp20db+K0MRWNcK2ztvtuV0Mq6j+kuFFfZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 17:07:14.9908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f04d18-1cb6-4ff6-6dcd-08dda9d39484
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7693

On Thu, Jun 12, 2025 at 08:12:29AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, June 10, 2025 1:13 AM
> > + * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a
> > given
> > + *                   @dev corresponding to @viommu_type. Driver should return
> > an
> > + *                   errno if vIOMMU isn't supported accordingly. It is required
> > + *                   for driver to use the VIOMMU_STRUCT_SIZE macro to sanitize
> > + *                   a driver-level vIOMMU structure related to the core one
> 
> What about returning size with '0' indicating NOSUPPORT?

I tend to support other errnos here. Basically this moves all the
driver-level sanity checks from viommu_alloc to get_viommu_size,
to reject an incompatible case immediately before allocating any
structure. And there can be another errno than EOPNOTSUPP.

Thanks
Nicolin

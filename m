Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286F192B90;
	Wed, 10 Sep 2025 02:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469828; cv=fail; b=EafiUR5RuGJjdxhQGMMSX4TbftluiXdAjb15mCPXR5rJ9lMzddPrcebrk0L8NlzP5+uZNACUsE6iPSfa0F7vLDQPp9F185SM4pGn+eaoqIf74+QBhvJhkNfuNwI2ok1kXZeWv09eRRCrWNn4eEwJkWUAmxN2csz4WJ6BCLEbc0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469828; c=relaxed/simple;
	bh=g1+tSd2E/1pJ5apbHezuNEBViHDWtQcCGAwBqY+JIKY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muWONjQ1GskMc6ONQgJLWVTGzPHh5MYxErF34t8XvnBC7NWNA2dBsbspJse8BVfqfQPQfWYZ4/wDJgvbZwUI+HnFOEYlRDHRDdrfUngsMH2ql8Lzg/kEnfYHVD0Cm1YxwQ8OMRwxNzkahU8m880IhYXraWILMR04H7XV8fOiJOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ixv4HO+c; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ixv4HO+c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMZz30cWX/Xm5UTFk5FESN2vH1qXe0Op9ShJws2hG/XajEBeIx88Bj14EG7ESfaksbg+JL02nCF7gNIE4xxH0xaVnEBaIsTqPGH9HBw+Xk1xQISY1QX/6eUwlvB2BUynKc9rih4a9JdXBpEfoqNbN772ARlDzySndU5tvF50LHxEIiaOMc5uCr4fU4CJ+4TR7gFN5qF/m8hsLRJBXhzCQrl0z2DvH8SSY55iMw4UFsMPWIb6y+4CNAISPjlxDs+O9JJBpvNXWqRGLOac2uZ2/K8WIPkqFGwzPspD3112aXy6bnGn2ubwv9asdjp51XwLT7w0Ynaj3Y7zke4e+UptTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jByL5tfNGOiM90GWwL/gOaalcpj+vbWhJVSeYgbZZVg=;
 b=xc1Y0lIsjvCq1VqYvbd675xW0ES53qpVr7i7yej2qmShITZaJZN1q2qSIWfjd1YzlQ16LO0oIAecFl9AIq4H6D/czi8iMWxGQWb3ufP8d1mrA625g7QlosTRVYr3inQsY3E74x8pLFEb/Yj72pWl/cnvRVKuK7OIyQsFLruPeiZnK4M7HLTzHxuS+nk9kHnIDP7pG99ABwfkJH05m7FKG2IhmtJXM3ukCZ0X0YZfojcAWsgkziztdd2BqLzXbS3u9wKIc3pPXyFeQZTKxL1N6xj2yh/jmipaUcmqTtSC22cFfd5LFEdONT/CGqiwcB4vVz3jbToUVdjsbYv2313anw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jByL5tfNGOiM90GWwL/gOaalcpj+vbWhJVSeYgbZZVg=;
 b=ixv4HO+ch0Vr59j1IRfPpmuQqLtp7JZQuLtqVj3p/y4G+wSijwPe9AJ9AequJoC4VovAOoChPvXaYTPiN0Q2l1LVnWIq1DhbC5tiQ2GCunqglSFDZGPau4lyY/fH1W54GRjK4OjKCO3UvF/WEO0BQTUASDdlj4gt+9Ef3ixFyPVn6PsQ8uD1o/A46yRi3E0I2UBqgP4W6JBRJttu9h3T8kS0olJtLySeiiS+ci4Rr0vxBk6UaTvYYY4PKTUztPdUs80IzpYKH3HldernSxv/7q7omd4E/siyimXtYno8+F/Ds2Av1JLPC9QlPUkcWZyNnXMfDllRqdxTPe988aoBDA==
Received: from SA1P222CA0067.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::17)
 by MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:03:43 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:2c1:cafe::9e) by SA1P222CA0067.outlook.office365.com
 (2603:10b6:806:2c1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Wed,
 10 Sep 2025 02:03:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 02:03:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 19:03:37 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 9 Sep 2025 19:03:36 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 9 Sep 2025 19:03:36 -0700
Date: Tue, 9 Sep 2025 19:03:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 1/8] iommu/arm-smmu-v3: Clear cmds->num after
 arm_smmu_cmdq_batch_submit
Message-ID: <aMDcdmlyCH2ZALPA@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
 <d2852d21-60bf-4ca4-a0d2-e70c0c6dc010@nvidia.com>
 <aL++Qv8bNvL5qjL8@nvidia.com>
 <9d463bc4-78e0-43f3-ae69-2746ab72e318@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d463bc4-78e0-43f3-ae69-2746ab72e318@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|MN0PR12MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: deab1174-f6d7-4f77-4178-08ddf00e44ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iH/Qkmuo+8otsU+PiVybdl/drK6ext2LkJfaokmfl3WamsshERDZA2ey9foF?=
 =?us-ascii?Q?4eS4L/CAYkdLbNlKVZRZWc5Wi91XcQnhOJ+Qxe4EjMHYnkBG6iNUdbn1rAOF?=
 =?us-ascii?Q?mW+3GnBm+vqv9HWzxqtSQkr3VkdHhtAW0YtTEJDN/lCF2jKto7o+tXEbye4D?=
 =?us-ascii?Q?3Rbd0ajdr9We2Wp233MBqnnrwEqC+B+N0Cu4qc55PmZ5VDL0boIUTGkMJrl5?=
 =?us-ascii?Q?7vnf6pnFRQVJJ/XeIGawaQN3dSrri55+ThilYjbJHbcvOHaSsT+O+Rggu2+l?=
 =?us-ascii?Q?KnDSLMt4roIxzUAG7tUkU3Tb5drLtB9RPSa1bElyPP02jmdIMuZbwrFEkdFl?=
 =?us-ascii?Q?uQv5ue0JarcHck/lUlxaXFWJinoomSCgdOX9Arp6Hh6tAvIsXKgnnfilKKCu?=
 =?us-ascii?Q?1pUN80uvgwuOlyQMDq4SqJnaF99kLpYzoMFm2P6PBeT4EGk9X1USWUMtNuUi?=
 =?us-ascii?Q?zhCA7GdgYVZDclAQn4tafvTUyKlxPQp9Ot3qdSE0Seaxe2dvftQnKMghn65j?=
 =?us-ascii?Q?wBGTIfXTX4RacmlkDiyba7OquBE6fovnJJx6+oJI1P7i4S8uF8XUgt3RUZ55?=
 =?us-ascii?Q?oW85f8hFlUyD2emsugu0lQH9ocw0nUf6WylwVQxb//yb2GOnIuHd1zcRp6xy?=
 =?us-ascii?Q?cvPIEfhv12vYctxe56suMmhS8LxPAXVd3qKXm7oW3k8MgdSku0K1ubNvlQGz?=
 =?us-ascii?Q?leqWN/PhR4wB09IVlVc/vyj1g/SzKXWK/km4YBip4BLGhTiA5Dbm+LsyfN77?=
 =?us-ascii?Q?Gtd6PbhMdcrPgmpNB6oLtT9f8bm92EEwGB6/7IqY6thgn62rvVAaJF+93Ub/?=
 =?us-ascii?Q?utyNBgQi78zs8sQPtHgOxpdrjQG9sU00397SZ8x0oS1Z2NNcuWxHcEig9HS4?=
 =?us-ascii?Q?rX83yT7K50O6/it88LS6AoUVa4wU64Emm1Nkx7n71nnwJTydLXrhvikVC+W2?=
 =?us-ascii?Q?ofn9b+Agp5nSwCqZGnVn912ZqkPCsHCWQD3fUpKqCNT1dTPCt4IoV809fsRI?=
 =?us-ascii?Q?O/BUBvnZIM/C9rzXSqD1/o6XQPaXikcaqpnOGct96EZjpiy140vYfhvZ14Vp?=
 =?us-ascii?Q?UI8qIaZlT488FCKKaRpz0lFF8lwZ+3CZ9WjoTLVVY+s2N/Ncyd0nM+nD/ryT?=
 =?us-ascii?Q?e1g8jNVYVflyr79y+W0QBCChR0EnI1S3igvAw9rV5VTE/CoA0eD1UWw8BLaI?=
 =?us-ascii?Q?lnINu5duEwDy37kobJn5gb+Pz9qTOrcBUr3hpshZk0ZJ6v53kbvpVM+KvmjO?=
 =?us-ascii?Q?f7ENhdXmAOb/lMEx3LyHob7LsUJZPlorLCTfsTkdZWOuOhMid2Ia5hSp+4vN?=
 =?us-ascii?Q?IL5MYGcB0X+QxIOcR00iItGFLQEg5zM8eZLpYlcquXSA0Dhdxr+ty9WhDKIr?=
 =?us-ascii?Q?Wrw/XxFNOUwxLixG14NBMw/E0TQ9AP/w+hvRPcuJQ/KzmwPZ4/zYMwVRcQ4E?=
 =?us-ascii?Q?ljf7VN9ffO7U+bPZ3cwQ+IxwA43pFt6FGvsqCvNioMditAiiPDAjk2SKQmoR?=
 =?us-ascii?Q?Qv3Rov60ZRq6gAAjmafM2n/RuwA+kOx93dPM?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:03:43.1817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: deab1174-f6d7-4f77-4178-08ddf00e44ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5713

On Wed, Sep 10, 2025 at 08:49:52AM +1000, Balbir Singh wrote:
> On 9/9/25 15:42, Nicolin Chen wrote:
> > On Tue, Sep 09, 2025 at 01:16:11PM +1000, Balbir Singh wrote:
> >> On 9/9/25 09:26, Nicolin Chen wrote:
> >>> None of the callers of arm_smmu_cmdq_batch_submit() cares about the batch
> >>> after a submission. So, it'll be certainly safe to nuke the cmds->num, at
> >>> least upon a successful one. This will ease a bit a wrapper function, for
> >>> the new arm_smmu_invs structure.
> >>>
> >>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> >>> ---
> >>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
> >>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> index 2a8b46b948f05..cccf8f52ee0d5 100644
> >>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> @@ -974,11 +974,17 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
> >>>  	cmds->num++;
> >>>  }
> >>>  
> >>> +/* Clears cmds->num after a successful submission */
> >>>  static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
> >>>  				      struct arm_smmu_cmdq_batch *cmds)
> >>>  {
> >>
> >> Nit: arm_smmu_cmdq_batch_submit_clear()?
> > 
> > Probably not. There is no particular point in highlighting it in
> > the function name, as there is no use case wanting an uncleared
> > version.
> 
> I did not suggest we need an uncleared version, I suggested the change
> in name to highlight that the function has a side-effect of clearing
> the cmds->num

No caller cares about the "side effect"...

Nicolin

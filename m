Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239361E231F;
	Tue, 11 Feb 2025 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739298046; cv=fail; b=MEqRYkZQ1p0EWaHw+08Qq//WzG+BCxxg6kFS7PFYJoZ7A4opa4J6vVcihRns4Tau7VQy+o+9gc0fKh8+OJEUbcSQRZ1gs3cofh8X2gZ9Xf5y7CzPk5z1lCO1dfp7EQv0dCXNFTvbEZq9fbcX0Kea3P06dvNqKTTUGiyGErgAFSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739298046; c=relaxed/simple;
	bh=d3YPB6ZIt5RFscAxBk5EROYYnigfh0EBGJV2kpz/NV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XQJk0SU74TN9cQszW3qZ6gMjfOUOBebdRNsQLHp1QRjNrhxzqXeKlK0Pi6OBK+A2Shec+wJvZJpC0JrLe3OtKOYxJJcUhSz1dMJH7QAESzUFD8llM4baqJyezcqtyVfyvIptJcYe3N9efO4LBWcz8ElYkee7mUdPLxioCVaZ8+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NMJxHNZe; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NMJxHNZe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xyezEU6ys5ucZPFWaFEO9mZhkCKdFCCbiLkpXIeaJXW/xICfmVButD6j3pojoTrJqEMkbGcwywFT9fUWp1f9g04qlTheU31ahNoYA/rGl+V6WXSsrIExqhhz6Ooobdb2hVDFOT884zVqbj/XTcRkg1wRnetarET3bFbPdeeffoodNKD/EWh7tb/sLgHpREFkbj2sgH2y1NxNIcLU8WgifDS5LgOyWOFZMRy99x2sHWqIHNFCOyajtVWr49ZSZvNbMnZ48e0pudncF3BEHreJZ70D/IBZTBTVAD8J8y4kiqXHHh88B4PzQs9lmqNGy4zDQ0l+KGiX2hjpLl+BI21WcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zMQGOJrV3tGSm3Qr0dBaCrqVuxNSLLmK91VPLFaN/g=;
 b=XNPJFsIoivfeE6r66F9/349mRJlgSFY2Cg56yMKWQi60++TuRjLrmIHA72ANt3fe8/u3xZyAhD1Hx+YXoKlqi9STFJirnFyHWTwCDZZ8KsiHtPbSEWfG/RB2l94wrgi7keUE9qEVkgfHlv5kiC264rHeXBztDXb+dqffghPuJfKWOhflyqzBP7yWgq+n3A0EeqT9UxbtnNqnprJeFFPTA7y3sqcA32VcvSioF0Fa4Q++iqiGGm2teLtkAAEey9u4CzblBCzz44BtOWS1hp/O9bp25+GsOCRpsVUgTtVMqIeVJ3WMJAwxbUKKJnniTSykQHeB6xFj3woAAcZvdLh6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zMQGOJrV3tGSm3Qr0dBaCrqVuxNSLLmK91VPLFaN/g=;
 b=NMJxHNZetfmQoMN5X1BQbdhOIIpbNziSUoNB3iaXoCjDnkU9zekOVqw7Y/f3sdd8p2jK41OX4I6KqJ3B5llas5SH/sYVyv/qveHqH+AMZFLzwXlWkw0zNfUmo2gDucr13VmSGC9Kfg9VVT3+HT85ACnliMtmO4QKXqQxhaumLtByHrww7N9kMmfnPEgnzaucLrnv8ZFXkJAAyCyjRa+LykTAXJfwAQoaapkvzB16+w/X49oq5oIngJmySwUDynCI3NnGNdP6qkCGlsYS5tTiJfIFh7QL2P7Bf47DfL5jQF1HviPU/e8HU+X7s8dcuuFqY01JCF+qMH8h7/+S6ymWYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB6921.namprd12.prod.outlook.com (2603:10b6:303:208::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 18:20:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 18:20:41 +0000
Date: Tue, 11 Feb 2025 14:20:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, eric.auger@redhat.com, baolu.lu@linux.intel.com,
	yi.l.liu@intel.com, patches@lists.linux.dev, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] iommufd: Make attach_handle generic than fault
 specific
Message-ID: <20250211182040.GL3754072@nvidia.com>
References: <cover.1738645017.git.nicolinc@nvidia.com>
 <32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BN9PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:408:f9::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB6921:EE_
X-MS-Office365-Filtering-Correlation-Id: 81313889-2c6d-4bce-25d4-08dd4ac8cad6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8HggrNhwj1GNUP9jB1tXnyd3NRk0laf6SZF46mxyLvQpinoVHd2ppXLr9RJn?=
 =?us-ascii?Q?RtAaQfB5d6XNQCjqBec2GoVnLjjCavF8wX1QOhEOJ5doWVuBHrS3dKvkVbgM?=
 =?us-ascii?Q?lL1z6heJrFOETmOe1A9rgPCd/5uzmriPkYhw65z6XS4S48IinJsoOEbyMXqL?=
 =?us-ascii?Q?gJ3WjCo8IKGnxMG5jMJxPK9EQT7Q7/+2NFIcL1EKP+TfGKjCU0GgoSEIpaRH?=
 =?us-ascii?Q?Dl/4z4R3sSBpN/cEzY33ofrhuEMLrgYzkydAM7hEg36JTwreex9YsCie7+wK?=
 =?us-ascii?Q?Kd8VZZkUXcdgdMDPCm0d/eb96cvjskBrDB+zMeZTMkw5ThXOIT/rp6YI7kiQ?=
 =?us-ascii?Q?cTnPQ2GTSvmrtEZqjVHbgoMn1jjEu4f9PPg+tayUqS1CsuY+siSDaWbWTyJq?=
 =?us-ascii?Q?/lmVtSUbl18ppMqJwSjGlDxzfGqIuGFDGZqARHxnSrpPHY0Gv/tTH2pT5p0o?=
 =?us-ascii?Q?VPAzEKsP5ld2kntrCz/lTeujHXKN45JFityavwdxYm64sehcNqQACaMwkztm?=
 =?us-ascii?Q?a+v95AVz8GNgl+uqmRkSnAJtTb0+1qUbFzxba4M5rdAttXze92zYBdMXqQBL?=
 =?us-ascii?Q?b9TfeqBPOCvqT5yUL1jN8jUKf5Xe0eUwv7tAHnJzPl0mMHoKFhjgyOc+Wx77?=
 =?us-ascii?Q?n2+pjgMLuE4eoUf0WO3oKJUdu+mc/HjCGAd9S9Wguk/WPeoPT8QiNy+/dRFG?=
 =?us-ascii?Q?4V3+Mb78qNjiq/gU0SCeWkPzYTB1zyg42+9n+ztUjbT5B4KGQ55CTopruKkS?=
 =?us-ascii?Q?9y0ErkSyGGKJjiyQBQO7yvwxjKxeYuQFKPwwekfahdNaMHh+zD7mHzXUeZ3v?=
 =?us-ascii?Q?Pmhu0UIqpCpvL50lJXI/mYnExgQtp6mdH6VXTIRD6rWBKUUTX3H899D7Z5o1?=
 =?us-ascii?Q?D5Xf6SxKIhuPvSFQlxrFKwFGj6scG48PBqR4ze3tAyFsuXKJOPyUfrSw/cdo?=
 =?us-ascii?Q?zAyB9HFOVEdS02urAIUYARII7xChZ7vJNQYKrR09j4IISZdx6EsYqTE1xCWu?=
 =?us-ascii?Q?nZl5nOQZUE9gG4+vVS5EVWJaoFpLg1cMOm7PSc4WoXgxlC0UTSgndvOJaPo/?=
 =?us-ascii?Q?pisKtTkGBBWpNOJAywynCdM5r2CWedbTRoV3irRJwUCc9cSObIl/SyKKwXUd?=
 =?us-ascii?Q?ZFWgx80oghXvsE9NX52SVsZkq2gquaNnUaGlBk/ADVF+Fpq3frtOkgwdDbRl?=
 =?us-ascii?Q?JnIKsEp7XpZXBSAkAuIspLaeYcCV/GNFY0fhIjsDPlwYA7hHI6sWwgA9k5db?=
 =?us-ascii?Q?jrG6/eYSLRuiYyCbG0a5ADyJuzwjXktQ3OHNYVY6PjSbAFfXeezHtT7XMZac?=
 =?us-ascii?Q?h3UlcX7n/1Yz1vhOUG7XWHZt6QiIhzASwyNHH6+dzGKBCH2GXa1/Aq1pV5Cr?=
 =?us-ascii?Q?r+oxQn1qB2FKdFY42liF30t/SYSa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/EBCcy6D55TIuCPxk/d2wpIGdy2eQwZiy4uMhX/Zx55CdOfdjbCNyUgW+OcL?=
 =?us-ascii?Q?aGdlwO5iyHn/LPmLu04Z2ATozm9kFzGgMzTAkvdnS8no5w3o8nB7Pz+MDY1d?=
 =?us-ascii?Q?cTSkugq+M1Br4Gcl/SwdLGaLxdJhkwCYZf+tEi8CCv+r9th2Ydo3dN7YVGCd?=
 =?us-ascii?Q?I3vhAuZx8KHq3E6eGDw+lkmRX0Q6ovJV7SeglmDZzjiGxrUbfV2cRENuvka9?=
 =?us-ascii?Q?E7ixjE+m6cCyd4Uhfjdlt8XUIknL5vNbzcFfewFwKBezzr/O0SVRfv8EHfUz?=
 =?us-ascii?Q?EN36EVh5NZN8I5LjfRwNNzQflEKMCVMaRfVPPPs380MuxfUT652s/bcv+J1V?=
 =?us-ascii?Q?+/XlXrOwNtb1tWsbbQ8aPq5YA+nOaYvObqu9yaLyWY6AEFtYmfzG58ujXDtH?=
 =?us-ascii?Q?y92ALZVXZZ7rcALD3m31vCVdsom9aQWWTXoooA1J/X7Y5cFxKjf3vC6Iy+We?=
 =?us-ascii?Q?hNwoj1sKVar3/9CpjtG9FFJMoNzunaZl1lUpxcuyLyj3XYn+xSI0TrEMBC9J?=
 =?us-ascii?Q?U7kDaLWJDnfuQbxMi1NjRxR2PI3VG6s6ksLtgUtKTQCA/BOXkCVb/UJga9Pv?=
 =?us-ascii?Q?eIp7m9g35HZ2BiYk3NEPAbULfOgwJ8THkTYVSyhT340nj0nPZ82vkfIZj/7R?=
 =?us-ascii?Q?oNKl4MOliehFKvcWGsy2R/2+KMncFEUHu4nYHxDZYT7SAYdLMRsuxGOuP4NW?=
 =?us-ascii?Q?ZrWwb8f/9cVwVfFk4okLP8K52RAu1wrmj4i4tfS6hZrZhRYv1e0YHbs1Zoow?=
 =?us-ascii?Q?MudgJT7MGbp7soS7tEEn4dRiBjV4Pc7bKoDtUQZ2Y/sj0JrZRE/aVm8gyFDm?=
 =?us-ascii?Q?LyS8kVtFWf1oYbeMec8bJb/MdGlD3pPPR6GE+MoY7ionVhJv4c3pB2MbRP1B?=
 =?us-ascii?Q?Hi0Lo6ZiST4U4A+/BocmG2RMNEinOlVftkCK7zJi3YY9A/ljdWQxXSoNnfbt?=
 =?us-ascii?Q?OR3jqYnmqs/Pz1HeHDBK5zyJeegeNAFkxKlhjkIyyJkLbP0oIc4Ic6BHWZly?=
 =?us-ascii?Q?zPvrfoqzjmpYzjLCZ/TDUW1xumKyB9fOP/HMIXZfSNNh/NW0UDEm93x6Gv6h?=
 =?us-ascii?Q?44fhcIdICiJweQnrY1ZFKs2VTkihSHjFkg4J9gEvKFfzdf62qi8BcyDZ7aTA?=
 =?us-ascii?Q?XwnRVkRq+uwOW4Nz6x+k1rdiU03308D5zfT+q3mRWKTdWSeiSqnTgKhD3rjh?=
 =?us-ascii?Q?aplNI65jXNric9n+Xq1ORLW98PKaGuyIzmNvvMChQec6eLyv/9qbBpV3OAgv?=
 =?us-ascii?Q?EfnQQt96Nry5f6JnYvELrWBwRA32pZOhDtoHoRmx6kV/fZ2kswWcrb4BgqZS?=
 =?us-ascii?Q?DCao3/KedWLCa+KdBl3JUEIuWFOU+zMoqGO19axzjqkHJNPsk3JbEBg4Qhvl?=
 =?us-ascii?Q?6VdvNZkUR6OsMhIS+ZdYhy8E05InKP1f7S345Y3PHcKYaW0UGp6KEU/JUQGN?=
 =?us-ascii?Q?E43QLr1FfKoD+ZSmVWK4CLx/hVVal3Sa+a3XQPSGOzdiRcyKJa3W0g2Fk0Uo?=
 =?us-ascii?Q?lTHdwBEmyomtNqU03eWemsp/JoqtVfCAVf7k/1AVB7CnQ+Jjnb8KM5YG1JxF?=
 =?us-ascii?Q?2Q06lx4EO/ds3w0wLKpv30UXNBq6md3oH5Wi7ihe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81313889-2c6d-4bce-25d4-08dd4ac8cad6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 18:20:41.5265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQeCAacAIQpW+ne1wfBsG2pXkGWK7w1A7+HAESgjSufNpz75Is5ABawFXx2No5/x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6921

On Mon, Feb 03, 2025 at 09:00:54PM -0800, Nicolin Chen wrote:
> "attach_handle" was added exclusively for the iommufd_fault_iopf_handler()
> used by IOPF/PRI use cases. Now, both the MSI and PASID series require to
> reuse the attach_handle for non-fault cases.
> 
> Add a set of new attach/detach/replace helpers that does the attach_handle
> allocation/releasing/replacement in the common path and also handles those
> fault specific routines such as iopf enabling/disabling and auto response.
> 
> This covers both non-fault and fault cases in a clean way, replacing those
> inline helpers in the header. The following patch will clean up those old
> helpers in the fault.c file.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h |  33 +-------
>  drivers/iommu/iommufd/device.c          | 101 ++++++++++++++++++++++++
>  drivers/iommu/iommufd/fault.c           |   8 +-
>  3 files changed, 109 insertions(+), 33 deletions(-)

I am going to add some lockdeps to this:

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 360ba3ed85455e..0786290b4056df 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -360,6 +360,8 @@ static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
 	struct iommufd_attach_handle *handle;
 	int rc;
 
+	lockdep_assert_held(&idev->igroup->lock);
+
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
 		return -ENOMEM;
@@ -391,6 +393,8 @@ iommufd_device_get_attach_handle(struct iommufd_device *idev)
 {
 	struct iommu_attach_handle *handle;
 
+	lockdep_assert_held(&idev->igroup->lock);
+
 	handle =
 		iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
 	if (IS_ERR(handle))


I think the one in get_attach_handle is important to discourage misuse
of that ..

Thanks,
Jason

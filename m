Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011070.outbound.protection.outlook.com [52.101.57.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A6420874;
	Wed,  8 Jul 2026 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783516561; cv=fail; b=LjQ4XxUhrn2gCoG05+bicv1NIYoBm9BPdqXJxJD526KxAcyyPrCN69vLbkTJVk+hGTjuWZKk7WQauKaXgqC5/vo2iJcyi4vSV/kLnBjFpebCAv1sOQxcW8kfAshYwLfSIqtWHexJ+ALwJjYinIdjrZAaKzSGNJiOskadTYuDEUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783516561; c=relaxed/simple;
	bh=fOiDPoXimLeRLsYeKRa29lwM4ApGb2qE6TI8+YbHWLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DKCIwAAWS1D5ixWyx1FZNH22i4hWFwemPJW1GVlSRj8P5inA3MhRXnmQU/B1rqKq8H9wwqkhM70Dek+KNUYxp0UtjV6l2pd1IcOJms7zJFI2BcMag2TO2MSsNfH+/SRFaCgDBuuJSxAZAA0S1ehOKscZjgKv3y1Nz/egUDyVeKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aSFpuNTy; arc=fail smtp.client-ip=52.101.57.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aSFpuNTy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6cX8qsanlrNrqcKiDY2CGhyEN62ktUNs+Wr1Msylifnl/uM4T/JgslQUSGhp+m8juOFScVSgfHFrogroZokBhgbFmOohlOVYO0BxKYWENfes8rbv0Flc/usXZpay9IRRDzkR/hoxUEXbB+Ln9iyeVK03NLwvRcyt8viNPwjEehjqYgOjWvdlfX6p7EJL0XCeQvEDMwk+xJOiRB2Wzm1zmOJpBSg9DZRqgYlDWNAFb65lc77ZnCHwkfZ1PGnyLwY82oJn3MiCd7DORyvkv3bSZZ6s6vWnBoA1mtoaqlFoilDwN4ExXXBSP1OZKKcxdhdqEle0OWO3ZxatvDOp+D7Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PI5oP08SAUuVFDvBIqR8npejMXtq170Z+GeUPaPrndE=;
 b=Dd1BanHbjxYndjYDXljMxoFKHNZF59TbtzlaCpNY2NN5UQhmhXpZ40sC9Sl98tvl3Vcu8CXxeLV4imjU1vCYKriZ8Rzr5g3N7kP54z5JEcvElnn7/jleUwv64mBrUIg2tu8HDaWUClgGO5UsRWB9kXd87qw2zbwrxJPlR3qXmflf7I+zJihaZxEWm5lcQToulzghKs/6Q7Rrzmgax70AIu1Fpt6uJ4XVNXcXiBPdecWjlNFNsBR2p2n27phybs7Gt28X6w2Dv6Gq+vrv0DbxptEovhZTGRm6lxfk78Gdq82fHb6oWGi9H3I7XfqLkIsctyDYf6aJ9t2eh2tMHWIfKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI5oP08SAUuVFDvBIqR8npejMXtq170Z+GeUPaPrndE=;
 b=aSFpuNTyyrleDhRYr/z3w8gAMcXNiF9Q7m3fwZGuOLzi0y8pDg428ydlwIa3IBIUsRwBeUIIj7HIYpzJyXd20XnUs/eHWg390JHvyRhQSXjP1yXEeB/OhgY9ChR85Ap7qUdAv637e1zpzUcerRSp1dnX6TyqKwU24JPC1sGT7nqmv9siLcbj7l6pUpn6ouMhMKy9MOWRzBkDVhHgBdHURtFFpOqSDtieV+78RgUaOaDRyi6+rCsHG3MXP1Aa3cAVL6XwCpb2fEDn94v4kEr0MGHPUmxoUIf3XlNNibVUdTwb5ALRII4xYmU8P744auJwHk0yzjTss7LKUnq/QsCh+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB6923.namprd12.prod.outlook.com (2603:10b6:303:208::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 13:15:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 13:15:54 +0000
Date: Wed, 8 Jul 2026 10:15:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <20260708131553.GA674038@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzoeexW-4W70QdU@google.com>
 <20260707145812.GK220801@nvidia.com>
 <ak4Rwnr39HuP053s@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4Rwnr39HuP053s@google.com>
X-ClientProxiedBy: YT4PR01CA0491.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a52949-17f6-4a14-06e4-08dedcf30a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|7416014|4143699003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	HWMhIK+aiHrHFerJ4h2nRycfDBlr+nr0ZCxBQrxh+afkD3QoHE4QGmifLc1zfZGPZXRpEkWC5jdqvzyGVxPdgRkWVxjGHy+EDr3JVAG76b6Vly6ilFcVjAHLccA7Syq1lC8TdLHV9mb8KeaqB57zRdnCU2RIC6Z7ru3bF24XcW5kKFEfn3jlseCiFc7csCPqqwgZ3RkwSkgN5iGEiHe5MSR2fvCFgG6qYXHvpH/c63UZz6NMxAwnOJicRs273XIZSfsBZtISxl2+I9JaQc1uOhVLECOxbJ9KuYPKjvFcrMApVyDCfZ6TAWrxLL/XDojWeaCdKjVxXB4HhVuSNLRGBkBz08nywvrpgCa7/Uvl0hbbx78cwh847i8DyVMAGwPMHjPFLmgCcc17nKMNpEG1AhlxHzgjIwompStryei10KgMNyCGK2DEg6qUItnQUF2fyb5c8XpLT8Em/VS99xk++aMvVS9I6PZ7D0oLQo1JTS59IftCLoSpIl8npAX4UgssYZiYepnw9IKBPmj+yVakbIIh1ublXh0JrqwZx5Np4iivwJl+6WLlCQX5UAl//1VSLfORa2PKvzB28TkkdycqS5BrkArFW8CTO19VmbAb+Rbfl0rZpMNwIwP8YiO1rnegzt5nLn9AQmqMJQnFNKrtxKtK+S1nF6VEzulnKHkjD7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(7416014)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A0Ku5neEdyGPDEv0yZ2vqT+jTAdnggJUqnOdR4Xl0GpN7VWvTgNXq5fudEyG?=
 =?us-ascii?Q?pCjOfQIEXGkiHNxLM23c247DksRgRORw+xqweq8owiFuWtErNJurfgfMTCvI?=
 =?us-ascii?Q?U3+KmC0j/M/u7KUF7NjAk71MnKdgjgAvqdP603PsO9kzn2npV2WuNwK7+3CI?=
 =?us-ascii?Q?SlDDSURXcyAb1wd7n2M9ifhee11qKSEfgtjkATPOCkeTAfCKMTWjAiySGRW8?=
 =?us-ascii?Q?O7uMGAoib3IhFpFEuV4ojIIdPgFx8MgsOSnS36ZdA8Em7Of1jOyDF4hn43VT?=
 =?us-ascii?Q?s/8H1FoOFa6mzOv6ZKbPrt3tSQ7iB8HNm+9h3AWpO8ryrrvp/jXA2etO6wJx?=
 =?us-ascii?Q?r/CVi78KZ1AmOGDYS/RvzPeCyRg33r8XuEVjaWbgfzlH9MiB8wP7EJNlD+qo?=
 =?us-ascii?Q?G7osn5b3lD9BYCoDm4YsuAfhUeTdcrw++TPp8/6IbKkLnANUERzwGiHQhXGs?=
 =?us-ascii?Q?ppSedp42X2XPEjZeQkO1A+rr7s4Oe5XeXvPDfBOKKs6NujGKUrlRTVcU0yjM?=
 =?us-ascii?Q?Vfi3s5GjglvEmGkxuhgpobQeZgL9F0ZGqJ30lfWyZ/hG6+5IK7Rpu769aUKc?=
 =?us-ascii?Q?SgLl4DlQ5DFz5CNnBretmlOgkucu2e6fVeXHIwkPjYGI65IMNeyWYSQiucns?=
 =?us-ascii?Q?5S/o8iqJci7VHMurmn9IIqFbMZXRuUdB3VjYFuxNsmeYVl4Pysx55aEd7FM9?=
 =?us-ascii?Q?Uc9Q6CF0st46UlYt+00Nf1TUGmpwPiRGQT8YAmEEOV2/DM4ebJqwuGjIIO32?=
 =?us-ascii?Q?igjwgOBrKKss/tmUzUCEgkGLnEvljyWBjkybVL/pV1CKR7EwIb70iNBhkwCf?=
 =?us-ascii?Q?RpHwp6Jin2V9b9E4EmtVqgXnHJzNbjm7UxWOTElqjhWYd4JqKh2qDONBhldr?=
 =?us-ascii?Q?7JY+Cd0sz8g9G5RtPvTa3Mh1QEDaP3WaQ9yXIbpajwqInETGUuxOeFThNrhc?=
 =?us-ascii?Q?PV0iY+JeyJaC4MXmasqsvQN1Xdf7u72nUKt/KfN/MOFXaztLjlb6GMia5o2A?=
 =?us-ascii?Q?Lps2zJlDg+CvdNPYwp9yGcm+yofISXVIGtZgnhbrnsP6y5qw7hOwYNyOS3Cm?=
 =?us-ascii?Q?rIyivPAgJfYZQlkizJsM1IL2E3suRU4/kJlE2eU2ANop3zyOKdhHVmYIL5yd?=
 =?us-ascii?Q?1i4TweQvHNen0cCj+1oZDOsDyF0prQqYglvU+lK+PbtFuzG6/KIdQUugqb1e?=
 =?us-ascii?Q?2J5jT5fo3aZqDy8SxqOx5ZDzm4j6uCID+YPNh6hlclQEQDUHcjPmvAg66xOz?=
 =?us-ascii?Q?wdmHFMi+LiZde202z3PVWKxv2ookeSMiTOhNepaVUTM6VAwzl7AoTxcuig1M?=
 =?us-ascii?Q?LHFntQgCiKwYQWtolp6jjPSg5ZWQvOUpeJN2/+Tsh0hNA4ftv1tO53RBfXVS?=
 =?us-ascii?Q?pieEwL8iNMeXpPjdyXabNuLkYjYtVis5U5AwVLAwy6fUbdQODIO3Np+4A395?=
 =?us-ascii?Q?X6/SRvKoDdTc8U83WPSm5V18vuz5vJkXAoZmS1A3VnvEPNLe0IWn4OmOeqny?=
 =?us-ascii?Q?8U7AuARMIndvsenq8Qmeu5+1sa9V24O2k5wFG/t39tJ2FdROnrYwuMjo6igH?=
 =?us-ascii?Q?zsrqjyNgamnwx7dC2qZRrgEw/Q+Up2Z6BNxUddVrXuyMAbb/N3FEwz409V/D?=
 =?us-ascii?Q?n+MlVG4aOciSTK4cxXwiw/6FHnpGAPPSIy7azw61QLfOx6bCLHZFMdigW2fP?=
 =?us-ascii?Q?TQnH+VhJbQPQWgF5BlhupdCZg0akwQzVxbcmTrwC1AurIj5q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a52949-17f6-4a14-06e4-08dedcf30a43
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 13:15:54.2255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqqDexPj5TEFBGFRA6HKdJLbhq74Aaw4PZ3qR+eluNdDzc/SWLrS+rPij5q/RJDK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6923

On Wed, Jul 08, 2026 at 09:00:50AM +0000, Mostafa Saleh wrote:
> On Tue, Jul 07, 2026 at 11:58:12AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 07, 2026 at 11:52:25AM +0000, Mostafa Saleh wrote:
> > > On Mon, Jul 06, 2026 at 01:26:42PM -0300, Jason Gunthorpe wrote:
> > > > Store the required cmd data in the tlbi and just copy it out when
> > > > processing each item in the invs list. The cmd form only depends on
> > > > if the instance supports RIL or not, otherwise it is always the same.
> > > > 
> > > > This avoids redundant calculations for each invs entry.
> > > 
> > > I do not understand how does this avoids redundant calculation?
> > > This would be the case if the domain shares multiple SMMUs,
> > > otherwise, a range TLB invalidation should be unique and can not be
> > > reused.
> > 
> > Right, if there are multiple SMMUs for the domain then currently it
> > recomputes the range for every one.
> > 
> > At the moment I think we can't have multiple SMMUs per domain but
> > Nioclin has a patch series changing that
> 
> Yes, it is not possible at the moment, I think it makes sense to have
> it in this series, but a comment would be helpful as it is not clear
> from just reading the code.
> 
> However, as I mentioned I am not sure if that actually helps on a real
> system, is that something that you noticed during perf or based on the
> code?

Not measured, it just fell out of how the tlbi flow ended up being
structured.

Jason

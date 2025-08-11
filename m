Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC861F4C8C;
	Mon, 11 Aug 2025 21:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947303; cv=fail; b=DcGdggeedWydGucWPu79GL+geyOi2ApvFRPh9mFFZ3DwyFq566AXIgQUOjSDORGzxUvGFL1c5s1ekVyrBbi+hwgK0lZaSBH5BHzCezR1rhDftJn6uEQwPiuI3+wA+KWwR6llrvCCQV+t10ULamzKq3kdPV5HV4THHKaYp9yDT5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947303; c=relaxed/simple;
	bh=zbwoY0nl+MbSIlOsqSk3E3rQxMdQIcVwr0H+pI6Xk8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XQy0M+fOcCNAAwwiP559xWKZOeX+KLEgNwrucd0eTqR8kZLOtZXhOQ05mhh+iKpQs5lVB7h0QaiUEgHnWQDm665m9hv4Mp5QJ5IhIjSot22yGA7omCyJgb6RiLIIP4Kuwe36/mNPCOaNTcNZYmYlhcSAzOM44gVlvjOXDEGsu5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oKbgVwde; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oKbgVwde"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+N8ogEpefp81ESm58VfgZQuRqkU3HltIp4W43ZFcnhMPz1tgtx0M+MPf1OCXhtur2CujARNZJrSbeI0mJaNb8WnZoHi8YSCXPodINqJyalClpwhjeLFUmjMlBsz8302P6dbrvGdqrLK+irtQqQ3N4DgbP3PCeR4+RjhlHQ3lPFnDt2jFvFmtHSsQIDdaBv5SJeKFX10bcqNHYPUVGy0fVOtPH7MOVedKRpiXYgf63oqx+SOgeaNtZLt62mJeq59rFs/EnA64MZGMk5xn9wO8qe8x5b1k03nMScsGrFZCEIyUgXs1HKu5tBnqjJhc6u/8ArTJm5HWR57I0oKYSh7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zbwoY0nl+MbSIlOsqSk3E3rQxMdQIcVwr0H+pI6Xk8M=;
 b=ho7qDEsSDIQbKLaDbY1iusVHIvQ7TVb59Y5bhWfPqC0/pH1NFNJX5/DyTgewmfgi7v7Nr+28DnTEIlfLkIkd7fFUsGDNYU5d89ntpVg+6AcieePrbMronJDht0uf5f26miY8emoy1ZNPu1zuXFtKVugEA3ErnkL6AqMabyL+JMl5yyqCKWIW9tGMLe8E8g48ll5RYsTLYT97NoFZaCxgqgw8KdFqcyUxC9nGle4uT/wZ4nQ4FBp+iY867Hd6wOmYks0ilJv/1JX71Wg41udwB6JvOKmTLzYj1aMZ+PzuWLXYW9xi8JnjMiYJIgw7//wLOZiccvYnCXpLeQ2c2vdCJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbwoY0nl+MbSIlOsqSk3E3rQxMdQIcVwr0H+pI6Xk8M=;
 b=oKbgVwdedy+OhBBZry4qLRTe77Ddfql5uRjUHjUqvdzoxQDPEXAR7QhL9TzCPY8D+s3ePCR8ip5P0lRinuIj1I7+nEfGCP24ir5sPMI/vA80Mpa/rJf7RXcWCrZ5CmCKoEFw8sQ6ubfF4sOs+7zBrcI3PqgAaeV4w5Jpkc/tLnwuAwYpy7VT7fGYzKuZtIIaW8uLunLUX7U/jCUW0G7ojaPn3ZeS9yxnp83O+pfRaoAwYVOuB8312Ft/poXVPmZeuzdkWZDsuWrwujO1Y+/yoX5PvLLJrc80Safl14f+hq+ho7DYQ+NW/xWbC7LARSr/GdmoaaR2v+EAkWs7/924AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 21:21:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 21:21:37 +0000
Date: Mon, 11 Aug 2025 18:21:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
Message-ID: <20250811212136.GA599426@nvidia.com>
References: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <00c5972b-a5d9-4604-aea6-cc0d8e2601a0@linux.intel.com>
 <20250729223240.GC82395@nvidia.com>
 <e94c33e4-7ef3-4777-aa28-852f4a013580@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e94c33e4-7ef3-4777-aa28-852f4a013580@linux.intel.com>
X-ClientProxiedBy: YT4PR01CA0122.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: 84969a6b-d048-4590-f9b0-08ddd91d0e60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVZobXXyMyYZCQ4Chz9ni4NVJqBp9McK6ba0V9dLZ+goSxUZz1/8TXHZPuIC?=
 =?us-ascii?Q?Me8Np7GlOEymH1l15au0C76CnXHSKiYcoGffT27FIVHFN0fcrvxBzut9igs0?=
 =?us-ascii?Q?naxbZngly1o7aW/qOOA1LQQ6yzWCrMt4frevuNyUOI1qRZeL0ko3+QzGeSGu?=
 =?us-ascii?Q?K7FdTnLSRbdIU+DJpf4jP0uHyki7/PZw7Valx2w/uI3oP/mupS7Dq+DA5Ksw?=
 =?us-ascii?Q?0ToOQdTwGvhF3FVrJWbBsCs6rFlWLtrRoymuUsNX/Dg3OzmX1yy38u0R9OWt?=
 =?us-ascii?Q?NNIDoMXiUrX/TNoznWeWj4Q1FccDK7KAfiRA0e3ulWOBlifwz1zfW1gUl31f?=
 =?us-ascii?Q?UFoFjsmshUoKWE/0VhM6JELQ09xeCWwbfm1hI3s2Wmz3lHEWDhMdQJoaDMP1?=
 =?us-ascii?Q?4hcch39BSLIFROLcpW3euKipn2zujW+/GjFGrDEXJf3xijTAe+bXp5WIqtR1?=
 =?us-ascii?Q?GqxnDjHRFPcWs0vKkdxmDg3JmVGP2Blkauh92z+MUbr3cEafEeVA7EoBDUf1?=
 =?us-ascii?Q?QnkpDLgdqCf3x0cyg1C8qWCuyOIlz/YbqdmWImiHSBVG2yMROoJLxjUFRjk5?=
 =?us-ascii?Q?L/sw392BbA5/tnXZJ9o3WHIYD44SV+zl+AuGWcq1u4E/L0eC5esj2oe8XTjZ?=
 =?us-ascii?Q?UvejsgP5v07KMB18Eub/68BB6uVjsz6ZXuvwieUSswA9uJYMzj3KXiatNbU5?=
 =?us-ascii?Q?fO2Bckd1NcT5AYqgSxKyqpTPIBNaChcJ5gx20YxJJ/Bm+Z4WoiKFJ/ci2w5q?=
 =?us-ascii?Q?5dTGRohtP0CHhA843cFqbxV3814dJghkAPE7vTv1XdOryWtk9yaRb9t6tVW2?=
 =?us-ascii?Q?EEldnapYE/KLWnJ+yDnKMnUVBAHA32l68aIf0GOpIn+7xD6TtMEZ/fLmiF6q?=
 =?us-ascii?Q?E4kz3gJ2BjDBN1pqXrl1eB3DkV2Y9CgoStTMBenpsicDg2UWPdWGnjWta/jS?=
 =?us-ascii?Q?T8LZS6i9XpY4MNOWjd8K3mdE48un5BPnjzpJpo39MF7N0MgPopBmG0BB85tx?=
 =?us-ascii?Q?+CB7ZX/i43m/VOsJs2vhhrO6xFh27zivaKirRXrAdv+vavrdeY3Ev9suALgz?=
 =?us-ascii?Q?zXBH/PRxYaTj3uKwxScHEftl3z98wOniX4P72JQQraT4HVlEs3k2SYtAnqD7?=
 =?us-ascii?Q?Iv9Oz8KK8bL+3RC87wWDIIErdgO4vkIh6eni2yoR6z/jStJQXMHdtSejQh6k?=
 =?us-ascii?Q?WUhssaP1hbvxVkZjekYLH9QPk+VXyOqna+jdhBHx0UFYJnWD1mlULDGOUGP4?=
 =?us-ascii?Q?ZxAdl5kXLI3VlyqjsLf15RdhUkgQqqVOr9Qhgnje8G37EHZW40mZkaDvc/6a?=
 =?us-ascii?Q?DZnirGtGGszX5Dr2beQnvrxHlKH2WsXTbfdMN4Z/qA8JmWAaSp0skDUU8/jL?=
 =?us-ascii?Q?bWc+pCXGQoBNPFjRXgIqtXEUuI2FPNAJGLDqxBkUk3yfDLkcCrpQW65D8fmD?=
 =?us-ascii?Q?EO16FO7Xhxg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P9ZMe68xn33k8/EKxkhb3c3Z79NWdrgWz2FdB2iJzimW3/WBSupN/OeU/ep+?=
 =?us-ascii?Q?7hesjBB0+psItC7gDeKtTYtQjqD2F+TAFDM0cvN07v4ng6nrgym2Cf6hlHiW?=
 =?us-ascii?Q?SxVWdzZvwwNgd+C170zaEiB+RuJwCjq5dpry8zXnEzY4oEM7Be6XYW2DZ1B4?=
 =?us-ascii?Q?AmBmESjDAPpNtz7y0u/UceKDycIGHwrAaZ6WVp6RfAQ2pOpuLZOvjLrPAFnA?=
 =?us-ascii?Q?gUhdGhgI12b8eeUcYsh6/SBrXJZK/kT/3oOFFALcLK6+H8gCUjfuPscs3qmY?=
 =?us-ascii?Q?iGPQwmLgwAPMf/trovoGRc834iIuI2J7dP2lhBKt9dv4cL16qgyS+zu3kMS7?=
 =?us-ascii?Q?+S2SRylzbBu0O+DY2d+y2jRfjOOdB4SbLnopzknTU+TqxnuKgkLkEmwDCiHa?=
 =?us-ascii?Q?oM6fflK2gMP0zklqgWDKFjT4J0R+KuWTrHh6PXA0vDwFTSQfjMEYF/dxX97N?=
 =?us-ascii?Q?TzLbmhJd8zKVfamKRi5V5fJBEIb27Urwje/O3ksx9rW/pkx2O3ztrt10L9yA?=
 =?us-ascii?Q?bdzgmVTTM935iqpEjeTyHt16DrMH0RS2tBbVNqgGTFNE6kctuieo5nubKa92?=
 =?us-ascii?Q?8RujjNMR8al/DKW/lbDIdynfRKxIGm+Fnmyxj8UmAPJN8xuQMsEb4QmSrEs8?=
 =?us-ascii?Q?HEdu0ad4rNigAyuk8Dsj3aclhBcmWJd+EUXfSMCFV9K9UiyoeT9q3bLFp/P+?=
 =?us-ascii?Q?/RBXNWWT1GnSexhod0H1f3UVI+zqF3CCtej8+7mCED9UR5uJR3Mghh5AL73K?=
 =?us-ascii?Q?Eh9M4I4Dh0Jpck2a+aZG6BTgaDOOKdy/Mp46TFdAvmbIyLH07e+hjYXby6oV?=
 =?us-ascii?Q?jVKQ6s02T3VtfLTYch0ZMdO1Gaz6wkaVq3nY686XTyPfNBL2yVa0QgpyAN/q?=
 =?us-ascii?Q?Lj4hxhZdumWPFiCJQEYGRfKomJ3FMexkEC4Gib9Rag0hPuoILvoV2ooe1RV6?=
 =?us-ascii?Q?W0JvW5bvrbfSUIjT01usnAP8xldTennj/wfV8LbYXxrbIau29AI85HabWI6G?=
 =?us-ascii?Q?eUqmtOgFDY3QGkrk8tF3qGDW3jkI9O+CHVTSW3D3iuWbqFlUPIli7y7FuIn5?=
 =?us-ascii?Q?17tyjVj86Ff/reGFl2I3OGtgVdJ8bf8GpjcTBg1WfXk6g8gro/ZfK6WablfI?=
 =?us-ascii?Q?+0ErHoR2Iu6txci3MwuYfqP52Q7XR4qJqYXZYfVCEnjUYS5OVTABFQ1HOVUF?=
 =?us-ascii?Q?BCZ1lwpp/TGPhfe+D1Xd47DKJRzOBj8Wg1LRL1DKCXYMNWLDG1xrw/QoSdNy?=
 =?us-ascii?Q?VFvHdO2TRSK79HLMbhpAc/VsFgGuzVjye12I2bsfhPODO/yCmtE4cSrLaS/B?=
 =?us-ascii?Q?ENmox2uAHl7DbNOmnVgNvoHbEJj2TINgPW0+dJTf9C9Rz2yompM2Nx816PWG?=
 =?us-ascii?Q?1MRkLHu/OW6MMWDs9eSFACjEJUF0K4e7IonD35zW8WqhmonHf+qXAIiNRP3r?=
 =?us-ascii?Q?rlFyO/CvT89rl4wVwcI1GMnoL3gyKWRtc6FiSUPPFLUk+XwybEHQriXD7Ul+?=
 =?us-ascii?Q?Ihia0O3TnZVuGIYaGu/k87xnjEti+mMaIs9sTjRF3FSrLwy0mVgymgiW6C8f?=
 =?us-ascii?Q?299xI/YS3wOq2YT6Ihs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84969a6b-d048-4590-f9b0-08ddd91d0e60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 21:21:37.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYmOeBis4JSKG4kWd/IWBk/kKRTqKex7i4BBAG3wlYxvOiBQr3gh5BBLhEJpYJvj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847

On Wed, Jul 30, 2025 at 09:49:08AM +0800, Baolu Lu wrote:

> I was just thinking about that: this field overlays struct page, so it
> makes more sense to clear it before repurposing it. It's fine as long as
> there's no functionality issue.

According to the comment on struct page only page->mapping needs to be
zeroed before freeing, index should be fine..

Jason

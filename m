Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83C230E85E;
	Thu, 19 Jun 2025 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358806; cv=fail; b=tQFXJerxm8/GjUBQi886praTL4v05He6+Tk6GGjg8O01QjaUer1zCH3hOXz5Pyb56hIHaLBoOadD/Ym2TUe/ejJkxmYibji3oqXvHiBrYZJ01Q+swzjHJJuvieuhr0c6n/cv5sB+4aHvY+hoGOV0zVzkiQ9FrKPfIK5SLXSZGwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358806; c=relaxed/simple;
	bh=lvLgriIL0LKZIq1MernaUG5zS4iRZNRvRCKQ/yRcUqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xso84KcRluMHhCM5gFrJYhnseOrYka+7mLrQTFwgcrKuVy2vWOVBQXrTY6scrii5oqEPcjcZSTk581Yy2WY0wNNsLp3yHmA7VKnnm+Q3GmF67jwW8iF5AEr3PwmU9ArBawt3dAz84J0lBtPC+keEaOODMqRofRcVTUM5QjIVvj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LswyvPfh; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LswyvPfh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2w4elrCh82cOeYB2e5GbQqk6fSPygJGrpdOWwvKcM82bA2MdiysQHoRi/Jbb2FcPRngnsZfAUV0EgGGFzXsDGK5X6jTs6sag8+xcc2cmVZJAibVJOpCRap2MT6I8lQDgjlGhy9iz090wWraaj0xzpYr2UqCuS+WF5asQF6I3SQqqO76bWAYthLmERpDHUcfmAkPbBk5DSlqv5xoG5ouqN4e4lP+zMO3fOL5bxqv2HBPzf9ZLWn0REYAfRNIlxmmHWUKDK3pCWq3B2wNV4oNGdiXbp80xE7AhDEwqs5QgXPThS10LsN+K5wXMxPShyeofhGov3f/J4Dv1EcIYFk7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JD2WG5MwYz9oTgbHSx5BT5+Xc3TsEuttCA+3Le0F+4I=;
 b=OuWfK19MyVl6KeLcKRxr2cUhV6hbnNh3M5bY1eC4d91LfBtyjWqL3NGRRpqS9f3gzyycB6tLjMb4lUfodPKlFHix/qUjS0rIlQRl2yLujgEOOu5RFhaGowMLFRxwrYHNlJ2i7U+pygVWEZRH7WwnTLE903jXDIFBjxmvHuxv89m6L+9cTBZFgE7vhJtJ848oatCbR6byaXoAfbEQ25KMrLKDZ4m56yStBYFOf2kAu5myj7w66lVbJBGwTm/T2KY9Ra4GqPF4uGxDmg4tWM7AzD1DMJqhQNR65Ahxg0uEclZBdUtaphgrZrBv03kJqfVqnbEVJWETU0Z4izYnUOqjxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD2WG5MwYz9oTgbHSx5BT5+Xc3TsEuttCA+3Le0F+4I=;
 b=LswyvPfhXAxmiAvphLPImZKgiw1ckVbDMpmisYlQyMKFQXSxv9j3wptu2RtIiK4dtJUrWhR4aeo907WUTX3wlP9idJa6IfDyaFddV19uhhsTzgvd8JVb7Qa0bh74k4XnBon4zZFicv1W9uoFaSjJtzeJeMJdloqEgzYZNO8TyrX3nhC/l6HTqZepelQzuChsIlrHAws+QHdmksUeoPhwjt/FdUbtEQLgdPawnnWSeQymKx7KxwEZk2rLvCEHtBlbITfYOU9HFClX/H4RwZDMfP879WGz5IxdXauKmUegeCltnhDBS6ROqntV8SnQvXmbcjMgaaHZIhhoi2WWy5WsMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS2PR12MB9776.namprd12.prod.outlook.com (2603:10b6:8:2bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Thu, 19 Jun
 2025 18:46:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 18:46:41 +0000
Date: Thu, 19 Jun 2025 15:46:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 00/14] iommufd: Prepare for IOMMUFD_OBJ_HW_QUEUE
Message-ID: <20250619184637.GA17127@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: CP3P284CA0010.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:6c::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS2PR12MB9776:EE_
X-MS-Office365-Filtering-Correlation-Id: bfcb6e53-696e-426e-4c46-08ddaf61a197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uG2Rk9raxbxZvV7h2KNB+bw9wvkCsWQFfRGDYWTYQ5Hz+nBqupRUahqfYsk+?=
 =?us-ascii?Q?kQrM0dpI0nf21YZaG8azUp5NQQZW06xdi0upZismPV/5l8DyD6r5R0CUNnQp?=
 =?us-ascii?Q?KlXM+DAaMino29O4XkL53LMh54fkYAHEjWbysRnWpyDAaoChGKQI6MEXWFJC?=
 =?us-ascii?Q?mW17SJ5Ut/7j28BLuk1n6LPCKvPdYfpcC/KC5gwTt0A6FDXbueeiTD5qaVQS?=
 =?us-ascii?Q?qugyh/nk4W5EbshKJ8I4cMnT39i5OUQTaoT7nCY7rvQ59BETPPw4FBYrqbNp?=
 =?us-ascii?Q?JTVppoetfyoB4WQQJd5f0wysDiOXC0iATZ+r6iA/Ulj1+v1AbSA9h78VZlUQ?=
 =?us-ascii?Q?yS48N1efEji7g0K+nNOXG9DqenjLPiQ8G/KXOgqITiJL6nwPD+bTzcQbN4wo?=
 =?us-ascii?Q?U0SLtxvYupQDWfKyvGvsrcKHw31C8SZ7Oqz7xdIGFlmPIpJgECBQfspsiKaT?=
 =?us-ascii?Q?Si5UX4DAn9qRUzijbPVB+xUEVuUTQdNc4ysq+N2xi6gaC0fngK1NibtMeto3?=
 =?us-ascii?Q?oDrRqnAQ4AUALUYfsbAKLONzVWoPNA4CLuZy3JLn2Y3mmx8GUQTMS0WnFZyD?=
 =?us-ascii?Q?KT5Tiubb9jbWU78+AiWzchNQN8w8orxIKM9SjNtKg5Ki0z8kRyx4zxsuohR0?=
 =?us-ascii?Q?T/BmyXJF8JVmvoAmuyasc7E774PyGAPKmeKPE6R9SZUZhJiOxOtZ3mZBmI3y?=
 =?us-ascii?Q?PLxdXbebbCwEMoJyCxFQFEZU3Az6DFFrPZ25zCwfxPchO0uF/nudMVPiWUOx?=
 =?us-ascii?Q?MVfXwGSegeCfprBaSEEj4P88KA1dXuMfAYmXBKBmX1abpongodYMtDUy0Ti1?=
 =?us-ascii?Q?ToCkRF7P53SQaglaAHIS2Op1ziJftUJcUfFdyoh7BZQStxPzQ2eMJrB+OvJP?=
 =?us-ascii?Q?u19eIuyN5gBzQUTlMgSVOt+xdCO8ZPIYkWIlEmlOgbyjAL5APdm36FdaxG8+?=
 =?us-ascii?Q?WAa6r3M5PRnLK7nUZdnUslAau8KYtF/F/NnbUQpqIso1/QsTTA2HuAJRSGa9?=
 =?us-ascii?Q?uFidEbUu6zmv/sFbyoVaIdbyQGKqxRg+FHhHb1I5y+m/utqG209aaLd7zDjB?=
 =?us-ascii?Q?MnS18A7Y9KZBg4KQw9Kidcjf3rCa3+LXlpEn+5lSGYaDq6Ar68TiQr5ZZYaA?=
 =?us-ascii?Q?HEQ9ZoWAUicrV1cWBELVRhZ9QAcuJknVt23fNxo54MSPiRNoFc2aathZs32C?=
 =?us-ascii?Q?nhI6O95FdirSq3852CF6WwJA80Vyu0WTjXCdobGbCwhxEivwIv4UC2zf/Z3h?=
 =?us-ascii?Q?K2bEcip8ZqqoojP0P32iqk4OyEWO8ilXIpnuO3nc4WhGPGOUhZX3/AwBnXqK?=
 =?us-ascii?Q?2TNeWu83Bce0noPqzlbTM17FSuTvI+jV2EF7ZBhFNOkQZpKBFAYQUsrVVO/4?=
 =?us-ascii?Q?1IiowjPegNshdbZORu5Rgu00EJV4el1Ft8bQwFDUX7r7kMHbF72+3s0I+aoV?=
 =?us-ascii?Q?XU+Bf7USrcU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pzV6OFSzEmt8/7gctfSXexpJ1wbLJhsVTCnNRA8CnGs7lZrDOE8WkUx7nj+g?=
 =?us-ascii?Q?CWMQjLSTQTa5X6041r9zvuJZcaUHF9gWrJfcKbN9Tie/l1Lwcv1k+8631Sij?=
 =?us-ascii?Q?KAKArVQGliTX7gmCGJd3LWNM8Miu3vjPagP3Nurxli5pO/PuOteq+17KIh0y?=
 =?us-ascii?Q?9dXZQJ++iqxENLWnsPjr57fvrSEyXDvbrOjFzS73o2i2cVqHWyepr1fG4q7e?=
 =?us-ascii?Q?bQRkqsjEU3nsNf+MGTWpHQIUiQO4Ay1kwFCfKGwZZEPcgqNdz8r7MdsT66l0?=
 =?us-ascii?Q?ftOFscS+aBMs0XPc1STVa7FTAycdP8CdPgCxd/hLSzUlq3egp+59w9OZswZu?=
 =?us-ascii?Q?caT2tRCg8SMn8+HBqhhwScZtueSHUQwOtbgOZCxwHCOvkltZ8iyud9CLIBSw?=
 =?us-ascii?Q?kSISOd5XrNLcct3fsnUsvlVtISwrpdFAVW+YSZNVB4d38xzNqtihvfnu9qac?=
 =?us-ascii?Q?Y3vzgpPgx7GNhe6tUmS0O6GelRk6ON2PIWeNkfBCXt2SDcEsMJCy60mPt4FF?=
 =?us-ascii?Q?HoNdFS9fF1YSpjVx9OgTbnoakKxpQfyOrToFWiiPomYL//JRFEWlhQE4zlWJ?=
 =?us-ascii?Q?ftlIPd1zetj9H/aecATdVCU564rYYGUlrg+NBHK0kAIVwSaw1bcrgWbTLnNw?=
 =?us-ascii?Q?GWBJyQPMcFsj/TQhXXznBRLfqbwKRQSwjGY46xKGtzIyS0ZxqmVAzDrcnYm5?=
 =?us-ascii?Q?rtsaOy5btrZokdvw+nMy90jkBHJjxlT/6/gXEnSs7r6ZAcy5y1pfo+Uspq0H?=
 =?us-ascii?Q?PKU8WcTh+k2cw6KsVK1ns610GyM4eERWnuIgaV0gy5tFTqHLs2pPMUIZhGNM?=
 =?us-ascii?Q?PQueqoeptOHbttaERt7ghHojS7ov4l58NOPyVg79CQ5ryQBFjcUI8ajdumnW?=
 =?us-ascii?Q?w0aa9LNcNRrZK6e1lJg6Lob8O+2Tqot5xEftVtsAbdOun3PbdTnl1lou79Vr?=
 =?us-ascii?Q?8J8OLcJSD++4Gg+jsSwj7pRiK6oSa5o9b70B/g/NtSphQHs51jnEUBz+AuLN?=
 =?us-ascii?Q?30bhBn/b70pv8JBJTI8/y7HyYQo6cxGWzdbN/IuGa56mfRcgi3gDK28h71di?=
 =?us-ascii?Q?AR340Hi+q2VAj/80OOEqvHW15HNscPdWCxe+jKlNX74T9f9NFEOi1CYfhNdh?=
 =?us-ascii?Q?Ha10tFM1VDgLhdmTiBNyLeJMWja5x8QGNu0zgLfgMxbsmBfPkagnmAn5bjiO?=
 =?us-ascii?Q?+yl5nQJMpJJJmx/XwEOfb319JQ8tZpqYqYkf40Wn1A9VZ+bb8zdvAQ0VuGTx?=
 =?us-ascii?Q?O+EvtPHd5IBmLZ0Jn7xOlO1GON+QzPNOBBkQm+sMgNbaOAfofvplrzHC8Uus?=
 =?us-ascii?Q?ey+Wen8X1b/LIm3wcVfkIQd7SR39Kp+Vis8iXWjNOSRHWmpTfMaJ08M5C/16?=
 =?us-ascii?Q?/CVhik2vLCNmtTJwAjcr9WOR2z8R6+5+Cs8b9ku/xMMT5yzuG9HSXdnfvOHp?=
 =?us-ascii?Q?aCypV7LhIp7zluJDWeUr46khUn94LysRmFNpWnZApsw5naXHsRjAOiKh0rcO?=
 =?us-ascii?Q?3PKp6NZEs1ZAKPQ8vWO0aghLqNBt1N5zgx7VWHbeikEDyjvu3oboEsQFnxwz?=
 =?us-ascii?Q?BWTvgghfwUOW7IH4/hgnIcjYGoWU2fS0KcFhwO2A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfcb6e53-696e-426e-4c46-08ddaf61a197
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 18:46:41.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wdq1q9fD/hHDBtFewIlRvrF+jV0Kl9swRxl/A+HRXGpOo8GyIixzv29hm8NK2CYt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9776

On Fri, Jun 13, 2025 at 11:35:12PM -0700, Nicolin Chen wrote:
> Nicolin Chen (14):
>   iommufd: Apply obvious cosmetic fixes
>   iommufd: Drop unused ictx in struct iommufd_vdevice
>   iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
>   iommufd: Use enum iommu_veventq_type for type in struct
>     iommufd_veventq
>   iommufd: Return EOPNOTSUPP for failures due to driver bugs
>   iommu: Introduce get_viommu_size and viommu_init ops
>   iommufd/viommu: Support get_viommu_size and viommu_init ops
>   iommufd/selftest: Drop parent domain from mock_iommu_domain_nested
>   iommufd/selftest: Replace mock_viommu_alloc with mock_viommu_init
>   iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with arm_vsmmu_init
>   iommu: Deprecate viommu_alloc op
>   iommufd: Move _iommufd_object_alloc out of driver.c
>   iommufd: Introduce iommufd_object_alloc_ucmd helper
>   iommufd: Apply the new iommufd_object_alloc_ucmd helper

Applied to iommfd for-next, thanks

Jason

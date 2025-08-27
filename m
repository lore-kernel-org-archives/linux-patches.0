Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9112BE7A5;
	Wed, 27 Aug 2025 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756313291; cv=fail; b=XUStguEI5q+P4hYyIXJE8p/ayovq224OV7pHokrw+PRAnhbk386uc1GbLYhUQNJgz8XNChWwfmoNPu0zKg1EYMXKIADwb48IqjdDiAK/elAG/11J/wOIG4Fl57Iq0Ru0c8yWmhTQhLan6CfkRoYrjFbxr/ej5WkoqjGy9uZU6E0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756313291; c=relaxed/simple;
	bh=zvMKvdz2iqQtSa2WcgmXqPR8mfcBDF8m+nQLQx1pnAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BokU01BU6WEqGX2gEX4Et/uyg3C4kj63t+e6pbvXarY+MLUCbg0TRLiCEGqGRetWUTMnLOQSJJBkRjYYM3zfk3xa3NdvxOog7VdWHccCnM7TOtgu0IeFPvh2IaeUOuFKKK2bdB1FYn/wPVR+DoVCFpZ+OBmPQ50BUD3jfTPEhuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r7XoM9mc; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r7XoM9mc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLHPZWy1aDqCZ9ttkSfuFAre8y/Y7AeFqp76CB7q6lQ676rtJa4BEnRTjoBD/CA1uQ0tftzHX9ksOhD00C4AzmFeXLHmYFZ/dDsu5z2llUctVxUPY6GaQ/td+YiNLWrVbK4tEafQG1gHsvkHigHYLf7dg3v/+XIuaNTKqem+RjZbtxCBMLd+JXBrUUAMdNbxhwx6RBkmanarIishBbH9utvPdfpqiImvDUrilwquLu/8YkwKvZIUAB6H/2Dk+5bfp7bVlonlDfrQZ5piKNO020jXPhX4esoPjQGhYJ14glq1rsF2AJyTUKuUVP7AOc/BFJ0EnT5fgDBTlVd5Qp3qoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YYBppzdjdhYPHF83U6ojTVry/Enrt+LZVkI0+bo40M=;
 b=DipRQ4ExANFP/v43d60va8uDuDMRljGHuNvlbVJ6emQQUlgoF781ksCchTcQ/AXRFAXpWMEYg9iwFHoBYoscZc1dq0szCUcez4W1bVvN5ZqhwQ9TaH+M4aUnLYyMm1PiIM/gAdNnHp7d6KHrIaLh475oBuq7ELy/nmQS6PhMYBqMbMAJGJNJQB9ZN6scug83GGAABXchRRlABv+zc67JvHlwvwreKtQ6+QG/MXlAF+xDZbnsY1NBXPOslzd61KNm2+l0w95/b0YdcaeQ6+9lIg46aeepVJFypL8IkiGbYA2AYEv8PAShMZh4iRT910mI5voa2Ft2LVoyJ7LS9aEdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YYBppzdjdhYPHF83U6ojTVry/Enrt+LZVkI0+bo40M=;
 b=r7XoM9mca5CivFC+tbM+28p64nuLGzww++kMANfondGwW7K1lUyb+NfjxvZSwcZ2Phc54EeHtXjx9avQKXwwz8GI8KfwmDzEv7GM8DL6BHVuwDW6wCH+iV9hgs2LGm9I9kIpkgHc9mNZYm9wGG+IAXgcuozNXVIQhLx66l6ACqDyf1j02gCv3gxP4g9y5i6fcXH3ROK+lClVYL+94iTiID3Af7xnFJC95l5BOeYS8a7N9aSaw0ahWPPq5uNue9HxVQ+XPNVdGWXMiZTomZRSX4TaqJcdoTSnQPL5Ky9tXVrMyH/VpwCsaRnq00o3KOiHbjWK0FWvx+aFrqOHtH5c/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB9515.namprd12.prod.outlook.com (2603:10b6:806:45a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 16:48:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 16:48:06 +0000
Date: Wed, 27 Aug 2025 13:48:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <20250827164804.GA2206304@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SA9PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:806:23::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB9515:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b8fd8f-069d-4421-4f07-08dde5897f4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mhdWvRDXynOg+w1/jClXisBtPKAfpJKOxkBXAlrij70+YdypqbF9UQhiHX0T?=
 =?us-ascii?Q?ehMS1oxJHihXDCfdtF74iqNqOpP9DFC1oN2PQjLRg6tcfOtSOaLRzZgnEXDt?=
 =?us-ascii?Q?/ORzCDk2Vsn+tgkW59BHxSeqcxfmX1HLWiUk3mi8O+2jI86hWzs830jzBS83?=
 =?us-ascii?Q?Ojc+CsvjnIFGjPYH5VbBAVVNp/XDOHiuUOHo+b+TJnXdsUiSvyV7Guhf+D1D?=
 =?us-ascii?Q?xQmDG9e0cq+44MyZ8t9CQZqc4itD5U4LsVuP9Om7Efsoy8uY4xsetidGy4RK?=
 =?us-ascii?Q?B5jubIR73cliGwIB63czdqmYIK3l8j37FNCEgXGu9sY/KQrWxH5VyGkfQ32v?=
 =?us-ascii?Q?k3JUGTW0A8eKfcF703JUiJL+ONlIhgRaFEc5kVkF93F8Ehz+76PDlOIQLiLF?=
 =?us-ascii?Q?VOIq3/FgxkDc+n3KPkz4k5RAqoMzX2ThhVDS5qz1LdbMosLgKyvHNUkzy/xO?=
 =?us-ascii?Q?ETAA1rMm7wQHyU3LnaOcGdCoYDYt+NYPZtJ9AdrJxQTVi7SUhoS25Ear7PtY?=
 =?us-ascii?Q?1fB0Ss8QQEpe1hgYn0SufMAClaiO90W3Cnmry+wAEUEGpQelgNj86ugHjTkF?=
 =?us-ascii?Q?dkZunIQtPPLzykmMnPchG2aQyP1p/IaFeulHBOou20ThX0nHRQ2NH4YB8xor?=
 =?us-ascii?Q?sEekvfTnRhtTd4w38N/ZnX6OnlvEP+3KKo8tTXXTcJ0M+KNovampSIWSThpX?=
 =?us-ascii?Q?HDZpjHRdUCIz30aQEEozGWh+tpYjAkbXBC7Mn+EhCGj88wgMLypgFFY0GVqg?=
 =?us-ascii?Q?RgDiV2nkuiwmLCSTqSU9Z/0Xe501Yw+zynhCwJ3tQve627oFvG7AIu80rElY?=
 =?us-ascii?Q?hv4g1ODNCEv5TjselHVfj6Uk4TnWI7vc3qp9LRnZBTQFhnzuX1C3J5NqkYl1?=
 =?us-ascii?Q?WyVlBWULef2ug+0VC52ovf75fIfCaR6NbP5X+B+QiFJA5ojnRJ11droT35Ny?=
 =?us-ascii?Q?gZ3YrCNZVI8wfCJLlLWx1pQYqcBe+AAK47QK22ZnoGPz6tAcK0NWBcndueuM?=
 =?us-ascii?Q?yBlJpb5YKXRnadTj0U5ItNMWxprl6RlWVNca41SorLi/LBcJBoLqIjSy6iLX?=
 =?us-ascii?Q?lbWOfdsm/BndQ71ObcnhT6r+GyxVGN2jPH0MeMCaTYZH+jyOJYMiGPRlV2iI?=
 =?us-ascii?Q?9hR2ZBBplh4OSLEjNLP1s5hWzgFOWFoEo3/1p09yfKGh8h7fQaNwGULSSfHq?=
 =?us-ascii?Q?Gu0PqY/xmZDd2Bh8aE7XqqpVXBQQiQCuQIsVyAWGFuvsamsiVv7Mqb9Ksa7t?=
 =?us-ascii?Q?EEF4ccEZx0OkwJX0A/TDwj9vv3jvJC2cP7YHxTViSXbFRfB/pudMY4U+icEy?=
 =?us-ascii?Q?x+VGloKmG+nTt5BSBzm3FKdNFurDbofNJM21FSY3se86qg0yDv2sZcbCX1nh?=
 =?us-ascii?Q?w9ID5ES7PPOj8dDBakvweLPv6yINagt6b5Wbi3PypGalDSLBtGsT6mNGvGIX?=
 =?us-ascii?Q?C4/mV2pi6EQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kGX2+VutwKsnskWIwxV33MVDsJs5uyefj1lrE7d9Dt4PQ5tf44IA3M7yefVY?=
 =?us-ascii?Q?C8edvMpf08RaXNdHkNW6q/jM1Jf3tg+pGYAkI7SNF6k2zTPALjPnsYmhlSOf?=
 =?us-ascii?Q?bbr4Yt9PCUsjGoBIntA6INaC65BdzjWSinxGezdaz88FS8+YHZxziXfrTSs3?=
 =?us-ascii?Q?9vNZalJBS158b+DPiHaNndWrJF0DubmTA7DZLW/Cu3Uyz2/6NlfAFkT5NRkE?=
 =?us-ascii?Q?Jry2vtTmk9w+vGSyZBs1JxTBYl2LCqRWQx4pBMC0sbAe3lgbfrZEnDbnwgMB?=
 =?us-ascii?Q?ulTqPF5ZbntXV/GCD9oWQi4EMRtwv0Cyf93cuyWJdxfPsLqn/az31KxTKJxd?=
 =?us-ascii?Q?4A6K88wcK05rtmxtl22X6kEtBNYdEKimZ4XouYwisjgRy2h6JbmEiU6JpUyw?=
 =?us-ascii?Q?OmSW596TAJhEIr8cGkL8ksrUj7S06lxSakcPNfk6PMCtgO06bMr4c3LA1Hp9?=
 =?us-ascii?Q?96STnHtDoRukXDQuGZEevsd61BQEzrmLEIqN3BcCf5UA3LN8H/AF2XBWkqCS?=
 =?us-ascii?Q?wVutAFaunyk9h0NabxzjUmQaM1F6BpXG44H5oAYl9VZOljWsSyqkOwBaoxLw?=
 =?us-ascii?Q?yZ3q4MsoQF1w6idCuzBld1Q+3djxvAWdkXofN6qLSqdVc15//E4Q42Vs0GRP?=
 =?us-ascii?Q?WqtpkYHGprdnMps0OIlGswAinXlzibtMpKclACAQOoMRvezSZYSnyzxNCIgP?=
 =?us-ascii?Q?08K30Ss5tnTchxC5M2mNMSlgkFRas7WOnMAQ6TzbDb52b71XVNjBrQhXMQVB?=
 =?us-ascii?Q?Jb9JCIZZZbONtGiXXfDpSvCb1q/inJKmkVEjO2jvStTr6pm7HzZPPGdaSBJj?=
 =?us-ascii?Q?tzbtKROxzGvS6EAx3R7bVkAUqZe0ytxW/k//k62W6koAv88Sju5aUsRBnTiH?=
 =?us-ascii?Q?njOEYK00MAictJ2KStnAKefrkBIp2FQT0zCR5OSNaDmwQPRcRCju+KuZJzQj?=
 =?us-ascii?Q?UUWgvZylPpcwmjOuF6Jo3eNJ2R/oCmmNrMxcoO8qmh1TN/kQ/x1t/9fZLFjF?=
 =?us-ascii?Q?nuTBPWXKCpsxpshSBx8ffU/mwCS+SSsTVTyGhRqqwQGxyXySWZn/VrzAtGeT?=
 =?us-ascii?Q?PnE31ZgOd+GTynmcZVXmEo99SpylEHnFFSbnQ97GDKBNed15hp562g4rzSLh?=
 =?us-ascii?Q?IWutb72bE4bignQRRjzWj09V5uQP6QYl8pq1FUjeBVDf5+zjocI1TOul4cSD?=
 =?us-ascii?Q?tKYpxSNae+gSbggYkUv/ExWiqMkRW4elaaR/16/KxoQaxr+LyoUYjEAtWoim?=
 =?us-ascii?Q?HwGECwwfcYQormyznTtJYigWl2aq0gPuwAp4YMRjnSgSSmQkb1VehnYkde8D?=
 =?us-ascii?Q?Aa9FjOXvr3AltjGrM5fc4QxSi8haAkvv/RSXNvwyzoEJ3EGLBafrS2hVJZ1B?=
 =?us-ascii?Q?zW5/pUSEpFhn8QTo3jixcM1xE3CbQSCEbhD0dSwOVfydZuBI7IBJ0xyyEqvv?=
 =?us-ascii?Q?e1fItcV8LgLfzaqoJAiH2SysrJ/5VOGZ33phLIfLA9OvjSQRWnIM9XFG+5/O?=
 =?us-ascii?Q?s6qw/bD77aEj9QM/3lCXNxotj7m33vJ/3pqowQTxXB2zqsfPlqXpLlrYeJno?=
 =?us-ascii?Q?YyUXuuBnjKw79iqWyYOcpWoy8GKCbKgHB3vE1H+i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b8fd8f-069d-4421-4f07-08dde5897f4f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 16:48:06.7298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFofm1sKbtXSgm2KoIje5TLa6CnVOz1CHiDW13PnSxW/TULZhJDUZ92DYsMF6OfL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9515

On Wed, Aug 13, 2025 at 06:25:35PM -0700, Nicolin Chen wrote:
> +/**
> + * arm_smmu_invs_del() - Remove @del_invs from @old_invs
> + * @old_invs: the old invalidation array
> + * @del_invs: an array of invlidations to delete
> + *
> + * Return: a newly allocated and sorted invalidation array on success, or an
> + * ERR_PTR.
> + *
> + * This function must be locked and serialized with arm_smmu_invs_add/dec(),
> + * but do not lockdep on any lock for KUNIT test.
> + *
> + * Caller is resposible for freeing the @old_invs and the returned one.
> + *
> + * Entries marked as trash will be completely removed in the returned array.
> + */
> +VISIBLE_IF_KUNIT
> +struct arm_smmu_invs *arm_smmu_invs_del(struct arm_smmu_invs *old_invs,
> +					struct arm_smmu_invs *del_invs)
> +{

Having looked at this more completely, I think we should drop this
function.

Just always do decr, then have a simple function to compact the list
after the decr:

struct arm_smmu_invs *arm_smmu_invs_cleanup(struct arm_smmu_invs *invs,
					    size_t to_del)
{
	struct arm_smmu_invs *new_invs;
	size_t i, j;

	if (WARN_ON(invs->num_invs < to_del))
		return NULL;

	new_invs = arm_smmu_invs_alloc(invs->num_invs - to_del);
	if (IS_ERR(new_invs))
		return NULL;

	for (i = 0, j = 0; i != invs->num_invs; i++) {
		if (!refcount_read(&invs->inv[i].users))
			continue;
		new_invs->inv[j] = invs->inv[i];
		j++;
	}
	return new_invs;
}

If this returns NULL then just leave the list alone, it is OK to sit
there with the 0 users left behind.

No need for the complex _del function and the _decr function..

This also means the memory doesn't need to be preallocated and it
significantly simplifies alot of the logic.

Jason

Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0875A2F1FF7;
	Tue, 26 Aug 2025 19:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756237811; cv=fail; b=oq+eg0N+cLKo3uQ9fW6t+7j6/ibjnGicFxL/4hJTbyjsFF8F91qd4/LyRleB3inKimeERtest5r8/i0f+rHvK7l9R/EooF0MsM3XAVW+vA7GAN6XgnFKlDz1TQs6QaKXNdf/zkL5G9k/yRjAnKg3Revq8vH1tzldCywhdt+GFdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756237811; c=relaxed/simple;
	bh=K0jJYkbZDB8UWF2WqnerkDahLQpGhEQs6FKlBVtXC8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hZYqc43zv9xQUcLLjnhOz3GXjmgIYVyr7R077mPRFmI96/e6ekS6iSxKoe0BJMKd6BzuwXDX4NhIcS5z8ZVgvKVaTuaS2E+bHqHKDrfjJbtTzCUbvHmdcEewK3udG/sroUIxT1hZ4go07vOPc01DsGQPQmR15riacqQHYDa+Sw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OsNJk+4F; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OsNJk+4F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIq5mYLvZ7TgWAZkJ8UT9S2quvOJGzXUEkfRe1j3CyL+2q08jJwIDlSVbqFKqgG1F4NXiFEzbi031e7wU7+lzsrXKR/cSK1RK8+Eep8B8sCjeerslyGSoqaxGvsyZy/ZWGW/NMCW/yRp3YVWywT1vaUlNASiaJy4KZNLqtM4GIK7Vm5NqPAVOky5p7LUJKoinGQSAmCLC8xSZWe+lliM6XNnAGx+5pAvcIq4BikIdPVVjgwO9MgHY6EyHE/chlKARYwhQDIEad8BkHq9gSGEZJO2U4xJYdd9NhX9+fKYa4HrUaLxL7H7yNdjdwz3q7L4pRsMVPdQsldmP8D9zOxvCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaOVIUb79Bxm9xFtev4stFolP+2WA/g06YHttLIPztI=;
 b=uzCua3RqYvI/YxexrcwbgvRsEoKvopntKCHystCgI1D5Cu55bBlOOWS+LNhAcgWmrW7ahgeUslNMbVY5R+8oQSSozU7NflDuzd5bKWWjQiTCskutoA6o/878t2xfFEWM7LbiKto6IKA897wF1ntMQpEPvKzgPN/ihEDe74WDVWo+vwOq1EEZDgb95K6v2cMAFwfzAcQgQpzxNRSShDYQXaSVB8vFh5SqH280TPONP9XTXlgSXNfhorORcQn/ZVg7xAck2rVFFjsrfrQJXRomj5T3ZFS43BPLZxzaW9HeGWx0CC1dOTNQyWU6mVWB0BFLgSNQYHNSEtHrDkETFTGt/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaOVIUb79Bxm9xFtev4stFolP+2WA/g06YHttLIPztI=;
 b=OsNJk+4FSgWDD9X+jKk3FozBD6S50V/rx97C/kl7SCy9uR71ySJkB5TbHSYDkLgNjPuELByrIeGlE6a8Ys8p7/T1jT5dBdc8jTBzZoXDlrwlSdq4GDiOD5U+58zyW97qZTBHtX38QTvC3iJD3cWLLt/ZeYt8raWK1u3ZjiFu1VoIjt/Pms4ocJ/XTdReUUijBObXJkh7IhV9tKZoo2dqSbudTXciCruaotMgrxLHZTAQZPVMmQ3G6HbwHXYaeXA9OCwNKHVG5okGazrn7lWwC0V2bost5ab4+WMYNINLnzrp8pxY+h9OYo7Ak8SFivVcqPc2nLuBK9QIzMgogSuQ1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by SJ5PPF0529573EF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::987) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Tue, 26 Aug
 2025 19:50:06 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 19:50:06 +0000
Date: Tue, 26 Aug 2025 16:50:03 -0300
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
Message-ID: <20250826195003.GA2151485@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SA9PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:806:23::22) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|SJ5PPF0529573EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c5ec97-6a83-4ea5-177e-08dde4d9c160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j0dbwFTlrcYL2FhFqOm+FFg7tT1ScD7Hpvnm6nXhUniarbCIBL56OPipgRgq?=
 =?us-ascii?Q?XUbcT+s4FHtPejwzn5YBRnpRtFJOJrh8pFTmJPHIu35BFt5a/j8ZBYo8DotC?=
 =?us-ascii?Q?FcrifqGZ6qNrrqvFr1s+EU0gRo7b2AA1IiJecov03W6SOhIpJNS0QerzVtTM?=
 =?us-ascii?Q?s6UdEgfdZlTiV7YKcl+1UcjAAFSXMuJQdo1/M0kKLjTX+H7vH7yHKzQlJ0mu?=
 =?us-ascii?Q?cHafVQ6FonD3xgEDw/locw33WnDclDregCGvr/oLd+SSVJ5amCR7xclLSnEH?=
 =?us-ascii?Q?F84+sYMG0l3JBjo1Ewta4A7WFNKMC1sRrhGnB5j3HjogcJ3ak6jphRp0hvz/?=
 =?us-ascii?Q?li2Ru35YqCS1BGw3xs8ct9CUO0BevLEVmuLn6NF16qLMALUDpneAaITf48kt?=
 =?us-ascii?Q?XwjRkEISTqSdTevdzYoSzgrYITRtpIiU4mp7eoe+nwgNJg8ireRwkhc18PYp?=
 =?us-ascii?Q?k/ohZC+h/BxRW8yT9po5qLr8YOKH+scpTJrsijgxdf/D/l15pLdla+o74YQN?=
 =?us-ascii?Q?FvfBA2DKcOqEemt50WJyXaWgxVGKDzDXf61DcqgZrO/6EV5Jod+p5udhikGv?=
 =?us-ascii?Q?NjZZ1AIRcUZsrUnWVyCvAtBJeSdU6+3Vl/S/Dy48q8s96J+TCSc63vV5LeB7?=
 =?us-ascii?Q?/6cBL25RAbYWSzYkp7NpS0WzbWgkmKvxGusp9Ct4yubJXPA/w0MGrV+zQc2P?=
 =?us-ascii?Q?Lc0Km1ZV8L2ekr+Ha4VJla9XJbYBc/WKCs0+EIBAnX0ux590jneGNUm3Y81q?=
 =?us-ascii?Q?ApLvWjhBKAAUhaxK+dnSG/XQSuntq7Bds9YiiBRZ7dCfdg+AhvTlNUjXGqPI?=
 =?us-ascii?Q?96/ufIx5moy8WRsey054YX6x6ReTc0Kd6xRrkJ+FZu/wsOWNseu/Si4JmZ5C?=
 =?us-ascii?Q?yLHgtvS53CVtR8mWJ+WAUyn7/mQ7GVra1k51KTsO0DsJ4qelr9bBOsWN8bEA?=
 =?us-ascii?Q?oURiH+67H+5ySMSyXwKAaCVLvSzXOpBsnZ5PLqh+Yn8RZfd8v2D+NJ0zMXOJ?=
 =?us-ascii?Q?FdiCRJU1pW5cacoUIO5LDIgy9eCYiyLSht1dKonE1ri4wRVML8sdJufwGVfi?=
 =?us-ascii?Q?KWqBdG8tr70MowdBa0wQMVXXQ5nH1+a3QRpM/yZPM0cCLqU81NzyOHV+OnpT?=
 =?us-ascii?Q?djIErLmCsICjk1KdoD9No60VGqmidHTgIi77Q0P6YaoyNBQ76CqdW5cZXvGS?=
 =?us-ascii?Q?Lxi47Dv6cgR5qXDOzEVSJtgHp7nMl6qpXATBygzdBgStHmKyneXz0bxRkMUg?=
 =?us-ascii?Q?fW/EnUUJMBY63KBoC0kEf7+3dI4WCFOiiRWRdsadIbSuUtr3KpsKczHeB0ha?=
 =?us-ascii?Q?JDIlqUlIv2kW8JS5by6YkKDI4j8Hvt4Dw7gXT4xS374kDycHoB8KOxoRYftc?=
 =?us-ascii?Q?ociHtkqyMOAO5e9tBBAC6Gi/HYvJDCQUUcR/weWlEIn22qn2F7hSXMKxZyx7?=
 =?us-ascii?Q?RjwE1Zj13b0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SLjvzE8n1GXXJfKmBpAcNRbGeTBBjWFNFWxZ5xdRRfJebCuSVMQR/3evS0K2?=
 =?us-ascii?Q?y1rszUw9O7czCu5GL4FSwQluGmUaniwwmiat7KfQ0dcISkHJiSPkHUjbHrYa?=
 =?us-ascii?Q?bWGTbtFnulsWJvVsLK9yDkLMvEPUE3d0wYevQmdfcvhOxt3/o15//qzHUO/6?=
 =?us-ascii?Q?P45tdErud3wDt/gA6b3D1wPaejZhnO19Mse6gVo2QDVmPP4hWfzSKsvn5utq?=
 =?us-ascii?Q?tTCdGrYx94J/+Ag+/6sFUmTCicZbVeTBV0mq9l3GcMIbdjGBxp6xexCwDqLJ?=
 =?us-ascii?Q?5zoNA+yj6hnTKzSRF42o229FiJgs/zLbkcs+oAFf8CHfGXxS38OhxCa0QPIZ?=
 =?us-ascii?Q?4t9HpEKGK5uS0zlu6/NCPWBQAGPzeiC1UgnUc0lA12M3IiUdgVaTBuCnu7xH?=
 =?us-ascii?Q?CODSMw6sFRNxiUd2YubqyYHu3qvUnldaOK8BwXPNda0aH9wSW8NFy5vO2PoJ?=
 =?us-ascii?Q?U8onItqqlVsp78q4Q7gZVYXnn5gEXxVDT+McyU/VWaZxDXGU56fbDh3BXuWM?=
 =?us-ascii?Q?sDxZJL9RB72dZ50/Ex/x1koVNXilS+q/OBjgErR+cxYATTBzpbmWfJw8HsIR?=
 =?us-ascii?Q?7UV6x+BEB1c5c+VmBFbRlrf0MK2Z1m2IJL3h+SPQHYlsQkzfto0Cm1MqLo3u?=
 =?us-ascii?Q?879EpTZqs3H8ljJvjb4qwAJUdAu0pO4pZBmPbP6Zrt3UUQJEbmZs9VKTDDX3?=
 =?us-ascii?Q?VZs+ryM72aa68y6sLM8ZkCgjJS6mmMg8HREuxF4H36CTvw5cR97+Ls6J8H9j?=
 =?us-ascii?Q?QoUXX1FFtRi/yYaNcMo3qYXLY1EkSOlyNIlhIivgTDW4IX9NoaJgQEvYIf5Y?=
 =?us-ascii?Q?0XXuTa2UlPnJWLWlEumC2xFRcpfbCWvxscSjs65iZ0elow7gjNCEy/FEWAPs?=
 =?us-ascii?Q?PChKTwYEkqLgJtnbOm/vtqfPfa3Pp2WUAAjhA3f+FwTjhbTxWXcod3YgNAdD?=
 =?us-ascii?Q?8jD7UGm20tkk6krrq60C3qVNhznCxuoZrfB17fUFmZUldrnZBfZqtRt/Nqen?=
 =?us-ascii?Q?kBnxd9X5M0BIa5qmyIGTayzyDwsa891F/Uz3ZJc8NYQmxjBPdGYRutvLFdhe?=
 =?us-ascii?Q?wc1ELq/1wacy696GQ1R9+iuIDV+obf7zYEEd+TbysrtRpD8RsuxWF9x8TfuD?=
 =?us-ascii?Q?iBOBLllOOeSo59dbArFLx/+jyQBhw0G8v1id+4H00fyaVr1AuS4KasypgtFH?=
 =?us-ascii?Q?8tTiN1rfhRMrfMolT3ejAG7DDTYYnzp/Z4xSRQdZyMZVM2ek5EOwiOmvbAZ1?=
 =?us-ascii?Q?0wsL5CObLOA3quKPxbOlTbq+tDZQxIrCTyFtxu6ZRoEF8jJAmJD6T1eY1xwN?=
 =?us-ascii?Q?My4ATYw8pMBehkVNsy8f2upNf4KmpZ9Se+e8mzXCUncQtj4nAizqTIlUwEWL?=
 =?us-ascii?Q?6b/KdTLBp7A2FSt54WbK4NnUXhRl+KkWk5YRDQE079y8uuBeKKj2cXB8XvGO?=
 =?us-ascii?Q?pPlwZkP47QgFb5CfWyUJYnyh0Xs+le0lmIOhQuyNbQjJF7hUkt3mcZWCgy2X?=
 =?us-ascii?Q?rX913LWXwr8xTwUl5y0/BijyVUzsnxbPTvYJv+v4RI5f1S1Rufq0JGA329nG?=
 =?us-ascii?Q?nEJ+3QbsHyIlP9FnoddE06UAlDLf198xKwOW4ZVP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c5ec97-6a83-4ea5-177e-08dde4d9c160
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 19:50:06.2277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRFg9TMeeJiljvbwoKlEBk15cWODwk0Yd9poFbBxAl68kQbQct4bpBXVgPKbXNF+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0529573EF

On Wed, Aug 13, 2025 at 06:25:35PM -0700, Nicolin Chen wrote:
> +/**
> + * arm_smmu_invs_add() - Combine @old_invs with @add_invs to a new array
> + * @old_invs: the old invalidation array
> + * @add_invs: an array of invlidations to add
> + *
> + * Return: a newly allocated and sorted invalidation array on success, or an
> + * ERR_PTR.
> + *
> + * This function must be locked and serialized with arm_smmu_invs_del/dec(),
> + * but do not lockdep on any lock for KUNIT test.
> + *
> + * Caller is resposible for freeing the @old_invs and the returned one.
> + *
> + * Entries marked as trash can be resued if @add_invs wants to add them back.
> + * Otherwise, they will be completely removed in the returned array.
> + */
> +VISIBLE_IF_KUNIT
> +struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *old_invs,
> +					struct arm_smmu_invs *add_invs)
> +{
> +	size_t need = old_invs->num_invs + add_invs->num_invs;
> +	struct arm_smmu_invs *new_invs;
> +	size_t deletes = 0, i, j;
> +	u64 existed = 0;
> +
> +	/* Max of add_invs->num_invs is 64 */
> +	if (WARN_ON(add_invs->num_invs > sizeof(existed) * 8))
> +		return ERR_PTR(-EINVAL);

Since this is driven off of num_streams using a fixed bitmap doesn't
seem great since I suppose the dt isn't limited to 64.

Given how this is working now I think you can just add a new member to
the struct:

struct arm_smmu_inv {
	/* invalidation items */
	struct arm_smmu_device *smmu;
	u8 type;
	u8 size_opcode;
	u8 nsize_opcode;
	/* Temporary bits for add/del functions */
	u8 reuse:1;
	u8 todel:1;

And use reuse as the temporary instead of the bitmap.

> +	for (i = 0; i != old_invs->num_invs; i++) {
> +		struct arm_smmu_inv *cur = &old_invs->inv[i];

missing newline

> +		/* Count the trash entries to deletes */
> +		if (cur->todel) {
> +			WARN_ON_ONCE(refcount_read(&cur->users));
> +			deletes++;
> +		}

Just do continue here.

todel should only be used as a temporary. Use refcount_read() ==
0. Then you don't need a WARN either.

> +		for (j = 0; j != add_invs->num_invs; j++) {
> +			if (!same_op(cur, &add_invs->inv[j]))
> +				continue;
> +			/* Found duplicated entries in add_invs */
> +			if (WARN_ON_ONCE(existed & BIT_ULL(j)))
> +				continue;

inv[j].reuse

> +			/* Revert the todel marker for reuse */
> +			if (cur->todel) {
> +				cur->todel = false;
> +				deletes--;

This wil blow up the refcount_inc() below because users is 0..
There is no point in trying to optimize like this just discard the
old entry and add a new one.

> +	new_invs = arm_smmu_invs_alloc(need);
> +	if (IS_ERR(new_invs)) {
> +		/* Don't forget to revert all the todel markers */
> +		for (i = 0; i != old_invs->num_invs; i++) {
> +			if (refcount_read(&old_invs->inv[i].users) == 0)
> +				old_invs->inv[i].todel = true;
> +		}

Drop as well

> +		return new_invs;
> +	}
> +
> +	/* Copy the entire array less all the todel entries */
> +	for (i = 0; i != old_invs->num_invs; i++) {
> +		if (old_invs->inv[i].todel)
> +			continue;

refcount_read

> +		new_invs->inv[new_invs->num_invs++] = old_invs->inv[i];
> +	}
> +
> +	for (j = 0; j != add_invs->num_invs; j++) {
> +		if (existed & BIT_ULL(j)) {

inv[j]->reuse

> +			unsigned int idx = add_invs->inv[j].id;


Similar remarks for del, use users to set todel, don't expect it to be
valid coming into the function.

Jason

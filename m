Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73FE3A2540
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783451618; cv=fail; b=S/8eTqmAhmSDnu5ZwHPVI1cMOpMadVrnO/Etsu3EzfRG+chm4AaG58ycQ++kRYKkYN5oJYZjl1FjHqpIBE7hX/koaGhV0M7leM9Z26bMFea7rFlqhkSv79wcy4wcjLK6n8YVf2Gd7WZFovFCRnD/w7TjTO2OvjL2pLws9YjJciU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783451618; c=relaxed/simple;
	bh=D+jT5gJOLpS2aZ04DCHweaWmvZIGbo0m1+bjHvvQ5nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pvd/8NkE3GqOqfGYnQXz1hZ+XGJepMsbUv6Uchd+JujZwvGkQPMNm4ko95OWExC4+4JEoMwlzvPdgh4N7DyQXGb+oN70oKSoXrQ5/JNvZl/JBXu1kQr107pu3rokcKhAItXarujC4Kou4HTke0dYJex8MJ5KQf21gCESj0iTmQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P8EMH6mk; arc=fail smtp.client-ip=40.107.208.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P8EMH6mk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWv3GSk90hIXJfivBquS7aFs5rUDBYNnCIVaDkYHK+4krsA3XozuOvI+P55V8/MCCfpyF41OS08Vriii8xZZ+1ihG2mZ3RMKswHFQyqxR22wtzmvxtaXrHu+ftWtDoqA6ci7IAZeyYLiZv6HnpauadQIt+TWhOKiA7oRtutg2qHk1zn0esVamhtPKXkwhmuuOaKnky4+9vsaa+c3D15+W+nXcqkle6Hrr2L3Ilgwi8DWXW09AWKVq3owuHOXSIBN7ybJqYgc0a/GY+2Fv7sdbbOCf1b6pX1fw+K/yPJGm6QE74pr3Ef7+SrV5BM2zBcjt9qSIelhzSYAhRmKnKtIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLN2+iqI8a18whHAVtRGGtjtyQ+A2YyciR07zGmuPEg=;
 b=i3DMotrLgYRiUTrvJAdSYMgbuUlaefGICXwBFcWLuqEG80L3ALaCOeFhn2jdjVyMW/3+QXRyHlxrcFwDfjH4il8ldS0E4hsyGoawrxdQQdDhItCvK5bGT1Hc4jzjHT6wWmDEHknWpNllGe4DN1jM53nZNu0dNQbJC9mOGmsCuc36XVgBKsLw0FHigkOHe1/F6cuuGNfa3gJzxY/svWzgPqj7lST+sIdi1lQCM3Adm2tuYOJsyL1F4GFYDuntwlXAfyExmPLi2wgtirZAgai/zMBEfM+ovw5eb3t+YpzAPgsJeCl62FYsVZ1rA+SnZAJRZrsEU+/4xmEgi9bXWj+IQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLN2+iqI8a18whHAVtRGGtjtyQ+A2YyciR07zGmuPEg=;
 b=P8EMH6mkPm3vz8hnbEPquKGtLs7gO6IOlLF5z+NF9qKuNrbqR/sIqPyAEYYr7Lhy9DQx81PRAo/ww9w45Dl9He7Oa1unoANE6uBwQAN5/F7ZWAfmRiFLFDiJULO1IJXLlPdJERe2RQEQv6OtDZQUZCgQsj9U6E+JkNchywf3MUkqOZ8jQDHyCHpzN4zz7jJqs7JOXmKh+JVR1oKWljuTn+QeIbD6jfqGtzh5h33bdFeQ/ijtbfQxW4HFDJMRcup1cq++GN/L9oHqYCp9U9S6H2pdaBWvIOXbge2QSW20V1e49kLnUYXBz96jgR8/MBqLIVU8kDB2yUemkSHNHe604g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7306.namprd12.prod.outlook.com (2603:10b6:510:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 19:13:31 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 19:13:31 +0000
Date: Tue, 7 Jul 2026 16:13:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260707191329.GC226829@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akyqH7f5h42wru8a@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akyqH7f5h42wru8a@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: f460dc3d-6fed-4624-08b7-08dedc5bd4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0qyQqsaM75KAwaSqiui3xnudrp/l2YZhOtJb/1kgcmWeXxcJSGOu5eLH/xQFp25ZPv7AJyf4Sor67qC73yYCqYw3B8IqLr4i/N3jZpJwkOVX4qo0d14PV5oOG66EDcdzeiaZQHDigrGglItXljeBVJ0zyG4Vi7cxiJDN8GnQ0moszBNmWPY5UTcFKHSWPVUlcc07wR23HD1DRbH7MiSR1AYYK/wJ6qt2Xv2/8uxek6nYOMqVxs1xryqt2PAJlwNsLHu3hXWfLJn1KCptXuX2sQX63NYM07DQY/ny5ZNO6d/KpB9mv805O8oFbI29pmoco6acCbL20ux0WcmSIjEO8PijwBUGhk4yk/fNAvZ1SyJelQBUv8EO6XrggH49GHDeso+QJMzPhaDI8bhQi+4DRBIMWEl9oke4VJvJuTT28ACA/+8JxDLNNdpv1rxB5pQn+SHBBL6iJSZaV3qWnbMLKg9A7hEUsyrYkciCX48t3Ah7+Tvqb/BJ2FQG9uYZxmyxUerTU5rW4rfvsLabZbByPwFAZNDFlu42dCqnUF1RP645UYs+bNj5AdslO8u3+v9ORP9Ucp5TZ7CTr8TFwXZssDXpmQ4C7HZiL4xZdKyAIDw2BCAcyoxJikT5BGkqi/xya1VRq15NXOm5qotuzLeg/Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZVykLWdKOqYZ/bGPDDPPYPX0aAsluAugPNW07jux/hTodmXsI3S9GveJkBNm?=
 =?us-ascii?Q?DyiQpmbJJQ9uUYPU0W0yIeRqmb7RN+WhLHU/chcLF2JVWMlbNtS+tN4nKDRb?=
 =?us-ascii?Q?9M/FLrbGImxvHmfYOOR1BKT1Mev3Eq8TQuZ/Lc0Hh26vqIVTaiNZZfdhQyJL?=
 =?us-ascii?Q?5reBwERYcPSKaAIJPcnmmNilgTef8mOFm3f9rbVcxK3DN+ch2EE5VDwFpw9A?=
 =?us-ascii?Q?y03XrixMBdWfk+uXkwL5mz9Xlvq17k3cuWdv4bKACpC1C8Qgpa3s8W90tEXc?=
 =?us-ascii?Q?zm1wOXVnWulWS/gKRtMAl1cO9v8K+vkeLdELWQY0JHUXKhC/ydbYO/YO3Lhg?=
 =?us-ascii?Q?eOl86V/8lOcS5yKfiS8Vu3OSSafejpGeFPCFJxof/7rfqzmaQ6VuURfLAyIr?=
 =?us-ascii?Q?lFJS40EatmxQ+sDyWFyI8GDMC3aKGP63uGPvu1FdIq5tCy8P3j+z1zHOXj5g?=
 =?us-ascii?Q?r+p2YFHQbjNAn/7EQjJVp7IvPKjrv5WQ4bkW+zwOaWNMD+VKW8xcqb3Y1eaz?=
 =?us-ascii?Q?yvjvUt5li9l8w5MSx6auMtqe4eVAeqQmpRTkQ7KgqRuKzHvv9Gas3IaN3yMn?=
 =?us-ascii?Q?3f6AITVBCyR7b9gXN0OIhViaaZoWjMtXryQIgVVvKpL3Y95VDnTg7OeUg15h?=
 =?us-ascii?Q?EwHQyemnFl1s2TJK1x/74XLcysq+zhr8xhksq+rrErlr8HkicguYHfiKTgim?=
 =?us-ascii?Q?uoBH6OdecgWdiOmjB2Z2dQtJuZl0abd6L23KH+uzVHu5BzGyJw7xoHqfibw7?=
 =?us-ascii?Q?V8wIlO+PjCxkknnQx+ExTaKeMT/umVbaRHweXIgHQPgaiJSDackNdUKvIKCO?=
 =?us-ascii?Q?DmhmfQCfQG7EbcArlxLKY46ZqAeQHTMagOsVhCVwKmKpt4ah3OL5VOtXMOKw?=
 =?us-ascii?Q?nnW9vlxVWO8gMSPrMgcdDN0YgHkr8ku6+CfZA0vMP4/DpzO4Qye1N5eDVf1L?=
 =?us-ascii?Q?xYjlFHvZoEx+HzDz0pA8AnZ+NKmIOx/YnOnMd0b5SqwQalrMVwGjwbcUJGTK?=
 =?us-ascii?Q?kdPcqzV2nMIoi2UgSMnRhgfWrAyeEkMUIRBLbDkQdvbsRQlI++rpfi0QtneU?=
 =?us-ascii?Q?Hkop37jThmUY8ZQryJPvSuSJG5EHP2EbR8xg91v9uGIX5fH7ZEwd+so3P7cU?=
 =?us-ascii?Q?EkOFgz2UU0bF+iKSyClLi/RMWPAnDJESwlS0mKwrXqJSUoGwGkGTpJIOsWqg?=
 =?us-ascii?Q?Z9UVQoBbpfVnrsrejOrGyPCRFdBZQQjO0C00xhVY3vJwhOuZ1XVaohWzZTKg?=
 =?us-ascii?Q?Sr/HxmudcVF/O0oIAakhPzldsQCwbxLPUoW/F7FnDG7v6PMB2M7717Xm781A?=
 =?us-ascii?Q?HlDAIj+ZuSuwA+gv/8gahw4qLO31teWlbKrCarfI3ERMlZAonkmejluRlWd3?=
 =?us-ascii?Q?gdhO0UcROFiOt2/m8r4UBnLt1xcVzXl/YrGr774qsFNcxZrfsacH290+NwH3?=
 =?us-ascii?Q?uMcZzhOYsTp7t8Hq0HAc+Hq5xupggye3cgPGBN9aXWuCPbzeYrBvqW/4/Jw2?=
 =?us-ascii?Q?mUUB2ErXTz4yNAJ27HTnw7WVHIw1NuTJfKeohjJAgpdhO/5vfjPcV91+9Wan?=
 =?us-ascii?Q?xS+zp1QWywg6AUrObiHN2naccNdHL7yDJ8LZSREXyFjwQaw2mM73rhv2eAt2?=
 =?us-ascii?Q?CVbUZlwh9rVZnnR4N/+mwmn8zcdfqIeWNqmp1hhNTxokPnLsJrIE+18ZmrpW?=
 =?us-ascii?Q?Ied/tCzCNqa7Wri++doaCOQA3NFej8R/NXglz1cxGyspfis3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f460dc3d-6fed-4624-08b7-08dedc5bd4a6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 19:13:30.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GF6DaNbutUrHetFBHT4QNiYl7tfKpi2lK+ONDNDMfjgh6I606BlZM/Ml/2Ebiga+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7306

On Tue, Jul 07, 2026 at 12:27:00AM -0700, Nicolin Chen wrote:
> On Mon, Jul 06, 2026 at 01:26:40PM -0300, Jason Gunthorpe wrote:
> > +	/*
> > +	 * There are at most 5 possible values for NUM based on SCALE. The
> 
> Mind elaborating the "at most 5 possible values for NUM"?

Oh, I guess it is at most 6 since it is +1

How about:

	/*
	 * The spec defines the invalidated range as:
	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules and SCALE scales
	 * that by a power of two. We must pick NUM and SCALE so the range
	 * covers num_tg granules, i.e. (NUM+1) * 2^SCALE >= num_tg with
	 * NUM+1 <= 32. That constrains SCALE to:
	 *    ceil(num_tg / 2^SCALE) <= 32
	 *    SCALE >= ceil(log2(num_tg / 32))
	 * Choosing the smallest such SCALE gives the finest granularity and
	 * thus the tightest (least over-covering) range, and equivalently the
	 * largest NUM.
	 *
	 * Unlike other IOMMUs the spec has no alignment requirement on the
	 * address beyond alignment to tg (so long as TTL=0).
	 */

Jason

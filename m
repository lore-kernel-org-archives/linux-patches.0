Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E22DCBFC;
	Mon, 26 Jan 2026 21:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769461718; cv=fail; b=P0BfM++rLvizlfmTuQaxFcROhzdwBFT3KarKSbtL9TB7P8lt10b2KGLP+KKN7QK06oXqXp514dXiVV4OmuH7B9maQ4CkVDJrktCasOrHy3opx3De83ZWVJ01gq9oqGYzCk2ZM50+ZooPaQJqdKODu+wIj4w7ADaC9jw6Ivp7RwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769461718; c=relaxed/simple;
	bh=QYHuNKSUIdIBBM38g7muqjNdEYJPq/vQWPohhaO1xtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T0BTvRMRS4ZFeTbUrzAhXcEOaFxHgTXMSXSvZI7qUVIM7iuPLVoXRaEuWZhT5zRlLqgADcLmN6Wzjg49iRjLem/z8rkIoUbhS4Qx2pCQ8l6d2qmfrcgd+pK91GJDzqdz5lHXZRbe0eISoRlIR5GhcyE8dWXIOnabV4YK7D/JTrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dbmf5eMX; arc=fail smtp.client-ip=40.107.200.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dbmf5eMX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnUvzIJ5otTD8t+pfBX3NLl30rMSi+nvIouOOOWuEEl0rs3Hi7Un564JzZ85fryZGbB6lnxMn5ccrSYiCup5lVW9rG0xam6z7XAYNZ9U8qPy1vx3agKpGa10Q1WOxGCZK2XP10ulSgd//4MfmIyBGMY2gPCMdtrNwXaxju2EC8W8waWLyrNFbP0oqyQZiSa/f+gjLldh4ha7sYOR8oTMRoCFtAiYKfPo1BoefayRfWcBgf3oxP+ziYcTFpumCQBYpc7hsDSGDFaJS7Qz5JQIX1VnagRd3tbiNFOpQ8ct3WmNMpDL05FbiZgUzvu6JN5CUHDObLVEF6i0lTm1SDem+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCkTwPB5Dhbj0yNWNF7BzSkIRuxoGbAdaZqzcsW7LiE=;
 b=EjjTfDoUrPc0V4lt6SYzILaUKMwMvjl1YYaRRSf3foTbynlh9+vpWCP7zFqYfIkgToIHRy9aEVPjgXkprYy0oEZL9mEHxAbrixgugDtrEtluFOvI4mhKbt0fxcU5+enTWEnxmuIWMDVV8Tx5qcMwbPZ9drJS33mck4LKHoebB7XhIUh9NqnA1N3TjJJ+0ecOfT+MAqdbqw1f6EWxTbtHgmyCx1gfK658bfw03+gM17iTxOg3e5T2YNgTqVvJcEy1wCdLkG5B/GOreAOPAqvVA96PL13F2pO9dJjCkKqDjYz/vQEBNP+v5RC7dfJ1XYsjooFkiTxDs/b2sfyVUJYwYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCkTwPB5Dhbj0yNWNF7BzSkIRuxoGbAdaZqzcsW7LiE=;
 b=Dbmf5eMXPWOMuOLcOwES5VuyVrERRWX6287PGvbS6SdJ5Uwe5ju7p1eu0CZFKm3aUOq+jy3bXapuldjcbpNbqwyBCWfcTZ/QGZOTGXiTCQsrwQaIUcdCZsG+GM3ncme15t23S120mHtvlZ98iYQ6MATOxKn2Lp22jzUi/9ywsUHOtodbEk1q898eVDpjObp3ht57cifAG5Wn+7jz/Dceo5OXVIzEqu6USMF9OgTHsNOdgMgdYFxYK8BRCjfrgGkUTcn2G6IQEnmNAJiwy9v3Io1fAM3HybByJ8Z5CBIBMlQxtH+qYRqtFdOsTvbibiqUND3gSp9+98ipbl9xCVgTQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB9564.namprd12.prod.outlook.com (2603:10b6:8:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 21:08:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 21:08:34 +0000
Date: Mon, 26 Jan 2026 17:08:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Flush iotlb in
 arm_smmu_iotlb_tag_free()
Message-ID: <20260126210833.GA1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <4ee324e4f189fed601f4d947af10393b14dfb7d8.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ee324e4f189fed601f4d947af10393b14dfb7d8.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:91::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: de1e32a9-74dc-4b19-2d0a-08de5d1f10bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BhOG7O0NcX6dYr2hQVT6nfnbtj8anwP9nKOiUbOHxRIY49ADeO+oELUARp9z?=
 =?us-ascii?Q?PgV8EIJIusWR006db0kb3HeUm2g0lcx8uVHJx9aY2Eo9WRD1a7/EhWDcpD2m?=
 =?us-ascii?Q?ZcmBHApif7yEKFgTH7xSog3eF6mwO0IsqD0uYxFea7651R3I27HV4HJdoH09?=
 =?us-ascii?Q?P6n3YVUfKlnKyXZUD7y3sdf42FRik0IlH4NA3DyDJ6RmXHx9qug0xCQqyKAJ?=
 =?us-ascii?Q?hPFWEKn+TcjwIvOykvvJU3S2m6kX2lbhjCrPcN27ZLNkPnlC+jkVOBZDnZzL?=
 =?us-ascii?Q?MYEWCTK2S7wS/5vuzw8NXzqUkJ1YDDLbFV3D/2EvdJlxsG9rmf0ocPFBaQiO?=
 =?us-ascii?Q?/7LEHzfampMWrHjY9Co4lwozQT5E1YF7dFJqQVcndtLcGIAgvCc/6thNbO48?=
 =?us-ascii?Q?RuVN3K9mDJJDKSIyyeb397metuaYUDbmhPjCIVOIyBXI5+4eDKxUrgvTn+Gh?=
 =?us-ascii?Q?lr2WlMWAYaWbLxG9KwZwCMTHaH5+0KfcXITYvEiMN85PtxhOuXc9FKhzTGDH?=
 =?us-ascii?Q?e3BFMIDX1aHS6Deo1JTFX/23a8q+2J0AWrKpuM0s0e4LLTK4UEZjzxvvruUD?=
 =?us-ascii?Q?czIaWAAWm846gsJ0WqFUwdvGwt10Tgv5f4SKrF11v5p1jpzp4BkglMK65/05?=
 =?us-ascii?Q?rX/O8Y14g+z9u90r8NZZFrE7DIIELax+8oWntqGFy9QMFuOIBVD6eKk9TPjY?=
 =?us-ascii?Q?lPBorsOAByMrK7YcBlWboDomSfarEbqQSdhPAi39ZQaXcNZgKJYnJC03MPvg?=
 =?us-ascii?Q?9Y28Dsn74kU5MIPeSfr2Sp5pg8g5TAeDyOAdSZ9PHyiaqlYOua+VfCvS0sJb?=
 =?us-ascii?Q?EMml3nC5GOCxeUEM6qNx5vG/nPBOtWNKnQ+NIg7UZKTJ6v1kzJcmHzqlFkTG?=
 =?us-ascii?Q?XeqxORPYYa4vjVbsPJI+ljmj1zIOBPxZEswcBiqiLkTw91qZuy/gM8RjSd0H?=
 =?us-ascii?Q?xMkzxNpYeqoXaEKIXE8eoBDt4f9yERp6G4yJtogzvb4pxLjklrV96twIYTqK?=
 =?us-ascii?Q?JYP4FeJSjITwFWLqqWb18jICuWT51VUc8bGc18G6w9bnaseRmwUTfe1Ly6Ml?=
 =?us-ascii?Q?VRVioBIRqyAxkqRxUyWwVVzcdw1I44gxyCxFlg1aQ+gEbGYEkOEsZeq8p+fJ?=
 =?us-ascii?Q?ie9/otVDWlrSDnEOv809h0fADmEXZPBpSy3jtXdV3WVioU1YxBBPnn+W0cse?=
 =?us-ascii?Q?xDqAuEHmTtmhuLeoyzN3IXYk81bfLCDc8oqv5YJch4v0g6bGIqT0e+hToEQ8?=
 =?us-ascii?Q?uq4XSb33avMyCY93wMQceGqqIdMx69xU/Q4BZQY/2OSmdABtjRZOmH+7Z404?=
 =?us-ascii?Q?0w6KhsAWgvLhdVZcs/APzRv9ACZYjkoWuYkZDR2P91duTpHk1jIqQ3QLln1H?=
 =?us-ascii?Q?63Fq7OXfEtdtiWJc55ZMQZ/SD0pb071p1I/XXzcS1QIohcnY+Ei9N9EEHB0L?=
 =?us-ascii?Q?UZRJINLNIqb0Rqsq7fPSsW7gqzmkfbrz9KwyeVZCAJqDOFPWudcLl9x/9OUx?=
 =?us-ascii?Q?Tt/Hkua9tkLCkGFFHj6jiornNrwKJHRat86QsaSJyrMQlskTBxcNMTTHdHiM?=
 =?us-ascii?Q?fOWbllwSjFqOL3lur5w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ltBtLkkC1JcB+qbHk/JDOS5PyYOSrrEEAV2+I3oU6suXNF3roBpGFAkFajRS?=
 =?us-ascii?Q?HhHzz2Ej74x1LcmQ1kVBATxMF90PWYRhJ9HxZtdXSnvfk2tLo3NrHKdLrVjD?=
 =?us-ascii?Q?Gs0Y+iBPMoG59e8Jf4oa89iUu4ob9cx1FQyJJFaFr1TwiLn14FAs1oekIPtr?=
 =?us-ascii?Q?Me1gCJKw5fdAEg1ykbIbuUoQrXe8YGF741GQmivK0KzgXnwsua5VmILS1+xF?=
 =?us-ascii?Q?C3849LqvqwoBdlm4SBKbWsC3mcVPc95WcQ9hD1efanb0d7z13aw5yKUzcNr4?=
 =?us-ascii?Q?5ZbQ5vODKSnpiXPtUDWGZsaUn9eFMfaEgnRvE96nGgpCQLOAtJLJFErkCVU5?=
 =?us-ascii?Q?Zugxcqh5wWPP76Siy+Ps/ZLCh69u5PSWVwHKajrU9EQKMotYjSIf0nmFA+8/?=
 =?us-ascii?Q?GJb/kw9LsyOSvd0ocACuzt1o+NpyuQovMhZpdcByaivqD88Vkmi0mLMffI/e?=
 =?us-ascii?Q?cB+ozDrCN7FR7E8uRmsElsBqsnk/CpJ6y9Zj3nx4UCweY/EgdMRIH8cof8iw?=
 =?us-ascii?Q?97XoZHhRg6HuXfn2HO3RPDzYwJeOTvMUAg65994MAoeCVnGmbHseTFq0YCD/?=
 =?us-ascii?Q?mhbogkQ0CtESqj8E/q5lGPP5+9OLykB8DhPqqDdHnN8jGhb6dyqi3iIgYbXj?=
 =?us-ascii?Q?mlEzXxC1m2lN0gX7ug191BxjuP3t/ZNm1RxEUui94Q2+51Sm2ksU0CJus2Ua?=
 =?us-ascii?Q?7fW6bvVvzefOGX9ldGzFJTjCGLGPx1RS84gYzz2bqHpB5dylhJiRpeNJMWZx?=
 =?us-ascii?Q?kp2F3XCm1nU/sAbZp/bC34zfog6eoN6M9XInY3pTc9ne70ysOJSHcHdzDYs0?=
 =?us-ascii?Q?+2bH4meOmT2/MGgwknPo56jsjuGprwtsg8g1SieiF9BPoWs1iXU3F6poL/OM?=
 =?us-ascii?Q?Q9lJ5zdjLN2NbTLKtG3Oo/gd40AXO4UONZErhSr7aySF7f3+5zNN/GViFL98?=
 =?us-ascii?Q?2jBy1VtKlgoiL+Llwbrb9M57f+9c+vpZpLARnxB809IiSIQsAy70qtQoeCOl?=
 =?us-ascii?Q?ac6hKo1DmI2AR7VCEgsoY4r7KmmwJRpixad5JdfGR4n1AQjHuBaqshpkZMwT?=
 =?us-ascii?Q?FEdAZQXMTn4sawtVVbSbG7+uxlSckt27E2+CA5XrCjuZyUzAxYf3a/u0Go0U?=
 =?us-ascii?Q?YrdGCMmsxl8TILsSUm61UUcxUwnc/oj+biT7tg0G1Db3UeQVQKooQPFGpdLI?=
 =?us-ascii?Q?nUN6UfbgmNmtW+1JtqE1XsS0FRljziH0ZMq4W8e7hQFqTP8xwEomzqkeqMqs?=
 =?us-ascii?Q?Lp9ydzSxknHEgVpoGEzVQpyU/Qp+ng3qYcVKn2um7cInpACML0FTj8HDiQ5d?=
 =?us-ascii?Q?LDUoMYc2gOAaAvrFAZ9UYgj7Zx8L6pWo3Jlx3Fn9SyWJ7lEhPTjFng6YWKOr?=
 =?us-ascii?Q?FG6i42P4gxd1deg8O/QhU0Ldbx8qk4z0Ngnnhj9P6OP6xB0Ln3QYcO820VRz?=
 =?us-ascii?Q?KM5c76Sj/YM90aKFAfvVttM+DUpfVC0kVX6Su9VsflCDNtkcMY3gu4ZDxp63?=
 =?us-ascii?Q?NiFbN21BcMgirkK3AdL1YrFFVIlQ0E+GjgP6TgtW0kL8X2SOD9rmj4s0UyrD?=
 =?us-ascii?Q?Y3rDOOjh7YXloJzdZ0XLvM+lTvsbW7MaZ3IkiuUwrEcJZFvroTbQRkMt4x4i?=
 =?us-ascii?Q?/56P/VHLcqpY/vyQLx971MfbqiOZuBI3XuFEla7ENJw/UmQ6A5+GvIIThTcJ?=
 =?us-ascii?Q?AJf8LlOyNJ9c1175gS+J+yFc9BDMTp1Q5nBPyC0T/M3Q3K3ds6n1E0TvMFkz?=
 =?us-ascii?Q?wbpGBKO16Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de1e32a9-74dc-4b19-2d0a-08de5d1f10bd
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 21:08:34.1190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdk7UE9qks1jAClxjA+eTIMkJpS5ZJyIMDb9V+uTLEH0TVR75LxMYP2a6+TznXC5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564

On Wed, Jan 21, 2026 at 05:24:23PM -0800, Nicolin Chen wrote:
>  static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
>  {
> +	struct arm_smmu_cmdq_ent cmd = {
> +		.opcode = tag->nsize_opcode,
> +	};
> +
> +	if (tag->type == INV_TYPE_S1_ASID)
> +		cmd.tlbi.asid = tag->id;
> +	else
> +		cmd.tlbi.vmid = tag->id;
> +	arm_smmu_cmdq_issue_cmd_with_sync(tag->smmu, &cmd);

I think in all these places checking the tag->type it is probably a
good idea to not use a catch all else for vmid? We have many tag types
and some should never come to this, or other, functions.

Jason

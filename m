Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A862B9BF;
	Mon, 24 Feb 2025 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740425955; cv=fail; b=a04YLE9S8NxI168KDViG9YsoTgr83jCs5HsUBEYAS4FihKH5rF4J0yvffOvbMyh6JF2hVJJzzv+J6hsCkztBXlJJBhkV+PAVb9lrBLznoDGoeQfZLoEyrzzPJa2X51KXTAvXP6J9mwqKN0pQKIdefxhfTA9xVZkSGR/NWxAtG6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740425955; c=relaxed/simple;
	bh=SjCItV+DmYCOKLHMudwziWsfejAp9ci2VLabVi1MELU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mGKlguIucQda9jfTJSZzlFWf6EUnwUaoFH54NHDYrrPBSZTZTSSy0ofgWG+PbLib5b2qf9r9P2SDgC+Ss2p/zwz5tlDy8F+HxYNBsg3QcE7M3CghmNhbX+nYfKxYJBUm5zZ742xKN8tv+8PQFeaKGRVj1AGksXBdUlrA8E/t2k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JkdrywwZ; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JkdrywwZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpgZIoADCjgwbFcoliAwZykGXYO9MaeHBC5w4tV3h+Vgp0T3LqwMZi1hlvNl6WG8qK4R6mLtZAK6pqryUWiYS62K3qx9CeDztFxGhEA3jJIEBcaTuBSLlmQ8uywOra4y/fKMgIafUYpu3FPw2xZWzLcscsnhg+hsJICFi0aPURFrJd1Wobw26OlQHmLnWCPhUHnCH6J4bWmLY0VJh1jEiFqIA7IJUFcWM3extBiCAlAvojMaknV0Wu8DsktjVpAM6PXNigdCF7lm07A2PDzCR8StDEr4fHq5s2s6idJl9/U7SD5wqQ6q6YT9tiiI0XFHlWfbq0aB1OytjePNHtbukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIg1Aq815KcQGXdpofO1X4gJCyY6+fsepDSYwr6N8CU=;
 b=eqtwcUgRo/r22ucPRU+WkAWFxG1VzlENFEKW59JTbkZMqaa3ElDlsClf3SUpMuz7BPutMPe8cTSHCoNJsR2Kqej09MCGN5fAJPglnGY7HMDk/yQr1PvFTm+tRkZ0T6bKXOJzMM7wIuP1xo+4fdmggCNsGL+3zp212GjC1rwtV/NL6/WcsF+nyf88PvxqmPtnXjIMkJprJM/5TCO3zTHlfQBH4z+At5LTZ4fq664uaHOBVVKH8bmH33THlKZtyMdKg1uKWSRR5j/tOegRxvtdKppXVS6yK30zuzeKvvrj/LA4Fn2oekkJOBNbeQNoRdlyHC0K3y/ynYyq971u6tsjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIg1Aq815KcQGXdpofO1X4gJCyY6+fsepDSYwr6N8CU=;
 b=JkdrywwZa0AIC9DmxuJCkXLo4EnM1DpaqDv9a/GlxpKRFYak+RChazkfRY67N5kD/2+GvwpheqY/+aeZogMhueGcVEwkqun4+bY0oqiKKAQqcH22Va8iFjwBUgwjda6pkxgpl6x+UAOzL3ddKqVekvh5IN6KW6P9iXl3HoPy2J5jb1tl7mwc8rS1wMLm8lQmA/xpQF40G4J1/2AhR46UR/bNdsqC8rTOfv0lwWgFLFUFL9KzJa+RwOmVELwTSvNMEY13doByfZKkob3DCDE56uPmCkbS6fcVt5Yz7Gs95FQS+0czJL+ec2Ke0rXzZDjwL153wGsdgad6N1bIjpu+Cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8326.namprd12.prod.outlook.com (2603:10b6:208:40d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 19:39:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 19:39:06 +0000
Date: Mon, 24 Feb 2025 15:39:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Jacob Pan <jacob.pan@linux.microsoft.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250224193904.GB524338@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250211164151.723cfce0@DESKTOP-0403QTC.>
 <20250212125007.GP3754072@nvidia.com>
 <20250221114206.GB719702@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221114206.GB719702@myrica>
X-ClientProxiedBy: YQBPR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8326:EE_
X-MS-Office365-Filtering-Correlation-Id: d59a3009-b84f-41c8-4730-08dd550ae63e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F69gV3iFe9AHo9le8t5/RHqPgcpskL0JOK0jgvhHZ2l7ZT+Ezx3j5VHTfU27?=
 =?us-ascii?Q?2VNJ3kbm+WDxqT0EK0009rfs0l6+3z4WZr6oQf8jYQNh9hbLi7IP3ndEH0fG?=
 =?us-ascii?Q?wb4/6wkmzvdYqBulsNl74tN5WE4HrKW9XsfV1/eVhfiLuQFVO9bdXcwtFVQ3?=
 =?us-ascii?Q?4S2B/jAlzZrX1KRTNOXsLCzk4HQLckCn5sCXtePst1leCA6OcSgCHRII9gjX?=
 =?us-ascii?Q?S3J08O76CilRjpoO4Q5ITCoqeZRk83Fb7ujb2xRRvWRPk/xk16bC2/qmVcaG?=
 =?us-ascii?Q?0e43cH5EBkOAOBn8tIAvvDpYTIpQ5v+YljXmKzRWTTO7qyFnogjM/U8tvNfO?=
 =?us-ascii?Q?XIuIyVf2+PPD4f8vst4wZDRU51WNVS4bPF7ZwJSQCI2AmPgD35XOpYscDU4D?=
 =?us-ascii?Q?aUr78tovQfjhWHja/552Y/reusoXtHhQYr5StzBOd2RHs2FWe1jXzrgfKkft?=
 =?us-ascii?Q?lk1Hr2Y+qGEr+MfKyVKai9KrHD8wJ9Idn2QN6Z/JTprg45aswqsExuAGgXUj?=
 =?us-ascii?Q?ZD3zqWf6xTg1d81qjFfxvxpoOJMRxavbVaUyTqGuSqPZp2b5WQFAYzKefs/S?=
 =?us-ascii?Q?FbW90RdQYzQOrBmBNbEE99Y0P3ABrrRjKrSiKVfTFxFMouiHfFl7wdVujCs0?=
 =?us-ascii?Q?m5GG/q7AVerildEYLTn7mr+M1/z8EEGFOCvJnBSbkpXnYHyhqcPCCPeeUFMG?=
 =?us-ascii?Q?4b8s6c/7Ylc/LN4uRQuPmLvMLd50mB0eZMdja5CPnrFN50DmwY5kRPMf/KcD?=
 =?us-ascii?Q?CWkWTNVci1rkMFRJhgONiEglvHvbaxLP1dOUBNyUQUIBQHWcrL1n2v6xJDII?=
 =?us-ascii?Q?L7FlyCFPeSpWrKJ6y6SWEv+cSQ0pnNnulpLijk7DNKbTgMvmJgAYmhOcBB4r?=
 =?us-ascii?Q?tEjYyDaXXh/sSwMS/l0AASQXG5fxkZFBsm/n02OzuvfS50XMT4BzhsQ3pGM1?=
 =?us-ascii?Q?F5cYYKStYXJqztdk29I2tZIO75W8/9eIUbI4UXos1kayscC+T86HVl8zbpcc?=
 =?us-ascii?Q?6eZfyozTZ/GWGRlMf2md6W1QUxWn7fh3LgqR8qwrQTfWUArZygOR3owuV6aA?=
 =?us-ascii?Q?NWdZ3ylo9wnS46vpzRrMTLg4uS+SGDHc9swr0RjbzcopYL9QVas5Wr2539yO?=
 =?us-ascii?Q?LrWdhpPE3qc3uW8ovknW+Df3ARQcl1QOvip/v0LB834mZwuiwhWZ9O/z0TaJ?=
 =?us-ascii?Q?V5jz39zWle0+AJf9iaptx9DqON/B05ruy0VKULd6eQJOhn0VPaM7aqPacxta?=
 =?us-ascii?Q?TB+ebBJsgijxniL+WL9h4D88oUd7QL+aNxYXlm9ve6lx56EgGgulit5JtZpi?=
 =?us-ascii?Q?6HCj2Sr20eKT2jLvKSYqe+my35/4d57DRzi8KYMJfh8QHwxVQHZGr9Wk+h3k?=
 =?us-ascii?Q?P7PSG6xqth30R27EnRMTQNIAWuKx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xZgWe+fX9oBuLTxkIvtY+NhvGcJaVAQBHXqYdxbdeciF6ladgnthvOVeFoIB?=
 =?us-ascii?Q?pJd73s2Y0AFJOna5zvycFpRYo53+z1bSDox1wK6AEPRxBd6AUgBNyqzapR+2?=
 =?us-ascii?Q?FsLQhdTOsNhVliYAuZvjO6ATKVWJp8/9d2OuxTE9l9asG3egYZ6UNgzA+F/P?=
 =?us-ascii?Q?UT1Uh56YjuM0z5I/qjBet3rxWnUmkK+jbf/z5reXIMJmVi5Gm9rERO5PGPN8?=
 =?us-ascii?Q?5sme3mbGWBC5GE2oUUeFfaLAYwfPJamDv2jvMVnvWUV7MUWTdEOOndDvculr?=
 =?us-ascii?Q?V0B8JBB6DNItryCBR5PqtoA63AQSrcGiHatJtNG+ihJxDxriG21mFogFHfvd?=
 =?us-ascii?Q?DtRvQXPVUDbJt9gWYlOfSSR/DeszgYPbI3YO6SwqWiJiPkPIrty6ZlI3qYF+?=
 =?us-ascii?Q?QmHlyijWZZsxrx4uv548aljS/vqghjGsjdpgEmiJHo9gL1XTsHK1p/88EiC1?=
 =?us-ascii?Q?uDdAWNaLAW8Dpdkc3bKHD/f6z69a79eKyasOJb5AyLAtVZRuyWy64y2Pv7hQ?=
 =?us-ascii?Q?J0S2xgpD1AkWCMXt/R2YXwE2jFx4Sv85a2dlsGu9Vq0EGzrfCnNvH62zAjBE?=
 =?us-ascii?Q?8ndC+0iK0yzdtZO9agPcLsBzKRJk7vcAS29bBDmCYzDfLJ6fghNf5nYTZiTO?=
 =?us-ascii?Q?9oRKf+Wd4mIamtzGxnbksxFhyn3bLOHJB9/EBpqjeP5pepecndOGEO3nQCuO?=
 =?us-ascii?Q?F+8Wd7btO9CdCcyN8NE3A80S9Xems0RrpLsX3jaXNFl/OZq2MC7LKvb/1TUu?=
 =?us-ascii?Q?LZXKcxKaaDL9q+UKqe1/7NImKsziEHcwDu7FOfDGKvGP9y01CNL2wMig38t+?=
 =?us-ascii?Q?Cd6Rysn8lk8yUivLdiGQ5hcJSpi1HzK7fwyzqqIPZlPGVc1Keok3F2kQjftj?=
 =?us-ascii?Q?UYRCngBFeUpZGRmQD2sZ7JeEIMJKRlEiedS6sEwMz83KnZhAZcWx615j4z4s?=
 =?us-ascii?Q?wYEBAaA4ld39zylnaStRMlWnI+xK7Bu/jsiwa50n8ZMLRObqe4kC8NmniWKe?=
 =?us-ascii?Q?5SUQT56w8lAMpumjbPo0X6BRJ4fawBI1NiJHLLTOqkysIucj5TmEV3oKgSPP?=
 =?us-ascii?Q?DqGGz3suapd/f6BJy7vtCzAv8TOMSh261EqzXVwjrmZk72JZjl3vO0YyxnkB?=
 =?us-ascii?Q?CTV064TKwVNlaC1VpDLG8eAhT7Pq9Afg2pd4N/NFLtNKnTuswSPKi1In6n9D?=
 =?us-ascii?Q?f6/5aiAoU9xDOUpWcPHTzxbLsXZbL7wfrOT99TCdfhvqXXVdiNfCmptcrBF4?=
 =?us-ascii?Q?Oiwzapolz1VegsDNSmUXK8Nd/bpx2VGd2NgGFjWQD292nRTj3qqM/HcvDdSH?=
 =?us-ascii?Q?oqW00JqhDT2/Z2/8hXgqHChCBAQVSF/YzOCLsI/a2FpzrynSFli9vUSsMC+H?=
 =?us-ascii?Q?ce7j/h2Tg2tu4lWf3hmiqa54QRonOW5zFDdUJuuPfSuAA/vUGT86Q7Qm+G3j?=
 =?us-ascii?Q?YezmGPW8c1xE+uxroFjVV3sCNC710NpFCodrnKkS5gGxxufCyBPy9kJuBW6S?=
 =?us-ascii?Q?PL3PxfkXQzc7LXeyWm/5A0C4gNcWYBQtSLCal3Iq40RAfE9WlphkYrhtsg2c?=
 =?us-ascii?Q?Mjb+U4N7DJR6qn4z1UBHdVSVofHcrDZuL/df/6Ma?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59a3009-b84f-41c8-4730-08dd550ae63e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 19:39:06.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1ULEvtgp00eVduQ8RPW4SPrblLHeZ0K2FNFNRdq5Q9VmQwMggJtkJOxZeRA8t1R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8326

On Fri, Feb 21, 2025 at 11:42:06AM +0000, Jean-Philippe Brucker wrote:
> > There is no requirement that an iommu driver implement identity, this
> > is all an optimization. If it doesn't work in alot of cases can we
> > just remove it? It would simplfy a lot..
> 
> No objection.  Identity domains are useful if the use-case of virtio-iommu
> is assigning devices to guest userspace, in which case you'd want to
> bypass the IOMMU for the devices that are still owned by the kernel. But
> VMMs have at least two alternatives to identity-mapping (BYPASS feature
> and tailored topology).

Since Robin pointed out a few other drivers that would like to use the
domain_op lets leave it as is.

Thanks,
Jason

Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9763E7BC8;
	Wed, 15 Jul 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127279; cv=fail; b=uqgHII+IwnpeRk6d2Jf0P5hP1h36jmF9LhLeXea+4VmJcOrGyvCBoD6NhReZnQ6TYKKdMhbSuXozy3vCjwKEdUbh+l2j4yclMBkKqKY1xD8U+d9KvwnACfx7sKfyLvcH7Z1ssA5EiujkLNuxje0p8+iDTQTUhd5yQBoX4U5U5jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127279; c=relaxed/simple;
	bh=gOJiGrJa6VzWrzFhufV4rFL7cmg/1G5U/ENWwkuSJ/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EgEH1kq1V/rd5+hdQJ7lXICZMFPz07wBQCrsvJGF3SUPx5FCjTPSRhpNlYPH0sh1G5k/IMyTV8p1/VkbEYdWAupXxY136bOxmMQDHs0Xo596lwUS1AhbRVOJyeDr0wkPWIbVty5C6ROo5dLFHFytTeJN1iZXBg34oddNOs93jZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MhTTRe7i; arc=fail smtp.client-ip=40.93.201.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MhTTRe7i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRZ08nTimrVVWwP90xEJlUoInVYdWvxBKFeD0NYIlgiGMkGqzhbWif47h6T5Bew4os2RYMYRyyLgVl500ARSHAJo1Hd1i33iKoS93nCJetWrZ5MGrDk21pgKoX/fIBeiA2TYX2spic7Lcj0lcVJhyTitL2nKB+VjOE+LqJjxhIAt1yyHkheEPtCVK0RnpqCgt3UqWXl+I0YaOrrwGwuC8Bi2bShUwqhg0OeCsKCR+AoR37Id0SCFJ6v2t+iNbDRkYHMeSWsg++c3DscCmLsMotOO0GPMLZ9a+7xpHhyHOQe6HOEGojU4gdH+MweK5Sx52K2vxUwvDQKuhr4RV0lG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=013RwQcVOBDEezjsjlFIjBC2Z2+pxIZ8JdM3AwD+kc0=;
 b=BJcJ5odGxj3ifAqCeAJIozGDNoRbQiXfIODRxtMmtUqjFJi63+1IpQvNl5XHHYogNx+o6oZROtNvKkh5REYwGnwrdlNfhBO4CGUptgz+x0c6J+g4F3YybQLjSmggigZQxBhOrQmYBEKLwuFhRzqTDaJe8+4qcOGxjPjuyZxz6wd14N3BZonW/tBXNBfsiSbFhfQ8TdiYK26gSWhJapSYIjar7h68oNeuaXdnc/hSjRDKn+dFyIR6bLV7UoC6I2RVcCckc9anisEO7XhsP7zrtJvpX38maB6N4/yJMACPclAXib/N1QEhD7aYPZI/2VUzYRiVD9JsYrgpQoEHz70YsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=013RwQcVOBDEezjsjlFIjBC2Z2+pxIZ8JdM3AwD+kc0=;
 b=MhTTRe7i56467WbH3uPkt3djqGjVCHUwD4IHLSpSc1ZZAi60q9NuJ6fjbdVrxacJ7jzdU0cb2MOGhG5hdWd/tLHesHyEO8Gx2iuooXQFgzX6grYSeXcCFwDElMseWi+yX/C4B1vsrIEve9XQTvD8pD3un9Y2vS043eAhYwtZRa3bRcueCNKYc/EfLGHzfuuTeLjs2OzuZBY3Opy6+GC5nyD2McDN2ko8eAoj78ni2nRt4f/NBbRmiv6yYm4P9Ps0qXofPdqantoWZHG3azPvvYrdaOV1bH9bF8KoJ7HXVOKG8/E/+xCr6ByB9lS6lRFFh7auLHa1uW2og1wwWpVlDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Wed, 15 Jul
 2026 14:54:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Wed, 15 Jul 2026
 14:54:30 +0000
Date: Wed, 15 Jul 2026 11:54:29 -0300
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
Subject: Re: [PATCH v3 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <20260715145429.GA103013@nvidia.com>
References: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
 <6-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
 <alaqMJnkplAuT9kT@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alaqMJnkplAuT9kT@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0125.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: be2c645e-0599-453a-77c3-08dee280f983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l0/vKWqrXm1Nz1F7Vr2EnJfER6xiTxTKZO0CAYu9CPnjsY56ZqZ3S6xON3sTAiMl5gUMerKYNcC7BA7WXXjX2wGNNZ4/w92P2BqvTWYNsqSmdQ17VQz+nyYfanisKXZZ2EP5xeBo2Hb4XPfZt35/hUDkD0hqv386w32wFd9Iac0toaXMnQaeYx61wpdJUPI88JbhAEZ3xzKsjPOlU7AQuQK7zz3pVgpkG1zaBH/vvNpCXdb8qIYb2ppt2don4gYnc8XBOWcsC6E86Dt1b4hW1YsrZoHo3U5owE7VHTULMBbJMBIIzOP9E7fyDQIW0FrEdX88dzo6o5xFuPwb+31WX+/TVr32RzI9PNgILT/qVhAVqVDo3o01zB7u3oK2bkkJp4UZ/8MX8UAW1ijM0f5fCB7+bVXJy/ccCn8n7hMX68cs3hPEFR8PrQIaxwingvKkMATchA8Y8+6F8URSknqVQS9nK7ofL3HMHBq3t/Yydh2DW/r+NKL37ovB2pA/nHpz2mBPD3mbXYfd+WLBOheJMN3c0U4FmLbrPORSx2Puo2g9f+GuGPFLEKmJgorP8F44+T4d/hRy9+Yab9YTC0nXs2fWXmv29EMO6BCL/OWhO0zVe5NSRgq+LpVwD8Yj59sl9RofCu6EQcoSrtLaa3dMfRzlZxZ7eMewaOtPGJgmXO4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RZY+cG3FxeekN1bD+uMu49EsJYN+aNgBRhapBrTrSGlnXf8ciSHV92AUR6we?=
 =?us-ascii?Q?H4sBvECxvLEIF+wEFJD2gdWBUYRtOmmYFdtryOipfV0vKsq+PqL1RdzmzRpg?=
 =?us-ascii?Q?mmDv4/3aQ7xd2ihPyQAyTzu4eEZ9p+3EsN/CDqV6neMzxrd+00OqZeZI73XT?=
 =?us-ascii?Q?0au56Ywb4rCPiu51y+pBUTrYfYLpu6DtRmB8QNsthlu3AtA+nh9Gt2BsXJQn?=
 =?us-ascii?Q?gZSAISEksiJfBPeb+S7sbgEwCfH/SerRaKEjYV7K6cfGo3EJk2Es3plO8LmH?=
 =?us-ascii?Q?7Drj35J/dh/Krb+RE4uUjVXYox3gariK+PBl6WPKJqHuslvU0Z3kAJTofCy7?=
 =?us-ascii?Q?oQw4odlcM6ss91VvZitwaamVdS8+fSEgWap9Y9kd8T5iooEPUFQTK42gsNtD?=
 =?us-ascii?Q?fWH6O2t5/ApWYIvOfc+xjIDB0naS8k4U3Ds+nu62plZi+n4+GxM6we1xSyZ3?=
 =?us-ascii?Q?Jy/Ns3+iQqIC7i9UCMzPJSqTJHiZYFblb31s7P2pVOdLlYkOZ7RQHn1pVPkq?=
 =?us-ascii?Q?mGAjqLUPRnGsqsSoDrlkETU18QMEL3qaETZw3No0J4zl4RuX0HKwN+QGQNLw?=
 =?us-ascii?Q?y9jd03TzZkDOBtFxe0bwXGr1WIflKGlhx0LYnr+W9UVlnBpl7oY91zKZQQfB?=
 =?us-ascii?Q?WBY5oAUmX4+uy2JFQTI/rydR4RorGNsCaLAaRkrAeVK4czs851aYGf99NERH?=
 =?us-ascii?Q?FL3Vq48yHx1b3PPs4P0nvP9YLXkTGZDnst1JTqUrOouKAnokEo4CacbcGiOC?=
 =?us-ascii?Q?m6NqHAQGNouWNGoY9JL0UIlrZNiRk1c9vzcg4rUR0li5OzdQK7wI1GnGQr4y?=
 =?us-ascii?Q?Ef/p6CP5pcytZOc33hU2j1Y1T9Dx856N/w8Pmz/4BYZcpkSR8MW36pWkKpaO?=
 =?us-ascii?Q?/DCN8X1kNuKimxk+MTIF3sxbQ2uv0NYsAdz0VDkrm5VpeAN73jkcpVb8q5jy?=
 =?us-ascii?Q?En3IRsRtN67FocdA4B7MYuFQwj8tUDzWdt8+9VqlNQ+dAJYUN3CR3nINxG4P?=
 =?us-ascii?Q?yz97hK4rZpOwqgg0Qo9Ii+kaBXsXi5t+7S+51OLI3efqkbPt9pSVqC550LmH?=
 =?us-ascii?Q?kQKTQqr1cfSgKxtuYNsK07NR20SmKiw+FKvHAs6k+rXJ3fiIf5UEmqhga0Rm?=
 =?us-ascii?Q?RSwODC1t/8zDpanLS7kCM1Mekc8bu9SB7QzO4kRie/addPAeUc09OgmMZ+9F?=
 =?us-ascii?Q?LAif62EHE9TWM1IChLEARLCmC5p9T2PbO7yjphM/13hrLQSNakVmVl6wxZu6?=
 =?us-ascii?Q?W/Qzd3oCsIbUQi0b54nBGHUepaPc9RT67cFyXn0Ew385wnqwlJv/v00RKAsS?=
 =?us-ascii?Q?Zl3VmSJ9WOVpcSkYGxcXDiNQ/hZIL6Dc30DoaYWd2ookWlBraLzISN0N7vsg?=
 =?us-ascii?Q?Vddxc3YscYMrW4ZrDv3sqJnFC3qTlqhFghg1x/tNBPD7nGDvWRp56Spm2f8m?=
 =?us-ascii?Q?la7t8qlW9dDdDfrMsbBmcuHfs1pxKweYEkgSbmgf18jDbiH/jEjyPzMHuNSP?=
 =?us-ascii?Q?ERUld2hEXkoIrF89dl6bjEfEcL61cp+kIAIlVbMWMtgFux86009GSegHC8Cv?=
 =?us-ascii?Q?D7bXONWD83Kk8kiJ4i9eYeiZxfW+etrftj19nOjEp1+a1Ro+FfqF5+Fdnyux?=
 =?us-ascii?Q?QNRSfobBwRcD650fS290Nfoczr229vPOa3xy1THGRJvt8/xu7PrhzQEIwwu7?=
 =?us-ascii?Q?GjTwaXpVYzYKBMNe37ICkVXPwQUJAm71iGhxnrqur47907qA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2c645e-0599-453a-77c3-08dee280f983
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 14:54:30.5503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qF/ailTKtMtBIuU6fpCmqAkkUW0qvpLIXEPM8YPUrwLuu571XI2sSn88YiTXGB0w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230

On Tue, Jul 14, 2026 at 02:29:20PM -0700, Nicolin Chen wrote:
> On Tue, Jul 14, 2026 at 03:46:06PM -0300, Jason Gunthorpe wrote:
> > +/*
> > + * Called by io-pgtable-arm.c for each single table level it wants to remove.
> > + * size is the size of the table level and granule is the tg in bytes. This must
> > + * clear the walk cache and any leaves within the range.
> > + */
> >  static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
> >  				  size_t granule, void *cookie)
> >  {
> >  	struct arm_smmu_domain *smmu_domain = cookie;
> > +	struct arm_smmu_tlbi tlbi = {
> > +		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> > +		.iova = iova,
> > +		.size = size,
> > +		.iopte_size = smmu_domain->tgsz_lg2,
> 
> Sashiko reported a typo here, though this gets fixed in patch-7.

Oops, I forgot the shift! But it is supposed to be tgsz since it has
to be tgsz to clear all the leaves.

Jason

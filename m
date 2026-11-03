Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793728600;
	b=lDSYxGAgrhsGIBixQrD74x/Djy3KDNWhM/pKAJpGUxu2+itNnfdysuBrt470E+gipp3U
	 D0pByIrANs5nyvXdKkXrYJSpr4Zg0iW7g7U7Hk7U5BF9pWXSxGzaALJxUzVJs5h7+Tmkq
	 BdKmx9kU/3gA7Bc/UBNArrRVOUt07QjbFrn3867tblNYXjnyDwaNbsfR/t0Mb6tklLvpB
	 pXfxZp9CImWsxIUUwM2WrDN+Z0nOrLkm61VOAV1K1ZIlsGUIbfUBMvvnAmOGSDw9E4YCV
	 C/+ZyOwjRgtgT/LJcTGxujYBisdth2jIlV9Rce9KACQQo1Fqdyz/+kqC5O2Gsy6ZNfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728600;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=wxkKUdNJ/YKke8UBkNYS5DVVUs9hlI82IGJbPleji5o=;
	b=t4LJN9di70p2XJty51ymo0Pitg5ep7a3vVeFua1AQ6BSx5W3vvLLFwBZWXjFbsNQU57b
	 Bj8Hl4K+X2dJ05kDLacUGH+vSUeBfTkoKKqR8ttIcGNDWzm/BcxhJEDRDx/34NTlFaFAu
	 gx0CVPhNEk6F+ZEGKfKreUm2s/za4w8G7E3AtM6FE4lq9Zv2bBQirO/4ud7QiJo3cdnGX
	 y5EDuxmig03Frn7yipZXKCs4ai6i0ng/Q9kcQ6WZCClHAyN5mHskA4DBJJ9FmMGRBM5wp
	 n+AYle5oMsE+ECL5Y5u4ZER5xlV9mR9iF58v9NgBBPHnsJpA9CAro5A3greDiVFAOnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KKwvLzll;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.68
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98791606A324;
	Tue,  3 Nov 2026 17:56:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98791606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KKwvLzll
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXVZU41GBPKL1pNvJwzVc7TTQt0Cjt0xb0WnmuzzFg1t5gIbJ3vI3vwGYyHw+TLzHq1ihtdsClF8d036Nf6a8+lHSCloF50QfFqV4hFLHbsrF47wNfUyUetW9OIAarGjukdofb890YQt21vF93KaOAkNZteyJdeyHWvsOk1Erbjg+9nxdjD9A0IEPT2fTUJKweCdQOi7WDg/ouQBoLcVh4CkI8otuQUa1Nh2oTAiAvRBMXRPsVtALcf0UyAZvAjptcP29gkYgg5zw+kexB9nhXsrbWQrIdOFbBS0354NXSzSL+964nVkulQcov4Zou/iRnyib+9vIDB4LsErIn60ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxkKUdNJ/YKke8UBkNYS5DVVUs9hlI82IGJbPleji5o=;
 b=Cq2m5U9+PbbhR3Ojy66WGinjdXExHwJcZPesZ2zj8/pGhTKMHoIJ/sCYFsttRo9XJ9hrBSXk80IoJViFrM3TP9KjjK9sNuJ4tBRlEDdakvJMoxaH4Q3pQpYRhPSsl+YJfnPMmv/ifxwlSpNJPVGlaHRvD/u02RzM8wKFdFJhbjdj0H+udgoReUyByPu9BShb4gcOH3/c42+LXYKWxOUtFe08BWCbl0BLvkBK3CJ+h83rDcR+SP9/jIbNGJQqPc8KzVkDutk7jlBshWCifti9ZUF8t8a3o1SP3M1zDtrSBQWhCjVNW2Li5/uwmgfNoBhjCg6TjLqYJmNCRFtCKTaK+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxkKUdNJ/YKke8UBkNYS5DVVUs9hlI82IGJbPleji5o=;
 b=KKwvLzlliTLF4XVGwNW2pAr7xXc4PD2bN9CDwXMEtD6sz1mO2h7K3FwV5TaJ+jo0xnjn6h8kqu5DiP2KEVogHOpGr7SFJ9DOHUPNnaeIyWn342Ofrn4lj2VoogfP7ENlP9YlsZoFxH0wkhipi8CW126XPjUh2kUvHCuIMm7zm2d+HDH0NWmg8NS8WNPX6fI9qMU5feXQKkEAERyif8hUEzKhZjSJTixI0Ae19d5R9Krc5Ma/mzAicaRDWHuEfBNSzffWI44NU+bEwr3thlVyHwEnjRLRMLwyW/+jaU39i2kmnsldcq9VIS/fVNGjjACkpmlDLsPGTgXNK1xsR2ULng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS4PR12MB9681.namprd12.prod.outlook.com
 (2603:10b6:8:281::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:56:34 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 17:56:34 +0000
Date: Tue, 3 Nov 2026 13:56:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261103175632.GP274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <yq5a4idx6fma.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a4idx6fma.fsf@kernel.org>
X-ClientProxiedBy: YT1PR01CA0097.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::6) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e776e57-d4d9-48c8-3bb7-08df39d3cc25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|261028144727099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261026121527099003|261026140227099003|4143699003|11063799006|5023799004|10067099003|56012099006|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	x0vNtzgzKrQ75SEqprsxZhP1DEif84tejFOD4clfxRn2FLjfQmr7gWlGf2dI6gCN2r1LZKW3inRjAyCzdznCiatSeYb87s5bjgfru1LO+6EN//41HpKvFlWFYhOCO6k490uMb8KhTqHIDuiiuN+bQD51MUJ+eQFjqIw3ECjM8YsYS9wgcqwqvAJMHuycuu+Yc8Bd8GsrmD/0PjICFokHzgRjQSTu8sO+hl9FmmqJDlSNNzviHuQ/8mDBC9A7CZ9qCaqfEpg/VRoC/OqYLxNrk3QM0NaE5ysvqvpmNkVD70uRT3hCAYXs7xF7YIJ4U/Kkhe7ZSupxy7A6PZ5GzgEJBTVZbkTpNXGeFthW/5L3foAie1sCodHA1rvqPECLqeffowUEX82Y9TmaOGe5jANoGXoFqlejRqljvsRyeTtvFmBiUtGfOxK/XVEcrvpt+iMQ2k3gLBztiJkskPq8IVeW+vzVifl+VFHb5iXsf6Pz91ZEOvq/V6zPh0Un56P+Ru8uIzy5sjWX4O2WsmhKzpIXpItLZUyRwIIg/B6T5qJ5WcwDqrEitGDVW/t2zPNPiGle25g2R5lDCqXJpsxdWNmomswboi8YvVlRNYjuY7Yeluwvdy2Qx8YG8SlQ+9FMGZ20caJW9dUJMf7OpKsfLZIQ48hI+NYVc3GGQ1tXeKNjFG0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(261028144727099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026121527099003)(261026140227099003)(4143699003)(11063799006)(5023799004)(10067099003)(56012099006)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kEfgZBxnCpunkYeOAah4BkzxsUYca+ZVaU7r9fUisViVra+3LzrIDKXYofiP?=
 =?us-ascii?Q?xMqQ0sEvMXfsufq8o5nbIjFZvrUFGB75lWUPMM4Z7CFOoSHuysI/jwfOdUxs?=
 =?us-ascii?Q?4H7Gy+MxXCVTyQ3FvQLxfSARi/GgA87ZS+CB/5bsjN8PyJXV7ofvIfNZ1V6b?=
 =?us-ascii?Q?n6ggk6hFG6Zt6k33VUzgVhS6RUVDHoY1Rvll+HoifBz2eJGHw+gOaQf0XvUi?=
 =?us-ascii?Q?Mt7Qnk5ni6qaDSBwkK8jT74MlEtXx2zUuIvzVrgzkezR7r024inV/lVePjv9?=
 =?us-ascii?Q?7TTrlkMoLEJ5vw3teD5OrX5kEvfK+LdEaDYMez7ivrz0bpf0zVny9d5S+LFL?=
 =?us-ascii?Q?+zKIkj/OMmzWA18YKsgG2P0dPXWwhldaO3iYkbV0MZM61AKfdFK8websD4k6?=
 =?us-ascii?Q?tYLgwK7kxSlHbEr0HsV/j/hrb/Bdd9CkvKlE106sDvvZ0fwPOPB/iFVG5RKM?=
 =?us-ascii?Q?ps3T7A+JyCsDWGzhfn9Lk3nS9amQkcyGMAapygh8gC4qJ6EeThSqR8oWjJTC?=
 =?us-ascii?Q?uZS3/IipkVmL+JoH+oYbL1ALl6Ou0J0/bwk6ibutMUmT7AbjFDtinFNtwMDj?=
 =?us-ascii?Q?xYqMAUGYYF9cOuOrHmsj74hj0K5hgkTlmBwvlm6FgjwtlyeN6OFKcUfHiC5X?=
 =?us-ascii?Q?gCJs7flqveiTi8KA09te6XIDhQfIRg9/hh/n3GWHXmIRYkee/yigUBVqy9ix?=
 =?us-ascii?Q?Q8GzV2NHj2ugdsaGLyvF1x3oxdnrXHbRMtOH+e5aiAL1aSijW/Qqd9sXi8Kx?=
 =?us-ascii?Q?BoLfrh50Y9gdCPKa1NoxCto0zZIUflzJnuF8kxHIwpsyMN4hxVIXE5wNsY5C?=
 =?us-ascii?Q?ccGydlBlkaZjUY9wtd6iM8UrrPRX4k7eIakO8NpOoyw8wzdeTe2aArxv9dto?=
 =?us-ascii?Q?5X1s6biYVAtVmDTyfkM7dXtZn7H7NCHclh/VwnJwWKXPevjOXanxV2A5wivQ?=
 =?us-ascii?Q?4t9UzYjNRDkWnyqBs7J3knTrXQUN+bpiEyUYGcaX2GZkaOV84oGS7/QsIo0P?=
 =?us-ascii?Q?Ik/mz8kiRYdWKlkpdAj6uXLuB6Id1OKir95jTYWiJRWto4WIB7Ouo6OWyk84?=
 =?us-ascii?Q?djWfyg1e27rxPijEoADctu11E5LlqjnRAAq72onIy9p/i/w4ApdLGW2En2xq?=
 =?us-ascii?Q?G1wu8c/6fs6CxleWZhdvdYoMWCijCeIVqGT2vLUQOrOwYvH1X+r1jsoicHf3?=
 =?us-ascii?Q?+B4oLbVK9mRM2VgkN5XTCh8MGx16G8UZZynn1Jd08B3Ev/bDVThkzqZrSp0m?=
 =?us-ascii?Q?/X4o20vd4/9geRF1Iqmtirv7XTBHg323W3fl0HQBqJDopq5JUqnz9g5kh/GF?=
 =?us-ascii?Q?eo+Plpnw25TO5nvsi6SZY7qbJDQueKTxF3F1Uch6W6uwtyCCl38CBEsaFRbF?=
 =?us-ascii?Q?EZKYycWa7gsK+l0WFPfcuxPVx11oi+UvbOP8jlBR/FCnZyoT2iLXNjsdt9ul?=
 =?us-ascii?Q?YiMflJKS815eX4h2LhXw3a38AoCMih9CdrOXB1+RdgdU4EC81+ex2MZTpRU9?=
 =?us-ascii?Q?uxmI5edm5Z7ghUy3wmIc4dlDO4slujIH7HsE5+uq66vmMigRNdLaqqKMRgIA?=
 =?us-ascii?Q?IcveCcKrJr/PGkCG1uKt0ho0gcNuq4mvuvY8Tu+Bjgp6uw+xdRPahXaac8ng?=
 =?us-ascii?Q?dA64MAL+Y9tPAM1xj3HzJUpdrTSDLUmuORyECHUgsu2RReC+88sOzqmJFs0g?=
 =?us-ascii?Q?cS2tRxpb/A8DXMqeZnlZXcOvaoD8qbbZh3MGm/SdrrN2X7TM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e776e57-d4d9-48c8-3bb7-08df39d3cc25
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:56:34.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZmHMs0PeU5pYPR5nHF6jllSz7v2FRUajz4fa4Jg/kaLUnJ+kXQ8UbHaO02KyUXd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681

On Tue, Nov 03, 2026 at 10:01:41PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Mon, Nov 02, 2026 at 10:11:44AM +0000, Reshetova, Elena wrote:
> >> > > AI tells me there are a couple of reasonable ways to implement slot
> >> > > selection and avoid downgrade attacks:
> >> > >
> >> > > 1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=true
> >> > >    1) Do via RustSPDM:
> >> > >         GET_DIGESTS / DIGESTS
> >> > >         GET_CERTIFICATE / CERTIFICATE
> >> > >    2) Userspace selects slots
> >> > >    3) TSM module does startup and also issues 'GET_DIGESTS' as part of
> >> > >       the signed transcript
> >> > >    4) Confirm that the digests from #1 match the digests from #2 in
> >> > >       the TSM transcript.
> >> > >
> >> > 
> >> > I am currently doing something similar to the above.
> >> > 
> >> > https://git.gitlab.arm.com/linux-arm/linux-cca/-
> >> > /commit/0657d167aee1ba43dd2765d99b5e3244b83c6ea6
> >> 
> >> If I understand this correctly, this is not quite the option 1 that
> >> Jason proposed above. You dont use GET_DIGESTS and I dont see
> >> a binding between cert chain discovered prior to TSM SPDM
> >> session and the one during the TSM SPDM session. 
> >> Or am I misunderstanding it? 
> >
> > Right..
> >
> > I have poked at this alot more and it seems a bit different than I
> > originally was told, especially if we narrow it to RMM only.
> >
> 
> Wouldn't comparing the selected certificate chains, together with
> successful RMM session establishment, be sufficient to bind the selected
> chain?

Only one chain can be checked that way, the chain that was hashed into
KEY_EXCHANGE.

The point is to avoid downgrade attacks where you are selecting chains
but the "best" chain was hidden by an attacker so you use something
weaker.

This is less important for 1.2 since there is only one private key,
but it is essential for 1.3 with multi-key and crypto agility that we
don't allow an attacker to hide a slot from the negotiation. Eg to
hide the strong crypto slot option or something.

> The certificate chain comparison alone does not prove possession of the
> private key, but the subsequent key exchange should provide that proof
> right? 

Yes, there is only one private key in SPDM 1.2 and the initial
KEY_EXCHANGE proves the remote possess it.

Read the later email to Elena first, it is better.

Jason

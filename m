Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794598502;
	b=mDK15ZLlbLjmfN4JJBUFKAAUikpKeOPrnMteSVganoV5f96VvsfQWbEqBODCaEmh+Uxt
	 BJcEq4/eJkKAkhubYMcFJQdR9OfuBMM2I+0p8EOgwVbFU4QKfbMsPnZZXJk6mfWVG7ras
	 ynafeEU47YmkiUy5kTS+dw6GCNClVkmBoqXSP/6+44hsTBiJWXiqXhGU8cNgD26OrbsDn
	 jKR3SyB/yToyLgiwhhYXxIui2tNZmhzpH43rNeysk8z2pb9Nkx4LVHS1GDtDpMLC5ywDh
	 CCd4J5hxcivhYvP9FsuZfG3TsfRkGLUO6zqiBXJ0plOER42S+cehTNIJ+LF6v5rGfdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598502;
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
	bh=C7pr7JW6SzJ6PtRpY7OPilcAlIJ5Rq6klJj1l3CGAxw=;
	b=EAd7/TJAVD3setDwp2SKaM9NF7Vx/ccajp4auv2vjhdx/rZg7GCn03RQx4EyM6ZnQYG6
	 /H3mxuaNwRExYEsayvTJL5ZiRwCwNjQFo3aSE/OWa/6ykh6IhtQLN5eRQmbSMqpj2SXq/
	 0pTMekAsUMrBtGeGnShj1LF66LVx/ZCkFBbq2eqWAuo6Fxvai+ULPffzRashIL16balYn
	 nROEHbM1fil23YfasPpBoauUDPobwW1M7IXl9Zok9Esjds7jjICCfYRC/cSdNc3WGIjZK
	 aauE/uFtwS7pJ1NZBykmnuHM81f76txXvpkFCFfPEF1Ark/cKNr9/YIEYMaWeddi7Hw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dn5ie4RF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.56
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C09606A323;
	Fri, 13 Nov 2026 19:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92C09606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Dn5ie4RF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBufuDGgdCr8tNqyr0kWyzp7kUsQDufUR61u3dE73jeweaZyAqwB4RkgBDRnlGg18Sa1j04K0b0HpBwsWuyasqRdbJB5Rgjt5MWb/84Him/A2jfixFTgieQTdDMpQfXkzVmwEA4rA/+vxT1J+30lVj79LKWKFU4+FT2hytxrQudqNYSt8HGgZ0XhqK7FygDYf6Ypye1aAHI7kE0P4yiddnsVB8Em5CxIHIoYoXUuenfBF3wnAPo5OR8g+WBoNQiOT3QteP/d8mfaK3jOmg90FHsDGqcg8bCrgJo8XooC4M3cu/FAA4OD4tXMJm1MO1YLDMzQc4zKuPAddBoLDaNh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7pr7JW6SzJ6PtRpY7OPilcAlIJ5Rq6klJj1l3CGAxw=;
 b=YL9feHOLqw97injU+u7nezrEn9huzBLm6+3xkgsH4iKuNOsg3kmf32k3/MIyCvxC1sPqTJ/VQkEhIjVlQqGqC1qwCwUTY3cV9PyakjBoeX0QN8BQ8+D1Zl429Fd0a3OYVTUElTTKniwlR+nu1e8gDCShXrfCud0ySmQGESsfUD2h+UpELhVlgF7SgbwCGddYA+hiqrz3j+kooVKT1aaPSsHEdhNpmhfVuAmIom133KLvOWd5vDEuBwXRP8MGLJd7FZ06y9s4k9ACELrPD9Wmd9ZMDBvIYsQ9z8xwtr1f0439wAbmkH7XnqERvEaPXtdO+66fbpOPB3/GHd/SUAtFog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7pr7JW6SzJ6PtRpY7OPilcAlIJ5Rq6klJj1l3CGAxw=;
 b=Dn5ie4RFdw45es+V9HXTSLwbc90Fy6VT81ykf3ApT3uxK+ESqWilpfhLM/iHgoZgCtuDWdDJu6GgFHrdqqDUdkyNSnB4SZeIK0VQTQRnxKqPwChjcHjNLUc2/NLDo9IPAPGbi2HWLHGOJ6joRduLRf+169XpLDlC0LR1xkT3vVxgkJeOMPS7jgb9VKEUBZphYXdlz9av5mPek1oZb67IIQdoDQTLPZ+Sv95noQGC2mNLdA+AqvydxXW/nOCbBqdfW3qqicdV3K51JFlxPJeZsoY6JCah6jXhpJIPjwInbJIiLeAks+KG0npfNiyJlScjgFxpi+5oTGLnhV5cGkgAJg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY5PR12MB6180.namprd12.prod.outlook.com
 (2603:10b6:930:23::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 19:34:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 19:34:52 +0000
Date: Fri, 13 Nov 2026 15:34:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261113193450.GD3706007@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <yq5abj7tm7q4.fsf@kernel.org>
 <20261113145249.GA3706007@nvidia.com>
 <yq5a33t4mza1.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a33t4mza1.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0337.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b8556e5-0517-49c7-d7c5-08df41bd2fe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|6133799003|4143699003|261022105027099003|11063799006|261022075727099003|261028144727099003|261021121427099003|261102123227099003|56012099006|261009223027099003|261022113327099003|261026121527099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YTtqUj2aQX4HQbQPuVEOpjXtG8o8KvTTobY/DOR2+0puHSgfxA/VMN0y1FKqDmUXUf+W+jf2pBH+hIsqVUJWO3gZqvieEmNyskloBAmSQJNFFhu0LT/+UpZydewhx+24Qa6FzpPgQZSeVJhEc0JuUaA32kC99BgFuZHnyANTJ4SyOL6unB59xT+IDPe2syIMWFy7ykMnp8a+9aDEgT083+uQ+Lt0OPYgM2NW7iXaEEoPd5DA9Agz91+awbCl0BhgfJj6SQEKkLps2c6+FgH8odqmtybsNsGcaKXlq0NaBVtdMb38yoqY/jNpfBtfdeGqtnpelAy43rQNCZ3WvTxz6NYmARpgPtLZ70osr3FYzr0qq6Yr3TnH069oNSwX2z62GPTvX8MDO3IcGj3GhUSvzX2zERxnNk1YiEsltuvnVCf7NaKgusdA8rkMci6PeYZ9spvpUMzrx+AJfevB7vOgVPRh8Qv46tMO8D9KvQ8UxeT5Kzu7d9tOqQLU0r1uUQcTiNH779iuJfmdjSuVz/3/+oUEMUbhgJ71ujiDysNbhqvhD1dx6pDeUtDJUMJFbwQ3gWxeKeCP1vl3xdJFm5ZV6tsy67EMTumSfl7t2GjBmfixOBCqtgT6/Kbv61EsDltMl7W79yfzf7BsrR+NP0KCaLlD77u3LBrBkiyphNvC/G4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(6133799003)(4143699003)(261022105027099003)(11063799006)(261022075727099003)(261028144727099003)(261021121427099003)(261102123227099003)(56012099006)(261009223027099003)(261022113327099003)(261026121527099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qe5D57eH8oRnHdtjcaQgw8absLGImxicPk8N0bqC/G6dzjvQWpL1n0fMJQ68?=
 =?us-ascii?Q?AJhmzHW+frKkC0BtUbXwLtID/MZbUbnvEW7TmWImZ79+zQFTy1dRPEm9zN7F?=
 =?us-ascii?Q?XSoHWMPHmqrIiKIhTq+Qk5DYhU+2VBwPxEqkfOQqLFvbVciqwiHm/b9Ggf7r?=
 =?us-ascii?Q?vNs+tdqzfZgiOxFGW9oXxNoVON/D/TZOGV6S5zaMDQqeZLx26yEQjyjH9Xko?=
 =?us-ascii?Q?mg1sKXR3PbuFs+irLKGLzzbeh629rjqVYHA7G7JX0tkSiKX4PHd+Ih/x+xH4?=
 =?us-ascii?Q?IJ6NSfnsGU52IPIlWFhamPfQ8QbyUnj3dsYH4SMsrxYGRg9pM6OAyvLJ7lot?=
 =?us-ascii?Q?78NODWm1B0FfN24/XyvL8kdrfM9ZXSOSD1TU8dDtlLsmmWkaYLGkdn7xT0RM?=
 =?us-ascii?Q?KXL40Cmuy6IGfDLTRYiZXyrJHrT3+t37yPXZyuykZZErqPfm1DuYZ+NdsgNu?=
 =?us-ascii?Q?JTRvy73FR6mVfI4uKnLWNN78hYQsEUFaikvV1WyUBeUTnfNd+FcNAx4Varc9?=
 =?us-ascii?Q?FfhKtnqNPOVSvKWhhbDRiwLGkbYL8z1o/1/WrefLaib1jfZ+SOGrrT5g1wGO?=
 =?us-ascii?Q?4pc+Q5eZOw/6CbIMoc0n0P74dXg/IyFVVqGVRidRkcb73qZZ+SlaiQcsiAaf?=
 =?us-ascii?Q?DB0KWQ6d3/5FWe3RREz4Cr/BvTILVpJ0Z9hQXtARHIRUAs6SNFZucVWTwnOo?=
 =?us-ascii?Q?AUSAs8qJfWCdkXtKPYFbeLCy+2jRIWjkd/HaCGMW5yCblPSn8QIpbtei9DBc?=
 =?us-ascii?Q?zOp90LvVhuxZGBYMeYy16RIhLMIIdtJh8Jst+cuA4Pc4O6HXf3BTyZIYeqh5?=
 =?us-ascii?Q?biw6BJ5/i5ahgyChilP5TOgnWllNlekdekOrNtXcoAIEEWPRjpKLBf0DyNoL?=
 =?us-ascii?Q?QF9LdA2Aldu4a2V7luS/w7kQuN7m0gFPv6SmJnAvhppCneVwAqRK1K0U1bHV?=
 =?us-ascii?Q?c21YQCKh3HwinBZnTOmeqBi6txrtGcebn9ZOPJrm8omJBXwDlPD25D7E2G3u?=
 =?us-ascii?Q?N4s8L6PchgVd9PQQ3WiXyMtDmsMXh76q8An/BVgtN2SaAOVY6/tjsD45JdNU?=
 =?us-ascii?Q?60GwypKNO8madbXjwQCvHKaVf2r2Mr12dYynA/C9tRGV55Y0851MeKu2Um00?=
 =?us-ascii?Q?cSyZPDFdc49JwrpuXYiAKCLnyk8avPooSDUCmwOmj+fDm85Vj6vKBojvaDBx?=
 =?us-ascii?Q?7WKcJbH7MDvhTj0rQAewp9XB8ryvyDl1EaS0U3rDRoPebOaEbY6HsbBGYycC?=
 =?us-ascii?Q?bNc2jS2oc6yIDBBphdq5ulYK4NjCry+f6UTVeaGx332XKiHB6rW0wFHXcW5p?=
 =?us-ascii?Q?rfBu+YthKcFtMg5CFG1a2Bk4yWa1uJr3vvwU2TnZcUgcRtjTG0vGAsMiMFdD?=
 =?us-ascii?Q?QbQYvtHddIfI2gPldlePrShs7fOwaDXiTOewALPHuKb0raquw69Ppksh/fhS?=
 =?us-ascii?Q?wnr+Ct6fT1u450jrF/hbduAyF5p+xZ0J0PSj86paXZAw5sxe0SVIU0DM3xe4?=
 =?us-ascii?Q?Hr+Adpv0rO+M0OvOVZkAehuzQvHo3B0no/26q9Eam5vNuHoPU4UFATbWLEXZ?=
 =?us-ascii?Q?od1lnLdf0eLQ/TfWogRMo+UJEFoV0I/aUp3Jlk7IkHa5LywJYafdU6gpeMPv?=
 =?us-ascii?Q?ixFUCUMZnr4m2KrVFO0y9G5Kr7BxLhszSEv1S8bkAG6oTK6DVmdlJ9Y2F4u4?=
 =?us-ascii?Q?cHcuJf9+/qlrbKfhZnyOykszT62VCa/0DTZpUoa9AlhyJe1d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8556e5-0517-49c7-d7c5-08df41bd2fe9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:34:51.9666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDRsMm9DqPTcHtWx7zTmUFOXsQj7NbFz0oeJ5ZqrXqS82/RmoBUThZbau/M7hQTc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180

On Fri, Nov 13, 2026 at 10:42:06PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Fri, Nov 13, 2026 at 02:24:59PM +0530, Aneesh Kumar K.V wrote:
> >> Jason Gunthorpe <jgg@nvidia.com> writes:
> >> 
> >> > On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
> 
>  [ ... 96 lines skipped ... ] 
> 
> > We really want the certificates to be loaded at the start before doing
> > key_exchange. That is when they are most useful.
> >
> > So when we fix this for 1.3 the opt in should trigger a transcript'd
> > GET_DIGEST in plain text and certificate collection from all the slots
> > in plain text.
> >
> > 1.3 will sign GET_DIGESTS during KEY_EXCHANGE
> > 1.2 RMM could issue CHALLENGE if the device supports it right before
> >     KEY_EXCHANGE and transcript it
> > 1.2 RMM could issue GET_DIGESTS inside the session and fail if != to
> >     the plaintext
> >
> 
> 
> So the combined flow would be:
> 
> Host                             RMM                              Device
> |                                 |                                  |
> | RMI_PDEV_CREATE(new-flow opt-in)|                                  |
> |-------------------------------->|                                  |
> |                                 | GET_VERSION / VERSION            |
> |                                 | GET_CAPABILITIES / CAPABILITIES  |
> |                                 | NEGOTIATE_ALGORITHMS / ALGORITHMS|
> |                                 |<-------------------------------->|
> | Cache individual VCA messages   |                                  |
> |<--------------------------------|                                  |
> |                                 |                                  |
> |                                 | GET_DIGESTS / DIGESTS [plaintext]|
> |                                 |<-------------------------------->|
> | Cache discovery transcript      | Retain original slot mask        |
> |<--------------------------------| and per-slot chain digests       |
> |                                 |                                  |
> |                                 | For each populated slot:         |
> |                                 | GET_CERTIFICATE / CERTIFICATE    |
> |                                 |<-------------------------------->|
> | Cache complete chains by slot   |                                  |
> |<--------------------------------|                                  |
> |                                 |
> |

This should be identical to your prior email where the host requests
each certificate. But yes.

> |                      Pause: PDEV_NEEDS_KEY                         |
> |                                 |                                  |
> | Validate candidate certificate  |                                  |
> | paths against userspace policy. |                                  |
> | Select slot S and extract key S.|                                  |
> | Discovery remains provisional.  |                                  |
> |                                 |                                  |
> | RMI_PDEV_SET_PUBKEY             |                                  |
> | (slot S, key S, chain hash S)   |                                  |
> |-------------------------------->|                                  |
> |                                 |                                  |
> |                    IF SPDM 1.2 AND CHALLENGE supported             |
> |                                 |                                  |
> |                                 | CHALLENGE(slot S, fresh nonce)   |
> |                                 |--------------------------------->|
> |                                 | CHALLENGE_AUTH                   |
> |                                 |<---------------------------------|
> |                                 | Verify signature using key S.    |
> |                                 | Authenticates earlier DIGESTS.   |
> | Cache challenge transcript      |                                  |
> |<--------------------------------|                                  |
> |                                 |                                  |
> |                    END IF                                          |
> |                                 |                                  |
> |                                 | KEY_EXCHANGE(slot S)             |
> |                                 |--------------------------------->|
> |                                 | KEY_EXCHANGE_RSP                 |
> |                                 |<---------------------------------|
> |                                 | Verify signature using key S.    |
> |                                 |                                  |
> |                    IF SPDM 1.3 multikey negotiated                 |
> |                                 |                                  |
> |                                 | Signature covers earlier DIGESTS.|
> |                                 | Authenticate retained inventory. |
> |                                 |                                  |
> |                    END IF                                          |
> |                                 |                                  |
> | Cache key-exchange transcript   |                                  |
> |<--------------------------------|                                  |
> |                                 | FINISH / FINISH_RSP              |
> |                                 |<-------------------------------->|
> |                                 | Session established.             |
> |                                 |                                  |
> |                    IF SPDM 1.2 AND CHALLENGE unavailable           |
> |                                 |                                  |
> |                                 | GET_DIGESTS / DIGESTS [secure]   |
> | Relay ciphertext                |<-------------------------------->|
> |                                 | Compare authenticated slot mask  |
> |                                 | and every digest with original   |
> |                                 | plaintext discovery.             |
> |                                 |                                  |
> |                                 | Mismatch: fail setup.            |
> |                                 | Match: authenticate inventory.   |
> |                                 |                                  |
> |                    END IF
> |

Yeah, I think this is probably the best we can do. You always end up
with some kind of authenticated GET_DIGESTS recorded to the
transcript. Authentication is either directly in the transcript with a
CHALLENGE/KEY_EXCHANGE signature or indirectly via the symmetric
session.

I would incorporate this into the 1.3 ecn upgrade as the 'now this is
how 1.2 works if you turn this on'.

But I don't see an urgency to stop the world, we should implement as
spec'd. All three arches are similar and have the same issues with 1.3
multikey.

Hopefully these flow diagrams help the other vendors to understand
what the ideal flow would look like. The ARM TSM directed "caching" is
very smart, IMHO.

Jason

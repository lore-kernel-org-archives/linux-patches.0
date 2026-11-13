Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794598011;
	b=wRA4vG4vp1PdiqGQ/6yAQWQOyIgbJ2lKFsnMBse0Tz5/gy6t4I2WRZ7KZvyNfDAmjDXm
	 Fg5aj+aZ0E8QDjb7lWucQQ6remYz/sXYm6lUnkYnFbnSMhsJLI3jBP/Y0rHNPW05+7sQ8
	 E4nBTLhpzBD5mIETB1so48RCogN/cJGSk+gonlhFatYon3OCVErzOCR1Cy3ae9VffcjPj
	 hXN9xUicUpE3ytDc60GTpZQPqY0JIBKJmLENGyMUxMwUkRSjmh6pKpBI785NUtwZb2fDD
	 EgbDnX1l8wq4uLu2sCKy8QMA07lhK8fTEqFJ97jz1693EiBzV0Rdf4bcSR+KDxI+Dzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598011;
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
	bh=dEkbUhG3TMM0JAp/iRIpBkypoIKQGWTdAyUC2Syoi/Y=;
	b=VUbiKWuomeUgrygXDUPy6lJuWWnMHvO9Od+tPU7svvNVfimf2Y27tbhChULuK2ZVZdsG
	 e1YKB7noPepM/eIhwwQtJ5pVn6+Jovbd4kz+XL+FdYkWjvKy5GgSHaKYVHjKLKM35KoCp
	 cUhNU2fneg/ubB39Z+c2Rsowy+7+1sk19PVdYJ1vSccnGthodNUyrqySB1tY3t0D7+B72
	 pLEhYO0fEC5hggdT9CRYdcUStFUCZA5K97VmsSyVLEQqD0jdDICIRtG48Prcr6HlRj735
	 /OLcgX/a6jaCsr4f+hXftyYRdGpxSBq/Dx6XquCfYVQz/9fPitwHufCYWiBbyVU5Zhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B73yGcwZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.1
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2147A606A88A;
	Fri, 13 Nov 2026 19:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2147A606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B73yGcwZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHpMNVjVLBSYWi/LoTh9myx/DkLbUtEXRFxwcDQ9oh4E4EaDP10IRxQa66bJ7qOPuxR9GlPpRMd5yGZlVhG56Y26nWj6rf/Oew7Mq/AJcpOyTqZ9BBR7srzT8LuRS8NbOYu8c+QVTTs0ZnDEcpeGrnb0OyE7z6zYyAEArAdGn4B7wV5dS0/TjkxQYj6gwahKfGNMH2rfH51lL0WieT2bJhuj1uyOg/zrZokHcnleKcw6sceIiVx0wPhbeLwEcSV6r6w8JwrWxyuu6Dl5SbP99K880s2VOPlQdzrh92m464g7JJ0e/UU3kccfs4uCkFSRLysjHrfcElhAao8R0MtTXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEkbUhG3TMM0JAp/iRIpBkypoIKQGWTdAyUC2Syoi/Y=;
 b=pwWfbN13voQorBAgdRDTIxuoc4DoUVglQsprbEmGjQgh9hRbdhUDsIU2BFsBqNpGvmaRELeh5OLhS+L5P9yigtPBbfO4TZOhEiUQLB35MjiM3mRP2OrPY/nvbypJ000/L70OudvsBT3vg6G/hCDOr5KJWKeaBaY+tO9pggtoxNfzYv8y1s8UBd+I68gWKF0JGBmi9Vg8Su7+NMTeWyO1LPW0iGpC8g+9cWKagqeOd2oTs/YmrUYL/6hwmARseIkfpm8kTfrLBWzMBmKDs3I4PcOo8JPzQR6PKK59WEP6Ow4LEvv8R31hR9OWZQv6Jj1fcNmOSEBPvJh3wuiB4rD8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEkbUhG3TMM0JAp/iRIpBkypoIKQGWTdAyUC2Syoi/Y=;
 b=B73yGcwZBnYwwWlwnWCH4A2RtjGZX3uNs4dbqQibCrWGx24rcE6ABwZ5OYQUy07p5FL6I2GYqt7UM2NgqzLrd9ReDGwd/tHfXpsAze+lwrRaHTykBeH/kFKuC03x2bogTsimr75dmd8E8RLR3foRSPwfwpgDzWMM3arsokoTK5ew93NALNkdJTG7QzrGiT48hS49ONeyriJ9HN9+3ozmRsxnNyaTJEXZ4NOwFdlCW+XgXQOB1wjJAR1BVY+YmVPwOEErthPBRojVWWByN1sBQSDxGQL08oixgAv1zCfsRiWp5SiXvj/4Q1ZBad7SAIx1crF7X6DsRb+qKYwu2STz6Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6441.namprd12.prod.outlook.com
 (2603:10b6:510:1fb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 19:06:46 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 19:06:46 +0000
Date: Fri, 13 Nov 2026 15:06:45 -0400
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
Message-ID: <20261113190645.GB3706007@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <yq5abj7tm7q4.fsf@kernel.org>
 <20261113145249.GA3706007@nvidia.com>
 <yq5a8q2wn18b.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a8q2wn18b.fsf@kernel.org>
X-ClientProxiedBy: YT4PR01CA0183.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3d2237-236f-4a59-486d-08df41b94342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|261009223027099003|10067099003|261026140227099003|11063799006|4143699003|261021121427099003|56012099006|261021130227099003|261021135927099003|261021123027099003|261022113327099003|261022115727099003|261022105027099003|261022075727099003|261102123227099003|261026130827099003|261028144727099003|261026121527099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 BXRVa9vv+2L099ezcNk1LfkN2SMf6eZcrbwCMN/aUlTK8rXMr4gItmCbIeO4CK0NLoahxUeTBDD+314aQwnxrRDTb9MvdXP4I8rFU4qqKOOIL0sK0Wd/+Xa4Y00n3ybDIriFuc0aijTXbjW1gCmGgDjRM9P2f6LbtCZJ7stAxOOA5AL6cBfh5/CLdb4SG3hqWlD4+MEBZKVhGzas2ZwRjdxy1+a9TBqAIz0DFNr3JoEeyCDSikROR6HJBN41dJpsplyqUiyuCte3Fw5BcgKg5IFJK+XxKikWcBHv0GlXB9GT8h6jaUAeIWhRkt0XGMrr78LvQKfDsL+Mvr+yRiVb8vkO9zhKvu+ZfbvsE7mYFHoB6mFJPxoW5G4+A1nn6T/+lxvnc8YngnMD5werUe3aICN30CoFhdFl/tbbd5E0SylYcgDJ3FsHuhxsNM6Vl2Pvf74CmZSQWbkCcmLaiKL9x7v+aQCTeA2XZY+u4UCRTcfQwIyLFlZwWfKo01IUVPr7HBq0yujJqpjeNmT06O0+udOlymrZKJTKFyL8FXQRxW8nT9dfYkK+VCKiHG9lQle+fyUpjOnQX3EdEYX1UdYFg6PsDt8UlMWK8dHgt6fUmM6xejfODDUGRZZnIDrjT/rv10Y8LkWo2K64ojAmbSPNUlBeGHE1tOmjCcTy6COEWGA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(261009223027099003)(10067099003)(261026140227099003)(11063799006)(4143699003)(261021121427099003)(56012099006)(261021130227099003)(261021135927099003)(261021123027099003)(261022113327099003)(261022115727099003)(261022105027099003)(261022075727099003)(261102123227099003)(261026130827099003)(261028144727099003)(261026121527099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?YRhKUc+OH3WO2BvO3zuQcSlYkHdolywdR02EnXt33x2th+f5IePOyN2+br5W?=
 =?us-ascii?Q?/AcgRHLstJGutjWF59zpMGEgV1kKPAltILXbranu/OHbQZZdlZBuobBQJaYU?=
 =?us-ascii?Q?Y2dDfEmPEyPBD6sp1fnTBBy+Zx0Ts8ajM4MNuyAWKqGcsWJ16obwN/zkgTyX?=
 =?us-ascii?Q?GNWOlujIBsPU7abzhURV9ezcuv2VAeYuk0yU5nNNNKBzPPmMSS0sUs0ncIwT?=
 =?us-ascii?Q?oqmKqsNHSu8UcO0RBkVBopDOLL4fqbCwfoYoToGl4Sg4yBnGXjQYUuRUc4C7?=
 =?us-ascii?Q?CcdwWBAt0hwtwIZSBzzi9NwHYHacPDnAjODEH5z1egkLylmXZDY1me62uWZw?=
 =?us-ascii?Q?guH9fdl1+/nuzQUiCXdW3AO/LOEvxCcQ5tVprI+0mlThMPbuJTSJZXxMOSqg?=
 =?us-ascii?Q?63H5NfcX+TbFlzxc0LHOUavWn7jcWg/5xeA3KOcEQmRDwUAwtTJ9fPZ76iID?=
 =?us-ascii?Q?d1/yUMYbqEvYemyjtYwBQmf8jW46+0DJ0JPwXaJSo7RIZPogciLgLxXZuiQH?=
 =?us-ascii?Q?DI41YZ/gBSTECEEZL0ndLwYbJdhTJOPRy7oQJbsVJHd1C6a/n+TLprOevPzr?=
 =?us-ascii?Q?eCMRWOiPkZ5/4AGt4JX/CsfmP7DbrDcMDDKdVRysaNex+8mq1JblGXuabCMs?=
 =?us-ascii?Q?AN2grB73+8TMcPgpBi6jNmdeLntWQYG45zpkrbiU/ZMA4IZO2CJ7mbO/AB80?=
 =?us-ascii?Q?YIwjh39nBP1YaIreKAr7t/7CTaL+jUuwIqS0WT1WwvNzHL0doxcjdeixlF45?=
 =?us-ascii?Q?FSaJNUpg0CdpxbahbN/gx6TbossjN4+M2J1z+Vc8s2p1xWW+rcdZViNX/KQ4?=
 =?us-ascii?Q?2SGx6bhDqYsDDDa/meJ3d4qLp/5NT3Zhv+kzg2nnSW4ihVlhqKA9hJBimTKG?=
 =?us-ascii?Q?0ejH3Sz4FUpRjs7VkPJ+4dWkzZzjpUIupeLI12sqfHqMYLbIfzXgqECDlqWG?=
 =?us-ascii?Q?qWmg37vSivPWzSS7i/mxK7BBonu0cKLeOC7fsV5gXN7vzdoND5MEfT5tYWdk?=
 =?us-ascii?Q?jp7XmnxxbFc5ktOD4i2GtE0for9t2p8wU7l26kb9olC/AdcYJr6jXKLKIgUw?=
 =?us-ascii?Q?0aodARVncgCum6j1qJTGVc0JKpYBo3x9fjZGOfhr2eTtVsxAdoXGKwxoCyvu?=
 =?us-ascii?Q?xLloKkow1NveVeh/gxqOwAixZCURhJJfF4bTfI9/0VRvdyXOrDWIkMgfqbh9?=
 =?us-ascii?Q?3eLEl7iwyCmRxHqzfbfyj1o3picZdDCYbSwSRWgqZt2BUpRXlq8349/OlPlZ?=
 =?us-ascii?Q?mI/XT8TCEH++PYFncg5sER08TtV6FBo3RCCTKGUvjPooSIfZ8cG78C+5BBWF?=
 =?us-ascii?Q?wO8M9APJv7SRX01HEqnZqnx/D4nhljowUFL/cG9ZrkhiMR+bsBYMi6fS3HSa?=
 =?us-ascii?Q?MmNZhXYlJFjrGZYmXUYSuiWTyVyjs6OmHCtwMhS2PyKORUugG5f7xHkGoFFO?=
 =?us-ascii?Q?VpfC871Ukdz37fsV/PpT2PwnsHjYUUOBMJg7GAFjtZzaWkcd03iwXfoWl3ip?=
 =?us-ascii?Q?x4C5iBEMKQ4tuvQkP5y781+kYyA0ngS1ocxN0ejPhkamZK8WNu7Wx1Zef+0/?=
 =?us-ascii?Q?ByV3qJ91y9Y6mHOOvCGdcickuXZyKiB4w4c7BjHMXvhHL7O2+hM1wTZn+paE?=
 =?us-ascii?Q?It6XPLqFcjBpkpxMwN5wOKZDhWDjnl4yodQvu6AQoq7LG980A1koGmrMk8Zx?=
 =?us-ascii?Q?R/l6/439AyqPWU1u98jka1X9fHB4Fs2a0LqfzkDzMwmvbmCS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3d2237-236f-4a59-486d-08df41b94342
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:06:46.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZVi7rJKIud9lKm8hYWyIOohgoF93MelF5Qw9X9JOHQMh+eVcZ5bXmKgvKLsCiiI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441

On Fri, Nov 13, 2026 at 09:59:56PM +0530, Aneesh Kumar K.V wrote:

> >> BTW, this proposal does require RMM changes. I have also omitted SPDM
> >> 1.3 multi-key support from this diagram because it will be easier to
> >> follow once the SPDM 1.2 flow is clear.
> >
> > IMHO, leave everything alone as is today. We can make it work well
> > enough as is.
> 
> Could you describe the flow you have in mind? Would we restrict
> everything to slot 0, without allowing userspace to select another slot,
> as this patch series does?

Unchanged from the earlier email, option a

https://lore.kernel.org/all/20261103151643.GI274202@nvidia.com/

1) CTLV Start Connect -> NOP
2) CTLV Try to fetch certificates -> EOPNOTSUPP
3) CTLV Finish Connect w/ slot #:
    PDEV_CREATE
    COMMUNICATE
    PDEV_NEEDS_KEY
    COMMUNICATE
    PDEV_READY
4) CTLV Now can fetch limited transcript and cert chain:
    RMI_DEV_PROTOCOL_DATA is broken up into 6 transcript entries "VCA"
    Certificates for slot # are directly from the RMI_DEV_IDENTITY
    (hopefully, the specs are unclear *exactly* which bytes are
     captured)
5) CTLV Accept
    RMI_PDEV_STREAM_CONNECT

Then VMM creates a special "vdevice attestation FD" through iommufd.
RHI maps onto this:

a. RMI_DEV_PROTOCOL_DATA reconstruct by concatenating the 6 transcript
   messages to make VCA
b. RMI_DEV_IDENTITY reconstruct by reading the certificate chain
c. RHI_DA_VDEV_GET_MEASUREMENTS and RHI_DA_VDEV_GET_INTERFACE_REPORT
   map to the evidence collection API

The kernel knows that the "vdevice attestation FD" uses the _VDEV_
versions of the RMI APIs while the /dev/attestationXX FD uses the
_PDEV_ versions.

From there we might someday have common code to do capture and then we
drop the VCA decoding and RMI_DEV_IDENTITY to just use the capture
logic. This now gives a complete transcript.

Then the other emails enable option c which makes the certificates
available at step #2.

I've got similar mappings drafted out for the other two arches and
this seems to be OK.

Jason

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794448137;
	b=QlKBrCyE2sY8Mayn8aS82gdhzaIZrU5VE1NfnxB63BqnoryrwG8m8uaAaRubrJpZ/Ixq
	 EshAgB45syJpUClw49w2GEC0+2dSik639yy8lYxKjpv1+jUdopJJdYVjWZ09jh+HmW0eR
	 xO3Q3A2nRXXfDIuVbFMtIqerwejBFmytLbVh3od+yWXLzpksF1YUGO82TmMDP8ramfXpJ
	 nf8hUHZnaKLeT87PVcTsngesx0c7b6zSJ42Dnum9zxyyESGqmVN8YXV/1rv6xccOkOWqi
	 yZmto1n96Dt72E3TtGf8evf5dQaSDNTOQCaZexYzYlUoK1HB2oDz8zGzzn8IaikN8UA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794448137;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yMyL6jyyODHDx9WhYaF3IwfwweLmslDhvc94vzI+EAA=;
	b=rKAyGP5pitqOVbaTcXJzQuk4dUlCCebHawHK/AGmhSQtyF1lBPbyu1/K5zRj8+Q5KX5U
	 BNmpo93ZBtWEaMRCB6TBpK+7Qk7knpo+pgZPgLKWxOgbyAUd6V9XN4fuEQWhHVFgFpWFx
	 kUDYJ6uGOgWz/CxFqkcQGVXm/bn9Yp0MGCBurd3X/sikd1QkIKVd4AXx8jB6zbg7aPrh1
	 tbETVRgfKIKom8wmlSKYdCRPrlDi9U4vnKMiMvEdatkqhG89r31BgxHuAueisEmOKPw9L
	 pp0leIIjEkcIMnIh6XpUJJWwJVE8zg3HUyq1fTPs/TqLOtOI3QMJ2Ge9VFwUMiXIc0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4nv3UG26;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.34
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A64606A321;
	Thu, 12 Nov 2026 01:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A64606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4nv3UG26
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ll1jzb0NKYZKBsrVM6pWlX+GLPz+fuSGtlKuLNDJClI/+bPFo9LlR69rujjCvrV1UpIObCAsnjmQT77wZh8c//XyVaWdWXzBMPHWBAQoSfP5hlj/TBOeyne/u7IAzJblnFVKjlEAWvo/gl+26aa5TO6b8LjFdF99vVmKI2tQ3b6IMs4UKLAChq4bKUxMnZTZU3N6lUtfe1Tw0CNKNslRscdFDlUtKDCBvGKAB5mJkbAy8sFGMRjwFj/XumB9n2f/Yo3PSjLVvaAIkILDAMcxqJpwEqtOkzsxovOBpdNvt7rWibooEGQrb6fhcaVt2sjVS3a81MKCbW6L0XXM553uwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMyL6jyyODHDx9WhYaF3IwfwweLmslDhvc94vzI+EAA=;
 b=hcLwGHVbpTbDtOo5XzsebTfEl7UAqwGuaJfXq3yN6jE6aUQWNHZa2I3rx9cc77BsR5NAax8sIaFyHJ4Rg1FDLyPPyQeDVH+2ZSGSvEbEogomT8rt1PIyJyAubpxJZv2Sn2bWhLtkYSXTiVAsczCj4DDdiwEQdWdID7zybJ+80J8xiz9i29SzY84p4bZzES5fY25xKL2+hXbOdjs5rsxPWma1bvC4di/+p1F9Z0jFnhYNrEsJIYgkmIFjg2uGnL2/PN6gPs9B+BTBmj4N39CWjj1gkS7PIkVuIwjZhnmdTJb61zwK7Dh2FU//5hciCi/HH+4D1f52CLOvtYDQTjgntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMyL6jyyODHDx9WhYaF3IwfwweLmslDhvc94vzI+EAA=;
 b=4nv3UG263wuj1fGv2vEFhIfZ3QbiIRF46UupNBr3pMy7FzjgN93qfCNhfFh7jXwtLZV3Y68v3SgL/mHjDj214D4r89cKwQr2nWH5Etr0NSIfY6HOyUunFw8Bv40q24dwsxtvzeAVyi2Gb99NZW+FsEoGolzTrzm/7z+R/sUyO8Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DM3PR12MB9433.namprd12.prod.outlook.com
 (2603:10b6:0:47::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 01:48:51 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 01:48:51 +0000
Message-ID: <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
Date: Thu, 12 Nov 2026 12:48:42 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun
 <yilun.xu@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261111141315.GI738765@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0079.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::23) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DM3PR12MB9433:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf72b58-03db-4797-6de7-08df405f1a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|11063799006|5023799004|56012099006|4143699003|18002099003|22082099003|6133799003|261009223027099003|261026140227099003|261022075727099003|261022105027099003|261021123027099003|261021135927099003|261021121427099003|261102123227099003|10067099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	/yuQ5FZLiFteuiTMA5XuBWA322sSlCo1Q9QrY4o5MTZBgMG8U9G+k23tGaotJBhiL2DyUXfnjFNFHnRYR6y7nNNwJigLuUPvhccdgyXG6dMw5LzNXsaYK7gIeBlZNiGfS5adTezttSgT+oSNCef1hW35yIFtqHRXFDp+zKNITaaagrK3qAX896Ptavc6M5nO9kgDrtxZrohxF8zE2Jet2uRGkZ9pBQ6ufUqD2A3MLYL3ZI6WCBLzznzlTQgmVswa6WdMk7N1I9s40aSdtdE29hId7Jlg9Hbp+WO7m1IWvWvCxoLhFcd680zGTcX9iLl0AA8mLC00pF3Hqo2PU9D3LQAHGiYYh7P3mrB+RbKcw4C8ciN8Xvi00hfKz3LS3atth4Lng+O5ySCUgvw/wX9dIKT2UViAl1cqz3zuH7HfXWT7aLOJD9fdDK2OSFEXJsaQWLzRT/unvNCjZbEwcYfVFzR3XmiXy0eEP+EIbRNj7NbCBF9pun5GMyd8NTIqbcla6nx7vqa+IDRYne9Dr5eh7E+9SVOWvF3u1K/0GjkJC6BNUwfjLNvv6uZRX3MRUXs5CQtQNluxnPSw71VXmMexFsfDC/l0IdydJ+Mw4fQKmoa/LusukJXhwSmKVbUNafXjx/7iEbCzvFh7NG139PcrQ66BbY7OU6MJdchtqUvlGkU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(11063799006)(5023799004)(56012099006)(4143699003)(18002099003)(22082099003)(6133799003)(261009223027099003)(261026140227099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021135927099003)(261021121427099003)(261102123227099003)(10067099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFlIVCtjeXVUanprbEdIdHFZbHhqcVd6d1dwdDdScytSVUFVTGFOaDZuamYv?=
 =?utf-8?B?b2hZQlhVaHlWMmZOKzMyTzZaNGhIRG5RREd3YXY3UVZuWDczdTZYVEhua0tB?=
 =?utf-8?B?TytFdm96WCtBWTV1OVBWSytreFQvVGNwbXpERnM0VWhHMTA0UGJlRTh3MmxB?=
 =?utf-8?B?ZXZFdXdsT0NucEpVNkNMZEwwMFdhakFlYlhQbzRjSkFhTUhXSlBrK3VXUHh3?=
 =?utf-8?B?SXFmMXRJcXlVZXBvdXN6ZCt4aUFnU1UyQlIvTVJ2dTZ6L3JLYTRZUWM1eldV?=
 =?utf-8?B?QjY2YVNlVVVxNjNNeVlGVVVEYjJXR3lvcnBNTGdobDVwR1JFZXZ6ZUhrQXVy?=
 =?utf-8?B?endENHRpUVlWSzdIc3ZJOFNETXQ3WFl6MnpoTUFncFEwdjA0d1VXSGZLU1Jy?=
 =?utf-8?B?UmJXRG5welF2aVlpc1ZpVGNsWFhkaXFGSDdUTlh5RzdKWHNzUnhIUlYxQVRh?=
 =?utf-8?B?dnk2UVdnVW5HUUVlMlcrWTlvV0k1WjM4WnhwYUVvOXArMTJsQnR1bExWZEtx?=
 =?utf-8?B?VFdodEk1WkN3UEtZL0ppMVVKaDY5ajB0WFE2eGxMaE1BL0pUTG5XbGtCOXJN?=
 =?utf-8?B?dzUwdXY4WDdDUTM1TkZrQzFvemx6b2FidGowdmdQMmRPVkw4RDAyTjc3V3Zz?=
 =?utf-8?B?Q1Z4SEpSMEx3OTl6eDloMmprNjhnWCs3eXlOellBajAvWENuTGNTc1FZdXBo?=
 =?utf-8?B?M1RvK2pJL0VVQXFvbFQrdEk1azI4YVV1QXdLOWVnWjBDczlJaG1Gc0FJbWJk?=
 =?utf-8?B?MEtydHhJQmVkNlRDV24wY3c4bDFydDNwTDZROVF2R0xqSTN6WEZGaW10Ymln?=
 =?utf-8?B?aW4ra0xWT3RjNXBtLzlYeEh3UXBVOVNQWTVrRzZhdksrR2twcU53WnIvbGhI?=
 =?utf-8?B?YWtORzBDQjlleXNNeHlUbUd2WGFBWUFBdklSbU1DRTc1QmMwcXdFamViYlBZ?=
 =?utf-8?B?UmY5a3Z1Sm4va1ZMb25INzU3KytsbHF6bHFCQ2pYVXJqTzdLaDlmbVVZNWFN?=
 =?utf-8?B?M1lnbW5sem1USnhSVUhreFJVM0VuWk9NejVhSFFubXlqa3VVTmx0bzRNQ1gw?=
 =?utf-8?B?cEVON1VFKzUvOWd5OEQxUFEvL3BINFhGT0EyRk5nQXBoZlYrVi95MFNmMkR0?=
 =?utf-8?B?cW1pZHFkVzVKdWNVdHNmbXZMc3RZMVhSSWVqNDlTZTBWV0JRNnRYck9EdHM1?=
 =?utf-8?B?ZmRYeGE0eUdhdjJNYWFGVTVoN3p3dUxYNzBIRnUreFNYWnJDUkM5bEhsdWRT?=
 =?utf-8?B?bm05Q29uMkVZbElkWk5DYUhVbVVRRkpSeFNrT0dOdDNqbGdIOHIraUNmOTJh?=
 =?utf-8?B?TUZ3ajFERzJJMUJoYkxRN2RvbFBOdjZqSWZDTUxVVi9uYll1ajFZcUJack45?=
 =?utf-8?B?SDlROVo5TDVkYmRwWDBQTjErUzAwSStiUFF5a0MwU2tIME1LN1FkZURsVEZD?=
 =?utf-8?B?ejhLdW55b1FqRUptQTQ0QU9Uc2g1QjV6c0YvaVRiNGtZeGp0a0RUY2lWNlZ4?=
 =?utf-8?B?a1MrQzJRUytJQVZvTU9iRHYxSFNrTitpYjZTbnh0ZmdyQVRod3hNdmxMKzhW?=
 =?utf-8?B?eFlabVQxWGhXU2lBK0RzaXo5T1Jsa3liNzYycnVDWkk1ckFlc0tjbVRXYjkr?=
 =?utf-8?B?elNrMzE1M3NhNE1RdHUxVFMrSUlkNkJheTEzb1FOMGg3eE8zWTZqYlFoWVhN?=
 =?utf-8?B?alZ6ZTVpSm9wOC9YSnc5QkhrLzFteWZXMFJ1R0VPZ3FPbldJOURGSnY5MzJv?=
 =?utf-8?B?a1lLbXpTUDNwWDZ4WHptaDVnUzRVR1RhdmNZckdnS2R3Rm9zVXdxTVAyWVRs?=
 =?utf-8?B?T0J2Q1JUVDZkQ2pyT2VQdjFqTlJYN3gvRW1UVjlaY0t2THorL0daQ01XRTZ1?=
 =?utf-8?B?dTVLa0ZueVl4T0I3cllSWm8rakw4cUlJNjNFVzI1UlhkcDcrdmdsd1JGVGhX?=
 =?utf-8?B?NEZvT2lTYmQ5Yi9MaURGRUNqWElzbkNhNThpM0xGRTVSSi9DUXV4OTVqWktS?=
 =?utf-8?B?SWF5UHJvNEl3OUVBWDlUL0R4RHBXaHNyZVZyYXoxalhhQ01Mdy9pa3FIOE5l?=
 =?utf-8?B?OHBIZGtnMzNvdGZGU0pDOVNWM1hhdmRDamVOZDNGelNYQjFxanNKdDEzZlU2?=
 =?utf-8?B?S3NWRm9jY2xpU2tMaVhWaGRWMGMvaHlaTTkwbU9DdUVzQ0RVLzJPWEl2V3h0?=
 =?utf-8?B?eFJ1YUFCczZEUGV4ZVJxcWk1YUFFdWpFVUZ5ckw5SnlWUzNSc1liK2pqWFBh?=
 =?utf-8?B?WEdPN2tjYi9KOHp2MC9UckZ5OHljOW15MThxQVZZZGl1U2J6RVB2VWE5UUlB?=
 =?utf-8?Q?jtE72VaXQ0e7LCRPhE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf72b58-03db-4797-6de7-08df405f1a34
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 01:48:51.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llM3hShoyLrZyB5p1ZmmW4zBx1uk4OjsSvwfzJdyUCeBPmGh7VsxElaTX4Tz/YXrkvq2thmPLIFBvIWscZLmjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9433

On 12/11/26 01:13, Jason Gunthorpe wrote:
> On Wed, Nov 11, 2026 at 01:09:43PM +0000, Reshetova, Elena wrote:
>>>
>>> On Tue, Nov 10, 2026 at 01:15:06PM +0000, Reshetova, Elena wrote:
>>>>
>>>>> On Mon, Nov 09, 2026 at 01:54:57PM -0700, Dave Jiang wrote:
>>>>>>> Why? Seems like another wasted operation..
>>>>>>
>>>>>> The TDX module runs it as part of the connect and with the current
>>>>>> module the host can't skip it. I'll discuss with Elena and see if
>>>>>> this can be different.
>>>>>
>>>>> Does it come out anywhere and become visible to the host or guest?
>>>>
>>>> Yes, it is visible to the host kernel as part of the initially returned
>>>> SPDM_DEVICE_ATTESTATION_INFO_T structure. The guest can get the
>>>> reference hash of this structure from the TDX Module/TSM.
>>>
>>> That's security broken.
>>>
>>> The guest must never see a measurement from *before* the guest did
>>> LOCKED.
>>
>> While I also personally prefer to do measurement checks after LOCK
>> (being a security person, you tend to be pessimistic and require strictest),
>> I dont think anything in TDSIP standard says that LOCK formally affects
>> measurements. The measurements tell what device/firmware is.
>> It is the TDI report that tells it how this particular TDI has
>> been configured and locked for assignment.
> 
> No, LOCK says the hypervisor can no longer tamper with the device.

True (well, depends on the definition of "tamper").

>  It revokes hypervisor access to MMIO registers.

TDISP's RUN does but CONFIG_LOCKED does not so MMIO and DMA work as before, until RUN.

> Taking a measurement and
> then allowing the hypervisor change measured state via MMIO is
> entirely security unacceptable.
> 
> Exactly how LOCKED works is device specific, but from a security POV
> the device must implement LOCKED in a way that excludes a malicious
> hypervisor from undetectably tampering with the device.

The device fw updates (if permitted) during LOCKED/RUN won't be detected by the VM but it is not tampering as we trust the device to not accept a bad fw?

> This is not statement about device firmware integrity, but about the
> device *runtime* state.
> 
> For example, if the hypervisor tells the device to do a DMA write
> after 1 second and then the guest attests and accepts this device
> while that command is active, all guest security is lost.
> 
> The device's security design is responsible to prevent these kinds of
> attacks one way or another. LOCKED is a key part of how the device can
> do that.
> 
> Broadly there are three device implementation options:
> 1) A TDISP device MMIO is simply entirely inoperable by hypervisor and
>     only works under locked. Trivial
> 2) Entry to LOCKED cleans the device so it is quieted down enough to
>     be safe

We run the attestation without a bound driver now so the device is quiet but so far PCIe TDISP did not require this.

> 3) Measurements record if the hypervisor did anything with the device
>     before it was LOCKED.
> 
> We cannot know what kind of device we have so the OS must always
> collect fresh evidence to support option #3. Or at the very least the
> verifier must be aware the evidence is pre-locked and stale.
> 
>> Again, you establish a trust in a device at the time of SPDM
>> connect.
> 
> This only establishes a tunnel to device firmware. It says nothing
> about what the device is doing.

+1.


> The CC locked/measure dance is establishing what the device is doing
> at the moment it is allowed to be dma enabled'd.
> 
>> Guest can inspect VCA and the cert chain for selected SPDM authentication
>> slot that was fixed during SPDM connect and decide whenever it trusts
>> this device or not. This decision *might* require to know what are device
>> measurements at the time of connect also. This can be needed if guest's
>> trust in this device depends on its current measurements, i.e. I trust
>> device A with a key B certified by a trusted intermediate C but only if
>> its firmware measurement SVN is higher than 12 (because I am aware
>> that device manufacturer reported a critical security bug in SVN 11).
>> If all these connect time checks are satisfied, guest can trust the device
>> *given that manufacturer specified that runtime downgrades of SVN are
>> not allowed* not to downgrade its measurements between SPDM connect
>> and LOCK, moreover it can trust the device not to downgrade measurements
>> while it stays alive (and while corresponding SPDM session stays alive).
>> So, the fact that SPDM session stays alive in this case would also guarantee
>> security.
> 
>> Do you see the logic in this reasoning?
> 
> IMHO you have focused too much on the device firmware state and not
> enough on the runtime state and the impacts the host can have over the
> device while its MMIO is under the control of the hypervisor.>
>>> The entire security argument of the guest is that it locks the device
>>> so the host cannot tamper with it. Collects a post-lock measurement to
>>> show what state it is in after locking, then makes a policy decision.
>>
>> Formally measurements of the device can change even after LOCK if you
>> dont explicitly forbid this via LOCK_REQUEST flags.
> 
> Yes, but this is something else entirely. We told the device it is
> LOCKED so it activates all its defenses against hypervisor
> tampering. We take a clean measurement to prove the hypervisor hasn't
> left anything behind in the run time state.

But measurements do not include the run time state (the TDI report does), where is this coming from?

Or it is about the HV updating the device fw between GET_MEASUREMENTS and LOCK(NO_FW_UPDATE=1)?  Which is a valid point.

But if it is LOCK(NO_FW_UPDATE=0) (which is valid configuration), then the device fw updates will go undetected by the VM so essentially the VM will keep using a device as trusted even it has not been given a chance to attest it :my brain explodes:


> Now we trust the device
> itself to only alow measurment changes that meet its own security
> model and the hypervisor cannot interfere. (bugs excluded)

Opposed to what, accepting any fw if not LOCKED? :)

>>> Capturing a measurement at SPDM session startup, while in unlocked, and
>>> then using TDX module to trick the guest into accepting it as a
>>> post-locked measurement is *entirely* unacceptable and I will oppose
>>> anything like that in Linux.
>>
>> There is no tricking, it is specified in TDX that these measurements are for
>> SPDM.Connect time and not after LOCK. And if you want to have later
>> measurements, then you must use recollection functionality.
> 
> I'm am feeling against even exposing early unlocked measurements to
> userspace, given how dangerous it could be to ever rely on them.
> 
>>> The guest must be able to affimitively say that a fresh measurement
>>> was collected after locked and when it gets the reference hash it
>>> needs to know it is fresh after locking.
>>
>> If it wants this, then it must do recollection and we provide this
>> functionality. What is missing from this currently is TDX module does
>> not refresh the reference hash because the assumption currently
>> is that the same key must be used to sign recollection measurements
>> that was seen during SPDM connect (and protected by a reference
>> hash).
> 
> I pointed this out already, this is obviously very bad. Loosing the
> direct binding to the SPDM session is a significant security
> degradation compared to every other architecture for no purpose.
> 
> Updating the digest means that the guest nonce ends up being captured
> by the hypervisor and presented to the next VM as the 'initial'
> connection measurement. This does not seem like a good choice to me.

Does anyone actually _present_ nonce to the guest, not just forward the guest-generated nonce?

> ARM's VM boot time mode selection of 'TSM controls nonce' or 'guest
> controls nonce' works better, IMHO.> But two digests 'initial' and 'latest this guest collected' might be
> the better option.



-- 
Alexey


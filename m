Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794232070;
	b=VpsY3q6i3/rhimHKbHciryIZ0mhv2Bj4n5pbaABgaZLFDoMJACw0H4B6XnGzvVOUX1K0
	 QRH7w4SbGWDQeoyeDQOs7EXijNgWQmaaY2pGCGWirTCtjT3rcfjfzUHinG2mCGFIEkc4Z
	 g+LImdDccJi67yXvysGxUHvWPwfbCeOLyLdiqqg2CWMFPSfR8XT0T0pWy8W+jKp7RTkSf
	 dWa+sF9uhwgQ3SY+6JSHV5QxgCVbB7vIQtm4cm/QMpIva3zDXncrlO0YFw2n8vYPvjzQ6
	 lDN8o2KOj4EB174ZPwD10OtH0AUHPkdeEuiwvVdXxC0KMueLRcXYmCdsBjK2xqjLYSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232070;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=7+xaK2YMn8Qlvs6RiICqvSwXfF/PZn/fC++NRYAT9eI=;
	b=4d8cqsthCtd7LOaFKH6MwSeg8K2tNbXACNzgjwNLHDzUA+hPhllo9iMdu2ZB1GONmORj
	 6rec83Y05zL6y8TNUjAyEt9uRjX7RudVkTB1J1Daiy8/ZZZpv2YNOiSNt1Yn8xgm9Ega/
	 2K9VeuijoQowzpi/uPGErpNYnHqFWJ09uCj08uUY8AXNOp3pX8adCkrJXrK+uJ+fqOjcv
	 ugpyRxMF7AFUP9W8gl987kRKqA5krLgW4EMu/utSXa/gI2DIn+2ATNGEa3xBNpqTgDdKD
	 pS0rAZCpUucAtl5md7MSOxH1TMaZG1tfFsmMZda5bX/upghRHKfN9UHpf2JKJG9LoXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=js6knbAb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.65
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011065.outbound.protection.outlook.com [52.101.57.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC7E606A322;
	Mon,  9 Nov 2026 13:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBC7E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=js6knbAb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=km7b+y/iOOZWRkPQRFgJp1uIAphtdUUO/4bqOPYsMzCo7QX1OoWBjNVX9A0Y0Qs2zLN3NmS5SMpbZjIqrTp2Vt93p7ZZL0ZeAVqsWmOf5BYLy5GvvPsrED7LWrlYepyO+yaoHQTCJYOa/sXS03ez5/fXjBJBcDKJHBra1oHT6QcH6iBHD6t9NPr7/n51mOn2zlQhNW/0beHy1SU+r9p/j5NmAa/hVz3zv67dluLTtaI0Y0lzXL9V3qi1dng3pD/g2HQuMI+REeLKEzx5eyfW/pKqgg1RN+C57y+AvCo4i66HHVplkdQAFoYN7R/oq6SYH83CVfEewUhwZcYkPXQUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+xaK2YMn8Qlvs6RiICqvSwXfF/PZn/fC++NRYAT9eI=;
 b=Jjr9qxVgMPab1i9QrpOfK+jFmSl+gsYDSGHoAd4OOgQ+41/kdS+pwU0Hll3E9JY9FCHV88sDfhoD1zIbWKfHdIt5zo5/jOnLpE5IQwSfteidRLdXjVZlq29US/qGNv7CFFQo89Rx8oT8G55VJlBqIqJh0tnaFTKzwtzvB+I19SwLMhKuK51HuJsHv8BY+KpDBQ1Lfb1en5Pn3mN96y8hRBex5WUkfLUaz1aQYYTOIR2a7pm4J6tlZ6IDCtRQwcstnvifzcs021MQOx81wPg+QZD3NPgChiTzqfc+wzem3NijLvYfZugTrTvMedegz2xkuv6qia4/wS7SCE7UH9OviQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+xaK2YMn8Qlvs6RiICqvSwXfF/PZn/fC++NRYAT9eI=;
 b=js6knbAbfXq752czK/vLm8/cjSLUf0BLIruXhRH6X0yz8h6ll5NTeWksUiUjvOkm6wyAkMxI4o7rQDB1kg/fKfODFJpSDDLx6m1H0TPCtqn7djV6PdQOnXWVdgk8ECxiLkQlHGNqlQsJ1D0+hWr5NW68NXrO4GrIA2yjaRqdFnXhNu3t3MlLyga6X1tYKF+1qGMhRBrgNMS56vKknZTZ9DRarCKzb3PAoGgJRyYqgZetv8ZraFKA1gH2VTYJ0O43DCIY25qxYDiAOrCMlqzwK5z5krMiMCuQJ7DFRdXUXakbCzbpNCt6rVwiOQOepoCEOTpgwlqjghY6ixVsgWu2qg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH0PR12MB7863.namprd12.prod.outlook.com
 (2603:10b6:510:28b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Mon, 9 Nov
 2026 13:47:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 13:47:45 +0000
Date: Mon, 9 Nov 2026 09:47:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261109134743.GM770409@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <DS4PPFA84FA90FC12B59A447BBEFE2053D8E7732@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS4PPFA84FA90FC12B59A447BBEFE2053D8E7732@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN0PR04CA0119.namprd04.prod.outlook.com
 (2603:10b6:408:ec::34) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH0PR12MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb4d997-4f64-4118-afdc-08df3e68087b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|22082099003|18002099003|6133799003|10067099003|4143699003|11063799006|5023799004|56012099006|261028144727099003|261026140227099003|261102123227099003|261021123027099003|261022105027099003|261022075727099003|261021121427099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	nn0Z75m5Cbl9vb9HVuTJXtBrTFlB36yMCnT2mwAJ1iBYVdGn097+F5joNwl7gXKORRFtaa+FvPZK9Y4Ardm12Bfbk/4F5IBvqffV0SrKjzzYIYwFhVhWVBz4uxweBdYjaSat9ThdH7/vynKdt6PyJrv0O9zU9YsSrOdvMK4OAqrA4tLxmseF3Tsk8GwgU+x4dTWc9Fn1n1QhOKUv8DU3OjnQatLrZF75qvZ7wjpsNHUl4KXaGV5mHiVlCXG7liFgCwvOLCDyHWBs/u2SzCCmC9gRUgwWOmcQWlHERh0BKVcXeRX1WGbFkOS5hXbmNRV23T86emActjlFsQ3FfRhqgaOAY0KQB25lqcXmKqimI6GYCrFbpVdmefEfjY14am3WLQ53lUqjZEwsUyzcQDJJu48sGlcQ4zYe0+KTxpC9RlGusf8OF70sMuw6e2z1HjagXoru9OECxc2fJ8nYeBuLCVPmxXRLYjl5G4CzeN+hu1AsD5CtIrUNjlQrcEJ5s7TN/r01fj9c4RNLWH234X5Omd7v5dUgrB9xyEe3oAB5RPBOt8WMcg/D28ld5jo0yFuS5n3RVSV4+ZnUEocX06OYs10M/IhqwRW18OaXXq5UuSf/tIDBWGS+pVto+bWrhOVrKPENGGWVcPuj+kbuHYnhqolAt4DYDc/G7q0PVsVH2Jg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(261028144727099003)(261026140227099003)(261102123227099003)(261021123027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGV5OFh6Sk13WTBjZFdBVFlUbWVCR1BZUG54b1R0Z3lpNUNUZU5MUVlCMmEw?=
 =?utf-8?B?N1gyNDU5dGhLR3pockF6UzFEOW1HVVE1TnVWM1M0UGxwWU81YlA5TXBteUVs?=
 =?utf-8?B?dXYwcU4xWkJXaXZ6OC95Y1BBM0YwYmExSVBPL3NKbk9KUVRHbk00SmJuMW1i?=
 =?utf-8?B?YUtrTDFUTCt6M1drQ1hOR3hxMHplbFBjNEYxdWVEYkNNc1M0cjRUMTg5OFhz?=
 =?utf-8?B?NDRGMkYySmVZb01Ud2h5Mlg3WC9CVU1xRzQrZmUzbTNTQnNrYzNEeHBlTHBi?=
 =?utf-8?B?QytlZ0lMQTF2N2FUM1A4eUpXK2xteEFMUEh4MGo2MDQ3L1ZCZ3RqdmVuZS9I?=
 =?utf-8?B?WkhQbDM1UjNnWW1GbEtUUUFSdnJFMWxsUk5rYUh6ZUhnODR1YUc4TnJrQU1Z?=
 =?utf-8?B?S0ZWaTN5cjFLeVl4UkkyekVFK0lQS2xTc29pc09SaHQ0d2dkclptMzJKVExs?=
 =?utf-8?B?WDlmMnNaRm4yUjdYbFQraXNzUURoRDFVL3dzUytmUmZwZmpSYzVtOWxhY29O?=
 =?utf-8?B?S1hDWmJlTmVnZ3IwQy82N3lrUmp4aEF5dHJvQmFtVEZzSzc1emd6K1NwUU5L?=
 =?utf-8?B?QW1zTzlWQWFsd0padHR0cVh3ZnI1eGxZbUl1MldtZmFMbmcwMzM4K3VBZ2ln?=
 =?utf-8?B?Tk5NeGlHcVRkVWVkZ3o0L0RRajlqbjZrQWJqZVNzbFBtaVJva3h2dFFTeEVk?=
 =?utf-8?B?bVc0RVJoS2ZndWhCMndwVEVXNGlyR0tPdTJiMzhKOGcyTS8waENHNGVzRFg4?=
 =?utf-8?B?aTBGQ3VXMFNzOGhRYWlQZHg0S3JVb0U4TkMxQm8zQktFSGgwTXhVd1g3L0pG?=
 =?utf-8?B?cTY4dzdkR0pYMzFlWXZ5cWhyK0JPOW5xcWREMFc0TFEzckFhR0ZQQ25NVHlY?=
 =?utf-8?B?ZnFrQmdpM2lLK3J0MHIzM3k5SVd5SFVvNVhDUFVTeDZ1MEtxMkZpdGJQdlhv?=
 =?utf-8?B?UTNhSjg5RXR3QXZWdFlMY3JRS2JuQXQyVDBORjJzUWJwdGVHUmlsa0VMMDZh?=
 =?utf-8?B?MGxDeG5kcTYyWVV1UUtCYW56dkhOVEl4YjdPNVM5Zys4YnIrQ3I0N1gxbnpl?=
 =?utf-8?B?OE1LS014TnRvczFMaGhmc2hXZmc4V0txbm5iWXEyQndzb2UrMWRuMVdaejB0?=
 =?utf-8?B?VCt3WFB3ZFBDTW11Qkhtd3ZnM1dleU5vR2pUbHJMVitOUXZ5M0Rsb2prajNo?=
 =?utf-8?B?aG9xVjZPaHhBb2laNjROVnhPa3dCV0xJVmFlNXVmZE1VUFNnZUxBUFA3Uy8x?=
 =?utf-8?B?WmpxaTJqcW9RcEdWVTI1NUxVS1FxdmVEdnplWXdKSlpRZUlwMkNNdVdLWVRY?=
 =?utf-8?B?TW5MQkRWSnNyV3FSRklxcXJIZlVDaU5jT2xpMXFFUFp3TmprQ0JWMC9LbXk1?=
 =?utf-8?B?UEdIUHpPbktteVBUVTUyWDc0emtOZVZMRkczc0FlWXprNWE0V0xkeFF1MG81?=
 =?utf-8?B?bkRES2V1MmErK3VzNFlkdUN2SHkyUlJKWnlIYlg3WXlzZUI0N2JwaFova01P?=
 =?utf-8?B?T0Zwb01DMnF6UUZONXJZLzRaUXdxQ005NDFWWUdHdmRFRHJ6ckFiN2o2emFw?=
 =?utf-8?B?UEtJQiszR21YMzNyeDVJMStXV1M0a0pxUE5SZllpMlBCRGE3blR2QmorMzdW?=
 =?utf-8?B?ZTBKWUZoY2hXQ1pxTWpKR2l2ZStVRllGc0NrbUtEZUtYeVJ6M2V4bkkyRXpq?=
 =?utf-8?B?UTdiMy9iWVFVOHF5TlVEVUJDeUpKT0JNdldIUDUwcnhUemMrT1Fab2s3ekhm?=
 =?utf-8?B?YVB4S0laNE1RSUpWZUlHYmVFbWt1TlY2OGM0K0tuU1pFUjEyQSs4S3F1UUZv?=
 =?utf-8?B?T0t0c016WkNROVZINTErWGlRYkl3NVhPaEpkNnR3OU1MM0N0M3NucU1CMDM5?=
 =?utf-8?B?WUVaa1pHNGNhNUxJamRudlRyejkyaFlpd3hFOXlhY25kZ3lXaSswK0NSMG1N?=
 =?utf-8?B?WUlBazRDMHNmd25DYmRJZzl2ZVJ2YmtaRmVOdnhJSjFhUGRpalBSdUJHSHRu?=
 =?utf-8?B?L2JsU2lWRVVSUVBJOWVKcGhBRXlvSFBEU1dQaXJaOUpvREFwRzUvT1JuaVZp?=
 =?utf-8?B?NXhLbGZ5L0FzTVpmc1grL1JPVmMrbVdLcUh1OTQvM29ncDRycFh1eGxMV3lu?=
 =?utf-8?B?ZDkvcnhIeEN2VjhDQ1lmbGwyZWN3V3hLTnNsSG5GVXB5UHBMTThqTFlNMisy?=
 =?utf-8?B?YmtPNnY4Ty9TQW95SE9oNFBoczJuV0YwNkZxNktMZHlqWVhOZ3lrV0xjaTVI?=
 =?utf-8?B?RnZaR0FRSjEwZllsTnBURzNjUGdxQXdrMmZsclNHdUphbnQwM0kvWVBMN3dS?=
 =?utf-8?Q?J6RDfta1weqhta2QDT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb4d997-4f64-4118-afdc-08df3e68087b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 13:47:45.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAMX42J6qfzYndTGGLq3KMGczqnFzUBFU/ZybohN/P0u6TkeRIAfDVkkrhs1OMZx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7863

On Mon, Nov 09, 2026 at 10:55:02AM +0000, Reshetova, Elena wrote:
> > The host could inject GET_CERTIFICATES on its own right before
> > KEY_EXCHANGE, and I'm wondering if we end up with this scheme if the
> > 1.3 mode should simply have the host issue GET_CERTIFICATES and the
> > TSM side just does GET_DIGESTS.
> 
> While it might be ok from security pov, it looks somewhat hacky...

It also feels hacky to build a FW call just to issue GET_CERTIFICATES
in plaintext so that Linux can capture them and the FW throws the data
away..

> > > On TDX the re-read of the chains comes with the measurement
> > > refresh. The kernel doesn't ask for it separately. For option (A) I
> > > think the kernel can drop the re-read chains and pass up only the
> > > new MEASUREMENTS. It already has the copy KEY_EXCHANGE signed.
> > 
> > I don't know why you guys do this, I would take it out, IMHO. Just
> > wastes time. Yes, kernel should forward the chain it collected with
> > KEY_EXCHANGE, it isn't allowed to change and there is no need to
> > recollect it.
> 
> I wasn’t part of the original design, but as far as I understand it was
> designed this way to allow cases when *some* cert chains/keys can
> change during device runtime as a result of a device FW update.

Who would ever check it? As I said there is only one security relevant
use of the certs, at the start. You can audit later, but who cares if
the certs have expired or changed during audit? What audit wants to
check is that the device hasn't changed in a negative way. Loosing
it's privkey absolutely should be considered an negative audit failing
thing.

> Especially when we think of multi-key case, different device keys may
> have different life spawn and *some* keys/chains will be changed when
> a FW update happens on a device. I think typically SPDM slot 0 (identity)
> remains stable, but rest of the keys can change. 

And, again, IMHO, the device is fully broken if it changes the keys in
the slot during operation. If the OS is doing auditing and requesting
a signed GET_MEASUREMENTS every hour the signing key *can not change*.
That would be completely insane from a security POV.

On FW live update the device has to retain any in progress session
exactly as is. It can manifest the new keys/slots only once when the next
GET_VERSION comes through and resets things. Think about the races any
other solution would create :(

> But of course in order to stay secure in such cases you will need to have
> a cryptographic binding between the old and new keys. This can be done
> given that re-collection happens inside previously verified and established
> SPDM secure session and you can put additional security

Nope, by the point you get to auditing the verifier can no longer make
the same assumption that the OS is actually still secure. It's job is
to prove that, it cannot assume it. This is different from a fresh
boot right off DRTM that is still in the initrd where we can much more
confidently say the OS is in a known state and we can trust it to have
done all the measurements correctly before using the PCI devices.

However, if the OS has since been hacked later on then it would be
trivial to just present new GET_DIGESTS, certificates, keys and
measuremnts relayed from some other device to hide its hacked
activities.

Allowing key change without a direct signed hand off is security
unacceptable. If you want to do live slot updates then the old slots
must be retained as is exactly while the connection lives, new slots
can be added, and you'd need to collect a new GET_DIGESTS signed by
the original slot. The spec doesn't really have a way to do any of
this it seems.

And you need a log of all these events for the auditor to check
everything. Overall it is super complicated for almost no benifit. I
wouldn't do it.

But definately Linux should not be supporting a broken version of
this, if Linux cannot directly confirm the signed authenticity of the
keys the it must not present them to userspace.

IMHO the spec needs changes for this kind of use model, it is missing
a pretty key operation: 'get digests signed' where you'd get the
digest of every slot *AND* an array of sigantures from every slot over
those digests.

Instead at best we get a single signature over all digests, so you end
up with the OS and verifier locked to a single key the OS seleceted at
startup.

> This is current design for single-key case (multi-key is not supported). 
> Given this, it makes sense to use fixed slot 0 to always establish SPDM
> session (since other slots must have the same key anyhow), but allow
> VMM to configure if it wants single slot (faster, less fetching) or all
> slots or a subset of slots. IMO, in a single key case it makes sense to fetch
> all slots and chains available and pass this info to the guest to maximize
> chances that guest will find at least one of these chains acceptable per its
> trust policy. 

I'd prefer that this be done via CHALLENGE at the start when possible
so we have a signed GET_DIGESTS to send to the guest and to the
verifier. But as a backup reading them over the encrypted session and
checking that every leaf PUBKEY is identical seems reasonable, but
only for 1.2 and must not be done in 1.3 multikey.

However, the guest still needs a way to indicate what slot to use for
its measurement report.

Jason

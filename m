Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794288767;
	b=l2bwrtVe16aSQBMQDC14XKeUj3YlYh7O7X7IjCN9YS9xq1DzjLLqCrDKExc83mObh6LG
	 OKRnvhHuFPiahtomec9R1uJ20UbjFsN96AeNVtnmpt6cEr4o9z19Mz+SdS80yiEtD/qpU
	 13qavSTobtCJ/NnxikdXQiv8ktjZvtlyyBjqwK/suG4TIHclFSeJu05NzZ5ft7WN4EoYY
	 UT1JwV4V2V/uBkxZ6NNJxJoXeBD1qicYrnggCtBQqPJxKjk2QFqKrB7Hnz9eLfJELZGch
	 9yAccdQhWzhIhhZVGqegu/qpMppUJZ191ldFIVmfWCNRgnsz/P+EMWU2vZD83+bnW3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288767;
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
	bh=48tNKPZclB6k5uKlbeAd9wU8A7Otyg8QTKcs77+2t6A=;
	b=KwUv55h0KHNrth8riozgyFvSHL2p2kW1wvoBHAP5/BpjB29D6RZG6yuPwL9oeeuBPxsn
	 pXUAp1vy195kAydT7y/+RwhPxc/W8ZZ0hpCOo5C0FVY2m95KgiBs0/Dc9hC7j0l1Wsm4k
	 0WEM0scAg7RqIQMoepMKhheTYbDzBRXZSoJwUQn6T3Bry+L+2p9pzYHm9pA0k77jofEZk
	 pXHOK8zHy1/N833bjj2qKQ/Jg4w1k262jfVD7GpK46Ew3el/K5lb7PNrbAJfxwqUH0go/
	 FK75Rz0NU1YM5sJpgpgqXOkfgVCHlZMRKank6jT6spmggct08NO7Lal4FLlKDcHZcsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=kHe7mbVk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.68
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FD3606A31C;
	Tue, 10 Nov 2026 05:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58FD3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=kHe7mbVk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hz+QZCTD2JOWQbsm10ohUrIs8uoDWoluh0VTbO2ISyMMqQaV3CsdzL3MIIuv7fc6YIKhh5l6dOzQQobdr2AFANs/YD2/mKjDEXNeWRaOR87cB2MODV6Wbx4K33miGjRV8acDlVTZB7vbF4mqDRpg/0M97tLTRzRnpIYWJn11uf0fKyI+DQCCluhiwsZxmgQ9r1gKjFgASFsEqVi9Y3w3O99S33Oq9n2La483GqK04k0fI7jP0QDOBtrNXZ8Gd/QtzBidLusYOII/HaZ9uBmxZZPntInkqGNa8m91y8YO/3CIK6MyMm8qPCt2jtD7YFExFuOfowEDDaXfNmk0kFt6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48tNKPZclB6k5uKlbeAd9wU8A7Otyg8QTKcs77+2t6A=;
 b=dawqRvpENbF9tzbFIC18D9xQ4AsA5Y9dHZby2vys4o1OkSXwJICLDoxAiQgNf+6qS6Kyzj59fcOXUEfMDoxJd/O/85qBug3dEDl3dJLu6lyBVicnF2YepIMmsDi2Rdf/5zAqAvunOBeqX3GAL2xbtmAV7hhXplgnByIjoVBqaYEGHRgC7uVo3hUgADWobjBFGnZ316gVuTh4ZODGgVZdgftMe5xfB1GbB4/t8TlkChPDkpDrc6WdIcaTXLQuiVoioiBjFp3hjz+3oEUapeuQhCcEB7Ss92rWjYix0jH0levZNJhQdnpOD0WeHlFjbYUgjruEqa5a1uvTMg5jHoZ+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48tNKPZclB6k5uKlbeAd9wU8A7Otyg8QTKcs77+2t6A=;
 b=kHe7mbVkGH2GdvS3Col1oX2LsrmVj36DxQG/RFixUDgOtXPU9sWJE1xu/V7sHY+GUZlSy98hECOSVahF8T1VJhWmCcS7IowC4gfMCn75bUiOFe6qLEKlcgpz/urNKT9em4Q4Ej7/BEjSCfDoaq5b8VlKNlMtzE2al/I6iervups=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8) by DS0PR12MB9060.namprd12.prod.outlook.com
 (2603:10b6:8:c4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 05:32:42 +0000
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408]) by CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408%2]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 05:32:42 +0000
Message-ID: <9cdaa99e-4a1a-4fa4-8fe7-73b9bf48ecd9@amd.com>
Date: Tue, 10 Nov 2026 16:32:34 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>, Dave Jiang <dave.jiang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261109185315.GS770409@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0030.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::8) To CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8)
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
X-MS-TrafficTypeDiagnostic: CHXPR12MB999219:EE_|DS0PR12MB9060:EE_
X-MS-Office365-Filtering-Correlation-Id: b4aae079-0237-44bf-6361-08df3eec0ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|4143699003|11063799006|261022115727099003|261021121427099003|56012099006|261026121527099003|261009223027099003|261022075727099003|261022105027099003|261021135927099003|261026140227099003|261028144727099003|261102123227099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZgZRUeQEt0Pw+3kaO8R4wRyYitE9RFUQxD1M7NAlLo0SAJQdea66GKCl/sa4OmWsNr02gr5oVnY6dwg/b3/eZY6ChYjvCKfYkx0X/kTeXoME3WuSgtVrv22zSOLWagQUHTjWSb8QNGTc60a2ohA3LPvjcbL7MxeGIa2lREgdy1DdLVJdh4BLr0uvs0KIMdJ9GYCMG08zEmx2SVNvXs1acgmdZNoGLwt8SrkDBifyGW0gR2WtNPYcsoDtU5p0YduTKsEA9plSKfLR3AMoH8um4ccjAcrwU71KmqDWUBEcyyqZuWOsae2gD4txyFIyx7JW1zXTMynIkyvwaZ8cXah+ox2EnkP1DGVw5OYSAy2B2gqeEsTXKbltE1uwRymuhscfwxpK9agdZttgbtUK1Se7sSrVFlTHoa+FQM9ComZUsUndUwEIUy+swDiT/W67//kHbMwhFFHprgf9T94qyXeXPRxWLKLE1N2xpj4XcIhFB8h7mYcbTceTcc5SsDq69qaxMlHalgLUWvndNvMJeifPMd4DMFyXvLK+ZHshrHqBJbgqSoY9SfyexMtgIh5OnOxKdGK7hEheWiKCgRq/po9gzEZwU7WIGAGFlOG+ZM9aCHeX+FzuCg0UtTI9QU9bbnfZ9Tvxo4EbD8AQxV7TvGdHfoRIUWMRi/uNGNWDoW5V59w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999219.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(261022115727099003)(261021121427099003)(56012099006)(261026121527099003)(261009223027099003)(261022075727099003)(261022105027099003)(261021135927099003)(261026140227099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVgwbHIrSEJQcCt4d3ByeStXNm96d3dTb2ROaFUwdHBQMHpScGxBbitqNzlr?=
 =?utf-8?B?UnVFZnI5TDBoeGZSaTVKZmdQY2UrV0lYNTZKZXNDT0VybHFaYVdwSmZXbWVq?=
 =?utf-8?B?R2FHTHEvRW55SFhjUUhkZ2JjTzVUWUhMdVB4cFk2SUR4amRreDdXcUxCWFps?=
 =?utf-8?B?NjJrTHhZaUoxRFRoUVQ4UVpPMCt1cXhUbzNmNy9IbytTakdGRENPNUFGS1kw?=
 =?utf-8?B?S3VVMjAzNW96RDlWSlJEWDdyNGdLOGRCWitxdHVYU0ZvNTNJa0I5NG9UZXJm?=
 =?utf-8?B?VXVtTU5nYlk4U2g5Y25ndmhaRzdyc1pHYis3ejROTDdITnVQTWtiSXRITTFX?=
 =?utf-8?B?bkcrcWZ3MGllKy91U0hrMGVRRmluMWkyYkM0N2ZTY1cyV2h0blNNbjBnWG1k?=
 =?utf-8?B?TTNoSnZtN1hHWFUzSnV0SHN4WFBUcXZ4cDVqajlGQjdBL2J0RVFsMXhCZ3RG?=
 =?utf-8?B?cStNUjFLK3ViZ1FvdmRKREJuY3J6QThzTzlkNXJMekc0d3RiS2JIUFoxSFZD?=
 =?utf-8?B?Y0ZnaTJXSHZjTW5zSDNtN0hGblpsU0I2YkJtOE9Yc09hWGhMYzJ6YjdpeS81?=
 =?utf-8?B?bEtrZWdtMC9sWkxKU1owazYweEpnV3dLR3AwZ29nL2JBbmFqODJVYTBEclc0?=
 =?utf-8?B?VVFRRjRJeCtKaEJONGxQWG5BY1JjdjA0QjZVMWNuRmQwVlZDbzdoYjFsM2p6?=
 =?utf-8?B?cXZFS0ZSaEZ6R2k5SUtFNWxpTE1iTmNTd3F6TXJyWXVLWTJ0M0F0dWxXM1Nj?=
 =?utf-8?B?ZmJ2Nm94VzM3V1dXaUVDZ3FOMGU5RXJ5aXFpWkxvenUyU0tTaWtaMlBvZnZt?=
 =?utf-8?B?Nll4ZEV0dEZRQ01BSmhLWXlEVFpCU1BYRDBuQzB4MW9nREdta0dMSEU0S1lj?=
 =?utf-8?B?ZDFYTTZNL3E1bWFDYW1hWUNYKzNreWZrbHA1enYvby9RNmxGUlFBMTAwZGZq?=
 =?utf-8?B?V2xnbjJjZmxoei82aUFISUFEdWw3ZHJNNWZ3SlhOTnBMZXA1eFlLOVo0K2Z6?=
 =?utf-8?B?a2RlUytlVFVFL1pjSmNweHQyY21QTXE0cFdRcGY1TlhkcUMyWnVxeFR2WGRl?=
 =?utf-8?B?aXNiUnNJcWxvYnM1OGNOMU5lYTVjUmJPeDIrOXRreWx4OTVIYndpRUhVckI4?=
 =?utf-8?B?RzlmdVp5WjFUV2dYMGJpMk1ocHRhMUIzZTdHNzd1T0hzQ0J5bVZ5aG1xT3d2?=
 =?utf-8?B?cXV4WnE4Rk42dmdOK09XMm9KZEVIMEJTaXpWOUdjcDA3MjczY0tVY1BHb3FH?=
 =?utf-8?B?TzBUclJHcEtyUC8vSXRjTGNwZUFFbk1USFBaTWh5eEdrK2FRZ09wLzRSZHQy?=
 =?utf-8?B?T1VwSXl5TkdMR09lUHBodlNYSHhyUUZCYTRKcktoclorNFg5TGVuZitScmFD?=
 =?utf-8?B?Z0NnT1ZlOFRaeHhkMFJYU09FYnBWWXBWSzYzRGlkZXhibFJOV1VMdkt0K29E?=
 =?utf-8?B?aTM0d3hyV3lWdlcvUFZUTlBpYU9IbmNnOVNvNm1CZE1CNmJ3alFNY3lhUUpz?=
 =?utf-8?B?N01GYnQyQTFZWlZRbm9xUnNGK2QwS1VIdmdGSE95NzlZVlBreWJXREFFOW5O?=
 =?utf-8?B?TElMaUpmSXdtS0tQSC85OTJrb1pacy9GbFY3d1V1QVcreENMSkMvaXpFRmhF?=
 =?utf-8?B?UnRxT3RZM1Y1YkZqOFM5RUNXUktEM3JNdW1ab0dLMUo5a0JtSlJIUmhXd0RF?=
 =?utf-8?B?Vnc0VFQrTk5hSW9tOVNOamZwbnBOK1N6bXRmYzhPSVMxZ1F4MldFTU5oclEw?=
 =?utf-8?B?eC9SbWx4ZThvZVhTVW91MmZreG0rVWNsbHQwY05KaGEzbVI1bnVPOENXQ2di?=
 =?utf-8?B?S0FMblJFNlhJNEFHYmk3WUZRZlc0b2dSSnF4a3RaVDB6OFJXZkNqdEIzdTBz?=
 =?utf-8?B?WmhhQk9GSkYyeXVjMHZtN0YxbW80bUZCUDNwUUpudzZ4bXgzSEpqazZOckMx?=
 =?utf-8?B?RFBDRytvRWxmbHdLaFZSTzV0MTNGU2xvUTRSZ1BQekgrKzBUZFZ5a3J6ejY5?=
 =?utf-8?B?WnVwWEN2V28vd3p3ZDZGanB5V1FWUXVBSzZWbUZvK01kSWVzMjYxdCtrdTZU?=
 =?utf-8?B?MkwxNlJ0RnQxNUZVQW01M0lDSkNZVzR5bURlbnA2RjdoMmxuQlNsbnBWMzBD?=
 =?utf-8?B?SmJsVHhhY0wyeWNLSktOZW5STFBJWk9VK3JJTjFqR3FQUmd3WkxxaWdzaEZs?=
 =?utf-8?B?MStYRTBXZXc2QXVGN05VNGQvbklsUC9oRHJyeENvdjBJTDEyeFFGaU95ZlBn?=
 =?utf-8?B?TjJyZ3Zid0R0RUlWeG5YSWxPWERQYWR0YXArVXNDMTJ5VS9pdktUVjBWbEU4?=
 =?utf-8?Q?o3i2jqkUmpCnGrR3Vc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4aae079-0237-44bf-6361-08df3eec0ae3
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999219.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 05:32:42.7031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fb5/bB4tV6hALR75pR00La4vlllVn/dBz1+Ob97jtcirBVnkrI0rlF8J3UXo8fQPVlHmWcWfZHeK2dWPhZ4eqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9060

On 10/11/26 05:53, Jason Gunthorpe wrote:
> On Mon, Nov 09, 2026 at 10:37:14AM -0700, Dave Jiang wrote:
> 
>> One thing on TDX is that TDH.SPDM.CONNECT also runs a
>> GET_MEASUREMENTS of its own during the connect, and the kernel
>> doesn't choose its nonce. The kernel wouldn't hand that one to
>> userspace. Measurements only come out through the two flows, with a
>> user nonce.
> 
> Why? Seems like another wasted operation..
> 
>> That works for TDX. tdx-host's relay is one function today. It takes
>> the module's request from a page shared with the module and calls
>> pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.
> 
> Yeah, it looks like it works for everyone.
> 
> I sketched out this library, and it is basically half or more of the
> in-kernel SPDM in just a different form. Basically all the reply
> message processing and de-framing abstracted into something a little
> different.
> 
> So in terms of *net* code needed it seems like very little
> 
> But it brings forward "rust spdm" or something in a new form as a
> pre-condition to do the TSMs. Which is annoying for sure.
> 
>> I tried a quick version of the capture in a test hack with the TDX
>> Module It rebuilt the VCA, slot 0's chain and
>> KEY_EXCHANGE/KEY_EXCHANGE_RSP from the relayed messages, and the
>> kernel's own check of the KEY_EXCHANGE_RSP signature passed. Agreed
>> it's more of a debugging aid. Two things I encountered:
> 
> So you (AI'd?) something basic up to do the captures and showed that
> indeed the right data comes through and the general notion is OK?
> 
> That's great, it matches what all the analysis points to. I could find
> no blocking issue on this idea.
> 
>> - The DOE payloads carry dword padding, so the capture has to trim
>>    each message to its SPDM length before hashing. 1 was
>>    160 bytes as a DOE payload and 158 as an SPDM message.
> 
> Yeah, I couldn't belive it when my AI pointed to this. Nobody thought
> to preserve an actual length so any SPDM over DOE implementation needs
> to be very, very painfully calculate a length from the message content
> and algorith negotiation.
> 
> My AI predicts 1000-2000 lines of code very careful spec derived code
> just to remove this padding. Such a big spec mistake.

Out of curiosity - why that many? There is only a handful of SPDM messages and secure SPDM has the size in the header.


>> - The chain hash in the KEY_EXCHANGE_RSP transcript is over the
>>    whole SPDM chain structure (length, reserved, root hash,
>>    certificates), not just the DER certificates. That's how the
>>    device and the TDX Module compute it.
> 
> Definitely, it would need to capture the certificate stuff in just the
> right way.
> 
> The optional chunking features are a bit tricky, but I don't think a
> 1.2 only implementation needs them. They seem necesary for future
> post-quantum.
> 
> This also formalizes the version locking: the TSM FW cannot use a SPDM
> version that the kernel does not understand. I think this was already
> basically true, trying to do the 1.3 multi-slot flow is not going to
> work out with out kernel support to move the additional data. Maybe
> nobody noticed, but with this scheme it would be really formal.
> 
> In practice this means all the TSMs will need the kernel to tell it
> what SPDM versions it can go up to.
> 
> So I'm a little bit stuck here. Some thoughts:
> 
> 1) I think this removes alot of code from the TSM drivers. All this
>     stuff they have to go back and get the data after the fact, or the
>     thing that is almost like this in RMM, goes away. The TSM drivers
>     are very slim, just run their communicate loops.

It is already like this pretty much, is not it? Well, on AMD.


> 2) Clear uniform path to 1.3, stop after GET_DIGESTS, let userspace
>     inspect the certificates, continue with the slot. Again drivers can
>     be super simple, just need to pause at the right point in the
>     sequence.


The AMD PSP calls SPDM_DIGESTS first, then SPDM_CERTIFICATE (just like the PCIe spec depicts). May be stop at SPDM_KEY_EXCHANGE_RSP?

This is the order:
VERSION
CAPABILITIES
ALGORITHMS
DIGESTS
CERTIFICATE
CHALLENGE_AUTH
KEY_EXCHANGE_RSP
(secure) PSK_FINISH

> 3) The data collected and presented to userspace is perfectly uniform
>     governed only by the SPDM specification. There is a clear path to
>     adopt newer versions in the kernel with in-kernel SPDM that
>     instantly with nearly no-code works with all the TSM drivers.
> 4) This is about half of in-kernel SPDM, the receive buffer
>     reassembly, certificate chain reassembly, x509, padding stripping.
>     Each a complicated topic on its own. We always imagined having
>     in-kernel SPDM, so I view this as effectively free code - contigent
>     on organizing the in-kernel SPDM implementation in a properly
>     modular way.
> 5) Without AI this looks actually fairly scary. I can see why people
>     wanted to avoid it with different schemes to have the TSM do some
>     of the work. Yet we planned to do it anyhow for in-kernel SPDM so..
> 6) With AI this is probably a weeks work I suppose to really expertly
>     polish and make excellent tests.
> 7) There is clear overlap with Alistair's work, I don't have a sense
>     right now how close some of the parts in that series are to fitting
>     this shape.

You want the above just to prevent IDE keys from being programmed into the device before accepting the device in the host os, or there is more to it? Thanks,



> I will look more closely at Alistair's series to see how close it is
> already.
> 
> But, I am strongly tempted to make a draft placeholder in C with AI as
> a way to get alignment and try it out. Something we can throw out if a
> Rust version comes along.
> 
> Jason

-- 
Alexey


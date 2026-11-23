Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795432310;
	b=0TFpcb24OqCAk7VNTp/igkuhRDQUhsOuP92Rcqlv3X5gj9q+kc+SentW+aWkRzIAapWO
	 dSIKlYFDJHmBhZjiYvc928euw88i+i/pd/peCgqqFDf5jTVRySX14tdLj5efmegS4Zr9q
	 S4ZjQrKCieUZbaWqb79nTZRSnW1ak+V5AhEFcQ0ta9qSgNjHFt3rbV3J12wNx0zmhmpC0
	 aRHEIVxfog+PepiIzRrlB8kwmLa6qABtkHwx2ONuutG4J98N9nB/PHI644b4WA0rtmLss
	 wY4q55pmHyytrLRRir0BWHCfBGJZUXeYZhleLQGH6cmk8bKolxip4tgzyPMlPZmaM6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432310;
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
	bh=dOd1YJ9jOZ3fTNNSBLtfy+WuKxqS8EP1J4Mmz2wILvY=;
	b=M7O4hK3a0jTKzzsRwMZSfmq2qA9WgODH19Mg/LqK2WbEcZimz2UsQLfaqbD45ux48aOD
	 dRc4RVMbACnoE+pUfoPQw3gIuw+GApafZcAmZShwXTGPneEMq8dm4q/HH0cDYVP4hKY2Y
	 yVECeHyd2zfQTD6TUwteadUQtAi5PuxsAAWG3GLAedbn061gEMRRdUg96K5sZBUtKXmdz
	 3ObDQhLr9CHoSSuIXJSteczKG14qS2YdJnOwG8LRpn3AzMUdd+vIhub3qEhTFe9rhWirS
	 GNRD8cIX3vMYKQqRFa2ncCiYRQYvT5e9fkYrvduS1osxC+PX80kAR2QSJK4er7Off4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FnTNKdxQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.27
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC62606A31A;
	Mon, 23 Nov 2026 11:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BC62606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FnTNKdxQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wy7RQc+QCuwONaXOp//loSSXOJSoLv2TBPvcAS5Q7nSViZJUnIZTMXHt0TXz71HOJWtP9z4di+axBham/CJkUNgYGmXI8bPTbLlB25dusfvmaQfd1LAve4ZPOrzviw86oHM5PfxwHaTIQ65pQaYuzY8v0+Sh2SKvoRPF1m5z/TsulnZanl4ucbHZ6xtvi0W8mK6jZgCvESJOJHSp45sgCTuqgabN6Ow1mdi9+FHBwKSbrp0DWY2PXmIUpTYRFvcqljDuEzhzl8gamyC6KG51A2ejF7HULA6Hb/EwThVPjv2oKzwjBkAGu54f5gInQ8jBWoq+sMQeD01l60zzLZWPcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOd1YJ9jOZ3fTNNSBLtfy+WuKxqS8EP1J4Mmz2wILvY=;
 b=KB6+9DwGYDKIxJ5BBPUB5xJlGP4Pug/vkgGlJ7bfLW2Lh+V3VaRA47Ha73uWRs3YEBRMtwX3vhStlQngLo4hbnDV78DT0gQ/R7etpnwHjsMa9Q4UwaUIvf5iYolLhGSeQQx8YyA8QS7VM/OcWYm9sBXEZFGFCqwn565awXsg3AxFvRCxNW13Dz7P460Lg7lZS8MLjva0VyVVXVFL7ph+ACzUPymchkk2C15K549HGE35KT36rMqmdkfGOhOTPk66hesYj6M4y2jo8foz2NNi+hw7RYY9l3ccnCy+jVCysFu/cay7zy5u6qiIgf4ZWfCynTV0/Qm2q9HWS9xgPvOt9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOd1YJ9jOZ3fTNNSBLtfy+WuKxqS8EP1J4Mmz2wILvY=;
 b=FnTNKdxQ3p7cyLO/iVMWlc/EeUuJ9QWucyIux/huWUCeajQH8KdKW1xPlzpy3ThiDJLkP9tAeZV1w2Sw2NS7pjuYrNk6MH2xJSjW9i42TY9nc7Brflw7IuW9dEvmg1c2Nr+Tl+14JXWcIa7ni+LnYdRy7xhWdqnKpGmvJMdddFY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by BY5PR12MB4084.namprd12.prod.outlook.com
 (2603:10b6:a03:205::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 11:10:12 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 11:10:12 +0000
Message-ID: <8fbf4262-5e6e-4bb6-a7d0-ebefca7c1da8@amd.com>
Date: Mon, 23 Nov 2026 22:10:05 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
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
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
 <20261117011837.GG2245175@nvidia.com>
 <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
 <20261118134155.GP2245175@nvidia.com>
 <f68e71a1-4c22-433f-91c7-064f419ca7b7@amd.com>
 <20261119140348.GT2245175@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261119140348.GT2245175@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0056.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::18) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|BY5PR12MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: c1e5c922-a566-4d2a-ef1a-08df495257e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|56012099006|5023799004|11063799006|4143699003|261026121527099003|261026140227099003|261028144727099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261102123227099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	GsQypJuNYqdM0er+8j/Hec/niLmZ65ILryENjl9R56Awohl//pHbXv0dx2dOzD3LU2b7oT2QEHl52KRRK1AKOQGHtMRn408i5/F4Fnu+GNiGJl4hIMWwwM9HvhKZaFISovc2QvOHhwOy2OYpQLwEMwzDcaluwCCupl+PLdzaqm/PyMRXLgA3Epk0iY/ZhPS/DPzN+YgOgGatiQJR8/BRlK7zoaQXbSyw35uzW/yYYiaHBxpX7SeuuCiFWli0/0OSwMgZ8GEn7IsHOe1gfqlrTBTXs5iTlZEdG3lmW+SA4PuhZl1IBnta/UR0bRaJhvgnl1KKcrcFUUEHDEidXiuj4u/28aK70xHIacFmxiYcHhZ+e6WnSnCit7hksOCgjsOozUzhnIshiEYlXYHHve+ExZHbSBgXv2Qh31LbEAb4C/gBzq6JZEqq3slqi9XNl8HYgUU6HVz2AmV5SG3jqbv9da+XpXB6sL1qckXm1oVOS+GH0Qd2sP5gB9QbKcgKK+QQt3v5w95rwX8MXNufwGDpUhKiONruJn3ess/nblxPctFmcB/Lx0ki05WnCGmmD2O+KXVjg1uLgBcghLTJ3UgcdxHe06vabPoIJUfHRFJ3/oHTuwa5vZmINGbqBtM3q8gLqqvrl2N4zPH87mu8xSycX29xTxgCrc9oNmFqMNWy5C0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(261026121527099003)(261026140227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0JlUTBBUHR3V1N5RzZmRURITGtGZVRnb2tQdEJjajdtTm05UGhYZnFZTFhX?=
 =?utf-8?B?QXFsOFNsSUkxRzBTMjUxR2lrYTNIamppRW5jTWtCMlB6YVhTNjJ2OUtONFV0?=
 =?utf-8?B?OFZDdHdHUW5OMVA2TDlmUTdaZWh6MUtNRVpjZlpjU05BemtDTTNZa29yU0xM?=
 =?utf-8?B?VnRaMkdlbTg3YjZCT25rN25wc2xHNk1FTUZnNzNIaWxlRlFOOG5lU0RSRi9X?=
 =?utf-8?B?UmY5TTNXS3QrQ2o3Z1FyRlgvSmlQSW1zdkpvbmVRMlJPelBHcDBRb01Dbm5J?=
 =?utf-8?B?aTlMMS9YSkF4cEpkQTFjOUZVSlJlSm9tYlFQbHVCMmYxeW44M2tVN09Ga3pm?=
 =?utf-8?B?M09VU2N5WGJycERaZlZaSDN3QjVyNmV0ZXB1T0E4L3ZFQUgrRlpkRDVpSzVL?=
 =?utf-8?B?SXJQaUFtTHNKQ2lzQlF2K0c5dHNkOExLTU5mWkZKOTFVSVRva1NMK2NkYm1T?=
 =?utf-8?B?RmtINEpPYnBUMWlRM3M1Z01DNnhuL2sxSmw4cDFFQTZJc1htai84SEY5SFhu?=
 =?utf-8?B?UmpDL1NnNEIyczh6SStIYk1HR2RBOW9MR0owN3pIVnZPdzV4Wno4YjRLT3gx?=
 =?utf-8?B?QjF6Umt3azBTTm5oUUlZTzBhYlB2M1lFdnNMbTllZ0owTEk2WGJMYjc5U3BU?=
 =?utf-8?B?eUVESXppckszaUtSUWJEZWFHS0dMbXBGL09sbmVwdk54NTgyaGhrMVNDbUMv?=
 =?utf-8?B?RlZVbkJFVGdWMkF0Mk1TS0JPOGM0OWg5bGhrSzVTUWViMU5qYmVvYmVJQnRn?=
 =?utf-8?B?N3dRV2pHQnp1ZkdqRThMbG5BTFI1NnlBYnJGRzFZeDF4ZGdrU1c3dlZJSkpE?=
 =?utf-8?B?dHhVbnJCVjV4T3I4VTVNdWt6dHZoSjZZVmQvR3VxeTh0OXBrUkZ5RW83ckRn?=
 =?utf-8?B?dWFET1ZaSXJMZEt3UVl5VUkvNE5IYUpIN2EwSFJjcEUwcDVFNTJ1M2thYnZy?=
 =?utf-8?B?NkFSajVmaExpb1VZV2w1SUJ0MUlvMzM1L3lPY25KNjB2cFpJcmFieVQ2cWFK?=
 =?utf-8?B?ZFhPSWNQMkREM0hkVUFtZWVHckFVTkVIVUR5NWt6eFpSa3o0c0NiMDlDdW9m?=
 =?utf-8?B?eW9XL1RwU1NsaXVJWFNuWnREK0hNeldGd0dXaFBYZlhFOGd3TWsvQkhZYlpE?=
 =?utf-8?B?YVBGdzJaVlg2M3Rib1VRYVM3OG9BK1J5eEd2MGNpV2JHMGdGSUhVaEZ1UGxh?=
 =?utf-8?B?cjdqWFpCNnozT2FBVjgvWWlzdzdCYmlvYnM2NjZzWDlvbituUU1DOWNvU1hV?=
 =?utf-8?B?OFlTZVhqNTc4VFViWmYwQVI5c0RLWUJJTmNRWGdvT3JVTWRJSitwQVY4LzIy?=
 =?utf-8?B?cUtzVG9IbVBuMFdJUkFGREdhejBteGl2NUg5SHdzVlo2N3dwem9LZ0dTRFpx?=
 =?utf-8?B?TlpKSzhNQ0tvWVpVUzdHVTVPbHdmTVF5eDA5YnFPZTZQcDdKZm12aU5hRVdy?=
 =?utf-8?B?YzdLRmJaaGw4c2ZWN0gvWmlIc0NqNmxNbnZhTWhFL0NGbUNlNWdUb2hybWp1?=
 =?utf-8?B?Y0o1dzJhdVRCK2M2YTROWkMwYUo2cXNWV2RzYStvS2taejJocjB2cmpyeTBj?=
 =?utf-8?B?b25KMWlkVGNCZHFyaG9WeWFMUTVNNGlTb09xYXFBU3dUZHdOSzd4NS9Qc0VE?=
 =?utf-8?B?MGdtcVoxSC9QRHNNSWZBV21zN3BwNzRHdVF4V3F0VlBGUllwYW1ZdHJldmFv?=
 =?utf-8?B?TU9wQktzTGtSZmNpK3cycEZBQ3laZExvalFmdVJyS3pDdjk4UEFYSHVBVDFh?=
 =?utf-8?B?cG00L09xeFdmUFRzaG5UZHlkSTVwdVhRVWVmWWROWVlLNEFkNG4yNnR2UEpl?=
 =?utf-8?B?RVg3QnFwZWZicjhBWFF0U2trbyt0NzdLMklNM090SGhXWG5BK0pxNnFHbzZE?=
 =?utf-8?B?cW0zVWZaeUZ5Skt3Yis0TnpQT1dvcGJzRTNEVnZ2anFMVjBWdTlhMUFQb1dz?=
 =?utf-8?B?dk1uWDM3OXJDWkJsNWR0dUR5U3hlMm1FZkhRUEIxQjNTOVR1QXZWMXljbUk0?=
 =?utf-8?B?WEUvNzYvVE9XRmg3Ni9rbTgvcTBGQVJXYmhQUVQyemdCVm0rUjFwM0JTQWNl?=
 =?utf-8?B?Zk9wUnN5V0s4MGN0WXdObW1paFRYQXNWaWNtNjYzb3JZNmZJbE1mM0xiaVFy?=
 =?utf-8?B?ZmFTYVdxM3VLRVVpSTZYbE9weEErcStpRjRQSWRVS3U1SE56bUJkblpjYkZk?=
 =?utf-8?B?SFFST2w2UTgweHREQ05zN1NCcDJ6NnNVa3E1QXRJL1dtaU1OT2RYakRrSUln?=
 =?utf-8?B?MzZWZVQxOGJkdWswS2FHTmloS2VhdmF1bFRjM1ZoUGszQVJmdHBUUk1XQkN6?=
 =?utf-8?Q?dZoGnuU0YJK0kBm2hK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e5c922-a566-4d2a-ef1a-08df495257e0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 11:10:12.3016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fs1g4WqgzX/l8XghauBHEwhTWI7QF7rcnYPXtMDmhWrDecY45ahbgcM3+dW9Oyi08MMKVtDmMpGQwfPnKJXrNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084

On 20/11/26 01:03, Jason Gunthorpe wrote:
> On Thu, Nov 19, 2026 at 01:19:22PM +1100, Alexey Kardashevskiy wrote:
>>> and worse as soon as you DMA
>>> enable a hostile device with ATS you loose all security.
>>
>> ? I'll set vTOM=0 to make all guest RAM shared and observe IOMMU RMP
>> faults if the device attempts accessing outside of shared SWIOTLB.
> 
> A T=1 ATS capable device can access all guest memory by definition, if
> it ignores the ATS protocol and directly issues translated requests.

If my IOMMU is configured as I said (vTOM=0 == treat access as shared), it is still going to check RMP, notice that the actual guest page is private and fail/fence. Only accesses to what the guest made/left shared will succeed and that is SWIOTLB. Thanks,


>>> So we cannot have a model where we accept a dirty device and then try
>>> to undirty it. The device has to be known clean before we enable DMA.
>>
>> SWIOTLB does not accept the device, it operates as untrusted legacy
>> device (which has parts of config space locked), we allow that
>> now...
> 
> Not at all.
> 
> Once we have got to RUN and issued DMA_ENABLE the device is now
> expected to only issue T=1 transcations.
> 
>  From the DMA API perspective, and in the IO fabric, this is now a
> trusted device that can potentially reach all system memory.
> 
> If you happen to have a vIOMMU in front of it then you can use
> iommu=strict and an adversarial hardended driver and maybe still keep
> it 'untrusted', but that is a huge thing to ask for.
> 
> Nothing to do with swiotlb.
> 
> Jason

-- 
Alexey


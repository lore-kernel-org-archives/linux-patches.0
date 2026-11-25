Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795577460;
	b=xbQl2xnwbhJbgcB4rP2pA1BR/RHrCmPnwkzlNB3VCjYhWvhm1bsb3+WAISVuTdCe7o1C
	 kUMyGjPp8x+jxvv2NvRATVi9FnAZ442HxCGcVXQ8DtYmFPNYC1MaqCUsiwMTVYR4eDmeg
	 lNRk8St2O4kZI81dt8VkLvMtTRyXumfzGMtQjOP71VOZljzu9wq1ZC2wIV3TX1kUYZ9is
	 i0AJa36g/TkkeX+6qzGWGZSHxK4WoeJw6wD7gOep7ecUI2YLapJ3LuO2qpMZnly4ICP0m
	 AN0bPXQWmRoIxNpHCUM8B+8tDyBh8fKpzfI17j+pGRLErAsurgpPj0E0mJyulZUz4Dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577460;
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
	bh=ftLYavOSZFS1lDJ8F5pLiytWF3tJ/P4tIHYMRcZyE+U=;
	b=GMqQ6jfGWoTUYJxtR+6xpokxUJqAUcSCl5g0cPe4eyNeHGlsgXPm4WDVSK3E/Pm3MsrH
	 eGWlhiCnWXJXrWohiMllvMiVgrEM7ml0RIVjc9CWJXTh3+t1XoMISxmsyvzGRbUg01ffy
	 FOzO6d15jrGdYQmCyKY0pYM2mYlnGf96Kq/UWu5A/d7RdISrW0sZuGabHZVduvL05D2nc
	 bfJ/winhi2VTjjLuFTRzyXEXkjYmVyXQYFP9xJyByR2rD9knWzEierkvsAKGWWH9ahHPf
	 HkbDvKVJc+cb0i08t+nKy8sYhxMKQoW92ci3SQegw9PkKGfPmWQvSE9ouARw/7k09sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="Jme/g7VP";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.62
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E25606A31E;
	Wed, 25 Nov 2026 03:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82E25606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Jme/g7VP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJMy1C6zF6LVD+Je+JgUiIiiAOFz6Efy6pYaNq3gwMo3mDki8sjfK8PohkpTRyLHsSv4tB8le1F9v2hhpFeaxVzy6CveyZa5WDVGSrZaDqd6NKmTHsuponmaH2QUlUnT47VIyYVYWXReLvyHkDDm2+jsRVkW2BWcOCUUPlV2auQJqnhn6yYvahXtHUTcTbYAPzgW1be4A9lvznDaIpQoWs14P7fkZ2DMlrhkVGsb/l5BRXNEyEb0L0u60mb+zZUndk6jqr8PbzL/UxZ1GBHJKKmG4JmsN8BaT5qO5qC/igbxVVbzrs3uZ8hIbBLnMXOVrTkwGKZNE9aIImuylDCv7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftLYavOSZFS1lDJ8F5pLiytWF3tJ/P4tIHYMRcZyE+U=;
 b=oxZI1BkVr+ZsPbgEEM1ZBFjuN0Rglr67sYW6/PfJyiaPl35I/PK0G5qCBQIOFM2E8rU40GYunfJWtYiRQfZG9zKXUtgnW8t86a37w6DV1y9m42ZU7JNZHBF6JAkRZCQsTulU/LWAMiVP5k9GE/DXINp4TmwOQMbwS7qdX3W8vC7KSnOQ+FtVOCaBGEFbr1jFzIhtbDZCTTJx34atW3C+wDEp9TxU8OO+4FGD7lZiIe6WruI4LIm1HbqecvtwpLPKQW3whFpuCCLbF76v114jdlIgQV3KUqkJHG5pMvP33Dpyfww/tqCe/QwCqXNSrmD+zPOd2eywK6YGeBuVthi8cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftLYavOSZFS1lDJ8F5pLiytWF3tJ/P4tIHYMRcZyE+U=;
 b=Jme/g7VPOGWEPlU+FxQ/8eiJ0knq83OE8Snf+fWmNiqw+2rXz2dnLWJRqVHRj52g+DluWHk/THM1cxzsq3PzhWL9mTSSGuMzPUuxyQd3vG/hA5LAdOQZFgxDYPo6vrB0fwBg7/4oC6yPxrNuk73Y6HeELcwSEoKhoYnQ2WECXH0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8) by PH0PR12MB8151.namprd12.prod.outlook.com
 (2603:10b6:510:299::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 03:30:54 +0000
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408]) by CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 03:30:54 +0000
Message-ID: <25fa4ffc-96cd-4851-8ac7-dd3750b71f15@amd.com>
Date: Wed, 25 Nov 2026 14:30:26 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host
 bridge
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
 <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
 <20261124024842.GB9566@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261124024842.GB9566@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0115.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20b::20) To DS3PR12MB999215.namprd12.prod.outlook.com
 (2603:10b6:8:38f::7)
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
X-MS-TrafficTypeDiagnostic: CHXPR12MB999219:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 25852d18-e9f7-4d7a-78e2-08df4aa4828d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|6133799003|18002099003|22082099003|261009223027099003|261021121427099003|261021123027099003|261021130227099003|261021135927099003|261026130827099003|261102123227099003|261022105027099003|261026140227099003|261026121527099003|261022115727099003|261022113327099003|261022075727099003|261028144727099003|56012099006|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	OP7aEvPQgp6TzeQAE7BdZzynUDXqXVHExcCbead3PIPVFsF9Cm9vo1CUX9jzLmzS/4AHIe4ytF/2RAqCNh3EEC/1c+OxlOX3fjAiyljVIu2nXS/MILY915zoZnOaWyGtWqz67lL6Dxs7kXRBUccgBppHJAOvp/Rbq+RFLuZQfy6/VQPMDmwcE78PactYVVii9PnkrhfPPwbwVGIYr+tZi6vQYkplrUsCEjDGdnevaQ30Y2+25vlyyoFlPG6kWQWyBq/bTsrdFszE2bAjeCkHFOHV89kJPghnjWVgzW/ftRSsUaS6J6Hpa1SJillzUf9uP6azlNm+6K0P5x+hnbADT8hinrrRlE5EsLaGfqSM/ggHHS8LlaQGoGI19Fb8zOIAYiFubBRKwevO0WlTnr8OTqabCmK7/NXDmxq/bHJm4wU+ngTfEXnfROxp3ZWhlCLMcyMCdZY5VpDgS/hdATDZC4cymPbYONmNYakoJYiNTmrf+xJZYyFrJq0nucD9IdT2+HWt0ogX40HnuKEJe8EMUMe9KjQt2Ot6sig+2loD/HBbRSKLwgBLeNLdZETPQX83DZOPPEhRMUc4ttHMNWdPmC5vKuzxeTzOcm9hjELipFQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999219.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(261021121427099003)(261021123027099003)(261021130227099003)(261021135927099003)(261026130827099003)(261102123227099003)(261022105027099003)(261026140227099003)(261026121527099003)(261022115727099003)(261022113327099003)(261022075727099003)(261028144727099003)(56012099006)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M002cTFzM0tTTzZCaVpYL01pTUtvb01uWFE4RFdhMlRUZ3IwQzhhUGZkMEZM?=
 =?utf-8?B?cE93cEhOQ2kvRWltZm9ZWXhmRlEzOXhvS2kyeStGNThjdmhoMHk1OGJKeDRr?=
 =?utf-8?B?bEVoUWVBWkg5OHFQbWxpSTExZUlUZHB4Njhuc1FibHRMdUFraGg3U1h1R3U1?=
 =?utf-8?B?RW1zb2w0SEpIdUFNTnh3bWMwL3Z2cmFyRnBSOEkxM204LzBHWTY5QVE0WHBZ?=
 =?utf-8?B?QnJxYS9nd1VWbjlSYmlTVUdlMFpTRE9iNU4rQzBQNDh2Z3EzeEJpcDE0cUZJ?=
 =?utf-8?B?WGhRWUcvb0dNRlRuWllCZjZYZW5sb3JFWkRyekQ3RkFzYzR1cGlzMU1vWHFJ?=
 =?utf-8?B?VDd4QjNRNjJWclRYMnZIcXBOTGJQQUxaU1N4cUIyVmM4VG5QRk5WMHBjelF3?=
 =?utf-8?B?VS9IcHlXeEdyK0JYam55T1dSVUtyZmJ6VHViV0t5cWdub0MxTWRNZ2ZCdHlQ?=
 =?utf-8?B?alZQRnJCbjdQQy9JUUdPelI4TWJISDVlbml2NjVLNGozVlQ1OFd5eTMrN0l6?=
 =?utf-8?B?cTA4QlAvNlZZY0pINzZjR3ExSnl3OWphdlF1OWZ3bis3cGZ1cmFIN2VPWUh0?=
 =?utf-8?B?ejJoQXMwcVl4UElMSFdMMXhnenJHdDJDV2pYMVFjYXdmL1VWK3V5Ym8vS0Yr?=
 =?utf-8?B?RUExVTZnRDZGbkdRZENoME5iekFPR1Nlci9oNWlXQlNOTjRTOStUdmhuT0R3?=
 =?utf-8?B?dmgyNE51MFVjTDd1dmk3NU5KTkIyOHY3SDY3ZlBNSkNyTTIxQU9RNmdMelEw?=
 =?utf-8?B?SUlRdHFlMXozcTEwcUVVNVIzcjVJRTZHT25helJPMENQN0wzYnQza3hoYU5T?=
 =?utf-8?B?bXBYVnhDN3YrNW1KVHcwZjVJQS9HYlV1TGNGcnIwbmxyUEw1Zk5USDZMaVBP?=
 =?utf-8?B?RnFvbEVXNVF2Q0Y3QUdoS0FxVDFHaE5XYks4cEhFVUhObnovRSs4M3dBWDYz?=
 =?utf-8?B?aDcyZ3AvMUZQRG8yU1dkdGcxUkFqUi8rOGxJbHhlaHc5c3RSQ0swcnRzaXU2?=
 =?utf-8?B?WWVjclhmVnMyVmJDZ2JRQ2d0dDVuQXpxaDI3TktFSFhHZmhXL3g1ci9ERm5R?=
 =?utf-8?B?U3EybHJXSHNsT0J4TlZiRWlZb2w5QXZpS0lDNVkvMEFKRWI3MGxCYlB3d3lj?=
 =?utf-8?B?REhmM0dua3V1UzVOcmlTT2VCM2h1d3Z5QjN4SzMxbGtHOHdmL1N0aVhhaHVI?=
 =?utf-8?B?R01CcnBMbzNUMmQ3Z1VrUXpzbFhlYVRGR05TbmNYa0FaTHZNT1c3eURXVzQ1?=
 =?utf-8?B?NmhUNDViNU1ESWJZYmNLcVErd1JscFBkZ0FRNG9nMmF6bGpkMzZiK2YvSlFl?=
 =?utf-8?B?eS85WmlCS201b0x1Y3R0Zk9tYVFqQ01aSjVnQVg3dWV4VXJ6aHlmL0FVbHRW?=
 =?utf-8?B?RFY5VHdPYnErQmhjalhRVEU1QVgvOERSWjViR1RSejZwaXlNaXdPbFlDYlA1?=
 =?utf-8?B?RTVRbjNuYldZRVc5QzBjQ1RoZUJhQWVWVzRaV1pacUJUQkhsanFqWGNlS3kw?=
 =?utf-8?B?dXdKRFN2WG91Wm1NbmpEazlPUEFLTlA0WkNzT3FFeFY4Y0RFeHgvb0p4cDNv?=
 =?utf-8?B?OHlJUUcyS1dyRmYwdkNBcEI3ZW5EeExVSmFVRzVYcUx4Z3g5SDRGeW1NZGNC?=
 =?utf-8?B?TXVhMDdFeVRHc0hrbEd3bGc4UXcya1FTTXRNL1NBUmI3ZTNFQ2ZBRDh3eW95?=
 =?utf-8?B?N2kvVTJCZXJJcXBuNlZsUENNQTgvODhZcE0wZExZN2JVZXo3Vnc5djdBUVYw?=
 =?utf-8?B?VjZuVEd6NGZUaWNSZXpSNXNTcnVlOTdXQmdpV0RsN2VsRzlKaVA5Rk9KeVI1?=
 =?utf-8?B?aWtndzBDYjlKdW56MlVIL0V2Z0pJa0hKVEtRL2tJL0tXdmZENEVZK0JXSHdQ?=
 =?utf-8?B?VGhCZlZqNVZQVk40eFpKeE5VQlVFYnRaZEhpQXZhNGd6K3hyQU9SY203bXg5?=
 =?utf-8?B?WUc4SUhmNVNzTml4akszQmM5Ui9ydUF6bHJmNG0wWmw5RVp4NXRpdFU2THNt?=
 =?utf-8?B?T2FVN3ZObDBvSCtadUthTDNtbVAvWnI1U1MxeDc2NEk2WVZIaVI4SkY4cW9S?=
 =?utf-8?B?SXF2WWN2bXoxcVNqQlUrUHFrME1DcEVKM04wMHdhSXg0aGo0RjdhUDlSbGNE?=
 =?utf-8?B?RlFGQTRYZ05oYVJNbWhYU2RiT0ZCdW1GVDNXek5Yd3Z5emlHSm55VkhWNFdz?=
 =?utf-8?B?czZjbGVQK0gydkRFMTVnalB5VnducnFmNVU1eHRqbVAvTDJnajFmMm1yMjlU?=
 =?utf-8?B?TkM1MmFqc09ubnYxQ3gvYW9nZjF2TERiaSt2TG1Ka0R2NEpJTlBLVkZWYyt1?=
 =?utf-8?Q?OZ1HMcZFcMBZ9yuw10?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25852d18-e9f7-4d7a-78e2-08df4aa4828d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR12MB999215.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 03:30:53.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZUg9pBg5uA6BEjKTX0HzuKRBHyvw6LC813LdraiAua1OYevQCfb6F/hH39t7V4Hu17wsnZM1rhayNL49QvZsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151

On 24/11/26 13:48, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 11:11:49AM +1100, Alexey Kardashevskiy wrote:
>> On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
>>> From: Dan Williams <dan.j.williams@intel.com>
>>>
>>> The first attempt at an ABI for this failed to account for naming
>>> collisions across host bridges:
>>>
>>> Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
>>>
>>> Revive this ABI with a per host bridge link that appears at first stream
>>> creation for a given host bridge and disappears after the last stream is
>>> removed.
>>>
>>> For systems with many host bridge objects it allows:
>>>
>>>       ls /sys/class/tsm/tsmN/pci*/stream*
>>>
>>> ...to find all the host bridges with active streams without first iterating
>>> over all host bridges. Yilun notes that is handy to have this short cut [1]
>>> and from an administrator perspective it helps with inventory for
>>> constrained stream resources.
>>>
>>> Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
>>> Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>>> ---
>>>    Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
>>>    drivers/pci/ide.c                         |  4 +
>>>    drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
>>
>> I'll take to the tsm tree, thanks!
> 
> Lets not take any new sysfs APIs please. These all need a careful
> thing and we are not having a good history right now on any of these.

hm okay.

> I'm not even sure what this is supposed to be for, is it debugging?
yup, pretty much.


-- 
Alexey


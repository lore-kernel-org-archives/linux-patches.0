Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794914247;
	b=JNXaumaicbwkbCrbhwInmG5paTgH/ypKwHGtboQBkNH9txXpFPUwb7CU+dkRWJpzIEkJ
	 5BnvyzZi95jdx4jl67lcLZQATi8rgyZF3M9u+YpWLep8mUsnsdCUgt01oAoqKYUO/GSic
	 j+B77thfbMBbygtUJaQWutaBMXVooCxQTrYgHcIu75ebFxhPMclfBfSa/tuJHKOoIMSLO
	 VaYZ88E65uRnh489tYeML0dqLpUfYRiMee6ZzypPPYFbQXL+qcZ7jZlYIFEyYEraz3roU
	 StQ5AApW8BRrfdps58EEgBn5ILUdwsoU0r78yJO3vgREfEE6o6ANuuYJoWupZw8wLZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914247;
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
	bh=7pcFhx56zhG11M9lusbdAY4JL4jprUhRRV5rYx1+i2I=;
	b=uIM5bW5URNPnnHBd+69EGLmQn8GE93c5gpgP87e7FbQ1Hy+IAmpjOvr7rqRaDVUPVRZZ
	 1ua4Mq/C7lS4GWv2AO46yudPEKOZR7TQNuJZaANaV3Obf1+Jhyz31jWoTU6oVYTRRnL0b
	 fQ3O4yTtLh7d+SseqDBA8Yaxf9as2652V+0cVwtC+NLKw7JXwcoeu1TyoqpX7QfKwKixh
	 mD6mhP55KA42Isio/ny4OwBpqZQXfzw3fQleabAAT8IXQovE7LjvsNCJ3Uhtm3SD6tUia
	 TmoFi6xASSSPPO2XhuJVpFXCz31GlmrJRGLEk0bHJSqd8AFADaNokTel1itWjVhp1Kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LO9SpBsX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482D606A31C;
	Tue, 17 Nov 2026 11:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6482D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LO9SpBsX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/9LLbZLhAo8WxcGPZBE7Ae+GEOLP5T9SOMl3DvAgs1iAOQab7yf/j1X4hDfwhoBydm0wdsafFcJf4xxyAUZLH2VTn0XEZ1nFvK+fOM0/2Km8tSjIpVB4SorMKooQXoCBWdcgX6XdET0p+x8uokzvCcP+yy3MGJ+5UI9cdpnKUmd2ZS1aH30Z+qBBo9i2/pxlp+XDzehibIzmfvWMYkyQabXD8qgeBCxypC68TVzZ9khbIfuwHumtH4dhMEbRoKXNi+ZPPPaxgrEn/GdqnAPBCBqDBpgUq4j+IMQHR/bwiAGPcgSxFAVRaMfmalAPHUojFN3rf3MMMEU0ZsQ7Oxz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pcFhx56zhG11M9lusbdAY4JL4jprUhRRV5rYx1+i2I=;
 b=MaDqkiHBhfZ7dhbh9S74srt419z9zbJ3RIDVbjvTX+YAWxDPT6qh61HDNWeO1B4jsmAVmeKcNGdhKpRF1l7/oxa9snRuGAVuy3Ssy9oE6vNKd5/DPMfDmSDU8v4zbvSYBG8Dx83aOjjDoFIHkPkuiU/w0u3LQXGeGUIfOUYymIz9hmnDZjw2SZU+2lhsV5Opk3b1zlXJc7Wrj3QfNBOnQkdtpOpIGCgv5PEnY+QiFG6Z000maqYVaO5E4OIaosrRWj3hwCPAD6j0ZCF3czfDJP4x6Q/kBL/eQKAhtFztbB6uefH2sPC5/nVpe5S0BNxKlJFvDl5YYILq9xzE4HvKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pcFhx56zhG11M9lusbdAY4JL4jprUhRRV5rYx1+i2I=;
 b=LO9SpBsXq1b+3DLlTgWcSZtpxU/uEpa8J1W3TQ5OcBsAgPSC4QveyqFkpPMNDeaJ29AolSACmS80H5jAmN1VKBZ48wkM6fv+tZ6JFfE5P56q6REFo9SKeJo9QqoxZoiFJml6mMdDbIncq+anJfYruh8jDXsxf6+vity9bHja5Mk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by LY0PR12MB854252.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 11:17:21 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 11:17:21 +0000
Message-ID: <53ab900a-8a6d-49e8-ac69-3b2d1130b2db@amd.com>
Date: Tue, 17 Nov 2026 22:17:14 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
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
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Alistair <alistair23@gmail.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261112145254.GL738765@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::20) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|LY0PR12MB854252:EE_
X-MS-Office365-Filtering-Correlation-Id: 32904a31-8059-4bb7-095e-08df449c5971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|6133799003|261009223027099003|11063799006|4143699003|56012099006|5023799004|261102123227099003|261102130727099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	H3MqOm9lkb2cmM9SagVsKodiKWinW/5br06Pigf+ktQLad7ovJoBVir588NA8AMgWWhNvQjLGJ0uB94oI054pAUpyctdNG1Z9YacHZG331Vra5zfpbSnEDMmpOd0+vTloZkBMV0HRanwvK/2wbayEIT/moTwsoilLnAa9CLIBySb5E1T8R05630ABCZV3w7+5ICkFh/FeF/Hl1w+luDFxZ5x2rxgigFFxJ1r9wgIIWjnu/I2ZaKW3uqSWVdvAoZmznAFT+vgmPsLb2Ql7X1tqJ36toJ4CBV+/91kU6zJnf+a+118tJ8oYp5nuWxFtYd8UNDVkmLDQrhaDwuL/lQbktqNTShun5OABTcvQyeF5q8Td+BLfqXj8dybGbfBep4wdrme6ZmBcbtHJ2GkQkszK93CAn9pUEG3g7pVn+CTvxA77HoNEzUKzxhC20JXwjpSICIs4woDUrN6sjmSvV877CS3Z7UbQE6pI6y9LXHb79c5K/0wQ5SCCrjUqSU9F3VNAMhkAn4+RyvTMc7Jjot2pCODNg1CczeYFlynagI+rGkPSDYFEDvX8Oe/chZNldTzWYlLyRZRV2JcqflXPmpTEHGM1B2gcFJ0FAYMA2AgUQLHPPKeGMQ7pdQQh4kPfSbg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(6133799003)(261009223027099003)(11063799006)(4143699003)(56012099006)(5023799004)(261102123227099003)(261102130727099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnlKaW9QSmUrZlErcVlhUk5jL0MzTk5INmJmdGc0cFgzMm43TVRIb240OSt3?=
 =?utf-8?B?SGI4VzhtQ2g4Q2puUXBPdHFMYkRUTFNSMCswcThRck5ISnAvSzc5K2NYUHFC?=
 =?utf-8?B?YkM5dytHdkJseFFkeC82cUIxSWFvN1d6bGVpWTFuYWxqVnpvZ005RVc0emty?=
 =?utf-8?B?aXBQbUVHVW0rZC9KcVJCb1lJaG9iTmhFN1FwYm1PK3BBS2FPVGZFZUVSTHpW?=
 =?utf-8?B?RWV5WFFzRXlwc2ZQWGVENHErcGVmS1psamIzd2lHNnkwcHZNUlBPSTJQYlFN?=
 =?utf-8?B?RnVWenJEV29FOVlXT09seTErT0tWUWRBMW9WMEQ2WXlZcmV5OVZHNVFvN0x1?=
 =?utf-8?B?UVlQSEt1cTdJdkJqelJMcUlZWnlNWHBOR1pvMHptTGJTMnhVK3pVTG53L1lI?=
 =?utf-8?B?VWxZSWZpejRMbE1JMElPTkQ1cUVhUmJ0UE1mZzZYVEJadW0rbldwSk0yZUx1?=
 =?utf-8?B?Q3FFeUMzMzZtZVJ5YmVER1NOMy80RVJhaFdQQ20zeTlXYjZwV1dKbGVjNTcy?=
 =?utf-8?B?SkU5ajZlblJXVkhLVlNieFZFSzFZa2R1dWhIUTlZZmhSRkJIR0ZTK2NvTSs5?=
 =?utf-8?B?YkYwdW1yMlVJV3ZoYjI2bWVQRkdCZXNiYjIzQyt0dWxkSXhPM2JWU1Q2MmZU?=
 =?utf-8?B?Vm9XNG16bnNiazNzMkk3NlVMMDJvOXVya2prU2ZGSUpvV0F0QTlHSnltZWky?=
 =?utf-8?B?YU5oZjdsU3FSZ1NwTVVYWjNjMjMzMFdKMDFaUWhXbDU3VlJENWVISFRBNGVp?=
 =?utf-8?B?MGdMZ0lVc1c1NkNvL3ZsSU9KZFc0Vks2TWdtcnowSmhiTkIxUTNLa2E3cTk4?=
 =?utf-8?B?ZTZKcTA1eSt1UjBNdGNPMHVFMTI5UVF5R2ZaTS96UXNzVXVHdGdTNXljWVM2?=
 =?utf-8?B?QUwyTlpjZ052allZYnNDazYwc1FVQnFyNFpldnRpUDhaMnc0THdjVDZRM0xR?=
 =?utf-8?B?cngrKzlMY3QzTy9pTUZqQ0RpTDFIckpRT0dhRkVDTUFYTjNMdFVMUkdUSnhk?=
 =?utf-8?B?RWdoS0MvL0ZQb0JhRGcxakNMYmNFV24zWDRrRVNPcWdlaVdaRng1VFZaTjVl?=
 =?utf-8?B?ZE5FUnBuS0tIeG9vZTdBbXQxS0NSRUdnS1dVNVFmU3BLWTNmaUZoa0hPNHVz?=
 =?utf-8?B?SFFqQUt6VzhpTk9FbUtOUDdmOUdGQUpJakpwUlQwaWU5V1dzaWpQNUF6ZEZI?=
 =?utf-8?B?Mkg2YUdXNVhPWkdlMWVTR2RqR2tlc2hyRWFkQ0xzNE0yaERXaVpnWkIxMk85?=
 =?utf-8?B?TE0yWHVpYm1zOGVxZWRRa2Q4Q2MwZkxOR2FtZFhIaUZxbE9YNEN0MEhxUHFu?=
 =?utf-8?B?UzhjeVRFTXNnZWNoZzVjcnBlS2NKZ2NKbGZNWWV5ZmdXSXY0QVRpNFFtZ25r?=
 =?utf-8?B?Q3NZWGVlTHZyaDI2eE5uZ29yejlOYTVLdEpkSDdBZWk3TGZRRXYweERZSnAv?=
 =?utf-8?B?ZHJ0UkZrWXpJdkdubXJvU0JFYW1KVEV2NmZSd0JEM2lxSjBoaHZFbmFUbGdR?=
 =?utf-8?B?RFBQeXp6aWwwUHNhOU5rWU9EcDVDT0JMZG9qVjV5YmduZHBGTEFGNFJQWGZP?=
 =?utf-8?B?c0JHY2dITjAzRWhOMHFEaEN6eEpwRktwZEJpemtjN0ZBLzh0enp1Y2dSRSth?=
 =?utf-8?B?WmNTcXZELzl0WXh2VW5kTXQ1dStoZXhiYmhYM1J1ajFIL1ZQOVN1WVU5VFo0?=
 =?utf-8?B?cHVJUWFxb3Rwcjd3T1kxcVMxbWI3SzRKZzV4bE1lWnpoeEtrVmtCeW9saDRv?=
 =?utf-8?B?YkNKWVdPVUptdlE5eXFMMm5qZFY4OW1Fb1NFaElWdy96V202TEhWc3Z3UFdK?=
 =?utf-8?B?V0xZVGhQMmd6S2t4WmtwQ2ROdjJtNlBYc201YXVVZXVnYVYrN3g5SlV0M202?=
 =?utf-8?B?RTlQWnZUcUpUcDFXeitNQXQ1cFp6RWVXMnBlbDA2RUlNM1VtWDUyOE05c3ZL?=
 =?utf-8?B?S2kybmIxdDlobm1PRWI4MDhzc3JIMVRqTFF0L3U3c1E0UUEzbXZ0QThoRVZj?=
 =?utf-8?B?TVpGWnhTOUhCbkhWQVJpRTIyTzlxMjhRU1pWRzVUK1RoeU1uWE1JZkd2bmFJ?=
 =?utf-8?B?cTlObndXY3QwdUZPbklaNzNtUnJ0eFBNbTBpZVVXa3pyV2ROM2lhWDJGMEFH?=
 =?utf-8?B?N1FockVvYXl5UFkwbnVDQUxkT0UwTmVRLyt1YzF6NXJHd2VUbXJMOHMrK0NS?=
 =?utf-8?B?MFRqTkVoMGpYL29rQjhXTUpTaDZjeUx5cjNvQXh5RW55RGRKOWNCWW9KVnJS?=
 =?utf-8?B?NDBMZnlNWlJXSmF1VERwUC9ESVpHWDJZUThXTUo5bE0vRnQwWUd6S0JEOHBW?=
 =?utf-8?Q?U9P4x65Hv9m5WAMmy3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32904a31-8059-4bb7-095e-08df449c5971
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 11:17:21.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfJISf2XjoBnCe71ad27WZA6rIwzXeE9F9rzsqsun5RwgGaveo/imUCF3IWDWbhI6+PbnRkzLNmmjgSHUVfknA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB854252

On 13/11/26 01:52, Jason Gunthorpe wrote:
> On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
>>> Like a whole bunch of TSM FW API just to do this:
>>
>> Can you help me understand why we need to snoop the DOE messages? IIUC,
>> the earlier proposal for 1.2 was to use Rust SPDM to perform the
>> following:
>>
>> GET_VERSION
>> GET_CAPABILITIES
>> NEGOTIATE_ALGORITHMS
>> GET_DIGESTS
>> GET_CERTIFICATE for all slots in the slot_mask returned by GET_DIGESTS
>> CHALLENGE using the slot 0 key (At this point, we can also verify that
>> we received the certificates for all slots supported by the device.)
> 
> At least I wasn't proposing exactly this.. CHALLENGE ideally has to be
> connected to KEY_EXCHANGE, ie they use the same nonce or get digests
> is hashed by the TSM or something to have the full value that 1.3
> brings.
> 
> I've also been told that not many devices are implementing CHALLENGE,
> so this may not be that useful to invest in..

I've heard of those devices too but never heard of devices with more than one certificate chain btw.

> But the main issue is we have to use the TSM to initiate
> NEGOTIATE_ALGORITHMS because that defines what the contents of the
> slots will be, and a rustspdm has to follow the TSM's selection.
> 
> So, any version of this flow would require capture as a building block
> anyhow, and you have this awkward version where TSM does all the
> negotiation then rustspdm injects its own messages according to the
> TSM selected rules.
> 
> It is possible but very hard, so I think we should set it aside. This
> is something to reach for if the vendors don't want to agree on FW
> changes as part of the 1.3 upgrade to improve things.

>> The host then select a slot and use it to establish the IDE connection?
>> (For intel we can only select slot 0 here?)
>>
>> What does snooping provide in this context?
> 
> Capturing the transcript makes everything 100% perfectly consistent
> for everyone. Userspace sees *the transcript* as defined by SPDM not
> some mangled, truncated or processed version that the TSM decides to
> provide.
> 
> Userspace gets to see KEY_EXCHANGE which means the verifier can prove
> the certificate binding, this is the ONLY way to let the verifier do
> this proof if it wants.

Say, the guest userspace can see the certificate chain and the measurements signed with the key from slotidX used for the session. The PSP promised it is the same slotid. Which part does this verifier not trust?


> Further with capture we have a nice primitive to pause and do slot
> selection before going to KEY_EXCHANGE. If we know the kernel has
> capture then the ideal FW design for 1.3 multikey is much simpler and
> clearer (more like ARM).

No CHALLENGE, then we read digests and certificates before KEY_EXHANGE so the digests won't come signed and you stated before you wanted them signed. I am confused.

https://lore.kernel.org/r/20261110125202.GD738765@nvidia.com 
> Also, ARM decided to do capture already, but directed by the TSM.  I
> think it is the right and best idea, they just made the implementation
> too narrowly specific. eg it doesn't split up VCA, it doesn't capture
> 100% of everything to get KEY_EXCHANGE, etc. Trivial to fix while
> upgrading to support 1.3
> 
> Finally, Intel actually seems to need Linux managed capture (Seriously
> Intel, WTF?) as they don't have any other way to get the VCA, and
> without the VCA the measurement signature cannot be checked. I hope
> they still have time in their spec process to adopt the ARM approach.
> 
> The ultimate goal is to get *consistency*, especially a consistent
> uAPI. The second long term goal is I want the guest and host to show
> the same data out of the same uAPI for attestation. The guest should
> not have an inferior view.. It will take some spec changes to get
> there.
> 
> I've now gone through all the exiting choices all the TSMs have made
> and here is what I'm thinking
> 
> 1) The uAPI presents a transcript interface, every message and reply
>     individually presented to userspace. Perfectly future extensible to
>     include GET_DIGESTS with 1.3 and whatever else comes down the road.
>     These are consistent spec defined message blobs 100% the same for
>     every single SPDM implementation and TSM.
>     The kernel will start with a partial transcript, but the API
>     can carry a full one as we improve with no uAPI change.
>     The guest will see partial transcript until/if vmm/guest changes
>     are made
> 
> 2) The uAPI presents the x509 certificate chains in a consistent spec
>     defined way that userspace can hash back to GET_DIGESTS
> 
> 3) The uAPI presents the signed measurement result and tdisp in
>     a consistent spec defined way
> 
> 4) We have the four step
>        Start
>        Get certificate
>        Finish using slot

I am trying to think of a simple DEV_CONNECT modification.

DEV_CONNECT(slotidX) - let it do the current thing with SPDM, SecSPDM, IDE_KM, return the certificate chain for slotidX. I can propose modifying DEV_CONNECT to return the digests of all slots.

Then modify the existing DEV_CERTIFICATES to take a mask of slotids and return certificate chains (as a transcript?).

Then, if the userspace wanted another slotid - run DEV_CONNECT(slotidY). Slow but simple.

The AI tells me we cannot change the slot in SPDM (1.2 or 1.3) after KEY_EXCHANGE which means restarting the SPDM session so we cannot just change the key on the go, right?


>        Accept

I keep missing the point of doing this on the host (in the TDISP or CMA case). The host "accepts" a PF by enabling IOMMU for that PF, not the PSP's (==TSM) job.

We can certainly make changes in the PSP but they are going to ask what exactly is missing now.


>     Flow I mentioned earlier
> 
> 5) We start without complicated capture. ARM will collect VCA with its
>     in built capture. AMD will do a measurement collection during
>     'Finish' and extract VCA from its blob. Common code will transform
>     both VCAs into a truncated transcript.
> 
>     Intel don't get a VCA at this point, so no signature verification.
> 
> 7) We implement common direct capture and throw away the VCA code from
>     the drivers. Intel can work. Every host driver has 100% perfect
>     transcript.
> 
> 8) We have a nice think and Linux sets a recommendation what the FW
>     TSM interface should look like and try to badger the TSM FW spec
>     authors into something more consistent than this mess as part of
>     a 1.3 multikey update.
> 
>     If everyone can standardize on ARM-like TSM managed capture, with
>     the proper breakdown and data inclusion then we can get 100%
>     consistency without a complicated capture process in the kernel.
> 
> 9) The VMM uses the above common interface to reconstruct the
>     RHI/GHCI/AMD. That mess doesn't leak into the kernel on the host.
>     I checked this and everyone but Intel is fine to construct their
>     host/guest channel from the common interface.
> 
>     Ie fetch the x509 bundle and reform it into whatever was speced,
>     then undo it and put it back into the x509 bundle for the guest
>     attestation subsystem.
> 
>     Except for Intel all the guest defined digests can be calculated
>     from the common spec messages. Well, maybe AMD has an issue, their
>     spec is too vauge to tell exactly what bytes are digested.

True, I asked for some clarifications there recently, the new SEV TIO spec update is on its way. Thanks,

ps. we really want you on these IOMMUFD calls :)


> IMHO ARM has the design that is closest to perfect, a few tweaks and
> it would be excellent and support 1.3 multikey.
> 
> AMD's is weird but at least what they have for 1.2 can be made to
> work. Will need to be rethought to get get 1.3 multi-key. Copy ARM.
> 
> Intel.. Is wrong IMHO. It is still unreleased, is it too much to hope
> you could just copy more from ARM?
>   1) No easy way to get the VCA, no easy way to do capture
> 
>   2) Wrong digests design for the guest. SPDM_DEVICE_ATTESTATION_INFO_T
>      is a terrible idea since it is not grounded in any spec. The other
>      two have multiple guest digests computed directly over spec
>      defined objects.
> 
>   3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
>      TDISP_CAPABILITIES for some bad reason. Nobody else even
>      exports this info from their TSM or digests it. Thus Intel would
>      need unique API for the VMM to even build
>      SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.
> 
>   4) How does future extension work? Oh you probably have to pass
>      SPDM_DEVICE_ATTESTATION_INFO_T as an opaque blob through to the
>      VMM. Lovely, so only Intel needs a special Intel specific blob
>      uAPI? Bah. This is a very bad idea.
> 
>   5) Several unnecessary collections during connection setup.
> 
>   6) Confusing/bad implementation of 'TSM selected nonce' and
>      "recollection"
> 
>   7) Lack of an API to do evidence colllection for the host, the only
>      provided API always changes the guest visible information.
>      Not nice.
> 
> Jason

-- 
Alexey


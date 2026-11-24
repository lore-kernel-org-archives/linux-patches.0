Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795478823;
	b=V5he9EpdyG4Lv95GCtwXwRxyUNDE/Doyh6oTDd3laGn2HWjf/NyVjCaZT+Yrbb4ceCf8
	 fnBeVBVvndsr97ZBJcpIYpQ1H/zWnaWOJqoNg9VZMnHAm0H/vWVmxEmbKQ6Eoz5qf63IV
	 tO+xmS7H2y9YdolXQAgUlQYS8TV8BRysgj6vdFscVunRZpQqFKyqI7HnX7Xv+G8Km63tj
	 yfFdKArohGbsJcj/p1iqiwep8SvVcg7wn3KLOynftSZkfMsui+yFA1bxEb9DuZ2OxLa9p
	 J4CI8jkCfH0IP8kAXKl7H9POb57eXUnUoS0IehgAeRLDtoxrg7YZpnZMYJdgYESstUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478823;
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
	bh=WaxEAZXKUR4naGLKd9fCle/+/EKsdOcUh9EWcX9vNcI=;
	b=YuAJ1N+BCUdg1iIIosasFD4TKjd5h6GweVRj6X9cKuYhegtHbXD6vL8ayZQrBSG+FtOb
	 hO6OSVI5Wu7fDlnLddZhmAxmoRkL23JSvQP1nC2O0eOxSdfiIhOSTvuYqPz4djPxntrx5
	 naHj4eB0tim53cSfIt8/KIfZcDRi4db1hMQ0rApZ0w/lEhq/X2NKzdYSuhYIrebggz3AV
	 2cGE+pY4VNBD216OKwE6iYLsXChqiV19TxEEV+B3sjV6+CR8vq+znk4XNy4l57adeiJo+
	 endLUqHB2at0T21lgKpvYmIC5NG7kFXqa7QSOh7Zxp7g00Yj4FhkCTlq+8R/EVrRnFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ssb5p6zQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.55
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF77606A321;
	Tue, 24 Nov 2026 00:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AF77606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ssb5p6zQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUTWqzZvpy38j4mrbFsT8smKq1rX9Ljv5k7cyrMvqQ00c2SjlXjrTdJ9DV8VmV/aI6t6lN+GyWEmMIp87nPYm26mpPKD0iIbecUsjTSN/ZR7qmE/OnwHLSUPafGj1MlU8LKDBUyn6uoS623HgDktVSQ2IDAXxoZvkT16LDPj/gCJP4HIqkLFswOljuTt9hgFnLK+0LDTdEQDdmb3URNUahnXJpU6o+z6aoQtw2uydpUSpes5qJjwYmmbeYH/uAiUQUT9ffuBcNnMwPtovzY9SgxcTA9iNVULgeB+V3uQFW9VQIfZYbnk1oThiejH+1Ol2IedRtiE+Mhl8v7WK5tDLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaxEAZXKUR4naGLKd9fCle/+/EKsdOcUh9EWcX9vNcI=;
 b=tylLwDHQukjtn2WpHunpg/Kwh5OV2g9foE2NFknZqa/6Aix2BR9KdWF0FsUfBB+X4Qp+sB7jCuZwbMx6RfLLlz3tBedgGpWUeWNKyzLi0AmGdJjliovhHGzudByg9IcGI/V/gEfMLkT/hJc+TNAm2pkaPb3keiXJlUGUsCOWGBV6GMEiojV39yydTHDsOWv0yB5i6Ry4ALQr5Oh4VbOcz6DgwFAov02wQDNPptZLhMQHBKKRYBMH95o/KIUlkfaODiRIXsANqplrYLVoVfF+kjd3CNmiTcZTjrPoQtjxZiAfuYxU+FN19t8qtTkgsYjPdSjNwTSjwViv41U9wtfL9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaxEAZXKUR4naGLKd9fCle/+/EKsdOcUh9EWcX9vNcI=;
 b=ssb5p6zQENDvx1QHLvBMgz0LShFR4mCQ4GIpLKVtOJ1Y9YCISjS74MidglBWXOj+IDERUFPi4xHrrdWcu0YlFSQ/JlQHGvlhEGP/MiBMSZ4canlDYFTvGxMgnrqESE0Kxtnqm/qRC2Bc3ag1hAsY2jpXB8tuKNiYHRrOIJCSxk0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA3PR12MB9090.namprd12.prod.outlook.com
 (2603:10b6:806:397::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:06:59 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:06:58 +0000
Message-ID: <b0367228-e9ac-4ec9-8843-91379902708d@amd.com>
Date: Tue, 24 Nov 2026 11:06:49 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before device
 drivers
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-3-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0028.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::13) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: bddf82c2-8386-4b0b-3dbc-08df49bedba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|261009223027099003|4143699003|56012099006|11063799006|10067099003|261102123227099003|261021123027099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	b7E84uDZ5HPeODhcPnsMXeTTUs2EbaL/IiB/efD28YR3GYhZu+CjjIn4OjbEdNO2RUFp1mwdEjodbjMnbjANe+ddnPS575FiiVJu7qhQZKO3NV3WmPO4wys1rv3u0ZUx06Q8k7Ml6E0Cf1ktIbJj/P7/tN7TJ1hOPX+B/vY/zfRELmuy/QV7XrmT+e8n85sOCp1KY/4Mu3U7Jp07cWe/NK9HgMx/8Dmi1KUmgAi4mHNX0YrB6TWL66HsTi7y0rZCizGUYWwV1LP6LRllJO+jf3GBNYrBVSG2h9MnonM1aAYD1L8LsaEAMJKLtmyM2t6vRjBjgPzX7xLFWShy2UXwQGnKIw0pC1tXrlY6J4FNW8nMMYwKYmoWYauj8UmnD1O87fg+rLHSddm1tTdMJC4jlgXdwCKgVTPrgnCrAWalIIRiInS8mJo5wiZzwXULuRv9dMqhosHfBf8Z89pcbDfmCiPA+kutzYQWVBlxL75Jz56gBpE+AmL4ZUslRrEAZBWBFQS//OJfmEeVOoAlYcPYK4hVo7w5K+VN845liSI/fPYdTABj7RewzWI+bwGKTITG0bfiY96CNQ5sh+Se/5o/JGa3zY4600NpGO7yqb04RhAJYR2D0n0s311c7Vycoi+Dm9pamugHGC2PHxw9HWYIOwfmLvv08KukxAWBiVeqyc0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(261009223027099003)(4143699003)(56012099006)(11063799006)(10067099003)(261102123227099003)(261021123027099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTRkKzJvWldLemtoQmlNeURnMm9KZ0dRa3ZDWFQ2VGhha3NqZ3FSeHVWY3lO?=
 =?utf-8?B?YVRyOEh4N0NVYkJPSTVvZkNJTVZEWFRqK0xIM2lBYUJneWpzc0pkRkZSZE1w?=
 =?utf-8?B?UVRXRXloUzhzVnh1M0N1MC9XVjk4SzduS1FYbXNIWFZmZGZwcXBKTXpaQ0Zt?=
 =?utf-8?B?eGZrV1FJZ3poeEtxdk9veVRlVldVUVNVbnc3UW9uMXBBWnpmM2JOUCthaVhr?=
 =?utf-8?B?V1ZQeHNjKzBYSE5ScWI2dFg0N09wUjlSV2F3dUN6K3kySjlGdENzUThEVVpT?=
 =?utf-8?B?dC9UK2x3dDZ0Z0hxSVZKWjhLNmN1dUhzZUVzeTNCVTBxaEwxNzBpR0tubU9w?=
 =?utf-8?B?Sm9aZXFHbFMzc1VuRkhFTm1UbmpsbUNTVWE3WXFLN0M1SXRqWEhCYmU2VmpN?=
 =?utf-8?B?QU1ySnVvUENORVJnMWVkWFVUaXFNYytJR3hKZ1Vtazl5SjhuWThYdVIxMU1r?=
 =?utf-8?B?T3hEbitNaHJ1UG5kcU1jaStBWVUxdU5wSThobi9YZFd6K1NnakUwZWVsTk9E?=
 =?utf-8?B?TlhmM0pxZ2owZzZQSG1qbEtDVEdzRWxRNTZWeWVGM2E2VkpsME0wSHNpVC94?=
 =?utf-8?B?ZmFiaW9MNGlEZlRxZkUrekxXN3pCY0FJNDhzU3dYNExBMHkzeXRjZ3RzZG1P?=
 =?utf-8?B?Mk0vTWZ2dWl4LysyZm1DUW5OTmdvMWpNM2dac0VyUG9FRlR5YlBlb0dyRjYz?=
 =?utf-8?B?RlFZYkwzU05zUUdDdGc4ZkhOcEJjRU01MUl4WHBNUmp1UjFkRFdaUG01NVdD?=
 =?utf-8?B?ZE5SQndPb21oZkhHdHgrL2tMWDl4RWFTSkdtaEp1Y3ZxMWtRNFR3TDRkTFZP?=
 =?utf-8?B?SUFwTElnSXNkYjZXSmZIWXdJRjhEQ0VSVklhQ0wxRTc3MU9JdjlVbGFVVFJi?=
 =?utf-8?B?YjU4QkNxNXJQT1R5Sm5SS0JPdk1xSkU1NGowS3pQQ2E3VDZranRlaDVOaDJH?=
 =?utf-8?B?OU4xRXErZlNUa1Bjbmg0cmRCSlJLdi9ka1JFS2kwVjYxSHNCZGFkclhLWHp1?=
 =?utf-8?B?NjZ4ZHFyQjArTHRSZUFyMU1SUjJHekt2MjhtR21CK280ckhXVUdBNGJiUmM1?=
 =?utf-8?B?dnhBemlENkhVeUhBd2kwaGlxYkFCMWpYUlE2QmxIaEdlYTZzME4rQ2hXNzA0?=
 =?utf-8?B?bzZxZVArNU5VUEtYU2VCVWhMZ2R1OHRxUEdqak1Tc0tJZEJmWE9PT3Fsd0tU?=
 =?utf-8?B?OXVUdFAyYXIrZnRnTW1sR1FHUzVJYmlFQlgyelprUTNocERTV1hRTmNhMWhR?=
 =?utf-8?B?MndTMHB6RU9OeUg1YUsxUndpelMxMUxJOFpZMDBKbVFYaWkxb1F6Z2p6Zk9q?=
 =?utf-8?B?ZzhqQy9ud0hnV28zNFhJZEtBNkxFOFV1MUFKU1d5YVZxK2ZzQU9CMVdpL3Jw?=
 =?utf-8?B?bHJHVzBaeTZJT281ZUlWcW1iMHQ2TmRJRm4zcnFiMWxsVHRESm1Pb24wMjg5?=
 =?utf-8?B?dkJEMk8wY1RWWHIrRitZczhVeEZRU3NFZWtRSVF4WVdyQXdRVmo3NlNOajZX?=
 =?utf-8?B?ZmptSzJGd1pxWmxBQ08wUHMzUnBHTGsvRnZ0OTBPN0JoRDhVNkxiTlA3dFJD?=
 =?utf-8?B?aDhleHhaaWFibVUxSml2T1RRdDkwdk43eUJQQWpXem5zT0MwbUdoTDNnL2hp?=
 =?utf-8?B?OW1ITzV2QjRzcXM1MjZ4OG5EUlJXb1FkRXZsU3FmK24vMzUyNmxzOTFiWWpF?=
 =?utf-8?B?a1BTcDYwZ3N6N1FLYTZ4Y3NsOC8wWURBM0MxMDJXemU2am1BNkhzWERleWtl?=
 =?utf-8?B?RnRKbmkrYzY2ZEdKc1lieUl2dWVoVDFadWIva01ab1grT3o1MUlTazlKVWVO?=
 =?utf-8?B?RFYxTGg4VkpYYXRwQ3Vnd3BmTFdJWHdLZCtSc29ueW1UT3dFU1J1YXhnTStu?=
 =?utf-8?B?WWRudDN2S08yOVNlSHVzUml6Sm5Dd25Ed3dYVlN2cm1KSGQ0VmFHamN6RmdC?=
 =?utf-8?B?ZXJZWGQvUWRMZHlYdHNpQjU2WFZBLzdScm56RFJUNUF3dDVzcW11eHpmb2tP?=
 =?utf-8?B?T1RmS3prb0VqNjNHUGE2VHRDS3lVaEt5TWtRcXE5RlJSWGt4emRXVU1VYUp0?=
 =?utf-8?B?QVpvR3ZXRXVEdjE3Qm5mMlVQVjJSemtwdXJZcmFRT3JoSTJmcWF0cW1hamJX?=
 =?utf-8?B?VzJYb1lMeXFXYlBmbE9IRHJmN0lLVTROd0xYb1pNR1l1cUZhQ1ZIK3VOTHg4?=
 =?utf-8?B?S2tTWUd2VXpDbGk3WmxKOUVZYjBkTE5IVlorbUxQMlBlVVFyZUtCb3FZQ2FN?=
 =?utf-8?B?R0NsaEdmam9TNkx3UWZPK2pqS282UmZuZ1R0WDUxYWxUU2kvZzg2a1NRN2R0?=
 =?utf-8?Q?yWvpMqDphhJ43lZS4V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bddf82c2-8386-4b0b-3dbc-08df49bedba6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:06:58.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uv4V8XVnYrhhwDZ+5D2Nbpomtp6cN4ga8keK56yT7cpuU+D3W+Zz3Tx8mnONpkjJwB0nXAa+ct3a3NZ+QHasRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> Register the built-in TSM class with subsys_initcall() so it exists
> before a platform TSM driver probes, independently of object link order.
> CONFIG_TSM is boolean; remove the unused module exit path.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

I'll take to the tsm tree, thanks!


> ---
>   drivers/virt/coco/tsm-core.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
> index f07e68dcf6e1..31ef48203eac 100644
> --- a/drivers/virt/coco/tsm-core.c
> +++ b/drivers/virt/coco/tsm-core.c
> @@ -379,14 +379,7 @@ static int __init tsm_init(void)
>   {
>   	return class_register(&tsm_class);
>   }
> -module_init(tsm_init)
> -
> -static void __exit tsm_exit(void)
> -{
> -	class_unregister(&tsm_class);
> -	xa_destroy(&tsm_ide_streams);
> -}
> -module_exit(tsm_exit)
> +subsys_initcall(tsm_init)
>   
>   MODULE_LICENSE("GPL");
>   MODULE_DESCRIPTION("TEE Security Manager Class Device");

-- 
Alexey


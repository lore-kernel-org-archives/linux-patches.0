Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C14377023
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920845; cv=fail; b=EX8uhzBtjIgW5zzH8QcQdeKZE9kvdJpASJbJVkRQSZSjTP4Af33ERhINCnEQ5bWpG5nydn2g64IpSY8QyatwPVj9ILBkHZS80CzZ2QqKlUiK2FifD/IJO/UQI5ZQdLYQLeMCxInXgtIn97sBbryfpWXK3bY61W48ExLvgdxhSds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920845; c=relaxed/simple;
	bh=KFed7xEHc8jrA19XkfUVJTRPK+OOHQtSb0PsmzB7hh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sAHFTOgsA60JqS8mZfzhdhqrsWLFkhScusZcNnIgANEiTwl4gWXTwxN/uQCUHFnqLZ6H/RsTR+RjWPcVUSajmC74vkbf7h4k/LvOg/WTfT/ju2OhX6swtwyal5yzVtPudAy+LvIU2M7ewrYANxadA+QhwrTc9j5n2nwo7XhIJlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bSqsgCD5; arc=fail smtp.client-ip=40.93.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bSqsgCD5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TLEM3dge4Z+Spp2Y5HaCUvd3hcwC1owHAjgJHHvRTFvgOhCpBuX9YAw64TfSN8t1MjN/WYe/d1QPEL/x+FLPW4qKgGneZQseE3MrTyI+wQAGZRfcWu2ohY1TjSj9t+MUPxM8+kqn9GGiI9QLLXAIH8V527UJfUkvDMYB2pM6x+crB3XdH7W1BJBmBPLGSoeu1vC0PyG5Z0VV4XVHlsdOM4JcrFAjCSH/PzPsnlvDrO+5kfGx5rlrWLI1/k7ZfU70cQSYKk946mX1EHc1zPDYilq6ENogZlmteHa4VTvNcVw7zpKc0YLC3+MrmS75x9KvsXWApX0Cfg2AQe2oT1ffbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwHJpKxdtNfsM3e/6Q1cTslMa8ve6HUxZei1De2ow50=;
 b=Bmdp1HnD1BXQurMYH6oBlWkA9CGBpWrP91FuVsuOp44wNBWGK2cVtVD5kcgXfAXe6kt4qkHYKoRLoaWG2fA0oU7l++zlKY0br9601AQrDXJ/hPgP5IwxqJ7ZF3sJ7eQmWBO/S2pTqjESnfkbE2knebblxRmKreVCNKYIWEQ7YjaZe5QlFY9TZQPm5PwsONjzQoTs5hRg9sxGYC8AesaG+FLUY1KG5WGar2ofa5c5uyyoEJ9Vykgca1P8Mf9OmLGI1iYM9GdYnoDc/ehAfxRzHRyXXVl8c1ObNk/WBDKrBDcpVzxVQkMGSe1ZXLnUhHqGoM2OU1v22bn3P3kbGe7Q0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwHJpKxdtNfsM3e/6Q1cTslMa8ve6HUxZei1De2ow50=;
 b=bSqsgCD5IdhErGsureQMXaf57VLdM+w265TGRSiRfMWyOL8z87DK/61lwsgIJHeRaMed05fHMMRiOpEYAn3ntXxIUsHbKRMTRQC9xCMmyI1fis6fYJqNIEUZUFP0rh0wF7s8YALMt6dYHHo2L0dEt8GnAWQOpvK71uoutqtYScoR48xmGPCFCDpvmRiU/SmxltwajeupKV+qbLplOG6O0re3a5EfR1RetvGsXXpCQ3B0UltB+5Ah0FXDcCs65YZjEYjAUYCaIgMfHLHbUSPOK8v5ayn9mBUi21ZDSq4JK6Kh+ZAtG+MGxwH1TpxSXVggEH/tzcXmfHzkOCNcllAPxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 12:13:57 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 12:13:57 +0000
Message-ID: <c56becbe-aabe-4c27-9324-7119ccc68d6d@nvidia.com>
Date: Mon, 8 Jun 2026 13:13:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260607095727.528828913@linuxfoundation.org>
 <aiWjTGe7fRnSvIl4@duo.ucw.cz>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <aiWjTGe7fRnSvIl4@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: 99cdbcbf-9c5b-4dbc-c010-08dec5576a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rDvx0/tP1HG094iBmAkfQy5A9RVhUCg7+06F4302gIml/nK8ByH7tmPhAMXCMfdQrvScTPZgD0EEmKcI6FyqMCzKQKcsOuNfQ1LR9wQITZB1VlvMm6KxQaa99EIIyllhCUT5ZJl/1nELr8274z4FTksU6UewMlBy6zUW1WlNXvDGDeKh7NKApbJaZD4TIlf48KO/B25XiKNOibAc+hNMG0UYx5xNJ8YXDGj7iULNsO5wFvu8HHMYgSE9ed8BSRNxFzU/Ad9bPce99Ws1zMB4wr+bShpbtWyfXarUn/gffn+qZCpE8GcB6PaeVJirjobnWYdzeJ9LE2HouLLSU18PW5xRp4D5ePko+nOcgPxNTusf9iQ7Tf1CwCmGRkjrT6gPiOHQkTUVsW3ysNRmlNsZCIpAQZd2xbAJP+8tNJys7xFxgZFWRuMk7evxhUxS6ug3o4sc4LY66OEZjbGLlf5eH0VqFhgQK3bskG1uU78KV1uGx9CHaVCZHY/dcR2wsu79YpuxSOz76Rso0tN8qbBA1CSaOHEPpNiG7VNTJOyFWgl0AaYMrFu84D1mBtO4T6reJIyMWDEZGlwq3kbS0mrOQNd75qnPxo74ok36ecUCPQSYV6kKx017GS4sKYAxNQ/MZu1xxM983as3acChiLFweJjQjDIY5mQLfJ/KIVgnZxQn5ZQux2hsTUnHkvvRNRZZtPfNmgbPdQYBQjX0N9Pp8Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzErUUdxc2ZyR0Z4aUJkWFdpZ0ZmUE9jNmh0R29jd0o0dHJYc1JTODBNcmJV?=
 =?utf-8?B?V3FSOWprZHhESGhFUVYwZGhYWHRrQllrSzh0UEEvWWF4U0UyaFAvNzhKckhC?=
 =?utf-8?B?NmNWSWpNSHl5UEdFTkVkT3B2eTJxMEVaQW9CSHdyWDMzUTZWbHdMVCs1T1hv?=
 =?utf-8?B?OENqd2hLU0MybFFlZm5jMmUrSXhKTUlyOUJsTk1YQWU5WkJ1NDkyemY1MUhl?=
 =?utf-8?B?Q1J1SHVFUDdWWWVyUDBKUzVHQUpLZ0NLZHNNbG1VUDBQbUltOGwyL1lubTdx?=
 =?utf-8?B?NEhzbGdHcVovN05OcitXM0FpbVlTVWVLdVNuUW1udGYxb1hTU21UNHdlTEpN?=
 =?utf-8?B?VW5SNFR3RnAzTUVveTFQbFNQMStFZHZTUFlHMzZXaW5WOU5ZMnBjOTFUa1N3?=
 =?utf-8?B?RUcreHZucjM3S0M0MG4ybUxEd1ZtaXpTc21aNk5ZektOWE15ZjllZTljQ2xS?=
 =?utf-8?B?NWFrb3k3cGhDeTdKR1VTZUc2QmtmNlZVNE5mZnNMT05LR0tueitIVXMwRzJz?=
 =?utf-8?B?OEltOVpvQVBuZnZGZU9JZ3VvR2U2UWx3ZUNiRU95UmdDdDVLNGN0SCtROXNC?=
 =?utf-8?B?TFZqdVVnbi95VUlVd1JISTRPL1pET3hueG5wR0FhUVFodzlGNFJVeWh0Y3Qx?=
 =?utf-8?B?K1oxYm5kaHJuVjAzTTNzWHVqRVJWWnpDV1hsbFJPVWxhbkZWY3BHZEJ4azRt?=
 =?utf-8?B?cW5wdVJvREF6MytHWE1nenpaeGtjWGl6bzdzK3FKQS9nZ3ZkNGE5Z0NZNUdv?=
 =?utf-8?B?aGJDR1FielBjS3lHeDlmdGVkTnltVG5Yai81MzY5dm80S3Y4S2lDais5RTZq?=
 =?utf-8?B?SXI3dmVCN2cxWHhBZ3AvSWNyaGlaVmNWcFQ4V3ZrbVBUeHdjRzRwSktmbW9D?=
 =?utf-8?B?MEZDcTNkL2lKWjIxZXNvRUpwN0Y4UG8rdGpqWmtBbmFxUGNoeVpIRGN2L045?=
 =?utf-8?B?K0pmMWJQc2ZXQjBMVlJuZDcyUFNDWS9NaFkxRmh4NU5vWUxZZ2NreTF3SkJP?=
 =?utf-8?B?R2V5QXdqVVRwUlE1TDN6MlByQ2gvdjlhd2l4TGxLK0Y2UndYcjBCYkJhUXFu?=
 =?utf-8?B?WE5Yd0IrRVZQSFVMZ09OWE1ZcWFBU1cwTE0vd004bFVqRlBaZUVzK0YvUzhR?=
 =?utf-8?B?cjhFMlpaWGEwbUJ1amJxVEd4Rm5tTG5LMHNqZzBtcytyOHhGbDQ2cFB6UWFP?=
 =?utf-8?B?QUF2VDFiRTlSYjJlZVlyREFNSlhneThSTWdsR3Zic2ZueVJ4eGk0ZlVLNCtL?=
 =?utf-8?B?VU5HcHZxZkRhRlRVYXBEVi95YmRpT0ZLYkFXa0hOdVk0ekhHdGRuejhXWVBT?=
 =?utf-8?B?YmROSzBsWnJjOWIzOVVLblQ5d0ZiRHB5TmdDemdJU2x3YytsUHp2L0xKam45?=
 =?utf-8?B?K2xFUnN2V2Y0WHB5b0JvZ0hlV2lhN2h2YmE0andKRWkrajFCdHRkZnk2TXY5?=
 =?utf-8?B?SmpicmIzWWcrNWk2bGx1Q0dJK3pWUm9rNVN3c1FRV2sxdENBZVhEWENsa2Ri?=
 =?utf-8?B?TGszRTk3T1lvOURCT0QzNDY0YXpzbjJ0dTRmYktic0dDT0g4enJFUVdma0VJ?=
 =?utf-8?B?MnFRU3NQNWE2TW5IL25qc0tUZWlJV01NSklKTElYTHRNOU5UNlhpOFFId0Y4?=
 =?utf-8?B?VFdwMG9sV2JmZjVmU3U0RDF5c1VRVmIwOCtqWERSb2RadGxvMCs4dU0rV1kw?=
 =?utf-8?B?VjhUdFBHMGtHTHV0Um5VZlpQNW0xT005Z2RQUkJmVEZ2MXo5aTJxT0x2RXdO?=
 =?utf-8?B?QnRmVWtUc1IwNGJGbzNYMFJsWlZuK2tjWm41YlNySlVNUThCZFAwemo2ZzVs?=
 =?utf-8?B?bEpYUEtiR1V3eDR2Z0ZuVkNSTWM4V20zLzgxZnpHNlpUN1ROdUZ0OW5hZElC?=
 =?utf-8?B?V2lVVmI1dTF2UzhxNXBMRzdKNTUydjlWVVN5cXJWNnRLRnVoejZ2NnRtMGw5?=
 =?utf-8?B?V2hFbTh4WHFYTDV5VnpscXN0UDhoQzFncjRNWFJpeTJjNUZhQ3hjRUQ5bVFU?=
 =?utf-8?B?TXFNTVQ3SlJlaEFOYkRXMnRNV0JDZDd3L0M5c1IxU3RTcERsSVZ6ZVVWNFRo?=
 =?utf-8?B?SU93cWZxTEpjMHBjTnhoUGtvcTdJWXJSeEpUOGVxY3I1RldPQStsTnNzLzkv?=
 =?utf-8?B?NmxTaTZpTmhSa3lKOGdXei9FQ1V1Z0JSdlJTWld2RHZxMmpEVVVveFV2cnBx?=
 =?utf-8?B?bWtRL0h0RzZ1SlFIeFMwajg1elVhWjNhb25qUlVFSUVQSk9tZjJYZHhIWVpK?=
 =?utf-8?B?Qjc3Yko3VVZ2dmpleFRRcllVVTU1SXorc0VWZ0M4Z1JXVkZiTnpDUzRJcXJ3?=
 =?utf-8?B?L0Z6ZUVldzUwcWpMcm9PTXREa0xSUDZ6aHVWMW1sYXYvUlBRUGRSMHF0Z29X?=
 =?utf-8?Q?+PQTM9g8/UMUw9i7YOXknifxhBuNA6hZ8TQ+52pZqPyG3?=
X-MS-Exchange-AntiSpam-MessageData-1: jrx3o3XvXUNEVA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cdbcbf-9c5b-4dbc-c010-08dec5576a8b
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 12:13:57.4509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j59I+yD6HdmFPuKOCG09tl8K0ScfInMpF0ZeXumDz6BT9j8+nhH8NMQh8cL7/oI8lguxpBKMrB6rZ1vuN/CsMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780


On 07/06/2026 17:58, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.18.35 release.
>> There are 315 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> We see build problem here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/14732223960
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2582906697
> 
> Best regards,
> 										Pavel
> 
> 
> 
> arch/arm64/kvm/nested.c: In function 'kvm_init_nv_sysregs':
> 1807
> 12:45:08
> arch/arm64/kvm/nested.c:1776:9: error: 'resx' undeclared (first use in this function); did you mean 'res1'?
> 1808
> 12:45:08
>   1776 |         resx.res0 = ZCR_ELx_RES0 | GENMASK_ULL(8, 4);
> 1809
> 12:45:08
>        |         ^~~~
> 1810
> 12:45:08
>        |         res1
> 1811
> 12:45:08
> arch/arm64/kvm/nested.c:1776:9: note: each undeclared identifier is reported only once for each function it appears in
> 1812
> 12:45:08
> arch/arm64/kvm/nested.c:1778:9: error: too few arguments to function 'set_sysreg_masks'
> 1813
> 12:45:08
>   1778 |         set_sysreg_masks(kvm, ZCR_EL2, resx);
> 1814
> 12:45:08
>        |         ^~~~~~~~~~~~~~~~
> 1815
> 12:45:08
> arch/arm64/kvm/nested.c:1641:29: note: declared here
> 1816
> 12:45:08
>   1641 | static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> 1817
> 12:45:08
>        |                             ^~~~~~~~~~~~~~~~
> 1818
> 12:45:08
>    CC      block/holder.o
> 1819
> 12:45:08
>    CC      drivers/irqchip/irq-ls-scfg-msi.o
> 1820
> 12:45:09
> make[4]: *** [scripts/Makefile.build:287: arch/arm64/kvm/nested.o]
> Error 1


I am seeing the same build error for ARM64.

Jon

-- 
nvpublic


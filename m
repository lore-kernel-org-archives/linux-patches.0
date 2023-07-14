Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2060.outbound.protection.outlook.com [40.107.6.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99801549B
	for <patches@lists.linux.dev>; Fri, 14 Jul 2023 17:15:50 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaDMl9j9T008Pq2yCbVK9FPeyfrf5TkVjULVHbWjecbWWnt26i4DOEvnnulFNgg2vLKO7GWdoveSRqY8CR9hmRdBjA3XyjZe5av+IJUPTZm3mVGJw2ZVBQxmXsbmUnbNGUsNnPayFigMGxXnuWDnmCmTaRJqlLpQuadVvbhtJAFOZLr2oCQ+B0D4UvgEC7Fwavrr4qYF+0WM+QdAP3z5bD0iJiKAZWiYUgHUk2uNG4ioa7I3ecuIkMkbiCUfxlSb79v2kBpTLvCjjLkk7fRMc2Qyh1FOhs4cxK6CXdcyz7G8HKRYcufB/8IDF4uctoPbVQCervX8qRIVsW3cFIU3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzhpBGnipYQ5HUu321+1vv3DqmRb2jJkOLfoLLD+czY=;
 b=MViHYvMNp8YgnaZoUnq68AzMxfl/zbMx1yeKFSV4u3QvJP+iejCik/cpgc12vnQQ4C+7nMPAigYc74aCR1joomuQ+moRd9Ti5vHhoX2utYeF3SFZumNbiqgoSmQjckzzSMA8HoURwVnqlBOEU2lNGyQ7/pnX6cMBY5n43luNI1+fYbw5+KoAxObZ8VJTMgzTKAcjJO5e4Kj1+xFHYABs4aD92ZDcLh1n9UoNRQWBEbntGZBKnV3b2UauwDMmEu64ivIPLSphr2av4qiDrTtGJwTOhAaULoAxpW5rlif6N2T02PQRjlCOLfjxGcC/Xb0EUrXTH9JxuAfpBgFPGJKohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzhpBGnipYQ5HUu321+1vv3DqmRb2jJkOLfoLLD+czY=;
 b=cldU4OgLRKE7dnTU+chBok1yd9WkWp8wKSwncV066CA9xFzeKRyUXmASWljXTpN1hRih/9YhMu/AMYN8IZYsoPUR5jsaZYXw6c4ZloijN253+vZ0rWAmg7PAL4xuUYkcgYrNXeEq4yYMmo1TdtkA6r8tSdkBPOMASOJt7+MD/l4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kunbus.com;
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM (2603:10a6:803:4e::14)
 by DB9P193MB1371.EURP193.PROD.OUTLOOK.COM (2603:10a6:10:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 17:15:47 +0000
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::33e5:1608:50a0:38a7]) by VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::33e5:1608:50a0:38a7%3]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 17:15:46 +0000
Message-ID: <c9c3fe87-9f70-2131-24d3-bbb626042c16@kunbus.com>
Date: Fri, 14 Jul 2023 19:15:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Felix Riemann
 <felix.riemann@sma.de>, patches@lists.linux.dev, sashal@kernel.org,
 stable@vger.kernel.org, Lino Sanfilippo <l.sanfilippo@kunbus.com>
References: <20230508094814.897191675@linuxfoundation.org>
 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
 <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
 <2023060906-starter-scrounger-1bca@gregkh>
 <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
 <2023062100-retrace-kitten-7241@gregkh>
From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
In-Reply-To: <2023062100-retrace-kitten-7241@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:803:4e::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P193MB0413:EE_|DB9P193MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: 5572dff6-3798-4ad2-4ba5-08db848df679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n0ncmN5W5R4Ak4TZPXRAytFr0RvqDwO7PRmbUrcR8HJj3u2jv0xCzS1+JTuJxVJpBr7bmw7G0P9jKmlhdzixCPVAmD0O+K4mInOAz3rAj2NL6OxuNEY1ob7xKXsxifhzrUAC+TSErNxtckL8k9qKV0BHYhrbs6yALzrFy3AoKyu3PmFhtynQn+Nv6f9n7strvoq+/RfurkrSgGmoh1/5MFLfY6xj3mLl0S13LsK26r+jkCD4D1p9L+XvRNd+KsVRhNI3iT9DnEyxRbL7QaYAg4C7lkxCWjiGqdQrhb3p5GqnVpIIHqLUzTUG8Nx8Q7YtId3Y8a0OCU3oROZFLe3wuBVujmsDISoeMyFeap+Tkun4/nZqmvdrKpTuCeLpKnLzaVnCS8y4Dt/yYFds9dRbzz9MWtlVTee2tVaFTO5Q4h0QwNsvSI+vT52BHhqlBtCIvpMnJkxWVKC4pf/x7iILGnoqFitth8wlsNyB7TtZVUXttBNjVSBMAW/0RWKSeQXPihlPsz2kP+oolNIGjlJnd0WuyYuaIuunGIU4j+vZUyumxF641gJqfdNxXo5pgRERAUo3c38YKAvrnnVb9bdfcj6T33V7JSwwbaV54+ZhIjWX70pVQ23uNY+RMK40z2OYJy9fGq/MmSr/OGPvWO7D2pU4MVim7DUkz3HNwA++eLdROlfiE0PLzOk+vjSGxsRz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P193MB0413.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39840400004)(376002)(346002)(396003)(451199021)(66556008)(66476007)(38100700002)(38350700002)(52116002)(6666004)(54906003)(6486002)(45080400002)(8676002)(478600001)(41300700001)(5660300002)(8936002)(316002)(6916009)(4326008)(66946007)(2616005)(6506007)(186003)(83380400001)(6512007)(26005)(53546011)(107886003)(31696002)(86362001)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVB2MGpqcWRXZkYydFVMem5ER0VWdlh4VDZSYVg1V3hCZWVaWEdHQW5uSEo1?=
 =?utf-8?B?Vm5QdHhuOFZwOGczUUdya0hKeVFUUG1zUUtSZUduRFZMN3hSVEZJZTE2Z2NX?=
 =?utf-8?B?YTNNWDBOOFYxUGE4MHZFREl0eGlIQkszYlZCcjBXOTc5dCtzcXR1SG9HbEZU?=
 =?utf-8?B?N1FKQldaRUZjYVFibjBhVWNiSTRlSnB3ZzVrcDJJMDJNbXlFL29RVHJySWpR?=
 =?utf-8?B?b1YyVDVYQTRRQ3ZxdUF5QytUanpvR3hrVjhIbVJ1N2RMcWFpWkVOUnlpeGFy?=
 =?utf-8?B?MWJuTG05K0JEUExRc3lDNFRRcUkrNW5TZXJUS2hpWHNyNWlUOWF6OTVSUU1t?=
 =?utf-8?B?NWRURzRNbjNxdTR1VDJHOWhYaG1tbmlzbCszZmVtSUwvRzhINDlPaEJ0aUdK?=
 =?utf-8?B?SjBVT2JZTy9aR2V3T1ZTdE1XMENUV01ybWVsdTRBelRSSlBXOHhNY0ZMMkRn?=
 =?utf-8?B?d2FMNVBPTzNleXhIVEFiaFN1d2pWMHRVbnhuVW1TcFJLZGNkMWFidWxTUW9t?=
 =?utf-8?B?TTNCS2FNb2VmRGlkY3N4VGkvbkxJSXhMdFFkRGpwWWZRN1hjNVY3WUd2aHFE?=
 =?utf-8?B?YnJtZU9IU0x5K1FLRjFmcThRTkNJVkJBK0xWaVg1SkJXVHVCdmxOcjJHa2tt?=
 =?utf-8?B?YzRBMjdhNTRqRUoycVI5YmlPaWh5cGdrTlJtRnJRYVVOeUt2RitnemYzblZP?=
 =?utf-8?B?VHdFa2ZkZ0UzM2lHUnQwdDFISkNTeTk5M1c0YnNUTGhORnNrQlJ5K3ptVW9i?=
 =?utf-8?B?alE4ajVkalczcTJUL2NGcS9UYWQxcUFzaUxVeFRob3J1SVZZYVptRXhpTVVJ?=
 =?utf-8?B?a3BLcHFOT0gxcEpoYnA1RzlYVGhMNWlHWXJjOGpVUjN0VUwwNVBheUk4aTlB?=
 =?utf-8?B?UDMrKzl4TEJObzBjNWZ5Q0YrVWJuc2pSQytRaGRXNzJ4WGVqT3VNdFZGbzZ5?=
 =?utf-8?B?a0xLd3RFcXFhcTNLbm0zdjlvcFc2eGpvVk5PTzJZZHN6ckhNL1l1ZDBSMFdp?=
 =?utf-8?B?Uno2Y0dQcjRZQ0M0cCtkL0tpeit2N1pmVkxDVDF3VmVMYVYySFVmTTAxRGpz?=
 =?utf-8?B?NWpoaEQ0VWVncGZQT3hVN3ppZWNTSmNZTk1PQnR1cVliZ3VRR3hwN0VnL3BO?=
 =?utf-8?B?NzdJR0MwWHMrOHo5TWtIUEpHQUxlVDBEMWpmQ2NBbUxhbmhJRm1tZmJLbmxW?=
 =?utf-8?B?aTh1ZGJiZjdIeHFWWHo4TUJVSE9yVnppOE9KWHVwd2JLMFFKVkNBelV1VHhO?=
 =?utf-8?B?NDFyRHZzaFloOGtRRXNweDdWcGhXSnZoSFFVcGJjcUhXTXIzQUdmajdUZXhK?=
 =?utf-8?B?UGFVUHJwWVliRFljZis1dDJVNTM5YVl4RUdJTlNCektXU1JQVk9kZTlTYkJ0?=
 =?utf-8?B?Zldvd3dHenVIOGFYYXZtQ1pRUW5qUU1lUDZYczRBZGk4K201ZlNBUHN2anNK?=
 =?utf-8?B?S0ZjeXhFQ2VOTE5rM014TUplR1dnL1RUb1JuVXREaDFGT0RlVHJxM2h1ZDNO?=
 =?utf-8?B?ODgvRVlxdUptVWxxSXp2SmFMZjVQOUEyUW9CUVVEVmllVHhOdkNYVEJadEZP?=
 =?utf-8?B?ZXJtZHgydTlaekhTNUpBelcvZ2EyeUloMmFDc3FvbWtGR0drTVVobDNBVjlr?=
 =?utf-8?B?NGtrdDdhdmxZSTl4eHhURXZhQ2ZXSGh0K1lLVmRtWCtVRDB6ckFOSnNGOEdO?=
 =?utf-8?B?NXFrN2xwVzJaTkxEOCtOWmdIUnZWSis5L1E5bEw1OWtiVlZ6T1I3WERORUhr?=
 =?utf-8?B?YUJTam5hNnMvcW9FNzJBZ1FUbkJhMEVrVlkwNGdIRlV6NVlhWHM2MXRpM01N?=
 =?utf-8?B?S1d0MDNPYnROckZqN3NqZW10OWt4UERyblo5YTBzNlBEVFZ0Vmt5TFc2ZTJS?=
 =?utf-8?B?dzYvNzNBVG5ZTG5BbzMxZHRCV0I0eXpYdFY3Ri8vcUl0SGNENGowd1NFMkd2?=
 =?utf-8?B?azI5SDB0ZWlUVkRVcFFnRGdKV3Q3SGV3QnE4QnMzK2Y2WUxFeVJmUnpLby84?=
 =?utf-8?B?b1NpS1BWZlc0UzFVVnJwL0JkQ1hZbFRZQXl1aWhSdlRSRTlwSnVtS2Y2Ui8v?=
 =?utf-8?B?MmhLY1lmaFdqV0NmTXJJWXBhMXdaRmdYUlRKZTVBMkVNZnpXUFlpNk81cktZ?=
 =?utf-8?B?RjQ0Q25ZeHBXWWdaL2FJYmVKbHhiVm5DcnNLdzZNYjdyQVZNcDhOa0c5Y2Nm?=
 =?utf-8?B?S1E9PQ==?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5572dff6-3798-4ad2-4ba5-08db848df679
X-MS-Exchange-CrossTenant-AuthSource: VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 17:15:46.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yW+pWiu5Ia79JfXCVXPT9fIfU0YD0UvN1n2Guab/TRUitN04b6I6jVPOLPVK1ViP0o2Ea+CKa1pyWyzvBHONw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P193MB1371

Hi Greg,

On 21.06.23 20:45, Greg KH wrote:

> On Fri, Jun 09, 2023 at 05:42:20PM +0200, Lino Sanfilippo wrote:
>> Hi,
>>
>> On 09.06.23 11:07, Greg KH wrote:
>>>
>>> On Wed, May 24, 2023 at 04:07:41AM +0300, Jarkko Sakkinen wrote:
>>>> On Mon, 2023-05-15 at 17:37 +0200, Felix Riemann wrote:
>>>>> Hi!
>>>>>
>>>>>> [ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]
>>>>>>
>>>>>> In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
>>>>>> TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
>>>>>> Currently these modifications are done without holding a locality thus they
>>>>>> have no effect. Fix this by claiming the (default) locality before the
>>>>>> registers are written.
>>>>>>
>>>>>> Since now tpm_tis_gen_interrupt() is called with the locality already
>>>>>> claimed remove locality request and release from this function.
>>>>>
>>>>> On systems with SPI-connected TPM and the interrupt still configured
>>>>> (despite it not working before) this may introduce a kernel crash.
>>>>> The issue is that it will now trigger an SPI transfer (which will wait)
>>>>> from the IRQ handler:
>>>>>
>>>>> BUG: scheduling while atomic: systemd-journal/272/0x00010001
>>>>> Modules linked in: spi_fsl_lpspi
>>>>> CPU: 0 PID: 272 Comm: systemd-journal Not tainted 5.15.111-06679-g56b9923f2840 #50
>>>>> Call trace:
>>>>>  dump_backtrace+0x0/0x1e0
>>>>>  show_stack+0x18/0x40
>>>>>  dump_stack_lvl+0x68/0x84
>>>>>  dump_stack+0x18/0x34
>>>>>  __schedule_bug+0x54/0x70
>>>>>  __schedule+0x664/0x760
>>>>>  schedule+0x88/0x100
>>>>>  schedule_timeout+0x80/0xf0
>>>>>  wait_for_completion_timeout+0x80/0x10c
>>>>>  fsl_lpspi_transfer_one+0x25c/0x4ac [spi_fsl_lpspi]
>>>>>  spi_transfer_one_message+0x22c/0x440
>>>>>  __spi_pump_messages+0x330/0x5b4
>>>>>  __spi_sync+0x230/0x264
>>>>>  spi_sync_locked+0x10/0x20
>>>>>  tpm_tis_spi_transfer+0x1ec/0x250
>>>>>  tpm_tis_spi_read_bytes+0x14/0x20
>>>>>  tpm_tis_spi_read32+0x38/0x70
>>>>>  tis_int_handler+0x48/0x15c
>>>>>  *snip*
>>>>>
>>>>> The immediate error is fixable by also picking 0c7e66e5fd ("tpm, tpm_tis:
>>>>> Request threaded interrupt handler") from the same patchset[1].
>>>>> However, as
>>>>> the driver's IRQ test logic is still faulty it will fail the check and fall
>>>>> back to the polling behaviour without actually disabling the IRQ in hard-
>>>>> and software again. For this at least e644b2f498 ("tpm, tpm_tis: Enable
>>>>> interrupt test") and 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt
>>>>> handler") are necessary.
>>>>>
>>>>> At this point 9 of the set's 14 patches are applied and I am not sure
>>>>> whether it's better to pick the remaining five patches as well or just
>>>>> revert the initial six patches. Especially considering there were initially
>>>>> no plans to submit these patches to stable[2] and the IRQ feature was (at
>>>>> least on SPI) not working before.
>>>>
>>>> I think the right thing to do would be to revert 6 initial patches.
>>>
>>> Ok, I think this isn't needed anymore with the latest 5.15.116 release,
>>> right?  If not, please let me know.
>>>
>>
>>


>> With 0c7e66e5fd ("tpm, tpm_tis: Request threaded interrupt handler") applied the
>> above bug is fixed in 5.15.y. There is however still the issue that the interrupts may
>> not be acknowledged properly in the interrupt handler, since the concerning register is written
>> without the required locality held (Felix mentions this above).
>> This can be fixed with 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler").
>>
>> So instead of reverting the initial patches, I suggest to
>>
>> 1. also apply 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler")
> 
> I've now done this, thanks.
> 
> greg k-h

While 5.15.y, 6.1.y and 6.3.y should be fine AFAICS commit 
0e069265bc ("tpm, tpm_tis: Claim locality in interrupt handler") is
still missing in 5.10.y. This commit is needed to make sure that TPM interrupts
are properly acknowledge (see text above).

Best regards,
Lino

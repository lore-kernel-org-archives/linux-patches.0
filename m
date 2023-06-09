Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2064.outbound.protection.outlook.com [40.107.21.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEA017757
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 15:42:26 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDTl9zYTicFD+7mzwXcatO5ivdIYJVweNNqcTFcwFLRbI99nTEY9YxngmCmMRJwsWyaihnw1FiKnnPppKfp3BeMgoyc6773UY0xBp/xzsRmjKA746Uhv3b2GowuHcD1isAMvTeGmmODCOszzi/DKp9+4JKikM8qhmwUxoyZtdHnj/LTiIwnVinlssDu4eHwtUrh5vNN0BPTfuAqoIIMceedr3fVvEHhrzARRi4sUTxOFtr+PYrs3mNMpQldxXnsDiA6AoU2RcmuC+EPnML92RanWoYJJLPyzMcQzxffhmXrv/vNmBngc4mxDIU8eIIrvcPCIzMYD6d2rcfeXNdFmMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxAgtWGIXdQ61ZAEUNyOwp+GthMdrPwS/DaJZe369rY=;
 b=V9BaTvDOujt1E6+AwO/cVJv/ijWI5+tw1KuAnVgoG982v7vWOHhJI+ZkYeYrpNc6q/VA7ZzVvGY6WEq6q5kvhFbCFvAxsrqL4HzmYNYvHuMJ2gO4AvpGm3u1bjH9Tw8ArGz2lGdswORb79e9aBkSXz4VELl5UwI1Jw0oaKc/IZQWp5nyRbDfoFGQ33rSlWJhMJAvqBZaujs24uXy3xr7wVwDNJkXUxBLN4EtKFAe5RU/R/MlKQvDQdf8eIjBbGkhgelMaJhRlJe1Amj7uT3tyaASzdAyOYSPCTbr2lKSJQnSwCrYrcSNqH1JZNwbmvZbKe5Jlw+zsfV5izxzEks8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxAgtWGIXdQ61ZAEUNyOwp+GthMdrPwS/DaJZe369rY=;
 b=GeMKiVwmOeqABBGkesQdHUJMZKvoqge0kYQ/Yv4hSXYBRqiT+tGv0QtM/lWc8ri2qua0JYigDvnRD76YofzmbqTNxL8B7KjblhGmvzCzkyfEJr4cq4B+LKHpkkta7ntkQRZqGmYu2LrLxMwUQ8hpFbgQV8OAhKQT+KX6y7kggJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kunbus.com;
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM (2603:10a6:803:4e::14)
 by PAXP193MB1694.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.14; Fri, 9 Jun
 2023 15:42:23 +0000
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::6727:e3fb:8fec:72a6]) by VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::6727:e3fb:8fec:72a6%7]) with mapi id 15.20.6500.015; Fri, 9 Jun 2023
 15:42:22 +0000
Message-ID: <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
Date: Fri, 9 Jun 2023 17:42:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: Felix Riemann <felix.riemann@sma.de>, patches@lists.linux.dev,
 sashal@kernel.org, stable@vger.kernel.org
References: <20230508094814.897191675@linuxfoundation.org>
 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
 <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
 <2023060906-starter-scrounger-1bca@gregkh>
From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
In-Reply-To: <2023060906-starter-scrounger-1bca@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::16) To VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:803:4e::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P193MB0413:EE_|PAXP193MB1694:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3b5478-b1b1-467d-9bfb-08db69001dc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BkLa2CFM8ER0yvZOMYwlVn7wwjaH2DpPweD9xYqfyPnsEncHNsyAMfg6EMuZrIW6pFD6Uy8/RetsD+/dcE5ZA5lMgi3ckF/JE2KNHH1O21qMfMvkW+ePIYAl839ludgVvRmsgTW/y/G/N69V3vh3xiNba2qCYCfmtZELaZkiLEY6h3QlQpRT73xKFrSg4EE79y5bHESgpypoCLtLzYtJTZ8oeZ0LNd/SWBMB84bRGoCP5y+5Icr+UII6h8z4oAoav3zywK3fPWhcY7Mkng38rJ9KB0ZIXAsrEDfBMoRNoJEpYtKdnd5ZRAsyPDlhWCqKRHNTOIgBbTolzsmDHG8ejSXe3Yo5WnC+QBloH44etTYDSTirGHaQ9D7Bb7JMiite7+f9ResJZpvPcHXVffFPAdahUAjcVLGfTUBxraXMdKIWDOXgkWIcbs8xNgD4lKM7O4NIHTLX+yn3zrp+D8NJOjqXsBH2BH3zm5KJs28Kusceoavb+W2jURPFeS1lLLWFuLQxPD4/ap0Y7pxTNARL7089GKWXdFfsykr8+gy4FQ5DUSIbSj5EkobYTItKW7zWCOQl6lN5+bNj8v+S4aIGDaOwZinPKIG+oqHDG2wEB33mgJCXnmGfRvhwSiV6Le6fukhy4DvRKfuD8tnNTLgNpA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P193MB0413.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39840400004)(136003)(396003)(346002)(451199021)(31686004)(66556008)(66476007)(66946007)(8676002)(5660300002)(8936002)(36756003)(4326008)(478600001)(110136005)(45080400002)(52116002)(41300700001)(316002)(6486002)(38100700002)(53546011)(6512007)(6506007)(186003)(83380400001)(2616005)(31696002)(86362001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nk5aVnYvZWRWcmRycHlJVDFqNmFwODV6ZmJRbUNlWk9US1p4dFAvZ2dWeDI2?=
 =?utf-8?B?V3NwOUJHOURwM0RUSXFMc1lDUjhvVlp1WU9DaWFmU2ZRZWE3UUkrOXVUcDlK?=
 =?utf-8?B?SzhGcWxVcVQ0M2NHczdvVWovaHU1Wk90N0YwWnNVcDkwTy9EWDhPSzlOdHpl?=
 =?utf-8?B?OEl0c2xWMUZiUHh2ZVhEK2lpQ1hSTUJ6TlZhTnNzWGRqRnRDd3FoSzZ5TVJu?=
 =?utf-8?B?dk91cUdnOG16eWhERDc1cGVHRWt1MnFWR0krT2JQSTNvcUliMitDbnZWeEI0?=
 =?utf-8?B?NytLdE1MWUtPWUVUTlBHcDN1bDBXY2hKK3ZKSW5oVUdqRjVQb2lZY2llZE9H?=
 =?utf-8?B?eE9TaWpoUytEdVVlUDVac0Vrd2d0YW5ReGFnYVNZNjMrOXl4S201SnhEUFNW?=
 =?utf-8?B?cnduVVp6cVZxUkVOdFhBamRoR0Y1U0lyQXBFNy9WeUZjK1VLckRHV1JLMkVa?=
 =?utf-8?B?WGlNdWlaMHNtZE9iTUZrYkJrRE9Fc2YvMFZQU2tGYitkWDJxTXl3aTNpWnF2?=
 =?utf-8?B?dnRWQ2ljcENDTWd2dUpmYTdMUFllR091Vnlrak5jZWUwNUlLOCtDQXdMSS9W?=
 =?utf-8?B?NW9md2FiRmZRWTQ4MFJROThqZk95KzBHazlldXh0NCtxaUNQVHc0ampUUlBz?=
 =?utf-8?B?eTZQZnpZcks2akZFanZ3eWxlZzB4REpiY2V4ZmNxb0JRVGZ0d2xpVFZFM2Ev?=
 =?utf-8?B?R1lKVEY5aGRGeWlvQThoNGllUi9mZSt2WXJaSjZoQjhPZWZ1eVkvcldtVXhw?=
 =?utf-8?B?MGNGYXpld2NxOVZsQ0pqb1FjTjByK3dpRGl5dTcwWFN3RUlWQWIwa0pRMU5s?=
 =?utf-8?B?TDFZS3RBSnlxME1yR2JER2RzV0o5a1VhbnZRcjlpMkFLejgxM3MrQWRrOWhG?=
 =?utf-8?B?RExCZmZJM1hUMlRwNDZ1TG1vMlEycWpkcS8xaEwxeUdyUHYxSGljdTZaYUhl?=
 =?utf-8?B?alc5NGRFUEIwRTQ4S1RhZzB0c1JBanhEb0ZkQkxQSW9xbkVwT3BTQ0tvR2N0?=
 =?utf-8?B?YUVzeGE5UDFPVDZuWXp0dWVFajdJZ2tHeW9jeXQ4R1FjRkI2SGVleFhHTGRs?=
 =?utf-8?B?NllnNG0yempqWlpLa2NPMFdrWTFxdnVhWkJ4cWt4SkpjSVdVdVBTNUh0ZVRE?=
 =?utf-8?B?RUg0RGtEZmFVZnNmS1N6QmVHa3psa2FGbVNVNHdIS3lMSEEwV2FwZTRGeDFz?=
 =?utf-8?B?TWsrak9pVWhaM3R1R1Z4Nk9ab3JSVFZHNmNsREdGaHlnV1VRZ2NTT3hjM214?=
 =?utf-8?B?bW10S3cvZHhoV05uTUpRMDBiMGVRbkdLNm4yWTdUVUxZeEU1Ti9EZnZMSkw4?=
 =?utf-8?B?cU4rQW9rN3NBZW9EaXZoZmpuTjN4SFZtZVRhejdPTlNad2tJMVJmVWNya0d0?=
 =?utf-8?B?bkF5c3dBUlBLcGNVelVEekY5Y2VSTWNtbzVEYTNIY1FkRE1CMGF1OXFDa0lT?=
 =?utf-8?B?M0g2U1JUNlZMV0w2YUp5aE5qdkUvYzZLUE9DNmVydEZ2WHZJQlNjb1cvSmdB?=
 =?utf-8?B?RFBMdURpYklSUG5KQllaTm15UHRYb2xVVE42alQ1T1dFSXRiRFEyZWFDTUlh?=
 =?utf-8?B?V1ZJVk90OVpSUlRjQUloYjVWSlc4dk4rQlZhbWo0S0RmdE9wTFJnaUJNUXF0?=
 =?utf-8?B?cW5Gd1dsMVlhbitjWmh6USs5eCs2QTJzR3dkQktjclQydnhteWVMTW1rWUg5?=
 =?utf-8?B?WGZ5SW90NGdJWXlMNUFiUTAwV1l3WitUeWZrNE9qMG1wK1IzVzZ3VUdVa3My?=
 =?utf-8?B?T3hJRkVDRnlIekZxL0VLVi85azFoSGxyd1kwRi9zUkpuL01ZVHVoc2pNMld0?=
 =?utf-8?B?OW1VVkc5VWpxcklaZzc5MWRLQUN2Vm9IcDU3L2VuYXlCNDhXSGdLcmsrakNF?=
 =?utf-8?B?czZMZGxzb3ZkVjNKZDRydm5mTnVTRE9tV1NiTE9Jeko5NmlDdGhsVFlML3oz?=
 =?utf-8?B?N21tUldub3FxYTdxZ3hVYVRtcjFFNnZvWHhsOC9ZNUdubXgzVGYyYXpPTnY3?=
 =?utf-8?B?dnc2dnRVeHFkQStYNzRqd3lSL1YzWUN3WTF6eXJkeElmcWtBajlvNVFUTGZX?=
 =?utf-8?B?bHM4SkI2VWU5WVV5RVJJVEpha01WQml1a056NE5uNnF3K213YTM0S08rZUNp?=
 =?utf-8?B?aU5QOEVBdzdiVkVaNko5bkRXNXYraUJNeWFXRFcyUEtBWEdwd2d3WnRibUNY?=
 =?utf-8?B?KzVBTlA1TUs5dzB4RHNhVEx1VzJMUjA1YzZVUUJ0cW1IMVhhR2VzTXU3U2hB?=
 =?utf-8?B?OFhlQmRzajAwUGxMUnVtaXVBUlNnPT0=?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3b5478-b1b1-467d-9bfb-08db69001dc4
X-MS-Exchange-CrossTenant-AuthSource: VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 15:42:22.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9lYxrOB99OXfXwMkEj9WCJuCeymOsZXOsrAPrVop69DceGVTsr059l+khiZkB02IpF3sa5VyhAIqrFNDkD/yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP193MB1694

Hi,

On 09.06.23 11:07, Greg KH wrote:
> 
> On Wed, May 24, 2023 at 04:07:41AM +0300, Jarkko Sakkinen wrote:
>> On Mon, 2023-05-15 at 17:37 +0200, Felix Riemann wrote:
>>> Hi!
>>>
>>>> [ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]
>>>>
>>>> In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
>>>> TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
>>>> Currently these modifications are done without holding a locality thus they
>>>> have no effect. Fix this by claiming the (default) locality before the
>>>> registers are written.
>>>>
>>>> Since now tpm_tis_gen_interrupt() is called with the locality already
>>>> claimed remove locality request and release from this function.
>>>
>>> On systems with SPI-connected TPM and the interrupt still configured
>>> (despite it not working before) this may introduce a kernel crash.
>>> The issue is that it will now trigger an SPI transfer (which will wait)
>>> from the IRQ handler:
>>>
>>> BUG: scheduling while atomic: systemd-journal/272/0x00010001
>>> Modules linked in: spi_fsl_lpspi
>>> CPU: 0 PID: 272 Comm: systemd-journal Not tainted 5.15.111-06679-g56b9923f2840 #50
>>> Call trace:
>>>  dump_backtrace+0x0/0x1e0
>>>  show_stack+0x18/0x40
>>>  dump_stack_lvl+0x68/0x84
>>>  dump_stack+0x18/0x34
>>>  __schedule_bug+0x54/0x70
>>>  __schedule+0x664/0x760
>>>  schedule+0x88/0x100
>>>  schedule_timeout+0x80/0xf0
>>>  wait_for_completion_timeout+0x80/0x10c
>>>  fsl_lpspi_transfer_one+0x25c/0x4ac [spi_fsl_lpspi]
>>>  spi_transfer_one_message+0x22c/0x440
>>>  __spi_pump_messages+0x330/0x5b4
>>>  __spi_sync+0x230/0x264
>>>  spi_sync_locked+0x10/0x20
>>>  tpm_tis_spi_transfer+0x1ec/0x250
>>>  tpm_tis_spi_read_bytes+0x14/0x20
>>>  tpm_tis_spi_read32+0x38/0x70
>>>  tis_int_handler+0x48/0x15c
>>>  *snip*
>>>
>>> The immediate error is fixable by also picking 0c7e66e5fd ("tpm, tpm_tis:
>>> Request threaded interrupt handler") from the same patchset[1].
>>> However, as
>>> the driver's IRQ test logic is still faulty it will fail the check and fall
>>> back to the polling behaviour without actually disabling the IRQ in hard-
>>> and software again. For this at least e644b2f498 ("tpm, tpm_tis: Enable
>>> interrupt test") and 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt
>>> handler") are necessary.
>>>
>>> At this point 9 of the set's 14 patches are applied and I am not sure
>>> whether it's better to pick the remaining five patches as well or just
>>> revert the initial six patches. Especially considering there were initially
>>> no plans to submit these patches to stable[2] and the IRQ feature was (at
>>> least on SPI) not working before.
>>
>> I think the right thing to do would be to revert 6 initial patches.
> 
> Ok, I think this isn't needed anymore with the latest 5.15.116 release,
> right?  If not, please let me know.
> 


With 0c7e66e5fd ("tpm, tpm_tis: Request threaded interrupt handler") applied the
above bug is fixed in 5.15.y. There is however still the issue that the interrupts may
not be acknowledged properly in the interrupt handler, since the concerning register is written
without the required locality held (Felix mentions this above).
This can be fixed with 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler").

So instead of reverting the initial patches, I suggest to

1. also apply 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler")

or 

2. revert the commit that enables TPM interrupts in the first place, namely 140735c46d37 
("tpm, tpm_tis: Claim locality before writing interrupt registers").

 
The situation is similar in stable branches 5.10.y, 6.1.y and 6.3.y.

Regards,
Lino





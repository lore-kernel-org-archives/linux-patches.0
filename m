Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2047.outbound.protection.outlook.com [40.107.15.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3041FB7
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 15:36:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSJ3whpFCXEcMdrCbqNVfRZnRoxBPRVCEWut1jYSlsQHbXf5ZM2qJRAtOQx0Uo6ChTT9FNK9KGzE4H7OuMANIKdaP2XKgNOxyrB/amQZg2nzavNmKFRUeRBcxQOCgoP2hq32utXqRKnpKFBKqBv18qXo1h+aNjhvfwHhYLSb2YHhaaqX49m76+sU2LV69iys40YJTPKgpwaIpPheHit1JzIdhBHrjig99KWkCEs7geLv0Ei39Vev42y6qqW9ZqNLQopZD0pSD24a8t8AOJCiZhVXIU+beLeUtUa/RLE21cqzhoIj6dHTUNr4tYUEBXt0msxUOOgwb9mae5/1wjRyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nA8v3linh5wx0qL4ma/TRmk/7w5PoUaRpgeVa5rdVw=;
 b=bUYyNe3oqPs35T3gamM2Ra2CgQkVXGYYARRLnt0zg+/VcKQcQlG37WKR2O1a6eJlxQ6XHcUUNSP2rixZZ4e6fjRSj4lDHMecl14uLA6Xg0e+3SnUMjRQ7u0ox0VcKsChnHJW2UdEeBO1UlPPq6pdG9yJ6OV4g9Cx82qA3nONFMpcShSpv0jqNOpiSpOLR6u56Y+MOgeLteqKD2ZmSnqvejY7fApXVRp6crUlOdUrnBj3ik/pjcRdlIZJLcQixtbJ8oMWpuv42D3QT9aZLoEc6gBSAk6NyXOeFb6fm48EKQJXOofq23HGcgst3z7C4tGJ/g4Yc41jsamkunFD74Z5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nA8v3linh5wx0qL4ma/TRmk/7w5PoUaRpgeVa5rdVw=;
 b=t8VK1WoYIGuvrkXFz/wKYoJS4z0GE1rt278jRh/i7MpvbJL+AYbtue9bhkuFpJuJavBuklF5YNE+/KyzY33zepY3H9ru6qt1tWbpsUppvVQhaZzzZugpC7z6gNSumK58wwCNEBBbnyUXkGChMM7CrjZDuKm+UYPCR5SetHkbQPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kunbus.com;
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM (2603:10a6:803:4e::14)
 by DU2P193MB2131.EURP193.PROD.OUTLOOK.COM (2603:10a6:10:2fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Sun, 16 Jul
 2023 15:36:40 +0000
Received: from VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::e7d4:5b78:aaf6:eb4d]) by VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 ([fe80::e7d4:5b78:aaf6:eb4d%6]) with mapi id 15.20.6588.031; Sun, 16 Jul 2023
 15:36:40 +0000
Message-ID: <82453437-6624-cb36-4079-0ecc1131b0d8@kunbus.com>
Date: Sun, 16 Jul 2023 17:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Felix Riemann
 <felix.riemann@sma.de>, patches@lists.linux.dev, sashal@kernel.org,
 stable@vger.kernel.org
References: <20230508094814.897191675@linuxfoundation.org>
 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
 <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
 <2023060906-starter-scrounger-1bca@gregkh>
 <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
 <2023062100-retrace-kitten-7241@gregkh>
 <c9c3fe87-9f70-2131-24d3-bbb626042c16@kunbus.com>
 <2023071600-backdrop-carless-b990@gregkh>
From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
In-Reply-To: <2023071600-backdrop-carless-b990@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0026.apcprd04.prod.outlook.com
 (2603:1096:820:e::13) To VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:803:4e::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P193MB0413:EE_|DU2P193MB2131:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d09a6a0-0f93-409a-1875-08db8612730a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VOjjudqHtvYJ0DTcIOknzggenlfz2n0ZfmCU3E+tXC58YwuijOVTVlcVgd3zdxq1Zw+HKA9c2+W5ITM6guAKISQ8+G1wa6X7IVQHgpwQU+DuMbQu2ERj78j1WVYThPrtQvSfJiq225ingqhtKKkWA2TVTzFzyypphHakXdUQVJCys4UPu8ZVUesYOjybfE42BVgpx/lp+Xl+hLN9695N5mPEjDJurLFK8seJ91cVebrdVuG5QxrG3JraRrtrJZaAjAvh5q7ibZ+Ulux2GMAkid2lcWEvDI7SNXeiqdtIwjsn8lqujR+0fw3vTOKT4hOKYhQF9/IrGt9o8028wWHnCwEULrdvTAnMCKvg3Ve8/lpsotSDA1HUz9/Do/0O8Ka1aI3ONEpCE5ZGt5u8cQThOoVviNdToi2RkwjVAtkwZ4Yd2RSCIFTZ+t9v7ztdiMfPH0PeDoakZZinhnnoY36uq1+erBGZuJhxdo6f0hlPNAH7PuhkyW4kBnlLUM8L2t3Du4kjBjj5bPVKvjbGeB1a+qgrunlVqtacBYOd2yge/QkgwH2ubLSyd6G//pDySHLxZMrLKnGmEGC2nbJkWpcm4ofASgQQ2TNELS/F2ktFK4z97c9mDHJKDX3nXoYPrnqZq7vRbQNAIAbDuxtSaeryh1IWKZ08WPp4ss3ZrOHpm9JPxt1hjoBolFN78ehA8RIz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P193MB0413.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39830400003)(396003)(366004)(376002)(451199021)(36756003)(31696002)(86362001)(38100700002)(38350700002)(2906002)(6666004)(478600001)(4326008)(6486002)(4744005)(53546011)(6506007)(26005)(54906003)(52116002)(6512007)(8676002)(8936002)(316002)(41300700001)(66946007)(31686004)(66556008)(5660300002)(66476007)(6916009)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWtsRVdObDJQM3h4YjEyVmprSGo4cmI0ZTAvRzBkNS9jUmlyUFg5OGZmUWF6?=
 =?utf-8?B?Z0lvN0xVNW1Wcit3WDFVQXY1VHZhelhTQVFQQjlEMGdzY0dFN2dzejJqZS9C?=
 =?utf-8?B?OVF6VHBEVXBqYks4blFRR1Y5L2UzL1NyL0k2Y2E1ZTF6ZVBaMmlFd1Q2N1J5?=
 =?utf-8?B?eWUrT3cxTWZwTVE1Mkl5Y0FFYmdiU1RYc0tIYzdBOHlnUjIrZC9jUnZITWc5?=
 =?utf-8?B?c0JLQVlQbko2QkgvN2g3dUgxNTg4RGp5REZ6SVRPenMzUVZ2cmJjcDZBeFFy?=
 =?utf-8?B?Rzc3dzRGSDNqQzdxaDdyV09sRlg0d3lWL0kyZjBqZ0Y4blJTdHhINTFlSzhu?=
 =?utf-8?B?c1NiQzZ1UUJrNnlZSHBmczhIYURNWE9SZEJ2WmJzSHFsWkdLcGNERStUYmpE?=
 =?utf-8?B?U05xdzhJay9Yb1V3bXp2eWNhd1FJLzdNRjZwQk45dG9ZTWpneUZPRzJlb1NT?=
 =?utf-8?B?Mm9MQlRZUXE5NkZQSVU0VDdXRitNQ3h4WHZiWlZqdnNxaE91M1JYcEJZR1ZV?=
 =?utf-8?B?VUMrV0FVb1owYzc4Yi9MU2xxRXdnZ1Zrc1loaFV5VE5NY2pyVHk3YmxQd05L?=
 =?utf-8?B?c0c5SnZvRG1KN0s2d1FaMmFyNzk4dDlUR2JPbzJCRGd3M3pKRjhNeExKRkFh?=
 =?utf-8?B?WFdzWDkzNTRsTXA2UkVsT2UxQWJubmZQOTZobnlyU0l2cVhsZ2MzSlVrbzlN?=
 =?utf-8?B?eE9jMGpiT3RBckRJMzZUQ2VxUU84VmllSVptdFdFQnhUYTJ4Z1UzbG1nS3Bx?=
 =?utf-8?B?b2VETEJxNGFsNzkyK2dGbVhhNnRnKzZsKzU5SXgvRit0UCt2NEFlUHJvUjR1?=
 =?utf-8?B?a0t5cUQ2ZDdQcngzSlpCQm1WVW01aDd2UUwvcUVwcUJEa2l3ZWpRak1BYmYw?=
 =?utf-8?B?b0ZjQmxGVjZKanhKOWN5cmE3YytCeFpqZERXQnlkamo3cTFxaUV5R2I5dExZ?=
 =?utf-8?B?RVFHendPUjlXY2hyUzlCYUpnb3ZKNjE1byt1UTB1UGhJa3lkRWVRWXpaVDF5?=
 =?utf-8?B?TnduTUpZTTBnTHZ3WTZ6VTRtYlFSZ0dVeWN2N252blJsSEx5TXl4Qm80WG5I?=
 =?utf-8?B?dlBLaXdMUmZUQkFmT3M3bE14UE4vb0lReFliWEtSTk56QnFwbU84K1IzOUhy?=
 =?utf-8?B?cHo0YUtpOGUyQ0lDZTNScEE4czNLU1BmRmZtNUpHMkViU1JycGd5SHNJRnhk?=
 =?utf-8?B?bWVVYmY2SjZBb0VVaHQvbDZzRXZKOXNiMFBpMDJwejQzSlIxVzRhVDNacDQ1?=
 =?utf-8?B?Z3dVNDg4K05TLzZiMXB1TXNuMFZQSjFxOWR1eHRqejRTWnRETmI2LzhLRlc2?=
 =?utf-8?B?TkJaenNqOENUZnpubEJVRlBiNUh5VjJjR2RSYjM2em5URTdSaXdBR3FtZHc2?=
 =?utf-8?B?YThkWXlucVk1TUNZTWFIUXExTnhodXlMaklqUDJIU1pBU3JPYUQzbnBhVmNQ?=
 =?utf-8?B?eHRvTnlMWFEyQkhacUwvcktRY0YwOFQwY0tHM2Q2WVJyT2FMbFh2aVQzTWJ3?=
 =?utf-8?B?ZzdSczlUUk0rYU9qb0p3T1lOajF1bzg1cmV5bExsZVBSL2QxSU9mK01XMzR1?=
 =?utf-8?B?SWZqM3dFT056dUNFVTI0OExPeXlPTm9CTEtSS2lIem51dHdsYThJamNpaVVa?=
 =?utf-8?B?WWpXWmpkYi9tRHltTlczYTgyY1B0TDEyM2V5SXloeG4vblI3eUlLYmpDNVVl?=
 =?utf-8?B?bUszQzRaZmhKVFNEQXpURlF3ODE4d0ZEVWJIWEk5aXJWaE0rRDRqYWF4VlJh?=
 =?utf-8?B?NWNaRG1JQ1hoekNkOXV5Y0ttKzAwaEpvVGNoVU5ldDFzb1NhdlBlSG9TWWxs?=
 =?utf-8?B?QkZCeExIVy9KVWo0SDdkN0xGN3E3TDVwaGdneDhpTkVoQmJ2NEdSNWJoWm9p?=
 =?utf-8?B?YUt1eVJFR3VMZm1CY1FObWlqTUxqUFNrSmo2MkI4dlEvalhITnJjMTh4R280?=
 =?utf-8?B?ck5uODF6RW5vRm0vQWtObUFUblBSN1Fpd2U3Mk1uUGJLaEMydytYS3Y4VGF4?=
 =?utf-8?B?aGVtVmJYdmdQWlVKUmFSUFNSK3JabnUzZ1duMVZwRTF0SFBNWFRuWUdxNDk2?=
 =?utf-8?B?OGR4c29qY1dhSTU4b3NjdFNFT0QvaGwwMEEwcko2SndqVzk4TXV6M1BURUpo?=
 =?utf-8?B?b2s5a2UyNWZNSlRrVFdlRExHQVlYTmc0Y1hoc004VFgweTh6YlFKYktOVU9k?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d09a6a0-0f93-409a-1875-08db8612730a
X-MS-Exchange-CrossTenant-AuthSource: VI1P193MB0413.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2023 15:36:40.4826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dnGmBcWYNFUrTaT9lZRKdcqQimvgQEAEio6XHqv4hxVJKwmqM1kyMqXmZsoIXdzCsfzjhhpFbBGOa5JY3t7MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2P193MB2131



On 16.07.23 17:18, Greg KH wrote:

>>
>> While 5.15.y, 6.1.y and 6.3.y should be fine AFAICS commit
>> 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt handler") is
>> still missing in 5.10.y. This commit is needed to make sure that TPM interrupts
>> are properly acknowledge (see text above).
> 
> Ok, now queued up, thanks.
> 
> greg k-h

Great, thanks a lot!

Regards,
Lino



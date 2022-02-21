Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A642586
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3EB21F395
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B582813A95
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 1fF5KWVnE2LOIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <7a1a4109-7be3-2fc6-cfe5-f95baf6852ce@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id 4P7KHmkgE2LpJQAAMHmgww
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka>; Mon, 21 Feb 2022 05:17:29 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id kFd4HWkgE2KBbgAApTUePA
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka@imap.suse.de>; Mon, 21 Feb 2022 05:17:29 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 6C299A3B85
	for <vbabka@imap.suse.de>; Mon, 21 Feb 2022 05:17:29 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: 0.588
X-Spam-Level:
X-Spam-Status: No, score=0.588 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, NICE_REPLY_A=-0.001,
	RCVD_IN_DNSWL_NONE=-0.0001, RCVD_IN_MSPIKE_H2=-0.001,
	T_SCC_BODY_TEXT_LINE=-0.01] autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wT5vzEFqiBAB for <vbabka@imap.suse.de>;
	Mon, 21 Feb 2022 05:17:22 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 01E78A3B81
	for <vbabka@imap.suse.de>; Mon, 21 Feb 2022 05:17:21 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70097.outbound.protection.outlook.com [40.107.7.97])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id BB8FBABED
	for <vbabka@suse.cz>; Mon, 21 Feb 2022 05:17:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnGsDXVZ3WY1a9s0Iq9DCI+E0+r0+O4mCPMEBF7onNg77P4hBau/dv9av0s16dZZGBVQgJqfu1lplDUpJI0e5Tyhe7R/w6Tu8FtsY6nhkvqv9k07CGAOQXK0P76L8wpLPq0S5t40Kw7GTiBnsgQA8/u0Yk5/NtLD8tJdXqxfKEkwFLs/PopbdFXpCeEGvMHKO35cksclr2g1TxRewG5J6Qtnd8Mtq9p+Am+vo2hrVD61JEt12C5zPL1R3Cw7NStXsCrcEOWYJqgDdCtEStupfJX0cxF9QcPwG7s9BTwrREeBhifXJigX1nhRdNYbK/N+eAYEVi0vFp26gIBIvX6GzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGV0W4MKpjKKnDNznnUJ6YsjiUFmdVmz09VgnEDlOEY=;
 b=Ydj23aVQOnb86Tvm6MzdAuqXp9Nzp1ho0XA/0dZbqaifToy2myAIdyhoq2Tpq+dt7sU3gnMjWpZqYgr7m/NMGAGuD6KYH5FL2a21NldzLlao4gQMsJ3UMSdpp5qKKpMG8a6KvLFmUQwaDxDhAsRMQtoO8ODEdZaTxM4+H988h5KnLR4vsOIH4ByVgpISxIdARv6/OsUQsrMRrA2SmsEzh9aII4tfG2GcVVBK9mZoL1FqblMqUhAfkNd5RC4QVYR8c9XNWf3F/dTL7Xj0iiD2521swBbRQqLQ1/yZ/Pfim9rMgOuNE3ZlOPB0XVSDhIV5DpbL+UZPqbxHnTffvLOvRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com (2603:10a6:20b:281::21)
 by DBBPR08MB5962.eurprd08.prod.outlook.com (2603:10a6:10:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.18; Mon, 21 Feb
 2022 05:17:18 +0000
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::2994:f9d7:4f06:8c3b]) by AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::2994:f9d7:4f06:8c3b%5]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:17:18 +0000
Message-ID: <11060a75-98c2-f547-68eb-fcab404a2539@virtuozzo.com>
Date: Mon, 21 Feb 2022 08:17:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Content-Language: en-US
To: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Matthew Wilcox <willy@infradead.org>,
 Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
References: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
 <Yg2EwqE07d97gmms@casper.infradead.org>
 <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
 <Yg2TQbpWen2SUP+l@casper.infradead.org>
 <Yg2cKKnIboNu7j+p@carbon.DHCP.thefacebook.com>
From: Vasily Averin <vvs@virtuozzo.com>
In-Reply-To: <Yg2cKKnIboNu7j+p@carbon.DHCP.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::21) To AM9PR08MB6241.eurprd08.prod.outlook.com
 (2603:10a6:20b:281::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cab8304e-6307-487d-4ba6-08d9f4f96dda
X-MS-TrafficTypeDiagnostic: DBBPR08MB5962:EE_
X-Microsoft-Antispam-PRVS:
	<DBBPR08MB59621B94EBD5574D89BBB711AA3A9@DBBPR08MB5962.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E763w+38QImLUZ5CKnrt4lLHtUQcb/8Q2oqNq7GXykGVJ116+S9UJjdNRkxyMkRpKHUV1z2dczJf3dfcxk10jtWGsq+hVw9Wu/wUXddPByj4tbakDiUKEowNAcahvm9xsbgPGZS2WOWxxiY/8AaFLYp5HihUnNbMEZ2a1DUDtBtcVCIfiZ0PpRlB7GrBf3cQd1L8+kL2CnAH29gPfKVwbvWcTWYHAKnGUGcmnMzE47XhtWFdNCqwM/oIIJKe5HHGZdrbxLV+zpRZFc5jrwPPFqfj23JfTblGFhhuu8yhkyJHBT9H/ZlqhPEcRN3dSu7cH05t9LfrznXplOI21DHFeov+iGnAJq4Vx2/34rYIVUAMSLnHpLKRH17oBiC7Krk1LPhDRovuGjMxtoyPMK4+XFMCcNLGTsFK4PyPw8rRvXPwgvJ5XG3FfF2D7R9oQ0h9M7w5E3yozjEZoGEr7XsE9x1vvYXBvS7LE7+ULqu96ZIik/VURDm6FyMhCk2Em/BrrK4ee8lHv2X7ZvcfChm8GUrnwXZlBN4/HIUJRMPqOqCgCOxrB32BGcL2gaKE99vovUOqy9DwOqjKyUgfB6uihmqijFYEBotIlqjiPGtUAQNgftWB06XLeNC36lEJW7r1/lfYSOiSYKHNxd+b2UTydmzsRFGqC+MCk4mpumcFXCNi+reDTEsNqdaKZgm3wO04xpMRsY8vXocINRuevoum1f2huMB1OfhGIwfCPSvx1CS9jefxGe7n4KsJXSAsbwOU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(6506007)(36756003)(2906002)(66556008)(6512007)(31686004)(2616005)(66946007)(4326008)(86362001)(26005)(31696002)(186003)(53546011)(8936002)(38350700002)(6486002)(508600001)(38100700002)(52116002)(8676002)(5660300002)(83380400001)(316002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnhpNXlETXdJRW14N2d6NXVHcE1WRi90RG1pcE43M1VYWWp3ZzdyZS90OStU?=
 =?utf-8?B?bDU1dSthcXJaenVqbHpra2l5alBUM2RnbjVQaE9LYlpZSldoVm1tR0xaR05E?=
 =?utf-8?B?YlJXemRYWW42b29CM3JYZGhFRGcvS0tTVzZiMUFRRTVrOHN3d0V4WVRGbkRp?=
 =?utf-8?B?Yk9rejRSU0RvVlhsUW5jTWx1Wm51WG1mT1d0dWNOZ2VPMGNhN0VPblFickEz?=
 =?utf-8?B?emNBN1FlRkRucjRaZkdLR0p4bFlENUYwbDlEUVdoc2VrQ2t4WDRhOXoxVmk5?=
 =?utf-8?B?cXMvamNLUE9nU2xHUEQyWWlrQUpaY1J4eTZYNUhvSzE2Ymtic3c1akZWdVp1?=
 =?utf-8?B?dEduYmN3NCs4bExLeGh0dnBFVkYrT0dzN1dnV2N5ZzFEdkpES0NsK29Bczda?=
 =?utf-8?B?amIzWms0cGZIb1BNbUlMZVZ3SE9BVlhOdzNTZ2ZEb0tJV2NGUUZlWGhCazEw?=
 =?utf-8?B?UWNRWldCYVJLQk9abW9MZk9wT3l3Y0xjTkJKeUFvaXA3S3hHd29qbW8zMmRp?=
 =?utf-8?B?ZVR0Z1k0d1dOQy9nemQ2TGpQbXFTdHlTQ2sxZnZzNlNaR092YjN2UDdocTJq?=
 =?utf-8?B?bEFqV05HQ1lUSWVLbkFnTDhvZUZXZElSV0NIQnBGNWFRTjhMRlllK0RGVWh1?=
 =?utf-8?B?cXA2dCtEb284dk1za1dhck9DcVpTd0o1alJ3S3NRRXRuL0l3eEJwV2tBRHd1?=
 =?utf-8?B?R255T1Yxc2E2U2E3dXNucHBXaXdYRElVb1JkQnJleUI5dmtGZm95dWNnUG96?=
 =?utf-8?B?bnFyc0ZmSEllejNsMmpKanM0Vk5LL1JRc2wwR01peXNEUHNNV01BSnUrMlhj?=
 =?utf-8?B?L0I1bkxnKzN6N1kzVURqWUJaWUJaNjBiUjNudWRZSGptYTllT0E3bElDVnJS?=
 =?utf-8?B?QVE5NXpUaWovMlRaUHA1eE9JYk5zZ3VtU0JqZ1dweXdTVmJSdHdyVDZwN0xi?=
 =?utf-8?B?bGY4RFJNRzg0d096S1I5WHdqRUgxUjVNU1Jxam1TZnY4L2V4ZjExTVBrL1la?=
 =?utf-8?B?M2Rqb2NNQXRraUVnREttcGxtMXIveFQvMFB2ejRMNFZlTmFJajgxdCtDTU9k?=
 =?utf-8?B?Q2w0OSt1RXl3dlZSZEpmVytwSVdwWHQwMW5UUHF0cHNNYzRxbTBoaFdJSTB5?=
 =?utf-8?B?VEtreFV1VVZ0cEN3N3cwVHloWDQyaHlScjdERzIvYkFDQzdHb2JiVFc5akVG?=
 =?utf-8?B?Wm5iK2RvN2hZWW1Qd0pxaVdpcU1GdzBkVzdSWnZtNjFmTENtbDd4MHlPY0pt?=
 =?utf-8?B?NGlTZWxGbkFmclJSNXd3RzVhUmNRekRFZDBJc2phelVzNW1QTDJiVEpqcWpQ?=
 =?utf-8?B?N2gxTExhM0VxN0gzZEFDWWxHa3JlcXE3K2x6cWdQNHlVYXBmUE94SVkrRkRv?=
 =?utf-8?B?dkM1UC9PeE5WY00rSXlwVXFaTWEyY2NYWUJDZUVHNzRlVzEva0NiZTNHeWxB?=
 =?utf-8?B?dExNdWpQQk9Rd2gwY2tRVnNWNVI4NlBhU2p5TUkxV0MydW55QlZ2SjZqMjNS?=
 =?utf-8?B?T0FwME8rak55V2RQenFzUkQvK1F0WWp2YmxEUXlneGsxNHVWTUJLUHFycm9k?=
 =?utf-8?B?ZlRaR2pUUE9hTVBUMG4zS2sxdmJYblhsT05zWFh5T284RmRMMDM5NDh0bVBn?=
 =?utf-8?B?OVpuTDNGcHNTcWFiTng4dHVQYkN6Wm1aREJTTFE3WlREcUVTaEtJRVQzSHJZ?=
 =?utf-8?B?R3dQYWxCQyszSVlDakVmcGtCZXoxRDNwVzRKSWplWUdPaitzQXlDTlBRV0lW?=
 =?utf-8?B?ZzNjL05VU0RVdE0rbUNhQjFiWEh3T1AvQmQrd1lFRzhXbTR2VUNCb3NUajZx?=
 =?utf-8?B?dDJ6SHZyOVVpOVlUNG9RM0RRRmZra0N2NTVpM0E5ZjFWWU4yNGZMckppblJ3?=
 =?utf-8?B?ZHMwMVBYR2RpWUtDUy9xK3NmVUZwM3VnbDErM3orVk5HTE5iVUxDRllOOXdo?=
 =?utf-8?B?akxEUzMzbiszNnIzejBPUkFwM29OY2FNcVBBSkNqTHhMYmJPcDUzejNBUnov?=
 =?utf-8?B?WElDUzRWQUJudUxmYWRjQUFJU243MjJkcndySXU4NnAyVmcwcXFvZiszOTJN?=
 =?utf-8?B?SllFK0dnMk4wUGNIaDNDcURVejNKZHVvQUZkZ2RxWG53bUhPK2x3WTBxRXE2?=
 =?utf-8?B?ZVlVcVlnMTg2YWZoMTNJb0lHdFhXdzdDMURmcXFKV1orRFc1cnZQS0ordURF?=
 =?utf-8?Q?lg3MFUonUurdlxVgnwUdC1s=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab8304e-6307-487d-4ba6-08d9f4f96dda
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6241.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:17:18.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzL5c9Cntrbg7JnXhzW7lrs1D0CCo0812KoO256r1T2arFB/N6+gT3Nss/DjYuFK4laLVGGQlJv5tGPtRsKfCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5962

On 17.02.2022 03:51, Roman Gushchin wrote:
> On Thu, Feb 17, 2022 at 12:13:53AM +0000, Matthew Wilcox wrote:
>> On Wed, Feb 16, 2022 at 03:57:39PM -0800, Shakeel Butt wrote:
>>> On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
>>>>
>>> [...]
>>>>> Here I'd keep _page (or _folio, if you want), because
>>>>> it makes it clear that the function goes over all pages
>>>>> (and is expensive therefore).
>>>>
>>>> But there's no intrinsic reason that it should.  If that's a
>>>> performance problem, you could keep slabs on a separate list
>>>> from, eg, file or anon memory.
>>>>
>>>
>>> Is there enough space in the struct slab for that list or do you mean
>>> something different?
>>
>> Well, I don't know what data structure your for_each_page() uses, so
>> I don't know what to suggest exactly.
>>
>> If it's an iteration over the entirety of memmap, then maybe you'd
>> rather iterate over each kmem_cache like /proc/slabinfo does?
> 
> Anyway, here is v2. I hope you're fine with it.

It works well on my test node,
Tested-by: Vasily Averin <vvs@virtuozzo.com>

Andrew,
this script was created in August 2020, broken in few months, repaired in April 2021,
then broken again in October 2021 and I hope will be repaired soon.

I think it would be useful to add smoke test with this script into checks
of some build robots.

Could you please advise how to do it?

Thank you,
	Vasily Averin

>>From 04efbbdcfde4535c4623f2fd6910a505a9c638bb Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro@fb.com>
> Date: Wed, 16 Feb 2022 12:43:30 -0800
> Subject: [PATCH v2] tools/cgroup/slabinfo: update to work with struct slab
> 
> After the introduction of the dedicated struct slab to describe slab
> pages by commit d122019bf061 ("mm: Split slab into its own type") and
> the following removal of the corresponding struct page's fields by
> commit 07f910f9b729 ("mm: Remove slab from struct page") the
> memcg_slabinfo tool broke. An attempt to run it produces a trace like
> this:
> Traceback (most recent call last):
>    File "/usr/bin/drgn", line 33, in <module>
>      sys.exit(load_entry_point('drgn==0.0.16', 'console_scripts', 'drgn')())
>    File "/usr/lib64/python3.9/site-packages/drgn/internal/cli.py", line 133, in main
>      runpy.run_path(args.script[0], init_globals=init_globals, run_name="__main__")
>    File "/usr/lib64/python3.9/runpy.py", line 268, in run_path
>      return _run_module_code(code, init_globals, run_name,
>    File "/usr/lib64/python3.9/runpy.py", line 97, in _run_module_code
>      _run_code(code, mod_globals, init_globals,
>    File "/usr/lib64/python3.9/runpy.py", line 87, in _run_code
>      exec(code, run_globals)
>    File "memcg_slabinfo.py", line 226, in <module>
>      main()
>    File "memcg_slabinfo.py", line 199, in main
>      cache = page.slab_cache
> AttributeError: 'struct page' has no member 'slab_cache'
> 
> The problem can be fixed by explicitly casting struct page * to struct
> slab * for slab pages. The tools works as expected with this fix, e.g.:
> 
> cred_jar             776    776    192   21    1 : tunables    0    0    0 : slabdata    547    547      0
> kmalloc-cg-32          6      6     32  128    1 : tunables    0    0    0 : slabdata      9      9      0
> files_cache            3      3    832   39    8 : tunables    0    0    0 : slabdata      8      8      0
> kmalloc-cg-512         1      1    512   32    4 : tunables    0    0    0 : slabdata     10     10      0
> task_struct           10     10   6720    4    8 : tunables    0    0    0 : slabdata     63     63      0
> mm_struct              3      3   1664   19    8 : tunables    0    0    0 : slabdata      9      9      0
> kmalloc-cg-16          1      1     16  256    1 : tunables    0    0    0 : slabdata      8      8      0
> pde_opener             1      1     40  102    1 : tunables    0    0    0 : slabdata      8      8      0
> anon_vma_chain       375    375     64   64    1 : tunables    0    0    0 : slabdata     81     81      0
> radix_tree_node        3      3    584   28    4 : tunables    0    0    0 : slabdata    419    419      0
> dentry                98     98    312   26    2 : tunables    0    0    0 : slabdata   1420   1420      0
> btrfs_inode            3      3   2368   13    8 : tunables    0    0    0 : slabdata    730    730      0
> signal_cache           3      3   1600   20    8 : tunables    0    0    0 : slabdata     17     17      0
> sighand_cache          3      3   2240   14    8 : tunables    0    0    0 : slabdata     20     20      0
> filp                  90     90    512   32    4 : tunables    0    0    0 : slabdata     95     95      0
> anon_vma             214    214    200   20    1 : tunables    0    0    0 : slabdata    162    162      0
> kmalloc-cg-1k          1      1   1024   32    8 : tunables    0    0    0 : slabdata     22     22      0
> pid                   10     10    256   32    2 : tunables    0    0    0 : slabdata     14     14      0
> kmalloc-cg-64          2      2     64   64    1 : tunables    0    0    0 : slabdata      8      8      0
> kmalloc-cg-96          3      3     96   42    1 : tunables    0    0    0 : slabdata      8      8      0
> sock_inode_cache       5      5   1408   23    8 : tunables    0    0    0 : slabdata     29     29      0
> UNIX                   7      7   1920   17    8 : tunables    0    0    0 : slabdata     21     21      0
> inode_cache           36     36   1152   28    8 : tunables    0    0    0 : slabdata    680    680      0
> proc_inode_cache      26     26   1224   26    8 : tunables    0    0    0 : slabdata     64     64      0
> kmalloc-cg-2k          2      2   2048   16    8 : tunables    0    0    0 : slabdata      9      9      0
> 
> v2: change naming and count_partial()/count_free()/for_each_slab()
>      signatures to work with slabs, suggested by Matthew Wilcox
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reported-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>   tools/cgroup/memcg_slabinfo.py | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
> index 1600b17dbb8a..1d3a90d93fe2 100644
> --- a/tools/cgroup/memcg_slabinfo.py
> +++ b/tools/cgroup/memcg_slabinfo.py
> @@ -11,7 +11,7 @@ from drgn.helpers.linux import list_for_each_entry, list_empty
>   from drgn.helpers.linux import for_each_page
>   from drgn.helpers.linux.cpumask import for_each_online_cpu
>   from drgn.helpers.linux.percpu import per_cpu_ptr
> -from drgn import container_of, FaultError, Object
> +from drgn import container_of, FaultError, Object, cast
>   
>   
>   DESC = """
> @@ -69,15 +69,15 @@ def oo_objects(s):
>   
>   
>   def count_partial(n, fn):
> -    nr_pages = 0
> -    for page in list_for_each_entry('struct page', n.partial.address_of_(),
> -                                    'lru'):
> -         nr_pages += fn(page)
> -    return nr_pages
> +    nr_objs = 0
> +    for slab in list_for_each_entry('struct slab', n.partial.address_of_(),
> +                                    'slab_list'):
> +         nr_objs += fn(slab)
> +    return nr_objs
>   
>   
> -def count_free(page):
> -    return page.objects - page.inuse
> +def count_free(slab):
> +    return slab.objects - slab.inuse
>   
>   
>   def slub_get_slabinfo(s, cfg):
> @@ -145,14 +145,14 @@ def detect_kernel_config():
>       return cfg
>   
>   
> -def for_each_slab_page(prog):
> +def for_each_slab(prog):
>       PGSlab = 1 << prog.constant('PG_slab')
>       PGHead = 1 << prog.constant('PG_head')
>   
>       for page in for_each_page(prog):
>           try:
>               if page.flags.value_() & PGSlab:
> -                yield page
> +                yield cast('struct slab *', page)
>           except FaultError:
>               pass
>   
> @@ -190,13 +190,13 @@ def main():
>                                          'list'):
>               obj_cgroups.add(ptr.value_())
>   
> -        # look over all slab pages, belonging to non-root memcgs
> -        # and look for objects belonging to the given memory cgroup
> -        for page in for_each_slab_page(prog):
> -            objcg_vec_raw = page.memcg_data.value_()
> +        # look over all slab folios and look for objects belonging
> +        # to the given memory cgroup
> +        for slab in for_each_slab(prog):
> +            objcg_vec_raw = slab.memcg_data.value_()
>               if objcg_vec_raw == 0:
>                   continue
> -            cache = page.slab_cache
> +            cache = slab.slab_cache
>               if not cache:
>                   continue
>               addr = cache.value_()


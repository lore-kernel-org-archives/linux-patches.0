Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD61F196
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:22:23 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHUOimHPIDrNPaVAWJc7NMrElCPA5uTETgEoGTFyh87Sd0xMkNF0qhHzCjLb8y6Za9zibxSPkk2Azw26E68xB9JuubhaTxDjD8ensG81a53/q0ZkpQW8e95rS0nMZG5laRM/Pdb4U76+OOhxeqXLSo+0X/eGCtQmiOb4s1p0SU1jwl65dLYQ0EazewR9702jQrnqipmdgdT/bqalZk2KdanOICfeazRaCjbYReCl3k+Ps3fVanlZc1HYBmBcbDig7IGA7GDZ40TZiGXFrEfzdz4qamI5gL7Lqd4iTvLli+uPbYST4IYZFJkf/qdYxGKkzUgLkzWfpj0jAjHJsi9v0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJY5g5RPTF43X8YWqQUdf6ITU9LQy1I0uPZBmbxgvKo=;
 b=gOoeLsUzEu1rMgv/mJ1kQBOK1+EnNGWH5jrNzjSadKjmvyqj59W02tl4LuvxArm6xqFaBG+Bg899hO1yS5JA9GZo17YtQZFN1m9OO9O2rgaAhHTY5ix/XMgAtQ3S/pXzhU5+/o0kCugTUbdHi0IQPHk0Pgo2LKyHajWBqcqegxh2g4t+iU+XDkZN0ODm0az4uS0HdLzQSOiTOpbvuwBIn1EnDbVojOaN+n+0oQQlLptCnQpKn02aPZxIBQsP6C70q5jiKGKttczzEsIH5cJCrP8vaI99Gw93uw+kjoVkWI1gOpJ8HNZt2lVIavuxl6NCN5szROucGuw0r7d98Vifzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJY5g5RPTF43X8YWqQUdf6ITU9LQy1I0uPZBmbxgvKo=;
 b=cyl6JV1AkAjZ0I3w0L2mb0rNU+G/1jWlaYo7YmMUILaOuXiBWJVs/mb8dorzNvRVwJPCdS7TAThsuj5UqTlD+WKSiqeIRW4qELHBjJn0jXHeTZBp4dwYBMmnnh+wGBYITB7HaB6hNIUT5wFLkZLfbvSAZiAFvhX2OuJVco99mew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB7283.namprd12.prod.outlook.com (2603:10b6:510:20a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 13:22:21 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::36f9:ffa7:c770:d146]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::36f9:ffa7:c770:d146%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 13:22:21 +0000
Message-ID: <774e7690-527a-7042-e61b-2f3a73c46c36@amd.com>
Date: Tue, 25 Jul 2023 08:22:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
 timings
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Alex G." <mr.nuke.me@gmail.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
 "Wu, Hersen" <hersenxs.wu@amd.com>, "Li, Roman" <Roman.Li@amd.com>,
 "Wheeler, Daniel" <Daniel.Wheeler@amd.com>,
 "eniac-xw.zhang@hp.com" <eniac-xw.zhang@hp.com>
References: <20230721160520.865493356@linuxfoundation.org>
 <20230721160527.097927704@linuxfoundation.org>
 <18e9e042-12ec-8e09-1225-ca44810e2b82@gmail.com>
 <BL1PR12MB5144A568ECEB3E9E18BA74C4F702A@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2023072503-subduing-entertain-878c@gregkh>
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <2023072503-subduing-entertain-878c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:610:e4::30) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|PH7PR12MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 826730b6-e840-4092-30e6-08db8d122d34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fnsvbvHkwue78vUEDdb2wVqJHSVZ9735RgbEgvQ3CqNW/CEHFrfweCziNLPLGWd2nmEnePjAgKW8qGer0mH1NrOoRTy4CpTA0tOs/7Zona52oA86My+phcQCMe0oHOjPSciomSaUse5MQIG8u6n6obAtBaki8mfyU7UoPle5hjmEyQGiNkKWIOb450pGMuNX5EawLzvfIPbMgsJLzlFfcsi/UFyyiEmUhVBq2NiJrCPCpSvTV27BFHBZDTm5ArWmvxuUXCKq9KA3VOJnI5tLlx3r9ZJ0SHqGfKnEcpgNtgmN3RhyDP+PIcCvgJgj9mBI2gkQqBQTrmeBL2Q6BaKnOPKF+L9g/I+4XoUZIAjT6HPI8Cit3ZvVygCIx7dNnJRwpzg4S7TMvOHAI8lmsrlM7RtPA8sn3zkDbPf8YCrpNr6uhPwl4vbm7zArTqSvrnoPFdGnJTJRQyv7Y4X+0F2ubX++2pIMUyCcbrJ+pm18nr/J3Ok7Ja07NNxUq5+dbFBFMg9h63FIlXuObQzuWmcaAxbyFivDR45eYQLbpT4cMAH1aiwRboYCMi3Jl/HlTL6iRU0f1zzknXL4It2ZsPxGmCzo5g3nNGE20lj+V8YWyop+VFwGi7BPdHb/gzV4qOSJv6Vx+BHxT8HFw6XeUuhmaA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199021)(110136005)(6666004)(38100700002)(478600001)(6486002)(6512007)(54906003)(41300700001)(5660300002)(316002)(8936002)(66476007)(66556008)(6636002)(8676002)(4326008)(66946007)(2616005)(186003)(83380400001)(6506007)(53546011)(31696002)(86362001)(44832011)(2906002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rml4NDdQcjVKZlhCRytxODNtM0wzL1JTUjU1a28xb1ZITklMcVRWTUU3alBk?=
 =?utf-8?B?SWxneDlYaGJ1M2VkUXZtQS90cTZ2QUhNOVRXMHozbDVMUEE5bFpVamdSNWE5?=
 =?utf-8?B?WmR1OGdBdzJUVlh0dHgyZUNmdm1aeUUzdjRFOTZaQTcvMzNzWlJuR0xUek9a?=
 =?utf-8?B?ZTBNZEE3RzhyRUhGdWkzRlpxb3NqTCtGNkNSNHUyNnltb0p1OEhaUlB3NTlX?=
 =?utf-8?B?enRJM0NoUXlLY1pJUWkxRjNMaWxyZHoxWUx4cmpQcG9YS3ZuSHIvOFVBQ0Vt?=
 =?utf-8?B?U3dIaG9FTFF6Y0V0S3RZVW0rR2pEL1BpN2ZQUVAyR0FCSFp4WTd3dDdFTksy?=
 =?utf-8?B?bHJpVStuQW5xZTlKb04vRXdJZGMvZytJUytLb0lrbithaGZ1Tm15b3k2WnMx?=
 =?utf-8?B?OWVSQmVIRVF0bVo5VjBsY1ZzS21uVzExQWFkMUl3N1BOcVVoSFhkY0ZaTWlu?=
 =?utf-8?B?R0lneWZQQTdKNFhxZ2lrL2dOVjA1dGtXZ2VVYlR5cE9PcXBZQ0UyYjNYUUVp?=
 =?utf-8?B?KzlwRy9VckhIdE51MFdaNi9IcGttSGh6d2crelNzQUdXMUFPalJxVHYyYTRW?=
 =?utf-8?B?UTcwbnQ4OE4reTE0b0lDOU5RRWJtbEVlanFPSGh4TjJucHphYnJOS2J2WnRQ?=
 =?utf-8?B?WDkvOW1hQjU0Ukl2Y2EwRlZzYjBac2FPbkdkR2Q2M2UvZkM4TEdRaE0rRDZY?=
 =?utf-8?B?Um9nUTZ3MkpmVEVSWE1lR1hqTzU4a0h1eXpzNzhzc2JreHgyQUJNYmNYMTFx?=
 =?utf-8?B?RDNCWkNacGVRUGdiOTE1cDRJdDBtaFppTjZtdlk0UkdPdHRiZkVodzBrSEoz?=
 =?utf-8?B?Y0xsYUxqTVJqdXpTSFhqUnNMZkY2amxjTDBDaUs2c21JaTdYT2t4NVg4MDBF?=
 =?utf-8?B?N29tQUdnWnZtbHhleHU5dlZweUliNHFjZGk5WkdZL1RmQmUrSWx6c1RMeWxM?=
 =?utf-8?B?aDExNS8yeVNhRHNLYXJCZUZMYzZSdUpRWk1vWCttTWhteUExUHhRTnA1MXlV?=
 =?utf-8?B?aTk5L2ZKcUs1WWlIMFlHWUxGaXh2RkVwVzk2TW1DT2tpL2ZZTW5WMUpzbC9H?=
 =?utf-8?B?bFNRZVhZQ01xWVlOK2JEamg0WU9ob3FSWldZVDhVb1UrUHVCZGRsL0hkQ05p?=
 =?utf-8?B?Qk01cy9hN3VydFZIaU9tZ3Z6YUdNMEhYaWJsRGRsU1dLSkhuMDNhaUI3emJF?=
 =?utf-8?B?OWNzbWtVemVCejhxaE5iTmpyZFI4Ynhxc1doZE9vS0lod3M2RWlvNkYvMHk4?=
 =?utf-8?B?Y2drZTd1Yk5tNEFsUGIrUzlRZXZ2d2NVN3RxQXpMSkRMcWVzS3p6Vk50ZGlI?=
 =?utf-8?B?eGFGcnRZTDRmTkUrWWJnenNzc3RXZTZ1TmxVbEJabkJqeUNtSUhMN2lwOWEz?=
 =?utf-8?B?UXVlQ2lWRU02SFJpY0RZOHhVeCtEaC80aHA2MDZCODhuSm85cmoxL0hxNGg5?=
 =?utf-8?B?L3Z0dlZFTmxDMU5ZUzJpVGx4SHNRVVJWQitta3VNd0tPd1lXMys2OGdCU2Mr?=
 =?utf-8?B?OGlFVllNZE1nb25pTWErV2J2YzBPbGV6YW0ydE1GVGllRTZxL3RVN09iSFhG?=
 =?utf-8?B?QklOczY1OElhMVFSZk9WMmYvZjhjRW1mc2ZaekI3NWZHR0s2NjhLMS92aDM4?=
 =?utf-8?B?ckRqb3NFTkFadkk3djVmRWxyWm5qbmJlNHpCY3duQ2VDUDMvRkI5d0tjRG5l?=
 =?utf-8?B?aTVZM3lQYURRWURJdjQ2YWpTdC90UUhVTFNhOXREcHM1OXdncVU0bU9ZeEFQ?=
 =?utf-8?B?NDJ1OXZTV2g2ZXJtZ3JHUzhLazNaS0cydlovR0RrRW1ZOFEwZGZJVGk0VDZm?=
 =?utf-8?B?cG9XV2pBelFhVTRxckRud0NrTmhQdko0TFUrWmlNUURaNlhhTXBaZGxuTlk2?=
 =?utf-8?B?dWJyRE8rbVJjWkNqRkhhQllzbklTOGVWN2d5UTd3aDE2bzJPaGtPZWlCSEtE?=
 =?utf-8?B?SW92UnhMZjFpU3RQb3IzNGVzRzkzRXNlVXpaMFM2ellWbGNCcUVEOFBDdE5X?=
 =?utf-8?B?STN4dGp2a0RqNHJXckk5MHkxMC9YWFJvSG9EYzViL2plMFRGRE5jUE9tM1l4?=
 =?utf-8?B?UVFRT0JRUGpZU2xEa3pKRDF2STBZQnNYbGFPRW1MMXNUdlZpNEYvV3piT0Rt?=
 =?utf-8?B?UnMzSlA1WW9sTU1vNXlYVkdLWjkvZko3OElzc2k1MWxXK1gxTE1NK09BMUZ0?=
 =?utf-8?Q?CqfEO1d/qfeqCUcntejB7sN897Az+T+1G5XXIW//np/4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826730b6-e840-4092-30e6-08db8d122d34
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 13:22:21.4959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Hrt091W8w0eQYkhE4eX6lVwejmIrl0ntnPogoHhYy9ThvFIOndTxU6UcH5kBCKILMtujDePraT2m0F6I7jPtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7283

On 7/25/23 02:13, Greg Kroah-Hartman wrote:
> On Mon, Jul 24, 2023 at 07:38:24PM +0000, Deucher, Alexander wrote:
>> [AMD Official Use Only - General]
>>
>>> -----Original Message-----
>>> From: Alex G. <mr.nuke.me@gmail.com>
>>> Sent: Monday, July 24, 2023 3:23 PM
>>> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
>>> stable@vger.kernel.org
>>> Cc: patches@lists.linux.dev; Limonciello, Mario
>>> <Mario.Limonciello@amd.com>; Deucher, Alexander
>>> <Alexander.Deucher@amd.com>; Wang, Chao-kai (Stylon)
>>> <Stylon.Wang@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Li, Roman
>>> <Roman.Li@amd.com>; Wheeler, Daniel <Daniel.Wheeler@amd.com>; eniac-
>>> xw.zhang@hp.com
>>> Subject: Re: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
>>> timings
>>>
>>> Hi Greg,
>>>
>>> This patch was
>>>       * originally added to v6.1.35
>>>       * reverted in v6.1.39
>>>       * added back in v6.1.40
>>>
>>> This patch is still reverted in mainline. Was this patch re-added by mistake in
>>> v6.1.y stable?
>>
>> Yes, this patch should stay reverted.
> 
> Where was it reverted in the 6.1.y tree?  And where was it reverted in
> Linus's tree?
> 
> I think the confusion here is you have the same commit in the tree with
> two different commit ids.  So when I see the patches flow by, I applied
> just this one to the tree, and I only see it in 6.1.40 with that id,
> missing any possible revert of a previous version as the ids don't match
> up.
> 
> In other words, what am I supposed to do here when you duplicate
> commits?  What's the revert of this commit, is it also in the tree
> twice?
> 
> thanks,
> 
> greg k-h

Here is the revert from Linus' tree (6.5-rc1):
d6149086b45e150c170beaa4546495fd1880724c

Here are the two times it landed in Linus' tree (6.4-rc7 and 6.5-rc1)
e749dd10e5f292061ad63d2b030194bf7d7d452c
7a0e005c7957931689a327b2a4e7333a19f13f95

It should be reverted in 6.1.

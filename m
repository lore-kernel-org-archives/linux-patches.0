Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5FD1640C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 16:04:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My2WRcspb1zZvDxVYkZY/1R/APWTeSf3I6KAi54ZHcKf58ZlCNMn7bse98JhzfSBOOmBoxj8sNBe6gqwL0wsL0yoUmWc9vR/rmG/JEcX9997WZ+H1y4FxMz3XVW8UZPzSN24A2JW/hZekf1C0xPbMONz/eTVsodMljRzV096Br52W0SyQLT2kPZddGVx2oxkK2a8kWdez5dJYNxqSn4vOojte6iYyUkQM/u89FTfDxOu/kk2yRfI3s4V732Zk5OgyoXp8erLuhDZ4LjfhNfTTxPKaYC5Vzbv7e5inlM9CqbZe49bpZtrUomNfGxd4jMbU9JGZwvT6bJfrw2bJ3UZWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EroJcLxotAtYPXddUSsZEPFar1zU5uKM2qp1OJ0NmxE=;
 b=UGbC59Oq2BNqFiJ2oxV6URQ0Cv00fSqYp3z3Sl62yn3ao+Mdd8XvzKlZeeA2UyGwYFoVvMWAtwLGzzKZk0Phbr1pDNrGN9hdx5hVha4Vkcmlh7jzNqVKSCxO09zW2majWcOkqc5O3p7fSNBteyYzjmD5HuE3EgsHzJTrBUcgfV5bNzyJWJPW5XiDY3sAHGYjvzvVBxVpddwyMGLHA7Uf7LKXkAsy+pBRtBT2LeMnv9P69zkcxNGwydzEqi1Nw0L9b3Ieo8mRzWSbLMuzOxTa4mJ1lhcXkmc1lFnOESsh4IuB9MGJ3yr4nB4vYavMO6ISFRWTV6L3Lmx3VEMMAweCNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EroJcLxotAtYPXddUSsZEPFar1zU5uKM2qp1OJ0NmxE=;
 b=vV4v//HpXon/ASeQN75BcN578wVAeDzRWgvp/82gAwPID/6KXWEDvoQKAN9/xEMk1vg8d+l1+Y9yJMngF4jGVcsaigBfUGpVzHpGcWipeVPLGLXfbG6CIAy7DkFLBi4SHOwB3Y9XYCZi7JxeaAN5q881VgtdNicF14i/uA62b54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5284.namprd12.prod.outlook.com (2603:10b6:610:d7::13)
 by MN0PR12MB5714.namprd12.prod.outlook.com (2603:10b6:208:371::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 16:04:23 +0000
Received: from CH0PR12MB5284.namprd12.prod.outlook.com
 ([fe80::1322:914a:589a:7146]) by CH0PR12MB5284.namprd12.prod.outlook.com
 ([fe80::1322:914a:589a:7146%5]) with mapi id 15.20.6792.019; Tue, 12 Sep 2023
 16:04:23 +0000
Message-ID: <6cbf86ee-14ea-7a46-2aa0-5434e3c3443b@amd.com>
Date: Tue, 12 Sep 2023 12:04:20 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 737/737] Revert "drm/amd/display: Do not set drr on
 pipe commit"
Content-Language: en-CA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Deucher, Alexander" <Alexander.Deucher@amd.com>,
 =?UTF-8?Q?Michel_D=C3=A4nzer?= <mdaenzer@redhat.com>,
 "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>
References: <20230911134650.286315610@linuxfoundation.org>
 <20230911134711.107793802@linuxfoundation.org>
 <CH0PR12MB5284A97461111A04912017798BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
 <2023091212-simplify-underfoot-a4d6@gregkh>
 <CH0PR12MB528496066990E49D4F93CD208BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
 <2023091211-contact-limping-4fe0@gregkh>
From: Aurabindo Pillai <aurabindo.pillai@amd.com>
In-Reply-To: <2023091211-contact-limping-4fe0@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::18) To CH0PR12MB5284.namprd12.prod.outlook.com
 (2603:10b6:610:d7::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5284:EE_|MN0PR12MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: e67d2489-291f-417f-cefe-08dbb3a9ee61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P+cIRBBjrXnBPDuNYc5+urDtjcrewtQYFCh29lqxgnr+Wn/oMPqihfxDq3jhIiTK6rzAKETyR4XqtdbrlE7hoVGhJfZdfNQsDLz56S5Hs5tdpYZeUkdKun5A2sW+KSScrzNwAI13scgWTnCSHjJGLFYfB+xB65s19ujG5qubuobfg912SR+grq0ysfYGKY9dRkpYamP8pQb0TaskULcfIbw2utd+VTkouXLRoKf8/PuBR5E7Ka/cQX4FnyLfAZ7fLP33oScQ+JmKu33Zl/sWuhRSnAiv6JIYppIEDsGi9+NleFvlN+JgPKpqfDHZBNwOtCq8iTXHJmrbwM2jdIrDp03XhKh8NHi5bwxmKqGeElWL0yOvOqzaydiShXqfJCOCjqoMeTW4NQx+3elheCyTiJcoDQdpvN7kIPlyTkl78ab9rT8GtRYZG6ZiosQQFqiw2pyV8RKkmimoTuB/43+x9KaPV4b5m44XBfZNQVeDZ7GxgxYt72iR1loVn1wq0k0FBtBGRh3p/4ePE11vzEzAUr8yAV8NG1HDK8X3/Qy4M7ckD9k7mxlRjE5M3AM0v9GP5Dc6cZevAu57m5SJgC6Q9OvlTkSLcPCietVTXpWNe/0P9LH6HfjRz1ttw5i7e4kfikfmtnORQzb8OwOB4w13adB5aXSwoypRRawxO1LzzYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5284.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(346002)(39860400002)(366004)(1800799009)(451199024)(186009)(5660300002)(31686004)(6486002)(6512007)(53546011)(6506007)(2906002)(36756003)(86362001)(31696002)(38100700002)(2616005)(26005)(478600001)(83380400001)(966005)(66476007)(4326008)(8936002)(8676002)(66946007)(44832011)(66556008)(41300700001)(316002)(6916009)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnEza2daM2F0UXJYUlUySGpNdnpGU2tQaHRDQWwzQis2R3JUUnpvV1BNMnpy?=
 =?utf-8?B?OW1rbmFicDN5UGhoTGd1b1JkcGtUelZ1d1QvV1lsbFZzWGlnTHdYRHIrY0dL?=
 =?utf-8?B?ZG5zK1daMGU2T0NXa01pWk9CZ3JvMWpiY2JZdkZTbm52M0c0dXdQeHo3QTZP?=
 =?utf-8?B?MVlFUDBzQ3drTVBYWWdpZVh5QjlaQVE0ZWJadXZORlFWaFRvSktkK2Jib0xi?=
 =?utf-8?B?a3pHMGVWQUhHUzNvMFREajJyR25JUTNoOUZXOHc5Ukx0UUkvNE1XNFRobUNt?=
 =?utf-8?B?YXBTVm1ReFdxQjV6NTlkdjBSbE5XMjNNcVBWZWhYaFQvQ2tIQ2ZRZENraVBq?=
 =?utf-8?B?aDgzL2hsRU1ENytMVUlIN1I1NmhmZzVneGcrNHpRbHhGRGd0d0ovS1Y0Q0Fz?=
 =?utf-8?B?c1FIVzFtL3l0L0ZabG11aVNSVkVmemxSL1RiakdOcXU5T2NsQU1RbDNVNy94?=
 =?utf-8?B?b2RBZnFOYnhwZnRWZUk2ejFJQXYyYzBZZ1hKWVlidkFxRnpjcTNoVmc2VFFq?=
 =?utf-8?B?MjZRaWFvNElLcGJLZ2s2QXJPaFJlWTRVQklQVldaRm9kQ0tYUFFWZFVidTN0?=
 =?utf-8?B?cEJlUjZ4QzBWRm9FaWhhaDVQc281SS9TUUJXbG5BWUdzR2NDSDVyVzlGREx1?=
 =?utf-8?B?cWR4dEpSUlN6K2dzMVRDeWxubmNHc1FhSHNtcytpZm1MVmVNdXoyQTVLcVps?=
 =?utf-8?B?RkVtdHdJSU5RYks0YTRxelUyUDhWMVBteEJmWEhaU1R3TDVFMnB2UTNXR1lR?=
 =?utf-8?B?Vm93blF2N3ozaEZTbXZpSVJQVVhMbjNXRkZOSU0ybDFXcFRNdXMwcmp0VkhJ?=
 =?utf-8?B?ZGQ4K2srWmlORUkrMGJpZ05SdGszWUNuR3dmQjRsSS9QTE9HckRHNmRxRXJL?=
 =?utf-8?B?T1NOa1hGUkNKOXd5N2lXYUJ6QmtpYmR0UUE4TjYxRjZDZkJ4MGMxbFJjTG1C?=
 =?utf-8?B?M2xrWVdJei9ybWYzTEorekZod3NONktkR1hxVm5JUVp3NjhoNTVUM1dCVldX?=
 =?utf-8?B?NVlYQ0wvNTZmTWVGejdlWTNVeG1RZVhabnhnSlNNd0RVRTA0clVudGtoczQ3?=
 =?utf-8?B?a3lQNmI4YnpmS0hyK05jZ1FNZnRSVTR3c3BJUldMMnJaN1JPZ1Z6TjhmaUJQ?=
 =?utf-8?B?SnNkQ1BrQ0FkRGxqU1BsQ3ZZckV4V2NRVVhMWTBEcWR5NUZqbDRaZ3c3V1RG?=
 =?utf-8?B?d05tTVZxTmtXWTMwK1gwaHNmUDZQTk1xRktDWk5HcDFzQkY2ampjUzFhVVpr?=
 =?utf-8?B?b3lCWkdNQktYWmQyRFIvS0V0WEZUUFNYSUlBUlFkRzgvdm14bTMvdjBhZi9w?=
 =?utf-8?B?TTlPYnA2ejJ0OVg0ZUtkWlE2SEI4d0FWZ0FOdXZIQkovcUdFeE1KT3JVOHpp?=
 =?utf-8?B?eHBCTHBackdNbjRCa0d5NC94QzkrcmpmWkhIWHAzYTNHc2VJZGZVMjA1L0x2?=
 =?utf-8?B?NGVSRHh6UWhCZmQvTXFPdnhFcWVDNVVSbHZPWGRKV0gzWlZEbk9aSWNJTkNy?=
 =?utf-8?B?VFplWkZmRVRVWSt3dVZrbG1oVU9ET0UwUUJKOC9hcFVwMVFXTHJqQnYwVmRG?=
 =?utf-8?B?UFFwUFl3bmZUczZyWVZva1l5anRzVDZORER0eWUzUDVGeTNaTXEwdUJpMzBD?=
 =?utf-8?B?TTkreHJkSlYrUUxUOUxLVmI5TXhvcnorcUh2aXppOHJuK2IzWGQvbThYdVdG?=
 =?utf-8?B?YWFiLzRWdW5qelBlVUtLSkxTNHNHa0ZZVjZ1QVY1NVhtQzU0VWVVZU50RitD?=
 =?utf-8?B?NHdOOFZGYXo4Q2lUR1IzWlg1dzBkcnY5T204VHU5VmVMbUJHR0YrV00zYkxG?=
 =?utf-8?B?SG5jb0puelBWa0FPaXY0REV4M3lyMGZZblQ1WjdDZXpaMW1HZnlzZ0ZzMWc0?=
 =?utf-8?B?cTZhTkhHQzN1MGVyc2RJbExlVlIrMm5TMFpJeGVRODFFSTU0VEdiK0hWdUJ1?=
 =?utf-8?B?L1cvN1FXU2RWdCtWVzd0VFB4dFJZMmN3SHZHbURlVnBkRmpEWmpHQ3ZtSDBS?=
 =?utf-8?B?enEyZi8vWVdHbGw4b0lTNWRHRDR6SUlzeVlidVJBMGhvRThSbjQ4YzlzcjZy?=
 =?utf-8?B?a284cDJXS2hsRmNHa1hBZmxuTDZLdjc0N0ZJNTVtQ0VFWlRsZjZOM3dxQUNE?=
 =?utf-8?Q?oWxpPzfycggVh2sK4BsVYJ9En?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67d2489-291f-417f-cefe-08dbb3a9ee61
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5284.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 16:04:23.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loSMl2xi7Y0JU3sZ47j1rUG6Qv2iHefp2GzCyI0U3WtqcJKDEwZ2T4iwkltgEZzmrc9EQR3vafAJusGIPTa8CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714



On 9/12/2023 11:39 AM, Greg Kroah-Hartman wrote:
> On Tue, Sep 12, 2023 at 03:31:16PM +0000, Pillai, Aurabindo wrote:
>> [AMD Official Use Only - General]
>>
>> Hi Greg,
>>
>> It was reverted but has been re-applied.
>>
>> Here is a chronological summary of what happened:
>>
>>
>>    1.  Michel bisected some major issues to "drm/amd/display: Do not set drr on pipe commit" and was revered in upstream. ". Along with that patch, "drm/amd/display: Block optimize on consecutive FAMS enables" was also reverted due to dependency.
>>    2.  We found that reverting these patches caused some multi monitor configurations to hang on RDNA3.
>>    3.  We debugged Michel's issue and merged a workaround (https://gitlab.freedesktop.org/agd5f/linux/-/commit/cc225c8af276396c3379885b38d2a9e28af19aa9
>>    4.  Subsequently, the two patches were reapplied (https://gitlab.freedesktop.org/agd5f/linux/-/commit/bfe1b43c1acee1251ddb09159442b9d782800aef and https://gitlab.freedesktop.org/agd5f/linux/-/commit/f3c2a89c5103b4ffdd88f09caa36488e0d0cf79d)
>>
>> Hence, the stable kernel should have all 3 patches - the workaround and 2 others. Hope that clarifies the situation.
> 
> Great, what are the ids of those in Linus's tree?


3b6df06f01cd drm/amd/display: Block optimize on consecutive FAMS enables
09c8cbedba5f drm/amd/display: Do not set drr on pipe commit
613a7956deb3 drm/amd/display: Add monitor specific edid quirk

 From https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

> 
> thanks,
> 
> greg k-h

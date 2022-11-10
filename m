Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A258D1E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668117526; x=1699653526;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ywMXjtLgopIVLtpEBzXDFofWmvrPYvbbIE0JWmRj9K4=;
  b=DZNupvAP9knUqYVelF8wUTQf6Ti/n/FEstk5FoImKrD6EoEPHfzu89PO
   j0VDMP/oBzGFNSp1j1sGQoUWetBiDlZ1nl5uSAdbm67TL2dIcQNabGGtF
   YioLhbdY0OAxjOTxLBsML+XI9sBYmOK4mpKDe+lIpeQKHIdH8jDX63PS0
   LSXRDLjiQkkYEfrw7enAXo1gq5hf9cWuZ4AaGm9BjhJ8AGSXkQidSMWVu
   fJlOlCVe6O1N+tPoo+4bDMDVthcUxnvGZSO4w9GA1NtYykoVZr53ZcfWf
   bDUkDMLX0NttN3agATPPrqr5OQbRun3SiBT3bEz4MtEeu0TRLtYg5WvRl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="311456863"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="311456863"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 13:58:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="966588292"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="966588292"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 10 Nov 2022 13:58:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 13:58:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 13:58:45 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 13:58:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE4ydLaut3GpTDfNiAPgm8RO4Snd/YTYyosnKnpWqDPU+7VlSt+MvwTLdEVo432nENx0rk+f7YBHtoeWEE9dj+JFfMB4c72+bb/Zml7wN2+Bs57wKWeIyUfDwmYCy449vU5j6jNBchTx882mh+OqGI1zYFSNxfVe51JNTCTmoItX7FWa6Guhg4XomuOyzEeeA9Nh6thVNLNl3M6heXr+MXGltpAp/PBAvgpI+mX5Za+lQAhN8uMmzaLeCgk2KLnBolVcMyMxAjbnczz4k0x88Cq+wWxTnaO8OuvmNm23IgvMueUFqggxX62sxYGtUbSq/S+1fTjyZrh15KPHUJ/Aew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o23XmIQgqr4rSOljsviOFxDIvhvasbugMMmc7njGdAI=;
 b=W1/XSIF7I0N8cDP9trDVOCF7KYBV61lK7ykjXPAVISQvp+4bfwWPXA0K2bonbFzUlkCTJxSm45DCfYm+XEPFOFMw8yqnjaejpDQAK52hVL4d07fdqFPCPUpCrTo4+1H9l5MsiTfm/1akmOoyuDk7quWStOKq/MqGIeMJfbrE5865q7lfHwbANwW0Iq7G8HMP7vOJ7PEowghbFdKvkhrgLZg6ITTN3tWNfNaLJQGXq0Bils4k3Esp7TIFle+E3XtLxG5wps2S1BaQxSdJxGBDnhgh55BJiTqWRk80wXpY9F7F0Zn2E+QZ6f8wj8BWc40AesoKZ9+UIasOqFCyxpTH8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3768.namprd11.prod.outlook.com (2603:10b6:a03:fa::20)
 by SJ0PR11MB5616.namprd11.prod.outlook.com (2603:10b6:a03:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:58:42 +0000
Received: from BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::f980:8dbd:ddf0:11c0]) by BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::f980:8dbd:ddf0:11c0%4]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:58:42 +0000
Message-ID: <7d4b5f20-68c2-5464-aeb9-a3afaf52b827@intel.com>
Date: Thu, 10 Nov 2022 13:58:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 00/14] IFS multi test image support and misc changes
Content-Language: en-US
To: Hans de Goede <hdegoede@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: <markgross@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<gregkh@linuxfoundation.org>, <ashok.raj@intel.com>, <tony.luck@intel.com>,
	<linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<patches@lists.linux.dev>, <ravi.v.shankar@intel.com>,
	<thiago.macieira@intel.com>, <athenas.jimenez.gonzalez@intel.com>,
	<sohil.mehta@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com> <Y2zLYDmO1fkOmFgw@zn.tnic>
 <c4b0cd93-767c-a778-6a38-0e4d981506d3@redhat.com>
From: "Joseph, Jithu" <jithu.joseph@intel.com>
In-Reply-To: <c4b0cd93-767c-a778-6a38-0e4d981506d3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:180::39) To BYAPR11MB3768.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3768:EE_|SJ0PR11MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 632fdf98-4ef6-42bc-4f5c-08dac366bb50
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEhFPo8V40ZPreDSgsIcq1NhZyrLMnlcxJ9dNwYDYDN6kr4VlH6k1nJl1bvoFxm7qZweFdqK0leuL9S78HQeURx9raQbaxjiuBf4JpRifgKuxXJK7RCQ433ho7wQq6AUdSRYKDKuFn7u7WHr76jIjfR+v+2g9SdmVIbPLsVh692DfG1ZhOB66qL35UKV4azP3jb6Xj4TldvJnV9JBQnYTsNWZgT3S8PNPBNRwRNqmhx5WOmixE0lf6+i2msWcpkn0WDC3lnSKS0rgKrpxkNOEcxewk0zZJa1U5ereIu8dWJrtKWjGJHfXgroC59bvSmmKWgOLRpt9EmBU8LFbmkvSiqd495Rm6dxuXOVYByHnphCrD24vCBPTiMV792o164Qx/wUqJthPvJhB7a5egoQPyDrIJHwMkTOLbLnJyO0PPupaWzQEmg5xkrm4Dv4MkcjG4EvJCNTvWmL8Lmh0Jqof7M6mc69xLdQnL9qCt+ARGsEom4UMTbp0Et8L1DUoPks6ZRlI3fQUHy89fuXlBpN7qQJwCeturULMyFxh8upLG+jHdJPoguvY+4oREUe5xNNV0CgkBukFpVz924tgMllBTCx2ZBMMyf5JwmTitd6jGB0AFCMDMJd6BGUvkASpZtDFCCwLM70eqP/obwS5hfjC6fC/M8UbL6PH0tRo0Rtt5W/x0Q8JaJVXJQblXM7QepDJHfVuJjLCAXoLTWc3bJw2WHN3KB4AXALJ69N6rIrXoWqqVAejM15FDiCCLDlOjtK7WrkoKbAsuMO4fWD9LdXmHjaX6Ti1Rq+DfmFVrhf/fs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(82960400001)(36756003)(66476007)(38100700002)(66556008)(86362001)(41300700001)(8936002)(7416002)(316002)(4326008)(31696002)(66946007)(8676002)(2616005)(186003)(53546011)(2906002)(83380400001)(110136005)(6512007)(478600001)(6666004)(26005)(6506007)(6486002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHNzNlF2aUJxWjZoU2ptTGVkMGtXTVplNi9ndHZJNytkdlF2Unh1Vm0ybGVM?=
 =?utf-8?B?L3pOalQ2ZWpQVFU1WVQvZFNUMEpENXRHdUxOcHB4VkwvWkZNam9WQ3ZpcWMw?=
 =?utf-8?B?cWtPanNZS2ZUbWpOYytyNmFlRXhrRXQxSGpIRUgxcDdHdUxiM3A5VUVrREtX?=
 =?utf-8?B?YS9ycGF0bXgvYkNBblYxUFF0czZyWExKY3M2OEYxd013YUNFelFLMEhTcmVn?=
 =?utf-8?B?M3J0Qk9uK2d5NW1kUzdhbnFTYmtFSmdDV1hmdnBmSG5HUmRVUjloMHdJd004?=
 =?utf-8?B?ZlhqMjF0dnNVR1ZQcHhLeUlIblY0aUtwU1pNakNhZEVDc0FjbVMzQmJqSG5O?=
 =?utf-8?B?THR1TEcxUzhNaWlLeFV4dDZsbXcrbGY5RGFhejJFdGJxdnZJakNXZ05TVUVL?=
 =?utf-8?B?TG9ZRzIzcGFFNzFQaGpFTEMxaWdpZGJoS1lDbzJETnlsNjQ5RzBvRjRzQ25X?=
 =?utf-8?B?OUVXL3RNd3IrQ3hFNXBYOSsxNjEzQzFmaExuYnVpV0NzZ0dzK2VaTG9ZMTFX?=
 =?utf-8?B?WlpQZUQ1aUg5RG9RcXRiTzRRTWc0SWtvVkc2M0pqMGtFQ0g0RnZIaXRtMGQx?=
 =?utf-8?B?Sld0M29NUllsNFRad1dPOXliWUdIWWVvdG1jL2ZaTWtRbmloZUJRLzNZNG9P?=
 =?utf-8?B?dXZxaFNDZlE2NWU3a21lMTFhY0RTMEpQcFhQNVpMelZ0RktYMnNIUVNNWTRy?=
 =?utf-8?B?UTZuV1JRYXQvOWFrUk1SOXkwcC9neEppRDJlMDF4a1kxRnp5Wmhjdnk4YXRn?=
 =?utf-8?B?cGI3R3NvenR3bWo0d0pkaFFkWFhKWit6WVc3NFVhUUVPaXI5S1ZxK2NzenRt?=
 =?utf-8?B?Qmh6dGluYTRPOS9CK1NxYUxMUElteGpQRFQ1TkowZlA4Y3JOaWNyTlo2VCtm?=
 =?utf-8?B?Mk1wdUoxTXJ4N0t6cFZzQlMwSlA1b2dzeGRuVDZYd0xtV25mZ09lK1V2L3Vx?=
 =?utf-8?B?VW05R0Y1bXJwRURuQnUyc1ErTXUzbFZTMXUzdGoxQVg2Z05LenhxRWp4ajJj?=
 =?utf-8?B?RktRVG9YSjhQM0hxd0xQUkFDcUY0bHg4b29BUlc3OURHdHdJc1h5ZTlUckdw?=
 =?utf-8?B?RFVpTkp0cDlEcW40dmpxQ0Vmc3ByUlpsSTYrdTFwcjdaNWdobUtVRVkxdmNl?=
 =?utf-8?B?OTEzaDdVRUhRUTZHbUNDU0VyOEM5Y0J3bXk4SmFuMUd4VjhFRjVMRGUvKzdZ?=
 =?utf-8?B?VUFiQ0tQTHFvdFk5NnVxWmdKUGlrM2ExYk0zNzVQb29vUVpSc0F0bUp1UERh?=
 =?utf-8?B?UVVuTWtmbTBlRFdZYmVuZlRidCtBb2dMS3cyQ2lNY0hEUDJRYk04QS81Y1Q1?=
 =?utf-8?B?Yy9nZ0JPS2lqTURsTXFKdWl1RlFJNDhNSUh1TkxQSkNuVWhkMEFkc1FLZWNV?=
 =?utf-8?B?REFqdWc4bUJ6azRUK2FpVzR0aGxFMDdXTmZPQlBIQ1F4eG1Ub1V0SVZVUW9Z?=
 =?utf-8?B?T044ZjI3TkV6NDFvK1NzUWJ1cm1KTzBHTmtacW5wTzhCcHFIekJ5MFhvM0dM?=
 =?utf-8?B?cFEvY1FFQ3pNRytySG90Y0NoVkpPL2d4N2lzaFBBdnpCUlpEc0xBVXo0ZXU2?=
 =?utf-8?B?Uzh5NWVRTCsxd0t5MDRrMkxweDBnNkpnYkNSb2pYZzFreVlEYkV3L3JlaGZt?=
 =?utf-8?B?Slp6V25qKysxTWFXRW9JTXJSWkFJdGJmZk1nWTdOQU5mUHUwQzdEeFNhME1u?=
 =?utf-8?B?Wmpqd0VUWkZQdk41Q1dJNXVPUjhiYmhEaXlKNnpPN0tlRExsUVJJOTBaYklK?=
 =?utf-8?B?Snp0Z09wMUtHQUxUZFZFQlVDUEcrSjEyK3RJWHlsQUFpYTBTQ2llVmswVXY5?=
 =?utf-8?B?ajJQNTNvZ1VaT3kwNnFyS2xOR1JaUzZ3bFMxbHMxL21sc2paRnVPQzgxenF4?=
 =?utf-8?B?ZDNHTEZFWnZjN3ppVGYyYmUzMzgxelhIYmpoa2tSS290dnlWeFVFTml1WXFI?=
 =?utf-8?B?RTg2bVlhZ3R0SW1UanpGZUIwWVllOW0yY2plQmIrWitjbVVJWHV3ZUdlVVh4?=
 =?utf-8?B?V2V5MW00cFc0akRqbkxoRnJBWUFoV0dYT0NSSU9rTjFKbzdJNUZ4eXQ0Zms4?=
 =?utf-8?B?V0dZSFRvNUdSRU5GUHFzL1kvZml6bW54dkVwZWdtYTh4NnRMZnhKd29MRDhF?=
 =?utf-8?B?SlMrTG5lYWJ3R1UyNDVoM0lkaktPTW5jc2NmeU52ZEgrTE02aGlCSmQrUGVh?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 632fdf98-4ef6-42bc-4f5c-08dac366bb50
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:58:42.4748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BI01whFZX9qLWqaaO1gfDP53QX1iov5aZb2lZCbcbgkyoib2wHfKikoxOzd+fGW9ZogHXvFqpV0h9luTkWOUyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5616
X-OriginatorOrg: intel.com



On 11/10/2022 1:37 PM, Hans de Goede wrote:
> Hi Boris,
> 
> On 11/10/22 10:59, Borislav Petkov wrote:
>> On Mon, Nov 07, 2022 at 02:53:09PM -0800, Jithu Joseph wrote:
>>> Changes in v2
>>>  - Rebased ontop of v6.1-rc4
>>>  Boris
>>>    - Moved exported functions (microcode_sanity_check(),
>>>       find_matching_signature ) from microcode/intel.c to cpu/intel.c 
>>>       (patch4,6)
>>>    - Removed microcode metadata specific code changes to
>>>       microcode_sanity_check() (patch6)
>>>    - Moved find_meta_data() from common to IFS driver (Patch 8)
>>
>> What's the upstreaming plan here - I'm assuming I should take the
>> microcode patches through the tip tree?
>>
>> Or should I take the whole thing through tip so that there's no
>> confusion and having to sync and share branches between trees?
> 
> I have just reviewed all the platform/x86/intel/ifs changes
> and they all look good to me.
> 

Hans, Thanks for reviewing.

Boris,  I have fixes from Sohil's comments (mainly  for patch 06/14). Let me know
if you have any other issues that need touching up in x86 parts (04 - 07).

I will post a cleaned-up series next week.

Jithu

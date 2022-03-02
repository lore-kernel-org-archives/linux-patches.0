Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D3620E9
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646182944; x=1677718944;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kZ5pWhy1BROva5NAhRzEmvger/JpXRnYjMb5oDEnXAo=;
  b=UDjBxWUNY2mfmSNpAb7hz7vdIXjRkq/lqTF1cJJvxH9/S+m3SsoxhF5P
   HhekBHu5eA8yfeR7eVy5nOTCO7Ewpvai7Oq7sNY42Ecocid8HOb83vVT7
   zt7+YCvkoequprQg/CWF/lInRTAlvh0pcNt39SUmiww66zXWls8j/cvXR
   4OyCqlPUGrZ4qhj1toZ/rraZb6spE3mXd2zOgJ6ioe55f9FswARrDRnew
   OtgieEFcg6Y5OkhrQ2bi8jIViiLMBuJDCjR37xvvPNLCN+to1Y0QaROpm
   89t4/jxvnNMTDjiQ49biOWcgbGNC9cwqmHhBVR5GT/P9SMYNmVbV6ed/S
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="339709912"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="339709912"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 17:02:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="510774028"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 01 Mar 2022 17:02:23 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 17:02:22 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 17:02:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 1 Mar 2022 17:02:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 1 Mar 2022 17:02:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWSiZaG3ng5QPdZuKsUZ4L7mGZmgFnNtBuD9d85MEo7tyb+k51KV/M06D7HQEGdPcySr3qPhKOK50n2m2FgIJ+nrPSKn6k09FYlXXo1Wafd1Gxf8c0Dw34t15FciWgg03qDwRwa+GqPKInGL8uEK+yxs/js0IkqMy5W3lJ/XfFUVKH4IT706dnHloXnZwMItT9G1e+pIIQIK7bR+yYuiUBvrDTQKeDbHsNuOrmX7cyJhDX7Q2qrHONEWWrINm5XY/nZ32sHZxH67cZrXQCAv0PV2D0xGsHFshpfoTOSbdedfAgyrfd59oFGlnMd45GOvX/yUGizbIjBo+MKSVHwn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QN3EhaiXRc2EeFwiBgvV2mgSgKyg3Yf8FbyU3fv+vQM=;
 b=GDFIHp8JjNStqVfs/PITlaWLEzbPUYakACM3xmhcbIx0qPCkgHvDtzQjhAz6rVq5TKSEE7jGCPv5lzS/RrwJu9kaQuB6BzMvEKuoru6KGbJxsL2AD+pnAPh7C1AqXg2Gt0K6VdbGbxFGxVwgQBcajnWr6EthmbDMu0ga3t6dFAOqOAGLtk8cR67GSrhf57KspepeWd5fjeAX/GG73Mz703V3O8cX0LqxSlJJskyVphhoZRF1A/3TAYKB4xysEm2a2pQP/58ujnCR76HtpR/y1gOe0xcit+y7WP6dISSwXpG7KztvGib2lMHjuhbTumRtplL9dlyZAWOgjpuDj340Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3768.namprd11.prod.outlook.com (2603:10b6:a03:fa::20)
 by MN2PR11MB4614.namprd11.prod.outlook.com (2603:10b6:208:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 01:02:20 +0000
Received: from BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::dc03:366a:dae3:aee]) by BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::dc03:366a:dae3:aee%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 01:02:20 +0000
Message-ID: <269ceab6-170f-82e5-f9fc-d3fafba60fba@intel.com>
Date: Tue, 1 Mar 2022 17:02:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC 10/10] trace: platform/x86/intel/ifs: Add trace point to
 track Intel IFS operations
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
CC: <hdegoede@redhat.com>, <markgross@kernel.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <corbet@lwn.net>,
	<gregkh@linuxfoundation.org>, <andriy.shevchenko@linux.intel.com>,
	<ashok.raj@intel.com>, <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<patches@lists.linux.dev>, <ravi.v.shankar@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-11-jithu.joseph@intel.com>
 <20220301151744.1ad5e11a@gandalf.local.home>
From: "Joseph, Jithu" <jithu.joseph@intel.com>
In-Reply-To: <20220301151744.1ad5e11a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:300:d4::18) To BYAPR11MB3768.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc994ea-eda5-4d4d-e3d4-08d9fbe84d91
X-MS-TrafficTypeDiagnostic: MN2PR11MB4614:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR11MB4614B405D06796E50AE7FA2A80039@MN2PR11MB4614.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPnEvktcc3EdHNYzsk/IxRjrHQEmKrLh2iX3auKdZshcEd+97eke/2URojPnMA4jvU7CRxotF+kt7aAaWAMhVsswNjMPM5reWa4DUpE7q9Z8Ip8fIS0xm8vF9cgHACUt5zVX2kWbP4a10RoWMEllWXG3zw87ShNASHrGu7Ag8x58uCTBM5d8QE3anfiAM4r1cOn5llQGpKRYifOFCx1t6/b9IGBlY62fPuSIFmrmcilZ658aNS/SQ3H0d6IRWf+Yc+2BrBj1J7yaeCYQn74DVApo7p2Qh7EK0cgctjoxj6yDXvxRn6yTa0T+SDF0O2FqA4EvfG7OGT+FjNnbcQXkgojMbCNjQW23c8KWChZrkoxakiokMtXBY98WVCXDON+IYdnrtKdqryjfkA/X70VNv7haY7XBWYEFHzfNg9Dztr9EGIJ9Y7NNdhMTeeHQPBRVbG5I/DhknyAcv+OyWgKliwgHyAR29dDDes0gm36UDXJSHKiUkKHsODJciDC/ejrnwZ0K/4fmsYaAJwg7ekocYJtSmkAtay/R+9vKCLDbYeSkFfJgKWkMvKLMy80ch8OxPIUsztXS/epov1/yZyzeT987gduRDvueuiqbFVIQZheVpvYUZh6Y8IlhPrzGQJa+Mp64QsfoyhsIyBy7pPMvEfm6m/2TesogMFeU6A6jSuF3I1oLPF6on4fC++wTnnCJxT+YhBJXnryKQTECSdNj2EGuiZuYsm1ObxAq4OiNw0JRdxm0/pteExyeQoyFQXun
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(82960400001)(508600001)(6506007)(316002)(38100700002)(53546011)(6512007)(2906002)(6486002)(31696002)(6916009)(8936002)(6666004)(7416002)(5660300002)(26005)(4744005)(2616005)(86362001)(66946007)(4326008)(66476007)(66556008)(186003)(36756003)(31686004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFtb3FUWTA2eTV6aXRLQko0bU5SZ0Q2ZnBibGRQdW9ubmh5NFBpY2RxNHRk?=
 =?utf-8?B?VWRrMlEvTmRoQ1FSRkFCR0dCMlBVeFRreVpLVzRIclRPQXd4L1JrZ2c5MHl0?=
 =?utf-8?B?ZnRpZ1RIbTN3aWo5aEpTbG1XMnUvaDJoQnBwMktEajRuUTQwK2Z0OVFoZGhu?=
 =?utf-8?B?bndvS3RWODVucTUweXR2cVVPRXlaY3RxZFlKSnFtMXpSOW1CV1RTUTJNRERN?=
 =?utf-8?B?ZEZCaDBNOFUrWEpvb24zMFY4emdYS0JBVmJZTVNwbm9nbHc1NkMrdTgxd0FD?=
 =?utf-8?B?TG9oajJMRW9icWdlaUhnZlEzTXpTMEVxSUlXTmRpdFJSU3RoSVMwcTFyQldU?=
 =?utf-8?B?SC9ET3BJelN0YW8rYmhQaUQvbEloOFVjd284WG1Ub1BMVGI1NjlQaEJGanFC?=
 =?utf-8?B?UmNjVW9Ccm9IbmJVMUNPb3RlWXpoUzRSTS84eG9oNE9Tb3d0cjRTN3JOQ3hq?=
 =?utf-8?B?ZktWWDFPUzBXbm9GRWFMZ1hqb2E0aGtlRmxBbW9lM3AwVE0zK2tabUp3c1VO?=
 =?utf-8?B?eWNKQWFQcG1JNFh1VDN4WUxkd010MW5MMlhBUFlDeHBIdVJGMTFyTzNNdHRU?=
 =?utf-8?B?bWluZVJvay9sUXgwcXdlSktjU1pVbUxYWnRKSjRraEw1NDNZNDJZb2ZlYlVV?=
 =?utf-8?B?dEZyNVh1MUgrQTRZR2JhaFZaYU50clR2LysyMFUxenZKek43TmcvVXRGVmNY?=
 =?utf-8?B?MDlzVmlVdFRMYXJndlBuUys0OFh3QitlcXZGUHBsWnFubitsc1FHZEVHQk9l?=
 =?utf-8?B?Q1l3aWdSQ3lPQjI2U1dRTWM1amk1ektmU3A4UjEzNFRSQkloWkFlZ0Mxb2pG?=
 =?utf-8?B?alVBaUtUV3NoOThsRHVCMVlSMGJHUmlqMGREc3Exb2w0L0s1YW01QVlSTmI3?=
 =?utf-8?B?NzNsSHBDZ1FxY05COVNKREp2aVJMQ1Z2emp5bXBUQ2xqMHdHbDRkRkRFVUpJ?=
 =?utf-8?B?bUt1SGFMU3JNRWdCUXZLdEZuc2t2cGpNMFpLdXpOU0h3bVNQVUR4OUdlSVcz?=
 =?utf-8?B?NDIrT21tWEdYVDQ3c204Yk9JTnBYQWxTcDJWYWxPd0p5L0Q4K2N3bkNhS1NR?=
 =?utf-8?B?bjVWOFZOQlI4Q0NzdkdXbmNpcll5aGFGNU1rb1ptYmtNaktLdzgrUjFsL0V6?=
 =?utf-8?B?Zk5IRmhia2NyeU1kenVmZCt6UWM0MEpLSDBFekV3Zm5LK3dJb2hhdUl4TXpy?=
 =?utf-8?B?bE9NajVwZ1gwWGFnZTVNazV6V1NXRDZCclNwRVBTUllIZC9BdmJMeDZSdy9L?=
 =?utf-8?B?Y1JUTDNEZFlRK1J5SGdIdFZKNU1IS1lkSUNuRVJwRjY0N2VENGU4LzNBaTVz?=
 =?utf-8?B?SHF4dzBCTzV3QkxFMGVZR2txNCtZTk9qTnJHMmFydlRXMTRyT0JSWUp6cVF4?=
 =?utf-8?B?ZlFSSktNa3laMjVvcUJ0bEZkcXdPRWhEdzBvUTB2ODlweXJpTHNTNWJxZFVr?=
 =?utf-8?B?eXpHenNhMU5XeWlkbit4UHFlZ2JYR3Vpa2JyU2hWbW1aOElENjNEK2JmM3Nj?=
 =?utf-8?B?eW82Sm9WWndwWGZ6Vld5bFJOVnhiY0VpM2c2T1ZIbS8xc1ZWbjlkR0Q3M09S?=
 =?utf-8?B?MDZzTHVuZmZjS29KVDB2OWlsNzFTV3V1dEZualYxb2RMUXpnMVExL1ZUbGVK?=
 =?utf-8?B?V0hQa0EzVzc3Tlg1Q1BOTzRwNUpUVUhvakpOb0wyS3NPb0J1OFM1MHZXekhV?=
 =?utf-8?B?OGg4SlRWRERqM0Z3ZnExazVCNGdEL3piVGQ3WkIrZUJ4TDZ5cnFVYkFPVytU?=
 =?utf-8?B?V0ZsSDZOQUdhdHFwZTFTRDdUdGpYRHBnL0pMaFJPYVdGN0h3RE9mTnhxeFpk?=
 =?utf-8?B?SlFSUVVadnZ6QU50QnhwVWYxOW1VQU1Qa1VOekFWUks1OFc3UnQ0MTVRQm9o?=
 =?utf-8?B?ODVhbnFaM3RWQk1wT3NlTTJSS21oSHZqdnJVRXNaSUx6b3NtaHVhZXF5QTho?=
 =?utf-8?B?c0VoZ0kyWitlVXhwL205Tk1YaTBQdTB3QjRpWWVYcEh1Q3JnQkluRTBCMC9T?=
 =?utf-8?B?cEJJUkR2ZHNSU3lJcjBycm5wdUZibXhDQzdRblRjVm1nZWRiOUh2TDJjY1Ev?=
 =?utf-8?B?NERWdm94UUp6UnNVSGhXSjlQRnE0cjF0dzBXcWhkSXRwYmZ2L2piL2FyNnor?=
 =?utf-8?B?czFTNCsxTWNESzI1eitCUUUvK2lzenRPZTlDV1NwQjFQcFpzVW1INkFXdThS?=
 =?utf-8?Q?Z4uBgsAxPgW/ywjqTqomAXQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc994ea-eda5-4d4d-e3d4-08d9fbe84d91
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 01:02:20.3745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7OIDXZ6PW8wQ74cjQFy9oU9Yymx4+ny07lbn6H+mQBQH9k+AswqAk4+ZCTLhYTmhvzkAW8jMhA7zN0ZbU1Z5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4614
X-OriginatorOrg: intel.com



On 3/1/2022 12:17 PM, Steven Rostedt wrote:
> On Tue,  1 Mar 2022 11:54:57 -0800
> Jithu Joseph <jithu.joseph@intel.com> wrote:
> 
>> +	TP_STRUCT__entry(
>> +		__field(	u8,	start	)
>> +		__field(	u8,	stop	)
>> +		__field(	u64,	status	)
>> +	),
> 
> I'd suggest swapping this to:
> 
> 		__field(	u64,	status	)
> 		__field(	u8,	start	)
> 		__field(	u8,	stop	)
> 
> As trace events are usually aligned by 4 bytes (sometimes 8 for archs that
> require 8byte alignment for 8 byte words), but any event, putting the
> padding at the end of the event is better than in the middle of the event.
> 
> Having the u64 come after two u8 (two byes) will pretty much guarantee a 6
> bytes hole in the middle of the event.

Will reorder the fields as you suggested. Appreciate the detailed comment.

Jithu



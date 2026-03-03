Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A1A3750CE
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504351; cv=fail; b=ovMBe68ysQ7+8/r3+Rg5EMp7vBZP2V3TU5eI0IKT+taCkQfqGxbkDV0i1EmXzXv06kpPteR7EosP+Mjrkm9wMNvqZNdRGrHI5meIrWgfEwHLOjWPWuxeqUPx2Z3SWWnNvk5TD4/YmXL/0YunT7ZNvB5NXaUjZgdud1hETlVcts8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504351; c=relaxed/simple;
	bh=1jVJ6QwHFcPWq+rToKuCBXw48YL69xKQaYeEAdTp0Jo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VURWbOILzcWQxhIU8DOux6SOsxfZAQ+1EkCFdqielQJuNwVLJvm5zGbMYRnsZnH3WtMQ+VPgTvSrQgBvmicO4XHxZO+8t46UVpP1zeZvAqleark6BBp0Zh0xxtOmmLz2tbp1cnkvcLmFaQO4THdl8iNJZE7VI3/erWqGnHFOCfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SBqVUh0w; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SBqVUh0w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772504350; x=1804040350;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1jVJ6QwHFcPWq+rToKuCBXw48YL69xKQaYeEAdTp0Jo=;
  b=SBqVUh0wWri0J5HaXw8u6yplb/k1SCVC0qS1OfqsjDg6yLO9TSHg2jaD
   yy1GGxLmwGWGdnCO8zYNLjt1L2WdNNIYMZs20UNJYBslcdCZsySbkFUJf
   vGCXYEwjCn0SEZ+MdE+q/p4b7CjEwwN9r88YHDbUstysV49qRNY40QQXu
   x9R9HQTQikU+/H60R6umCrkJgonmWnU54jOPHXx8lvaVeEfZtUHLXRlje
   +353/S11pWxlbO6uxY0sCNZX10YwNvhsnl+HEOUDiHSOcTNjCGrGHVfL4
   5XJx7kRQggfyRRGgeslUe9UrYlgm48xTPlZfPVd6CuInLpXeSX6U/0BAR
   g==;
X-CSE-ConnectionGUID: H8M96meUSk6yA59D5Ak7TA==
X-CSE-MsgGUID: 8h4GNRvuS2qQ1vTzvvlNig==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="72556230"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="72556230"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 18:19:09 -0800
X-CSE-ConnectionGUID: AcA857lhQrCzoD7ey6AtzQ==
X-CSE-MsgGUID: 9iku1FjlT564ojPEbgG8sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="240858827"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 18:19:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 18:19:08 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 18:19:08 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 18:19:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8YPioGs1fj9RjbJXn/AaiHcdcKxcvVMjtIC2316ijPSvEFYOfV1XcNfRgLe+U57KZZRxxYhEg9yxj57AeZ1MYIeBnwpXiR3YUWGjsjDHXUG3YKVNW5o6FHc8i+MAKKI8OWkT9M+snBOseCdDwf5bS8+Y4/DXqN+A9J2yWdCcixyW+xZeBQG5FDpeF9Xk6lKCzykJ+m70pezIOVraSni3j49HTlcddUbLhU/igTpfcekBuDoG6bc0HqvftV3qGAYFhUVpcJK+W20bPxDElokf2RnMbxr+HLSpY9tIm8RyJWBavCUxPiET/9sqO5C0UUh/aC80HK9hcbhH0wFvzkFmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoVdTQ5gGg65Wkqmh8qRE21Z1cNp1x8Eo+cyk7L4BRs=;
 b=VKKdjGtsJ6x0FcqrGGdSVUrmZtg1zUr8hJTOE4MBn/WLHJvZsIf/2rwBy41DrGcmFOF61d/OWDtoDa/c6B+CSDUxFas6n0f8zFE4en5dF+nlFi02niXmA85Z8vlnU49laFfAjCApp7BG4R4OCGA1W1+I8+EyXY2Uac2ZlyvqjSph+xHdaFG3dRW0WQqa8ncmY0MFrWDVYPBiTuKhjcTMH6MBH1XDaFPj1eCaMpxdNKXPGMPllqeq+eyYTu5t2omOMROBOXJx491tkJVOlNYTfq3BIwTdUPH3i1/gU1Axua4OJ/G83kXUHhEsyYd4Uwzr6HkLzZD5VRPDrChGguAm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB7470.namprd11.prod.outlook.com (2603:10b6:510:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Tue, 3 Mar
 2026 02:19:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9654.014; Tue, 3 Mar 2026
 02:19:06 +0000
Message-ID: <ccd92176-89f8-42ec-8313-5b5f3b8c402c@intel.com>
Date: Mon, 2 Mar 2026 18:18:27 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <aaYfSTppsqwgMz1d@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aaYfSTppsqwgMz1d@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0228.namprd04.prod.outlook.com
 (2603:10b6:303:87::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: caa3d21f-c3b7-4aac-e2e5-08de78cb3ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 3c4kJz1mlVf59kJStjDPMPCtnd1OTJEJjz9XhJpyHow1o35m/oPU16ngFkzcqyHM9AeD62pP4kdNkZV+NawUor/n/tSkDjx/IVwC+DJ7DPhUz4//HOE3vAXad6jTFu4vShVFrxggiEbzNXU7aoVlC2i4LCfo0J1nkUSbfvjsQPWL3MvuIr32FykZq/xsRFtaBUqg5ApPnODXacXrX8btzHQ0Gmvoy2fTyGuoxj4Abaul5G+q2A81AXt9neOjP5PXaZ9fWenecPJxiIdfpFRedhk1aPgLcSYk2b6I4Kp+IBVSHh2NyX/JTGE6jBN8czxkRzC6kOiS9aRz1C+DJvaU+tyCl43RQyIPRMHQukYJYCq8HbWXFoCk9kuRy/1hILcUB2yHDMTpxzd6UGL4sCHe6PQ+y2b4ffikM8tmteN3JmZ/9gHWb18yHM6wWI3/+dC2PGL8c5cCUGQf0tkmJNaAEARuwlW1pogRTvg6lCEE078csEIH67xyoMleBfLhvCAKrJtgQcs5rHll1qRdPSoereScJ436OPqu9rwI9/CANiX1t4SVgJGMY6tbmEyJn+mXz9cfG3q2cc7lpMdCfCYXw197ydaCbltCHQeGSr86ZMolUNM5jP7OL+AdcOxIYmqa0kALEknOS6qftqtw8LWhoeQ6SdrKH3H4l230MfNn374CqFFKIPGrs9axL93f4Dt0mtLg+KUAgxpvt5IuX7Jg3Q2wZ4E3WWWrUlU+rK9XnQs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHpNZXp3MUw4V1kwYjlWYmxzQkFzZjlhVVF2YnF1UHFkbGhyMTFzZFBjWkdN?=
 =?utf-8?B?dGNyV2dlOVJORGROdDgzZFRYWHA3dkVCSjVFSG1pRHdnVTNPRWJuOG1lbVFt?=
 =?utf-8?B?UnVCTjM3dU5QcjN2WVlsQi9JR0pNRkUzMmlrK05NY2VBZG8vMzFlOXphekNL?=
 =?utf-8?B?WmRhMVZ3UGVSenlTRk9TSjZPUDgrMlNpcW9rV2NHSEJId29hQVN3VWdtUVBG?=
 =?utf-8?B?VDBReGVjL2R0dmY0TDZuVWNIMkw0VE00SzNibVo0MlFWOWhnV095WGk1Rzhh?=
 =?utf-8?B?Q2pkckI3VXFqVVNUczQ1TUJ2NnNoVHo0U1Y0Y2VBUzZRZUoxcGF4TGlTWHQz?=
 =?utf-8?B?QnE0SUFuNVRrVUg5ajhySGsyVk9KVlllYjJyNTRZRnVWblhwT1NYQWlOK3JG?=
 =?utf-8?B?Y0hnSVlmR2NnU3pxc2FmZDJ1N3IyVFBNRGtJc0JKSUFBV2lvRmkyOWp6WHJZ?=
 =?utf-8?B?Sm9vWEVBTDg0cWk4b2Y4ZzFnVWVNaVlWTUxZcjFiSmh5RnN4ZHhNS1RCeEtG?=
 =?utf-8?B?am9ERTVXSFpvc1I0dk9wSS82bENuUmY1WU5tMmhHcEVlbyt1L245cUR4SnB1?=
 =?utf-8?B?WnJnZGR3K2VHdE4zUW91TktDc25OZ1NFTVZISVRhY0NNN2NBbFJSSXd3Mk9B?=
 =?utf-8?B?Kzc3Mkw4NGFQVXF0ZFg2QWJLM09WZkltWm5YME42ME1iYlo2KzQ4MEZqamJI?=
 =?utf-8?B?ZHRSY2RqZ0hwOTZPMFFaVkxXR3V0ZjNKU3JHdDV1SHdsL0Y0NUV3UmZ5Ykp3?=
 =?utf-8?B?VWE0eEpCVWlwOHZDNW5xNDNveUlDSXJiYzJWV3dkSlN2VVZsa1NqYktXbXEv?=
 =?utf-8?B?Q0RKdnZxUHpCZC8xWSs1UTJXVWpRd2hJY0FxNG1hOFNUT0RUNXNZbmxEK0l6?=
 =?utf-8?B?WUs2dUpOMXNucWxFV0VEbHJiNWh3VHEvZXpOQWp6RU93Z1RpVTQ0MkEzOWxo?=
 =?utf-8?B?Wnd1TFo1MmdTSjUrdTg0ZHl5akd4UjVzSmZzdk9MSnFrME1DUnpVMUQrTUlm?=
 =?utf-8?B?Y0FUOGdkUUFMdkdBK3M5NkVZYUVqVDgxRVZVZGhtSGF2YzZ4M1BsVnpuRmZ0?=
 =?utf-8?B?WUc3cUtHR0dZVlFTZ1N6RnY1cG1SZklRZTNwczY1MW1YYUxwWXBjRytUQytz?=
 =?utf-8?B?R3haazdlZjRJT1pGcC84emRwOVA3bHNUUEtPNkM2SlExeDNpUndhbCt6dmRs?=
 =?utf-8?B?c25oM1BORUI4bFp2NFdkSk1pcHFhbW8zQVpOTzNCZjUrYUNmTmdONHNocTJ3?=
 =?utf-8?B?dHpCRXlnZzN5c0tpeGxNOGRlWDFweW1rbDRNMHBjWVZBMUJ0YXNXSU9UZlFj?=
 =?utf-8?B?aGJOem1POFBLa2QyMGVET2FxcnB2cGkxb28wKytWcWsxZTgzNlZiUThXYjRa?=
 =?utf-8?B?UjRpUFoyK080Ym9wRk9WcHJjcThiYmpHNnNaYnI4dklUNkxLSXEybHJDbVZG?=
 =?utf-8?B?N0VPdndRajhXSU1RbDI1cHlvakdES0Jkelh4dHVLcEx5bUlMQmQ0enMrZXgy?=
 =?utf-8?B?SzBZUXd2R0xqWk5tVDRvRE9nUERlazdIOWRFaUxNQzJoQy9DYU1FUXpoUHlq?=
 =?utf-8?B?UkVIQ0lKNlZYeHhSZko2Qm5jakVtdE9WQTVRTWJXaDZDdEc4VkRVQWVNek42?=
 =?utf-8?B?QzRTaDl3RlF1bmJSdGRHblhlNDBzdFd3Y21zazhNRjd2Wnk0ZnVZcmlUS2xx?=
 =?utf-8?B?ZmhlSnNMbTErTXhBQWYzU04xdVJYRGEzSUd5OEJnS3JpZVBlVUJ6SGUzUEdh?=
 =?utf-8?B?eTBFWU9DL1kzNnV3a1VVMVlkNFRSaDdoWkRRc29xWmNyNlpHdkhrYVpyZlFn?=
 =?utf-8?B?ZGhTUGtUMWdVVENueTNScE5VQTFoK1FpaDJPek9YbFQxb1Q5bnphaEorMVlu?=
 =?utf-8?B?R2x0ZGRHeVluUFhXQ1VocDVTVnJ4VEw3N24wazArWWxhbVdOeTlBMWkwc1pC?=
 =?utf-8?B?aldqZEpkK3VrSjlPZUMzNTNCMVBndXZkYkdSalFhRFc2Ui9HK2gzMUsrOVc5?=
 =?utf-8?B?dHhwcXJQcm1LbVNpZE9vS1VwS0ZTb3RzN1hpZGNFQm9uZmgxR2t5cXlXeEJF?=
 =?utf-8?B?RERvS0FtdWd2RDk5Q28zaFZSbURHM1ZscXFCRlNQTmVqZkN5RzUvSkpWZEVO?=
 =?utf-8?B?SEpySjR1cjVyZHMxOTVxc2liZkVBWXM2b2llR25sOFhJR0NDR2xNaldJRzZa?=
 =?utf-8?B?VVVQdVNscEVuRm5nSGFsQUJNQ083SHJ0N0h5N3JkQVVtUEdjRlhFTVRLcS9N?=
 =?utf-8?B?NExPM0QwOTVJNmtFMDBCZXlYeWIvNTZPckpUOHlIY3ozVG5yRlNrRVJqMjZx?=
 =?utf-8?B?cEg1NXZPaFUrTVpVZzVCOUt0dCs4djFrNjV0OVlQb1E5ejBoKzlWNmJPWVlz?=
 =?utf-8?Q?QcIHLGK79mny6TAU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caa3d21f-c3b7-4aac-e2e5-08de78cb3ee5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 02:19:06.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4Jg0fxv90dc7FioglRI+wgSxK3gQK9XSALkdR5xjQWtbznHYlM8232Ut7lVqRdpubplJZdKbkiLAf401PN+ovvqAcSiBArl9blzHcb4ZKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
X-OriginatorOrg: intel.com

Hi Tony,

On 3/2/26 3:37 PM, Luck, Tony wrote:
> On Mon, Mar 02, 2026 at 10:46:06AM -0800, Reinette Chatre wrote:
>> Hi Everybody,
>>
>> This is a collection of resctrl cleanups assembled together for convenience
>> and simpler tracking. I'd be happy to split them up if it makes review and/or
>> handling easier.
> 
> If it is time for spring cleaning in the rescctrl code, maybe fix some
> bad fir tree declarations too?

I do not know if a cleanup like this will be appreciated but it looks good to me
and I can include it for consideration as part of the next version.

> Note resctrl_arch_pseudo_lock_fn() needs help too, but complicated by
> having #ifdef CONFIG_KASAN mixed in with declarations. It might need
> to remain an exception.

Agreed.

Reinette



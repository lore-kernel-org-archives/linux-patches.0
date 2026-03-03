Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBAD224B04
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577026; cv=fail; b=UatdrZ83h5DoapUTHwDelmYiPFEphbUVkvtwiN6k4hLgn082YMOKCdP54xWgeohnB9YAWn94XQdt1aoLRZTgya34NoAAKoT75SOm5mQZqSS2K8XhHo3dmpYFbOwvHSkO5J/UMnMU44pfXhBl+05uvPVPRumI5n8QvenQTQfYWIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577026; c=relaxed/simple;
	bh=rk6zsC+fMsdgjqVlVE2h5Sa9PIRAOkjbkC7TYROlLps=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FKyYo/EuATBSjbka0XzQgGBCl3YXpMYJAhHAOuv3CtUKMoZYx+srliGn6IWf61+6GTi0KHe7Ht26zGf/2V6gIyaKAmQK6HoScK6eZ0rhU83F0VjYKJHWqYrb3htVosLbCx1+WW9af6duEPTLVhPdzE4mxPuswOHEZBUCpeWWCBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yd+CRHdq; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yd+CRHdq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772577025; x=1804113025;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rk6zsC+fMsdgjqVlVE2h5Sa9PIRAOkjbkC7TYROlLps=;
  b=Yd+CRHdqx5CIJx9e4q9JTy2kGZlldDwX/Jn9m7xAw3c8ssZM2Pjqq1Ep
   Vt8m1ZC4cP2geD7Y+HCWQZsBVMOYsVrqy/zjW6L6n92tuGwRhuqvJNNFA
   qGk3TsL/rKWdEyQ/AY9mVrVwr1eSE/hHVA4S3xGBJ+VIW84kExZeWUvgO
   +UXRdXLZLR+6ywo0qYUfmZ5KgKvBg7VEVah+X6DcIbImNgaUKdPquL2gp
   nqpBcRNFpFNh6D2Owelh6Yjwz4jxeMFjcWvZy7osbMkTBQwpHajRbAUHs
   JXQMRM/QGZZqO6zi1ThiF99vmIBCcbsMuv2hIRhRr85XwuqR3AqCM46qh
   Q==;
X-CSE-ConnectionGUID: lt2VlyRQS/K5ZsucFJtBEw==
X-CSE-MsgGUID: 8K0SeE0sTdWTSyzl3aQUiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73678797"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73678797"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 14:30:24 -0800
X-CSE-ConnectionGUID: VhUdYNPiQhm/z3Oe43l3mw==
X-CSE-MsgGUID: Xlr3D3HsQ7uFFGuaMunc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="218097275"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 14:30:24 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 14:30:24 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 14:30:24 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.17) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 14:30:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9UFe/d0uhxiy7dA0S2+Ja18Usw68G27SQgayvrjwhHbh2+ic+cYzK0LpiF5N6zo4G6INVTOLYXhK///rEQkbtGr740RKaM5zB9fEry2YslqRi478EfuX5nCHUM9G8lFieogGpvJ8VRHU07CyijZNFhKts+y2U71ma6+u1S3TEW20nD4jsU4wrr4oCa1y/0OxUvuwPWJ0yWfxo4J6ygkVYTMXbzl37xZCB3aRXu2bVr23RbgnpZnZ8Dtc/RRIhYt4XI/UFvVI+MQ9Y1nk9dLL6B9/ecCZbpBqs9eaUCrajfR7co1Pt2istmLLtWcbZLg/0NwMXL1RdpWWY5mtPQgOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drMyCal0zUW3E9VOadOmKvbXjj/GSqNoj31ONWh3n94=;
 b=J6rsHSUPWXq8hauCcaMmHZiBEgnMXz7i8Xj/p4wt4q7hJISDu/2T3KMgmXiZfH8AttgnNdCuJcHdnhqT8Sc5chAm90pS6BAGlIrvoiXfNIhkHCiSOihZHBEFf+Dklkl0r8O3++6M9HXjvtGZB2xHzZyfxj+rOn9IL128aEzz7ymhVz9P0cvoC4fU0zZng1UbChtL44DA6bepY0TReaE9o9QkFIfYKXwhOhW8gbpsnxuzCK2HIzcgKpV1VNNEW4DutAQV+4MSTRl/d/USbMSQyriRmiP1nerTSYpeaoQIgCdGNuHs68L4DbEHjCBrR64JEpFY2/OpzYgg+wAHZm0pWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 22:30:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 22:30:00 +0000
Message-ID: <29ae7f66-9e98-4350-9dd6-6781dcd5d0c0@intel.com>
Date: Tue, 3 Mar 2026 14:29:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
 <aacmf_CM52gHRMot@agluck-desk3>
 <a3343e9b-e481-4282-a775-651a516164a1@intel.com>
 <aac8baGgAWgpWSH2@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aac8baGgAWgpWSH2@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 18bbd585-a62d-4816-3e20-08de7974684c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: DB1RzhsUBUPJwdVaRVzhma+1AoOTOepQM9+ZiOBTu0yi76rhyXCGi6lbwoLAXXPUr/6hSnO7XLlRBi98XK8BXjXe2UGc9l+qmBMxp/WDjqY3w/HjIrt984I+WLM4dn1bb2wJyASQQpkpKvVuKPTBvstfxcHLVHhGCcYYhZaTRB4qDyghD019I0eSL1PkJ7FSlOeYXl6cwxJ1TKh7E2QyE+Xdel/QaovQNh44BuQWSSLoQM2omhhefZOS0339p4klGaA7TBnGcV/dYqkppPUqwagvkOpDP6ZhfKZ6jz+X0yxCOqtT1lbILCM1b5Xe1MqSIS9vdtNK92T9/LJByfdwFdGqQTDwQB3P2evo0lSYfPXQ2SLyHJWt2i7GgrAqkrn2Pxsnx2a74NCVfS2oBeLRkCQL7MQ9PbzPQ6mxSnp/pkypB06ktpeHbD6QVST9X2omjtCVw3ELri7z+4PC8m69ilo/UWnpehVCrNHGhB3Z6JEqvYWf8oAiF37m9Hw/lipdvBRo0w0WoESx0Mbev0ZsqosOF0Bme/fvWhlPgJhn5FcHwdoSxn6UQGDo5sVyp6XV5hrIECc7HjehhMhNWdODU+RypmszfwAKyFTuhvqavBBddzgFnuuBRlYLOJGfThPem8m/toIEXAScfHqV342TmO7oLOz6sEm/m2E25sCRqNwlVFR8bK+QSqAjbql1TSIOaDpQa2u/naxPIna2PROjS8JUh3axa+V1eQ3woDV1+fk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRpcWdocml4RDRMQkc4RS9LbmRsN0JDbXZ0TWVGNnNLaWlHWVVhc1VTWno3?=
 =?utf-8?B?bTVNdFFSc0VkaVNlK2dPYXk0M3hjSm5SNUtmQ0xENUhMdEpLejJYNjc2M1E4?=
 =?utf-8?B?dnozYzlpeGFtREF2OTBublR4YWNoSU02ZnVmUi9sdFppa0tQSFNBUHlpNFAw?=
 =?utf-8?B?bXNKMDRRK3pXaVdnWDdUM2N1cHBaNml6aFo3dVFiaFBRZlZSRlJuYTVGYWwz?=
 =?utf-8?B?c1M0SHJQcFFRY2h2dnBad1g1RklhWm1lQXpEWEQyUis2MkFHVUFYcjl5Um5t?=
 =?utf-8?B?K2hXUTZSSmw5VC9oK3FuNnA0RTR1V3kvRnNBMy9FcXlLQzlBalJ5dkViSXl1?=
 =?utf-8?B?SXc5eG81Y3ZJd1BJT0h4UGhUd1RSM05hWndWU0JMcFhSVUxsRWQ4WDNVZW9s?=
 =?utf-8?B?dXhFRjFyREZVcFVHK2tZSjRJOSthQ1llcjZZdTA0cHhJZ3VVa3NWTm41Rzlr?=
 =?utf-8?B?dHRURVVaVUJXNWZadFhpcWlRVVJkN1hobWtJZUZGUWw2UEFUdTlIWHRnWnRW?=
 =?utf-8?B?UXRKQWJPZk0yMjRZVWxVK3RoN2pva0dndC94T05wcmRtZzE2aGZUTFZnWkx1?=
 =?utf-8?B?MUw5VFJtMGp2RDIvU1VSVGx2VmdOZElKalVUN2F2ays0T0VyUFBRV3ZpRnlv?=
 =?utf-8?B?ZGJiNU9qZ0tmQWlyT2d6dGpXSWxNTzRPd2pwUG9sNmRSTzNZYTZxWkcxVWUr?=
 =?utf-8?B?ZmZSSCtrU3kxRGpUMVRCem14Z0lNZEJWYmt6NjN6bjUrNkxRUlA2RGtYMzYx?=
 =?utf-8?B?S3VzMTB5MHByN1lTMHlBa2NkQ0F3VHhGRnNoVExmd3RvWkw5U1UwZ0F0Szdk?=
 =?utf-8?B?VzdzRld0RGhVRERQM3RjaTJlV0tmOUJNMmk0T2syNVBuRjJDejduUmVjd2dK?=
 =?utf-8?B?eVdoc0NsZGxEYmZ0aFNuUDdVblJnRnZxdU9hZWppTTJOU2RsWkFXNnV5NlE4?=
 =?utf-8?B?OFNwOC9qWWtoZnZLTmdWYklFWUJUV1Z1MDVvUUhEVSs0UmhNMXNtbWFINFlo?=
 =?utf-8?B?SEtNcm5HUHpTUUJLNE1kUGlrYkJkT2VZcjhxM2FnUlBzNEJRcExBOWNkK2M5?=
 =?utf-8?B?SzVYYi9zY1pFTG1jRUE3VmpxMXJ1M1VXNWVyNmgzSFUzVnNad3lUTDZHS2VW?=
 =?utf-8?B?Q0R1bHNUYThzZm1oQ0RzNUExUDFHeE16VnJLZTdrQXI3RzJRVWJIajh6OTY3?=
 =?utf-8?B?NzNRbjB0STJ5bTdqelh5Vkl1a3hQMDlZa3d0OHpFRHBmb1cvMVdhaUZQYUcr?=
 =?utf-8?B?ME43bVBNSmZnUXJsamxJZ0NWd0lrSUNCcGh3d1B3RGFRd2dTZGg1Rk02a2o1?=
 =?utf-8?B?VlZhNDRuUEVVS0NkbTRmOWN5eFVleXg3QXJ1TzllNjRubmRhQU12L2tZQzJC?=
 =?utf-8?B?UldnNDJHZDFLZHhaaXhwSjFIS3J2cmdPRHJ1dG1tb2ppdFJFTnczYnlUQmRB?=
 =?utf-8?B?ZFN5NmRNa0kwZ1J3YlFOY2tNakdUTlBhNThDRmU3bGdlcS9Dd3d3NVJsTmt4?=
 =?utf-8?B?NDdEdkZzV28zZGZkV1RZWXNmWjNsVHRBS1kzK1pHWGZUS1c5TG9DWWtJYUll?=
 =?utf-8?B?NnJsVmR0REtQYVJmUUZvWEdzMnFuQllsdW9Ja2RaZlNUYzJSTEpIbTdNamFn?=
 =?utf-8?B?Z1pReUI4a202YlpSNHpvVzlGa2c3L3JnZFNsVlhXNHZMeVE5TWxTcUl2R2xm?=
 =?utf-8?B?Y0FURHhzM0d2RTAwMjdMc3hGb3JUeWVJWFFHZ0tZUmNoNWlTUjZSUUt5MVR6?=
 =?utf-8?B?VnhQL2JYR2h1Y0M4WTFZdHkwdGdoVkgzNWNoRENKaFRYNTVxQXJzWTBtanNM?=
 =?utf-8?B?QVZWVW14ZGtQYm5MUjFFRGx0c3lQQkpjRDI4cDkrL08yNzNOUDdPekJuVjZs?=
 =?utf-8?B?L3JBKzBGOVJ2Y09WQ29LQmpseUYyYzRkVm8ySW1rNmVKci9mdkFYWHczUlgw?=
 =?utf-8?B?NTdFcThxaDNFWmNOY0UzZlFPV0Rxa08xakhMQjh4MlUyOVVpZVhMNGVLOHhP?=
 =?utf-8?B?UWFGUW1HSWZnSjhURUpvcVNZS043MFpsUUwyaVRTbGZGZ2VkYnlTS3ZVNFBN?=
 =?utf-8?B?c25aS2ovL3paRmpyVGVUblUySXdScUxwTWhIYTJtS2EyUS9iVEN1eW9YcWky?=
 =?utf-8?B?MGVaSjdmR2MzVmdkM2hCa0pISm9wVGNJS1R6ZVc5YzJoQVdlMnI0RllHR3dp?=
 =?utf-8?B?S3p1YTRPeUFPUm1KMGVYOXByVFRpSnd4R2hMWDFoR2xEL1RralJLZm10TFQ2?=
 =?utf-8?B?bGJJSGxkUDhHZlNoaW9tSVFQRWlLdXhUL2llaCtPbHk2UG9xaTUwM0t5akw4?=
 =?utf-8?B?WnBxY2VJejAyOVdIWWkyd0twRXdkTlBYaU0veGR4NTN6Tnp0b0xqM0tzZkdR?=
 =?utf-8?Q?/voEQr89RLHG/0dE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18bbd585-a62d-4816-3e20-08de7974684c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 22:30:00.8310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOXRyO4UnRXoUfX9//UZLiDf8uswkOqaQ6PKEI6VXsiJBM1IjfWUuo4zlpP2RsBVgvnQZYgZy9efNAy4kzdi6Qj2O5v9rWLrmrO7lCctWQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
X-OriginatorOrg: intel.com

Hi Tony,

On 3/3/26 11:54 AM, Luck, Tony wrote:
> On Tue, Mar 03, 2026 at 11:06:52AM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>> +int rdt_num_resources = ARRAY_SIZE(rdt_resources_all);
>>> +
>>
>> ... and this proposes to let the *architecture* initialize how many
>> resources resctrl fs supports?
> 
> Not exactly. The file system is free to support as many resources as
> it wants to.
> 
> The architecture just provides the largest value that will provide
> any useful result from resctrl_arch_get_resource() so that this filesystem macro
> works without redundant iterations for unimplemented resources at the high
> end of the enum range:

I am seeing three different values being considered:
- The number of resources supported by resctrl fs.
- The number of resources supported by architecture.
- The maximum resource id supported by architecture.

At this time RDT_NUM_RESOURCES is used for all three on x86 but these three
numbers can be different.

If I understand correctly you are not actually proposing to "Replace the
RDT_NUM_RESOURCES #define with a variable initialized to
ARRAY_SIZE(rdt_resources_all)." but instead you are proposing
to drop RDT_NUM_RESOURCES entirely and introduce a new variable that 
captures the maximum resource ID supported by the architecture (which can
be different from the number of resources supported by the architecture).

> /* Walk all possible resources, with variants for only controls or monitors. */
> #define for_each_rdt_resource(_r)						\
> 	for ((_r) = resctrl_arch_get_resource(0);				\
> 	     (_r) && (_r)->rid < rdt_num_resources;				\
> 	     (_r) = resctrl_arch_get_resource((_r)->rid + 1))

Letting rdt_num_resources be the maximum resource ID supported by the architecture
will not avoid that resctrl_arch_get_resource() be called for a resource that is
not supported by the architecture nor does it avoid resctrl fs calling 
resctrl_arch_get_resource() for resource IDs larger than the maximum set by
the architecture.

Consider all the other places where resctrl fs call resctrl_arch_get_resource()
directly. There are several places where resctrl_arch_get_resource() is called
directly for a resource. Introducing a new max that architecture can set with
the expectation that  resctrl_arch_get_resource() will not be called for an id
larger than that is not correct and a solution that implements such contract
between resctrl fs and the architecture needs to look further than the
for_each_rdt_resource() loop.

>> This implies that all architectures need to initialize this on behalf of
>> resctrl fs. resctrl fs does not force an architecture to use an array nor does
>> it require an architecture to support all resources. What if an architecture
>> decides to not use an array and does not support all the resources resctrl fs
>> supports? How should it initialize rdt_num_resources?
> 
> Yes. Each architecture would have to provide a value. Each architecture
> must support the resctrl_arch_get_resource(enum resctrl_res_level l)
> function. Regardless of whether this is backed up with an array of
> resources, a list, or some other exotic structure this function must
> return a valid "struct rdt_resource *" pointer that can be dereferenced
> for all values [0 ... RDT_NUM_RESOURCES).

To support the loop the architecture only needs to provide valid pointers
(with an initialized rdt_resource::rid) up to the maximum resource ID supported
by it. This proposal does not change this requirement.

The expectation is that for any resource known to resctrl the architecture
will return a "not-capable" resource. For a comprehensive solution resctrl
fs should either never call resctrl_arch_get_resource() on a non-capable
resource or be able to handle NULL returned from any resctrl_arch_get_resource()
at all other call sites.

This may be where this proposal is headed but in its current form it
creates a fragmented contract between resctrl fs and the architecture.

> Allowing the architecture to define the upper limit of supported resource
> numbers doesn't constrain the file system.

What is the purpose of defining an upper limit when file system still
expects architecture to handle requests that exceed the limit?

>> I see the number of resources supported by resctrl fs as a resctrl fs property,
>> not something it should depend on the architecture to initialize.
> 
> Having resctrl fs define the number means that an architecture that uses
> an array must pad out that array.

Not for the for_each_rdt_resource() loop but it does still require padding the
unsupported resources with IDs less than the max that this proposal does not address.
Will need to survey resctrl for the other call sites that are not covered by this
proposal anyway. If the goal is to avoid padding then the solution needs to be
more comprehensive.

Reinette

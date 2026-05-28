Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0224934389C
	for <patches@lists.linux.dev>; Thu, 28 May 2026 20:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001796; cv=fail; b=Opt5LiyM06mPrzn6X02Mn8KsXWwmnwbeCRmUtfsc560nH4EDrC46K1UgNkdI7T3DRY1Lo80ievm9D7pgvm9iv6CCR7Pb6Tvjr8izF+KHBQGNejzDnweptBdCv+wbvYi5JqzBkS8ILWGhBVLdunmTJfj91Cy2DtpdtVEvZK78enA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001796; c=relaxed/simple;
	bh=tjt0LmYlHicbmavJ6tBuUNQB7tLU9Q4qZvXdVrVGq8o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rf50g86uhMT0KoEnlcA6rcvuqVsypD6lS40ldsbfWyNmvU0W+Sdgq6zjkxwSq92BaWVk/qTTiiAh2K9mr3omV7REgDjWHMH9Se7Vf2AqYWQHdLzSs9rQLqfw4+vHigXjsK8LTD8RRq5yQq/HtSI4cm/M4AhkmVvlDuHmM4/IaRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EsjmjL4k; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EsjmjL4k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780001794; x=1811537794;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tjt0LmYlHicbmavJ6tBuUNQB7tLU9Q4qZvXdVrVGq8o=;
  b=EsjmjL4kOwhYmrfuakWI/GEmg5bZFZSFgni8R05YubYK+JI/5AbwxF0Z
   6f3frmHkO047La24TFDR5/h7rwYdEtE8AaVMOXR4Z0n8UdDiHSeeUSmeX
   yilHCke0CDX79oRWMQHsvHMnSIJKk1MF0aimuMOdZ6kmUeK9mVmwV0h4g
   YqhiT0YPTS48n31c8+aXUh3O2a+ks3/kRs3SZKTA/t0t43ghuBUsseCYd
   9sRrAAyHwQxgS8/QUT0jjcKlvRqqMJS2jC06s4UZpX1csdLRAh3pK6F6K
   172qv/UI0cvbu7oOX7QFsusQX/9GtohiLoZxnJjI0UkSAREfNuwdqP+Md
   g==;
X-CSE-ConnectionGUID: al39qWizTqWmGXEJxobl4g==
X-CSE-MsgGUID: HdsNysYsSMiTf2EjzY7v8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="79888941"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="79888941"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:56:33 -0700
X-CSE-ConnectionGUID: By/ZxhRoTKi+WqUNxyAlDA==
X-CSE-MsgGUID: bHptDb3LTHyqL2Md/ucYsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="236301067"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:56:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 13:56:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 13:56:32 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.68) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 13:56:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ViQKoyEaGdEssfRvmyzRH5sCIewmfE3V6QeuwU99aHeGqDukN+v9lpkyQSN2K2EiLJAl59xBWOBogwv+X5qgk6uM0hJRNwOd+BE7N/jB+YQpKfhjCfKsQ811e6m2ceNYccuP8sANxqwDSU0Rjwr/LblxinGdwFbZnuqrUowKAfgfcU6qtJdemX/WW5XJjT6vGDSbYRMpU1Moxlc2V2AsXHdeZZeYIDy291N5dFPIinAwySkF7NkdDxdbKApYT+U315nSJH0pYv6V94JCc1k1bz1n6tXGcENVYMzmZ48K1JuIg7zlfCT0w3ojGiVf8GjxH94pvS4O3W+zoB5FXu0ZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHoIZiHza8n4ZaH+s3lS5XC+1SgU3clwOvLr2mLOvws=;
 b=nL0f3wjQ2fW+r+JduPJUnVTDAHO2eYpBBsW8lh9Nd0Yps9Zp11Cdolxfp3mWII4vSt8kOv24bUhl4UKogh86yhcGcPwNBxF07rVrSf8Hf5OIp9rSfx+Pns6rHqA8lff6a+GYO03qKIua4VeHxDtrRa7lop77auSvWCxvWHBUx4CL6tIUhrJqMvjQRhRLa4OnjuC+mE2m14pNFVKA3gpsu3qxZHluyXUWr/phJxfZYvEdxHTH8Uv51DRMDksZSWIs3Cj6kP6AQftIMm/iM6530tZDgvjpl63xZnfep1vNMLrTpoiQ77ahKXCj+jxNNzijcFGaKmdqLC49UHuflwBbrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB7131.namprd11.prod.outlook.com (2603:10b6:806:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 20:56:29 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 20:56:29 +0000
Message-ID: <c6bc7632-6076-4bb9-82d5-c1cf1b9e8188@intel.com>
Date: Thu, 28 May 2026 13:56:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: Babu Moger <babu.moger@amd.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
 <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
 <6a0a2f88-c22f-4a08-b3cd-b46e9677caba@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <6a0a2f88-c22f-4a08-b3cd-b46e9677caba@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:303:6a::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: a571c329-2ff1-414b-9076-08debcfb9707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 1Qtxw2laNAGjwk9iTs7cQPe0uyQ2wFrcl2wCvpBbSfNcxJPJ2NVppjqAVvsOkr3FjS0zgnkn+Kc3K61TeaQvVtUJGxA97l7hSKTxGQ0QMP3lY46neRBPTtMk7+hyjaD+pv19kepc315NXlIODiFfAlSgk2hKFFu8YImcyeJT5RViYKNUhjVHByNyzLgB2RVbv5kkxE8jYl4yMqGWTb5ZY99mDi1PK4jEUnGN/kW6L2Z9T3qXwYUUxXDdsLK7uO5luq0tUpAYX69OIQVajo7d2tOWVNrqOeceE2oSDILWrjNFQZeGxKWFW4/hVTYFKFN3vQ9oUctqGOYbKZKMopBRcBPqx9a5mqxLf5JNHfHAlMm7hhbTir2vSoWf8A+/drOQguU1Bfpl20oXjUN2/ynAzhTJflDxo31FYIrCUCl3fTNkp5gDtsYRu3jsk4DuufwlZEQgMseLJhVA0m1UG17FHPEAVExhA0xWttdoNVAX2KswLXjG+3aOKNbY0hvTRGX7ztpDokDBff5iHUqoXFKO3VRTMDU3R6lKTQn6Jdxm0ocanDnyMdYNEaz8KyBIPYbCri7E6RPvk9wHEy1pawV4Tj/1pOrnIT0t80J6OCuLFr7b6ZL2Jpu5sSz1dIQ2bFStm/h9nhyksY++KiShhMCxag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anhnNjA1MG93NDBtZTgvSWJEV3NSVkVCOFFTQ1lEd3licFlGQ2xvb3RacVN4?=
 =?utf-8?B?QTVMS3FhbVhKVCt6cjRyS0RHWGRPRFJ2N0ZPSjZKNjEzeVlRbGtSRTVreHk1?=
 =?utf-8?B?QUM2bnN0VjBOOG5RTnRlTDQwVmdBKzViQzRPeUlOT0srRUoxZkd2bDZWZjdN?=
 =?utf-8?B?RzZxeUthak44T0VvVVlVTEE2ZE5CWHNsQjY2Ujh6RGIrc2dkZTVOb1BNRTdn?=
 =?utf-8?B?SDBCTEQyUFMzZm5RdkJkOVNXVUdlLzFsOC9pV20xVEMrU2c5dVdMZXVFeUVS?=
 =?utf-8?B?aTdGY1FQdFJ0L1M3TzdOWU1pbUYyQlRZTUV3U3A5WUFvTFByenlLd2cvM2VN?=
 =?utf-8?B?QkdocjlkMHdXSVZRV0lWZXNnL0JKcXo2ckxGUE1DNW5ONjNSQTNjeU5HSWdi?=
 =?utf-8?B?WVg1ZHZ1a2doTXVSUDJrcEhITHdObFFUZXBsMjk0eHpxeUNDdzQyMFBLVHBC?=
 =?utf-8?B?QXN4NlVkNlo0bmV5RGxqRUhrV3BzSXp6STNxUG9wcnhGMGtpbzVRSkpIOGFY?=
 =?utf-8?B?RVRGVEdMTGxwQVYrdkNRWnBPSi9PRldPd1NsTzZpT3p2cis1eVhobFBaUjBL?=
 =?utf-8?B?UkRGWkJDZ2NXem1UUk1ldDVQM2VPTlpyMTNsMlZZdm1mME16SWNzR1RaWUF2?=
 =?utf-8?B?YWJtekVWQlZUSklkV0RqUlNwanpDdDlYNFp1YjM0VWdsQWpxNTNVeUxYYy9k?=
 =?utf-8?B?Slh3bEsrVll1ZVdNd0o0ek5HVzRFd05sWFZWLzdOY0tLR25OS0hUUUZWWFZy?=
 =?utf-8?B?VVFaQzFJOEtLbFJoK1U5WjVncDU5bnZjU3ZXWndqQU1rTHNWSllXSmsxVXpr?=
 =?utf-8?B?NnNkMWNRdUtwcks4dC9WU1RxQ1JzTWpBcnExYnpNUUlPVGRqem5LYlJadW1n?=
 =?utf-8?B?TkFCc1BVM1FVVFBaWTErK3o5S2NCRWI1SjRaWVBNeXFrMFhnS1JCQmRXNHVL?=
 =?utf-8?B?LzkxQlhhdVhHQThvQUROWTZJSHdaRnlabU01ZkkzVFBUSVVTK2srZStUMzVw?=
 =?utf-8?B?dFYwam9YNTJseTc2TytkR0Y4ZTBQL3VkN05SSmJSa2l2cUM3UEIrM2JVWG5J?=
 =?utf-8?B?OWthZlI0d3FMakhhLzEyNHd5OXUyNmpmZGRXRzBpeXJML0tZVjB5cGxTNFgv?=
 =?utf-8?B?dmNlbnVtbjJYR1NONjkzQUtpb1JMMzEvSjdYamFITnhYa3ArUHZ1TEhDRmww?=
 =?utf-8?B?MVlvcE43bUxjdzRTeVBuM2dCNXpDT0V4bmplVXJrRUxZdDVTbzRlMVpwOFVH?=
 =?utf-8?B?RDRMOVFzK1BWR1ZuTGMrQlFEaWxSWS9LSkFDczFuZDJ2ZjROUEpwcHZ3U1JN?=
 =?utf-8?B?MlZ4WUJDaStDc3RjdSs2MmJiVzg2U0hXNFFsR3lXTlhkQk15eTdSQ1VaL0lO?=
 =?utf-8?B?UU11ZjRSQ1hnMlF2ZlFyVzViV0oxbjR1RkRMenhaTVdPWEVaWSsva3RJcFZ4?=
 =?utf-8?B?c3VyNmVxZVZpbDMySWxLZWViY0RHYWszVDg1cUNqSDFSdzk1VUZUQU8xQWZr?=
 =?utf-8?B?M3BxdWI4eFNIZE5HMkpNc2o3YzIvdWt6bDBVZkJmT1JPSEVDbFNZQ3k2bzFn?=
 =?utf-8?B?cXBlOEozdHBqWk1VQ2VlS0tQSEozdGp6N25XSDRnSWkxeGxFZzhIemhLVVBO?=
 =?utf-8?B?QzQwYVdHVHhWSi9sTnV5NmdhRUU2L1Vsb1dEOUVUOHFXekhjSFBwTEp6TlRh?=
 =?utf-8?B?cmR6cG90RzZuZGxUUjlTNENoeXNHenVJUWx5clJURHNrdW96TzVXQUtHMklC?=
 =?utf-8?B?NURpVGhWL3lHM1F5SUpkcm9QRXBtbnlTM1R5RW9YYW5nWUZBVkpjNnFXRzY1?=
 =?utf-8?B?WkRLQ1FkTDZUVFlIbTJqZVdzdGYxQVNmVDFlY3Q0RnFSbFY3aG5GTi83L2NX?=
 =?utf-8?B?L1M4WGxjZUFPam1TZTZFcENWZ1ZVZDFZbnZUUmZuSkZSbEVhZjFNSFNRWUxv?=
 =?utf-8?B?U1lPMmx2ZDVTKzJUaGVsUFkvUk00Q0VqbFQ2bXo3L3pmZW5hZmZhYzJ6NTY0?=
 =?utf-8?B?WUxKUU5iR1VwZFFxUFNwb284Y2hBYzJiSTVTa25qUW1ZQnFTYXRlQjVWMUlL?=
 =?utf-8?B?OHpMVUVuamFGZTNqeUdONTEzTjZ6b05oTW12UDJoeW8zWklQNVBpUVFPcE5R?=
 =?utf-8?B?VmRoRjZUMW1MYnNaaDliNmU1U3Y5N0VLb0xXdStjcU1vcVhzSC8wbnE5L2Vm?=
 =?utf-8?B?aEZGWVNHUEk3aS9pZ1lmZHowbmE2TkxwZEw0RFptL3N0d3dmOEhEZmx3VzN6?=
 =?utf-8?B?d2FYeWdrSGFHM0lKWEwvclU4bUpXNkhXaW9XNVVTd0RYL201dCtHdDl1dklr?=
 =?utf-8?B?MDBFRWFSNmtlTEd2QXVUOEFQYk5hd0RmUmd2bC9uZVJKZkcyc0daM3pycC9Y?=
 =?utf-8?Q?DaxDtLWONDWHgvKA=3D?=
X-Exchange-RoutingPolicyChecked: nopjoB+5AXIZI+26CdaqLPQ0kd7H8XvzCYL5XzTn9oeE40xzwKmKKdL+keviFSXMoGOAhs9Ng2dcJTVApV/6unva/t2xznuoAtAZzpTAz09DzwXN6Qs5nMTO5oBPeAtQ+/tLIpS9wKIJt49Kvs8wHaZZucRkgYcej2V7NplWIoUGDfBT8nowGNZv8pUmBIsDCElSJxcpgtgchvOJb8QzjxKPY4m02liy8e4Kc4Gz7I9ootcW/1ftm3PW741+N9RqiRbAOVsFsxwhDeu2qJGFWPfvsgjyclLmpSRhmRhD8QOZaIxpGM3W/Ip0x0F79rvK5BED5ZkelrIfoS1lSuoooA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a571c329-2ff1-414b-9076-08debcfb9707
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 20:56:29.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzpjXjH3+3LhNVemdzLXTYthsPypErkR+Jh1m2tRV9f0PlYP3QeBL7m6PV0+nn4PxqT08nPunlM1L9o4qD/kOLzHEObhI9swEBD73AVP9Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7131
X-OriginatorOrg: intel.com

Hi Babu,

On 5/28/26 12:04 PM, Babu Moger wrote:
> On 5/28/26 11:11, Reinette Chatre wrote:
>>
>>
>> On 5/22/26 12:15 PM, Reinette Chatre wrote:
>>>   static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>>> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>>>           return;
>>>       }
>>>   -    list_add_tail_rcu(&d->hdr.list, add_pos);
>>> -
>>>       err = resctrl_online_mon_domain(r, &d->hdr);
>>>       if (err) {
>>> -        list_del_rcu(&d->hdr.list);
>>> -        synchronize_rcu();
>>>           l3_mon_domain_free(hw_dom);
>>> +        return;
>>>       }
>>> +    list_add_tail_rcu(&d->hdr.list, add_pos);
>>>   }
>>>     static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>>
>> I resubmitted the last three patches of series to obtain Sashiko review [1] and
>> respond to that feedback here:
>>
>> a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
>>     domain is actually added to the RCU list?"
>>
>>     Yes. As pointed out by Sashiko there is a short time where the monitoring data files
>>     may be exposed to user space before the monitoring domain is added to the RCU list.
>>     Also pointed out by Sashiko, if user attempts to read from such file it will return
>>     -ENOENT.
>>
>>     This behavior looks correct and acceptable to me.
> 
> Yes. I agree,

Thank you for taking a look.

> 
>>
>> b) Sashiko: "This is a pre-existing issue, but does resctrl_find_domain() safely traverse
>>     the RCU list?
>>     Yes, this is safe because resctrl_find_domain() is run with cpus_read_lock() that ensures
>>     the list can be traversed safely because the list can only be modified with
>>     CPU write lock held.
>>     One improvement to resctrl that would help support this is to replace the "list_for_each()"
>>     domain list traversals with something like:
>>         list_for_each_entry_rcu(pos, head, member, lockdep_is_cpus_held())
>>     Doing something like above would help document why such list traversal outside of
>>     RCU read-side critical section is safe.
> 
> Are you planning to make this change at this time? It appears to be a corner case, and we haven’t observed it in real-world scenarios.
> 

I am considering it, yes, and was planning to make the change first to determine the impact on this series
before deciding. This is not a functional change but instead making the code conform to best practice that
implicitly documents why it is safe to traverse the list outside of an RCU read-side critical section. I
think this would be a nice addition to resctrl. Including it in this series may actually help reviewers consider
all the flows involved in these races. Do you think this should be deferred? resctrl cleanup work is not
popular [2] ...

Reinette

[2] https://lore.kernel.org/lkml/cover.1777419024.git.reinette.chatre@intel.com/

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F417B425
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014241; cv=fail; b=GHBsQ+7o3lzgYzHCzfSPrr0FL3FqWyd3Jj2mWNjwzSqp/t0MNHFt9cMNGe6O5NvS6aTOeyzSy7nVwKbHkrng3bur5EhHzoAakMhbHqFgcdlisjoEF2lDqa/YKqsSSZBGXBOPdWjHBOvCJn+H5O7NsQx0V4G8ujVV+9e1ipZ0oEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014241; c=relaxed/simple;
	bh=oJKKQ9o8rryZ8u6oLDwRd0aO1MsNhaLR05HaSuggpK8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ccM6lXODJg4OTuTHzLsSbLHe7uFqxsInVTulF2IXVsj1I60CZu4dssVfTziz3pKln28sPDl/hs8gddCsB7Lp50Qh7QTtxNrtQjcPzeE7Rfca4mIYXMO909pzSKBX9mNcN0DUnEqVNajf5jigBTXQcKufFs6ja0ghVD7Px4oe2AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hDW6ro/+; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hDW6ro/+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014239; x=1818550239;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oJKKQ9o8rryZ8u6oLDwRd0aO1MsNhaLR05HaSuggpK8=;
  b=hDW6ro/+BY+QaEcQenUYxnIkhTDP+4DnqmVtXb4lU+9K4t+d7woplNDC
   0fyiD7S9+wuPoXXJBFPK4JpzsSseA7RLq/cBbMhEHAWaVI5EAl02DnY06
   F2v7f7xalBC1qtfjTYCEPFmsXrttAek7mbk3C/s5p97xPebSrVMWk5z52
   d5mbCKC3qYB0mtzTRyi1NSe4FfYCpVF652HzLDcAFQVhMM61Ozm6PO7ai
   TUiAQGjZRoeTkyl2j6ZE2gpyjnhDB8B8+7XbdlIYoZ83/FsmJgh04tQTq
   GPJxvIC6DXeb4XFFHfdczbjMgJhvQcgjWHQRJInFr3/cPPObM1M1KkogS
   g==;
X-CSE-ConnectionGUID: 57xWefriTLOGDKTz9ve+Wg==
X-CSE-MsgGUID: S7/fKWoBTOm/gpBZB+N53Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98162495"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98162495"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:50:37 -0700
X-CSE-ConnectionGUID: 7Y+V8ePmRFGGtdTck58Dqg==
X-CSE-MsgGUID: NahT3h2mRHys6iwp06s6aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="268904582"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:50:38 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:50:36 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:50:36 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.41)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B1LdEp5DOhC+Jp4xULrii+pC2a7arwCicYS2CBMYHZyTzG8La5yrkqSAfhR5EmOa2BkKucL2yc8Fw7XeC+tqQoQA2R805nSBrnQh4XPqvG9qvnkvnkwLRdREtWkCzm7CxO+HGUwYYT2MDes0gdKRQGif/F2bc431oGDYs3XJH6/z6hlBn+zQCwwvQIi0nJc+7VqI20p+p4y3khCo/+EnEhVNZcP5n3wzSXj9J/mhZ+mDMK08cl1EErxY6zfLeXyNRoMefxXxCi9y85twPbl9Bxb+LqRFR8wEhSmXFrelR8P0QAVDLBHwuLOpCS3DpsMPIirhtCMyIM0SNiP94rvdnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FY5ZM5hFNEAVlbCC/xx4+/yrb2xYjRWGE15ya4sJrOM=;
 b=mRbvBl3eBQv6oDFUpULd+fVJiImYtNvHeYT+RWDfKD02QrsPSHVzhUJcwLhVB6WO9xnL2gvvzBPu5juOn1eD4BpFeZDynx8lAW53r3Iwrmox0WjQ4maWNoyHWDhyBmaFO93wFwLeT7X4nPTd6XKCE4PBJUOi2+Zq7JjVtscmWccrZNKbLlptAs0OIGW9qG2x/jfn/ePdvZtoDtZGnHrd+8BHFWudk3iJrFngWU8x/PG2imIvXvGfYJZXX5E0KbH9wJez67YXPUJn+5hDFB35+j/5aRp6eU+Mri1smCSeVrs8fvVMhdkzevZevPMxcDsjM0IrhLFzCtp1M2edl2ILng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:50:34 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:50:34 +0000
Message-ID: <d97deaa1-f42c-4fce-8ca8-5ccf8d822cd2@intel.com>
Date: Mon, 17 Aug 2026 17:50:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/17] x86/resctrl: Require 64-bit x86 for resctrl
 support
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Hongyu Ning <hongyu.ning@linux.intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-3-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::25) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd41469-82a1-46a4-b28f-08defcc2b60b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: r0af/sEd7+fWKfKoAUY5DiTjlxJLpDlc/S6cU88862HroXw74UyzJVV3S8e4kDYjbsqoIL9ftR9g0jmD3wYpgzZecfQBjEErD+9PistcRDgWwzGu+4JjHtxNK26+9gfz4hQvTHkTs6YCalfoNACEZQ7350+plPyOEcNHNrOKr8tmsQiOYEmFZVN2nyTM/8Xwcv81qOZEtPBKmDyH28QFLEX+06j4ReGx8dcs0pJ5eeuo2r6pURloTslXnXQIx8WVFURSTUDJbZb5fsceInP7wBXctntSZ37T+yAbuMHFzQmtPKS/eHuWPkCuxir3M5rZVGW/4MLmAqCFlcfsPLg/RRApEq7KqHPSQ9zeehvWp9IjFlKadGBFgC01c5oUiBtaQZOhmgAKNMJEzpjnrXG20TEY+T514oqln9NYUmZ0l3HiU0vnPB1lAFIsJtzox+8xS7Xbul3Jfa3Z428tegyE/pOAaCKomyuv7kMoGIsfgnOpSA4B7RheOAj1+ZHyuwXCopdq15zP4OK7NtIHlr6n4HE3MmY8hsLBhdXDzj+KxqlDGTLRSAsv2pWEmzEkv6SX8o33L4DVAOUsX0Kn8sv2a0glNUu0snXEBwk7KvmoJBHZDj+05y8izeN//gQpqleJNolWTU5eRePGYRPoomOHP9wdDnVYbtpPseTOyCHGbVKD8vMUye6jiq9Ho97dnHvRL4lV0U+jLK5MZzHc/o/LfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzZTVnB6MFZaSm0rOHNRbkNBeEhoV01JRTRFWFViUlk2YTZqWkFnVGt4eE1B?=
 =?utf-8?B?c2ovRHBJdkUwdFBxbDkySEdDYXpoWmJpQ3FTYk9UN0tIMDJBQ0IrYWQ0cTRy?=
 =?utf-8?B?QW81RjNHU3pZOGZLYUw4WWY2YUZCSDVHenJVWE9QYzNiZWFIWHdVVXFnWnNG?=
 =?utf-8?B?ZW0zTTFEQzJQWHNGKy9CdG03d1RHUTBZcVJiVEtEcEtVN21PampsdzIyRHJE?=
 =?utf-8?B?NmQyUFRJbTV0SmUvNFRxZndnaDI4cWYySkUyQk5DLzYxL3ZjbkNPTG9zVjI0?=
 =?utf-8?B?eWdJV1VTWVZnT0Nvb3IxR3ZTL282eSs0di9QRHd4UThlUU5Ha2NZUmhwTWND?=
 =?utf-8?B?U1crRCs5NkxzUUNnZTVGNm54b1cybmpma1pHbGtueVMrQm1pK2tvRVBlOElq?=
 =?utf-8?B?dmFsdkx2QVlrYVpUdytnbmhGa05TcGhYb2JGOGlSczYyUGVqWFFwMlJqa0Za?=
 =?utf-8?B?eGxCcTdmc29CRnpyK3dUTXZ1UTdnb2Nmc1QybURrM0dwM09WSjdUSE5mMS94?=
 =?utf-8?B?MmxJYmlJWFZwNWh3RTVsRFV4QmtmUnVKOVIvN1Z4cXFTbGh0ejduNWZDbCtO?=
 =?utf-8?B?aGxSeHNVYW5QOWZhK1FwaXNjMHlJZ2pxZk0wLzJiOHU2TXdRZWtLem4zYVJP?=
 =?utf-8?B?cVlUQXBUb21pNG1sa2UrSUtJOEZ0d2l0S2RNVmlnanl2RjF5bXFRSU4wOVc3?=
 =?utf-8?B?M0VSaS9GRUdxbDhlNDRGckVoNFlyWWEzRHN0NERLQks5eXA3VTc4bnZOTUcx?=
 =?utf-8?B?SWFFQWh3ZnB2Q3NlZTE4Szl2NS9yUkdoVlovRjRJN3VISzhEd1oyK3NWSzZE?=
 =?utf-8?B?T0t4bWl3OVIvWGpISHRYNEFja3FQVW5IOWwrajB1cVQzMXcrczVuV2ZWUjho?=
 =?utf-8?B?VEZBMk9uNGIvMkJZNXpYVWhEaVlzbG52S2NsZGY0dUV1VjJXVm0rSnhOcmJJ?=
 =?utf-8?B?Vm5mTE5YZUpBQ2V5VWg0aEJ1Y0FoUWN0MVcrd2pTZ09hQVVwU1E1c2hwYkMz?=
 =?utf-8?B?WmUrMHpDSjJjdjkyOUhtZlRneVp6NUNaaEdVMTJqTEV0ZGZjS3czS3g2eGQ0?=
 =?utf-8?B?dTR5VE1DWmxkQlJ0R2p5VnFKMDdKcGdTZUlaQ2YwVkVRZU9EV0crdDk3VEdP?=
 =?utf-8?B?V0FVWmtLWnVTVE9DY2dIc2wzbk5GY3pjVmVDMUd5ZXB2VmlOQmFJZCttbDVw?=
 =?utf-8?B?WS83S1YvZGd0c3U5Z0tTRjZlTElBVG5rNE9CeEJlcUU3NXUxS1ZOVFFHL1FN?=
 =?utf-8?B?VTMzU1E4OHpnZWN2VW1EUlJ4Vlp3TEkvMHNqRW1BQXVlT2tlbi9qcWZaWk1O?=
 =?utf-8?B?Z2VJSjVSa0xHbk9MQnhiMXBQTEpJOHlUM2twSFhIUGZxN0RPUFR0TG1LSjgv?=
 =?utf-8?B?QXdkUlNsc3lON3hlN1I1TVRCcS9ObWRlcVd3bVVpZDhjZEZ3ZkE2T041Z1By?=
 =?utf-8?B?YXhCUFp6R2VDQk9xb1NjdzNxeGhSWC9ob3lTeFNRNjBJMkZyNVRqaWJ5STBa?=
 =?utf-8?B?eHJ6alhXTWVBSHN4cTBXcFBJMUhsQlZRYzBkaUlWRHBnV0tUWHFDQkQ1NWRM?=
 =?utf-8?B?eVNocXoyVFU1WkthZFoya3FsNGM5Ykl5MU8wVExtMTF2Z0s0ZE1LLzBVY3JC?=
 =?utf-8?B?alQ5dWdxVkF1eGdBYm9sdlptS09QdHFURU4yc3VqRHV2U1plYzhGUnY2MHV4?=
 =?utf-8?B?RDlFOERXUUpldm9sSUVsUWNENHl3bU5xMVNNaFBoTVZVRnlCSDh2L0hUVm9q?=
 =?utf-8?B?bEFHai8yV1lpcmFEMTJldzdkaXVrWStiV1FUVGplL3RQbXFQUXBJM0h6YzZI?=
 =?utf-8?B?bm1QZkJOeDJQRjFnOHkvdzBTZ3ZTY2dKNnpXRzY2TENwQWZzd1k5QWFOVVli?=
 =?utf-8?B?R003Uzl4N1A4R1JlRnFBTXMwR1M3NTZCMzFnWmd0MlZVazNwZ0tISG5MM0tL?=
 =?utf-8?B?MXFvNG56NUZ1YnFOV1JLNGJjbzhUOWdpZXcrYWg5ejJacnNZR1RGalhlZTky?=
 =?utf-8?B?Wi91L0xka1dHSy9tVDhuRE03UHl2U1gwVFlFUzNtdGpKc1FmdXdrQjhuNUJo?=
 =?utf-8?B?SUdPTWY5MTVOT3l3bFFRaDBCNk1IZDN2ZG9tZkNXWVV2bnpOSmVoUTFuZDds?=
 =?utf-8?B?MHMzV3ZQamdjWng3d3FCRmh3YVRhWmRyYmhOWEs5ZldxYlBlbzYyMjJQWTJp?=
 =?utf-8?B?cDJJSElDL3J5Znp1eWxPcXZvU1hDUnRRd3lFQlRyV1ZsVFEzOUlNdXBQRlhQ?=
 =?utf-8?B?ODI2ZTVacjBpOVVoZGY2Wkpyb0VDT1RGcXhXZGI5MmJvS01rVlRLdG1zWWNJ?=
 =?utf-8?B?ZUgxZGllSmhlZndCdWhWVXVhdGN3M0ZFREhsRVM4V3kvS1VsYlcvLzBXbnVm?=
 =?utf-8?Q?E2GN3/aNgjGxPh7E=3D?=
X-Exchange-RoutingPolicyChecked: eEpd+i3CU2vjRjqR3U/OvzLZ2nXDpUXAoNCU3Sv7tc4hW5ObM/qGiAsVByEigxY8+cKp17jrUURL3Xctok/4s/00Qcn5oLnxIcJKd1MjiWQHahGjq+ga+XURxW6XWKk/3EXLBVNowgwgs9Vhh6ciLthXYDMlAkRfQqx/PbiUp4dEaNrUi1tGSzPo/XdSVYnY73mn+oqg5sRwOK7inxXxdHMRSQiUjKjh2E0a+6DOaYWNBotRdxJeH+I0sC7Tnt3U6pV6EdGKgtYgN0hZqoMybOLlWWVm7jtc0vo/EnuiA9PGpUPIzQr3nR1Nriy3oQc3t8O7vIsSbTZf6QQb9mmq3g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd41469-82a1-46a4-b28f-08defcc2b60b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:50:34.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1hbBZi2zeF3pLMh5nWMI9+Vv6UYfbnSQ8fN9po2p+rudPyomcEuMWV1tZ9swakaf8eFhBF2LqxT6KAEEjYlb38vxvIFkVB3S12Q+OKjjZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> From: Chen Yu <yu.c.chen@intel.com>
> 
> All known hardware that supports Intel RDT or AMD QoS is 64-bit. Future
> enhancements like MMIO-based Enhanced RDT (ERDT) monitoring require
> readq()/writeq() which are only available on 64-bit. There is also no
> realistic use case for users to build a 32-bit kernel on a server and

I find the "no realistic use case" statement quite bold. Would a 32-bit kernel
not have same needs for resource allocation as a 64-bit kernel?

nit: server -> system
(since RDT is not limited to servers)

> enable resctrl.
> 
> Drop 32-bit support by changing the X86_CPU_RESCTRL dependency from X86
> to X86_64.
> 
> Since X86_CPU_RESCTRL now implies X86_64, remove the redundant X86_64
> dependency from X86_CPU_RESCTRL_INTEL_AET.
> 
> Tested-by: Hongyu Ning <hongyu.ning@linux.intel.com>
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

I support this change but I would just like to ensure the motivation is
accurate.

Reinette

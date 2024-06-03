Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3913699A
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717433734; cv=fail; b=dqbc5NNXw+Ts9IP6JD2y2CmQPtOnnaxrvwN6TkelHhVntfzgzwOeGrGHdJXnjHZABHl9SlopHaDCxAnpfRk4ychn8hpsu7lmmLSD6QHtBlmsWKw4KC5MBO2CJfR9yElO17nyUqo8ddiXjeenP5VPv7raBfR/4H63bFvha3lItFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717433734; c=relaxed/simple;
	bh=NjTBHvVJ99u3PPofrPRoI0LUWVNbrRUav+xpgUWSMfE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CEcEps+xvaNP7othNkWGCoxYXaeVKlmOlDakKlqOf6/FVGxrq4Rggk/E4Q/f5v9B0bvdwf7d5QiRAm2fX23sJ04Y2NkLUpjAmF8BP/o+HajNoD4+MolY6IXrXChRtIItuaishVg0b4Gn9gJ6iEXaRXvcHr4Slg97ikAbMT17aT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bVgZeX6A; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVgZeX6A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717433732; x=1748969732;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NjTBHvVJ99u3PPofrPRoI0LUWVNbrRUav+xpgUWSMfE=;
  b=bVgZeX6AoTLwiGgfDwsk4nCCvJ0DnQ3MT0oeBhhR1ycqlH2zb82eUDb7
   CQpoLIa9gxkwChjEPZp0dnAAvbUTsJZBzmTHBzic+XKE8v1l7DCOFOFQa
   oRsRbJHhL9/neO9UX3CjZy0vtXGG0KrxLKaSlZD/PxcUxRVLioS/eisHi
   jjfvw8GB6nEOKdCQBv8Ss5ix6GH+NHJHx6gHR5nGW2MabHpjhJ1WmYbqD
   EEoXwDOEIsmTera26Zh2AIjX3mTHxgWwE1ccYsWDjmX8NwxWrNhpzipos
   IPGf9QiqeGkevux0qjcXC5soM0OwJgl4QsaVCgLLAkgnEgiwz6H/66iWB
   w==;
X-CSE-ConnectionGUID: eC4SD4aQTEm352BeLwP93Q==
X-CSE-MsgGUID: Cc7CJRjOQIGYEyVifoDfUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="13747990"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="13747990"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 09:55:31 -0700
X-CSE-ConnectionGUID: dJe0A0vmT+maAqBxH0SVoQ==
X-CSE-MsgGUID: CUfSNh6ZTxaA2kzkDzSJ1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="36964248"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 09:55:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 09:55:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 09:55:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 09:55:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 09:55:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPalMXvAYmS8Xm0sAkOkNnzv66ovh8rvYfG1rrfgCTGP5R0NH8wVnhyM1zxu0GkCbxjw4PmbraoUReXH04TVrl9LYIDhLM3tPD3zxDeF231R8yAj2dkVzEwzfxsg3X+WJMaZCV0cgEDBzaf35ezi/qPwh3IqHI2YcDo2882BXmRgvJ3y2wr53cIq76V1+z9QVX9TKj0EuRd8UBs5Rs4yQ75p0s4GdzPr+SGO4XDAfTj+6Xi7cJ2vDBlB8Ytu5R4AH/62fmnHSAWR2z6j3PaDZKErg0StTvmIpKbp4OCyPe7DeBW2qG65HqGaYmjpcthOuGefziCAfw73x7yAImFrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3AXHAucbcqpAiczSGxcQ+CJeqSFKGxuTvyTZja5mjc=;
 b=AjMx/u/i/ibQWzVQ3N8OTtFsmGTV1iyiiA2wnEs4e5DSOmyk0fu+MgEN8z9WRcr+/xaLOzsrQN45aWDcq9ICVmgi9wbaV1NzvRIR/LcVL6Rdd2/40v0cEX3R/32y1jN3Pw5Tl+KRIiDGQA4X/0UFXGOc29XhQINpGsrjVtkhcioyc6Jtk5wpzH8f7ZpzJdhUD4+boe8GfJKvVNfSXNv+MHFMcmoqK1qg5futEFO5FBWUOZKP5zDgrOBBgREcTPA+n/1L+De8ZDYV7+pzJF0xSwYW14TZumqXazyDYTa6e/ZAxaKueBribD6FQFzMNqSyUphRP5xGsIbGrCfaMSIG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6863.namprd11.prod.outlook.com (2603:10b6:303:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Mon, 3 Jun
 2024 16:55:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Mon, 3 Jun 2024
 16:55:26 +0000
Message-ID: <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
Date: Mon, 3 Jun 2024 09:55:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
To: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240531195720.232561-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240531195720.232561-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0318.namprd04.prod.outlook.com
 (2603:10b6:303:82::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: e39cd1b7-df1a-48ba-bd60-08dc83edf7c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MWpZS0FpcHVXM2phS2hMRGdCaGdmN1hIWjlNVC9YZG1HRG4wb2NjM0tGSUh6?=
 =?utf-8?B?TE44LytMR3pJU2FSdm14amFqeW4zbEpKejNTUy9QQlVpM1FUSkJUR0Jsbktr?=
 =?utf-8?B?bSt3WEI1WFFMVUxxOGdJTlhOYmlIRE9GZSt4bk1IeUJrYkoyZjRCV0E5dXRj?=
 =?utf-8?B?cmMyRWY3YjRlV1UvTC93Yy84MU4vNGRJblUyTWFWZnRQV0xROElCUmpNMnp6?=
 =?utf-8?B?cWQ4dnVSUnBoenUzeFJFUVpXTGFYckdYeE1LZ0ZjNG0zZW9tQm84UFBCZ0Rp?=
 =?utf-8?B?TzZ4L1BsY0FTUnExdUNRTFhNUnJyekdQSTNwS2hoWHRRY1FrNnhIeTE3NTgz?=
 =?utf-8?B?NGg0VjNBNjlCemh5c1NjM25RQ3dJVHZWTDYwaGE0YW1SZ2swRXViNG9uMVhv?=
 =?utf-8?B?eUFsLzRFbU5za1k3VlRDMDkyY1lFdi9PcXVCZjFYM3dUa2JublNIMnNCa1p4?=
 =?utf-8?B?YkZ4NzFWU1BhSzN6bTNFcXRXbUwxdGh3TVVKaFViVDZubEdhVUxkZlhMcjlq?=
 =?utf-8?B?SHh0UDdzdnlBQzB2MTJlbnNtVi9iWFJYcXVhcERPNm9rcW1sNnFEa1pXNTg5?=
 =?utf-8?B?SGNhTHNmRGtaaW9Pd1BRTjdqa1V4REhIZzJUZXFrS2VPSGx4QU01WFJrQVRO?=
 =?utf-8?B?UnhRZFdmTVUyUyt1bEFtN21NNG1BeDIwUnEyVFg2ald3NVZPb2FBZHhKVmdY?=
 =?utf-8?B?V09oVWVuQ25OdnZsZURkdDdSZlZSaEtjNEU5aTVHaTdPVU5HcmlRNHp6d2lB?=
 =?utf-8?B?N2VuSHZWdEJmbVdxVjJkYy9FcWNVYXZlcTNJNXY2Yzh5VUQ2ZzlORGNxNGNQ?=
 =?utf-8?B?NUxGeDNaUm8vako1RzRIdlk3RnBwWkJmS2xaUmxjcVNqdGtWVG9VMkZTU1p1?=
 =?utf-8?B?aFhIRzQzcUpHVGd6UHFGUGdqN1ZDTzIvODZGMXZhVUpIUjFiMFJaTmxpZjVO?=
 =?utf-8?B?ZnRLM2RycWYwTVRzdlM5OVVQbWJxSGNZd2cxZngvSitWS3p6Y09LZDhrOVpE?=
 =?utf-8?B?cWl6VHZxYkhQQ3ZybUhvOUxvbWYwRlNTVGI0Y2JjQ2EwY0FLazVrS2MxcGtX?=
 =?utf-8?B?Vnk3WVhyTEJ4UHpmVWtlRGxMcXRaMHc1TUNUYVZWemwvRlpVNGRvWUdvT28w?=
 =?utf-8?B?b1NkeFIvd2p0SFY1dDlDbnhRVS93aXloMXEzbmpZa1dVRWFVREVWbFpiNXdw?=
 =?utf-8?B?OXFMWnkvMmN5eXlxS1JUcm1uVE9vSWdqSlBwbkNQVjFDbS9SR1lLRmVNS05V?=
 =?utf-8?B?QXUrUXhBWG15eU0yd0FmS1VEdmR4WHBPck9lT0NuTTFnWXV1WmNJZ3FWZmlK?=
 =?utf-8?B?eFlvQXIyRDFENGF1ZFpraUVNMDVKUGxUVVVJT1NFRDh0VlF5TjBQMkZCeWdy?=
 =?utf-8?B?Z2ttdS9HZlRPOStoRlYweXpQWlB2TmhGZ1F3UXJHNzlaM3ZobWhrYXk3L2py?=
 =?utf-8?B?cGlyWXFRTTZzdmtOSzFXU1JRcG1GSHVzeGpXQUp1aTdKS3RtNHEzNDRKY21o?=
 =?utf-8?B?WGM4c1ZZY28rTzAvVis5WVJKeFZBbHN6WWo0OXNLdHVxOUo1YjdqcCtVaWFw?=
 =?utf-8?B?SXBjKzNtNVQ1WmhZRk1zTDFhUUgzVkdYazFzR0tFdXZ1ODFmWXIxclMrU3Iz?=
 =?utf-8?B?S2hXbno2VXRQN3lxV3J2cEtYbkNwYkJRYlBaMU1pQ09lKzJJekZEaC84S2RS?=
 =?utf-8?B?RlZ3eFI4c1lSMXF5K2V1REZlcktJL2JHTlBxcTdyWEhBZXdtdGJUbU5XcVFp?=
 =?utf-8?Q?+oAIEZttvYGFrozotk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVZrUEdRZk9uRUVzZGZhM2RnWERTY1lrakhkTkxMcGZsemVrZnl2SmdYckF2?=
 =?utf-8?B?SU5mUnRxNVRtNGlrZUp6WFhtZWdRYlJXdkRkbTk0YW5xL0pERVJ5T1Z2R014?=
 =?utf-8?B?S2pSQm0zdDVIMkVGMXRFWXBRL2dlWGlZbWUzYTlzUHFXL2htWmo0WnZ3emp3?=
 =?utf-8?B?R3NXdVFQMjg4QUdtVVYzRGxlMFZSYldzUWcvZmFOVGovZ25pbVljRkhmQi9u?=
 =?utf-8?B?UEhMdTN1QnlLcnFPaGdXMUhFcW1vUkE1NFlRZzN3YXpZUlBiNkZTM0xQMGly?=
 =?utf-8?B?Y3dNWXZPOUZtV1Y3SG9vcFBURFg3Yno5WWI5ZEZtVlJiTVU4R3FlQmR0T0JB?=
 =?utf-8?B?dmV1OVpaS3daUW94MmhMaDZtZm5JWExydzRCcHBNYW11d0xIUWMvcUFBd0NT?=
 =?utf-8?B?cTVwUUYwcnZlVTdkZXJ0YlV2Skl4LzBEOFZGd2xRdXRLRU1ZWGxja3BYbmNy?=
 =?utf-8?B?cVA1RWVUNmk2WkUvMk9XRFRnR3NDcWF6UkVSM0dPMCtJMHVwL2crNkRDR3la?=
 =?utf-8?B?SXFDNFZMZjFFWHptOFVBeVdBdklpYytIOXVadEg5L0ZJT3lwNTJNYmxRdWRD?=
 =?utf-8?B?Q0R5SkF1L0ozbVovRjcvK2VONjJ3Nmpkdk55L0l0akNuZ2R3NTF4VVNtbVlX?=
 =?utf-8?B?OTRYWkU1SEdTTG54TkdvM2hiOVo2VDIvai82a2N4MEZrWFg4cmJqcGFjNERh?=
 =?utf-8?B?MGsvQWpZek1PMUpxSHJ1RTVNVWpHZFNNOU1CbGQwb0E0R3BON3I5NTdCUTR1?=
 =?utf-8?B?UW82M2UyeTNUbmxsYWplZzQ0RlB0Y1ZQZy9KdU1vUjRVV1kvOUZNTkJEcHF6?=
 =?utf-8?B?WEU4M0VDTVN1ZHBJUzJGalRGWlhLVjlBcjJvd05IMHJOREMrWFVSS0dIM0JK?=
 =?utf-8?B?TnFjaC9jQUtCYUFtdUd4dHVMOC84eXB2ZFdqVDFhdEhiaHFVSjhnbVp2dTNN?=
 =?utf-8?B?MU82amwzekRtL0Y5NGkydmR4ZFpBYzkvcElCZmExUkUzbzhhL2pjVXNwMlZv?=
 =?utf-8?B?MDQzSVFQRi9BVnY0UkM3UWtQSld4UDhQVUFrbG5IZ3V0djh4WmJpNTVsYllw?=
 =?utf-8?B?NVhGcHZaNEVWYTJVWFNiVWhxS2JITWpzTVlxaFlsNGJxUm00bHBsMkNOK2V5?=
 =?utf-8?B?bXNYVWlWY3lqK3cyQ1Y0WVZWWjIxSmxvZ1dGbkt3T1NnWXQzMFRQbHkrQ2JG?=
 =?utf-8?B?ZFhZMlQ5Y2hBZUw5YVRxUENqbXY2MFFpeWUvUHQyRVVna3BtM2xDLzEvWUda?=
 =?utf-8?B?U3lPWTZpZmlNMGp1VjFmNUtNZTl6R011WitOZlNSQitzdFVCNUNFN1Y0UGNn?=
 =?utf-8?B?Z1h1dHBSQ3hDaks3V1RJRno0a3lRanZEY2w1RVVhajMvOG9KZms4UVlkM0hy?=
 =?utf-8?B?RVlQNzl2SkpBR2Zzc1Vkd2J0V2krUEhTSVVMVk4wRmt6OU1SSlJ1VXFzcXh1?=
 =?utf-8?B?VXlIVllXcGtLUVF3SVJBdGtRM2V6YnBNWGR5ZHRkN210ZGR6aHlwQ2h5VHhX?=
 =?utf-8?B?bUZWQURELzVtTk4xMnBTWWxMcjB1eWVSRUJrbTRDdVNRTVdZdUhmKy8yR0V6?=
 =?utf-8?B?MkFXN1lQSmptc1h0MGJPeElFdmdPWUZQOEhnUUxoWXo1MkltcTJrbHBrSFIy?=
 =?utf-8?B?NEZHL25IMGxJdVdPck8rQWFmRWdDQ0t0eGZ3djhCTnNRN3NYcGVBWjZOakNr?=
 =?utf-8?B?MEV3Y0d4eUVDM28xVGsvbHpUOS9JMlNxdnJ6cUx6VUI0WHl5YkZmdGx2VEpE?=
 =?utf-8?B?ZnVCRUdYcE1KM0hRTTJpd3FpODk0Zno1c0RNMDN2SVF5dnd4N2F1eGNZeWVs?=
 =?utf-8?B?OTNJZXUzTDF1VmdaRlh2L21wcmRVQWZBdWdXY0cxWjRJYWI3ZHRXNVZJd3lB?=
 =?utf-8?B?b1BKU3A5QklPZ0FlOWtlVGhYdGJZVFg4eWg3ZWtQVEN3dForQjRSRFpGR285?=
 =?utf-8?B?ZU5FejJtT284MXIrV2lEWEVwODR2K2pjU0diZG1EQndFc1BWemVxdzRsbVFx?=
 =?utf-8?B?VFBJTjgwTnlPamI3YmdNSTNhUHMrbHZ4Q2I0VlNqelhjYW9DRFY1RjZPSFpl?=
 =?utf-8?B?eTJiYnp6L1dnS1FEc1kwMXp4WTd3a2ZUZUV1aUJvNVp0VXh0MU9mcUY3Z2Ix?=
 =?utf-8?B?eEZOYU9UaVlOQlhvMUVXaVVEa2w1Z085TXN6VWpZNXRHSUlJNEg3bllSbXVt?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e39cd1b7-df1a-48ba-bd60-08dc83edf7c0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 16:55:26.8073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsSaFrJMs/ZFpdXgYLSpe+gq1+gfjcUJRdXcRkw6sDRhPUC+vNpbFHpeMIRv2mXoKHMghS6Y62vN9nBRtALW4mWjwyjkhETfskxtm51Ad0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6863
X-OriginatorOrg: intel.com

Dear Maintainers,

On 5/31/24 12:57 PM, Tony Luck wrote:
> [get_maintainer.pl is vague about who owns <linux/cacheinfo.h>
>   to I've scattershooted some of the folks that committed changes
>   for this file]

Thank you to Andrew for picking up this series into the
mm-nonmm-unstable branch. I am not familiar with how patches flow
from this repo/branch but I expect that this inclusion will require some
high level coordination between the big repos since resctrl changes
usually flow upstream through x86/cache branch of tip and I
anticipate some conflicts and also needing to figure out how to deal
with this new dependency in planned resctrl changes.

As Tony mentioned upcoming resctrl changes depend on this new
include/linux/cacheinfo.h addition while some other planned
resctrl changes [2] will conflict with patch #2 and #3 of this series.

A previous change to include/linux/cacheinfo.h (commit
709c4362725a ("cacheinfo: Move resctrl's get_cache_id() to the
cacheinfo header file")) was able to accompany the resctrl
changes via x86/cache of tip. Could it be possible to repeat
such a patch flow?

Looking at mm-nonmm-unstable there is indeed one other pending
change that touches include/linux/cacheinfo.h ("cpumask: make
core headers including cpumask_types.h where possible"). I
confirmed that there is no conflict between it and patch #1
from this series, the two can be applied in any order. Of course,
this means nothing for any other changes to this file
that may arrive later during this cycle.

Could you please provide your guidance on how to achieve a smooth
upstream of this work?

Thank you

Reinette

[2] https://lore.kernel.org/lkml/20240321165106.31602-1-james.morse@arm.com/

> This helper function came up in discussion of the resctrl patches
> for Sub-NUMA Cluster (SNC) support. Reinette pointed out[1] that there
> are already two places where it would clean things up by avoiding
> open coding. The SNC patches will add two additional call sites.
> 
> So rather than have this jammed up as part of the SNC series, I'm
> posting it as a simple standalone cleanup.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> [1] https://lore.kernel.org/all/050c64b3-20b3-4db6-b782-f5124ebaab31@intel.com/
> 
> Tony Luck (3):
>    cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
>    x86/resctrl: Replace open code cacheinfo search in
>      pseudo_lock_region_init()
>    x86/resctrl: Replace open code cacheinfo search in
>      rdtgroup_cbm_to_size()
> 
>   include/linux/cacheinfo.h                 | 21 ++++++++++++++++-----
>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 17 ++++++-----------
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 14 +++++---------
>   3 files changed, 27 insertions(+), 25 deletions(-)
> 
> 
> base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0

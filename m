Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9995B313275
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691065; cv=fail; b=tQVKO64nigXBzabfgJVyDPO00b9c8NhcZnm3g0MPHVucugARd4noL32pUksuU0tiVCQRxjt6ng/BdzbC8mboXNADp1I1L5jlJm5VK5QBLNf3w2oHJpF5n5jyNksCO0ZA3ddbAg5Y3/TjoMREpWUIwmhe1wojC3+l3BwwL48YGoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691065; c=relaxed/simple;
	bh=v7ludfQMPYDcWpHWuRRvvSLrYXpiS97NqV88lvr5He0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ixm/NRi4zhjgXF8H/qQamZcMgRvltuP+vl2jfA7EGPxpN5QB6VsMvQtgCKOMZYNMkXfC9H8Bc6ChJk+RvZ8TVF1A/UxCqKBoqGiQ+FefcvDtTka0gqoKG8l/4lVmLAuNWJjw2T9TvUQAEG4TNiEmnZpRZCN1BzEEuO+dRa7tC2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5S85g64; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5S85g64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757691064; x=1789227064;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v7ludfQMPYDcWpHWuRRvvSLrYXpiS97NqV88lvr5He0=;
  b=k5S85g64F9kTs6XNGWhiTtl+s6hDZcJQRk9eCYY6cYqmihY+A1mQW01a
   ol7xIsR+cU2GoQ9tdlV+NwKaKaDWo9ihPhq1++73anoFWe3yOS7s5yx44
   gRdFatof1vbuwXJmlVHALMMuWQMOCcg0T4OhwmFFawh7I1OziAXLG0S3l
   ErX+JGDxivzmvqCPtYzilk8IqmyheZ+r2dLF7uF8RwalTQtKF636lSL2i
   xUxPRUCWlq4MytNEpwWadvp2juFLOgC3+hyw83u/7vsIdRvvzfCwriz0X
   nPIEYTxrt6evIGXe3MeX5F36far0W4AxF/ETgzdueGIu+suWvyDjNDOKn
   w==;
X-CSE-ConnectionGUID: HdtKbHTrSDSllzUbNC/iww==
X-CSE-MsgGUID: qxmfuslCTAap997bvl88YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="59735862"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="59735862"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 08:31:02 -0700
X-CSE-ConnectionGUID: SnDSxNFIQGuOHCU8j8b+4Q==
X-CSE-MsgGUID: M62YItupTr6xqrvZJ6SWhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="173907845"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 08:31:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 08:31:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 12 Sep 2025 08:31:00 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.52) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 08:30:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haHy+2phsebZiW6kSQj7QEB82D8z17Gd26G35DiMt4U8h4rkNkdgj6/oTtWM2BoxOR0r8kG8lZv5+YVF/jsbWr9LWBk+qam2IqW2e9VFoAyOqpyrbcKM6CSb7JTfaBFnpPg8gcFsISJW6VlP+fKngoGfbhzY9UYwv+jQq4IdPqG+NRLTh21gVRe+cxEbrKC9e+gZi/09H6mTqS4WX05EPqLSqLbJnkdbBrweh+wvqV1kgswj7DAd52/Rm46GRmEOUsPGetNytzeRd85PhxUXyczF1MUaD4iv64iHFk0UU5OSqHAc+LDPWvNign3a7fMY9qDabTYX6uGaS55lBnbyjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixz5A1xxzSZn86gj8Tzjp2j1B/EoLODG5QXjjRLKdNE=;
 b=IcguLgk68iM0G5IPyQBANO6ptT5QmdrW+1AYOUeT6pws3qwU7kJpz2tH0K8VRhbpAPC5q9lYmjZPOJ2LusTeiVQlw16WIGSRkJvRV56P+XwfdDnaGnaa/lSRmJWMepArbxm50EjTnrbRMODLGWKN8sFT3czMcvujRGBP4PUmyY8yKr/u5vnrwgHclM/Jyjv4Hhs4LWdpnG5p5SF56kFGWTjZ01hXnYV+RBtWnlz6rYcYpta8V9e1Rq7GH/bdK6s4DgxiKaWbVOJBuaqpBo68jUHt0q0VhXSQDcC8lOJM14H6nY9geBiYrFa/Mn1PGzzZ5IKpoSEwcW7LWKI70W7DrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 15:30:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 15:30:56 +0000
Message-ID: <8de19e0b-161a-4c9e-8520-62a7e043622e@intel.com>
Date: Fri, 12 Sep 2025 08:30:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Eliminate false positive lockdep warning when
 reading SNC counters
To: qinyuntan <qinyuntan@linux.alibaba.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <0819ce534d0cb919f728e940d9412c3bab1a27c7.1757369564.git.reinette.chatre@intel.com>
 <611ec112-02ee-492f-baef-270edbd08957@linux.alibaba.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <611ec112-02ee-492f-baef-270edbd08957@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:303:8e::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: a319310e-8642-4492-78ad-08ddf2115e38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bjRzYkp1M1QxaFd4QVFobGw1Zm1yTG05NnIyVVE0SWsvODM2Sk52ckVrdkxi?=
 =?utf-8?B?YUVPN2RrdEF6eW92U2xtRXliN1krSzh6UTYyVlVOdlYvYjh3eXFOR3FOMllm?=
 =?utf-8?B?WVV2OGhmTGxYNmlqUzhiRk1Bb0ZiWWxCY3NEcUlaWGM2bUdCMnZ2SVU0WHpI?=
 =?utf-8?B?S1lYZXhrK3dZRWkxako5SEpwVXNzUFNiSGdINE81L0JMWGd1SE1DdTkvUHRB?=
 =?utf-8?B?L01hOExwcUxJU0N3SVhMUVlZQjJWSEtxek5ZVkhlL2YwRlVza0V1dWU4YnNs?=
 =?utf-8?B?bXZJcnVMVjVGbVNLZlRZeC91aE5TNjIyMHc1a3pUcTl6SzNUWE9CYlc5Yzhu?=
 =?utf-8?B?Ym9rcHhDYzkrcnhBNE1PbkpmL2hrSFJwUjZ4bGVhZHFjbHQvVjIvSEpXeVVj?=
 =?utf-8?B?VlB1NEsyRDZndXZ6YlFxODZsTyttS1dEU2pOdkpOb0FXeVYxZlZyeG13UWk2?=
 =?utf-8?B?N2oxdHB2QUgwdXBnVjBZdzFKbGd3OGNCcDNEbHdCb1RXVjhsaUlPMHBEODMv?=
 =?utf-8?B?K2dqaDRjUVVWRkw2K1M2SlMrRjY5eGFpcUxZN0hNV09sYXlld0hhUGdzY2Rr?=
 =?utf-8?B?UjRmZXhuM0hqRVY1NkxhczdHMTdWYlJta0JkbUs2aVBKaDJORzY1bEZ4ZXlK?=
 =?utf-8?B?d2R0eEM4SWR3TVJjdGIwMVpzN2IydlM4bThNbnFVRGNIWkllSWhJc3U5ZDZv?=
 =?utf-8?B?R2pCMXBUNVVQbk05OFhzTHhaQkJ0MFVIaTE0RWMwNTNuRUdJS01iWlJxMFg3?=
 =?utf-8?B?RXdrS0J4bFBxY1JaU1JTajJoOUFFT2VqVVYvck1vTjRBK1R4U0IvTkRoVXFl?=
 =?utf-8?B?d0lPc0VRa29KMXIvZGJtVWlkTkg0b2duaHhRM3d1TTJFMXZFRDlrWDBMQkpa?=
 =?utf-8?B?NEo5N3pQb2Qwb0k0TXdxOWZDMHl0cVl6Z0pocWxBeExSa3FkVUhvWkxvazQr?=
 =?utf-8?B?R280dDF1Nm5oS2VxRVJFaVRHaDZJZDRKTWZMVk9wanBIeXVBNytkU0hmTmZi?=
 =?utf-8?B?VXBTWXI4MGFBMmUzTGNyVXNrcWlHQ29XOXJKTVN3YnN3QnRIVmEyd0lDSmRD?=
 =?utf-8?B?bDhRTE9iMUdrUGVDeSs1R0ErQW1RL3BnRWk2L3Z0QjhRLzRpdDJOekUrS2or?=
 =?utf-8?B?ZzJhUGN5UzdBL3g5KzlVUDRWamZPVEtQSFkxdmhjc085VzFxZUlld3IrdFhJ?=
 =?utf-8?B?VkJNcXRSU1hpMUk5WStMb0pPalBMQlQ2MVBod1ZydnpRWFY4VUhYR3BMd2Iv?=
 =?utf-8?B?TGhhamRpdWUzUHRqS2xMZ2ZBeDFUb2ZFSUtKY2FYYjNVa0ZKOFdsRE43cVBZ?=
 =?utf-8?B?bG5PbzJNcy83L0Jwc2pva3Fyd0psYU1oL25wK21wV3pEU2pTNXVjUk9PeU1l?=
 =?utf-8?B?NkxEcHZiakF4cXdGWW9VdXBOWmQ2LzY4dTRGbWlOUzUyekp4clJESWFKbFlP?=
 =?utf-8?B?c1VnWVlETlExVSt5eWU3MXFOOXc2ZHpaam5zNGVoYzFFY21LZ0dUZ3g2LzN1?=
 =?utf-8?B?VUc0U1k4YkpkQit0YzlWWURob0VCZkEySk1lczlOKzJBUDBjbE9XeWJZc2F6?=
 =?utf-8?B?NVBJK1d5WjFuTlNKODBwSGwvSXc0cWFHZ0FpVmhoOEVuZlFHR3I3YXNCa1Yv?=
 =?utf-8?B?Zkp5OHpJbDVlbWw1ZEJ0YXdSeDJ1TUcwV0RUN3dleWdwUDRFOXhlb2JyMnJJ?=
 =?utf-8?B?ekVRdURYbldqQlBBdHdiRzM3MzFPWlltYkxvem0ybnVIYm5uM3gxbHNLZFRV?=
 =?utf-8?B?aUkrcmhFbktqVmlNMnFIZnJiN3JpenQ4TFp5aFpQV243SU1HQzA0RGVwTk4x?=
 =?utf-8?B?SFhLelErL0RnUHpuUUc2UjVORVV1dGNQSU9wM2E0UVgvRGQweGxYUUpuNGZC?=
 =?utf-8?B?SkJnK21pRFNOWjYvZ0p6QXhWbXkyNEhtdVJEK2U2L2dYVkovSG9TWnNvaTFp?=
 =?utf-8?Q?BJrx2Dogqxs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em9nUTdmcktZdkV5RndkVzhpRU03bVdlMVgxUmswVml6c1JJVkVBazZuNFJn?=
 =?utf-8?B?b2V0TEZDTXcwUXZPdnA1dWwyYWpqM3ZRdGhqS2UzOEpDa2xhbnhTV2pGLzNM?=
 =?utf-8?B?TkgzNnNaL3BCWVpmUTF4clRSbEloUjZZdXB1TTZxYnN5Vm82L2JUUUtjVS96?=
 =?utf-8?B?enptZDhWUXlQYmJvSUUxcUEyOVVRMzVBc1dDQ1Z3cWMrKytnQ2FnMEJpM2gr?=
 =?utf-8?B?aGthK1RtcEZ3ZHJ4T0hKeFY0bDBwZUI3WGtETVo5ZGZGejNXVXFtRXVEYUd1?=
 =?utf-8?B?S1lYd2E2UWtjcTZ5V0Qrd0l2aVA5OGZ2K3NKUzk4S0J5STg4VGl4Q3dpRnZP?=
 =?utf-8?B?NkVZQ2hOaUlzeEdtUnJuZTRvNGtFTWE3bnArK1hDZ3UxamlPbGFGdytoYnRu?=
 =?utf-8?B?M2xDcFVLc3dJL2dldmg2aDFGcnkyK0dsZnZ4THV2V3R6dktVb1I1enEwbVJV?=
 =?utf-8?B?U2ErUTVtd2ZjQWFIUEZTc2lzMWYrNHlTbW16bHJDaWtYUnptSkFMMmNYUExD?=
 =?utf-8?B?TUtxaWJyNVZBNE1zQ1NxVWphbG1IeGFvWDJnVWlFdG9CTmE0ck0vc05STkdS?=
 =?utf-8?B?QjlRcWFvUm9yTi9tTjRobUR0RTlvRE44VVQ1cVF2TWQzRUlyRE15STZqaDA3?=
 =?utf-8?B?SDlGMEM4NjJJSm5yaHMwc2tHTjMvRnl3d3JrNW1VSEJYYUE2cXNheldSUTBY?=
 =?utf-8?B?aVpaV3pKWXB5ZzJ5UUl1TkZPZGNMSk5SOURHR205K3BmUmQ2bUFqUGtWSVdj?=
 =?utf-8?B?TG1vUGtUcFA3MGJqUC9LY2ZJVWNEVUR1Q0ZUNzVlRzRtT3JKWDVLdHhFVEh5?=
 =?utf-8?B?cGxMK25JZjMvUWJKUFI5TDBid09KMnAzbXBRb2NoR0JGc25sNHNRTWlCL01B?=
 =?utf-8?B?UjhlN0VwN1hCSkxwN2hmQVJTZW9ZMGQzblk1VHVkeFdEUktrN0JlVWV0bHV1?=
 =?utf-8?B?dHJXU1ZaUDdaZTQwRDBLVWNTMW83a1Jlc0xleXh3RjVBOFROdlk1bTg3b1M2?=
 =?utf-8?B?TFdpaHAwOUQzMlhvTUxIa3gzR3Q4eHBHY3VaNFJ6VDR2VlRwY1p0aFJKd1kw?=
 =?utf-8?B?eDhEcWNwMW8zK2tnRmJIRkxRTkVkUVVreXdrV1ZrUEc2YnNEQXBjVVBQTGY2?=
 =?utf-8?B?VGhUdmIrYkhNM3NvTnNYM0FTYm1vcWNPQW9kSmFtd25kQzd5L0wzRWpFTzNn?=
 =?utf-8?B?Tm8vZFJ1a3B5Vm5yblE2SkJkUkFPVW9ZM0Z1V0dZWkZYWWVwekJ2MHBZVXNQ?=
 =?utf-8?B?WURXbDVGVGJ6bkF1YmIzdnVwKzgrUmJsb3BsMUJVQTNTcUZIWjFRVDYzQWxs?=
 =?utf-8?B?MTJrbEh0NngzV0k2SVBXaEJaRW1BNWdvcG9KS1JhY3VsbG1EMTdvaFpjTFh5?=
 =?utf-8?B?c3FSRmZzdDZyNHRiK21qUzVYSEdvbWpxSXpwZGttdE9OWXYzUXphUXl6K1ha?=
 =?utf-8?B?S014NTdmN2RTYVhjM3VsZG9TZytYZzBkRmdmcVZlSkp1SHIyN2JVbXJSNEVp?=
 =?utf-8?B?OEtHZFRjRmxsSktYUlJrdXAwSTU2TUgvQVc5bjBlU2Y5bURUYTBaeWVuaVhZ?=
 =?utf-8?B?OFR6eThHZ3U4V1lWTkVSNmpyS1h2aG9aY2FKWmZGSjRHSW9vd3pydkppYTlt?=
 =?utf-8?B?L0k4RmtiN2ZXUy9SUlRnQjdvbjZ4b2k2ZzdsYjdnZkJhVVQvaXFpYlpHM2M4?=
 =?utf-8?B?ckVWYkFhVnJJbzh3bmhIdFJIUm9lbjk0UVhJRXYxNnJtbDhhYkErQ1VQcTli?=
 =?utf-8?B?d3cvOEgwTHJ2TmNFaTVhZWducXFOOTVFY0VjVkJDNTZnbHk4YlBjTnpjOVZr?=
 =?utf-8?B?Qnl3VFdJU2ovZUpqVTQwd3NrN0J6NzN5QWpMN3VrKzdpR0tjR0wwaWdJdHNL?=
 =?utf-8?B?Rk04Uk9iRmVDL2dmbGNMNnlRZUtDWWUzL09wVVc2MjFFRm0zcnJUSGwySElE?=
 =?utf-8?B?bnJFLzZDL21xS09mKytScVNnYUJFaW1RN1lkZDJWR3NuRTl5WS9UYWZWam1N?=
 =?utf-8?B?TTJXeDk5VGIyTnRpT1FFOUJBZm1lMDl6dUcreGNqMG81cE9pSUk3d05wd0pF?=
 =?utf-8?B?dmhwcFlnK1VJRGNDWlBVdEVsMTBEZTdDRzRUbDM1dEFvTVI3RWdJMHZ2dGhw?=
 =?utf-8?B?MDZmYXk5ZEJYU2poU3NBY0xzMk9wSjRGM216OHQyN0dNUVhRdEdFSWR4U2Iy?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a319310e-8642-4492-78ad-08ddf2115e38
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 15:30:56.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpXGBZiH2ZBGkDXlDDvA4D0zFqBXHC97WnTRhfZiUpy77onAmPHvkMoVrUgirfiU3MYYyoxPmolA7Rgm/zrcBUzEEA3TR/1hujnGTF6KurU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
X-OriginatorOrg: intel.com

Hi Qinyun,

On 9/12/25 2:51 AM, qinyuntan wrote:
> Hi Reinette,
> 
> Thank you for reporting this issue, and my apologies for the delayed reply :).
> 
> I was able to reproduce the same lockdep warning on my local SNC-3 system, and the warning disappears after applying your patch.
> 
> The change looks good to me.
> 
> Reviewed-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> 

Thank you very much for testing and reviewing!

This patch has already been queued for inclusion. Unfortunately
there may not be another opportunity for your tag to be added, but it will
forever be associated with this patch in lore.kernel.org.

Reinette



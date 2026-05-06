Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD3846A
	for <patches@lists.linux.dev>; Wed,  6 May 2026 22:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778105824; cv=fail; b=DjO37bVhVFrakzA4TYyZifntJ6dzltCRjELdmPCvkBsjMHwEj+qihZflFC1T0grxEj2n97YnrXoMEEY6GI95vu2y5tOITL6HefR4rTlk+cUlTsf9UjZ4aRzsgaG9VG2gNcU4sLzqVPbXMcRlz8ZPm3q0G5EIsiK7E0F8IQbxDWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778105824; c=relaxed/simple;
	bh=q7zEFakrOJPxlwOqUQyFgBLJxZ720+P7f8mv9EJkZWk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DKHwXoueckVuHrR9bRWlgylRipDdr02jqSsR4fF4Q7H5CBmZJ9hVXuRzpYZofmexQ18j2Rq8A26tS4DygyzBN9TDRQwP8XFUukuHydnZgkIc+ifeP41V4CH18Q/zqMWtp/r3UXRLdxJBicwZ28bsqFiLEVq41GcnTWe6tqE6El8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WHaS4O2C; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WHaS4O2C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778105822; x=1809641822;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q7zEFakrOJPxlwOqUQyFgBLJxZ720+P7f8mv9EJkZWk=;
  b=WHaS4O2CjXRS3175Lf90O9e1ETdgYNUFuRjMUstCERH6cDTt0GEqKqEo
   81449SAYyJlBi4wgSNpg1GsY3H+Dc33xd2H+61pbqsnup0iyR02ztfsS5
   VPS/bohWYvm1Np9am5QJKd8o0NkNTdcedsJPnGJe/UCu34YE46hcLg7Pd
   CsJstD/jhSeIi/+0s7vZLoTSQa+3/4sM93Ibdnc5DOtTSMTQQUkrs5iBQ
   LScEOJAvZDy6rinaUSSX4VhDmAestCLsADqZgGm2inGREiCx8b6XOvA/s
   Fh+/7/I0HYs4AJluVJa55C6MSiS7GPlrmEHQt3bAsmQRdefXsdKRVWH15
   g==;
X-CSE-ConnectionGUID: J1D/vPQ7RW+kiPJY8B8iRQ==
X-CSE-MsgGUID: JWkUiK0VSb+gYMXfvSuvvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="79098799"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="79098799"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:17:02 -0700
X-CSE-ConnectionGUID: K94An1DcT32ohmE76ZjR0Q==
X-CSE-MsgGUID: vFeAeQoiSFOJ3AYjuKmUFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="235421741"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:17:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:17:01 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 15:17:01 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.61)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:17:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnzS07XCtAjf61bGjKPVB7RE1EQXUIgTUed761j0aEEEn3dUKrmV+xnnIUrTLSe5zYPlF6SbnNuE1Hjus+0hV51FagOvYvTT04bx5gL4UpGDdN5ZwHn5HGqDg3SGW1jn/8M4eykEnUbA+O7pEX53rvOlia1NmZIGNufjvGQJKrSmLKYZuB64nCMSD6yyucQlar2jUmPP7m79cL8qwUVXUYgt4MZ4zYxr4yMmFB1tefyprdc/0e8m+Cgim4yatspVOZixI9O9Al7D2mucCde+NdIcrXtsixDichDO0TSLB4zt1sCLpIUgJaCdkVz9P+EBP8NzBiZXEk/3aIQ7i2oLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOljuwf33rM1D9eZHKIcZS1Jq0l57A8D0R3PWR65TR4=;
 b=YmqjYYz+JUkcYa9Lw+/eLUAN3wYbDHEjx7CnoDxUqVVclBTh7f8UJMeScTgCm857oS0VA4SA7swpMrCNmUtncHvSIygB9ptk/7IiJ20hC2yGeA6vLsjSQCOq3FW0C9a30SqehepMT2mvCtZ4+OsjQe55ztXSHmHeiOvfqRa8u7n33KBoy6AE8+StH9MLcMMVKbS1SbjdnoP1UY4EQQ+dL7OG+RX0WLcvoTjbGF8UYH/Uuxk84OEMfeUu9u6h78LeN7Q0CxBQIQgRAOct1KSS5Zkyk0/QBZDocVgvpwaqNYADvlcvCRtKuJa5+M2OQJn5RHWpBqywIZnAgjbYCeV1OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by IA1PR11MB6218.namprd11.prod.outlook.com (2603:10b6:208:3ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 22:16:57 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%3]) with mapi id 15.20.9891.016; Wed, 6 May 2026
 22:16:57 +0000
Message-ID: <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
Date: Wed, 6 May 2026 15:16:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260504220149.157753-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260504220149.157753-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:303:6b::7) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|IA1PR11MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: 4288582d-5e6e-4f8b-b5f0-08deabbd2fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: T/lop8nALhGhsCVMfsy8aHHmlD8ranw6qLUZdgd7P4/yZSqLbwEd3Pj3CicFW6bZIHxu10sRGaV8mjO84PJDlnqsBcjfOKcmpeBof/qISEQVEqCekJGHd/tAVMp6omzXM7IIr8XphaG/lKF0Az1D1J1kv3F38RDmVAAZuqPXXH8DwQa5HKImPQQ2u6ZRNoxlY3ULkuzG+Wsh75q6EzVoCnzArcHaa8/j2V/qANZBhc7js9b3/gPdoXGuzVSdufCo82/llgzAXopQ0T2JvbgqgRU6i/zkvfHEDZoRqGQovrezR7hiSj5q2g1gHwWCg97POmSUFPheDC7fZKjtE61u3EYQHLeKanHzL7WVSeLZ2/ZNqMzQmrNhd7rBOpapzti3oEgSRihh1lHheYSKo4F2R3ffuJisNmey4nULZRj/BW8hsd2SPxoZ7dvG+FUo2Bu6hHtxQhJrWLF0vgkz/Ey1M1r1exLwR+ynUnrVdwgoUNNd10HrdS2ywdenf0z3s6ad/z8bT5K0ewmtydGMEHzB+WrtyoagX/UXbyqwiRh80ftwr4X8fZZGEPasI2+cKV/Ifi4kfPx9OIigAU5FBd/eo01tHp6P9r63xgGP1TYv2zvZQUk+rv/Sd65jUsc2Nr91bXNfCWD/t2DweBH5DG8p6R+/PrdyNKa1Qc9ixg4T9dYz6SCdZuTIaP3q9CA17fZh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFRJMmdZOVNCazBUdktPdFErR1lUb1pBWG5rN0FoREdxd0dTTmdSMU1XMWpW?=
 =?utf-8?B?ZzdBODJCcXJoaHBTUktyU0g5R1FaQjFMRkE4bjgwYS9kL2VTUDFXUU9oNUZo?=
 =?utf-8?B?T2pMTzhid0VpZGJTazZFZHBLK0xjUmZSc3UxU1BvZTQ0M1RKTmRkV3dvNmc3?=
 =?utf-8?B?QllMREZDNDlyWmVLVmpFMFU0ZEwyaUpTT2VyNHVHaFB0WVNpRURSbU5SRlBq?=
 =?utf-8?B?aUkvdGNFZXFEVndQOXdQSG5GVG5YTnQ4L05VYmVNZGZ2dEx5QzVQVU5pblJU?=
 =?utf-8?B?azcrOG5XalF4bHpjSmZ5MzUwSy9NRFBPUVpheVF4aHE3eCtnMTNYWEhVZHpM?=
 =?utf-8?B?UUtPWVVteGx4NmpBaUN1UUNxbU52RjBuTENaMW1ObE8yTzlkbm1iSyt0TFlY?=
 =?utf-8?B?MjhhU2lJSXdGKzdKb2NRVHRUTTlYeWFlMXVUQzNIQ0h4UVlJUGJxbWVSWWZR?=
 =?utf-8?B?OHBUcUtPNnQxOEJDSFo4M1Z0VEhNWkNKM0xYVk9FOHA0TUFZMkNneS8vNTFy?=
 =?utf-8?B?RlNmUlAvY3dHSGtPckpQTlNpekhZbjAwL2ZON05MQVJoRG5UZEkvTGwrS3R4?=
 =?utf-8?B?eGdzS3B6bmRrMmpjTWtJS1R0bGRFTmxRTDB5RUlHa2dPcUZhMnFMZDBrQkFa?=
 =?utf-8?B?UWU4NGdFRHYwNGNvalBnMFZFZ1FxTWxzbEFpUTAvb0lhd1VZUDRielJpbHl4?=
 =?utf-8?B?WnAzYnczWDkrR1ZCbTRFdDUwLzVJaGc4V05xb0JwbHdodDEvd2VXdTczNTh3?=
 =?utf-8?B?NGQ2RjRKWVFsTUN5aXE0SzczM1R4S1gvSTRTSXdza2J5UityQWhucW1jYXhZ?=
 =?utf-8?B?ZGFPMWV2NXVTaXNNak9RQ2l4N0FwTFU2Z1V4czd2QU1xZGgvNDdKM3FhZFB1?=
 =?utf-8?B?bDRpUkNDRFZhOFlmeGNHOU41RVZ3OWJJT085WWdqdmdvOEwvMmFiSHlDemIx?=
 =?utf-8?B?a3VteDh5VEFDMW9WdGw1dFZ2cHdEL1JjTkV0VjhwZkp6NDBVekJ1SDVnUSth?=
 =?utf-8?B?V1IvWndxUnF6K3JiankyNk9JSmw5dzJkNDk0YzQwTGlLMm1nMzVzVWMzVXp6?=
 =?utf-8?B?K2phSEdyaUdTRG4rOWE4R1k0UE5FdlJqZDVkVDVkTWZjQ3pkY2JhT2ZrM1FU?=
 =?utf-8?B?UFNNWEFhakxYb0NtNHpSM1hPbTJQVmZDWDBHa29uLzZISzkzTVdxdE5pWjdQ?=
 =?utf-8?B?ZEhVTXlTQ2lSMXJkNUlnWWdWdVVqclA0bWcrQ0JPbldaRmhrVldxaGp4cHZF?=
 =?utf-8?B?UFBSejgyM25EOUQ0QnpaSGh2Q2JFQUptTjdHVFNxbFQvVVgrdVpnekE1S1BC?=
 =?utf-8?B?a2xOR2NyaDFGc0Ntd2hCcXFNZmV0eHpSSExoeVNRVE9MOEQvdmlsbGZTMUVV?=
 =?utf-8?B?a0dCc3RnUzNobzNNWUhyZXQ5eWZOZ0ozaEFZUVFWTDJLZm5adVhCTVFORXA0?=
 =?utf-8?B?NmtDU0RlNHFJNkZmRG9KNVdyUE9rMld1ekRseUFIc3pqWnd5TVA3a3o0VDJU?=
 =?utf-8?B?ZFlkdzdSL0sySGYwQzBkL2NUZkN0MVEwSkVUYVdmMVFSR1FvQUJnSlJmVjRJ?=
 =?utf-8?B?T3dBazFtZlZwSUZJNEltTm9Sa1VXbTFuRDZIK1lmaUVISFY3ZjB6NHI1ZDBn?=
 =?utf-8?B?Yk5QcDRFS09GUHZ1TDB2QTBpMmRodE1KVVVOSm52K2t4a2JBdXJPazVQMk9v?=
 =?utf-8?B?UjN6U2V2b0RjWWNCd1oxMkdmbjhXM0xzWnZqOWllaC9US3dOU21HNHlMZktP?=
 =?utf-8?B?UjNxanVjeWVadk91Ky8zWlpFWkZYckNLcXJKQmFNVEdhcFI3M0tLUEJZZVR3?=
 =?utf-8?B?Q1VFRmlraVpESmR1MXdQT1BjSVh0MFdiK21RSWV4ZmtjTWF5MEdJbmZLVnVS?=
 =?utf-8?B?UHo0KzFUZTFWSzVub1gxUHcxZTdkZmlneVRmc2M0WWhSb1J4YWtVOTQ2dERL?=
 =?utf-8?B?K1pvYUxFdEIzWExJYllkNjBJL0gzZzhCV2c1Z1d3YnJtVm1oYTV1eFN6UUx5?=
 =?utf-8?B?SFU2Q3pNNmV0NlB1TCtQRFpiQzVTMDk5QzNwVnF3bGprQk5OMkVxNFVLUEI5?=
 =?utf-8?B?MDBJQmR6MFJoeG5hS3JidkwrMlNudXpjaU9kRUpIckFhY1lmcXBxbkIxSTg3?=
 =?utf-8?B?VTBGUDI3c0xXN29zek0rU3BFWVpOUzVJeVhRZ1AwMS9aRnBZci9PTFJxZHFM?=
 =?utf-8?B?eXQ4ZmsyV1d2WVFMTm84aDlVbU5mYmEybGlTMys3UFM1ak9NTXgxdE5RamFC?=
 =?utf-8?B?enJHQVkvdm9qbHdDTUgvZDQ0S25xYkNFVlRZdnNhU1VMRDFaR0JVcGttSE9a?=
 =?utf-8?B?a2tSR0VFc0pMS29hUHJHQklLb3kxZU8zRkNIcDlNWXpvWm0ySTRaQjdMNzZB?=
 =?utf-8?Q?gFxrva6cUE6HovhU=3D?=
X-Exchange-RoutingPolicyChecked: nTU8UFpsOKFK31eASfACEk/iHEmYorQAp0g/oBQhXbEItYSprBGYayEhiGT932Je931YY29M0ZgvrKuEERUSpbnWk/UHSRPaNS6P2IHp4cMSoEUsJFclE0enxKfJSeaneoxWSYOANkb07AvK0HfTtBpw7Ipxwy9XuVUo+XUVSVn5EYknRt0YgzrN+Q06xgDTLEO2dctGfbdLZoEHMqlWBe2zV45CeaGrSHrtA2O8gmIQZBXWTCxkK49zePiOfdXB0yvFqQ5Q61CyFTYD3XoGmMnL7KGLeMUV8vfX8Y9KFmUzi4TUInkYiK+zMlg+lV0O+ly/4GX8Wg3nkouIc/rO5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4288582d-5e6e-4f8b-b5f0-08deabbd2fcf
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 22:16:57.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnMgSV3LNGvqOgrUKL93LO0Ig1v1IVMGQRESSezV9oTeDUxmfasm7d3L4jL0+1+Rh6NjNU7Vt8lx/g9JHvzjrld1mqIIiQYZlFwZp4PdOVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6218
X-OriginatorOrg: intel.com

Hi Tony,

On 5/4/26 3:01 PM, Tony Luck wrote:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dfdaa6f9d8f..6709b74bd655 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2855,10 +2855,6 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (ret)
>  		goto out_mondata;
>  
> -	ret = kernfs_get_tree(fc);
> -	if (ret < 0)
> -		goto out_psl;
> -
>  	if (resctrl_arch_alloc_capable())
>  		resctrl_arch_enable_alloc();
>  	if (resctrl_arch_mon_capable())
> @@ -2874,10 +2870,26 @@ static int rdt_get_tree(struct fs_context *fc)
>  						   RESCTRL_PICK_ANY_CPU);
>  	}
>  
> -	goto out;
> +	/* Release locks because kernfs_get_tree() may call rdt_kill_sb() */

I neglected to add a rdt_last_cmd_clear() to this path now used for success and failure.
It is needed on success path to ensure that the last_cmd_status file does not show stale
information.

> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +	ret = kernfs_get_tree(fc);
> +	if (!ret || ctx->kfc.new_sb_created) {
> +		/* mount succeeded, or failed and already cleaned up */
> +		return ret;
> +	}
> +	cpus_read_lock();
> +	mutex_lock(&rdtgroup_mutex);
> +
> +	if (resctrl_arch_alloc_capable())
> +		resctrl_arch_disable_alloc();
> +	if (resctrl_arch_mon_capable())
> +		resctrl_arch_disable_mon();
> +
> +	resctrl_mounted = false;

I find symmetrical code significantly easier to reason about while the above introduces
asymmetrical code in two ways:
- kernfs_get_tree() failures have identical resctrl state but the resctrl
  cleanup is done differently (rdt_kill_sb() or rdt_get_tree() error path) based on the
  specific failure that has nothing to do with resctrl. I think it will be simpler if
  resctrl state is cleaned up consistently irrespective of how kernfs_get_tree() fails.
- Above change creates inconsistency in how kernfs_get_tree() is called without
  locks but its "partner" function kernfs_kill_sb() is called with both
  CPU hotplug lock and rdtgroup_mutex held. Here too I believe it will be
  simpler to just keep locking consistent when interacting with these
  kernfs calls.

>  
> -out_psl:
>  	rdt_pseudo_lock_release();
> +
>  out_mondata:
>  	if (resctrl_arch_mon_capable())
>  		kernfs_remove(kn_mondata);

While comparing rdt_kill_sb() and this error exit path to make sure they do the same
I seem to have stumbled on a bug where out_mondata is missing mon_put_kn_priv(). Do you
agree?

Putting all comments together, how about something like below?

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..6d0d6ab34985 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -73,6 +73,11 @@ static char last_cmd_status_buf[512];
 static int rdtgroup_setup_root(struct rdt_fs_context *ctx);
 
 static void rdtgroup_destroy_root(void);
+/*
+ * Temporary forward declaration for testing only. Move functions instead.
+ */
+static void resctrl_unmount(void);
+static void mon_put_kn_priv(void);
 
 struct dentry *debugfs_resctrl;
 
@@ -2855,10 +2860,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -2874,13 +2875,24 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	rdt_last_cmd_clear();
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	ret = kernfs_get_tree(fc);
+	/*
+	 * resctrl can only be mounted once, new superblock only expected
+	 * to be created once.
+	 */
+	if (!ctx->kfc.new_sb_created)
+		resctrl_unmount();
+	return ret;
 
-out_psl:
-	rdt_pseudo_lock_release();
 out_mondata:
-	if (resctrl_arch_mon_capable())
+	if (resctrl_arch_mon_capable()) {
 		kernfs_remove(kn_mondata);
+		mon_put_kn_priv(); /* separate fix */
+	}
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
@@ -2896,7 +2908,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3169,7 +3180,7 @@ static void resctrl_fs_teardown(void)
 	rdtgroup_destroy_root();
 }
 
-static void rdt_kill_sb(struct super_block *sb)
+static void resctrl_unmount(void)
 {
 	struct rdt_resource *r;
 
@@ -3188,11 +3199,17 @@ static void rdt_kill_sb(struct super_block *sb)
 	if (resctrl_arch_mon_capable())
 		resctrl_arch_disable_mon();
 	resctrl_mounted = false;
-	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 }
 
+
+static void rdt_kill_sb(struct super_block *sb)
+{
+	resctrl_unmount();
+	kernfs_kill_sb(sb);
+}
+
 static struct file_system_type rdt_fs_type = {
 	.name			= "resctrl",
 	.init_fs_context	= rdt_init_fs_context,


Reinette

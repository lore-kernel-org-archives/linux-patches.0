Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9F528F951
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745346056; cv=fail; b=nnd1px1qQX4Jr/N217yh8vnJW4pHEBNVZ2vwKrBmW3JRHKOB4NBTTjkxc4knmfrj9+fSqv6LijQMPzf50LZCnfN1L5I3osmzXNOp0UBgeQGK4DG6dkcRs+6T9RN2p8mKAPtjdIPCFoGppRKM6c6CvyESNuirrjsNJfvT8YNajQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745346056; c=relaxed/simple;
	bh=TAnwV0s+aRNuzA5ds2+8GUqQWZzc9RYgwt0b25kbf0I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J6TtdRoSHuGfESSKAQ1oOn+iPrpWtdFUv8ZzmMKYtPcxBs+6C0eXpXa4LRm3XWUQD8vTz2hB1PDvi5cfDuwOA9OSNhM4bmoBWOt1G+ijD8lUR3phIXtdvKNDQxS5R+J6Ne+pmHsUWxjWNtrrAbp8is9enQ49lGXmoBNE4wCAl7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ot4w0ANJ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ot4w0ANJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745346055; x=1776882055;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TAnwV0s+aRNuzA5ds2+8GUqQWZzc9RYgwt0b25kbf0I=;
  b=Ot4w0ANJ99NxZB1j4BMc5vqeBCiyJWRX7LFv/ohxLmA5jhFoYqY/KW7/
   epY7oedhSvCVHRpsgYotNZFdIhEac7K1HV9ohw2gDq+iXiBe7ElsbEtF9
   tcmn/4AZmdcKquAjWDAK0I+HjhkS3VDioU1x6dAzlEOEDLAfkqcm7jtQ/
   uejVeRHZpqvtnSd375AIwNcHeYZAxkFQY1/ClOeAqUnS1iXCD6Xc3Naeh
   lIjT+JtuST5GaYOwLG1T1z9L4x4DQVGLz/uKzfGx/S+eGl9bU3WUZ76vt
   +hPstMRn1AoClZXiC21p6rMN82/IhDpf+ER+h4ORCRMSu1x2QorFF/BPe
   Q==;
X-CSE-ConnectionGUID: SztBDz2UQUe+hc8f7vww5A==
X-CSE-MsgGUID: Bcqz7BZLRnuep9LMG1qBqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57109083"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="57109083"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:20:53 -0700
X-CSE-ConnectionGUID: bgcv5UbUSHu2tkHsYL0/vg==
X-CSE-MsgGUID: 4++2m05PS5i6qbzH4tBTLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="169301527"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:20:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 11:20:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 11:20:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 11:20:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YvwucAtHo6JhJnpEeKzSQyuWHP2MTAfiyUTKZk52vX8hDu5+euYS7d85hzm+n2i/1F8GrqyR7Sn1lUxbEYh1cmaaEV0BNWPovWE0QlRo2IG4WxGKygp8BYnlQ5lr+WyHcnW8GbQ0w9U0WhqGf83LdqzlP3xY1DuH71udgwS/llsAgVTLvStM5PHZ027LyofuiF8xg2kUMbHRLMbKj3cPL/Jcp70FSIA3Ofd3kx+xRirk9IDE9V4yj2QnLEfk4lKe6DWN3q9/r8dvwgHoh2hmaCuzInjbVDugP4ZjxkciD+wd+1TegQHbCDRgwDuHQw90wmpr8etSVmyPaPB7PIVBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UBie3sk6ecJ/hMx+C2kVEnTMLtrGAWQDUKQIXulw30=;
 b=AjCqhp6kd1yhO7w98/HTPHeY23xOEtGEGYxGhQQ0nEFoFYKemWLwq/AT0aGuK32IMQmtFJVhOqTqtXmIALWZDkfmpqm6lOz56AfkzNWopcQbcYH7svW3zNyL8f9hKCceLGI4AjUF++pcw/jVR4Oyzuq1Q+CZYOpBjnaf3GOL9FZmn+NGsADXetZoGF+itUuGEwfYyayjwhffGHVjYG10QM5mIZo9mvhjz/vEbxVFjEr/D9gVO2kc8k3DDLrIS4dHamFBKwT2o3+K+A/m84UfpYN9Yn+0l3rpkjxUQBlfpvNiAduYyNcWg5wra6mrmRdnPePSN2PykYqKZ6peuRc/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 18:20:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Tue, 22 Apr 2025
 18:20:36 +0000
Message-ID: <d65b0ecb-61ba-4dde-abe8-666370d3e5d8@intel.com>
Date: Tue, 22 Apr 2025 11:20:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/26] fs/resctrl: Add hook for architecture code to
 set monitor event attributes
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-13-tony.luck@intel.com>
 <948e4fb6-f1c2-4547-b430-7d9ca3af7cf3@intel.com>
 <aAahh0Mv6m1sIq1k@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aAahh0Mv6m1sIq1k@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0271.namprd04.prod.outlook.com
 (2603:10b6:303:89::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: f2066873-6e39-4c25-246f-08dd81ca608f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YmtVWHk1UWE3azFyc1BrdFgxKzJjL2R0RExiZkdUakRIbVFPdVp4WUxzYWh3?=
 =?utf-8?B?TEpYSTNVdHdFUWQxeG5lWDg4N0xiSEdpVlQ1V0lUblIvMGxNSmdUSmVMaUQ3?=
 =?utf-8?B?Q3hSM2NVc3RDNnRlYlUvZnlDQm1DYVlDK1RSVzd3cllSRkZXZFJTWGxjVGVJ?=
 =?utf-8?B?N0tMYUs2UVRQSlM5dS9YK1EvN2VLZHFNZFAwb3VGcTU4RFRqQTZRd3poNHdK?=
 =?utf-8?B?azRmUHZZbVl6eHlWOHF1enphZ3VLakJ5SEhkdGluMlFGQ0duMXNuTk1FZUM2?=
 =?utf-8?B?SWNia1M1clpSUlJoWjBmYm40Y0Nzb2Q1MzFyeG5pbGVZV0ZrYmRZNVpWVUNL?=
 =?utf-8?B?cFcyUW8wbnFzY1ppY29kbzU4UlVYY0RtQlZYb09FaitCMEtRUHFpOThFc2Rp?=
 =?utf-8?B?YmNhcklieW5STHRrY09oODI1RnFnNThkNjBFQ0FMaVlWd2duOEhVcHJjdDFp?=
 =?utf-8?B?cHM1akw2b0JTS1N3ZnhwYXhEZXVpbXpvblZVTkJ3bHJtOE0wblgyUHZXbW11?=
 =?utf-8?B?bEVnN2tqcHUvL3NsWFFsbEtrbG1HSFVTTkU0d3lmcUc4MVFoR0VNczc3Sk9o?=
 =?utf-8?B?aVZsblM5aE1XbHhiUHM2Y09lZWhodHhveGRNaHJUUlhCY2FTSldqR3ZiQjRj?=
 =?utf-8?B?TStxZzR2WnRuQVlMUFJadE1XSlhndEtvVU40V3BIK2JrMmFrOHB3RFhKYlYy?=
 =?utf-8?B?VUpPYmVpUkFKamlLa3FzZnhGZFl4WXo3MTkwQjBvd3kxaFBNWVd4UzZtN1Fl?=
 =?utf-8?B?UTFmcnE0K2pDdGVkZVJaZWtab0Jhc2pTVkFaWWtVNXhyVHM2Qk5XMEdCSmNi?=
 =?utf-8?B?UzZVaWJaa1VzV3A1Q2Y0MW5TdTVEMWFlUnhXSHN3V1RMRE43RHU1R0lxM3g2?=
 =?utf-8?B?T0JMZkJteDY4TG9vKzZ5S2UzdWFibUVEZDRsbW9oQ2RkR0FLVGJmck9tcjht?=
 =?utf-8?B?dG1wNU02UVpSckRScVV6dWRyTUpVR1FwWUV6bGNwVUJac3pMRHpjckRMVVV6?=
 =?utf-8?B?TENxL3dRNk5Wcmd5NVJoLzZvVlk5SGZYY2pBWGd3bmxFOVFyZGFFblVUVEFI?=
 =?utf-8?B?SU1HWVFBeEorUmt6L3RhV080aEJrcHpEQWZSeTdKdkMwNmJoZkdmNG9WbTlv?=
 =?utf-8?B?emY1MGRybDNQb2ZaNUlqR1NLSzcxdHRKcm45MHFZZ0Myanp3ekJNSzJYVkJw?=
 =?utf-8?B?UUJ4Nkhyd3pWUExLMHg3Wkx6SzBBNTV2WS9uRmZ4b0hhVGFSa0tqUUJYU1d6?=
 =?utf-8?B?Z1BKdUU0SXVnN1RRd2ZHRGVEbUZFNDdCUWNPN3pxQTU1V3hBc0cwWjN2Wkp1?=
 =?utf-8?B?R0F6VXNGcHRCN2RmUFlZWHBQeVU2WldVNHF6VlhNUWlVWTF4VFY4RkZFME5N?=
 =?utf-8?B?S0cyRVlQSmRnU3d4bUtIMzZDL2pRTStDZ3U2UWJzdnJGRmlWMUJBVHhieDhk?=
 =?utf-8?B?RVFVRkJrOWNIVjRjSHExVTV4cklHcFVmVmdUQjl5M0dEUGZNb1VBQ3F6SGdm?=
 =?utf-8?B?T0Z2ZVo2eG5NZXVuampCTGs1ZVlDMjFzSnF1aWtHVFZxeFlxVWZOaTdIalhh?=
 =?utf-8?B?Z2hNT1BLVWsvTlVLVEp2V2R2UG4zQXdRNGhPcGxLamJOMzAzQjVQTkIzSlZh?=
 =?utf-8?B?T0dmYjhCajNRN2dhK3YvQUoxTVE5ZUpXaVlmSUxUN0tpTGFRZUFtSnRhdno4?=
 =?utf-8?B?YUVYejBOR1E2cnN2eDV6WnVTb2hxcWR3dlhoaGRDd1ZQWXNBeC9QTlN4dUpZ?=
 =?utf-8?B?WHdnbFRDZHlKQmpLWEdHcXN5Y1E5SFFWcGN1VDdJMHdGeG9PL2NIWlBZVFd0?=
 =?utf-8?B?TXhPQWQrMnFid2tJa0VVVVZQYk11M29oWUFoYUdsZ29oSG9VWUJKY3F6ejRp?=
 =?utf-8?B?TVFIL241MUNRbkhNQVpidTVuOG5EcnZVS2w5SkpoVlQwaDJFSUdnY0FFK2V4?=
 =?utf-8?Q?uKFoC0w5nl0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXZiWG53bWYxMWwxMHlrdVRNU0Uxc2tWdHFGSW1MMExvYzUyd1J0VDZaMkNK?=
 =?utf-8?B?RGhMak84bEN1MFBrUndwSVU1U2ZNY2JaTWMvYWtJc3lWR1p1MXVmV3pzckpa?=
 =?utf-8?B?UWwrLzdic0tVdUZUUTdJYU9KV21hdE9JNkNEVVUrdDhkcDhVT0ZHV3oxbUFK?=
 =?utf-8?B?eTU0Rk10V2NUSXVNZWUvUjNWQU9RUGJLQmVWTXZ2UUc0eGxac01FRnJ2bk5B?=
 =?utf-8?B?SWdjS0s5bjM1TVUyWjRhUVF0TjBhbC9BRkdhazJGMk9xK2dSMDJZd3R2Q2JE?=
 =?utf-8?B?RFVZMkt6SDd1SEQvcUR4OFRoVC9QdVNqZWJRa2RtaVA0Uy9aWEFOK2RYQXUy?=
 =?utf-8?B?ZmtEQnp0REVZejR3YjR6a1N1RFc3NXRUMUV4NmRUUzlkNFk2ZkdaLzNFUktp?=
 =?utf-8?B?U0RjOE5DeHBCNlU4TlY2cStXajJNRGJlQU1vREtOdVNyR1VYYWpxU2ZjTzNj?=
 =?utf-8?B?YklLMGh5dVY5eGV5aHY3VXdsV1VHWFlrS3h3R3hXYzFpWk91QjZ4bS9abGti?=
 =?utf-8?B?K3E3MUZtc2FsbENEMnpqUnBLUkdyS0JVNnF3MGF2OC9rdWh6Z0tja3pGMjgv?=
 =?utf-8?B?Q2dnTU1IQjFnbU0wbjkrRTMraTF0VkptUDRMR3kwVkZpbXdHWGdkcjZ3aTJ5?=
 =?utf-8?B?Rzdkc0t1MVBrVUplbFRKZUVsdFg1MW5hdjlUMHRGQ290cFNaL0lWNk1DN01m?=
 =?utf-8?B?RHlZTVFCU1RBUDhhaUdiM1p5UUlUZ2RlSUQ1Zy9iNzhlbDdnK3dqU0NBWXNn?=
 =?utf-8?B?WkFOdnJLVzVSRHdlcVFEQUZOcGdBTjFTV0o5bDRpditkYTRoZnJZRFNTT1dB?=
 =?utf-8?B?RzdLbG1ZUWJnZHlObUxwZUppRHk3Z0orc1dBbzV6eFgvb2grVi90K1lxVXY5?=
 =?utf-8?B?U3B0TTdsQko1dVM3dThwV0F1N25id1BrenUwcEpkOWN4TDZaMUJ0N0k2Ni9s?=
 =?utf-8?B?Q0QycWhLWldMblF1Z3JVbng3M1grZjEvUktNMkZ0NmpRTUY0RnhQaTlEcHpm?=
 =?utf-8?B?MU5PVWlENndndlA2QUMrMWlORmxzS0RYSUQ5QjRyMXdFNzRnTGd6QnA4ZmQv?=
 =?utf-8?B?NHBtOWdpWDZqN0pwb1JDYWEzQU9iKytOc29KK2VKOWxFZ3BZVGhUd3FzdE5n?=
 =?utf-8?B?RWxPOFpXdFdacjNDcXBUdllscmlTZlRaUkdhZlpwVm9TZkhFc1ZvTjB6WVJv?=
 =?utf-8?B?VThuMnJEd1kyNUZzQTlySmVjdHZ6K25qbjBWQWlycDZlRWQrTGlaQk1rQVpi?=
 =?utf-8?B?Y2IxcFhsaFU5ZlB1QnpXRVcxU1N5QlpUNzNXTHVadUJtU1JNSDAyQ25nZkww?=
 =?utf-8?B?eWJ5TmNtK0JRbXd6cGZqd05KY1lIam9qKy8yMEVvRnNURnVVNDZJUlpyNjlB?=
 =?utf-8?B?SGtaZlQvTWZwOEVVMnAxMFl2Uzdvay91S2lIUW9zaHhibjlEVVB4M0FXNFdW?=
 =?utf-8?B?a3dVRUNDbFpacC9tbDFlRllBMTNzNlQ1NTdLUThtcjdYdENROW9hQmE3NXdJ?=
 =?utf-8?B?V1o3VmtEdkVUcHVsVEpKaVAzVERZbFlhcFhvMEpnbnBRWE9SQWFLV3BUQWpG?=
 =?utf-8?B?ZFZhMjJWMjhyMFYxQ1F4eU9EWERPY2twd0Z0dVlDT210dzR5S0tHU0dtZjYx?=
 =?utf-8?B?Vy9aSlkzRnMrQjFMNVVTQXh2elNjeVZEUmxMQ1Vra0xOQW43Z05PQ3JRaW4y?=
 =?utf-8?B?SDhlVHR5eXVPVlYxK2NCODNNQUlick5sUnJsSG9BSVhieUxyaGJYSFBYdFdN?=
 =?utf-8?B?aWRTbzI1QkRaSTlYcEh2TEoyWnZMcGlQOGNQTG1MQkIxSzZYa2szZTZjNFVi?=
 =?utf-8?B?N05HOW5BbGprTEdGWG13UjU4MngzWVRpVG5iZzZlVWE0QkN1OTkyV3F5ajJD?=
 =?utf-8?B?ajNmZFpkNFJ4eGVsWjNHWFk2YmhvcWpJMVBtdmdHNWtLSVp4V2k5OFNlZ2xE?=
 =?utf-8?B?eExOTE9Od2FjaW5JbmFpK2xIeXIxTVpYV0tMcXNrMkRSdmMwdXZscDZSaGlW?=
 =?utf-8?B?TXZiUU1LNDkzeEQrWEVhcVhvWUpya2RkL0N0QnNxZExYRmRQOHZuUGpmOGFN?=
 =?utf-8?B?eGZJRVpmMTRkTC9XZ2Z5REplUFNTQXpOTmhRNWNuWFRzTzJCbUwzbFUxbUJ3?=
 =?utf-8?B?RWR5WjZ6SnFyeWpIYW82djM5NXdtTjM1cjROYVFWVDBNV1NJTTc5TjZmcWlE?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2066873-6e39-4c25-246f-08dd81ca608f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 18:20:36.1080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1Hp0hZwMmEWvZot0Z3uF0k7juNv+Xtotp85Wmfa0Oi9GMrkW+buib/XcSy/S8Um/HvZHQOku882WvYIHvWvUkCqYq7D1Pq9MS0IHBGSv9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5820
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/25 12:50 PM, Luck, Tony wrote:
> On Fri, Apr 18, 2025 at 04:11:22PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/7/25 4:40 PM, Tony Luck wrote:
>>> Architecture code knows whether an event can be read from any CPU, or
>>> from a CPU on a specific domain. It also knows what format to use
>>> when printing each event value.
>>>
>>> Add a hook to set mon_event.any_cpu and mon_event.type.
>>
>> If the architecture modifies the output format then the values exposed
>> to user space will look different between architectures. User space will
>> need to know how to parse the data. We do not want user space to need to
>> know which architecture it is running on to determine how to interact with
>> user space so this makes me think that this change needs to be accompanied
>> with a change that exposes the event format to user space.
> 
> Would it be enough to include this in Documentation? I.e. add specific
> entries for "core_energy" to say that it is reported as a floating point
> value with unit Joules, and "activity" is reported as a floating point
> value with unit of Farads.

If it is always a floating point, yes, but this patch enables an
architecture to modify output to be different.

> 
> Alternatively the filesystem code could convert the fixed point values
> to integer values of micro-Joules and micro-Farads. Then the filesystem
> code can print with "%llu" just like every other event. Would still need
> the Documentation entries to explain the units. This has the limitation
> that some future implementation that measures in greater precision would
> be forced to round to nearest micro-{Joule,Farad}.

I do not think we are talking about the same issue.

> 
> File system code controls the formating options available, so options
> for architecture code to break the user interface are limited.

File system gives away the control with this patch, no?

This patch enables the architecture to change the output format. On
one architecture the event may thus be presented as floating point while
on another architecture the event will not be floating point.

Reinette


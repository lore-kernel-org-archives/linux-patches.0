Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B261D5AC6
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745010842; cv=fail; b=HbosMLEHbSTr4eVeDddT3Pu3YEZGcQAloaDcywgpFL+ZucjE/8JoiCL7l61xk44FMSb5jPRId0e9swAo4GJmjbIh1psVJ34tlz98E88+nlEvpdbOWncU8ndUIrXMat6yleItmsbeRPYCB6GRp5kf9xWVO6fEcHY2NbTGxICnuMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745010842; c=relaxed/simple;
	bh=lP5sny4HdxYancmuktUpnf5Xq6h8+1+sQwqmPR+1WZM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WAIllONyQVdIoyNPdFDjxwXW27mb0ceCTvVJtGhULTtNC6VG7OlCX7OawJOUc8duSX8zN/nZEb67M5IKNXD9dePsNvonMI9wlZVgNV2uIRgdga9kgVUBWLS3VSPu/GRnZ7UzDoWToAfaHadCZE/kKLyhZCj3B1J3l9dH0qVp18E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMTh7DSw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMTh7DSw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745010840; x=1776546840;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lP5sny4HdxYancmuktUpnf5Xq6h8+1+sQwqmPR+1WZM=;
  b=EMTh7DSwTcgGhahmrxgQqoU26sUwxaFkxCRwPyJ3VGUBxupDbUqCjwBt
   LVwl0Pvr/7QjNlTfMJAXSECDH9ZhCw+RsktDlsIIwW7QKKlf4kX0FnW9y
   IVq2phcmOvAOt7i2cQiREBM/im1juRDgbBAP9tXIPtupSbObhK+RGyLB2
   AAejd0b3+0I/aXP45f5RZPsKeVjeJUxXMcKnBzgLMpoLITbfLqbe3I1cJ
   EwQvpSs9XJl8knHztgqcTJAxEypG38D5X6QwkGo0VYZeAndfvHfksoLpK
   EpfCGohqB0QG1z+RqOmMld3VCgUKdfCxm/RTCHf94/GToTj377QQgSMXg
   g==;
X-CSE-ConnectionGUID: hzdEGqMfR/yH+Vn5hTxFdg==
X-CSE-MsgGUID: S0FLy/0MQQSFqmtoel5Xhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46563823"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46563823"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:13:59 -0700
X-CSE-ConnectionGUID: W5z9laYeRHOg7M/mPeAefg==
X-CSE-MsgGUID: noRaL+nDTLOz+cQ8vcUQHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="136183206"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:13:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:13:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:13:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:13:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQuLdf01EOrl6fDv+GyILRugg7FwnbbXEx1F0wvw3izmUHCmPXII8y0JV/4835/VPqr3FJ9Qepzht7ykFWr2jyCjVA6RbHwaKAPz0Ou4uQ89HbNmIgi8QzV0hyFwy6auZdgiLKd3O8e4VqBkbwuiRxmeNAarbBCI0sYO+1NirVEQHSFqUI/qdVpYBJvLvyIgZIwfjiDXeu26vbtOrs3qCAh8IabXtJrTdat+4I5sk3QpxAuOQ5+eE1J1//n5N7RbHK3TgQrYl/Sz2cuqtS7QDTUssR0QRf3UwZe9rJWI36XaLpQv7nv9lifxbKjXEmYH4bC0K9Ro95yXEtGFtYY7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKEuwzTP/jd3QwL8SfcgceWAks5sUESht5VlxF1FdHI=;
 b=j4iauzThN2qDzLYzXCxr/LxpdfkZ4NE30TGTL4PSQRF/a3QqfvwvmNPM085uIybX2rSAVOq2hMQqOTQYuZ7YCJblq9WZqEJ7AcdKwlYK9CWaXX5XoxsJ6UMIbD+saLfm/E+dLEHOgid8lPprtpLWW+djCg/tJLUq1CARAqLmpu9LHRWdFe+E4wS1m4WI3upJuXRX7lRUi/OL4srJQEu8vftz83zYb84lNRbCdAcId/gPvDCmouE6iIih2Y4gIy39IGlxImlKaGl3UkQEYI7cQ7wyZjO+w6IMuhrCU96jWPkXqvYFIQNmIV5WKUHxWb96hYLfcmFGqm6RGdoQN1CXjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Fri, 18 Apr
 2025 21:13:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:13:41 +0000
Message-ID: <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>
Date: Fri, 18 Apr 2025 14:13:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] x86/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:303:b4::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e0ea6c-c8ea-4f70-a248-08dd7ebde4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N013dEhKMDF6NjZOallCR1FVbzduN1FlekpWWm9CZTBBa1RqMW12czFzak41?=
 =?utf-8?B?U0JOQStkN3FMTkU0SVpDbXVucmlzWnZWNDU5SlJXNWxSOXVtczVaNDNtVU5M?=
 =?utf-8?B?ZUt6eFJ4ME1VclBXcGNtWjRxVlFTd0Q3VVBXNW5zVkxDTGV5ZmVjcTl2T2Zy?=
 =?utf-8?B?U25ENHJnckZ3dDZYWG9VakZ3ZkwzZnQ0VE5naCs0L3A4REN4VzhCaEwxOVdB?=
 =?utf-8?B?NGNPWHJtY3dILytadE5VRW02VkFScytrRnM3ZnpLVzRjS0VNbytQZG1LYzJ5?=
 =?utf-8?B?S3YzdFh5L1B2a3lQSW5XaWlzL3pEd2lnMU56T3U5MUhNSldQY3lTV0wvQjlD?=
 =?utf-8?B?UEI3cmZYZzhsdmJKUW1JWml3ajMybEsvRUlNNSttRGx3S3o1QTBoc0FIOVo0?=
 =?utf-8?B?cFB0U1cyaUpPeGJHRWJPYkMzZVdLZWhVVnFCRHRqbEN0UmVMaUZmTUNYQ0V6?=
 =?utf-8?B?Uk1Ja2E5aE1MRTVYbkp4MUdCL3RyOE90WjR3TmdyaUdYVUh5VFZuMWdyUTMy?=
 =?utf-8?B?SHQwNy91TzBwWTg5b3psaEpnbU5VeDNZbVpUNlJob0JhVnJGYVYwRlhzSUgx?=
 =?utf-8?B?V2wrZmtlY3l3NlI1LzdhU1pTZkhoYWtkTGxZcm9uM2ZJOUlpRUZvU29YUGxz?=
 =?utf-8?B?MkVoOVdvdC9WSFM4RnBiNFNhRDR5eHBVTDd3SmpTNlYvdUhiRGJSU0c3VlZi?=
 =?utf-8?B?TzFsdXo1NUZlWTJKMUNpSmljZFVlclBDWkFjdDR2U05Hbi9LcWIxdUlOQ2VJ?=
 =?utf-8?B?dHVrZ1pQUFlNRDVOcW1nV2JyWkNzT1oxWjdRSENCZ2pjeUxQb3ZGcnNaWGJw?=
 =?utf-8?B?bEtmdWdWMTZzY3ZCUTNFbE1QaG9CQ2NtQkhOVHJBWXYzdWk5a2ZwMkJyY3Rw?=
 =?utf-8?B?SCt2S3huK1lRbFVXNzB3N1A4UE9ncnArTXY2dXR3NUxsOWMweGhWb2lONG13?=
 =?utf-8?B?TlQxRm9WdFZRb1lGTVpyeVdwNTQyVFVQNVVjR0ZWLzQ3S3RPNHhGaVp0SHB5?=
 =?utf-8?B?VEdOOG94aGZxbDNJaHp5WWIrWkErMU5tK0JucmRuaGIwM1gyQTdBcVRFMWM3?=
 =?utf-8?B?U2hyMjVwb2c2ckU2dVg1d1VKRGo1dVBZUGw5NEJ1TXh4M2VZRHNoTCswbFRC?=
 =?utf-8?B?YlpNbHE2SDJHS2svRnJJcU53WEUrR1pDQ2NwRk9jbktoSnR3L3dIa3VvZmVO?=
 =?utf-8?B?RGFMTEN6VzQ1RTZJczQ1STErYmlGb3ZtM1NCUDB5YldXbW5PNURUZTV6b1RK?=
 =?utf-8?B?Um1TZjdwdTRSQWg0aDNudG91c3RkeTNHTWRndnViV0dWRytaSEJhWUUrOEJH?=
 =?utf-8?B?VXRxcDFqZjBkTHdUNlZVY3Y2OVhpT1RNUUEvZDl5MGVaNyttV0ovUkpyVlFh?=
 =?utf-8?B?YTdDSTJJekRLZHlWSUMrTE1nUDVSTm5kSGYraXJUekljV3NHdHNzdDEzUTdY?=
 =?utf-8?B?am9IZ0RPNExMSlRkMkRlSHUvNkNvMktLQmRSZlA2Sk1vMzQ5aXU5S2FRT1B4?=
 =?utf-8?B?NmVQWnN0OWRndUtrdXZnOEwwRzBHK0xaNkJMemFsV3ZlSDVDMnBzSjk3NkNY?=
 =?utf-8?B?UzlFVGMzUnR0TXQ0TlhHek1vODJwdGMvNzUvUjlRSlUvbjZQZ05EdTQ2b1JM?=
 =?utf-8?B?aHNTdjFIcjhDYlhHSmpFNFEvMncwUGxpM1pqVVZ6NTR3b0dXaTFraTVYTDdG?=
 =?utf-8?B?TTEyT1puTktTWFZHS0dJaVVOdmp6Q0ptK3d3KzFoY3lBdE85S0hYOG9kVmhF?=
 =?utf-8?B?cy9UMGNITnRISTA5dDl2M1ZMVmZEQ3Q4YU5sUVRYajdIZTVnZXJZVXpZaFlI?=
 =?utf-8?B?YzVHU1VCekQyZlVTcXlBWEE3cFBQQ2JsMFpWV0lRUUowWTBPdFpJcFJtWThJ?=
 =?utf-8?B?bkRJQWpJdUI2ajdKblBCTlF0WnJ4a0QwQ3JPTHpjQ3NDMWo3eW53dDZzb0t1?=
 =?utf-8?Q?FdR3aejQk1Esx8jQ1TYT76CfJkRcIROI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzRjcFBHL3FYMWRLSGRrV2tmVVIydnNsRUVYL2M2VTI3OS9rUGgxUHlvNlB1?=
 =?utf-8?B?U0xqMjB0Y1E2Wmd5RjhVc3NLZDZiMXpQM2lKVFAzZzZyY0hPZTBhOW5nWEtV?=
 =?utf-8?B?QTJPN1B1ZnpVYWtsNy9JYUlkTUFodXpiSzBsVk90MmRHcVBDNlhiZnlacTJ6?=
 =?utf-8?B?bnpKdE5UR25vejREUDEzV3BnWDZKWXc0cE1LN283V0toRUtleEVueEREazZR?=
 =?utf-8?B?Y2RVNFlkRU8ycjNQR0M2OFVmZWdxWFE0Y3AzN2l3YkVSYitjL1NEN1I3c1M1?=
 =?utf-8?B?SUZBcEM4eUJXY29JQTg0VHJSd2xmU1E4S28xNDc3ZkE5cGYyaldIdDk0Tm8y?=
 =?utf-8?B?bDdNVVEvMVJ0Qyt6dU9kaE5BVWZIWmdzNjNQTCt3cjZXaGF1aU1aSUFndFpz?=
 =?utf-8?B?cExRZTdZbzJkSHVLY0lmY2I4OHc0Rjh2Z0o1UW1MVHo3Vm4rbG1uczJYVjNS?=
 =?utf-8?B?Wnh6ZStTek5oNUc2T2NkUEJuQ0grK2x0WlVCd3VQQnJ6RllSTkt2NW9TTUhs?=
 =?utf-8?B?cE5iRERkR1lZd1hZMElvWjBaY2NKWU1SNzZJcmZhL0RkM3hpT3lXcTVnT21V?=
 =?utf-8?B?WGlKODYxa3FYZ0ZvZnh3bFdRRm56TEJjVnp5bHZNQVdQUDdBOXEvYWtaT2xv?=
 =?utf-8?B?cFZOWndrOEg5Ni9kMVZWbk1LY3dsZkN0TG04TDNKZGI0WXd1bmI0bGtiYjFh?=
 =?utf-8?B?d056NC8zcHVVcVJQUnNFZWc3OWJSeGI3ZDVMTTAwSmY0Z0N5OUFCQVFwck1Z?=
 =?utf-8?B?UDJEYlp6UVdSOFkwSHgwOE9RYVltd3cyQTdYVnRVWnRkK0NHeVF2T0E5TXE0?=
 =?utf-8?B?TG95czVqMUtlcWNMcWNXL1NsYXN5VE5iSERONXYvSnZTZlVPb29qMUJnZVU3?=
 =?utf-8?B?dktTV1RGdnpQN3BnSU95R0NhWTBSYlIrQm1zSkk5SGNRSmY4N0lIcTNCNXlx?=
 =?utf-8?B?dlNuUjNrQWJ1Q2IzUEZUWUxjTGwxUzZRTXNaZVg2T3VMU2graytSOTVjMTM0?=
 =?utf-8?B?bENSRGRTL0dpRkswNjdNdnUyTkZrcFhWTU1STU5qcHkwbWh5TGZuaUJEWkdI?=
 =?utf-8?B?aWtsalo4Qlh5V2U5RG5reFh4ZE9zWisyaGJaeWdOZWZFdG1LR29GU0VXSEZG?=
 =?utf-8?B?MlFMWFd6ZFU3aE5WazdwOE8rUXBteWdpYjB0UTlTWUFCWnppU1dhZ01wbUtj?=
 =?utf-8?B?TFNVdTFSMzBwRHZHV01yTWcrOHZjSE1vaExXQXdiU3JQazdWbUVCSk80KzZL?=
 =?utf-8?B?S0ZvTG1uNXR1aFp1cXhGNGxFVnJMUWdGNFhaRFF0UGNnZjdYdGN5dE9BVm1o?=
 =?utf-8?B?aDkrQm94bVlrbUloUTcySmJsdXh0YUk1STdNQmRzWkJLQzZuOWZ4YWE0RlFt?=
 =?utf-8?B?cmhraURZbG9nSEEreGtEcUpvcG5sNnlDemljeXFDU2RNcmV5WEJtaDVXSHRB?=
 =?utf-8?B?TjZBSisyOGNHcVVJekpkR3cvZ1pKT3ZSTnVINVlKenA3eW9vbVRSTVBoNFhu?=
 =?utf-8?B?T3ltZWJESEMwcnp1TitvUGoxUDJidmVMWEtiemNLRmxpa293dTd5SGNtS2U4?=
 =?utf-8?B?OC8rRUQ2RzRta1hXN1JLMStWUkV6d3lOSlJrdXhwMnZBN3pKMmZQRjlITmRC?=
 =?utf-8?B?aHZOdUNHaVd1SE1rdm45WVNQUzdLNEh5VENpa0RKMjBVaWd3MHBmZkk4WG1N?=
 =?utf-8?B?RERSdUpsMDFxclF1amU3bjZ3NUI4V0cwZHFSTEpTekNGQkNLU0ZOYXBidU40?=
 =?utf-8?B?Q2JLQnhRVWFZSVFaVVpkem1yUFN4TE4rQzQ2UUZldzNGTzh0OTVlckUySnpw?=
 =?utf-8?B?SE81Ni9pZ2hOZFZXUENwOGFhR2xZZ0k5VUc3Yk5kZU1TZ2U0TXpIb0xvWExI?=
 =?utf-8?B?UGUxaHNaN3lzWm14dW1Da0c5eGhqbHNhY3JUOEVLZzRpakY0L2pvWU00QWJw?=
 =?utf-8?B?NzRSUXAyZ2t6d0V6NTJGR0lpUmx1dHJoVjVKSnRlNlp4NlZlQ29meDZaK2U5?=
 =?utf-8?B?NkNpOHIvUFRCQU55MVVHYzZ2bk1VMzdGYWNZbEdCZUtUbUV6L04xdVJxbmZX?=
 =?utf-8?B?VnRYS0Vpd2xwTFduUEE0WFlSYjFVQkFMNU5rODV3RTFHc2R4S2JRNnR0dEMz?=
 =?utf-8?B?RUdRWG1aeXZEaFU2Tkk0VVVSb25DTGRjYXdRcjFsQlNpUTZlTHh6Wkord2JU?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e0ea6c-c8ea-4f70-a248-08dd7ebde4e5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:13:41.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmI6wnlDFnNoSSsAc1lZDxcExivORh79zPtk/hvfuLpZmRD6BDiKQQCrmNYTstciFB0Olq+XH9Mr4Aot4cy7iTtYjkH0/AgzNSL2+SrFUNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Previous version here:
> https://lore.kernel.org/all/20250321231609.57418-1-tony.luck@intel.com/
> 
> This series is based on James Morse's "fs/resctrl/" snapshot.

Would be helpful to provide link to snapshot used to avoid any uncertainty
about what base to use.

> 
> Background
> 
> Telemetry features are being implemented in conjunction with the
> IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> counts for various events to a collector in a nearby OOMMSM device to be
> accumulated with counts for each <RMID, event> pair received from other
> CPUs. Cores send event counts when the RMID value changes, or after each
> 2ms elapsed time.
> 
> Each OOBMSM device may implement multiple event collectors with each
> servicing a subset of the logical CPUs on a package.  In the initial
> hardware implementation, there are two categories of events:
> 

(missing the two categories of events)

> The counters are arranged in groups in MMIO space of the OOBMSM device.
> E.g. for the energy counters the layout is:
> 
> Offset: Counter
> 0x00	core energy for RMID 0
> 0x08	core activity for RMID 0
> 0x10	core energy for RMID 1
> 0x18	core activity for RMID 1
> 
> 1) Energy - Two counters
> core_energy: This is an estimate of Joules consumed by each core. It is
> calculated based on the types of instructions executed, not from a power
> meter. This counter is useful to understand how much energy a workload
> is consuming.
> 
> activity: This measures "accumulated dynamic capacitance". Users who
> want to optimize energy consumption for a workload may use this rather
> than core_energy because it provides consistent results independent of
> any frequency or voltage changes that may occur during the runtime of
> the application (e.g. entry/exit from turbo mode).
> 
> 2) Performance - Seven counters
> These are similar events to those available via the Linux "perf" tool,
> but collected in a way with mush lower overhead (no need to collect data

"mush" -> "much"

> on every context switch).
> 
> stalls_llc_hit - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which hit in the LLC
> 
> c1_res - Counts the total C1 residency across all cores. The underlying
> counter increments on 100MHz clock ticks
> 
> unhalted_core_cycles - Counts the total number of unhalted core clock
> cycles
> 
> stalls_llc_miss - Counts the total number of unhalted core clock cycles
> when the core is stalled due to a demand load miss which missed all the
> local caches
> 
> c6_res - Counts the total C6 residency. The underlying counter increments
> on crystal clock (25MHz) ticks
> 
> unhalted_ref_cycles - Counts the total number of unhalted reference clock
> (TSC) cycles
> 
> uops_retired - Counts the total number of uops retired
> 
> Enumeration
> 
> The only CPUID based enumeration for this feature is the legacy
> CPUID(eax=7,ecx=0).ebx{12} that indicates the presence of the
> IA32_PQR_ASSOC MSR and the RMID field within it.
> 
> The OOBMSM driver discovers which features are present via
> PCIe VSEC capabilities. Each feature is tagged with a unique
> identifier. These identifiers indicate which XML description file from
> https://github.com/intel/Intel-PMT describes which event counters are
> available and their layout within the MMIO BAR space of the OOBMSM device.
> 
> Resctrl User Interface
> 
> Because there may be multiple OOBMSM collection agents per processor
> package, resctrl accumulates event counts from all agents on a package
> and presents a single value to users. This will provide a consistent
> user interface on future platforms that vary the number of collectors,
> or the mappings from logical CPUs to collectors.
> 
> Users will see the legacy monitoring files in the "L3" directories
> and the telemetry files in "PKG" directories (with each file

Now PERF_PKG?

> providing the aggregated value from all OOBMSM collectors on that
> package).
> 
> $ tree /sys/fs/resctrl/mon_data/
> /sys/fs/resctrl/mon_data/
> ├── mon_L3_00
> │   ├── llc_occupancy
> │   ├── mbm_local_bytes
> │   └── mbm_total_bytes
> ├── mon_L3_01
> │   ├── llc_occupancy
> │   ├── mbm_local_bytes
> │   └── mbm_total_bytes
> ├── mon_PKG_00
> │   ├── activity
> │   ├── c1_res
> │   ├── c6_res
> │   ├── core_energy
> │   ├── stalls_llc_hit
> │   ├── stalls_llc_miss
> │   ├── unhalted_core_cycles
> │   ├── unhalted_ref_cycles
> │   └── uops_retired
> └── mon_PKG_01
>     ├── activity
>     ├── c1_res
>     ├── c6_res
>     ├── core_energy
>     ├── stalls_llc_hit
>     ├── stalls_llc_miss
>     ├── unhalted_core_cycles
>     ├── unhalted_ref_cycles
>     └── uops_retired
> 
> Resctrl Implementation
> 
> The OOBMSM driver exposes a function "intel_pmt_get_regions_by_feature()"

(nit: no need to use "a function" if using ())

> that returns an array of structures describing the per-RMID groups it
> found from the VSEC enumeration. Linux looks at the unique identifiers
> for each group and enables resctrl for all groups with known unique
> identifiers.
> 
> The memory map for the counters for each <RMID, event> pair is described
> by the XML file. This is too unwieldy to use in the Linux kernel, so a
> simplified representation is built into the resctrl code. Note that the
> counters are in MMIO space instead of accessed using the IA32_QM_EVTSEL
> and IA32_QM_CTR MSRs. This means there is no need for cross-processor
> calls to read counters from a CPU in a specific domain. The counters
> can be read from any CPU.
> 
> High level description of code changes:
> 
> 1) New scope RESCTRL_PACKAGE
> 2) New struct rdt_resource RDT_RESOURCE_INTEL_PMT
> 3) Refactor monitor code paths to split existing L3 paths from new ones. In some cases this ends up with:
>         switch (r->rid) {
>         case RDT_RESOURCE_L3:
>                 helper for L3
>                 break;
>         case RDT_RESOURCE_INTEL_PMT:
>                 helper for PKG
>                 break;
>         }
> 4) New source code file "intel_pmt.c" for the code to enumerate, configure, and report event counts.

Needs an update to match new version of this work.

> 
> With only one platform providing this feature, it's tricky to tell
> exactly where it is going to go. I've made the event definitions
> platform specific (based on the unique ID from the VSEC enumeration). It
> seems possible/likely that the list of events may change from generation
> to generation.
> 
> I've picked names for events based on the descriptions in the XML file.

One aspect that is only hinted to in the final documentation patch is
how users are expected to use this feature. As I understand the number of
monitor groups supported by resctrl is still guided by the number of RMIDs
supported by L3 monitoring. This work hints that the telemetry feature may
not match that number of RMIDs and a monitor group may thus exist but
when a user attempts to ready any of these perf files it will return
"unavailable".

The series attempts to address it by placing the number of RMIDs available
for this feature in a "num_rmids" file, but since the RMID assigned to a monitor
group is not exposed to user space (unless debugging enabled) the user does
not know if a monitor group will support this feature or not. This seems awkward
to me. Why not limit the number of monitor groups that can be created to the
minimum number of RMIDs across these resources like what is done for CLOSid?

Reinette


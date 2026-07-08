Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCA282F29
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551095; cv=fail; b=BLB0xZAPdD942CeS6/z8B+o90cNa0Uv8PY/gcYI+7iQ1An/wQT1mSAozByVlaO4h3mUMWDSpiGXn5viMQ3Q9RZMRlhPNavwBTAW8FqoxEFpzS4RobkW0E3nu33vaz6ffCKRfBsM3cZrwDQI0j5Chx3UV/b4hsJJ2LNGCq6Xb50I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551095; c=relaxed/simple;
	bh=YaREH0ZvFi2Mn3sxd3qALW7a4/Og4j5c1u2FjLwS+Vo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dkAc7GtkZPxDXpEZt+eurs+G5L4/AcHc4n0aFSmHqgj/l4YNjdFbc3p7X+xXm2znIKhyd6C0ux1VBt/A6FynmdMTriZDhAIQSHhmQVu1mKI5SdOf+wyoaCRoUz5Xel6lmybBujqcHfsG4jfQsf/meTmvy6542iYX2uIdv7UnuXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7IgEHDQ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7IgEHDQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783551094; x=1815087094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YaREH0ZvFi2Mn3sxd3qALW7a4/Og4j5c1u2FjLwS+Vo=;
  b=l7IgEHDQHAX5fNe//vNpT26A4Qi0faPVuP1cdKoRXidkM5fefxNrFYFi
   nwoYR1dU9VH6h8M4hmuaUAV4T7xVLaoTPajqiLRPtxcDTpwttF2ZuHx0U
   hwGQ6bcVaXnj1T4wtTZ/7N380pf/2BR3C4dksZeOHW79NIcC7mNPjBO/G
   LHFdUpIvBk9OJHrCX3kAJDt80ARHqdi0L+xpLBqdjinyp0M9yGdDTEUDw
   tkD57ve0kQ9xk4uc2IPlbFE3VMoNCcsBDmXqy4QrOKgvDHLJ+jqPcFI+h
   tPnOjios6kmy49m52+oCRX50ibSDhgDfeKZvn+7zNahm43pwBhABgKRAA
   g==;
X-CSE-ConnectionGUID: 602SKEgtTSij8I6eiPgfQQ==
X-CSE-MsgGUID: vQhMKIE8Rj2zuYD7fVdcag==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84007771"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84007771"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:51:34 -0700
X-CSE-ConnectionGUID: UD8k6qKISLeC8nRcyhZE6A==
X-CSE-MsgGUID: 2ufxeW4QTzy5b67M4/XnaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="255063845"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:51:33 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:51:32 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:51:32 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.70) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:51:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBWFROGECfjoaNxZsQtrTWfyOtogX8FXsqx6BrpmrObbu3118YFqH6BATGzadBdlrVKds94Aypl3Ek3tJR4o6oJqCB4KWoc8Ly53IIyBwPzYIS07lG0kryoh6bHh05nvi9pw3XAFqp5Mm/GcJmdyIIE9iUKc3P+S9V0TSuhM42+B2rfFziPlCSYa4+9AgyDsjQJ5EKKGAx2RhN+yqEz8K2gqH8aJQ0CrEvmG7nbiUF6fccmv8zEA2xI82+E4j4EMmm2fv+7/UbuUZ8FbYVoGUxzDYrAq/CXdXqcNtK54eolfyZYmlkZ1spt3vBV/HpD4yRSYNaiDdrAo9w5mbaJp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uy7UTDC+RI0MmN+Ek2NArfO7CdRHIc1d8AJ2qbstuoE=;
 b=oKcRslwi9dhVP4GTpz3dU3897z/nkbXDzskZGUbGp6JOUnbUKfOg/cd9VKXlyBU6BRuwa1YW4uNx3Nr8O4n1sXtBBO49qBXPHs2EGxIQLmJjEexQO3PdTE/ycDEzT3zI1J+PFUgYjBWRWR4z+sPhICvvBj8orzLxrmhi7nSLTADWlOJphDSQT0VbLQPAnxSrdz1XWnewTOgNE5McXdipJxSrIv/OmhM7IVfwD+CFnrDc2KfaLBGNJPkDUkeniJKN1I+aH5G/XuDROALjE8/twSBsT0VRw9s6JhtY0nFJe+E8ity3u2IBIK5V7cHvWJgySvsQ7DbUG3EhQtzrq3AUAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM3PPF99D0888FA.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 22:51:24 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:51:24 +0000
Message-ID: <b128216b-cc06-4e6e-b6b4-498a6e135d16@intel.com>
Date: Wed, 8 Jul 2026 15:51:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/12] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701213553.15222-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0240.namprd04.prod.outlook.com
 (2603:10b6:303:87::35) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM3PPF99D0888FA:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ede1be1-14e7-40a8-ee2e-08dedd436fcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|921020;
X-Microsoft-Antispam-Message-Info: zqJt8TrUzWWRlIvk22U5j3GCBVe6tI+FNY8pz1ZyJQOZHWsuwaQKKTXiqeuQ47fzNLEP+D8Mq3/1PPrdOBMln2Qfd14TkCbAdIuakcCuXUwBtrGKebQ+tfMv/ZUWXKQywPw6KLWgxEqccFU0hTWoaIaLnUmDDkuid4sYTtfVOa1RH3wBxkNOUvNQ8JeC8i8fHl4TIa8q0/enD/6xD6dEfQNq+qRGFDw1sndK31JyJbocinBqeK9szZSv2qdjeIF5bpnHNvBgE0C1+0D1S3q3B/CY2LU+RZrr4KQmMeSdfxMNxPYv7z4Kmse8yOoIFK5rGGWrhOF54WxSsYjosz9WDiwXLwabm95a6ERuhFW2ttqDiMrzxWlKOKxsC5KgPpFbPhNNvOuG7oCfocO6BgveSFwpW945JcuAN/LE3XtdXuMcEBdGla2tWOLmcKVAj5gLMsFIxeTzUgMB5Y9gKC5hxDRq6kTClVa3jPftafTJ2TlGKtPc+mfyWMFgHRCYQYYv0I9/bdsDzuf41pGnmZ6hvJoDS9rrtxMzLy92GW5a12Bx2nlZHP9yLafXbjgsqmjmA6q0/VsxQcphHfIXk1SwcFzJ8kGMaOS/GTOmv9GfcJW+EPvmw/RnklUHbJrsCdHHVFqnKBvGDwNzdBy63FX8fkbe4UwOdfitPrrYZa97lxXaOwyKMmBmWTa5BRPDfUNmhJJOaWTDPvkRnZCk66zSQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW1VZWxnL2hlS0lVNTZQSkZpaFpVSFlFT0p6ZWh0aHBxQldDakI0K1NYZkY4?=
 =?utf-8?B?YisyamFNRXdzYlJSSDgrVXFyNG9QUkJmQlNOeXYrVUF0VXkrbXBFWTQ3dWVX?=
 =?utf-8?B?bGVvMG01ZnJoeDArLzhwOXE5cW5CUEQ1dXo1SHdBc1ZSOGxLU3JLZVZDWkcw?=
 =?utf-8?B?YkFHRWtHWEgreTNibWYxa3d6OGJjZEw0OTlpdGkwazVTUThhT2p4M0dVSUFm?=
 =?utf-8?B?TEg2SS9EN2pHZ2d2aUxVQmNtdGkyS1kzSHBOb256eG9SK09Sa2hHVi9uWitR?=
 =?utf-8?B?VXkzVGxCaWVKUVE4bloza2NBR2dHWkNCWTJYZytWTWV6eWI4U21COWRFM3NJ?=
 =?utf-8?B?QUFXeitIbDh0VW1RVURraFI4eEYrK2pKSVI4Y3BkRWEvd3VqM0tEYVoybDcx?=
 =?utf-8?B?cm9Ec1hWUXZYdXgrUEJHaHBlOUE2OGU4alhMcTljdllWYmZ6ckI1NzY1dnU5?=
 =?utf-8?B?dG05K2hOUjJtSnhnYk5wOHBwYm9ZbllQUHl3NXF3cFRHNDc1ZklhVnVVcHJG?=
 =?utf-8?B?VXpzZlZTR0xaZ3Ayb1IxUUE5VTNkalhCK0ZQTHZaOFM4NVFpRi9ReUlyc0Na?=
 =?utf-8?B?dStzbEw1dFNLd2MxamREbTZPNWtXNlhmZjJHUHN6c2tXSGRadUtDM0FaLzh5?=
 =?utf-8?B?VFRwMk4rUGViK2ZJTk8wdVBkYzdYc3VMM0hsU0wrK0YybXUvV09FdmxOKzkr?=
 =?utf-8?B?NjlIRENDblRqZ05LdlB6K3VqVkE3UXF3aHc3aGpTdW9DZmI1L3VQQW4vQ0R5?=
 =?utf-8?B?UWNEMlJaUVFSVENWVGFGWmswcFhzd3FKaHhaMVFUZzJKVE9iMFJTVEtFQ3pp?=
 =?utf-8?B?RDFPaUQwM1hDNVN0d05sc2tBRlM4KzN5UzE2NkErZTE2Z2g1WmRsWGJmaDNx?=
 =?utf-8?B?MWQ1VVVWNVFDWCtaREUwQjBhTmtnT2tvdGp3MHRYd09Pc29UazVQOG10c1o4?=
 =?utf-8?B?TFhoRDVPYTFtaWJLaUhuL1c1dFhYTWlSSi9zU1VQT2JUSWdoL3M4dzZtalhq?=
 =?utf-8?B?L0VxZnB6NzVoNUxsNjVha3BDYU5SWHdRVTd0Zk82VVZMcVVNVGRMdWpwQWhM?=
 =?utf-8?B?VU1vYjlzYlZBY3I5bHQvTFA4QWtkbkpuOWFIWnFRcXhXekRmcEFoaWVZSExL?=
 =?utf-8?B?bE1yVTBNNjdNcXlMbUUrc2tSTyt1K0xkQWxOSTRVYWZPc0FXUE1Yb0w2RTNW?=
 =?utf-8?B?R0dSUlZOcmtPRTJXeVk0R24zU3JQRkYxWkV4L1UrbHdFQUthUWJnamJoU1lt?=
 =?utf-8?B?OUowRm9mME5reGI4SkI2TWQ2bnUydFg0TmdtQXVMd2EvbXBudFBFYVlLbnY0?=
 =?utf-8?B?VUVRaXdrZUtpTW9DelV4RlhTc1pML3Ywajlsb1R6cnBmaWNib1RpMnY3WjdS?=
 =?utf-8?B?QUFCdzZUWFlYUklvSk5OM3MraWlGTFpjZGtCU0FQeUtPeVBKaEJpV1JSbld3?=
 =?utf-8?B?a3pnSGxYbmczenRzdTF3R2Q4VVRTTDVSZDQ5c0kydEFLQVNMYk5IbUpKZ05z?=
 =?utf-8?B?NjdFaDdVajlHanRCQTFDalIxdkFRaDRwUnhrQlc5cDJSbFlHTTZsTkh3L2g3?=
 =?utf-8?B?ZjJucFZpbEROZC8yNEkrM3IrWGNFMEcwaWtRZWlJYUFGd1BjdUszeU9ZYXFX?=
 =?utf-8?B?ZlVpOXFud1N5ekZUS2JYVTJQL2x3VHNDYVovSUxwWUluRGZtSC82MlkxUkQy?=
 =?utf-8?B?TnVNSXQ0MCtZaUZmakhxRDdlRW1ETXJicU5MdWEzakJ4NnY3bXVQS0llT2Vu?=
 =?utf-8?B?QzV2bldGamZnaXVOOGF5dTlmSnNoN3VjemhjY0wzSTQ0M253cVNCeDJTa0RO?=
 =?utf-8?B?Nzl2L0MyV3E5eG5KTE5UdHZyR29WRVFQalpldHN0cUJHL3Z3SVlycXV2Y2Fj?=
 =?utf-8?B?Ni9nWkovcVZ2ZVZOc010Y0c4OUZvZmFyc3czb05ORUhxdEloQzNBTDVSYXh2?=
 =?utf-8?B?U081aFNBc1doMXgvUDNFdUd0VzlEaER3MnNkZjIrYUp0NVFJcjdXNE5LOWF1?=
 =?utf-8?B?b1JiUXBlUmtnQjdkZ2VyYktnejRWUmR0RFpWSHFBdU1SODBxd1VXL2w2b3JU?=
 =?utf-8?B?Qy9CN1ZHMVMzRFp1UmpTYzkwc0dxcC9DZ1dWaXl5OHdMaS9wRHdhbkkvR0NB?=
 =?utf-8?B?OUFDbHFkakdteURwVTlDU3VWNVZnbHVSQUVoTkplUVhUa1doWVp6blJraGFN?=
 =?utf-8?B?aVZtWWwyeWNzYWVqV010bEFVbDlVRW4zS1hNdE9WWndIbjJlR3JJWWZxdFVt?=
 =?utf-8?B?ZXhwQW85Zkp0OHlIZlB0YnBiYmc0YlEyakRySjVMYkNWTVczNGIvbXFXMEtM?=
 =?utf-8?B?VENNeWtCeHpnQXVDWXNId1BYU0paakIvVDJpeitEWGNZemNrNzQyUWdYbEZG?=
 =?utf-8?Q?JI8VFNeDCOAmfTZs=3D?=
X-Exchange-RoutingPolicyChecked: f9/0R+oTLk8enmO1M7a4NlmjuQNAzgK21bhF9AybjIARLEPkD1DUAO+M5W8ZQdcBJHWjblnklbrRShilEnTOYkhTfHCkVnwuBfZUMlk8vHRuFFdGuVEQfxFXpaShy31w/WHoPWoJHkZSJ6OsCb6k16UqYW2OcaSu1S33/HOBcLvnrDB9YeE4k0DrCKv4ZYPhCYmeLuIH1V4rdUsFTcKQX7yYdTdgtafiHJJOENteBaXnYVOlSE6TrzH5u+YbeHjrsm2aXgv/WOXmfcrqtaG8cdMXMhdg2g5bV2unOPrsXbaJH3N5iO+zJ1mb5JgpV/TY7Djyxr2psO1FqkkflSubgg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ede1be1-14e7-40a8-ee2e-08dedd436fcb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:51:24.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Dc9x6L78Q6OF4TJH9vovLciWf5zAA5JRqdc8VpgtNpOw9YQwIvNCik5ueAq9RTS/Po2MxwPMM6X5KcErl6fG4C2F40on2zdtX6uA1fWg94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF99D0888FA
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
> export, register/unregister functions so the PMT module can supply/clear
> enumeration callback functions when loaded/unloaded.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index a9f481b7a8ed..48ad55bcda66 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -4,6 +4,8 @@
>  
>  #ifdef CONFIG_X86_CPU_RESCTRL
>  
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>
>  #include <linux/jump_label.h>
>  #include <linux/percpu.h>
>  #include <linux/resctrl_types.h>
> @@ -189,11 +191,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
>  
>  void resctrl_cpu_detect(struct cpuinfo_x86 *c);
>  
> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> +void intel_aet_register_enumeration(struct module *module,
> +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> +				    void (*put)(struct pmt_feature_group *p));
> +void intel_aet_unregister_enumeration(void);
>  #else
> +static inline void intel_aet_register_enumeration(struct module *module,
> +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> +						  void (*put)(struct pmt_feature_group *p)) { }
> +static inline void intel_aet_unregister_enumeration(void) { }
> +#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
> +
> +#else
> +
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>

Are we sure we want to include these in arch/x86/kernel/process_32.c and
arch/x86/kernel/process_64.c when resctrl is not built in?

>  
>  static inline void resctrl_arch_sched_in(struct task_struct *tsk) {}
>  static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
>  
> +static inline void intel_aet_register_enumeration(struct module *module,
> +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> +						  void (*put)(struct pmt_feature_group *p)) { }
> +static inline void intel_aet_unregister_enumeration(void) { }
> +
>  #endif /* CONFIG_X86_CPU_RESCTRL */
>  
>  #endif /* _ASM_X86_RESCTRL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index cd8257c58f84..c26bd813e057 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -12,17 +12,21 @@
>  #define pr_fmt(fmt)   "resctrl: " fmt
>  
>  #include <linux/bits.h>
> +#include <linux/cleanup.h>
>  #include <linux/compiler_types.h>
>  #include <linux/container_of.h>
>  #include <linux/cpumask.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
> +#include <linux/export.h>
>  #include <linux/gfp_types.h>
>  #include <linux/init.h>
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> @@ -291,6 +295,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>  	return FEATURE_INVALID;
>  }
>  
> +static struct module *pmt_module;
> +static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
> +static void (*put_feature)(struct pmt_feature_group *p);
> +
>  /*
>   * Request a copy of struct pmt_feature_group for each event group. If there is
>   * one, the returned structure has an array of telemetry_region structures,
> @@ -325,6 +333,32 @@ bool intel_aet_get_events(void)
>  	return ret;
>  }
>  
> +/*
> + * Defend against races between pmt_telemetry register/unregister and
> + * resctrl file system mount/unmount.
> + */

Please help developers understand what this mutex protects. I am not able to deduce
from above when this mutex needs to be taken.

> +static DEFINE_MUTEX(aet_register_lock);
> +
> +void intel_aet_register_enumeration(struct module *module,
> +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> +				    void (*put)(struct pmt_feature_group *p))
> +{
> +	guard(mutex)(&aet_register_lock);
> +	get_feature = get;
> +	put_feature = put;
> +	pmt_module = module;
> +}
> +EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
> +
> +void intel_aet_unregister_enumeration(void)
> +{
> +	guard(mutex)(&aet_register_lock);
> +	pmt_module = NULL;
> +	get_feature = NULL;
> +	put_feature = NULL;
> +}
> +EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
> +
>  void __exit intel_aet_exit(void)
>  {
>  	struct event_group **peg;

Reinette

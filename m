Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354FA59
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 18:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745346017; cv=fail; b=TFS0VNb8iCEw/fakGQ86wTGdo4OZJpvhhQdJx3cMo3Ma2bdNp23y4C3jvU8hvLvL2qwUuI/Zbwoo34u7GrsjQE3jk6n3u9nEHjikW6R7xMc7GgEKxMGK2JxpWiRPd1Y+rpZtq6pUGvJJPVmdnWxCaoYU+mHMAn6Bl2ogOWO0crI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745346017; c=relaxed/simple;
	bh=ktnqDeTbJKD9+UQVxGcgPHmHm/rRYJvwr3sT9xCVLMY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qS3XefU+wU0XqX4peL/zOL9PI3j/ro5m0GWnlF4Fkjfwdn9hjQ4Q6KUc5rgtpgH3fAgqQt2v4Lu3jQCgUaiOXPh6oRPzXqhsD55SaYNo8k2nyLxq4zdsVFcMeJJBKhBbevx45Ljaj8sGPgL3SuUiLdC2qt8bJII82r34DGWwAiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9GPphMe; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9GPphMe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745346016; x=1776882016;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ktnqDeTbJKD9+UQVxGcgPHmHm/rRYJvwr3sT9xCVLMY=;
  b=e9GPphMeXSFUbNWL4XT6cZGoKWgTmH2IGukD964ZeIsSi34b6fNfujTz
   6gW2uOCKfcBfgCv9YQLdCUqbQmKTQedZ73gVOWkDhCnQmY69bMuWfr39l
   hHItHIZMUMj6hilKurZuR+VQT1iGIrg7RAKizGn59uZerDEmCfyPpTjDq
   Mr5JHhRaBcgdyfdwHC6uz6mcfjIMJCYvC9ghFsLDLJ1fa6qHb4avKSg9U
   TMYRWdcWiTnCCQcafv/JrLAKLKVB1A35immBtkDEUwhRCD2dSB4ak7qjy
   78WEqGDfsCWBnGqGBwC+qWHFIYRESgcwuoBo0w1iU8Bk0n68k7BDBh9yr
   g==;
X-CSE-ConnectionGUID: mRJ8lG33QXCCj7vGF47lHQ==
X-CSE-MsgGUID: 4Y5GZbvTSlyazhsfv3EwKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46801190"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="46801190"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:20:15 -0700
X-CSE-ConnectionGUID: 7b1DhfVBTlqTpELtxsGjtQ==
X-CSE-MsgGUID: eKJD6W5LQzuNYswV+Tkm1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="155297146"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:20:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 11:20:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 11:20:14 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 11:20:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlLNMHu1d4Fjq2U5f8I3zUCyQ7ILsdk2kEWwhrKNesyTZjb74UqRDQPhkQzQmU51D4bP+8+uA253XsDWTRWz7bsQtbgO91IU6vaTI98NreXgC9dbgH0WrMQ8IxPDo9mS+li6CBry5lbQq0n5l2Pf4kjiOb9DOLLOqYvWBB+++4Br3IfsGhS8JmNMoQdiG2uDIh4+9UB92iGgEJb8YKzTmmAF0ri8WpXpF8bYn+la7XDzg387u7Ie8GlA3YMZJ+IMIHE/yOan2kYwfZDrw+V9sQ7ZBImoMFcW7LmcsI4l9VUW17O3pRFDzMHc1NG7FHjeRaqToe63YKivQE6qOUYCSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfeAEdtlEAh6L4zm8asW3SlbQWsfDXtJTDthh9hYff4=;
 b=MnF8SXVPgk6+R7/juVdaDTS53uhinlo9qWJ2/cT0TgmddpKty/gEn5xpzZR4KlRtGnbbVMRXCb8JSIWKMhBP9kdu7d2tplRx3byZRInYG5Twi+Ev78jGmVrikXSrkld8ccRqf4Ef8PFjfgbUsrasjruQ59W5nzWPZ7FiHKXRAVinHBHjzy8sQvCze88R05S/cSh77uUwaKhEE/N9Dt2PEGq1d/I2f4IeZjuWKs+9zvFAMcBbkfRnFgr93c+K7jj6SB0IgVNBHRja02xn0C6GTB3IVyYUhRQ/M9leWx6lJELOHmtDtYfKQm9XA5V06M7ZmnAS6O8CcJaBm5dAqd1ZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 18:20:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Tue, 22 Apr 2025
 18:20:10 +0000
Message-ID: <79a0eea8-e08f-46c7-bfc2-135bcd90dd87@intel.com>
Date: Tue, 22 Apr 2025 11:20:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/26] fs/resctrl: Add support for additional monitor
 event display formats
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-12-tony.luck@intel.com>
 <4c8da281-fb6a-423a-bf8f-56c9ee45514f@intel.com>
 <aAadxhaapT_3-W-I@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aAadxhaapT_3-W-I@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0287.namprd04.prod.outlook.com
 (2603:10b6:303:89::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 3de73631-8492-40ee-3dd1-08dd81ca514f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1l6UVM0QkJ2NU1HWnJaSVJqbEdCdWlBSUh3bmp1c2dmakhwRGN6djNuamdX?=
 =?utf-8?B?NllnVW9JZDNFUkdYQ0JUb2xBaEVNZXlEMWpjWEpTR0FmVEttNFkweXkxN3Z2?=
 =?utf-8?B?cXpJNmlKM3hmNFBoUEpiRVV4YUZMdGtMQjVKd2RvaUI0NUE0SldLQ1RqOEV5?=
 =?utf-8?B?eEE5U2EydUdXcHYzSnR0RDFHc25hSkZrdGtsWTdnUmduQmZjcnJwbjg1MGIy?=
 =?utf-8?B?Qy9NYTZYVlFlUWpPSUY3U2FRYWdjZHBGd0J4L2xwNDNQUEJEbVF1ais5RjN1?=
 =?utf-8?B?Vi80b3M0ZW5HTHEwTTFWa1JZRjJCbGFCZ0hCVjAwcUsyZjFMVXI3b3lyd3V2?=
 =?utf-8?B?RUpLQ0NqRG9FOHE5cGdJeUV4ZnBBRDRNNCtud0lNeGNrR2Z1N2NUTHV6R3lS?=
 =?utf-8?B?ZnN2RE9BbXY1aXZ3M0RMeTNTZzYzR21qT0RZVm0wUjk2a2xJeGNHRmhWZXRP?=
 =?utf-8?B?bDI0TmRIbTk5ZE9JRWd3bnhnNTZGUEM3UjdJSkdYSDBBczZiZ293OUxEQ1h2?=
 =?utf-8?B?Rkg5bjhGNTdBT1RNVXZjdHNRUGQya0xRbGg3Z2ZQZVhmc0NSVnBxN1ZqN3h3?=
 =?utf-8?B?VVFucTQ5OXc3bTFhQTh3YkZUZUhRWlJIQllDVisvS3FBaDc3WlB4YXRCbUNn?=
 =?utf-8?B?amc4Y0FFRll3NjZ4ZlRIOWNNMmtNNzg2bG1SNElWTitXNkxGYS9iaGIxclFD?=
 =?utf-8?B?RDVBb2l0Mm1jRlIzRzZ6VWVmSFl4RzhkbnVDVjR0V0g1c2tzeGlUSVMxREN6?=
 =?utf-8?B?c2hZUnQrd0U1NGxDekFSeWw3VDIwa2p0NGd1a2RsMDM4Z0ZPbTlXQ3FxSmhD?=
 =?utf-8?B?Rnp1VFJkYzN5N1pRVkk0VXN0dW5MSTNYWU1JZ21rc29uNmwyT3FBZ25tbDBB?=
 =?utf-8?B?KzlYa3lSNkVDMkg3S3JhQWY3d3k5Zy95eWVJVG10ZEZiVHlaNU9KS2hhVlFW?=
 =?utf-8?B?SnlPWTQ4MEoxNDJUZ1Rwais4ZWdvdmlrL0FQSnNCTmdYcEJxTnRubU1VUy9x?=
 =?utf-8?B?TFk4aUdHUnhaWDFPd3hPYzRjWjNtTDh6SVR3dlNKZjhBMWFRUjhJcnFRQ25n?=
 =?utf-8?B?eDJpdnloR1NOck5mTHRnNUY0UW1BMmQ3RE5XeWt1MzkyYm0wLzI0aHZmd0RC?=
 =?utf-8?B?T1JpL2tXS0xWbWtTa0l6dlRCR2ZVRGRZaDh5SXZsN1YwbVpWNmcxd3gxTzR4?=
 =?utf-8?B?L3hCYURYSWg5cnhlMnlBM1J6aFpLT3U5RFZHUWJORUpxRmVWeFFSaXAwbTk1?=
 =?utf-8?B?bHJkQUVGL0RqZ1NQUWhaSEJGalV3UE1FRXRqTlp4SlI4S3g0TGhxRjdacGd1?=
 =?utf-8?B?WWovTk5XRHRyN0lCZ0VtL1FNMTBPbnordFhHUkl0anROV1BJRWF0VlR3SFdj?=
 =?utf-8?B?UjYvSU1xSlpkWENlQTVncUt0RW5BN2gzeko4NGVXalZLajQ1YjZOT1h1ZHFY?=
 =?utf-8?B?dlIrVU5CWEwrNFowcC96MkdIdlVrK1JmczFDNkxkZDNncEtGZm9SWlY3clRK?=
 =?utf-8?B?SXYySW1zakt4SXB6QlJ4RGxBS2M2alJ3bUZycWZCclZ4dWdjcGZ2SFl3Vyto?=
 =?utf-8?B?YXBIWGNJUTN0eTdoVGJYbjRvTGZZVW1lcjV0blVPSTVXNDB3MW1RaTlNUkVH?=
 =?utf-8?B?K0QyL1BTSG5UYTZYVlNQZys2VEd0dFBHcEkwM1B1TFN4SjAxbk1zNjJiZWlZ?=
 =?utf-8?B?SW9zNGFwcExKUU12RmlsV3JNVE41MWRlZzV6aHYvUVpySzk1Y0ZPaTV6elRF?=
 =?utf-8?B?bk94SEFkc0R5c0M2RVFwSEZ3VlpTY3ZITXJzSDhuRWZLZmZneGhSdHl2R09n?=
 =?utf-8?B?VXFRL2V2VGxNNlRya1BmS055cEIrYU9COXpqNjlTeUZiSnpkcTd1NGxpcDJX?=
 =?utf-8?B?TWp3dkMwZFBVK2xIbGJIeGNmUW9TeDQzbTVsb0ZGMVVyWHZheldQVnZJL1pK?=
 =?utf-8?Q?qs/sybpcSfk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE1yUkVFYUxDRGhOcjlKS2kvWlI5eVRLS0FrQ1dlRkU5bHhLUWUxVnRqQU9X?=
 =?utf-8?B?RFNCM1NCaU8xRkVqNG5CYlBEUWVFOHI2QkRHb3pCMWttUVlzZVpwOWlKOFAy?=
 =?utf-8?B?a3dNT1U0ZFBUeUNwcmtiTy85OExDdjcySWRZZjdSYVlsUnd4S0FqdkorREI1?=
 =?utf-8?B?Z1I5MzdscHR6SVJEV2RFWFcybEl1OTJ1R1RkcmtjSWNyU1VXSGZncnRXSEVJ?=
 =?utf-8?B?bzI2VUEzMDZ6bllxdDVrbklOL0tKVmp4VmRsN0UraHRuNzZDZEpzc2RIdWRl?=
 =?utf-8?B?OUZYYkcvQkJ0NFJlZ1h1TW5TL3lXbUtBU3BBQk1kd0prNGNuNWlWTnBzeE1D?=
 =?utf-8?B?Z3ljVTJOcnJHYjNWcHcyRW1LTVg1L1pMblo4ZDFvTERCa1VYeUVpZlhNT1kr?=
 =?utf-8?B?L0VDMm42S2RLRXNoNURpbTdaYk5PY0QyTVZXWTFUVk9jaDVlRlpEVnVyUzJ6?=
 =?utf-8?B?anhnYmFLQXNGRE1mc0tWMlREUjAyTStTaDI0bjFuQm1reTFSQWxZSDlRMjY4?=
 =?utf-8?B?aWNvaGtPSUZlVnE3dkkyWk9qdnljbXFvVzhDdnlQdi90Q0dtcjErQzhhUWxM?=
 =?utf-8?B?WkVWM0RpYzhDcjUrK2pzSkVFUDZ6QmwwTG9TVXFUTXltMU1HVk1YQklLb2F4?=
 =?utf-8?B?Qmdsa3FXWll3Z0JDR29tdjNPYUNVcDAzUzNkYWUyRUJXTnVmYitzV0hPNjNZ?=
 =?utf-8?B?dzRTenlIZXd6dkNCaWxJc1dnZndQMWR3bzQ0T3ZaODVBS2pORFlHTGttVkdC?=
 =?utf-8?B?TStMMFUvbUR6ZmRENHpjcWFpRkV4WXRNZE95cUp4VThNU3p4cDhFWjJQRTcv?=
 =?utf-8?B?QjQxRGVwK3NacGdsMVFWSCtoeWlhWCtyVzF5VzFySEgvZkRMcXRCeWxYTXp2?=
 =?utf-8?B?MUc3ZUZtMnc4eGpjSXpPU1QxUHBDaEp2Z0ZsVi9QSktNTE1nOENzQ1A0dXdu?=
 =?utf-8?B?aUNnWTk0eDB6MGE0eFlYem1pQW9MZFJDbUREeDFTalo3WFpxdE1nZUw2NEEw?=
 =?utf-8?B?Q3oxRFBsakxFWHBPNXVxVzB5bndoQWprelpGdmZYQTZsQzVpSjl1ZnJkQU5V?=
 =?utf-8?B?SUNkbTdYZHBPSGowdkNoWXBNdjZDemt3QS9LK1pDWENMV1ZFMjhhb1VHazd4?=
 =?utf-8?B?dXpzVU1BVXNVODIvbmRlS1FpY2hZcFlXVTB6Mk1UMGFkYkxOY3RUQjFseUw4?=
 =?utf-8?B?cjF1OEU2T1d2L09EeGlFWmFWTnZKR1VLUjBTYUpkbEtjaXhoWmVCOGJYdkho?=
 =?utf-8?B?OWZkSXlJQ3NpdUxmazRndHRyQkVORUVVMC9HVHYvbG44WmVER3R2aXVrREd4?=
 =?utf-8?B?bTQxM0ZZTisvL0NzZjQ4OFhnRjFUMjBIejFmV1AyZ3dSMDVDOWVSQ1VDMTNH?=
 =?utf-8?B?Y1ZFM1hDRDJoNXZUT3MvSHRRYnZWbDJQVFk0cm91SFBORlhhNFVjVVRJbHBa?=
 =?utf-8?B?SzVyQ3RmbDNJcW9VbldxeUdXVHh5NTVOc05wTTFhZ2pncjFxRzZtSnhNWkVC?=
 =?utf-8?B?Ly84RCsyblhTRkxIZjJHSDVKR2U0WmY4QS9XcmYvQWhYVVJ4TGVzOVFWbFFl?=
 =?utf-8?B?UERsSm1LQkJqTHcwSEp1VVZPWTV6RDdwRk5vNDB1YmxQNTRmNXRpMVFXRDZh?=
 =?utf-8?B?dEx2WU9Edk5uS1dVaG5YVWVXN1B3aG80YTlicVpyZm1VVWFIbFlONktxUWM2?=
 =?utf-8?B?N0JBaUxjYU13RHhWeXk2V1k2NGg5eGxnSUdGek93WmFtRFN4Yks4UWttdG93?=
 =?utf-8?B?OFZrZitRbnpNbnUrbUY5ZmRJWmM2a1JRVDYvSGdSaytHR3dTa3Z1VWhmajJ2?=
 =?utf-8?B?Y3VDd1ZwcHdJZElBSzdIVEtQNXhuNFUya0o0SlNSYTFieXRETkNSaWh6alhM?=
 =?utf-8?B?SVdlVWllby9vRnRKeDhYQlcrbGNQS3hLdmpCVmVmbXkxTjMwcDRodnhNWTBx?=
 =?utf-8?B?L3B4a1N2WGVuWGFwcThSd1dodXZreHpTT0REVCtSamIvSDBURnpUU0ZkekZ5?=
 =?utf-8?B?Q2dkZGo1UDdySlJEMEkzT2x4TVlpbmVrTnRhTGliQUdOUDRqa21iUFNlWld2?=
 =?utf-8?B?OVFxdnk3bE14TlBtNjI0WHVUTWJvRG11b0JJMi9ockpBVzU1bXJMVEk0d3Rr?=
 =?utf-8?B?eXpHdGdibkJUNC9zbVhiRDhmR2lzLzN4WGQxMVBUbHgwTnlldGRmZDArWk9q?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de73631-8492-40ee-3dd1-08dd81ca514f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 18:20:10.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JE4vHBj0cWVJNrFxpqkivS9hAGDUg9wXJLbgkjtYbI7S6plSy7SlwPvS9n0X7r5hmNhrcC56MRw8yDbRj2CMq4zHuW55ClFzSKbKQJg1mio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5820
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/25 12:34 PM, Luck, Tony wrote:
> On Fri, Apr 18, 2025 at 04:02:08PM -0700, Reinette Chatre wrote:
>>> +	case EVT_TYPE_U46_18:
>>> +		frac = val & FRAC_MASK;
>>> +		frac = frac * 1000000;
>>> +		frac += 1ul << (NUM_FRAC_BITS - 1);
>>
>> Could you please help me understand why above line is needed? Seems like
>> shift below will just undo it?
>>
>>> +		frac >>= NUM_FRAC_BITS;
>>> +		seq_printf(m, "%llu.%06llu\n", val >> NUM_FRAC_BITS, frac);
>>> +		break;
>>> +	}
> 
> The extra addtion is to round the value to nearest decimal supported
> value.
> 
> E.g. take the case where val == 1 This is a 1 in the 18th binary
> place, so the precise decimal representation is:
> 
> 	1 / 2^18 = 0.000003814697265625
> 
> rounding to six decimal places should give: 0.000004
> 
> If you run the above code without the small addition you get:
> 
> 	frac = val & FRAC_MASK; // frac == 1
> 	frac = frac * 1000000;	// frac == 1000000
> 	frac >>= NUM_FRAC_BITS;	// frac == 3
> 
> So the output with be the truncated, not rounded, 0.000003
> 
> The addition will have a "carry bit" in to the upper bits.
> That isn't lost when shifting right. The value added is
> as if there was a "1" in the 19th binary place.
> 
Thank you very much.

Reinette

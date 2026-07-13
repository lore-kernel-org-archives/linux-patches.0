Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D25357D13
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 20:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783975683; cv=fail; b=kVN9fCGaDRsCvtfc37jGBw/vmnOYnkZcN4QvJ814mspQoJr5W21YAztxomhSRq2/lVaOqTjT7csRpGEpd2dus+bk8dHKzEgp/uTTJs6w490EZK7vd7IuRZEh5OwPDuE0l+4/r8aeh2PjQ9wiolR8i6q07HolOdsal0atxIiNgOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783975683; c=relaxed/simple;
	bh=D9/DmpQq9tqWJDv2esa1eEzPWRC5/0dg0TbKMR3t7S0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AgYpbZp/gG70fnKQjriPaUZnPwQ+DB5stO85M9N63YOUj48V5q1gNHSzefvy9h/NAL3pvbEBSXaqjMYQrUztfQblxeyE07iAss/YoDyxCpMokcek8IRqeli7F4ADxsZXAkbOcOftoBFvzxr4p04CWpAnpKTsnJRVvKIX+fshFBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KI3LOfkF; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KI3LOfkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783975682; x=1815511682;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D9/DmpQq9tqWJDv2esa1eEzPWRC5/0dg0TbKMR3t7S0=;
  b=KI3LOfkF8QoC4jghHWJzM2AMWIjdxgRmth3nXu0PKgZn/QE6SDlCqXhK
   YePptuDlKpwZF7X6wc2sePGYzrQYC2xIVEN29ch3St5nMcFOzZxKE6Z0Q
   /wkDTU584tV1u8mkg1FLey//OOYGYI4qR4U2DlsGxybW1C8BVNGsP13jW
   j13C72+/CAiEbDz8aGZisPiBQHtoYOYCd7heP3j9CI4swcqrFmRnXRcAF
   tU0Ex+1Vzg16TM5zX+Eeq/43Qv7R5OzesBu8O7BC58SgBxzd+NqyszbTD
   jVqeE3skkDFR0Dk2h6aNtjM8y3kmMxTeLRRovwo4AnFenxvuJE5g2wkft
   g==;
X-CSE-ConnectionGUID: pIFG1PiKQtqgRY52tISF/Q==
X-CSE-MsgGUID: 1pONvzPSSDaRl8aOhlgMFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88416570"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88416570"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 13:48:01 -0700
X-CSE-ConnectionGUID: aYBrp8B4SGiO9/Hb9P57Yw==
X-CSE-MsgGUID: bDNbIL7qTumtP6eRNYw1Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="293843179"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 13:48:01 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 13:48:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 13:48:00 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.3) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 13:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHbxIeXs4SljzKoiI690rNbI0fo+OyJBhdLPRSP7rzGlz+1wRYQqlfxLltOQ9GW5D09mKUrxlpDPaaoiifLQnhM2NKaYzJvPh5Lgzu5VpCVJz+sAt2S600nHOkff4fqEbHGaLSMmaCNXPrebit23ESoRdGqWCkPWXLbFTPKvhiGXkIfpwJABa1mPK9Oj/ezRwO3nEPV7HK5OKV9zex3qucaQ/2vcG1FUmehZldxkNPDWnuE0WiAfhvI49tKsXzzZH/zhaiW20LVfGG3MRuChid3q1pYiZN5/KEVgGff00Klk3oVAJlZvuQEA7dPcbEPonWoLRjr/2L3tArU0l1G1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajn3D+glgJhzNQ0I00tm/nJ+MQl+z+Ahus9Bx/zVJVs=;
 b=WthA9fTu4u0WtMladtF/IbkORqpEtayPSNd1pFkSzWKxJ/kzMAPQxJCdaqXmBGRTUNorIphkv7YLW+m+9JKhuC7SZIiL39lkzazaYlxC4g7l7kZILL1Fd3OnIt5bMeOyZYG3j/asEvpjm7XZJ9i1pgrCfUKYQ5MLxzJh72a86K4NQsBs6svwlq5+aFr7oS/R3sWBCiigX270Ikdna5Q3RBq88uBT83lFQ1FJQRg990GKHlwIRGomY+LeqoTLmF5G8RaxER7Vi/yKUFkyGA64fa0V9buM6lKH3mmWhdZC5ZAiRLT9dC04dER+G+euVUhweNamlGXHYfN1yjjAbjh4kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB5328.namprd11.prod.outlook.com (2603:10b6:5:393::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 20:47:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Mon, 13 Jul 2026
 20:47:57 +0000
Message-ID: <98a46b67-5259-418f-8a78-e87ca86847b5@intel.com>
Date: Mon, 13 Jul 2026 13:47:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1783963505.git.reinette.chatre@intel.com>
 <20260713182421.GAalUtVdzT-QmG-nhJ@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260713182421.GAalUtVdzT-QmG-nhJ@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB5328:EE_
X-MS-Office365-Filtering-Correlation-Id: 8516175e-eefc-4006-5991-08dee120051a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: heMlrvzVdW9BDNtxWe3NpAXmWDwPUYQWWCfPTu6d1xJZ1s68/s9XzGWFXqUDlyXg/SmCKs3EPaOHmnmG+1tRGtIqDdFNS5z79f9v85n2DcSq3ryiMxcgSybWghV2TIXmJ10dqXLysBRo1RVQ3QHQ5ocMuSzvuU5l4207NBrUqY3rPEf7umvfsuE0BdSBGkgVu0aqi3gKvORujZ3UgniweVSNe/n1BBIWbRIZP/Nfkr2s3/NVj/6djKXUnymj7vWJfIuaqQFgIDMXP8bFKqo7ZI9q0wAGXDELIAPBha1ykG7Kc05b8RLMS7tVyg7mZlRhekhyH4FGOme4amvhJrp4BJHBb+GVNj1ErH+PVaJPpUT1lXzIUuUq/QnEaDB4Ytf9DELj4VwTWGCgTQMj834fdSPnORRPmQrlhgTg2U230icMBy61w9P2Osw5Jhy4qm2A5NwFwodMsgS9ssRsVK3vNGQykQ977DDuqSL7M7qJdPMZrto7XAlNDL8QgCxCt3TSu5dkr8tqdRMMy4QEPMU0QpL/LfOBIxvzG06aRTZw3gYU0Sejej2a7+Xn8X/0LsKC5lLf2o4PJ0lH6buuBLRpKhwYr19Jz1wNogPAnDD8qrHUr55TFhrZWH6+l6l/tr8n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c01TZkJyS2kyVVhUQnkrdkZlVXJqWGR4N0Z6Y0ZmWDhlWXVveStMVDVpOENQ?=
 =?utf-8?B?eWRrVnNydjdXRGRNZ0FwOTRMK0Ixbjc1REo3YzlvVFZKK1hac1JsUzdxT3Jv?=
 =?utf-8?B?VnBDZVRHRUEybk9JVlorM2hudVBJemhJVC81WjlUSG1KbEg1RUY0bVEraUtw?=
 =?utf-8?B?aVdQeWkrSEtrYld1c2FNcGhqR2FzTHVHT0swVFVCT3JuanNSRDlvRG5Wc0M4?=
 =?utf-8?B?SWpZd090QmxKL1J3RWgybkdTQ1VPeHB2YS9ZSmw2Vy9YeDZROTZMNEZtMHRz?=
 =?utf-8?B?czdpSllreDlNb0R0TGg4L1pHallBbDMwcXd4cTZEZ212L0hvTE5tcjNOSGJN?=
 =?utf-8?B?RGQwQng3V3prT1BlWURzTFpqcStmVGJ6ckR1eWJpWkZrTUcxMExuWXUxWTZu?=
 =?utf-8?B?V0hNY0VPSWpvcHlrSyt6dVUxVGZmZHlGdkgyRys0bXg5SXU2ZzA5eWlNbGJX?=
 =?utf-8?B?VTRmSmYrNFpyL0lkOFlUTzl2b2JlWDhQU1Z2Q0RreVZvajBLYWxmVkhUZ0t0?=
 =?utf-8?B?eVgzRjJ1c3BYR1h5TjV2b3g1V2pqcUhlaXQySUFsYUtoRlMzYTRDT1N4OWd4?=
 =?utf-8?B?cWhmejdXa1o4cE5hRnZSaFpHTU5BOHFnbWlsM1RyeStmMGV1eWEyNnBuU2RJ?=
 =?utf-8?B?cEZsSlBCNHBiNWphQUZrT2RIM0h4aXZoZ3JqeGIyclNDamlmbFU2UTZxSjBv?=
 =?utf-8?B?WFlDaEllc2ZDWWZzK2M4QkdEWFZPV2xJL3NpbUNFNUhFU2VCMVcyYjQ2Qy9m?=
 =?utf-8?B?VGpIL1FHc09oNVRKMjVwRG85R2tuWEE1SzRSVWI1eWZnQmlNbUNmbmR2REJS?=
 =?utf-8?B?bFN6ZDdNaHV2Qms5Z3NodEFBbzZSRjd0cWgxSkI3ZUlGMGRlL2tPbEdod3Ur?=
 =?utf-8?B?WlFMUW5lTy9wTUZuUG0yanREaGNKbmJXajVsR0xJdUJEdWpNd01GdFpQT2x0?=
 =?utf-8?B?N1BsTDdGQXg2alFhRldSS2NUSk1MY1NDRU1tV2pQSXd6aEJmeCtGRDRHa0RF?=
 =?utf-8?B?VU5LOXVCUDd1dmJJcWoxRWJyVHc0cXo4ZlhTSjhlOVcyT2o0eElJNkw3OFlP?=
 =?utf-8?B?WDJNOEsraUp3V1YvbytvQ1RsYzlua0g1TWpTRTFaK0QwQXVwMGZjUEY4TVJp?=
 =?utf-8?B?ZXBrRWh3cm56eTdHU1FXY2RGZ1NiRmVUK01rdmx1TEM4SEdLVnpmbWs1MFRQ?=
 =?utf-8?B?VWk5VFRPNmdLQXdjSHJPT1Y3NmVtNWdjNlo3TXhVS3Q1SStscWhFdnhkMGxk?=
 =?utf-8?B?a25JZCtMRVRKSG5IbjFBaDBrM2cxNU9CRFlxeGhndTh0VjVLY2Qwd3FvRkND?=
 =?utf-8?B?TkpPaHUxY3ZXT0xoNCtyRTVmbnZtT0kweGIxZ1JlTTR0eHFLb1RCSjl5OUtN?=
 =?utf-8?B?QVZqZzkwc1l2VnU0TmE5dlhhdDRJTFZUNDg3SGpMT0hxVlViS3prRnNHZW1T?=
 =?utf-8?B?NkllU0tBdFF0QXdLQ1plOGZvT3pXQ2t1WlZlbGhRMGJPb0t2R256OG5rWW8v?=
 =?utf-8?B?Nm03R25FSmdnRmdiWnoyNTFEdmk3cDFpSUZNOStsSWtLb0U0cUJoTXlnYURI?=
 =?utf-8?B?SmJxSUZLWlBTZlVncjdhTGxqWCtXWXNUMVBuVzFmVml0Rnc2R3p1dThIS2FP?=
 =?utf-8?B?elBIYmZWQWJQaUEyUkpOK1h3ZndQbCt6OGV1a3ZCQXRxZUtlUG1TODEzMkpQ?=
 =?utf-8?B?Z0RCMXg3Y1dIZUtwRktKNFNHK0tGSUk1Z2djMkp0MFVQdC9QdWZiSzlYak1D?=
 =?utf-8?B?dXZCRjFlcDQ5YWZiYUpkZlNQYlRTMndQMHBXTG93dXFTU2ZoeDJwbU15SWU5?=
 =?utf-8?B?YWdpQ2NyUnZyVm1vQThjamRIOXE3aHRYNWJwYUF1MTY0dnN4Z2VvR1YrcytD?=
 =?utf-8?B?SUlhUXZqSDZqQjg4TXRRRXBNSzdkUDdKZS9WbzBtYUwzWjRPaGEyZm5rY0da?=
 =?utf-8?B?aXE0Q0RsbG9tM2ltRnF3L1FROFNnemZwdlRXMmRZMHArd0NWRjQwdlBKTWo1?=
 =?utf-8?B?aS9Md1ZaNnlFUVVkTEVUT08xT25XR3hsdld6MjZzWWxOWnZrM2lobVRZbTIv?=
 =?utf-8?B?OEp4bmJpSEhqM2VjUHhldmZ6RTlNdnRyZEdrYm5idWNhUFV4RTFoM1F5MG5Y?=
 =?utf-8?B?MzRDem1ldTIrTWFQZFh0UmhTZWYzWVZSaGR1U2wvQklZaHNQOFMyVmtkWVZN?=
 =?utf-8?B?L0doVzU2N1JFQXBJbFJlYmgvSUVFeUwxZE1JWHg4TXFqdEhDUUNyNXBYZThv?=
 =?utf-8?B?THQrQlI0emZQT2YrcytzTktWaVN3MVZSNmxJbmtsUkRFdlFWMkRvdlNoWXJu?=
 =?utf-8?B?MHlTMHJwZ2NqT3krdXdobmNOV2lPTExHcDdlaEI5dEFIY2JucHJMc1hPYytr?=
 =?utf-8?Q?rITkg7gBPLNCR+BE=3D?=
X-Exchange-RoutingPolicyChecked: EAISnllXwJH8KBEuPZfkp/gQRRx4of0QYO6T5QvGU6y+FJN13pwPQMOKHFW5K6+KH9R+k9oY4IY1feTH3Y0jEP7cXls2yVObeYdg/LQ9L+3fS8ed9ira7Fzwu2IGpkVah8owC0J2onyZclweLtwcqzgb4feZFmgzQvMJWLC2vtOMIgaHfv063f9c5E7m0azOF4LOR4Ff1ArjvBhN1XLTaRAxXvcAWkDVgChgIQ9ADi9P34F8mR0wMiJ4/NjbuwAGgLW/lkN/uzWtgZiiDvwsYltG79LV4dUnrStw6Xkab1vxF6XG0WRJbY21Elyjb7lyLFD0sIDgLpfKyi7dRyCTVA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8516175e-eefc-4006-5991-08dee120051a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 20:47:57.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCQ0NqrPYg5l1nU9Qpmi1/0BArOKWvxZmYMv9/kj75ZHhEio5ZWIfdoYjOOA6/v7w3tb5HvM6CgFNoRv1pchODNYCvVq8fGVdrVLMk+NZlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5328
X-OriginatorOrg: intel.com



On 7/13/26 11:29 AM, Borislav Petkov wrote:
> On Mon, Jul 13, 2026 at 10:39:36AM -0700, Reinette Chatre wrote:
>> v6: https://lore.kernel.org/lkml/cover.1783377598.git.reinette.chatre@intel.com/
>> v5: https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
>> v4: https://lore.kernel.org/lkml/cover.1780456704.git.reinette.chatre@intel.com/
>> v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
>> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
>> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
>>
>> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
>> and a use-after-free when an L3 domain is removed during CPU offline. More issues
>> were uncovered as fixes were developed and reviewed. While the goal is to
>> fix all issues the races surrounding pseudo-locked regions are not yet
>> solved and have been removed from this series (last appearance was in V3 of
>> this series).
>>
>> Applies against v7.2-rc3.
> 
> Ack, now that your fixes are upstream, lemme stick those ontop.
Thank you very much Boris.

Reinette

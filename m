Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36C136A35A
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012632; cv=fail; b=PQjeyWWUbrogl09Xf+MgoIROiaLWacsUyoTpCBYaC6TgJln8uS4EehX9u9kAdF95fr/6ZarJwE5Y5DVjYfTMoPVymrg+IAblxiYycoc7+PygnjI8ZqbaOLONSG5nUXuxQBBpqa7PN4dXRsjTrFC92WQpXd38NGLUtatFwMJsznw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012632; c=relaxed/simple;
	bh=w3AXxt72CWnvaPr6dDCG86sUaWSFzoPp+nGHW3U6Yys=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UpvXK/1TLetoZDDhuZYwF9raBFttJa+J//3kTk46pxB9pTFXQMCIaeF5IzxbqiNbW5szNugEItfSz4Ot3V4W0pXM9fD99CWec4q8rB8iMaqGGJ6VVExw0Sx8UA7fJDl2uLdWQ5LfCZzssxFcsZM3j7opZQVcTEW1VtuLdbxoWDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D86w5rYk; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D86w5rYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012631; x=1820548631;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w3AXxt72CWnvaPr6dDCG86sUaWSFzoPp+nGHW3U6Yys=;
  b=D86w5rYkrL7dgQ7pnZUNcj2a6gjU67D62uwaZfyVFWv3GTnLuj+yogyd
   giraOLXu2nyo2SGjbCZAr7pTMZl+/46EVj3GJEhRPGuwglwH7VcAmG74I
   OB017R2854f+7bBWY+ab1LQX12HYA1yp5iGF+cQcauGFyH2Zbo/etv3ys
   ucV1dWF/HxMXi74FK6f1lUPaaTt7w0q0gjp3I45ensZ453bLrGubvMr3Z
   CZxlHP/YTjJFI1aTHZAAiAi8ynCbl5vyk0pW9F4WUsJKF6kdb8zZFv7NQ
   SyJ/Y2AgMDJDCjzg+fxZSFXdsNw90jMkO7yEdlBLuKZ2Ig8utgbPaltza
   w==;
X-CSE-ConnectionGUID: OpSd1krMTmO8YqtU02lN6g==
X-CSE-MsgGUID: f0vBSUuOQ1SgOZ8NHyPcKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100617837"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="100617837"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:57:09 -0700
X-CSE-ConnectionGUID: OVbRAVyNT0aHZU0+DjAWwA==
X-CSE-MsgGUID: PPwUUfoBSKShiOzj5+AhMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275023685"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:57:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:57:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:57:08 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:57:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RM1jk3bVFt+23ocHE2Yp+h0lWo5VEV6S7RnIZummTHqHhuTR28R6+k9NS+EE2VczfKDSqHy+vx8oEXf3M0BmKYBNE/7ExSiP2YghLPb6kfuCrSCXlrtEr4No4yD2eDDdJV/KVhdq47Icn9c7nzwKbxKetkDdKS5DYBGC3rni7iy8kLht+TURfYr9BUjgu9F71+3Oc6HC0KX+3VsAeCjDJJ8I5bNCpDYiWQ2chHilrXeJ2ZgU0g/Gtd1I4KqVDWTs2A+b2SUmflWtBtxNP76nzFwoaeBUCJ6dvOrd/qbKR9MJbYPINftz/SLM38fcnHTGrRTFVeiRTYrYJwZsUxW0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pH5ZqnFnct6EQ0RCnphK/yzaoBgzqf0UPrywOXNrrBs=;
 b=VWer/fwnGponPabCY9W+FGxZLcMn5hsdu1ZDMDBDCf1UjGWnbtup6ZzRmfk3b1ZGgDpMPJnVm3JzUAt9KJlx8IpT5DJfJSQWKCNI7y7bYPg2Er4nNXzcKZtdsTqL57LhqBOoH+rajQPoz/mmZPAQOEbBBMFeHJ85qaxioxGPtP7pn3KAJZe3xsB6mAA5hi+wKipclCuIRiJ7kIjSynaf8jFjFnzKRaDzxIaR9C5XqX/FRwysb5oogpPAGf6Nvb3udYBSG4gLme+V3RtYBvjfhBIcaFPj5cggn5T0+hy26uJlLS0KwjRI9BKfFBRfGy8cFSdhPahv6Gim1hMvT+QY8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 03:57:06 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:57:06 +0000
Message-ID: <cd00837e-3a60-4b22-96ce-738c98bd47fa@intel.com>
Date: Wed, 9 Sep 2026 20:57:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/23] x86/resctrl: Delete rdt_alloc_capable and
 rdt_mon_capable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0336.namprd04.prod.outlook.com
 (2603:10b6:303:8a::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: ea03abf9-6203-4e52-4837-08df0eef946a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: lVDnwQX0sVkr5XSo0IzmpHY1yeJjIvE4QiVLE9yZ503ev2E6wMuWsth+j4K2ZHld6CPILUmUF+KRag4TTQsvtFI68XmQEDKRDs3eo7pkvJUCWI9c29NkmD2b/sc6hTeiIZ5DDCyQM2nPuxorfbCzGmL6/hg6wK3+tBBLoIWslbw2m/VtqWOOtgq2rj6dwWoOAfgTBAo13p4J0BiNCF9slPfbEKDmvZvRSprWHQHPUpwRwIcCx5klLmW7/u0gGHy9Wx4AyqOGTR8uPDdBCVXQXndXQ93ZFRfwSnHcO7gqMhJJb7RbR2qjIf9wikneWliVbUp2a0/7t4mlvE1Mf+9nJNIxghKJlXa2wTDk2YOOon44WiraOzEU6u8jrAd5R+XDwEAgCo+lbkwUISphwySdX6O3AKbcbX1pNr4zlmEWTsF/yPTtpZ6A5G2/cBV58szLCvXGKkyyE9B8siOK5xL6LeTgLPx85J2aFgR9IPRvTmgHNMxOovntXfG7VBB4wgWcpkf8Hp52c2MvDvTbuNHGoLe5+ANtPikH5h7Y0eY8MJSf6TLlZl+cJ1ccNGIajoot9x+Ns8rsdTZQ37ZIbAdId7QRhm6gn4dgdve3kyMcVM0RsNTxmghdDULX9bZCaZWFX6wkhm5eqrOuzUPdNFwaBRVmCUC55Y7r8tSzE56UJ+bx+/Muv20xfXF+3/cInuuPRn3+bnumyNOGL5rpexByhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGRtM3BKSHM3alB2S3FmT05BWEhzRm9TOEpGNUJuRHJ0amc4cGl3d08wb3RP?=
 =?utf-8?B?R3NnMk9YTjg0dzlOOUo2NjFwUDQxNnJEUFdnTkxNYlM2SXNwM2E4QnRselNF?=
 =?utf-8?B?QzdxbW11cmwrUkhMMyttOUZHakVlbFlnK3ovaFJnOU5UV1JZYk4vS1pSOVNq?=
 =?utf-8?B?NzNkdjVjSU9YZnZFTGFLSUFmTFMrcVdFeVR2d3pjb1ZRcHl1TUEvMzFwZVVo?=
 =?utf-8?B?NHZhYVpQc3Y1QzJRdEM2WDJicS9JMmlYMTBycVNzbk82K1ordzFHTWxMVjMv?=
 =?utf-8?B?TXJ3dEdaQnpkQ0RESHhmVVZ2ZHlTMk44RzM5a2Y3d21IRGlJbFFaaXU5cWdv?=
 =?utf-8?B?dXV0REovbzNKcHIzM3hneW5BdEo0OWlxQmlxYjAyUnFMY09xeGtacUV1R2xR?=
 =?utf-8?B?QVRzbHVTZVVBNHFiaHM0VFQyRlVrZkIyaU1hQjZrdVJRVFZudTU1N2lGR1JP?=
 =?utf-8?B?WjZhWlJvQkJwWndrdWxRMUVqQWtLRlF6MXpCVEpybGd4TVhkd3RjelgrMmNI?=
 =?utf-8?B?c0tnVjNmWE9GMWtMWnlrWHJrai9hSVZHTlE5T1hwaU5DVGs3ZWErSDNLRWMw?=
 =?utf-8?B?ditRTGpDa2MwdjdTOWJrV1FtemZxS0xJdnBHNXJ0dEI5bUhoMTZIZGlONEM4?=
 =?utf-8?B?eEJSQTJZLzI4QVdPMTZBQ3BvYW9xTHUxVnJQSTY0MlNSeE1Sd285dy9iUHBW?=
 =?utf-8?B?SzhXc3RibzRNNk5DZVh2K204U2ExMk9tY0N3OG16VklFT0hPSkpqOExvTzFE?=
 =?utf-8?B?bHkvL1RPOS92RlhkWGJMaElSaDVJb01kN3QvOXd5RWlFVHE2ajVWY2tYditn?=
 =?utf-8?B?R0VSQjJLeEl3SGFKWFgzK0dlZmdybkcyeWdHOTZFczBneklITVlJeWpCbDAz?=
 =?utf-8?B?djNzK3JvL25VNVRMTmY4WjR2akgwcUdrRDVHMHlqR3dxZC9TaVZwRThBRmNG?=
 =?utf-8?B?YmFzc1RMZnZrNVFiWjdDSVBUeWhZYko2M2dORWhSNVQ4Tm90VnBuVGE0RkYy?=
 =?utf-8?B?bU9JcmhKaEY2cms1QnBGNEMzcWlIN0Era3AydldUVm1yTmd2c2NqVTNOUTVo?=
 =?utf-8?B?M1UzejhmOTlQUGZXSjhhbEpQMjZjcWpaSm42bHV3TUxkSFFDcmdiRm1kZWdt?=
 =?utf-8?B?TnltTHdHUy9CNENVMDZIRlVwYi9ZNUxDS3BmSGdrMDkrWmlFRUUzdURjVytR?=
 =?utf-8?B?cEdMSm5ERzdDZlJxZ0V5T1VLeG9MS1JoK3RhRGRNQWFmSmlpQ1BET1NDcXNZ?=
 =?utf-8?B?ZVFBajFrRXNRZmFEZWRjUCt3alFDMVRxVGtQZ2Q5MVNKOU1ubC9JSUJTL3Vw?=
 =?utf-8?B?N0VsclJrS1pYUVRYeFBud01xbUlqZjVnQlJ2SkNJN1haUktGL3JVT0Jzajhk?=
 =?utf-8?B?alYvdXR5QVR0akRQSDFzUjQrR21ZWEttdWdLSHN0TGl5aStJYzliTE1meEJx?=
 =?utf-8?B?UUMydllTRzhqcEQvMUZHcnBjQ2hDNE9yaWJCV242S1V3dEZ2aFpzWloxeWJm?=
 =?utf-8?B?OHdrTTErL3hSTk9BelBBNGpGb0V3RGJIaHJWUXhkdlRUTlVob29XOTFVVHZJ?=
 =?utf-8?B?a3V5VXNIbzFydThBSXdxblRVNDZrZTlOVFBBSVptS05aZVBzc2NiQnh1czF2?=
 =?utf-8?B?bXh2c3VzL3VySDNkN3JWRlBaVDYrYTJlSDRXTUxNK3BzODhPalQyaGdmQnJ0?=
 =?utf-8?B?b2FsdUNCUjVRWEI2U0RtcEx3Mlo3WUVsTDVOaXZmQmFuZTVaYk0yeFNzVTRE?=
 =?utf-8?B?TXJhMVBQNjE2ZGZab2tZNDBCNjVrUU9lY2VKRlpZc1d5THFqT3pDQXlFSXQx?=
 =?utf-8?B?NkJodWMvMmN5NlpETjZMcXN0cVRBVFFxdzl2WFFTODZ1MkZDMThlK1k4cGlq?=
 =?utf-8?B?bzFvZm9HeFZBaVFpLzRRREE5Z2lkWTUrZXE0QzlaZUhKWi9kTHlqbFJsNHEv?=
 =?utf-8?B?OUYrSG1IakQwSTB3RnhIeUxGclB3aDJBWGZzeGYzMm1ra1lvZ0lUVGVvWUJU?=
 =?utf-8?B?MzJ4bk9SNHpQdElUSlJ0SXFwb3BOL3ZMV01KZTh3SUFnNVhHcWpISHJTWWx6?=
 =?utf-8?B?MStBMk9vR1Jxa3BiSURReVQvU0wrNVdsdXRLaXRpQXQ1S1hPanpPNWsvRHBE?=
 =?utf-8?B?WUZ4SFNBbytvNzJuTHFEUkxZeFhYN2JKUW10TzBMZXN6SjhnV0dTWjg4UE1v?=
 =?utf-8?B?ZmExdHhVMmJ3elFzZXBZM2owd3pQRlByQ2ZaNUhWTkVaRWNuL3VVQkJoMGx1?=
 =?utf-8?B?RWVza2VKalZCaGx4T0lLR2JTVkFYek5tbCt5Zk5ZL2pNbW1qdVpGWXBmYVo5?=
 =?utf-8?B?ME9xbmM0ejN6NVZ6Qlk3Y2tmbGViT3V3UEY3djUxcHNUWHY1ODJudWJmb25p?=
 =?utf-8?Q?WOuP6J/Kbof9/AxU=3D?=
X-Exchange-RoutingPolicyChecked: da4588gSg4B7WsPPc0LCh0JJqwd4pOk73gnyH2bwJuX0uoglLWqPr+CbFHY2hcO7V8jPwg78yzA0c8xx8ynVuM+vsoxxfv8TBCowZq206k5uZ6AQbAYGH4drEEmug6LTl1gv0eGlljO99xGJcR84OGExhgUBX6ygarXPB8Q1g+Wigyh89eNj/oE8mtQ9lhogw6u6DqKf4ymvld1vTz8n3D91RUnGu0zH+SDm7avTJIQn3CtR+gy0tRGc+1T1/IPzCBLndBanIydOiGHe7oblt9+A+Y7M8QQsyLQ1Cfuph9VCQZvfID81iqSUOTMprqb5n3nBIomn/BqPUYk6dRV0Ow==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea03abf9-6203-4e52-4837-08df0eef946a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:57:06.1014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDihbEjQ725PunN9Rk28EEetoznaNGU6WJtAq5K0S0CmLcOujiOFYBkpwxqa6uE/2qkl2EDiaPzuPHwupMHjGYTpctKPa9wxx5YSda8ZX0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> These globals are no longer needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

(missing scissor lines)

> v11:
> 	New patch
> ---
>  arch/x86/include/asm/resctrl.h        |  2 --
>  arch/x86/kernel/cpu/resctrl/core.c    | 15 +++++----------
>  arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
>  3 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index fb6cfff82e2f..49b5357e2e5c 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -42,8 +42,6 @@ struct resctrl_pqr_state {
>  
>  DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>  
> -extern bool rdt_alloc_capable;
> -extern bool rdt_mon_capable;
>  extern unsigned int __ro_after_init rdt_l3_mon_scale;
>  
>  DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 62b97e357ce5..e851da431dd9 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -45,12 +45,6 @@ static DEFINE_MUTEX(domain_list_lock);
>   */
>  DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>  
> -/*
> - * Global boolean for rdt_alloc which is true if any
> - * resource allocation is enabled.
> - */
> -bool rdt_alloc_capable;
> -
>  static void mba_wrmsr_intel(struct msr_param *m);
>  static void cat_wrmsr(struct msr_param *m);
>  static void mba_wrmsr_amd(struct msr_param *m);
> @@ -786,7 +780,6 @@ void resctrl_arch_pre_mount(void)
>  	cpus_read_lock();
>  	mutex_lock(&domain_list_lock);
>  	r->mon_capable = true;
> -	rdt_mon_capable = true;
>  	for_each_online_cpu(cpu)
>  		domain_add_cpu_mon(cpu, r);
>  	mutex_unlock(&domain_list_lock);
> @@ -1026,10 +1019,12 @@ static __init void check_quirks(void)
>  
>  static __init bool get_rdt_resources(void)
>  {
> -	rdt_alloc_capable = get_rdt_alloc_resources();
> -	rdt_mon_capable = get_rdt_mon_resources();
> +	bool alloc_capable, mon_capable;
> +
> +	alloc_capable = get_rdt_alloc_resources();
> +	mon_capable = get_rdt_mon_resources();
>  
> -	return (rdt_mon_capable || rdt_alloc_capable);
> +	return (mon_capable || alloc_capable);

Are these new local variables really needed? Looks like this can just be a single
return statement ... which in turn makes get_rdt_resources() look unnecessary?

>  }
>  
>  static __init void rdt_init_res_defs_intel(void)
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 0bce199a5f7b..bc2df287ccfa 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -26,12 +26,6 @@
>  
>  #include "internal.h"
>  
> -/*
> - * Global boolean for rdt_monitor which is true if any
> - * resource monitoring is enabled.
> - */
> -bool rdt_mon_capable;
> -
>  /*
>   * Scale factor to convert L3 monitor events to bytes.
>   */

Reinette

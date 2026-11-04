Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793753459;
	b=PRYmvzhiefKosTdpB7wn/hGXdZYFjOvGfWD5xOVyGFbf6ppy7L0cYo/XBuJzpEIlX/F1
	 1VuPzPzeJBU50rpegVNPycyl5IVpjNUH+3XbYWIlx/h5H6poYs5kH4mum1M2Scrr10xQI
	 rb8cOXpD8+4kgQnCoH2+Y42gdylafcAGCTlqYKm+W2iMpGONMxg2ElXmlWew1r3629Qw1
	 JEpMzjFU6/IUTcMLd31/vy1gQINWfcjKqrW3n8wMMnPcB/bZtOF+HoDi7JjsoFvNm5gKQ
	 liBBOfy3dMDgKltSCHq+Je4cJ6wk0G13uYnh5ExsA8Th1n9eKYUji8+ZRMoZBIrtrEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753459;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=zr5Hg6Kl+4dEvxveWs1H+YzdBL02THFonpBsSi3VH74=;
	b=dZxawWs018xWpdholZ7iniGEuxTxAFPLkfD7hrb1kK94OvIqGANOU2SdnuNFwarE3KWe
	 SFpEIV4GnB6kzOGeRTfTWhNaYl1dpimhuuAxNcZLRFZ+0Um2g5D42FUhExMsFUmhwiC+l
	 uaqVyNWJK8JtmKQNZErWPBf1OvN1slUDCFuDBKDeRh16SNGS8pfznJ34wj7VDt/VvBXim
	 lnf14cOQkMtdHKLD4D60cTNBgG/3lVej+xRqonUx1FrGthwIHERHXwg8kIf6DXPBgLUDh
	 z56tfudYDA94zuOCYk+B7FA0buwOZVX3damC8NVoQvcCDkRB/dFKB+fkqC93hA9Xp1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mQYS378A;
	arc=fail smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A3A606A328
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 00:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90A3A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mQYS378A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793753457; x=1825289457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8UY4A8KJHZwrG6zFjg1LXomIndeVxY+xpaYNtFiD4Vc=;
  b=mQYS378Awmue/TuctdW4hEj1Tl5exrZmSsKPLlgS/+O5RdW/RGo1ye6m
   u2VREH0HdyxkXmXwnC8ORrk6e4AQ75+aKokt+cXm0XLyCa0wP7z25SIte
   nnYnTLZGFXeinKD5BDCksbzH13TKQqBxAPDBi8kZ6Uu2HNM21V2Nt320Q
   ruOpeM9fQ+CDRQh16InQY0ZG5eEGM3blBoZmP6247eTAvuHVAQCXb5B2W
   jOS+ENebztHkkh9z9oAe0sz0q6jeXU/uj+YpaMSsosIFukO8fboDYbv4U
   HsrK4jvU7YrtbXNONodgBqUQxl9H8Yc+SZjrux0JUpkBL2H344LOi5rRV
   Q==;
X-CSE-ConnectionGUID: LVBdaocISW2/yjA6it8uAw==
X-CSE-MsgGUID: Q9sT7EtzQdyPx3qz31Iwbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2385812"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2385812"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:50:57 -0800
X-CSE-ConnectionGUID: YMXHWCOeTTqM//XjLj36mQ==
X-CSE-MsgGUID: 8wCg2Hj2QkW80k7m+37uyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6398313"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:50:56 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 16:50:56 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 16:50:56 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 16:50:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HES8oWosxVE9Foq88qQRZI0aEEbYt2pCSl8rYhUVFze3d8dujZQy3uU8fxeEyDe8RlGzMSKG9e9y3i+/Epd62s7t+IH94i6Y6OHF/zjqyCurXXjqts6dVVtbPu9wPsZe5EaSCDMpEDgT3/gY0Xfc00dJ6t5YDfJlkz3E86WsDapY4lsEo2Y9/flKKQtYIH7nI35tV+iz3TuNmH6ZBw5MDDZ769Wdtbckhm0E+IwLg8M3cOPTdyU6s9rkpJ9G8puM3XRS8VbOkxV/v4TZc5N+vk6EXp465nALbwQxc5ecglXUrSFREGsckPInjzAhDkASC88/SbWIOjhg/WSCgmndIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zr5Hg6Kl+4dEvxveWs1H+YzdBL02THFonpBsSi3VH74=;
 b=nBjwDVz6IFtPfQZXkvlAKIpv0BhkDPSGUY1r3kaXtpBZt/YSiy8m/lg/UJ3EftNxOc1CxpqbB9iYwdf94vZIYrubEJlbJWUWg1RAhtKiwzJBIX2x6KaiMCZ7oDdOa2dPpxwoNl/+qJEfGoYV4MjytpSgYzyG6RkFq0Tkb7S1k9RJxulZygMjW6v2jgumqx0XR/oL64RlzcPykNMh+j69sLhJOXIAXYe3pkO34ENwUVUwpn8KeVe4xThI3DXWgyijGeR9d2rrdQmOJfROZe1JqNKM8sqiUBaV7+MiZGcXQkcwR80vXvsd9pnRDL+uRx0NQ8pigFBLDoU1K/bkZwBNCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH3PR11MB525758.namprd11.prod.outlook.com (2603:10b6:610:34d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 00:50:54 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 00:50:54 +0000
Message-ID: <7df8d7eb-2518-456d-8905-e86dc1dc695d@intel.com>
Date: Tue, 3 Nov 2026 16:50:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/10] arm_mpam: resctrl: Do not fail CPU online
 when domain setup fails
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <660ffee2c7d069aed25c2757c51e12b28318bbc7.1792443633.git.reinette.chatre@intel.com>
 <2008960d-b5d3-41e5-b9c8-29c5d54c2c3e@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <2008960d-b5d3-41e5-b9c8-29c5d54c2c3e@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:303:2a::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH3PR11MB525758:EE_
X-MS-Office365-Filtering-Correlation-Id: aff31e52-8075-4bad-4b99-08df3a0dae62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|261102123227099003|5023799004|11063799006|4143699003|261028144727099003|261009223027099003|261021121427099003|261026140227099003|261022105027099003|56012099006|261026121527099003|261022075727099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info: 8f3vs6A/L5PYXP21oqAz5HyK7MAXH0dKleRezXqxYYc+x4CTZJYaE/96kUylWpFAt7R/SGIhJjzRT8unoaIb745wYl7xHwa24TAfztmTQ4DkvJFxKpym18mASOBhRUtw0gYgeoMn4sxhPzvKBiAQNtWLTOqSCLtBuuTH8n1EDwXmxUaNmrqtsEPFBrZwqOm0aW7STmLQ7Au+FGMRTR3dgpgHwof9g+gPh2O+XodBLbN59trOEgSUkWNPYOBuGpQP1Y/Bmb4nKKrBkSBF3fXHxy3hCV9k5/lUfJB0jDdMMoyQ38vHMYjslxcaxy29RbF1YDtQEIPxP3dQzDwQjIIV+onUC4XxviRejKLNENQLe36lglG5qV3yHKfLfN1KM7lhB27ZkJJ1JZ2lCXRMSFxf5SWvqjmWlZO4Q9R7hru1pcZWccB55swKGTTTdez8WwUQiG5fkUZZuAYomOH+Y7J7bcLpDkRFi2tKypS9tI5dRT1kLQItgCD3bOLjOUOI4FbeCWUaF4Go0Cuh157fBwOvnjzeFUxG2mq/t3QjxGd9croOFpAOkaVgycf7BMZmTgECayIsN7pZYw3TEVQtb9ZZlEKHBteACWvQQTewZslPqNq5kBJCNwmLTIcI3FHPBOR0Uea4cosTGMz9yVYegrJx7CjMQQ2q7zHYKSzwMvfoNg4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(261102123227099003)(5023799004)(11063799006)(4143699003)(261028144727099003)(261009223027099003)(261021121427099003)(261026140227099003)(261022105027099003)(56012099006)(261026121527099003)(261022075727099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3EydFMvREJiY1E0SW1YTThsYVVWWUFjeU5ydlljcGQ2eUtuZzF4WmtxTGs5?=
 =?utf-8?B?MlFMUmZacWtGTjNyTTlpMTkvMnlQdUZNaFpOc1RSTnI5OFpDQ2t2UmpOWGQy?=
 =?utf-8?B?SkpvNnFxekxNRkFxbzBwQUIwTElGMWF5SGNRNmVkTWhyTVJmeG9RUmVmVVlV?=
 =?utf-8?B?MFVpNlZ4VzBEWHBXY0ZyUmNmMDlyQk1XS0hDbndIeTgyYkhQdGJ1M05IWXdC?=
 =?utf-8?B?SmpBWURZZHp2QWdaaVR3TTNTWEJSVU9wS2FCQnpDY2tRaHNTbFAwN2xKVFQ0?=
 =?utf-8?B?Snh0K3VaSWlXK3Y3WVpRcTFsM1J1ZGJld3NvTGFlcDB5a1FqSHZ5VUJaS2pB?=
 =?utf-8?B?ZTVheTRkZHBMdzRpM1pGTFBkejVEMCs2dUxLOUVpZ3dvK2kwc3I2MDJ2YW1u?=
 =?utf-8?B?M25BNCsvdHBiL3FQdjZxc1V4N3lDS1JFUW1rYnJQVTVZdXVPS28rWkEzbUtk?=
 =?utf-8?B?aGlOandiUkd3ZUczOGp2dTROdmNPU29kaHBzQ2lHcXlJRnRnTzFLNWdEeFI0?=
 =?utf-8?B?MWFlbUNkRnZ4Q3RuaU5odmpiejNTZFJiKzNVNlNnbEJzQ1pOemZLZ3dKVm1L?=
 =?utf-8?B?ZWwvcVJOamE2bmtjM3NsMCtXT1FVTlRJT0V6bUprTWdUeDdGVUd6SVpPRkRM?=
 =?utf-8?B?SVhlaVdGNUxmUEJaUFQ5aVZvYzErdm9CRGhhUG1MVnBDdnlkZDc4VHVCNXdi?=
 =?utf-8?B?V3JncVlDR2doNFR3NFdEWmZydDAzNmFQYTBCR2hBT1VzMGdKR2pRMFYvM1RU?=
 =?utf-8?B?N0JUU1g5WGZxQXNXeWtxUUxVejJpZzd0MXg2L0xuVDdKUHpSVXhHUDBCeTZ4?=
 =?utf-8?B?QlkyMjFJc01lSEpzSDZCeHlQVVQ5NDNkVko3QTYzS282VlVHUEs4M2hCejFG?=
 =?utf-8?B?Qy9YTURSR0J5eWE2NEFqN2lZN2x2NDRGOUliaXVUVG0vSVJ2elNKOXVLM3R1?=
 =?utf-8?B?N1p3TE1DVlB2cG1YWU55YWR0ZzdTUWU0bmFVRGttd05ZaVEzcDhvbTdROVhC?=
 =?utf-8?B?MWk4VmJ2YnRnL2UvcDNMT2d2RjFoVTNsL0NRNzVhbUNtNHR3K3R4US9qVXR3?=
 =?utf-8?B?eWVOMW9xQ0xjaDFsVjZ0dkMwUlM4UG5YMTVOSmN5TVljNGUveGt1WnJER1pY?=
 =?utf-8?B?bStXWjJBdjloUUhTMFNDc0JmeE5TMngxYk9qUTFraXNTckt4SUFTeUg2VUla?=
 =?utf-8?B?dXAxUzFmRGhnWURXRFFrVVZaVWNFWDZrcnovM3VtSmNLdjJrbmFKNmk3MWJY?=
 =?utf-8?B?alROTWVSejJpV0sxR0NwUlJieHl3ZEJ3MjRFTG9hY0tFTnZMSzJwZURGTkxO?=
 =?utf-8?B?VXRqZWIzaXNjNzdUUyt2NlhvZGhlcWtQeHQ4RHNVNGZVMkxYNE9Ea1pFSVlu?=
 =?utf-8?B?ZXppQUNNU3VrR2FOdUhIMlVPYUxwSm5IMnV2dDdTWmc4RHRIZHNBd0Nza0dE?=
 =?utf-8?B?dkE5dmcyMVJWdnI1SlIvRStsWlQxQW5Mb2R5Y3pvRis4QXRKY05qUzlJbW4z?=
 =?utf-8?B?dUlWN2h2YytJK25CNnBzZTRkVEozbXU1WU5TZDR4OUw5MUM2dHpEM3F5bnF4?=
 =?utf-8?B?Y09WcEtXUFRKWXJWenY1SGtla1JJTTZ0ck42MU8rZ3ZCWFNsN21RWWYrUnVX?=
 =?utf-8?B?bGNKcldJbVFRUmprSm1HOWRjZk1nbjlvbmF4VDhUQzY5dGZpWFlMcG1DQWto?=
 =?utf-8?B?Q0o5SFVQRmNYZTJXOXdUb3c2UDEvVGt4bS9KeHlseml2NUw5TU5Icyt1czhL?=
 =?utf-8?B?UFRibHhVdmdycjFhaGV4aWtKVUJkczVFdVROV1pDQ2pxK2l5SzN6QW5LREVM?=
 =?utf-8?B?SHFZaWV5dnR0VFc2c3Buc3Fnc1dDc1FiTEZ5a1JJaDErSG9UbHFpSXIrVFhT?=
 =?utf-8?B?ZlpPTUd5dnRpdUEreUdyZ1dKdDVVd2RLR0o1Q1laWXBmMWJWdnhiNGx1QnBV?=
 =?utf-8?B?WnhSbUFETHMycEkyKzFQeThicnIrV2EzelZVRU9WY3VUWW9Tdnl2L0EweHNj?=
 =?utf-8?B?d3VOVXRxMmZlQWxZZUY0VWYzZmRBNWR2c1BUTmVobG94L1owNVh5MGdxaTlJ?=
 =?utf-8?B?VnQ3TUlUaXQ2MHZTVGJaenZBeDM1ZnJCZEFGajZEcUIvaWEwK0pYc3J6S2pS?=
 =?utf-8?B?dzc0WGcvS0pWK1A2SndkeUpVUWJCRUNvMUhSWDd5N0xGZzFaeWROVDZyMnhJ?=
 =?utf-8?B?L2ZRWTBqS0oyMHo1NE05NDNYS2pyenVocytQNDU1WFh5R0hlQ3VhdjZnYlFr?=
 =?utf-8?B?TzYzWDMyaU95eFc4dkhqWWlrUDZaVytEK2VkTkdSSEZhM3JiNERFWk91Y2pK?=
 =?utf-8?B?YnB0RXNPQXYzWFZ4R3N6dEsxR3YxTkNEeklNS3VJZFBYUUovNlcwREp2dmYw?=
 =?utf-8?Q?uTT5JpnR9dMfImF8=3D?=
X-Exchange-RoutingPolicyChecked: XkD4oNZkdMxMoDJJSq+2tIiZkqsBnn08bT3bnDp0iar5erVwXZGB9K8AcnJyTNILXjLnO+D2PNLYpqETR83XBtx0HOz/UAKw9pySJtjHeuSvaVmW+YIw2bSSyutJk3W1+hMozS0Su5bq10qv+x37S6c0FueCuULgNzy+Oha09zs3uOS+mKuowjo+sGiW3d6kzWai4OFTU0tdBWjGm84O4BxUK4I2A2Iv01Nukw/ZjsFWwPV605F8Qc+4ZIrbRViCoXWc8cFzGS42QPoUUJ0rlNJzaZfeUvwwlaiH0jfiwcHeq8/XysdFIdbCMYVokVhPWmU0A6sR7TM2JyzpLPrfFQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: aff31e52-8075-4bad-4b99-08df3a0dae62
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 00:50:54.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQXkBOaeP9IGF4OQd9pRD883yOj9Kix8b1iORQrYXCqzfz1tpTxFoSyNTQCLajLH2HbMUjZAxYw0s9vG2Ezi3ARicWSqMuewVQhSnAX58no=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB525758
X-OriginatorOrg: intel.com

Hi Ben,

On 11/3/26 7:38 AM, Ben Horgan wrote:
> On 19/10/2026 23:07, Reinette Chatre wrote:

...

>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index b07e5dd895dd..dc442851fd7e 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -1615,8 +1615,8 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>>  	return NULL;
>>  }
>>  
>> -static struct mpam_resctrl_dom *
>> -mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>> +static void mpam_resctrl_alloc_domain(unsigned int cpu,
>> +				      struct mpam_resctrl_res *res)
>>  {
>>  	int err;
>>  	struct mpam_resctrl_dom *dom;
>> @@ -1631,11 +1631,11 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>  	comp = find_component(class, cpu);
>>  	/* class has no component for this CPU */
>>  	if (WARN_ON_ONCE(!comp))
>> -		return ERR_PTR(-EINVAL);
>> +		return;
>>  
>>  	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>>  	if (!dom)
>> -		return ERR_PTR(-ENOMEM);
>> +		return;
> 
> Do you think a warning is warranted here?

Sure. I'll add a warning here in the next version, propagated in later patches
to mpam_resctrl_add_cpu_ctrl_domain() and mpam_resctrl_add_cpu_mon_domain().

> 
>>  
>>  	if (r->alloc_capable) {
>>  		dom->ctrl_comp = comp;
>> @@ -1678,7 +1678,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>  		}
>>  		if (!any_mon_comp) {
>>  			WARN_ON_ONCE(0);
> 
> I think you could fold in your patch 7 here.
> arm_mpam: resctrl: Warn when no monitoring component is found for a CPU
Will do.

Reinette


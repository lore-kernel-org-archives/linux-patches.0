Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA2742BC3C
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 21:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784063244; cv=fail; b=obi0Y7GiIMvX6AvA+5AiawN5gxLkOLc5tPDCqFY8GEsQiE+Xu12inHy5YJJEBy7arGDDZkorsIQ/Bqy/cfazHZWu6dDwScijfBNRnvqn+3vhsrXU6eeTPDqQG6yaiH0A7GPx7mOG/an+HC1flSKwDBlxixdsiQEyEOPHrw8iyds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784063244; c=relaxed/simple;
	bh=LaJkB2FCYaKziONcI96B7plRmKzd9HpBdAnBa66DXkI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gW8mlr2mgdUNGtfHO34F6ooRe6/FWzzXj4sWvndSyaiDzr7iEF2RgkrP3KxvQr79Ob4DIDuEQR3xc1bsRQc5Dcj98FtzbJ0nyRRbBEXaqNDYiOE4IkhYqsKl3VvPJ8G2MCey0Vfh2u6fIhJoRCNpqGN1zqA8M57HY56Rpljvrlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZwE/Q9o; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZwE/Q9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784063244; x=1815599244;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LaJkB2FCYaKziONcI96B7plRmKzd9HpBdAnBa66DXkI=;
  b=cZwE/Q9o662o15OntoiJtl/CQX2jVHUJ96JGv4V3s4zCloUkvCnLtyRr
   ZUB+j+BUfBwXg9MdkuG6x48zixqD0vGINIGWQ0xaCV7xl08b8sIKCiq/+
   quI2EuHsf1FPbWV9KTCw0rQKTRNs33pZjY+KasMSGEBXG5f0hukFOw5/W
   +3vmV/gG+RGeFeKKXvIybyhLk8Wqh99U02/crOI90RlYnx55CzC2UX6J0
   ch87aNJBq6+56G80kKifBxHR9pwkaOpU8IwtfyaRY2K4faFcjPrU+jLhN
   pXC8IXH24otkX9aoqiyctzZn9SkEJDmCUs1sf2sCLigBfxsKIiq9QUVxV
   A==;
X-CSE-ConnectionGUID: D0epTYZKSkuF9bK8CAYekQ==
X-CSE-MsgGUID: rdrsNvuXTZmCs98Q7zFf/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96206675"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="96206675"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 14:07:23 -0700
X-CSE-ConnectionGUID: XbSNGEx/Q0yLM8bvRHir4Q==
X-CSE-MsgGUID: a3XkvIQxQ1WaGrSD+2+kyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="253352854"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 14:07:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 14:07:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 14:07:21 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 14:07:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWqVfq779F2WdIwVlcE1ifrp7NidzcwSPq8jV7I7vItqD+7UzR1qPvBGdz1FV2DR6EVruuV32Y2wmj8NWvT8TP50Wjwtj58yKQRuI4WKC9s6YB2kInZrpgjfck59S22BAmsMoefBDsJF5ouM5x3uqRiJ7PhJJxXeDfcz61NJtJrrB1RpROpnMrhtYaz8Zgem0yIVTv+kMvgtHYhKkW3dX68IIvC+XyzC3ymTVVZ5acmh8ZHDpmvJKdjPs1y+kDv6HMPQFxO3Cuo4E9z1duSldzZ17W8tqkefV1nKAC2G0TR1NyoGKWXCnePxdSkVJnMyt6aw2NTgrHl3UgXmX/FelQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uglsLaAoNNo9jA9KOIkyS4XWMxTs7tlBEr9KbWMuBdg=;
 b=Kou5pxTkNwdo9QAINBsfwE+CNegjbQCpuV33nMLTvbGq43IMpswnwawxoPvJZ8mMWKE82wZh7dtJpCqZGAk9wnw2IjAe2tQvr7R1qeZK/xpzVD9FZJOLfdqzJCTggUaHCspfm+2RZ9ggBHfx6Ttle9zlKz+WONRy/MhNUJUcbOlpNz8nF4iYkaKom9j9XrDQjTdlZbRM+Xmg5LriIesLMZRMI64MxpVlG66KQg3SAptnymFJkGKXx3yxV8Tk+NumY+eSrXRiQviKVIZWze2bb/yYiQK3x+Pe+GeasEW7TdgvK0yGrgL+CgPcpZ6wj0oKHhq1tUeXMpU6QvrvhuBfLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN7PR11MB765673.namprd11.prod.outlook.com (2603:10b6:208:5f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 21:07:19 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 21:07:19 +0000
Message-ID: <1dac7a0e-8b69-4b4f-81e1-c010d186e69d@intel.com>
Date: Tue, 14 Jul 2026 14:07:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
 <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
 <alZ2-eJ3yXWHVelp@agluck-desk3>
 <4f0124ca-d4a5-40a3-9bc8-3a1e75ff576a@intel.com>
 <alacCy4Ja4gF97PU@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <alacCy4Ja4gF97PU@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:303:2a::10) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN7PR11MB765673:EE_
X-MS-Office365-Filtering-Correlation-Id: 4029e180-9e27-4b98-3fa0-08dee1ebe437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|3023799007|4143699003|11063799006|56012099006|5023799004|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: mRkZ4IuX3fm0H0wt9uGDk9e+l/v4NSeGke9Ts5MCIHhAZ5RdIIsQ3NXsypTQke35Misz45SNNBC0jzqSrWVrg4lzOUcU6K6p4+aNXcH8APVAd2W1p7wNBJm49c8ZM9sa7+05HrBMJY7RMZfd32pZyl0qY4JhOdOtMwJB3jja9aiyq0FIyZUgjJewLnZa8FyPdLMe1qpOi0050DqcEVK8Uhgj/4Zz1YPVrwHBF6dcuMlKHXmHw4fljZlmy13aj2ka7ssDao197JT9rLH9y5FbfSzTjDShJjQ32824IJobeP81pJeBh+4fcWbUxDAJV2ls0xKsf2CZiNGLBbJrQ6ys/3MuYzbBBpYwMgjYHLkIDEGE8cZQL2AiF6HstaLTig4c17cB5CdHFivhRJ0SC48AP0GLFVsTgO7CX1gKsyf1LCBMs1WG9eRG5Q/g67OQhCdl2J7emUlsSHKyvkcnslVnlnQaELEGDFX8Itj2ut0PPCRlhcF8+MY05lDSujAB386eXOANTnXWcj+VZJqcYdFxuyM3/w12zt9sj5Xhtscbsi6Vvxfq2Gqu7kzVfCmqlwR1ehQY+wWEGvN4QiEcTfXrPLS9Vpz3jd9TmIxP9x05mhDt0i6V2j43hR/e1vbefiwu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(3023799007)(4143699003)(11063799006)(56012099006)(5023799004)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3dOSk5QV2NxZkowZ1RTVXhaYmFZaVFHOEVSQ1RXbTNFb05MS08vYytWMDVP?=
 =?utf-8?B?ZVBVTXhnQitjb0hBb2ZlVWhQdkcvMVkvdFRoWUN4ZlRRSFpPaVRuTFUweFZp?=
 =?utf-8?B?K09uNHpLeVZXbnpYME5ta25iN0NVdXVTNUVKdWZ5Y0ZqbnpqS1ZLNVNpbE1P?=
 =?utf-8?B?dnA4K09GekhDQzNSWkR4eXVaY01JRjdrc1pFZ094dUZsODc1cXFMRXUvVTdX?=
 =?utf-8?B?OUllREJyWWR0TlEyR3dXMERpaWJpdENqWDBWNTUvWC9qLzF2SEVTcFBIREgv?=
 =?utf-8?B?OCtud2ZxaCtOTXdwVDk0NjdQWS9Yb1BBSnIwcW80dTNFbnFzcVk2MEVsTEhX?=
 =?utf-8?B?Nmw5b2FlTWcxdWJDNVZiK1JMYnQ4ZEFMWEhkRVkzTXlaRCtnL29telJpbEw5?=
 =?utf-8?B?UkV2dC9EV1dhRnhURUN0blg4OElNbm04OUE5TWxqVDNkQkZQOGdNbWd1WmFL?=
 =?utf-8?B?bVhJR05nZEY4RVI4TkdtdEd1OFRHYllwd2pKRTVua3R2dU1nLzZDaUtSWk1E?=
 =?utf-8?B?THlDUWQvdlhqTFA0dnVGVEkzMXBnalFxSTZwTnlXdkhkckhJTXBWRURXeEF2?=
 =?utf-8?B?a2tWSEJVMnJiMWxmVUZUU01GUThVNnRrblJlaWV0VlJyMEYvMUNnUDQ3Lzg0?=
 =?utf-8?B?N2JSSlJ0TitGNWRlRzVjcmpZQ25EbW5aeVNaNUQzcHhsSmVsMUw5c1NxejVv?=
 =?utf-8?B?Z24xSUFENjRjQUdKS0RhdzczanVKKzdwMTdUb00yRDZLWW9IVXhLNDdva2Y1?=
 =?utf-8?B?NGZCNXo0K3FFK0t1cmptSVVBU3N4a1Mwc2FtcWlJTjNJL0VQM1plQWNrU094?=
 =?utf-8?B?OWNNVnhUcmlaS251QmZtMzJNTm55dGQvNnVrVi8wWHhEcmh2TmVNeG04ZEh6?=
 =?utf-8?B?WTVQNUROdU5GWlRzeTI3SEE0WFl1ZEk2TDlGb216MCszVytzZjV1NXdzRXhz?=
 =?utf-8?B?ZFNCWlIvRDdxV3prY28ycnFRaG5oQWJxT3RtTHlidTVjbTFsZG5yZHRtN283?=
 =?utf-8?B?Y1JKRWlUek1laXNieWdrRDdaZ0VtejJEeVQxOW54WTFmNDVPR2ZIazV0c2RK?=
 =?utf-8?B?aDQ4TllxWllaSlRyRG1vYVFYTHhickJrRi85NGwyRFluM2RmR0k3U2xaSkFm?=
 =?utf-8?B?RFErR3V6OFNsQy9KbDRCd3A4d1Mwb0huWGJkNHl1VjlSM2VTWkU4a1RhOS96?=
 =?utf-8?B?K2xCR3RTUytWbVBBcjhqUjA5OUlsb2FqOUUvQzlzdXdQS2k4bG45ZVVmTGMr?=
 =?utf-8?B?V2s5ZVdqZU1waXdlamdLaTRaZVhrM3ZJYnNIMXlKaS9iQWRFVkU4VVBJVWVz?=
 =?utf-8?B?Q2hqSGZ3Sm94dEUrRWptQklnUTdMa3dBc25SUU92ZzNiTExyOXVtZGlyT0Jx?=
 =?utf-8?B?WitsOC9RL1VVVzkzYmNLcE9CaXZHSnhPWlZENG1pc0tUSUF5K1JadlI5RVlM?=
 =?utf-8?B?cDRHbHNhem5BOWJQbG9JZTdYdnlYOTIrL2l2TDNnVG4wSFZ2YWV4MTV5Ylgv?=
 =?utf-8?B?VWZxWGdVaXk1SWpVdFBaVXp1Mkx3a1JvZVEwKzZhR3lDWUxxY09xNCswVHc2?=
 =?utf-8?B?b0V6T0N2NFpuOUJOY3AxNWJVclA4NFBlcE5vM09kRkFYVjZkOVY2V0FjRFF6?=
 =?utf-8?B?eUVINXVreTNNUjdMYWR5c3ExZ2lyT1JFeGxyMmhzRzAzeVFQSXV4ZVpPQjQx?=
 =?utf-8?B?Zis1L0lvRGVieGNxWDZSUU9MbWFKTWIyWitpcHVxaXMvVVNVLzdIaFRJR0g0?=
 =?utf-8?B?UFlqcllyODZySXg0Vm04MUU1K1AwYWR4QTlIdFluMCsxTXQyS3FPUG9nRGRQ?=
 =?utf-8?B?WlZ5R1ZOVllRYXEybE56QUFDSkQwVDZLckYwMTRxWnpSUURXRSs4N2pmNDZt?=
 =?utf-8?B?blI5K2xyem1BTHRkTGI5THBuK00xTzVJdlFrVDZvM2ovTmhpWXBvUWxQYkNi?=
 =?utf-8?B?K2hwb1N6TzByT0dRcFNMMERTdE1ER1NTSUNuZy8yeXNQd210ZXNtR0VKT3R5?=
 =?utf-8?B?Nytzd0tPNHJnZ3l0S1B1empKYnRDWEdOYXo4Uy9ZOHRJaFZPR3puSzRsOTEy?=
 =?utf-8?B?Ymh1ZmZydHRtb3Nha3JsU2dDcmJnbFJSc0t4WCswdGhhY1MwMERQSDJNUUJE?=
 =?utf-8?B?aDRwRDNVa0FnZEc1VVhFTUFJY3FwYUZaYVMwS1BhUkl3dHJpNnNSZmtJQ0Vl?=
 =?utf-8?B?RUNuaTZMVkVDbEQ4c0N3Z0ttMUZ4OTE1RlZNeTl2aElYbVRraDNDVWFyMHpt?=
 =?utf-8?B?M25taGYyeTdmV0RiUDJDTHRpMTdzTDdEOTloaTdYbTNaeE1CdWwvMkczMjNy?=
 =?utf-8?B?RTZuY2tkWkZJMjllY0tMNDNsd0tnaWZoMS9tWjRnWnZsa2R0NmlOK28rYUVa?=
 =?utf-8?Q?Jd/nhHd3J16KqPqI=3D?=
X-Exchange-RoutingPolicyChecked: EiEi3eEDdrVVtL1aQ0qeBId/A5E6c9CSEVShQWvt2dYENvDYE41bq7lrPC9rFsAF2YdQ7VS03hYOAwPz2l1N/zQn0Lp6a4dSJAQJCfHT4Vzf/zhiUbBAf1Eg4mFzd70PnDbNG8TX/zPT/SjbrIoAtGTtTm5VvBhebUMMOAnQnnHlTleigdtKowZTUS2ivqqH6e5GUfFCwT7IeTvO30ZC4zI+3XVNTxE8cxHuF3fKjwtHjGA93hUEnZeaGod6hllhYCSHJyh3JEHzaixMFGhDEdu1THYBeKA67ioikyR5+rU6yBJWlFs6WbxBwx3dHNKAcTvUFPMtSKYmGuFOvEvjAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4029e180-9e27-4b98-3fa0-08dee1ebe437
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 21:07:19.6988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtwnUbM7LKXCHbnBQWk4Qf64ZWn/5V0uILQw/aseZJyFXh7cN/agvTWx7fouON7HdwmSFZIXdDIr/yxOiRzs36ts++oFGa1uJV5/fpgmg3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB765673
X-OriginatorOrg: intel.com

Hi Tony,

On 7/14/26 1:28 PM, Luck, Tony wrote:
> Hi Reinette,
> 
> On Tue, Jul 14, 2026 at 11:16:53AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/14/26 10:50 AM, Luck, Tony wrote:
>>> On Tue, Jul 14, 2026 at 09:45:04AM -0700, Reinette Chatre wrote:
>>>> Hi Tony,
>>>
>>> ... trimming to open issue ...
>>>
>>>>>> How much to rely on CPUID is not clear to me. The direction seems to
>>>>>> be to move away from CPUID, which makes adding new CPUID dependencies
>>>>>> less ideal? 
>>>
>>> Where is this direction to move away from CPUID coming from?
>>
>> This is the impression I got from the discussions during series that adds support for
>> LLC occupancy monitoring via ERDT (https://lore.kernel.org/lkml/cover.1782866200.git.yu.c.chen@intel.com/).
>> If ERDT is the future direction then I do not think resctrl should assume that the
>> same data will always be available via CPUID also. With ERDT there is a separate
>> per-domain maximum RMID that should be discovered via ACPI.
> 
> My view of system design today is that architects have a box full of Lego(TM)
> bricks for features that they clip together. The bricks often have different
> parameters - sized based on the maximum values across all systems where they
> might be used.
> 
> In this case you end up with different components supporting different
> numbers of RMIDs.

ack.

> 
> For RMID the absolute maximum usable value is defined by CPUID(0xF).EBX.

Would this be the case even if CPUID(0xF).EDX == 0?

> A WRMSR to IA32_PQR_ASSOC.RMID of any value greater than that will #GP
> fault. So, while you might have an ERDT table saying that it supports 500
> RMIDs, if that Lego brick is plugged into an SoC that has CPUID(0xF).EBX =
> 399, then you can only use 400 RMIDs, and the extra 100 counters on the ERDT
> device will sit unused as there is no way for them to be accessed.
> 
>>>>> Here's my current work-in-progress version:
>>>>>
>>>>> u32 resctrl_arch_system_max_rmid_idx(void)
>>>>> {
>>>>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>>>> 	u32 ret;
>>>>>
>>>>> 	/* CPUID provides maximum possible RMID value */
>>>>> 	ret = cpuid_ebx(0xf) + 1;
>>>>
>>>> There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
>>>> could be used directly? Looks like resctrl_cpu_detect() already scales the number of
>>>> RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.
>>>
>>> I looked at that, but rejected it because it isn't adjusted for SNC.
>>
>> Right. Neither is cpuid_ebx(0xf). Is it necessary for resctrl_arch_system_max_rmid_idx()
>> to call CPUID every time or could it use the cached value in boot_cpu_data.x86_cache_max_rmid?
> 
> Yes. Necessary. See how boot_cpu_data.x86_cache_max_rmid is derived:
> 
> /* Runs once on the BSP during boot. */
> void resctrl_cpu_detect(struct cpuinfo_x86 *c)
> {
> 	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
> 		c->x86_cache_max_rmid  = -1;
> 		c->x86_cache_occ_scale = -1;
> 		c->x86_cache_mbm_width_offset = -1;
> 		return;
> 	}
> 
> On a theoretical platform that doesn't support X86_FEATURE_CQM_LLC or X86_FEATURE_ABMC
> x86_cache_max_rmid will be -1.
> 
> In fact you can get this with boot argument of "clearcpuid=cqm_occup_llc"
> 
> I wonder if that test should really be for X86_FEATURE_CQM and thus
> check CPUID(0x7).EBX[12]?

It seems that doing so would match the definition of IA32_PQR_ASSOC found below that
you highlighted earlier and should result in a valid x86_cache_max_rmid as intended?
I am not familiar with the history of the original enabling
(commit cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection"))
that resulted in X86_FEATURE_CQM not used.


> 
>>>>> 	/*
>>>>> 	 * if system is capable of L3 monitoring the maximum RMID value may
>>>>> 	 * be lower that system maximum. Either because the L3 monitoring
>>>>> 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
>>>>> 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
>>>>> 	 */
>>>>> 	if (r->mon_capable)
>>>>> 		ret = r->mon.num_rmid;
>>>>>
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> CPUID seems unavoidable in the case that the platform doesn't support
>>>>> (or has disabled the various L3 monitoring events). In that case using
>>>>
>>>> Since L3 monitoring is the only CPUID supported monitoring resource I do not
>>>> think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
>>>> I expect that would mean that leaf 0x7 would indicate that monitoring is
>>>> not supported which would make leaf 0xf invalid? Interestingly resctrl does
>>>> not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
>>>> to leaf 0xf.
>>>
>>> I disagree. The definition of IA32_PQR_ASSOC says:
>>>
>>> 1) The MSR exists if either of CPUID.07H.00H:EBX[12] or CPUID.07H.00H:EBX[15] is set
>>>    (in this case bit 12 for monitoring, It does appear to be a bug that resctrl is
>>>    not checking bit 12 before looking at leaf 0xF).
>>>
>>> 2) The supported width of the RMID field is Ceil(Log2 (CPUID.0FH.00H:EBX[31:0] +1))
>>>
>>> So I believe that a theoretical system that supported AET (or some other
>>> monitoring) but didn't support L3 monitoring, would have to set CPUID.07H.00H:EBX[12]
>>> and provide the max RMID value in CPUID.0FH.00H:EBX[31:0].
>>
>> I see. That would mean that CPUID would report a max RMID value while also reporting
>> that there are no resources being monitored. I assume ERDT is an example of "some other
>> monitoring" and it has its own per-domain max RMID that is separate from the different
>> monitoring features. How do these different max RMID values relate? Should this
>> architectural "get the max RMID" be expanded to also consider the per-RMDD maximum when
>> ERDT support lands?
> 
> Yes, ERDT is an example of a monitoring resource enumerated by ACPI.
> 
> AET is enumerated via a combination of PCIe configuration space VSEC
> entries and an XML file.
> 
> See above "Lego" explanation for why they don't factor into the "max RMID"
> calculation.
> 
>>>
>>> For resctrl we have the practical case of booting with "rdt=!cmt,!mbmtotal,!mbmlocal"
>>> to software disable all L3 monitoring.
>> ack.
>>
>> Reinette
>>
> 
> -Tony

Reinette

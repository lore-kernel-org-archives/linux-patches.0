Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3154F32ED39
	for <patches@lists.linux.dev>; Mon, 11 May 2026 23:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778540781; cv=fail; b=JabGVwFKpTXaLTR8k65DZ4ZbaWFpiUrzfnsOv85SYE1VeZIpzlaEg6QGDhNSBqMOesjloC7ErJZTJye1wFfr/kPT3MQw8x9QvGc16SspABYZgOI6kVfk12ND5LacW15ryBf/sAsIvld32cZDLsjA9tt6I5NQPS7cfYmDFhNB4Ug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778540781; c=relaxed/simple;
	bh=Y4NNttMB+5Vqn+8AD9+diHmHz6I3KYKet3B3efENpCA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dPx4u595CokBz1A0p/OJPqtY4dzH55dg83iltqREzv4SkjsxDruDoqG6yQ4lHwlJhCLY4glM7SmgPPGrH6Tnuzw5CcDgt4fVXyTp+ksXvFvmNEMG6UmZutVLUkKbUjO5/aGERZ1M2NxnAGZsKQ0kVtofMS3sS/K1VtIsniu9evM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QLVWIb+S; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QLVWIb+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778540779; x=1810076779;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y4NNttMB+5Vqn+8AD9+diHmHz6I3KYKet3B3efENpCA=;
  b=QLVWIb+SxzO6vIfhj2lhNOlOcF3U6dyDH8jYX0mu9jx+ElwOIU1nBrXS
   g2nMA49W7avKEtgtoH0xw3lTJbby8BPFWlt0FuDELg1pALE9rcUMry4SV
   XO3X0l82t6zXdnzL7d/hErz0BDWOQZaMBHrouoA050sMtj/qisKUAwiiU
   qPkIyj80JYxsiH7wHFlBLUogQL3BqOPtCl51vx/5nH1JIsHVvRHHFVR/+
   AU5BfxgMVn9wvagJe7zSPeKD5P6loq+IQZH/gcmlYiXq7UuTT0i5HAIXm
   5UzTx5i2JxkNUHiM2+rWWhl/Mk+8f/GQr4SAtlzcRt+3QsF06gBSdgfj+
   Q==;
X-CSE-ConnectionGUID: ZWyKicmJTOmE3Jq7nCfPNA==
X-CSE-MsgGUID: LhsAQZaITXKFOA52VUqiiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="79471345"
X-IronPort-AV: E=Sophos;i="6.23,229,1770624000"; 
   d="scan'208";a="79471345"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 16:06:19 -0700
X-CSE-ConnectionGUID: Cfugodd6TPy4miQvB4wPjQ==
X-CSE-MsgGUID: 1iSLOJaYT3eXgynech8dwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,229,1770624000"; 
   d="scan'208";a="234922942"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 16:06:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 16:06:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 11 May 2026 16:06:16 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.23) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 16:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O+EF/rKWz8QgnIC1mNy2RDDJC1eRvRmo292lkDZDiOjXqcSqbQaqjhdHJs4VQ6rkWvPXwBRBuIxDiOQrtsfkQavBPRjd31Ne9coKeDbbWu5s7PPr8ZIZPhcidZ4KzJXqpz4cBgCKO9aC5DxlZL/mP+QrZ9fPw6iKOMr9Z3OWab8KjXkx1Dsg+x3wkGxK87OmQtkTRtHmretjFKHWJrYOKy8Xz+jjcOLcumPthaBkKsoi4pkwnbnkuFBspR3mxsY6HhZFGBIhFST7pne9lz8PTUpKABg1lYUDgdeJzCOXEF/GKJUw0K+7XfW/lLpMb5IfTuuaEeo8EtLSxnYo9K2enA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMpfFSok9xY3ZvM9u5AJPGg8tQDP41ha5NGDwUNZ5Js=;
 b=QvL50YqvSdXu0Vm45843iwIswuY/HIqQkwdUDbRs+U4qKk00ZVzkIKGYXAULrMHoTTRwfstauqXtLklCvWTLP9sOo/ISmENTEAYDX3xqPM0sM7imGbJkTd3cj0s+7TVZ/6yu5eJfR5uDHTtCFM13yJqhok+U/ddoWs3F0RA/YAZQoUM5RUv54/0+xc8R622/9faCefDBbHoBx79ZU3m+30h7xXHletQzGgp/rCSTmkM0+FNr8+YWrUcU6xYQe0yxBSXqAxFTWFdENgjx1dFhlg2p43MYbgeyUELOzkFCb66bNy4XBxcetDdqxdSLbjBMDLcupwvGTdJWa2wS/R8kYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8175.namprd11.prod.outlook.com (2603:10b6:208:44f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 23:06:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 23:06:06 +0000
Message-ID: <1216ef85-9cc5-4037-9c51-6915bc6f4bdd@intel.com>
Date: Mon, 11 May 2026 16:06:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] fs/resctrl: Fix issues with worker threads when CPUs
 are taken offline
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260508182143.14592-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0215.namprd04.prod.outlook.com
 (2603:10b6:303:87::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: d172bb5e-929a-4c3b-c769-08deafb1e1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info: IF7qT53MkSGWJzbz46vdofBFZlsCgX7tevGnX5VAix/GqZLR2BuOAhjH/r1e12HfSHSZIB3SMsKH9PylEwPiz7QDgd4awvonNndPwV6aVRqrbi082Y1s2BFSXdCAG6t+Tn/dNS//Cohdb/+SCZf4UfaKIlsSYv6fB9EViHa5SYuScvhxHhvfPU/ccZdBP+sY78r7vAuBTbuNdcZQG9d/3oE4iI2bh9ffP8IgyV5lw+ajht7c/r5xk9AlTYZDRHPcYjsNFWQaN5fWVj5rt6gBM+hUpcICdJU8nuIA8zxS3cmjkPAbqWcOGlcsfJ8qSleOrGxLnp6/jb1zMrVwaVC42YCL6u6ns9INuaEFoSLgWG9T+KvpoeWPQJwmn8Yp9MuDsLuzLRTOOvj9pYpAHaK3RutzZhRT4HQuYH5n1ARWAk6lv8FmLn+wScv1gVyS6zR3SWMKOuwF4gw+Wbf3uGWE0BMWC8/7WP1MksT+VeW8pPGMMA1fho6tMkjUDeqSj4Jc0EZ9Cyxxjy1bOfHuMv8kgNTot6p6kMppI15OxLoc0qmu6BVy0I9DNh5qs/nse01UCyOXImk6UxBdgHgptA6kQKuLETHKzBFyiWyMdWxfLvZWgRzNCg6hgsTsXQjX5xYSgbWlNCB1lQeFipdtBVoPbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUoxSXk0Y1VYT0pyUGt6a1kvbElnRTRuM3h4cGVNcTRwcEFRMGNPTDRzZTNy?=
 =?utf-8?B?QlRhTFVpNFBpWmx3VjVrdTZWNE04MjlaUzlPS3dVQTUyQ2diWW9NT1Q3Q3Np?=
 =?utf-8?B?a05jeHF4eWxORXQ4bkpvSG5Tc3NaVHMyM3BFRC9kdHJ5TUpweHdadjF6ZlMw?=
 =?utf-8?B?Wlpnei9ra2VGWitvbXNoVENiS1JaL09ZdHEybm12eitNNFYwQ1V4a0k3UWZu?=
 =?utf-8?B?MW4zbmFhdm01bURwaHJkbzJlS1IwKzdmRUNGeXJLWTYyYmsyOGpCVEEyclZr?=
 =?utf-8?B?ZzlNemlxQ3RYdFE3ZTBLVzkzMDBXZlNpWW9PZkFobEcwQ2VmRWs3aUM1UXY2?=
 =?utf-8?B?aHVsYmUvdkdFZnJza2ZaWENtSEhiaGVNbjdMTm9ITHVVNHdJbXZYZjlVSi81?=
 =?utf-8?B?NzhTSGFzeWwzTjFsSFNuejBhWG95b2pONXU2ZXNUVGhLd1dXSDhzOGdyNGF6?=
 =?utf-8?B?czM3eFo5d0VYanNaM2thRXZzUVRlVkRZRWw4eGRIREh4SGdPdmJFd0ZRUm5v?=
 =?utf-8?B?V01lcjN4QnlJVSt1cHdGTUlTSHZWTHBrb09KWlVBY09JZ3FNMWlCU1ErdzdH?=
 =?utf-8?B?V0JUYksxSmF4RzlTdTRJb0pNUHVkWlhnZzJRNEtoSW5QdHFEVXlFZnE3U0I3?=
 =?utf-8?B?eUxHWW1xR3BoRU5VNDQ0TURMQ2I2Sy9PUTZiajREZzhFaVhRM3pMT3VXRTlk?=
 =?utf-8?B?NUpxUWRBelRFcXN4clhGdnpEYUVPNk1DdDljNjNBaGI3b2wvd1JFVlBveVpF?=
 =?utf-8?B?d1g0WDdIKzJMTm1YNCthQUw3emZvd2dHc3FwSXZhYTlBOVBLSnc3Y1NFL3RT?=
 =?utf-8?B?aW5kYjd6bG5kNk1lL2VORGIyOWN5NEtKZFlTYTRuT1RHRDVXd2VRemlNQlJK?=
 =?utf-8?B?dDZpMUQwU1F0dy9aUnpCc3J0WFV1clBIeWJOcDU0T0xVS1VOd0RweGVuQW84?=
 =?utf-8?B?K1pRK3RSY2llK1dibjExMWN1YjhMTWZqWWpYNm9jU1pRZUZJNDJ4MUpydUgz?=
 =?utf-8?B?bDRCMVJ6bXYxYTZTRHhtcXZxQnlpT0NLb3l2YUF5aFBxdmhxQmg1U2dILzRi?=
 =?utf-8?B?alpVVkFNZ09KVEJNQzVNUnl4QThNc0FKUS9yTVhVbkhWcVFNemZZVnpybWtV?=
 =?utf-8?B?VmJDL0E5Qko1Z0NkZzBKQzVXL09vOHdWUndMeERZaTdVWVVrU0pVQ2w2T2Rz?=
 =?utf-8?B?ckRzb3FqM2JxVWlqdnQ0NUU1OEVBejZCcm10Q3NJdzZRZUcvcmlSRGhVVSt1?=
 =?utf-8?B?cnJCbFRqb1N1cUNXYklDQklHK3Zueld3UGZDclpoNFYwNWFQaWFWRE0xMUNK?=
 =?utf-8?B?THNhaW8ySGRmU3NWNUhETXFuWE5XSXpab0QzbGp4Z1ZOdnEwVndrdXNuMnl6?=
 =?utf-8?B?RU04N0xQRmVXM04yQWphNTNiWHMvWnBPSXRudWFORC9FdTdQUXdZdFg1dnpw?=
 =?utf-8?B?SzdmdU51L3Nkc3NpT2NxZkpNSThlQmJELzNvZ1d5VWFWbXMwNVZlU1FNOVha?=
 =?utf-8?B?MTdlZXo4d1gyNHhPZEk1WmJZeHVPcWhhSzlxVWJuN0tIYUdJL2dsNUx1emlX?=
 =?utf-8?B?SWUwTVF0cjhNSFc0WFliUkxZMGVyNXVNR2Y1WTNpUThaQmRRQUpTMXQ5TVUr?=
 =?utf-8?B?RURUeXFGNGl0SjNvR0dpaFRjQ3BFcmRXSFlGV0ZUcXYxY2ZYb3pWOE9ZR0pY?=
 =?utf-8?B?NTdsUVlxV2FFN1hlRlR6TDVuSEdUNUN4RkdrZFkxYXF6ODFUaHJKR3BacTFG?=
 =?utf-8?B?dXU4dW1IQTRlcE93Z0V2UlBYVjF3ZENaNGs3MFZ6anlXb3BKajhQOGVleE1t?=
 =?utf-8?B?MEpJMUxEZDUzc0luU1l0TUNrcTNsa1hudzdVYXRFKzE5aXBEZGl1RDg0b0h1?=
 =?utf-8?B?MTBnTC9OUjBKYm9kaXhPOU5lNWROVVdCNm84NWhCeUdRTlhDQWc4ZjFnbnV2?=
 =?utf-8?B?MkFkOUNaM2V6ZnhRYjR0R0FpdnJFaEZYNDVVcUoreitpTkdtVzhzb05kR0Qy?=
 =?utf-8?B?LzNaYnYyK09uc3ZoQkNZeDR1dHQ5eW1nL0RueUhhZkZIb2hvdDVFamN4aldJ?=
 =?utf-8?B?amNpa1lhUkJwQnBObDI4ODJuZDBFSFNOaFJQNnl2anBlejd1VC9VaXNHV1Rj?=
 =?utf-8?B?Q28wZHdnYnNFRXB5bVZFMDhXMHF4WXExRW85QmpsYmhvN3Joa1JqNVNMcmJQ?=
 =?utf-8?B?K3FCLzhHSVNwdkRBbUZxTW9JV2Z1dTJYdFVCZEV5c29ibVd4T1JBbEpQdm1x?=
 =?utf-8?B?cFNEcDBxdVRzWjNPSlhjQ3RkN0NmY283Zzd3eXhIS1dhZFNoTFBmbURYOWp0?=
 =?utf-8?B?RWR4d25qbHVMTzFmL2tyTkVLelJrN1JiK0J3Q013OGhIYTVXckZpZURxRFNi?=
 =?utf-8?Q?pq5oCCIpUIGfv5t4=3D?=
X-Exchange-RoutingPolicyChecked: vYoHJC8Xm8Z2SMS6ZQZA3ZkTKozx0s1yPhRkCDoSxo0Ji2g2VFpXp7DlHYLGyjSLnpo+7YEGfy4Pyf+rZXk2lPu/ZvEXMgdDQeTdGYr7ApK2wIosl3SQVG7WoHNYKUSt+TtKmk5wmL+bBBW1pVb2BYyETtw7H7I3vZcgQ6P5R512pMSIQaGDmAJD6hjYvYZllJQnaBGkIWo6q68NuJ86cc5jFRRg3FMNGDfET1nIUqDQmc7N4weQKhKjviVuT9b0EkWVUh/OanN26Z5tYK3RNr+tB4HYcvHYIJX4783nLQqon5cW84xNZ8FPWOjjW6ymzap8uPRSSLqDnhWAuvJLbA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d172bb5e-929a-4c3b-c769-08deafb1e1c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 23:06:06.6746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPigM32S7QWY444piL4EjXKp+y8FDX8qFhta11Qc/vtM1/17GsLLvO2UOcUZkb5aKSNBTv6pj1+6ScQiczDw9sPBkbq3pNZ721dY4FQk3Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8175
X-OriginatorOrg: intel.com

Hi Tony,

On 5/8/26 11:21 AM, Tony Luck wrote:
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 9fd901c78dc6..02434d11e024 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -791,12 +791,38 @@ static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>   */
>  void cqm_handle_limbo(struct work_struct *work)
>  {
> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
>  	struct rdt_l3_mon_domain *d;
>  
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	/*
> +	 * Worker was blocked waiting for the CPU it was running on to go
> +	 * offline. Handle two scenarios:
> +	 * - Worker was running on the last CPU of a domain. The domain and
> +	 *   thus the work_struct has been freed so do not attempt to obtain
> +	 *   domain via container_of(). All remaining domains have limbo
> +	 *   handlers so the loop will not find any domains needing a
> +	 *   limbo handler. Just exit.
> +	 * - Worker was running on CPU that just went offline with other
> +	 *   CPUs in domain still running and available to take over the
> +	 *   worker. Offline handler could not schedule a new worker on
> +	 *   another CPU in the domain but signaled that this needs to be
> +	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
> +	 *   that needs a worker and schedule it after the normal CQM
> +	 *   interval.
> +	 */
> +	if (!is_percpu_thread()) {
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->cqm_work_cpu == nr_cpu_ids)
> +				cqm_setup_limbo_handler(d, CQM_LIMBOCHECK_INTERVAL,
> +							RESCTRL_PICK_ANY_CPU);
> +		}
> +		goto out_unlock;
> +	}
> +
>  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
>  

The issue reported by sashiko [1] is not clear to me. The claim is that if above worker
is running on last CPU of a domain and is blocked at cpus_read_lock() at the time
the CPU it is running on is rapidly offlined and then onlined, then when the
worker can run it will find is_percpu_thread() to be true but the domain structure
will be freed. 
I am not familiar with the CPU hotplug locking but from what I can tell, in this
scenario, the cpus_write_lock() in _cpu_up() will block since there is a pending reader
and the worker will be able to run before the CPU online work is done. The scenario presented
thus seems to be defeated by percpu-rwsem semantics. What do you think of the scenario
presented in [1]?

Reinette


[1] https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=4


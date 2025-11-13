Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D504D2DFA46
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074017; cv=fail; b=NM6BvUwB6hmaeHCtyBKMcWFd8AW05xDtBQCIdDXP+WjHaaj4kAFov+ix7Htx75JB5U6mxwMIubmP4JuT3MiqoqgI0DnO8Er7rwMeaNbO0eiaFXxCHP6yX0ughoGOD+Uk+OnzwP+JtJiLRBGu/tSmyvQJzGPyj1H453Ekxv6ttY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074017; c=relaxed/simple;
	bh=xBiQQUA+Yj/yow6+P0v6IkuGIWgLQsdO/q2dNOfVy9g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=diY/OX8rOToc+Pmd77XuMFbE91s6U94F8aVf/E4lEf5XTJHDN6vGQHR+vkNm3bkqn8un+UxKcLPsKNz/q7uhHbRw/9CzOSehRNbTr7XxhrEDNxYCKwkyBKYo0GTWZwaVOBNPmVUMeed/weFQ7C1vZMfioNBoTPCzVA+gKkG9EXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XEM7K6EP; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XEM7K6EP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074015; x=1794610015;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xBiQQUA+Yj/yow6+P0v6IkuGIWgLQsdO/q2dNOfVy9g=;
  b=XEM7K6EPg4D2Ym7fK3wbzgN3n0LYa5wy+PSvfv6GC8kJOOEkkhfpuDo9
   39Q6qMULK+9li7qpxQgSNb9Ji0FCWtThaguhaT1GYB4eDfm2usCCzREjD
   SLagZLAvS3xDbaxOEAm5Te13NRJM2k/P1q1HtXWwAPXP78kCYqI8Tgy/k
   o6YibEdWfr/0LUalcxc+jo45v18D7u1PpmMpyyH3nGIZMNARend5uG9iI
   3WZxzOWNi3Ysg9GJrY6Nm7TF7J5l5QOnyUsFzynOq5UtmRVUnznZE2KZJ
   VEvlj4D+mye8AVTmpJJXRsImhKD2QaB1GLGKhZ8C3jju/x/V/mNpCb3R1
   A==;
X-CSE-ConnectionGUID: EwNQwsAuRK6dbYmw7v+ZAA==
X-CSE-MsgGUID: BW5A1h1IRfqvWfdJd2P0Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65095594"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65095594"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:46:55 -0800
X-CSE-ConnectionGUID: xrqql9qXQDepHNyEGbTcFg==
X-CSE-MsgGUID: TboDp9cIR2K/BpoiMJEAAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189624965"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:46:55 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:46:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:46:54 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:46:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YAckrCSPlowODLvFQGKw9uphyI3Bn1J8dGSW80iTH/nO1QL5udGLQOjCukqv9l+rZAUeXIBZDFF/Y3DLmSfYvD9O2DVPDnGlJtB07uwbrBEwp1cmsOdv/X1R8MpudtRlZNTVIkkeLUUks7SPqX4XziDT2fnlfNu6rmyK8Mdwa4f6oKRhvsgVhthD899GSJMCHCyo4pi+zD+pNiWnKuNRpmPlrONaXVl2WlGJdzbDEHJ154/jOqGP+bw8mGoh37zRnGB1czXR7FNueMnNXRN1JlUkf51MYho6Pqe4TQT4XJFi+bXOcbevPN1TSShHp9kwTlWDHSxN8JPYzkLS7m1A+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6T4VOfE++Voi7mJToD4JtnEtrHK/xbG7AE+n7bOIAok=;
 b=SUOwMINj2tWQw1PMiUnFHPUd77kK56RfiHctOZ6nTKceXNb9+CJgywLqtdlyA3h3tQfY2csWA9e4UuaWXn+lSBccemI3ii67flaErgQAlHRcSsOGRmzTk/5sNGp/OH3O6NxuNK/B/yEEidH1yvhH73B6zQmiZLcpX768pqTR9UEIbojh7uq6x8XIvm1nRxODYokkspcz4gF4Ub4IOXNHkBqECea9PvwusNj7T9c8H3ytUzIE6qFKmlHhHqUT+SZHAfr7VwmAc0IWEJbvLPQzwFA1kO+Iu/r4Zbxjrfi49wVNs+Uv6eQfX4qwsx1nQLFyP6DdZuVJA6lbEDwM9djdsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:46:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:46:50 +0000
Message-ID: <9bad886a-51b4-43cf-b46b-9def6f415e87@intel.com>
Date: Thu, 13 Nov 2025 14:46:39 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 19/32] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: RI1P284CA0121.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:10:157::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ef2cee-76a9-4632-321c-08de230688a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bTlyWEpyWVYrVjlHamZjZ1RtOHhHNGJBdUllM1d1Mklpa3VRQ3pCNDlNeElj?=
 =?utf-8?B?VlNrUEtoRkRrWDh4K2VjMjJOUE5pZmhEcTA2SGhoc2RxYUpPU0VKdnJEeTUr?=
 =?utf-8?B?UnY0L1BBcDNDNlhHOUFMTE5mZGZPY3RwSTdLZHZaZ2p4T3FUSitqN1R2d3Uv?=
 =?utf-8?B?SExBTXpOMEo3OVEyMGlicWg3Q0NEaENiY2F4UG9pNHdlbEdyWDBkQy9NWGFk?=
 =?utf-8?B?K05HKy8xa3J6WlFxaERrNzNyUTd6a0N4cVRKWHpKc0p2YmJtdi9XcSsvQ3pk?=
 =?utf-8?B?UmVUaUllVEFrTnNSWGZTSXpOUCtCelF2OVBOdGpQL2dzOHBCcUpIOG9sRW5P?=
 =?utf-8?B?N240bU9mTXhibFNTVTdmcFEvZmcwZVZCaUNiUmJMTGErRWwyYU1zOUx5aGlV?=
 =?utf-8?B?bWdUZ1F3Ui9CQldrVHZCYWJ2TjgydHBWaHNubjgvYitEYUhrU2MxTUNFcDJG?=
 =?utf-8?B?cmZGVFYzRUxoVDlqbllLWHR1WlFXRldUMk5nOGU3VTFlSUYvTFdzbHkzQmNF?=
 =?utf-8?B?bHRwcGNxamtFN1I0Vm04Z0xYTml6aG1XY3FTVjZqM3Z0dUhnU0NkbjFZaWtw?=
 =?utf-8?B?VWwyODlPWkh3WTVOMUpRbDFpclZpRHY0NjJmZE95MGFBbHlHcmZISFV2Vmsw?=
 =?utf-8?B?STlpNEUrZG5CcDMwUVByaU9OWDl2NGR4aDR6UjdrVysrMWJwTnIxdWxaN1Q1?=
 =?utf-8?B?dFBwVFNBUVNFZ2RCczhKSGNqTkhqRm15d1p1ZTROaUI5akZmYTBlam5WOWgw?=
 =?utf-8?B?SnNBZU9ZNjVXdnpQZDZkSVA5eTVOQ2hFWHJuZnNmU3MzQXdzMTh3MHB5SFNB?=
 =?utf-8?B?VGpLN0pxZTh3eGM3SktyRFlNVi91MEdsL3lIenM2YkdIVldQaUJMTjVJNzVp?=
 =?utf-8?B?Y3YvMkp0eFdRS3h5NGdDNGwzVEZiL0pQYTFXMnNCR08velRNcjdnOWNIQ0NJ?=
 =?utf-8?B?SlJlQUVOMWU3ME4wR2ZSNmhDemgydExwalZpSGJHRVhaanlha0RrU1FzYzRI?=
 =?utf-8?B?OUdVcHo0SXRVNW1OU2QrUzVzT3d6amZUdUdSSE4zMFo3QjFBbFRxMU0vOENn?=
 =?utf-8?B?TEIyOHkrQ1FsVVM1SUhzSU9oUEdPN3IrOTJxeHhxbVlGM3RUeEVhcFgvNkV4?=
 =?utf-8?B?b3I5OHNCdUt0SE9kMnRCZEJ4VFYyWS9wUHlTOXZRM2tuTjJDYlJ2THduSzVx?=
 =?utf-8?B?TUR0VnBGTVlXaXdtTzlWQmZMY0dvTENJRUxvOWptZ0RiR1dmNEhSVi85bW1P?=
 =?utf-8?B?WElhb1J3OUlnYzRXTmZXTDdiRXlhM2UyNnBkUG1zemdEUE4xWGpLV28zcE5R?=
 =?utf-8?B?NGRzMzJOUmxPa3pnVUZkNnh6aXJjY2k1V0xCVmZhdk1HMXpvaFNETERmd1ly?=
 =?utf-8?B?ZTZlUkpOeE5JaG8wN0FkK2YyaVJKODNTdmh5MVUyNW8wL1RoUVpUeStqblVU?=
 =?utf-8?B?dURtRkUyYVlZY3FBK1I0Y1p4NjRGNlpiVzdVQk1HUVBEci9ubjN6bHQxUnZI?=
 =?utf-8?B?NUNhR0xwM1NFQWRqZW0rbHZVaUhLNTdKU3QyMUljYjRacUJNL1g1NC9YTXNV?=
 =?utf-8?B?c2c4TG5aSytnNlg4OUxaVUhnNFRzQ0tYZUV0bWV5VVA1NHNLd21sZ05HcXZY?=
 =?utf-8?B?clJ5Y29LZnlMZTBJeWlOTDRsa0llakVSeTdLU0tSc25NemZ0Q3lnaHVFak5U?=
 =?utf-8?B?ZE8xVXpVaFhIcjJrMjVCUTZBTFpGTVVxdWc5VUQxaHRMSE15SzlIelc4bnU5?=
 =?utf-8?B?ZkNLdUhBZk5aL01PUmhMbWNudzlFc3RUWUE3cnZKd2RkZE93QkV5MDF6QURV?=
 =?utf-8?B?YlpHTjE3alNCRHhKQWE5L0hIZVlKTEZETHpMY2JxZERnanVoRS9YczVHTEVt?=
 =?utf-8?B?YTVyc2xYaW5RNVNJSjQ3TzVFU1pGR3RyNDZ2dE16NkpiM1V3U2JqTXQ0OTAy?=
 =?utf-8?Q?RbUE4IE33JHoqUF7XPgLp3vGVHn322Bk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU5WL1dHZlVZYXR3WDc0NFRQVng3NVd2QVRHSjRIOHpNaVJQb2IyLzR6cXlJ?=
 =?utf-8?B?dFdUcTY0MlA2WkowQnNPaUFzK2xSYXFIeW1GVjZBYlRycEMyUFBiQStKdEpE?=
 =?utf-8?B?V1FZazFYNDJENEc1Nm1veU9QdFJ6bVVGNTVmWit0QWs2RmY0ZlRxWW1vb0pF?=
 =?utf-8?B?Y1hobFhnNTlKeTc5Nk1jMFVqK0VxWVBaSlQxUEJ4UmpiU2ZTQ1Eya2d2R1Nt?=
 =?utf-8?B?S1gxK1o4WDgxdkd5eitnZ2dqL1ZuRnlpd2lwalkwWitFN0dtZjJmUitGU2hO?=
 =?utf-8?B?YzFMa3Y3dmVaQnZpY3FJYWsySDhsR1hTNytBcFl2WWNZM1p4OEk5Q21jcElF?=
 =?utf-8?B?eUQySmRiSi9RNE1xWWJERUZDbVdyTVBOdlc5TjZPRml3MnlOdnI2SmRVRkdh?=
 =?utf-8?B?WlRzcGt0aS9IZ3JyNm5nakZVZHh0L0VvcWlNMFZDSkFibnJEb1gyekZOMEwv?=
 =?utf-8?B?S2hCY1ltY25kTUdqSWNPbTdFWkQrYWhBVjZvcmVZR2RPa1p1clZVdzRUZU1Z?=
 =?utf-8?B?U2ZvS29CRXN5WHdZQVdEV1Z6dm03dTF5TFAyVlVxYUkvaHJDNXp3SVcwMitF?=
 =?utf-8?B?K0F0dWppRklXQUNadzdwVHY0OSs4Qk9yOGRIVWo2NlZ0ZDB3NVA5aHJOMml2?=
 =?utf-8?B?RGZ2MUVYU3dMVGtzd29KRDhkUUJvU2V6dHJGUWxnV1J3eDNhZUk1dG0rNC9q?=
 =?utf-8?B?TVhHVWZqaDV5QzBtUHNyU1Zsd1lES0xJQXNZejArdGNDS0tPYmcrcGRnOEhS?=
 =?utf-8?B?bHFWcVlDNVJ3WVVoYU9ZNndlWWxqU29TN1ppRU9RZ1AreGpLa0psejlwNkxX?=
 =?utf-8?B?ZnB1eWNkVnJqRE9TRDdqajFrT0I1SWRNVDVZdkN3SWhFVzJBZEprOWVhQjhj?=
 =?utf-8?B?VHBQaHVBb0lwRmRmM29FL1RVWGRCWmlweFRoTVdsb2p6RDhQUkluOHpIWlkw?=
 =?utf-8?B?RlFaZ0VZczhXR2p0RU1vcFhDMWViVWo3aE15NmVidGt2VFhGaGg3bFRSTU1B?=
 =?utf-8?B?Ykt4NVZjRWdFLytQQ2R6Y1lGUFVwZEpMN1RVT2dDSUJmL2NGRG5ZSGZqUlVO?=
 =?utf-8?B?Q2k4VmFhN1MvdWpvdXpEMjlNemJzbVZDaEhNeFFLOUUvakEzNFZSSnFodkZP?=
 =?utf-8?B?V3hQaEw2OGFmQnVWUDFjZUJTdXk4b2o2N3hRUlV6d25KdmxWdm54T2lIVE1w?=
 =?utf-8?B?TkZVRWIwZThGREZtU1RZejFidzFPMGNnam1PZVNjMy9Nb1ltbk1oeEhxaUlI?=
 =?utf-8?B?eU05Qlo1Ryt2TlNqbWJlbGtGUG5HZGdiMHFZVVd5TVFVQ240UW1LZFpuaEhQ?=
 =?utf-8?B?akU4VkhML0VqcTFSZWQ5dzBWRTRUY296dTJINE5GdGg4bFVwLzRudk9BOVAz?=
 =?utf-8?B?RzdDMzNTVFMrd0NFTFh6bmt6L2t3MXp4MnE0L1RiL3Y3UU5ROG1oVWlDUmEz?=
 =?utf-8?B?Nm5pZS9vU2VuRnphejBST0xIQS8reVBZZ08xNlJWWS9zN0Z4YXpWV3Q4Qzha?=
 =?utf-8?B?dVNhQ2UvUGhaeUQ2QmRMeXpLUGtETUlGLzdmQS9sTjlwYXJ3ZGpBK3UvZStU?=
 =?utf-8?B?YWtrRGE3NjRFN1pxNmdBYXYrZ2J5eGpvb3NUeXFPU0xES2FnQXdyQmtHNXN0?=
 =?utf-8?B?a2dMZGdqTUVja0dsbXl4dUdPSVloWmVKeFVDbGxLSldrekxQa21zcUtxbklm?=
 =?utf-8?B?Y24rVFdTdmVqWldqZjVkc2tYRXoxVnp5cjM1ZkpRc1RTVU5zUkp4azNRcVVH?=
 =?utf-8?B?Ukt4ZWRWUDk4N0hXV1NibmMvK3YxbDdsMlpyWUxFWTVuQkpSc2g2VHJzVXdr?=
 =?utf-8?B?U0lWNWQyQ1lIQVVvNGs1RHZCQVBGc0d3R215WWVQejlnM25WQlNMQ3IrYlRI?=
 =?utf-8?B?Q3pIYm05ci84ZGhuVjBjZFkrVWsxY0FEQnRjZkZ4eEFYZHo3Z0Z4bXd1RjQ5?=
 =?utf-8?B?RUJHTnBLazZlVklUalBFRUtsaXd2cEVQY2F4Tk1SakZRYTNpZW43SzZmakpF?=
 =?utf-8?B?Tk5kVDVZa29MMVhGaW1naTRjMS9kdXZMQVRReURQYm1TR3d1blJ4N0VDUlQv?=
 =?utf-8?B?dmtncmNlK0hSN3VQVnU1S0xxbTN4T2xnZEdxeWVla1RkUHF6Uml2VlpSbmlm?=
 =?utf-8?B?Y1JRVkpUOVlkWFVNV2E0V0hCb3AvallIQjM3RmFEdEVDYm5jTHp2M1JodVgw?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ef2cee-76a9-4632-321c-08de230688a9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:46:50.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHlZ9u4W9bSBwqNAb8rtQBgAjJhU2A0dkIoob3NSOFtW4Le1iAyQr3DJq3GZ7Ba8BhcuKLFos8f7gCiMGJQlHVTKuKxbqBmIo0w5cYRTe28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> resctrl requests a copy of struct pmt_feature_group from the INTEL_PMT_TELEMETRY
> driver for each event_group known to resctrl.
> 
> Scan pmt_feature_group::regions[] and mark those that fail the following tests:
> 
> 1) guid does not match the guid for the event_group.
> 2) Package ID is invalid.
> 3) The enumerated size of the MMIO region does not match the expected
>    value from the XML description file.
> 
> If there are any regions that pass all of these checks enable each of the
> telemetry events in event_group::evts[].

Above mostly just describes what can be seen from the patch. Below is a draft of an
attempt to change this:
	Every event group has a private copy of the data of all telemetry event
	aggregators (aka "telemetry regions") tracking its feature type. Included 
	may be regions that have the same feature type but tracking different
	guid from the event group's.

	Traverse the event group's telemetry region data and mark all regions that
	are not usable by the event group as unusable by clearing those regions'
	MMIO addresses. A region is considered unusable if:
	1) guid does not match the guid of the event group.
	2) Package ID is invalid.
	3) The enumerated size of the MMIO region does not match the expected
	   value from the XML description file.

	Hereafter any telemetry region with an MMIO address is considered valid
	for the event group it is associated with.

	Enable all the event group's events as long as there is at least one usable
	region from where data for its events can be read.

> 
> Note that it is architecturally possible that some telemetry events are only
> supported by a subset of the packages in the system. It is not expected that
> systems will ever do this. If they do the user will see event files in resctrl
> that always return "Unavailable".
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette

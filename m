Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C19433BBC0
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780961174; cv=fail; b=sEPsQn4N6/Afc2uFn8jgd/uD4/sHQFy4ygCMqw0Kd1mADOx365u940X+g3hbtGXPHtOxqayrziJRCxZ7O+AIaF5RCmv8LfOTdM7G1WpVeW3c5hI9CUfAMAOzykTn2slQyfSDF907ayzD7DjoNyF+tgi6CEhSboKERO3YIedArRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780961174; c=relaxed/simple;
	bh=Im/SF/KpjQuZRxAqHt1y8uiJMab8xk5ZiWxMHEs5gc4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J7kWpD9Dnjjbw3hj4ybnhOR3kNSdfBMwIYWPOW4h+2gJFBqvKf2pB3OWLK9imOrx/AOj80VZsPBlkysYgXOWLdjWqPb1K1L7ZJsGuo1YL+SFEeWtGJLbasp5pHuCV71D9WK1Auuk2OAN0A4bOpijpfjD3n5dY6FU5vZcLQqME0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHFD2Wrj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHFD2Wrj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780961173; x=1812497173;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Im/SF/KpjQuZRxAqHt1y8uiJMab8xk5ZiWxMHEs5gc4=;
  b=oHFD2Wrj/fghyXelKxqXspUUSWWl2uRjNVoTRPZd6y1WFzrTQcG6XJiF
   R0dwqMaeFXgGYRHSYQa7npORDjrYvvsIIF/Bc1MxTzAFJ944Ilyy5eO6K
   IsR9IKDwoRbtCsZR3+yMbaLxyZMp3BFTPSG95hbjC1izF3NEADYzuCt+s
   mNUhiO0c21cLj/+2vBCLtVN9gQMMXCQhvy16PUeRA/Gssr5Nr7ECCg45g
   a1Dp9ovuTeyFh10Zjhnd54ght7Sj0l90VOo2kPINB1rBi/XGmAC03outd
   y85hFGcbuzE4wuKeQVgT/B0V/2ebWgYl7+xRDoWDVTgNySCCFJqojkrRY
   Q==;
X-CSE-ConnectionGUID: GKWAXCC+TlmB8twoYWk4Zg==
X-CSE-MsgGUID: pNz0v3sRTHyGMq3HUStiqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81754691"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="81754691"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:13 -0700
X-CSE-ConnectionGUID: BSHaUHB4QCuBqU9jOXTfRQ==
X-CSE-MsgGUID: 5WQfuT84Rxi3YjkwRygfiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="241519857"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:13 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:26:12 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.49) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXu5q5LPC/+V4fPm9BVcNPxPvh+QhYemQPLHd6AcbQJ1Ri15f4icHY12hFiKfJBz0MlEn9xQvKs51NjwJgLaof6oPMtzbN8InEp2tSiLOGGRgb3KLvIb1sgrZAShrTMtr2uFebQ7UhOPfND7vwZ4C/px9F1vHEi9t6mZmNp6DvRBfqaTU/jybbHutT/RGBGRQQbJzK8o4rFfOyAFJW9PhiJto7jxMvnNl0oG99yja6PjB5bpRTzOJmwhlNCs93ziGXFNl63eaCrGkjacYM5bc/sE9UnpywotS7R6FWR8kFR3YAzmOcW8zvQf5wDX+kHzAS5cPxl3bQ/ObfDlWOQN5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSV6smgu/2hs0QXUFRjIS7/zoZwtenTpcHr1zUO5/IE=;
 b=j+PSfrGg0Ym8Cpnf+GWeZrRTxc03tENZnKVIeFt1GW0JxWs6PXVjgtuEPxjNQTcq0f6Lz7OUS7nA9wC4B4lhZg/CIvFW5IuDX/zbfuBo9EdXFCymDrV5CXb1eJAnWX6BAPhGIIEr6OocArev7JIZdl3r/m8jDS4m0wp4bKbd5/cADb4Gxv936S9Rrm2rDAai6+1ERBbovbZmD3uNS2O1hbsK5qkmpwcklCr9kOj7A2qYG5AfIB1dAzjvXrhHGP62xLrqrvMBdfoz5rgw+gSxikyRxaprDamFYX3ZLjGD5ALcxygWxMF3bcomdnC1BeTCNnBZD/kaiWJeJLaC55mBfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB7581.namprd11.prod.outlook.com (2603:10b6:806:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 23:26:09 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:26:09 +0000
Message-ID: <a22cf368-4a60-4d80-a262-cd4f724c8fbc@intel.com>
Date: Mon, 8 Jun 2026 16:26:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/14] fs/resctrl: Call architecture hooks for every
 mount/unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:303:6b::28) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ebc2d1-f8cf-4091-40a9-08dec5b551e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: PElSSi6EHUCvKs/L2IJiTjtRye5Jqwb6WQopz9d14yjFJNdqTr1xqDzXOb4p1pqNtRlA6m/H1EA5hNRBYoZ7zdl+Wq1gNqjIKJfPYr+vCfgPHIo9Y9FFguH/BPg6NIjCln+ya35AqbDL81Xtuiy3/RanZ2LMMc1e+Kw7Lvw+YTrAWdw347WpuM96Wk64zXBA10uGk5TcR4wxilzeI3caysTp/QwHqAoapm2s9D1HB7ksnUj1vImqb4T5FhLq5lgyFHOYnSTxTTR7miXz39Z/mokhGVlgJQou72vTXe9yOh10WDfY4lFKavHPFZtEJWWr3830h9HXRPS/hPq9D6W624dtDvoWOhzm6zhjstIUKUiJPBYOcaOqdQElkX+BASbe7jkxFs3bRWLOrrO6c76XX4B07wWSs3yfcT5dHSYHGNAFI1x8Cq6QaqPCerQtL6iJvoKtAyAFVjRLc721xhQt8TLWURzBp9oQ3kf4gOJfO9qylxejNOzssvOTWmwYUTyJyPPkBTqRUYbtEgePTjoG9pY57ZdR9dc5Mr922PJ44uXDZWQ9PcpZMNbxBYFz0mUYA0g2E2nzzMnaqnC2nGzx+dCoELi0wFGDnXkL03PXXdE3rIkSk9vFQ5Dk/ITP6NhwxgU2XiTBgIefspH+UwbMsk7zxGieS8p0Hznn1eyNimMtJNl7Fghvzk7yywnxmQ0mMfyEVMx9AAmc+IiEDPX7p7c92uDEq5KdRteY7ZtyErc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFNyUmZUd0FCSUlkOVVjWmN5S0x1cEE1eHA5SGRpYVErNmJ3WlNlOXg5Wnhl?=
 =?utf-8?B?MGx6emFKSE1PVHlNbE0yaFNrWEx0ZFVTeS9qMDR3YWphcW9JWHVoK3lzTG9o?=
 =?utf-8?B?TW5rWnFRTEEwSzFGUEtrZzF0SmNGVDhqY3ovL1Zlb2o3aGZxWXk5eG5icEUx?=
 =?utf-8?B?UlB6WG93RnBuMjkyOXN4dUtEMjNvY2RUZjVWQU5tSXlMTnRTa0NRb1BMK3hi?=
 =?utf-8?B?UnhDYWxGa3FVbGJybWFtNTBQZ0NGbVNhMVN6WXdGYVM1TTZwc2ZmRVpUYkI5?=
 =?utf-8?B?eGEwaGhkcmMyc0tWb1RvcUVDT2J5cDI2ZjJLdFlscWoyOGhzNkhEdEsvQUtQ?=
 =?utf-8?B?UzNOb25RcG1VZWJGNEcyVWNrK1JPaHA3MDZYdzRHKzJ2emVSYXJKUHg3N25V?=
 =?utf-8?B?WEhGQUtGVFN0dWJMaXBCU3lnM1JTZXg4R0RIeXRvR3ZFcUVMU1VUQ2hKZTlv?=
 =?utf-8?B?MmoraE5ybm5sMTRIcElKZXBieWcyQlBTUWk0OW5hd1lzdVdHM2tISWI5akRZ?=
 =?utf-8?B?RXNmMzNqeHVranRYQmZmak1kU1IvMXNldEZYckV4YzZ2alBWL2hvT3V4dGVE?=
 =?utf-8?B?T1YwZEpmTXRjeU5uNGhQRVV2VUJjZmY5aFpzeDRVMEpYSlZLVjZ0aW9PLytu?=
 =?utf-8?B?OHAvVjg2dFBaR3FDYjRySTFYK0ZnYkZOcm5TRWpJb21ON1lFWjFLZGVHRkd1?=
 =?utf-8?B?L09aakFSc1NISURrN094NGZLdGJRRGJXa1Z0NG1vREx6Q2NYRmpML3hCdjU5?=
 =?utf-8?B?bFVkN3lHdFh2M3lKT1VUemxNQUhZcm5ycEl6dUR4L3dHMzVQTHZRV2xpaFpk?=
 =?utf-8?B?bFNTR2t4RXhlRU9VM1p3OHNFdE5KV09CanpzbG40ekU2MlJUZWF2VlJ1eDVH?=
 =?utf-8?B?KzY1d2h3S2Z6SnNacEI0UmREZk90dGRESlNLTVhidDBZNjcvQUI0UTBIUkwy?=
 =?utf-8?B?TFhEbkdYMEtJQzNkRW5jMERoWG9aYWovTEpoaHc3SUlSMGNmT3dPb0ZnRTZk?=
 =?utf-8?B?OVZjclNKOW9qSnBWRFQvVVBoTitFQk91cVp2RE5ydjlQU25qMFpmWko5Q0Ft?=
 =?utf-8?B?ay92aGNvQnFLdkhTamdhSzhyYzdJZkI5dDJyWFhBV1JrK3g0Rm5rOFhXZzZO?=
 =?utf-8?B?c3Vud2Q4WFNNdW9aaUkxZ2hFdFBFWUlybjdpTDlwRUZXdFZWamNtcDU3blZz?=
 =?utf-8?B?dlNhWUFtOVhWMWxDS0ZmRG5BNFNnSTJ2NjNrZGJIcVUvS2NLa1ZvcDVaYlBJ?=
 =?utf-8?B?QnpranBTU0VBd1czdUY5ZHlxSHVxS29qRnZQR1R0VkpRNG9HVEd0UGk0aGhz?=
 =?utf-8?B?dHRJSVlIMTRkWjVkM3d4QWlqVmtvUFhhaXh0L3RwRHFocVpYKytGT1ROYmtv?=
 =?utf-8?B?bDNGQUpFci8zYzNuVzVjdzhadkFBejFheWxiL1E0UVJtdHNaNXVZdEM5WjVw?=
 =?utf-8?B?eWp5SUJsZHlhYjdDZkhmYUNCRjJIeHQ5S3RlWkx2NENkbjhqaloySm40WU5K?=
 =?utf-8?B?ZnVTM25HTHJ1ZWVLRVVEcWdUaHczemtuRGlnM3NIWlhYNkxsaEU3M1JrTnVU?=
 =?utf-8?B?Si91d0c0ZjZJWWN4c3hKMWlOV01Na0NFYWN5c05iVnFlbUYrWTZpbXE4WUxZ?=
 =?utf-8?B?dGgzUDRiWjdlUDNzdkZtSzJDbU1XaUt3MUx6dlJ2aVNSbFJQWTFJc0hzVzJG?=
 =?utf-8?B?VzF0UiswOEREV29rWVEvVlA3dE9YMVZSZTZpZFR0bDJtL2hoL3BQTnZBdjVL?=
 =?utf-8?B?NGhqcWJxMFQxWHhiWU1UU0FWSHZyYzN4Ym01azZEWjRTYy8wU3R3WTlqSUto?=
 =?utf-8?B?VytoQitqMkhDanc3ZmlxWTFGbmtLSjh3QXdlZ0lLQ3FOYmRBZ0hZeUFXWFh1?=
 =?utf-8?B?QVZEU1duQjlmN1p4aW1KV0x2S1dQbDl4eks2NFo2ZEhaaWNCeng4NVF1ZVpL?=
 =?utf-8?B?YWxZaGJqNmpTM2x3bEV0dWY1MjRzeGRwWTFMdGgwNHdzKzJFczFhbU82b2NG?=
 =?utf-8?B?RzcxeHhlUi9TUW9scUQxME5EWG1QWEw0cmxvSUtVaVd5Rmh6ZWhIc1drcHc1?=
 =?utf-8?B?cHo5bXd1TFFSVUNPY3o1aFBFREJDekI4TW0zaG5xcktreU83OFhjdHo1Y1hE?=
 =?utf-8?B?SXdNQ0trQUg1YTJaRjdueURIVzR4NWhXTXNidE9HN3NiQ1A2MCtLTm1nQndj?=
 =?utf-8?B?WnJGTUZhNDNBV01zaVJmM1RpT04xZmpJTHhPYWxEc0lZTThreWNqbGYrRkN5?=
 =?utf-8?B?MFJIUkNMa1NJaXRpUktPQ2V5QlVVU1M0OWxvdHJUTDBranpHcHFoZU9vd2Yy?=
 =?utf-8?B?VDEvdVlUZ3RhWGNhUXhrZmcyNjJ3MEcrMEJTMDAyUXByYlA4bkQ4QUxMemlL?=
 =?utf-8?Q?6aLmmO9Shhg3rpag=3D?=
X-Exchange-RoutingPolicyChecked: kRfi1xzyobS/dzV+ZKZ4HR6ymywuEnKrfUgxMW2Spwi3SJcj3rDcedbFb/SbC66AzQt641/IqoPRhjE8/aLJgd5astvSC2TaSuuka9cWFjTmBlzjyKRpp8+BmS8BZtSZnUSULUvCPhE+t+6luF/GiM6XfuJKVXvbbBkMGWfBD73vAyL5POR/AbysVi5hBD+cyrR3sU7RzXFuEEs9B70oIxJRi910zxhS2/Vp2O/pL6ceexYYMH8/HiHFIQoQF2YmWwfzPZx6wXKAVjTMYmV6GjmE03tylgS1d5A5AXR0BAU3MfpREMjNGGdA5080Wd9MGkGYAf0DPPnNzvzdTdaJ1g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ebc2d1-f8cf-4091-40a9-08dec5b551e8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:26:08.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5EeevCEZ7BTfbYlyH5c/mzpZMze3xq5+KqjNhP3Bdu2+1qRgcjfyWbho1YiirUm9+nZzP1cwLYhDS2U5FpFHiTZX9AnusI0Dch1UnMejB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7581
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> @@ -3147,6 +3148,10 @@ static int rdt_get_tree(struct fs_context *fc)
>  out:
>  	mutex_unlock(&rdtgroup_mutex);
>  	cpus_read_unlock();
> +
> +	if (ret)

Can ret be zero here?

> +		resctrl_arch_unmount();
> +
>  	return ret;
>  }
>  

Reinette

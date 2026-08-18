Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51AA241C8C
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014451; cv=fail; b=HeWPBio6R5q/zgyU7OCe1Ch06Uyr3GGKGnZzTeCaPE84aow8ySDARjzeaDco9JoLBj1QEtYcBxVeqO5ch1LkvO3hzY1c+nJ6S1cGtGRQ/Hts+zttrO/E91E7aIytaYWiYL090UQtMxzLF7T/rwHyELSi78dXGlc2fmBXiY7jgKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014451; c=relaxed/simple;
	bh=0E6cHGaZr82S+LbHipE3LEHcFW6XmtDgzzdjQhSPquI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sSvubZNEN/7+kSRcYCnXnoCDI8NPokfmWhCNLkrBBVFKI0dy1O0nRFSdajY35+RswY6MPnPv5z4WhfN5piXjBjA/nUSuTrRbosyZrEIqdBG5cnCmTReVf12rpRUmgu7XdnokcgrIYlcLQr+IqymhPDwTCWG31sP/B8Vc+D0OiLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kAsJKdWk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kAsJKdWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014450; x=1818550450;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0E6cHGaZr82S+LbHipE3LEHcFW6XmtDgzzdjQhSPquI=;
  b=kAsJKdWk8uHkSP7Yjs9/sJpD/7zRL07qwTA2K+6NeUZM9OaBssb/HwF5
   31p3JEtc/r6MwCbqetgBayFjfCHxD2sC/c34V4sna2NHCUOQEV2u+x6Az
   /VY7nai7dICfrfanRUSJsdw07SU1JXhuCoXl7YMJ0SPhYFNigRJWl3QdI
   Rk1D0lcBiB5PYZWU7kk//b/jsKhLU+98fdwUuJ82ItuAkSiw3qi7E9sv4
   i5j/btKMZ+StEIdaUc5q7XsMrc28gVOHaMvUCT221PdoHw9nqTC1rDqCB
   vPZIX8Q0akGOAyRp06thgaZgy0NFAZW4dqhmlGzFShJxs8ITGKgH6/L+h
   Q==;
X-CSE-ConnectionGUID: bwhPwv1lSnm1Jud5TrLiQg==
X-CSE-MsgGUID: BTj7cXmMShevUYTt2kCbKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98162776"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98162776"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:54:09 -0700
X-CSE-ConnectionGUID: ZpeVD7tYTnW6+Hzh1jPOMg==
X-CSE-MsgGUID: QPgdqxgzTOOLRd5hDf1EQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264623992"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:54:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:54:08 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:54:08 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.47) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:54:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuaPQfQU2VdkI2lveRmWNKwdULqJiaXUfEmf97e/nTAgM9XKOmAqwVmmsZjGwMrkaT44LbEIRKqIbM3BAhbhh3aWF3NOECe7+2f/twgOnvqcwp2lRwjZQlOXX8N5M4wBD4L5MLxf1DYqllSGGUislQTPUVt9Gvr5IP44VA45/iaHkNMcGNseBc75V3w1utyR2kDa/Z1NWtm7bJhk0rEoMRZjOvAmNp7SQ/vpfRc5rs2iQlGu9KvGBGJzJPwGmJuJl44unv7RyV3coVYlRrbe91A5FenNe8A6cFTOH2yG/lORo2e/sKLXi7PN4M7mVczowdZgSO4pi6I50+1gTcciCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqL3+wCeFYujAlb+h2SEwns0Ub1W031bOVglJn8cEO4=;
 b=wbGq6OL9UVFSekMqZaH/JGiLg3LH5iB8tNkIY4iIV7Vft6cKbkac041Uo86Q32Pj6C/ruw07vgPVD+qf9J68C3tW/Cw2VbZhqSOlBHm+9eKXwxgxOUbES+ZZ8uIOS/timQRz47h9uqrYWd3JBMYJkzjCT6RbdyfsSniThewziHViZOLd6zoIVWsi3TWwL+SakTiq9xfgNaoPI9WCjihbdSwIdYVQvgPUD44hTnLXwVZMjYasy58MnnopNvXqCVKEzwTbSKOcxtVZFTA+WBXG8Fdgw6a8dGVeU645ZWu+/J0+BHe5bDSx5qc44KX6DmSzYNAAGYWglCBJFVY2kxigFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:54:07 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:54:06 +0000
Message-ID: <99d9098b-3a6c-49d9-997d-bb7e6545a158@intel.com>
Date: Mon, 17 Aug 2026 17:54:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/17] x86/resctrl: Drop global 'rdt_mon_capable' flag
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260729172752.11561-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: b4cfd6d3-82c8-4785-9fda-08defcc33487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|18002099003|22082099003|4143699003|11063799006|5023799004|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info: XjJMU+08WfOltGGa7j3In+4VTS0kb7RY3aYLBbMYwRJwzXhaNi9r5ncNcHo6zYdj4kxwuumtBSrjgLxiEQjTGSLdM7sHiP6zqEVbgLqDX+6YXWo2QuoTZds0fEWy29tF7rr8AIPXHAepjUxblnQ2cQQ/uKVgIDF6fmtVzRYXSJ9N+aB76i9UA1xV2ebrNjsXT6LYAYLwZRZsoyZKThWHy/LRcIbrbAFoCQjUtHiDlIQzUiC2Po4UBkHAFW7AJyoHsc6uA5IbsYPh2Su6lfTY3zjS3OZPq1HH+3tGhZy2vC0kSXL/iTK9c+l8oPDUTHCTS/bwO4ie9HTZqpQcm7Fbm5rEoGwCUpdQtYI0Gbj+1o4BEBOhdwE/mj/lp4ubF8g48hfgumR7Q42r/la8IQS5cNhYOibbuR2Pcz1aOWtsaEH0Rw8FkD+KMflCtBObpjVF5GPkaQJa4loKFg61J+2GrDkLdGAKdBEqVIMeWTGDVn1OeMkauoeoyvc0FAN2HgRak5b7kc5vyTubZw9M5Maph3ilDvM/j/gqCVZx4C9+OcC5RQge85Vqw7vO+AtZ788WHGJ/MXBMRZs8KedYpBfonzBw6wJbHbDIu1yULj0hq76h/ILj+XI75Yx7Xf/cma4P+FT3SCt2t91JkWJZiJV9HAAZK8gmU12VSnoh/EQiIJHcWzb0shfS+NknMFAuX1//dsDrVD8maxKhZ5t4WZNT6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(5023799004)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d25adXV4ZUxTVmdsRnd3VS9rQUlHMVBUQ2c1NEN5THNKZDVQdFRYSVlyNG55?=
 =?utf-8?B?SDFqUndZQUczQUlyS1pvOGJWa0JtRk1DT3dJRjNrMy9RRGZtMWpZc1RVUERs?=
 =?utf-8?B?QmNQZlpieGVpZFNYa012cjJDekJRU3drS3F2cjYxOWxFSUpKMVZFcTZQZWVH?=
 =?utf-8?B?SHBtK3BIL0FGbnRjUGVrcXdIeXJRaXlCaEJFVkRoejByZ0hzRzBZL3ZoS0dn?=
 =?utf-8?B?RDBuNUNwcmhSc0JGSUdvU2xzcitLMXEyMG5FdHVMeW5ISXNTbXlNVVhXMjlP?=
 =?utf-8?B?MU5iZHBLdjJJTFJnVmhQbXJrZUpvL0pqRW0yK0pqUGNxNGtZZUlnS3JrVzJu?=
 =?utf-8?B?djNNUHVEeDdJUUpUaHpPbCtKMnBPYksxc05GTEhiQXRGS3FtTjdhWmY3cWsx?=
 =?utf-8?B?bGRQYTFFdzFWRVM3MmNQNHhWRXB0cGFKKzcrNWdiWDBKMUU0UDBrY3JqNW5l?=
 =?utf-8?B?Rlo3bTUrN0NKMklUa1daTFAwSzBuUkRxVmhtVVlWbkFvaVlwWVlXcUVNaDdF?=
 =?utf-8?B?Myt3VzA2ME95M3phc2RmUnJzNTlzM0JqbVNxWnc2NDdJZ3VqUFR6bGhyK2N4?=
 =?utf-8?B?YkV0ajFjcVVsZ2MyVzZmcWloME1xTmpwbXV6Uks2QmhuM1o3elB3REhyb0k4?=
 =?utf-8?B?RzkvRGFUbUZkQnJHdFBXV1NvOUtFdWRZSXE1OGV3TElaam5GemlSMTc4ODJx?=
 =?utf-8?B?S04wVUJ4MEdTSmlDZm52eW9lL1EvMkdPTERubW5VZlZGcDBiMzVxVC9NdUti?=
 =?utf-8?B?ekdBREdLZUdsZ0FZVzVmZnZWcVBZWnpQNzUvSWJ4M1VEVjVjdmhHeGZ1Q1Fx?=
 =?utf-8?B?eEM5QjRLY09hOFVpUUxFN096d0ZDZHV0dkxzUE9qdUZ5Mjd6Qk1uQ0pmd0g0?=
 =?utf-8?B?TVFIeVBvL3VFWEJ6YlVQWnU5MTJzMVRERzJDS1pmM2RhdkNGdXpFOERRTWFH?=
 =?utf-8?B?SWt5MWg2UTVWZ1RsNGR3aExlNE96eDM2ajN5TnB0TEt2MTN4aVpRdFBZTU5T?=
 =?utf-8?B?NG5OdlhZOWFaVkhiWi8wVWtleHMyRFpaMWRjUjExdmh3bEtUWUozdHVnbVdo?=
 =?utf-8?B?d21qUXViS2tyQ2V2bEpzcCtxamcvRUNBWDJyOTR3TTA5RnRqV1RTRGU5ZVhI?=
 =?utf-8?B?SmpUeXN2eDdyQktGNW5GYVNvWlRqbytjSTNlS2prMGdEZTBnWGE3RTdUMCsw?=
 =?utf-8?B?RUNrS3pEU0V6VThFa0Fvd2x3Smd5alVON0ZLZkNRNys0TzBDTEFDWEMwVlhy?=
 =?utf-8?B?QytWMnBYL3hqMTh1dWxDdWdJOVdYWWdyM0JMZVkwdnd0MUUzd2k2L1hVcU5L?=
 =?utf-8?B?ZitkS0FYVHZvQzl6ZDdWZ0dZMWpReTh6em4ySlhQQTl0VnQxMFFPeC94bmNL?=
 =?utf-8?B?Tk1OenE2dGcwdzROdmlCa2dkK09pdW0xNnM2c1FlZDBXU2xOcU53cjVRVGR2?=
 =?utf-8?B?YzdLLzk3UFpGbklEQWQvcWhaVGg0cC8rSjdWQWE5UTh6MlNDNUQ3WTJXY1V0?=
 =?utf-8?B?bTRlTTJKWnF6RlpFM2NDdW13WnFLakk4V2FnUXpkZjVNMnlEM1MvcTk1VVBy?=
 =?utf-8?B?ZHhDU2dpRGFLRHhqTnFLSndBUFZVOXBWTnptYnp3TjEyNVgrV3RsMWs3RTJZ?=
 =?utf-8?B?VExRdkdEa3lOcUwxVzVlR3J1S2NrTXhEaWR4Q3Z5VmROQVpJWFhEbkVxVGVS?=
 =?utf-8?B?R0FYSHhTMHQxNnN2OG92d0JkSUxrc05BVHFkYmNEckxkSlZGdzFTeVpVdEdr?=
 =?utf-8?B?NXFVNndwektHUnFGcTF3R2pYVkRNWXY2dXdUVUxDRDZNd1VkcXZweGt0YTg4?=
 =?utf-8?B?TU91V0o5blVSOG5ZSTZ0ZFdsWjQ3bG1KN3VKOW9RaEE0a09aVmhTUlAvSGpm?=
 =?utf-8?B?UzFORm5LVENmLzc3aHVBQ0hUSVdlSlhYWHJxaHBJL0ZKVjZ2bGJ0YTFLdlNz?=
 =?utf-8?B?aDBnTS9aUTJ5c01TRUt1RGU2c0tIRG8zMnJJdjNNYzJ0a21mb0FHdW5Ja2dC?=
 =?utf-8?B?VjR4Z3ByNFpIVVRYa1BMQzZyR080cWM1TExQaFZqKy9JQ2NvdzZGTEVJQ2xy?=
 =?utf-8?B?VDhTaWpQQUErUTluU1VVbExNTktQVitRcE9nbXd2Q214YTVsbmFzT1JEREN0?=
 =?utf-8?B?TVlYU2R2VHE4ZmZTSnQyK0lPMEFHaWFNZldmSkZmNDd5RFdhMlUxSkVodHBs?=
 =?utf-8?B?MFpaem5zOTVZSXBLb29GNUlUNGU4ekN3NHYxSnIyY2xHRVVDSlJnQlRvWE4z?=
 =?utf-8?B?N0VFVWZESThkYmZJTGorbktKOFVZcEp3Q0h4bmdZYzNrVkJnYlZaQTBHUjhF?=
 =?utf-8?B?L3U2K3JGSHlwTmt5WXZrOVhNUk94bEE5SEZ4SCtFTEl2UElNR0M5dDJkSHdD?=
 =?utf-8?Q?nMXN0l/kB5/1gXQs=3D?=
X-Exchange-RoutingPolicyChecked: ZEo/RDNVg4OLTylUETXAzahJeL2vmTCYlt5t6j6+/1c2VKXvT2uLRZX8Nk2ukPVt912UahHWFSTHNagylgiXXP66RpUfTH7uPM0cTHhIOZ+FEaZLKTnmkgHi+GobyP0I7bYroqRdxDi8HZlklZHJogyW6UZ7NTX0q1nZ+5LogzVc71ztc+T5rlUjfslRNZEzvgXnn1PlICMIvpbJPeqN1oDW4yjglcTeTsEEzIuo2VIJSybcedWxfq1tdPzwvTKRypXTiGiOLL68bXfYUZa7w6Ej7uV3xRaw3qgF1rBK83mHpk6ZT7tkW8c3w7vEZuaKg1qg6jhG8H+PWyKwNl6XrA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cfd6d3-82c8-4785-9fda-08defcc33487
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:54:06.8857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GefvPLnE8zaPgFr+NbyIB7ZMg7nRuIkSx0g0bW8Dd7UYlCsqeEidWNmbuQjIltSDq0OnVS7HOr2v0wPwjQoo8d3tEqNTeNjQufO6mqG2yHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> File system code calls resctrl_arch_mon_capable() to determine if the
> system supports any monitoring features.
> 
> x86 architecture code sets a global flag to support implementation of
> resctrl_arch_mon_capable() but the upcoming change to enumerate AET
> (Application Energy Telemetry) features on each mount introduces a new
> corner case.
> 
> Specifically when AET is the only monitoring feature, loading and
> unloading the pmt_telemetry module between resctrl mounts may result
> in monitoring support enabled on some mounts, but not on others.
> 
> Replace the global flag with a scan of resources to check if any are
> marked mon_capable.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v10:
> 	Move declaration of resctrl_arch_mon_capable() to <linux/resctrl.h>
> 	and provide kerneldoc comment on usage.
> 
>  include/linux/arm_mpam.h              |  1 -
>  include/linux/resctrl.h               | 17 +++++++++++++++++
>  arch/x86/include/asm/resctrl.h        |  6 ------
>  arch/x86/kernel/cpu/resctrl/core.c    | 19 ++++++++++++++++---
>  arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------

Note that this patch changes MPAM, resctrl fs, as well as x86 while
the subject prefix just mentions x86.

>  5 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index f92a36187a52..b6e8683657c0 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -51,7 +51,6 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
>  #endif
>  
>  bool resctrl_arch_alloc_capable(void);
> -bool resctrl_arch_mon_capable(void);
>  
>  void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index a184500745f8..59ddedb27539 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -419,6 +419,23 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> +/**
> + * resctrl_arch_mon_capable() - Report whether monitor events are enabled
> + *
> + * Some monitor events may be enumerated or implemented in loadable modules.
> + * This means that available events may vary from one mount of the resctrl
> + * file system to another. If modules are not loaded at mount time there
> + * may be no monitor events at all.

I do not see how this is relevant to the API documentation. Please just focus on
the contract between resctrl fs and architecture. Looks like this is information that
can be provided in the x86 implementation of this callback. It is not guidance to
all architectures.

> + *
> + * File system code may call it during mount after architecture enumeration is

There cannot be any "may". This needs to be a contract where it is clear to
architecture when resctrl fs can be expected to call this and what the expected
return should be. For example, resctrl fs calls this during a mount cycle and
architecture has to provide the same value during the entire mount cycle.

> + * complete. Calls during domain add/remove operations must check resctrl_mounted

Not possible. resctrl_mounted is internal to resctrl fs so architecture has no
insight into this. The guidance to "must check" is not useful, as in, what should
be checked for? That it is mounted, that it is not mounted? How does domain
add/remove apply here?

> + * before calling.
> + *
> + * Return:
> + * true if any monitor events are enabled in the current mount cycle.
> + */
> +bool resctrl_arch_mon_capable(void);
> +
>  /**
>   * resctrl_enable_mon_event() - Enable monitoring event
>   * @eventid:	ID of the event
Reinette


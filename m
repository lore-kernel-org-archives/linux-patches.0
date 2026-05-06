Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02733CC9E9
	for <patches@lists.linux.dev>; Wed,  6 May 2026 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778109310; cv=fail; b=bICDATlnx4+XVAaXMPs1+KxxTZEZhmo76eNU5hTn7ILQGkhcWKuYURf+n/g2pHMgoQgxkVU3eqXXIgEVqu4dZFGu0hUJw0LnxEmU5+QZG4iJZ4ds2aX8mlfnhcWuxVGjwA/1bN6udiV4tYWFWfKWz27M/IQRkaJVm/CHQeK1ijA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778109310; c=relaxed/simple;
	bh=sCWMxHXq8ZH/5qJppw/dTPV/3QA3NB8ntNhFswdCKw4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jIPffIXzoc1cbG+0YWczM878Y0/QHtoM8c+cCFHhDX3NYA1VsHSe23ubLsgtfWLGvjfDqLfycERpIzPa7jDZ6BgWZkRRtjp4NIEnne5A7DZlmDM7CuQlPCxkhGbjArPZ8fovVvh6NoB8JKORFF3/2mH38/erlmBUEXktxtcxCRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LrttNF48; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrttNF48"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778109306; x=1809645306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sCWMxHXq8ZH/5qJppw/dTPV/3QA3NB8ntNhFswdCKw4=;
  b=LrttNF48G56WtneiLmtrLx+mBM303Ap+cLdgA+5S9kR01Hi8qa5Fhg1Z
   1BTY7N4PkMMqxKufiPSIE3GkwevY23VTO8x3CVkwkLqvbwhhlZ/O0OHI/
   nBLdDmvYy5X+yPrl+1V8XEdMcyYVa1YmSYXD/rHRrxc0whumK0zh9axxe
   aoKYd5NI4u/Sw3PdYyYHIBGrhi52BIrGU048fPOsonC/Hk6rrtABhRZsf
   aNWkYWMaQq/oI5b3B4sHjbznbHXYxrlBz+yHuHB7NLRQGgMC1EzhWl8n3
   GZXn2hCJ/3VuYePrHcSfCHYH626ivGduF3w11Iwo966E8uAHS3QxO0rGk
   Q==;
X-CSE-ConnectionGUID: KunZzap9TdyivtZ3OEy3VA==
X-CSE-MsgGUID: dXeLVXAjRNiE3/WNEMsFFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="81620376"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="81620376"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 16:15:05 -0700
X-CSE-ConnectionGUID: O6GpH7yeQqapK6KvDRJg0Q==
X-CSE-MsgGUID: L4EGsppxTD28KJh+wA/nQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="240620002"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 16:15:05 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 16:15:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 16:15:04 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 16:15:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4xY/jlaNPeaZ8LGcoLTL5NrCf1XJSntBUmR7j5QLR6kJrm5eMrlLVG9ptzaJP9hcjuGUdpDG4lVcVTZ9+4IMn7tdenOh/TClI7+kMvJu09rpJQ81fGwKZd8DCjkoK93sylsBwWsQk44tTPjyiATRFPvWue4QfZmv5o5gYHI9p69wZCM2I4FCaboa4WUaUaEjzAwHW2Jto8/S3Us50wbUgbObUVeYywQHSkw3lByuqrR+Q8cokDsqt+0ggzcmmktB1q03LA/YJ+maHHcgHnDY8tIiCanh/UJRDNKjqMexdShqEEMcG/ilJDW5AKBh0P/q4ep+u4ZSt/vsXYNepfAFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCWMxHXq8ZH/5qJppw/dTPV/3QA3NB8ntNhFswdCKw4=;
 b=TizaXQIC0cRKUAV6BjmcafsNJpbCnCT52oqIx/43+DOD58DvdkOSDdxLHD00hD+vSsWqtQhd88MxfP2MNPrhgx8lwCGPFppVDdhQRY0Bz3YyiQlf3yczjJFf0J4JlpT/+6j/k4uV8UB063ZM0EziFJJgEb3QzsqDklOfgyXrLz0O52zAR6vDdn1ixfXDY+CSsDOy568bBp0GiiwCijNFWc1lTfLAzlg+g+6L0gGfsuICA7TzBN3rgD2+7oRN0ixp2ue20Yns8XIpYv+0uY0xZuQ7StHl3OqWR6/ylwJ+mYUfsf25xpWQh7qkk3MTOcdRLVup72kUSymwlQTQmwe4OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB8493.namprd11.prod.outlook.com (2603:10b6:610:1bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 23:14:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 23:14:58 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, Fenghua
 Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Topic: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Index: AQHc2bKUdc4/WN+WbUyjxuEkqyLnwrX9/UIAgACARQCAAGFyAIAAytUAgABOY4CAABxYAIABQzoAgAAXkYCAACCHAIAABacQgAAGVICAAAhrUA==
Date: Wed, 6 May 2026 23:14:58 +0000
Message-ID: <SJ1PR11MB608396D4D57AD6C1E079A4B7FC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
 <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
 <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <198e6dc2-b57e-4117-a71f-5c3983da3ed8@intel.com>
In-Reply-To: <198e6dc2-b57e-4117-a71f-5c3983da3ed8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CH3PR11MB8493:EE_
x-ms-office365-filtering-correlation-id: a085fb41-1c4d-4b78-2562-08deabc54aa8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info: moVMxpvfMBjlL037jWnSeyOCKVieZ9LiIdupMxOcXUxT/Q9gZum7vOoSZSDY8Cg0N/7F8LqCXhvqR7rxvc9us6bG4g1wyroiarJzJ8j7G/sDNOHjXW/EV4E8EB9sy5qOok3wHKt/4LiDbZskmBXlZC9drxq0VBCOe2djAn/ZrNa1cMEmq4IvzxIezDR64po5eyDqHyLE0PAiAzpUv56SKiUPj/uPadoNA/+/VejS3jjZaYpu+Pfx9FWuTIts5Y5wADvHaBILHIlnpeZvwigZHSUUG6E97+bqXLswV2wyuinH+9qS13xM0hTgsKmQBOV6A9mpssebdAN5hZ5aPFCmSX2VsgjbAwo7Ez3/FJrwL3FvIiwjBA5MaXgo1TvgJW/zgIaKeXQzk3qT3/aZKhSuhxLMF78LVpJzpgok+G0/8corQliOEocQGNi/LV3IqE66C2JiqAiwAvaXN0PzlRglWQzdofvkX/8iURViHu+G2OJ8nwICR99tGAZYYpnLtX7cHKkBfNfGtWPXJP2k7zqyTa12vhJ3qLOdlYwUKT60cLwgYRdhN/+OeUyM/yLvRBRIpUsxxADx4egLSPj23YVZZFGA6ymKxt+x0gYhBUY8VsceL7lqnJD2auNgHawbpGuiY7gPOy3zqijxq/+FR3RuusEaudMEGQOjfjdzZ2ou00NFIAA4zrzWCXeRmPB58aW4n+2JvlxMfVLCs/fUoy7CSNLL1Zhx4NETXTmMvJ70jCeHskmSeRA7Bf8Uo9M/BJ/f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDdDV1pLZ3l4aHJYaW1BR1RaeUFsUlA3ZUFkYlpHVnJYLzRBeXp4WDczYVFw?=
 =?utf-8?B?TnhzSlNSZFpyUTRLZ3VSYjNZNEJYcnFDRzBza3dvRFI0Y0hubDhKMjRFRUwy?=
 =?utf-8?B?cEUvTjkyaDV1a1FnV0dBZjFPTWxVSjhUTFdFcDhWMHI4Sk04UE41cTUyZDRN?=
 =?utf-8?B?ZFoxWHhSL1FJdERta0tUcUdMcDR6SkRXN1ErUS9JZmxQcVE4WTJpZHpMUzUw?=
 =?utf-8?B?c0laMnZrdUdJNngzYXNmMU1GNlRvbWc5V3JQWUoraVZXRnVrNkV2dGN4TGJC?=
 =?utf-8?B?ckJKNTJjQ0VhZkhhMEJnRktoVmhiM3pFNWNTdHhhaUptclJ5Y21RdmN1OXpH?=
 =?utf-8?B?RG1HcXIrOUJoRHBjb3F6bXpKU1BmaDZqMFczOGR5aFNkSE1IRWMxUFYzQ210?=
 =?utf-8?B?RFVkYkNRV2VhRklhUnl4QmQ0NU1reHR6NHFRUUV6VGRMeWJzdnU1ZU91cUZs?=
 =?utf-8?B?L05rWElHZTUrcjZ1bHBKR2xLZUNzYTVPS2lwOFVFeGV1ekZxc2UrbzJkMWQr?=
 =?utf-8?B?M3NWK1dRWkU5dk41SWZvTGZDclV2MnE1SUg2OXNLNnU5NUVuR3MvSWo4MjZ1?=
 =?utf-8?B?Yk1HQVFkMGVtdVQwek11cm1xTTRqdEdIelF2TFF1eGV6L1A2TVI5WGZOY2JT?=
 =?utf-8?B?elVrbXdVOUpIa2t6VHVhaURrQXJxcTNMWE9mMkZGQVZ1bC9lTGtMY09uU0VV?=
 =?utf-8?B?RWVHNVVobGoyVm9hak5ZTloxNmR6Sk9OMkRYa2RiTm9pUnM1REZaOE0raTBh?=
 =?utf-8?B?b3dkSDdTSk9qU3Y4ZW1pcHY1eWRHTXA5Z1dJcUFQZTE1MUZ3MGpMdlFpdXVG?=
 =?utf-8?B?OHlvYkZzNCs4QW5vOVo4WU5oRkVmeFp6U3k0WDZpL0ZaUmtNUDNkSXNoZElF?=
 =?utf-8?B?L01heGMyeSsxMTNOaHJUcC9WUGZ6S0lKK0xqZ2RYaXhaSlAzOG1vRVB4bTZO?=
 =?utf-8?B?SEVBSzVXcUdhWC9RdXVZckF3cUoyZzJnUGN4VlpFS05KdnRxMnpDY2t4TGJU?=
 =?utf-8?B?cUkvVHIxd1RNNDBnb3Z2clJkWUFrdTRzNkFUUnFVQVlsa0FBSlhQV0FpdjZo?=
 =?utf-8?B?OUZYQm5MbWVzQk1BRDRKNzJoRGFnQkFHbzYxYjFrVkMwSUFJeitrMjQrWEZU?=
 =?utf-8?B?RkxpNzVVVVYyeFdlZWszNjh4cU0zYWxtL1NqWVRBN2ZkQ3Vib0RtS1VTdndm?=
 =?utf-8?B?ZTFnaHZwZUdrcGdNaDY2eHd1Um8yL2xrY25OL3hSSllkQWlKRU5XVFRtcmFv?=
 =?utf-8?B?WDIzTWZnWlFFeEdkbFArdEp3RG9nZXgyTERSSE9EaU1zODFnY2JKUmd0N05Q?=
 =?utf-8?B?enB3SVFUNXpnbjN3eTRYQlRXQkhlRkF3RFdsYVhvZUV6RU5uL1lVK2N0b3NU?=
 =?utf-8?B?a2I2WXNBQnloNnl3N2U4U0hzTkZ4Ry9ML2FyRmMvVkJsb1I5ZUNjanYvcGcv?=
 =?utf-8?B?d0FsdElrYzlLcVN6OThCUUVxcEZQYU1pdzQvN213ek1zYzduRHkxMExGMU1B?=
 =?utf-8?B?Z0lMNkNQQjA0SDJCeEtUaUhldi9wR05WYmVnbEh0Q3h0LzUxNE92S0FnVW9t?=
 =?utf-8?B?ZTBtSjlLNVV1cytHOHlweWg1Rlg0QkJYcDJaS0srUmZBNmhobUc2dG9WeDRX?=
 =?utf-8?B?SmZjVkdIellOdXR5aXlhVWo2eW93VjN6U2JBVTlYbkZzV0NyQTU4TnZqbGts?=
 =?utf-8?B?UnZLbS9ZeXNhWm14cUpuRUJtWEhyS1ZYck5QcGk3bzFxUmsxaDl1d29taGtX?=
 =?utf-8?B?Y2ZuMzZ4TStNQ1BJRk95TWdkSHZ1dFM0VmZrUUN1aFpScytETWd4eG9iRG5i?=
 =?utf-8?B?Q241ZlRqWkRqTXIzVVN3YjlYS0ZhS0lsRWlKbC84V1ZnaWVRdSswUGhXVWE5?=
 =?utf-8?B?dTNFSDdMaEF4V0hBYTdDMm5ZdWlsYzhCeGsxRHZmR3F2WVF0TWNIUnVDaEh5?=
 =?utf-8?B?ZkhxM3lud3NRaHRKSUk4SDRSeEUzVFREZ2NiVnFMZ05yVWRrcjhHckZKVnV3?=
 =?utf-8?B?QUJUSHFDa3RnQ2VWZzBYV1djTURGanFwOHVtam11dXFwc2lmUHFWc1JTU2tD?=
 =?utf-8?B?MmJnbUEwQnM5TmtjNFhRT0ppdEhWSk1BK1dQR1VRN1pYTTNrUTBMRnFMamgx?=
 =?utf-8?B?V0FSM082cVNCMEEwSHJYVlF3amk0OGc1eFJ0N0xBNlF1cjZYLzZ6d2FBWHo5?=
 =?utf-8?B?RjZqV0FWcHAxWnZyL3Z3K2VIZzh3RXA2dksrNUt4NVdXOVJFdE5FbTgvb0JJ?=
 =?utf-8?B?bElJRUh1VFlXdVQ0KzZOcGRpV25HZ2JVbkh6MXc2eFNEeGVsMVRsMDYva2g4?=
 =?utf-8?Q?ZUyaZt4ESJqfxqmU1g?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ahc9oFq0qnzFO8Z+zECSv8XcTfCGj6aK64p+cMm1kOtIjwTGiC9JjBXOlrU+7YrvpjnXZua9QmfKEReOKM0VBeqrZnnYDH5bNJJPuyxpIIWW1yYKBcjCXXsFWYwn07IYDFGQT07hYO8jHFTRLCJDtfJzYfIANRqvY6fJa+YK/XiPkv5PlfJmQp/6P62KQdUKs3oTQNsF9QWbGJR0k5QOyFdb+J5Rbnta8kmcjUQpFXA1G9EbeBcGfI5Sc1jYQzCyqj5N61s7qO4Qi3qlRGok0kgHk9lkMbqOzg8nxYlmmRfgQvdpX3vNxRKw4kIRN2dUm166AT40Sgg/M+yvfTXwsA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a085fb41-1c4d-4b78-2562-08deabc54aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 23:14:58.2508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8U4f1Z0MvzlnDetF1wgrVzbsEEoEiD/ZAfemxZMvza0v57DOHMGRc143OXHrUcentjXuKZ2TEwGdrsoSkAuBdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8493
X-OriginatorOrg: intel.com

PiA+PiBVbnJlbGF0ZWQgdG8gdGhpcyBxdWVzdGlvbiBidXQgbWF5IGJlIHdvcnRoIGEgbWVudGlv
biBpbiB0aGUgZml4IGlzIHRoYXQgdGhpcyB3b3JrIGZvY3VzZXMNCj4gPj4gYW5kIGZpeGVzIHJl
c2N0cmwgdG8gbm90IGFjY2VzcyBmcmVlZCBtZW1vcnkgZnJvbSB0aGUgd29ya2VyIHNlbGYuIFRv
IGNvbXBsZW1lbnQgdGhpcyBpdCBtYXkNCj4gPj4gYmUgd29ydGh3aGlsZSB0byBoaWdobGlnaHQg
dGhhdCBpdCBpcyBzYWZlIGZvciB0aGUgd29ya19zdHJ1Y3Qgc2VsZiB0byBiZSBkZWxldGVkIHdo
aWxlIHRoZQ0KPiA+PiB3b3JrIGlzIHJ1bm5pbmcgKGJ1dCBibG9ja2VkIG9uIGNwdXNfcmVhZF9s
b2NrKCkpIGJhc2VkIG9uIHRoZSBmb2xsb3dpbmcgY29tbWVudCBmcm9tDQo+ID4+IGtlcm5lbC93
b3JrcXVldWUuYzpwcm9jZXNzX29uZV93b3JrKCk6DQo+ID4+ICJJdCBpcyBwZXJtaXNzaWJsZSB0
byBmcmVlIHRoZSBzdHJ1Y3Qgd29ya19zdHJ1Y3QgZnJvbSBpbnNpZGUgdGhlIGZ1bmN0aW9uIHRo
YXQgaXMgY2FsbGVkDQo+ID4+IGZyb20gaXQgLi4uIg0KPiA+DQo+ID4gU2NvcGUgaW5jcmVhc2Vk
IGZyb20ganVzdCB0aGUgdXNlLWFmdGVyLWZyZWUgd2hlbiB0aGUgZG9tYWluIHdhcyBkZWxldGVk
LiBUaGUgY2FzZQ0KPiA+IGZvciB0YWtpbmcgdGhlIGN1cnJlbnQgd29ya2VyIENQVSBvZmZsaW5l
IGRvZXNuJ3QgaW52b2x2ZSBhIHVzZS1hZnRlci1mcmVlLiBJdCBqdXN0IHJlc3VsdHMNCj4gPiBp
biBydW5uaW5nIHRoZSB3b3JraWVyIG9uIHRoZSB3cm9uZyBDUFUgZm9yIG9uZSBpdGVyYXRpb24u
DQo+ID4NCj4gPiBEZWxldGluZyB0aGUgd29ya19zdHJ1Y3QgaW5zaWRlIHRoZSBjYWxsZWQgZnVu
Y3Rpb24gaXMgZGlmZmVyZW50IGZyb20gc29tZSBhZ2VudCBkZWxldGluZw0KPiA+IHRoZSB3b3Jr
X3N0cnVjdCB3aGlsZSB0aGUgd29ya2VyIGlzIHJ1bm5pbmcuDQo+DQo+IFJpZ2h0LiBJIGludGVy
cHJldCB0aGlzIHRvIG1lYW4gdGhhdCBqdWRnaW5nIHRoZSBzYWZldHkgb2Ygd29ya19zdHJ1Y3Qg
cmVtb3ZhbCBzaG91bGQgY29uc2lkZXIgbm90DQo+IG9ubHkgdGhlIHdvcmtxdWV1ZSBBUEkgaXRz
ZWxmIGJ1dCBhbHNvIGV4dGVybmFsIGFnZW50cyB0aGF0IG1heSBhY2Nlc3MgdGhlIHdvcmtfc3Ry
dWN0IGFmdGVyIGl0cw0KPiByZW1vdmFsLiBUaGUgY3VycmVudCBmaXggYWRkcmVzc2VzIGFjY2Vz
cyB0byByZW1vdmVkIHdvcmtfc3RydWN0IGZyb20gd2l0aGluIHdvcmtlciBpdHNlbGYgd2hpbGUg
SQ0KPiBpbnRlcnByZXQgdGhlIHdvcmtxdWV1ZSBBUEkgdG8gZ3VhcmFudGVlIHRoYXQgdGhlcmUg
d2lsbCBiZSBubyBhY2Nlc3MgdG8gd29ya19zdHJ1Y3QgZHVyaW5nIG9yDQo+IGFmdGVyIHdvcmtl
ciBleGVjdXRpb24uIFRoZSBmaXggdW5kZXIgZGV2ZWxvcG1lbnQgdGh1cyBtYWtlcyBpdCBwb3Nz
aWJsZSB0byBzYWZlbHkgcmVtb3ZlIHRoZQ0KPiBkb21haW4gZXZlbiBpZiBhIHdvcmtlciBiZWxv
bmdpbmcgdG8gaXQgaXMgZXhlY3V0aW5nIGFuZCBibG9ja2VkIG9uIGNwdXNfcmVhZF9sb2NrKCku
IERvIHlvdQ0KPiBzZWUgYW55IHJlbWFpbmluZyBpc3N1ZXMgaGVyZT8NCg0KT0suIEknbGwgYWRk
IHNvbWV0aGluZyB0byB0aGUgY29tbWl0IG1lc3NhZ2UuDQoNCkkgYXNrZWQgbXkgb3JpZ2luYWwg
QUkgYWJvdXQgdGhpcyBmaXguIEl0IGNsYWltZWQgdG8gZmluZCBwcm9ibGVtcyByZWxhdGluZyB0
byBrZXJuZWwgdXNpbmcgdGhlIHdvcmtfc3RydWN0DQphZnRlciByZXR1cm4gZnJvbSB0aGUgZnVu
Y3Rpb24uIFBhc3RpbmcgaW4gdGhhdCBjb21tZW50IHlvdSBnYXZlIG1lIGZyb20gcHJvY2Vzc19v
bmVfd29yaygpIGFib3V0DQppdCBiZWluZyBPSyB0byBmcmVlIHRoZSB3b3JrX3N0cnVjdCBtYWRl
IGl0IHJlY29uc2lkZXIgYW5kIHJldHJhY3QuDQoNCkFub3RoZXIgQUkgKHVzaW5nIGEgY29weSBv
ZiB0aGUgc2FzaGlrbyBydWxlcykgaGFzIGZvdW5kIGFuIGlzc3VlIHdpdGggb3VyIHJlbGlhbmNl
IG9uIGlzX3BlcmNwdV90aHJlYWQoKQ0KDQpUaGUgcHJvYmxlbSBpcyB0aGUgb3JkZXJpbmcgb2Yg
aG90cGx1ZyBjYWxsYmFja3MuDQoNCnJlc2N0cmxfYXJjaF9vZmZsaW5lX2NwdSgpIHJ1bnMgZWFy
bHkgYmVjYXVzZSBpdCBpcyBpbiB0aGUgQ1BVSFBfQVBfT05MSU5FX0RZTiBjbGFzcy4gQUkgY2xh
aW1zDQp0aGF0IGNwdXNfd3JpdGVfbG9jaygpIGlzIHJlbGVhc2VkIGFmdGVyIHJ1bm5pbmcgdGhp
cywgYnV0IGJlZm9yZSBydW5uaW5nIHdvcmtxdWV1ZV9vZmZsaW5lX2NwdSgpIGluIHRoZQ0KQ1BV
SFBfQVBfV09SS1FVRVVFX09OTElORSBjbGFzcy4NCg0KU28gb3VyIHdvcmtlciBtYXkgb2J0YWlu
IGNwdXNfcmVhZF9sb2NrKCkgYW5kIG5vdCB5ZXQgbG9zdCBpdHNfcGVyY3B1X3RocmVhZCgpIHN0
YXR1cy4NCg0KDQotVG9ueQ0K

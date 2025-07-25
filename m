Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD727253F35
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487371; cv=fail; b=XvsUw2nyOh9fJGmlAETOSdFpg1ck0CcEktIAgnHziS9F4H/A7i0E3CxhlfaV0Uo1KfD23q/h/kJQe1Wdqzl7NK1knZX8+tB5+I9Gpw9uo5avNbdv4x45nvzQvuFRBfJxbEiWKZzpHCqBCNy9fLEp2IomMfj0bg756xV3xDde8qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487371; c=relaxed/simple;
	bh=c1vSyE/xG1avLCnYo1wdSZtypnE96J+wVHELCTIHDtE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ABkth1QUdfA7xxUOl3ouE60frYaM83fbx6H8HmZ810Dz1R5jTFvHybtZxeDvnZJEGzjEt+iirymujdMkZlaaE2JaY0wLln8LZBWUG32NCL2ieUQaG7E/sIvJR5aJJCkL7+VKfsrUPbWdRcekQ404IICOCLaoIkQp2jSx6g1QLQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3dMzbZ9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3dMzbZ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487369; x=1785023369;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c1vSyE/xG1avLCnYo1wdSZtypnE96J+wVHELCTIHDtE=;
  b=Q3dMzbZ9s+1+c4gJiZOBDsAP/42fgInW2totbicTkORsxkZrbkwnKQgf
   oiY5xRfb0u3sG/wxYIfp+fniZk+qz1cw3nFpqYswxe28QfClBxXOlYETe
   MarzoodLVn8N6kha0o8Xc+tMo9Xk0MXLstX5O0qrvwn4QmBYBr9IJsPgO
   v8pjS9n+//ackS6ppui+ewm1U3Z9V2X9ZI6Vwqzwtir7JaT6U2gcaZPy5
   GtQuVOrAs2iJeSVeG7wvqSbthDTQhwbsK8PYJCs/54fSIHfJPgukLdFfG
   cBJWSTg0O+RjInTg5DEyceTVaDT2YEATnHgGIw9WVigwu1ww+fe/ldlGs
   g==;
X-CSE-ConnectionGUID: WQwwoPYGSESOgFq65Q8j9Q==
X-CSE-MsgGUID: eLzCIjsUT2ScoJDDDYLhmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="59628448"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="59628448"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:49:28 -0700
X-CSE-ConnectionGUID: vriulbNoRka3zlbyhos2JQ==
X-CSE-MsgGUID: SpbmPla/RQeeNWDjcvNkiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160400772"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:49:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:49:27 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:49:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:49:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FiuRLwuZAvvFT3O2lfyVel01o28OFZBGZK4XCW2aso8tdL0e9VgP/oLqs0drIBrn2yya7AIViYh6pBOuCbaEcBwZKqGBjcFQxIdPd3UX+sDFTvPrydXlb5liDKkWGRvlysZoGjljG9MFvtLLXqOY5wvWw5U+1yNiQoHqj7qjaP0XAqWmQb8XEt5lwRZlCU2KIqe0FZOWOKkrmAf/bOz8reiz3zpoY8WODk90l5RXAhf/x/u6z9qALscoTnBUfnrvA9Hs+IZ5et5YGjRTRpwAt1n6F7auAmFvwp97ufVOz55o9OdKpO1Qx6Px+6Kg2s5YsUot4whveeNmtioixwuBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7WPQd3YlmQXkpS0PrxdHNGjvfMYC1BJcYOrLgarsn0=;
 b=qOfazqDRAuWKVZXO7Tn8Uz38FLIg81Tg23TAGXWXDkK6JyRI+XcX9HFyJ7Sqv+Cfx/6EA8iWky1mYxJzqxiiB3cEg+tvzzyzi/pHKz4iKGC1uVxFU2s07OTVuLKf+gdiV8wMwq+burMZ8ezXEiLmFcM80G34TmeY2hBKLBoHiOIdrW6Dnida/OYt0omTsq75xk8KRXshnA2jqj9sznnpDBXFq54yKt0Hg0d4ItdLtATgThnspHigJaLzDJXLbutMhjPIrqTC4defGvro22b9owXgl/GIJh7IDKMKzNmiZ4tLXMqnbQlsUWDnpFOaCEP66XLy2vYB+4MIUAmKa1vXtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 23:49:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:49:24 +0000
Message-ID: <13b4d47f-ad57-4df0-be98-2b54b844d5db@intel.com>
Date: Fri, 25 Jul 2025 16:49:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 25/31] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0280.namprd04.prod.outlook.com
 (2603:10b6:303:89::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: affb5243-b68f-48d7-189e-08ddcbd5e1bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0ZNbHFYZkQyMkdYSFVXK1dJTEZaTDM0WVB0Z2dVR1J2VUR1MUpxL1FFY3Bx?=
 =?utf-8?B?ZXRQOUJadTF4V0Q5U3lONHZaWUU1amN5blErbG1odFBaTVdoNk1na2ZWcnRR?=
 =?utf-8?B?T3NielVpclBHclVEd0xkRXBXQUtvay94TXJIZVp0OWRpenZnV3ZMeUpMdWk0?=
 =?utf-8?B?eml6N0RIdTY3OEpFbXhNYVFkRjRlN3N0ODc2M0JJU3N2emFHZDIxYjF0Mlhv?=
 =?utf-8?B?UENSazNXMWl6SktEbDM0STdldmJ4T3VZOHI3QnY3VFMwb2I2ckVmT2M2SW1I?=
 =?utf-8?B?b0d4TTlIdWhCSFpJMGhuWDN4Zk11UXJwTmFZK3Nja3Fqdmo0WUtmVm4vR1NQ?=
 =?utf-8?B?cDhhSDVFdGpLTE1tU04ySEhZQ3lmWDBQenpMWWJFeENRYmRqTHBYSXI5VXNn?=
 =?utf-8?B?RWdxeWVCcGRwOTkveklxajE0M0RjY3hQclJaTGp6NFYvaEZxaDVkbW1UK1ov?=
 =?utf-8?B?Z0o5SEU1RXpUV3pFTklYeVV1bXJsTGxBR0FjOUJ6QytXZDdCT3Ewb1BWc2hH?=
 =?utf-8?B?ZHlqQ0tXV29Dd3N6bmszbjEvams1eGUyOGloaGFBMmRwL0RpRVBkSmhrU0ZX?=
 =?utf-8?B?b1d4dzQ1WC96OGtwbEZVMHhSQW9lRDhyaU12L0VLcUlsQmxIeUZGU1BLMVA2?=
 =?utf-8?B?RFlOZHJYYkcvOVZJUHl4ZHhIUW9aZDhoR1RiWUxvT3RydkVCeWdJa3BjdVo4?=
 =?utf-8?B?UkJCL1RneTdQTnpmSERxbEtuMEhnK2xEb000VEtXM1RpeC9PWDVKSmFlVi9u?=
 =?utf-8?B?UmZyMm9BejZaSHpEUWZCOTdibndJK29NRUhPMXFuNkRWVXl6Mzk0eWJLNEVa?=
 =?utf-8?B?S3M5RjFKbDN6bFpNeDh1TEtyVmFvRHJvbXJtK2xUUmxJVDlaQzdQS0tRanlV?=
 =?utf-8?B?c0E0citFeWpOR3BRd0FsS09TUllvVXdnZWRCS0RORGdKUkJzNjBCa2xPZUdW?=
 =?utf-8?B?N2tmbUwrVEFUZEtXMVdsRmdBYXFqckZMZVNobjR0SlE0cjdySHRGb2NpS2tK?=
 =?utf-8?B?TS9WNElCb0ZCOG5xVDZ6KzIyNUVsdm5RUDF0TXRoamRCYWdKcWVBZUhpZjdP?=
 =?utf-8?B?dlAxUm1zSmExU1J4VXFyL3ZRRWlzUzNRMjVjTjFzeTNNVHdwQ1BibHhLV216?=
 =?utf-8?B?VUNjNEwxZW9PVFVuWFk4Mm90dkVpME00ZnlTRGt2eGc1NE5IYmI5emg4a3Z1?=
 =?utf-8?B?WnlITUdRV2EvU3Rjb21VcGV4cDMzNGVoY3dDM3oyREkzcklZanE3NlVLWk9H?=
 =?utf-8?B?YkE2Z0p0SCtPcnQ0NzNrOG83YUEzalFkZlExMFMrYUFNSHVyL1Z1SUJlSCtF?=
 =?utf-8?B?Tm53OVNKTW5HUUQzQ0xXU0Y5WTVXR1V2Q0pPVXNiWjBUVENaS1UxWmhYTldZ?=
 =?utf-8?B?Y3dRYnBJdFluSC9PaEFjbUpLSHZuMVUvM01kZmU3T2gwTmoza3FrR1diWGky?=
 =?utf-8?B?ck03anFrRnpQZ3VWZTZmdXRoOXE1TjI5K1RTQUNhbGREVmVFVFpaWFVKTUlj?=
 =?utf-8?B?Q1V4SWZLZ1hMYUUxQ3BDM3ZNbXA3RDFWZXhXYndrTXBUaWZYTWQ0NlpoblZj?=
 =?utf-8?B?eG9Fd0RadEV6N1h4b3FQLytJUFdTNEtTZG1qS1NVbWlzMStYN1E4SnNiaVBv?=
 =?utf-8?B?SWxIaHJsdklmYWFqSHhBcUhGTTZxTUIralJEWWRyUTlieU4xNlN1YVVXT3FZ?=
 =?utf-8?B?T3dxUithb3E0YXY4L01tYnFnZW0yeDhNT1p3a2ZmWXlnSTZkTExoV2Nldm1H?=
 =?utf-8?B?U3hiRHY1TVBrMzZ4M2FPakx6aUZrajgwd25NOHAwQ3M1ajFIblBGQUNkTkxX?=
 =?utf-8?B?a0NIM0kyQ2tNcWlha0FrZ05ONEp2eW8wK1dqdWw4NkpsWXgwUXlpcm9GZXFi?=
 =?utf-8?B?Unp1VnVza0doaUF5SGliWXEyUktOK1QwZXFtdnRQY3hGaEN6cVNFZ0RZeHhR?=
 =?utf-8?Q?T+Ua3UMfjlU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG13LzJvWFlGUC8yU2RtQ1JRb1ZHN3lkdGhOVzVlUm5RdEhrazc4ZHVuaVZs?=
 =?utf-8?B?Wkh0VU5hZUlrWnNkSjhkamtWU2p5SnFuTWEyRlFxV2I3a25hcVluWCtPV1lo?=
 =?utf-8?B?bWVueVFuZG9SeHhQc01FQm5Ed1BzZTM1djdjcVhjYWFISysyblpzQjhKdUVt?=
 =?utf-8?B?QTVCKzRCT3RCZ0V1OThuK2RiWDg2L2ZudUMyT1JrSVNjMVFhMGgxNnR2YTNu?=
 =?utf-8?B?WkxvL3N5MW9oUEJMbHNjWWtCYUp4RUZsT29GQkh2aXFJMko1RDVQSnV1ejlY?=
 =?utf-8?B?aExpcnlJQ3FQUVRTUStuN1Y3SFlrbUp1MVNZcWJMUS9Jek94Vk45NjRRWnlV?=
 =?utf-8?B?b3dRUlZ6UXI2dnZDM3RtWEU4aVFrRWVLQUNhZnkrakI0ZlI2aFlpTGJSSlpt?=
 =?utf-8?B?M25yVGtuQmJVN0JLNFJSQTJ2N2NjVFRYMzJjQkVuVkFrUXZUdVZBakFjUG01?=
 =?utf-8?B?a1JFdWhpaUpZV3Q1SVFzMHlteW1yVkVzMFA0dWNoYUhDUGxBVmdwV3VHRUYy?=
 =?utf-8?B?REI3Zi9vSzF1WTQrVTRIRXdWWlZDeUhWMlBKUkNIY2MrS0F0SEdpZ0d4ZUtL?=
 =?utf-8?B?bU1oTzVKdjY3ZDhkcDZNTUtlc0FXSGRFSGNpZmlERkl1WmhRRjFEUUhKbERo?=
 =?utf-8?B?MWFUS1d4eWN4aEkrREUrTkdFb1NkVEFDZ2tCTmU2SGlqUmwxcjhrbDQrVVdY?=
 =?utf-8?B?THB6WjA2ZU5XU25JSTJ5bmIwbU1UZHdrd3h4elNtcU5BM2lzL1p5RDJCRU5G?=
 =?utf-8?B?TDhNY21qZmRwMjR4SjFzbStST3R4Z1VtS25XTU1rb3ZsTW01UGNXZXFRVTFS?=
 =?utf-8?B?M0x3dlZadG05UXcyTFFyRTNsb1h5cWVXSjk2bUszUENiNERhM1gyWUtYdlhB?=
 =?utf-8?B?ays4NGtkQkJJcFRIUVMyZ3piKy84cG5YT2x1L0tTRENjcXM4Q2pSeUNaZ0hx?=
 =?utf-8?B?bzFldzRXaXBGcDR5aTVmRnNBVENZekl3SThSdHZ6QzJGbEhydm0yYzFtZmZl?=
 =?utf-8?B?YnlmVVd0QmMxOXBySThIV0NtZ2RJMXFvZFhVcFlZOWtFNWhLbFNndjhsRDEw?=
 =?utf-8?B?K21USTcwMGpmWm52VmJvZ0MrRVg0Y1FHQ0pyeUt6bDNkanVySnhqeUc2K2pS?=
 =?utf-8?B?RUw1ZnJjTGd5UFRNVmhqRjJmWG94WmhtaEhURml3MXN4LzhkMFI0S3NNcU82?=
 =?utf-8?B?Q0VDc25TejhEZjIrUk8welMxaGhMNExYSkVKQXAwMDRkbUZIaE90TUNEK0dm?=
 =?utf-8?B?ZGZKeHF4TnVQdnpyRGRqTlNvWWFYWGczWmxqWGtDTXlQdHpiMWlSZUlpTWdX?=
 =?utf-8?B?aFMwZlpUVHpjenVCSXg1elpVc0sxOUllOWlFUzVGUCtZY290YU1kTlp6MjZK?=
 =?utf-8?B?OXlPL3Q0ZzlXaHQ5TGVIcUJlMGFKV3AwdEtxbFc1aXUrM3RyTEgwclJ4b0JB?=
 =?utf-8?B?b1BCeVNmTlNQTGl0NWg3US9CUmdELzdOWURFc001anMyMnZTRTcvRFNCUHNs?=
 =?utf-8?B?eG8ycG5hWVM3cGNiY1B4UmNtbjVUYTR5Um40cGZwNkk3amVtWFJLNUxubkFV?=
 =?utf-8?B?MVZKOXovTUllRVBqZnhNYTgzWG12RS9vRjRBYzU0NDlncGZwYTdzS2lMMHRH?=
 =?utf-8?B?QmFZeHVxeVZucnc2MlZEQnVkRkF4VDgxZHlnVk1RZEo4dVdvMHdMSkxKZ1Ev?=
 =?utf-8?B?Q0lFbnFKa0ZBaGQxRUF5emdLVVdRbjNBUnBpQ2w5emNvYWFvQ2FIdXh1ZkdN?=
 =?utf-8?B?NHYySDhYUEo5R3QwZ3krblBRZ2lpcnhtT3d4WCswMGhxTEtBYlFFNzR1L2hm?=
 =?utf-8?B?YmdvUmhsZU54RjFQQkhXZDA4a1hUa3l0THBsZ3BWOHNHMlE4RFNjdFdWTGtt?=
 =?utf-8?B?YmRVUnpDdHhnUEZzeEhoL3ZNaDRacGtPS0wzT2xGWHQrZFg2UnlFVjgxL25u?=
 =?utf-8?B?V2w3dEhiUXRCcjhTYVhSWEFicWxUY1lJdjVSdmpjY0ltM3o5NXdTOXJ1R1lz?=
 =?utf-8?B?c0p3ZjZqcklSajJwa3BaNEQwM29LcG9UR01oRjkxVlZrbmJBR3d2R1FOcEE5?=
 =?utf-8?B?L2xIR3g3Y00ydzRhT0lFT2QzaG1EcmZvOVo2QWlyQ3RVaEExVFIyWXE2dGRn?=
 =?utf-8?B?SXJUNld4L1dCTWF5aklHYzM1SVN4eWRmQ0hYanRmRkpaSTRXU0pUWlpxZVFJ?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: affb5243-b68f-48d7-189e-08ddcbd5e1bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:49:23.3877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YySV0TlGV4nv3bEXetBWlOCYpg6uO5pKcKUSDtuWcwctxeiBC7KgsngZ5iBrLwLtCBtiZvJqWclF+xwqdfKrtYoXPyIHm2TNmNbJBTZ184=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids. This will be overwritten with a lower
> value if hardware does not support all these registers at the
> same time (see next case).
> 
> 3) The number of "h/w counters" (this isn't a strictly accurate

"h/w" -> hardware (throughout please)

> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "h/w counter" to track all RMIDs are
> difficult for users to use, since the system may reassign "h/w counters"
> at any time. This means that users cannot reliably collect two consecutive
> event counts to compute the rate at which events are occurring.

Based on definitions in (1), (2), (3) I interpret above paragraph to mean that
event groups with insufficient hardware counters, thus when 
"telemetry_region::num_rmids < event_group::num_rmids", are hard to use. 

> Add a variable rdt_num_system_rmids which holds the number of RMIDs
> supported by the system (including adjustments if Sub-NUMA Cluster
> mode is enabled).

I asked in v6 why rdt_num_system_rmids is necessary but that was not answered
so here we are again. It still is not clear how this fits in.

> 
> Use rdt_set_feature_disabled() to mark such under-resourced event groups
> as unusable.  Note that the rdt_options[] structure must now be writable

So an "under resourced event group" is one that does not have sufficient
hardware counters, aka telemetry_region::num_rmids, right?

> at run-time.  The request to disable will be overridden if the user
> explicitly requests to enable using the "rdt=" Linux boot argument.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values as this
> value will be used later to compare against the number of RMIDs
> supported by other resources.

... and that "later" is the spot where the max RMID that can be loaded into
IA32_PQR_ASSOC will be taken into account.

> 
> N.B. Changed type of rdt_resource::num_rmid to u32 to match, and
> print as unsigned value in rdt_num_rmids_show().

Only if rdt_num_system_rmids is really needed but even then  
resctrl_arch_system_num_rmid_idx() already exists and returns a u32.


> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h  |  4 +++
>  arch/x86/kernel/cpu/resctrl/core.c      | 18 ++++++++++++-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 36 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
>  fs/resctrl/rdtgroup.c                   |  2 +-
>  6 files changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index da76e9c37b69..74cd2979549b 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -288,7 +288,7 @@ struct rdt_resource {
>  	int			rid;
>  	bool			alloc_capable;
>  	bool			mon_capable;
> -	int			num_rmid;
> +	u32			num_rmid;
>  	enum resctrl_scope	ctrl_scope;
>  	enum resctrl_scope	mon_scope;
>  	struct resctrl_cache	cache;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 83166dd0b9c8..a6c41068dc2f 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -18,6 +18,8 @@
>  
>  #define RMID_VAL_UNAVAIL		BIT_ULL(62)
>  
> +extern u32 rdt_num_system_rmids;
> +
>  /*
>   * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
>   * data to be returned. The counter width is discovered from the hardware
> @@ -171,6 +173,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
>  bool rdt_is_feature_enabled(char *option);
>  
> +void rdt_set_feature_disabled(char *name);
> +
>  #ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 83e046313600..31fb598482bf 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -807,7 +807,7 @@ struct rdt_options {
>  	bool	force_off, force_on;
>  };
>  
> -static struct rdt_options rdt_options[]  __ro_after_init = {
> +static struct rdt_options rdt_options[] = {
>  	RDT_OPT(RDT_FLAG_CMT,	    "cmt",	X86_FEATURE_CQM_OCCUP_LLC),
>  	RDT_OPT(RDT_FLAG_MBM_TOTAL, "mbmtotal", X86_FEATURE_CQM_MBM_TOTAL),
>  	RDT_OPT(RDT_FLAG_MBM_LOCAL, "mbmlocal", X86_FEATURE_CQM_MBM_LOCAL),
> @@ -869,6 +869,22 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/*
> + * Can be called during feature enumeration if sanity check of
> + * a features parameters indicates problems with the feature.

"features" -> "feature's"

> + */
> +void rdt_set_feature_disabled(char *name)
> +{
> +	struct rdt_options *o;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name)) {
> +			o->force_off = true;
> +			return;
> +		}
> +	}
> +}
> +
>  /*
>   * Hardware features that do not have X86_FEATURE_* bits.
>   * There is no "hardware does not support this at all" case.
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index e64a4630e95c..6958efbf7e81 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -56,6 +57,9 @@ struct pmt_event {
>   * @list:		List of active event groups.
>   * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards
> + *			if enumeration from intel_pmt_get_regions_by_feature() indicates
> + *			fewer RMIDs can be tracked simultaneously.

ok ... still matches changelog by confirming "downward adjustment" is based on telemetry
region data ...

>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -69,6 +73,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;
>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -86,6 +91,7 @@ static LIST_HEAD(active_event_groups);
>  static struct event_group energy_0x26696143 = {
>  	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts				= {
> @@ -101,6 +107,7 @@ static struct event_group energy_0x26696143 = {
>  static struct event_group perf_0x26557651 = {
>  	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts				= {
> @@ -143,6 +150,22 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +static bool check_rmid_count(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +
> +		if (tr->num_rmids < rdt_num_system_rmids)

This is the unexpected check that seems to contradict everything described thus far.
Should this not be "tr->num_rmids < e->num_rmids"?

> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
>  {
>  	int num_pkgs = topology_max_packages();
> @@ -165,12 +188,18 @@ DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
>   */
>  static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	struct pkg_mmio_info **pkginfo __free(pkg_mmio_info) = NULL;
>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
>  	struct pkg_mmio_info *mmi;
>  	int num_pkgs;
>  
> +	/* Potentially disable feature if insufficient RMIDs */
> +	if (!check_rmid_count(e, p))
> +		rdt_set_feature_disabled(e->name);
> +
> +	/* User can override above disable from kernel command line */
>  	if (!rdt_is_feature_enabled(e->name))
>  		return -EINVAL;
>  
> @@ -182,6 +211,8 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  		if (skip_this_region(tr, e))
>  			continue;
>  
> +		e->num_rmids = min(e->num_rmids, tr->num_rmids);

This seems to confirm that the check_rmid_count() check should be against e->num_rmids.

> +
>  		if (!pkgcounts) {
>  			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  			if (!pkgcounts)
> @@ -228,6 +259,11 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);
>  	}
>  

Would this be "step 4" of discover_events()? If you started a "let's keep track of the
steps" then the expectation is that all steps will be tracked.

> +	if (r->num_rmid)
> +		r->num_rmid = min(r->num_rmid, e->num_rmids);
> +	else
> +		r->num_rmid = e->num_rmids;
> +
>  	return 0;
>  }
>  

Reinette

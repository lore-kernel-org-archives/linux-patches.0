Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126A93314BC
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527155; cv=fail; b=jgfcAbHccVT5Jajh5GjUCI8sgKFe6dunKJQsk58+QYB0d1pxVdXDFPaxxzhx8QcU5sL8Gw6+aea8v/QNFR6hvdiqWSOmbnnD7j7ZraAhh1ccCsjfNPOa9pR/wKywgfU1VKmV691RunAth7nwdxqoUt35MBqhUVGiXwVS+6V4IlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527155; c=relaxed/simple;
	bh=8badDP6xf8OrtviL9oQSjBsTu/wXg0i7Negxt5TBuys=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QMYlZ/PL4kM/QdkDkR0rNCS6sNXVziB3Zoo4O7ZmVRNyd1fHIVDNcOkXQF13Zr1rFCWzyRq/fju+r5hSOgQewq2jxt6P4WDkt1sdXNolCfKM9IfXPXU9RcWBJexhr3/FiDnKuAhHR7vNpMsEoA4nV82tUbBiDhQ8iUpnIj5cSyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B5QTpLn/; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5QTpLn/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527154; x=1789063154;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8badDP6xf8OrtviL9oQSjBsTu/wXg0i7Negxt5TBuys=;
  b=B5QTpLn/YrOud3GAAxWdmH7pmvCizm6hFO/1x5zdB4g6WE0ru1Gcdxn8
   rHryKrd8GYd5DJS1qrIjoncKPtplsPOTthTS6Cl1q1vzPyS2ql11dtLjh
   nlCjR7rh9BxKcuiOujJS6Wp3vDCcWvEdXBYB6QEztuT7/maZN/EfHNSRN
   cN8KGFFMCbyOfQF1uozTabxVIomc8NbzLfIUYutjb2o63thuF7f4rghut
   IlnMjKz0plLE7/00sIWip6Oc9gtenPeoFMMmYjxg9Npo7eypgmR1P/kj3
   CUjPNPvzzqDfFs9R1yfcrITvz3zLsT0h6OXc15JNeVCZvYq6nSghnrM+J
   g==;
X-CSE-ConnectionGUID: mGnJth3pRIWa1V2Ekt4xPw==
X-CSE-MsgGUID: ft0jpN4OTMKM6TUH3PBtzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="85292620"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="85292620"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:59:14 -0700
X-CSE-ConnectionGUID: rE2JS7h1RN6CNeljhdJpDQ==
X-CSE-MsgGUID: wcHTobLBTd22EBsvCzZJUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="197144541"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:59:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:59:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:59:12 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SMuKKGqJ7gBGbITEmMabQ/+UIhZ50Jr6acU3yflnJQYw4K8qJHn7ujozwZH7190Xiw+Adpdt4lT6/oLFkz+JqG/WoSeud+7Q9Sntp61MG16IuJdSzDmQ86WDKXPaCbfuQiBwpx5+AelT0fv1/8cafh7UMm9iBfnsgMHQ959FKC+qghvH5OoyjxBk0Q6olHXjXirQ5xhbjdZ5J1BUm+acV5Ws+vrcPEtTJYOGbVz9h8ns4W/X0qcMaQtN7lIT67ikmDkhVW+nuTZQ2a5ScBFVVpJU3dGt8tPdmrrixlluoun1iZGR4vcqWGgk3e++zIm/NqZ+hZqoQsBXEw77rBoJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCMkCozfCdSH2wKXiazd38qAfY5NnbSJRV37LwGdWfQ=;
 b=O+d8Eon85sEqslGSU4S6FUcsWHGuOO/de01//qfkPqzDfmOPwApL2f8qujK/+ci/TaTHa5xKaq8GdgAfFRB69exYhcBvXTN2VBZxyV37GfHWH+TK9V4GnjPHYhvuGdKxN8Nf1h7WbwgtfvLzL7SHPIYhErDGVW1DyIfgmUJOpk3n+c3hOOZJU2iNgYhW6s+BTwk5JyGagjlsmukZXtSBHsQz5lO0S7WEG7gKkY2mlY8Y1GtD/gHjxyyvCx++RRSYzT+SwXmd+Yx2P4FNUvzlav0BUbNpsYEdIbWfDzljTy36DlWf24i0IM+8o33VHfIpFaTj9HzuYrqan+81Wqyl0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:59:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:59:03 +0000
Message-ID: <69d0b80e-cf48-4496-9df1-528bba1889e6@intel.com>
Date: Wed, 10 Sep 2025 10:59:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 30/31] x86/resctrl: Add debugfs files to show telemetry
 aggregator status
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-31-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-31-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:303:b4::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: e70d3a10-4f5f-4694-4fd5-08ddf093b9ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U3VRVm9oTDlJVzBhNUFBL1RmOHplRzc1TzJZYjA1Q0M0UThWdVNReWlIbzNF?=
 =?utf-8?B?Nm5kaTRMc1dUTmJldHdnMGN6Y1htTnlwTjNvTitnWHpURTV0dWtxbHdqamdt?=
 =?utf-8?B?QjdDTzJFRXd4OFBkdzF4WUd4U0FmTFBPUU5uTVFlWXFCOSsyVDZmUmh6ZkVC?=
 =?utf-8?B?WlpUNEhQbjlkMmV5VVQrVXdDSk1Ua3p2UWJHVjN6QXVvSlBhbEwzNllENkFm?=
 =?utf-8?B?NGRqTklZWEl6aEtDbW4ramxHc2Uxa1VoR1FVbEVpbktDN3lxNWJlaEs1WU9r?=
 =?utf-8?B?RlRlckRUZGtqQUhydUFBMTh1ZEV2ZkJMbE5pVlo2VEhleGora1FLUlZBdE1L?=
 =?utf-8?B?YjE5R2RCV21lVE9aK3hacml4akZGcWt2Ni90VWM1NDFjNE5rQ0NUS3VHQjQ0?=
 =?utf-8?B?aTVDblFhKzZZZEcyWCs4c2c1YjZUcEYrdGVlNEJNcCt5SEVHS2xtSExod1RU?=
 =?utf-8?B?cThwU0pEUDQzT3E3R0NDUmN0RjFOdkU5cDV4VStNUk9HYUgrUmZFN0hNQTBq?=
 =?utf-8?B?MjZTaUo3SzhVdUh0NjVoZjVhYmlQSTRpK2FFMG4yVi82ZGk5MUZlVmRmTEY0?=
 =?utf-8?B?YjRFTzJqM21JdTErcVFzbWh2aGM0L1JvZU12UXdjRmxHdHFaNFNsN3RYVWpO?=
 =?utf-8?B?dzNsTk5peHZ1SnltckE0OWd0YWRtdHVUTTZBeTJLN2lmRGRtamtXanVQRU9u?=
 =?utf-8?B?eWcyUTM3TEVHUnJnNWxBR2d1eGlxdU5ybU9yRkV6Mnpoc21DSTdEVGRPekhQ?=
 =?utf-8?B?UjVCd2wxb0hTQ3ZlM1h4N1RZaFFES0R2eUNCbjZ6RXJydUZLc0FhdW1CRW5K?=
 =?utf-8?B?bzJqVVNWUkIxZFdHZFB6VjZmRWNyb3RFTGh6Z2phaDFkTDhXNkE1Uy8yZ0ZJ?=
 =?utf-8?B?Q3Z0R1lWdUVadjlCU1l4YWowRHBNcVQ4YkJXQUlVWWdXVEV4c2NNMTZIaVB2?=
 =?utf-8?B?dkQ1VTRnZzA0WUlkK3dtczNaR2o3WXl6OXk3Y2V4YlhOb2o4bmI5R1NMTmRZ?=
 =?utf-8?B?YUhyZDB0QzRtVG54OFRGRDFjS2c4Y3NvOUlqYVY0U090dEMzTDA3cXdoaTVy?=
 =?utf-8?B?Vks5ajFvK2twTHhaM1owbUxVOXhFWFdocTdzbDVPaEJKTlVlVldzTHpWZXJl?=
 =?utf-8?B?UzBCSjdXYi9hNXZpbWhjOFFtTHNVRU5nUFRGNTkveFoxYUNHdTUzbGt0TFYz?=
 =?utf-8?B?c3U0dW9kR3VtRFgxWFhvZ1NKS041NHZVY0NaTmhyNWhHVEVmWGZNZExxK2Fk?=
 =?utf-8?B?VGYvSEtnY2dzUkVndUVnMklUWVdMakxjblZQT24yRC9GUFBRNjFKVDQ4QlRM?=
 =?utf-8?B?dFVhVTJyMER1bHlkV3RBZWtIR0ljR0U0UjVnQkNXczN6MlpQUEYyNlZyTExY?=
 =?utf-8?B?VFZQdFMxbnFJUW9ZUWwzVTI1THVGck5JSVRkM2N4WUJuQW5pZm8rMC9Fdmd2?=
 =?utf-8?B?R1hrQVRkNmc0NGVwYllhVkRHQi9nQzFneCtEbTlYcncxcy9Qa3o1VVI2WU4w?=
 =?utf-8?B?NlBVT0tVZ0liUndDWTViMVJyUGN1dWloMWtyakJJdG9LbXRKY1FEUE5pcldl?=
 =?utf-8?B?NjRRbTFpUXR0OW9VRkVBb2VhMXViYk5aR05RclJrdmtwV1RuSDBtaEtlc0Jl?=
 =?utf-8?B?K1ZzUnRJaWxpVnNMVk5DMVh1QnRBcnJHSlpZQnE4OVBSRWNVMHRvMkU5SGpv?=
 =?utf-8?B?YmZSZDluUXYxb0ZZOUpoSmthQzFnbXZSb2N5eVJaN1RuN2ZmVVBEc2VXZFcz?=
 =?utf-8?B?VnBlQlpUSDRVbm1hbWVzK2syekxTaU10Z0czWVFWVlo5b0o4ajk0Wk83dEdz?=
 =?utf-8?B?elJWL1Q2WlpmWnFNaG40MWxvNTloUUUyWUk0M0pjRDNWcnZxNzNnMkRBOEdR?=
 =?utf-8?B?L2tXc2w5WDVhNzhHUGxLek41Ty9ZbEFZa2ZZWGg2RWY4aUdKQ0E4YVduek9k?=
 =?utf-8?Q?86YsWfw7CmU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2hXUThhS0o3SVA0ck9LNW1KMi9HM0RIWVFCckdYdEFwWVlUb1pQNU54aFVq?=
 =?utf-8?B?NG1OOEIrZmhBZnkzcGQ5R3Jhb3RsN3cxdTR0aDVXVTRhOTRQbytsYkZTL2dn?=
 =?utf-8?B?Uk14bktWSU96VGg1MmpNWm5nVEViNmFJV3VZOVFCMktQdnpvMEJpQXpscWxH?=
 =?utf-8?B?NW1id2dRWmhPMkp0ekxIazBBQTVCcDdVYWhkdWk3eE55OVZXZjJpRXVPOE0z?=
 =?utf-8?B?YzUvTFRUZUZoNlc2ditKMmNtOGdTRnBWS3VBTXZOZDNDSFhySUd0OXlKZFBx?=
 =?utf-8?B?Zy84MTEvb2VxMnV3K1lkWm8rVWlMWmt6eVl6aDlMUk1iVU9GRlNUUHV0OHNP?=
 =?utf-8?B?TVNRemwvN044ZVM3Z1JZdTAxM0hPcW50Y29vek94NlQydUlXZ0l0NThKM25J?=
 =?utf-8?B?OStSRzNtVkx5OW1TVnFRY0g4Q056L29tZ2pVREFERmthSTBlMHJzZDdTWW1l?=
 =?utf-8?B?WGFTN1ZEMzh2YTBjazJOQ3kyYWQycER4R3N4eWZVUWZIcVpLK0lla3hVL3Bt?=
 =?utf-8?B?ODVWN3hiSFNmdldVd3RsejR5SkxuZE9jRERtVDFaOVhNeEFzNHlhQ2x3Nkd3?=
 =?utf-8?B?YkZkRmhtUkp3MVJCY0JYY2Y2eEFYUTFieStLQjVyVVRJNUZONytwT2RpbzVv?=
 =?utf-8?B?THlmeVBkN1poQ2xUdVBRNm0xVGsyMWgyTXQ1bU9MaEgzOVVKUUhrNW9MeFpI?=
 =?utf-8?B?WThmTFYyWmFlNWgvdzM1R2h0QzZPelNEYndSWWtiSW1OanpZMVZMOU1xUXJ1?=
 =?utf-8?B?ZkJ3ZkRkczh3aURGNlU4K255Ly9kR0RHUURPR0NJUUVxN2JNNVhTMTVraUcv?=
 =?utf-8?B?c2pDUUdoOG9DYUdySVhjcDhNOTRkQ2FNdlJxNk0vUWYzMWs4SW9SKzlnU1lD?=
 =?utf-8?B?a2d1b2F2UnBKSlBHTlJzVEpmNHJublJ5ZnEwcXJxYXp0QzhISGsxQ1h5QXpC?=
 =?utf-8?B?YmVIa3h3d0pYaGlRQnVwd2l3U2FHanpjLzhzcnBpd2M3ZGV3cWdtcFpBVTFQ?=
 =?utf-8?B?eGhPTjRQU2UxNXN4clp4OHdjdis2SzVFdlJrU2NwWXJtZ0dQK1dYWG00OWp4?=
 =?utf-8?B?Y3ROeUdrRVIxVm5WM3J2N0o1OVBwS054STVicE5JY1V5Kyt0bEhjeW1ZK0R4?=
 =?utf-8?B?NUJYVHFuUXpRSDVUc01leGRGVEk0WWl0RlFHUWFGMnpIWmc3ZXlBQ3BmVEls?=
 =?utf-8?B?aTJzWXp0Yk0xTVRkZ2VSVk10SXMxZ0gweUd6OHB1ZzIycUZ0RDRTSERNRzRi?=
 =?utf-8?B?OEp3SmVyT2Y3ejNCUG50ZUhHOUVzekdkNUdDTzVKc0ZVUDRBUFJPdjNUMHNJ?=
 =?utf-8?B?SVhWalJqMTU4ak45SEtpZmEyZGFRbFV3dlhCaTYzREZzRE1ZcXhjdVpHMFdn?=
 =?utf-8?B?SG43WDBRaGJ3QmxqOUlqdHNEU0V2MkE3UVN2ZGx1cWlvcG5sa3NHbk9ZRnlw?=
 =?utf-8?B?TU1hUk5nbDZlbGNVQUlrUVo2MDVJb0ZSSWFmS0xnRWZiRHlLZng5UU9XWkZJ?=
 =?utf-8?B?a21haXBPVmo5OUI0bzNzM2l1ZTNhd2pwN3JPamE1YWRjVDhHdkFvRndPUDc0?=
 =?utf-8?B?VzRLUmQ5YVJ1VlQ3dGpvaHdTRnk3L1o1MnpuN0JxcWxlQm44R2E4c3laRk11?=
 =?utf-8?B?N0VNcS8zaSsxSllEbk1DZmVURlZ5T3hwVktGcXJJU2Z0by9Sd0xnSGFDYVlF?=
 =?utf-8?B?YjFjbmh6blFqU256bGhiT3pLYjFheFA2RjNReURPRERIaWhqakNJRTlhNGlT?=
 =?utf-8?B?TXBrMW9jZHcxYnJtYjZuWWx4VGhRSkova25Zc3NWbUhicmZnRzZxa1dMbmEz?=
 =?utf-8?B?Qzl0K3hEMGxsMjh5OThsdHQyKzB1UTk4bzZ1UmdzL1MyblJlMnhPdWZsNi9k?=
 =?utf-8?B?aE9OYmZwTmQvb0RocVFQMzFSVG5DNjJGUUdvVUcvVHYyV1kzV1FncUtjbWcx?=
 =?utf-8?B?RWZQSGtyS2lyVXM5RVNlVDBub2dWL04yQUlwOTF3czZ6bGlzTHdZWkJCdTNY?=
 =?utf-8?B?aXNmVERoc2x6dGlJZnJtS0F0b3pnWDFBMkxsdEtNMU5FaTZXYW0xWU1XVHh5?=
 =?utf-8?B?c1ZUM2lqNkhpWC9CeTZ1UTB3aVRVY0dpbjZXNFJHbkNvcUd6MjRUcWVYRm85?=
 =?utf-8?B?ZEVJbjg3cDNnazJwRnRKczQ2WHFYMXV3RXpDdWhzQkw1SWdLNkJaWHEvbWJ1?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e70d3a10-4f5f-4694-4fd5-08ddf093b9ca
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:59:02.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWMcmB2dV1dnhlHsyCrzCdPxC1ImUXNmOC49K7qxVUUtLVDAHAQFADQMAjoGJ0E+IeGJiGuSXTag5hWjYGhUtazhGJ8fQjGrQhvZGzMzYRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> @@ -194,6 +236,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  		resctrl_enable_mon_event(e->evts[j].id, true,
>  					 e->evts[j].bin_bits, &e->evts[j]);
>  
> +	if (!infodir)
> +		infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
> +
> +	if (infodir)

	if (!IS_ERR_OR_NULL(infodir))?

> +		create_debug_event_status_files(infodir, e, p);
> +
>  	pr_info("%s %s monitoring detected\n", r->name, e->name);
>  
>  	return true;

Reinette

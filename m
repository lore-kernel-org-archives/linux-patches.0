Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B8240856
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485754; cv=fail; b=mqjF9MgZXvcR8ORrOdhJiGc3Wcm4PZumLUgKXZQl2Yp1aeAGvMyyuf3hQ4lDWcT6P+hkVWcqUn8lbMTPWBZbL0o6SkLF1unMiv/ziSFyQaDJQsk87KepUX0CnEPyVSzxFLxaSDFsYSzuo3vnl/nQxvLNjfOv4rR0qBXxsI7e2U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485754; c=relaxed/simple;
	bh=f2K1Gflrkt6lpcNuWe0JXjSug+jeI3/TPJGy8RHZ/TY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XbmZJKJCEYhv7xWCoGdd9T5pzgDtak4Nk5U3spiaEQvFNIZj2Nm1AsYies8uWMrnQD/Ev1sNjiJyv9vTWKLaFjJca2UiS4xp669LSWujAC44SE8zPeJ8PKcEYWVWKlOPb/G/rzSK4XCZXOflXkyaqCdSnPw89WMMZlVSnGw1jNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j006WGuw; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j006WGuw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753485753; x=1785021753;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f2K1Gflrkt6lpcNuWe0JXjSug+jeI3/TPJGy8RHZ/TY=;
  b=j006WGuwgTcIpMXZJURaQr4BBxwKV19qKP9/NfpOQ3pdCC+VezNrVHNL
   6xow9UkZxrVWfd+q2hF5A6Fg6y7VAfyZzg0msuca7LcnEa5N5q6Q8wQdL
   LRzqu/PZnfqDfAg87FVD556KOUJkRzDVM//OrV3tjy+zIuEw1MfbcoULk
   YZmRDLKebGxvgGaSKiqZ6GmEDJ39zkZze9JMU+VWrOIygrUa7jboZFTRX
   eCspaFIGBGzjGypTSIKw3XmXvT2a9AGc3U9ruGcDn7WLNQod1ijdibzp/
   EZMnUIaCHCnFO/uEk6Erb5tbd8AKazHzHx4lHgtR/B/3ZOrkLWVl+UtqY
   g==;
X-CSE-ConnectionGUID: 0mOUtOAmTG2XGCfkoAcoBg==
X-CSE-MsgGUID: UQ+uVdcJRli0hkxFtmqRxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55921708"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55921708"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:22:31 -0700
X-CSE-ConnectionGUID: UdywbY2/SLmvQyysVqQ4Bg==
X-CSE-MsgGUID: kkenI5k8RlaFngF5NU5iqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="162048104"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:22:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:22:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:22:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:22:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EVnPKeHXRfYOumQnBQWikWYOww74ZnOI57ykiJNbQIvbP3kV9XiP5QH4JsthQ2cm/DwdOeeVecHJc0pPzoVUOa42XuyIdtezwooL7BI1skblFDjy8Lu6FBFmhqC4JAHO8gX1896AhSJW/Ak+BRjAw98k9RUXoRkz/CpRi6DFI1IN/2tXQ5ah2Juw1xHoxxBRKLwH2lZ5bsugeI2akDYnxN9ywQI+rJmjabCUAjqalS1NvCKw+vDhHs6DcJFnh8IdoLdKNaEl7wtDfF0HlHEgZ4BI0EhsLkJm9xjcI/+abc7PJ9dbGwGtvaP6OktvIHbxjdDie6SVD93AHFDYYSXyaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEqtfYuqIr1cliCLyQ7ujtlOAojR8Qh53Ap6nd51ffk=;
 b=NaMZaNWfVHLYpjsj2rChWYkLn7yDLdvopk8H0vNUTY6uQvBtsSqu72Ugmm0HcRC+2GQnJvnF0ydgbMbrk8teyd1Lj/a6UC6ujCinshFnlqFmWUqUFVYwu2ZMw0uvu/002E7iqahUYR2ufOEYDQuiWhpB5+aLLP5Y6RsqEJtf5vO4o2NpGhSdEqW1Joxxvr+xyuRkwvGD1uJZlp9xIBerFeDq0pnuS47C4cztCe0e7BZqaORKGqOv+x2mYuujj1Ea1qnizfNKEAp18mlLESf1xyx1NPODAREYJzQCk6ZHly0Ut/FOKgwI7zB57kzebSlPrC5np/jyrdVFiNBYe+M0zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:22:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:21:59 +0000
Message-ID: <6ac15beb-7306-4507-b88b-b6f6cca66def@intel.com>
Date: Fri, 25 Jul 2025 16:21:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/31] x86/resctrl: Move L3 initialization into new
 helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250711235341.113933-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0277.namprd04.prod.outlook.com
 (2603:10b6:303:89::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: a03d9efc-8425-428b-1394-08ddcbd20e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N00yT29qMlZjNWtnVDlsZ0lKSWFIRnhVdlVwS2JKUE16TlhGR1NLQUFJQ2Ru?=
 =?utf-8?B?NjU5d3FSamkvei9pbUZQbU1lYWlncUZjckpwbUhZblk1TEFMNi83SEYyYVYr?=
 =?utf-8?B?dVczeUV2L1NmOTlOY1hPRllsak5DTy9DWHBGelhCVmdFVmoyMXJHczVEdU5r?=
 =?utf-8?B?NFNpOHNJQW9TS2x2RW5yVFFFeUhHbDdaVWRIMTZBR3dNaTgzMmwvSTBzbWlr?=
 =?utf-8?B?ZXc3OWhTbmRRYnhocnBsb3dHT1JlL2l4THU2OXN0YnNYTWNOWU1MZTRFSk80?=
 =?utf-8?B?STZWYnN5dnRVYkNrQTV3cGFXV3gzZmluQkZkaW92ZkxvZjBiZnhhWEttNzYw?=
 =?utf-8?B?WXZDZmZZYm5FMjA2MkpPdU1xZS9MTGQyTzZFVUFUMGxObE1zYTIzN3NDbFV2?=
 =?utf-8?B?cUhCbmdHSzA1ZVpueGZCdmo3OEZFVldaUWhzRXA1OHVaZVlranpON1ZvcW04?=
 =?utf-8?B?ZEVsQmJYc2NkeENZeExyYnl3U25HL2x6cmhVcEY2TTFKWEJldFovTU9SQTJL?=
 =?utf-8?B?MTFTSEowelJUVVVUQm16aUNYbGVlT09VWkFSZW1RTUlsUU1nSlpvSVgyTndB?=
 =?utf-8?B?bWVraE5qSXNCQjAwVXdGS2JQVmdtMWhndlFNVXBhNk96RVZ1OEoxN2RYMTJn?=
 =?utf-8?B?R0QwU2FVRzZqc3VlV0QxZFN2aFJhL1U4Ti83cmF2a2pYY2lVd1pJUStQUlky?=
 =?utf-8?B?R2JuZ2loYTFRNTJ6dVk0N3NNMW9PNWpZVitsU2FGdEVXeTF0a1d2NjF2TGkw?=
 =?utf-8?B?M0ViYW1IbStqZEhaRUNtRFZVTlh6L0dobEtMZ2NHV2N0eTBoeE5PZS9rSjQ1?=
 =?utf-8?B?QXpXOU5sb0JzblBhYmFMby9GYWVBRXRVaWFjdXUrejJzS1V0ZWNIenRJR004?=
 =?utf-8?B?K1A1WmVNdFlJRmJRNUFhVHpyTktYMmtPbUk1ai9XVGlZMjUrRC9UeFY0WUpv?=
 =?utf-8?B?eGxvZVBBOElnUnp0Zm45V29LdEtKWFFTVVNnVXdzY0VHZXJ3bFU4VnRFVFJG?=
 =?utf-8?B?aVBMaTBsenFUaHlIRTRic3ZZRzJUSlVJOU5GbHpJa1FXZEltRjV1cFU2c3pZ?=
 =?utf-8?B?RVJNT3NWSit3Rk9xbjJYOTJjWUNvenpNcjBkT0hER1BqeGR1eFgvTE40Ymk4?=
 =?utf-8?B?RkQ2T0tuVkNPU0VQNkpxb0FqeTBUQXJPeW9kY0tWd244Uzd6dlNwL2lFWStQ?=
 =?utf-8?B?NmNmRHVibzZhMEJ2S0gyQjY4ckNpYU1FbXh3MVRXeEw3aXRqM0dpREMzNlFj?=
 =?utf-8?B?OXhXNy80MG93TFdpdmlKVzJ2VlQ1U3lWZUZCWm5aTlBOZ1hzNzZKZHFKckdZ?=
 =?utf-8?B?WXJIa0R3Q2QwenZjNFRBZXA2WkNtaUF5TDVTV3FpeDAzUklHZTV1Yml1MHg4?=
 =?utf-8?B?YWpQY3N0OUN6VU5FczAyNUVZZi9sYThmUUFZRVUrZzBqR1JpM2RmZE5kLzgw?=
 =?utf-8?B?djdtbnAzZUhBUnlsMEtvdHB4cmdmcDVNdlVqVWFuQXIxU2tueldac3U1d0FN?=
 =?utf-8?B?L3puZWdrVXlNdzBVM2RaemgzbUhKSHJDS1JkRVByU29vTVIwNEN5Z3NjNHFW?=
 =?utf-8?B?dU11NGV5Yzd4TXV3NVVkc3FHKzdvVEVJa0k1ZWRNK1hJdmcweG11UWdWdWpU?=
 =?utf-8?B?N2RpOXhrQXJDcVB4bjcwM1Q2eUwzeHVBSjFHdGxGbC9vckVpaVdCMzlJaW9z?=
 =?utf-8?B?RmU5UyszWDcxaG92WmlRazNJWC9KUWNrNnROZ3F5SldhenhRS2oweU1SeWR3?=
 =?utf-8?B?NDYxL2pOSFFNZjBESlJ0L1pCVVJHR1VndnltTlp2UW9ScGI0UXZXYkpsTTJo?=
 =?utf-8?B?eDNvYVVxOW9rSnA4SE51SHFyU2hNWGNzSGlkMzNDa2RRR0RJKzBndWdlV1gy?=
 =?utf-8?B?QktJMTZ0N0oxYlgyOW9SWGpCc0JYK3V0djFpeVQ1WVNjR2VUQ1l4OEFYSUY4?=
 =?utf-8?B?WEtIK012U1ZxOXFNZHJVZWc5U1A4cE8vM3J3NWNtbzUwU0xSL2V2c2tkaklZ?=
 =?utf-8?B?cGpjemRSQkJ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXhqbXUyUFh4TkRqTk4rUG5rMWQxdzBQdnZlakE2Ryt0UnVFQ2dEdHFsMS8w?=
 =?utf-8?B?YS9wQXY5VE9IdkV2cG5OREhjMU83TFhiTjh2MGJQSExXb0N6dnVYeG1hZTlW?=
 =?utf-8?B?WTc4TFBlcWdLc0R1WHU1bDNGM3Y1REUrK1ZvQ1dET20rZlUwdGYvNFhlUm8r?=
 =?utf-8?B?YW5sOVR6Wkhicll3bnN6OExiaCtQdi9rZDFaK0tnYUl6a2VlSC9mUU8yVXRn?=
 =?utf-8?B?VDJFc0pWWHZXSGc3SDUvL3U1R25mVWJoWUliUU5od2EyWisxSzg4ZW1Pa2sx?=
 =?utf-8?B?cllmSUlub2x0bktGSHl6Y2p0NmFGZ2pxZUdtakkvRzV6dndieDhYSTBwS25D?=
 =?utf-8?B?UWFqWmpVN0trOUZ5SVMveEtkck8xaHJZNmVVWC9tQ25mTWhnTjVUZDFpOUtw?=
 =?utf-8?B?S2w3dy9TSk01L1U3ZStIYXFXd084U2JLWEFBRklTMFI2T09QNzJ3MWdKWDls?=
 =?utf-8?B?WFNpOVB5TXRYblp1aHUwUllWclg5ejJPUWk2MDNNUWpvdVhHa1RXTVlpcmtp?=
 =?utf-8?B?elNqeW1MRHVLaEFGci9SSE95b3FyWmcxS1YxOFNnYU9UYTVGZXRTRVUzSXFG?=
 =?utf-8?B?TEZNNVNOWEd5djgxS0QzU0hKcWViaitOMGRLcnUzKy96UnN0Z29tZm1hRTlC?=
 =?utf-8?B?dFdkNGtZZHRpYlhYYnFkVXI4dXp0K3lwazJiU2o1L084WjZNSjJtcTJjOXls?=
 =?utf-8?B?NVFkL1pHOGV2VmpEb0ZmZW5pUlUyMTlpQ3hURVVpQVpMaE8zSUYxTHk5dU1O?=
 =?utf-8?B?Y0ZnaGRCRklJdGlhZ3ZIOUM3ajdnWHdUYVltZTFhdHZveEs0OFNmUHcreWVh?=
 =?utf-8?B?aFRwaUFjRmtSdmU1ekRFNkFNdFkySitLYzVxY3lqVHc3ajlmcHdVM0l3Yjdk?=
 =?utf-8?B?bXJSVjV0SGVtRy9Bc2dvK3BBQW1xbFhxc1VWUmlKejYweG9mZmx5UUR2UXJB?=
 =?utf-8?B?R3Qrb0tNaGU5Z2lYMGlJL2lSQ1pjeVRpalJmV1ptZHNmM1BBT04wMGsrUWNE?=
 =?utf-8?B?azQ3U1djWmhxb2xhRVA0bU1ocFI2VnR3cFpsMjhwd2pWK3dkRkZOdEoreUMw?=
 =?utf-8?B?Z2lnWmVpSHBiMVpsRjFFaU1qNHVBUEExOTdER1cybHBxektaOFc4cXY4YTU0?=
 =?utf-8?B?U3lUTDZVbzlXV1dBK2o1ZU1BVTRPSTA4cmtTUURPUEg2TzA3MkQ1SzJicXBx?=
 =?utf-8?B?RkRsZWcvR0ZXUm01eXdWM0FxcGdqcTdnV0FRbWhvMmZycVBYWmViUm5CNFNs?=
 =?utf-8?B?R1RVVG82di9BQSszOXVwcXIrSTVkQnA0YjJkOVRHalBqcjB5Um5iQmVMbGtw?=
 =?utf-8?B?THkzZFQzSjZUUEszZGM5a3BmaFhJZjlMUlVrSk8vazk5TEpDQzBHbGxVaHlt?=
 =?utf-8?B?TzZWRm52SUd4YjZjZWtkUTlxeEo1R0Z4TW1BTHJzdG9yeS9CN3ZNbzFCK2lO?=
 =?utf-8?B?TzRuNWZ2TEErSmxCbmtXb2Rzcm5pd0lFRmJySllKbGIwWVlkRGVmRkorNEZr?=
 =?utf-8?B?cVI5RWRUSmJZSk1uODhlRk0rOWZTcmJ1Z0syUkIxS0EvOFJhS1ZUQzJqa2J1?=
 =?utf-8?B?RHVsdnV5Qng0bnRObzFWWHZ2ai8ySTI1Wi9tWU9qOEwrTlVWSjFxNGppV0t5?=
 =?utf-8?B?TzVXbE43TDZnUGFSNGpML2xIQWdxcEcrREdqc1VBYmMrcytiTGMyRUhqWUUx?=
 =?utf-8?B?aFlpcFRLWnZVcUZSSURBbFo0OHRDbmVlc2dYdFVMSGkzOUtZTWdOMHlVMUlN?=
 =?utf-8?B?TTFkcjZEaWFFRVFiMThycWcyYldlclRKZTh6QkJYWGZvcU5lTVlTZHZlZ0VD?=
 =?utf-8?B?eElaWjlMMkRia1FCazFFbjJtOXFPbUtnZkExKytWcXZPVTJGODZ1WG9GM2ZH?=
 =?utf-8?B?VU9paTRZbVpTbjFNRWtxdmhBVVgyQmczWkFZNDM2UDV4MTdmaXkvQTRUZlAw?=
 =?utf-8?B?b0JpMDJJZFdZZnRhc2FPVEw3MG56dE1wRFN1cHFhSEQ3M3VYZlF4WFZNek1l?=
 =?utf-8?B?a1VWMmZpVUo3MjMwQnZEQUU1UE44UlF0TEk2QWxZdDNqbkVJcUJsSXNLVi9K?=
 =?utf-8?B?M204NzArcGE2aWFJVk9xaHNBVXd2c2cxWEtTSGQ5cVBRM2RsWGc0dGd5OHAy?=
 =?utf-8?B?cmJCTVJta1BTZmlNZ2h1VjBHYUREQTIwY0FvMmc3S3FhanRNcWdNYmhEZzVv?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a03d9efc-8425-428b-1394-08ddcbd20e1d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:21:59.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HoMa7E+aYKGVvFuW17CeFnFY7/hE1UjaKuSSnopfai+t0k2ESOP12d7IYT4UHIzpzjh3OAigBAlLk47JVOsRl78h/Dri/HFHGgB8DPARq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:

Missing context and problem description.

> To prepare for additional types of monitoring domains, move open coded L3
> resource monitoring domain initialization from domain_add_cpu_mon() into
> a new helper function l3_mon_domain_setup() called by domain_add_cpu_mon().

Please drop "function" that is unnecessary when using ().
(this highlights to consider my proposals critically as this confirms how easily
I too get it wrong)

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +{
> +	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> +	struct list_head *add_pos = NULL;
> +	struct rdt_domain_hdr *hdr;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	if (id < 0) {
> +		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->mon_scope, r->name);
> +		return;
> +	}
> +
> +	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> +	if (hdr) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
> +
> +		return;
> +	}
> +
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L3:
> +		l3_mon_domain_setup(cpu, id, r, add_pos);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);

Please add a "break". For consistency, when compared with the changes to
partner domain_remove_cpu_mon() in the next patch I'd vote for how the
default branch in domain_remove_cpu_mon() looks.

Reinette

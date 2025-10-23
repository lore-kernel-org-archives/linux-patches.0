Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C1D242D92
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761194879; cv=fail; b=nqbt5nLuANDqbyFtTxLtuljVfQNTmtgTP3kzYX0CszRahfdCPc4RvTUzvfFi8kbntm+xIeW0EpZqC3T58RSHBYVi7vVEyNPYWZWdRCn+aEWvsNHUzhFxxpaVDgN3bd+ogRxo4aHvqE8iT5hrXhficMgqOae2Yu7tvgfNi43Q/t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761194879; c=relaxed/simple;
	bh=vz1QeIXep6xa7ALlVLRntrqYEATCBpLekYVMIWOAq5k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u+0eRpbhhi2K9NQyUpoNm5Iw5KwJPWXRxoaY8I4CI0Jgmwh3BEkCJP6nMIi3gAvpgvpNpjmFSXs5YuVJYYaYRFTMwClHKKc0wWhaVme6OC/Jlj4x4JA0dX6iuq0/fXUfj6ulD6JInI/NC4CRYwh58+ff8g3O84Vz2cCCoHUJekE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OB2vnHyT; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OB2vnHyT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761194877; x=1792730877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vz1QeIXep6xa7ALlVLRntrqYEATCBpLekYVMIWOAq5k=;
  b=OB2vnHyTCz7LAmB3jJoJgkUJGDDN2UPW6PtANm+QCr0fmSIaUbDOOqbC
   kEsyXqDj9LJm9iWpIYbKx57mN4FD183HRv7DawvfPqz2Tr4XsbEmQ/Xij
   S9NZ7ay7Ci0GiwEv1p69NJYW7hP3tieG8LFYyOuYlAQB0RCAwozZF0p5c
   Z9QrZnyMGfAgZSt0JjZMQ38hjwUEb3R9WiCsyPsUiMG55OxmZ5GULBmFp
   mPXTotqoQomv9P1YKmHybW+VrLtXQF1++QQBLr6nNUapADG2ozCDr/wv9
   GINj+jBLfrgk7hx+tHJHGdx57TQ3U96gUJ7zfiyk1Y9vIByEl2WxZ4gB6
   A==;
X-CSE-ConnectionGUID: iRr4Qt06SqCUh+8+2z5bHQ==
X-CSE-MsgGUID: tctZzNYgTdOxFGYng4ohUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74473033"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="74473033"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:47:57 -0700
X-CSE-ConnectionGUID: 2H8bqWjxTo6UG7qk1IYb3A==
X-CSE-MsgGUID: lAYEuhEuRB6pUHM90nc2Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="188102595"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:47:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:47:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:47:56 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:47:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2nOQYbCayWFnQ3lPKp76TWXJ+wFsLIcYvQk0PpgplHURhThovTS+a2d6jGHiFxC1D2E6AQhWCVp4j/Xf9EhkZ3JtkJxkq/UYFhhwOSa43QWtqdXqxQUMGTdOdLWUUUze60YWzqlAE5ADrpyC+w6XBzDGjGuIOy2pWhPthSwYsRjDBGQ/otv75syZA04zHSV5oQgjP+YhgdN+wA6d8Y+kpS2VPqLJ/NmcMdLryn1C6ow/gMSxrXTdW7nfDfXv9b/g4AX31yExe7hRhI5cBb8tIxJnIbMMwZ0QMO/7YXS5AjQ3ZClXS9asrdrrBm+ebwTmf2mFpoqVE2gsLdcqJDJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAqAdBNWPgTHFfBYQpbRiv1UqzY9imUiXULByl1Cm3c=;
 b=cnpoQcd/n90V2IvOPRi3WISiVuFLkoA/WguiJWyG6zkRqjmMXxJrtRwyncOVy6tYvNgov6dQKjKpDF3UoXUrCa2L+Wjbz8ghC8XOAmeSe7lYfqi9ruwtmcQZVrcMwhOP0qGoX+ip5M/vw/rLLo8JcBeHyKPyG+Tqv6OIPWtJuRmZndphsZqIq8gS1Q0YlWLiKrvvVtvBpWVbuI7s/SBC9XD+0/f86uiMnLlVHhXdhiYaeuC8pabYHwv8uKLEVzEdfYFasJsfX7lq3djGw/ngpd9Lmb13xhAtmB0Dkeuyb0cM+KAbbWprFCw+G1LAK1sC+a/cF0QCc1ptjevEaoVQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6878.namprd11.prod.outlook.com (2603:10b6:510:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:47:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:47:53 +0000
Message-ID: <a8ee6c4e-7390-4313-9b34-6133186d2f7a@intel.com>
Date: Wed, 22 Oct 2025 21:47:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 19/31] x86/resctrl: Read telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:303:dc::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc4ed38-5a89-4a2a-694c-08de11ef53d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SFZKK205Y2dKdWg0YTZFMlV5QUx5VHZ4Uk5JNW1QdUpiVW5HUGxIaVZid2VJ?=
 =?utf-8?B?dUNUNGFHcTVXaGU4djhHNlhxejVNSndDbzgwamc3ZXAyUDl6U0lUSzIyWWc4?=
 =?utf-8?B?NEtnMTlsSDZvYWh6QVFsc0pMdG1DcExTYlZsVHhTUUZsenZsMVMrdkVNb1Fz?=
 =?utf-8?B?Y05kRHR3ZWkyQlNiSXcwQlhhYzN0Ni9Ca3pwVUNRQnErWUhCREdmZExPeEpG?=
 =?utf-8?B?aGJQaGxKVkt4YlRuK2xCMEMya0liSExscThCOFYzQUhOV25YM3c0UzUxNWU1?=
 =?utf-8?B?TTdONC9rdXpBTzduS3d3ZUVuRmNaNGxnejBHYXJQeUlRZlJYVzU0SFBNTHhn?=
 =?utf-8?B?MHNINCtvQmoxSTFmS1ZLdDhCS2FyTXdaUjA1dHNMNUFxaWxXQlgrRnNzWjNa?=
 =?utf-8?B?NzhFbUZqcHFnREwrZzBkVmgxTWkrc2hMQXlDdG8vMUJ4b29JZHJNOWNBM3Vp?=
 =?utf-8?B?NkVtd3FXbUhjaW5uUmkzWU95R29XcGR0cE9ZZjZld0IyTW5uWjBHSG5tMzRE?=
 =?utf-8?B?ckJJMnpGMXY1dmJIOVdzOGt3bkt1Vk1GaGlOOGRnVzBkdEpLVXRTNHJWcTQ0?=
 =?utf-8?B?aWNUdzY0U1R3SmJZSEZJVnVQNjZ5SDNheSs3eXBhR3NaeEZYUlB6MHJOZGtV?=
 =?utf-8?B?UDBqU3JnWXJjcnNqRnl1ODVVUnpYVG1mRWo3NUM4SmtWSmI2cmJsWkxZSWlx?=
 =?utf-8?B?aVJnUGQ5M2NuZjMwaE5GSmEvdU5ab3VtdWlqU0REbHdEOFNvTVpyVnhNalZN?=
 =?utf-8?B?K204b0RZMU9YNnc1NTh4T0QzaEpER1h5VG5MajlPc0RjSEx0RDZ5VFlhZE5O?=
 =?utf-8?B?RTZQbmZZRUpJblc2T25HZlJHcUw4T2lOaWdOaW1VT3hhV3JWSngxQU1rWGdB?=
 =?utf-8?B?M3ZheEx3UUZZc29vT3V1TkJSMHArK2V1Z1haeDRRVEU4a2NTc3dyN1ovOGxT?=
 =?utf-8?B?eEZ2M1dIVWR5MzJNbzBBZkRDcTVWNlhGdDgwLzN2YjlnTWd5RzRqWjR1RmtG?=
 =?utf-8?B?NEpzb3kvaHQxKythN0UyWTVSZE1pb0NWWElGUXZjSDdXS1NMRE5HWTVJWkFF?=
 =?utf-8?B?ZnV2NWE2VGdDUUZRUDEvYWhtWFNRdllQczIzWUZ6UWlic1IranN6RG5mVCsr?=
 =?utf-8?B?T09pMEdhdXZlQXcreE5HSXRmdE04TG1oZmY0MEV1V2N5d05WeXAyeUFyL0Rk?=
 =?utf-8?B?RkdLMVVFM1ozTzJGaUhTeG9BVkhsdHJMWWNrUHQyZUQ0cnJoQzNCc1hyRkpa?=
 =?utf-8?B?aHZRVGw2Z0NKcVVtcUxKUHBJR09zSkZtRGJDZG1jNVovMzJ0R05UVEVVZ1hT?=
 =?utf-8?B?ZU9wY3Z4ZXZ1ZFNENEVSelJTSFUwTzVzMVVnKzRrUS9ITU9VU2tZNW1HSHRQ?=
 =?utf-8?B?NjVaK04yMTZoVE0zZXI3VzNsTmVhRW1QV2xhdDhDTzY2eFBUMjY4cE5zMHVU?=
 =?utf-8?B?d3Z2TzdwTWJNM3hEaTIrSzhZclRwTnhXbHJjSWhKQWlaSFd1VmdEUE1Jbm5Q?=
 =?utf-8?B?SFVlVW1sZU5NVURYR3B2YW50clZ4UGJJK2p3RWxpQlI3ZUFDelRSUVlpS3Jw?=
 =?utf-8?B?UWZLUjljNG9YQjlWdWN4Rm9GWlBlNFBVNzQwa0s2OFMySm03WWh5UU90RVZ6?=
 =?utf-8?B?dG5mUlVTcXhjWVlVSjY2ZzlRQjlrQkNTaG9KbUZSWHF2T0RXdS9FdEJnQmlU?=
 =?utf-8?B?UnJUTTBRbk94RVBqMzVvVHZmTTlSQmYxVnd1Si9YMzI2UWY0MzgrUnpsZmNI?=
 =?utf-8?B?alEyUnNLYUNCNk04a0NVbmhJbnRJWUREelNhbEIrak5EVTBTT0J0aFdYYmNx?=
 =?utf-8?B?bW1zTGRsYitOSzRoU1Zmcmd6aXBiZVoza3lRU2dmQWNLREF6VzNuaUJaVjZQ?=
 =?utf-8?B?ZHR6MjJITEt6T09yZ1EzejYzWjkxT2NXMFdYaTRqTFkxSkFJZEFiR3N3OCtH?=
 =?utf-8?Q?Mu8gLqQ8jJQ085EwOOwUNHLAzlJs3j9Y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVRpd20ya2N4N1R2VUhtNUVWczRHbXNycFNxQWE1ZFdBZ3hGMm1TOVFLS25i?=
 =?utf-8?B?ZjV4WXpWOXViYzl2d0hOMGY1V0lTRUFrRkNEY0NqczZveVJGWXEvT3hWZ1JZ?=
 =?utf-8?B?YU1WdWROazdINW5xODlBV1hzdjVjcWRxYnJlUklUc29IcXV3ZDdDM3oveU4z?=
 =?utf-8?B?dkJVYVZsVmhoeDBhcVNmVUp5UHJ0TkZEdFplS3c2RXI4OWFROHppMUZDQ3N0?=
 =?utf-8?B?RTZQenMrYURmV00wYW1hYSs5YW8za2Npb3QxVkt0L3A3OEhnRUZ3QUFZaG9B?=
 =?utf-8?B?UHJlYVlqN1VaNzcycFprMkxIUnJNa3huMFpEVTBWQnB1MnliV3pNQnhUb2Rq?=
 =?utf-8?B?ZFRMUEpVNUJCZTZEdHB0VENpK1pQRk43RjQ1Rk9DQVIveTdjSXEvQ2FhaUhS?=
 =?utf-8?B?Ty92T2N0aUU4NWJPK1VQL2E3bHpzbytzREhTV2VjdjRqSnp3bC9zWFZsbE1m?=
 =?utf-8?B?amR1Z2k1UHBFeEhsWjByS2hmNFROZ0lwYm1RWDFhU2h0MG83RzFWZFp1VTRI?=
 =?utf-8?B?bW95SmRPaVpkdmhtamhIL3BtNDFnQ2RSamhLSkhtYk5QeXlET2JXcDJUQ09F?=
 =?utf-8?B?TXlyd05TL1JOblJ4R1RwU3FaZ2xDSWx6b0RodVRyb3JmT2NldmdiNzFMVk5q?=
 =?utf-8?B?cEJHNUVJZHFyRlRiRUFSZFdiS1dLdWVNN3FON0pyZm4xOFhBME83UmtjcTBp?=
 =?utf-8?B?WWNadXNqUWo1Q09GYU9OeWpiRWlVUXVBcFJ0bjlHUnpaYUI4cE1jbFFEZDVR?=
 =?utf-8?B?MzhrRHA2bS93dFBER0huUGxrL2ljbWd3SnpaSVN1NUZoZWZGNTlwcjFYOXdR?=
 =?utf-8?B?ZExkVTVxdzM0S1N5VTVqdVEraXpvVnFsYzhrSnlqYVpLTWt5aEtUQ0s3NTNE?=
 =?utf-8?B?U2RPSytOcXdyYmgxaFVxcTJFQklIM25uZU02WEVSUVFXOHpHd0tCRC9QM2NL?=
 =?utf-8?B?M0JZR2dycXVZaGxVOVo4d1NJR3hCMk5VcWJYT0Njeis5SEdxQWx4YlpLWmlu?=
 =?utf-8?B?dWQ3cjF0MWpIWVhWK2JoN1Mvay9taDBzanhrUTd5SUtsSEpVRFZvemdGa3Uv?=
 =?utf-8?B?d1RoVG5XNTJKZENPL25qKy9DS3pwd2dmbzhTS090eTlGZTZsQVd3aE4ydTJr?=
 =?utf-8?B?UDFPNWV1NlZ2VDdWbmJmL2FuSkRNc094TVorSmpuaXBHMEFJMkdDK2FCQ3Ar?=
 =?utf-8?B?QWRoYTJqYTZ4RTdaeXAzWFQzMlVMemJTbk1WTnlJOFZCaUZhV2ZrSjhhdXZN?=
 =?utf-8?B?bXFnRTlmbG5PM1VBU2Mwd0R1ZHgrV3EwNmQ4VURLOUtDZVBMS3Q2L044MzNM?=
 =?utf-8?B?Rmw5QUE5d3RlYnM5K3ZuZmFNL0IwSTNtTXhMMHBpZ2w4MDRCSlFOeHlCMy9E?=
 =?utf-8?B?ZlpOVUZwRVVCMTAzNHFaZFBobCtzNDRpamR6NklHblFURlZZWmVEUENOazFZ?=
 =?utf-8?B?Nks0QS8waUYrTTN1SWVGQSt4MjBHYW51d1FBSG1WTmdoUHBwR0NTdFNJRktK?=
 =?utf-8?B?bEc0SjliSDFUZklOL0RXSXVxVFhFakJoL0h4Y2dvcWI2WldxWFhqN1EwS1hE?=
 =?utf-8?B?Q29NSW9WVWlnYm5ieUxMc1lMcjcyNk03OTQ5Lys1R25UbjMzRXFFYm5DZGZ2?=
 =?utf-8?B?U1NqYVFpZ21KdzlHTGtNeDFPRmpENUJZTnRrZDhiRkwyaGVqK0pvRWs2eTJM?=
 =?utf-8?B?ZTloZ1JpL1VqMFdUdFl2M2tIc0QzMFA4OTY1aWViRCtuQ3hVR2dzVlFnQnMv?=
 =?utf-8?B?OTFMWXZpOG1GcU4zcDdpNnRKcXhoclUvYzNVeUJ3WTcrRjVBcG5US2JZN2w5?=
 =?utf-8?B?cmdCZkhsQkVPUXM3OHdrMC9TN3J2cG1HbXlGK0FDeUNibXR5NHdZUTZmTTJy?=
 =?utf-8?B?Ykllb3EwV3k4UlM0RFlFUk9uOHZNbGhkdE5RdEJ6SDZWSkw5UHVBOXY5SDVl?=
 =?utf-8?B?QklLUzd4RTNac2xWMi93UE0wLy9sZmVrak9RWTYvTEFKbGUzUmVmYXE3ZG1L?=
 =?utf-8?B?NnNQVEdaam5wYy9Ec1dlTzh0ak1aR3lRL3QrQXozSlh4cHFoMW1ldmVhSWo3?=
 =?utf-8?B?VlV1a1BQWkg4NEMzVjA3SWx0TkJoZTZKazl2NXdWVFhnODNxRE1QZS91eXpt?=
 =?utf-8?B?M0M3MjMyN2hZa3BzRkNHUEtpWVV3OE5oak9tbTdWajlrWjYxUUdYUWgwQkMv?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc4ed38-5a89-4a2a-694c-08de11ef53d8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:47:53.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOjPFSGqpyZMi5yxan7CZTWkKrpj5sYcKBlQQ5rZAmAfLx59gXaxo2OGl9VwzieBifuD72GjBA10kHloIdBrZT4SlEx5ka8PEu5+jL6kOhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6878
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Telemetry events are enabled during the first mount of the resctrl
> file system.

Not clear how above is relevant to this patch?

> 
> Mark telemetry regions that did not pass the sanity checks by
> clearing their MMIO address fields so that they will not be
> used when reading events.

Above is definitely not relevant.

> 
> Introduce intel_aet_read_event() to read telemetry events for resource
> RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each
> package, so scan all of them and add up all counters. Aggregators may
> return an invalid data indication if they have received no records for
> a given RMID. Return success to the user if one or more aggregators
> provide valid data.

"success" (via return code of 0) is always returned to the user. The
difference is whether user will see event data, "Unavailable", or "Error".

> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> @@ -230,3 +234,47 @@ void __exit intel_aet_exit(void)
>  		(*peg)->pfg = NULL;
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain). If an aggregator hasn't received any data for a
> + * specific RMID, the MMIO read indicates that data is not valid.
> + * Return success if at least one aggregator has valid data.
> + */
> +int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)
> +{
> +	struct pmt_event *pevt = arch_priv;
> +	struct event_group *e;
> +	bool valid = false;
> +	u64 evtcount;
> +	void *pevt0;
> +	u32 idx;
> +
> +	pevt0 = pevt - pevt->idx;
> +	e = container_of(pevt0, struct event_group, evts);
> +	idx = rmid * e->num_events;
> +	idx += pevt->idx;
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
> +		pr_warn_once("MMIO index %u out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < e->pfg->count; i++) {
> +		if (!e->pfg->regions[i].addr)
> +			continue;
> +		if (e->pfg->regions[i].plat_info.package_id != domid)
> +			continue;
> +		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			continue;
> +		*val += evtcount & DATA_BITS;

I missed this before. This just blindly adds the event data to whichever variable the
caller provides. Could you please instead use a local variable to do this addition and
on success assign it to the provided val parameter?

> +		valid = true;
> +	}
> +
> +	return valid ? 0 : -EINVAL;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 5565a8752266..6804b83934e8 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -252,6 +252,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
> +
>  	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>  		return -EINVAL;
>  
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index faaa2851c5c2..84a0cbe90748 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -526,12 +526,26 @@ static bool cpu_on_correct_domain(struct rmid_read *rr)
>  
>  static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  {
> +	u64 tval = 0;

please declare this variable local to the PERF_PKG block to help keep the
different resource code separate.

> +
>  	if (!cpu_on_correct_domain(rr))
>  		return -EINVAL;
>  
>  	switch (rr->r->rid) {
>  	case RDT_RESOURCE_L3:
>  		return __l3_mon_event_count(rdtgrp, rr);
> +
> +	case RDT_RESOURCE_PERF_PKG:
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, rdtgrp->closid,
> +						 rdtgrp->mon.rmid, rr->evt->evtid,
> +						 rr->evt->arch_priv,
> +						 &tval, rr->arch_mon_ctx);
> +		if (rr->err)
> +			return rr->err;
> +
> +		rr->val += tval;
> +
> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}

Reinette


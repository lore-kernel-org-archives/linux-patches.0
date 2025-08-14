Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACF2FF65F
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144678; cv=fail; b=MYgsCXeBHeWrw2OXEFxGC1rXTgxhu6vCIg0KKcu+pzJ+o3nbS+OhzRo4Wsb0mkrVvjxBRmotmwxWnJz/duphIHUL+lLtQTOxPKH1DOnJ3NWekR/TucQG95TZDIXCj7iAK8RTPU5wvt6MEKq2NZseLa46o+sNxnZBgrxPHeqKn6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144678; c=relaxed/simple;
	bh=LzqeLxas8RON3pKR7BP8DFwkqY4xyvP/bhVhFkdA2xE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ieanXJ7uHPRIybJtwehWrQKQiPiezekAXHa+cPvSk0Xq6ISt7Z63xc0XT1nxoC0Qbvc+QLpjayKLTQeB9I0K4AFwk1x0hpTRQi9YeiOM8sN0ykS+hchNCwBS+QmymcahAhroe/geHx3VvYc+Gc8KwcPiqZf+t675njyjg6V+9kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IUL4J+6a; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IUL4J+6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144677; x=1786680677;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LzqeLxas8RON3pKR7BP8DFwkqY4xyvP/bhVhFkdA2xE=;
  b=IUL4J+6ahI8+wLGtg1wYajLHFcS2vV5DCgy1pKmgnrzMXMj9kdwUs4AY
   khAFv7H5rbolUmZVgnEFhKN8C38fMjf6ypMsJR6Ktk4PuOlzAWAPkurpg
   rGok/02sMpuYp/BDIV2QQWtKVqc6LtFh+9ne11wVfEl2ym+yDwrUZfiwN
   4uucsofDcoPPg87HEQ5GAyejTqljCVvANczl4nIBe+8dYstyD0f5cmaq9
   jdAZ9rV3gVihfvBrpGgnLcf39en2c753UwgguoJuWRFUCENtyZkNa8WdG
   B3SIDwBOGokwK+7jwiL/gI4375jiRFArMpY2beZsGR4GsKk4JnOkYLKpI
   Q==;
X-CSE-ConnectionGUID: d2KBychBTfuiXY+LiyO67w==
X-CSE-MsgGUID: DzYIXgC4T/2ZIIu1VnUfMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="45032489"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="45032489"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:11:16 -0700
X-CSE-ConnectionGUID: aAAQ50CMTkiz1+8ye9XFDQ==
X-CSE-MsgGUID: i5GJZEBaQM2BuPeFDXhnbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166644475"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:11:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:11:15 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:11:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.51)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 21:11:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWuDqnr2jzGQCPiTNXQT4DdUQ2qdQPoJhIm4luBREKl3IMhXKMvvn08vst/mme+JktI2bNJ3H/MW035+RIQ6UsVAwGDhIox2P8NrmLdCLZ8g+GgBQkUoiWNwIRNJcDyAGgyPtQn9UQ8eLOIDbUF37joijC6ngT5LNfqWZVvFcsuPswI/FfaPk0l+jimp8ynCK2vseq8/5GrCIvqhHBgZUm/zs3hj0RO8+GVge3CbnMQdmpGN4aeYXFHZmahjDtbU4VKF7AhY4ndIFXnkUebSxTP9k+r42hQEH+Cu6VXhhkwox44cWOO6JjEnpvB7uJmbip9LZypqPhXBFaU3VPTUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVNqj97suiXAGWroqjAzQdcck+nuRneOVrPkBHbp56A=;
 b=CeyQ1P9f6SzIet5ZQZQLNoeF7eRY6Ae3vDE2ZmnVLbySK11B+6su2UMyFXrf1MWGz7XshSXdS/Q2qToxkK7F/UgyIkGEYx6dBNhE3Bek/LtHzovLB/M2EoxZ8mfpx9ec0m+kuM61L0/TgTYIbkTp3nJbOn59WI9GgcxPiymxOl+CbjQ41Vo6v34gMpL1ewfEAQp2gxpg/3kHdumos1kAM5LK7Kbn9o3thrrkN5dK5EoI05lW4hgMe9Tkix+51BBxkgQK3Qjj51Piz1+oOWFAygImWQC2aRn4HvD/p8SUEwshlgTcswRdV6hcmJLEO1K+SxVJmWoWd6Ff4ecCn6omgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 04:11:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:11:13 +0000
Message-ID: <abe9801e-074f-4191-b545-97a56855d584@intel.com>
Date: Wed, 13 Aug 2025 21:11:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/32] fs/resctrl: Make event details accessible to
 functions when reading events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:303:b4::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 293013bc-aec3-4c3e-ccc0-08dddae89b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDdmbTdMRFl2OUFnZU9GSkZ1RkdJRkpHMmxBekNIQi9FRVpaZ3FLMU1PbXpZ?=
 =?utf-8?B?UGVTV1FoNGw1NllSRisvY0diVFFPNFhRQkdJLzNTckNxYlBDSVpsSWVFQ0hq?=
 =?utf-8?B?TEhndTRjK3pQb0wxVWRiQllsZndKTEhHUVFadklxZ1puU3VNUWdKK0pIS2Fr?=
 =?utf-8?B?Q0U0a2Z4dHJWcCsrZzJtbzA5R1A2bld4ZUFsc051dnh3WERTSGpraWtneDFE?=
 =?utf-8?B?ZGlPcGhlVnl5azdlQ3pYZ1UzanIvU2tkTWp2VTdKcjhhUnc1SFAyMStZaG1S?=
 =?utf-8?B?RlhqMEk5TWtGTFpJVEFyOUJuamc0amNySHZ5clZHY3BDWFB3UjhYK1JlOElF?=
 =?utf-8?B?RWszbDhrZXAzVlJ5SmlCOTVaSU4yUGpGZEJBcmwrOVl3ZExyQ25rcmVTWkQw?=
 =?utf-8?B?YlZNZXRTQmlCZ3o3OTdLQWFTS1JNY2pMRm4wQThjY1UyQ3hpOGFXK2ZoZjlr?=
 =?utf-8?B?Tkk3RDJUQVZSbVF2NE1UOUQ3TEMxQ0xhcjNSYitEeXZ2R3FWUTRFMVlhYUps?=
 =?utf-8?B?K296NXpuS2RjbERLRlJ2NjBISisrKzFzSGdPenJUS0d4T1RMREZuRHVkbUNS?=
 =?utf-8?B?QjRuOWMrRGJPS2pRSVRwcTJic0I1R1pVQ2RMQURvc2ZHZVNDTTVUWjh3UW1z?=
 =?utf-8?B?amhFT28rQW1wUVMyaURXWENTRUFwMDJVcFRhQjRoMVU4U2tZMWU3VndwSzQz?=
 =?utf-8?B?cTNkeVNQcEdNVW1pZjVrUnJDenN6cmZnelJYZGswdUl6a3ZFcktEOFJUSmlY?=
 =?utf-8?B?QWFpK3h1aFVkdHB3SzdRZnl5cklxUUI5Y1dBZkY5ejBIbWEvZ0ZQbHhLeDA4?=
 =?utf-8?B?Yjl3d2Vnbi94SDNudlZqNERWQzZxcnlUS1Z5NUNVcHNCdGo0Tk15VTlTcHlZ?=
 =?utf-8?B?SGhjUlg5aGtwdHBVcUk2QnI2bGpCV21Zc1REWjlzVCttVE5qZFF5NGRzUjdR?=
 =?utf-8?B?N0NzaDJDQ3JsWjFtR3hqS3kvMy9RbXZYeTFkVUxHV2R6K2lnODFKaFZ0VlZy?=
 =?utf-8?B?bU5ORXpqNTRFaU03d2IvVm5hTzdDbVllMEIvWTFjaDY4dnhqSTlZcE8wM3Q5?=
 =?utf-8?B?aGI4ZUpJbFVhQzgxUklpT3JRemtsQ2ZHN3l0U0JzOGx6eDJHbmpaN3hXaFpI?=
 =?utf-8?B?aVFvbkRWbjZQclgvOUlOZmp5Ui9tYmRWYUVJNWdobi9CcDFpdndlakdqUnRY?=
 =?utf-8?B?emNhMmc5bDV6RnIxVzNYdktYbi9xdWF4ZHMxWVBmYTNESXJJWnI5YlYzNGQw?=
 =?utf-8?B?TW1URTBVemlzOXBTV3VxYTBSZG1ieEJuMG5FMWxUbzAya0hmSUM1akFDN25J?=
 =?utf-8?B?RDd0TU91cm1MK3luOFh2c28rTjRzU2ltMUQ0NW5UQWE0eDJqWHJrWitJS1Fv?=
 =?utf-8?B?dklyUkM4V3JRMjhVNUorR3Q1eUNzZ0o3SHFsUlRadzFnUWVBSzJMWmNyUFhD?=
 =?utf-8?B?OTh0TzV5WExKT0lGYi9Tc2hKdC9oWG9DeHA1V2tTckVxb0k4TlZBUDk5M2tJ?=
 =?utf-8?B?UHBIYmJQRGZVakYyOFBwaFNUalQ0SkptMmFNc1NENHVPVXNJSDRKeHF5di8y?=
 =?utf-8?B?NDhUWXJTZ1FoTm0zY25KTDc3MmNxK3ArZE5OL1k3TjJNUUducXVMbmUxM09k?=
 =?utf-8?B?azAzR21SeXM4czdkYnhKalRmV3FoOXVKWDBnNmgvQ01rMmdGOVgyME4yMnU5?=
 =?utf-8?B?YVJNWUx5cXozRm85ZUJmbXR6N3Y1dEFiZ0tTNmhYaFB3VHFMMGNobzZWak5B?=
 =?utf-8?B?TUFiU21aNTdrSldKRW4rS0tqQmpKTWxwWFd4SGxkZnpiVFhQNlNBdWRUV1VZ?=
 =?utf-8?B?MmpqaUJaSWlLa1FEZkVMbzNIbmkyT0xkRUowN3gveTdOVXg4T2N1ZUQ2bk0x?=
 =?utf-8?B?S2xxeXFVNGtBd2V3WTJDQTZFZGQwcno3RUNKYjR5T1VOQzZ3d0RDY0V6NzZO?=
 =?utf-8?Q?/4wV7hWHtGs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1BCSm5EbCtlWkVoMlU2ZkRQV0sybWtQcW53clZxcHp2Qnp4UDhYTnlPZ0Rr?=
 =?utf-8?B?akcvK2dDTlYzZVF1MmhJajJ3QWNmbWRlamx4T240SG40UVVIQktEeWhJaStB?=
 =?utf-8?B?cmhVVXRNTnN4VXZMdnNDMk93VUhKTkNOTUJIeXdOMDZpOXF2M1hRYUt3VEM5?=
 =?utf-8?B?OUhkWTVXQmx6MHVjR3dTY2VnOVFVYjZzTUVzSXNKUU8vdXZkc1dic3JvbzEz?=
 =?utf-8?B?YmNxZlU3TlpjQWhjdUdnTzBKV1lJeWhCNU9UaDMvQXVFS2t1bitGTTlpeDRS?=
 =?utf-8?B?N21zRGtvZFYvbVpwKy9vRkIweUxqTG4rWFhySjI2V0hzQlY1djE0dVNIV1Vk?=
 =?utf-8?B?VzFESHJWKzRINFh3T1h3S0VHVDMvb25MblRiY1owVzNCOUVoUDNvY3pyUW93?=
 =?utf-8?B?UkxTRnhQNWxnaTZSMDM2VDRBdjI5MVErKzFCS2RrVW9rdEJ3MUJkM25RYlNz?=
 =?utf-8?B?UkVCTHBSYVJtWmZqZGRPS1lIUDhjWnREZXZ2dktqRGtPUWx4aTRMMWFlNkcy?=
 =?utf-8?B?bFViWjlSd0RyYUNoTnFrRVF0U2l6NVluNEF3MWV0cEQvZ1pITTFFUDJNT3RV?=
 =?utf-8?B?S0JrZjJFbW56eXcxYlM0Znd3SkJXenRPNFZKajB5VlNJV1dROTFHeW9CUStz?=
 =?utf-8?B?aVo2V1hiVVpMTWRobldTU0ZIUEdPejlKbCsvZTIzV2wxdVNLd3o5U0p4U0Qy?=
 =?utf-8?B?NnA4WHQxVUl3Tm84SkY5QndXMnE3blVpVUhTWTNvR09KMFdBV0VCeHVHWWpQ?=
 =?utf-8?B?ck80MVAvOU5kajN4N3I4Tndrckpyb041WVBlamg0Wk9qWDZaZVFMME9nUisr?=
 =?utf-8?B?UElnZlhMZGQ3VGZiUTRKZkxkTS9FNnhRYTZ3T0VjQmh4dWREUWtMbG9RcjVr?=
 =?utf-8?B?RXhSUzROZE9RQXRhQzZYdjB4VVR5L3dzNy93TTMvWTJCWjlUYmZTUWM4TCtD?=
 =?utf-8?B?SERwNzVWMDZQV0Y3ZDJ4VVR4OFRCMkp6YTlDaU1FWFlpUGNhRnYySTBVblVq?=
 =?utf-8?B?T2I4SEdRZVdzdlBVbDc3QkdtR20wZVh2YmNiVzJSV0NJeXpva2RVZlFDemhE?=
 =?utf-8?B?WXBUTS85Skg4Q29uOWFnaWduWS91ZXZnK21kWXJFZXNLZlZoUkZ3MldqaVFY?=
 =?utf-8?B?d0NFcmpFd1V0WEY1ck9qdmx5aks4M2sxVVhzNVN2eEx4SWV2ZjBqM3pWVG8y?=
 =?utf-8?B?bjdjUFF0Z2pMeGl3L3BRZVB1WTFETkpaaWNrcVJLaUwzWFVOZzFHeUJackU2?=
 =?utf-8?B?bXpQZFp4Mk4wemdGK2Q0WUhtc05hUFBONHQ2ZXM0UXduUWIzRWtpRkc5RXpM?=
 =?utf-8?B?L0R0WEsvNUNkOU9YVGNHYUhqZ2xjd1ZiSmhVbzBpTVREUnlYaVRzNDN2VTJS?=
 =?utf-8?B?blpvcTJBN2NKSlQzN0lYSXVkQ3VqUHhGR3BQNUhNa3MycjgzM05kbVBaSDdC?=
 =?utf-8?B?bmRTY1Mvd1BwY083QzUvbnhpajFDcDJIWGhRRUQzbzZlVlFoU1VYZnczSXhE?=
 =?utf-8?B?ZzMyWUxDQytzRnVtSjVMWEs4L0t6U2h2NHhWTVdHR0MzMnJRZVlYWGhuQU16?=
 =?utf-8?B?S0tRWmtaL2ZtbnNBWktkc2F4NHo5TEl5dlVYOTgrUmNQTlJTWjFscHdaN0Mr?=
 =?utf-8?B?OWp2Slczc2J6WUZnOVVMekpobVFrVm1rZjNaTXZMTFhxTEJCYXhSK0t1WU1P?=
 =?utf-8?B?Vk1UY2VuYXpvdnNaSk5YaWEvR1Z6eklxMlRQaVdFL0NidmtTMkdlRHlVbXdJ?=
 =?utf-8?B?RUpndnB2MEprNlBCOVc4MUpSUzNMZjliclFTaG5vR0IvY1lkRm8ydHdMeVox?=
 =?utf-8?B?L3c2RmozazE4MlRpT3piUkdUcGFYVXI5ejJZM1UyakYwOStuTXZrUm5NSDdl?=
 =?utf-8?B?Tjc1bkhBR0Y1Wm14MTBTZ0o3NU1RT1UwNlpJMnBVNGVQeWd0UlZLNGVXNzdj?=
 =?utf-8?B?QTVObW5JaHZWcnpKdURVak1abXdoL0hpVkFKZUJIM3JzOVhLQUZrcDZnNUZZ?=
 =?utf-8?B?bWVLYm9CVHdxS0UyMVFtbjhGcm9yUGVLdVVqajl2N2p6THBwSUtudWRCUVMw?=
 =?utf-8?B?VEljR1BLRXhzOG1yOFd1dVNMWEc3NWtlcWZQTjNVQ1BLRjhETTZWZCtvQjls?=
 =?utf-8?B?b3czV1UvQjhONTFzeGtZSUMrOG0rQzZCd2FTUjJsK3JsRTJjenZHY0krWjJF?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 293013bc-aec3-4c3e-ccc0-08dddae89b6a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:11:13.2173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gsPkyfY6u6HiUKHkwuMN2/GTIxVbFoMtudms2l1GbdgCbXlWRwdMfwYjdiKG479r7uECgh6GWK3Jny6KOt2cKiJV9Z75RrlvsoVdqrH7SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> All details about a monitor event are kept in the mon_evt structure.
> 
> Upper levels of code only provide the event id to lower levels.

"to lower levels" -> "via the mon_data and rmid_read structures to
the functions finally reading the monitoring data."

> 
> But those lower levels need more than just the event id, they need
> the attributes of the event too.
This motivation is weak. If those "lower levels" needed more than what
they have now then existing code will be broken, no? This change is thus
in support of a new requirements and "this is needed" is not a valid
motivation.

Consider something like:
	The event id is sufficient for reading existing monitoring event
	data that requires programming of event id into MSR when reading
	the counter. Reading monitoring data from MMIO requires more
	context to be able to read the correct memory. struct mon_evt
	is the appropriate place for this event specific context.

> 
> Change the mon_data and rmid_read structures to hold a pointer
> to the mon_evt structure instead of just taking a copy of the
> event id.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793753481;
	b=CHi2R6rg8XQTgaoLAN4sQpaFUpoB+EScCScnWBm7VRXnlkcCg3WJOgMXzdU6FsnTKVVw
	 N5F7/rgSr5v9hMZaL1k+XtNTM58tGELyBckXRrU0zk/9bbJLL1b3VGSDrMiomSOQ+lAnH
	 Ipk4QAXLlGHcAJ9CHE7DvVKCXikEc5Uu3x4EQUm+b16S6Szm4RqmkuErZW2d9kqZATX4c
	 D6JhneRhg3c72YBpTA60kNOerYA9oZ3qcE5uXP+4pctPgYSpurv9MP1bwHzCchQSTFXgI
	 xzkDHqNq0JS34KxoTKjLqYACtBSv3UEnOuyJQ6xsLhMyouK/CVf4aOiVlXdwhvfyHFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753481;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=d+VNjbqnIdkPj+Dr8BYT+E+/EzP+AzKN2YbQGjScHUU=;
	b=qhN5P/086leLpQLFmTTQcI40KeBSztk0ly2PnDsxRc82Rdf4SMfcWSgVu+IyQblIgaiX
	 MaK8OT06jRvkv4+hebfipF8/8Xdu6Z869+rGnKiCFTAknVHyfIIj86aTxPHJ/wUFi3BnY
	 iLrw0mFbajHhTRsdxex6ToupTQl4WTAL2hRzVLNmE/2zBfouaLpzKbMChO+cqLnpUrswD
	 rvgAz/MfOZrucwFaz7c6STPBca9TboYJHnTKkMRp2FMsjJ4JpEqeAWldHCbfX6H7CReCv
	 s+/RnR0iAPFX+igYVpyLhdEv6YzOJioRjm/OlDXDpLKHIg32oVkQApiRvC2gRWLBboQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZxtVug9g;
	arc=fail smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F0F606A31B
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 00:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94F0F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZxtVug9g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793753481; x=1825289481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O8L+ZN7/jI5iHUoSXwoBUtJLA35YErXgaoYdC6VgQ6A=;
  b=ZxtVug9gy02Wmt5KJJ8a5fWSjX/aTti/DNao9ZWgrJ6AXMRIrVxjg+ir
   rF5zhhahVgbcza+EqdYhCbQ51XAEKf+hbjGZ+yhviNvihxHZ0NK/NDUWi
   VVDAX2WCnmtsy+4xUQRto8TpZBfmjD05l05mSbBBwiE50z5tZfi9oZqzS
   wJiwnIgB2l97xSybmbTcIaz+65s5TYv/gK8DXnbtg+ECmZQGx4dbc4JEP
   4xwx4G1C9WSYAPDePob/qgCJZr/xQBKhXV8jzCdioZCr9hXnNb5TT18xE
   MKBJp6sM0mPRPoZfvz4N8L1d9RYov0XwMssl++7V3P+3ig/XDMfQn0TV1
   w==;
X-CSE-ConnectionGUID: F6J4Nx9xSZybZ5YQF4B1jg==
X-CSE-MsgGUID: V473piJ3ReGVi8Ire9iXAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2373817"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2373817"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:51:19 -0800
X-CSE-ConnectionGUID: Ej4ZTV8MRnGGaEU8ZSn/6g==
X-CSE-MsgGUID: OE2xKcy6QH6qlex0dhdZ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6584690"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:51:19 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 16:51:16 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 16:51:16 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 16:51:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ye80B+z0FteHpJfVTA0p4+EMFYAhA4N/CLLpUUHq8Uz5OIO61RSBb23a0JZunLTSCy7j4yDUZrs8iPtf89jYsY/6LGsq0TRYl/Erz8XEpoHBY37uocFBf/dRQQQZrAAmpHrOERYyTQQpUjz1xHzdP+fb0PxFmZnJ5zkPrVRKqcsDw5wU+O9M6al9HKRZcz1tj0mFHnN0TYLqvlxrfjsHkGG485IcV+YAFvqe9nNJVFW2NQKw6pw2QLQI+v8hht0MBHkF4mQr+fMRQ3nJuE5Lh+oWVmmdGCqVs4yCo5PV7+nz7SPjTgdbSzwzy3G6ZDWfjayDmkfCtoxuWvhsOzbxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+VNjbqnIdkPj+Dr8BYT+E+/EzP+AzKN2YbQGjScHUU=;
 b=F+ENbfwY5Kr8BQGWt+vZHD3O9Qmt+iEVUqcZKZMpUD7/+tc+3q0yGq0B3ED3wJchGsm8XtCtiyRuJ8Z6KVI0HY4uh0xONFl1lVGQRdX+CfnBVt7/wlG+POeREJgdorr51xJSu9yLgTCMnKC+DXqGKpjhIl/9GMbp4irCqdNMlLv6aTHTw/WLOUPiq2Vhu88on88ftHS6HahIgGaAzv/tvOA8F0W/9PVY1QC7lsnt8wfGI2nfxT2U8QAZYlZR2MVVdcq26l/VULZRWlWbCZDsF1tvWq3m5/26WQ1LOlr09mfSpHN7ISy4Mx/rLzE1OHjoGHg/NWdOEOysHDgBO/3jKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH3PR11MB525758.namprd11.prod.outlook.com (2603:10b6:610:34d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 00:51:14 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 00:51:14 +0000
Message-ID: <56d16560-51ca-4a73-a376-b897bb77e612@intel.com>
Date: Tue, 3 Nov 2026 16:51:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 10/10] arm_mpam: resctrl: Update the comment on
 monitoring domain setup
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <f6080eca2696f4a06777725854447a563aa29696.1792443633.git.reinette.chatre@intel.com>
 <c7f180d1-f81e-495e-91be-b76a4c4df21d@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <c7f180d1-f81e-495e-91be-b76a4c4df21d@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:303:2a::25) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH3PR11MB525758:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e827c39-8a07-4813-dec7-08df3a0dba58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|11063799006|4143699003|261028144727099003|261009223027099003|261026140227099003|261022105027099003|56012099006|261026121527099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info: Zkh7lLt6kuKvdhfAK23gtCQfSm+pcPvGSoqaeJtDuJFZpsG6j+1JRNGM9+/Q8W21RO/TWDrS0Bo+OSgXN6mgOzrrYH1QdvItNUxihwR9RC9NrQRcvcnW3FNOU0SfDSJXt6giiliBzaFouL16QZVQISVZmVAecHMusBFPWU2rBk+6jzgKDSwo7bUF1/PjgDG49pgFDutwVbOGEeWh5eYs0nxQabsaY9DkIb8CsidHlEd7EHKlQEVO5ealrlMX/tv6G0ZUpfh6ZNieB8tG6OCxseamHivd1NGZghLzBhFQNM0UbEcuzEvA1yvCz19e/eoNMK9/6vTh+Rj05MyLEshRlDo1sFX4tz7OloTTvj2tpDQFWXQhm0RfBFvREkKg9+lh3jdXer6b1nPQiGppTIkBN8b8V6+jlSMK9tn1nVmyt3phh+Vp69+Evhq3F6UlaRveCIhUyTJ+UsLnxlPIQGVJdBdBOCFSx1Qsiw7hrJmZmyH7Yn1avbTMZJ0sdZq0+nmD6PfNWE5gY9VwpNamLwlqUzd3HNnyZgLI/s2ERnakvpx/hrFtM2hlXAy8+UtlqHKx7gXLSGN6Vw7nuFYvh9E8ZT7GuUwvjR3d28siOiRmTLWttuv/gl2qUUZrElxJqAR/WHQH7TWIplBKT3/bHNJwaSbToil/AtwGOEvimb4YUQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(11063799006)(4143699003)(261028144727099003)(261009223027099003)(261026140227099003)(261022105027099003)(56012099006)(261026121527099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnljWFdTUXpxMXlaR2NldmJTdkl2SGM5bTZ6YXAyUy9MTW5NTmt3SlNFaC9M?=
 =?utf-8?B?K1lJR1lKYllqSzNxSy9pV3ZIV2VYNTJtMlZwamRwK3puVFpVODFsVU9lajFi?=
 =?utf-8?B?emVJUmMzT1hjY1JaeS9rWURSYVF4S1hXMm5kSVgyZStPNkpUQVJIWDVrazl3?=
 =?utf-8?B?L0xMdVQrZEViUE5Xb3J2RjdtTzVlWXRsb0hYeG1Bcit0SHNqTi9BNm5VcURw?=
 =?utf-8?B?akQ5Q2ltY2oveXdvTmRSUUlSby9tZlJUNU9WMlFXd2xHSGVucmRBV3QyMDkz?=
 =?utf-8?B?R0Q3VHFhenVtNEFCTlFwMDdiWVN2V21MZGZUL3ZrQlNWRmc3T3p1Q014bTB0?=
 =?utf-8?B?dmVwQ2c2Wlo2Sk1sQ2FINGlTdm5xRU4zTFZ1WjBkeGthYStSQU1EWmVyckg2?=
 =?utf-8?B?SXJiNitadVh1akhoNWgwd2NCNE4zK0dmcDlOck5YMHNXQTJveHZtWHZpKzRW?=
 =?utf-8?B?UUFqSDVwa205bUM3ZFpMRUdTdFJtYnhBa25seUpJNUdqcWFETTFONjVGZmxh?=
 =?utf-8?B?UjgwNnBvY3lGUHAzSDk5T2U5cjRGTGdyVkduaFpoK2Q5alo4MGp2UW5CNlZa?=
 =?utf-8?B?bGY0L2Rzb2hFQk8xdVIwSjdpOEFrTUI1Mlk0OEN1YUpSL3AvYys2NzVtNzFv?=
 =?utf-8?B?TSs4SS9xdHhCZHJyUzloQldTa215Z3d6VGhJUmg0WUs5a2l5cjR0dHo2aVJ3?=
 =?utf-8?B?RlRXTEdUdlZETFd5YTRXQWh4ekZZaUZIYjN6MXBvK0VSbmVuQTJkdW9saGMw?=
 =?utf-8?B?TXRLK3kwOTI5eTVlMlhkNFVjdkMxM1ZRVVNEYWdoNFJrYytSSGNmS3QxWmpR?=
 =?utf-8?B?RWZ0S0g5WEZPblBqNnQ4ek1HUnMrS0RUYVkxUmhvU1pOKzMzZ0dGQWYwcHBh?=
 =?utf-8?B?M0QwM2ZBM0pwL21lNVhyZlRweWFCVWJpT3dZMVdObWUwVC84NEttUHR1cG9s?=
 =?utf-8?B?dXNuaC9yWEwrTTVJZUhoRFUzU1d2ZjYvQ3lkMHdQY3B6U1JDVmc4ZW5nNjJX?=
 =?utf-8?B?dlJCYW9OT294UnpZbU5md1ZucTJrMEV6NEFRVmZ6S1c1b2ZQYmtJS2hpM2VI?=
 =?utf-8?B?aTJDTHl3WDhEYUhLVm14cnczTEpXM1NXeWJzWUJRQndhSVh1c2VRSzN3Z0pN?=
 =?utf-8?B?TVIrZXczRFJSTloxS2ViZ25lQjJqQlRES3MyeFVrWTZaeSs3MW5QZmJXTEtv?=
 =?utf-8?B?enlHeUJYRTY0UjIwV2o4Z3pMRWFWRXJsVlNxam04d1RBR1JqelBzZ3ByL1RM?=
 =?utf-8?B?S0o0d01rZThhcTBxQkFwNEtEbTcveitCVnpEdkRqazdTbTA4S2xsZjF3dXN4?=
 =?utf-8?B?T05CZ3JFYThHaERvb0ovaHl0UTlyNW91TExJVkd3MEx2OGdyUEdyNzdWdGNP?=
 =?utf-8?B?SHA2Rkw3THc4UHI3NkhHL3Z6YTFSd2VaZk1CeXEzT1dBQXdqNEhFVWNlU1JE?=
 =?utf-8?B?NkZpTVcxQkd1WWR4MHd2VFcyZklQMGtoY3BTekxSMWhqQkFRVHdPdlpiUzAx?=
 =?utf-8?B?ODNMcFdKR3owR2pXd01NUjJXSzA2bnFSc2lyWUIwZURWTlFPV2l0TEw3Y1Fa?=
 =?utf-8?B?cFEvVVBGWUo1WXhSeStQeUlXdVFqU0lwL3hjd0NJUyt2eExFd0FUclBSN3Yr?=
 =?utf-8?B?KzRZUXM2Z01NSmJSZWhTdmZaYklIY3NwQk80MTVFZVdSayt6U3NaUDZ2Rnlw?=
 =?utf-8?B?YVdkOGgydEsrRkxFSERtQ0xCd1Vab2Y2ang3TGw2MXFuMVBHL3YrNnVCbGNo?=
 =?utf-8?B?V1VsWkRtT1piMkRHOGJUTmt4eGZ2SkN5QW1MNFJLZnpTN3VxdzJDbDIrOVVv?=
 =?utf-8?B?aVMrSFJCdzFmMDd3OHFhc1pPbjIwMFpPeU9PeXhJM1RtY2hGL2Uvd3kyYTZo?=
 =?utf-8?B?ZElpcGdrb2ZnQk4vZzhQVGNpK0xkaUtOMzZycW4veEtMWHErWUhqM01YWkFY?=
 =?utf-8?B?MklobUhXZzlOb1o2MFZGc29WMTBLNkg4S1NhOUVvZ1NkVVNCZnppblJNWmtN?=
 =?utf-8?B?VFVWY200azZHdkhLY2hMOFVlbERvZkVPRGJheVgvWmRpdWpWZGNqVGxzZitm?=
 =?utf-8?B?WVUyc1l6cVY2aEdEQTIxTVZYdnFDcW5uY0JhdWUzeEVtbXFOakIwOWw1OS82?=
 =?utf-8?B?aEowcmxDT2VnbE5hOGtndXdESTVwaU5zWGhObGpMRC9sRE0yai9zODFPR29j?=
 =?utf-8?B?R1p6bDhiZUdIMkhjekMrL1VkR2tDYkUvbVZhdkVtWDVyeFhHclV2MnVSWEN1?=
 =?utf-8?B?eFpDdWxnOFo4Y1pBUUt1d0k0NjRDSmRZZXM0anhhWFBaOTFWVXJlb3ZGaFFQ?=
 =?utf-8?B?czM1RmdsWmorM1NvM1RJcmhXSjlpUmV4UEdGb1E5cERFSmpSdGpxQXdDbXlT?=
 =?utf-8?Q?3lHjFiy+qya7VR8Y=3D?=
X-Exchange-RoutingPolicyChecked: ttcULE750DTr88+OTFv+0n9jFEY3WRqXRgWNqdKZhQyJ/DC/JwA1mxUGkj0r6rtZ0LolBxxDkN/UVowLEhQLSrmCc2h36W20CPZN88VE/vi2TzhaSnQbb3su1gQ9rvCLJVBI68F7h/2VVGWFid8TU3nu3UFldqRMl0U8C8YarTTsLxwKLlM74uRcnpiw1/4d+2a9S6EDL2SvhDIaUNBNPA7kKf59Mm3kS7J9M1qZxYXr9APVlJw49NT2tyd0GYO9t7Xlp6TwblbDhMTWki0G8cuEs9XXSyaVatUOMXcGg/chYwYPJXH2s7aczFo1orkLwbUZS3X1x+NsunxFROyONA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e827c39-8a07-4813-dec7-08df3a0dba58
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 00:51:14.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bh6WKNfsPGHGi9+0VxxBvjIiCfFwH/tR6iCb5Q18aUlX/RP6y4BILVuBFyOWvBbADl2de5Z4kXi2h0lhKCZz/XJ81GGad4z6AlNyGej+YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB525758
X-OriginatorOrg: intel.com

Hi Ben,

On 11/3/26 8:27 AM, Ben Horgan wrote:
> On 19/10/2026 23:07, Reinette Chatre wrote:
>> The comment in mpam_resctrl_setup_mon_domain() explains that the L3
>> component IDs need to be used for a monitoring domain because there may
>> be no control component for the L3. It also describes searching each
>> event's class for a component with overlapping CPUs.
>>
>> Neither matches the code. The monitoring domain has its own structure
>> and is set up independently of the control domain, so whether a control
>> component exists has no bearing on it. Each event's class must have a
>> component that contains the CPU, and all components of the domain must
>> cover the same CPUs, which is stricter than overlapping.
>>
>> Rewrite the comment to say where the domain's ID comes from and what is
>> required of the components that back the domain's events.
>>
>> No functional change.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>> Note to maintainers: This comment update is kept as a separate patch to
>> make it easy to review. It can be folded into "arm_mpam: resctrl: Give
>> the monitoring domain its own structure" and "arm_mpam: resctrl: Require
>> monitoring components to cover the same CPUs" if preferred.
> 
> Yes, I think squashing those 3 patches together would be good.
> 
Done. Since "arm_mpam: resctrl: Require monitoring components to cover the same CPUs"
depends on "arm_mpam: resctrl: Require a component for each monitoring event" for
which you provided RB separately I re-ordered "arm_mpam: resctrl: Require a component
for each monitoring event" to be before "arm_mpam: resctrl: Give the monitoring domain
its own structure" to support this squash.

At this point the next version of this series looks like:
	arm_mpam: resctrl: Add a helper to find the component counting an event
	arm_mpam: resctrl: Use find_component() when allocating a domain
	arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
	arm_mpam: resctrl: Do not fail CPU online when domain setup fails
	arm_mpam: resctrl: Split control and monitoring domain setup into helpers
	arm_mpam: resctrl: Require a component for each monitoring event
	arm_mpam: resctrl: Give the monitoring domain its own structure
	arm_mpam: resctrl: Rename struct mpam_resctrl_dom to mpam_resctrl_ctrl_dom

Thank you very much for your review. Unless something shows up I plan to send the
next version next week.

Reinette

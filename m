Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB46D33471C
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527140; cv=fail; b=d2/bOesiCuCRQxtq7hLsdBeXcXVPmAVAR41siMG65PsuubIhC8CcdnPOYaOPDyQdXGI+PJhDztZScDJQWXWaswiMu8KL3fJk7dxvArHoeQVy8qvo9FLhmlabyBelA5jfcskiikeL0otgT3Q3NtmEOd7kE5aRajMs9O7njgEumXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527140; c=relaxed/simple;
	bh=+f0Ll9oAAUTjBu1pf+rg6rU84DdbK+RlvwJkk0+kp0U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hzwz3Iqg41+aCHK2eon99b2PYMXfFbpcXSULUL8Rbk3f3DfKEFOS+LQo2yD/ImQQyJDruMUQXEmDyypw9M3Xnpe3mGKxgoTfkyNezZjucPK1HqcZWBUV12VhhvE1Gaa5PJDfxtdOTawOxybTbHS5ui6XAL0hwMM4O/d36Gf8RPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HhVeC8DA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HhVeC8DA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527139; x=1789063139;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+f0Ll9oAAUTjBu1pf+rg6rU84DdbK+RlvwJkk0+kp0U=;
  b=HhVeC8DAcj9a7XdSv0XdZHtbH6ZFspx+hYLRxH05+pMnMaFwwl2B04dH
   bryaZeld6aQJFeY0eWU5sOGPa0Jl10BXcT7HiqxOwktmHi7xcU+TI+G98
   8B3i5hk/xyhgO5XZV4N2ZyHq03SRWSoqNidm8SURwIEM0n8WRNb0/AGF3
   DpiGWm37aHqYla93xuluvb1KmaWZ0NE2uhBcbFqvrgFvK21chqKovsfDj
   34OrsWW0/HZNNObGJprao3ozlTz9aiuoMf1oW526PBbQ0emE0ugmU48n8
   4k9BBUuMTwowAwZL0KFhF4DZjvMb3K2bRTjmjfis5Jtz34OEoaWii8Cj+
   w==;
X-CSE-ConnectionGUID: ZwJEKeYlRjmkrRnxZUtW2Q==
X-CSE-MsgGUID: l7QGYaUeSzyv0Tb8U15TGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="70102869"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="70102869"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:59 -0700
X-CSE-ConnectionGUID: k5IE0TePQciu9ggthYAYEQ==
X-CSE-MsgGUID: tDXYIsRrRGu+GY+S3fpGmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="172751339"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:58:57 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQ7wxzHpJzxdrNrq1cW5FN4Nuer3uCezk5GzIdUrVVjXbWm7PPJT5o/Z0yb20KuOdceV2qK+A5SlteKlcx1MW2ilQIvgWoU4vE0SIMit231TBngLZtKlGSYSqgZCQn+jloWG/xCRvIj5h3PobGYn9T5phRFAw3xGbxUrpCh3NpHEutB78LfizD5NuHoREKZBCJ6KUSOxqiTbrZHfVyetqYig3XaprWqNOfUI7Cvgexr+5+Yb4Leaac0qI1CcCuvpfYBEI2VgGvvnfXtfZT6tsH0cBzVPsrJBpOZYCVg5sZrE26wXJCEE+ROqP5GM/6L+gx/ndpj0D4qQ92QN7iAU6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1z25qqDyHt7gkL95bP2GYAL1Py1ew/NjFoz91WVoiY=;
 b=p3vZ/0iQwcMJvGY+IlWu6tHm8af1B4l2L+oz4UFEZWqaghxNHbha3tu23Bjvp2CZye8hD8KWOIfd0fHCumoxepM8wCR8/mCX8GrSXv1OSzW5m9uNXWVlBTEZxpao8yoexRw0dgfXpSE6U3VSNpHOXIXvrIYchaHqKms+Pl0bdHVLLBrktAUld1K6o/+9nn6CIdvzFStuXXL00UehxyNUi0xgBdHvJcmq9GKDRWDVDghCzLcovGvV+KmDA/vsV0pxRYb4tNKNze8O4TzG3tAGaG7qVx3kwU95D8uJaDLji7m3CBzO1pjhb/H+xZT2z3itjkZ92A8qiBavIF3neuq7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:58:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:58:50 +0000
Message-ID: <0cc5fe14-4fe3-4e18-bd50-59476ba73f56@intel.com>
Date: Wed, 10 Sep 2025 10:58:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 29/31] fs/resctrl: Provide interface to create
 architecture specific debugfs area
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-30-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:303:b4::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a737b23-895e-4019-99b4-08ddf093b253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SkxlYmxnK0ZJRFNjOUIxR1BDb0V4K1ZmOHg4ZUFlVXJINHdJUUg2RUZIVDZR?=
 =?utf-8?B?UWhmdzZWcXQ5d0dqeXRTaGpUNXFlcDlESEp4VTA2c01RZnJKSVNpVFczVlAw?=
 =?utf-8?B?VElBUkpNMzNML3U2ejVLNmFiTzJ6RXdkOFFIbE52cUQxODlOSXZ0T0paM1Fu?=
 =?utf-8?B?UXQzQkRHcGdvZ2JLb0hVeFo4VUc1aVhYT0VCdGZUU0R0LzJtOGJOZmpFSkxp?=
 =?utf-8?B?YW5Ba2pFSm5UMXNKSFNVZnJzckFvUFpPN1VYMTg3SWtNTnVIUi9Obmh2RWhN?=
 =?utf-8?B?L21XZjVhaWpxelh2OEl1ZGNnd1llN0xjSWtuQjhzRVoyZ0N1Q1ZnWDFxVExR?=
 =?utf-8?B?Rkp3Qks5eTJlVStXU25IenEvUTlXYnlMaTZaSjNaVGVUUVZFSFQ3bFdlZUx3?=
 =?utf-8?B?eWV0V2pzWlZLY3BmbGtycXI2OThseFB3R0YvSW1UMG9VVTZ4OCtVV2J1Z2dO?=
 =?utf-8?B?c1dEK20vQkdIVlgvMDVqU2laUUVadGw4WFBOM3pGcEZnay9LZVRSTFBRZU1K?=
 =?utf-8?B?dXlUK0s4NFVBSlkxbFM2VnQ0Q3hhckp1TkVLcWEzSk5FWTZ5bC8wcDZ5LzRl?=
 =?utf-8?B?cDJlUlNDMng0cVp5cmRCT1BuT0p2cURuQXBDNmtGQlhxTmh5M2toZ2dURE5C?=
 =?utf-8?B?NmpxMUVMMVJuRXhRVENpYTJXQzA1Rzgwemd1eDZWNTh4U0kvUDI2RDZlRjBs?=
 =?utf-8?B?QmEwQnZSSi9JWmp0NUFSZE55M1RTWUdmWnl4cU5sNlgvM3RSSTRuc0tCemJY?=
 =?utf-8?B?dmp3dmRuZjhyTGppMVJNd01ua3VqMHpuR0hSek1QRkdPNWtSL3lTY2NzdDBY?=
 =?utf-8?B?ejVHZ2RsZGRSVm9YWUJLZTVCOUlkTUk4UUZBSE1tb2tUSDlrMXN0U1VWYm03?=
 =?utf-8?B?UEJ2aXRUaE1aSTN0djM3S0xpbGV1RFhqMEpwSUF3ek5EZTViU1VWZFVDbDhk?=
 =?utf-8?B?NGlNMG91WFNBN2tpQkl1blEzYVJqSEdPVVFIVEx2cWdVd3JVcVZwU0p0Slcx?=
 =?utf-8?B?L3dReTlhczF2QzdWd0NIeFI3dEFtZ1I2M3RlVlZzVXZxcE9MRXF2V0Z1c3lH?=
 =?utf-8?B?dmRZT1Uyb2dTVUxxZGJ6QTJTZFJZeTFYZTZBbVEvRXRkNU1Rd2VwOTFrYnVZ?=
 =?utf-8?B?WTdFSXM3QktzbDVDYllBMHpWejVBdGNLSVZXQ2ZDazVzMmxuWE1aZ2NRSGxO?=
 =?utf-8?B?anNLTC84dWlkWXpnSTJDU2NWOGRsdDBrQm41RDVkRjd2SkU4VS9xMkgxVEQz?=
 =?utf-8?B?RGsvMHMvclUxVE5lSW8wdkM1TjhLZjFKQ2RWNnh6dkVBZmVNMGFQVGErR29H?=
 =?utf-8?B?Yi9Mdmpoek5jdFpmVzNoekNvVFJncExtdm12ZkxBTmplNy9BSk05eFA3Y2RL?=
 =?utf-8?B?dWRiT1RlNk5BT0s1RTFZdzlLSEVtdmVpN0ZieUtGVlI2QkxScGVKWlNtVHJv?=
 =?utf-8?B?MjBVZkdkM0h3U25kdkt4SW9GbVhSMFFTRGhlcGVrTklOYUdZVTZHZ2xiTTd0?=
 =?utf-8?B?ZnRtaWtHbGtmeEJDZk44V3JjbGZiRTBWSDEwcGJRY0g4RFFPN0NmWmFGNmh3?=
 =?utf-8?B?QkZyZ2RqQS9QOFRabk1yK2psMENJMjd6cjh5WHQzZllMVWlNVHJJN1hOdkMv?=
 =?utf-8?B?MjJ4MG5pcU9UQy9CTlB5T2pwQ1pQS29DS1RmQklLWGd0bGlzQ0JUVEt1QjZw?=
 =?utf-8?B?bHFWVTVvczcvTi85ZXF3amVtbEpFUXBwdFQvM1ViS3B1aFd4NXpzTXJBdFZD?=
 =?utf-8?B?blJtK0QzWlJmclhVVFJvWjNOd05LczNZUTF0cU1qOER0UW1zOHM2UDQyV2do?=
 =?utf-8?B?OTg5Sk0vMVRoQk9lOTBGdFhHSmFrSklVM25maGcrcDZIOG9qMHl2T24ycDMw?=
 =?utf-8?B?cnZIWHdTRmxSUHZXNmhtQ2dEZVhpdVRPUjV1RDlUQTRRa0hqQTJoVU9kRFYx?=
 =?utf-8?Q?UjWp/4Loc6A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTk4S3lUUHVub01VcTBWcTlsSzVuUWJnaXlDb1M2RWtPRms4WXdsNDd0YlM5?=
 =?utf-8?B?M0x6RXBZL3U4ZkdMQUdDd0lEaHJwckljcFltcDlMNFkraW1hd2h5elpkRXYy?=
 =?utf-8?B?V0VKUW5pTVNLUGVkajU1aVR3NndraVBta3ArV1g4bmtZZVR6L3hhZVBSUDdW?=
 =?utf-8?B?RTBBNjl2ZmhXM25zZjhtTmh2K2VZZ2tVTHd6VVFhb0dXcXIzcHRuUWVLVGxP?=
 =?utf-8?B?eGg2dFU2NkptMjJiWEJCejR1bDJQdU9JOHNzTFZxRlVoRllwTXpNTll3UmZJ?=
 =?utf-8?B?cHJNTEIzMGtQeXpKcFNFTU9nUG9NTnRERDhTY1lMQ0R2eWxCS3hwamJOL0hv?=
 =?utf-8?B?bzJIYUg1aU9WbWExcnpUemZwRUhGK1piSlVBUmltVXJlWVZ2UFRaZ2EvQWVV?=
 =?utf-8?B?ejM2bHJSZkFhOVdLTHFSV05mTURsUS9HenZPRlE4Nk10WUh6Qk1qMWZnVW04?=
 =?utf-8?B?SkFYTzZEcHc4QWMzelVNUkxpNitGUWd6NW5xSFRad2FmdlhRMWk0OUlPQzYz?=
 =?utf-8?B?UDFmZldUKzVVbmw3cGtuaFF3REhJNHAzcXVNdzFmTXFmVzhsMTlxRE8yRCs3?=
 =?utf-8?B?cjhrZWtQTlY3UTVvbzJtc3FBYUk2d2ZVZ0NZbkhUS2prWndMUERsVmJyYSs5?=
 =?utf-8?B?VzhJRjdqQzZoQzlHcEMwcmVha2Z2RTZtVTFFNUR5c2F5MnRKZi95WU1xenY5?=
 =?utf-8?B?eGp1VXZ4RGtxL0RVS0V6OWNaTlVGUFVRdnNyWVEwZlE1emhPcHU5ei9MN1Vp?=
 =?utf-8?B?WmtmUDdPNG11a3A1OWNPRXJsKzZMM3AwTmtSNkcyM0hycGNTVWlWN1JhK2lM?=
 =?utf-8?B?d0llcXFEU3BWV1AzWXVtWm9hVXlOQlcyRVJ2R1VVTEIzNi9odXc1eks0UERt?=
 =?utf-8?B?ZWhlZ3l3RUQvMzBXR200cCt5aTNJVWFpZGJBZVhaYmc3aFRiQ2tMbGQwY2lj?=
 =?utf-8?B?cEtqeW9TYU9PQmwwRTZkUCtHbnVIWVRLOUh6eFZXR0RnL2srRXZZdjk0QVZs?=
 =?utf-8?B?dElOd1RTL3F4aTUyTjFOSmhOcis1ckthVTdCVjBvUGxNeStNTVRNSWtDQmRQ?=
 =?utf-8?B?OEJxZW00UXRZZURhL21wcnIxOHVyZmRMNkJmME4xakR4ZmxUUnhXNmRpYW04?=
 =?utf-8?B?bDZqUlZGUkwvQVF5am13VElGR3g1YlFDSG5vcFA5QnpzU2YvczRBNGFBUDBZ?=
 =?utf-8?B?dTh2V2phM2NDdmxHTkR0VXpkNjJCZmgwVUoyR0lTYVU1NHNWY2JMVm1UNTV6?=
 =?utf-8?B?TUxmMDJLdkZjUm9nYXJmYjVpVjd0aFJLQWlhMjlrVk9VZGwycmJ3VFpDZDBE?=
 =?utf-8?B?MFBWNC9xT1h1US9ncXVlSGZhQm1qb0xnQm02K1lXczM1Yk9lb1BycW5FWEZ5?=
 =?utf-8?B?Z0VIYUNvUE0xTUFNVlpJKytnOUpsa2Y1b2sxVnFlUmcxcHhuWjVLYVJDaEF2?=
 =?utf-8?B?VXMzamRRTzBFZWt4aHV1WGU3ZU93TEZtb0wyWDJjaFpxUUN4bjliV0tHY3o0?=
 =?utf-8?B?YklHcHpBRm11RlltbGI0anBjcXArSm9KWTZSODJoT0EvdGpzQ3ZRTU9zWE9X?=
 =?utf-8?B?TEo3TjJYTWhJZlcvSUI0cmEwNHFQY3FTUURsVDI5N0dNcVpBanUwOE92Smo5?=
 =?utf-8?B?emxvcHBxay8xazdKdUZ4RnYvMzVTWlgvQnpLR3Z1RitxQS9jZzdtUE40UTN0?=
 =?utf-8?B?Q3daTUZtejZINUV4OTl1d25xSVZaMTgwMDByZWJUMXp6VjQ2anBGWXdGaWV0?=
 =?utf-8?B?Smw5K3RLTmxjbTJJMklPNGowNm1WV1ozOTN4U1dWL0w5L0x4ZWxYelY4eUpY?=
 =?utf-8?B?OVRtU1JwS1A2Qy91bXZHT3ppL1dUOXppc3dITVZBbjBxb29QeWtPcXhic211?=
 =?utf-8?B?aXJjQWlza05SVHczaGFLRzBUM2lUbjZwbkhZSjlxNXdEUHJ4TjYrbHdiZ2VW?=
 =?utf-8?B?bnp0Nm1kZFVvTnZqNngreHJTR0RPb2J3NnI2SDZWL25EUC8wY2QrdlF1N1I2?=
 =?utf-8?B?N2NuWnh2OW9pVUZQL0NEV0p0WEZROEdjTUxiTWFUR2ZOVFYxOFZISlQ2NGNH?=
 =?utf-8?B?eWovdXlVbG8rL1RXZnU5KzU1bHkrMVpCTWFwNnB0aGk5OUtMK3lRWGRPS1pI?=
 =?utf-8?B?QUZsc3N6aDBQYVJhZTRITXc2TUc3MUdqOHpFOGhvVGNkNWxhMno5VzBVUXJr?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a737b23-895e-4019-99b4-08ddf093b253
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:58:50.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnYOB7vNkQ8HqiHVYgvTZZPjvRvafmH7kIR39j5aG6my07OORruzJ5bP+g/pWsQTmHVsd5p9Bq4d/FSLU1j+zPZ4cUC2Lhbp3QmeeKMT/28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 1f42bc761377..8a010c29c8b4 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -569,6 +569,15 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
>  extern unsigned int resctrl_rmid_realloc_threshold;
>  extern unsigned int resctrl_rmid_realloc_limit;
>  
> +/**
> + * resctrl_debugfs_mon_info_arch_mkdir() - Create a debugfs info directory.
> + *					   Removed by resctrl_exit().
> + * @r:	Resource (must be mon_capable).
> + *
> + * Return: dentry pointer on success, or NULL on error.

NULL is returned if resource is not monitoring capable, otherwise
it returns debugfs_create_dir() which is ERR_PTR(-ERROR) on failure.

Reinette

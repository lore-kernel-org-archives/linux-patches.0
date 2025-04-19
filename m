Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646EA17E
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 00:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745021312; cv=fail; b=MLb4QE8Yh3d2mUvz9wQex9S3lRiVOURmWWaorOa/7oZfkHn7Mb4t9v1zxOC11Q7nB3j0V13RmyZP91EfM4UNxymD03nDHeNfDYWh7WklSqdOOVrFxbRWDx1wYi4gJm7D1rdxJpW9Wm6HP+YENoVq6lpjBU1Wlk9xpgm8dqmEdZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745021312; c=relaxed/simple;
	bh=+cJDLYq/tLWMaAPWWv5DYjAz4hlQukaGFl8ow5awg/Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=juPVXUmYtSdbU43TWG5FJwTra4cJYWlS7y4qbJJ74L47rJTvPUTbJet0NptwavjbR37FdMfHlPWm3abVjryWizVb9D5Fv4c3YBurOHT32tOwmtL14ocgQOeX8nUIC4zjhshJKegHSdcMCsgMgQ9biwR5CT+480c0QVsLiBETFxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jH+1yW+1; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jH+1yW+1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745021310; x=1776557310;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+cJDLYq/tLWMaAPWWv5DYjAz4hlQukaGFl8ow5awg/Q=;
  b=jH+1yW+1mL0DIuvHW65lu7Wo8gD2M44HqdLrl/JqNk62Wu2mAsk2/N0G
   B8zewHWwtl+x/LtEAKBm4j+bBRHUwMv3g0yur7LL0vsDEyJ2Tp6xxWmSc
   +ERdrdrOdklLtLl/QH7CTP15Zh1UP0Y9dJ73z1CgNhcq2jqac/IVreZFQ
   Jg8BPwqwIR8kUl+TjifeYq9FjGKWOis2jtHVkJ+ym1WoFrkGq1z3/OJMN
   LQApjBRR+KrJwotWB2+4ViMqibBvuCLx8Gjr0LlJ0nQlbLNnx3TvixRFX
   KzyBvKfXXUUpZU9MwI2u1mbZ9yveiIp7/1Yvx6+9saqtjMEsOGIyhfBcg
   g==;
X-CSE-ConnectionGUID: l3kcZCftTB2dk4q4mFV6DQ==
X-CSE-MsgGUID: fLVAtoJ3TGaCUavZ6ZpheQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="49319541"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="49319541"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:08:29 -0700
X-CSE-ConnectionGUID: yMqSM70lS+6hNROHd8G4hQ==
X-CSE-MsgGUID: im+U7kdET8KpMIXw/lYBQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="154405742"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 17:08:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 17:08:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 17:08:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 17:08:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdP2j4aD+a9bZ2uPiVl0/fbTPDal/+tTDuo0aDZcj81GNXiVzMEsczg8K49i8QRvRBzxw/Dbi3LBl63ydHjyJ1rZf5BNL2l9LXQ7UIZ8PG6rWWXvjTw9O456HMigJfoHDCxwHy0PtGBpOomgBcurDYq8TXKhcRA2PsaAmADvV+BcnbTrfE22t1A5CqygtyVrK7nx2QmYJSyMFGJrA6yVKcJgn8+spAMmuPYmU6pU13A1luXojyPeRc5+CZhGcldznrUCAh+lMgKrFtBOXYq4N05toszM2lq+EVKdPsKT2Ojs0LSOEVPnFWPTYNzOmJekNs9ypSuuI53S6sDhdwAweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVrpdkvHvWcJdihUKfHcxwXr9JuK8pQU+Ph91OqORG8=;
 b=IQlQaRHB08j/hUrrKGcJPpUUfZyQJNELoCFzDKWq+Tm0jkr3GUL4BM/n9t/RN/JdSyjkHZCat/gFPjV259PyP9NeywZc034KwjphfXSN435C0n82MInEU9zuNljRXs+IV5/am/xWk/iHHZj9hmMRNhJo63FJfDnXn9XF3Ux4XLQOXYeM72NYyjYNExb7udLjZPA+ycRpDK3LRd/zjf41xy0FQpEKmdm/MVSyYuECJA7ZiUiNPizSfjkQ3leHESoc3VFvAi9IDlCfHZwX0ceQxP8ejCnrMNxLRcyw2JLxpJ3S7qjQyL/i6gksYIbG8PdFA2Axc6KwevOSJXxaVLErPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.26; Sat, 19 Apr
 2025 00:08:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 00:08:20 +0000
Message-ID: <74e6bc40-7d91-4175-a59f-f16dcb281a7d@intel.com>
Date: Fri, 18 Apr 2025 17:08:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/26] x86/resctrl: Add first part of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:303:b6::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV3PR11MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: b72348f9-eea6-4cd1-6e0a-08dd7ed64b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NWNmOUpJWjR3YXMvWVNtZXV3K2RtTC9QcDdrNTdIWTgyeU4ydlIvWjk3Vmhk?=
 =?utf-8?B?WEdkTTFQMnRwZ0p1UUVYYlBCMERKRkp0S0oxUm5tOVpkczJaZExOSlQranU1?=
 =?utf-8?B?V0liNUtNMGR6cFRETDlJV3JBaEJSaVpuTzBvR3NsSWI2cWtDUmdhV0lFQmEv?=
 =?utf-8?B?ZVNmb3hqNEtoWnVicStmc2ZqMHQwM1liMUF1Qkk5ZUxEeHZ3REV0WHlUMzRS?=
 =?utf-8?B?OUJqQUJQbWpOS0NMdHphQUJlbkpzMlQrK3prQXF0NHgzT3lCQkJWc0NaYnFn?=
 =?utf-8?B?dTRuRUU2cHlEMHd5V3pHOURHY0MzT1lSVFVxRnNqY2xlMXQ1cHlkRlk1U2Nj?=
 =?utf-8?B?TGxOMm9DRm5PVTljZVFJdlNncEEyVytjSmdqQXd0dStLb1pRdzFvVHZGZVhk?=
 =?utf-8?B?THJqN25BWktqL2dBNDhKWkZsYlN2ODhRUXp2RXdGV1N4ZXAzY21EU05XL0h1?=
 =?utf-8?B?NXFpZjREU1czTHdvVklaamVCVTljcnVjZUJUV0F6WjFRVldmV3R4bmRMRk5m?=
 =?utf-8?B?ekhWTEJrNjhGOCt4Wk9jZWNacGRYQWlJbkwwNy9nSHhsRjFrL3IwUm5jNUYr?=
 =?utf-8?B?Z0NSdkcxaTRrTWpycWJEU0JnK1JmcHZqWHFDZUJVaDM4dC9URXZ3MExvSGZN?=
 =?utf-8?B?enV5NWY3K0gxcy9FeE5uODlwMVVxRnY0TThVeVNtYTkvb2VCVkwwem1lZVhM?=
 =?utf-8?B?VFU3Tk9uSWFvaFV6VUxWV0JSeS96TjlDZUQ1RUJBYVVtaW5xc3pvd2g3VTR4?=
 =?utf-8?B?ZmJ0bEZQZDM5aytNZlplR2UrUlErdFVENFhhd1YzdXJ3WTdnUHdsU3FYYWJx?=
 =?utf-8?B?MzkvZWdIbk5od2twaTJDL2xsM25paHZXTlhFZ1g4TkhZby9WTVNCNnlsN1Fh?=
 =?utf-8?B?N2pvQ0xzTU5SZVVlODRDYWFUSWJKNmd2TEg5NDBiOWZDc2RiaStmWGRvSFBD?=
 =?utf-8?B?UW1TcVpOeTRSTWpSY01MVGxBRmo0bS9OazhsYjF4QlpFWkZEMVFVME9WdWdo?=
 =?utf-8?B?aVBEOVJrckhteTdFc3R2WFlSUUxzQTNEbldjbFpaTXI3WXUyaU5rajdNb29L?=
 =?utf-8?B?eXhNL2djWEIyc3NvanliZkpua25DZS9yVWR4emZvajIySVRrcnpSSGhkSXow?=
 =?utf-8?B?dW1NRlFsMzBma05IOWQrUWpzTVp1UHl1ek91VE1hWFUvb3k2dEFPVlBLNHpC?=
 =?utf-8?B?Z21yamRQUHNkRFhOYUNMV0lGR1BiUFA1MmZ3dG93VGdOWlQwZjFsSmFOaHRZ?=
 =?utf-8?B?cGlLa3NtVG00a1BWcVhqT1htZUxmYlh4UnZGQXkzNUtWZjlMQ21XaC9kczhD?=
 =?utf-8?B?YmdHTlhDOTZOZnhXaHlpNVFGVGUwK3ZRYkRkR05zL3hmRWFrT1pHWTAyaGtx?=
 =?utf-8?B?NStyT2NHYlhHV2xkVGNhZmhwaU1qQW04UTFkRlVHZG5nMU5kemRkWU5nYlJ4?=
 =?utf-8?B?OHZOZjIzWDlEWVJWTllTd1pOTE5oa2VCOTJLTEduVkRQd2ZEd1lvNzNROE9I?=
 =?utf-8?B?L2hVdzlpZWd3VVNBU2FieWdld2dVQjB0WkQzQlZSMlBRYTZPTG5XM3ZxRjRa?=
 =?utf-8?B?OFVoVS9hWXF4UjhIMGxoTzkrOUoyWHF3akJTMWVrMlZBV1IrQmRnQnVmcnp5?=
 =?utf-8?B?QUpZT3UxZTlpOVBXRWJ6TFJiQXdXN0c5dk11bUoxUmFaTE0zNE9sS20xN3dT?=
 =?utf-8?B?cW5OSEMrdEprVDEvZjd1S2xmelA3aUJkQTBiYkFNZnRkbWRwbVBQcVNaanZN?=
 =?utf-8?B?SVVrRlB4Skx4OXRXaXhtek1aQjI3OHNUSGZxeUZvM2NIVjcxbnArZmthWmdB?=
 =?utf-8?B?MFdXY0Q4bDZMRlVwN3h2UktxWEpob0EwWE9ZTHdwNFdmNmlpc0JVTnVyN1Z1?=
 =?utf-8?B?WTVHUzlNYnlOZXk3TkF2bzJzbFlNclcxMzlPOTM1V3p0TFU2cGNNOS80SmFR?=
 =?utf-8?Q?BFm1pJ+4boo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MThndmQrZENsWGU1aDB1bzVTSHdrZXorMG9JbXFXc1V3VlNibmt4MkREUzRu?=
 =?utf-8?B?K29NdkhrN2ZZM1dBcU9Ta29Pb0xNQ3ZDcHR1cDRhaVc4eEhxWnlGNHdRd0ZF?=
 =?utf-8?B?V3U2TGxDOXViV1REd2M4U3VoWlZ3RGxpN2VUdXdDMUwzdUhaY09sRzJiZGFW?=
 =?utf-8?B?VUtjUkVNOVhOa1B4S0Q5M3E1WHdkUjFRRkJRalJoOHpmSExGZWlVcnBHNTZM?=
 =?utf-8?B?Uk1uMVMwMVdRL3ZpMVFUQUVzL09xeExFc3V1T0tGd1BZQS9QQ2NzS3ZzOTdl?=
 =?utf-8?B?MmNpRktjaitEeEN3UTNzdk44czFnS3FQM2tRdlowNlZPSkF0OFNOOHQrT1Q1?=
 =?utf-8?B?eVJqU25XVmZ2cDlxQ0I5d1NDSzE1b1M2VVlmMGk5ODZZSzY5bEhVZXYyR3Bj?=
 =?utf-8?B?R2YrRTBtT2lVMUhQWUZmaURpVDR3OUFldDVMVE5XWjRpYmJhK3I2OFpDbUdy?=
 =?utf-8?B?UE82TnZYdjRtL1pLS2tYT05FS3BEUTJiNEE2VnZYakFaMW1RN2xjNThPUVJZ?=
 =?utf-8?B?NnlLcE1HWE9XQ092d2lqNGFHNDFNaUhsNGNBT2ZJM2o4dThtMGlVUXJOUk5z?=
 =?utf-8?B?RDFZSVJCcXM3WU5YZVpvaWVjK1krSTZ4OTNJZTdDSUN4WVF4eHY2RVNkQjQz?=
 =?utf-8?B?bFFEYXp1S0RyQU95cmhvcW5XOSsyV2p1VmpUYUIyN1pMRGxVK2hWQVYyWkhF?=
 =?utf-8?B?bWY1L3RWMTNLVm5qWTJrS0NiRVpmSEZlSTFObkJLc2Z3dzRtUndqNHFDY1pQ?=
 =?utf-8?B?OHFFYW0yRWZMSEdxUkZkVnNYV284aTFXVnduZzJsWXBya0pqV3R1REllNnpV?=
 =?utf-8?B?Z09tMG90NjNHb0ZJT2t4WnJ4UzA1ODhLVzRucHFVS2dvQ2JCNDZteVVHSXFW?=
 =?utf-8?B?SWhQVjI4WS9Odm9abEZGTmtaYlBsd2FrenlmSXBpODV1SEV3NG15bnVPV2lH?=
 =?utf-8?B?d1ZscUVQeVFHdDBJWDdJQUdqM3lTZExudEduWU1tZ2wyVkd6cmVIanltamZF?=
 =?utf-8?B?dFJVNDVKTWh0eEg5b2FrVEZneEZlY2crOG8yeGxwSk5mc2IwTVpOam04cExT?=
 =?utf-8?B?U2ZMUDQxMUFZSmdXdmR5VW1EeXAzWVY0b0lDUkNEU3ZUMmFNK0lKWXdJZEsx?=
 =?utf-8?B?YzZ3WmM2RUhOMUxZaXUrRkpVeDU2MjJOK2k3SVE3cUM0allMb2ttUWdyM1JG?=
 =?utf-8?B?L1pQY3hPTUY1OU1BdmxBUjRkcTFXY2NEVTVEaTlidDdEamRLSzV2T2xWR09q?=
 =?utf-8?B?ZWJWbTNFVXgxZzlERHRxMVJLRWIxSzJuVTF6WXlNUEdpRFhMb0lDcWd6eWhB?=
 =?utf-8?B?Q3R4ZjF4N3d5MkZCck1iVFpBOGp6Z2lXcVR4Si9TT0QyK0RwZHJGbFhRajlz?=
 =?utf-8?B?ZmJLS0lJdHl0Wk5NdVBxWHpOSVNnd0dnak1XK3dRa210OVd1Z3VYR2xROCtV?=
 =?utf-8?B?Z1JOdDFsR2pwa1dtb1dVNCtLTkpKSmE3M1ZOSUlOcVprM1MzcXl5cEM5a1kz?=
 =?utf-8?B?eUI2c2dQQXI2dTVZa1N4ZEtwU1l6R3REbjNlMmRweE9FNTJpSmw5ZUtpZTRC?=
 =?utf-8?B?ZVN2a1czbFdiK2FUQU9ibHZhMW5UYmdiTWtiUGNXVzlKaEdkYjRzZXJuZzBB?=
 =?utf-8?B?SnJWT1FId096Z2Z0YlZLTkxmdDY4NUdsZXZrSFVuZVBOdVgwWGFFaEtyRisz?=
 =?utf-8?B?RGhzQVVOOURYaWpKaXR5ZEphT09NWk1PN1NZMHE1RzREenBaK3V0Q2V4MWpC?=
 =?utf-8?B?TjNSTDZ3WnhrejhybDlKWElLSkRxcEhXTFAxcGlBYjlTR2VxeDFDdk5rSTI3?=
 =?utf-8?B?WEhXM0tZMjUxOTFKazc4V0h5Rm90cnlCcW8rSDVkdG1uaGJBWG5yS3N5NG5P?=
 =?utf-8?B?dS9FZ09RcDU1Z0NISHg5WVVUNmhGT21WZEtqZ05WWUtURVI0NE83MkZvWFBU?=
 =?utf-8?B?MkZiTzRtVlJlQzF5UGROTnFJcHIrb1BveWZ1L0pYS1M5ckZYYzVLa3M3L0Jq?=
 =?utf-8?B?T0hvODl6NVRVZVZIK1N0ZEgzUS9MbjVNeGRPUGRWUmx3N1ppTnVueDRQZ1l1?=
 =?utf-8?B?K0hRZGhQVU9PSVo4TnRjZkdQMHlxa1NYVXY0RXRzciswTGxYdG5WRXhNUTFE?=
 =?utf-8?B?UjlQbjl3S2RXQnRHb2JmOFkwTC9Cd1FvUEJDRzlnQkNhRkgydUFvSG52aE5Q?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b72348f9-eea6-4cd1-6e0a-08dd7ed64b01
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 00:08:20.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKwEEYfFRYf9seGx/V3C4w35JJKBSaZWf9PsIO+q6OGRS9wBNA2Y8a9OuUpDvZO9B4qGX8AX7gZ8/vCgNdCW9gRT+hhMEPgw7eJ1X+r93Kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com

Hi Tony,

The following three patches progress as follows:
x86/resctrl: Add first part ...
x86/resctrl: Second stage ...
x86/resctrl: Third phase ...

Could you please make the language consistent?

On 4/7/25 4:40 PM, Tony Luck wrote:
> The OOBMSM driver provides an interface to discover any RMID
> based events for "energy" and "perf" classes.

Please add context about what an RMID based event is.

> 
> Hold onto references to any pmt_feature_groups that resctrl

Please add context about what a 
"pmt_feature_groups" (intended to be pmt_feature_group?) is.

> uses until resctrl exit.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++++
>  arch/x86/kernel/cpu/resctrl/core.c      |  5 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 62 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/Makefile    |  1 +
>  4 files changed, 76 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 45eabc7919c6..70b63bbc429d 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -172,4 +172,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +#ifdef CONFIG_INTEL_AET_RESCTRL
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void intel_aet_exit(void) { };
> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index a066a9c54a1f..f0f256a5ac66 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -718,6 +718,9 @@ void resctrl_arch_mount(void)
>  	if (only_once)
>  		return;
>  	only_once = true;
> +
> +	if (!intel_aet_get_events())

hmmm ... keep in mind that this is called without
any locking and thus there may be risk of parallel calls?

Please document how/if this is relying on some fs features to 
ensure there are not two instances running at same time.

> +		return;
>  }
>  
>  enum {
> @@ -1063,6 +1066,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..8e531ad279b5
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,62 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cpu.h>
> +#include <linux/cleanup.h>
> +#include "fake_intel_aet_features.h"
This include can be marked as "Temporary" to highlight that it
will not stay.

Please separate headers into blocks and sort alphabetically.

> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +#include <linux/slab.h>

Are all these headers used in code below?

> +
> +#include "internal.h"
> +
> +static struct pmt_feature_group *feat_energy;
> +static struct pmt_feature_group *feat_perf;
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> +	if (!IS_ERR_OR_NULL(_T))					\
> +		intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
> +	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
> +	bool use_p1, use_p2;
> +
> +	p1 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> +	p2 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
> +	use_p1 = !IS_ERR_OR_NULL(p1);
> +	use_p2 = !IS_ERR_OR_NULL(p2);
> +
> +	if (!use_p1 && !use_p2)
> +		return false;
> +
> +	if (use_p1)
> +		feat_energy = no_free_ptr(p1);
> +	if (use_p2)
> +		feat_perf = no_free_ptr(p2);

This reminds me of something I read recently .... "There's a rule in computer
programming that objects appear zero, once, or many times. So code accordingly."
Not expecting a change .... just finding it amusing.

> +
> +	return true;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	if (feat_energy)
> +		intel_pmt_put_feature_group(feat_energy);
> +	if (feat_perf)
> +		intel_pmt_put_feature_group(feat_perf);
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index c56d3acf8ac7..74c3b2333dde 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
>  obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  

Reinette

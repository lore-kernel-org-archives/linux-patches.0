Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334853043CF
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790037010; cv=fail; b=gy/KMTq+5uyZctFciMSHipiXeRKfc6SgQx/b522AKPQMjEyMmoKmaPbhJGDDVFYx0xD7ChPgS0icLeSZPMcQ46eQFJ7gZ2uaYjHx0Apqwgi+HDK8x+WPfuSUNvbKWqDwyp5m/jPXw5bqWxULRd9iHsgvpxqUcACr2126Ao3yh4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790037010; c=relaxed/simple;
	bh=w4RGA8E9yQQ5ymBfJoAziyflWGnvU4eBcIGQr2lFUcA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZOYw+hbBZhcz6GrAHVCGhPHu8O/nk6XqCpMmoP46DoLgR3n1PJ/oJNUmEuLR8fBoo9Btoc6d4CjnHS51iNLjV3q/2+cOrAKxfri1XEfoGc9AXBKVbFXsIYBB3C4P4D3Fv9JX2Q5BJCxWSpQjvwEUfKOPmn1kOHgaT2Uc1Mmpsos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1J8Snna; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1J8Snna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037008; x=1821573008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w4RGA8E9yQQ5ymBfJoAziyflWGnvU4eBcIGQr2lFUcA=;
  b=C1J8SnnatL1HMzb8imAAUE3jCq5x2p5xdQCbVOV6Bdz9OjArYwI6aVEy
   7yWj4ZBtrOfTRxkK2/FKZioPpwNj5STSztQr3vtsKFat8Fvbh/8MoNMFC
   wHsKeaVl87hztEwFqPCFQIl/umVXIe4l4QkhSfCAJ6kXyWg6w3d+8tX4H
   0WrEiszBcsB9XLuBlbVW5Mv/MNXoqhm7pBius3LURDaqdWMKPjNYtJyOI
   JuhrSkBDSy6HBa1oZXJKV3gNJe5+Fcxa64DqjKuFDIFLF5NwWfUXcPEsW
   oxPCaPw5M/JN5YWamXT9YVx82wub7R8KpSv+00JIpcPtOOfy1FKP2de6W
   A==;
X-CSE-ConnectionGUID: PJ4MXKzuRpmspipah+Hg5w==
X-CSE-MsgGUID: FfgWmAMWRxSN6LgkOqG0DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101259615"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="101259615"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:30:07 -0700
X-CSE-ConnectionGUID: 1hej6L2IQE2WN5MpbvaRLA==
X-CSE-MsgGUID: 1YVLAB+bTBWTupfIPc5Ing==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="271427122"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:30:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 21 Sep 2026 17:30:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 21 Sep 2026 17:30:06 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 21 Sep 2026 17:30:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l7BvPq+zhOMGUBqqELXn7pW5DwAvXCdxULqED6LjgPmG90B+BdYXrp5LiyS/qfz4ihDPhh5cEjTb67lEY5sihbrIORRuwA6RXcUoGF1repjOLrMWQ0aXZeL8OCKp6mTaQ2FtihVZHf4PyHn4OWneTzCLLSNfDMSj+qy1C2biLLuKgR6SxfxXunguho8wm3w4cCOngRxSxItLKsqHFccNktnE/MYZH9oYLwAkHfjP2dMEmzUN8m3AEEe75sYw0wm8xJg1FjKxhMcpnxuccvgVEVD/JFDQXzGnWusuANorfgFxUSksvvpJIxPWDy2oVmnBSveeA8WPx5t+LLWWccsz7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mN6ABDNkU5UgDmOfC38rUaoKs/3Z29Kw1YIIcuPf/i8=;
 b=jjnhfvhD5ot+yN7SzMdbw2hgO5YKKNEXKDfVOEkKl3IqxtAhk/WdFv8ZTGbBImDYN/pIGD4x/EPYjDhaOL/K1EapfG4whVYS7oHAkgNSDNCDtceFY+w3kBpmmJ+6G7r78O5WmcQwaPqI4TSE17cbMD6mpSlRzQQWe54jq/pmaIi0NJPByCOa6xThfiT4D+lS+ww8xGIrxJTL+VI1yn+RLOaJD4Lm4HCGO/tTuDwkTtlndzZuTw6hkZREdnuabqmJzVrtBfwgbDsUXUTmTr9fUXqgVi/HCiusJ8Fscl4n681UwyHl39uP9JEAqbaVDIAY/55fZo95QwZsUczAUTaDoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA0PR11MB4767.namprd11.prod.outlook.com (2603:10b6:806:97::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Tue, 22 Sep
 2026 00:30:04 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 00:30:04 +0000
Message-ID: <d5f9dfff-abe9-4622-a0fd-09a2bb6b389d@intel.com>
Date: Mon, 21 Sep 2026 17:30:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 12/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: Babu Moger <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, "Fenghua
 Yu" <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-13-tony.luck@intel.com>
 <87ec019b-762b-4ef3-b2bb-6322efb6a7de@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <87ec019b-762b-4ef3-b2bb-6322efb6a7de@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA0PR11MB4767:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f51fcb-786e-4c24-0430-08df1840a535
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|3023799007|10067099003|4143699003|921020|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: GszMVF0frB94S831P+y5zzxGGN79XGmRG2m8okQUb0ojlT5JvyEHPMItuPXXDbz/wFNF4WWoj472Ea6rN01VJWmhFyJWLz9Ajx79iOtCzRfhQ9cNKF0/Wo9i1JKcajjJDKkb4KPT3mhd22syEpySchAahVyy4UUu0lrvSJRIubd+zMt7ho8wFto3EIlL575ZNf5FPP2pLE2wUVfj6VmXNiQoWMR/+p1aHyfWmCkGZ/x7xnDNciV4wwmvd92p8uIGgR0NVyYoSGpPbjluiatyEsr5xSA3kZUk52/tTw1UI5jJWdqOAWQb4i57LEz+r3ErmgHa4REYdCth9MG5/9U0DbwbxgFf7jk2cVZCv5ASF16aKDWGMPFfNyVg5Co3v6vEVzzihXrnG2tGDX8BfXdXJDBQTINFMpfBnjjkbFF1zAjdwX3FDN7zHgeA654mYddnG5IoKR7k3ngTu7wsHzEyUNbeX6NFLuALzoAiQ/xr12/FhNmL6xTGK3vIOXnN3Wol8qMqdAgFqRzsWUx+Vw6p9q8dBeDYzKiLyoBSiPifpm+YF8Q69MD6wHNFNDn4dtiUWj2eP9E6lslCjSRad1NRrZhgARGbA2c5q51+2LXasmYt7JFnBfVrBpUQiDMrBr8PAe1J/El41GtoiIzvxh0zEB8VXIH4WU2Y7xSwyMYlwyc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(3023799007)(10067099003)(4143699003)(921020)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWZjSzA1UzFMQXVNazBzUHVFeTBLZVc3ZFdVLzFhVDdISnVjNjhQWjRZWTI0?=
 =?utf-8?B?NzNpbGZZMisyZFRBN2djSDZuREx1UmJja0RPYzZIRXdOWFNOcHFFc0t0TldC?=
 =?utf-8?B?K3hkL29idWFQbERkQUNXVzVWMXk5R2R2Y1llUlUrQXBmQ2IzM3lUSDM5c1Jw?=
 =?utf-8?B?WFo1dERXbStpWXM1MUhiME1Hc2M4VTJCRzJyTXRTVHZHWWhKTDBNR3p3QThy?=
 =?utf-8?B?NVBISkp4TldxSHQ4NDZoY0h2K29tSDR6ZXZoQWxJZmRVWDFPcjZxL2p2cmJF?=
 =?utf-8?B?UHFSTWF5Z3VsRU83eENmUEVjTUtXR2kwRUFTRWFUZ0FubXBQQXdGajFqeUph?=
 =?utf-8?B?d3RxNlcrWDZkVi9sRFZ3ekY0UVNYakpudEd4MFdjWHlqNGQvSDI0SE85R2k3?=
 =?utf-8?B?WTNrTkVBMTVqZHFwUFZCcG4vV0tyK09tTE5XOEsxSzk4RUJDWlFPdGpWdnNO?=
 =?utf-8?B?dUEvQ0FQVEMzdnJIVWt2NE1QSFNXV0dBaUNBb1ZlaC9Ubi9zajJ1WnNxSlhE?=
 =?utf-8?B?ckhnNUNkTXJhNE1yRlNnczEremZBWUxHck1mYnphSzFwbjIrV0VQd1pLaUt5?=
 =?utf-8?B?MWlycEhoVTIzcVkrd0JSQlk3NDZFN2J6cDNnUzNwanRnUzFPdFU4QjV5K1pY?=
 =?utf-8?B?Nm45WVBQWHVFR0dsWkJ6emhadTh4KzBJcS9RNEdVck92ZmVjcjRFUnZZOFhN?=
 =?utf-8?B?S2F0YmpTQ3hMQW5oODMvZC84TW5kaThsTTN4V2Z3VEM5UC91Z0xmQzExQkdT?=
 =?utf-8?B?dDl6STNkY2NKY0ZnOFA3UVdQTTRJTk8zSzFYRDNvYmVhZmlvMTVWWm8zVDdr?=
 =?utf-8?B?OTJKbkZuUm12WFFhM3BNWGZIOTdEZmhWR213aGEyOE5uZ2FZVlFRQVc4RCt2?=
 =?utf-8?B?bndLdUViejFuZUllYTJURUpRakIyOXJ6S3FIaW9yK2pHYzBrNzRkemZRRWtx?=
 =?utf-8?B?RHgwVlVNMkhQTnRKMXV3WWdnaHVuTUtJQ2tPTGN4U2VEOE9HYUlvZHNQeVd4?=
 =?utf-8?B?TmZYcWFZb1lIVzZNeDZMaFJ0ZUtiS2l0R0Q3TGhFblpBNXhXcVJDMUpTcVl1?=
 =?utf-8?B?UzkwN0Nzb29kNGFxM0pYRTFnbTNOTzJ0TnJCMVU0Mzhad0tObk5adXVDU0Jy?=
 =?utf-8?B?UWxrcHY1Tk1JaDhRQUQvYk1FV3hjLzE1QUdvZ0NHeUZ0K1o3dUllZVNUek5P?=
 =?utf-8?B?emM5b0EyMUg4K2Y0Ny8xRkJINnlabm1lZ3BWZHFjUWJMOGF3RlVtZ0Y0QzZN?=
 =?utf-8?B?WUhUb2hnbnlvUm1uWS9oek1LcWZ5YzFQaHlNbXp0c24zTzhJUDArWDhHcWk0?=
 =?utf-8?B?RXQ3Y1MyL2hJWTN4NmdsZDFkYkVUWDc2WlJrT3g5L1M2cnZxamNYYjBGdlZ4?=
 =?utf-8?B?cXFlRy9lMy9sTEJXbmhQdUptaGdUcjN3ZDlxdFd6RWlFVk5MV2lLWlpRWTdS?=
 =?utf-8?B?ZDE1eEFVT3o2U0M0dTFIT3N2T0F1M2dhRFM0STBpZ1ozRzhWMGtpZGZhb1pO?=
 =?utf-8?B?Q1V6Z0cyUDVpaDgrRWRwSzhLdkJPTXZ6SGVnWDRvZEVTZjFCZXpBTlY4TGtC?=
 =?utf-8?B?K09Ncm9mNStmZit0TG5INVpzT29OMHdORDhVNFdBZnFiOFdYdndYNS9kMm83?=
 =?utf-8?B?WG1WM0lsTVR5ZmZ3QS9rYXNTQ0t3ZjdqQmtFVUh6bTF0TWVuRjVlWXJsb1Ju?=
 =?utf-8?B?MkxuT1B3b25adHdJMmtNOFdJUThRbkxNYkpvbE9IdTgwemJkMHlBamc3L1J4?=
 =?utf-8?B?b2RmVTMwbVluRGliWlpGM0Vyai9WUlpmOVVITi9ROTVkV2l5S2NISmFkVDBk?=
 =?utf-8?B?c1NwUkt3cGpNVEhRNmdzdTVuNUVtemdKaWZoRjM1clduK2t0K01kRGZydDFt?=
 =?utf-8?B?ekFJQjJiM1VsQmUyVjFuS1lVangvTEtoWGJTVzZlMTg3UjNLL3dUQTJsYkxT?=
 =?utf-8?B?L0RvVHRDUWp5V3RuM1Q0aGpvRTNJczQzQU05NVlRYzR1c0o0eTFPdXRUSTF5?=
 =?utf-8?B?UytERGZaMHJDVWNzSkZQRjJxMkp4Nmt5dkZmYXIraTJNYndaNUJvcjREeVlI?=
 =?utf-8?B?akdQdmVJdmpMSFkwVGJ1N2owWnEwRFB6T1dSeW1oaHNnUmxodlJvRVpmSHNY?=
 =?utf-8?B?YTh0a2N2LzdWNW1uaFJQaStLTmFrMCtKbHhWbjZvM00raEtNZG94bXlpVHZN?=
 =?utf-8?B?T1BTRHp1aWZua00wRGM3SDk3ZUcvU01CRXlmMmdiRTg3RkUxME90aEgxSWwz?=
 =?utf-8?B?MStVeHVoMk0yZnBERDJRZ1hvYVIxcHdhTWxJcmxLV3Z1OGFodHkyQWRVdHNz?=
 =?utf-8?B?cWVGalFvbWxSbEZsZWVNaS94bVM0T1hWVXpSc3RnV2hXanpYQ3h6Mkt3UXEw?=
 =?utf-8?Q?/nBmARXgs97AS6RA=3D?=
X-Exchange-RoutingPolicyChecked: Q5HSWuaaEXpfNBHk3K6NTHPnC7wIaSBcgwkK4/wExz2CMafjTENVfqoEx+V9LP/QygZ4wy5U2ZALxYXWKRIjka+B46+EStIfeaN0PQVVhdEhR9VSmfWlzAq6VaPyd3V9PM4d/5p1o3lDT0jsC0uKNfCWGV3R9f2mIGbRIoxAlOz+r9KN6HTZfUYqedbSQaX/QyqGYcF/pDW5A+9/WNqBd4QRE8DgFJsCHGFJRKDBKAM9CVisHJ2VruTtTAE2cS1MCiJUwpU7xUi3qVraz7rAx3qdhevJZ//YxGR5a8HGaTiv1H4mGMjSByPRX+fIqVrSL4ue0kM6HIo9snt1H/8SRw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f51fcb-786e-4c24-0430-08df1840a535
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 00:30:04.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amPSy8hp8+euSbUYfvXe7mTsKAenEl+ef1Ug57kBnevz8KU7vg2b/oZbozR7BD4BF1aVDhLHqFvByiGD28OztU4pEEO77qaVuFFvjuf6/qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4767
X-OriginatorOrg: intel.com

Hi Babu,

Thank you for taking a look.

On 9/21/26 10:45 AM, Babu Moger wrote:
> On 9/16/26 18:13, Tony Luck wrote:

...

>> @@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
>>    */
>>   DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>>   +/* Number of RMIDS values that can be written to IA32_PQR_ASSOC.RMID */
>> +static u32 pqr_assoc_num_rmid;
>> +
>>   static void mba_wrmsr_intel(struct msr_param *m);
>>   static void cat_wrmsr(struct msr_param *m);
>>   static void mba_wrmsr_amd(struct msr_param *m);
>> @@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>>       return num_rmids == U32_MAX ? 0 : num_rmids;
>>   }
>>   +/**
>> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
>> + *
>> + * Return: Maximum possible number of RMIDs used for boot time allocations.
>> + */
>> +u32 resctrl_arch_system_max_rmid_idx(void)
>> +{
>> +    struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>> +    u32 num_rmid = pqr_assoc_num_rmid;
> 
> Why not  use "cpuid_ebx(0xf) + 1" instead of global variable?
> 
Tony did so in v11 but I proposed it to be changed [1]. This series adds
multiple consumers of this value so it seems more efficient to enumerate
it once and re-use that value when needed. Locating this one-time enumeration
with all the other monitoring information enumerated from hardware in
get_rdt_mon_resources() also has the benefit of keeping all monitoring data
enumeration together.

Reinette

[1] https://lore.kernel.org/lkml/0ef770ec-ac65-4a80-b676-a8bd92caea88@intel.com/


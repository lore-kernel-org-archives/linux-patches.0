Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA9032ED57
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765315878; cv=fail; b=T+YumRidwvFygqnJtcaNPquVYWbeMra6F9r924OXqftUOsc4Y4BEbWlhSAWO8QT8z1jnKJy8SKVEFM7ju34TPMzj1Dm0+2KMzI45H4xvLKVJmAJkNiUQdFRO0sSk5jBtbkeugWviXTrAskWTtvlpJQaLAxv1hu7ucUpSLpmNzbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765315878; c=relaxed/simple;
	bh=W+eexPh451S82tvonKUVR0eO7A2IDuk8NoXwNXKr8eQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DOYXjDCypk7i4UmmtGFdmY2aFqJNSq8xT6Pt8cRhPQheaIN/FJryetu8jPgWGz/aHRS98EyiuSE3u/Qxkih9BqpCKDV8ZSDLI2H1C6N88XpHj5FzoAs247k0xi7jKJEM2wU5/PamesME0gyEIehWlGExQAJMzI3RrfbjtOvWx+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlQ/e7NI; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlQ/e7NI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765315877; x=1796851877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W+eexPh451S82tvonKUVR0eO7A2IDuk8NoXwNXKr8eQ=;
  b=QlQ/e7NIUslxNJNaoma4fd6LdFcryYJ1K0oPkWaW1DU5XuF1d2sw3Qet
   KKFHu9tO0Cc7FqUNuTE9kXrxGF9tsMauGSOLvbdTsdD7BaN6mRqzIjHKn
   uOynYyVLgZJ97xqb/F+hmsjnNRRiSIiQ17MKm6w4eYzpuINl5VirGpI4J
   ZkeGJ7r2oM3F6MhXIekGGoIYTxY3P7yXB5Z1s6/uirFuEz5gSpgokV7uE
   g8cthSFDi15PGk4W1/E5zCk0yiZGC9Z2QkU8L1VAQ99A7WIb/B3UtrRah
   95+5YtK1W7RCFpWbOAV9ibXvQsHGKf9Hx8q89MBmphi4E1GGVaHIUKhqz
   g==;
X-CSE-ConnectionGUID: L1KQSNenSUabnLE9f4LB6g==
X-CSE-MsgGUID: UZOk0WFwTqyYKcyQTfmShw==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67177779"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67177779"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 13:31:16 -0800
X-CSE-ConnectionGUID: x/+TZFrLTbmOqbXrEnS3jA==
X-CSE-MsgGUID: 7A+QIFXBTyG+41muJPpCEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196628516"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 13:31:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 13:31:15 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 13:31:15 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 13:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tEkw8As6aG7NHuBY3kRzTz0JPIDJfgpI0AKJzxjDSijIPA/TsM1+n7lzV2qRoLQ92m7nVWizuLasUdAt0G/vS81svx5lD3N2LXuIoKYrVRElh+hlhU1QyRCxWZ9hNfGiKehiZxBfcfdC783d0kM/qPrauA1GobLsWBdpPUecmM6NSpKZ0I5CzS+YpniRea2ocsfl9ND8bviZPUmdzF5H0+yODLBgfBqnJ37aiG4uo2FpA7dmDKUEwvxyS5UdnJ+UE1qpgaHM7I8RXnA1punm5Plow0QGYrqIIw+WdRhuJydPcXEw8X8K6bxwtDn98XDTGpEO1nkVcA/19oHR3NaNDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrPKFF1i4xWBAT9+U4912pCaGFPdRpJC2Muc//9vmpk=;
 b=rzP+GpnCbpCeLYKMKKeWdsu9D33ZdRGw3tEUp740keCEiUGTE9K4J0P6bQtrMDSu7Ty6yWwz0An/ZTAiXqqxV2Xlg8rngg1+XKspHkirZnKMD0d7f4z0xGweyz7G4w9pi8zEOES50NrWYju1wgoPr+veAtKnm1ORr2f0Y44Q/k/EA8UCyAR3drmJqQ5R5fhXuWvqQ9YbD5Z4CtWvUM/OKjxaSScFR0psAOe50CLktcsfydLpHH6xfTc5rSqWjPeTskbqF21Y2IkJ3iSAg/iLUpP704GDpPBYvUe3XzPcpfj5rq/CeZh7EXCl4Gw0A3TfrpwGlNUQGOxjWwI6pQPhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6617.namprd11.prod.outlook.com (2603:10b6:303:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 21:31:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 21:31:11 +0000
Message-ID: <33a2ada3-d523-4ed8-9313-74814daded0b@intel.com>
Date: Tue, 9 Dec 2025 13:31:09 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-12-tony.luck@intel.com>
 <34dfe97d-3aa0-4fc5-8f1d-3da5066a0b6c@intel.com>
 <aTiIe6U6e5PlEyj5@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aTiIe6U6e5PlEyj5@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:303:86::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e1e0f3e-f125-4322-a770-08de376a460c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SXdSZmptaitiYjY4U3JiRGxhL0cydkRVNEYxa2EreTZKNElBZllvNk02UVdn?=
 =?utf-8?B?Q083TFg2blJZbVg4UVg4MFEwcm1aMk9kci9RVEZuaFRPY0RHQ1Z5dG5kRmE4?=
 =?utf-8?B?T085TWVXa3c1WHVESFo2M1NxOVlBbUJyVTZYNjB2VDhEd1FiaHBPdkFnODNJ?=
 =?utf-8?B?aHFSZEkwMHZqc3dmRUd1N01ZNlRzNVZqV2orcmFTa2NQeUpoZWYrYVE2VXZq?=
 =?utf-8?B?TmVaOGMvdjNFaFBFYXdjbExIOTdIa3dKVEtOckZGcFpOWXFVLzg3UWNVem9s?=
 =?utf-8?B?VTk4YlFpT2N6T3UyS2xCZUYwanNEdzJBSUxyN1NJek1JTTZYczA5ZUVkUU82?=
 =?utf-8?B?NVVJcHRLcHZaYjhja2RrM3V3RjdMaE91UXJJcGRPOGdoT1BMdzd1MDB0MnRa?=
 =?utf-8?B?Vm5wRnhPV2tidXVpeWhOc1F0cElwblQ0NjlnUlpQaFJKdTA1ODYydVFVQ0l3?=
 =?utf-8?B?dXJ4aFRmVWVmSXJYRVBmaVkrUnE4d05FbGdTd3FEazZObzhyZlZnREFWN2RL?=
 =?utf-8?B?U251VG1iVkFYaHk3Si96dzVvWGtIVkJuQ3JJczluTmYzSUk0R3hBZU5ZU1RH?=
 =?utf-8?B?emtPb0diZHkvUVdhOFFOai9DT1MvU3NKSEZJWUxYYnBFeWk4cmp5MjdOVHpM?=
 =?utf-8?B?YUZEV2xvcWU3L3lEZFJ1eVJxTm1JeFFDTlJ5dXhDeVMyNmRaUjVHU3cvQnFE?=
 =?utf-8?B?YWtkcVl4T25uOWZMS2c3OXhhQjlXMk1QU3B4L0lXajdLL2hnbHRWL0NFcWZF?=
 =?utf-8?B?YWI2TXQwY3EreHpzc0VjZmlERjFiVCt5M2g3TFdlNVR6V1RyV0wvaEozeG82?=
 =?utf-8?B?MkhQOWxkM24yNzA5N1BBQ0ZhYWpYcG9Cd25FU3dZeHQ1djh4TGtmRjZybjY4?=
 =?utf-8?B?YjUvR1RUemlYTEs2VDY4aDdZY3JSUGVzREdjdTlpWVR3L2d4clhKUytnTFhG?=
 =?utf-8?B?OW5oMmlZOC9OTFNOaU9zUSsyTG0xRlBheUdvZ2lDTURCUFNpcFF5RXhuRkEz?=
 =?utf-8?B?eU1jQmF6TzFDM0QwcmlmM1hnUmcvNWdBMzF0dWxUOGNFclRId2l6S0VVT29j?=
 =?utf-8?B?bHdSQmZZY0FmSGpHdkxOVnR0UWkwMFFpUmRVQTlITmJZODVWV2hVNnY4dEZC?=
 =?utf-8?B?VGp5WFErNzBUN2tXdHdBVzd5TU5OeU5yOHBYbUhRZDJTci9tWWFKZi9MNG4z?=
 =?utf-8?B?N1dHeDh2ZlJxL2RnTHFpNC9xd2JoNll5UGNVMGJsNk9oQ0ZtUzRZZVVLWmtu?=
 =?utf-8?B?SndYdzBEcTZaZW1rT1YzblZPMHA5M0w0bzhnYThhQlNOcEsrUHBXTjJwVEV6?=
 =?utf-8?B?UE9ZNHMzaHFIb1U1SlRvdGNSU3QxZHhNZ2x2Y2JjYzVNUjVNMlo1RFdmOE8y?=
 =?utf-8?B?eXpRcy9SRksrVEs2UVl3RlluRVVCQUpsZDVjVGRHcHhhRUpqVkN3R2MzUUFI?=
 =?utf-8?B?ajJvK1h1c3pRN3FiSWJ5bVNVdUFmV01IRkEwbjlLd0VvdHFSekxhRG5JYkVk?=
 =?utf-8?B?QkV3bEtLQVZwMm1ncXZyalpkb2JXTnEwTXJUYy9tOUFqQStUeWUrd0RtVUk0?=
 =?utf-8?B?WStNbzF0TWpwWXVvYjd4ZEFxcFRLT09lOE52NmFjODlpdFpzem81SDlvZCt5?=
 =?utf-8?B?dlQzMWdmb3V4SXZPeEdFVk14M3VWbytueHZERTU3bEIxMW1DcWM4TVBxQW1I?=
 =?utf-8?B?KzNidFBVdjdSbEZEZEZvWU40WnJaY3NkMERiODBaMVduaUxBQXF4ZkdZOVpv?=
 =?utf-8?B?S0x1eUxlQnFVLzdlbGtWYmNXNGswVkpUKzFPN0tYaURDVzk1YUNkTDlpajNM?=
 =?utf-8?B?MUxCYWFtOWRwWGhMTGY4UmZ0LzN0T1lTcHF0Q3E4dEJKZmwweEw2eXJiNk9H?=
 =?utf-8?B?aFZ4elM2ak9WVXdOR3c4eC9yc3lXN2JnOHR0cm9YVGlxVFptdFJaNXB1RDVJ?=
 =?utf-8?Q?x9HwhqRhbWFQreVVV1JQDl4O1mCw/04k?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NZQ1k2VjRxcE1INlpOTm4zNnlNVVJheU9aSUZibTlsZUdhbkZ1UGNpRTY0?=
 =?utf-8?B?bGNFMjh0K1EyeWZ0Q3pKUkFYK3pEOVFRMUtzb3paaHpodTY3b3hQZkd1YlI0?=
 =?utf-8?B?RWVuVkUyRHZFdmoyWlVOK0xwWXkxZlUyM2lLKzZ4eWt2dDBFWjNDWUdnekpv?=
 =?utf-8?B?SHU3MmQzWUIvMU5KRWpJZ245ajdIUlpyZHRsdU5WMEVPOGZNUW0zK0NaSlRE?=
 =?utf-8?B?N1RrMkVRTkNHK2tXUWsyWkhmSmwwandEcERKeDUvL0N6WmhySGNzY0ZMYnFY?=
 =?utf-8?B?VllNaTQwT0d6SzROMGtvZVdnRFU4Yk9SNk9SbmRLWHIzRnVtcmhtVWg2eEFr?=
 =?utf-8?B?RjRsWkUyaExEd1dIMklVRzJsV1lQd0JEZDBKY3YrZVdyYVJXYVY1KzFyZVBE?=
 =?utf-8?B?OE1VODF2bUZMZzk1VnlyTGxnL1ZFemxSSzBlZDZEK0xXVmtFdGJHcGpQU3R2?=
 =?utf-8?B?eklyVU1zZWc4SzV4OGpKRHVuRVNubWFXTHJsNlpxQUFSTk1xQVh5clkxUXE3?=
 =?utf-8?B?RGFRRHRLM1NMdDEvd2w2aFpuRlNXeDFIT0kraFYvem9iWnRNcXdobTRMUG9q?=
 =?utf-8?B?OHVGVzQ0UFFubFFlbUJuMlhQV0k0bGhOUWtwREJxdHp2SVhCQytZdVhWemRh?=
 =?utf-8?B?bDhmS096eEszaERvYXdKaHRFeXBiN2lieUZ5TzlDOHgrMnprOTBUN0p2WUhW?=
 =?utf-8?B?dXlxUCsyT1UzWjNzK3VMeEptNThack1id1ZKQ2dIS04vZENPQmZsS09mMy9Q?=
 =?utf-8?B?ZmhXK1RVaTJsRHFIN3FmV3BnS1JaU2o1OVJraTlaSi84c3dIV0VnNzBRRkVq?=
 =?utf-8?B?Qkl1UFVsdlFOR0tMY29uT1lQVGc3WngvVnBLVG1lSVY1RmZSU3dkY09helVk?=
 =?utf-8?B?VmlERlFEYjZYSThEcVkveWxYbHRNVDhuVm13SUdxMUtIc1NvTlZoZmo5UUNu?=
 =?utf-8?B?VHcra3p6ODFkUU1CcG00VlVzUGtEM1VVVXNzdWRnRUplZlBqeWNDZ2xBZ0d2?=
 =?utf-8?B?Z1puNUZNTWNySDU3S2dNUGpOTFkyWFJhcGRWTFczNHpDNjNVNEtPMVRMZ01B?=
 =?utf-8?B?KzExbDhtaUVJQzFqVnArMDRmYWdHRUNUdXFzZkY0YkRPcHFmZ0JvZ1EzL3BX?=
 =?utf-8?B?V2V5b1piS2R6bXJwYWE0Wmtjbm5jS3MwTGs5ek9DRFAwVDF6L2RzTStYb2FF?=
 =?utf-8?B?eDhXbVJNSEZoSm1HOTVsckl3MXFXWkMzTzRXdCtURHJRd0pxM0ZUaHlqb0Jr?=
 =?utf-8?B?cjR1dkVZeTJqWTZ1SXJVQ0ZZTTRzQWNudUxoVjNVUGJPTTJKOFFCL0FMSjFR?=
 =?utf-8?B?ZzJKdFoxV3RxK0tjaDJOVndEek5hWW52akR6WTZnZklyc21CZS9wNERKNDlx?=
 =?utf-8?B?SmgzeHNhd0JZNityTnVmZE1yREptdExDRlRKdVBKUHJlRHA3VzhwbGM3WUNo?=
 =?utf-8?B?dk9QS2R5RFJZRVVIVW8rdE1udURLaGZ1eWR1bzAwQ1hjWXB2VkhOM25jaG1x?=
 =?utf-8?B?dUxsK2hVdHgxSlZLRzdYQnhqMFlXTmx4Tk5MbklhbEtCUFlEb2t4VGZranNh?=
 =?utf-8?B?cjB4OG9RemFwN3E5aDhCazNQUWNVOWZuSE5kWGhMWXMvM3JhREZNQ0JQQ0F0?=
 =?utf-8?B?aGMzMDRPdjFETlVTZnBhcjdHZHpvS3JSRERodVRrT0lua0pEZ2hBOExyUzNq?=
 =?utf-8?B?ZVZZRjMxZXZ1eXE3Y1ZVNGxjUk1WZmZKV0J6YmJTUGZQdmZFaThPZnZrc09H?=
 =?utf-8?B?NVRaRjdwUFFHUU1jM1M0Z1h4VXZGSVZ0VEpWNGRPSnNFK2JySkpoVjVNNG9T?=
 =?utf-8?B?REc0ejZCdlBmMmFhOElCeUhWV2F0OE9kRS8yMldtUit1cWY2OWJDNHZLcEtu?=
 =?utf-8?B?bVgxaFdKWHAyUHEzL0RnOENJbzBPcnJPUmdkUWtpN0pudzhtTkZDNENrSks2?=
 =?utf-8?B?aHRWbnJqZ25Ca3BHYUtxelBHWDVVZUJVK3pTbUtJbUU5ZVpNK2xrVnFGaTRp?=
 =?utf-8?B?bHBWd0JITDROeDBJQWYxalduRHJaTG85cUM2aUlVZjBqYS9iN21PNXZQTEJ4?=
 =?utf-8?B?d0hrOTNaTmxBQmpqeUNaalJHZWRnV0FLS2FVVjdkRktXdGUzTE4zN2FiUmdp?=
 =?utf-8?B?anlmbjlMcHJ3cGt2bjEyWGZHZWJpbEZRMXdUUEFSOVI3QmMzWng0ZGc0cEd0?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1e0f3e-f125-4322-a770-08de376a460c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 21:31:11.6126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRuDc4eHreGpFQ1hVVau09i4HHGcxgjCuHTYIJw/XrK/Mh8y6nCcBE53xf4bBwvsTRJx+iIe/pQQm+ocgR97DSgcfr0p8As3WM2lOjIbMBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6617
X-OriginatorOrg: intel.com

Hi Tony,

On 12/9/25 12:37 PM, Luck, Tony wrote:
> On Tue, Dec 09, 2025 at 11:39:56AM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 12/4/25 12:53 PM, Tony Luck wrote:
>>> resctrl assumes that monitor events can only be read from a CPU in the
>>> cpumask_t set of each domain.  This is true for x86 events accessed with an
>>> MSR interface, but may not be true for other access methods such as MMIO.
>>>
>>> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
>>> indicates there are no restrictions on which CPU can read that event.
>>
>> I propose to append (something like): "This flag is not supported by the L3
>> event reading that requires to be run on a CPU that belongs to the L3
>> domain of the event being read."
> 
> Perahps simpler?
> 
> This flag is not supported for RDT_RESOURCE_L3 monitoring events.

Simpler, but missing "why". The changelog starts by highlighting that it is x86 events
accessed with an MSR interface that can "only be read from a CPU in the cpumask_t set
of each domain" but worth highlighting is that __l3_mon_event_count()/__l3_mon_event_count_sum()
is resctrl fs code that, independent from x86, requires to be run on a CPU that belongs to
the L3 domain.

> 
>>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 340b847ab397..081ff659b52c 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -518,10 +518,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>>>  {
>>>  	switch (rr->r->rid) {
>>>  	case RDT_RESOURCE_L3:
>>> -		if (rr->hdr)
>>> +		if (rr->hdr) {
>>> +			WARN_ON_ONCE(rr->evt->any_cpu);
>>
>> I appreciate that this addresses the feedback from v13 but it needs to be adjusted for the
>> code changes made since then. This means that this warning applies to both
>> __l3_mon_event_count() and __l3_mon_event_count_sum() , no?
> 
> I'l move the WARN_ON_ONCE() before the "if"

Thank you.

Reinette

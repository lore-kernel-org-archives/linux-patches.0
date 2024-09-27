Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2E8187844
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 22:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727477228; cv=fail; b=N257vAhQvFfgHjPyV4cFpTUrrs1ELCZrvzUWdnvE4yOWioEZCwCHHfqXcq+vl9SkMhlbYtFH2ZttHlHbuCQbt+pWkcVUviPr15Po+/FVzcYX7msG3yiGR7FlLhU07taBzjBry0ODC3WitbSN/JQ6xkDlpeH9bIHMcOarw8TJCsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727477228; c=relaxed/simple;
	bh=ATnLaRSiApQVUuGq+X7V9s08bcKLC2+06pAq82S90J4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rIJxZ/N2+rG4KaIaqnc+ZD+KB4NY/V7M3F4vIa65wdM5Xj6ajcWUARriApFctJMgMsHLAsrTCVOADBeEuqtG5AyCZYAqBrbNCfTjDFQewwN2zA42QZl0Emg9aCR0k3YSETt7Uc9UZLXr7B+khkQpGXpvpbbBLSdX0O7/jUkskN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VUkxWS0L; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VUkxWS0L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727477227; x=1759013227;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ATnLaRSiApQVUuGq+X7V9s08bcKLC2+06pAq82S90J4=;
  b=VUkxWS0LeAjmGyhxR4n3/73QxDuNF0IHSLckvvdJ2Gz4hQF3nOXYJ/+P
   FkJhq+AUP/v9pr7eePnpM/QSdfXF+GOYXgjymVgW+wS1EcLjeSJs5fhl2
   qSoj/NvDSo1AAnfeeLVWeMVdkRfOX2RKK6iN/yvW3Ql8a5tL7mGPe12PX
   f1E4tazGE1JK23sKeyuzH/6GQurSAFIEbhxbMYcPeY6YCwXYyVSR9fDZO
   TZh3zTzJ2uoYVqKtL9nEWKMJzQ4YQfa2SoGgEkqnVuGigoEKeD5harkje
   DPq654R5SQ/FCuwrurdb+69tN3+Dr01WL7jJk5ZHiOpCTr17fZ2N5xOYB
   Q==;
X-CSE-ConnectionGUID: hlMcasWrRnSnifLlT0UoVw==
X-CSE-MsgGUID: ckxy3qgMR3Wz6gBtcn8J3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11208"; a="30341546"
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="30341546"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 15:47:03 -0700
X-CSE-ConnectionGUID: 4Sx32tiWToO3kBfbgmgToQ==
X-CSE-MsgGUID: m3Bt6P/PRG+6CdnZK0tYMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="77050974"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2024 15:46:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 27 Sep 2024 15:46:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 27 Sep 2024 15:46:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 27 Sep 2024 15:46:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iiE5L8WViRV4tQQrwcKaELUJtxBWg/hl6hJz8yr1K2BHaHdMfmYRtNEZB3/TUFkGuGjtkJaMDLLlqStoI03/SrtliWNqyaqFuuz3g56A1al6WyF8cpOwFblgNEMehstjDj5M8Ky0KgyrsWi7xqr7tFWQKx6wxgdgJ8t14jsgao9+vUxbEvkkkvFacO9bVX+qvYoh7yOdI2SPbBaBi7M0xUPvglA0oNopUtVy2jwDfZyOegrMo7A+8cxi+2pp0p0eIwEE5nUQVChVMSmmXUcI0BG2VHEAaHAGhuZw1LWAWHksQ1/j6Fonr4at3YAWJkwazS5gn4bsavSSBtYG8hu/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sli39uHtWhg5jCfc/FK6smkl6Uws0q0IULHX2SLYDGs=;
 b=tocFdAaofSw8R/v8V2XXudD3NF+Dp3nTd+4/6c8a5oihb4hMJMIYuvYSdSiOaJF66eJjOsoZwO6DFYCVvfOFNyzjRzyNVn+f0jucvi58HOYUlfRFqc4KQVtPpdcW/CrD6isXmKXcQBD2o9TaoDJ2O4UW1PvRFL8VUwSAEaRCvTByq4pCrMkNZZg7tePH50RVoqdZ/hZsiCzppBTe7v1qDeXmz41m61itlXtZ8gcJgrSLeKaqLcp53RpCWCmchfMpRhfNeqWP06A24Bo1aW4FYiTIHY4dcrlEuu9x0D3U+60ETzR7XY1+rqBuRyGySPSPCDp1Cyc4qInsMk1K+0nH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6894.namprd11.prod.outlook.com (2603:10b6:806:2b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Fri, 27 Sep
 2024 22:46:48 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8005.020; Fri, 27 Sep 2024
 22:46:48 +0000
Message-ID: <623a4a0d-b479-4bfe-9c2b-b62584a19738@intel.com>
Date: Fri, 27 Sep 2024 15:46:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Do not round up mba_MBps values in schemata
 file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Borislav Petkov <bp@alien8.de>, Martin Kletzander
	<nert.pinx@gmail.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240927223038.41198-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240927223038.41198-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: cd620c32-5888-4c8a-0fa6-08dcdf46457d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cjVJQ0J6bkljWDgxQ1IwalNuZkN0VkM0NkdUTnpINUxzbjNMVzFUTEpER1kx?=
 =?utf-8?B?OWZReXpjeHZnSTdmRU04amRsZytJSGFEaUNVWXJjOWM3OUNUNWJvU0I1TEpB?=
 =?utf-8?B?SW9hWlZxUnRUVFpPcUNUWWpoU1pZUG5ISjJsaWJ3cy90K2FiL3dVWjFiTTc4?=
 =?utf-8?B?R0VDT1UvdXd3ZXZtcDAvdDVrZERlemdoMDQyUnhwWlJpRy9hWmxMRjdPTndY?=
 =?utf-8?B?Y2Y5TGFrK05jbEkwNnErT3d2d09HaDVRZStKTktQQ2pkSFFOQXlIeHc3Rm52?=
 =?utf-8?B?VGlpdjZjL2prSjR4Qm40cXk2NVI3ZDhhOVdYV244RkhvYkZ2cXZJangxcnZh?=
 =?utf-8?B?N3luNnpURkd4OTk5NVF6c210ZzZIcmVzUUsrZGJRelhsVHVhVlVaNkszVDYz?=
 =?utf-8?B?RjQ4TWZubVNyZ2ZwMndXdnpXRWdLK2gwQzZ6U2lSaDVrT2pKa1hCUC8xM01i?=
 =?utf-8?B?aWlQWWtFTGRJOXU3SXU4Wm1FRmZvUFJoKzBLV2hvaUtwMnZhbEdBd3Axck1H?=
 =?utf-8?B?TXBkUGo0N3grT3JWOXVxVkdKN05RdXVLV0ZRQXBwUnExeDRqOVNRQ3VIc3lF?=
 =?utf-8?B?NFFGaEdrRWJjekhmTUliRjRveWh0bW5YRkJKWWluS1hiWHlVcTBHWHRJdkZB?=
 =?utf-8?B?SDFZajQxbytmbjB4bE5nd29HaU1tdFFSaTQ5VUZQWnN4KzNvVTV4SHRaeVpN?=
 =?utf-8?B?czJVSWdxdmoyNXNkdVBKMm0xdEUxRTdpa1c4Q3ZGejk3WEN1aXVjOG10Ukpm?=
 =?utf-8?B?UlNVaktuQ3ZEME00ZTJQd0FWakJtZVNlRWc0RWgxcHUzL2FoaVRvd1dUVlg3?=
 =?utf-8?B?TzVQRjFwOTdLRm1RWHJFTzR6TFM0OXpHUHlTL3JWZ2ZUWnRLM2pFVERYWktw?=
 =?utf-8?B?Mjl6NGVoZ2tjNXQ1SjRKd3FuR0JpbTN5UG5tdWx4QVJpcGZDY1hxT2N1b3ZX?=
 =?utf-8?B?c3N1cERkaGY1R1BiU0pTdHNmN1FpVncrNWFDa1E2b2VIaklUS2xSMk92dWp3?=
 =?utf-8?B?UTVwYUpTYUU0RTR1TWNyTzJscjZ2d1NjR2JYdWJpSWQxaWxJNkZFV0hBcXY0?=
 =?utf-8?B?dHZPZUJrT1RDVVJLQVdrRUtqVnlrTDZkR0JqalFWYktNN3Y4WkU5TW4yYmdL?=
 =?utf-8?B?bDFJNG1wR29sclBsNUFONEJCU09sUFNIb2NvaTU0NFR1dXJhVmNhWUpBL1cw?=
 =?utf-8?B?UGRmbFdjVFBFVmpEZGh5cytrcFV3c08ya0UzRFJueWE5S29zZnVacjRxdnpy?=
 =?utf-8?B?OHRPMmN1bUxvU0RRTjlJeGNTT1BZUmtPMTM0Nko3WG1MenJIK1ZaYUs4dkpr?=
 =?utf-8?B?QVpjZmk4eWl2NVRvN1RpeGZDZisyTkxXR0t1a2VJR1N5cTFGbTc3SFNWdFlW?=
 =?utf-8?B?M2xYY3F4NWYrM3k0eEVNNHFFZW85MWwvWUlHZHl0WEcvd1lDNTlmbGFid0w4?=
 =?utf-8?B?b0M2K2ZLckp1dGR1c3BjdlMrQ3lrYit1bDJHMDJoN3JkQWRZRmFDcFZnREZy?=
 =?utf-8?B?ZGgvRmllTGhGTHI1Z1A4bXpPNGdTc3EvMlFmeGFpMWh5QlQzWG1kaGR0WlI1?=
 =?utf-8?B?bml1TDh1WHgzUUp5UUNLRHlpUVNOWFRTRzlYWlVnYk0rd2VYd0RVVjZUb1lX?=
 =?utf-8?B?bHk4cEI0eHQxcUNGYkhvMDNmbWk5NG14U0duankwUDBVcHRSb05Jak1XS0s3?=
 =?utf-8?B?WU4vQXZWTHRGMmFDNEszbGQzZWEyaTJKQWVVYXhrU29BY2l5WFNsSEtjalM5?=
 =?utf-8?Q?HSTVdggNn0p10RUyZff2aAIBWS+gow0JRe3q50a?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1dnclFza3dVaytGVElQZjRBT0N5SHFGNWxQcWV0S2tsWU9ZeGFub0hIVlZl?=
 =?utf-8?B?b0svdDhiLzJHT1ArQ2UvY1piSzV3NDVHM3pXZFBxM0JXcEQvM3I3aGxQYWU2?=
 =?utf-8?B?bVcyZWRBSFBFM3huS2pOOXBoTHBPVVI2cVBSRU0wUkZMcFJUV1FZVnVqbjI4?=
 =?utf-8?B?OTc2UkJCSno5Q0pXRXBYNW9aVlNDZmJqNlNTZzdMdzY2RlN4VGUwVDVOUWlt?=
 =?utf-8?B?U2R6TFNCbUFLMlhxcGpjdjZWdmQzUnhIL05NbERHeDMwblBubUNjMlpWUEx1?=
 =?utf-8?B?M01KNFc3Qm1UQnYxM2FRalFneWQ5YmdYMk9pWGlPRWNrR2xHZUhJYk0xN0Z0?=
 =?utf-8?B?TEhqTWZBeE9CZlpUYlM3U0hBUURUcjI5aXhvcGEzRk0rYVJBZUZ4VjVCR0hI?=
 =?utf-8?B?UWNJQkRQNjRzWmlHQ3VyRTdNK2JBdkJ6ajMxbVg3aFJ3VjlmTlhuWmxma24w?=
 =?utf-8?B?dVZxQUt6ekNsU1lSMWlqRmladDhjNTNjUnNsaFExazEyVXdpR3ZnWUZYSDlC?=
 =?utf-8?B?U3dCZUcvMUhSWFZZU1dQbGRpUEY0QTVEc0pPenhKSU84QjY5d2E2RXhmOXJU?=
 =?utf-8?B?eGNEMWt5clRVdUhrbG0vdnFjRTlGaC9ISzNENkRnRnQ5VmlsM0dUTUoyRXQ5?=
 =?utf-8?B?YXAza3kvSFBXZm5STjl6VFAveGdiSy9naXhNMjkwaGp2akd4Vm9nS2hodHFC?=
 =?utf-8?B?VXVwaUtqZklSOVd0bzJKbmVjeDhrKzRDY1J4c20rMFQyNnZRQTZGTkxjdVQ4?=
 =?utf-8?B?aWhHcVdwZnJRN1kvT0Vha3BGRTQ4RDdTS2NwZHNLR2ZjMFA5TlVFa2thSkZU?=
 =?utf-8?B?dW1UVEptK2pudUZoQ1ZQVnFySXZBMnVLWUJkdXVJSHVhc29iTk9wWERHQURl?=
 =?utf-8?B?bnBrUG9wS1AzeXhBWjJlSVNCd01UZThyR3BlZHZvL0drTjk1V2c3d1lubi9w?=
 =?utf-8?B?bytYUmpPTy9hRXhnV05oTnlLVjNJY01SSEVBZ2tNL0lzTmNzOWttczFlOG8x?=
 =?utf-8?B?UTZwMDVtSU5YaHdxNSs3bXdIeTIrMjV0QVdHYlhHb1JGbEZ5elNIYzZTTkVE?=
 =?utf-8?B?Q0g3a01uY0JtMkFNR2tiblpESzBQajZ6WWtBZUFtWFNZMkREd24wajJhUlR2?=
 =?utf-8?B?eTl4NEVEYkcwNU1WWjV6YmROaG9mT01QcXFhaS9aZjdqY1BpUy8ySnhZQnBG?=
 =?utf-8?B?YU9sZnZEblY5ZVNCbTFwNldpbkx4bHAwZ1gwalhCajIvVU0zc0M2bGJaUGcv?=
 =?utf-8?B?bFYvTWZjWmoySUJ3VnlQMURtZk10dkNLajhNM3A4SUFKK2tTUnB2bWlqTXRj?=
 =?utf-8?B?UTFiUVllM3doL2U2VGc4dnA4WnBNMkVTdEhNLy9GU0dZMTNJdjlacGdIOXI2?=
 =?utf-8?B?Q2t3elRKMVVKbHVyLzRKZFoxYkppTTZROXU4SitDSk9sR2V0TkVYL3BPYTZq?=
 =?utf-8?B?amJ2Z3NBSS9QclAxclBzSXlyZ1JON3p2QVNNa0U2NGJsWEV0NVNURFI5cW1w?=
 =?utf-8?B?SXMrWDdFR0VZVldkSEVOTTBwUDJ4eTV3NGVrUmRsV253SHdmODV6L1JqN1F2?=
 =?utf-8?B?Q2E0bGJ4TGY2b0lqRWpzQm84UThXanhNdUMyKzJsd3pKNVk5WTEyUjVDWDRK?=
 =?utf-8?B?WkQ4QW93bnc0UkNiOEpwZ2pwbFVDWk5QcC9yTWoyQXgrU2pFT2FCRHFsMlJY?=
 =?utf-8?B?V01ZOXQ3cG5ack90aDJMNHliRXdLVXlCZEdNd2ZTN1RLbjJpRGhiU1EvUTRp?=
 =?utf-8?B?ZlY1c2FVV2RFUDM3anhvWEtSN1ptYldmcEs4cElTMVFhOXVpcUpDbzRTVDZP?=
 =?utf-8?B?N1F4WnNFMVdCUVNmdHYvQ3pqR25zK1ptdGFjOXo0VkNlRjVvdFhDdS9SbnlU?=
 =?utf-8?B?WG5vZnRvZExPNHl2WXkvZzhUaXpNaFJrNi9WRzh4cTRNZmE3TFpIZnpqM2M5?=
 =?utf-8?B?VXlEL3FLbkY4SEVQVE5Cdnh6SFZieS8rUDlVd1J0d3hWaVk2S2NoaUplTXRH?=
 =?utf-8?B?SEhXcjFXbFAzRFl2bkc2NGFTOE9UVFlpcVpDdVlYWU1oSDUrYWt6T3MwSVAy?=
 =?utf-8?B?L0RoR2NMbEp1ckVqZmZ2SVJiems3bk92YldWL1hzcXBCY3M4T0t1OVRERzNS?=
 =?utf-8?B?alk3VDd6RCs1cDRobVBMelcrQzBrR01HZ1M5KzFUNVpXcmUwVGtTVEFCTW1E?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd620c32-5888-4c8a-0fa6-08dcdf46457d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 22:46:48.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBQ47AJFWImTV8YFu7oC+vO+w0D4mbMnQAUYFYoci/pUXEkM4+Y6BmAMUPEUj0P5PFFiADZSgk2OoP/tW1IUncRLdWbeWk1fkYN9wS9V7rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6894
X-OriginatorOrg: intel.com

+Martin

Hi Tony,

On 9/27/24 3:30 PM, Tony Luck wrote:
> When the mba_MBps mount option is used Linux initializes the
> MBA control values in the schemata file to MBA_MAX_MBPS (which
> is defined as U32_MAX). So the schemata file contains this line:
> 
>  MB:0=4294967295;1=4294967295
> 
> If a user edits the schemata file with vi(1) (or other editor) and
> simply writes that line back, it gets changed to:
> 
>   MB:0=   4;1=   4
> 
> which sets maximum bandwidth to a very low value.
> 
> This happens because bw_validate() unconditionally rounds user supplied
> values up to next multiple of r->membw.bw_gran. That results in a value
> that will not fit into d->mbps_val[closid].
> 
> Rounding up only makes sense when mba_MBps is not enabled and control
> values are expressed as percentage values.
> 
> Skip the roundup() when mba_MBps is enabled.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

A fix for this issue is already being discussed. Please see latest fix
at [1] that additionally addresses the issue if a user attempts to 
write a value larger than 4294967295. Could you please check if that
fix works for you?

Thank you.

Reinette

[1] https://lore.kernel.org/all/a7c80676-0761-4618-ac07-0b53434b1a9b@intel.com/


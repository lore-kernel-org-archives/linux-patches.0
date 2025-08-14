Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0575D23D2B1
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208248; cv=fail; b=ayaZErzdVmHa/pwh8C6e+P4LqsYI++ebnMwAuvEQxBPD/rfa+4Grgi6vBY4ubrRNNsat/w8z2XsTxGC+8gBJsPb04S4sbLaEBgvu5fxuug+0lu+otptLFDWEXK61PzpYGJ0fRToMBIJZKd3XSTZeF/9wf/DuBk3q3vaX2CCS408=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208248; c=relaxed/simple;
	bh=h7g6Np5PMQxEW1W34erSfKuQ0WuaIRq0SQUW35jy778=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kMWVx1RtxEA8larSEYuVUYzUPxMV0RBQ6o9l287HBrhSzUl24ZGLGbUhHrpBmPFraptLuHL8U/pr/WgnokG/4O+Ef2Mh7mj7sXZtG9k0lWASZA+AEK6NOzHaKiOBG0G4JDE8YulIZUkQ67wN+KxuSzoeZ4tImqyDXkc+JSZFgmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=THXPBA6K; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="THXPBA6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208247; x=1786744247;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h7g6Np5PMQxEW1W34erSfKuQ0WuaIRq0SQUW35jy778=;
  b=THXPBA6KoVYqC51W5K6etBYm4dUGzHnpqoDZaqt1Qh11saGSLlIUyuCE
   T2TrtsQJxWpSBBUpgoAY+ISMB5eK3J6Mm45KSaa6VYdK69kmnpJdmugdJ
   VfRQiZYN9onREPVP1CCjLfiZA7bM9IOPn45MmqpTUPUC0kPXkuKBaTlzO
   zStTAq/jxF4w0FqVjS0X9RTYiGk0azIkUtSAB9hAVVKG+QfkmhhLgwULR
   KFrFluCttqsVclaMVTKlcBvbSNgQaaHoTwRudUcqbp8D7Umn5dYV/Muut
   sFt4GzGQO1P5Q+y3ofLyLY0iDMIs2NzKb4p1x6OoiNpckKtSSb4j8yWcW
   g==;
X-CSE-ConnectionGUID: cY0iLJPkSwiUWHPjRUNN0w==
X-CSE-MsgGUID: pDUOhKSFTsun69WDxuHpKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57685837"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57685837"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:50:46 -0700
X-CSE-ConnectionGUID: ezUPu1soQWGWvLnbCsMCzg==
X-CSE-MsgGUID: fIqqw6CKTa+/sVydI0964w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167121557"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:50:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:50:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:50:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.51)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:50:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iF25KPIMUcae66xny80pOmiGmFvmMUznJSKo81YndgWfFyl7Bqxf5PcdqOdRGezFF4+ospEzXIOiKigLg/XsMJ4ZKLMTWsUvTm5882NHZpi5NfMJLAYVK29HunRZt48qZt88perhjEvONm9g/Bd2XNEjRMy2l/0/DOZH3oZc4c3IguMzuqy0eS1g/HlZTbJZFyC7Koe0rk3A6ijQfd8Lo78IZG3QH9krI+E76BbzLT1js1CHhQZtMVAo7VYAD4xy1xJRxHjmA33DrmounElu7DDGJLqLVkxykJLTrHxzVTrAhF3V3/cgMGc2VvbrPxTdQ2EleGAsDWk3D1KLuWsyBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twrRYXoPOCSeAsVAZvAAM/cTsUO2TBs6AZaEePSa5j4=;
 b=xce22FKas5ecMjxbRocCsxF8OkeJBQvMyaqoZNZSv8hKcxvtmqQ8Kp8608PFC92H5FPIgl/SS5y10/3H8p5uq6tXAy/hPPnkCDNsKyXW96vz2/CwUwv+CPMOIHy5sGtFEEx9CWM18IUDdWnExfz/bucTQk8LYDmcXByMRdOxBGUyz5Tiq95UkanWjkD3gMOSo4Ht3WbLOjaDwatn887tSHnkr1z+7UpHwZ2Ery8Z8EFWaD+BXdB+gqDcUjJSnGBBAx6fDTBd1vUpdcNDsw7SC0WyBbTKUVhSygFTwoeyBSdkGfxtY4NX5XEuXo+eC51YU6+JPCUctCNAikn/c5E9/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF5A636EDE4.namprd11.prod.outlook.com (2603:10b6:518:1::d21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 21:50:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:50:37 +0000
Message-ID: <97d03a02-d110-48e9-9619-27a7596aa16a@intel.com>
Date: Thu, 14 Aug 2025 14:50:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/32] x86/resctrl: Read telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF5A636EDE4:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b0f643e-7924-48a2-00ae-08dddb7c9ac1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZUcydEpwMDhmeW5iNVc0MlZ0OEtkMzh3UWRmUko1QUMxTVMyWHdIVHA5aytw?=
 =?utf-8?B?OGZOQkRRRDIyVG0rK3M1akhEQ2MvV3U1V0R6aFZ5N056V1FTNGNWcStWUUhD?=
 =?utf-8?B?WnpkUmVBK3ROTUZLUHAvUmRKTTU1NUNMc2NocEwvN0pHVnUzblphRS9Ealpt?=
 =?utf-8?B?dWQyU0dMandVeCt4MFp0ZHhXUFdxdFlOVVlHMExDSisrVkRUWlpEc3F1amZT?=
 =?utf-8?B?QitDM0Z5MGc4NHJTNW1vNEFwUUlPSCtIQUEvWS8zVk1TWUlhMi9TM2lpSEhl?=
 =?utf-8?B?UUY4dk5VQW1YMzIwZnRHWjhuV09pSzI4ajFJYUNzaC9DTXZqeVIvUC9TeGk4?=
 =?utf-8?B?MzJVTlBVcmZuaWs3L1RCN2c5aXN0c0k1UExZREJGMVlFMUJvK0pLN0x4cVN2?=
 =?utf-8?B?U0M1K2dSbzh0Q3R2Nkc5a1AxTzIzQzFuR3cxLzBwVFhaa2V3QjVsMjFWenh1?=
 =?utf-8?B?OXVsRE9rejlNVkhaUGFTMU82Y1EyWVJmV1F6T2wrdVhhUDdnSXV6NjVaYmxh?=
 =?utf-8?B?MEEzUktXeUJ5TnRMTU5KUE8zZ3IyNTY4M2RuUTJtSmVGTk16REQwQmJscXVR?=
 =?utf-8?B?b0pOWkFGNnhiOWZHNW5NMmJTVzI0b1RsSHdiaDU0VSsxNW9FQW9Wc1JxTWtz?=
 =?utf-8?B?UEdoQ2dwVzBMcUFERS9EM1hyeEVXK3lkL05EWmJQWjUvRDg5MVg4MnQrM0Zn?=
 =?utf-8?B?ZVN4SkFCamNhaWJjRVdMZ0QvVkROeFNuT0VBdlFwU0FoejZQSEhPTGtxcjRQ?=
 =?utf-8?B?bC9OcElsWDZhNHo5c1hpcEFJdXhIcFdja0JyVis2ZG1NSkpDenVVQy9QZERT?=
 =?utf-8?B?OThjL1dmYWJ1Y1JtMzF2WXU4OUNMdTJxQ0xweUhrVVBQWE1Dd1NQNHV1WXNU?=
 =?utf-8?B?QUlOSUtsS2ZLVlB4cnRaR3lQQWlrZjd0b09TRFFHeEZFNmgwV1JrRjNjRmVU?=
 =?utf-8?B?dmFRUzNMRFg4WDFudTNrT2lVWnNRaVFtZWp1cW5TV21iTnVkTnB4RHZRejNU?=
 =?utf-8?B?T2MvMXVoQXBFN0lRVm01MSsrV3p0eGZxMDFGdnFaT0t5UEd0eFVaWHcrbC93?=
 =?utf-8?B?MWhLTkFMa0YrWXJyOG5qMEd6eTFuQkZaRVVpL240R083RC9qWEUzVVZ5USt0?=
 =?utf-8?B?L01NOXFhekZ5YXdHR0lTOHFZdDQ4eGxhZGRVVnMwbjZpa1Vud1ZtcUYwbWtZ?=
 =?utf-8?B?YkIyamt5WEZuWUFlZ2RNbUVxNnpJaUwxVmNMbDNBZTVNSm96YmdFM3FZM09m?=
 =?utf-8?B?T3AyTUtEMmxUOVlFalZETmxwWWVHVnN2R0FVSktINnZURDhJb2txd0xoZ2Zv?=
 =?utf-8?B?R2xJYUJkUWVkUldWOUZHU054VVpuVFpnZ2puZ1h0dVo4NlpGUFMwZlI0a0dZ?=
 =?utf-8?B?WktJY2JJRmVESHRxZmNqTWUwYXN6WmVIWHEvLzR5WHh2SzRjQXVCZTN2Sncr?=
 =?utf-8?B?WU9aMENMR0QwTnBiYzU5dGNXSVVGTzNHWFdydzRGd0VGdTJBNkFzS215VDBZ?=
 =?utf-8?B?Qzl5a1lHZlZSdElTSGR1TWZZS3ZlcHZoZXl6TnQyZDlGNWl3dVNjdjN1bXk1?=
 =?utf-8?B?WEdMN2FuaXhTVkR6ZGhobmtkcGw0dEJtc1pBNERyeU1PNUxMZjJjQ3V6N2xy?=
 =?utf-8?B?ZFZTZ2ZJdFN6SStKMlU1eEswSWw1djNUeVZodEtvQlJidC9QSVJNNVpJckNW?=
 =?utf-8?B?ZXlPRTRXdlpGdm9JdmliZnV0M1FJVGRnclZnZWhpck1YK09rNzY4ck5PdGph?=
 =?utf-8?B?am43OENIRnJKLzcycy9NZUlRbHBDUEhHZCtkaExidnNPUERIR3Y1QWRnNGp5?=
 =?utf-8?B?Mi9ZNUd2ZWU0cUdvQ0ZmQmYzTjY4eXpYL1dZV2twb0lXbUc4SnM1Qk96Z2kv?=
 =?utf-8?B?MUZ0Y1RnVnk3TWVuak9rd0M2c0ZaR1FVM1pGaDZSbUJwYjdmTEJpSkk2Tys0?=
 =?utf-8?Q?LaOw6HNu+Cs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU43RkF6VTl6aGFwSHpXYUhrKzE0QVZSZHhwMFo2M29XdktqcE9LcFJhbkFX?=
 =?utf-8?B?ZzVrdTE2ZGpLRGtoNnlHci9pTG5zVi9nQ09uRW45dkQwRXhFS21tRVJ6S3FW?=
 =?utf-8?B?Yzg0WEhPenNId0pyeVQzd2xhbEdaYmppcXkvYjZzaHdnM01oYzRkMEVLRWJV?=
 =?utf-8?B?Y3RPSjFRb2hlbDl4TzI4TE5tdE5PU1lKZEtXeTdibGFoN2ROSUtab0U0TEFD?=
 =?utf-8?B?R2dLNmJEeVdSVWV6R2Z5L0FMcmJ3SFZJRzdnYmpkdnI2SXpxS2ZFYUNkMkNE?=
 =?utf-8?B?WlBJY0YyQTA1VUJSanRLNFBjMC9zeW5CV2ZrSU13OTBhcDRiQ052VXR2Z3Rz?=
 =?utf-8?B?Ym5mVWlTd1I5TE44dVdSZGMxYm1sN2lXVFdDMnBvZU9SMm1xcGpzZDZDNUV3?=
 =?utf-8?B?aDM5N2RKbmlMWUxxc1RXcDJIeXZTNUxlRXBCQldnaExZb0dTckN0U0s5YlRx?=
 =?utf-8?B?S3UrRG0vc05YMXBVZmJlVDA0TGNMaDhoL2FCcnJsL0tBUStQcnEvaW01RDVG?=
 =?utf-8?B?anFUSkpaMk1Fb1JTMnB3ZWxvVUQwcmNvTHNrSzRsWFhxVEt3VGY2MEtlYlBX?=
 =?utf-8?B?OGw3TTR5L0V2akJGNUl6MXhaVGU2bXBUaEhWMGt4VUMyT2xNRVFwN2JzdkFF?=
 =?utf-8?B?U0NrMzBta2x2dTFTRlFobmY0QXZMT3E0T2VscSszWk9xQXNNd2pIQjJNQUkv?=
 =?utf-8?B?UlAwWkJSUWF6dWVqSCtWWWJmYU55QzMrVG45Q2Q4UWgxdDNlaVR0ZCtDOXk3?=
 =?utf-8?B?N3NtU1FzZE9BRFhIWDJnVldUK3hVdTZBWndlbis3TDJXREgyUWg3TklPNGVL?=
 =?utf-8?B?dmxRSEM4SEh3Nzh2SFJXakgrR2t3azl1K09ram1aamNOZXJhdjFjVTRWVXhN?=
 =?utf-8?B?TFk1Sys1Y1ZxZllnVzlFUTRJR0dZSXlmQU9MWXg1elFJMGE1b1F2Y0kzR08r?=
 =?utf-8?B?ZHZRQ0kwVU53VUhkR091Z2pnSVhIMldkUDFtRDBNOEhJMFZzdTMwNGExR2VG?=
 =?utf-8?B?RnVRejdjamNKbzRSK3dXM1V0VmhoRHNVZXpsa1lRZnoyVUNBcHpaUEl0Mk9p?=
 =?utf-8?B?dVk5YXNLMSsxVStFcWZpczNheGpPd1doVDNpSU9YdmZOd3dleFdiZi96NStX?=
 =?utf-8?B?T1NtVnRFVjVZR0VzT0FlTzZaT0g2enVBazZpQmVCa0praTZBTVMyMkE4dWp2?=
 =?utf-8?B?NzVUTVpUQTBsR3FYVFNGRTFZSmFJU3Q4QmNlT2o4YlRHaWRLeVF2QTNzY01x?=
 =?utf-8?B?Q0xyM0E3Tk9mMjVncUZNQXBaZHN6cjFKM0ZSUDQ2N1BhZWtyUmVMcEVXS204?=
 =?utf-8?B?Mmw0WDhtWmgwcHNUV01LQ2xlWkNZeWlHZGF5N0FRQWF4YmFQaU55UFBrVC9a?=
 =?utf-8?B?V0tqZ2MzcmFyRi84NUdia1VHNzU2VGZuVjNLbkk2ZllzRVl2ai96aStpYjlY?=
 =?utf-8?B?cUpsaU4zSzNzUklSVFlZVjA5MVo2dlg1MlFGWlo4Skt3azBWZHA2eDlqdStv?=
 =?utf-8?B?RHY0R003MVJTcVBYc2hNSHlyZFlRY2VVSmJZbmRycEhVMVk1ZnJNTkRzM1lw?=
 =?utf-8?B?bzZDcEZPZVlOUFA4Rlk4K08zdUtBTzNWa3Y1d2d3bnB6TEQ4MXlNQWM1QmFR?=
 =?utf-8?B?bDJPNmQ1cHVSdUFRT3JBakJMQVBac1NvWXMrTUNEb2ZFV0Z2WGYxRDE1TGZm?=
 =?utf-8?B?a0FITEYxaDBUSW5mK2NQQUhwMzA3ejE3b1JUYVJJZC9wSWlXYzkxVTZsTzkx?=
 =?utf-8?B?VGw1ZklvbzFRVDJBdVFMTHpkV0o2T2lqQlZTR1dGcFArMEFFRk1NeWdVVGxy?=
 =?utf-8?B?ZTgzZno1c0k5Ni9GSHZicTZKZGVRWjJBUjNRSnd3dG16VlowMkpZSkxWU3JK?=
 =?utf-8?B?dnVseHc1NGVnaFBpakNWNDVZWTI4aFpKRU5nQTYwK3F3SkFNSDl0aVZ1MDJD?=
 =?utf-8?B?QzNXOWl5Y1VZeStZUXRxUW9odmRHN3pIYzgvRDZVRzBKZjNxVlE1NTdxcE5j?=
 =?utf-8?B?OUtBQmUrRTE1TGZVcTIxSzJRRExuazkwK3Q4ZkQwdUZ6THZicTJBMjl4ckJn?=
 =?utf-8?B?MkZGUzVRaEtKbEs2Y21BM05maUQ1L1hxa3ZLbC9oUnAyTjZ4NW1sTW96RnFB?=
 =?utf-8?B?MmVHQTd3R3NuamxyNHRZaHRCUkdPS0Nxc3poMjMzQlJHRFZVdHplSlhFWi8y?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0f643e-7924-48a2-00ae-08dddb7c9ac1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:50:37.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcz/FrGMv8J4g5K4dxJJfmhngXp+g2nip/J3Fz5EQH/OmDi7+r/RNMpxf7nCa7WKfeHbuEC2TSsipEG3BxjwVr/E+dLPhpFyi3OMHUsIF3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5A636EDE4
X-OriginatorOrg: intel.com

Hi Tony,

Subject: "x86/resctrl: Enable and read telemetry events"?

On 8/11/25 11:16 AM, Tony Luck wrote:
> Telemetry events are enumerated by the INTEL_PMT_TELEMETRY subsystem.

Above is the context but does not actually describe what this patch builds on.
Below is something to start working from:

	The active event groups are known after matching the known event groups
	with the system's telemetry events enumerated by the INTEL_PMT_TELEMETRY
	subsystem.

	Enable the active events in resctrl filesystem to make them available to
	user space. Pass a pointer to the pmt_event structure of the event within
	the struct event_group that resctrl stores in mon_evt::arch_priv. resctrl
	passes this pointer back when asking to read the event data which enables
	the data to be found in MMIO.

	...

	
> resctrl enables events with resctrl_enable_mon_event() passing a pointer
> to the pmt_event structure for the event within the struct event_group.
> The file system stores it in mon_evt::arch_priv.
> 
> Add a check to resctrl_arch_rmid_read() for resource id
> RDT_RESOURCE_PERF_PKG and directly call intel_aet_read_event()
> passing the enum resctrl_event_id for the event and the arch_priv
> pointer that was supplied when the event was enabled.
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters.

As mentioned below it is possible for some aggregators to not return valid data
and this is treated as a success. User will not be aware when this happens.
What is likelihood of this happening? Should user be made aware when this
happens?

> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

>  
> @@ -211,6 +212,9 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)

Recurring feedback to this series is that in the beginning of the series
discover_events() gets function comments the describes the "steps" of discover ... but
later in series (like in this patch) when discover_events() is updated these comments/steps
are no longer updated.
Looking at the final work discover_events() thus has function comments with only two steps
that document part of what it does. 

I actually find the comments within the function that describes what an associated snippet does more
helpful than lumping everything at top of function in a list. For example, below change can get a 
comment like:
	/*
	 * Enable all events of active event group. Pass pointer to event's struct pmt_event
	 * as private data that resctrl fs includes when it requests to read the counter.
 	 */

>  
>  	list_add(&e->list, &active_event_groups);
>  
> +	for (int i = 0; i < e->num_events; i++)
> +		resctrl_enable_mon_event(e->evts[i].id, true, e->evts[i].bin_bits, &e->evts[i]);
> +
>  	return 0;
>  }
>  
> @@ -278,3 +282,43 @@ void __exit intel_aet_exit(void)
>  		list_del(&evg->list);
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain).

Function comment can highlight that it is intentional that as long as
at least one aggregator returns valid data the read is considered a success
with the possibility that partial data may be returned to user space without
user being aware.

> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)
> +{
> +	struct pmt_event *pevt = arch_priv;
> +	struct pkg_mmio_info *mmi;
> +	struct event_group *e;
> +	bool valid = false;
> +	u64 evtcount;
> +	void *pevt0;
> +	int idx;
> +
> +	pevt0 = pevt - pevt->idx;
> +	e = container_of(pevt0, struct event_group, evts);
> +	idx = rmid * e->num_events;
> +	idx += pevt->idx;
> +	mmi = e->pkginfo[domid];
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < mmi->num_regions; i++) {
> +		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			continue;
> +		*val += evtcount & DATA_BITS;
> +		valid = true;
> +	}
> +
> +	return valid ? 0 : -EINVAL;
> +}

Reinette

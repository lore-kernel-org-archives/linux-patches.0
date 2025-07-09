Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEF41DC988
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 03:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752031315; cv=fail; b=RlW/XmCc/Hin2+Tn+rx9KB6GydxYgIfFvAsLUrj0Gs9yuWcdEtZP6fDZoxMyUfX0kODsNljsg4iN0DKekaQDPZzCKK9Ytj+iD24zjUxSyRMSrex7IhwoX0O/PeWwcr9v3LhNXBZPOvMko/bXwm2rFFscwf88hkmJJTFEtE6QxzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752031315; c=relaxed/simple;
	bh=8qz5Lug/3/FMScGPg/w1VB99Y3cQx8nNsoII5rfHr4w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lmxwtcSEHWMTEU7Y9lGuYDVnvPqbJKlSMWfyLbOilg7hYEkQm9RZIAykymDPm4F2IQ5rIaG/j9ADkAAuTT6BtpBNOKm98kwgEYr/hnpseuDP6l6DMjSW8oEbrcar7fTOhGAbrUxb2EfuDI2dJAxtry5+zHZ8cshZc93Z43DHgjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lUoo9qEn; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lUoo9qEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752031312; x=1783567312;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8qz5Lug/3/FMScGPg/w1VB99Y3cQx8nNsoII5rfHr4w=;
  b=lUoo9qEn82Vdg8tn3Gl0eiORNzsq94jnnmXOmCWdPmbEqT/bd7FinrL8
   FBPcNN9l3x/iWQkSctNQIDG3obV0itEK9UULDNBOUg30cW5CdwHAP2/nN
   i4HUtjS/UR1A01uyJ3MZUn38eU91UfvmxJc+mv4w56qLufRU3k68CCMFM
   yn5/HO0//kz3Q2vvnIX9NFP2oXffAVH1oSJPSkW3P41TEv/jW3eltO8Ao
   yGq43/Zsko+PtmLNjEiZA+nkOsvpMxl+s44P47QX7jsF9OY0blTcFv0ng
   hoiXNFNXBvZ7aEYYC2LPDuQEFaQ2mhi8YFost3SbEmpysKdrNT12nwy4n
   A==;
X-CSE-ConnectionGUID: uThP7v19Q/WiUafUwc6Oqw==
X-CSE-MsgGUID: XazULnG/T/GgO4XlRNAvHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64530602"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64530602"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:21:47 -0700
X-CSE-ConnectionGUID: FjQfHY8+Tx2eWXO6e3nqXQ==
X-CSE-MsgGUID: ceRtAn5LS6izmfytPA9qBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161309113"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:21:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 20:21:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 20:21:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.47)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 20:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMuDFNqw8mjSie80IeaHpKWdYvSob4UKStfHKHY+OGAdpB1ZRBFC0DQ2OI9LESkLVBVPDe6Z30HxLyUDuY6n7zEfoO5lOE3LzpdOVJidWipGhltycOHthPmaS0rOVp46p+ExR7j1MCuC5qeLoYPhbOO4NQAOIpeesGnjYzFGeIvE1Q0Z0xnG4/pfOL4NxRAGU2macXdpzKz8sl9pnV7KNqnrQhasOEAM2qSi7W+tHJpH1p6sNfGlaOCN6niUQ/Fpa5LhYkkSZrJTyoSXLTH9DVlv67ZxfSJLCMzN5qvNq3K5m4ajdW2jJoldRi1zODtmM9KF+RCNB6lDIV2HVrQ+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkN6uaW22ayGVTLbHc5yOoiyolqOaktrJI9ur+IGh9Q=;
 b=Kv/N9Lf0oJm16z1cm/oYQQcUAGV2W3W3el171BoOPb4PDvJloHl1zL+yIc11IlaooEzjXg6hltEIz3MjHPdMrbBSmQfLxniE0zw57i+8SY740OLxNYgxiSvqKtq435sAQ05nSNekXEGIDL6a9gFV02USTHv3PA8SoLTecojH9cR21trKXUuAA74dQVNgzAnNqKBrCFbmoKlNky8uhLURtRjuHYQKsieesrNG0iKvrc7+Klh9cADOpUTH+MRpfr3zPT0EJSBaaLrucbMZsyu/Z6MOP1WVkE0ia2UCEgpQrMdy0fuDAI26WGg4vPHNfjsgEJ4efW1Bbsn5FlZvvOIdJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 03:21:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 03:21:43 +0000
Message-ID: <7dbe58c4-7006-4cce-8f5f-16f3a6f6eaad@intel.com>
Date: Tue, 8 Jul 2025 20:21:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/30] x86,fs/resctrl: Add architectural event pointer
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL1PR11MB5285:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af3d6b7-9eed-4849-bfcf-08ddbe97ba8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDNhNzAvcG9TM0NmcHFPNk5oWTRab1lqQk8yZlNCNXB2UE15aDBTZjZPN0Qv?=
 =?utf-8?B?TEJFeDVqVS9ZdVN6ZDBXdXd4ZUQ2UDZ3NEJxNWtLbWJTYkFYUDRIbXdpMEJB?=
 =?utf-8?B?Um1vcDl4Ujk0Nk9lVEpOem1aU0dJZS9kUDE2TDdBUnpSY3ZiQmNuWkpnT3RH?=
 =?utf-8?B?bnFpekphZWNKUWl6UlZsMXBVZ093elA3NDQyK2pLS1VBZUhQOEIxS2tRUGdw?=
 =?utf-8?B?VTRjSkRHdUpyaEwvSk03RHUyQzNKWCtiSlJEanhBSFdmMnlkRkQzS21HblVH?=
 =?utf-8?B?T2RxWjZBQW9zZGFDc2hhVmdETDNEbEFZMFdjZTNGWk4za2RNODBQWHI1a2Zu?=
 =?utf-8?B?c3N1SW96RlVRR1ppVHBqOEdwODZUamhGTGNza0wvRTVkbmxyeWU2MnVvZTFD?=
 =?utf-8?B?N1FpRnlmd0J3bWV5SkYydGgyOTNKeDFFU3ppY2lvVTNLa1ZONjlHckU0TUU2?=
 =?utf-8?B?RnUwSGhvTVpSVHhtbVYrMUdOaGR0UmtxVHpvRmtOUHpWMU80S0ZCY0hBbUIz?=
 =?utf-8?B?T1Q5WGpCQU9OcnhxS2dpVnl1NTJUOS9LbzYvc2ttZG5Rd0U0T1UxQ01CSUxM?=
 =?utf-8?B?aE9QamJ6UkJSdnEzY1JHd3NuekduN21ucXhLZVcwZ1B4ai9UeC80MmMrSWl4?=
 =?utf-8?B?c0g5Y2RXTXA2Z09aMWZvY1F1bmZ6SEhjRnhiN0Q1SzhxL0VYQURsSzF3UExt?=
 =?utf-8?B?Tlk5L3R3RVQ5ekZ0Q3B0Q1JrWFlINWNjRHdOZmJRdWZML0xtOEJob3R1Q2ZB?=
 =?utf-8?B?UUhHME9NNHNtc0RmSHZDZzM1Q0dLQjBFcVIxbzFhNG1heEh3RzgxMUU2Sk4w?=
 =?utf-8?B?MVZ1UGIyWXU3TkJXTWFZbFFjM0pINi9pSmNBV1A4b3MxRGh0WXNrTFRHVito?=
 =?utf-8?B?ZGgrUlpQME1Rdi84Q0FRNFQxaXdHM1Bwbzc2VUJHZy9paTBlbGpkRmw5QSto?=
 =?utf-8?B?VGpnd2FjZlJzM3JWeHJIOER1WjJQTy94ZDFVZERzbVR5NG85dzltbUF2ME01?=
 =?utf-8?B?Y1ZWNkZpOXE3c0hkQ1ZRcGxXUDhSbnhhVlAwQ1J5K3NjZ0Vsdll4VTUrVjE1?=
 =?utf-8?B?dHRLU1FIa3dRZmRBWnY3Smo1TnNGRTZOdngzc0xhK0NWSGlyMnp2Q1RXb0hj?=
 =?utf-8?B?MEFGK1FZb2ViNGx1NDA2RmgvVEFicHErOVdSWCtxaVNHbkdIb29mdU82a0hL?=
 =?utf-8?B?R0ZnMWJVejhsNm1MdS96OHJuTHJDMUhaTjE3cEdoYjFxdHM2S2R4cUYvaEpr?=
 =?utf-8?B?aHpwYXZaTytkeTBDRFBBU1loNUJCcC83S0VEb3B5SXY0Tm1NeWtNYUgxS1VX?=
 =?utf-8?B?RWVkY3lhMGVPUnJMdjNPYm12K0hPU21URklkUjMzR2xRaEpDcHcvT01ZY3BE?=
 =?utf-8?B?RE1lY1BZQzhNWkFuM093c2pXZHZpSHR1c3h4d0VZd1FFekNxZnVNamRKQzJU?=
 =?utf-8?B?VGMvZS9HQnNPanV4Tkp4WiswMzJGSmdFWFFpbmdnNkpMNmkrWldYS2hFbEd1?=
 =?utf-8?B?VlpZY0o4RGszVWNXbjhBdmg2ZTl4SkJqNWw4WjFUVm9IaG5xakdxWVo2TzVo?=
 =?utf-8?B?QkFGN0l2cUVqYzNwWE9panViaXZGbE9QTHhvMndUSnpqTEZvcG91UnV4cno5?=
 =?utf-8?B?T1ZLeXRDek0xZkJLRzJFN0tUK050ckxDUVptZlRzRkMxcWxjd3hBeHJSdmZZ?=
 =?utf-8?B?dWNtdGRUcFBoVEl5bHQwUjFKM21MSmFOTzBURjZzYy9uTUtlWWZCS0JpdTRM?=
 =?utf-8?B?d2pMNWthVk8xQzNad0FWajRUcEtXTEdyRkRRK1NoY2Q3ZGF6Skh2c21pNlFt?=
 =?utf-8?B?dlZnbzhUTWxZa3lnRXhISFhZakFIYzEzcnlhdi9vOVkwYjREcnF4cno1Z0hu?=
 =?utf-8?B?RkV3MEliSXpaMkMxRzN3Yy80d041WG8rc1c4cWlZYmxyRndMeFFISHZZZ3NJ?=
 =?utf-8?B?TjN2QlJRNzdmNzc3TEY2QUNwYmRxeE94cDRmWXEwSUhmQUgzRXlkRGhJS09O?=
 =?utf-8?B?cVdSV0tkaXhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW9kNEh0Yyt6RkdZY2crS3BDdTViL3VRMFhsZDFCTkR1WlhqVzUxSTE3QmFh?=
 =?utf-8?B?bnZXd3ZZbWE3dlJGN2poQ1Jzck44MWdEckNhWG1zWEMvd3I4dUdEYlRQZUxK?=
 =?utf-8?B?MTJVVTJDUGYvOVVvYU9UM1pIVGlMTHVZWktQSmdXM20zd0d1MmtGWGhlSFRu?=
 =?utf-8?B?ZTBYbmEvYXJsTlFoZk84cVg0RmcwSXVDNzhTbGVuZHFzY2p3Sys4SVNSMzl3?=
 =?utf-8?B?Rmt5S3NxMEhZVFpCUlA3QUdYMVFaSndieENxdE9pOC9abkxMclE0OFd0bkph?=
 =?utf-8?B?dGIvUUFPUVNSVXVUVVNTZVEvRWJzaHpoNHhXb2d1b05aUmllZU81SUhMV3dq?=
 =?utf-8?B?T3Q5NWI2Wjh4USt1Z0lDSEdSNkJMMTUrWWgyRnM0clNhWDVpa2h0YVRodFg4?=
 =?utf-8?B?Vzl6UUFud2ZlOWVlMnlLVy9ERzduS2tVb2pnckNpVUlkWEFVeklPSUkxNEdH?=
 =?utf-8?B?OWtiaWFld1dBMkRKNUpLaEZxNFVHRGVvMktQWmhSK3cwUlRUNUJGZTFPemQr?=
 =?utf-8?B?Nkl3YVJrNE5nNS9HODdZVStJempMcXdDcDZNelczN1RoRGdNbkliY0QyNUI4?=
 =?utf-8?B?Y2JRYUZBSTNqWEo2bU51NmlQY0RORDBrdkxubUNkTC8zYk8xSi8xL1hTaklq?=
 =?utf-8?B?ZVlpTGVXOWNwZ1JRTG1HTHNsVG9oTlVrR01PdXFYWFFCcTEvK0FCTEZPVHRZ?=
 =?utf-8?B?UUwwRzAzeFlDSGFwS2RnNHFjKzE0UVJmVFAzdnBaR1ZVTW1uZzBVQ3p6ZEVM?=
 =?utf-8?B?YWExallDbVloT1grMlU1VFh3bDAvTVd1TGdOZHBlOTRXYlFCWWdId1h4YTJ5?=
 =?utf-8?B?UjdxSjNkaE1XMEwyZE1lelRqWE44NDRpTGorZGJ4UzNEL0RWY2dTMGp4L1Ji?=
 =?utf-8?B?KzJUUkp5UWM3SXY1em1pcWN1dE9yYWFuT2QycmtmOU5jQ2QwVUtCbjQvVXR4?=
 =?utf-8?B?OXBza2FXVmtYRGFwblZZVkVwQnJaSEZnWnNubGl1SzMzbG5aZE4rMmI5NmR5?=
 =?utf-8?B?SitXVDRrdWp1ekJRZkV0ZDY0TGZuMlpNeHl1NjFsdStiVnNMV3d1cjRyZEJR?=
 =?utf-8?B?aFNxVFRnNWxURXJCKy9xU2VtdjV4YVZWQnJTakZFeWNBT3lDS1Q5RDZ4L2J4?=
 =?utf-8?B?WTBRZ1VyL215YWtrQklBbW5KaDJ0eXZQT3lXbVd1Zmo3ZVVzZmJrVFJNeUpz?=
 =?utf-8?B?TmZKcVQ0MnBsd3hpNGRjYy83S0doc3Z2Vm5YRzFCT08xNnIzcWIzK1BHdGFw?=
 =?utf-8?B?cWRremtYT3piZTN4ZGpoUXhHNUNMczE0dk43KzJPWHpMS2YzRmFpUnBhcDRD?=
 =?utf-8?B?Q2h6SEliU2JqK3YxRjRXVGhTbk1IcGlBYUZUUWg0d2VMKzZYNnBkSXRYa1pF?=
 =?utf-8?B?aWxDZ1B0ZHB6YTRKem1LRXdZL1NtSkIxWDZZUlY0N1ZCQkV2Ly9uczJNZzFF?=
 =?utf-8?B?UVUxZ0NzRngxeHRhaElpWElrdmEzYXpUK21aaUZtTjAzcjN5UFhZODJSZ0dI?=
 =?utf-8?B?dk5GZ0ZQVU1ndzRub28zV29Jb01jdGhTUnNBcWt4RjU5YTdwVmtBUWtQVTZI?=
 =?utf-8?B?SllFMkRYRHdiOERIUVoyaUdDRytyUlp3clZiK3V5bmt2d25KMlpDMmNNZG9M?=
 =?utf-8?B?UmN0am82SG5vTEFHUWlaRjBHT0pFUVJQUkY1SWVCaXhNUkFZTkpSeDV4ZDRM?=
 =?utf-8?B?V1VHWEtkQWZ0Tk56V2tYRUUrcURxY0pVa1Zwa3VXUEVRQll3U0V0UDZ1cHp1?=
 =?utf-8?B?Vi84anltMGY0Rk55Sno0b2l3VFRNWklmVS95M0NtTmlqOFNxMFhRWm9sckhi?=
 =?utf-8?B?L3hFUkhqVXBTMEdXQlVRNXhWdVVPNDdZOWpxcVNxNEQyN2ZZdDZCSytranFE?=
 =?utf-8?B?L3NaRm91L3loNDRWbmVqc0VJdXlUajRuREM5NzdSRE9aUmQ5akIydnVZTTl4?=
 =?utf-8?B?aTF3WTN5NXoyQndOUEhUQjFOaTMrL2JoMFRVL2tOeVBDSS9rcXFTL3A3ZmI2?=
 =?utf-8?B?OWNHZUViZ1VvT1F3bVNtN204UUlLd2xLMFE2RGQzMW55cCtNa1JkdXFxelRj?=
 =?utf-8?B?bHV4aEhCNTNZNytXNUFLWXp4MDFmeGMvYm1Ta3A0N0F4Qy9tYVZhU1lSaVpB?=
 =?utf-8?B?SmZSejRLM0VUK2JzbDFtWnRwN2VTSHFnOUwycWg0YVBSemJDdlVyb0hSV3ls?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af3d6b7-9eed-4849-bfcf-08ddbe97ba8a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:21:43.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6X8qxm+7G4bGCP8LJiAZlkQCeP2/co+h2J1zs9vnJpewaBi2xyQht3HqlOXXoZbc5B7lht97SjPUHGCQsn4N7sBZkaGxIlnP3CH5SJfpvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> The resctrl file system layer passed the domain, rmid, and event id to
> resctrl_arch_rmid_read() to fetch an event counter.

Please write in present tense and use uppercase for acronyms.

  The resctrl file system layer passes the domain, RMID, and event id to
  resctrl_arch_rmid_read() to fetch an event counter.


> 
> For some resources this may not be enough information to efficiently
> access the counter.
> 
> Add mon_evt::arch_priv void pointer. Architecture code can initialize
> this when marking each event enabled.
> 
> File system code passes this pointer to resctrl_arch_rmid_read().
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h               |  6 ++++--
>  fs/resctrl/internal.h                 |  1 +
>  arch/x86/kernel/cpu/resctrl/core.c    |  6 +++---
>  arch/x86/kernel/cpu/resctrl/monitor.c |  2 +-
>  fs/resctrl/monitor.c                  | 12 ++++++++----
>  5 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 76c54b81e426..b9f2690bee1e 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -383,7 +383,8 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
>  #define MAX_BINARY_BITS	27
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits);
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +			      u32 binary_bits, void *arch_priv);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  
> @@ -478,6 +479,7 @@ void resctrl_arch_pre_mount(void);
>   *			only.
>   * @rmid:		rmid of the counter to read.
>   * @eventid:		eventid to read, e.g. L3 occupancy.
> + * @arch_priv:		architecture private data for this event.

Please append some detail on how it is used. For example,
	"Architecture private data for this event. The @arch_priv provided by
	 the architecture via resctrl_enable_mon_event()."

>   * @val:		result of the counter read in bytes.
>   * @arch_mon_ctx:	An architecture specific value from
>   *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
> @@ -495,7 +497,7 @@ void resctrl_arch_pre_mount(void);
>   */
>  int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
> -			   u64 *val, void *arch_mon_ctx);
> +			   void *arch_priv, u64 *val, void *arch_mon_ctx);
>  
>  /**
>   * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 53ced959a27d..2126006075f3 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -71,6 +71,7 @@ struct mon_evt {
>  	bool			is_floating_point;
>  	int			binary_bits;
>  	bool			enabled;
> +	void			*arch_priv;
>  };
>  
>  extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 9144766da836..f3144fe918dd 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -909,15 +909,15 @@ static __init bool get_rdt_mon_resources(void)
>  	bool ret = false;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
>  		ret = true;
>  	}
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 043f777378a6..185b203f6321 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -219,7 +219,7 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
>  
>  int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
> -			   u64 *val, void *ignored)
> +			   void *arch_priv, u64 *val, void *ignored)
>  {
>  	int cpu = cpumask_any(&hdr->cpu_mask);
>  	struct rdt_hw_l3_mon_domain *hw_dom;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index cff8af3a263e..c4b092aec9f8 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -160,7 +160,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  
>  		entry = __rmid_entry(idx);
>  		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
> -					   QOS_L3_OCCUP_EVENT_ID, &val,
> +					   QOS_L3_OCCUP_EVENT_ID, NULL, &val,

This is resctrl fs code. To maintain clear separation it should not assume architecture
behavior, which this does by setting arch_priv to NULL because x86 does not use it.

>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
>  		} else {
> @@ -402,7 +402,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  			return -EINVAL;
>  
>  		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
> -						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
> +						 rr->evt->evtid, rr->evt->arch_priv,
> +						 &tval, rr->arch_mon_ctx);
>  		if (rr->err)
>  			return rr->err;
>  
> @@ -430,7 +431,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  		if (d->ci_id != rr->ci_id)
>  			continue;
>  		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
> -					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
> +					     rr->evt->evtid, rr->evt->arch_priv,
> +					     &tval, rr->arch_mon_ctx);
>  		if (!err) {
>  			rr->val += tval;
>  			ret = 0;
> @@ -902,7 +904,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +			      u32 binary_bits, void *arch_priv)
>  {
>  	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS) ||
>  			 binary_bits > MAX_BINARY_BITS)
> @@ -918,6 +921,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 b
>  
>  	mon_event_all[eventid].any_cpu = any_cpu;
>  	mon_event_all[eventid].binary_bits = binary_bits;
> +	mon_event_all[eventid].arch_priv = arch_priv;
>  	mon_event_all[eventid].enabled = true;
>  }
>  

Reinette
